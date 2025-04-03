# IntuneAppProtectionPolicyAndroid

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | Display name of the Android App Protection Policy. | |
| **Description** | Write | String | Description of the Android App Protection Policy. | |
| **AllowedAndroidDeviceModels** | Write | StringArray[] | List of allowed Android device models. | |
| **AllowedOutboundClipboardSharingExceptionLength** | Write | UInt32 | Maximum length of outbound clipboard sharing exceptions. | |
| **BiometricAuthenticationBlocked** | Write | Boolean | Indicates whether biometric authentication is blocked. | |
| **BlockAfterCompanyPortalUpdateDeferralInDays** | Write | UInt32 | Number of days to block access after a company portal update deferral. | |
| **BlockDataIngestionIntoOrganizationDocuments** | Write | Boolean | Indicates whether data ingestion into organization documents is blocked. | |
| **ConnectToVpnOnLaunch** | Write | Boolean | Indicates whether to connect to VPN on launch. | |
| **CustomDialerAppDisplayName** | Write | String | Display name of the custom dialer app. | |
| **CustomDialerAppPackageId** | Write | String | Package ID of the custom dialer app. | |
| **DeviceLockRequired** | Write | Boolean | Indicates whether device lock is required. | |
| **FingerprintAndBiometricEnabled** | Write | Boolean | Indicates whether fingerprint and biometric authentication are enabled. | |
| **KeyboardsRestricted** | Write | Boolean | Indicates whether keyboards are restricted. | |
| **MessagingRedirectAppDisplayName** | Write | String | Display name of the messaging redirect app. | |
| **MessagingRedirectAppPackageId** | Write | String | Package ID of the messaging redirect app. | |
| **MinimumWipePatchVersion** | Write | String | Minimum required patch version for wipe. | |
| **PreviousPinBlockCount** | Write | UInt32 | Number of previous PIN block counts. | |
| **WarnAfterCompanyPortalUpdateDeferralInDays** | Write | UInt32 | Number of days to warn after a company portal update deferral. | |
| **WipeAfterCompanyPortalUpdateDeferralInDays** | Write | UInt32 | Number of days to wipe after a company portal update deferral. | |
| **Alloweddataingestionlocations** | Write | StringArray[] | Sources from which data is allowed to be transferred. | |
| **AppActionIfAndroidDeviceManufacturerNotAllowed** | Write | String | Defines a managed app behavior, either block or wipe, if the specified device manufacturer is not allowed. | `block`, `wipe`, `warn`, `blockWhenSettingIsSupported` |
| **AppActionIfAndroidDeviceModelNotAllowed** | Write | String | Defines a managed app behavior, either block or wipe, if the specified device model is not allowed. | `block`, `wipe`, `warn`, `blockWhenSettingIsSupported` |
| **AppActionIfAndroidSafetyNetAppsVerificationFailed** | Write | String | Defines a managed app behavior, either warn or block, if the specified Android App Verification requirement fails. | `block`, `wipe`, `warn`, `blockWhenSettingIsSupported` |
| **AppActionIfAndroidSafetyNetDeviceAttestationFailed** | Write | String | Defines a managed app behavior, either warn or block, if the specified Android SafetyNet Attestation requirement fails. | `block`, `wipe`, `warn`, `blockWhenSettingIsSupported` |
| **AppActionIfDeviceComplianceRequired** | Write | String | Defines a managed app behavior, either block or wipe, when the device is either rooted or jailbroken, if DeviceComplianceRequired is set to true. | `block`, `wipe`, `warn`, `blockWhenSettingIsSupported` |
| **AppActionIfDeviceLockNotSet** | Write | String | Defines a managed app behavior, either warn, block, or wipe, if the screen lock is required on an Android device but is not set. | `block`, `wipe`, `warn`, `blockWhenSettingIsSupported` |
| **AppActionIfMaximumPinRetriesExceeded** | Write | String | Defines a managed app behavior, either block or wipe, based on the maximum number of incorrect pin retry attempts. | `block`, `wipe`, `warn`, `blockWhenSettingIsSupported` |
| **appActionIfUnableToAuthenticateUser** | Write | String | Specifies what action to take in the case where the user is unable to check in because their authentication token is invalid, such as when the user is deleted or disabled in Azure AD. | `block`, `wipe`, `warn`, `blockWhenSettingIsSupported` |
| **MobileThreatDefenseRemediationAction** | Write | String | Determines what action to take if the mobile threat defense threat threshold isn't met. Warn isn't a supported value for this property. | `block`, `wipe`, `warn`, `blockWhenSettingIsSupported` |
| **DialerRestrictionLevel** | Write | String | The classes of dialer apps that are allowed to click-to-open a phone number. Inherited from managedAppProtection. | `allApps`, `managedApps`, `customApp`, `blocked` |
| **MaximumAllowedDeviceThreatLevel** | Write | String | Maximum allowed device threat level, as reported by the MTD app. Inherited from managedAppProtection. | `notConfigured`, `secured`, `low`, `medium`, `high` |
| **NotificationRestriction** | Write | String | Specify app notification restriction. Inherited from managedAppProtection. | `allow`, `blockOrganizationalData`, `block` |
| **ProtectedMessagingRedirectAppType** | Write | String | Defines how app messaging redirection is protected by an App Protection Policy. Default is anyApp. Inherited from managedAppProtection. | `anyApp`, `anyManagedApp`, `specificApps`, `blocked` |
| **RequiredAndroidSafetyNetAppsVerificationType** | Write | String | Defines the Android SafetyNet Apps Verification requirement for a managed app to work. | `none`, `enabled` |
| **RequiredAndroidSafetyNetDeviceAttestationType** | Write | String | Defines the Android SafetyNet Device Attestation requirement for a managed app to work. | `none`, `basicIntegrity`, `basicIntegrityAndDeviceCertification` |
| **RequiredAndroidSafetyNetEvaluationType** | Write | String | Defines the Android SafetyNet evaluation type requirement for a managed app to work. | `basic`, `hardwareBacked` |
| **TargetedAppManagementLevels** | Write | String | The intended app management levels for this policy. Inherited from targetedManagedAppProtection. | `unspecified`, `unmanaged`, `mdm`, `androidEnterprise`, `androidEnterpriseDedicatedDevicesWithAzureAdSharedMode`, `androidOpenSourceProjectUserAssociated`, `androidOpenSourceProjectUserless`, `unknownFutureValue` |
| **ApprovedKeyboards** | Write | StringArray[] | If Keyboard Restriction is enabled, only keyboards in this approved list will be allowed. A key should be Android package id for a keyboard and value should be a friendly name. | |
| **ExemptedAppPackages** | Write | StringArray[] | App packages in this list will be exempt from the policy and will be able to receive data from managed apps. | |
| **PeriodOfflineBeforeAccessCheck** | Write | String | The period after which access is checked when the device is not connected to the internet. | |
| **PeriodOnlineBeforeAccessCheck** | Write | String | The period after which access is checked when the device is connected to the internet. | |
| **AllowedInboundDataTransferSources** | Write | String | Sources from which data is allowed to be transferred. Possible values are: allApps, managedApps, none. | `allApps`, `managedApps`, `none` |
| **AllowedOutboundDataTransferDestinations** | Write | String | Destinations to which data is allowed to be transferred. Possible values are: allApps, managedApps, none. | `allApps`, `managedApps`, `none` |
| **OrganizationalCredentialsRequired** | Write | Boolean | Indicates whether organizational credentials are required for app use. | |
| **AllowedOutboundClipboardSharingLevel** | Write | String | The level to which the clipboard may be shared between apps on the managed device. Possible values are: allApps, managedAppsWithPasteIn, managedApps, blocked. | `allApps`, `managedAppsWithPasteIn`, `managedApps`, `blocked` |
| **DataBackupBlocked** | Write | Boolean | Indicates whether the backup of a managed app's data is blocked. | |
| **DeviceComplianceRequired** | Write | Boolean | Indicates whether device compliance is required. | |
| **ManagedBrowserToOpenLinksRequired** | Write | Boolean | Indicates whether internet links should be opened in the managed browser app, or any custom browser specified by CustomBrowserProtocol (for Android) or CustomBrowserPackageId/CustomBrowserDisplayName (for Android). | |
| **SaveAsBlocked** | Write | Boolean | Indicates whether users may use the Save As menu item to save a copy of protected files. | |
| **PeriodOfflineBeforeWipeIsEnforced** | Write | String | The amount of time an app is allowed to remain disconnected from the internet before all managed data it is wiped. | |
| **PinRequired** | Write | Boolean | Indicates whether an app-level pin is required. | |
| **DisableAppPinIfDevicePinIsSet** | Write | Boolean | Indicates whether use of the app pin is required if the device pin is set. | |
| **MaximumPinRetries** | Write | UInt32 | Maximum number of incorrect pin retry attempts before the managed app is either blocked or wiped. | |
| **SimplePinBlocked** | Write | Boolean | Block simple PIN and require complex PIN to be set. | |
| **MinimumPinLength** | Write | UInt32 | Minimum pin length required for an app-level pin if PinRequired is set to True. | |
| **PinCharacterSet** | Write | String | Character set which may be used for an app-level pin if PinRequired is set to True. Possible values are: numeric, alphanumericAndSymbol. | `numeric`, `alphanumericAndSymbol` |
| **AllowedDataStorageLocations** | Write | StringArray[] | Data storage locations where a user may store managed data. | |
| **ContactSyncBlocked** | Write | Boolean | Indicates whether contacts can be synced to the user's device. | |
| **PeriodBeforePinReset** | Write | String | TimePeriod before the all-level pin must be reset if PinRequired is set to True. | |
| **PrintBlocked** | Write | Boolean | Indicates whether printing is allowed from managed apps. | |
| **RequireClass3Biometrics** | Write | Boolean | Require user to apply Class 3 Biometrics on their Android device. | |
| **RequirePinAfterBiometricChange** | Write | Boolean | A PIN prompt will override biometric prompts if class 3 biometrics are updated on the device. | |
| **FingerprintBlocked** | Write | Boolean | Indicates whether use of the fingerprint reader is allowed in place of a pin if PinRequired is set to True. | |
| **Apps** | Write | StringArray[] | List of IDs representing the Android apps controlled by this protection policy. | |
| **Assignments** | Write | StringArray[] | List of IDs of the groups assigned to this Android Protection Policy. | |
| **ExcludedGroups** | Write | StringArray[] | List of IDs of the groups that are excluded from this Android Protection Policy. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Intune Admin | |
| **ApplicationId** | Write | String | ID of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | ID of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **ManagedBrowser** | Write | String | Indicates in which managed browser(s) that internet links should be opened. Used in conjunction with CustomBrowserPackageId, CustomBrowserDisplayName and ManagedBrowserToOpenLinksRequired. Possible values are: notConfigured, microsoftEdge. | `notConfigured`, `microsoftEdge` |
| **MinimumRequiredAppVersion** | Write | String | Versions less than the specified version will block the managed app from accessing company data. | |
| **MinimumRequiredOSVersion** | Write | String | Versions less than the specified version will block the managed app from accessing company data. | |
| **MinimumRequiredPatchVersion** | Write | String | Versions less than the specified version will block the managed app from accessing company data. | |
| **MinimumWarningAppVersion** | Write | String | Versions less than the specified version will result in warning message on the managed app | |
| **MinimumWarningOSVersion** | Write | String | Versions less than the specified version will result in warning message on the managed app | |
| **MinimumWarningPatchVersion** | Write | String | Versions less than the specified version will result in warning message on the managed app | |
| **AppGroupType** | Write | String | The apps controlled by this protection policy, overrides any values in Apps unless this value is 'selectedPublicApps'. | `allApps`, `allMicrosoftApps`, `allCoreMicrosoftApps`, `selectedPublicApps` |
| **IsAssigned** | Write | Boolean | Indicates if the policy is deployed to any inclusion groups or not. Inherited from targetedManagedAppProtection. | |
| **ScreenCaptureBlocked** | Write | Boolean | Indicates whether or not to Block the user from taking Screenshots. | |
| **EncryptAppData** | Write | Boolean | Indicates whether or not the 'Encrypt org data' value is enabled.  True = require | |
| **DisableAppEncryptionIfDeviceEncryptionIsEnabled** | Write | Boolean | Indicates whether or not the 'Encrypt org data on enrolled devices' value is enabled.  False = require.  Only functions if EncryptAppData is set to True | |
| **CustomBrowserDisplayName** | Write | String | The application name for browser associated with the 'Unmanaged Browser ID'. This name will be displayed to users if the specified browser is not installed. | |
| **CustomBrowserPackageId** | Write | String | The application ID for a single browser. Web content (http/s) from policy managed applications will open in the specified browser. | |
| **Id** | Write | String | Id of the Intune policy. To avoid creation of duplicate policies DisplayName will be searched for if the ID is not found | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

This resource configures an Intune app protection policy for an Android Device.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Group.Read.All, DeviceManagementApps.Read.All

- **Update**

    - Group.Read.All, DeviceManagementApps.ReadWrite.All

#### Application permissions

- **Read**

    - Group.Read.All, DeviceManagementApps.Read.All

- **Update**

    - Group.Read.All, DeviceManagementApps.ReadWrite.All

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param
    (
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
        IntuneAppProtectionPolicyAndroid 'ConfigureAppProtectionPolicyAndroid'
        {
            DisplayName                             = 'My DSC Android App Protection Policy'
            AllowedDataStorageLocations             = @('sharePoint')
            AllowedInboundDataTransferSources       = 'managedApps'
            AllowedOutboundClipboardSharingLevel    = 'managedAppsWithPasteIn'
            AllowedOutboundDataTransferDestinations = 'managedApps'
            Apps                                    = @('com.cisco.jabberimintune.ios', 'com.pervasent.boardpapers.ios', 'com.sharefile.mobile.intune.ios')
            ContactSyncBlocked                      = $false
            DataBackupBlocked                       = $false
            Description                             = ''
            DeviceComplianceRequired                = $True
            DisableAppPinIfDevicePinIsSet           = $True
            FingerprintBlocked                      = $False
            ManagedBrowserToOpenLinksRequired       = $True
            MaximumPinRetries                       = 5
            MinimumPinLength                        = 4
            OrganizationalCredentialsRequired       = $false
            PinRequired                             = $True
            PrintBlocked                            = $True
            SaveAsBlocked                           = $True
            SimplePinBlocked                        = $True
            Ensure                                  = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
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
    param
    (
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
        IntuneAppProtectionPolicyAndroid 'ConfigureAppProtectionPolicyAndroid'
        {
            DisplayName                             = 'My DSC Android App Protection Policy'
            AllowedDataStorageLocations             = @('sharePoint')
            AllowedInboundDataTransferSources       = 'managedApps'
            AllowedOutboundClipboardSharingLevel    = 'managedAppsWithPasteIn'
            AllowedOutboundDataTransferDestinations = 'managedApps'
            Apps                                    = @('com.cisco.jabberimintune.ios', 'com.pervasent.boardpapers.ios', 'com.sharefile.mobile.intune.ios')
            ContactSyncBlocked                      = $true # Updated Property
            DataBackupBlocked                       = $false
            Description                             = ''
            DeviceComplianceRequired                = $True
            DisableAppPinIfDevicePinIsSet           = $True
            FingerprintBlocked                      = $False
            ManagedBrowserToOpenLinksRequired       = $True
            MaximumPinRetries                       = 5
            MinimumPinLength                        = 4
            OrganizationalCredentialsRequired       = $false
            PinRequired                             = $True
            PrintBlocked                            = $True
            SaveAsBlocked                           = $True
            SimplePinBlocked                        = $True
            Ensure                                  = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
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
    param
    (
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
        IntuneAppProtectionPolicyAndroid 'ConfigureAppProtectionPolicyAndroid'
        {
            DisplayName                             = 'My DSC Android App Protection Policy'
            Ensure                                  = 'Absent'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

