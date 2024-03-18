<#
This example creates a new App Configuration Policy.
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
        IntuneAppConfigurationPolicy 'AddAppConfigPolicy'
        {
            DisplayName          = 'ContosoNew'
            Description          = 'New Contoso Policy'
            Credential           = $Credscredential;
            CustomSettings       = @(
                MSFT_IntuneAppConfigurationPolicyCustomSetting {
                    name  = 'com.microsoft.intune.mam.managedbrowser.BlockListURLs'
                    value = 'https://www.aol.com'
                }
                MSFT_IntuneAppConfigurationPolicyCustomSetting {
                    name  = 'com.microsoft.intune.mam.managedbrowser.bookmarks'
                    value = 'Outlook Web|https://outlook.office.com||Bing|https://www.bing.com'
                }
                MSFT_IntuneAppConfigurationPolicyCustomSetting {
                    name  = 'Test'
                    value = 'TestValue'
                });
            Ensure      = 'Present'
        }
    }
}
