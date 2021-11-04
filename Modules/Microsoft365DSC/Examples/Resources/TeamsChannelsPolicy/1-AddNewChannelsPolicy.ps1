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
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        TeamsChannelsPolicy 'ConfigureChannelsPolicy'
        {
            Identity                    = 'New Channels Policy'
            AllowOrgWideTeamCreation    = $True
            AllowPrivateChannelCreation = $True
            AllowPrivateTeamDiscovery   = $True
            Description                 = 'This is an example'
            Ensure                      = 'Present'
            Credential                  = $credsGlobalAdmin
        }
    }
}
