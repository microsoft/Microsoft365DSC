<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration MSFT_SPOAccessControlSettings
{
    Import-DSCResource -ModuleName Office365DSC
    $credsGlobalAdmin = Get-Credential -UserName "TenantAdmin@O365DSC1.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {
        SPOAccessControlSettings MyTenantAccessControlSettings
        {
            IsSingleInstance             = "Yes"
            CentralAdminUrl              = "https://o365dsc1-admin.sharepoint.com"
            GlobalAdminAccount           = $credsGlobalAdmin
            DisplayStartASiteOption      = $false
            StartASiteFormUrl            = "https://o365dsc1.sharepoint.com"
            IPAddressEnforcement         = $false
            #IPAddressAllowList           = "" #would generate an error while writing this resource
            IPAddressWACTokenLifetime    = 15
            CommentsOnSitePagesDisabled  = $false
            SocialBarOnSitePagesDisabled = $false
            DisallowInfectedFileDownload = $false
            ExternalServicesEnabled      = $true
            EmailAttestationRequired     = $false
            EmailAttestationReAuthDays   = 30
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

MSFT_SPOAccessControlSettings -ConfigurationData $configData
