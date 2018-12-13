Configuration POCOneDrive
{
    Import-DSCResource -ModuleName Office365DSC -ModuleVersion 1.0.0.0
    $credsGlobalAdmin = Get-Credential -UserName "derek@smaystate.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {
      <#
        OneDrive OneDriveSettings
    
        {
            CentralAdminUrl = 'https://smaystate-admin.sharepoint.com'
            GlobalAdminAccount = $credsGlobalAdmin
            OneDriveStorageQuota = '1024'
            ExcludedFileExtensions = @('pst')
            DomainGuids = '786548dd-877b-4760-a749-6b1efbc1190a'
            GrooveBlockOption = "OptOut"
            DisableReportProblemDialog = $true
            BlockMacSync = $true
        }
        #>
        OneDrive OneDriveSettings
        {
            CentralAdminUrl = 'https://smaystate-admin.sharepoint.com'
            GlobalAdminAccount = $credsGlobalAdmin
            OneDriveStorageQuota = '1024'
            ExcludedFileExtensions = @('pst')
            DisableReportProblemDialog = $false
            BlockMacSync = $true
            DomainGuids = '786548dd-877b-4760-a749-6b1efbc1190a'
           
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
