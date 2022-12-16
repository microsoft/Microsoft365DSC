# SCDeviceConfigurationPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The name of the Device Configuration Policy. | |
| **Ensure** | Write | String | Specify if this policy should exist or not. | `Present`, `Absent` |
| **Comment** | Write | String | The Comment parameter specifies an optional comment. | |
| **Enabled** | Write | Boolean | The Enabled parameter specifies whether the policy is enabled. | |
| **Credential** | Required | PSCredential | Credentials of Security and Compliance Center Admin | |

## Description

This resource configures a Device Configuration Policy in Security and Compliance.

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

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SCDeviceConfigurationPolicy 'ConfigureDeviceConfigurationPolicy'
        {
            Name                 = "Human Resources"
            Comment              = "Device Configuration Policy for Human Resources department"
            Enabled              = $True
            Ensure               = "Present"
            Credential           = $credsGlobalAdmin
        }
    }
}
```

