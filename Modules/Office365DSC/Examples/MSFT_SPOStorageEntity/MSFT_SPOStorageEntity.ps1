<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration StorageEntityConfig
{
    Import-DSCResource -ModuleName Office365DSC
    $credsGlobalAdmin = Get-Credential -UserName "TenantAdmin@O365DSC1.onmicrosoft.com" -Message "Global Admin"
    Node localhost
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
$configData = @{
    AllNodes = @(
        @{
            NodeName                    = "localhost"
            PSDscAllowPlainTextPassword = $true
            PSDscAllowDomainUser        = $true
        }
    )
}

StorageEntityConfig -ConfigurationData $configData
