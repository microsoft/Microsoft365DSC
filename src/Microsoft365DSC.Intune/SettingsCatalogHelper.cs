using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;
using System.Reflection;
using System.Text.RegularExpressions;

namespace Microsoft365DSC.Intune
{
    /// <summary>
    /// Internal representation of a Microsoft Graph DeviceManagementConfigurationSettingDefinition.
    /// Avoids a direct dependency on the Microsoft.Graph SDK types.
    /// </summary>
    public class SettingDefinitionInfo
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string OffsetUri { get; set; }

        /// <summary>
        /// Flattened list of unique parentSettingId values from dependentOn[].parentSettingId.
        /// </summary>
        public List<string> DependentOnParentSettingIds { get; set; } = [];

        /// <summary>
        /// Flattened list of unique parentSettingId values from options[].dependentOn[].parentSettingId.
        /// </summary>
        public List<string> OptionsDependentOnParentSettingIds { get; set; } = [];

        /// <summary>
        /// The OData type from ['@odata.type'].
        /// Used to determine the setting type (e.g., ChoiceSettingDefinition, GroupSettingCollectionDefinition).
        /// </summary>
        public string ODataType { get; set; }

        /// <summary>
        /// Maximum number of instances allowed for this setting (from maximumCount).
        /// Used in GroupSettingCollection logic to determine single vs. multi-instance handling.
        /// </summary>
        public int MaximumCount { get; set; }

        /// <summary>
        /// Child setting definition IDs (from childIds).
        /// Used in Export to find child definitions of a GroupSettingCollection.
        /// </summary>
        public List<string> ChildIds { get; set; } = [];

        /// <summary>
        /// Options for ChoiceSetting definitions (from options[]).
        /// Each option has an itemId and an optionValue with a value and OData type.
        /// </summary>
        public List<SettingDefinitionOption> Options { get; set; } = [];

        /// <summary>
        /// Value definition metadata (from valueDefinition).
        /// Contains the OData type and isSecret flag.
        /// </summary>
        public SettingValueDefinition ValueDefinition { get; set; }
    }

    /// <summary>
    /// Maps Microsoft Graph DeviceManagementConfigurationSettingDefinition objects (passed as PSObject or Hashtable)
    /// to the internal <see cref="SettingDefinitionInfo"/> representation.
    /// </summary>
    public static class SettingDefinitionMapper
    {
        private static BindingFlags _publicIgnoreCaseInstanceFlags = BindingFlags.Public | BindingFlags.IgnoreCase | BindingFlags.Instance;

        /// <summary>
        /// Maps a single Graph SettingDefinition (typically a PSObject or Hashtable) to <see cref="SettingDefinitionInfo"/>.
        /// Extracts Id, Name, OffsetUri, and the parentSettingId collections.
        /// </summary>
        public static SettingDefinitionInfo FromGraphObject(object settingDefinition)
        {
            var info = new SettingDefinitionInfo
            {
                Id = TryGetProperty(settingDefinition, "Id"),
                Name = TryGetProperty(settingDefinition, "Name"),
                OffsetUri = TryGetProperty(settingDefinition, "OffsetUri")
            };

            // Extract AdditionalProperties - this is an IDictionary<string, object> on the Graph SDK objects
            // Accessing the property is only possible through reflection with BindingFlags NonPublic and Instance
            IDictionary<string, object>? additionalProperties = null;
            List<string> defaultProperties = ["Id", "Name", "OffsetUri"];
            additionalProperties = new Dictionary<string, object>();
            foreach (DictionaryEntry entry in settingDefinition as Hashtable)
            {
                if (!defaultProperties.Contains(entry.Key.ToString(), StringComparer.OrdinalIgnoreCase))
                {
                    additionalProperties[entry.Key.ToString()] = entry.Value;
                }
            }

            if (additionalProperties is not null)
            {
                info.DependentOnParentSettingIds = ExtractParentSettingIds(additionalProperties, "dependentOn");
                info.OptionsDependentOnParentSettingIds = ExtractOptionsParentSettingIds(additionalProperties);

                // Extract OData type
                if (additionalProperties.TryGetValue("@odata.type", out object? odataTypeValue))
                {
                    info.ODataType = odataTypeValue?.ToString();
                }

                // Extract maximumCount
                if (additionalProperties.TryGetValue("maximumCount", out object? maxCountValue))
                {
                    if (maxCountValue is int maxInt)
                        info.MaximumCount = maxInt;
                    else if (int.TryParse(maxCountValue?.ToString(), out int parsed))
                        info.MaximumCount = parsed;
                }

                // Extract childIds
                if (additionalProperties.TryGetValue("childIds", out object? childIdsValue) && childIdsValue is IEnumerable childIdsEnumerable)
                {
                    foreach (var childId in childIdsEnumerable)
                    {
                        if (childId is not null)
                            info.ChildIds.Add(childId.ToString());
                    }
                }

                // Extract options
                info.Options = ExtractOptions(additionalProperties);

                // Extract valueDefinition
                if (additionalProperties.TryGetValue("valueDefinition", out object? valueDefValue) && valueDefValue is not null)
                {
                    info.ValueDefinition = new SettingValueDefinition
                    {
                        ODataType = TryGetProperty(valueDefValue, "@odata.type"),
                        IsSecret = string.Equals(TryGetProperty(valueDefValue, "isSecret"), "True", StringComparison.OrdinalIgnoreCase)
                    };
                }
            }

            return info;
        }

        /// <summary>
        /// Maps a collection of Graph SettingDefinition objects to a list of <see cref="SettingDefinitionInfo"/>.
        /// </summary>
        public static List<SettingDefinitionInfo> FromGraphObjects(IEnumerable<object> settingDefinitions)
        {
            return settingDefinitions.Select(FromGraphObject).ToList();
        }

        /// <summary>
        /// Extracts parentSettingId values from additionalProperties["dependentOn"][].parentSettingId.
        /// </summary>
        private static List<string> ExtractParentSettingIds(IDictionary<string, object> additionalProperties, string key)
        {
            if (!additionalProperties.TryGetValue(key, out object? value))
                return [];

            if (value is not IEnumerable dependentOnCollection)
                return [];

            List<string> result = [];
            foreach (var item in dependentOnCollection)
            {
                string parentSettingId = TryGetProperty(item, "parentSettingId");
                if (!string.IsNullOrEmpty(parentSettingId))
                    result.Add(parentSettingId);
            }

            return result.Distinct().ToList();
        }

        /// <summary>
        /// Extracts parentSettingId values from additionalProperties["options"][].dependentOn[].parentSettingId.
        /// </summary>
        private static List<string> ExtractOptionsParentSettingIds(IDictionary<string, object> additionalProperties)
        {
            if (!additionalProperties.TryGetValue("options", out object? value))
                return [];

            if (value is not IEnumerable optionsCollection)
                return [];

            List<string> result = [];
            foreach (var option in optionsCollection)
            {
                var dependentOnList = TryGetPropertyAsEnumerable(option, "dependentOn");
                if (dependentOnList is null)
                    continue;

                foreach (var dep in dependentOnList)
                {
                    string parentSettingId = TryGetProperty(dep, "parentSettingId");
                    if (!string.IsNullOrEmpty(parentSettingId))
                        result.Add(parentSettingId);
                }
            }

            return result.Distinct().ToList();
        }

        internal static string TryGetProperty(object obj, string propertyName)
        {
            return TryGetPropertyRaw(obj, propertyName)?.ToString();
        }

        internal static object? TryGetPropertyRaw(object obj, string propertyName)
        {
            if (obj is null)
                return null;

            if (obj is PSObject psobject)
                obj = psobject.BaseObject;

            // Try dictionary access (Hashtable / IDictionary)
            if (obj is IDictionary<string, object> dict && dict.TryGetValue(propertyName, out object? value))
                return value;
            if (obj is Hashtable ht && ht.ContainsKey(propertyName))
                return ht[propertyName];

            // Try reflection
            var prop = obj.GetType().GetProperty(propertyName, _publicIgnoreCaseInstanceFlags);
            return prop?.GetValue(obj);
        }

        internal static IEnumerable<object>? TryGetPropertyAsEnumerable(object obj, string propertyName)
        {
            if (obj is null)
                return null;

            if (obj is PSObject psobject)
                obj = psobject.BaseObject;
    
            if (obj is IDictionary<string, object> dict && dict.TryGetValue(propertyName, out object? value))
                return value as IEnumerable<object>;
            if (obj is Hashtable ht && ht.ContainsKey(propertyName))
                return ht[propertyName] as IEnumerable<object>;

            var prop = obj.GetType().GetProperty(propertyName, _publicIgnoreCaseInstanceFlags);
            return prop?.GetValue(obj) as IEnumerable<object>;
        }

        /// <summary>
        /// Extracts the options array from AdditionalProperties.
        /// Each option has an itemId, optionValue (with @odata.type and value), and dependentOn parent setting IDs.
        /// </summary>
        private static List<SettingDefinitionOption> ExtractOptions(IDictionary<string, object> additionalProperties)
        {
            var options = new List<SettingDefinitionOption>();

            if (!additionalProperties.TryGetValue("options", out object? optionsValue))
                return options;

            if (optionsValue is not IEnumerable optionsCollection)
                return options;

            foreach (var option in optionsCollection)
            {
                if (option is null) continue;

                var opt = new SettingDefinitionOption
                {
                    ItemId = TryGetProperty(option, "itemId")
                };

                // Extract optionValue
                var optionValueRaw = TryGetPropertyRaw(option, "optionValue");
                if (optionValueRaw is not null)
                {
                    opt.OptionValue = new OptionValue
                    {
                        ODataType = TryGetProperty(optionValueRaw, "@odata.type"),
                        Value = TryGetProperty(optionValueRaw, "value")
                    };
                }

                // Extract dependentOn for this option
                var dependentOnList = TryGetPropertyAsEnumerable(option, "dependentOn");
                if (dependentOnList is not null)
                {
                    foreach (var dep in dependentOnList)
                    {
                        string parentSettingId = TryGetProperty(dep, "parentSettingId");
                        if (!string.IsNullOrEmpty(parentSettingId))
                            opt.DependentOnParentSettingIds.Add(parentSettingId);
                    }
                }

                options.Add(opt);
            }

            return options;
        }
    }

    /// <summary>
    /// C# port of the PowerShell module M365DSCIntuneSettingsCatalogUtil.
    /// Provides deterministic setting name resolution for Intune Settings Catalog definitions.
    ///
    /// Each method maps 1:1 to its PowerShell counterpart. Deviations are documented inline.
    /// </summary>
    public static class SettingsCatalogHelper
    {
        /// <summary>
        /// Name simplification rules applied when the setting name was disambiguated (settingsWithSameName.Count > 1).
        /// Each entry is (wildcardPrefix, wildcardSuffix, searchString, replacementString).
        ///
        /// Corresponds to the "switch -wildcard" block in the PowerShell Get-SettingsCatalogSettingName.
        ///
        /// Optimization note: The PowerShell version uses a switch with -Wildcard patterns that are evaluated
        /// sequentially. Here we use a data-driven approach with a list of tuples, which is equivalent but
        /// more maintainable - adding a new simplification rule requires only one line instead of a new
        /// switch case block.
        /// </summary>
        private static readonly List<(string? ExactMatch, string? Prefix, string? Suffix, string? Search, string Replace)> NameSimplificationRules =
            [
                // Exact match: 'com.apple.managedclient.preferences_enforcementLevel' -> 'enforcementLevel'
                ("com.apple.managedclient.preferences_enforcementLevel", null, null, null, "enforcementLevel"),

                // Wildcard prefix replacements: 'prefix*' -> replace prefix portion
                (null, "access16v2~Policy~L_MicrosoftOfficeaccess~L_ApplicationSettings~", null,
                    "access16v2~Policy~L_MicrosoftOfficeaccess~L_ApplicationSettings", "MicrosoftAccess_"),
                (null, "excel16v2~Policy~L_MicrosoftOfficeExcel~L_ExcelOptions~", null,
                    "excel16v2~Policy~L_MicrosoftOfficeExcel~L_ExcelOptions", "MicrosoftExcel_"),
                (null, "word16v2~Policy~L_MicrosoftOfficeWord~L_WordOptions~", null,
                    "word16v2~Policy~L_MicrosoftOfficeWord~L_WordOptions", "MicrosoftWord_"),
                (null, "ppt16v2~Policy~L_MicrosoftOfficePowerPoint~L_PowerPointOptions~", null,
                    "ppt16v2~Policy~L_MicrosoftOfficePowerPoint~L_PowerPointOptions", "MicrosoftPowerPoint_"),
                (null, "proj16v2~Policy~L_Proj~L_ProjectOptions~", null,
                    "proj16v2~Policy~L_Proj~L_ProjectOptions", "MicrosoftProject_"),
                (null, "visio16v2~Policy~L_MicrosoftVisio~L_VisioOptions~", null,
                    "visio16v2~Policy~L_MicrosoftVisio~L_VisioOptions", "MicrosoftVisio_"),
                (null, "pub16v2~Policy~L_MicrosoftOfficePublisher~", null,
                    "pub16v2~Policy~L_MicrosoftOfficePublisher", "MicrosoftPublisherV2_"),
                (null, "pub16v3~Policy~L_MicrosoftOfficePublisher~", null,
                    "pub16v3~Policy~L_MicrosoftOfficePublisher", "MicrosoftPublisherV3_"),
                (null, "microsoft_edge~Policy~microsoft_edge~", null,
                    "microsoft_edge~Policy~microsoft_edge", "MicrosoftEdge_"),
                (null, "edge~httpauthentication", null,
                    "edge~httpauthentication", "MicrosoftEdge_HTTPAuthentication"),
                (null, "edge~contentsettings", null,
                    "edge~contentsettings", "MicrosoftEdge_ContentSettings"),
                (null, "edge~passwordmanager", null,
                    "edge~passwordmanager", "MicrosoftEdge_PasswordManager"),

                // Contains-style (wildcard on both sides): '*~X~*' or '*~X_*'
                (null, null, "~SmartScreen_", "~SmartScreen", "SmartScreen"),
                (null, null, "~L_Security~", "~L_Security", "Security"),
                (null, null, "~L_TrustCenter", "~L_TrustCenter", "_TrustCenter"),
                (null, null, "~L_ProtectedView_", "~L_ProtectedView", "ProtectedView"),
                (null, null, "~L_FileBlockSettings_", "~L_FileBlockSettings", "FileBlockSettings"),
                (null, null, "~L_TrustedLocations", "~L_TrustedLocations", "TrustedLocations"),
                (null, null, "~HTTPAuthentication_", "~HTTPAuthentication", "HTTPAuthentication"),
            ];

        /// <summary>
        /// Port of Get-SettingsCatalogSettingName.
        /// Resolves a unique, human-readable setting name for a given setting definition.
        /// Accepts raw Graph SDK objects and maps them internally.
        /// </summary>
        public static string GetSettingName(object settingDefinitionAsGraph, List<object> allSettingDefinitionsAsGraph)
        {
            var settingDefinition = SettingDefinitionMapper.FromGraphObject(settingDefinitionAsGraph);
            var allSettingDefinitions = SettingDefinitionMapper.FromGraphObjects(allSettingDefinitionsAsGraph);
            return GetSettingName(settingDefinition, allSettingDefinitions);
        }

        /// <summary>
        /// Port of Get-SettingsCatalogSettingName.
        /// Resolves a unique, human-readable setting name for a given setting definition.
        /// Accepts pre-mapped <see cref="SettingDefinitionInfo"/> objects to avoid repeated reflection.
        /// </summary>
        public static string GetSettingName(SettingDefinitionInfo settingDefinition, List<SettingDefinitionInfo> allSettingDefinitions)
        {

            // Remove invalid characters and replace spaces with underscores
            string settingName = Regex.Replace(settingDefinition.Name, @"[\{\}\$]", "");
            settingName = settingName.Replace(' ', '_');

            var settingsWithSameName = allSettingDefinitions.Where(s => s.Name.Equals(settingName, StringComparison.OrdinalIgnoreCase)).ToList();

            // Edge case where the same setting is defined twice with identical name and id
            // Example is RDVAllowBDE_Name from the IntuneDiskEncryptionWindows10 resource
            if (settingsWithSameName.Count == 2)
            {
                if (settingsWithSameName[0].Id.Equals(settingsWithSameName[1].Id) &&
                    settingsWithSameName[0].Name.Equals(settingsWithSameName[1].Name, StringComparison.OrdinalIgnoreCase))
                {
                    settingsWithSameName = [settingsWithSameName[0]];
                }
            }

            if (settingsWithSameName.Count > 1)
            {
                // Get the parent setting of the current setting
                var parentSetting = GetParentSettingDefinition(settingDefinition, allSettingDefinitions);

                if (parentSetting is not null)
                {
                    // Check if parent+name combination is unique
                    List<SettingDefinitionInfo> combinationMatchesWithParent = [];
                    foreach (var s in settingsWithSameName)
                    {
                        var innerParent = GetParentSettingDefinition(s, allSettingDefinitions);
                        if (innerParent is not null)
                        {
                            if ($"{innerParent.Name}_{s.Name}".Equals($"{parentSetting.Name}_{settingName}", StringComparison.OrdinalIgnoreCase))
                            {
                                combinationMatchesWithParent.Add(s);
                            }
                        }
                    }

                    // If the combination of parent setting and setting name is unique, add the parent setting name to the setting name
                    if (combinationMatchesWithParent.Count == 1)
                    {
                        // Unique with parent prefix
                        settingName = parentSetting.Name + "_" + settingName;
                    }
                    // If the combination of parent setting and setting name is still not unique, do it with the OffsetUri of the current setting
                    else
                    {
                        // Try disambiguating via OffsetUri traversal
                        var result = GetUniqueNameFromMultipleMatches(settingDefinition, settingName, settingsWithSameName);
                        if (result.Success)
                        {
                            settingName = result.SettingName;
                        }
                        else
                        {
                            // Fallback: derive from parent setting Id
                            // Alternative way if no unique setting name can be found
                            string[] parentIdParts = parentSetting.Id.Split('_');
                            string parentSettingIdProperty = parentIdParts[parentIdParts.Length - 1];
                            string parentSettingIdWithoutProperty = parentSetting.Id
                                .Substring(0, parentSetting.Id.Length - parentSettingIdProperty.Length - 1);

                            // We can't use the entire setting here because the child setting id does not have to come after the parent setting id
                            settingName = settingDefinition.Id
                                .Replace(parentSettingIdWithoutProperty + "_", "")
                                .Replace(parentSettingIdProperty + "_", "");
                        }
                    }
                }

                // When there is no parent, we can't use the parent setting name to make the setting name unique
                // Instead, we traverse up the OffsetUri.
                if (parentSetting is null)
                {
                    var result = GetUniqueNameFromMultipleMatches(settingDefinition, settingName, settingsWithSameName);
                    if (result.Success)
                    {
                        settingName = result.SettingName;
                    }
                    else
                    {
                        // Can happen if both settings have the same name and the same OffsetUri, e.g. "enforcementLevel" in the IntuneAntivirusPolicyLinux resource
                        // Potential risk of overwriting settings with the same name but different OffsetUri
                        string settingIdWithoutName = Regex.Replace(settingDefinition.Id, "_" + settingName, "", RegexOptions.IgnoreCase);
                        string[] parts = settingIdWithoutName.Split('_');
                        string lastPart = parts[parts.Length - 1];
                        settingName = lastPart + "_" + settingName;
                    }
                }

                // Apply name simplification rules
                // Simplify names from the OffsetUri. This is done to make the names more readable, especially in case of long and complex OffsetUris.
                settingName = ApplyNameSimplification(settingName);
            }

            return settingName;
        }

        /// <summary>
        /// Port of Get-ParentSettingDefinition.
        /// Finds the parent setting by looking up the first unique parentSettingId
        /// from either dependentOn or options.dependentOn.
        /// </summary>
        public static SettingDefinitionInfo GetParentSettingDefinition(
            SettingDefinitionInfo settingDefinition,
            List<SettingDefinitionInfo> allSettingDefinitions)
        {
            if (settingDefinition.DependentOnParentSettingIds.Count > 0)
            {
                string parentId = settingDefinition.DependentOnParentSettingIds.First();
                return allSettingDefinitions.FirstOrDefault(s => s.Id == parentId);
            }

            if (settingDefinition.OptionsDependentOnParentSettingIds.Count > 0)
            {
                string parentId = settingDefinition.OptionsDependentOnParentSettingIds.First();
                return allSettingDefinitions.FirstOrDefault(s => s.Id == parentId);
            }

            return null;
        }

        /// <summary>
        /// Port of Get-UniqueSettingDefinitionNameFromMultipleMatches.
        /// Iteratively traverses up the OffsetUri to find a unique prefix for the setting name.
        /// </summary>
        public static (bool Success, string SettingName) GetUniqueNameFromMultipleMatches(
            SettingDefinitionInfo settingDefinition,
            string settingName,
            List<SettingDefinitionInfo> settingsWithSameName)
        {
            int skip = 0;
            int breakCounter = 0;
            const int threshold = 8;
            string newSettingName = settingName;
            List<SettingDefinitionInfo> combinationMatches;

            do
            {
                string previousSettingName = newSettingName;
                newSettingName = GetSettingDefinitionNameFromOffsetUri(settingDefinition.OffsetUri, newSettingName, skip);

                combinationMatches = [];
                foreach (var s in settingsWithSameName)
                {
                    string newName = GetSettingDefinitionNameFromOffsetUri(s.OffsetUri, previousSettingName, skip);
                    if (newName.Equals(newSettingName, StringComparison.OrdinalIgnoreCase))
                    {
                        // Exclude v2 versions from the comparison
                        bool currentIsV2 = settingDefinition.Id.EndsWith("_v2");
                        if (currentIsV2 && s.Id != settingDefinition.Id.Replace("_v2", "") ||
                            !currentIsV2 && s.Id != settingDefinition.Id + "_v2")
                        {
                            combinationMatches.Add(s);
                        }
                    }
                }

                settingsWithSameName = combinationMatches;
                skip++;
                breakCounter++;
            } while (combinationMatches.Count > 1 && breakCounter < threshold);

            if (breakCounter < threshold)
            {
                if (settingDefinition.Id.EndsWith("_v2") && !newSettingName.EndsWith("_v2"))
                {
                    newSettingName += "_v2";
                }

                return (true, newSettingName);
            }

            return (false, settingName);
        }

        /// <summary>
        /// Port of Get-SettingDefinitionNameFromOffsetUri.
        /// Traverses up the OffsetUri segments to find a distinguishing prefix for the setting name.
        ///
        /// Optimization note: Instead of PowerShell array slicing ($arr[0..($arr.Length - 1 - $Skip)])
        /// which creates new arrays at each step, we use a List and track the effective length via an
        /// integer index. The algorithm is otherwise identical.
        /// </summary>
        public static string GetSettingDefinitionNameFromOffsetUri(string offsetUri, string settingName, int skip = 0)
        {
            // If the last part of the OffsetUri is the same as the setting name or it contains invalid characters, we traverse up until we reach the first element
            // Invalid characters are { and } which are used in the OffsetUri to indicate a variable
            var segments = offsetUri.Split('/').Where(s => !string.IsNullOrEmpty(s)).ToList();

            if (skip > segments.Count - 1)
            {
                return settingName;
            }

            // PS: $splittedOffsetUri = $splittedOffsetUri[0..($splittedOffsetUri.Length - 1 - $Skip)]
            // Effectively remove $skip elements from the end
            int effectiveLength = segments.Count - skip;

            // Traverse upward while the last element matches settingName, contains { or }, or settingName starts with it
            // PS: while (-not $traversed -and $splittedOffsetUri.Length -gt 1)
            bool traversed = false;
            while (!traversed && effectiveLength > 1)
            {
                traversed = true;
                string lastSegment = segments[effectiveLength - 1];

                // PS: if ($splittedOffsetUri[-1] -eq $SettingName -or $splittedOffsetUri[-1] -match '[\{\}]' -or $SettingName.StartsWith($splittedOffsetUri[-1]))
                if (lastSegment.Equals(settingName, StringComparison.OrdinalIgnoreCase) ||
                    lastSegment.IndexOfAny(['{', '}']) >= 0 ||
                    settingName.StartsWith(lastSegment, StringComparison.OrdinalIgnoreCase))
                {
                    effectiveLength--;
                    traversed = false;
                }
            }

            // PS: if ($splittedOffsetUri.Length -gt 1) { $splittedOffsetUri[-1] + '_' + $SettingName } else { $SettingName }
            return effectiveLength > 1
                ? segments[effectiveLength - 1] + "_" + settingName
                : settingName;
        }

        /// <summary>
        /// Applies the name simplification rules that correspond to the PowerShell switch -wildcard block.
        ///
        /// Important behavioral note: The PowerShell switch -Wildcard does NOT break after the first match -
        /// all matching cases are executed sequentially. This C# implementation replicates that behavior by
        /// iterating through ALL rules and applying every match. This matters for names that could match
        /// multiple rules (e.g., a name containing both a prefix pattern and a contains pattern like '~SmartScreen_').
        /// </summary>
        private static string ApplyNameSimplification(string settingName)
        {
            foreach (var (ExactMatch, Prefix, Suffix, Search, Replace) in NameSimplificationRules)
            {
                // Exact match
                if (ExactMatch is not null)
                {
                    if (settingName == ExactMatch)
                    {
                        settingName = Replace;
                    }
                    continue;
                }

                // Prefix match: 'prefix*'
                if (Prefix is not null)
                {
                    if (settingName.StartsWith(Prefix))
                    {
                        settingName = settingName.Replace(Search, Replace);
                    }
                    continue;
                }

                // Contains match (Suffix is used as the contains-check string): '*contains*'
                if (Suffix is not null)
                {
                    if (settingName.Contains(Suffix))
                    {
                        settingName = settingName.Replace(Search, Replace);
                    }
                }
            }

            return settingName;
        }
    }
}
