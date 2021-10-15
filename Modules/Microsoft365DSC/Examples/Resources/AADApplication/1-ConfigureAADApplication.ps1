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
            DisplayName                = "AppDisplayName"
            AvailableToOtherTenants    = $false
            GroupMembershipClaims      = "0"
            Homepage                   = "https://app.contoso.com"
            IdentifierUris             = "https://app.contoso.com"
            KnownClientApplications    = ""
            LogoutURL                  = "https://app.contoso.com/logout"
            Oauth2RequirePostResponse  = $false
            PublicClient               = $false
            ReplyURLs                  = "https://app.contoso.com"
            Permissions                = @(
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.Read'
                    Type                = 'Delegated'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $false
                }
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.ReadWrite.All'
                    Type                = 'Delegated'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $True
                }
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.Read.All'
                    Type                = 'AppOnly'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $True
                }
            )
            Ensure                     = "Present"
            Credential                 = $credsGlobalAdmin
        }
    }
}
