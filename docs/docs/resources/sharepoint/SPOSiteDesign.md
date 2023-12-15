# SPOSiteDesign

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Title** | Key | String | The title of the site design. | |
| **SiteScriptNames** | Write | StringArray[] | The names of the site design scripts. | |
| **WebTemplate** | Write | String | Web template to which the site design is applied to when invoked. | `CommunicationSite`, `TeamSite`, `GrouplessTeamSite` |
| **Description** | Write | String | Description of site design. | |
| **IsDefault** | Write | Boolean | Is site design applied by default to web templates. | |
| **PreviewImageAltText** | Write | String | Site design alternate preview image text. | |
| **PreviewImageUrl** | Write | String | Site design preview image url. | |
| **Version** | Write | UInt32 | Site design version number. | |
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

This resource configures Site Designs.

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
        SPOSiteDesign 'ConfigureSiteDesign'
        {
            Title               = "DSC Site Design"
            SiteScriptNames     = @("Cust List", "List_Views")
            WebTemplate         = "TeamSite"
            IsDefault           = $false
            Description         = "Created by DSC"
            PreviewImageAltText = "Office 365"
            Ensure              = "Present"
            Credential          = $Credscredential
        }
    }
}
```

