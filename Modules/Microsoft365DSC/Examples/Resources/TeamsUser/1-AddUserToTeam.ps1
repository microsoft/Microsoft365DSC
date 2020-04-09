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
        TeamsUser MyTeam
        {
            TeamName           = "SuperSecretTeam"
            User               = "jdoe@dsazure.com"
            Role               = "Member"
            Ensure             = "Absent"
            GlobalAdminAccount = $credsGlobalAdmin
        }
    }
}
