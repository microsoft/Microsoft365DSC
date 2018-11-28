Configuration ProofOfConcept
{
    Import-DSCResource -ModuleName Office365DSC -ModuleVersion 1.0.0.0
    $credsGlobalAdmin = Get-Credential -UserName "TenantAdmin@O365DSC1.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {
        O365User JohnSMith
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

        O365Group OttawaTeam
        {
            DisplayName = "Ottawa Employees"
            Description = "This is only for employees of the Ottawa Office"
            GroupType = "Office365"
            ManagedBy = "TenantAdmin@O365DSC1.onmicrosoft.com"
            Ensure = "Present"
            GlobalAdminAccount = $credsGlobalAdmin
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
