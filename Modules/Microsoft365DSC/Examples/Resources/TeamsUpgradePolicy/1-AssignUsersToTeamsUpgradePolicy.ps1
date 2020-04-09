<#
This example demonstrates how to assign users to a Teams Upgrade Policy.
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
        TeamsUpgradePolicy IslandsPolicy
        {
            Identity               = 'Islands'
            Users                  = @("John.Smith@contoso.com", "Nik.Charlebois@contoso.com")
            MigrateMeetingsToTeams = $true
            GlobalAdminAccount     = $credsGlobalAdmin
        }
    }
}
