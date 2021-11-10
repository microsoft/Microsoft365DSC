# SPOPropertyBag

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Url** | Key | String | Url of the site where to configure the PropertyBag property. ||
| **Key** | Key | String | Key that should be configured. ||
| **Value** | Key | String | Value of the assigned key. ||
| **Ensure** | Write | String | Specify if this policy should exist or not. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Global Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for certificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||

# SPOPropertyBag

### Description

Configures a value in a site's property bag.

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
        SPOPropertyBag 'ConfigurePropertyBag'
        {
            Url        = "https://contoso.sharepoint.com/sites/Marketing"
            Key        = "MyKey"
            Value      = "MyValue"
            Ensure     = "Present"
            Credential = $credsGlobalAdmin
        }
    }
}
```

