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
            foreach (var sourceItem in source)
            {
                if (sourceItem is null)
                {
                    continue;
                }

                var assignment = ComplexObjectConverter.ToHashtable(sourceItem);
                var dataType = GetPropertyValue<string>(assignment, "dataType");

                if (string.IsNullOrEmpty(dataType))
                {
                    continue;
                }

                // Check if dataType ends with 'AssignmentTarget'
                if (dataType!.EndsWith("AssignmentTarget", StringComparison.OrdinalIgnoreCase))
                {
                    var assignmentGroupId = GetPropertyValue<string>(assignment, "groupId");
                    var assignmentIntent = GetPropertyValue<string>(assignment, "intent");

                    // Find matching assignment target by dataType and groupId
                    Hashtable? assignmentTarget = FindAssignmentTarget(target, dataType, assignmentGroupId);
                    testResult = assignmentTarget is not null;

                    // Check for mobile app assignments with intent
                    if (testResult && !string.IsNullOrEmpty(assignmentIntent))
                    {
                        var targetIntent = GetPropertyValue<string>(assignmentTarget, "intent");
                        testResult = string.Equals(assignmentIntent, targetIntent, StringComparison.OrdinalIgnoreCase);
                    }

                    // If not found by groupId, try by groupDisplayName
                    if (!testResult)
                    {
                        var assignmentGroupDisplayName = GetPropertyValue<string>(assignment, "groupDisplayName");
                        assignmentTarget = FindAssignmentTargetByDisplayName(target, dataType, assignmentGroupDisplayName);
                        testResult = assignmentTarget is not null;

                        if (!testResult)
                        {
                            drifts.Add(new Dictionary<string, object>
                            {
                                { "PropertyName", "Assignments.GroupDisplayName" },
                                { "CurrentValue", assignmentGroupDisplayName },
                                { "DesiredValue", null }
                            });
                        }
                    }

                    // Check filters if group found
                    if (testResult)
                    {
                        testResult = CompareFilters(assignment, assignmentTarget, drifts);
                    }

                    // Check collectionId if still matching
                    if (testResult)
                    {
                        var assignmentCollectionId = GetPropertyValue<string>(assignment, "collectionId");
                        var targetCollectionId = GetPropertyValue<string>(assignmentTarget, "collectionId");

                        testResult = string.Equals(assignmentCollectionId, targetCollectionId, StringComparison.OrdinalIgnoreCase);

                        if (!testResult)
                        {
                            drifts.Add(new Dictionary<string, object>
                            {
                                { "PropertyName", "Assignments.collectionId" },
                                { "CurrentValue", assignmentCollectionId },
                                { "DesiredValue", targetCollectionId }
                            });
                        }
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

                        var targetHash = ComplexObjectConverter.ToHashtable(targetItem);
                        var targetDataType = GetPropertyValue<string>(targetHash, "dataType");

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
                            { "PropertyName", "Assignments.DataType" },
                            { "CurrentValue", dataType },
                            { "DesiredValue", null }
                        });
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
        private static bool CompareFilters(Hashtable assignment, Hashtable assignmentTarget, List<Dictionary<string, object>> drifts)
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
                    { "PropertyName", "Assignments.Filters" },
                    { "CurrentValue", assignmentFilterType },
                    { "DesiredValue", targetFilterType }
                });
            }

            return testResult;
        }

        /// <summary>
        /// Finds an assignment target in the array by dataType and groupId.
        /// </summary>
        private static Hashtable? FindAssignmentTarget(Array targetArray, string dataType, string groupId)
        {
            foreach (var item in targetArray)
            {
                if (item is null) continue;

                var hashtable = ComplexObjectConverter.ToHashtable(item);
                var itemDataType = GetPropertyValue<string>(hashtable, "dataType");
                var itemGroupId = GetPropertyValue<string>(hashtable, "groupId");

                if (string.Equals(dataType, itemDataType, StringComparison.OrdinalIgnoreCase) &&
                    string.Equals(groupId, itemGroupId, StringComparison.OrdinalIgnoreCase))
                {
                    return hashtable;
                }
            }

            return null;
        }

        /// <summary>
        /// Finds an assignment target in the array by dataType and groupDisplayName.
        /// </summary>
        private static Hashtable? FindAssignmentTargetByDisplayName(Array targetArray, string dataType, string groupDisplayName)
        {
            foreach (var item in targetArray)
            {
                if (item is null) continue;

                var hashtable = ComplexObjectConverter.ToHashtable(item);
                var itemDataType = GetPropertyValue<string>(hashtable, "dataType");
                var itemGroupDisplayName = GetPropertyValue<string>(hashtable, "groupDisplayName");

                if (string.Equals(dataType, itemDataType, StringComparison.OrdinalIgnoreCase) &&
                    string.Equals(groupDisplayName, itemGroupDisplayName, StringComparison.OrdinalIgnoreCase))
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
