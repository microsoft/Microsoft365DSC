# TeamsShiftsPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | | |
| **AccessGracePeriodMinutes** | Write | UInt64 | | |
| **AccessType** | Write | String | | |
| **EnableScheduleOwnerPermissions** | Write | Boolean | | |
| **EnableShiftPresence** | Write | Boolean | | |
| **ShiftNoticeFrequency** | Write | String | | |
| **ShiftNoticeMessageCustom** | Write | String | | |
| **ShiftNoticeMessageType** | Write | String | | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |


## Description

This resource allows you to create a new TeamsShiftPolicy instance and set it's properties.

## Permissions


