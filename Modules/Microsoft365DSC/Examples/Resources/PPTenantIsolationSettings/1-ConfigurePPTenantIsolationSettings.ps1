<#
This example sets Power Platform tenant isolation settings.
#>

Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        PPTenantIsolationSettings 'PowerPlatformTenantSettings'
        {
            IsSingleInstance = 'Yes'
            Enabled          = $true
            Rules            = @(
                MSFT_PPTenantRule
                {
                    TenantName = 'contoso.onmicrosoft.com'
                    Direction  = 'Outbound'
                }
                MSFT_PPTenantRule
                {
                    TenantName = 'fabrikam.onmicrosoft.com'
                    Direction  = 'Both'
                }
            )
            Credential       = $Credscredential
        }
    }
}
