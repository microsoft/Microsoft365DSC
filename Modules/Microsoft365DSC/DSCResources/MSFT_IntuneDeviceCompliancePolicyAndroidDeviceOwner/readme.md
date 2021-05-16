# IntuneDeviceCompliancePolicyAndroidDeviceOwner

## Description

This resource configures the Fully Managed, Dedicated, and Corporate-Owned Work Profile compliance settings in your cloud-based organization.

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
  Select the maximum allowed machine risk score for devices evaluated by Microsoft Defender for Endpoint. Devices which exceed this score get marked as noncompliant.
  * Not configured (_default_)
  * Clear
  * Low
  * Medium
  * High

### Device Health

* **Require the device to be at or under the Device Threat Level**
  Select the maximum allowed device threat level evaluated by your mobile threat defense service. Devices that exceed this threat level are marked noncompliant. To use this setting, choose the allowed threat level:
  * Not configured (_default_) - This setting isn't evaluated for compliance or non-compliance.
  * Secured - This option is the most secure, and means that the device can't have any threats. If the device is detected with any level of threats, it's evaluated as noncompliant.
  * Low - The device is evaluated as compliant if only low-level threats are present. Anything higher puts the device in a noncompliant status.
  * Medium - The device is evaluated as compliant if the threats that are present on the device are low or medium level. If the device is detected to have high-level threats, it's determined to be noncompliant.
  * High - This option is the least secure, as it allows all threat levels. It may be useful if you're using this solution only for reporting purposes.

### Google Play Protect

* **SafetyNet device attestation**
  Enter the level of SafetyNet attestation that must be met. Your options:
  * Not configured (_default_) - Setting isn't evaluated for compliance or non-compliance.
  * Check basic integrity
  * Check basic integrity & certified devices

  Note:
    * On Android Enterprise devices, Threat scan on apps is a device configuration policy. Using a configuration policy, administrators can enable the setting on a device. See Android Enterprise device restriction settings.

### Device Properties

* **Operating System Version**
  * Minimum OS version
    When a device doesn't meet the minimum OS version requirement, it's reported as non-compliant. A link with information on how to upgrade is shown. The end user can upgrade their device, and then access organization resources.

  _By default, no version is configured._

* **Maximum OS version**
  When a device is using an OS version later than the version in the rule, access to organization resources is blocked. The user is asked to contact their IT administrator. Until a rule is changed to allow the OS version, this device can't access organization resources.

  _By default, no version is configured._

* **Minimum security patch level**
  Select the oldest security patch level a device can have. Devices that aren't at least at this patch level are noncompliant. The date must be entered in the YYYY-MM-DD format.

  _By default, no date is configured_

### System security

* **Require a password to unlock mobile devices**
  * Not configured (_default_) - This setting isn't evaluated for compliance or non-compliance.
  * Require - Users must enter a password before they can access their device.

  _This setting applies at the device level. If you only need to require a password at the Personally-Owned Work Profile level, then use a configuration policy. See Android Enterprise device configuration settings._

* **Required password type**
  Choose if a password should include only numeric characters, or a mix of numerals and other characters. Your options:
  * Device default - To evaluate password compliance, be sure to select a password strength other than Device default.
  * Password required, no restrictions
  * Weak biometric - Strong vs. weak biometrics (opens Android's web site)
  * Numeric (_default_): Password must only be numbers, such as 123456789. Enter the minimum password length a user must enter, between 4 and 16 characters.
  * Numeric complex - Repeated or consecutive numbers, such as "1111" or "1234", aren't allowed. Enter the minimum password length a user must enter, between 4 and 16 characters.
  * Alphabetic - Letters in the alphabet are required. Numbers and symbols aren't required. Enter the minimum password length a user must enter, between 4 and 16 characters.
  * Alphanumeric - Includes uppercase letters, lowercase letters, and numeric characters. Enter the minimum password length a user must enter, between 4 and 16 characters.
  * Alphanumeric with symbols - Includes uppercase letters, lowercase letters, numeric characters, punctuation marks, and symbols.

  Depending on the password type you select, the following settings are available:
  * Minimum password length
    Enter the minimum length the password must have, between 4 and 16 characters.

  * Number of characters required
    Enter the number of characters the password must have, between 0 and 16 characters.

  * Number of lowercase characters required
    Enter the number of lowercase characters the password must have, between 0 and 16 characters.

  * Number of uppercase characters required
    Enter the number of uppercase characters the password must have, between 0 and 16 characters.

  * Number of non-letter characters required
    Enter the number of non-letters (anything other than letters in the alphabet) the password must have, between 0 and 16 characters.

  * Number of numeric characters required
    Enter the number of numeric characters (1, 2, 3, and so on) the password must have, between 0 and 16 characters.

  * Number of symbol characters required
    Enter the number of symbol characters (&, #, %, and so on) the password must have, between 0 and 16 characters.

  * Maximum minutes of inactivity before password is required
    Enter the idle time before the user must reenter their password. Options include the default of _Not configured_, and from _1 Minute_ to _8 hours_.

  * Number of days until password expires
    Enter the number of days, between 1-365, until the device password must be changed. For example, to change the password after 60 days, enter 60. When the password expires, users are prompted to create a new password.

    _By default, no value is configured._

  * Number of passwords required before user can reuse a password
    Enter the number of recent passwords that can't be reused, between 1-24. Use this setting to restrict the user from creating previously used passwords.

    _By default, no version is configured._

### Encryption
* **Encryption of data storage on device**
  * Not configured (_default_) - This setting isn't evaluated for compliance or non-compliance.
  * Require - Encrypt data storage on your devices.

  You don't have to configure this setting because Android Enterprise devices enforce encryption.

## Example

```PowerShell

IntuneDeviceCompliancePolicyAndroidDeviceOwner f7d82525-b7c0-475c-9d5e-16fafdfa487a
        {
            Description                                        = "";
            DisplayName                                        = "DeviceOwner";
            DeviceThreatProtectionEnabled                      = $False;
            DeviceThreatProtectionRequiredSecurityLevel        = "unavailable";
            AdvancedThreatProtectionRequiredSecurityLevel      = "unavailable";
            SecurityRequireSafetyNetAttestationBasicIntegrity  = $False;
            SecurityRequireSafetyNetAttestationCertifiedDevice = $False;
            OsMinimumVersion                                   = "10"
            OsMaximumVersion                                   = "11"
            MinAndroidSecurityPatchLevel                       = "2020-03-01"
            PasswordRequired                                   = $True;
            PasswordMinimumLength                              = 6;
            PasswordMinimumLetterCharacters                    = 1;
            PasswordMinimumLowerCaseCharacters                 = 1;
            PasswordMinimumNonLetterCharacters                 = 2;
            PasswordMinimumNumericCharacters                   = 1;
            PasswordMinimumSymbolCharacters                    = 1;
            PasswordMinimumUpperCaseCharacters                 = 1;
            PasswordRequiredType                               = "numericComplex";
            PasswordMinutesOfInactivityBeforeLock              = 5;
            PasswordExpirationDays                             = 90;
            PasswordPreviousPasswordCountToBlock               = 13;
            StorageRequireEncryption                           = $True;
            Ensure                                             = "Present";
            GlobalAdminAccount                                 = $Credsglobaladmin;

        }
```
