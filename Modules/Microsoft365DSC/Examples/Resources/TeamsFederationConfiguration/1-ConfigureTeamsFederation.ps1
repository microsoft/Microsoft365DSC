<#
This examples sets the Teams Federation Configuration.
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
        TeamsFederationConfiguration 'FederationConfiguration'
        {
            Identity                  = "Global"
            AllowFederatedUsers       = $True
            AllowPublicUsers          = $True
            AllowTeamsConsumer        = $False
            AllowTeamsConsumerInbound = $False
            Credential                = $credsGlobalAdmin
        }
    }
}
