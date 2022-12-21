# TeamsIPPhonePolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | | |
| **AllowBetterTogether** | Write | String | | |
| **AllowHomeScreen** | Write | String | | |
| **AllowHotDesking** | Write | Boolean | | |
| **Description** | Write | String | | |
| **HotDeskingIdleTimeoutInMinutes** | Write | UInt64 | | |
| **SearchOnCommonAreaPhoneMode** | Write | String | | |
| **SignInMode** | Write | String | | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |


## Description

New-CsTeamsIPPhonePolicy allows you to create a policy to manage features related to Teams phone experiences. Teams phone policies determine the features that are available to users.

## Permissions


