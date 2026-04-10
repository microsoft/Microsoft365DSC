using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;
using Microsoft.Management.Infrastructure;

namespace Microsoft365DSC.Intune
{
    /// <summary>
    /// C# port of <c>Get-IntuneSettingCatalogPolicySetting</c> and <c>Get-IntuneSettingCatalogPolicySettingInstanceValue</c>.
    /// Builds the Settings Catalog policy body (array of setting instances) from DSC parameters and setting templates.
    ///
    /// <para><b>Architecture:</b></para>
    /// <list type="bullet">
    /// <item>The Graph API call to fetch setting templates remains in PowerShell.</item>
    /// <item>This class receives the raw Graph SDK template objects and the DSC parameter hashtable.</item>
    /// <item>All template/definition objects are mapped to C# models at the boundary via <see cref="SettingTemplateMapper"/>
    /// and <see cref="SettingDefinitionMapper"/>, then the builder works purely with C# models.</item>
    /// <item>Value resolution delegates to <see cref="SettingValueResolver.Resolve"/> (already ported).</item>
    /// <item>CIM instances from DSC parameters are handled via direct <c>CimInstance</c> access.</item>
    /// </list>
    /// </summary>
    public static class SettingCatalogPolicySettingBuilder
    {
        private const string ODataTypePrefix = "#microsoft.graph.deviceManagementConfiguration";
        private const string SettingODataType = "#microsoft.graph.deviceManagementConfigurationSetting";
        private const string GroupSettingCollectionInstanceType = "#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance";
        private const string SettingGroupCollectionDefinitionType = "#microsoft.graph.deviceManagementConfigurationSettingGroupCollectionDefinition";
        private const string ChoiceSettingInstanceType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance";
        private const string ChoiceSettingDefinitionType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingDefinition";
        private const string ChoiceSettingCollectionInstanceType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance";
        private const string ChoiceSettingCollectionDefinitionType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionDefinition";
        private const string SimpleSettingCollectionInstanceType = "#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance";
        private const string SimpleSettingCollectionDefinitionType = "#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionDefinition";
        private const string ChoiceSettingValueType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue";
        private const string SecretSettingValueType = "#microsoft.graph.deviceManagementConfigurationSecretSettingValue";
        private const string DefaultSettingInstanceName = "MSFT_MicrosoftGraphIntuneSettingsCatalog";

        /// <summary>
        /// Builds the Settings Catalog policy body from DSC parameters and setting templates.
        /// Entry point called from PowerShell after template fetching.
        /// </summary>
        /// <param name="settingTemplatesFromGraph">
        /// Raw Graph SDK objects from <c>Get-MgBetaDeviceManagementConfigurationPolicyTemplateSettingTemplate</c>.
        /// </param>
        /// <param name="dscParams">The DSC parameters hashtable (Identity/DisplayName/Description already removed).</param>
        /// <param name="containsDeviceAndUserSettings">True if the policy has separate device_ and user_ prefixed settings.</param>
        /// <returns>Array of Hashtables, each representing a <c>deviceManagementConfigurationSetting</c>.</returns>
        public static Hashtable[] Build(
            IList<object> settingTemplatesFromGraph,
            Hashtable dscParams,
            bool containsDeviceAndUserSettings = false)
        {
            // Map all Graph objects to internal models at the boundary
            List<SettingTemplateInfo> settingTemplates = SettingTemplateMapper.FromGraphObjects(settingTemplatesFromGraph);

            return containsDeviceAndUserSettings
                ? BuildDeviceAndUserSettings(settingTemplates, dscParams)
                : BuildCore(settingTemplates, dscParams);
        }

        /// <summary>
        /// Core build logic that processes setting templates and produces setting instance Hashtables.
        /// </summary>
        private static Hashtable[] BuildCore(
            List<SettingTemplateInfo> settingTemplates,
            Hashtable dscParams)
        {
            // Collect all definitions across all templates
            List<SettingDefinitionInfo> allDefinitions = settingTemplates.SelectMany(t => t.SettingDefinitions).ToList();
            List<Hashtable> settingInstances = [];

            foreach (var settingTemplate in settingTemplates)
            {
                if (settingTemplate.SettingInstanceTemplate is null)
                    continue;

                var instanceTemplate = settingTemplate.SettingInstanceTemplate;

                // Find root definition: matches SettingDefinitionId and has no dependentOn/optionsDependentOn
                var settingDefinition = settingTemplate.SettingDefinitions
                    .Where(d => string.Equals(d.Id, instanceTemplate.SettingDefinitionId, StringComparison.OrdinalIgnoreCase) &&
                                d.DependentOnParentSettingIds.Count == 0 &&
                                d.OptionsDependentOnParentSettingIds.Count == 0)
                    .FirstOrDefault();

                if (settingDefinition is null)
                    continue;

                // Derive setting type: InstanceTemplate -> Instance
                string settingType = instanceTemplate.ODataType?.Replace("InstanceTemplate", "Instance") ?? string.Empty;

                // Build the setting instance hashtable
                var settingInstance = new Hashtable(StringComparer.OrdinalIgnoreCase)
                {
                    ["@odata.type"] = settingType
                };

                if (!string.IsNullOrEmpty(instanceTemplate.SettingInstanceTemplateId))
                {
                    settingInstance["settingInstanceTemplateReference"] = new Hashtable(StringComparer.OrdinalIgnoreCase)
                    {
                        ["settingInstanceTemplateId"] = instanceTemplate.SettingInstanceTemplateId
                    };
                }

                // Use pre-computed values from the template mapper
                string settingValueName = instanceTemplate.SettingValueName;
                string settingValueType = instanceTemplate.ValueTemplateODataType ?? string.Empty;
                string settingValueTemplateId = instanceTemplate.ValueTemplateId;

                // Build the setting instance value recursively
                var settingValue = BuildSettingInstanceValue(
                    dscParams,
                    settingDefinition,
                    instanceTemplate,
                    allDefinitions,
                    settingTemplate.SettingDefinitions,
                    settingType,
                    settingValueName,
                    settingValueType,
                    settingValueTemplateId,
                    DefaultSettingInstanceName,
                    level: 1);

                if (settingValue is null || settingValue.Count == 0)
                    continue;

                // Skip empty group setting collections
                if (settingValue.ContainsKey("groupSettingCollectionValue"))
                {
                    var groupValue = settingValue["groupSettingCollectionValue"] as IList;
                    if (groupValue is not null && groupValue.Count > 0)
                    {
                        var firstGroup = groupValue[0] as Hashtable;
                        var children = firstGroup?["children"] as IList;
                        if (children is not null && children.Count == 0)
                            continue;
                    }
                }

                // Merge the setting value into the setting instance
                foreach (DictionaryEntry entry in settingValue)
                {
                    settingInstance[entry.Key] = entry.Value;
                }

                if (!settingInstance.ContainsKey("settingDefinitionId"))
                {
                    settingInstance["settingDefinitionId"] = instanceTemplate.SettingDefinitionId;
                }

                settingInstances.Add(new Hashtable(StringComparer.OrdinalIgnoreCase)
                {
                    ["@odata.type"] = SettingODataType,
                    ["settingInstance"] = settingInstance
                });
            }

            return settingInstances.ToArray();
        }

        /// <summary>
        /// Handles policies with separate device and user settings.
        /// Splits templates by prefix, extracts CIM-based DSC params for each scope, builds separately.
        /// </summary>
        private static Hashtable[] BuildDeviceAndUserSettings(
            List<SettingTemplateInfo> settingTemplates,
            Hashtable dscParams)
        {
            var deviceTemplates = settingTemplates
                .Where(t => t.SettingInstanceTemplate?.SettingDefinitionId?.StartsWith("device_", StringComparison.OrdinalIgnoreCase) == true)
                .ToList();
            var userTemplates = settingTemplates
                .Where(t => t.SettingInstanceTemplate?.SettingDefinitionId?.StartsWith("user_", StringComparison.OrdinalIgnoreCase) == true)
                .ToList();

            var deviceDscParams = ExtractCimPropertiesCamelCase(dscParams["DeviceSettings"]);
            var userDscParams = ExtractCimPropertiesCamelCase(dscParams["UserSettings"]);

            var combinedInstances = new List<Hashtable>();
            combinedInstances.AddRange(BuildCore(deviceTemplates, deviceDscParams));
            combinedInstances.AddRange(BuildCore(userTemplates, userDscParams));

            return combinedInstances.ToArray();
        }

        /// <summary>
        /// Recursive method that builds a setting instance value subtree.
        /// Mirrors <c>Get-IntuneSettingCatalogPolicySettingInstanceValue</c> exactly.
        ///
        /// Handles 5 setting types:
        /// 1. GroupSettingCollectionInstance / SettingGroupCollectionDefinition
        /// 2. ChoiceSettingInstance / ChoiceSettingDefinition
        /// 3. ChoiceSettingCollectionInstance / ChoiceSettingCollectionDefinition
        /// 4. SimpleSettingCollectionInstance / SimpleSettingCollectionDefinition
        /// 5. Default (Simple settings: Integer/String)
        /// </summary>
        private static Hashtable BuildSettingInstanceValue(
            Hashtable dscParams,
            SettingDefinitionInfo settingDefinition,
            SettingInstanceTemplateInfo instanceTemplate,
            List<SettingDefinitionInfo> allDefinitions,
            List<SettingDefinitionInfo> currentDefinitions,
            string settingType,
            string settingValueName,
            string settingValueType,
            string settingValueTemplateId,
            string settingInstanceName,
            int level)
        {
            // GroupSettingCollection
            if (IsGroupSettingCollection(settingType))
            {
                return BuildGroupSettingCollectionValue(
                    dscParams, settingDefinition, instanceTemplate,
                    allDefinitions, currentDefinitions,
                    settingInstanceName, level);
            }

            // ChoiceSetting (not Collection)
            if (IsChoiceSetting(settingType))
            {
                return BuildChoiceSettingValue(
                    dscParams, settingDefinition, instanceTemplate,
                    allDefinitions, currentDefinitions,
                    settingValueType, settingValueTemplateId,
                    settingInstanceName);
            }

            // ChoiceSettingCollection
            if (IsChoiceSettingCollection(settingType))
            {
                return BuildChoiceSettingCollectionValue(
                    dscParams, settingDefinition, allDefinitions,
                    settingValueType);
            }

            // SimpleSettingCollection
            if (IsSimpleSettingCollection(settingType))
            {
                return BuildSimpleSettingCollectionValue(
                    dscParams, settingDefinition, allDefinitions,
                    settingValueType, settingValueName);
            }

            // Default: Simple settings (Integer/String)
            return BuildSimpleSettingValue(
                dscParams, settingDefinition, allDefinitions,
                settingValueType, settingValueName, settingValueTemplateId);
        }

        #region GroupSettingCollection
        // GroupSettingCollections are a collection of settings without a value of their own
        private static Hashtable BuildGroupSettingCollectionValue(
            Hashtable dscParams,
            SettingDefinitionInfo settingDefinition,
            SettingInstanceTemplateInfo instanceTemplate,
            List<SettingDefinitionInfo> allDefinitions,
            List<SettingDefinitionInfo> currentDefinitions,
            string settingInstanceName,
            int level)
        {
            var result = new Hashtable(StringComparer.OrdinalIgnoreCase);
            var groupSettingCollectionValue = new List<object>();

            // Find child definitions that depend on this setting
            var childDefinitions = FindChildDefinitions(currentDefinitions, settingDefinition.Id);

            int instanceCount = 1;
            string cimParamName = null;
            Hashtable effectiveDscParams = dscParams;
            List<SettingDefinitionInfo> effectiveAllDefinitions = allDefinitions;

            // Multi-instance detection
            bool isMultiInstance =
                (level > 1 && childDefinitions.Count > 1) ||
                (level == 1 && settingDefinition.MaximumCount > 1 && childDefinitions.Count >= 1 &&
                 !childDefinitions.Any(c => string.Equals(c.ODataType, SettingGroupCollectionDefinitionType, StringComparison.OrdinalIgnoreCase)));

            if (isMultiInstance)
            {
                string settingName = SettingsCatalogHelper.GetSettingName(settingDefinition, allDefinitions);
                string fullClassName = settingInstanceName + settingName;

                var (paramName, cimInstances) = FindCimInstancesByClassName(dscParams, fullClassName);
                cimParamName = paramName;

                if (cimInstances.Count > 0)
                {
                    var newParams = new Hashtable(StringComparer.OrdinalIgnoreCase);
                    var instanceList = new List<Hashtable>();
                    foreach (var cimInstance in cimInstances)
                    {
                        instanceList.Add(ExtractCimPropertiesModifiedOnly(cimInstance));
                    }
                    instanceCount = instanceList.Count;
                    newParams[cimParamName] = instanceCount == 1 ? (object)instanceList[0] : instanceList.ToArray();
                    effectiveDscParams = newParams;
                }

                effectiveAllDefinitions = new(childDefinitions) { settingDefinition };
            }

            // Iterate over instances
            for (int i = 0; i < instanceCount; i++)
            {
                List<Hashtable> groupChildren = [];
                Hashtable currentDscParams = ResolveCurrentDscParams(effectiveDscParams, cimParamName, instanceCount, i);

                foreach (var childDef in childDefinitions)
                {
                    // Derive child setting type, value name, value type
                    string childSettingType = childDef.ODataType?
                        .Replace("Definition", "Instance")
                        .Replace("SettingGroup", "GroupSetting") ?? string.Empty;
                    string childSettingValueName = childSettingType
                        .Replace(ODataTypePrefix, "")
                        .Replace("Instance", "Value");
                    string childSettingValueType = ODataTypePrefix + childSettingValueName;
                    if (childSettingValueName.Length > 0)
                    {
                        childSettingValueName = char.ToLowerInvariant(childSettingValueName[0]) + childSettingValueName.Substring(1);
                    }

                    // Find matching child template from parent's children
                    var childTemplate = instanceTemplate?.Children
                        ?.FirstOrDefault(c => string.Equals(c.SettingDefinitionId, childDef.Id, StringComparison.OrdinalIgnoreCase));

                    string childValueTemplateId = null;
                    if (childTemplate is not null)
                    {
                        // Extract the value template ID from the child template
                        childValueTemplateId = childTemplate.ValueTemplateId;
                    }

                    var childValue = BuildSettingInstanceValue(
                        currentDscParams,
                        childDef,
                        childTemplate,
                        effectiveAllDefinitions,
                        currentDefinitions,
                        childDef.ODataType ?? string.Empty,
                        childSettingValueName,
                        childSettingValueType,
                        childValueTemplateId,
                        settingInstanceName + (isMultiInstance ? SettingsCatalogHelper.GetSettingName(settingDefinition, allDefinitions) : string.Empty),
                        level + 1);

                    if (childValue is null || childValue.Count == 0)
                        continue;

                    // Special wrapping case: single child definition with maxCount=1 but multiple group values
                    // If only one child item is allowed but we have multiple values, we need to create an object for each child
                    // Happens e.g. for the IntuneDeviceControlPolicyWindows10 resource --> {ruleid} and {ruleid}_ruledata definitions
                    if (childValue.ContainsKey("groupSettingCollectionValue"))
                    {
                        var innerGroupValues = childValue["groupSettingCollectionValue"] as object[];
                        if (innerGroupValues is not null && innerGroupValues.Length > 1 &&
                            childDef.MaximumCount == 1 && childDefinitions.Count == 1)
                        {
                            // Wrap each inner group value in its own parent group
                            foreach (var innerGroupValue in innerGroupValues)
                            {
                                var innerGroupHt = innerGroupValue as Hashtable;
                                if (innerGroupHt is null) continue;

                                var wrappedChild = new Hashtable(StringComparer.OrdinalIgnoreCase)
                                {
                                    ["children"] = new object[]
                                    {
                                        new Hashtable(StringComparer.OrdinalIgnoreCase)
                                        {
                                            ["@odata.type"] = GroupSettingCollectionInstanceType,
                                            ["groupSettingCollectionValue"] = new object[]
                                            {
                                                new Hashtable(StringComparer.OrdinalIgnoreCase)
                                                {
                                                    ["children"] = innerGroupHt["children"]
                                                }
                                            },
                                            ["settingDefinitionId"] = childDef.Id
                                        }
                                    }
                                };
                                groupSettingCollectionValue.Add(wrappedChild);
                            }
                            continue;
                        }
                    }

                    // Normal case: add settingDefinitionId and @odata.type
                    if (!childValue.ContainsKey("settingDefinitionId"))
                    {
                        childValue["settingDefinitionId"] = childDef.Id;
                    }
                    childValue["@odata.type"] = childSettingType;
                    groupChildren.Add(childValue);
                }

                // Only add if there are children (does not happen for wrapped children)
                if (groupChildren.Count > 0)
                {
                    groupSettingCollectionValue.Add(new Hashtable(StringComparer.OrdinalIgnoreCase)
                    {
                        ["children"] = groupChildren.Cast<object>().ToArray()
                    });
                }
            }

            if (childDefinitions.Count > 0 && groupSettingCollectionValue.Count > 0)
            {
                result["groupSettingCollectionValue"] = groupSettingCollectionValue.ToArray();
            }

            return result;
        }

        #endregion

        #region ChoiceSetting
        // ChoiceSetting is a choice (e.g. dropdown) setting that, depending on the choice, can have children settings
        private static Hashtable BuildChoiceSettingValue(
            Hashtable dscParams,
            SettingDefinitionInfo settingDefinition,
            SettingInstanceTemplateInfo instanceTemplate,
            List<SettingDefinitionInfo> allDefinitions,
            List<SettingDefinitionInfo> currentDefinitions,
            string settingValueType,
            string settingValueTemplateId,
            string settingInstanceName)
        {
            var result = new Hashtable(StringComparer.OrdinalIgnoreCase);
            var choiceSettingValue = new Hashtable(StringComparer.OrdinalIgnoreCase);
            var choiceChildren = new List<Hashtable>();

            // Find child definitions
            var childDefinitions = FindChildDefinitions(currentDefinitions, settingDefinition.Id);

            foreach (var childDef in childDefinitions)
            {
                string childSettingType = childDef.ODataType?.Replace("Definition", "Instance") ?? string.Empty;
                string childSettingValueName = childSettingType
                    .Replace(ODataTypePrefix, "")
                    .Replace("Instance", "Value");
                string childSettingValueType = ODataTypePrefix + childSettingValueName;
                if (childSettingValueName.Length > 0)
                {
                    childSettingValueName = char.ToLowerInvariant(childSettingValueName[0]) + childSettingValueName.Substring(1);
                }

                // Find child template from parent's choiceSettingValueTemplate.children
                var childTemplate = instanceTemplate?.Children
                    ?.FirstOrDefault(c => string.Equals(c.SettingDefinitionId, childDef.Id, StringComparison.OrdinalIgnoreCase));

                // Extract value template ID - may need to match by settingDefinitionId
                string childValueTemplateId = null;
                if (childTemplate is not null)
                {
                    childValueTemplateId = childTemplate.ValueTemplateId;
                }

                var childValue = BuildSettingInstanceValue(
                    dscParams, childDef, childTemplate,
                    allDefinitions, currentDefinitions,
                    childDef.ODataType ?? string.Empty,
                    childSettingValueName, childSettingValueType,
                    childValueTemplateId, settingInstanceName,
                    level: 1);

                if (childValue is null || childValue.Count == 0)
                    continue;

                if (!childValue.ContainsKey("settingDefinitionId"))
                {
                    childValue["settingDefinitionId"] = childDef.Id;
                }

                if (childTemplate is not null && !string.IsNullOrEmpty(childTemplate.SettingInstanceTemplateId))
                {
                    childValue["settingInstanceTemplateReference"] = new Hashtable(StringComparer.OrdinalIgnoreCase)
                    {
                        ["settingInstanceTemplateId"] = childTemplate.SettingInstanceTemplateId
                    };
                }

                // Fix: SettingGroupCollectionInstance -> GroupSettingCollectionInstance
                if (childSettingType == "#microsoft.graph.deviceManagementConfigurationSettingGroupCollectionInstance")
                {
                    childSettingType = GroupSettingCollectionInstanceType;
                }

                childValue["@odata.type"] = childSettingType;
                choiceChildren.Add(childValue);
            }

            // Children array is required - either populated children or empty array
            choiceSettingValue["children"] = childDefinitions.Count > 0
                ? choiceChildren.Cast<object>().ToArray()
                : [];

            // Resolve the choice value from DSC params
            var valueResult = SettingValueResolver.Resolve(
                settingValueType, settingDefinition, allDefinitions, dscParams);

            if (valueResult?.Value is not null)
            {
                choiceSettingValue["value"] = valueResult.Value;
                // Derive the value @odata.type
                string odataType = (settingDefinition.ODataType ?? string.Empty)
                    .Replace("Definition", "Value")
                    .Replace("Instance", "Value");
                // If settingType passed was already an Instance type, handle that too
                if (string.IsNullOrEmpty(odataType) || !odataType.Contains("Value"))
                {
                    odataType = ChoiceSettingValueType;
                }
                choiceSettingValue["@odata.type"] = odataType;

                if (!string.IsNullOrEmpty(settingValueTemplateId))
                {
                    choiceSettingValue["settingValueTemplateReference"] = new Hashtable(StringComparer.OrdinalIgnoreCase)
                    {
                        ["settingValueTemplateId"] = settingValueTemplateId
                    };
                }
            }

            // Add to result only if there are children or a value
            if ((choiceChildren.Count > 0) || choiceSettingValue.ContainsKey("value"))
            {
                result["choiceSettingValue"] = choiceSettingValue;
            }

            return result;
        }

        #endregion

        #region ChoiceSettingCollection
        // ChoiceSettingCollection is a collection of ChoiceSettings
        private static Hashtable BuildChoiceSettingCollectionValue(
            Hashtable dscParams,
            SettingDefinitionInfo settingDefinition,
            List<SettingDefinitionInfo> allDefinitions,
            string settingValueType)
        {
            var result = new Hashtable(StringComparer.OrdinalIgnoreCase);

            var valueResult = SettingValueResolver.Resolve(
                settingValueType, settingDefinition, allDefinitions, dscParams);

            if (valueResult?.Value is null)
                return result;

            var values = valueResult.Value as IEnumerable;
            if (values is null && valueResult.Value is not null)
            {
                values = new[] { valueResult.Value };
            }

            // Add all values to the collection, each with its own children array (empty) and @odata.type
            List<Hashtable> collection = [];
            foreach (var value in values)
            {
                collection.Add(new Hashtable(StringComparer.OrdinalIgnoreCase)
                {
                    ["value"] = value,
                    ["children"] = Array.Empty<object>(),
                    ["@odata.type"] = ChoiceSettingValueType
                });
            }

            if (collection.Count > 0)
            {
                result["choiceSettingCollectionValue"] = collection.Cast<object>().ToArray();
            }

            return result;
        }

        #endregion

        #region SimpleSettingCollection
        // SimpleSettingCollections are collections of simple settings, e.g. strings or integers
        private static Hashtable? BuildSimpleSettingCollectionValue(
            Hashtable dscParams,
            SettingDefinitionInfo settingDefinition,
            List<SettingDefinitionInfo> allDefinitions,
            string settingValueType,
            string settingValueName)
        {
            var result = new Hashtable(StringComparer.OrdinalIgnoreCase);

            var valuesResult = SettingValueResolver.Resolve(
                settingValueType, settingDefinition, allDefinitions, dscParams);

            if (valuesResult is null)
                return null;

            // Derive the collection item type from the value definition
            string itemODataType = settingValueType;
            if (valuesResult.SettingDefinition?.ValueDefinition?.ODataType is not null)
            {
                itemODataType = valuesResult.SettingDefinition.ValueDefinition.ODataType.Replace("Definition", "");
            }

            List<Hashtable> collection = [];
            var values = valuesResult.Value as IEnumerable;
            if (values is null && valuesResult.Value is not null)
            {
                values = new[] { valuesResult.Value };
            }

            if (values is not null)
            {
                foreach (var v in values)
                {
                    collection.Add(new Hashtable(StringComparer.OrdinalIgnoreCase)
                    {
                        ["value"] = v,
                        ["@odata.type"] = itemODataType
                    });
                }
            }

            if (collection.Count > 0)
            {
                result[settingValueName] = collection.Cast<object>().ToArray();
            }

            return result;
        }

        #endregion

        #region Simple setting (default)

        private static Hashtable? BuildSimpleSettingValue(
            Hashtable dscParams,
            SettingDefinitionInfo settingDefinition,
            List<SettingDefinitionInfo> allDefinitions,
            string settingValueType,
            string settingValueName,
            string settingValueTemplateId)
        {
            var result = new Hashtable(StringComparer.OrdinalIgnoreCase);

            var valueResult = SettingValueResolver.Resolve(
                settingValueType, settingDefinition, allDefinitions, dscParams);

            if (valueResult is null || valueResult.Value is null)
                return null;

            // Update to resolved types
            string resolvedValueType = valueResult.SettingValueType ?? settingValueType;
            var resolvedDefinition = valueResult.SettingDefinition ?? settingDefinition;

            var settingValue = new Hashtable(StringComparer.OrdinalIgnoreCase);

            if (!string.IsNullOrEmpty(resolvedValueType))
            {
                // Handle secret settings
                if (resolvedDefinition?.ValueDefinition?.IsSecret == true)
                {
                    resolvedValueType = SecretSettingValueType;
                    settingValue["valueState"] = "NotEncrypted";
                }
                settingValue["@odata.type"] = resolvedValueType;
            }

            if (!string.IsNullOrEmpty(settingValueTemplateId))
            {
                settingValue["settingValueTemplateReference"] = new Hashtable(StringComparer.OrdinalIgnoreCase)
                {
                    ["settingValueTemplateId"] = settingValueTemplateId
                };
            }

            settingValue["value"] = valueResult.Value;

            result[settingValueName] = settingValue;
            result["settingDefinitionId"] = resolvedDefinition?.Id ?? settingDefinition.Id;

            return result;
        }

        #endregion

        #region Helper methods

        /// <summary>
        /// Finds child setting definitions that depend on the given parent setting ID.
        /// Checks both <c>dependentOn.parentSettingId</c> and <c>options.dependentOn.parentSettingId</c>.
        /// </summary>
        private static List<SettingDefinitionInfo> FindChildDefinitions(
            List<SettingDefinitionInfo> definitions,
            string parentSettingId)
        {
            return definitions
                .Where(d =>
                    (d.DependentOnParentSettingIds.Count > 0 && d.DependentOnParentSettingIds.Contains(parentSettingId)) ||
                    (d.OptionsDependentOnParentSettingIds.Count > 0 && d.OptionsDependentOnParentSettingIds.Contains(parentSettingId)))
                .ToList();
        }

        /// <summary>
        /// Resolves the current DSC params for the current iteration of a multi-instance group.
        /// </summary>
        private static Hashtable ResolveCurrentDscParams(Hashtable dscParams, string cimParamName, int instanceCount, int index)
        {
            if (instanceCount == 1)
            {
                if (!string.IsNullOrEmpty(cimParamName) && dscParams.ContainsKey(cimParamName))
                {
                    var single = dscParams[cimParamName];
                    return single is Hashtable ht ? ht : dscParams;
                }
                return dscParams;
            }

            if (!string.IsNullOrEmpty(cimParamName) && dscParams.ContainsKey(cimParamName))
            {
                var arr = dscParams[cimParamName] as object[];
                if (arr is not null && index < arr.Length)
                {
                    return arr[index] as Hashtable ?? new Hashtable(StringComparer.OrdinalIgnoreCase);
                }
            }

            return new Hashtable(StringComparer.OrdinalIgnoreCase);
        }

        private static bool IsGroupSettingCollection(string settingType)
        {
            return string.Equals(settingType, GroupSettingCollectionInstanceType, StringComparison.OrdinalIgnoreCase) ||
                   string.Equals(settingType, SettingGroupCollectionDefinitionType, StringComparison.OrdinalIgnoreCase);
        }

        private static bool IsChoiceSetting(string settingType)
        {
            return string.Equals(settingType, ChoiceSettingInstanceType, StringComparison.OrdinalIgnoreCase) ||
                   string.Equals(settingType, ChoiceSettingDefinitionType, StringComparison.OrdinalIgnoreCase);
        }

        private static bool IsChoiceSettingCollection(string settingType)
        {
            return string.Equals(settingType, ChoiceSettingCollectionInstanceType, StringComparison.OrdinalIgnoreCase) ||
                   string.Equals(settingType, ChoiceSettingCollectionDefinitionType, StringComparison.OrdinalIgnoreCase);
        }

        private static bool IsSimpleSettingCollection(string settingType)
        {
            return string.Equals(settingType, SimpleSettingCollectionInstanceType, StringComparison.OrdinalIgnoreCase) ||
                   string.Equals(settingType, SimpleSettingCollectionDefinitionType, StringComparison.OrdinalIgnoreCase);
        }

        #endregion

        #region CIM Instance helpers

        /// <summary>
        /// Scans DSCParams values for CimInstance objects matching the expected CIM class name.
        /// Matches exact class name or alternate <c>{name}_Intune*</c> pattern.
        /// </summary>
        internal static (string ParamName, List<CimInstance> Instances) FindCimInstancesByClassName(
            Hashtable dscParams,
            string expectedClassName)
        {
            string alternateName = expectedClassName + "_Intune";
            List<CimInstance> instances = [];
            string paramName = string.Empty;

            foreach (DictionaryEntry entry in dscParams)
            {
                object value = entry.Value;

                // Unwrap PSObject
                if (value is PSObject pso)
                    value = pso.BaseObject;

                if (value is CimInstance cimInstance)
                {
                    string className = cimInstance.CimClass?.CimSystemProperties?.ClassName
                        ?? cimInstance.CimSystemProperties?.ClassName
                        ?? string.Empty;

                    if (string.Equals(className, expectedClassName, StringComparison.OrdinalIgnoreCase) ||
                        className.StartsWith(alternateName, StringComparison.OrdinalIgnoreCase))
                    {
                        instances.Add(cimInstance);
                        paramName = entry.Key?.ToString() ?? string.Empty;
                    }
                }
                else if (value is CimInstance[] cimArray)
                {
                    foreach (var ci in cimArray)
                    {
                        string className = ci.CimClass?.CimSystemProperties?.ClassName
                            ?? ci.CimSystemProperties?.ClassName
                            ?? string.Empty;

                        if (string.Equals(className, expectedClassName, StringComparison.OrdinalIgnoreCase) ||
                            className.StartsWith(alternateName, StringComparison.OrdinalIgnoreCase))
                        {
                            instances.Add(ci);
                            paramName = entry.Key?.ToString() ?? string.Empty;
                        }
                    }
                }
                else if (value is object[] objArray)
                {
                    foreach (var item in objArray)
                    {
                        object unwrapped = item is PSObject psoItem ? psoItem.BaseObject : item;
                        if (unwrapped is CimInstance ci)
                        {
                            string className = ci.CimClass?.CimSystemProperties?.ClassName
                                ?? ci.CimSystemProperties?.ClassName
                                ?? string.Empty;

                            if (string.Equals(className, expectedClassName, StringComparison.OrdinalIgnoreCase) ||
                                className.StartsWith(alternateName, StringComparison.OrdinalIgnoreCase))
                            {
                                instances.Add(ci);
                                paramName = entry.Key?.ToString() ?? string.Empty;
                            }
                        }
                    }
                }
            }

            return (paramName, instances);
        }

        /// <summary>
        /// Extracts properties from a CimInstance, keeping only modified values.
        /// Property names are PascalCase. Nested CimInstances are preserved as-is for recursive processing.
        /// Mirrors the PS logic: <c>foreach ($property in $instance.CimInstanceProperties) { if ($property.IsValueModified) ... }</c>
        /// </summary>
        internal static Hashtable ExtractCimPropertiesModifiedOnly(CimInstance cimInstance)
        {
            var result = new Hashtable(StringComparer.OrdinalIgnoreCase);
            if (cimInstance is null)
                return result;

            foreach (var property in cimInstance.CimInstanceProperties)
            {
                if (property.IsValueModified)
                {
                    result[property.Name] = property.Value;
                }
            }

            return result;
        }

        /// <summary>
        /// Extracts properties from a CimInstance (or PSObject wrapping one) with camelCase property names.
        /// Filters only modified values and excludes PSComputerName.
        /// Mirrors <c>Convert-M365DSCDRGComplexTypeToHashtable -SingleLevel -ExcludeUnchangedProperties</c>.
        /// </summary>
        internal static Hashtable ExtractCimPropertiesCamelCase(object value)
        {
            var result = new Hashtable(StringComparer.OrdinalIgnoreCase);
            if (value is null)
                return result;

            // Unwrap PSObject
            if (value is PSObject pso)
                value = pso.BaseObject;

            if (value is CimInstance cimInstance)
            {
                foreach (var property in cimInstance.CimInstanceProperties)
                {
                    if (string.Equals(property.Name, "PSComputerName", StringComparison.OrdinalIgnoreCase))
                        continue;
                    if (!property.IsValueModified)
                        continue;

                    string camelName = property.Name.Length > 0
                        ? char.ToLowerInvariant(property.Name[0]) + property.Name.Substring(1)
                        : property.Name;
                    result[camelName] = property.Value;
                }
            }
            else if (value is Hashtable ht)
            {
                // Already a hashtable - return as-is
                return ht;
            }

            return result;
        }

        #endregion
    }
}
