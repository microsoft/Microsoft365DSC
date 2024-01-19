﻿# AADAuthenticationMethodPolicyVoice

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsOfficePhoneAllowed** | Write | Boolean | true if users can register office phones, otherwise, false. | |
| **ExcludeTargets** | Write | MSFT_AADAuthenticationMethodPolicyVoiceExcludeTarget[] | Displayname of the groups of users that are excluded from a policy. | |
| **IncludeTargets** | Write | MSFT_AADAuthenticationMethodPolicyVoiceIncludeTarget[] | Displayname of the groups of users that are included from a policy. | |
| **State** | Write | String | The state of the policy. Possible values are: enabled, disabled. | `enabled`, `disabled` |
| **Id** | Key | String | The unique identifier for an entity. Read-only. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

### MSFT_AADAuthenticationMethodPolicyVoiceExcludeTarget

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | The object identifier of an Azure AD group. | |
| **TargetType** | Write | String | The type of the authentication method target. Possible values are: group and unknownFutureValue. | `user`, `group`, `unknownFutureValue` |

### MSFT_AADAuthenticationMethodPolicyVoiceIncludeTarget

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | The object identifier of an Azure AD group. | |
| **TargetType** | Write | String | The type of the authentication method target. Possible values are: group and unknownFutureValue. | `user`, `group`, `unknownFutureValue` |


## Description

Azure AD Authentication Method Policy Voice

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
        AADAuthenticationMethodPolicyVoice "AADAuthenticationMethodPolicyVoice-Voice"
        {
            Credential            = $credsCredential;
            Ensure                = "Absent";
            Id                    = "Voice";
        }
    }
}
```

