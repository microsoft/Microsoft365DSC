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
            Office = "Ottawa"
            LicenseAssignment = @("O365dsc1:ENTERPRISEPREMIUM")
            UsageLocation = "US"
            Ensure = "Present"
            GlobalAdminAccount = $credsGlobalAdmin
        }
        O365Group TestGroup
        {
            DisplayName = "Nik MEDL Group"
            Description = "Hello World"
            PrimarySMTPAddress = "HI@o365dsc1.onmicrosoft.com"
            Alias = "HI"
            GroupType = "MailEnabledSecurity"
            Ensure = "Present"
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
