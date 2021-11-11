# SPOOrgAssetsLibrary

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **LibraryUrl** | Key | String | Indicates the absolute URL of the library to be designated as a central location for organization assets. ||
| **CdnType** | Write | String | Specifies the CDN type. The valid values are public or private. |Public, Private|
| **ThumbnailUrl** | Write | String | Indicates the absolute URL of the library to be designated as a central location for organization Indicates the URL of the background image used when the library is publicly displayed. If no thumbnail URL is indicated, the card will have a gray background. ||
| **Ensure** | Write | String | Specify if the SPO Org Assets library should exist or not. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the SharePoint Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for certificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||

# SPOOrgAssetsLibrary

### Description

This resource configures an SharePoint Online Org site assets library.

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
        SPOOrgAssetsLibrary 'ConfigureOrgSiteAssets'
        {
            LibraryUrl   = "https://contoso.sharepoint.com/sites/org/Branding"
            ThumbnailUrl = "https://contoso.sharepoint.com/sites/org/Branding/Logo/Owagroup.png"
            CdnType      = "Public"
            Ensure       = "Present"
            Credential   = $credsGlobalAdmin
        }
    }
}
```

