# IntuneDeviceConfigurationPolicyWindows10

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | Description of the device configuration policy for Windows 10. ||
| **Description** | Write | String | Display name of the device configuration policy for Windows 10. ||
| **EnterpriseCloudPrintDiscoveryEndPoint** | Write | String | Endpoint for discovering cloud printers. ||
| **EnterpriseCloudPrintOAuthAuthority** | Write | String | Authentication endpoint for acquiring OAuth tokens. ||
| **EnterpriseCloudPrintOAuthClientIdentifier** | Write | String | GUID of a client application authorized to retrieve OAuth tokens from the OAuth Authority. ||
| **EnterpriseCloudPrintResourceIdentifier** | Write | String | OAuth resource URI for print service as configured in the Azure portal. ||
| **EnterpriseCloudPrintDiscoveryMaxLimit** | Write | UInt64 | Maximum number of printers that should be queried from a discovery endpoint. This is a mobile only setting. Valid values 1 to 65535 ||
| **EnterpriseCloudPrintMopriaDiscoveryResourceIdentifier** | Write | String | OAuth resource URI for printer discovery service as configured in Azure portal. ||
| **SearchBlockDiacritics** | Write | Boolean | Specifies if search can use diacritics. ||
| **SearchDisableAutoLanguageDetection** | Write | Boolean | Specifies whether to use automatic language detection when indexing content and properties. ||
| **SearchDisableIndexingEncryptedItems** | Write | Boolean | Indicates whether or not to block indexing of WIP-protected items to prevent them from appearing in search results for Cortana or Explorer. ||
| **SearchEnableRemoteQueries** | Write | Boolean | Indicates whether or not to block remote queries of this computer's index. ||
| **SearchDisableIndexerBackoff** | Write | Boolean | Indicates whether or not to disable the search indexer backoff feature. ||
| **SearchDisableIndexingRemovableDrive** | Write | Boolean | Indicates whether or not to allow users to add locations on removable drives to libraries and to be indexed. ||
| **SearchEnableAutomaticIndexSizeManangement** | Write | Boolean | Specifies minimum amount of hard drive space on the same drive as the index location before indexing stops. ||
| **DiagnosticsDataSubmissionMode** | Write | String | Gets or sets a value allowing the device to send diagnostic and usage telemetry data, such as Watson. Possible values are: userDefined, none, basic, enhanced, full. ||
| **OneDriveDisableFileSync** | Write | Boolean | Gets or sets a value allowing IT admins to prevent apps and features from working with files on OneDrive. ||
| **SmartScreenEnableAppInstallControl** | Write | Boolean | This property will be deprecated in July 2019 and will be replaced by property SmartScreenAppInstallControl. Allows IT Admins to control whether users are allowed to install apps from places other than the Store. ||
| **PersonalizationDesktopImageUrl** | Write | String | A http or https Url to a jpg, jpeg or png image that needs to be downloaded and used as the Desktop Image or a file Url to a local image on the file system that needs to used as the Desktop Image. ||
| **PersonalizationLockScreenImageUrl** | Write | String | A http or https Url to a jpg, jpeg or png image that neeeds to be downloaded and used as the Lock Screen Image or a file Url to a local image on the file system that needs to be used as the Lock Screen Image. ||
| **BluetoothAllowedServices** | Write | StringArray[] | Specify a list of allowed Bluetooth services and profiles in hex formatted strings. ||
| **BluetoothBlockAdvertising** | Write | Boolean | Whether or not to Block the user from using bluetooth advertising. ||
| **BluetoothBlockDiscoverableMode** | Write | Boolean | Whether or not to Block the user from using bluetooth discoverable mode. ||
| **BluetoothBlockPrePairing** | Write | Boolean | Whether or not to block specific bundled Bluetooth peripherals to automatically pair with the host device. ||
| **EdgeBlockAutofill** | Write | Boolean | Indicates whether or not to block auto fill. ||
| **EdgeBlocked** | Write | Boolean | Indicates whether or not to Block the user from using the Edge browser. ||
| **EdgeCookiePolicy** | Write | String | Indicates which cookies to block in the Edge browser. Possible values are: userDefined, allow, blockThirdParty, blockAll. ||
| **EdgeBlockDeveloperTools** | Write | Boolean | Indicates whether or not to block developer tools in the Edge browser. ||
| **EdgeBlockSendingDoNotTrackHeader** | Write | Boolean | Indicates whether or not to Block the user from sending the do not track header. ||
| **EdgeBlockExtensions** | Write | Boolean | Indicates whether or not to block extensions in the Edge browser. ||
| **EdgeBlockInPrivateBrowsing** | Write | Boolean | Indicates whether or not to block InPrivate browsing on corporate networks, in the Edge browser. ||
| **EdgeBlockJavaScript** | Write | Boolean | Indicates whether or not to Block the user from using JavaScript. ||
| **EdgeBlockPasswordManager** | Write | Boolean | Indicates whether or not to Block password manager. ||
| **EdgeBlockAddressBarDropdown** | Write | Boolean | Block the address bar dropdown functionality in Microsoft Edge. Disable this settings to minimize network connections from Microsoft Edge to Microsoft services. ||
| **EdgeBlockCompatibilityList** | Write | Boolean | Block Microsoft compatibility list in Microsoft Edge. This list from Microsoft helps Edge properly display sites with known compatibility issues. ||
| **EdgeClearBrowsingDataOnExit** | Write | Boolean | Clear browsing data on exiting Microsoft Edge. ||
| **EdgeAllowStartPagesModification** | Write | Boolean | Allow users to change Start pages on Edge. Use the EdgeHomepageUrls to specify the Start pages that the user would see by default when they open Edge. ||
| **EdgeDisableFirstRunPage** | Write | Boolean | Block the Microsoft web page that opens on the first use of Microsoft Edge. This policy allows enterprises, like those enrolled in zero emissions configurations, to block this page. ||
| **EdgeBlockLiveTileDataCollection** | Write | Boolean | Block the collection of information by Microsoft for live tile creation when users pin a site to Start from Microsoft Edge. ||
| **EdgeSyncFavoritesWithInternetExplorer** | Write | Boolean | Enable favorites sync between Internet Explorer and Microsoft Edge. Additions, deletions, modifications and order changes to favorites are shared between browsers. ||
| **CellularBlockDataWhenRoaming** | Write | Boolean | Whether or not to Block the user from using data over cellular while roaming. ||
| **CellularBlockVpn** | Write | Boolean | Whether or not to Block the user from using VPN over cellular. ||
| **CellularBlockVpnWhenRoaming** | Write | Boolean | Whether or not to Block the user from using VPN when roaming over cellular. ||
| **DefenderRequireRealTimeMonitoring** | Write | Boolean | Indicates whether or not to require real time monitoring. ||
| **DefenderRequireBehaviorMonitoring** | Write | Boolean | Indicates whether or not to require behavior monitoring. ||
| **DefenderRequireNetworkInspectionSystem** | Write | Boolean | Indicates whether or not to require network inspection system. ||
| **DefenderScanDownloads** | Write | Boolean | Indicates whether or not to scan downloads. ||
| **DefenderScanScriptsLoadedInInternetExplorer** | Write | Boolean | Indicates whether or not to scan scripts loaded in Internet Explorer browser. ||
| **DefenderBlockEndUserAccess** | Write | Boolean | Whether or not to block end user access to Defender. ||
| **DefenderSignatureUpdateIntervalInHours** | Write | UInt64 | The signature update interval in hours. Specify 0 not to check. Valid values 0 to 24 ||
| **DefenderMonitorFileActivity** | Write | String | Value for monitoring file activity. Possible values are: userDefined, disable, monitorAllFiles, monitorIncomingFilesOnly, monitorOutgoingFilesOnly. ||
| **DefenderDaysBeforeDeletingQuarantinedMalware** | Write | UInt64 | Number of days before deleting quarantined malware. Valid values 0 to 90 ||
| **DefenderScanMaxCpu** | Write | UInt64 | Max CPU usage percentage during scan. Valid values 0 to 100 ||
| **DefenderScanArchiveFiles** | Write | Boolean | Indicates whether or not to scan archive files. ||
| **DefenderScanIncomingMail** | Write | Boolean | Indicates whether or not to scan incoming mail messages. ||
| **DefenderScanRemovableDrivesDuringFullScan** | Write | Boolean | Indicates whether or not to scan removable drives during full scan. ||
| **DefenderScanMappedNetworkDrivesDuringFullScan** | Write | Boolean | Indicates whether or not to scan mapped network drives during full scan. ||
| **DefenderScanNetworkFiles** | Write | Boolean | Indicates whether or not to scan files opened from a network folder. ||
| **DefenderRequireCloudProtection** | Write | Boolean | Indicates whether or not to require cloud protection. ||
| **DefenderCloudBlockLevel** | Write | String | Specifies the level of cloud-delivered protection. Possible values are: notConfigured, high, highPlus, zeroTolerance. ||
| **DefenderPromptForSampleSubmission** | Write | String | The configuration for how to prompt user for sample submission. Possible values are: userDefined, alwaysPrompt, promptBeforeSendingPersonalData, neverSendData, sendAllDataWithoutPrompting. ||
| **DefenderScheduledQuickScanTime** | Write | String | The time to perform a daily quick scan. ||
| **DefenderScanType** | Write | String | The defender system scan type. Possible values are: userDefined, disabled, quick, full. ||
| **DefenderSystemScanSchedule** | Write | String | Defender day of the week for the system scan. Possible values are: userDefined, everyday, sunday, monday, tuesday, wednesday, thursday, friday, saturday. ||
| **DefenderScheduledScanTime** | Write | String | The defender time for the system scan. ||
| **DefenderDetectedMalwareActions** | Write | StringArray[] | Gets or sets Defenders actions to take on detected Malware per threat level. ||
| **DefenderFileExtensionsToExclude** | Write | StringArray[] | File extensions to exclude from scans and real time protection. ||
| **DefenderFilesAndFoldersToExclude** | Write | StringArray[] | Files and folder to exclude from scans and real time protection. ||
| **DefenderProcessesToExclude** | Write | StringArray[] | Processes to exclude from scans and real time protection. ||
| **LockScreenAllowTimeoutConfiguration** | Write | Boolean | Specify whether to show a user-configurable setting to control the screen timeout while on the lock screen of Windows 10 Mobile devices. If this policy is set to Allow, the value set by lockScreenTimeoutInSeconds is ignored. ||
| **LockScreenBlockActionCenterNotifications** | Write | Boolean | Indicates whether or not to block action center notifications over lock screen. ||
| **LockScreenBlockCortana** | Write | Boolean | Indicates whether or not the user can interact with Cortana using speech while the system is locked. ||
| **LockScreenBlockToastNotifications** | Write | Boolean | Indicates whether to allow toast notifications above the device lock screen. ||
| **LockScreenTimeoutInSeconds** | Write | UInt64 | Set the duration (in seconds) from the screen locking to the screen turning off for Windows 10 Mobile devices. Supported values are 11-1800. Valid values 11 to 1800 ||
| **PasswordBlockSimple** | Write | UInt64 | Specify whether PINs or passwords such as '1111' or '1234' are allowed. For Windows 10 desktops, it also controls the use of picture passwords. ||
| **PasswordExpirationDays** | Write | UInt64 | The password expiration in days. Valid values 0 to 730 ||
| **PasswordMinimumLength** | Write | UInt64 | The minimum password length. Valid values 4 to 16 ||
| **PasswordMinutesOfInactivityBeforeScreenTimeout** | Write | UInt64 | The minutes of inactivity before the screen times out. ||
| **PasswordMinimumCharacterSetCount** | Write | UInt64 | The number of character sets required in the password. ||
| **PasswordPreviousPasswordBlockCount** | Write | UInt64 | The number of previous passwords to prevent reuse of. Valid values 0 to 50 ||
| **PasswordRequired** | Write | Boolean | Indicates whether or not to require the user to have a password. ||
| **PasswordRequireWhenResumeFromIdleState** | Write | Boolean | Indicates whether or not to require a password upon resuming from an idle state. ||
| **PasswordRequiredType** | Write | String | The required password type. Possible values are: deviceDefault, alphanumeric, numeric. ||
| **PasswordSignInFailureCountBeforeFactoryReset** | Write | Boolean | The number of sign in failures before factory reset. Valid values 0 to 999 ||
| **PrivacyAdvertisingId** | Write | String | Enables or disables the use of advertising ID. Added in Windows 10, version 1607. Possible values are: notConfigured, blocked, allowed. ||
| **PrivacyAutoAcceptPairingAndConsentPrompts** | Write | Boolean | Indicates whether or not to allow the automatic acceptance of the pairing and privacy user consent dialog when launching apps. ||
| **PrivacyBlockInputPersonalization** | Write | Boolean | Indicates whether or not to block the usage of cloud based speech services for Cortana, Dictation, or Store applications. ||
| **StartBlockUnpinningAppsFromTaskbar** | Write | Boolean | Indicates whether or not to block the user from unpinning apps from taskbar. ||
| **StartMenuAppListVisibility** | Write | String | Setting the value of this collapses the app list, removes the app list entirely, or disables the corresponding toggle in the Settings app. Possible values are: userDefined, collapse, remove, disableSettingsApp. ||
| **StartMenuHideChangeAccountSettings** | Write | Boolean | Enabling this policy hides the change account setting from appearing in the user tile in the start menu. ||
| **StartMenuHideFrequentlyUsedApps** | Write | Boolean | Enabling this policy hides the most used apps from appearing on the start menu and disables the corresponding toggle in the Settings app. ||
| **StartMenuHideHibernate** | Write | Boolean | Enabling this policy hides hibernate from appearing in the power button in the start menu. ||
| **StartMenuHideLock** | Write | Boolean | Enabling this policy hides lock from appearing in the user tile in the start menu. ||
| **StartMenuHidePowerButton** | Write | Boolean | Enabling this policy hides the power button from appearing in the start menu. ||
| **StartMenuHideRecentJumpLists** | Write | Boolean | Enabling this policy hides recent jump lists from appearing on the start menu/taskbar and disables the corresponding toggle in the Settings app. ||
| **StartMenuHideRecentlyAddedApps** | Write | Boolean | Enabling this policy hides recently added apps from appearing on the start menu and disables the corresponding toggle in the Settings app. ||
| **StartMenuHideRestartOptions** | Write | Boolean | Enabling this policy hides 'Restart/Update and Restart' from appearing in the power button in the start menu. ||
| **StartMenuHideShutDown** | Write | Boolean | Enabling this policy hides shut down/update and shut down from appearing in the power button in the start menu. ||
| **StartMenuHideSignOut** | Write | Boolean | Enabling this policy hides sign out from appearing in the user tile in the start menu. ||
| **StartMenuHideSleep** | Write | Boolean | Enabling this policy hides sleep from appearing in the power button in the start menu. ||
| **StartMenuHideSwitchAccount** | Write | Boolean | Enabling this policy hides switch account from appearing in the user tile in the start menu. ||
| **StartMenuHideUserTile** | Write | Boolean | Enabling this policy hides the user tile from appearing in the start menu. ||
| **StartMenuLayoutEdgeAssetsXml** | Write | String | This policy setting allows you to import Edge assets to be used with startMenuLayoutXml policy. Start layout can contain secondary tile from Edge app which looks for Edge local asset file. Edge local asset would not exist and cause Edge secondary tile to appear empty in this case. This policy only gets applied when startMenuLayoutXml policy is modified. The value should be a UTF-8 Base64 encoded byte array. ||
| **StartMenuLayoutXml** | Write | String | Allows admins to override the default Start menu layout and prevents the user from changing it. The layout is modified by specifying an XML file based on a layout modification schema. XML needs to be in a UTF8 encoded byte array format. ||
| **StartMenuMode** | Write | String | Allows admins to decide how the Start menu is displayed. Possible values are: userDefined, fullScreen, nonFullScreen. ||
| **StartMenuPinnedFolderDocuments** | Write | String | Enforces the visibility (Show/Hide) of the Documents folder shortcut on the Start menu. Possible values are: notConfigured, hide, show. ||
| **StartMenuPinnedFolderDownloads** | Write | String | Enforces the visibility (Show/Hide) of the Downloads folder shortcut on the Start menu. Possible values are: notConfigured, hide, show. ||
| **StartMenuPinnedFolderFileExplorer** | Write | String | Enforces the visibility (Show/Hide) of the FileExplorer shortcut on the Start menu. Possible values are: notConfigured, hide, show. ||
| **StartMenuPinnedFolderHomeGroup** | Write | String | Enforces the visibility (Show/Hide) of the HomeGroup folder shortcut on the Start menu. Possible values are: notConfigured, hide, show. ||
| **StartMenuPinnedFolderMusic** | Write | String | Enforces the visibility (Show/Hide) of the Music folder shortcut on the Start menu. Possible values are: notConfigured, hide, show. ||
| **StartMenuPinnedFolderNetwork** | Write | String | Enforces the visibility (Show/Hide) of the Network folder shortcut on the Start menu. Possible values are: notConfigured, hide, show. ||
| **StartMenuPinnedFolderPersonalFolder** | Write | String | Enforces the visibility (Show/Hide) of the PersonalFolder shortcut on the Start menu. Possible values are: notConfigured, hide, show. ||
| **StartMenuPinnedFolderPictures** | Write | String | Enforces the visibility (Show/Hide) of the Pictures folder shortcut on the Start menu. Possible values are: notConfigured, hide, show. ||
| **StartMenuPinnedFolderSettings** | Write | String | Enforces the visibility (Show/Hide) of the Settings folder shortcut on the Start menu. Possible values are: notConfigured, hide, show. ||
| **StartMenuPinnedFolderVideos** | Write | String | Enforces the visibility (Show/Hide) of the Videos folder shortcut on the Start menu. Possible values are: notConfigured, hide, show. ||
| **SettingsBlockSettingsApp** | Write | Boolean | Indicates whether or not to block access to Settings app. ||
| **SettingsBlockSystemPage** | Write | Boolean | Indicates whether or not to block access to System in Settings app. ||
| **SettingsBlockDevicesPage** | Write | Boolean | Indicates whether or not to block access to Devices in Settings app. ||
| **SettingsBlockNetworkInternetPage** | Write | Boolean | Indicates whether or not to block access to Network & Internet in Settings app. ||
| **SettingsBlockPersonalizationPage** | Write | Boolean | Indicates whether or not to block access to Personalization in Settings app. ||
| **SettingsBlockAccountsPage** | Write | Boolean | Indicates whether or not to block access to Accounts in Settings app. ||
| **SettingsBlockTimeLanguagePage** | Write | Boolean | Indicates whether or not to block access to Time & Language in Settings app. ||
| **SettingsBlockEaseOfAccessPage** | Write | Boolean | Indicates whether or not to block access to Ease of Access in Settings app. ||
| **SettingsBlockPrivacyPage** | Write | Boolean | Indicates whether or not to block access to Privacy in Settings app. ||
| **SettingsBlockUpdateSecurityPage** | Write | Boolean | Indicates whether or not to block access to Update & Security in Settings app. ||
| **SettingsBlockAppsPage** | Write | Boolean | Indicates whether or not to block access to Apps in Settings app. ||
| **SettingsBlockGamingPage** | Write | Boolean | Indicates whether or not to block access to Gaming in Settings app. ||
| **WindowsSpotlightBlockConsumerSpecificFeatures** | Write | Boolean | Allows IT admins to block experiences that are typically for consumers only, such as Start suggestions, Membership notifications, Post-OOBE app install and redirect tiles. ||
| **WindowsSpotlightBlocked** | Write | Boolean | Allows IT admins to turn off all Windows Spotlight features ||
| **WindowsSpotlightBlockOnActionCenter** | Write | Boolean | Block suggestions from Microsoft that show after each OS clean install, upgrade or in an on-going basis to introduce users to what is new or changed ||
| **WindowsSpotlightBlockTailoredExperiences** | Write | Boolean | Block personalized content in Windows spotlight based on users device usage. ||
| **WindowsSpotlightBlockThirdPartyNotifications** | Write | Boolean | Block third party content delivered via Windows Spotlight ||
| **WindowsSpotlightBlockWelcomeExperience** | Write | Boolean | Block Windows Spotlight Windows welcome experience ||
| **WindowsSpotlightBlockWindowsTips** | Write | Boolean | Allows IT admins to turn off the popup of Windows Tips. ||
| **WindowsSpotlightConfigureOnLockScreen** | Write | String | Specifies the type of Spotlight. Possible values are: notConfigured, disabled, enabled. ||
| **NetworkProxyApplySettingsDeviceWide** | Write | Boolean | If set, proxy settings will be applied to all processes and accounts in the device. Otherwise, it will be applied to the user account thats enrolled into MDM. ||
| **NetworkProxyDisableAutoDetect** | Write | Boolean | Disable automatic detection of settings. If enabled, the system will try to find the path to a proxy auto-config (PAC) script. ||
| **NetworkProxyAutomaticConfigurationUrl** | Write | String | Address to the proxy auto-config (PAC) script you want to use. ||
| **NetworkProxyServer** | Write | StringArray[] | Specifies manual proxy server settings. ||
| **AccountsBlockAddingNonMicrosoftAccountEmail** | Write | Boolean | Indicates whether or not to Block the user from adding email accounts to the device that are not associated with a Microsoft account. ||
| **AntiTheftModeBlocked** | Write | Boolean | Indicates whether or not to block the user from selecting an AntiTheft mode preference (Windows 10 Mobile only). ||
| **BluetoothBlocked** | Write | Boolean | Whether or not to Block the user from using bluetooth. ||
| **CameraBlocked** | Write | Boolean | Whether or not to Block the user from accessing the camera of the device. ||
| **ConnectedDevicesServiceBlocked** | Write | Boolean | Whether or not to block Connected Devices Service which enables discovery and connection to other devices, remote messaging, remote app sessions and other cross-device experiences. ||
| **CertificatesBlockManualRootCertificateInstallation** | Write | Boolean | Whether or not to Block the user from doing manual root certificate installation. ||
| **CopyPasteBlocked** | Write | Boolean | Whether or not to Block the user from using copy paste. ||
| **CortanaBlocked** | Write | Boolean | Whether or not to Block the user from using Cortana. ||
| **DeviceManagementBlockFactoryResetOnMobile** | Write | Boolean | Indicates whether or not to Block the user from resetting their phone. ||
| **DeviceManagementBlockManualUnenroll** | Write | Boolean | Indicates whether or not to Block the user from doing manual un-enrollment from device management. ||
| **SafeSearchFilter** | Write | String | Specifies what filter level of safe search is required. Possible values are: userDefined, strict, moderate. ||
| **EdgeBlockPopups** | Write | Boolean | Indicates whether or not to block popups. ||
| **EdgeBlockSearchSuggestions** | Write | Boolean | Indicates whether or not to block the user from using the search suggestions in the address bar. ||
| **EdgeBlockSendingIntranetTrafficToInternetExplorer** | Write | Boolean | Indicates whether or not to switch the intranet traffic from Edge to Internet Explorer. Note: the name of this property is misleading; the property is obsolete, use EdgeSendIntranetTrafficToInternetExplorer instead. ||
| **EdgeSendIntranetTrafficToInternetExplorer** | Write | Boolean | Indicates whether or not to switch the intranet traffic from Edge to Internet Explorer. ||
| **EdgeRequireSmartScreen** | Write | Boolean | Indicates whether or not to Require the user to use the smart screen filter. ||
| **EdgeEnterpriseModeSiteListLocation** | Write | Boolean | Indicates the enterprise mode site list location. Could be a local file, local network or http location. ||
| **EdgeFirstRunUrl** | Write | String | The first run URL for when Edge browser is opened for the first time. ||
| **EdgeSearchEngine** | Write | String | Allows IT admins to set a default search engine for MDM-Controlled devices. Users can override this and change their default search engine provided the AllowSearchEngineCustomization policy is not set. ||
| **EdgeHomepageUrls** | Write | StringArray[] | The list of URLs for homepages shodwn on MDM-enrolled devices on Edge browser. ||
| **EdgeBlockAccessToAboutFlags** | Write | Boolean | Indicates whether or not to prevent access to about flags on Edge browser. ||
| **SmartScreenBlockPromptOverride** | Write | Boolean | Indicates whether or not users can override SmartScreen Filter warnings about potentially malicious websites. ||
| **SmartScreenBlockPromptOverrideForFiles** | Write | Boolean | Indicates whether or not users can override the SmartScreen Filter warnings about downloading unverified files ||
| **WebRtcBlockLocalhostIpAddress** | Write | Boolean | Indicates whether or not user's localhost IP address is displayed while making phone calls using the WebRTC ||
| **InternetSharingBlocked** | Write | Boolean | Indicates whether or not to Block the user from using internet sharing. ||
| **SettingsBlockAddProvisioningPackage** | Write | Boolean | Indicates whether or not to block the user from installing provisioning packages. ||
| **SettingsBlockRemoveProvisioningPackage** | Write | Boolean | Indicates whether or not to block the runtime configuration agent from removing provisioning packages. ||
| **SettingsBlockChangeSystemTime** | Write | Boolean | Indicates whether or not to block the user from changing date and time settings. ||
| **SettingsBlockEditDeviceName** | Write | Boolean | Indicates whether or not to block the user from editing the device name. ||
| **SettingsBlockChangeRegion** | Write | Boolean | Indicates whether or not to block the user from changing the region settings. ||
| **SettingsBlockChangeLanguage** | Write | Boolean | Indicates whether or not to block the user from changing the language settings. ||
| **SettingsBlockChangePowerSleep** | Write | Boolean | Indicates whether or not to block the user from changing power and sleep settings. ||
| **LocationServicesBlocked** | Write | Boolean | Indicates whether or not to Block the user from location services. ||
| **MicrosoftAccountBlocked** | Write | Boolean | Indicates whether or not to Block a Microsoft account. ||
| **MicrosoftAccountBlockSettingsSync** | Write | Boolean | Indicates whether or not to Block Microsoft account settings sync. ||
| **NfcBlocked** | Write | Boolean | Indicates whether or not to Block the user from using near field communication. ||
| **ResetProtectionModeBlocked** | Write | Boolean | Indicates whether or not to Block the user from reset protection mode. ||
| **ScreenCaptureBlocked** | Write | Boolean | Indicates whether or not to Block the user from taking Screenshots. ||
| **StorageBlockRemovableStorage** | Write | Boolean | Indicates whether or not to Block the user from using removable storage. ||
| **StorageRequireMobileDeviceEncryption** | Write | Boolean | Indicating whether or not to require encryption on a mobile device. ||
| **UsbBlocked** | Write | Boolean | Indicates whether or not to Block the user from USB connection. ||
| **VoiceRecordingBlocked** | Write | Boolean | Indicates whether or not to Block the user from voice recording. ||
| **WiFiBlockAutomaticConnectHotspots** | Write | Boolean | Indicating whether or not to block automatically connecting to Wi-Fi hotspots. Has no impact if Wi-Fi is blocked. ||
| **WiFiBlocked** | Write | Boolean | Indicates whether or not to Block the user from using Wi-Fi. ||
| **WiFiBlockManualConfiguration** | Write | Boolean | Indicates whether or not to Block the user from using Wi-Fi manual configuration. ||
| **WiFiScanInterval** | Write | UInt64 | Specify how often devices scan for Wi-Fi networks. Supported values are 1-500, where 100 = default, and 500 = low frequency. Valid values 1 to 500 ||
| **WirelessDisplayBlockProjectionToThisDevice** | Write | Boolean | Indicates whether or not to allow other devices from discovering this PC for projection. ||
| **WirelessDisplayBlockUserInputFromReceiver** | Write | Boolean | Indicates whether or not to allow user input from wireless display receiver. ||
| **WirelessDisplayRequirePinForPairing** | Write | Boolean | Indicates whether or not to require a PIN for new devices to initiate pairing. ||
| **WindowsStoreBlocked** | Write | Boolean | Indicates whether or not to Block the user from using the Windows store. ||
| **AppsAllowTrustedAppsSideloading** | Write | String | Indicates whether apps from AppX packages signed with a trusted certificate can be side loaded. Possible values are: notConfigured, blocked, allowed. ||
| **WindowsStoreBlockAutoUpdate** | Write | Boolean | Indicates whether or not to block automatic update of apps from Windows Store. ||
| **DeveloperUnlockSetting** | Write | String | Indicates whether or not to allow developer unlock. Possible values are: notConfigured, blocked, allowed. ||
| **SharedUserAppDataAllowed** | Write | Boolean | Indicates whether or not to block multiple users of the same app to share data. ||
| **AppsBlockWindowsStoreOriginatedApps** | Write | Boolean | Indicates whether or not to disable the launch of all apps from Windows Store that came pre-installed or were downloaded. ||
| **WindowsStoreEnablePrivateStoreOnly** | Write | Boolean | Indicates whether or not to enable Private Store Only. ||
| **StorageRestrictAppDataToSystemVolume** | Write | Boolean | Indicates whether application data is restricted to the system drive. ||
| **StorageRestrictAppInstallToSystemVolume** | Write | Boolean | Indicates whether the installation of applications is restricted to the system drive. ||
| **GameDvrBlocked** | Write | Boolean | Indicates whether or not to block DVR and broadcasting. ||
| **ExperienceBlockDeviceDiscovery** | Write | Boolean | Indicates whether or not to enable device discovery UX. ||
| **ExperienceBlockErrorDialogWhenNoSIM** | Write | Boolean | NIndicates whether or not to allow the error dialog from displaying if no SIM card is detected. ||
| **ExperienceBlockTaskSwitcher** | Write | Boolean | Indicates whether or not to enable task switching on the device. ||
| **LogonBlockFastUserSwitching** | Write | Boolean | Disables the ability to quickly switch between users that are logged on simultaneously without logging off. ||
| **TenantLockdownRequireNetworkDuringOutOfBoxExperience** | Write | Boolean | Whether the device is required to connect to the network. ||
| **Ensure** | Write | String | Present ensures the site collection exists, absent ensures it is removed |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Intune Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||


# IntuneDeviceConfigurationPolicyWindows10

This resource configures an Intune device configuration profile for an Windows 10 Device.

## Examples

### Example 1

This example creates a new General Device Configuration Policy for Windows .

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
        IntuneDeviceConfigurationPolicyWindows10 'ConfigureDeviceConfigurationPolicyWindows10'
        {
            displayName                                           = "CONTOSO | W10 | Device Restriction"
            description                                           = "Default device restriction settings"
            defenderBlockEndUserAccess                            = $true
            defenderRequireRealTimeMonitoring                     = $true
            defenderRequireBehaviorMonitoring                     = $true
            defenderRequireNetworkInspectionSystem                = $true
            defenderScanDownloads                                 = $true
            defenderScanScriptsLoadedInInternetExplorer           = $true
            defenderSignatureUpdateIntervalInHours                = 8
            defenderMonitorFileActivity                           = 'monitorIncomingFilesOnly'  # userDefined,monitorAllFiles,monitorIncomingFilesOnly,monitorOutgoingFilesOnly
            defenderDaysBeforeDeletingQuarantinedMalware          = 3
            defenderScanMaxCpu                                    = 2
            defenderScanArchiveFiles                              = $true
            defenderScanIncomingMail                              = $true
            defenderScanRemovableDrivesDuringFullScan             = $true
            defenderScanMappedNetworkDrivesDuringFullScan         = $false
            defenderScanNetworkFiles                              = $false
            defenderRequireCloudProtection                        = $true
            defenderCloudBlockLevel                               = 'high'
            defenderPromptForSampleSubmission                     = 'alwaysPrompt'
            defenderScheduledQuickScanTime                        = '13:00:00.0000000'
            defenderScanType                                      = 'quick'   #quick,full,userDefined
            defenderSystemScanSchedule                            = 'monday'  #days of week
            defenderScheduledScanTime                             = '11:00:00.0000000'
            defenderDetectedMalwareActions                        = @("lowSeverity=clean", "moderateSeverity=quarantine", "highSeverity=remove", "severeSeverity=block")
            defenderFileExtensionsToExclude                       = "[`"csv,jpg,docx`"]"
            defenderFilesAndFoldersToExclude                      = "[`"c:\\2,C:\\1`"]"
            defenderProcessesToExclude                            = "[`"notepad.exe,c:\\Windows\\myprocess.exe`"]"
            lockScreenAllowTimeoutConfiguration                   = $true
            lockScreenBlockActionCenterNotifications              = $true
            lockScreenBlockCortana                                = $true
            lockScreenBlockToastNotifications                     = $false
            lockScreenTimeoutInSeconds                            = 90
            passwordBlockSimple                                   = $true
            passwordExpirationDays                                = 6
            passwordMinimumLength                                 = 5
            passwordMinutesOfInactivityBeforeScreenTimeout        = 15
            passwordMinimumCharacterSetCount                      = 1
            passwordPreviousPasswordBlockCount                    = 2
            passwordRequired                                      = $true
            passwordRequireWhenResumeFromIdleState                = $true
            passwordRequiredType                                  = "alphanumeric"
            passwordSignInFailureCountBeforeFactoryReset          = 12
            privacyAdvertisingId                                  = "blocked"
            privacyAutoAcceptPairingAndConsentPrompts             = $true
            privacyBlockInputPersonalization                      = $true
            startBlockUnpinningAppsFromTaskbar                    = $true
            startMenuAppListVisibility                            = "collapse"
            startMenuHideChangeAccountSettings                    = $true
            startMenuHideFrequentlyUsedApps                       = $true
            startMenuHideHibernate                                = $true
            startMenuHideLock                                     = $true
            startMenuHidePowerButton                              = $true
            startMenuHideRecentJumpLists                          = $true
            startMenuHideRecentlyAddedApps                        = $true
            startMenuHideRestartOptions                           = $true
            startMenuHideShutDown                                 = $true
            startMenuHideSignOut                                  = $true
            startMenuHideSleep                                    = $true
            startMenuHideSwitchAccount                            = $true
            startMenuHideUserTile                                 = $true
            startMenuLayoutXml                                    = "+DQogICAGlmaWNhdGlvblRlbXBsYXRlPg=="
            startMenuMode                                         = "fullScreen"
            startMenuPinnedFolderDocuments                        = "hide"
            startMenuPinnedFolderDownloads                        = "hide"
            startMenuPinnedFolderFileExplorer                     = "hide"
            startMenuPinnedFolderHomeGroup                        = "hide"
            startMenuPinnedFolderMusic                            = "hide"
            startMenuPinnedFolderNetwork                          = "hide"
            startMenuPinnedFolderPersonalFolder                   = "hide"
            startMenuPinnedFolderPictures                         = "hide"
            startMenuPinnedFolderSettings                         = "hide"
            startMenuPinnedFolderVideos                           = "hide"
            settingsBlockSettingsApp                              = $true
            settingsBlockSystemPage                               = $true
            settingsBlockDevicesPage                              = $true
            settingsBlockNetworkInternetPage                      = $true
            settingsBlockPersonalizationPage                      = $true
            settingsBlockAccountsPage                             = $true
            settingsBlockTimeLanguagePage                         = $true
            settingsBlockEaseOfAccessPage                         = $true
            settingsBlockPrivacyPage                              = $true
            settingsBlockUpdateSecurityPage                       = $true
            settingsBlockAppsPage                                 = $true
            settingsBlockGamingPage                               = $true
            windowsSpotlightBlockConsumerSpecificFeatures         = $true
            windowsSpotlightBlocked                               = $true
            windowsSpotlightBlockOnActionCenter                   = $true
            windowsSpotlightBlockTailoredExperiences              = $true
            windowsSpotlightBlockThirdPartyNotifications          = $true
            windowsSpotlightBlockWelcomeExperience                = $true
            windowsSpotlightBlockWindowsTips                      = $true
            windowsSpotlightConfigureOnLockScreen                 = "disabled"
            networkProxyApplySettingsDeviceWide                   = $true
            networkProxyDisableAutoDetect                         = $true
            networkProxyAutomaticConfigurationUrl                 = "https://example.com/networkProxyAutomaticConfigurationUrl/"
            accountsBlockAddingNonMicrosoftAccountEmail           = $true
            antiTheftModeBlocked                                  = $true
            bluetoothBlocked                                      = $true
            bluetoothAllowedServices                              = "[`"8e473eaa-ead4-4c60-ba9c-2c5696d71492`",`"21913f2d-a803-4f36-8039-669fd94ce5b3`"]"
            bluetoothBlockAdvertising                             = $true
            bluetoothBlockDiscoverableMode                        = $true
            bluetoothBlockPrePairing                              = $true
            cameraBlocked                                         = $true
            connectedDevicesServiceBlocked                        = $true
            certificatesBlockManualRootCertificateInstallation    = $true
            copyPasteBlocked                                      = $true
            cortanaBlocked                                        = $true
            deviceManagementBlockFactoryResetOnMobile             = $true
            deviceManagementBlockManualUnenroll                   = $true
            safeSearchFilter                                      = "strict"
            edgeBlockPopups                                       = $true
            edgeBlockSearchSuggestions                            = $true
            edgeBlockSendingIntranetTrafficToInternetExplorer     = $true
            edgeSendIntranetTrafficToInternetExplorer             = $true
            edgeRequireSmartScreen                                = $true
            edgeFirstRunUrl                                       = "https://contoso.com/"
            edgeBlockAccessToAboutFlags                           = $true
            edgeHomepageUrls                                      = "[`"https://microsoft.com`"]"
            smartScreenBlockPromptOverride                        = $true
            smartScreenBlockPromptOverrideForFiles                = $true
            webRtcBlockLocalhostIpAddress                         = $true
            internetSharingBlocked                                = $true
            settingsBlockAddProvisioningPackage                   = $true
            settingsBlockRemoveProvisioningPackage                = $true
            settingsBlockChangeSystemTime                         = $true
            settingsBlockEditDeviceName                           = $true
            settingsBlockChangeRegion                             = $true
            settingsBlockChangeLanguage                           = $true
            settingsBlockChangePowerSleep                         = $true
            locationServicesBlocked                               = $true
            microsoftAccountBlocked                               = $true
            microsoftAccountBlockSettingsSync                     = $true
            nfcBlocked                                            = $true
            resetProtectionModeBlocked                            = $true
            screenCaptureBlocked                                  = $true
            storageBlockRemovableStorage                          = $true
            storageRequireMobileDeviceEncryption                  = $true
            usbBlocked                                            = $true
            voiceRecordingBlocked                                 = $true
            wiFiBlockAutomaticConnectHotspots                     = $true
            wiFiBlocked                                           = $true
            wiFiBlockManualConfiguration                          = $true
            wiFiScanInterval                                      = 1
            wirelessDisplayBlockProjectionToThisDevice            = $true
            wirelessDisplayBlockUserInputFromReceiver             = $true
            wirelessDisplayRequirePinForPairing                   = $true
            windowsStoreBlocked                                   = $true
            appsAllowTrustedAppsSideloading                       = "blocked"
            windowsStoreBlockAutoUpdate                           = $true
            developerUnlockSetting                                = "blocked"
            sharedUserAppDataAllowed                              = $true
            appsBlockWindowsStoreOriginatedApps                   = $true
            windowsStoreEnablePrivateStoreOnly                    = $true
            storageRestrictAppDataToSystemVolume                  = $true
            storageRestrictAppInstallToSystemVolume               = $true
            gameDvrBlocked                                        = $true
            edgeSearchEngine                                      = "bing"
            #edgeSearchEngine                                     = "https://go.microsoft.com/fwlink/?linkid=842596"  #'Google'
            experienceBlockDeviceDiscovery                        = $true
            experienceBlockErrorDialogWhenNoSIM                   = $true
            experienceBlockTaskSwitcher                           = $true
            logonBlockFastUserSwitching                           = $true
            tenantLockdownRequireNetworkDuringOutOfBoxExperience  = $true
            enterpriseCloudPrintDiscoveryEndPoint                 = "https://cloudprinterdiscovery.contoso.com"
            enterpriseCloudPrintDiscoveryMaxLimit                 = 4
            enterpriseCloudPrintMopriaDiscoveryResourceIdentifier = "http://mopriadiscoveryservice/cloudprint"
            enterpriseCloudPrintOAuthClientIdentifier             = "30fbf7e8-321c-40ce-8b9f-160b6b049257"
            enterpriseCloudPrintOAuthAuthority                    = "https:/tenant.contoso.com/adfs"
            enterpriseCloudPrintResourceIdentifier                = "http://cloudenterpriseprint/cloudPrint"
            networkProxyServer                                    = @("address=proxy.contoso.com:8080", "exceptions=*.contoso.com`r`n*.internal.local", "useForLocalAddresses=false")
            Ensure                                                = 'Present'
            Credential                                            = $credsGlobalAdmin
        }
    }
}
```

