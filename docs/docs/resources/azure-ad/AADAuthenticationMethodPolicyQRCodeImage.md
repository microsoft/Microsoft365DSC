# AADAuthenticationMethodPolicyQRCodeImage

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Key | String | The unique identifier for an entity. Read-only. | |
| **ExcludeTargets** | Write | MSFT_AADAuthenticationMethodPolicyQRCodeImageExcludeTarget[] | Displayname of the groups of users that are excluded from a policy. | |
| **IncludeTargets** | Write | MSFT_AADAuthenticationMethodPolicyQRCodeImageIncludeTarget[] | Displayname of the groups of users that are included from a policy. | |
| **State** | Write | String | The state of the policy. Possible values are: enabled, disabled. | `enabled`, `disabled` |
| **StandardQRCodeLifetimeInDays** | Write | UInt32 | Lifetime in days of the qr code. | |
| **PinLength** | Write | UInt32 | Length of the PIN. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Absent`, `Present` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_AADAuthenticationMethodPolicyQRCodeImageExcludeTarget

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | The object identifier of an Azure AD group. | |
| **TargetType** | Write | String | The type of the authentication method target. Possible values are: group and unknownFutureValue. | `user`, `group`, `unknownFutureValue` |

### MSFT_AADAuthenticationMethodPolicyQRCodeImageIncludeTarget

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | The object identifier of an Azure AD group. | |
| **TargetType** | Write | String | The type of the authentication method target. Possible values are: group and unknownFutureValue. | `user`, `group`, `unknownFutureValue` |


## Description

This resource configures an Azure AD Authentication Method Policy QR Code Image.

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
    node localhost
    {
        AADAuthenticationMethodPolicyQRCodeImage "AADAuthenticationMethodPolicyQRCodeImage-QRCodePin"
        {
            ApplicationId                = $ApplicationId;
            CertificateThumbprint        = $CertificateThumbprint;
            Ensure                       = "Present";
            Id                           = "QRCodePin";
            IncludeTargets               = @(
                MSFT_AADAuthenticationMethodPolicyQRCodeImageIncludeTarget{
                    Id = "all_users"
                    TargetType = "group"
                }
            );
            PinLength                    = 9; # Drift
            StandardQRCodeLifetimeInDays = 365;
            State                        = "disabled";
            TenantId                     = $TenantId;
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
        AADAuthenticationMethodPolicyQRCodeImage "AADAuthenticationMethodPolicyQRCodeImage-QRCodePin"
        {
            ApplicationId                = $ApplicationId;
            CertificateThumbprint        = $CertificateThumbprint;
            Ensure                       = "Absent";
            Id                           = "QRCodePin";
            IncludeTargets               = @(
                MSFT_AADAuthenticationMethodPolicyQRCodeImageIncludeTarget{
                    Id = "all_users"
                    TargetType = "group"
                }
            );
            PinLength                    = 9; # Drift
            StandardQRCodeLifetimeInDays = 365;
            State                        = "disabled";
            TenantId                     = $TenantId;
        }
    }
}
```

