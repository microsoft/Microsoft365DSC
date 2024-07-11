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
        AADEntitlementManagementConnectedOrganization 'MyConnectedOrganization'
        {
            Description           = "this is the tenant partner";
            DisplayName           = "Test Tenant - DSC";
            ExternalSponsors      = @("AdeleV@$TenantId");
            IdentitySources       = @(
                MSFT_AADEntitlementManagementConnectedOrganizationIdentitySource{
                    ExternalTenantId = "e7a80bcf-696e-40ca-8775-a7f85fbb3ebc"
                    DisplayName = 'o365dsc'
                    odataType = '#microsoft.graph.azureActiveDirectoryTenant'
                }
            );
            InternalSponsors      = @("AdeleV@$TenantId");
            State                 = "configured";
            Ensure                = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
