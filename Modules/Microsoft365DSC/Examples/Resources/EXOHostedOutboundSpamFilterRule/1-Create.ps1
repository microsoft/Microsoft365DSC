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
        EXOHostedOutboundSpamFilterRule 'ConfigureHostedOutboundSpamFilterRule'
        {
            Identity                       = "Contoso Executives"
            Comments                       = "Does not apply to Executives"
            Enabled                        = $True
            ExceptIfFrom                   = "AdeleV@$TenantId"
            FromMemberOf                   = "Executives@$TenantId"
            HostedOutboundSpamFilterPolicy = "Integration SFP"
            Ensure                         = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
