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
        AADEntitlementManagementAccessPackageCatalogResource 'myAccessPackageCatalogResource'
        {
            DisplayName         = 'Test Resource'
            AddedBy             = 'admin@contoso.onmicrosoft.com'
            AddedOn             = '05/11/2022 16:21:15'
            CatalogId           = 'My Catalog'
            Description         = 'My Resource'
            IsPendingOnboarding = $False
            OriginId            = "https://$Domain.sharepoint.com/"
            OriginSystem        = 'SharePointOnline'
            ResourceType        = 'SharePoint Online Site'
            Url                 = "https://$Domain.sharepoint.com/"
            Ensure              = 'Present'
            Credential          = $Credscredential
        }
    }
}
