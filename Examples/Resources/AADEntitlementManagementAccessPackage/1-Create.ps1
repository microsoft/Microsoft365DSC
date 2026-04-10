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
        AADEntitlementManagementAccessPackage 'myAccessPackage'
        {
            AccessPackagesIncompatibleWith = @();
            CatalogId                      = "General";
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            Description                    = "Integration Tests";
            DisplayName                    = "Integration Package";
            Ensure                         = "Present";
            IsHidden                       = $False;
            IsRoleScopesVisible            = $True;
        }
    }
}
