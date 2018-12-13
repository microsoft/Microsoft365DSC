<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration ProofOfConcept
{
    Import-DSCResource -ModuleName Office365DSC
    $credsGlobalAdmin = Get-Credential -UserName "TenantAdmin@O365DSC1.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {
        <#O365User JohnSMith
        {
            UserPrincipalName = "John.Smith@O365DSC1.onmicrosoft.com"
            FirstName = "John"
            LastName = "Smith"
            DisplayName = "John J. Smith"
            City = "Gatineau"
            Country = "Canada"
            Office = "Ottawa - Queen"
            LicenseAssignment = @("O365dsc1:ENTERPRISEPREMIUM")
            UsageLocation = "US"
            Ensure = "Present"
            GlobalAdminAccount = $credsGlobalAdmin
        }

        O365User BobHoule
        {
            UserPrincipalName = "Bob.Houle@O365DSC1.onmicrosoft.com"
            FirstName = "Bob"
            LastName = "Houle"
            DisplayName = "Bob Houle"
            City = "Gatineau"
            Country = "Canada"
            Office = "Ottawa - Queen"
            LicenseAssignment = @("O365dsc1:ENTERPRISEPREMIUM")
            UsageLocation = "US"
            Ensure = "Present"
            GlobalAdminAccount = $credsGlobalAdmin
        }

        O365Group OttawaTeam
        {
            DisplayName = "Ottawa Employees"
            Description = "This is only for employees of the Ottawa Office"
            GroupType = "Office365"
            ManagedBy = "TenantAdmin@O365DSC1.onmicrosoft.com"
            Members = @("Bob.Houle", "John.Smith")
            Ensure = "Present"
            GlobalAdminAccount = $credsGlobalAdmin
        }#>

        EXOSharedMailbox AdminAssistants
        {
            DisplayName = "Test"
            PrimarySMTPAddress = "Test@O365DSC1.onmicrosoft.com"
            Aliases = @("Joufflu@o365dsc1.onmicrosoft.com", "Gilles@O365dsc1.onmicrosoft.com")
            Ensure = "Present"
            GlobalAdminAccount = $credsGlobalAdmin
        }
        
        ODSettings OneDriveSettings
        {
            CentralAdminUrl = 'https://o365dsc1-admin.sharepoint.com'
            GlobalAdminAccount = $credsGlobalAdmin
            OneDriveStorageQuota = '1024'
            ExcludedFileExtensions = @('pst')
            DomainGuids = '786548dd-877b-4760-a749-6b1efbc1190a'
            GrooveBlockOption = "OptOut"
            DisableReportProblemDialog = $true
            BlockMacSync = $true
            OrphanedPersonalSitesRetentionPeriod = "45"
            OneDriveForGuestsEnabled = $false
            ODBAccessRequests = 'On'
            ODBMembersCanShare = 'On'
            NotifyOwnersWhenInvitationsAccepted = $false
            NotificationsInOneDriveForBusinessEnabled = $false
        }

        SPOSite HumanResources
        {
            Url = "https://o365dsc1.sharepoint.com/sites/HumanRes"
            Owner = "TenantAdmin@O365DSC1.onmicrosoft.com"
            StorageQuota = 300
            ResourceQuota = 500
            CentralAdminUrl = "https://o365dsc1-admin.sharepoint.com"
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

ProofOfConcept -ConfigurationData $configData
