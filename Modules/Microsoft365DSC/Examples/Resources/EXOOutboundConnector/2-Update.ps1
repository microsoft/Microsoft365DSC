<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
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
        EXOOutboundConnector 'ConfigureOutboundConnector'
        {
            Identity                      = "Contoso Outbound Connector"
            AllAcceptedDomains            = $True
            CloudServicesMailEnabled      = $True
            Comment                       = "Outbound connector to Contoso"
            ConnectorSource               = "Default"
            ConnectorType                 = "OnPremises"
            Enabled                       = $False  # Updated Property
            IsTransportRuleScoped         = $True
            RecipientDomains              = "*.contoso.com"
            RouteAllMessagesViaOnPremises = $True
            TlsDomain                     = "*.contoso.com"
            TlsSettings                   = "DomainValidation"
            UseMxRecord                   = $True
            Ensure                        = "Present"
            Credential                    = $Credscredential
        }
    }
}
