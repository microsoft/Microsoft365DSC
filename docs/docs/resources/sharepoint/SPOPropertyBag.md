# SPOPropertyBag

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Url** | Key | String | Url of the site where to configure the PropertyBag property. | |
| **Key** | Key | String | Key that should be configured. | |
| **Value** | Key | String | Value of the assigned key. | |
| **Ensure** | Write | String | Specify if this policy should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for certificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

Configures a value in a site's property bag.

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
        SPOPropertyBag 'ConfigurePropertyBag'
        {
            Url        = "https://contoso.sharepoint.com/sites/Marketing"
            Key        = "MyKey"
            Value      = "MyValue"
            Ensure     = "Present"
            Credential = $Credscredential
        }
    }
}
```

