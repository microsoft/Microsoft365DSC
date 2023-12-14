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
        AADEntitlementManagementAccessPackageCatalogResource 'myAccessPackageCatalogResource'
        {
            Id                  = 'a694d6c3-57cb-4cb1-b32b-07bf1325df8e'
            DisplayName         = 'Communication site'
            AddedBy             = 'admin@contoso.onmicrosoft.com'
            AddedOn             = '05/11/2022 16:21:15'
            CatalogId           = 'f34c2d92-9e9d-4703-ba9b-955b6ac8dcb3'
            Description         = 'https://contoso.sharepoint.com/'
            IsPendingOnboarding = $False
            OriginId            = 'https://contoso.sharepoint.com/'
            OriginSystem        = 'SharePointOnline'
            ResourceType        = 'SharePoint Online Site'
            Url                 = 'https://contoso.sharepoint.com/'
            Ensure              = 'Present'
            Credential          = $Credscredential
        }
    }
}
