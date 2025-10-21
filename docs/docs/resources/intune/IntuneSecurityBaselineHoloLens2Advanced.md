# IntuneSecurityBaselineHoloLens2Advanced

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Description** | Write | String | Policy description | |
| **DisplayName** | Key | String | Policy name | |
| **RoleScopeTagIds** | Write | StringArray[] | List of Scope Tags for this Entity instance. | |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |
| **DeletionPolicy** | Write | SInt32 | Deletion Policy (0: Delete immediately upon device returning to a state with no currently active users, 1: Delete at storage capacity threshold, 2: Delete at both storage capacity threshold and profile inactivity threshold) | `0`, `1`, `2` |
| **EnableProfileManager** | Write | String | Enable Profile Manager (false: False, true: True) | `false`, `true` |
| **ProfileInactivityThreshold** | Write | SInt32 | Profile Inactivity Threshold | |
| **StorageCapacityStartDeletion** | Write | SInt32 | Storage Capacity Start Deletion | |
| **StorageCapacityStopDeletion** | Write | SInt32 | Storage Capacity Stop Deletion | |
| **AllowMicrosoftAccountConnection** | Write | SInt32 | Allow Microsoft Account Connection (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **VideoPowerDownTimeOutAC_2** | Write | SInt32 | Turn off the display (plugged in) (0: Disabled, 1: Enabled) | `0`, `1` |
| **EnterVideoACPowerDownTimeOut** | Write | SInt32 | When plugged in, turn display off after (seconds) - Depends on VideoPowerDownTimeOutAC_2 | |
| **AllowAutofill** | Write | SInt32 | Allow Autofill (0: Prevented/Not allowed., 1: Allowed.) | `0`, `1` |
| **AllowCookies** | Write | SInt32 | Allow Cookies (0: Block all cookies from all sites, 1: Block only cookies from third party websites, 2: Allow all cookies from all sites) | `0`, `1`, `2` |
| **AllowDoNotTrack** | Write | SInt32 | Allow Do Not Track (0: Never send tracking information., 1: Send tracking information.) | `0`, `1` |
| **AllowPasswordManager** | Write | SInt32 | Allow Password Manager (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **AllowPopups** | Write | SInt32 | Allow Popups (0: Turn off Pop-up Blocker letting pop-up windows open., 1: Turn on Pop-up Blocker stopping pop-up windows from opening.) | `0`, `1` |
| **AllowSearchSuggestionsinAddressBar** | Write | SInt32 | Allow Search Suggestionsin Address Bar (0: Prevented/Not allowed. Hide the search suggestions., 1: Allowed. Show the search suggestions.) | `0`, `1` |
| **AllowSmartScreen** | Write | SInt32 | Allow Smart Screen (0: Turned off. Do not protect users from potential threats and prevent users from turning it on., 1: Turned on. Protect users from potential threats and prevent users from turning it off.) | `0`, `1` |
| **AllowBluetooth** | Write | SInt32 | Allow Bluetooth (0: Disallow Bluetooth. If this is set to 0, the radio in the Bluetooth control panel will be grayed out and the user will not be able to turn Bluetooth on., 1: Reserved. If this is set to 1, the radio in the Bluetooth control panel will be functional and the user will be able to turn Bluetooth on., 2: Allow Bluetooth. If this is set to 2, the radio in the Bluetooth control panel will be functional and the user will be able to turn Bluetooth on.) | `0`, `1`, `2` |
| **AllowUSBConnection** | Write | SInt32 | Allow USB Connection (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **DevicePasswordEnabled** | Write | SInt32 | Device Password Enabled (0: Enabled, 1: Disabled) | `0`, `1` |
| **DevicePasswordExpiration** | Write | SInt32 | Device Password Expiration - Depends on DevicePasswordEnabled | |
| **MinDevicePasswordLength** | Write | SInt32 | Min Device Password Length - Depends on DevicePasswordEnabled | |
| **AlphanumericDevicePasswordRequired** | Write | SInt32 | Alphanumeric Device Password Required - Depends on DevicePasswordEnabled (0: Password or Alphanumeric PIN required., 1: Password or Numeric PIN required., 2: Password, Numeric PIN, or Alphanumeric PIN required.) | `0`, `1`, `2` |
| **MaxDevicePasswordFailedAttempts** | Write | SInt32 | Max Device Password Failed Attempts - Depends on DevicePasswordEnabled | |
| **MinDevicePasswordComplexCharacters** | Write | SInt32 | Min Device Password Complex Characters - Depends on DevicePasswordEnabled (1: Digits only, 2: Digits and lowercase letters are required, 3: Digits lowercase letters and uppercase letters are required. Not supported in desktop Microsoft accounts and domain accounts, 4: Digits lowercase letters uppercase letters and special characters are required. Not supported in desktop) | `1`, `2`, `3`, `4` |
| **MaxInactivityTimeDeviceLock** | Write | SInt32 | Max Inactivity Time Device Lock - Depends on DevicePasswordEnabled | |
| **DevicePasswordHistory** | Write | SInt32 | Device Password History - Depends on DevicePasswordEnabled | |
| **AllowSimpleDevicePassword** | Write | SInt32 | Allow Simple Device Password - Depends on DevicePasswordEnabled (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **AllowManualMDMUnenrollment** | Write | SInt32 | Allow Manual MDM Unenrollment (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **AllowAllTrustedApps** | Write | SInt32 | Allow All Trusted Apps (0: Explicit deny., 1: Explicit allow unlock., 65535: Not configured.) | `0`, `1`, `65535` |
| **AllowAppStoreAutoUpdate** | Write | SInt32 | Allow apps from the Microsoft app store to auto update (0: Not allowed., 1: Allowed., 2: Not configured.) | `0`, `1`, `2` |
| **AllowDeveloperUnlock** | Write | SInt32 | Allow Developer Unlock (0: Explicit deny., 1: Explicit allow unlock., 65535: Not configured.) | `0`, `1`, `65535` |
| **BlockThirdPartyCookies** | Write | SInt32 | Block third party cookies (0: Disabled, 1: Enabled) | `0`, `1` |
| **ConfigureDoNotTrack** | Write | SInt32 | Configure Do Not Track (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftEdge_ContentSettings_DefaultPopupsSetting** | Write | SInt32 | Default pop-up window setting (0: Disabled, 1: Enabled) | `0`, `1` |
| **DefaultPopupsSetting_DefaultPopupsSetting** | Write | SInt32 | Default pop-up window setting (Device) - Depends on MicrosoftEdge_ContentSettings_DefaultPopupsSetting (1: Allow all sites to show pop-ups, 2: Do not allow any site to show popups) | `1`, `2` |
| **AutofillAddressEnabled** | Write | SInt32 | Enable AutoFill for addresses (0: Disabled, 1: Enabled) | `0`, `1` |
| **AutofillCreditCardEnabled** | Write | SInt32 | Enable AutoFill for payment instruments (0: Disabled, 1: Enabled) | `0`, `1` |
| **SearchSuggestEnabled** | Write | SInt32 | Enable search suggestions (0: Disabled, 1: Enabled) | `0`, `1` |
| **ExtensionInstallBlocklist** | Write | SInt32 | Control which extensions cannot be installed (0: Disabled, 1: Enabled) | `0`, `1` |
| **ExtensionInstallBlocklistDesc** | Write | StringArray[] | Extension IDs the user should be prevented from installing (or * for all) (Device) - Depends on ExtensionInstallBlocklist | |
| **MicrosoftEdge_PasswordManager_PrimaryPasswordSetting** | Write | SInt32 | Configures a setting that asks users to enter their device password while using password autofill (0: Disabled, 1: Enabled) | `0`, `1` |
| **PrimaryPasswordSetting_PrimaryPasswordSetting** | Write | SInt32 | Configures a setting that asks users to enter their device password while using password autofill (Device) - Depends on MicrosoftEdge_PasswordManager_PrimaryPasswordSetting (0: Automatically, 1: With device password, 2: With custom primary password, 3: Autofill off) | `0`, `1`, `2`, `3` |
| **PasswordManagerEnabled** | Write | SInt32 | Enable saving passwords to the password manager (0: Disabled, 1: Enabled) | `0`, `1` |
| **SmartScreenEnabled** | Write | SInt32 | Configure Microsoft Defender SmartScreen (0: Disabled, 1: Enabled) | `0`, `1` |
| **AADGroupMembershipCacheValidityInDays** | Write | SInt32 | AAD Group Membership Cache Validity In Days | |
| **LetAppsAccessAccountInfo** | Write | SInt32 | Let Apps Access Account Info (0: User in control., 1: Force allow., 2: Force deny.) | `0`, `1`, `2` |
| **LetAppsAccessAccountInfo_ForceAllowTheseApps** | Write | StringArray[] | Let Apps Access Account Info Force Allow These Apps | |
| **LetAppsAccessBackgroundSpatialPerception** | Write | SInt32 | Let Apps Access Background Spatial Perception (0: User in control., 1: Force allow., 2: Force deny.) | `0`, `1`, `2` |
| **LetAppsAccessBackgroundSpatialPerception_ForceAllowTheseApps** | Write | StringArray[] | Let Apps Access Background Spatial Perception Force Allow These Apps | |
| **LetAppsAccessCamera** | Write | SInt32 | Let Apps Access Camera (0: User in control., 1: Force allow., 2: Force deny.) | `0`, `1`, `2` |
| **LetAppsAccessCamera_ForceAllowTheseApps** | Write | StringArray[] | Let Apps Access Camera Force Allow These Apps | |
| **LetAppsAccessMicrophone** | Write | SInt32 | Let Apps Access Microphone (0: User in control., 1: Force allow., 2: Force deny.) | `0`, `1`, `2` |
| **LetAppsAccessMicrophone_ForceAllowTheseApps** | Write | StringArray[] | Let Apps Access Microphone Force Allow These Apps | |
| **AllowSearchToUseLocation** | Write | SInt32 | Allow Search To Use Location (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **AllowAddProvisioningPackage** | Write | SInt32 | Allow Add Provisioning Package (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **AllowVPN** | Write | SInt32 | Allow VPN (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **PageVisibilityList** | Write | String | Page Visibility List | |
| **AllowStorageCard** | Write | SInt32 | Allow Storage Card (0: SD card use is not allowed and USB drives are disabled. This setting does not prevent programmatic access to the storage card., 1: Allow a storage card.) | `0`, `1` |
| **AllowTelemetry** | Write | SInt32 | Allow Telemetry (0: Security. Information that is required to help keep Windows more secure, including data about the Connected User Experience and Telemetry component settings, the Malicious Software Removal Tool, and Windows Defender, 1: Basic. Basic device info, including: quality-related data, app compatibility, app usage data, and data from the Security level, 3: Full. All data necessary to identify and help to fix problems, plus data from the Security, Basic, and Enhanced levels.) | `0`, `1`, `3` |
| **AllowManualWiFiConfiguration** | Write | SInt32 | Allow Manual Wi Fi Configuration (0: No Wi-Fi connection outside of MDM provisioned network is allowed., 1: Adding new network SSIDs beyond the already MDM provisioned ones is allowed.) | `0`, `1` |
| **EnablePinRecovery** | Write | String | Enable Pin Recovery - Depends on TenantId (false: Disabled, true: Enabled) | `false`, `true` |
| **TPM12** | Write | String | Restrict use of TPM 1.2 - Depends on TenantId (false: Disabled, true: Enabled) | `false`, `true` |
| **Digits** | Write | SInt32 | Digits - Depends on TenantId (0: Allows the use of digits in PIN., 1: Requires the use of at least one digits in PIN., 2: Does not allow the use of digits in PIN.) | `0`, `1`, `2` |
| **Expiration** | Write | SInt32 | Expiration - Depends on TenantId | |
| **History** | Write | SInt32 | PIN History - Depends on TenantId | |
| **LowercaseLetters** | Write | SInt32 | Lowercase Letters - Depends on TenantId (0: Allows the use of lowercase letters in PIN., 1: Requires the use of at least one lowercase letters in PIN., 2: Does not allow the use of lowercase letters in PIN.) | `0`, `1`, `2` |
| **MaximumPINLength** | Write | SInt32 | Maximum PIN Length - Depends on TenantId | |
| **MinimumPINLength** | Write | SInt32 | Minimum PIN Length - Depends on TenantId | |
| **SpecialCharacters** | Write | SInt32 | Special Characters - Depends on TenantId (0: Allows the use of special characters in PIN., 1: Requires the use of at least one special characters in PIN., 2: Does not allow the use of special characters in PIN.) | `0`, `1`, `2` |
| **UppercaseLetters** | Write | SInt32 | Uppercase Letters - Depends on TenantId (0: Allows the use of uppercase letters in PIN., 1: Requires the use of at least one uppercase letters in PIN., 2: Does not allow the use of uppercase letters in PIN.) | `0`, `1`, `2` |
| **RequireSecurityDevice** | Write | String | Require Security Device - Depends on TenantId (false: Disabled, true: Enabled) | `false`, `true` |
| **UseCertificateForOnPremAuth** | Write | String | Use Certificate For On Prem Auth - Depends on TenantId (false: Disabled, true: Enabled) | `false`, `true` |
| **UseHelloCertificatesAsSmartCardCertificates** | Write | String | Use Hello Certificates As Smart Card Certificates - Depends on TenantId (false: Disabled, true: Enabled) | `false`, `true` |
| **UsePassportForWork** | Write | String | Use Windows Hello For Business (Device) - Depends on TenantId (false: Disabled, true: Enabled) | `false`, `true` |
| **AllowUpdateService** | Write | SInt32 | Allow Update Service (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **ManagePreviewBuilds** | Write | SInt32 | Manage Preview Builds (0: Disable Preview builds, 1: Disable Preview builds once the next release is public, 2: Enable Preview builds, 3: Preview builds is left to user selection) | `0`, `1`, `2`, `3` |
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
| **dataType** | Write | String | The type of the target assignment. | `#microsoft.graph.cloudPcManagementGroupAssignmentTarget`, `#microsoft.graph.groupAssignmentTarget`, `#microsoft.graph.allLicensedUsersAssignmentTarget`, `#microsoft.graph.allDevicesAssignmentTarget`, `#microsoft.graph.exclusionGroupAssignmentTarget`, `#microsoft.graph.configurationManagerCollectionAssignmentTarget` |
| **deviceAndAppManagementAssignmentFilterType** | Write | String | The type of filter of the target assignment i.e. Exclude or Include. Possible values are:none, include, exclude. | `none`, `include`, `exclude` |
| **deviceAndAppManagementAssignmentFilterId** | Write | String | The Id of the filter for the target assignment. | |
| **deviceAndAppManagementAssignmentFilterDisplayName** | Write | String | The display name of the filter for the target assignment. | |
| **groupId** | Write | String | The group Id that is the target of the assignment. | |
| **groupDisplayName** | Write | String | The group Display Name that is the target of the assignment. | |
| **collectionId** | Write | String | The collection Id that is the target of the assignment.(ConfigMgr) | |


## Description

Intune Security Baseline HoloLens2 Advanced

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - DeviceManagementConfiguration.Read.All, Group.Read.All

- **Update**

    - DeviceManagementConfiguration.ReadWrite.All, Group.Read.All

#### Application permissions

- **Read**

    - DeviceManagementConfiguration.Read.All, Group.Read.All

- **Update**

    - DeviceManagementConfiguration.ReadWrite.All, Group.Read.All

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
        IntuneSecurityBaselineHoloLens2Advanced 'mySecurityBaselineHoloLens2Advanced'
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
        IntuneSecurityBaselineHoloLens2Advanced 'mySecurityBaselineHoloLens2Advanced'
        {
            DisplayName                           = 'test'
            AADGroupMembershipCacheValidityInDays = 8; # Drift
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
        IntuneSecurityBaselineHoloLens2Advanced 'mySecurityBaselineAdvanced'
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

