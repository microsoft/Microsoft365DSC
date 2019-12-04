<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration MSFT_SiteGroup #Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Office365DSC

    node localhost
    {
        SPOSiteGroup ee4a977d-4d7d-4968-9238-2a1702aa699c
        {
            Url                                         = "https://m365x478508.sharepoint.com/sites/classictestsite"
            Identity                                    = "TestSiteGroup"
            Owner                                       = "admin@M365x478508.onmicrosoft.com"#"admin@Office365DSC.onmicrosoft.com"
            PermissionLevels                            = @("Edit", "Read")
            Ensure                                      = "Present"
            GlobalAdminAccount                          = $credsGlobalAdmin
            
        }

        SPOSiteGroup adfd6217-29de-4297-95d4-7004455d3daa
        {
            Url                                         = "https://m365x478508.sharepoint.com/sites/testsite"
            Identity                                    = "TestSiteGroup"
            Owner                                       = "admin@M365x478508.onmicrosoft.com" #"admin@Office365DSC.onmicrosoft.com"
            PermissionLevels                            = @("Edit", "Read")
            Ensure                                      = "Present"
            GlobalAdminAccount                          = $credsGlobalAdmin
            
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

#Example -ConfigurationData $configData
MSFT_SiteGroup -ConfigurationData $configData