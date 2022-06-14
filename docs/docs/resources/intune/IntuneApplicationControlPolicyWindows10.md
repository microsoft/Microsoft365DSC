# IntuneApplicationControlPolicyWindows10

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | Display name of the endpoint protection application control policy for Windows 10. | |
| **Description** | Write | String | Description of the endpoint protection application control policy for Windows 10. | |
| **AppLockerApplicationControl** | Write | String | App locker application control mode | `notConfigured`, `enforceComponentsAndStoreApps`, `auditComponentsAndStoreApps`, `enforceComponentsStoreAppsAndSmartlocker`, `auditComponentsStoreAppsAndSmartlocker` |
| **SmartScreenBlockOverrideForFiles** | Write | Boolean | Indicates whether or not SmartScreen will not present an option for the user to disregard the warning and run the app. | |
| **SmartScreenEnableInshell** | Write | Boolean | Enforce the use of SmartScreen for all users. | |
| **Ensure** | Write | String | Present ensures the site collection exists, absent ensures it is removed | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Intune Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |


## Description

This resource configures a Intune Endpoint Protection Application Control policy for an Windows 10 Device.

## Permissions


## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneApplicationControlPolicyWindows10 'ConfigureApplicationControlPolicyWindows10'
        {
            DisplayName                      = "Windows 10 Desktops"
            Description                      = "All windows 10 Desktops"
            AppLockerApplicationControl      = "enforceComponentsAndStoreApps"
            SmartScreenBlockOverrideForFiles = $True
            SmartScreenEnableInShell         = $True
            Ensure                           = "Present"
            Credential                       = $credsGlobalAdmin
        }
    }
}
```

