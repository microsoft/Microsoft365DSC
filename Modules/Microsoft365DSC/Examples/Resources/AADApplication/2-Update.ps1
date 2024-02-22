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
        AADApplication 'AADApp1'
        {
            DisplayName               = "AppDisplayName"
            AvailableToOtherTenants   = $true # Updated Property
            Description               = "Application Description"
            GroupMembershipClaims     = "None"
            Homepage                  = "https://$Domain"
            IdentifierUris            = "https://$Domain"
            KnownClientApplications   = ""
            LogoutURL                 = "https://$Domain/logout"
            PublicClient              = $false
            ReplyURLs                 = "https://$Domain"
            Permissions               = @(
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
            Ensure                    = "Present"
            Credential                = $Credscredential
        }
    }
}
