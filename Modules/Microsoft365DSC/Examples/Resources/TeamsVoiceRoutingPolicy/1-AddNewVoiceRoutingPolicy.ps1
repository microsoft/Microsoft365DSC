<#
This example adds a new Teams Voice Routing Policy.
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
        TeamsVoiceRoutingPolicy VoiceRoutingPolicy
        {
            Identity           = 'NewVoiceRoutingPolicy'
            OnlinePstnUsages   = @('Long Distance','Local','Internal')
            Description        = 'This is a sample Voice Routing Policy'
            Ensure             = 'Present'
            GlobalAdminAccount = $credsGlobalAdmin
        }
    }
}
