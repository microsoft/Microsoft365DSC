using Microsoft.Management.Infrastructure;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;

namespace Microsoft365DSC.Compare
{
    /// <summary>
    /// Provides comprehensive comparison of complex M365DSC objects for drift detection.
    /// Supports hashtables, PSObjects, CIM instances, arrays, and nested structures.
    /// </summary>
    public static class ComplexObjectComparer
    {
        /// <summary>
        /// Compares two complex M365DSC objects to detect configuration drift.
        /// </summary>
        /// <param name="source">Source (desired) object</param>
        /// <param name="target">Target (current) object</param>
        /// <param name="propertyName">Property name for drift reporting</param>
        /// <returns>True if objects are identical (no drift), false otherwise</returns>
        public static Tuple<List<Dictionary<string, object>>, bool> Compare(
            object source,
            object target,
            string propertyName)
        {
            var drifts = new List<Dictionary<string, object>>();
            bool result = CompareWithDrifts(source, target, propertyName, drifts);
            return new Tuple<List<Dictionary<string, object>>, bool>(drifts, result);
        }

        /// <summary>
        /// Compares two complex M365DSC objects and collects drift information.
        /// </summary>
        /// <param name="source">Source (desired) object</param>
        /// <param name="target">Target (current) object</param>
        /// <param name="propertyName">Property name for drift reporting</param>
        /// <param name="drifts">List to collect detected drifts</param>
        /// <returns>True if objects are identical (no drift), false otherwise</returns>
        public static bool CompareWithDrifts(
            object source,
            object target,
            string propertyName,
            List<Dictionary<string, object>> drifts)
        {
            var workStack = new Stack<ComparisonFrame>();
            workStack.Push(new ComparisonFrame
            {
                Left = source,
                Right = target,
                PropName = propertyName
            });

            bool result = true;
            while (workStack.Count > 0)
            {
                var frame = workStack.Pop();
                var left = frame.Left;
                var right = frame.Right;
                var propName = frame.PropName;

                // Both null => identical
                if (left is null && right is null)
                {
                    continue;
                }

                // One null and the other not => drift
                if ((left is null) != (right is null))
                {
                    var drift = new Dictionary<string, object>
                    {
                        { "PropertyName", propName },
                        { "CurrentValue", right is null ? "Current value is null" : "Current value is NOT null" },
                        { "DesiredValue", left is null ? "Desired value is null" : "Desired value is NOT null" }
                    };
                    drifts.Add(drift);
                    result = false;
                    continue;
                }

                // Check if left is a complex array
                if (IsComplexArrayCandidate(left) || IsComplexArrayCandidate(right))
                {
                    _ = CompareComplexArray(left, right, propName, drifts, workStack, ref result);
                    continue;
                }

                // Check if left is a normal array
                if (left is Array || right is Array)
                {
                    Array leftArray = ToArray(left);
                    Array rightArray = ToArray(right);
                    var arrayCompareResult = ArrayComparer.CompareArrays(rightArray, leftArray);
                    if (arrayCompareResult.Count > 0)
                    {
                        var driftEntry = new Dictionary<string, object>
                        {
                            { "PropertyName", $"{propName}" },
                            { "CurrentValue", string.Join(", ", rightArray as IEnumerable<object>) },
                            { "DesiredValue", string.Join(", ", leftArray as IEnumerable<object>) }
                        };
                        drifts.Add(driftEntry);
                        result = false;
                        continue;
                    }
                }

                // Handle single complex objects or simple values
                _ = CompareSingleObject(left, right, propName, drifts, workStack, ref result);
            }

            return result;
        }

        /// <summary>
        /// Compares complex array objects with order-insensitive matching.
        /// </summary>
        private static bool CompareComplexArray(
            object left,
            object right,
            string propName,
            List<Dictionary<string, object>> drifts,
            Stack<ComparisonFrame> workStack,
            ref bool result)
        {
            Array leftArray = ToArray(left);
            Array rightArray = ToArray(right);

            // Check count mismatch
            if (leftArray.Length != rightArray.Length)
            {
                drifts.Add(new Dictionary<string, object>
                {
                    { "PropertyName", propName },
                    { "CurrentValue", $"Current value has {{{rightArray.Length}}} items" },
                    { "DesiredValue", $"Desired value has {{{leftArray.Length}}} items" }
                });
                result = false;
                return false;
            }

            if (leftArray.GetValue(0) is CimInstance cimInstance)
            {
                if (cimInstance.CimSystemProperties.ClassName.Equals("MSFT_DeviceManagementConfigurationPolicyAssignments") ||
                    cimInstance.CimSystemProperties.ClassName.Equals("MSFT_DeviceManagementMobileAppAssignment") ||
                    (cimInstance.CimSystemProperties.ClassName.Contains("MSFT_Intune") && cimInstance.CimSystemProperties.ClassName.EndsWith("Assignments") &&
                    !cimInstance.CimSystemProperties.ClassName.Equals("MSFT_IntuneDeviceRemediationPolicyAssignments")))
                {
                    bool compareResult = IntunePolicyAssignmentComparer.Compare(leftArray, rightArray, drifts);
                    if (!compareResult)
                    {
                        result = false;
                        return false;
                    }
                    return true;
                }
            }

            // For arrays: we must find for each source element a matching distinct target element
            // We'll keep a boolean array for consumed target elements
            var consumed = new bool[rightArray.Length];
            var wasProcessed = false;
            for (int i = 0; i < leftArray.Length; i++)
            {
                var srcItem = leftArray.GetValue(i);
                bool found = false;

                int driftCounter = 0;
                for (int j = 0; j < rightArray.Length; j++)
                {
                    if (consumed[j])
                    {
                        continue;
                    }

                    var tgtItem = rightArray.GetValue(j);
                    var tempDrifts = new List<Dictionary<string, object>>();

                    if (CompareWithDrifts(srcItem, tgtItem, $"{propName}[{i}]", tempDrifts))
                    {
                        consumed[j] = true;
                        found = true;
                        break;
                    }

                    if (tempDrifts.Count > 0)
                    {
                        // Track last drifts for reporting
                        driftCounter += tempDrifts.Count;
                        drifts.AddRange(tempDrifts);
                        wasProcessed = true;
                    }
                }

                if (found)
                {
                    if (drifts.Count > 0)
                    {
                        // Remove any drifts recorded during failed attempts for this source item
                        drifts.RemoveRange(drifts.Count - driftCounter, driftCounter);
                    }
                    continue;
                }

                // If no attempts happened (r was empty) or lastCompareResult is $null, record AllDrifts as original did
                if (!wasProcessed)
                {
                    drifts.Add(new Dictionary<string, object>
                    {
                        { "PropertyName", $"{propName}[{i}]" },
                        { "CurrentValue", right },
                        { "DesiredValue", left }
                    });
                }
                result = false;
                return false;
            }

            return true;
        }

        /// <summary>
        /// Compares a single (non-array) complex object or simple value.
        /// </summary>
        private static bool CompareSingleObject(
            object left,
            object right,
            string propName,
            List<Dictionary<string, object>> drifts,
            Stack<ComparisonFrame> workStack,
            ref bool result)
        {
            // Get keys from source object
            var leftKeys = GetObjectKeys(left);
            if (right is PSObject psObject)
            {
                right = psObject.BaseObject;
            }

            bool returnResult = true;
            foreach (var key in leftKeys)
            {
                // Check if key exists in target
                if (!HasKey(right, key))
                {
                    continue;
                }

                var sourceValue = GetValue(left, key);
                var targetValue = GetValue(right, key);

                // One null and the other not => drift
                if ((sourceValue is null) != (targetValue is null))
                {
                    drifts.Add(new Dictionary<string, object>
                    {
                        { "PropertyName", $"{propName}.{key}" },
                        { "CurrentValue", targetValue },
                        { "DesiredValue", sourceValue }
                    });
                    result = false;
                    returnResult = false;
                    continue;
                }

                if (sourceValue is not null && targetValue is not null)
                {
                    // Check if complex nested type
                    if (IsComplexType(sourceValue))
                    {
                        // Push nested comparison onto stack
                        workStack.Push(new ComparisonFrame
                        {
                            Left = sourceValue,
                            Right = targetValue,
                            PropName = $"{propName}.{key}"
                        });
                        continue;
                    }

                    // Simple type comparison
                    if (!CompareSimpleValues(sourceValue, targetValue))
                    {
                        drifts.Add(new Dictionary<string, object>
                        {
                            { "PropertyName", $"{propName}.{key}" },
                            { "CurrentValue", targetValue },
                            { "DesiredValue", sourceValue }
                        });
                        result = false;
                        returnResult = false;
                        continue;
                    }
                }
            }

            return returnResult;
        }

        /// <summary>
        /// Compares simple (non-complex) values.
        /// </summary>
        private static bool CompareSimpleValues(object left, object right)
        {
            if (left is PSObject psObject)
                left = psObject.BaseObject;

            if (right is PSObject psObjectRight)
                right = psObjectRight.BaseObject;

            // Handle DateTime comparison
            if (left is DateTime leftDate && right is DateTime rightDate)
                return leftDate == rightDate;

            // Handle string comparison with normalization
            if (left is string leftStr && right is string rightStr)
            {
                // Normalize line endings
                leftStr = leftStr.Replace("\r\n", "\n");
                rightStr = rightStr.Replace("\r\n", "\n");
                return string.Equals(leftStr, rightStr, StringComparison.OrdinalIgnoreCase);
            }

            // Handle numeric type comparisons (Int32, Int64, Int16, UInt32, etc.)
            if (IsNumericType(left) && IsNumericType(right))
            {
                return CompareNumericValues(left, right);
            }

            // Default comparison
            return left.ToString().Equals(right.ToString(), StringComparison.OrdinalIgnoreCase);
        }

        /// <summary>
        /// Determines if an object is a numeric type.
        /// </summary>
        private static bool IsNumericType(object obj)
        {
            if (obj is null)
                return false;

            Type type = obj.GetType();
            return type == typeof(byte) ||
                   type == typeof(sbyte) ||
                   type == typeof(short) ||
                   type == typeof(ushort) ||
                   type == typeof(int) ||
                   type == typeof(uint) ||
                   type == typeof(long) ||
                   type == typeof(ulong) ||
                   type == typeof(float) ||
                   type == typeof(double) ||
                   type == typeof(decimal);
        }

        /// <summary>
        /// Compares two numeric values, handling different numeric types.
        /// </summary>
        private static bool CompareNumericValues(object left, object right)
        {
            try
            {
                // Convert both values to decimal for comparison
                // Decimal provides the widest range and precision for most scenarios
                decimal leftDecimal = Convert.ToDecimal(left);
                decimal rightDecimal = Convert.ToDecimal(right);
                return leftDecimal == rightDecimal;
            }
            catch (OverflowException)
            {
                // If decimal conversion fails (e.g., for very large ulong values),
                // fall back to double comparison
                try
                {
                    double leftDouble = Convert.ToDouble(left);
                    double rightDouble = Convert.ToDouble(right);
                    return Math.Abs(leftDouble - rightDouble) < double.Epsilon;
                }
                catch
                {
                    // If all conversions fail, use default equality
                    return Equals(left, right);
                }
            }
            catch
            {
                // For any other conversion issues, fall back to default equality
                return Equals(left, right);
            }
        }

        /// <summary>
        /// Determines if an object is a complex array candidate.
        /// </summary>
        private static bool IsComplexArrayCandidate(object obj)
        {
            if (obj is null)
                return false;

            if (obj is Array array && array.Length > 0)
            {
                var firstElement = array.GetValue(0);
                return IsComplexType(firstElement);
            }

            return false;
        }

        /// <summary>
        /// Determines if an object is a complex type requiring deep comparison.
        /// </summary>
        private static bool IsComplexType(object obj)
        {
            if (obj is null)
                return false;

            if (obj is PSObject psObject && psObject.BaseObject is not null)
                obj = psObject.BaseObject;

            return obj is CimInstance ||
                   obj is IDictionary ||
                   obj is Array;
        }

        /// <summary>
        /// Converts an object to an array.
        /// </summary>
        private static Array ToArray(object obj)
        {
            if (obj is null)
                return Array.Empty<object>();

            if (obj is Array array)
                return array;

            if (obj is IEnumerable enumerable)
                return enumerable.Cast<object>().ToArray();

            return new[] { obj };
        }

        /// <summary>
        /// Gets keys from an object (hashtable, PSObject, etc.).
        /// </summary>
        private static IEnumerable<string> GetObjectKeys(object obj)
        {
            if (obj is Hashtable hashtable)
            {
                return hashtable.Keys.Cast<object>()
                    .Select(k => k.ToString())
                    .Where(k => k != "PSComputerName");
            }

            if (obj is PSObject psObj)
            {
                return psObj.Properties
                    .Where(p => p.Name != "PSComputerName")
                    .Select(p => p.Name);
            }

            if (obj is IDictionary dict)
            {
                return dict.Keys.Cast<object>()
                    .Select(k => k.ToString())
                    .Where(k => k != "PSComputerName");
            }

            if (obj is CimInstance cimInstance)
            {
                return cimInstance.CimInstanceProperties
                    .Where(p => p.IsValueModified && p.Name != "PSComputerName")
                    .Select(p => p.Name);
            }

            return [];
        }

        /// <summary>
        /// Checks if an object has a specific key.
        /// </summary>
        private static bool HasKey(object obj, string key)
        {
            if (obj is Hashtable hashtable)
                return hashtable.ContainsKey(key);

            if (obj is PSObject psObj)
                return psObj.Properties[key] is not null;

            if (obj is IDictionary dict)
                return dict.Contains(key);

            return false;
        }

        /// <summary>
        /// Gets a value from an object by key.
        /// </summary>
        private static object? GetValue(object obj, string key)
        {
            if (obj is CimInstance cimInstance)
                return cimInstance.CimInstanceProperties[key]?.Value;

            if (obj is Hashtable hashtable)
                return hashtable[key];

            if (obj is PSObject psObj)
                return psObj.Properties[key]?.Value;

            if (obj is IDictionary dict)
                return dict[key];

            return null;
        }

        /// <summary>
        /// Represents a comparison frame in the iterative comparison stack.
        /// </summary>
        private class ComparisonFrame
        {
            public object Left { get; set; }
            public object Right { get; set; }
            public string PropName { get; set; }
        }
    }
}
