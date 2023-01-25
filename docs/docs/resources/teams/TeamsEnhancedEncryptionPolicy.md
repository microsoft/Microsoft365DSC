# TeamsEnhancedEncryptionPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Unique identifier assigned to the Teams enhanced encryption policy. | |
| **CallingEndtoEndEncryptionEnabledType** | Write | String | Determines whether End-to-end encrypted calling is available for the user in Teams. Set this to DisabledUserOverride to allow user to turn on End-to-end encrypted calls. Set this to Disabled to prohibit. | |
| **Description** | Write | String | Enables administrators to provide explanatory text to accompany a Teams enhanced encryption policy. | |
| **MeetingEndToEndEncryption** | Write | String | N/A | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |


## Description

Use this resource to create a new Teams enhanced encryption policy.

## Permissions


