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
        AADActivityBasedTimeoutPolicy "AADActivityBasedTimeoutPolicy-displayName-value"
        {
            AzurePortalTimeOut    = "02:00:00";
            DefaultTimeOut        = "03:00:00";
            DisplayName           = "displayName-value";
            Ensure                = "Present";
            Id                    = "000000-0000-0000-0000-000000000000";
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
