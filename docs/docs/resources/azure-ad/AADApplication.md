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
| **OptionalClaims** | Write | MSFT_MicrosoftGraphoptionalClaims | Application developers can configure optional claims in their Microsoft Entra applications to specify the claims that are sent to their application by the Microsoft security token service. For more information, see How to: Provide optional claims to your app. | |
| **Api** | Write | MSFT_MicrosoftGraphapiApplication | Specifies settings for an application that implements a web API. | |
| **AuthenticationBehaviors** | Write | MSFT_MicrosoftGraphauthenticationBehaviors | The collection of breaking change behaviors related to token issuance that are configured for the application. Authentication behaviors are unset by default (null) and must be explicitly enabled or disabled. Nullable. Returned only on $select.  For more information about authentication behaviors, see Manage application authenticationBehaviors to avoid unverified use of email claims for user identification or authorization. | |
| **PasswordCredentials** | Write | MSFT_MicrosoftGraphpasswordCredential[] | The collection of password credentials associated with the application. Not nullable. | |
| **KeyCredentials** | Write | MSFT_MicrosoftGraphkeyCredential[] | The collection of key credentials associated with the application. Not nullable. Supports $filter (eq, not, ge, le). | |
| **AppRoles** | Write | MSFT_MicrosoftGraphappRole[] | The collection of roles defined for the application. With app role assignments, these roles can be assigned to users, groups, or service principals associated with other applications. Not nullable. | |
| **LogoutURL** | Write | String | The logout url for this application. | |
| **PublicClient** | Write | Boolean | Specifies whether this application is a public client (such as an installed application running on a mobile device). Default is false. | |
| **ReplyURLs** | Write | StringArray[] | Specifies the URLs that user tokens are sent to for sign in, or the redirect URIs that OAuth 2.0 authorization codes and access tokens are sent to. | |
| **Owners** | Write | StringArray[] | UPN or ObjectID values of the app's owners. | |
| **OnPremisesPublishing** | Write | MSFT_AADApplicationOnPremisesPublishing | Represents the set of properties required for configuring Application Proxy for this application. Configuring these properties allows you to publish your on-premises application for secure remote access. | |
| **Ensure** | Write | String | Specify if the Azure AD App should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials for the Microsoft Graph delegated permissions. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **Permissions** | Write | MSFT_AADApplicationPermission[] | API permissions for the Azure Active Directory Application. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_AADApplicationOnPremisesPublishingSegmentCORS

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **allowedHeaders** | Write | StringArray[] | The request headers that the origin domain may specify on the CORS request. The wildcard character * indicates that any header beginning with the specified prefix is allowed. | |
| **maxAgeInSeconds** | Write | UInt32 | The maximum amount of time that a browser should cache the response to the preflight OPTIONS request. | |
| **resource** | Write | String | Resource within the application segment for which CORS permissions are granted. / grants permission for whole app segment. | |
| **allowedMethods** | Write | StringArray[] | The HTTP request methods that the origin domain may use for a CORS request. | |
| **allowedOrigins** | Write | StringArray[] | The origin domains that are permitted to make a request against the service via CORS. The origin domain is the domain from which the request originates. The origin must be an exact case-sensitive match with the origin that the user age sends to the service. | |

### MSFT_AADApplicationOnPremisesPublishingSegment

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **alternateUrl** | Write | String | If you're configuring a traffic manager in front of multiple App Proxy application segments, contains the user-friendly URL that will point to the traffic manager. | |
| **corsConfigurations** | Write | MSFT_AADApplicationOnPremisesPublishingSegmentCORS[] | CORS Rule definition for a particular application segment. | |
| **externalUrl** | Write | String | The published external URL for the application segment; for example, https://intranet.contoso.com./ | |
| **internalUrl** | Write | String | The internal URL of the application segment; for example, https://intranet/. | |

### MSFT_AADApplicationOnPremisesPublishingSingleSignOnSettingKerberos

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **kerberosServicePrincipalName** | Write | String | The Internal Application SPN of the application server. This SPN needs to be in the list of services to which the connector can present delegated credentials. | |
| **kerberosSignOnMappingAttributeType** | Write | String | The Delegated Login Identity for the connector to use on behalf of your users. For more information, see Working with different on-premises and cloud identities . Possible values are: userPrincipalName, onPremisesUserPrincipalName, userPrincipalUsername, onPremisesUserPrincipalUsername, onPremisesSAMAccountName. | |

### MSFT_AADApplicationOnPremisesPublishingSingleSignOnSetting

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **singleSignOnMode** | Write | String | The preferred single-sign on mode for the application. Possible values are: none, onPremisesKerberos, aadHeaderBased,pingHeaderBased, oAuthToken. | |
| **kerberosSignOnSettings** | Write | MSFT_AADApplicationOnPremisesPublishingSingleSignOnSettingKerberos | The Kerberos Constrained Delegation settings for applications that use Integrated Window Authentication. | |

### MSFT_AADApplicationOnPremisesPublishing

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **alternateUrl** | Write | String | If you're configuring a traffic manager in front of multiple App Proxy applications, the alternateUrl is the user-friendly URL that points to the traffic manager. | |
| **applicationServerTimeout** | Write | String | The duration the connector waits for a response from the backend application before closing the connection. Possible values are default, long. | |
| **externalAuthenticationType** | Write | String | Details the pre-authentication setting for the application. Pre-authentication enforces that users must authenticate before accessing the app. Pass through doesn't require authentication. Possible values are: passthru, aadPreAuthentication. | |
| **externalUrl** | Write | String | The published external url for the application. For example, https://intranet-contoso.msappproxy.net/. | |
| **internalUrl** | Write | String | The internal url of the application. For example, https://intranet/. | |
| **isBackendCertificateValidationEnabled** | Write | Boolean | Indicates whether backend SSL certificate validation is enabled for the application. For all new Application Proxy apps, the property is set to true by default. For all existing apps, the property is set to false. | |
| **isHttpOnlyCookieEnabled** | Write | Boolean | Indicates if the HTTPOnly cookie flag should be set in the HTTP response headers. Set this value to true to have Application Proxy cookies include the HTTPOnly flag in the HTTP response headers. If using Remote Desktop Services, set this value to False. Default value is false. | |
| **isPersistentCookieEnabled** | Write | Boolean | Indicates if the Persistent cookie flag should be set in the HTTP response headers. Keep this value set to false. Only use this setting for applications that can't share cookies between processes. For more information about cookie settings, see Cookie settings for accessing on-premises applications in Microsoft Entra ID. Default value is false. | |
| **isSecureCookieEnabled** | Write | Boolean | Indicates if the Secure cookie flag should be set in the HTTP response headers. Set this value to true to transmit cookies over a secure channel such as an encrypted HTTPS request. Default value is true. | |
| **isStateSessionEnabled** | Write | Boolean | Indicates whether validation of the state parameter when the client uses the OAuth 2.0 authorization code grant flow is enabled. This setting allows admins to specify whether they want to enable CSRF protection for their apps. | |
| **isTranslateHostHeaderEnabled** | Write | Boolean | Indicates if the application should translate urls in the response headers. Keep this value as true unless your application required the original host header in the authentication request. Default value is true. | |
| **isTranslateLinksInBodyEnabled** | Write | Boolean | Indicates if the application should translate urls in the application body. Keep this value as false unless you have hardcoded HTML links to other on-premises applications and don't use custom domains. For more information, see Link translation with Application Proxy. Default value is false. | |
| **onPremisesApplicationSegments** | Write | MSFT_AADApplicationOnPremisesPublishingSegment[] | Represents the collection of application segments for an on-premises wildcard application that's published through Microsoft Entra application proxy. | |
| **singleSignOnSettings** | Write | MSFT_AADApplicationOnPremisesPublishingSingleSignOnSetting | Represents the single sign-on configuration for the on-premises application. | |

### MSFT_AADApplicationPermission

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Write | String | Name of the requested permission. | |
| **SourceAPI** | Write | String | Name of the API from which the permission comes from. | |
| **Type** | Write | String | Type of permission. | `AppOnly`, `Delegated` |
| **AdminConsentGranted** | Write | Boolean | Represented whether or not the Admin consent been granted on the app. | |

### MSFT_MicrosoftGraphOptionalClaims

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **AccessToken** | Write | MSFT_MicrosoftGraphOptionalClaim[] | The optional claims returned in the JWT access token. | |
| **IdToken** | Write | MSFT_MicrosoftGraphOptionalClaim[] | The optional claims returned in the JWT ID token. | |
| **Saml2Token** | Write | MSFT_MicrosoftGraphOptionalClaim[] | The optional claims returned in the SAML token. | |

### MSFT_MicrosoftGraphOptionalClaim

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Essential** | Write | Boolean | If the value is true, the claim specified by the client is necessary to ensure a smooth authorization experience for the specific task requested by the end user. The default value is false. | |
| **Name** | Write | String | The name of the optional claim. | |
| **Source** | Write | String | The source (directory object) of the claim. There are predefined claims and user-defined claims from extension properties. If the source value is null, the claim is a predefined optional claim. If the source value is user, the value in the name property is the extension property from the user object. | |

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

