# IntuneDeviceCategory

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | Display name of the device category. ||
| **Description** | Write | String | Description of the device category. ||
| **Ensure** | Write | String | Present ensures the category exists, absent ensures it is removed. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Intune Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||


# IntuneDeviceCategory

This resource configures the Intune device categories.

## Examples

### Example 1

This example creates a new Device Category.

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
        IntuneDeviceCategory 'ConfigureDeviceCategory'
        {
            DisplayName          = "Contoso"
            Description          = "Contoso Category"
            Ensure               = "Present"
            Credential           = $credsGlobalAdmin
        }
    }
}
```

