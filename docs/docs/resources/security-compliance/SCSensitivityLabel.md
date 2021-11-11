# SCSensitivityLabel

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Key** | Write | String | Advanced settings key. ||
| **Value** | Write | StringArray[] | Advanced settings value. ||
| **localeKey** | Write | String | Name of the Local key. ||
| **Settings** | Write | InstanceArray[] | The locale settings display names. ||
| **Name** | Key | String | The Name parameter specifies the unique name for the sensitivity label. The maximum length is 64 characters. If the value contains spaces, enclose the value in quotation marks. ||
| **Ensure** | Write | String | Specify if this rule should exist or not. |Present, Absent|
| **Comment** | Write | String | The Comment parameter specifies an optional comment. ||
| **AdvancedSettings** | Write | InstanceArray[] | The AdvancedSettings parameter enables client-specific features and capabilities on the sensitivity label. The settings that you configure with this parameter only affect apps that are designed for the setting. ||
| **DisplayName** | Write | String | The DisplayName parameter specifies the display name for the sensitivity label. The display name appears in the Microsoft Office and is used by Outlook users to select the appropriate sensitivity label before they send a message. ||
| **LocaleSettings** | Write | InstanceArray[] | The LocaleSettings parameter specifies one or more localized label name or label Tooltips in different languages. Regions include all region codes supported in Office Client applications. ||
| **ParentId** | Write | String | The ParentId parameter specifies the parent label that you want this label to be under (a sublabel). You can use any value that uniquely identifies the parent sensitivity label for example name. ||
| **Priority** | Write | UInt32 | The Priority parameter specifies a priority value for the sensitivity label that determines the order of label processing. A lower integer value indicates a highter priority. ||
| **Tooltip** | Write | String | The ToolTip parameter specifies the default tooltip and sensitivity label description that's seen by users. It the value contains spaces, enclose the value in quotation marks. ||
| **Disabled** | Write | Boolean | The disabled parameter specifies whether to enable or disable the sensitivity label. ||
| **ApplyContentMarkingFooterAlignment** | Write | String | The ApplyContentMarkingFooterAlignment parameter specifies the footer alignment. |Left, Center, Right|
| **ApplyContentMarkingFooterEnabled** | Write | Boolean | The disabled parameter specifies whether to enable or disable the sensitivity label. ||
| **ApplyContentMarkingFooterFontColor** | Write | String | The ApplyContentMarkingFooterFontColor parameter specifies the color of the footer text. This parameter accepts a hexadecimal color code value in the format #xxxxxx. The default value is #000000. ||
| **ApplyContentMarkingFooterFontName** | Write | String | The ApplyContentMarkingFooterFontName parameter specifies the font of the footer text. If the value contains spaces, enclose the value in quotation marks. ||
| **ApplyContentMarkingFooterFontSize** | Write | SInt32 | The ApplyContentMarkingFooterFontSize parameter specifies the font size (in points) of the footer text. ||
| **ApplyContentMarkingFooterMargin** | Write | SInt32 | The ApplyContentMarkingFooterMargin parameter specifies the size (in points) of the footer margin. ||
| **ApplyContentMarkingFooterText** | Write | String | The ApplyContentMarkingFooterText parameter specifies the footer text. If the value contains spaces, enclose the value in quotation marks. ||
| **ApplyContentMarkingHeaderAlignment** | Write | String | The ApplyContentMarkingFooterAlignment parameter specifies the header alignment. |Left, Center, Right|
| **ApplyContentMarkingHeaderEnabled** | Write | Boolean | The ApplyContentMarkingHeaderEnabled parameter enables or disables the Apply Content Marking Header action for the label. ||
| **ApplyContentMarkingHeaderFontColor** | Write | String | The ApplyContentMarkingFooterFontColor parameter specifies the color of the header text. This parameter accepts a hexadecimal color code value in the format #xxxxxx. The default value is #000000. ||
| **ApplyContentMarkingHeaderFontName** | Write | String | The ApplyContentMarkingFooterFontName parameter specifies the font of the header text. If the value contains spaces, enclose the value in quotation marks. ||
| **ApplyContentMarkingHeaderFontSize** | Write | SInt32 | The ApplyContentMarkingFooterFontSize parameter specifies the font size (in points) of the header text. ||
| **ApplyContentMarkingHeaderMargin** | Write | SInt32 | The ApplyContentMarkingFooterMargin parameter specifies the size (in points) of the header margin. ||
| **ApplyContentMarkingHeaderText** | Write | String | The ApplyContentMarkingFooterText parameter specifies the header text. If the value contains spaces, enclose the value in quotation marks. ||
| **ApplyWaterMarkingEnabled** | Write | Boolean | The ApplyWaterMarkingEnabled parameter enables or disables the Apply Watermarking Header action for the label. ||
| **ApplyWaterMarkingFontColor** | Write | String | The ApplyWaterMarkingFontColor parameter specifies the color of the watermark text. This parameter accepts a hexadecimal color code value in the format #xxxxxx. ||
| **ApplyWaterMarkingFontName** | Write | String | The ApplyWaterMarkingFontName parameter specifies the font of the watermark text. If the value contains spaces, enclose the value in quotation marks. ||
| **ApplyWaterMarkingFontSize** | Write | SInt32 | The ApplyWaterMarkingFontSize parameter specifies the font size (in points) of the watermark text. ||
| **ApplyWaterMarkingLayout** | Write | String | The ApplyContentMarkingFooterAlignment parameter specifies the header alignment. |Horizontal, Diagonal|
| **ApplyWaterMarkingText** | Write | String | The ApplyWaterMarkingText parameter specifies the watermark text. If the value contains spaces, enclose the value in quotation marks. ||
| **EncryptionAipTemplateScopes** | Write | String | The EncryptionAipTemplateScopes parameter specifies that the label is still published and usable in the AIP classic client. ||
| **EncryptionContentExpiredOnDateInDaysOrNever** | Write | String | The EncryptionContentExpiredOnDateInDaysOrNever parameter specifies when the encrypted content expires. Valid values are integer or never. ||
| **EncryptionDoNotForward** | Write | Boolean | The EncryptionDoNotForward parameter specifies whether the Do Not Forward template is applied. ||
| **EncryptionEnabled** | Write | Boolean | The EncryptionEnabled parameter specifies whether encryption in enabled. ||
| **EncryptionOfflineAccessDays** | Write | SInt32 | The EncryptionOfflineAccessDays parameter specifies the number of days that offline access is allowed. ||
| **EncryptionPromptUser** | Write | Boolean | The EncryptionPromptUser parameter specifies whether to set the label with user defined permission in Word, Excel, and PowerPoint. ||
| **EncryptionProtectionType** | Write | String | The EncryptionProtectionType parameter specifies the protection type for encryption. |Template, RemoveProtection, UserDefined|
| **EncryptionRightsDefinitions** | Write | String | The EncryptionRightsDefinitions parameter specifies the rights users have when accessing protected. This parameter uses the syntax Identity1:Rights1,Rights2;Identity2:Rights3,Rights4. For example, john@contoso.com:VIEW,EDIT;microsoft.com:VIEW. ||
| **EncryptionRightsUrl** | Write | String | The EncryptionRightsUrl parameter specifies the URL for hold your own key (HYOK) protection. ||
| **SiteAndGroupProtectionAllowAccessToGuestUsers** | Write | Boolean | The SiteAndGroupProtectionAllowAccessToGuestUsers parameter enables or disables access to guest users. ||
| **SiteAndGroupProtectionAllowEmailFromGuestUsers** | Write | Boolean | The SiteAndGroupProtectionAllowEmailFromGuestUsers parameter enables or disables email from guest users. ||
| **SiteAndGroupProtectionAllowFullAccess** | Write | Boolean | The SiteAndGroupProtectionAllowFullAccess parameter enables or disables full access. ||
| **SiteAndGroupProtectionAllowLimitedAccess** | Write | Boolean | The SiteAndGroupProtectionAllowLimitedAccess parameter enables or disables limited access. ||
| **SiteAndGroupProtectionBlockAccess** | Write | Boolean | The SiteAndGroupProtectionBlockAccess parameter blocks access. ||
| **SiteAndGroupProtectionEnabled** | Write | Boolean | The SiteAndGroupProtectionEnabled parameter enables or disables the Site and Group Protection action for the labels. ||
| **SiteAndGroupProtectionPrivacy** | Write | String | The SiteAndGroupProtectionPrivacy parameter specifies the privacy level for the label. |Public, Private|
| **Credential** | Required | PSCredential | Credentials of the Exchange Global Admin ||

# SCSensitivityLabel

### Description

This resource configures Sensitivity labels in Security and Compliance.

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SCSensitivityLabel 'ConfigureSensitivityLabel'
        {
            Name                                           = "DemoLabel"
            Comment                                        = "Demo Label comment"
            ToolTip                                        = "Demo tool tip"
            DisplayName                                    = "Demo Label"
            ApplyContentMarkingFooterAlignment             = "Center"
            ApplyContentMarkingFooterEnabled               = $true
            ApplyContentMarkingFooterFontColor             = "#FF0000"
            ApplyContentMarkingFooterFontName              = "calibri"
            ApplyContentMarkingFooterFontSize              = 10
            ApplyContentMarkingFooterMargin                = 5
            ApplyContentMarkingFooterText                  = "Demo footer text"
            ApplyContentMarkingHeaderAlignment             = "Center"
            ApplyContentMarkingHeaderEnabled               = $true
            ApplyContentMarkingHeaderFontColor             = "#FF0000"
            ApplyContentMarkingHeaderFontName              = "calibri"
            ApplyContentMarkingHeaderFontSize              = 10
            ApplyContentMarkingHeaderMargin                = 5
            ApplyContentMarkingHeaderText                  = "demo header text"
            ApplyWaterMarkingEnabled                       = $true
            ApplyWaterMarkingFontColor                     = "#FF0000"
            ApplyWaterMarkingFontName                      = "calibri"
            ApplyWaterMarkingFontSize                      = 10
            ApplyWaterMarkingLayout                        = "Diagonal"
            ApplyWaterMarkingText                          = "demo watermark"
            SiteAndGroupProtectionAllowAccessToGuestUsers  = $true
            SiteAndGroupProtectionAllowEmailFromGuestUsers = $true
            SiteAndGroupProtectionAllowFullAccess          = $true
            SiteAndGroupProtectionAllowLimitedAccess       = $true
            SiteAndGroupProtectionBlockAccess              = $true
            SiteAndGroupProtectionEnabled                  = $true
            SiteAndGroupProtectionPrivacy                  = "Private"
            LocaleSettings                                 = @(
                MSFT_SCLabelLocaleSettings
                {
                    LocaleKey = "DisplayName"
                    Settings  = @(
                        MSFT_SCLabelSetting
                        {
                            Key   = "en-us"
                            Value = "English Display Names"
                        }
                        MSFT_SCLabelSetting
                        {
                            Key   = "fr-fr"
                            Value = "Nom da'ffichage francais"
                        }
                    )
                }
                MSFT_SCLabelLocaleSettings
                {
                    LocaleKey = "StopColor"
                    Settings  = @(
                        MSFT_SCLabelSetting
                        {
                            Key   = "en-us"
                            Value = "RedGreen"
                        }
                        MSFT_SCLabelSetting
                        {
                            Key   = "fr-fr"
                            Value = "Rouge"
                        }
                    )
                }
            )
            AdvancedSettings                               = @(
                MSFT_SCLabelSetting
                {
                    Key   = "AllowedLevel"
                    Value = @("Sensitive", "Classified")
                }
                MSFT_SCLabelSetting
                {
                    Key   = "LabelStatus"
                    Value = "Enabled"
                }
            )
            ParentId                                       = "Personal"
            Ensure                                         = "Present"
            Credential                                     = $credsGlobalAdmin
        }
    }
}
```

