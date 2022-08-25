﻿# AADApplication

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Write | String | Name of the requested permission. ||
| **SourceAPI** | Write | String | Name of the API from which the permission comes from. ||
| **Type** | Write | String | Type of permission. |AppOnly, Delegated|
| **AdminConsentGranted** | Write | Boolean | Represented whether or not the Admin consent been granted on the app. ||
| **DisplayName** | Key | String | DisplayName of the app ||
| **ObjectId** | Write | String | ObjectID of the app. ||
| **AppId** | Write | String | AppId for the app. ||
| **AvailableToOtherTenants** | Write | Boolean | Indicates whether this application is available in other tenants. ||
| **GroupMembershipClaims** | Write | String | A bitmask that configures the groups claim issued in a user or OAuth 2.0 access token that the application expects. The bitmask values are: 0: None, 1: Security groups and Azure AD roles, 2: Reserved, and 4: Reserved. Setting the bitmask to 7 will get all of the security groups, distribution groups, and Azure AD directory roles that the signed-in user is a member of. ||
| **Homepage** | Write | String | The URL to the application's homepage. ||
| **IdentifierUris** | Write | StringArray[] | User-defined URI(s) that uniquely identify a Web application within its Azure AD tenant, or within a verified custom domain. ||
| **KnownClientApplications** | Write | StringArray[] | Client applications that are tied to this resource application. ||
| **LogoutURL** | Write | String | The logout url for this application. ||
| **Oauth2RequirePostResponse** | Write | Boolean | Set this to true if an Oauth2 post response is required. ||
| **PublicClient** | Write | Boolean | Specifies whether this application is a public client (such as an installed application running on a mobile device). Default is false. ||
| **ReplyURLs** | Write | StringArray[] | Specifies the URLs that user tokens are sent to for sign in, or the redirect URIs that OAuth 2.0 authorization codes and access tokens are sent to. ||
| **Owners** | Write | StringArray[] | UPN or ObjectID values of the app's owners. ||
| **Ensure** | Write | String | Specify if the Azure AD App should exist or not. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials for the Microsoft Graph delegated permissions. ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **Permissions** | Write | InstanceArray[] | API permissions for the Azure Active Directory Application. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||

# AADApplication

### Description

This resource configures an Azure Active Directory Application.

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
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
        AADApplication 'AADApp1'
        {
            DisplayName               = "AppDisplayName"
            AvailableToOtherTenants   = $false
            GroupMembershipClaims     = "0"
            Homepage                  = "https://app.contoso.com"
            IdentifierUris            = "https://app.contoso.com"
            KnownClientApplications   = ""
            LogoutURL                 = "https://app.contoso.com/logout"
            Oauth2RequirePostResponse = $false
            PublicClient              = $false
            ReplyURLs                 = "https://app.contoso.com"
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
            Credential                = $credsGlobalAdmin
        }
    }
}
```

