﻿# IntuneDeviceConfigurationPolicyAndroidDeviceAdministrator

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **dataType** | Write | String | The type of the target assignment. |#microsoft.graph.groupAssignmentTarget, #microsoft.graph.allLicensedUsersAssignmentTarget, #microsoft.graph.allDevicesAssignmentTarget, #microsoft.graph.exclusionGroupAssignmentTarget, #microsoft.graph.configurationManagerCollectionAssignmentTarget|
| **deviceAndAppManagementAssignmentFilterType** | Write | String | The type of filter of the target assignment i.e. Exclude or Include. Possible values are:none, include, exclude. |none, include, exclude|
| **deviceAndAppManagementAssignmentFilterId** | Write | String | The Id of the filter for the target assignment. ||
| **groupId** | Write | String | The group Id that is the target of the assignment. ||
| **collectionId** | Write | String | The collection Id that is the target of the assignment.(ConfigMgr) ||
| **odataType** | Write | String | odatatype of the item. |#microsoft.graph.appleAppListItem|
| **appId** | Write | String | Kiosk mode managed app id ||
| **appStoreUrl** | Write | String | Define the app store URL. ||
| **name** | Write | String | Define the name of the app. ||
| **publisher** | Write | String | Define the publisher of the app. ||
| **Id** | Write | String | Id of the Intune policy. ||
| **Description** | Write | String | Description of the Intune policy. ||
| **DisplayName** | Write | String | Display name of the Intune policy. ||
| **AppsBlockClipboardSharing** | Write | Boolean | Block clipboard sharing between apps (Samsung KNOX Standard 4.0+). ||
| **AppsBlockCopyPaste** | Write | Boolean | Block copy and paste functionality. ||
| **AppsBlockYouTube** | Write | Boolean | Block YouTube (Samsung KNOX Standard 4.0+). ||
| **AppsHideList** | Write | InstanceArray[] | Specify the apps that will be hidden on the device. Users cannot discover or run these apps. ||
| **AppsInstallAllowList** | Write | InstanceArray[] | Specify the apps that users can install. Users will not be able to install apps that are not on the list. ||
| **AppsLaunchBlockList** | Write | InstanceArray[] | Specify the apps that users cannot run on their device. ||
| **BluetoothBlocked** | Write | Boolean | Block Bluetooth (Samsung KNOX Standard 4.0+). ||
| **CameraBlocked** | Write | Boolean | Block use of camera ||
| **CellularBlockDataRoaming** | Write | Boolean | Block data roaming over the cellular network (Samsung KNOX Standard 4.0+). ||
| **CellularBlockMessaging** | Write | Boolean | Block SMS/MMS messaging functionality (Samsung KNOX Standard 4.0+). ||
| **CellularBlockVoiceRoaming** | Write | Boolean | Block voice roaming over the cellular network (Samsung KNOX Standard 4.0+). ||
| **CellularBlockWiFiTethering** | Write | Boolean | Block Wi-Fi tethering (Samsung KNOX Standard 4.0+). ||
| **CompliantAppListType** | Write | String | Device compliance can be viewed in the Restricted Apps Compliance report. |none, appsInListCompliant, appsNotInListCompliant|
| **CompliantAppsList** | Write | InstanceArray[] | Enter the Google Play Store URL of the app you want. For example, to specify the Microsoft Remote Desktop app for Android, enter https://play.google.com/store/apps/details?id=com.microsoft.rdc.android. To find the URL of an app, use a search engine to locate the store page. For example, to find the Remote Desktop app, you could search Microsoft Remote Desktop Play Store. ||
| **DateAndTimeBlockChanges** | Write | Boolean | Block user from changing date and time on device (Samsung KNOX). ||
| **DeviceSharingAllowed** | Write | Boolean | Allow multiple users to log into the Company Portal using their AAD credentials (Samsung KNOX Standard 4.0+). ||
| **DiagnosticDataBlockSubmission** | Write | Boolean | Block submitting diagnostic data from device. ||
| **FactoryResetBlocked** | Write | Boolean | Block factory reset on device. ||
| **GoogleAccountBlockAutoSync** | Write | Boolean | Block Google account auto sync functionality on device. ||
| **GooglePlayStoreBlocked** | Write | Boolean | Block Google Play store (Samsung KNOX Standard 4.0+). ||
| **KioskModeApps** | Write | InstanceArray[] | Kiosk mode apps ||
| **KioskModeBlockSleepButton** | Write | Boolean | Kiosk mode block sleep button ||
| **KioskModeBlockVolumeButtons** | Write | Boolean | Kiosk mode block volume buttons ||
| **LocationServicesBlocked** | Write | Boolean | Location services blocked ||
| **NfcBlocked** | Write | Boolean | Block Near Field Communication (NFC) technology (Samsung KNOX Standard 4.0+). ||
| **PasswordBlockFingerprintUnlock** | Write | Boolean | Block using fingerprint to unlock device. ||
| **PasswordBlockTrustAgents** | Write | Boolean | Block Smart Lock or other trust agents from adjusting lock screen settings (Samsung KNOX Standard 5.0+). ||
| **PasswordExpirationDays** | Write | UInt32 | Number of days until device password must be changed. (1-365) ||
| **PasswordMinimumLength** | Write | UInt32 | Minimum number of digits or characters in password. (4-16) ||
| **PasswordMinutesOfInactivityBeforeScreenTimeout** | Write | UInt32 | Maximum minutes of inactivity until screen locks. Ignored by device if new time is longer than what's currently set on device. If set to Immediately, devices will use the minimum possible value per device. ||
| **PasswordPreviousPasswordBlockCount** | Write | UInt32 | Number of new passwords that must be used until an old one can be reused. ||
| **PasswordRequired** | Write | Boolean | Require password to access device. ||
| **PasswordRequiredType** | Write | String | Specify the type of password required. |deviceDefault, alphabetic, alphanumeric, alphanumericWithSymbols, lowSecurityBiometric, numeric, numericComplex, any|
| **PasswordSignInFailureCountBeforeFactoryReset** | Write | UInt32 | Number of consecutive times an incorrect password can be entered before device is wiped of all data. ||
| **PowerOffBlocked** | Write | Boolean | Block user from powering off device. If this setting is disabled the setting 'Number of sign-in failures before wiping device' does not function. ||
| **RequiredPasswordComplexity** | Write | String | Define the password complexity. |none, low, medium, high|
| **ScreenCaptureBlocked** | Write | Boolean | Block capturing contents of screen as an image. ||
| **SecurityRequireVerifyApps** | Write | Boolean | Security require verify apps ||
| **StorageBlockGoogleBackup** | Write | Boolean | Block sync with Google backup. ||
| **StorageBlockRemovableStorage** | Write | Boolean | Block removable storage usage (Samsung KNOX Standard 4.0+). ||
| **StorageRequireDeviceEncryption** | Write | Boolean | Require encryption on device. Not all devices support encryption. ||
| **StorageRequireRemovableStorageEncryption** | Write | Boolean | Storage cards must be encrypted. Not all devices support storage card encryption. For more information, see the device and mobile operating system documentation. ||
| **VoiceAssistantBlocked** | Write | Boolean | Block voice assistant (Samsung KNOX Standard 4.0+). ||
| **VoiceDialingBlocked** | Write | Boolean | Block voice dialing (Samsung KNOX Standard 4.0+). ||
| **WebBrowserBlockAutofill** | Write | Boolean | Block autofill. ||
| **WebBrowserBlocked** | Write | Boolean | Block web browser on device. ||
| **WebBrowserBlockJavaScript** | Write | Boolean | Block JavaScript in the browser. ||
| **WebBrowserBlockPopups** | Write | Boolean | Block pop-ups in web browser. ||
| **WebBrowserCookieSettings** | Write | String | Allow or block browser cookies |browserDefault, blockAlways, allowCurrentWebSite, allowFromWebsitesVisited, allowAlways|
| **WiFiBlocked** | Write | Boolean | Block Wi-Fi (Samsung KNOX Standard 4.0+). ||
| **Assignments** | Write | InstanceArray[] | Represents the assignment to the Intune policy. ||
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Intune Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||


# IntuneDeviceConfigurationPolicyAndroidDeviceAdministrator

### Description

This resource configures the settings of Android Device Administrator device restriction policy in your cloud-based organization.


