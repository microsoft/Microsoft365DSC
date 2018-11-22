Configuration ProofOfConcept
{
	Import-DSCResource -ModuleName Office365DSC -ModuleVersion 1.0.0.0
	$credsGlobalAdmin = Get-Credential -UserName "TenantAdmin@O365DSC1.onmicrosoft.com" -Message "Global Admin"
	Node localhost
	{
		SPOSite TestNik
		{
			Url = "https://O365DSC1.sharepoint.com/sites/PoC4"
			Owner = "TenantAdmin@O365DSC1.onmicrosoft.com"
			StorageQuota = 7777
			Title = "ProofOfConcept"
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