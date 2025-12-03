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
        EXOSharedMailbox 'SharedMailbox'
        {
            DisplayName        = "Integration"
            PrimarySMTPAddress = "Integration@$TenantId"
            EmailAddresses     = @("IntegrationSM@$TenantId", "IntegrationSM2@$TenantId")
            Alias              = "IntegrationSM"
            Ensure             = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
