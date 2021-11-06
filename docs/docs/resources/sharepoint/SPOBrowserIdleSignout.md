# SPOBrowserIdleSignout

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Specifies the resource is a single instance, the value must be 'Yes' |Yes|
| **Enabled** | Write | Boolean | Enables the browser idle sign-out policy ||
| **SignOutAfter** | Write | String | Specifies a time interval of inactivity before the user gets signed out ||
| **WarnAfter** | Write | String | Specifies a time interval of inactivity before the user gets a warning about being signed out ||
| **Credential** | Write | PSCredential | Credentials of the SharePoint Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for certificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||

# SPOBrowserIdleSignout

### Description

This resource configures an SharePoint Online Idle session sign-out policy.

## Azure AD Permissions

To authenticate via Azure Active Directory, this resource required the following Application permissions:

* **Automate**
  * SharePoint
    * Sites.FullControl.All
* **Export**
  * SharePoint
    * Sites.Read.All

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
        SPOBrowserIdleSignout 'ConfigureBrowserIdleSignout'
        {
            IsSingleInstance = "Yes"
            Enabled          = $True
            SignOutAfter     = "04:00:00"
            WarnAfter        = "03:30:00"
            Credential       = $Credsglobaladmin
        }
    }
}
```

