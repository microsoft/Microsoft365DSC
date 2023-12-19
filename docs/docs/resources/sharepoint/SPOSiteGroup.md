# SPOSiteGroup

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The name of the site group | |
| **Url** | Key | String | The URL of the site. | |
| **Owner** | Write | String | The owner (email address) of the site group | |
| **PermissionLevels** | Write | StringArray[] | The permission level of the site group | |
| **Ensure** | Write | String | Used to add or remove site design. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Office365 Tenant Admin. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for certificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |


## Description

Configure groups for a SharePoint Online site.

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
        SPOSiteGroup 'ConfigureTestSiteGroup1'
        {
            Url              = "https://contoso.sharepoint.com/sites/testsite1"
            Identity         = "TestSiteGroup1"
            Owner            = "admin@contoso.onmicrosoft.com"
            PermissionLevels = @("Edit", "Read")
            Ensure           = "Present"
            Credential       = $Credscredential
        }

        SPOSiteGroup 'ConfigureTestSiteGroup2'
        {
            Url              = "https://contoso.sharepoint.com/sites/testsite1"
            Identity         = "TestSiteGroup2"
            Owner            = "admin@contoso.onmicrosoft.com"
            PermissionLevels = @("Edit", "Read")
            Ensure           = "Present"
            Credential       = $Credscredential
        }
    }
}
```

