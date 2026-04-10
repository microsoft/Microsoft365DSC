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
            IsSingleInstance                            = 'Yes';
            AllowedDomains                              = @();
            BlockedDomains                              = @();
            AllowFederatedUsers                         = $True;
            AllowTeamsConsumer                          = $True;
            AllowTeamsConsumerInbound                   = $True;
            RestrictTeamsConsumerToExternalUserProfiles = $False;
            SharedSipAddressSpace                       = $False;
            TreatDiscoveredPartnersAsUnverified         = $False;
            Credential                                  = $Credscredential
        }
    }
}
