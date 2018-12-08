Configuration POCOneDrive
{
    Import-DSCResource -ModuleName Office365DSC -ModuleVersion 1.0.0.0
    $credsGlobalAdmin = Get-Credential -UserName "derek@smaystate.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {
        OneDriveQuota OneDriveStorageQuota
        {   
            Key = 'OneDriveStorageQuota'
            OneDriveStorageQuota = '1024'
            CentralAdminUrl = "https://smaystate-admin.sharepoint.com"
            GlobalAdminAccount = $credsGlobalAdmin
        }

        OneDriveSyncSettings OneDriveSyncSettings
        {
            BlockMacSync = $true
            CentralAdminUrl = "https://smaystate-admin.sharepoint.com"
            GlobalAdminAccount = $credsGlobalAdmindir

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
