# AADAppManagementPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | The display name of the policy. | |
| **Id** | Write | String | Id of the policy. | |
| **Description** | Required | String | The description of the policy. | |
| **IsEnabled** | Write | Boolean | Denotes whether the policy is enabled. | |
| **Restrictions** | Write | MSFT_AADAppManagementPolicyRestrictions | Restrictions that apply to an application or service principal object. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Absent`, `Present` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_AADAppManagementPolicyRestrictionsCredential

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **MaxLifetime** | Write | String | String value that indicates the maximum lifetime for password expiration, defined as an ISO 8601 duration. For example, P4DT12H30M5S represents four days, 12 hours, 30 minutes, and five seconds. This property is required when restrictionType is set to passwordLifetime. | |
| **RestrictForAppsCreatedAfterDateTime** | Write | String | Specifies the date from which the policy restriction applies to newly created applications. For existing applications, the enforcement date can be retroactively applied. | |
| **RestrictionType** | Write | String | The type of restriction being applied. The possible values are: passwordAddition, passwordLifetime, symmetricKeyAddition, symmetricKeyLifetime, customPasswordAddition, and unknownFutureValue. Each value of restrictionType can be used only once per policy. | |
| **State** | Write | String | Indicates whether the restriction is evaluated. The possible values are: enabled, disabled, unknownFutureValue. If enabled, the restriction is evaluated. If disabled, the restriction isn't evaluated or enforced. | |

### MSFT_AADAppManagementPolicyRestrictions

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **KeyCredentials** | Write | MSFT_AADAppManagementPolicyRestrictionsCredential[] | Collection of keyCredential restrictions settings to be applied to an application or service principal. | |
| **PasswordCredentials** | Write | MSFT_AADAppManagementPolicyRestrictionsCredential[] | Collection of password restrictions settings to be applied to an application or service principal. | |


## Description

Manages an app management policy that can be assigned to an application or service principal object.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Policy.Read.ApplicationConfiguration

- **Update**

    - Policy.ReadWrite.ApplicationConfiguration

#### Application permissions

- **Read**

    - Policy.Read.ApplicationConfiguration

- **Update**

    - Policy.ReadWrite.ApplicationConfiguration

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
        AADAppManagementPolicy "MyAppManagementPolicy"
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            Description           = "Cred policy";
            DisplayName           = "AppManagementPolicy";
            Ensure                = "Present";
            IsEnabled             = $True;
            Restrictions          = MSFT_AADAppManagementPolicyRestrictions{
                passwordCredentials = @(
                    MSFT_AADAppManagementPolicyRestrictionsCredential{
                        restrictForAppsCreatedAfterDateTime = "01/01/0001 00:00:00"
                        restrictionType = "passwordAddition"
                        state = "enabled"
                    }
                    MSFT_AADAppManagementPolicyRestrictionsCredential{
                        maxLifetime = "P90DT0H0M0S"
                        restrictForAppsCreatedAfterDateTime = "01/01/0001 00:00:00"
                        restrictionType = "passwordLifetime"
                        state = "enabled"
                    }
                    MSFT_AADAppManagementPolicyRestrictionsCredential{
                        restrictForAppsCreatedAfterDateTime = "01/01/0001 00:00:00"
                        restrictionType = "symmetricKeyAddition"
                        state = "enabled"
                    }
                    MSFT_AADAppManagementPolicyRestrictionsCredential{
                        maxLifetime = "P90DT0H0M0S"
                        restrictForAppsCreatedAfterDateTime = "01/01/0001 00:00:00"
                        restrictionType = "symmetricKeyLifetime"
                        state = "enabled"
                    }
                )
            };
            TenantId              = $TenantId;
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
        AADAppManagementPolicy "MyAppManagementPolicy"
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            Description           = "Cred policy";
            DisplayName           = "AppManagementPolicy";
            Ensure                = "Present";
            IsEnabled             = $True;
            Restrictions          = MSFT_AADAppManagementPolicyRestrictions{
                passwordCredentials = @(
                    MSFT_AADAppManagementPolicyRestrictionsCredential{
                        restrictForAppsCreatedAfterDateTime = "01/01/0001 00:00:00"
                        restrictionType = "passwordAddition"
                        state = "disabled" # Drift
                    }
                    MSFT_AADAppManagementPolicyRestrictionsCredential{
                        maxLifetime = "P90DT0H0M0S"
                        restrictForAppsCreatedAfterDateTime = "01/01/0001 00:00:00"
                        restrictionType = "passwordLifetime"
                        state = "enabled"
                    }
                    MSFT_AADAppManagementPolicyRestrictionsCredential{
                        restrictForAppsCreatedAfterDateTime = "01/01/0001 00:00:00"
                        restrictionType = "symmetricKeyAddition"
                        state = "enabled"
                    }
                    MSFT_AADAppManagementPolicyRestrictionsCredential{
                        maxLifetime = "P90DT0H0M0S"
                        restrictForAppsCreatedAfterDateTime = "01/01/0001 00:00:00"
                        restrictionType = "symmetricKeyLifetime"
                        state = "enabled"
                    }
                )
            };
            TenantId              = $TenantId;
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
        AADAppManagementPolicy "MyAppManagementPolicy"
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            Description           = "Cred policy";
            DisplayName           = "AppManagementPolicy";
            Ensure                = "Absent";
            TenantId              = $TenantId;
        }
    }
}
```

