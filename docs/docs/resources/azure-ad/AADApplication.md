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
| **Api** | Write | MSFT_MicrosoftGraphapiApplication | Specifies settings for an application that implements a web API. | |
| **AuthenticationBehaviors** | Write | MSFT_MicrosoftGraphauthenticationBehaviors | The collection of breaking change behaviors related to token issuance that are configured for the application. Authentication behaviors are unset by default (null) and must be explicitly enabled or disabled. Nullable. Returned only on $select.  For more information about authentication behaviors, see Manage application authenticationBehaviors to avoid unverified use of email claims for user identification or authorization. | |
| **PasswordCredentials** | Write | MSFT_MicrosoftGraphpasswordCredential[] | The collection of password credentials associated with the application. Not nullable. | |
| **KeyCredentials** | Write | MSFT_MicrosoftGraphkeyCredential[] | The collection of key credentials associated with the application. Not nullable. Supports $filter (eq, not, ge, le). | |
| **AppRoles** | Write | MSFT_MicrosoftGraphappRole[] | The collection of roles defined for the application. With app role assignments, these roles can be assigned to users, groups, or service principals associated with other applications. Not nullable. | |
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

### MSFT_MicrosoftGraphPreAuthorizedApplication

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **AppId** | Write | String | The unique identifier for the client application. | |
| **PermissionIds** | Write | StringArray[] | The unique identifier for the scopes the client application is granted. | |

### MSFT_MicrosoftGraphApiApplication

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **PreAuthorizedApplications** | Write | MSFT_MicrosoftGraphPreAuthorizedApplication[] | Lists the client applications that are preauthorized with the specified delegated permissions to access this application's APIs. Users aren't required to consent to any preauthorized application (for the permissions specified). However, any other permissions not listed in preAuthorizedApplications (requested through incremental consent for example) will require user consent. | |

### MSFT_MicrosoftGraphAuthenticationBehaviors

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **BlockAzureADGraphAccess** | Write | Boolean | If false, allows the app to have extended access to Azure AD Graph until June 30, 2025 when Azure AD Graph is fully retired. For more information on Azure AD retirement updates, see June 2024 update on Azure AD Graph API retirement. | |
| **RemoveUnverifiedEmailClaim** | Write | Boolean | If true, removes the email claim from tokens sent to an application when the email address's domain can't be verified. | |
| **RequireClientServicePrincipal** | Write | Boolean | If true, requires multitenant applications to have a service principal in the resource tenant as part of authorization checks before they're granted access tokens. This property is only modifiable for multitenant resource applications that rely on access from clients without a service principal and had this behavior as set to false by Microsoft. Tenant administrators should respond to security advisories sent through Azure Health Service events and the Microsoft 365 message center. | |

### MSFT_MicrosoftGraphKeyCredential

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **CustomKeyIdentifier** | Write | String | A 40-character binary type that can be used to identify the credential. Optional. When not provided in the payload, defaults to the thumbprint of the certificate. | |
| **DisplayName** | Write | String | Friendly name for the key. Optional. | |
| **EndDateTime** | Write | String | The date and time at which the credential expires. The DateTimeOffset type represents date and time information using ISO 8601 format and is always in UTC time. For example, midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z. | |
| **KeyId** | Write | String | The unique identifier (GUID) for the key. | |
| **Key** | Write | String | The certificate's raw data in byte array converted to Base64 string. | |
| **StartDateTime** | Write | String | The date and time at which the credential becomes valid.The Timestamp type represents date and time information using ISO 8601 format and is always in UTC time. For example, midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z. | |
| **Type** | Write | String | The type of key credential for example, Symmetric, AsymmetricX509Cert. | |
| **Usage** | Write | String | A string that describes the purpose for which the key can be used for example, Verify. | |

### MSFT_MicrosoftGraphPasswordCredential

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Write | String | Friendly name for the password. Optional. | |
| **EndDateTime** | Write | String | The date and time at which the password expires represented using ISO 8601 format and is always in UTC time. For example, midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z. Optional. | |
| **Hint** | Write | String | Contains the first three characters of the password. Read-only. | |
| **KeyId** | Write | String | The unique identifier for the password. | |
| **StartDateTime** | Write | String | The date and time at which the password becomes valid. The Timestamp type represents date and time information using ISO 8601 format and is always in UTC time. For example, midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z. Optional. | |

### MSFT_MicrosoftGraphAppRole

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **AllowedMemberTypes** | Write | StringArray[] | Specifies whether this app role can be assigned to users and groups (by setting to 'User'), to other application's (by setting to 'Application', or both (by setting to 'User', 'Application'). App roles supporting assignment to other applications' service principals are also known as application permissions. The 'Application' value is only supported for app roles defined on application entities. | |
| **Description** | Write | String | The description for the app role. This is displayed when the app role is being assigned and, if the app role functions as an application permission, during  consent experiences. | |
| **DisplayName** | Write | String | Display name for the permission that appears in the app role assignment and consent experiences. | |
| **Id** | Write | String | Unique role identifier inside the appRoles collection. When creating a new app role, a new GUID identifier must be provided. | |
| **IsEnabled** | Write | Boolean | When creating or updating an app role, this must be set to true (which is the default). To delete a role, this must first be set to false.  At that point, in a subsequent call, this role may be removed. | |
| **Origin** | Write | String | Specifies if the app role is defined on the application object or on the servicePrincipal entity. Must not be included in any POST or PATCH requests. Read-only. | |
| **Value** | Write | String | Specifies the value to include in the roles claim in ID tokens and access tokens authenticating an assigned user or service principal. Must not exceed 120 characters in length. Allowed characters are : ! # $ % & ' ( ) * + , - . / :   =       + _    } , and characters in the ranges 0-9, A-Z and a-z. Any other character, including the space character, aren't allowed. May not begin with .. | |

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

