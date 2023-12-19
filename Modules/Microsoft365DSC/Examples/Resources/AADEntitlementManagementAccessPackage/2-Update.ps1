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
        AADEntitlementManagementAccessPackage 'myAccessPackage'
        {
            DisplayName                     = 'General'
            AccessPackageResourceRoleScopes = @(
                MSFT_AccessPackageResourceRoleScope {
                    Id                                   = 'e5b0c702-b949-4310-953e-2a51790722b8'
                    AccessPackageResourceOriginId        = '8721d9fd-c6ef-46df-b1b2-bb6f818bce5b'
                    AccessPackageResourceRoleDisplayName = 'AccessPackageRole'
                }
            )
            CatalogId                       = '1b0e5aca-83e4-447b-84a8-3d8cffb4a331'
            Description                     = 'Entitlement Access Package Example'
            IsHidden                        = $true # Updated Property
            IsRoleScopesVisible             = $true
            IncompatibleAccessPackages      = @()
            AccessPackagesIncompatibleWith  = @()
            IncompatibleGroups              = @()
            Ensure                          = 'Present'
            Credential                      = $Credscredential
        }
    }
}
