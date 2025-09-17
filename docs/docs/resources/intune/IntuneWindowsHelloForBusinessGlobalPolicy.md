# IntuneWindowsHelloForBusinessGlobalPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Only valid value is 'Yes'. | `Yes` |
| **EnhancedBiometricsState** | Write | String | Controls the ability to use the anti-spoofing features for facial recognition on devices which support it. If set to disabled, anti-spoofing features are not allowed. If set to Not Configured, the user can choose whether they want to use anti-spoofing. Possible values are: notConfigured, enabled, disabled. | `notConfigured`, `enabled`, `disabled` |
| **EnhancedSignInSecurity** | Write | UInt32 | Setting to configure Enhanced sign-in security. Default is Not Configured | |
| **PinExpirationInDays** | Write | UInt32 | Controls the period of time (in days) that a PIN can be used before the system requires the user to change it. This must be set between 0 and 730, inclusive. If set to 0, the user's PIN will never expire | |
| **PinLowercaseCharactersUsage** | Write | String | Controls the ability to use lowercase letters in the Windows Hello for Business PIN.  Allowed permits the use of lowercase letter(s), whereas Required ensures they are present. If set to Not Allowed, lowercase letters will not be permitted. Possible values are: allowed, required, disallowed. | `allowed`, `required`, `disallowed` |
| **PinMaximumLength** | Write | UInt32 | Controls the maximum number of characters allowed for the Windows Hello for Business PIN. This value must be between 4 and 127, inclusive. This value must be greater than or equal to the value set for the minimum PIN. | |
| **PinMinimumLength** | Write | UInt32 | Controls the minimum number of characters required for the Windows Hello for Business PIN.  This value must be between 4 and 127, inclusive, and less than or equal to the value set for the maximum PIN. | |
| **PinPreviousBlockCount** | Write | UInt32 | Controls the ability to prevent users from using past PINs. This must be set between 0 and 50, inclusive, and the current PIN of the user is included in that count. If set to 0, previous PINs are not stored. PIN history is not preserved through a PIN reset. | |
| **PinSpecialCharactersUsage** | Write | String | Controls the ability to use special characters in the Windows Hello for Business PIN.  Allowed permits the use of special character(s), whereas Required ensures they are present. If set to Not Allowed, special character(s) will not be permitted. Possible values are: allowed, required, disallowed. | `allowed`, `required`, `disallowed` |
| **PinUppercaseCharactersUsage** | Write | String | Controls the ability to use uppercase letters in the Windows Hello for Business PIN.  Allowed permits the use of uppercase letter(s), whereas Required ensures they are present. If set to Not Allowed, uppercase letters will not be permitted. Possible values are: allowed, required, disallowed. | `allowed`, `required`, `disallowed` |
| **RemotePassportEnabled** | Write | Boolean | Controls the use of Remote Windows Hello for Business. Remote Windows Hello for Business provides the ability for a portable, registered device to be usable as a companion for desktop authentication. The desktop must be Azure AD joined and the companion device must have a Windows Hello for Business PIN. | |
| **SecurityDeviceRequired** | Write | Boolean | Controls whether to require a Trusted Platform Module (TPM) for provisioning Windows Hello for Business. A TPM provides an additional security benefit in that data stored on it cannot be used on other devices. If set to False, all devices can provision Windows Hello for Business even if there is not a usable TPM. | |
| **SecurityKeyForSignIn** | Write | String | Security key for Sign In provides the capacity for remotely turning ON/OFF Windows Hello Sercurity Keyl Not configured will honor configurations done on the clinet. Possible values are: notConfigured, enabled, disabled. | `notConfigured`, `enabled`, `disabled` |
| **State** | Write | String | Controls whether to allow the device to be configured for Windows Hello for Business. If set to disabled, the user cannot provision Windows Hello for Business except on Azure Active Directory joined mobile phones if otherwise required. If set to Not Configured, Intune will not override client defaults. Possible values are: notConfigured, enabled, disabled. | `notConfigured`, `enabled`, `disabled` |
| **UnlockWithBiometricsEnabled** | Write | Boolean | Controls the use of biometric gestures, such as face and fingerprint, as an alternative to the Windows Hello for Business PIN.  If set to False, biometric gestures are not allowed. Users must still configure a PIN as a backup in case of failures. | |
| **Credential** | Write | PSCredential | Credentials of the Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Intune Windows Hello For Business Global Policy.

**Attention:** Only the export works with app-only authentication. To update the settings, credential authentication is required.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - DeviceManagementServiceConfig.Read.All, DeviceManagementConfiguration.Read.All

- **Update**

    - DeviceManagementServiceConfig.ReadWrite.All, DeviceManagementConfiguration.ReadWrite.All

#### Application permissions

- **Read**

    - DeviceManagementServiceConfig.Read.All, DeviceManagementConfiguration.Read.All

- **Update**

    - DeviceManagementServiceConfig.ReadWrite.All, DeviceManagementConfiguration.ReadWrite.All

## Examples

### Example 1

This example updates the Device Management Compliance Settings

```powershell
Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneWindowsHelloForBusinessGlobalPolicy 'WindowsHelloForBusinessGlobalPolicy'
        {
            EnhancedBiometricsState     = "notConfigured";
            EnhancedSignInSecurity      = 0;
            IsSingleInstance            = "Yes";
            PinExpirationInDays         = 0;
            PinLowercaseCharactersUsage = "disallowed";
            PinMaximumLength            = 127;
            PinMinimumLength            = 6;
            PinPreviousBlockCount       = 0;
            PinSpecialCharactersUsage   = "disallowed";
            PinUppercaseCharactersUsage = "disallowed";
            RemotePassportEnabled       = $True;
            SecurityDeviceRequired      = $False;
            SecurityKeyForSignIn        = "notConfigured";
            State                       = "notConfigured";
            UnlockWithBiometricsEnabled = $True;
            ApplicationId               = $ApplicationId;
            TenantId                    = $TenantId;
            CertificateThumbprint       = $CertificateThumbprint;
        }
    }
}
```

