<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Teams
{
    Import-DSCResource -ModuleName Office365DSC
    $credsGlobalAdmin = Get-Credential -UserName "derek@smaystate.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {
        

        ODSettings OneDriveSettings
        {
            CentralAdminUrl = 'https://smaystate-admin.sharepoint.com'
            GlobalAdminAccount = $credsGlobalAdmin
            OneDriveStorageQuota = '1024'
            ExcludedFileExtensions = @('pst')
            DomainGuids = ''
            GrooveBlockOption = "OptOut"
            DisableReportProblemDialog = $true
            OrphanedPersonalSitesRetentionPeriod = "45"
            OneDriveForGuestsEnabled = $false
            ODBAccessRequests = 'On'
            ODBMembersCanShare = 'On'
            NotifyOwnersWhenInvitationsAccepted = $false
            NotificationsInOneDriveForBusinessEnabled = $false
        }

        TeamsTeam MyTeams
        {
            DisplayName = "TestTeam"
            GlobalAdminAccount = $credsGlobalAdmin
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

Teams -ConfigurationData $configData
