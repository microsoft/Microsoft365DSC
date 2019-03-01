<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration SearchRSConfig
{
    Import-DSCResource -ModuleName Office365DSC
    $credsGlobalAdmin = Get-Credential -UserName "TenantAdmin@O365DSC1.onmicrosoft.com" -Message "Global Admin"
    Node localhost
    {
        SPOSearchResultSource SearchMP
        {
            Name               = "MyResultSource"                      
            Description        = "Description of item"
	    Protocol           = "Local"
            Type               = "SharePoint
            GlobalAdminAccount = $credsGlobalAdmin  
            Ensure             = "Present"
            CentralAdminUrl    = "https://Office365DSC-admin.sharepoint.com"
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

SearchRSConfig -ConfigurationData $configData
