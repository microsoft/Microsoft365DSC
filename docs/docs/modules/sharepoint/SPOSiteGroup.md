# SPOSiteGroup

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The name of the site group ||
| **Url** | Key | String | The URL of the site. ||
| **Owner** | Write | String | The owner (email address) of the site group ||
| **PermissionLevels** | Write | StringArray[] | The permission level of the site group ||
| **Ensure** | Write | String | Used to add or remove site design. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Office365 Tenant Admin. ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for certificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||


# SPOSiteGroup

Configure groups for a SharePoint Online site.

## Azure AD Permissions

To authenticate via Azure Active Directory, this resource required the following Application permissions:

* **Automate**
  * SharePoint
    * Sites.FullControl.All
* **Export**
  * SharePoint
    * Sites.FullControl.All

NOTE: All permissions listed above require admin consent.

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
        SPOSiteGroup ee4a977d-4d7d-4968-9238-2a1702aa699c
        {
            Url                                         = "https://office365dsc.sharepoint.com/sites/testsite1"
            Identity                                    = "TestSiteGroup1"
            Owner                                       = "admin@Office365DSC.onmicrosoft.com"
            PermissionLevels                            = @("Edit", "Read")
            Ensure                                      = "Present"
            Credential                                  = $credsGlobalAdmin
        }

        SPOSiteGroup adfd6217-29de-4297-95d4-7004455d3daa
        {
            Url                                         = "https://office365dsc.sharepoint.com/sites/testsite1"
            Identity                                    = "TestSiteGroup2"
            Owner                                       = "admin@Office365DSC.onmicrosoft.com"
            PermissionLevels                            = @("Edit", "Read")
            Ensure                                      = "Present"
            Credential                                  = $credsGlobalAdmin
        }
    }
}
```

