# AADAuthenticationRequirement

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **PerUserMfaState** | Write | String | The state of the MFA enablement for the user. Possible values are: enabled, disabled. | `enabled`, `disabled` |
| **UserPrincipalName** | Key | String | The unique identifier for an entity. Read-only. | |
| **Credential** | Write | PSCredential | Credentials of the Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Azure AD Authentication Requirement Resource to set up Per-User MFA settings

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - UserAuthenticationMethod.Read.All

- **Update**

    - UserAuthenticationMethod.ReadWrite.All

#### Application permissions

- **Read**

    - UserAuthenticationMethod.Read.All

- **Update**

    - UserAuthenticationMethod.ReadWrite.All

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

    Node localhost
    {
        AADAuthenticationRequirement "AADAuthenticationRequirement-TestMailbox109@xtasdftestorg.onmicrosoft.com"
        {
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            PerUserMfaState       = "disabled";
            UserPrincipalName     = "TestMailbox109@$OrganizationName";
        }
    }
}
```

