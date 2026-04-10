<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SCSensitivityLabel 'ConfigureSensitivityLabel'
        {
            Name                                           = 'DemoLabel'
            Comment                                        = 'Demo Label comment'
            ToolTip                                        = 'Demo tool tip'
            DisplayName                                    = 'Demo Label'
            ApplyContentMarkingFooterAlignment             = 'Center'
            ApplyContentMarkingFooterEnabled               = $true
            ApplyContentMarkingFooterFontColor             = '#FF0000'
            ApplyContentMarkingFooterFontSize              = 10
            ApplyContentMarkingFooterMargin                = 5
            ApplyContentMarkingFooterText                  = 'Demo footer text'
            ApplyContentMarkingHeaderAlignment             = 'Center'
            ApplyContentMarkingHeaderEnabled               = $true
            ApplyContentMarkingHeaderFontColor             = '#FF0000'
            ApplyContentMarkingHeaderFontSize              = 10
            ApplyContentMarkingHeaderMargin                = 5
            ApplyContentMarkingHeaderText                  = 'demo header text'
            ApplyWaterMarkingEnabled                       = $true
            ApplyWaterMarkingFontColor                     = '#FF0000'
            ApplyWaterMarkingFontSize                      = 10
            ApplyWaterMarkingLayout                        = 'Diagonal'
            ApplyWaterMarkingText                          = 'demo watermark'
            SiteAndGroupProtectionAllowAccessToGuestUsers  = $true
            SiteAndGroupProtectionAllowEmailFromGuestUsers = $true
            SiteAndGroupProtectionAllowFullAccess          = $true
            SiteAndGroupProtectionAllowLimitedAccess       = $true
            SiteAndGroupProtectionBlockAccess              = $true
            SiteAndGroupProtectionEnabled                  = $true
            SiteAndGroupProtectionPrivacy                  = 'Private'
            LocaleSettings                                 = @(
                MSFT_SCLabelLocaleSettings
                {
                    LocaleKey     = 'DisplayName'
                    LabelSettings = @(
                        MSFT_SCLabelSetting
                        {
                            Key   = 'en-us'
                            Value = 'English Display Names'
                        }
                        MSFT_SCLabelSetting
                        {
                            Key   = 'fr-fr'
                            Value = "Nom da'ffichage francais"
                        }
                    )
                }
                MSFT_SCLabelLocaleSettings
                {
                    LocaleKey     = 'StopColor'
                    LabelSettings = @(
                        MSFT_SCLabelSetting
                        {
                            Key   = 'en-us'
                            Value = 'RedGreen'
                        }
                        MSFT_SCLabelSetting
                        {
                            Key   = 'fr-fr'
                            Value = 'Rouge'
                        }
                    )
                }
            )
            AdvancedSettings                               = @(
                MSFT_SCLabelSetting
                {
                    Key   = 'AllowedLevel'
                    Value = @('Sensitive', 'Classified')
                }
                MSFT_SCLabelSetting
                {
                    Key   = 'LabelStatus'
                    Value = 'Enabled'
                }
            )
            ParentId                                       = 'Personal'
            Ensure                                         = 'Present'
            Credential                                     = $Credscredential
        }
    }
}
