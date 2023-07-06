# PlannerBucket

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name of the Planner Bucket. | |
| **PlanId** | Key | String | Id of the Plan to which the bucket is associated with. | |
| **BucketId** | Write | String | Id of the Bucket, if known. | |
| **Ensure** | Write | String | Present ensures the Plan exists, absent ensures it is removed | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the account to authenticate with. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource is used to configure the Planner Buckets.

* This resource deals with content. Using the Monitoring feature
  of Microsoft365DSC on content resources is not recommended.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Tasks.Read

- **Update**

    - Tasks.ReadWrite

#### Application permissions

- **Read**

    - Tasks.Read.All

- **Update**

    - Tasks.ReadWrite.All

## Examples

### Example 1

This example creates a new Planner Bucket in a Plan.

```powershell
Configuration Example
{
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        PlannerBucket 'ContosoPlannerBucket'
        {
            PlanId                = "1234567890"
            Name                  = "Contoso Bucket"
            Ensure                = "Present"
            ApplicationId         = "12345-12345-12345-12345-12345"
            TenantId              = "12345-12345-12345-12345-12345"
            CertificateThumbprint = "1234567890"
        }
    }
}
```

