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

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        AADEntitlementManagementConnectedOrganization 'MyConnectedOrganization'
        {
            Description           = "This is the tenant partner - Updated"; # Updated Property
            DisplayName           = "Test Tenant - DSC";
            ExternalSponsors      = @("AdeleV@$Domain");
            IdentitySources       = @(
                MSFT_AADEntitlementManagementConnectedOrganizationIdentitySource{
                    ExternalTenantId = "e7a80bcf-696e-40ca-8775-a7f85fbb3ebc"
                    DisplayName = 'o365dsc'
                    odataType = '#microsoft.graph.azureActiveDirectoryTenant'
                }
            );
            InternalSponsors      = @("AdeleV@$Domain");
            State                 = "configured";
            Ensure                = "Present"
            Credential            = $Credscredential
        }
    }
}
