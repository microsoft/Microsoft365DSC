# SPOStorageEntity

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Key** | Key | String | The key of the storage entity. | |
| **EntityScope** | Write | String | Scope of the storage entity. | `Tenant`, `Site` |
| **Value** | Write | String | Value of the storage entity. | |
| **Description** | Write | String | Description of storage entity. | |
| **Comment** | Write | String | Comment for the storage entity. | |
| **Ensure** | Write | String | Used to add or remove storage entity. | `Present`, `Absent` |
| **SiteUrl** | Required | String | The url of site collection or tenant. | |
| **Credential** | Write | PSCredential | Credentials of the Office365 Tenant Admin. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for certificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures Storage Entity for SharePoint Online.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Domain.Read.All

- **Update**

    - Domain.Read.All

#### Application permissions

- **Read**

    - Domain.Read.All

- **Update**

    - Domain.Read.All

### Microsoft SharePoint

To authenticate with the SharePoint API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Sites.FullControl.All

- **Update**

    - Sites.FullControl.All

#### Application permissions

- **Read**

    - Sites.FullControl.All

- **Update**

    - Sites.FullControl.All

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
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SPOStorageEntity 'ConfigureDSCStorageEntity'
        {
            Key         = "DSCKey"
            Value       = "Test storage entity"
            EntityScope = "Tenant"
            Description = "Description created by DSC"
            Comment     = "Comment from DSC"
            SiteUrl     = "https://contoso-admin.sharepoint.com"
            Ensure      = "Present"
            Credential  = $Credscredential
        }
    }
}
```

