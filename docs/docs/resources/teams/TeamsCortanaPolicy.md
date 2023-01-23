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


## Description

The CsTeamsCortanaPolicy resources enable administrators to control settings for Cortana voice assistant in Microsoft Teams.

## Permissions


