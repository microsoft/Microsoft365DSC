<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADEntitlementManagementConnectedOrganization 'MyConnectedOrganization'
        {
            Description           = "this is the tenant partner";
            DisplayName           = "Test Tenant - DSC";
            ExternalSponsors      = @("12345678-1234-1234-1234-123456789012");
            IdentitySources       = @(
                MSFT_AADEntitlementManagementConnectedOrganizationIdentitySource{
                    ExternalTenantId = "12345678-1234-1234-1234-123456789012"
                    DisplayName = 'Contoso'
                    odataType = '#microsoft.graph.azureActiveDirectoryTenant'
                }
            );
            InternalSponsors      = @("12345678-1234-1234-1234-123456789012");
            State                 = "configured";
            Ensure                = "Present"
            Credential            = $Credscredential
        }
    }
}
