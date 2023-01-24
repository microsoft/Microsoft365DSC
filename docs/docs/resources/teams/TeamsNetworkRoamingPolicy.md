# TeamsNetworkRoamingPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | | |
| **AllowIPVideo** | Write | Boolean | Determines whether video is enabled in a user's meetings or calls. Set this to TRUE to allow the user to share their video. Set this to FALSE to prohibit the user from sharing their video. | |
| **Description** | Write | String | Description of the new policy to be created. | |
| **MediaBitRateKb** | Write | UInt64 | Determines the media bit rate for audio/video/app sharing transmissions in meetings. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |


## Description

New-CsTeamsNetworkRoamingPolicy allows IT Admins to create policies for Network Roaming and Bandwidth Control experiences in Microsoft Teams.

## Permissions


