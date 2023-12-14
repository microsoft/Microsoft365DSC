<#
This example adds a new Teams Channels Policy.
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
        TeamsChannelsPolicy 'ConfigureChannelsPolicy'
        {
            Identity                                      = 'New Channels Policy'
            Description                                   = 'This is an example'
            AllowChannelSharingToExternalUser             = $True
            AllowOrgWideTeamCreation                      = $True
            EnablePrivateTeamDiscovery                    = $True
            AllowPrivateChannelCreation                   = $True
            AllowSharedChannelCreation                    = $True
            AllowUserToParticipateInExternalSharedChannel = $True
            Ensure                                        = 'Present'
            Credential                                    = $Credscredential
        }
    }
}
