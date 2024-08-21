# IntuneDeviceEnrollmentLimitRestriction

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | Display name of the device enrollment limit restriction. | |
| **Description** | Write | String | Description of the device enrollment limit restriction. | |
| **Limit** | Write | UInt32 | Specifies the maximum number of devices a user can enroll | |
| **Ensure** | Write | String | Present ensures the restriction exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Intune Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

This resource configures the Intune device enrollment limit restrictions.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - DeviceManagementServiceConfig.Read.All

- **Update**

    - DeviceManagementServiceConfig.ReadWrite.All

#### Application permissions

- **Read**

    - DeviceManagementServiceConfig.Read.All

- **Update**

    - DeviceManagementServiceConfig.ReadWrite.All

## Examples

### Example 1

This example creates a new Device Enrollment Limit Restriction.

```powershell
Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceEnrollmentLimitRestriction 'DeviceEnrollmentLimitRestriction'
        {
            DisplayName = 'My DSC Limit'
            Description = 'My Restriction'
            Limit       = 12
            Ensure      = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

### Example 2

This example creates a new Device Enrollment Limit Restriction.

```powershell
Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceEnrollmentLimitRestriction 'DeviceEnrollmentLimitRestriction'
        {
            DisplayName = 'My DSC Limit'
            Description = 'My Restriction'
            Limit       = 11 # Updated Property
            Ensure      = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

### Example 3

This example creates a new Device Enrollment Limit Restriction.

```powershell
Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceEnrollmentLimitRestriction 'DeviceEnrollmentLimitRestriction'
        {
            DisplayName = 'My DSC Limit'
            Ensure      = 'Absent'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

