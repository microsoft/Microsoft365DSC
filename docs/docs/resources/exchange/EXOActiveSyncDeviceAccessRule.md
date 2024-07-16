# EXOActiveSyncDeviceAccessRule

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the identity of the device access rule. | |
| **AccessLevel** | Write | String | The AccessLevel parameter specifies whether the devices are allowed, blocked or quarantined. | `Allow`, `Block`, `Quarantine` |
| **Characteristic** | Write | String | The Characteristic parameter specifies the device characteristic or category that's used by the rule. | `DeviceModel`, `DeviceType`, `DeviceOS`, `UserAgent`, `XMSWLHeader` |
| **QueryString** | Write | String | The QueryString parameter specifies the device identifier that's used by the rule. This parameter uses a text value that's used with Characteristic parameter value to define the device. | |
| **Ensure** | Write | String | Specify if the Active Sync Device Access Rule should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

This resource configures Active Sync Device Access Rules in Exchange Online.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Organization Client Access, View-Only Configuration

#### Role Groups

- Organization Management

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

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
        EXOActiveSyncDeviceAccessRule 'ConfigureActiveSyncDeviceAccessRule'
        {
            Identity             = "ContosoPhone(DeviceOS)"
            Characteristic       = "DeviceOS"
            QueryString          = "iOS 6.1 10B146"
            AccessLevel          = "Allow"
            Ensure               = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
```

### Example 2

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

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
        EXOActiveSyncDeviceAccessRule 'ConfigureActiveSyncDeviceAccessRule'
        {
            Identity             = "ContosoPhone(DeviceOS)"
            Characteristic       = "DeviceModel" # Updated Property
            QueryString          = "iOS 6.1 10B145"
            AccessLevel          = "Allow"
            Ensure               = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
```

### Example 3

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

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
        EXOActiveSyncDeviceAccessRule 'ConfigureActiveSyncDeviceAccessRule'
        {
            Identity             = "ContosoPhone(DeviceOS)"
            Characteristic       = "DeviceModel" # Updated Property
            QueryString          = "iOS 6.1 10B145"
            AccessLevel          = "Allow"
            Ensure               = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
```

