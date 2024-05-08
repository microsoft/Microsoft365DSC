# IntuneDeviceCategory

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | Display name of the device category. | |
| **Description** | Write | String | Description of the device category. | |
| **Ensure** | Write | String | Present ensures the category exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Intune Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

This resource configures the Intune device categories.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - DeviceManagementManagedDevices.Read.All

- **Update**

    - DeviceManagementManagedDevices.ReadWrite.All

#### Application permissions

- **Read**

    - DeviceManagementManagedDevices.Read.All

- **Update**

    - DeviceManagementManagedDevices.ReadWrite.All

## Examples

### Example 1

This example creates a new Device Category.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceCategory 'ConfigureDeviceCategory'
        {
            DisplayName = 'Contoso'
            Description = 'Contoso Category'
            Ensure      = 'Present'
            Credential  = $Credscredential
        }
    }
}
```

### Example 2

This example creates a new Device Category.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceCategory 'ConfigureDeviceCategory'
        {
            DisplayName = 'Contoso'
            Description = 'Contoso Category - Updated' # Updated Property
            Ensure      = 'Present'
            Credential  = $Credscredential
        }
    }
}
```

### Example 3

This example creates a new Device Category.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceCategory 'ConfigureDeviceCategory'
        {
            DisplayName = 'Contoso'
            Ensure      = 'Absent'
            Credential  = $Credscredential
        }
    }
}
```

