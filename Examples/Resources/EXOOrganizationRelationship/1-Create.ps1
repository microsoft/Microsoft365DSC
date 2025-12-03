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
        EXOOrganizationRelationship 'ConfigureOrganizationRelationship'
        {
            Name                  = "Contoso"
            ArchiveAccessEnabled  = $True
            DeliveryReportEnabled = $True
            DomainNames           = "mail.contoso.com"
            Enabled               = $True
            FreeBusyAccessEnabled = $True
            FreeBusyAccessLevel   = "AvailabilityOnly"
            MailboxMoveEnabled    = $True
            MailTipsAccessEnabled = $True
            MailTipsAccessLevel   = "None"
            PhotosEnabled         = $True
            TargetApplicationUri  = "mail.contoso.com"
            TargetAutodiscoverEpr = "https://mail.contoso.com/autodiscover/autodiscover.svc/wssecurity"
            Ensure                = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
