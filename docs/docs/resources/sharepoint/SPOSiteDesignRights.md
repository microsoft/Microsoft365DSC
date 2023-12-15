# SPOSiteDesignRights

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **SiteDesignTitle** | Key | String | The title of the site design | |
| **Rights** | Key | String | Rights to grant user principals on site design rights. | `View`, `None` |
| **UserPrincipals** | Write | StringArray[] | List of user principals with seperated by commas to site design rights. | |
| **Ensure** | Write | String | Used to add or remove list of users from site design rights. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Office365 Tenant Admin. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for certificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures rights on Site Designs.

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
        SPOSiteDesignRights 'ConfigureSiteDesignRights'
        {
            SiteDesignTitle = "Customer List"
            UserPrincipals  = "jdoe@contoso.onmicrosoft.com"
            Rights          = "View"
            Ensure          = "Present"
            Credential      = $Credscredential
        }
    }
}
```

