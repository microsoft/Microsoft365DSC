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

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        AADEntitlementManagementAccessPackageCatalogResource 'myAccessPackageCatalogResource'
        {
            DisplayName         = 'Human Resources'
            CatalogId           = 'My Catalog'
            Description         = "https://$($Domain.Split('.')[0]).sharepoint.com/sites/HumanResources"
            IsPendingOnboarding = $true
            OriginId            = "https://$($Domain.Split('.')[0]).sharepoint.com/sites/HumanResources"
            OriginSystem        = 'SharePointOnline'
            ResourceType        = 'SharePoint Online Site'
            Url                 = "https://$($Domain.Split('.')[0]).sharepoint.com/sites/HumanResources"
            Ensure              = 'Present'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
