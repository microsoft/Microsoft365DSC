# IntuneDeviceConfigurationPolicyAndroidWorkProfile

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | Display name of the device general configuration policy for Android WorkProfile. ||
| **Description** | Write | String | Description of the device general configuration policy for Android WorkProfile ||
| **PasswordBlockFingerprintUnlock** | Write | Boolean | Indicates whether or not to block fingerprint unlock ||
| **passwordBlockTrustAgents** | Write | Boolean | Indicates whether or not to block Smart Lock and other trust agents. ||
| **PasswordExpirationDays** | Write | UInt32 | Number of days before the password expires ||
| **PasswordMinimumLength** | Write | UInt32 | Minimum length of passwords ||
| **PasswordMinutesOfInactivityBeforeScreenTimeout** | Write | UInt32 | Minutes of inactivity before the screen times out ||
| **PasswordPreviousPasswordBlockCount** | Write | UInt32 | Number of previous passwords to block ||
| **PasswordSignInFailureCountBeforeFactoryReset** | Write | UInt32 | Number of sign in failures allowed before factory reset ||
| **PasswordRequiredType** | Write | String | Type of password that is required |deviceDefault, lowSecurityBiometric, required, atLeastNumeric, numericComplex, atLeastAlphabetic, atLeastAlphanumeric, alphanumericWithSymbols|
| **WorkProfileDataSharingType** | Write | String | Type of data sharing that is allowed |deviceDefault, preventAny, allowPersonalToWork, noRestrictions|
| **WorkProfileBlockNotificationsWhileDeviceLocked** | Write | Boolean | Indicates whether or not to block notifications while device locked ||
| **WorkProfileBlockAddingAccounts** | Write | Boolean | Block users from adding/removing accounts in work profile ||
| **WorkProfileBluetoothEnableContactSharing** | Write | Boolean | Allow bluetooth devices to access enterprise contacts ||
| **WorkProfileBlockScreenCapture** | Write | Boolean | Block screen capture in work profile ||
| **WorkProfileBlockCrossProfileCallerId** | Write | Boolean | Block display work profile caller ID in personal profile ||
| **WorkProfileBlockCamera** | Write | Boolean | Block work profile camera ||
| **WorkProfileBlockCrossProfileContactsSearch** | Write | Boolean | Block work profile contacts availability in personal profile ||
| **WorkProfileBlockCrossProfileCopyPaste** | Write | Boolean | Boolean that indicates if the setting disallow cross profile copy paste is enabled ||
| **WorkProfileDefaultAppPermissionPolicy** | Write | String | Type of password that is required |deviceDefault, prompt, autoGrant, autoDeny|
| **WorkProfilePasswordBlockFingerprintUnlock** | Write | Boolean | Indicates whether or not to block fingerprint unlock for work profile ||
| **WorkProfilePasswordBlockTrustAgents** | Write | Boolean | Indicates whether or not to block Smart Lock and other trust agents for work profile ||
| **WorkProfilePasswordExpirationDays** | Write | UInt32 | Number of days before the work profile password expires ||
| **WorkProfilePasswordMinimumLength** | Write | UInt32 | Minimum length of work profile password ||
| **WorkProfilePasswordMinNumericCharacters** | Write | UInt32 | Minimum count of numeric characters required in work profile password ||
| **WorkProfilePasswordMinNonLetterCharacters** | Write | UInt32 | Minimum count of non-letter characters required in work profile password ||
| **WorkProfilePasswordMinLetterCharacters** | Write | UInt32 | Minimum count of letter characters required in work profile password ||
| **WorkProfilePasswordMinLowerCaseCharacters** | Write | UInt32 | Minimum count of lower-case characters required in work profile password ||
| **WorkProfilePasswordMinUpperCaseCharacters** | Write | UInt32 | Minimum count of upper-case characters required in work profile password ||
| **WorkProfilePasswordMinSymbolCharacters** | Write | UInt32 | Minimum count of symbols required in work profile password ||
| **WorkProfilePasswordMinutesOfInactivityBeforeScreenTimeout** | Write | UInt32 | Minutes of inactivity before the screen times out ||
| **WorkProfilePasswordPreviousPasswordBlockCount** | Write | UInt32 | Number of previous work profile passwords to block ||
| **WorkProfilePasswordSignInFailureCountBeforeFactoryReset** | Write | UInt32 | Number of sign in failures allowed before work profile is removed and all corporate data deleted ||
| **WorkProfilePasswordRequiredType** | Write | String | Type of work profile password that is required |deviceDefault, lowSecurityBiometric, required, atLeastNumeric, numericComplex, atLeastAlphabetic, atLeastAlphanumeric, alphanumericWithSymbols|
| **WorkProfileRequirePassword** | Write | Boolean | Password is required or not for work profile ||
| **SecurityRequireVerifyApps** | Write | Boolean | Require the Android Verify apps feature is turned on ||
| **Ensure** | Write | String | Present ensures the site collection exists, absent ensures it is removed |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Intune Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||

# IntuneDeviceConfigurationPolicyAndroidWorkProfile

This resource configures an Intune device configuration profile for an Android WorkProfile Device.

## Examples

### Example 1

This example creates a new General Device Configuration Policy for Android WorkProfile .

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
        IntuneDeviceConfigurationPolicyAndroidWorkProfile 97ed22e9-1429-40dc-ab3c-0055e538383b
        {
            DisplayName                                    = "Android Work Profile - Device Restrictions - Standard";
            Ensure                                         = "Present";
            GlobalAdminAccount                             = $Credsglobaladmin;
            PasswordBlockFingerprintUnlock                 = $False;
            PasswordBlockTrustAgents                       = $False;
            PasswordMinimumLength                          = 6;
            PasswordMinutesOfInactivityBeforeScreenTimeout = 15;
            PasswordRequiredType                           = "atLeastNumeric";
            SecurityRequireVerifyApps                      = $True;
            WorkProfileBlockAddingAccounts                 = $True;
            WorkProfileBlockCamera                         = $False;
            WorkProfileBlockCrossProfileCallerId           = $False;
            WorkProfileBlockCrossProfileContactsSearch     = $False;
            WorkProfileBlockCrossProfileCopyPaste          = $True;
            WorkProfileBlockNotificationsWhileDeviceLocked = $True;
            WorkProfileBlockScreenCapture                  = $True;
            WorkProfileBluetoothEnableContactSharing       = $False;
            WorkProfileDataSharingType                     = "allowPersonalToWork";
            WorkProfileDefaultAppPermissionPolicy          = "deviceDefault";
            WorkProfilePasswordBlockFingerprintUnlock      = $False;
            WorkProfilePasswordBlockTrustAgents            = $False;
            WorkProfilePasswordRequiredType                = "deviceDefault";
            WorkProfileRequirePassword                     = $False;
        }
    }
}
```

