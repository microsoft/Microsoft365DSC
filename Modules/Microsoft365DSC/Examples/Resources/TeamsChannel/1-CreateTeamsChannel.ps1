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
        TeamsChannel MyChannel
        {
            TeamName           = "SuperSecretTeam"
            DisplayName        = "SP2013 Review teams group"
            NewDisplayName     = "SP2016 Review teams group"
            Description        = "SP2016 Code reviews for SPFX"
            Ensure             = "Present"
            GlobalAdminAccount = $credsGlobalAdmin
        }
    }
}
