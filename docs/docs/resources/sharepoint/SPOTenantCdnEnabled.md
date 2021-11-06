# SPOTenantCdnEnabled

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **CdnType** | Key | String | Specifies the CDN type. The valid values are public or private. |Public, Private|
| **Enable** | Write | Boolean | Specify to enable or disable tenant CDN. ||
| **Ensure** | Write | String | Get-PNPTenantCdnEnabled always returns a value, only support value is Present |Present|
| **Credential** | Write | PSCredential | Credentials of the SharePoint Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for certificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||

# SPOTenantCdnEnabled

### Description

This resource enables / disables SharePoint online CDN

* Not supported in GCC High

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
        SPOTenantCdnEnabled 'ConfigureCDN'
        {
            Enable     = $True
            CdnType    = "Public"
            Ensure     = "Present"
            Credential = $credsGlobalAdmin
        }

    }
}
```

