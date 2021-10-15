# IntuneAndroidDeviceCompliancePolicy
## Description

This resource configures the settings of Android device compliance policies
in your cloud-based organization.

## Permissions Needed

To authenticate via Azure Active Directory, this resource requires the following Delegated permissions:

* **Automate**
  * DeviceManagementConfiguration.ReadWrite.All (Delegated)
* **Export**
  * DeviceManagementConfiguration.Read.All (Delegated)

NOTE: All permisions listed above require admin consent.

## Parameters

### Microsoft Defender for Endpoint

* **Require the device to be at or under the machine risk score**
  Select the maximum allowed machine risk score for devices evaluated by Microsoft Defender for Endpoint. Devices that exceed this score get marked as noncompliant.
  * Not configured (_default_)
  * Clear
  * Low
  * Medium
  * High


### Device Health

* **Devices managed with device administrator**
  Device administrator capabilities are superseded by Android Enterprise.
  * Not configured (_default_)
  * Block - Blocking device administrator will guide users to move to Android Enterprise Personally-Owned and Corporate-Owned Work Profile management to regain access.

### Rooted devices
* **Prevent rooted devices from having corporate access. (This compliance check is supported for Android 4.0 and above.)**
  * Not configured (_default_) - This setting isn't evaluated for compliance or non-compliance.
  * Block - Mark rooted (jailbroken) devices as not compliant.

* **Require the device to be at or under the Device Threat Level**
  Use this setting to take the risk assessment from a connected Mobile Threat Defense service as a condition for compliance.
  * Not configured (_default_) - This setting isn't evaluated for compliance or non-compliance.
  * Secured - This option is the most secure, as the device can't have any threats. If the device is detected with any level of threats, it's evaluated as noncompliant.
  * Low - The device is evaluated as compliant if only low-level threats are present. Anything higher puts the device in a noncompliant status.
  * Medium - The device is evaluated as compliant if existing threats on the device are low or medium level. If the device is detected to have high-level threats, it's determined to be noncompliant.
  * High - This option is the least secure, and allows all threat levels. It may be useful if you're using this solution only for reporting purposes.

### Google Play Protect
* **Google Play Services is configured**
  Google Play services allows security updates, and is a base-level dependency for many security features on certified-Google devices.
  * Not configured (_default_) - This setting isn't evaluated for compliance or non-compliance.
  * Require - Require that the Google Play services app is installed and enabled.

* **Up-to-date security provider**
  * Not configured (_default_) - This setting isn't evaluated for compliance or non-compliance.
  * Require - Require that an up-to-date security provider can protect a device from known vulnerabilities.

* **Threat scan on apps**
  * Not configured (_default_) - This setting isn't evaluated for compliance or non-compliance.
  * Require - Require that the Android Verify Apps feature is enabled.

* **SafetyNet device attestation**
  Enter the level of SafetyNet attestation that must be met. Your options:
  * Not configured (_default_) - This setting isn't evaluated for compliance or non-compliance.
  * Check basic integrity
  * Check basic integrity & certified devices

### Device Properties
* **Operating System Version**
  * Minimum OS version
  When a device doesn't meet the minimum OS version requirement, it's reported as noncompliant. A link with information about how to upgrade is shown. The end user can choose to upgrade their device, and then get access to company resources.

  _By default, no version is configured._

  * Maximum OS version
  When a device is using an OS version later than the version specified in the rule, access to company resources is blocked. The user is asked to contact their IT admin. Until a rule is changed to allow the OS version, this device can't access company resources.

  _By default, no version is configured._

### System Security
* **Encryption**
  Encryption of data storage on a device
  Supported on Android 4.0 and later, or KNOX 4.0 and later.
  * Not configured (_default_) - This setting isn't evaluated for compliance or non-compliance.
  * Require - Encrypt data storage on your devices. Devices are encrypted when you choose the Require a password to unlock mobile devices setting.

* **Device Security**
  Block apps from unknown sources
  Supported on Android 4.0 to Android 7.x. Not supported by Android 8.0 and later
  * Not configured (_default_) - this setting isn't evaluated for compliance or non-compliance.
  * Block - Block devices with Security > Unknown Sources enabled sources (_supported on Android 4.0 through Android 7.x. Not supported on Android 8.0 and later._).

  To side-load apps, unknown sources must be allowed. If you're not side-loading Android apps, then set this feature to Block to enable this compliance policy.

* **Company portal app runtime integrity**
  * Not configured (_default_) - This setting isn't evaluated for compliance or non-compliance.
  * Require - Choose Require to confirm the Company Portal app meets all the following requirements:
    * Has the default runtime environment installed
    * Is properly signed
    * Isn't in debug-mode

* **Block USB debugging on device**
  _(Supported on Android 4.2 or later)_

  * Not configured (_default_) - This setting isn't evaluated for compliance or non-compliance.
  * Block - Prevent devices from using the USB debugging feature.

* **Minimum security patch level**
  _(Supported on Android 6.0 or later)_

  Select the oldest security patch level a device can have. Devices that aren't at least at this patch level are noncompliant. The date must be entered in the YYYY-MM-DD format.

  _By default, no date is configured._

* **Restricted apps**
  Enter the App name and App bundle ID for apps that should be restricted, and then select Add. A device with at least one restricted app installed is marked as non-compliant.

### Password

The available settings for passwords vary by the version of Android on the device.

#### All Android devices
The following settings are supported on Android 4.0 or later, and Knox 4.0 and later.

* **Maximum minutes of inactivity before password is required**
  This setting specifies the length of time without user input after which the mobile device screen is locked. Options range from 1 Minute to 8 Hours. The recommended value is 15 Minutes.
  * Not configured (_default_)

#### Android 10 and later
The following settings are supported on Android 10 or later, but not on Knox.

* **Password complexity**
  _This setting is supported on Android 10 or later, but not on Samsung Knox. On devices that run Android 9 and earlier or Samsung Knox, settings for the password length and type override this setting for complexity._

  Specify the required password complexity.
  * None (_default_) - No password required.
  * Low - The password satisfies one of the following conditions:
    * Pattern
    * Numeric PIN has a repeating (4444) or ordered (1234, 4321, 2468) sequence.
  * Medium - The password satisfies one of the following conditions:
    * Numeric PIN doesn’t have a repeating (4444) or ordered (1234, 4321, 2468) sequence, and has minimum length of 4.
    * Alphabetic, with a minimum length of 4.
    * Alphanumeric, with a minimum length of 4.
  * High - The password satisfies one of the following conditions:
    * Numeric PIN doesn’t have a repeating (4444) or ordered (1234, 4321, 2468) sequence, and has minimum length of 8.
    * Alphabetic, with a minimum length of 6.
    * Alphanumeric, with a minimum length of 6.

#### Android 9 and earlier or Samsung Knox
_The following settings are supported on Android 9.0 and earlier, and any version of Samsung Knox._

* **Require a password to unlock mobile devices**
  This setting specifies whether to require users to enter a password before access is granted to information on their mobile devices. Recommended value: Require
  * Not configured (_default_) - This setting isn't evaluated for compliance or non-compliance.
  * Require - Users must enter a password before they can access their device.
  When set to Require, the following setting can be configured:
    **Required password type**
    Choose if a password should include only numeric characters, or a mix of numerals and other characters.
    * Device Default - To evaluate password compliance, be sure to select a password strength other than Device default.
    * Low security biometric
    * At least numeric
    * Numeric complex - Repeated or consecutive numerals, such as 1111 or 1234, aren't allowed.
    * At least alphabetic
    * At least alphanumeric
    * At least alphanumeric with symbols

    Based on the configuration of this setting, one or more of the following options are available:
    * Minimum password length
    Enter the minimum number of digits or characters that the user's password must have.
    * Maximum minutes of inactivity before password is required
    Enter the idle time before the user must reenter their password. When you choose Not configured (_default_), this setting isn't evaluated for compliance or non-compliance.
    * Number of days until password expires
    Select the number of days before the password expires and the user must create a new password.
    * Number of previous passwords to prevent reuse
    Enter the number of recent passwords that can't be reused. Use this setting to restrict the user from creating previously used passwords.

## Example

```PowerShell
IntuneDeviceCompliancePolicyAndroid a58cdba9-c410-4ba4-b7d2-3a09593b5d84
        {
            Description                                        = "";
            DeviceThreatProtectionEnabled                      = $False;
            DeviceThreatProtectionRequiredSecurityLevel        = "unavailable";
            DisplayName                                        = "Compliance Android";
            Ensure                                             = "Present";
            Credential                                         = $Credsglobaladmin;
            osMinimumVersion                                   = "7";
            PasswordExpirationDays                             = 90;
            PasswordMinimumLength                              = 6;
            PasswordMinutesOfInactivityBeforeLock              = 5;
            PasswordPreviousPasswordBlockCount                 = 10;
            PasswordRequired                                   = $True;
            PasswordRequiredType                               = "deviceDefault";
            SecurityBlockJailbrokenDevices                     = $False;
            SecurityDisableUsbDebugging                        = $False;
            SecurityPreventInstallAppsFromUnknownSources       = $False;
            SecurityRequireCompanyPortalAppIntegrity           = $False;
            SecurityRequireGooglePlayServices                  = $False;
            SecurityRequireSafetyNetAttestationBasicIntegrity  = $False;
            SecurityRequireSafetyNetAttestationCertifiedDevice = $False;
            SecurityRequireUpToDateSecurityProviders           = $False;
            SecurityRequireVerifyApps                          = $False;
            StorageRequireEncryption                           = $True;
        }
```
