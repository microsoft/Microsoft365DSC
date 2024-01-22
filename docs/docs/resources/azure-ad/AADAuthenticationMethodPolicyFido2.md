# AADAuthenticationMethodPolicyFido2

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsAttestationEnforced** | Write | Boolean | Determines whether attestation must be enforced for FIDO2 security key registration. | |
| **IsSelfServiceRegistrationAllowed** | Write | Boolean | Determines if users can register new FIDO2 security keys. | |
| **KeyRestrictions** | Write | MSFT_MicrosoftGraphfido2KeyRestrictions | Controls whether key restrictions are enforced on FIDO2 security keys, either allowing or disallowing certain key types as defined by Authenticator Attestation GUID (AAGUID), an identifier that indicates the type (e.g. make and model) of the authenticator. | |
| **ExcludeTargets** | Write | MSFT_AADAuthenticationMethodPolicyFido2ExcludeTarget[] | Displayname of the groups of users that are excluded from a policy. | |
| **IncludeTargets** | Write | MSFT_AADAuthenticationMethodPolicyFido2IncludeTarget[] | Displayname of the groups of users that are included from a policy. | |
| **State** | Write | String | The state of the policy. Possible values are: enabled, disabled. | `enabled`, `disabled` |
| **Id** | Key | String | The unique identifier for an entity. Read-only. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

### MSFT_MicrosoftGraphFido2KeyRestrictions

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **AaGuids** | Write | StringArray[] | A collection of Authenticator Attestation GUIDs. AADGUIDs define key types and manufacturers. | |
| **EnforcementType** | Write | String | Enforcement type. Possible values are: allow, block. | `allow`, `block`, `unknownFutureValue` |
| **IsEnforced** | Write | Boolean | Determines if the configured key enforcement is enabled. | |

### MSFT_AADAuthenticationMethodPolicyFido2ExcludeTarget

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | The object identifier of an Azure AD group. | |
| **TargetType** | Write | String | The type of the authentication method target. Possible values are: group and unknownFutureValue. | `user`, `group`, `unknownFutureValue` |

### MSFT_AADAuthenticationMethodPolicyFido2IncludeTarget

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | The object identifier of an Azure AD group. | |
| **TargetType** | Write | String | The type of the authentication method target. Possible values are: group and unknownFutureValue. | `user`, `group`, `unknownFutureValue` |


## Description

Azure AD Authentication Method Policy Fido2

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
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsCredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        AADAuthenticationMethodPolicyFido2 "AADAuthenticationMethodPolicyFido2-Fido2"
        {
            Credential                       = $Credscredential;
            Ensure                           = "Present";
            ExcludeTargets                   = @(
                MSFT_AADAuthenticationMethodPolicyFido2ExcludeTarget{
                    Id = 'Paralegals'
                    TargetType = 'group'
                }
                MSFT_AADAuthenticationMethodPolicyFido2ExcludeTarget{
                    Id = 'Executives'
                    TargetType = 'group'
                }
            );
            Id                               = "Fido2";
            IncludeTargets                   = @(
                MSFT_AADAuthenticationMethodPolicyFido2IncludeTarget{
                    Id = 'all_users'
                    TargetType = 'group'
                }
            );
            IsAttestationEnforced            = $False;
            IsSelfServiceRegistrationAllowed = $True;
            KeyRestrictions                  = MSFT_MicrosoftGraphfido2KeyRestrictions{
                IsEnforced = $False
                EnforcementType = 'block'
                AaGuids = @()
            };
            State                            = "enabled"; # Updated Property
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
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        param
        (
            [Parameter(Mandatory = $true)]
            [PSCredential]
            $credsCredential
        )
        AADAuthenticationMethodPolicyFido2 "AADAuthenticationMethodPolicyFido2-Fido2"
        {
            Ensure                           = "Absent";
            Id                               = "Fido2";
            Credential                       = $credsCredential;
        }
    }
}
```

