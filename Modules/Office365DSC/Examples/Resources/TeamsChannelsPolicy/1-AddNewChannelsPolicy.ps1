<#
This example adds a new Teams Channels Policy.
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
        TeamsChannelsPolicy ChannelsPolicy
        {
            Identity                   = 'New Channels Policy'
            AllowOrgWideTeamCreation    = $True;
            AllowPrivateChannelCreation = $True;
            AllowPrivateTeamDiscovery   = $True;
            Description                 = 'This is an example';
            Ensure                     = 'Present'
            GlobalAdminAccount         = $credsGlobalAdmin
        }
    }
}
