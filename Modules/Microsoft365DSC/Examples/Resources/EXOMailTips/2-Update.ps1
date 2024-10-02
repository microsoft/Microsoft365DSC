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
        EXOMailTips 'OrgWideMailTips'
        {
            IsSingleInstance                      = 'Yes'
            MailTipsAllTipsEnabled                = $True
            MailTipsGroupMetricsEnabled           = $False # Updated Property
            #MailTipsLargeAudienceThreshold        = 100
            MailTipsMailboxSourcedTipsEnabled     = $True
            MailTipsExternalRecipientsTipsEnabled = $True
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
