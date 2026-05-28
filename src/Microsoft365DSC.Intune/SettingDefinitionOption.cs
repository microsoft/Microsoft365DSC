using System.Collections.Generic;

namespace Microsoft365DSC.Intune
{
    /// <summary>
    /// Represents a single option in a ChoiceSetting definition.
    /// Maps from options[] on Graph SettingDefinition objects.
    /// </summary>
    public class SettingDefinitionOption
    {
        /// <summary>
        /// The unique identifier for this option (e.g., "device_vendor_msft_policy_config_..._enabled").
        /// </summary>
        public string ItemId { get; set; }

        /// <summary>
        /// The option value object containing the actual value and its OData type.
        /// </summary>
        public OptionValue OptionValue { get; set; }

        /// <summary>
        /// DependentOn entries specific to this option.
        /// Maps from options[].dependentOn[].parentSettingId.
        /// </summary>
        public List<string> DependentOnParentSettingIds { get; set; } = new List<string>();
    }

    /// <summary>
    /// Represents the value portion of a setting definition option.
    /// Maps from options[].optionValue.
    /// </summary>
    public class OptionValue
    {
        /// <summary>
        /// The OData type of the option value (e.g., "#microsoft.graph.deviceManagementConfigurationStringSettingValue").
        /// </summary>
        public string ODataType { get; set; }

        /// <summary>
        /// The actual value of the option (e.g., "0", "1", "enabled").
        /// </summary>
        public string Value { get; set; }
    }

    /// <summary>
    /// Represents the valueDefinition portion of a setting definition.
    /// Maps from valueDefinition on Graph SettingDefinition objects.
    /// </summary>
    public class SettingValueDefinition
    {
        /// <summary>
        /// The OData type of the value definition (e.g., "#microsoft.graph.deviceManagementConfigurationStringSettingValueDefinition").
        /// </summary>
        public string ODataType { get; set; }

        /// <summary>
        /// Whether this value definition represents a secret value.
        /// </summary>
        public bool IsSecret { get; set; }
    }
}
