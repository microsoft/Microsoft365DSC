Configuration POCOneDrive
{
    Import-DSCResource -ModuleName Office365DSC -ModuleVersion 1.0.0.0
    $credsGlobalAdmin = Get-Credential -UserName "derek@smaystate.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {
        OneDrive OneDriveSettings
        {
            BlockMacSync = $True
            CentralAdminUrl = 'https://smaystate-admin.sharepoint.com'
            GlobalAdminAccount = $credsGlobalAdmin
            OneDriveStorageQuota = '1024'
        }
     
    }
}

$configData = @{
    AllNodes = @(
        @{
            NodeName = "localhost"
            PSDscAllowPlainTextPassword = $true;
            PSDscAllowDomainUser = $true;
    }
    )
}

POCOneDrive -ConfigurationData $configData
