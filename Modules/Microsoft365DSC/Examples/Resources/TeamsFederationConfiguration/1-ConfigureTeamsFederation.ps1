<#
This examples sets the Teams Federation Configuration.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        TeamsFederationConfiguration 'FederationConfiguration'
        {
            Identity                                    = "Global";
            AllowedDomains                              = @();
            BlockedDomains                              = @();
            AllowFederatedUsers                         = $True;
            AllowPublicUsers                            = $True;
            AllowTeamsConsumer                          = $True;
            AllowTeamsConsumerInbound                   = $True;
            RestrictTeamsConsumerToExternalUserProfiles = $False;
            SharedSipAddressSpace                       = $False;
            TreatDiscoveredPartnersAsUnverified         = $False;
            Credential                                  = $Credscredential
        }
    }
}
