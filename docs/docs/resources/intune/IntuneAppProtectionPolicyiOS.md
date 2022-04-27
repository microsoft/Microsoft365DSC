# IntuneAppProtectionPolicyiOS

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | Display name of the iOS App Protection Policy. ||
| **Description** | Write | String | Description of the iOS App Protection Policy. ||
| **PeriodOfflineBeforeAccessCheck** | Write | String | The period after which access is checked when the device is not connected to the internet. ||
| **PeriodOnlineBeforeAccessCheck** | Write | String | The period after which access is checked when the device is connected to the internet. ||
| **AllowedInboundDataTransferSources** | Write | String | Sources from which data is allowed to be transferred. Possible values are: allApps, managedApps, none. |allApps, managedApps, none|
| **AllowedOutboundDataTransferDestinations** | Write | String | Destinations to which data is allowed to be transferred. Possible values are: allApps, managedApps, none. |allApps, managedApps, none|
| **OrganizationalCredentialsRequired** | Write | Boolean | Indicates whether organizational credentials are required for app use. ||
| **AllowedOutboundClipboardSharingLevel** | Write | String | The level to which the clipboard may be shared between apps on the managed device. Possible values are: allApps, managedAppsWithPasteIn, managedApps, blocked. |allApps, managedAppsWithPasteIn, managedApps, blocked|
| **DataBackupBlocked** | Write | Boolean | Indicates whether the backup of a managed app's data is blocked. ||
| **DeviceComplianceRequired** | Write | Boolean | Indicates whether device compliance is required. ||
| **ManagedBrowserToOpenLinksRequired** | Write | Boolean | Indicates whether internet links should be opened in the managed browser app, or any custom browser specified by CustomBrowserProtocol (for iOS) or CustomBrowserPackageId/CustomBrowserDisplayName (for Android). ||
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
| **FaceIdBlocked** | Write | Boolean | Indicates whether use of the FaceID is allowed in place of a pin if PinRequired is set to True. ||
| **IsAssigned** | Write | Boolean | Indicates if the policy is deployed to any inclusion groups or not. Inherited from targetedManagedAppProtection. ||
| **ManagedBrowser** | Write | String | Indicates in which managed browser(s) that internet links should be opened. When this property is configured, ManagedBrowserToOpenLinksRequired should be true. Possible values are: notConfigured, microsoftEdge. |notConfigured, microsoftEdge|
| **MinimumRequiredAppVersion** | Write | String | Versions less than the specified version will block the managed app from accessing company data. ||
| **MinimumRequiredOSVersion** | Write | String | Versions less than the specified version will block the managed app from accessing company data. ||
| **MinimumRequiredSdkVersion** | Write | String | Versions less than the specified version will block the managed app from accessing company data. ||
| **MinimumWarningAppVersion** | Write | String | Versions less than the specified version will result in warning message on the managed app ||
| **MinimumWarningOSVersion** | Write | String | Versions less than the specified version will result in warning message on the managed app from accessing company data. ||
| **AppDataEncryptionType** | Write | String | Require app data to be encrypted. ||
| **Apps** | Write | StringArray[] | List of IDs representing the iOS apps controlled by this protection policy. ||
| **Assignments** | Write | StringArray[] | List of IDs of the groups assigned to this iOS Protection Policy. ||
| **ExcludedGroups** | Write | StringArray[] | List of IDs of the groups that are excluded from this iOS Protection Policy. ||
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Intune Admin ||
| **ApplicationId** | Write | String | ID of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | ID of the Azure Active Directory tenant used for authentication. ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||


# IntuneAppProtectionPolicyiOS

This resource configures an Intune app protection policy for an iOS Device.

## Examples

### Example 1

This example creates a new App ProtectionPolicy for iOS.

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
        IntuneAppProtectionPolicyiOS 'MyCustomiOSPolicy'
        {
            AllowedDataStorageLocations             = @("sharePoint")
            AllowedInboundDataTransferSources       = "managedApps"
            AllowedOutboundClipboardSharingLevel    = "managedAppsWithPasteIn"
            AllowedOutboundDataTransferDestinations = "managedApps"
            AppDataEncryptionType                   = "whenDeviceLocked"
            Apps                                    = @("com.cisco.jabberimintune.ios","com.pervasent.boardpapers.ios","com.sharefile.mobile.intune.ios")
            Assignments                             = @("6ee86c9f-2b3c-471d-ad38-ff4673ed723e")
            ContactSyncBlocked                      = $False
            DataBackupBlocked                       = $False
            Description                             = ""
            DeviceComplianceRequired                = $True
            DisplayName                             = "My DSC iOS App Protection Policy"
            ExcludedGroups                          = @("3eacc231-d77b-4efb-bb5f-310f68bd6198")
            FingerprintBlocked                      = $False
            ManagedBrowserToOpenLinksRequired       = $True
            MaximumPinRetries                       = 5
            MinimumPinLength                        = 4
            OrganizationalCredentialsRequired       = $False
            PeriodOfflineBeforeAccessCheck          = "PT12H"
            PeriodOfflineBeforeWipeIsEnforced       = "P90D"
            PeriodOnlineBeforeAccessCheck           = "PT30M"
            PinCharacterSet                         = "alphanumericAndSymbol"
            PinRequired                             = $True
            PrintBlocked                            = $False
            SaveAsBlocked                           = $True
            SimplePinBlocked                        = $False
            Ensure                                  = 'Present'
            Credential                              = $credsGlobalAdmin
        }
    }
}
```

