# IntuneDeviceFeaturesConfigurationPolicyIOS

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | Id of the Intune policy. | |
| **DisplayName** | Key | String | Display name of the Intune policy. | |
| **Description** | Write | String | Description of the Intune policy. | |
| **Assignments** | Write | MSFT_DeviceManagementConfigurationPolicyAssignments[] | Represents the assignment to the Intune policy. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Intune Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |
| **RoleScopeTagIds** | Write | StringArray[] | List of Scope Tags for this Entity instance. Inherited from deviceConfiguration. | |
| **DeviceManagementApplicabilityRuleOsEdition** | Write | MSFT_deviceManagementApplicabilityRuleOsEdition[] | The OS edition applicability for this Policy. Inherited from deviceConfiguration. | |
| **DeviceManagementApplicabilityRuleOsVersion** | Write | MSFT_deviceManagementApplicabilityRuleOsVersion[] | The OS version applicability rule for this Policy. Inherited from deviceConfiguration. | |
| **DeviceManagementApplicabilityRuleDeviceMode** | Write | MSFT_deviceManagementApplicabilityRuleDeviceMode[] | The device mode applicability rule for this Policy. Inherited from deviceConfiguration. | |
| **AirPrintDestinations** | Write | MSFT_airPrintDestination[] | An array of AirPrint printers that should always be shown. | |
| **AssetTagTemplate** | Write | String | Asset tag information for the device, displayed on the login window and lock screen. | |
| **ContentFilterSettings** | Write | MSFT_iosWebContentFilterSpecificWebsitesAccess[] | Gets or sets iOS Web Content Filter settings, supervised mode only. | |
| **LockScreenFootnote** | Write | String | A footnote displayed on the login window and lock screen. Available in iOS 9.3.1 and later. | |
| **HomeScreenDockIcons** | Write | MSFT_iosHomeScreenApp[] | A list of app and folders to appear on the Home Screen Dock. This collection can contain a maximum of 500 elements. | |
| **HomeScreenPages** | Write | MSFT_iosHomeScreenItem[] | A list of pages on the Home Screen. This collection can contain a maximum of 500 elements. | |
| **HomeScreenGridWidth** | Write | UInt32 | Gets or sets the number of columns to render when configuring iOS home screen layout settings. If this value is configured, homeScreenGridHeight must be configured as well. | |
| **HomeScreenGridHeight** | Write | UInt32 | Gets or sets the number of rows to render when configuring iOS home screen layout settings. If this value is configured, homeScreenGridWidth must be configured as well. | |
| **NotificationSettings** | Write | MSFT_iosNotificationSettings[] | Notification settings for each bundle id. Applicable to devices in supervised mode only (iOS 9.3 and later). | |
| **SingleSignOnSettings** | Write | MSFT_iosSingleSignOnSettings[] | The Kerberos login settings that enable apps on receiving devices to authenticate smoothly. | |
| **WallpaperDisplayLocation** | Write | String | A wallpaper display location specifier. Possible values are: notConfigured, lockScreen, homeScreen, lockAndHomeScreens. | `notConfigured`, `lockScreen`, `homeScreen`, `lockAndHomeScreens` |
| **WallpaperImage** | Write | MSFT_mimeContent[] | A wallpaper image must be in either PNG or JPEG format. It requires a supervised device with iOS 8 or later version. | |
| **IosSingleSignOnExtension** | Write | MSFT_iosSingleSignOnExtension[] | Gets or sets a single sign-on extension profile. | |

### MSFT_DeviceManagementConfigurationPolicyAssignments

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **dataType** | Write | String | The type of the target assignment. | `#microsoft.graph.groupAssignmentTarget`, `#microsoft.graph.allLicensedUsersAssignmentTarget`, `#microsoft.graph.allDevicesAssignmentTarget`, `#microsoft.graph.exclusionGroupAssignmentTarget`, `#microsoft.graph.configurationManagerCollectionAssignmentTarget` |
| **deviceAndAppManagementAssignmentFilterType** | Write | String | The type of filter of the target assignment i.e. Exclude or Include. Possible values are:none, include, exclude. | `none`, `include`, `exclude` |
| **deviceAndAppManagementAssignmentFilterId** | Write | String | The Id of the filter for the target assignment. | |
| **groupId** | Write | String | The group Id that is the target of the assignment. | |
| **groupDisplayName** | Write | String | The group Display Name that is the target of the assignment. | |
| **collectionId** | Write | String | The collection Id that is the target of the assignment.(ConfigMgr) | |

### MSFT_airPrintDestination

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **ipAddress** | Write | String | The IP Address of the AirPrint destination. | |
| **resourcePath** | Write | String | The Resource Path associated with the printer. This corresponds to the rp parameter of the _ipps.tcp Bonjour record. For example: printers/Canon_MG5300_series, printers/Xerox_Phaser_7600, ipp/print, Epson_IPP_Printer. | |
| **port** | Write | UInt32 | The listening port of the AirPrint destination. If this key is not specified, AirPrint will use the default port. Available in iOS 11.0 and later. | |
| **forceTls** | Write | Boolean | If true, AirPrint connections are secured by Transport Layer Security (TLS). Default is false. Available in iOS 11.0 and later. | |

### MSFT_iosWebContentFilterBase

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **url** | Write | String | url. | |
| **bookmarkFolder** | Write | String | bookmarkFolder. | |
| **displayName** | Write | String | displayName. | |

### MSFT_iosWebContentFilterSpecificWebsitesAccess

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **dataType** | Write | String | The type of data. | |
| **specificWebsitesOnly** | Write | MSFT_iosWebContentFilterBase[] | specificWebsitesOnly, embedded instance of iosWebContentFilterBase. | |
| **websiteList** | Write | MSFT_iosWebContentFilterBase[] | websiteList, embedded instance of iosWebContentFilterBase. | |
| **allowedUrls** | Write | StringArray[] | allowedUrls. | |
| **blockedUrls** | Write | StringArray[] | blockedUrls. | |

### MSFT_iosHomeScreenApp

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **displayName** | Write | String | Name of the app. Inherited from iosHomeScreenItem. | |
| **bundleID** | Write | String | BundleID of the app if isWebClip is false or the URL of a web clip if isWebClip is true. | |
| **isWebClip** | Write | Boolean | Is it a website URL or an app | |

### MSFT_iosHomeScreenItem

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **icons** | Write | MSFT_iosHomeScreenApp[] | A list of apps, folders, and web clips to appear on a page. This collection can contain a maximum of 500 elements. | |

### MSFT_iosNotificationSettings

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **bundleID** | Write | String | Bundle id of the app to which to apply these notification settings. | |
| **appName** | Write | String | Application name to be associated with the BundleID. | |
| **publisher** | Write | String | Publisher to be associated with the BundleID. | |
| **enabled** | Write | Boolean | Indicates whether notifications are allowed for this app. | |
| **showInNotificationCenter** | Write | Boolean | Indicates whether notifications can be shown in the notification center. | |
| **showOnLockScreen** | Write | Boolean | Indicates whether notifications can be shown on the lock screen. | |
| **alertType** | Write | String | Indicates the type of alert for notifications for this app. Possible values are: deviceDefault, banner, modal, none. | `deviceDefault`, `banner`, `modal`, `none` |
| **badgesEnabled** | Write | Boolean | Indicates whether badges are allowed for this app. | |
| **soundsEnabled** | Write | Boolean | Indicates whether sounds are allowed for this app. | |
| **previewVisibility** | Write | String | Overrides the notification preview policy set by the user on an iOS device. Possible values are: notConfigured, alwaysShow, hideWhenLocked, neverShow. | `notConfigured`, `alwaysShow`, `hideWhenLocked`, `neverShow` |

### MSFT_appListItem

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **name** | Write | String | The application name. | |
| **publisher** | Write | String | The publisher of the application. | |
| **appStoreUrl** | Write | String | The Store URL of the application. | |
| **appId** | Write | String | The application or bundle identifier of the application. | |

### MSFT_iosSingleSignOnSettings

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **allowedAppsList** | Write | MSFT_appListItem[] | List of app identifiers that are allowed to use this login. If this field is omitted, the login applies to all applications on the device. This collection can contain a maximum of 500 elements. | |
| **allowedUrls** | Write | StringArray[] | List of HTTP URLs that must be matched in order to use this login. With iOS 9.0 or later, wildcard characters may be used. | |
| **displayName** | Write | String | The display name of login settings shown on the receiving device. | |
| **kerberosPrincipalName** | Write | String | A Kerberos principal name. If not provided, the user is prompted for one during profile installation. | |
| **kerberosRealm** | Write | String | A Kerberos realm name. Case sensitive. | |

### MSFT_mimeContent

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **type** | Write | String | Indicates the content mime type. | |
| **value** | Write | StringArray[] | The byte array that contains the actual content. | |

### MSFT_keyTypedValuePair

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **dataType** | Write | String | The type of data. | |
| **key** | Write | String | Key for the custom data entry. | |
| **value** | Write | String | Value for the custom data entry. | |

### MSFT_iosSingleSignOnExtension

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **dataType** | Write | String | The type of data. | |
| **Realm** | Write | String | The case-sensitive realm name for this profile. | |
| **Domains** | Write | StringArray[] | A list of hosts or domain names for which the app extension performs SSO. | |
| **BlockAutomaticLogin** | Write | Boolean | Enables or disables Keychain usage. | |
| **CacheName** | Write | String | The Generic Security Services name of the Kerberos cache to use for this profile. | |
| **CredentialBundleIdAccessControlList** | Write | StringArray[] | A list of app Bundle IDs allowed to access the Kerberos Ticket Granting Ticket. | |
| **DomainRealms** | Write | StringArray[] | A list of realms for custom domain-realm mapping. Realms are case sensitive. | |
| **IsDefaultRealm** | Write | Boolean | When true, this profile's realm will be selected as the default. Necessary if multiple Kerberos-type profiles are configured. | |
| **PasswordBlockModification** | Write | Boolean | Enables or disables password changes. | |
| **PasswordExpirationDays** | Write | UInt32 | Overrides the default password expiration in days. For most domains, this value is calculated automatically. | |
| **PasswordExpirationNotificationDays** | Write | UInt32 | The number of days until the user is notified that their password will expire (default is 15). | |
| **UserPrincipalName** | Write | String | The principal user name to use for this profile. The realm name does not need to be included. | |
| **PasswordRequireActiveDirectoryComplexity** | Write | Boolean | Enables or disables whether passwords must meet Active Directory's complexity requirements. | |
| **PasswordPreviousPasswordBlockCount** | Write | UInt32 | The number of previous passwords to block. | |
| **PasswordMinimumLength** | Write | UInt32 | The minimum length of a password. | |
| **PasswordMinimumAgeDays** | Write | UInt32 | The minimum number of days until a user can change their password again. | |
| **PasswordRequirementsDescription** | Write | String | A description of the password complexity requirements. | |
| **RequireUserPresence** | Write | Boolean | Whether to require authentication via Touch ID, Face ID, or a passcode to access the keychain entry. | |
| **ActiveDirectorySiteCode** | Write | String | The Active Directory site. | |
| **PasswordEnableLocalSync** | Write | Boolean | Enables or disables password syncing. This won't affect users logged in with a mobile account on macOS. | |
| **BlockActiveDirectorySiteAutoDiscovery** | Write | Boolean | Enables or disables whether the Kerberos extension can automatically determine its site name. | |
| **PasswordChangeUrl** | Write | String | The URL that the user will be sent to when they initiate a password change. | |
| **SignInHelpText** | Write | String | Text displayed to the user at the Kerberos sign-in window. Available for devices running iOS and iPadOS versions 14 and later. | |
| **ManagedAppsInBundleIdACLIncluded** | Write | Boolean | When set to True, the Kerberos extension allows managed apps, and any apps entered with the app bundle ID to access the credential. When set to False, the Kerberos extension allows all apps to access the credential. Available for devices running iOS and iPadOS versions 14 and later. | |
| **EnableSharedDeviceMode** | Write | Boolean | Enables or disables shared device mode. | |
| **BundleIdAccessControlList** | Write | StringArray[] | An optional list of additional bundle IDs allowed to use the AAD extension for single sign-on. | |
| **Configurations** | Write | MSFT_keyTypedValuePair[] | Gets or sets a list of typed key-value pairs used to configure Credential-type profiles. This collection can contain a maximum of 500 elements. | |
| **ExtensionIdentifier** | Write | String | Gets or sets the bundle ID of the app extension that performs SSO for the specified URLs. | |
| **TeamIdentifier** | Write | String | Gets or sets the team ID of the app extension that performs SSO for the specified URLs. | |
| **urlPrefixes** | Write | StringArray[] | One or more URL prefixes of identity providers on whose behalf the app extension performs single sign-on. URLs must begin with http:// or https://. All URL prefixes must be unique for all profiles. | |

### MSFT_deviceManagementApplicabilityRuleOsEdition

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Write | String | Name for object | |
| **OsEditionTypes** | Write | StringArray[] | Applicability rule OS edition type | |
| **RuleType** | Write | String | Applicability Rule type | `include`, `exclude` |

### MSFT_deviceManagementApplicabilityRuleOsVersion

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Write | String | Name for object | |
| **MinOSVersion** | Write | String | Min OS version for Applicability Rule | |
| **MaxOSVersion** | Write | String | Max OS version for Applicability Rule | |
| **RuleType** | Write | String | Applicability Rule type | `include`, `exclude` |

### MSFT_deviceManagementApplicabilityRuleDeviceMode

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | Name for object | |
| **DeviceMode** | Write | String | Applicability rule for device mode | `standardConfiguration`, `sModeConfiguration` |
| **RuleType** | Write | String | Applicability Rule type | `include`, `exclude` |


## Description

This resource configures an Intune Device Features Configuration Policy for iOS Device.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Group.Read.All, DeviceManagementConfiguration.Read.All

- **Update**

    - Group.Read.All, DeviceManagementConfiguration.ReadWrite.All

#### Application permissions

- **Read**

    - Group.Read.All, DeviceManagementConfiguration.Read.All

- **Update**

    - Group.Read.All, DeviceManagementConfiguration.ReadWrite.All

## Examples

### Example 1

This example creates a new Intune Device Features Configuration Policy for IOS.

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

    Node localhost
    {
        IntuneDeviceFeaturesConfigurationPolicyIOS "IntuneDeviceFeaturesConfigurationPolicyIOS-FakeStringValue"
        {
            ApplicationId            = $ApplicationId;
            TenantId                 = $TenantId;
            CertificateThumbprint    = $CertificateThumbprint;
            AirPrintDestinations     = @(
                MSFT_airPrintDestination{
                    port = 0
                    resourcePath = 'printers/xerox_Phase'
                    forceTls = $False
                    ipAddress = '1.0.0.1'
                }
            );
            Assignments              = @();
            ContentFilterSettings    = @(
                MSFT_iosWebContentFilterSpecificWebsitesAccess{
                    allowedUrls = @('www.allowed.com')
                    dataType = '#microsoft.graph.iosWebContentFilterAutoFilter'
                    blockedUrls = @('www.blocked.com')
                }
            );
            Description              = "FakeStringValue";
            DisplayName              = "FakeStringValue";
            Ensure                   = "Present";
            HomeScreenDockIcons      = @(
                MSFT_iosHomeScreenApp{
                    bundleID = 'com.apple.store.Jolly'
                    displayName = 'Apple Store'
                    isWebClip = $False
                }
            );
            HomeScreenPages          = @(
                MSFT_iosHomeScreenItem{
                    icons = @(
                        MSFT_iosHomeScreenApp{
                            bundleID = 'com.apple.AppStore'
                            displayName = 'App Store'
                            isWebClip = $False
                        }
                    )

                }
            );
            Id                       = "ab915bca-1234-4b11-8acb-719a771139bc";
            IosSingleSignOnExtension = @(
                MSFT_iosSingleSignOnExtension{
                    extensionIdentifier = 'com.example.sso.credential'
                    dataType = '#microsoft.graph.iosCredentialSingleSignOnExtension'
                    domains = @('example.com')
                    teamIdentifier = '4HMSJJRMAD'
                    realm = 'EXAMPLE.COM'
                }
            );
            NotificationSettings     = @(
                MSFT_iosNotificationSettings{
                    alertType = 'banner'
                    enabled = $True
                    showOnLockScreen = $True
                    badgesEnabled = $True
                    soundsEnabled = $True
                    publisher = 'fakepublisher'
                    bundleID = 'app.id'
                    showInNotificationCenter = $True
                    previewVisibility = 'hideWhenLocked'
                    appName = 'fakeapp'
                }
            );
            SingleSignOnSettings     = @(
                MSFT_iosSingleSignOnSettings{
                    allowedAppsList = @(
                        MSFT_appListItem{
                            appId = 'com.microsoft.companyportal'
                            name = 'Intune Company Portal'
                        }
                    )
                    allowedUrls = @('https://www.fakeurl.com')
                    kerberosRealm = 'fakerealm.com'
                    displayName = 'FakeStringValue'
                    kerberosPrincipalName = 'userPrincipalName'
                }
            );
            WallpaperDisplayLocation = "notConfigured";
        }
    }
}
```

### Example 2

This example creates a new Intune Device Features Configuration Policy for IOS.

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

    Node localhost
    {
        IntuneDeviceFeaturesConfigurationPolicyIOS "IntuneDeviceFeaturesConfigurationPolicyIOS-FakeStringValue"
        {
            ApplicationId            = $ApplicationId;
            TenantId                 = $TenantId;
            CertificateThumbprint    = $CertificateThumbprint;
            AirPrintDestinations     = @(
                MSFT_airPrintDestination{
                    port = 0
                    resourcePath = 'printers/xerox_Phase'
                    forceTls = $False
                    ipAddress = '1.0.0.1'
                }
            );
            Assignments              = @();
            ContentFilterSettings    = @(
                MSFT_iosWebContentFilterSpecificWebsitesAccess{
                    allowedUrls = @('www.allowed.com')
                    dataType = '#microsoft.graph.iosWebContentFilterAutoFilter'
                    blockedUrls = @('www.blocked.com')
                }
            );
            Description              = "FakeStringValue - NEW VALUE"; #changed
            DisplayName              = "FakeStringValue";
            Ensure                   = "Present";
            HomeScreenDockIcons      = @(
                MSFT_iosHomeScreenApp{
                    bundleID = 'com.apple.store.Jolly'
                    displayName = 'Apple Store'
                    isWebClip = $False
                }
            );
            HomeScreenPages          = @(
                MSFT_iosHomeScreenItem{
                    icons = @(
                        MSFT_iosHomeScreenApp{
                            bundleID = 'com.apple.AppStore'
                            displayName = 'App Store'
                            isWebClip = $False
                        }
                    )

                }
            );
            Id                       = "ab915bca-1234-4b11-8acb-719a771139bc";
            IosSingleSignOnExtension = @(
                MSFT_iosSingleSignOnExtension{
                    extensionIdentifier = 'com.example.sso.credential'
                    dataType = '#microsoft.graph.iosCredentialSingleSignOnExtension'
                    domains = @('example.com')
                    teamIdentifier = '4HMSJJRMAD'
                    realm = 'EXAMPLE.COM'
                }
            );
            NotificationSettings     = @(
                MSFT_iosNotificationSettings{
                    alertType = 'banner'
                    enabled = $True
                    showOnLockScreen = $True
                    badgesEnabled = $True
                    soundsEnabled = $True
                    publisher = 'fakepublisher'
                    bundleID = 'app.id'
                    showInNotificationCenter = $True
                    previewVisibility = 'hideWhenLocked'
                    appName = 'fakeapp'
                }
            );
            SingleSignOnSettings     = @(
                MSFT_iosSingleSignOnSettings{
                    allowedAppsList = @(
                        MSFT_appListItem{
                            appId = 'com.microsoft.companyportal'
                            name = 'Intune Company Portal'
                        }
                    )
                    allowedUrls = @('https://www.fakeurl.com')
                    kerberosRealm = 'fakerealm.com'
                    displayName = 'FakeStringValue'
                    kerberosPrincipalName = 'userPrincipalName'
                }
            );
            WallpaperDisplayLocation = "notConfigured";
        }
    }
}
```

### Example 3

This example creates a new Intune Device Features Configuration Policy for IOS.

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

    Node localhost
    {
        IntuneDeviceFeaturesConfigurationPolicyIOS "IntuneDeviceFeaturesConfigurationPolicyIOS-FakeStringValue"
        {
            DisplayName              = "FakeStringValue";
            ApplicationId            = $ApplicationId;
            TenantId                 = $TenantId;
            CertificateThumbprint    = $CertificateThumbprint;
            Ensure                   = 'Absent'
        }
    }
}
```

