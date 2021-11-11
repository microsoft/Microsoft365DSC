# SPOSiteDesign

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Title** | Key | String | The title of the site design. ||
| **SiteScriptNames** | Write | StringArray[] | The names of the site design scripts. ||
| **WebTemplate** | Write | String | Web template to which the site design is applied to when invoked. |CommunicationSite, TeamSite, GrouplessTeamSite|
| **Description** | Write | String | Description of site design. ||
| **IsDefault** | Write | Boolean | Is site design applied by default to web templates. ||
| **PreviewImageAltText** | Write | String | Site design alternate preview image text. ||
| **PreviewImageUrl** | Write | String | Site design preview image url. ||
| **Version** | Write | UInt32 | Site design version number. ||
| **Ensure** | Write | String | Used to add or remove site design. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Office365 Tenant Admin. ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for certificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||

# SPOSiteDesign

### Description

This resource configures Site Designs.

## Azure AD Permissions

To authenticate via Azure Active Directory, this resource required the following Application permissions:

* **Automate**
  * SharePoint
    * Sites.FullControl.All
* **Export**
  * SharePoint
    * Sites.FullControl.All

NOTE: All permisions listed above require admin consent.


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
        SPOSiteDesign 'ConfigureSiteDesign'
        {
            Title               = "DSC Site Design"
            SiteScriptNames     = @("Cust List", "List_Views")
            WebTemplate         = "TeamSite"
            IsDefault           = $false
            Description         = "Created by DSC"
            PreviewImageAltText = "Office 365"
            Ensure              = "Present"
            Credential          = $credsGlobalAdmin
        }
    }
}
```

