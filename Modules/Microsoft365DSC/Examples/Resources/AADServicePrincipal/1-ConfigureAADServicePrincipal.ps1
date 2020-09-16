<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADServicePrincipal AADServicePrincipal1
        {
            AppId                         = "<AppID GUID>"
            DisplayName                   = "AADAppName"
            AlternativeNames              = "AlternativeName1","AlternativeName2"
            AccountEnabled                = $true
            AppRoleAssignmentRequired     = $false
            ErrorUrl                      = ""
            Homepage                      = "https://AADAppName.contoso.com"
            LogoutUrl                     = "https://AADAppName.contoso.com/logout"
            PublisherName                 = "Contoso"
            ReplyURLs                     = "https://AADAppName.contoso.com"
            SamlMetadataURL               = ""
            ServicePrincipalNames         = "<AppID GUID>", "https://AADAppName.contoso.com"
            ServicePrincipalType          = "Application"
            Tags                          = "{WindowsAzureActiveDirectoryIntegratedApp}"
            Ensure                        = "Present"
            GlobalAdminAccount            = $credsGlobalAdmin
        }
    }
}
