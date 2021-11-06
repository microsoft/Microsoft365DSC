# SPOApp

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The name of the App. ||
| **Path** | Key | String | The path the the app package on disk. ||
| **Publish** | Write | Boolean | This will deploy/trust an app into the app catalog. ||
| **Overwrite** | Write | Boolean | Overwrites the existing app package if it already exists. ||
| **Ensure** | Write | String | Present ensures the site collection exists, absent ensures it is removed |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the account to authenticate with. ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for certificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||

## Description

This resource allows users to deploy App instances in the
App Catalog.

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
        SPOApp 'ConfigureDemoApp'
        {
            Identity   = "DemoApp"
            Path       = "C:\Demo\DemoApp.sppkg"
            Publish    = $true
            Ensure     = "Present"
            Credential = $credsGlobalAdmin
        }

        SPOApp 'ConfigureDemoApp2'
        {
            Identity   = "DemoApp2"
            Path       = "C:\Demo\DemoApp2.app"
            Publish    = $true
            Ensure     = "Present"
            Credential = $credsGlobalAdmin
        }
    }
}
```

