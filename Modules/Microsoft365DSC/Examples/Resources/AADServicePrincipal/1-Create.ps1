<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADServicePrincipal 'AADServicePrincipal'
        {
            AppId                         = 'AppDisplayName'
            DisplayName                   = "AppDisplayName"
            AlternativeNames              = "AlternativeName1","AlternativeName2"
            AccountEnabled                = $true
            AppRoleAssignmentRequired     = $false
            Homepage                      = "https://$TenantId"
            LogoutUrl                     = "https://$TenantId/logout"
            ReplyURLs                     = "https://$TenantId"
            ServicePrincipalType          = "Application"
            Tags                          = "{WindowsAzureActiveDirectoryIntegratedApp}"
            Ensure                        = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
