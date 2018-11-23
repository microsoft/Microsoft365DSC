Configuration ProofOfConcept
{
	Import-DSCResource -ModuleName Office365DSC -ModuleVersion 1.0.0.0
	$credsGlobalAdmin = Get-Credential -UserName "TenantAdmin@O365DSC1.onmicrosoft.com" -Message "Global Admin"
	Node localhost
	{
		SPOSite TestNik
		{
			Url = "https://O365DSC1.sharepoint.com/sites/PoC7"
			Owner = "TenantAdmin@O365DSC1.onmicrosoft.com"
			StorageQuota = 100
            ResourceQuota = 777
			Title = "ProofOfConcept"
			CentralAdminUrl = "https://o365dsc1-admin.sharepoint.com"
			GlobalAdminAccount = $credsGlobalAdmin
		}

        O365User Bob
        {
            UserPrincipalName = "Bob.Houle@O365DSC1.onmicrosoft.com"
            FirstName = "Bob"
            LastName = "Houle"
            DisplayName = "Bob Houle"
            UsageLocation = "US"
            LicenseAssignment = "O365dsc1:ENTERPRISEPREMIUM"
            GlobalAdminAccount = $credsGlobalAdmin
        }

        O365User John
        {
            UserPrincipalName = "John.Smith@O365DSC1.onmicrosoft.com"
            FirstName = "John"
            LastName = "Smith"
            DisplayName = "John Smith"
            UsageLocation = "US"
            LicenseAssignment = "O365dsc1:ENTERPRISEPREMIUM"
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