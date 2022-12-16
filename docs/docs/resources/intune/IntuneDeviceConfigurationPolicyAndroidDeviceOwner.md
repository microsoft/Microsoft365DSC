# IntuneDeviceConfigurationPolicyAndroidDeviceOwner

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | | |
| **Description** | Write | String | | |
| **DeviceManagementApplicabilityRuleDeviceMode** | Write | MSFT_Intunedevicemanagementapplicabilityruledevicemode | | |
| **DeviceManagementApplicabilityRuleOsEdition** | Write | MSFT_Intunedevicemanagementapplicabilityruleosedition | | |
| **DeviceManagementApplicabilityRuleOsVersion** | Write | MSFT_Intunedevicemanagementapplicabilityruleosversion | | |
| **DisplayName** | Write | String | | |
| **RoleScopeTagIds** | Write | StringArray[] | | |
| **SupportsScopeTags** | Write | Boolean | | |
| **Version** | Write | UInt32 | | |
| **AccountsBlockModification** | Write | Boolean | | |
| **AppsAllowInstallFromUnknownSources** | Write | Boolean | | |
| **AppsAutoUpdatePolicy** | Write | String | | |
| **AppsDefaultPermissionPolicy** | Write | String | | |
| **AppsRecommendSkippingFirstUseHints** | Write | Boolean | | |
| **AzureAdSharedDeviceDataClearApps** | Write | String | | |
| **BluetoothBlockConfiguration** | Write | Boolean | | |
| **BluetoothBlockContactSharing** | Write | Boolean | | |
| **CameraBlocked** | Write | Boolean | | |
| **CellularBlockWiFiTethering** | Write | Boolean | | |
| **CertificateCredentialConfigurationDisabled** | Write | Boolean | | |
| **CrossProfilePoliciesAllowCopyPaste** | Write | Boolean | | |
| **CrossProfilePoliciesAllowDataSharing** | Write | String | | |
| **CrossProfilePoliciesShowWorkContactsInPersonalProfile** | Write | Boolean | | |
| **DataRoamingBlocked** | Write | Boolean | | |
| **DateTimeConfigurationBlocked** | Write | Boolean | | |
| **EnrollmentProfile** | Write | String | | |
| **FactoryResetBlocked** | Write | Boolean | | |
| **FactoryResetDeviceAdministratorEmails** | Write | String | | |
| **GlobalProxy** | Write | String | | |
| **GoogleAccountsBlocked** | Write | Boolean | | |
| **KioskCustomizationDeviceSettingsBlocked** | Write | Boolean | | |
| **KioskCustomizationPowerButtonActionsBlocked** | Write | Boolean | | |
| **KioskCustomizationStatusBar** | Write | String | | |
| **KioskCustomizationSystemErrorWarnings** | Write | Boolean | | |
| **KioskCustomizationSystemNavigation** | Write | String | | |
| **KioskModeAppOrderEnabled** | Write | Boolean | | |
| **KioskModeAppPositions** | Write | String | | |
| **KioskModeApps** | Write | String | | |
| **KioskModeAppsInFolderOrderedByName** | Write | Boolean | | |
| **KioskModeBluetoothConfigurationEnabled** | Write | Boolean | | |
| **KioskModeDebugMenuEasyAccessEnabled** | Write | Boolean | | |
| **KioskModeExitCode** | Write | String | | |
| **KioskModeFlashlightConfigurationEnabled** | Write | Boolean | | |
| **KioskModeFolderIcon** | Write | String | | |
| **KioskModeGridHeight** | Write | UInt32 | | |
| **KioskModeGridWidth** | Write | UInt32 | | |
| **KioskModeIconSize** | Write | String | | |
| **KioskModeLockHomeScreen** | Write | Boolean | | |
| **KioskModeManagedFolders** | Write | String | | |
| **KioskModeManagedHomeScreenAutoSignout** | Write | Boolean | | |
| **KioskModeManagedHomeScreenInactiveSignOutDelayInSeconds** | Write | UInt32 | | |
| **KioskModeManagedHomeScreenInactiveSignOutNoticeInSeconds** | Write | UInt32 | | |
| **KioskModeManagedHomeScreenPinComplexity** | Write | String | | |
| **KioskModeManagedHomeScreenPinRequired** | Write | Boolean | | |
| **KioskModeManagedHomeScreenPinRequiredToResume** | Write | Boolean | | |
| **KioskModeManagedHomeScreenSignInBackground** | Write | String | | |
| **KioskModeManagedHomeScreenSignInBrandingLogo** | Write | String | | |
| **KioskModeManagedHomeScreenSignInEnabled** | Write | Boolean | | |
| **KioskModeManagedSettingsEntryDisabled** | Write | Boolean | | |
| **KioskModeMediaVolumeConfigurationEnabled** | Write | Boolean | | |
| **KioskModeScreenOrientation** | Write | String | | |
| **KioskModeScreenSaverConfigurationEnabled** | Write | Boolean | | |
| **KioskModeScreenSaverDetectMediaDisabled** | Write | Boolean | | |
| **KioskModeScreenSaverDisplayTimeInSeconds** | Write | UInt32 | | |
| **KioskModeScreenSaverImageUrl** | Write | String | | |
| **KioskModeScreenSaverStartDelayInSeconds** | Write | UInt32 | | |
| **KioskModeShowAppNotificationBadge** | Write | Boolean | | |
| **KioskModeShowDeviceInfo** | Write | Boolean | | |
| **KioskModeVirtualHomeButtonEnabled** | Write | Boolean | | |
| **KioskModeVirtualHomeButtonType** | Write | String | | |
| **KioskModeWallpaperUrl** | Write | String | | |
| **KioskModeWifiAllowedSsids** | Write | String | | |
| **KioskModeWiFiConfigurationEnabled** | Write | Boolean | | |
| **MicrophoneForceMute** | Write | Boolean | | |
| **MicrosoftLauncherConfigurationEnabled** | Write | Boolean | | |
| **MicrosoftLauncherCustomWallpaperAllowUserModification** | Write | Boolean | | |
| **MicrosoftLauncherCustomWallpaperEnabled** | Write | Boolean | | |
| **MicrosoftLauncherCustomWallpaperImageUrl** | Write | String | | |
| **MicrosoftLauncherDockPresenceAllowUserModification** | Write | Boolean | | |
| **MicrosoftLauncherDockPresenceConfiguration** | Write | String | | |
| **MicrosoftLauncherFeedAllowUserModification** | Write | Boolean | | |
| **MicrosoftLauncherFeedEnabled** | Write | Boolean | | |
| **MicrosoftLauncherSearchBarPlacementConfiguration** | Write | String | | |
| **NetworkEscapeHatchAllowed** | Write | Boolean | | |
| **NfcBlockOutgoingBeam** | Write | Boolean | | |
| **PasswordBlockKeyguard** | Write | Boolean | | |
| **PasswordBlockKeyguardFeatures** | Write | String | | |
| **PasswordExpirationDays** | Write | UInt32 | | |
| **PasswordMinimumLength** | Write | UInt32 | | |
| **PasswordMinimumLetterCharacters** | Write | UInt32 | | |
| **PasswordMinimumLowerCaseCharacters** | Write | UInt32 | | |
| **PasswordMinimumNonLetterCharacters** | Write | UInt32 | | |
| **PasswordMinimumNumericCharacters** | Write | UInt32 | | |
| **PasswordMinimumSymbolCharacters** | Write | UInt32 | | |
| **PasswordMinimumUpperCaseCharacters** | Write | UInt32 | | |
| **PasswordMinutesOfInactivityBeforeScreenTimeout** | Write | UInt32 | | |
| **PasswordPreviousPasswordCountToBlock** | Write | UInt32 | | |
| **PasswordRequiredType** | Write | String | | |
| **PasswordSignInFailureCountBeforeFactoryReset** | Write | UInt32 | | |
| **PersonalProfileAppsAllowInstallFromUnknownSources** | Write | Boolean | | |
| **PersonalProfileCameraBlocked** | Write | Boolean | | |
| **PersonalProfilePersonalApplications** | Write | String | | |
| **PersonalProfilePlayStoreMode** | Write | String | | |
| **PersonalProfileScreenCaptureBlocked** | Write | Boolean | | |
| **PlayStoreMode** | Write | String | | |
| **ScreenCaptureBlocked** | Write | Boolean | | |
| **SecurityDeveloperSettingsEnabled** | Write | Boolean | | |
| **SecurityRequireVerifyApps** | Write | Boolean | | |
| **StatusBarBlocked** | Write | Boolean | | |
| **StayOnModes** | Write | String | | |
| **StorageAllowUsb** | Write | Boolean | | |
| **StorageBlockExternalMedia** | Write | Boolean | | |
| **StorageBlockUsbFileTransfer** | Write | Boolean | | |
| **SystemUpdateFreezePeriods** | Write | String | | |
| **SystemUpdateInstallType** | Write | String | | |
| **SystemUpdateWindowEndMinutesAfterMidnight** | Write | UInt32 | | |
| **SystemUpdateWindowStartMinutesAfterMidnight** | Write | UInt32 | | |
| **SystemWindowsBlocked** | Write | Boolean | | |
| **UsersBlockAdd** | Write | Boolean | | |
| **UsersBlockRemove** | Write | Boolean | | |
| **VolumeBlockAdjustment** | Write | Boolean | | |
| **VpnAlwaysOnLockdownMode** | Write | Boolean | | |
| **VpnAlwaysOnPackageIdentifier** | Write | String | | |
| **WifiBlockEditConfigurations** | Write | Boolean | | |
| **WifiBlockEditPolicyDefinedConfigurations** | Write | Boolean | | |
| **WorkProfilePasswordExpirationDays** | Write | UInt32 | | |
| **WorkProfilePasswordMinimumLength** | Write | UInt32 | | |
| **WorkProfilePasswordMinimumLetterCharacters** | Write | UInt32 | | |
| **WorkProfilePasswordMinimumLowerCaseCharacters** | Write | UInt32 | | |
| **WorkProfilePasswordMinimumNonLetterCharacters** | Write | UInt32 | | |
| **WorkProfilePasswordMinimumNumericCharacters** | Write | UInt32 | | |
| **WorkProfilePasswordMinimumSymbolCharacters** | Write | UInt32 | | |
| **WorkProfilePasswordMinimumUpperCaseCharacters** | Write | UInt32 | | |
| **WorkProfilePasswordPreviousPasswordCountToBlock** | Write | UInt32 | | |
| **WorkProfilePasswordRequiredType** | Write | String | | |
| **WorkProfilePasswordSignInFailureCountBeforeFactoryReset** | Write | UInt32 | Indicates the number of times a user can enter an incorrect work profile password before the device is wiped. Valid values 4 to 11 | |
| **Assignments** | Write | MSFT_Intunedeviceconfigurationassignment1[] | | |
| **DeviceSettingStateSummaries** | Write | MSFT_Intunesettingstatedevicesummary[] | | |
| **DeviceStatuses** | Write | MSFT_Intunedeviceconfigurationdevicestatus1[] | | |
| **DeviceStatusOverview** | Write | MSFT_Intunedeviceconfigurationdeviceoverview1 | | |
| **GroupAssignments** | Write | MSFT_Intunedeviceconfigurationgroupassignment[] | | |
| **UserStatuses** | Write | MSFT_Intunedeviceconfigurationuserstatus[] | | |
| **UserStatusOverview** | Write | MSFT_Intunedeviceconfigurationuseroverview1 | | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Intune Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

### MSFT_IntuneDeviceConfigurationPolicyAndroidDeviceOwnerapplicabilityruledevicemode

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DeviceMode** | Write | String | | |
| **Name** | Write | String | | |
| **RuleType** | Write | String | | |

### MSFT_IntuneDeviceConfigurationPolicyAndroidDeviceOwnerapplicabilityruleosedition

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Write | String | | |
| **OSEditionTypes** | Write | StringArray[] | | |
| **RuleType** | Write | String | | |

### MSFT_IntuneDeviceConfigurationPolicyAndroidDeviceOwnerapplicabilityruleosversion

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **MaxOSVersion** | Write | String | | |
| **MinOSVersion** | Write | String | | |
| **Name** | Write | String | | |
| **RuleType** | Write | String | | |

### MSFT_IntuneDeviceConfigurationPolicyAndroidDeviceOwnerAassignment1

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Intent** | Write | String | | |
| **Source** | Write | String | | |
| **SourceId** | Write | String | | |
| **Target** | Write | MSFT_Intunedeviceandappmanagementassignmenttarget1 | | |

### MSFT_IntuneDeviceConfigurationPolicyAndroidDeviceOwnerappmanagementassignmenttarget1

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DeviceAndAppManagementAssignmentFilterId** | Write | String | | |
| **DeviceAndAppManagementAssignmentFilterType** | Write | String | | |

### MSFT_IntuneDeviceConfigurationPolicyAndroidDeviceOwnerdevicesummary

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **CompliantDeviceCount** | Write | UInt32 | | |
| **ConflictDeviceCount** | Write | UInt32 | | |
| **ErrorDeviceCount** | Write | UInt32 | | |
| **InstancePath** | Write | String | | |
| **NonCompliantDeviceCount** | Write | UInt32 | | |
| **NotApplicableDeviceCount** | Write | UInt32 | | |
| **RemediatedDeviceCount** | Write | UInt32 | | |
| **SettingName** | Write | String | | |
| **UnknownDeviceCount** | Write | UInt32 | | |

### MSFT_IntuneDeviceConfigurationPolicyAndroidDeviceOwnerdevicestatus1

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **ComplianceGracePeriodExpirationDateTime** | Write | String | | |
| **DeviceDisplayName** | Write | String | | |
| **DeviceModel** | Write | String | | |
| **LastReportedDateTime** | Write | String | | |
| **Platform** | Write | UInt32 | | |
| **Status** | Write | String | | |
| **UserName** | Write | String | | |
| **UserPrincipalName** | Write | String | | |

### MSFT_IntuneDeviceConfigurationPolicyAndroidDeviceOwnerdeviceoverview1

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **ConfigurationVersion** | Write | UInt32 | | |
| **ConflictCount** | Write | UInt32 | | |
| **ErrorCount** | Write | UInt32 | | |
| **FailedCount** | Write | UInt32 | | |
| **LastUpdateDateTime** | Write | String | | |
| **NotApplicableCount** | Write | UInt32 | | |
| **NotApplicablePlatformCount** | Write | UInt32 | | |
| **PendingCount** | Write | UInt32 | | |
| **SuccessCount** | Write | UInt32 | | |

### MSFT_IntuneDeviceConfigurationPolicyAndroidDeviceOwnergroupassignment

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DeviceConfiguration** | Write | MSFT_Intunedeviceconfiguration1 | | |
| **ExcludeGroup** | Write | Boolean | | |
| **TargetGroupId** | Write | String | | |

### MSFT_IntuneDeviceConfigurationPolicyAndroidDeviceOwner1

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Assignments** | Write | MSFT_Intunedeviceconfigurationassignment1[] | Represents the assignment to the Intune policy. | |
| **CreatedDateTime** | Write | String | | |
| **Description** | Write | String | | |
| **DeviceManagementApplicabilityRuleDeviceMode** | Write | MSFT_Intunedevicemanagementapplicabilityruledevicemode | | |
| **DeviceManagementApplicabilityRuleOSEdition** | Write | MSFT_Intunedevicemanagementapplicabilityruleosedition | | |
| **DeviceManagementApplicabilityRuleOSVersion** | Write | MSFT_Intunedevicemanagementapplicabilityruleosversion | | |
| **DeviceSettingStateSummaries** | Write | MSFT_Intunesettingstatedevicesummary[] | | |
| **DeviceStatusOverview** | Write | MSFT_Intunedeviceconfigurationdeviceoverview1 | | |
| **DeviceStatuses** | Write | MSFT_Intunedeviceconfigurationdevicestatus1[] | | |
| **DisplayName** | Write | String | | |
| **GroupAssignments** | Write | MSFT_Intunedeviceconfigurationgroupassignment[] | | |
| **LastModifiedDateTime** | Write | String | | |
| **RoleScopeTagIds** | Write | StringArray[] | | |
| **SupportsScopeTags** | Write | Boolean | | |
| **UserStatusOverview** | Write | MSFT_Intunedeviceconfigurationuseroverview1 | | |
| **UserStatuses** | Write | MSFT_Intunedeviceconfigurationuserstatus[] | | |
| **Version** | Write | UInt32 | | |

### MSFT_IntuneDeviceConfigurationPolicyAndroidDeviceOwneruserstatus

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DevicesCount** | Write | UInt32 | | |
| **LastReportedDateTime** | Write | String | | |
| **Status** | Write | String | | |
| **UserDisplayName** | Write | String | | |
| **UserPrincipalName** | Write | String | | |

### MSFT_IntuneDeviceConfigurationPolicyAndroidDeviceOwneruseroverview1

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **ConfigurationVersion** | Write | UInt32 | | |
| **ConflictCount** | Write | UInt32 | | |
| **ErrorCount** | Write | UInt32 | | |
| **FailedCount** | Write | UInt32 | | |
| **LastUpdateDateTime** | Write | String | | |
| **NotApplicableCount** | Write | UInt32 | | |
| **PendingCount** | Write | UInt32 | | |
| **SuccessCount** | Write | UInt32 | | |


## Description

This resource configures an Intune Device Configuration Policy Android Device Owner.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - DeviceManagementConfiguration.Read.All

- **Update**

    - DeviceManagementConfiguration.ReadWrite.All

#### Application permissions

- **Read**

    - DeviceManagementConfiguration.Read.All

- **Update**

    - DeviceManagementConfiguration.ReadWrite.All


