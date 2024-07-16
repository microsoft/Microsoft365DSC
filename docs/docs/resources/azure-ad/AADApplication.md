# AADApplication

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | DisplayName of the app | |
| **ObjectId** | Write | String | ObjectID of the app. | |
| **AppId** | Write | String | AppId for the app. | |
| **AvailableToOtherTenants** | Write | Boolean | Indicates whether this application is available in other tenants. | |
| **Description** | Write | String | A free text field to provide a description of the application object to end users. The maximum allowed size is 1024 characters. | |
| **GroupMembershipClaims** | Write | String | A bitmask that configures the groups claim issued in a user or OAuth 2.0 access token that the application expects. | |
| **Homepage** | Write | String | The URL to the application's homepage. | |
| **IdentifierUris** | Write | StringArray[] | User-defined URI(s) that uniquely identify a Web application within its Azure AD tenant, or within a verified custom domain. | |
| **IsFallbackPublicClient** | Write | Boolean | Specifies the fallback application type as public client, such as an installed application running on a mobile device. The default value is false, which means the fallback application type is confidential client such as web app. There are certain scenarios where Microsoft Entra ID cannot determine the client application type (for example, ROPC flow where it is configured without specifying a redirect URI). In those cases, Microsoft Entra ID will interpret the application type based on the value of this property. | |
| **KnownClientApplications** | Write | StringArray[] | Client applications that are tied to this resource application. | |
| **LogoutURL** | Write | String | The logout url for this application. | |
| **PublicClient** | Write | Boolean | Specifies whether this application is a public client (such as an installed application running on a mobile device). Default is false. | |
| **ReplyURLs** | Write | StringArray[] | Specifies the URLs that user tokens are sent to for sign in, or the redirect URIs that OAuth 2.0 authorization codes and access tokens are sent to. | |
| **Owners** | Write | StringArray[] | UPN or ObjectID values of the app's owners. | |
| **Ensure** | Write | String | Specify if the Azure AD App should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials for the Microsoft Graph delegated permissions. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **Permissions** | Write | MSFT_AADApplicationPermission[] | API permissions for the Azure Active Directory Application. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_AADApplicationPermission

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Write | String | Name of the requested permission. | |
| **SourceAPI** | Write | String | Name of the API from which the permission comes from. | |
| **Type** | Write | String | Type of permission. | `AppOnly`, `Delegated` |
| **AdminConsentGranted** | Write | Boolean | Represented whether or not the Admin consent been granted on the app. | |

## Description

This resource configures an Azure Active Directory Application.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Application.Read.All

- **Update**

    - Application.Read.All, Application.ReadWrite.All, User.Read.All

#### Application permissions

- **Read**

    - Application.Read.All

- **Update**

    - Application.Read.All, Application.ReadWrite.All, User.Read.All

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
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
        AADApplication 'AADApp1'
        {
            DisplayName               = "AppDisplayName"
            AvailableToOtherTenants   = $false
            Description               = "Application Description"
            GroupMembershipClaims     = "None"
            Homepage                  = "https://$TenantId"
            IdentifierUris            = "https://$TenantId"
            KnownClientApplications   = ""
            LogoutURL                 = "https://$TenantId/logout"
            PublicClient              = $false
            ReplyURLs                 = "https://$TenantId"
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
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
```

### Example 2

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
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
        AADApplication 'AADApp1'
        {
            DisplayName               = "AppDisplayName"
            AvailableToOtherTenants   = $true # Updated Property
            Description               = "Application Description"
            GroupMembershipClaims     = "None"
            Homepage                  = "https://$TenantId"
            IdentifierUris            = "https://$TenantId"
            KnownClientApplications   = ""
            LogoutURL                 = "https://$TenantId/logout"
            PublicClient              = $false
            ReplyURLs                 = "https://$TenantId"
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
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
```

### Example 3

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
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
        AADApplication 'AADApp1'
        {
            DisplayName               = "AppDisplayName"
            Ensure                    = "Absent"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
```

