# IntuneSecurityBaselineHoloLens2Standard

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Description** | Write | String | Policy description | |
| **DisplayName** | Key | String | Policy name | |
| **RoleScopeTagIds** | Write | StringArray[] | List of Scope Tags for this Entity instance. | |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |
| **AllowMicrosoftAccountConnection** | Write | String | Allow Microsoft Account Connection (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **VideoPowerDownTimeOutAC_2** | Write | String | Turn off the display (plugged in) (0: Disabled, 1: Enabled) | `0`, `1` |
| **EnterVideoACPowerDownTimeOut** | Write | SInt32 | When plugged in, turn display off after (seconds) - Depends on VideoPowerDownTimeOutAC_2 | |
| **AllowCookies** | Write | String | Allow Cookies (0: Block all cookies from all sites, 1: Block only cookies from third party websites, 2: Allow all cookies from all sites) | `0`, `1`, `2` |
| **AllowPasswordManager** | Write | String | Allow Password Manager (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **AllowSmartScreen** | Write | String | Allow Smart Screen (0: Turned off. Do not protect users from potential threats and prevent users from turning it on., 1: Turned on. Protect users from potential threats and prevent users from turning it off.) | `0`, `1` |
| **AllowUSBConnection** | Write | String | Allow USB Connection (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **DevicePasswordEnabled** | Write | String | Device Password Enabled (0: Enabled, 1: Disabled) | `0`, `1` |
| **DevicePasswordExpiration** | Write | SInt32 | Device Password Expiration - Depends on DevicePasswordEnabled | |
| **MinDevicePasswordLength** | Write | SInt32 | Min Device Password Length - Depends on DevicePasswordEnabled | |
| **AlphanumericDevicePasswordRequired** | Write | String | Alphanumeric Device Password Required - Depends on DevicePasswordEnabled (0: Password or Alphanumeric PIN required., 1: Password or Numeric PIN required., 2: Password, Numeric PIN, or Alphanumeric PIN required.) | `0`, `1`, `2` |
| **MaxDevicePasswordFailedAttempts** | Write | SInt32 | Max Device Password Failed Attempts - Depends on DevicePasswordEnabled | |
| **MinDevicePasswordComplexCharacters** | Write | String | Min Device Password Complex Characters - Depends on DevicePasswordEnabled (1: Digits only, 2: Digits and lowercase letters are required, 3: Digits lowercase letters and uppercase letters are required. Not supported in desktop Microsoft accounts and domain accounts, 4: Digits lowercase letters uppercase letters and special characters are required. Not supported in desktop) | `1`, `2`, `3`, `4` |
| **MaxInactivityTimeDeviceLock** | Write | SInt32 | Max Inactivity Time Device Lock - Depends on DevicePasswordEnabled | |
| **DevicePasswordHistory** | Write | SInt32 | Device Password History - Depends on DevicePasswordEnabled | |
| **AllowSimpleDevicePassword** | Write | String | Allow Simple Device Password - Depends on DevicePasswordEnabled (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **AllowManualMDMUnenrollment** | Write | String | Allow Manual MDM Unenrollment (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **AllowAllTrustedApps** | Write | String | Allow All Trusted Apps (0: Explicit deny., 1: Explicit allow unlock., 65535: Not configured.) | `0`, `1`, `65535` |
| **AllowAppStoreAutoUpdate** | Write | String | Allow apps from the Microsoft app store to auto update (0: Not allowed., 1: Allowed., 2: Not configured.) | `0`, `1`, `2` |
| **AllowDeveloperUnlock** | Write | String | Allow Developer Unlock (0: Explicit deny., 1: Explicit allow unlock., 65535: Not configured.) | `0`, `1`, `65535` |
| **BlockThirdPartyCookies** | Write | String | Block third party cookies (0: Disabled, 1: Enabled) | `0`, `1` |
| **ExtensionInstallBlocklist** | Write | String | Control which extensions cannot be installed (0: Disabled, 1: Enabled) | `0`, `1` |
| **ExtensionInstallBlocklistDesc** | Write | StringArray[] | Extension IDs the user should be prevented from installing (or * for all) (Device) - Depends on ExtensionInstallBlocklist | |
| **PasswordManagerEnabled** | Write | String | Enable saving passwords to the password manager (0: Disabled, 1: Enabled) | `0`, `1` |
| **SmartScreenEnabled** | Write | String | Configure Microsoft Defender SmartScreen (0: Disabled, 1: Enabled) | `0`, `1` |
| **AADGroupMembershipCacheValidityInDays** | Write | SInt32 | AAD Group Membership Cache Validity In Days | |
| **AllowVPN** | Write | String | Allow VPN (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **PageVisibilityList** | Write | String | Page Visibility List | |
| **AllowStorageCard** | Write | String | Allow Storage Card (0: SD card use is not allowed and USB drives are disabled. This setting does not prevent programmatic access to the storage card., 1: Allow a storage card.) | `0`, `1` |
| **EnablePinRecovery** | Write | String | Enable Pin Recovery - Depends on TenantId (false: Disabled, true: Enabled) | `false`, `true` |
| **TPM12** | Write | String | Restrict use of TPM 1.2 - Depends on TenantId (false: Disabled, true: Enabled) | `false`, `true` |
| **Digits** | Write | String | Digits - Depends on TenantId (0: Allows the use of digits in PIN., 1: Requires the use of at least one digits in PIN., 2: Does not allow the use of digits in PIN.) | `0`, `1`, `2` |
| **Expiration** | Write | SInt32 | Expiration - Depends on TenantId | |
| **History** | Write | SInt32 | PIN History - Depends on TenantId | |
| **LowercaseLetters** | Write | String | Lowercase Letters - Depends on TenantId (0: Allows the use of lowercase letters in PIN., 1: Requires the use of at least one lowercase letters in PIN., 2: Does not allow the use of lowercase letters in PIN.) | `0`, `1`, `2` |
| **MaximumPINLength** | Write | SInt32 | Maximum PIN Length - Depends on TenantId | |
| **MinimumPINLength** | Write | SInt32 | Minimum PIN Length - Depends on TenantId | |
| **SpecialCharacters** | Write | String | Special Characters - Depends on TenantId (0: Allows the use of special characters in PIN., 1: Requires the use of at least one special characters in PIN., 2: Does not allow the use of special characters in PIN.) | `0`, `1`, `2` |
| **UppercaseLetters** | Write | String | Uppercase Letters - Depends on TenantId (0: Allows the use of uppercase letters in PIN., 1: Requires the use of at least one uppercase letters in PIN., 2: Does not allow the use of uppercase letters in PIN.) | `0`, `1`, `2` |
| **RequireSecurityDevice** | Write | String | Require Security Device - Depends on TenantId (false: Disabled, true: Enabled) | `false`, `true` |
| **UseCertificateForOnPremAuth** | Write | String | Use Certificate For On Prem Auth - Depends on TenantId (false: Disabled, true: Enabled) | `false`, `true` |
| **UseHelloCertificatesAsSmartCardCertificates** | Write | String | Use Hello Certificates As Smart Card Certificates - Depends on TenantId (false: Disabled, true: Enabled) | `false`, `true` |
| **UsePassportForWork** | Write | String | Use Windows Hello For Business (Device) - Depends on TenantId (false: Disabled, true: Enabled) | `false`, `true` |
| **AllowUpdateService** | Write | String | Allow Update Service (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **ManagePreviewBuilds** | Write | String | Manage Preview Builds (0: Disable Preview builds, 1: Disable Preview builds once the next release is public, 2: Enable Preview builds, 3: Preview builds is left to user selection) | `0`, `1`, `2`, `3` |
| **RequireNetworkInOOBE** | Write | String | Require Network In OOBE (Device) (true: true, false: false) | `true`, `false` |
| **Assignments** | Write | MSFT_DeviceManagementConfigurationPolicyAssignments[] | Represents the assignment to the Intune policy. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_DeviceManagementConfigurationPolicyAssignments

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **dataType** | Write | String | The type of the target assignment. | `#microsoft.graph.groupAssignmentTarget`, `#microsoft.graph.allLicensedUsersAssignmentTarget`, `#microsoft.graph.allDevicesAssignmentTarget`, `#microsoft.graph.exclusionGroupAssignmentTarget`, `#microsoft.graph.configurationManagerCollectionAssignmentTarget` |
| **deviceAndAppManagementAssignmentFilterType** | Write | String | The type of filter of the target assignment i.e. Exclude or Include. Possible values are:none, include, exclude. | `none`, `include`, `exclude` |
| **deviceAndAppManagementAssignmentFilterId** | Write | String | The Id of the filter for the target assignment. | |
| **deviceAndAppManagementAssignmentFilterDisplayName** | Write | String | The display name of the filter for the target assignment. | |
| **groupId** | Write | String | The group Id that is the target of the assignment. | |
| **groupDisplayName** | Write | String | The group Display Name that is the target of the assignment. | |
| **collectionId** | Write | String | The collection Id that is the target of the assignment.(ConfigMgr) | |


## Description

Intune Security Baseline HoloLens2 Standard

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - DeviceManagementConfiguration.Read.All, Group.Read.All

- **Update**

    - Group.Read.All

#### Application permissions

- **Read**

    - DeviceManagementConfiguration.Read.All, Group.Read.All

- **Update**

    - Group.Read.All

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

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
        IntuneSecurityBaselineHoloLens2Standard 'mySecurityBaselineHoloLens2Standard'
        {
            DisplayName                           = 'test'
            AADGroupMembershipCacheValidityInDays = 7;
            PasswordManagerEnabled                = "0";
            VideoPowerDownTimeOutAC_2             = "1";
            Ensure                                = 'Present'
            ApplicationId                         = $ApplicationId
            TenantId                              = $TenantId
            CertificateThumbprint                 = $CertificateThumbprint
        }
    }
}
```

### Example 2

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

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
        IntuneSecurityBaselineHoloLens2Standard 'mySecurityBaselineHoloLens2Standard'
        {
            DisplayName                           = 'test'
            AADGroupMembershipCacheValidityInDays = 8; # Drift
            PasswordManagerEnabled                = "0";
            VideoPowerDownTimeOutAC_2             = "1";
            Ensure                                = 'Present'
            ApplicationId                         = $ApplicationId;
            TenantId                              = $TenantId;
            CertificateThumbprint                 = $CertificateThumbprint;
        }
    }
}
```

### Example 3

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

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
        IntuneSecurityBaselineHoloLens2Standard 'mySecurityBaselineHoloLens2Standard'
        {
            DisplayName           = 'test'
            Ensure                = 'Absent'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

