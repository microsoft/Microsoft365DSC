# AADAuthenticationMethodPolicySoftware

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **ExcludeTargets** | Write | MSFT_AADAuthenticationMethodPolicySoftwareExcludeTarget[] | Displayname of the groups of users that are excluded from a policy. | |
| **IncludeTargets** | Write | MSFT_AADAuthenticationMethodPolicySoftwareIncludeTarget[] | Displayname of the groups of users that are included from a policy. | |
| **State** | Write | String | The state of the policy. Possible values are: enabled, disabled. | `enabled`, `disabled` |
| **Id** | Key | String | The unique identifier for an entity. Read-only. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_AADAuthenticationMethodPolicySoftwareExcludeTarget

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | The object identifier of an Azure AD group. | |
| **TargetType** | Write | String | The type of the authentication method target. Possible values are: group and unknownFutureValue. | `user`, `group`, `unknownFutureValue` |

### MSFT_AADAuthenticationMethodPolicySoftwareIncludeTarget

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | The object identifier of an Azure AD group. | |
| **TargetType** | Write | String | The type of the authentication method target. Possible values are: group and unknownFutureValue. | `user`, `group`, `unknownFutureValue` |


## Description

Azure AD Authentication Method Policy Software

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Policy.ReadWrite.AuthenticationMethod, Policy.Read.All

- **Update**

    - Policy.ReadWrite.AuthenticationMethod, Policy.Read.All

#### Application permissions

- **Read**

    - Policy.ReadWrite.AuthenticationMethod, Policy.Read.All

- **Update**

    - Policy.ReadWrite.AuthenticationMethod, Policy.Read.All

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
        AADAuthenticationMethodPolicySoftware "AADAuthenticationMethodPolicySoftware-SoftwareOath"
        {
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            Ensure               = "Present";
            ExcludeTargets       = @(
                MSFT_AADAuthenticationMethodPolicySoftwareExcludeTarget{
                    Id = 'Executives'
                    TargetType = 'group'
                }
                MSFT_AADAuthenticationMethodPolicySoftwareExcludeTarget{
                    Id = 'Paralegals'
                    TargetType = 'group'
                }
            );
            Id                   = "SoftwareOath";
            IncludeTargets       = @(
                MSFT_AADAuthenticationMethodPolicySoftwareIncludeTarget{
                    Id = 'Legal Team'
                    TargetType = 'group'
                }
            );
            State                = "enabled"; # Updated Property
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

    Node localhost
    {
        AADAuthenticationMethodPolicySoftware "AADAuthenticationMethodPolicySoftware-SoftwareOath"
        {
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            Ensure                = "Absent";
            Id                    = "SoftwareOath";
        }
    }
}
```

