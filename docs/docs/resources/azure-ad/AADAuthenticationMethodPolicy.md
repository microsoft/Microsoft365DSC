# AADAuthenticationMethodPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Description** | Write | String | A description of the policy. | |
| **DisplayName** | Key | String | The name of the policy. | |
| **PolicyMigrationState** | Write | String | The state of migration of the authentication methods policy from the legacy multifactor authentication and self-service password reset (SSPR) policies. The possible values are: premigration - means the authentication methods policy is used for authentication only, legacy policies are respected. migrationInProgress - means the authentication methods policy is used for both authenication and SSPR, legacy policies are respected. migrationComplete - means the authentication methods policy is used for authentication and SSPR, legacy policies are ignored. unknownFutureValue - Evolvable enumeration sentinel value. Do not use. | `preMigration`, `migrationInProgress`, `migrationComplete`, `unknownFutureValue` |
| **PolicyVersion** | Write | String | The version of the policy in use. | |
| **ReconfirmationInDays** | Write | UInt32 | Days before the user will be asked to reconfirm their method. | |
| **RegistrationEnforcement** | Write | MSFT_MicrosoftGraphregistrationEnforcement | Enforce registration at sign-in time. This property can be used to remind users to set up targeted authentication methods. | |
| **SystemCredentialPreferences** | Write | MSFT_MicrosoftGraphsystemCredentialPreferences | Prompt users with their most-preferred credential for multifactor authentication. | |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

### MSFT_MicrosoftGraphRegistrationEnforcement

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **AuthenticationMethodsRegistrationCampaign** | Write | MSFT_MicrosoftGraphAuthenticationMethodsRegistrationCampaign | Run campaigns to remind users to setup targeted authentication methods. | |

### MSFT_MicrosoftGraphAuthenticationMethodsRegistrationCampaign

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **ExcludeTargets** | Write | MSFT_MicrosoftGraphExcludeTarget[] | Users and groups of users that are excluded from being prompted to set up the authentication method. | |
| **IncludeTargets** | Write | MSFT_MicrosoftGraphAuthenticationMethodsRegistrationCampaignIncludeTarget[] | Users and groups of users that are prompted to set up the authentication method. | |
| **SnoozeDurationInDays** | Write | UInt32 | Specifies the number of days that the user sees a prompt again if they select 'Not now' and snoozes the prompt. Minimum 0 days. Maximum: 14 days. If the value is '0'  The user is prompted during every MFA attempt. | |
| **State** | Write | String | Enable or disable the feature. Possible values are: default, enabled, disabled, unknownFutureValue. The default value is used when the configuration hasn't been explicitly set and uses the default behavior of Azure AD for the setting. The default value is disabled. | `default`, `enabled`, `disabled`, `unknownFutureValue` |

### MSFT_AADAuthenticationMethodPolicyExcludeTarget

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | The object identifier of an Azure AD group. | |
| **TargetType** | Write | String | The type of the authentication method target. Possible values are: group and unknownFutureValue. | `user`, `group`, `unknownFutureValue` |

### MSFT_AADAuthenticationMethodPolicyIncludeTarget

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | The ID of the entity targeted. | |
| **TargetType** | Write | String | The kind of entity targeted. Possible values are: user, group. | `user`, `group`, `unknownFutureValue` |

### MSFT_MicrosoftGraphExcludeTarget

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | The object identifier of an Azure AD user or group. | |
| **TargetType** | Write | String | The type of the authentication method target. Possible values are: user, group, unknownFutureValue. | `user`, `group`, `unknownFutureValue` |

### MSFT_MicrosoftGraphAuthenticationMethodsRegistrationCampaignIncludeTarget

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | The object identifier of an Azure AD user or group. | |
| **TargetedAuthenticationMethod** | Write | String | The authentication method that the user is prompted to register. The value must be microsoftAuthenticator. | |
| **TargetType** | Write | String | The type of the authentication method target. Possible values are: user, group, unknownFutureValue. | `user`, `group`, `unknownFutureValue` |

### MSFT_MicrosoftGraphSystemCredentialPreferences

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **ExcludeTargets** | Write | MSFT_AADAuthenticationMethodPolicyExcludeTarget[] | Users and groups excluded from the preferred authentication method experience of the system. | |
| **IncludeTargets** | Write | MSFT_AADAuthenticationMethodPolicyIncludeTarget[] | Users and groups included in the preferred authentication method experience of the system. | |
| **State** | Write | String | Indicates whether the feature is enabled or disabled. Possible values are: default, enabled, disabled, unknownFutureValue. The default value is used when the configuration hasn't been explicitly set, and uses the default behavior of Azure Active Directory for the setting. The default value is disabled. | `default`, `enabled`, `disabled`, `unknownFutureValue` |


## Description

Azure AD Authentication Method Policy

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Policy.ReadWrite.AuthenticationMethod

- **Update**

    - Policy.ReadWrite.AuthenticationMethod

#### Application permissions

- **Read**

    - Policy.ReadWrite.AuthenticationMethod

- **Update**

    - Policy.ReadWrite.AuthenticationMethod

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsCredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        AADAuthenticationMethodPolicy "AADAuthenticationMethodPolicy-Authentication Methods Policy"
        {
            Description             = "The tenant-wide policy that controls which authentication methods are allowed in the tenant, authentication method registration requirements, and self-service password reset settings";
            DisplayName             = "Authentication Methods Policy";
            Ensure                  = "Present";
            Id                      = "authenticationMethodsPolicy";
            PolicyMigrationState    = "preMigration";
            PolicyVersion           = "1.4";
            RegistrationEnforcement = MSFT_MicrosoftGraphregistrationEnforcement{
                AuthenticationMethodsRegistrationCampaign = MSFT_MicrosoftGraphAuthenticationMethodsRegistrationCampaign{
                    SnoozeDurationInDays = 1
                    IncludeTargets = @(
                        MSFT_MicrosoftGraphAuthenticationMethodsRegistrationCampaignIncludeTarget{
                            TargetedAuthenticationMethod = 'microsoftAuthenticator'
                            TargetType = 'group'
                            Id = 'all_users'
                        }
                    )
                    State = 'default'
                }
            };
            Credential           = $credsCredential;
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
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsCredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        AADAuthenticationMethodPolicy "AADAuthenticationMethodPolicy-Authentication Methods Policy"
        {
            Description             = "The tenant-wide policy that controls which authentication methods are allowed in the tenant, authentication method registration requirements, and self-service password reset settings";
            DisplayName             = "Authentication Methods Policy";
            Ensure                  = "Present";
            Id                      = "authenticationMethodsPolicy";
            PolicyMigrationState    = "migrationComplete"; # Updated Property
            PolicyVersion           = "1.4";
            RegistrationEnforcement = MSFT_MicrosoftGraphregistrationEnforcement{
                AuthenticationMethodsRegistrationCampaign = MSFT_MicrosoftGraphAuthenticationMethodsRegistrationCampaign{
                    SnoozeDurationInDays = 1
                    IncludeTargets = @(
                        MSFT_MicrosoftGraphAuthenticationMethodsRegistrationCampaignIncludeTarget{
                            TargetedAuthenticationMethod = 'microsoftAuthenticator'
                            TargetType = 'group'
                            Id = 'all_users'
                        }
                    )
                    State = 'default'
                }
            };
            Credential           = $credsCredential;
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
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsCredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        AADAuthenticationMethodPolicy "AADAuthenticationMethodPolicy-Authentication Methods Policy"
        {
            Description             = "The tenant-wide policy that controls which authentication methods are allowed in the tenant, authentication method registration requirements, and self-service password reset settings";
            DisplayName             = "Authentication Methods Policy";
            Ensure                  = "Absent";
            Id                      = "authenticationMethodsPolicy";
            Credential              = $credsCredential;
        }
    }
}
```

