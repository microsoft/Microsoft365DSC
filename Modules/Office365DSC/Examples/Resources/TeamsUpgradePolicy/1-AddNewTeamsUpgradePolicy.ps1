<#
This example demonstrates how to create a new Teams Upgrade Policy.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Office365DSC

    node localhost
    {
        TeamsUpgradePolicy NewPolicy
        {
            Identity           = 'My Demo Policy'
            Description        = 'This is my Demo Policy'
            NotifySfbUsers     = $true
            Ensure             = 'Present'
            GlobalAdminAccount = $credsGlobalAdmin
        }
    }
}
