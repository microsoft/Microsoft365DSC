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
        EXOOnPremisesOrganization 'ConfigureOnPremisesOrganization'
        {
            Identity          = 'Contoso'
            Comment           = 'Mail for Contoso'
            HybridDomains     = 'contoso.com', 'sales.contoso.com'
            InboundConnector  = 'Inbound to Contoso'
            OrganizationGuid  = 'a1bc23cb-3456-bcde-abcd-feb363cacc88'
            OrganizationName  = 'Contoso'
            OutboundConnector = 'Outbound to Contoso'
            Ensure            = 'Present'
            Credential        = $Credscredential
        }
    }
}
