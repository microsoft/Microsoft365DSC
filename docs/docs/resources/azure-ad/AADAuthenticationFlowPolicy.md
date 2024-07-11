# AADAuthenticationFlowPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Only valid value is 'Yes'. | `Yes` |
| **Id** | Write | String | Unique identifier of the Authentication Flow Policy. | |
| **DisplayName** | Write | String | Display name of the Authentication Flow Policy. | |
| **Description** | Write | String | Description of the Authentication Flow Policy. | |
| **SelfServiceSignUpEnabled** | Write | String | Indicates whether self-service sign-up flow is enabled or disabled. The default value is false. This property isn't a key. Required. | |
| **Credential** | Write | PSCredential | Credentials of the Azure Active Directory Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

Represents the policy configuration of self-service sign-up experience at a tenant level that lets external users request to sign up for approval. It contains information, such as the identifier, display name, and description, and indicates whether self-service sign-up is enabled for the policy.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - None

- **Update**

    - None

#### Application permissions

- **Read**

    - Policy.Read.All

- **Update**

    - Policy.ReadWrite.AuthenticationFlows

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example {
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

    Node Localhost
    {
        AADAuthenticationFlowPolicy "AADAuthenticationFlowPolicy"
        {
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            Description              = "Authentication flows policy allows modification of settings related to authentication flows in AAD tenant, such as self-service sign up configuration.";
            DisplayName              = "Authentication flows policy";
            Id                       = "authenticationFlowsPolicy";
            IsSingleInstance         = "Yes";
            SelfServiceSignUpEnabled = $True;
        }
    }
}
```

