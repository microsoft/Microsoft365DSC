configuration ProofOfConcept
{
    param (
        [Parameter(Mandatory=$true)] [ValidateNotNullorEmpty()] [PSCredential] $GlobalAdminAccount
    )
    Import-DSCResource -ModuleName Office365DSC
    Node localhost
    {
        EXOSharedMailbox AdminAssistants
        {
            DisplayName = "Test"
            PrimarySMTPAddress = "Test@O365DSC1.onmicrosoft.com"
            Aliases = @("Joufflu@o365dsc1.onmicrosoft.com", "Gilles@O365dsc1.onmicrosoft.com")
            Ensure = "Present"
            GlobalAdminAccount = $GlobalAdminAccount
        }

        SPOSite HumanResources
        {
            Url = "https://o365dsc1.sharepoint.com/sites/HumanRes"
            Owner = "TenantAdmin@O365DSC1.onmicrosoft.com"
            StorageQuota = 300
            ResourceQuota = 500
            CentralAdminUrl = "https://o365dsc1-admin.sharepoint.com"
            GlobalAdminAccount = $GlobalAdminAccount
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
