# SCFilePlanPropertyDepartment

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the unique name of the department. | |
| **Ensure** | Write | String | Specify if this department should exist or not. | `Present`, `Absent` |
| **Credential** | Required | PSCredential | Credentials of the Exchange Global Admin | |

## Description

This resource configures a department entry for Security and
Compliance File Plans.

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

    Node localhost
    {
        SCFilePlanPropertyDepartment 'FilePlanPropertyDepartment'
        {
            Name               = "Demo Department"
            Ensure             = "Present"
            Credential         = $credsGlobalAdmin
        }
    }
}
```

