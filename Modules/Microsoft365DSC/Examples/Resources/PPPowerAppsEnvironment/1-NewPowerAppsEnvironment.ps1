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
        PPPowerAppsEnvironment DemoEnvironment
        {
            DisplayName        = "My Demo Environment"
            Ensure             = "Present"
            EnvironmentSKU     = "Production"
            GlobalAdminAccount = $credsGlobalAdmin
            Location           = "canada"
        }
    }
}
