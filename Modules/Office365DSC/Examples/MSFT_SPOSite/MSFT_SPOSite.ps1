<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Site
{
    Import-DSCResource -ModuleName Office365DSC
    $credsGlobalAdmin = Get-Credential -UserName "TenantAdmin@O365DSC1.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {
        SPOSite ee4a977d-4d7d-4968-9238-2a1702aa699c
        {
            Url                = "https://office365dsc-my.sharepoint.com/"
            ResourceQuota      = 0
            CentralAdminUrl    = "https://Office365DSC-admin.sharepoint.com"
            StorageQuota       = 26214400
            LocaleId           = 1033
            Template           = "SPSMSITEHOST#0"
            GlobalAdminAccount = $credsGlobalAdmin
            Owner               = "08b23058-d843-4b09-8174-d8d1b42d03c2"
            CompatibilityLevel = 15
            Title              = "My Site"
            Ensure             = "Present"
        }
    }
}

$configData = @{
    AllNodes = @(
        @{
            NodeName                    = "localhost"
            PSDscAllowPlainTextPassword = $true;
            PSDscAllowDomainUser        = $true;
        }
    )
}

Site -ConfigurationData $configData
