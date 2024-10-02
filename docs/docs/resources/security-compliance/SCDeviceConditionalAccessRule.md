# SCDeviceConditionalAccessRule

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | Name for the rule. | |
| **Policy** | Write | String | Name of the associated policy. | |
| **TargetGroups** | Write | StringArray[] | The display names of the graoups targeted by the policy. | |
| **AccountName** | Write | String | The AccountName parameter specifies the account name. | |
| **AccountUserName** | Write | String | The AccountUserName parameter specifies the account user name. | |
| **AllowAppStore** | Write | Boolean | The AllowAppStore parameter specifies whether to allow access to the app store on devices. | |
| **AllowAssistantWhileLocked** | Write | Boolean | The AllowAssistantWhileLocked parameter specifies whether to allow the use of the voice assistant while devices are locked. | |
| **AllowConvenienceLogon** | Write | Boolean | The AllowConvenienceLogon parameter specifies whether to allow convenience logons on devices. | |
| **AllowDiagnosticSubmission** | Write | Boolean | The AllowDiagnosticSubmission parameter specifies whether to allow diagnostic submissions from devices. | |
| **AllowiCloudBackup** | Write | Boolean | The AllowiCloudBackup parameter specifies whether to allow Apple iCloud Backup from devices. | |
| **AllowiCloudDocSync** | Write | Boolean | The AllowiCloudDocSync parameter specifies whether to allow Apple iCloud Documents & Data sync on devices. | |
| **AllowiCloudPhotoSync** | Write | Boolean | The AllowiCloudPhotoSync parameter specifies whether to allow Apple iCloud Photos sync on devices. | |
| **AllowJailbroken** | Write | Boolean | The AllowJailbroken parameter specifies whether to allow access to your organization by jailbroken or rooted devices. | |
| **AllowPassbookWhileLocked** | Write | Boolean | The AllowPassbookWhileLocked parameter specifies whether to allow the use of Apple Passbook while devices are locked. | |
| **AllowScreenshot** | Write | Boolean | The AllowScreenshot parameter specifies whether to allow screenshots on devices. | |
| **AllowSimplePassword** | Write | Boolean | The AllowSimplePassword parameter specifies whether to allow simple or non-complex passwords on devices. | |
| **AllowVideoConferencing** | Write | Boolean | The AllowVideoConferencing parameter specifies whether to allow video conferencing on devices.  | |
| **AllowVoiceAssistant** | Write | Boolean | The AllowVoiceAssistant parameter specifies whether to allow using the voice assistant on devices. | |
| **AllowVoiceDialing** | Write | Boolean | The AllowVoiceDialing parameter specifies whether to allow voice-activated telephone dialing. | |
| **AntiVirusSignatureStatus** | Write | UInt32 | The AntiVirusSignatureStatus parameter specifies the antivirus signature status. | |
| **AntiVirusStatus** | Write | UInt32 | The AntiVirusStatus parameter specifies the antivirus status. | |
| **AppsRating** | Write | String | The AppsRating parameter species the maximum or most restrictive rating of apps that are allowed on devices. | |
| **AutoUpdateStatus** | Write | String | The AutoUpdateStatus parameter specifies the update settings for devices. | |
| **BluetoothEnabled** | Write | Boolean | The BluetoothEnabled parameter specifies whether to enable or disable Bluetooth on devices. | |
| **CameraEnabled** | Write | Boolean | The BluetoothEnabled parameter specifies whether to enable or disable Bluetooth on devices. | |
| **EmailAddress** | Write | String | The EmailAddress parameter specifies the email address. | |
| **EnableRemovableStorage** | Write | Boolean | The EnableRemovableStorage parameter specifies whether removable storage can be used by devices. | |
| **ExchangeActiveSyncHost** | Write | String | The ExchangeActiveSyncHost parameter specifies the Exchange ActiveSync host. | |
| **FirewallStatus** | Write | Boolean | The FirewallStatus parameter specifies the acceptable firewall status values on devices. | |
| **ForceAppStorePassword** | Write | Boolean | The ForceAppStorePassword parameter specifies whether to require a password to use the app store on devices. | |
| **ForceEncryptedBackup** | Write | Boolean | The ForceEncryptedBackup parameter specifies whether to force encrypted backups for devices. | |
| **MaxPasswordAttemptsBeforeWipe** | Write | UInt32 | The MaxPasswordAttemptsBeforeWipe parameter specifies the number of incorrect password attempts that cause devices to be automatically wiped. | |
| **MaxPasswordGracePeriod** | Write | UInt32 | The MaxPasswordGracePeriod parameter specifies the length of time users are allowed to reset expired passwords on devices. | |
| **MoviesRating** | Write | String | The MoviesRating parameter species the maximum or most restrictive rating of movies that are allowed on devices. You specify the country/region rating system to use with the RegionRatings parameter. | |
| **PasswordComplexity** | Write | UInt32 | The PasswordComplexity parameter specifies the password complexity. | |
| **PasswordExpirationDays** | Write | UInt32 | The PasswordExpirationDays parameter specifies the number of days that the same password can be used on devices before users are required to change their passwords. | |
| **PasswordHistoryCount** | Write | UInt32 | The PasswordHistoryCount parameter specifies the minimum number of unique new passwords that are required on devices before an old password can be reused. | |
| **PasswordMinComplexChars** | Write | UInt32 | The PasswordMinComplexChars parameter specifies the minimum number of complex characters that are required for device passwords. A complex character isn't a letter. | |
| **PasswordMinimumLength** | Write | UInt32 | The PasswordMinimumLength parameter specifies the minimum number of characters that are required for device passwords. | |
| **PasswordQuality** | Write | UInt32 | The PasswordQuality parameter specifies the minimum password quality rating that's required for device passwords. Password quality is a numeric scale that indicates the security and complexity of the password. A higher quality value indicates a more secure password. | |
| **PasswordRequired** | Write | Boolean | The PasswordRequired parameter specifies whether a password is required to access devices. | |
| **PasswordTimeout** | Write | String | The PasswordTimeout parameter specifies the length of time that devices can be inactive before a password is required to reactivate them. | |
| **PhoneMemoryEncrypted** | Write | Boolean | The PhoneMemoryEncrypted parameter specifies whether to encrypt the memory on devices. | |
| **RegionRatings** | Write | String | The RegionRatings parameter specifies the rating system (country/region) to use for movie and television ratings with the MoviesRating and TVShowsRating parameters. | |
| **RequireEmailProfile** | Write | Boolean | The RequireEmailProfile parameter specifies whether an email profile is required on devices. | |
| **SmartScreenEnabled** | Write | Boolean | The SmartScreenEnabled parameter specifies whether to requireWindows SmartScreen on devices. | |
| **SystemSecurityTLS** | Write | Boolean | The SystemSecurityTLS parameter specifies whether TLS encryption is used on devices. | |
| **TVShowsRating** | Write | String | The TVShowsRating parameter species the maximum or most restrictive rating of television shows that are allowed on devices. You specify the country/region rating system to use with the RegionRatings parameter. | |
| **UserAccountControlStatus** | Write | String | The UserAccountControlStatus parameter specifies how User Account Control messages are presented on devices. | |
| **WLANEnabled** | Write | Boolean | The WLANEnabled parameter specifies whether Wi-Fi is enabled devices. | |
| **WorkFoldersSyncUrl** | Write | String | The WorkFoldersSyncUrl parameter specifies the URL that's used to synchronize company data on devices. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Absent`, `Present` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Manages Purview Device Conditional Access rules.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - None

- **Update**

    - None

#### Application permissions

- **Read**

    - Group.Read.All

- **Update**

    - Group.Read.All

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

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
    node localhost
    {
        SCDeviceConditionalAccessRule "MyDeviceConditionalAccessRule"
        {
            AllowAppStore             = $True;
            AllowAssistantWhileLocked = $True;
            AllowConvenienceLogon     = $True;
            AllowDiagnosticSubmission = $True;
            AllowiCloudBackup         = $True;
            AllowiCloudDocSync        = $True;
            AllowiCloudPhotoSync      = $True;
            AllowJailbroken           = $True;
            AllowPassbookWhileLocked  = $True;
            AllowScreenshot           = $True;
            AllowSimplePassword       = $True;
            AllowVideoConferencing    = $True;
            AllowVoiceAssistant       = $True;
            AllowVoiceDialing         = $True;
            ApplicationId             = $ApplicationId;
            BluetoothEnabled          = $True;
            CameraEnabled             = $True;
            CertificateThumbprint     = $CertificateThumbprint;
            EnableRemovableStorage    = $True;
            Ensure                    = "Present";
            ForceAppStorePassword     = $False;
            ForceEncryptedBackup      = $False;
            Name                      = "MyPolicy{394b}";
            PasswordRequired          = $False;
            PhoneMemoryEncrypted      = $False;
            Policy                    = "MyPolicy";
            RequireEmailProfile       = $False;
            SmartScreenEnabled        = $False;
            SystemSecurityTLS         = $False;
            TargetGroups              = @("Communications");
            TenantId                  = $TenantId;
            WLANEnabled               = $True;
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
    node localhost
    {
        SCDeviceConditionalAccessRule "MyDeviceConditionalAccessRule"
        {
            AllowAppStore             = $True;
            AllowAssistantWhileLocked = $True;
            AllowConvenienceLogon     = $True;
            AllowDiagnosticSubmission = $True;
            AllowiCloudBackup         = $True;
            AllowiCloudDocSync        = $True;
            AllowiCloudPhotoSync      = $True;
            AllowJailbroken           = $True;
            AllowPassbookWhileLocked  = $True;
            AllowScreenshot           = $True;
            AllowSimplePassword       = $True;
            AllowVideoConferencing    = $True;
            AllowVoiceAssistant       = $True;
            AllowVoiceDialing         = $True;
            ApplicationId             = $ApplicationId;
            BluetoothEnabled          = $True;
            CameraEnabled             = $True;
            CertificateThumbprint     = $CertificateThumbprint;
            EnableRemovableStorage    = $True;
            Ensure                    = "Present";
            ForceAppStorePassword     = $False;
            ForceEncryptedBackup      = $False;
            Name                      = "MyPolicy{394b}";
            PasswordRequired          = $False;
            PhoneMemoryEncrypted      = $False;
            Policy                    = "MyPolicy";
            RequireEmailProfile       = $True; #Drift
            SmartScreenEnabled        = $False;
            SystemSecurityTLS         = $False;
            TargetGroups              = @("Communications");
            TenantId                  = $TenantId;
            WLANEnabled               = $True;
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
    node localhost
    {
        SCDeviceConditionalAccessRule "MyDeviceConditionalAccessRule"
        {
            ApplicationId             = $ApplicationId;
            CertificateThumbprint     = $CertificateThumbprint;
            Ensure                    = "Absent";
            Name                      = "MyPolicy{394b}";
            Policy                    = "MyPolicy";
            TenantId                  = $TenantId;
        }
    }
}
```

