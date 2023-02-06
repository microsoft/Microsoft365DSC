# TeamsMobilityPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Specify the name of the policy that you are creating. | |
| **Description** | Write | String | Enables administrators to provide explanatory text about the policy. For example, the Description might indicate the users the policy should be assigned to. | |
| **IPAudioMobileMode** | Write | String | When set to WifiOnly, prohibits the user from making and receiving calls or joining meetings using VoIP calls on the mobile device while on a cellular data connection. Possible values are: WifiOnly, AllNetworks. | `WifiOnly`, `AllNetworks` |
| **IPVideoMobileMode** | Write | String | When set to WifiOnly, prohibits the user from making and receiving video calls or enabling video in meetings using VoIP calls on the mobile device while on a cellular data connection. Possible values are: WifiOnly, AllNetworks. | `WifiOnly`, `AllNetworks` |
| **MobileDialerPreference** | Write | String | N/A | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |


## Description

The TeamsMobilityPolicy allows Admins to control Teams mobile usage for users.

## Permissions


