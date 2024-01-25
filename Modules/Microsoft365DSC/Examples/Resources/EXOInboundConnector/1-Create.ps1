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
        EXOInboundConnector 'ConfigureInboundConnector'
        {
            Identity                     = "Contoso Inbound Connector"
            CloudServicesMailEnabled     = $True
            Comment                      = "Inbound connector for Contoso"
            ConnectorSource              = "Default"
            ConnectorType                = "OnPremises"
            Enabled                      = $True
            RequireTls                   = $True
            SenderDomains                = "*.contoso.com"
            TlsSenderCertificateName     = "contoso.com"
            TreatMessagesAsInternal      = $True
            Ensure                       = "Present"
            Credential                   = $Credscredential
        }
    }
}
