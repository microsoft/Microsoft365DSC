<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration SiteDesignConfig
{
    Import-DSCResource -ModuleName Office365DSC
    $credsGlobalAdmin = Get-Credential -UserName "TenantAdmin@O365DSC1.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {
        SPOSiteDesign SiteDesign
        {
            Title               = "DSC Site Design"
            SiteScriptNames     = "Cust List", "List_Views"
            WebTemplate         = "TeamSite"
            isDefault           = $false
            Description         = "Created by DSC"
            PreviewImageAltText = "Office 365"
            PreviewImageUrl     = ""
            Ensure             = "Present"
            CentralAdminUrl    = "https://o365dsc1-admin.sharepoint.com"
            GlobalAdminAccount = $credsGlobalAdmin
        }
    }
}

$configData = @{
    AllNodes = @(
        @{
            NodeName                    = "localhost"
            PSDscAllowPlainTextPassword = $true
            PSDscAllowDomainUser        = $true
        }
    )
}

SiteDesignConfig -ConfigurationData $configData
