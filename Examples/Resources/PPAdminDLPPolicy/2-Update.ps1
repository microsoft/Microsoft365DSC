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
        PPAdminDLPPolicy "PPAdminDLPPolicy-Test"
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            DisplayName           = "SuperTest";
            Ensure                = "Present";
            Environments          = "Default-e91d4e0e-d5a5-4e3a-be14-2192592a59af";
            FilterType            = "include"; # Drift
            TenantId              = $TenantId;
        }
    }
}
