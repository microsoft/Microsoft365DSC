# IntuneDeviceCleanupRule

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Only valid value is 'Yes'. | `Yes` |
| **Enabled** | Key | Boolean | Indicates whether the cleanup rule is enabled. | |
| **DeviceInactivityBeforeRetirementInDays** | Write | UInt32 | Number of days until Intune devices are deleted. Minimum: 30, Maximum: 270. | |
| **Ensure** | Write | String | Present ensures the category exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Intune Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |


## Description

This resource configures the Intune device cleanup rule.

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

This example sets the device cleanup rule.

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
        IntuneDeviceCleanupRule 'Example'
        {
            Enabled                                = $true
            IsSingleInstance                       = 'Yes'
            DeviceInactivityBeforeRetirementInDays = 25 # Updated Property
            Ensure                                 = 'Present'
            Credential                             = $Credscredential
        }
    }
}
```

