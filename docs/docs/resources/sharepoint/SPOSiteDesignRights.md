# SPOSiteDesignRights

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **SiteDesignTitle** | Key | String | The title of the site design ||
| **Rights** | Key | String | Rights to grant user principals on site design rights. |View, None|
| **UserPrincipals** | Write | StringArray[] | List of user principals with seperated by commas to site design rights. ||
| **Ensure** | Write | String | Used to add or remove list of users from site design rights. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Office365 Tenant Admin. ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for certificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||

# SPOSiteDesignRights

### Description

This resource configures rights on Site Designs.

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
        SPOSiteDesignRights 'ConfigureSiteDesignRights'
        {
            SiteDesignTitle = "Customer List"
            UserPrincipals  = "jdoe@contoso.onmicrosoft.com"
            Rights          = "View"
            Ensure          = "Present"
            Credential      = $credsGlobalAdmin
        }
    }
}
```

