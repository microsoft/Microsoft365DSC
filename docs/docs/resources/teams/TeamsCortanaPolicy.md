# TeamsCortanaPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Unique identifier for Teams cortana policy you're creating. | |
| **CortanaVoiceInvocationMode** | Write | String | The value of this field indicates if Cortana is enabled and mode of invocation. | `Disabled`, `PushToTalkUserOverride`, `WakeWordPushToTalkUserOverride` |
| **Description** | Write | String | Provide a description of your policy to identify purpose of creating it. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

The CsTeamsCortanaPolicy resources enable administrators to control settings for Cortana voice assistant in Microsoft Teams.

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

    - Organization.Read.All

- **Update**

    - Organization.Read.All

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        TeamsCortanaPolicy 'Example'
        {
            CortanaVoiceInvocationMode       = "WakeWordPushToTalkUserOverride";
            Credential                       = $Credscredential;
            Ensure                           = "Present";
            Identity                         = "Global";
        }
    }
}
```

