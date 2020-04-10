<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SPOStorageEntity MyStorageEntity
        {
            Key                = "DSCKey"
            Value              = "Test storage entity"
            EntityScope        = "Tenant"
            Description        = "Description created by DSC"
            Comment            = "Comment from DSC"
            Ensure             = "Present"
            SiteUrl            = "https://o365dsc1-admin.sharepoint.com"
            GlobalAdminAccount = $credsGlobalAdmin
        }
    }
}
