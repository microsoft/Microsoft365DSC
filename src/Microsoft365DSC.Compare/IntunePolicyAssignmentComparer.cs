using Microsoft365DSC.Converter;
using System;
using System.Collections;
using System.Collections.Generic;

namespace Microsoft365DSC.Compare
{
    /// <summary>
    /// Compares Intune policy assignments between source and target arrays.
    /// </summary>
    internal static class IntunePolicyAssignmentComparer
    {
        /// <summary>
        /// Compares two arrays of Intune policy assignments and identifies drifts.
        /// </summary>
        /// <param name="source">The source array of assignments (desired state)</param>
        /// <param name="target">The target array of assignments (current state)</param>
        /// <param name="drifts">List to collect drift information</param>
        /// <returns>True if assignments match, false otherwise</returns>
        public static bool Compare(Array source, Array target, List<Dictionary<string, object>> drifts)
        {
            if (source is null || target is null)
            {
                return source == target;
            }

            bool testResult = source.Length == target.Length;

            if (!testResult)
            {
                drifts.Add(new Dictionary<string, object>
                {
                    { "PropertyName", "Assignments.Count" },
                    { "CurrentValue", target.Length },
                    { "DesiredValue", source.Length }
                });
                return false;
            }

            // Compare each assignment in source array
            for (int i = 0; i < source.Length; i++)
            {
                var sourceItem = source.GetValue(i);
                if (sourceItem is null)
                {
                    continue;
                }

                Hashtable? assignment = ComplexObjectConverter.ToHashtable(sourceItem);
                Hashtable? assignmentTarget = null;
                string? dataType = GetPropertyValue<string>(assignment, "dataType");

                if (string.IsNullOrEmpty(dataType))
                {
                    continue;
                }

                // Check if dataType ends with 'AssignmentTarget'
                if (dataType!.EndsWith("AssignmentTarget", StringComparison.OrdinalIgnoreCase))
                {
                    var assignmentGroupId = GetPropertyValue<string>(assignment, "groupId");
                    var assignmentCollectionId = GetPropertyValue<string>(assignment, "collectionId");
                    var assignmentIntent = GetPropertyValue<string>(assignment, "intent");

                    if (dataType.Equals("#microsoft.graph.allDevicesAssignmentTarget", StringComparison.OrdinalIgnoreCase)
                        || dataType.Equals("#microsoft.graph.allLicensedUsersAssignmentTarget", StringComparison.OrdinalIgnoreCase))
                    {
                        assignmentTarget = FindAssignmentTarget(target, "dataType", dataType);
                    }

                    // Find matching assignment target by dataType and groupId
                    if (assignmentTarget is null && assignmentGroupId is not null)
                    {
                        assignmentTarget = FindAssignmentTarget(target, "groupId", assignmentGroupId);
                        testResult = assignmentTarget is not null;
                    }

                    if (assignmentTarget is null && assignmentCollectionId is not null)
                    {
                        assignmentTarget = FindAssignmentTarget(target, "collectionId", assignmentCollectionId);
                        testResult = assignmentTarget is not null;
                    }

                    // If not found by groupId, try by groupDisplayName
                    if (!testResult)
                    {
                        var assignmentGroupDisplayName = GetPropertyValue<string>(assignment, "groupDisplayName");
                        assignmentTarget = FindAssignmentTarget(target, "groupDisplayName", assignmentGroupDisplayName);
                        testResult = assignmentTarget is not null;

                        if (!testResult)
                        {
                            drifts.Add(new Dictionary<string, object>
                            {
                                { "PropertyName", $"Assignments[{i}].groupDisplayName" },
                                { "CurrentValue", GetPropertyValue<string>(ComplexObjectConverter.ToHashtable(target.GetValue(i)), "groupDisplayName") ?? string.Empty },
                                { "DesiredValue", assignmentGroupDisplayName }
                            });
                        }
                    }

                    // Check for mobile app assignments with intent
                    if (testResult && !string.IsNullOrEmpty(assignmentIntent))
                    {
                        var targetIntent = GetPropertyValue<string>(assignmentTarget, "intent");
                        testResult = string.Equals(assignmentIntent, targetIntent, StringComparison.OrdinalIgnoreCase);
                    }

                    if (testResult)
                    {
                        string? assignmentTargetDataType = GetPropertyValue<string>(assignmentTarget, "dataType");
                        testResult = dataType.Equals(assignmentTargetDataType, StringComparison.OrdinalIgnoreCase);
                        if (!testResult)
                        {
                            drifts.Add(new Dictionary<string, object>
                            {
                                { "PropertyName", $"Assignments[{i}].dataType" },
                                { "CurrentValue", dataType },
                                { "DesiredValue", assignmentTargetDataType }
                            });
                        }
                    }

                    // Check filters if group found
                    if (testResult)
                    {
                        testResult = CompareFilters(assignment, assignmentTarget, i, drifts);
                    }
                }
                else
                {
                    // For non-AssignmentTarget types, just check if dataType exists in target
                    bool found = false;
                    foreach (var targetItem in target)
                    {
                        if (targetItem is null)
                            continue;

                        assignmentTarget = ComplexObjectConverter.ToHashtable(targetItem);
                        var targetDataType = GetPropertyValue<string>(assignmentTarget, "dataType");

                        if (string.Equals(dataType, targetDataType, StringComparison.OrdinalIgnoreCase))
                        {
                            found = true;
                            break;
                        }
                    }

                    testResult = found;

                    if (!testResult)
                    {
                        drifts.Add(new Dictionary<string, object>
                        {
                            { "PropertyName", $"Assignments[{i}].DataType" },
                            { "CurrentValue", dataType },
                            { "DesiredValue", null }
                        });
                    }
                }

                if (testResult)
                {
                    // Check for assignmentSettings if available
                    var assignmentSettings = GetPropertyValue<Hashtable>(assignment, "assignmentSettings");
                    if (assignmentSettings is not null)
                    {
                        var targetAssignmentSettings = GetPropertyValue<Hashtable>(assignmentTarget, "assignmentSettings");
                        var compareResult = ComplexObjectComparer.Compare(assignmentSettings, targetAssignmentSettings, $"Assignments[{i}].assignmentSettings", []);
                        if (!compareResult.Item2)
                        {
                            testResult = false;
                            foreach (var drift in compareResult.Item1)
                            {
                                drifts.Add(drift);
                            }
                        }
                    }
                }

                // Exit loop if drift found
                if (!testResult)
                {
                    break;
                }
            }

            return testResult;
        }

        /// <summary>
        /// Compares filter settings between source and target assignments.
        /// </summary>
        private static bool CompareFilters(Hashtable assignment, Hashtable assignmentTarget, int index, List<Dictionary<string, object>> drifts)
        {
            var assignmentFilterType = GetPropertyValue<string>(assignment, "deviceAndAppManagementAssignmentFilterType");
            var targetFilterType = GetPropertyValue<string>(assignmentTarget, "deviceAndAppManagementAssignmentFilterType");
            var assignmentFilterId = GetPropertyValue<string>(assignment, "deviceAndAppManagementAssignmentFilterId");
            var targetFilterId = GetPropertyValue<string>(assignmentTarget, "deviceAndAppManagementAssignmentFilterId");

            bool isFilterTypeSpecified =
                (!string.IsNullOrEmpty(assignmentFilterType) && !assignmentFilterType!.Equals("none", StringComparison.OrdinalIgnoreCase)) ||
                (!string.IsNullOrEmpty(targetFilterType) && !targetFilterType!.Equals("none", StringComparison.OrdinalIgnoreCase));

            bool isFilterIdSpecified =
                (!string.IsNullOrEmpty(assignmentFilterId) && !assignmentFilterId!.Equals("00000000-0000-0000-0000-000000000000", StringComparison.OrdinalIgnoreCase)) ||
                (!string.IsNullOrEmpty(targetFilterId) && !targetFilterId!.Equals("00000000-0000-0000-0000-000000000000", StringComparison.OrdinalIgnoreCase));

            bool testResult = true;

            if (isFilterTypeSpecified)
            {
                testResult = string.Equals(assignmentFilterType, targetFilterType, StringComparison.OrdinalIgnoreCase);
            }

            if (testResult && isFilterTypeSpecified && isFilterIdSpecified)
            {
                testResult = string.Equals(assignmentFilterId, targetFilterId, StringComparison.OrdinalIgnoreCase);

                // If filterId doesn't match, check filterDisplayName
                if (!testResult)
                {
                    var assignmentFilterDisplayName = GetPropertyValue<string>(assignment, "deviceAndAppManagementAssignmentFilterDisplayName");
                    var targetFilterDisplayName = GetPropertyValue<string>(assignmentTarget, "deviceAndAppManagementAssignmentFilterDisplayName");
                    testResult = string.Equals(assignmentFilterDisplayName, targetFilterDisplayName, StringComparison.OrdinalIgnoreCase);
                }
            }

            if (!testResult)
            {
                drifts.Add(new Dictionary<string, object>
                {
                    { "PropertyName", $"Assignments[{index}].Filters" },
                    { "CurrentValue", assignmentFilterType },
                    { "DesiredValue", targetFilterType }
                });
            }

            return testResult;
        }

        /// <summary>
        /// Finds an assignment target in the array by property value
        /// </summary>
        private static Hashtable? FindAssignmentTarget(Array targetArray, string key, string value)
        {
            foreach (var item in targetArray)
            {
                if (item is null) continue;

                var hashtable = ComplexObjectConverter.ToHashtable(item);
                var itemValue = GetPropertyValue<string>(hashtable, key);

                if (string.Equals(value, itemValue, StringComparison.OrdinalIgnoreCase))
                {
                    return hashtable;
                }
            }

            return null;
        }

        /// <summary>
        /// Gets a typed property value from a hashtable with null safety.
        /// </summary>
        private static T? GetPropertyValue<T>(Hashtable? hashtable, string key)
        {
            if (hashtable is null || !hashtable.ContainsKey(key))
            {
                return default;
            }

            var value = hashtable[key];
            if (value is null)
            {
                return default;
            }

            try
            {
                return typeof(T) == typeof(string)
                    ? (T)(object)value.ToString()
                    : (T)value;
            }
            catch
            {
                return default;
            }
        }
    }
}
