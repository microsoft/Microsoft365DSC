<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration SiteDesignRights
{
    Import-DSCResource -ModuleName Office365DSC
    $credsGlobalAdmin = Get-Credential -UserName "derek@smaystate.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {
        SPOSiteDesignRights MyTenant
        {
            SiteDesignTitle    = "Customer List"
            UserPrincipals     = "jdoe@dsazure.com","dsmay@dsazure.com"
            Rights             = "View"
            Ensure             = "Present"
            CentralAdminUrl    = "https://smaystate-admin.sharepoint.com"
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
