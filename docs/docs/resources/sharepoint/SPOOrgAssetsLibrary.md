# SPOOrgAssetsLibrary

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **LibraryUrl** | Key | String | Indicates the absolute URL of the library to be designated as a central location for organization assets. | |
| **CdnType** | Write | String | Specifies the CDN type. The valid values are public or private. | `Public`, `Private` |
| **ThumbnailUrl** | Write | String | Indicates the absolute URL of the library to be designated as a central location for organization Indicates the URL of the background image used when the library is publicly displayed. If no thumbnail URL is indicated, the card will have a gray background. | |
| **Ensure** | Write | String | Specify if the SPO Org Assets library should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the SharePoint Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for certificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures an SharePoint Online Org site assets library.

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
        SPOOrgAssetsLibrary 'ConfigureOrgSiteAssets'
        {
            LibraryUrl   = "https://contoso.sharepoint.com/sites/org/Branding"
            ThumbnailUrl = "https://contoso.sharepoint.com/sites/org/Branding/Logo/Owagroup.png"
            CdnType      = "Public"
            Ensure       = "Present"
            Credential   = $Credscredential
        }
    }
}
```

