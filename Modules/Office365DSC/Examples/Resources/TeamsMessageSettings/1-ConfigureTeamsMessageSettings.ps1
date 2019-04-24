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
    Import-DscResource -ModuleName Office365DSC

    node localhost
    {
        TeamsMessageSettings MyTeamMessageSettings
        {
            TeamName                 = "Sample3"
            AllowUserEditMessages    = $false
            AllowUserDeleteMessages  = $false
            AllowOwnerDeleteMessages = $false
            AllowTeamMentions        = $false
            AllowChannelMentions     = $false
            Ensure                   = "Present"
            GlobalAdminAccount       = $credsGlobalAdmin
        }
    }
}
