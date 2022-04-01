<#
This example sets Power Platform tenant isolation settings.
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
        PPTenantIsolationSettings 'PowerPlatformTenantSettings'
        {
            IsSingleInstance = 'Yes'
            Enable           = $true
            Rules            = @(
                MSFT_TenantRule
                {
                    TenantName = 'contoso.onmicrosoft.com'
                    Direction  = 'Outbound'
                }
                MSFT_TenantRule
                {
                    TenantName = 'fabrikam.onmicrosoft.com'
                    Direction  = 'Both'
                }
            )
            Credential       = $credsGlobalAdmin
        }
    }
}
