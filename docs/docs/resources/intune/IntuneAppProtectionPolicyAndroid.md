﻿# IntuneAppProtectionPolicyAndroid

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | Display name of the Android App Protection Policy. ||
| **Description** | Write | String | Description of the Android App Protection Policy. ||
| **PeriodOfflineBeforeAccessCheck** | Write | String | The period after which access is checked when the device is not connected to the internet. ||
| **PeriodOnlineBeforeAccessCheck** | Write | String | The period after which access is checked when the device is connected to the internet. ||
| **AllowedInboundDataTransferSources** | Write | String | Sources from which data is allowed to be transferred. Possible values are: allApps, managedApps, none. |allApps, managedApps, none|
| **AllowedOutboundDataTransferDestinations** | Write | String | Destinations to which data is allowed to be transferred. Possible values are: allApps, managedApps, none. |allApps, managedApps, none|
| **OrganizationalCredentialsRequired** | Write | Boolean | Indicates whether organizational credentials are required for app use. ||
| **AllowedOutboundClipboardSharingLevel** | Write | String | The level to which the clipboard may be shared between apps on the managed device. Possible values are: allApps, managedAppsWithPasteIn, managedApps, blocked. |allApps, managedAppsWithPasteIn, managedApps, blocked|
| **DataBackupBlocked** | Write | Boolean | Indicates whether the backup of a managed app's data is blocked. ||
| **DeviceComplianceRequired** | Write | Boolean | Indicates whether device compliance is required. ||
| **ManagedBrowserToOpenLinksRequired** | Write | Boolean | Indicates whether internet links should be opened in the managed browser app, or any custom browser specified by CustomBrowserProtocol (for Android) or CustomBrowserPackageId/CustomBrowserDisplayName (for Android). ||
| **SaveAsBlocked** | Write | Boolean | Indicates whether users may use the Save As menu item to save a copy of protected files. ||
| **PeriodOfflineBeforeWipeIsEnforced** | Write | String | The amount of time an app is allowed to remain disconnected from the internet before all managed data it is wiped. ||
| **PinRequired** | Write | Boolean | Indicates whether an app-level pin is required. ||
| **DisableAppPinIfDevicePinIsSet** | Write | Boolean | Indicates whether use of the app pin is required if the device pin is set. ||
| **MaximumPinRetries** | Write | UInt32 | Maximum number of incorrect pin retry attempts before the managed app is either blocked or wiped. ||
| **SimplePinBlocked** | Write | Boolean | Block simple PIN and require complex PIN to be set. ||
| **MinimumPinLength** | Write | UInt32 | Minimum pin length required for an app-level pin if PinRequired is set to True. ||
| **PinCharacterSet** | Write | String | Character set which may be used for an app-level pin if PinRequired is set to True. Possible values are: numeric, alphanumericAndSymbol. |numeric, alphanumericAndSymbol|
| **AllowedDataStorageLocations** | Write | StringArray[] | Data storage locations where a user may store managed data. ||
| **ContactSyncBlocked** | Write | Boolean | Indicates whether contacts can be synced to the user's device. ||
| **PeriodBeforePinReset** | Write | String | TimePeriod before the all-level pin must be reset if PinRequired is set to True. ||
| **PrintBlocked** | Write | Boolean | Indicates whether printing is allowed from managed apps. ||
| **FingerprintBlocked** | Write | Boolean | Indicates whether use of the fingerprint reader is allowed in place of a pin if PinRequired is set to True. ||
| **Apps** | Write | StringArray[] | List of IDs representing the Android apps controlled by this protection policy. ||
| **Assignments** | Write | StringArray[] | List of IDs of the groups assigned to this Android Protection Policy. ||
| **ExcludedGroups** | Write | StringArray[] | List of IDs of the groups that are excluded from this Android Protection Policy. ||
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Intune Admin ||
| **ApplicationId** | Write | String | ID of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | ID of the Azure Active Directory tenant used for authentication. ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||


# IntuneAppProtectionPolicyAndroid

This resource configures an Intune app protection policy for an Android Device.


