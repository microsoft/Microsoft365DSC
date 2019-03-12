<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration SiteDesignRights
{
    Import-DSCResource -ModuleName Office365DSC
    $credsGlobalAdmin = Get-Credential -UserName "TenantAdmin@O365DSC1.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {
        SPOSiteDesignRights MyTenant
        {
            SiteDesignTitle    = "Customer List"
            UserPrincipals     = "jdoe@dsazure.com"
            Rights             = "View"
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
            PSDscAllowPlainTextPassword = $true;
            PSDscAllowDomainUser        = $true;
        }
    )
}

SiteDesignRights -ConfigurationData $configData
