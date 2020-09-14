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
        AADApplication DSCApp1
        {
            DisplayName                   = "AppDisplayName"
            AvailableToOtherTenants       = $false
            GroupMembershipClaims         = "0"
            Homepage                      = "https://app.contoso.com"
            IdentifierUris                = "https://app.contoso.com"
            KnownClientApplications       = ""
            LogoutURL                     = "https://app.contoso.com/logout"
            Oauth2AllowImplicitFlow       = $false
            Oauth2AllowUrlPathMatching    = $false
            Oauth2RequirePostResponse     = $false
            PublicClient                  = $false
            ReplyURLs                     = "https://app.contoso.com"
            SamlMetadataUrl               = ""
            Ensure                        = "Present"
            GlobalAdminAccount            = $credsGlobalAdmin
        }
    }
}
