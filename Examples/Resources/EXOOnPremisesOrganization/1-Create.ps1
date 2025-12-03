<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOOnPremisesOrganization 'ConfigureOnPremisesOrganization'
        {
            Identity          = 'Integration'
            Comment           = 'Mail for Contoso'
            HybridDomains     = 'o365dsc.onmicrosoft.com'
            InboundConnector  = 'Integration Inbound Connector'
            OrganizationGuid  = 'e7a80bcf-696e-40ca-8775-a7f85fbb3ebc'
            OrganizationName  = 'O365DSC'
            OutboundConnector = 'Contoso Outbound Connector'
            Ensure            = 'Present'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            DependsOn         = "[EXOOutboundConnector]OutboundDependency"
        }
        EXOOutboundConnector 'OutboundDependency'
        {
            Identity                      = "Contoso Outbound Connector"
            AllAcceptedDomains            = $False
            CloudServicesMailEnabled      = $False
            Comment                       = "Outbound connector to Contoso"
            ConnectorSource               = "Default"
            ConnectorType                 = "Partner"
            Enabled                       = $True
            IsTransportRuleScoped         = $False
            RecipientDomains              = "contoso.com"
            RouteAllMessagesViaOnPremises = $False
            TlsDomain                     = "*.contoso.com"
            TlsSettings                   = "DomainValidation"
            UseMxRecord                   = $True
            Ensure                        = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
