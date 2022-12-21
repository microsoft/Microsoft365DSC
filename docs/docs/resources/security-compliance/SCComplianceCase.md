# SCComplianceCase

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the unique name of the compliance case. | |
| **Description** | Write | String | The description of the case. | |
| **Ensure** | Write | String | Specify if this case should exist or not. | `Present`, `Absent` |
| **Status** | Write | String | Status for the case. Can either be 'Active' or 'Closed' | `Active`, `Closed` |
| **Credential** | Required | PSCredential | Credentials of the Global Admin Account | |

## Description

This resource configures an eDiscovery Case in Security and Compliance.

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
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SCComplianceCase 'ConfigureComplianceCase'
        {
            Name               = "MyCase"
            Description        = "MyPolicy"
            Status             = "Active"
            Ensure             = "Present"
            Credential         = $credsGlobalAdmin
        }
    }
}
```

