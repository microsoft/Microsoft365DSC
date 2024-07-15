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
        AADEntitlementManagementAccessPackageCatalogResource 'myAccessPackageCatalogResource'
        {
            ApplicationId         = $ApplicationId;
            CatalogId             = "My Catalog";
            CertificateThumbprint = $CertificateThumbprint;
            DisplayName           = "Finance Team";
            OriginSystem          = "AADGroup";
            OriginId              = '50523ab8-a3d2-4b4f-a77d-16bd1abd328f'
            Ensure                = "Present";
            IsPendingOnboarding   = $False;
            TenantId              = $TenantId;
        }
    }
}
