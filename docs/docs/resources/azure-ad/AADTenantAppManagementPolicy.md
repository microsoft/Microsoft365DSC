# AADTenantAppManagementPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | The display name of the policy. | |
| **Description** | Write | String | The description of the policy. | |
| **IsEnabled** | Write | Boolean | Denotes whether the policy is enabled. | |
| **ApplicationRestrictions** | Write | MSFT_AADTenantAppManagementPolicyRestrictions | Restrictions that apply to an application  object. | |
| **ServicePrincipalRestrictions** | Write | MSFT_AADTenantAppManagementPolicyRestrictions | Restrictions that apply to a service principal  object. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Absent`, `Present` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_AADTenantAppManagementPolicyRestrictionsCredential

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **MaxLifetime** | Write | String | String value that indicates the maximum lifetime for password expiration, defined as an ISO 8601 duration. For example, P4DT12H30M5S represents four days, 12 hours, 30 minutes, and five seconds. This property is required when restrictionType is set to passwordLifetime. | |
| **RestrictForAppsCreatedAfterDateTime** | Write | String | Specifies the date from which the policy restriction applies to newly created applications. For existing applications, the enforcement date can be retroactively applied. | |
| **RestrictionType** | Write | String | The type of restriction being applied. The possible values are: passwordAddition, passwordLifetime, symmetricKeyAddition, symmetricKeyLifetime, customPasswordAddition, and unknownFutureValue. Each value of restrictionType can be used only once per policy. | |
| **State** | Write | String | Indicates whether the restriction is evaluated. The possible values are: enabled, disabled, unknownFutureValue. If enabled, the restriction is evaluated. If disabled, the restriction isn't evaluated or enforced. | |

### MSFT_AADTenantAppManagementPolicyRestrictions

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **KeyCredentials** | Write | MSFT_AADTenantAppManagementPolicyRestrictionsCredential[] | Collection of keyCredential restrictions settings to be applied to an application or service principal. | |
| **PasswordCredentials** | Write | MSFT_AADTenantAppManagementPolicyRestrictionsCredential[] | Collection of password restrictions settings to be applied to an application or service principal. | |


## Description

Tenant-wide application authentication method policy to enforce app management restrictions for all applications and service principals.

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
        AADTenantAppManagementPolicy "AADTenantAppManagementPolicy-Default"
        {
            ApplicationId           = $ApplicationId;
            ApplicationRestrictions = MSFT_AADTenantAppManagementPolicyRestrictions{
                passwordCredentials = @(
                    MSFT_AADTenantAppManagementPolicyRestrictionsCredential{
                        restrictForAppsCreatedAfterDateTime = "1/1/2021 3:37:00 PM"
                        restrictionType = "passwordAddition"
                        state = "enabled"
                    }
                    MSFT_AADTenantAppManagementPolicyRestrictionsCredential{
                        maxLifetime = "P4DT12H30M5S"
                        restrictForAppsCreatedAfterDateTime = "1/1/2001 3:37:00 PM"
                        restrictionType = "passwordLifetime"
                        state = "enabled"
                    }
                    MSFT_AADTenantAppManagementPolicyRestrictionsCredential{
                        restrictForAppsCreatedAfterDateTime = "1/1/2002 3:37:00 PM"
                        restrictionType = "customPasswordAddition"
                        state = "enabled"
                    }
                    MSFT_AADTenantAppManagementPolicyRestrictionsCredential{
                        restrictForAppsCreatedAfterDateTime = "1/1/2003 3:37:00 PM"
                        restrictionType = "symmetricKeyAddition"
                        state = "enabled"
                    }
                    MSFT_AADTenantAppManagementPolicyRestrictionsCredential{
                        maxLifetime = "P40DT0H0M0S"
                        restrictForAppsCreatedAfterDateTime = "1/1/2004 3:37:00 PM"
                        restrictionType = "symmetricKeyLifetime"
                        state = "enabled"
                    }
                )
                keyCredentials = @(
                    MSFT_AADTenantAppManagementPolicyRestrictionsCredential{
                        maxLifetime = "P30DT0H0M0S"
                        restrictForAppsCreatedAfterDateTime = "1/1/2015 3:37:00 PM"
                        restrictionType = "asymmetricKeyLifetime"
                        state = "enabled"
                    }
                )
            };
            CertificateThumbprint   = $CertificateThumbprint;
            Description             = "Default tenant policy that enforces app management restrictions on applications and service principals. To apply policy to targeted resources, create a new policy under appManagementPolicies collection.";
            DisplayName             = "Default app management tenant policy";
            Ensure                  = "Present";
            IsEnabled               = $True;
            TenantId                = $TenantId;
        }
    }
}
```

