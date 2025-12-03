<#
This example creates a new App Configuration Policy.
#>

Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneAppConfigurationPolicy 'AddAppConfigPolicy'
        {
            DisplayName          = 'ContosoNew'
            Description          = 'New Contoso Policy'
            CustomSettings       = @(
                MSFT_IntuneAppConfigurationPolicyCustomSetting {
                    name  = 'com.microsoft.intune.mam.managedbrowser.BlockListURLs'
                    value = 'https://www.aol.com'
                }
                MSFT_IntuneAppConfigurationPolicyCustomSetting {
                    name  = 'com.microsoft.intune.mam.managedbrowser.bookmarks'
                    value = 'Outlook Web|https://outlook.office.com||Bing|https://www.bing.com'
                }
                MSFT_IntuneAppConfigurationPolicyCustomSetting { # Updated Property
                    name  = 'Test2'
                    value = 'TestValue2'
                });
            Ensure      = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
