<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        AADServicePrincipal 'AADServicePrincipal'
        {
            AppId                         = 'AppDisplayName'
            DisplayName                   = "AppDisplayName"
            AlternativeNames              = "AlternativeName1","AlternativeName2"
            AccountEnabled                = $true
            AppRoleAssignmentRequired     = $false
            Homepage                      = "https://$Domain"
            LogoutUrl                     = "https://$Domain/logout"
            ReplyURLs                     = "https://$Domain"
            ServicePrincipalType          = "Application"
            Tags                          = "{WindowsAzureActiveDirectoryIntegratedApp}"
            Ensure                        = "Present"
            Credential                    = $Credscredential
        }
    }
}
