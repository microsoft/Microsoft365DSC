﻿# IntuneDeviceEnrollmentLimitRestriction

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | Display name of the device enrollment limit restriction. ||
| **Description** | Write | String | Description of the device enrollment limit restriction. ||
| **Limit** | Write | UInt32 | Specifies the maximum number of devices a user can enroll ||
| **Ensure** | Write | String | Present ensures the restriction exists, absent ensures it is removed. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Intune Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||


# IntuneDeviceEnrollmentLimitRestriction

### Description

This resource configures the Intune device enrollment limit restrictions.

## Examples

### Example 1

This example creates a new Device Enrollment Limit Restriction.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceEnrollmentLimitRestriction 'DeviceEnrollmentLimitRestriction'
        {
            Description          = "My Restriction"
            DisplayName          = "My DSC Limit"
            Limit                = 12
            Ensure               = "Present"
            Credential           = $credsGlobalAdmin
        }
    }
}
```

