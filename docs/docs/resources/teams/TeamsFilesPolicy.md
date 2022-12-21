# TeamsFilesPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | | |
| **NativeFileEntryPoints** | Write | String | | |
| **SPChannelFilesTab** | Write | String | | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |


## Description


New-CsTeamsFilesPolicy [-Identity] <string> [-NativeFileEntryPoints <string>] [-SPChannelFilesTab <string>] [-MsftInternalProcessingMode <string>] [-WhatIf] [-Confirm] [<CommonParameters>]


## Permissions


