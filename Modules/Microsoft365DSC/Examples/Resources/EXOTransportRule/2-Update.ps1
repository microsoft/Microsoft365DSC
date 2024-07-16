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
        EXOTransportRule 'ConfigureTransportRule'
        {
            Name                                          = "Ethical Wall - Sales and Executives Departments"
            BetweenMemberOf1                              = "SalesTeam@$TenantId"
            BetweenMemberOf2                              = "Executives@$TenantId"
            ExceptIfFrom                                  = "AdeleV@$TenantId"
            ExceptIfSubjectContainsWords                  = "Press Release","Corporate Communication"
            RejectMessageReasonText                       = "Messages sent between the Sales and Brokerage departments are strictly prohibited."
            Enabled                                       = $False # Updated Property
            Ensure                                        = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
