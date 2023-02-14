# TeamsFeedbackPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **UserInitiatedMode** | Write | String | | |
| **ReceiveSurveysMode** | Write | String | | |
| **AllowScreenshotCollection** | Write | Boolean | | |
| **AllowEmailCollection** | Write | Boolean | | |
| **AllowLogCollection** | Write | Boolean | | |
| **EnableFeatureSuggestions** | Write | Boolean | | |
| **Identity** | Key | String | | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |


## Description


New-CsTeamsFeedbackPolicy [-Identity] <string> [-UserInitiatedMode <string>] [-ReceiveSurveysMode <string>] [-AllowScreenshotCollection <bool>] [-AllowEmailCollection <bool>] [-AllowLogCollection <bool>] [-EnableFeatureSuggestions <bool>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]


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

    - None

- **Update**

    - None


