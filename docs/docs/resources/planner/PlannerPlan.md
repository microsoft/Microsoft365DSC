# PlannerPlan

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Title** | Key | String | The Title of the Planner Plan. | |
| **OwnerGroup** | Key | String | Name of Id of the Azure Active Directory Group who owns the plan | |
| **Ensure** | Write | String | Present ensures the Plan exists, absent ensures it is removed | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the account to authenticate with. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource is used to configure the Planner Plans.

* This resource deals with content. Using the Monitoring feature
  of Microsoft365DSC on content resources is not recommended.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Group.Read.All, Tasks.Read

- **Update**

    - Group.Read.All, Tasks.Read, Tasks.ReadWrite

#### Application permissions

- **Read**

    - Group.Read.All, Tasks.Read.All

- **Update**

    - Group.Read.All, Tasks.Read.All, Tasks.ReadWrite.All

## Examples

### Example 1

This example creates a new Plan in Planner.

```powershell
Configuration Example
{
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        PlannerPlan 'ContosoPlannerPlan'
        {
            Title                 = "Contoso Plan"
            OwnerGroup            = "Contoso Group"
            Ensure                = "Present"
            ApplicationId         = "12345-12345-12345-12345-12345"
            TenantId              = "12345-12345-12345-12345-12345"
            CertificateThumbprint = "1234567890"
        }
    }
}
```

