<#
This example creates a new PowerApps environment in production.
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
        PPPowerAppsEnvironment 'PowerAppsDemoEnvironment'
        {
            DisplayName        = "My Demo Environment"
            EnvironmentSKU     = "Production"
            Location           = "canada"
            Ensure             = "Present"
            Credential         = $credsGlobalAdmin
        }
    }
}
