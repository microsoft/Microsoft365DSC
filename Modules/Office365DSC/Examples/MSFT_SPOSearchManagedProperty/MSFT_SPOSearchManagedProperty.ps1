<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration SearchMPConfig
{
    Import-DSCResource -ModuleName Office365DSC
    $credsGlobalAdmin = Get-Credential -UserName "TenantAdmin@O365DSC1.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {
        SPOSearchManagedProperty SearchMP
        {
            Searchable                  = $True
            FullTextIndex               = ""
            MappedCrawledProperties     = @()
            GlobalAdminAccount          = $credsGlobalAdmin
            LanguageNeutralTokenization = $True
            CompanyNameExtraction       = $False
            AllowMultipleValues         = $True
            Aliases                     = $True
            CentralAdminUrl             = "https://Office365DSC-admin.sharepoint.com"
            Queryable                   = $True
            Name                        = "TestManagedProperty"
            Safe                        = $True
            Description                 = "Description of item"
            FinerQueryTokenization      = $True
            Retrievable                 = $True
            Type                        = "Text"
            CompleteMatching            = $True
            FullTextContext             = 4
            Sortable                    = "Yes"
            Refinable                   = "Yes"
            Ensure                      = "Present"
            TokenNormalization          = $True
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

SearchMPConfig -ConfigurationData $configData
