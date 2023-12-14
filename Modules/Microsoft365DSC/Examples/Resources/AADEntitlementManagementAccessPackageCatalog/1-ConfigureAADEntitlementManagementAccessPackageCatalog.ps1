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
        AADEntitlementManagementAccessPackageCatalog 'myAccessPackageCatalog'
        {
            Id                  = '7f66090e-11d2-4868-bc13-df98a327077d'
            DisplayName         = 'General'
            CatalogStatus       = 'Published'
            CatalogType         = 'ServiceDefault'
            Description         = 'Built-in catalog.'
            IsExternallyVisible = $True
            Managedidentity     = $False
            Ensure              = 'Present'
            Credential          = $Credscredential
        }
    }
}
