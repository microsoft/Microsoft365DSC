Configuration POCOneDrive
{
    Import-DSCResource -ModuleName Office365DSC -ModuleVersion 1.0.0.0
    $credsGlobalAdmin = Get-Credential -UserName "derek@smaystate.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {
        OneDrive OneDriveSettings
        {
            CentralAdminUrl = 'https://smaystate-admin.sharepoint.com'
            GlobalAdminAccount = $credsGlobalAdmin
            OneDriveStorageQuota = '1024'
            ExcludedFileExtensions = @('pst','xls')
            DomainGuids = '786548DD-877B-4760-A749-6B1EFBC1190A;877564FF-877B-4760-A749-6B1EFBC1190A'
            GrooveBlockOption = "OptOut"
            DisableReportProblemDialog = $true
            BlockMacSync = $false
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
