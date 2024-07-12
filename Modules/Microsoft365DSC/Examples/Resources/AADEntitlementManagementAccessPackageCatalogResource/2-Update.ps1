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
            DisplayName         = 'Human Resources'
            CatalogId           = 'My Catalog'
            Description         = "https://$($TenantId.Split('.')[0]).sharepoint.com/sites/HumanResources"
            IsPendingOnboarding = $false # Updated Property
            OriginId            = "https://$($TenantId.Split('.')[0]).sharepoint.com/sites/HumanResources"
            OriginSystem        = 'SharePointOnline'
            ResourceType        = 'SharePoint Online Site'
            Url                 = "https://$($TenantId.Split('.')[0]).sharepoint.com/sites/HumanResources"
            Ensure              = 'Present'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
