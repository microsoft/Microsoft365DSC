Configuration ProofOfConcept
{
    Import-DSCResource -ModuleName Office365DSC -ModuleVersion 1.0.0.0
    $credsGlobalAdmin = Get-Credential -UserName "TenantAdmin@O365DSC1.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {

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
