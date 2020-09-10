<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

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
        SCSensitivityLabel DemoRule
        {
            Name           = "DemoLabel"
            Comment        = "Demo Label comment"
            ToolTip        = "Demo tool tip"
            DisplayName    = "Demo Label"

            LocaleSettings = @(
                MSFT_SCLabelLocaleSettings
                {
                    LocaleKey = "DisplayName"
                    Settings = @(
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
                    Settings = @(
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
            AdvancedSettings = @(
                MSFT_SCLabelSetting
                {
                    Key = "AllowedLevel"
                    Value = @("Sensitive", "Classified")
                }
                MSFT_SCLabelSetting
                {
                    Key = "LabelStatus"
                    Value = "Enabled"
                }
            )
            ParentId           = "Personal"
            GlobalAdminAccount = $credsGlobalAdmin
            Ensure             = "Present"
        }
    }
}
