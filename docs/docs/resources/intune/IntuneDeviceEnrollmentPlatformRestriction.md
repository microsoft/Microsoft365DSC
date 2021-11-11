# IntuneDeviceEnrollmentPlatformRestriction

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | Display name of the device enrollment platform restriction. ||
| **Description** | Write | String | Description of the device enrollment platform restriction. ||
| **AndroidPlatformBlocked** | Write | Boolean | N/A ||
| **AndroidPersonalDeviceEnrollmentBlocked** | Write | Boolean | N/A ||
| **AndroidOSMinimumVersion** | Write | String | N/A ||
| **AndroidOSMaximumVersion** | Write | String | N/A ||
| **iOSPlatformBlocked** | Write | Boolean | N/A ||
| **iOSPersonalDeviceEnrollmentBlocked** | Write | Boolean | N/A ||
| **iOSOSMinimumVersion** | Write | String | N/A ||
| **iOSOSMaximumVersion** | Write | String | N/A ||
| **MacPlatformBlocked** | Write | Boolean | N/A ||
| **MacPersonalDeviceEnrollmentBlocked** | Write | Boolean | N/A ||
| **MacOSMinimumVersion** | Write | String | N/A ||
| **MacOSMaximumVersion** | Write | String | N/A ||
| **WindowsPlatformBlocked** | Write | Boolean | N/A ||
| **WindowsPersonalDeviceEnrollmentBlocked** | Write | Boolean | N/A ||
| **WindowsOSMinimumVersion** | Write | String | N/A ||
| **WindowsOSMaximumVersion** | Write | String | N/A ||
| **WindowsMobilePlatformBlocked** | Write | Boolean | N/A ||
| **WindowsMobilePersonalDeviceEnrollmentBlocked** | Write | Boolean | N/A ||
| **WindowsMobileOSMinimumVersion** | Write | String | N/A ||
| **WindowsMobileOSMaximumVersion** | Write | String | N/A ||
| **Ensure** | Write | String | Present ensures the restriction exists, absent ensures it is removed. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Intune Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||


# IntuneDeviceEnrollmentPlatformRestriction

This resource configures the Intune device platform enrollment restrictions.

## Examples

### Example 1

This example creates a new Device Enrollment Platform Restriction.

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
        IntuneDeviceEnrollmentPlatformRestriction 'DeviceEnrollmentPlatformRestriction'
        {
            AndroidPersonalDeviceEnrollmentBlocked       = $False
            AndroidPlatformBlocked                       = $False
            Description                                  = ""
            DisplayName                                  = "My DSC Restriction"
            iOSOSMaximumVersion                          = "11.0"
            iOSOSMinimumVersion                          = "9.0"
            iOSPersonalDeviceEnrollmentBlocked           = $False
            iOSPlatformBlocked                           = $False
            MacPersonalDeviceEnrollmentBlocked           = $False
            MacPlatformBlocked                           = $True
            WindowsMobilePersonalDeviceEnrollmentBlocked = $False
            WindowsMobilePlatformBlocked                 = $True
            WindowsPersonalDeviceEnrollmentBlocked       = $True
            WindowsPlatformBlocked                       = $False
            Ensure                                       = "Present"
            Credential                                   = $credsGlobalAdmin
        }
    }
}
```

