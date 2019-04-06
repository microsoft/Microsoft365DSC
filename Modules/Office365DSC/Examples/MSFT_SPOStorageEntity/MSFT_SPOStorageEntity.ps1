<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration StorageEntityConfig
{
    Import-DSCResource -ModuleName Office365DSC
    $credsGlobalAdmin = Get-Credential -UserName "derek@smaystate.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {
        SPOStorageEntity MyStorageEntity
        {
            Key                = "DSCKey"
            Value              = "Test storage entity"
            Scope              = "Site"
            Description        = "Description created by DSC"
            Comment            = "Comment from DSC"
            Ensure             = "Present"
            SiteUrl            = "https://smaystate.sharepoint.com/sites/devops"
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
