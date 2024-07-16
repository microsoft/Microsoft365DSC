# EXOMobileDeviceMailboxPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the friendly name of the mobile device mailbox policy. | |
| **AllowApplePushNotifications** | Write | Boolean | The AllowApplePushNotifications parameter specifies whether push notifications are allowed to Apple mobile devices. | |
| **AllowBluetooth** | Write | String | The AllowBluetooth parameter specifies whether the Bluetooth capabilities are allowed on the mobile phone. The available options are Disable, HandsfreeOnly, and Allow. The default value is Allow. | `Disable`, `HandsfreeOnly`, `Allow` |
| **AllowBrowser** | Write | Boolean | The AllowBrowser parameter indicates whether Microsoft Pocket Internet Explorer is allowed on the mobile phone. This parameter doesn't affect third-party browsers. | |
| **AllowCamera** | Write | Boolean | The AllowCamera parameter specifies whether the mobile phone's camera is allowed. | |
| **AllowConsumerEmail** | Write | Boolean | The AllowConsumerEmail parameter specifies whether the mobile phone user can configure a personal email account on the mobile phone. | |
| **AllowDesktopSync** | Write | Boolean | The AllowDesktopSync parameter specifies whether the mobile phone can synchronize with a desktop computer through a cable. | |
| **AllowExternalDeviceManagement** | Write | Boolean | The AllowExternalDeviceManagement parameter specifies whether an external device management program is allowed to manage the mobile phone. | |
| **AllowGooglePushNotifications** | Write | Boolean | The AllowGooglePushNotifications parameter controls whether the user can receive push notifications from Google for Outlook on the web for devices. | |
| **AllowHTMLEmail** | Write | Boolean | The AllowHTMLEmail parameter specifies whether HTML email is enabled on the mobile phone. | |
| **AllowInternetSharing** | Write | Boolean | The AllowInternetSharing parameter specifies whether the mobile phone can be used as a modem to connect a computer to the Internet. | |
| **AllowIrDA** | Write | Boolean | The AllowIrDA parameter specifies whether infrared connections are allowed to the mobile phone. | |
| **AllowMobileOTAUpdate** | Write | Boolean | The AllowMobileOTAUpdate parameter specifies whether the Exchange ActiveSync mailbox policy can be sent to the mobile phone over a cellular data connection. | |
| **AllowMicrosoftPushNotifications** | Write | Boolean | The AllowMicrosoftPushNotifications parameter specifies whether push notifications are enabled on the mobile device. | |
| **AllowNonProvisionableDevices** | Write | Boolean | The AllowNonProvisionableDevices parameter specifies whether all mobile phones can synchronize with the server running Exchange. | |
| **AllowPOPIMAPEmail** | Write | Boolean | The AllowPOPIMAPEmail parameter specifies whether the user can configure a POP3 or IMAP4 email account on the mobile phone. | |
| **AllowRemoteDesktop** | Write | Boolean | The AllowRemoteDesktop parameter specifies whether the mobile phone can initiate a remote desktop connection. | |
| **AllowSimplePassword** | Write | Boolean | The AllowSimplePassword parameter specifies whether a simple device password is allowed. A simple device password is a password that has a specific pattern, such as 1111 or 1234. | |
| **AllowSMIMEEncryptionAlgorithmNegotiation** | Write | String | The AllowSMIMEEncryptionAlgorithmNegotiation parameter specifies whether the messaging application on the mobile device can negotiate the encryption algorithm if a recipient's certificate doesn't support the specified encryption algorithm. | `AllowAnyAlgorithmNegotiation`, `BlockNegotiation`, `OnlyStrongAlgorithmNegotiation` |
| **AllowSMIMESoftCerts** | Write | Boolean | The AllowSMIMESoftCerts parameter specifies whether S/MIME software certificates are allowed. | |
| **AllowStorageCard** | Write | Boolean | The AllowStorageCard parameter specifies whether the mobile phone can access information stored on a storage card. | |
| **AllowTextMessaging** | Write | Boolean | The AllowTextMessaging parameter specifies whether text messaging is allowed from the mobile phone. | |
| **AllowUnsignedApplications** | Write | Boolean | The AllowUnsignedApplications parameter specifies whether unsigned applications can be installed on the mobile phone. | |
| **AllowUnsignedInstallationPackages** | Write | Boolean | The AllowUnsignedInstallationPackages parameter specifies whether unsigned installation packages can be executed on the mobile phone. | |
| **AllowWiFi** | Write | Boolean | The AllowWiFi parameter specifies whether wireless Internet access is allowed on the mobile phone.  | |
| **AlphanumericPasswordRequired** | Write | Boolean | The AlphanumericPasswordRequired parameter specifies whether the password for the mobile phone must be alphanumeric. | |
| **ApprovedApplicationList** | Write | StringArray[] | The ApprovedApplicationList parameter specifies a list of approved applications for the mobile phone. | |
| **AttachmentsEnabled** | Write | Boolean | The AttachmentsEnabled parameter specifies whether attachments can be downloaded. | |
| **DeviceEncryptionEnabled** | Write | Boolean | The DeviceEncryptionEnabled parameter specifies whether encryption is enabled. | |
| **DevicePolicyRefreshInterval** | Write | String | The DevicePolicyRefreshInterval parameter specifies how often the policy is sent from the server to the mobile phone. | |
| **IrmEnabled** | Write | Boolean | The IrmEnabled parameter specifies whether Information Rights Management (IRM) is enabled for the mailbox policy. | |
| **IsDefault** | Write | Boolean | The IsDefault parameter specifies whether this policy is the default Mobile Device mailbox policy. | |
| **MaxAttachmentSize** | Write | String | The MaxAttachmentSize parameter specifies the maximum size of attachments that can be downloaded to the mobile phone. | |
| **MaxCalendarAgeFilter** | Write | String | The MaxCalendarAgeFilter parameter specifies the maximum range of calendar days that can be synchronized to the device. | `All`, `TwoWeeks`, `OneMonth`, `ThreeMonths`, `SixMonths` |
| **MaxEmailAgeFilter** | Write | String | The MaxEmailAgeFilter parameter specifies the maximum number of days of email items to synchronize to the mobile phone. | `All`, `OneDay`, `ThreeDays`, `OneWeek`, `TwoWeeks`, `OneMonth` |
| **MaxEmailBodyTruncationSize** | Write | String | The MaxEmailBodyTruncationSize parameter specifies the maximum size at which email messages are truncated when synchronized to the mobile phone. The value is specified in kilobytes (KB). | |
| **MaxEmailHTMLBodyTruncationSize** | Write | String | The MaxEmailHTMLBodyTruncationSize parameter specifies the maximum size at which HTML-formatted email messages are synchronized to the mobile phone. The value is specified in KB. | |
| **MaxInactivityTimeLock** | Write | String | The MaxInactivityTimeDeviceLock parameter specifies the length of time that the mobile phone can be inactive before the password is required to reactivate it. | |
| **MaxPasswordFailedAttempts** | Write | String | The MaxPasswordFailedAttempts parameter specifies the number of attempts a user can make to enter the correct password for the mobile phone. You can enter any number from 4 through 16 or the value Unlimited. | |
| **MinPasswordComplexCharacters** | Write | String | The MinPasswordComplexCharacters parameter specifies the character sets that are required in the password of the mobile device. | |
| **MinPasswordLength** | Write | String | The MinPasswordLength parameter specifies the minimum number of characters in the mobile device password. | |
| **PasswordEnabled** | Write | Boolean | The PasswordEnabled parameter specifies whether a password is required on the mobile device. | |
| **PasswordExpiration** | Write | String | The PasswordExpiration parameter specifies how long a password can be used on a mobile device before the user is forced to change the password. | |
| **PasswordHistory** | Write | String | The PasswordHistory parameter specifies the number of unique new passwords that need to be created on the mobile device before an old password can be reused. | |
| **PasswordRecoveryEnabled** | Write | Boolean | The PasswordRecoveryEnabled parameter specifies whether the recovery password for the mobile device is stored in Exchange. | |
| **RequireDeviceEncryption** | Write | Boolean | The RequireDeviceEncryption parameter specifies whether encryption is required on the mobile device. | |
| **RequireEncryptedSMIMEMessages** | Write | Boolean | The RequireEncryptedSMIMEMessages parameter specifies whether the mobile device must send encrypted S/MIME messages. | |
| **RequireEncryptionSMIMEAlgorithm** | Write | String | The RequireEncryptionSMIMEAlgorithm parameter specifies the algorithm that's required to encrypt S/MIME messages on a mobile device. | `DES`, `TripleDES`, `RC240bit`, `RC264bit`, `RC2128bit` |
| **RequireManualSyncWhenRoaming** | Write | Boolean | The RequireSignedSMIMEAlgorithm parameter specifies the algorithm that's used to sign S/MIME messages on the mobile device. | |
| **RequireSignedSMIMEAlgorithm** | Write | String | The RequireSignedSMIMEAlgorithm parameter specifies the algorithm that's used to sign S/MIME messages on the mobile device. | `SHA1`, `MD5` |
| **RequireSignedSMIMEMessages** | Write | Boolean | The RequireSignedSMIMEMessages parameter specifies whether the mobile device must send signed S/MIME messages. | |
| **RequireStorageCardEncryption** | Write | Boolean | The RequireStorageCardEncryption parameter specifies whether storage card encryption is required on the mobile device. | |
| **UnapprovedInROMApplicationList** | Write | StringArray[] | The UnapprovedInROMApplicationList parameter specifies a list of applications that can't be run in ROM on the mobile device. | |
| **UNCAccessEnabled** | Write | Boolean | The UNCAccessEnabled parameter specifies whether access to Microsoft Windows file shares is enabled from the mobile device. | |
| **WSSAccessEnabled** | Write | Boolean | The WSSAccessEnabled parameter specifies whether access to Microsoft Windows SharePoint Services is enabled from the mobile device. | |
| **Ensure** | Write | String | Specify if the Mobile Device Mailbox Policy should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

This resource configures Mobile Device Mailbox Policies in Exchange Online.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Recipient Policies, View-Only Recipients, Mail Recipient Creation, View-Only Configuration, Mail Recipients

#### Role Groups

- Organization Management

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
        EXOMobileDeviceMailboxPolicy 'ConfigureMobileDeviceMailboxPolicy'
        {
            Name                                     = "Default"
            AllowApplePushNotifications              = $True
            AllowBluetooth                           = "Allow"
            AllowBrowser                             = $True
            AllowCamera                              = $True
            AllowConsumerEmail                       = $True
            AllowDesktopSync                         = $True
            AllowExternalDeviceManagement            = $False
            AllowGooglePushNotifications             = $True
            AllowHTMLEmail                           = $True
            AllowInternetSharing                     = $True
            AllowIrDA                                = $True
            AllowMicrosoftPushNotifications          = $True
            AllowMobileOTAUpdate                     = $True
            AllowNonProvisionableDevices             = $True
            AllowPOPIMAPEmail                        = $True
            AllowRemoteDesktop                       = $True
            AllowSimplePassword                      = $True
            AllowSMIMEEncryptionAlgorithmNegotiation = "AllowAnyAlgorithmNegotiation"
            AllowSMIMESoftCerts                      = $True
            AllowStorageCard                         = $True
            AllowTextMessaging                       = $True
            AllowUnsignedApplications                = $True
            AllowUnsignedInstallationPackages        = $True
            AllowWiFi                                = $True
            AlphanumericPasswordRequired             = $False
            ApprovedApplicationList                  = @()
            AttachmentsEnabled                       = $True
            DeviceEncryptionEnabled                  = $False
            DevicePolicyRefreshInterval              = "Unlimited"
            IrmEnabled                               = $True
            IsDefault                                = $True
            MaxAttachmentSize                        = "Unlimited"
            MaxCalendarAgeFilter                     = "All"
            MaxEmailAgeFilter                        = "All"
            MaxEmailBodyTruncationSize               = "Unlimited"
            MaxEmailHTMLBodyTruncationSize           = "Unlimited"
            MaxInactivityTimeLock                    = "Unlimited"
            MaxPasswordFailedAttempts                = "Unlimited"
            MinPasswordComplexCharacters             = 1
            PasswordEnabled                          = $False
            PasswordExpiration                       = "Unlimited"
            PasswordHistory                          = 0
            PasswordRecoveryEnabled                  = $False
            RequireDeviceEncryption                  = $False
            RequireEncryptedSMIMEMessages            = $False
            RequireEncryptionSMIMEAlgorithm          = "TripleDES"
            RequireManualSyncWhenRoaming             = $False
            RequireSignedSMIMEAlgorithm              = "SHA1"
            RequireSignedSMIMEMessages               = $False
            RequireStorageCardEncryption             = $False
            UnapprovedInROMApplicationList           = @()
            UNCAccessEnabled                         = $True
            WSSAccessEnabled                         = $True
            Ensure                                   = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
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
        EXOMobileDeviceMailboxPolicy 'ConfigureMobileDeviceMailboxPolicy'
        {
            Name                                     = "Default"
            AllowApplePushNotifications              = $True
            AllowBluetooth                           = "Allow"
            AllowBrowser                             = $False # Updated Property
            AllowCamera                              = $True
            AllowConsumerEmail                       = $True
            AllowDesktopSync                         = $True
            AllowExternalDeviceManagement            = $False
            AllowGooglePushNotifications             = $True
            AllowHTMLEmail                           = $True
            AllowInternetSharing                     = $True
            AllowIrDA                                = $True
            AllowMicrosoftPushNotifications          = $True
            AllowMobileOTAUpdate                     = $True
            AllowNonProvisionableDevices             = $True
            AllowPOPIMAPEmail                        = $True
            AllowRemoteDesktop                       = $True
            AllowSimplePassword                      = $True
            AllowSMIMEEncryptionAlgorithmNegotiation = "AllowAnyAlgorithmNegotiation"
            AllowSMIMESoftCerts                      = $True
            AllowStorageCard                         = $True
            AllowTextMessaging                       = $True
            AllowUnsignedApplications                = $True
            AllowUnsignedInstallationPackages        = $True
            AllowWiFi                                = $True
            AlphanumericPasswordRequired             = $False
            ApprovedApplicationList                  = @()
            AttachmentsEnabled                       = $True
            DeviceEncryptionEnabled                  = $False
            DevicePolicyRefreshInterval              = "Unlimited"
            IrmEnabled                               = $True
            IsDefault                                = $True
            MaxAttachmentSize                        = "Unlimited"
            MaxCalendarAgeFilter                     = "All"
            MaxEmailAgeFilter                        = "All"
            MaxEmailBodyTruncationSize               = "Unlimited"
            MaxEmailHTMLBodyTruncationSize           = "Unlimited"
            MaxInactivityTimeLock                    = "Unlimited"
            MaxPasswordFailedAttempts                = "Unlimited"
            MinPasswordComplexCharacters             = 1
            PasswordEnabled                          = $False
            PasswordExpiration                       = "Unlimited"
            PasswordHistory                          = 0
            PasswordRecoveryEnabled                  = $False
            RequireDeviceEncryption                  = $False
            RequireEncryptedSMIMEMessages            = $False
            RequireEncryptionSMIMEAlgorithm          = "TripleDES"
            RequireManualSyncWhenRoaming             = $False
            RequireSignedSMIMEAlgorithm              = "SHA1"
            RequireSignedSMIMEMessages               = $False
            RequireStorageCardEncryption             = $False
            UnapprovedInROMApplicationList           = @()
            UNCAccessEnabled                         = $True
            WSSAccessEnabled                         = $True
            Ensure                                   = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
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
        EXOMobileDeviceMailboxPolicy 'ConfigureMobileDeviceMailboxPolicy'
        {
            Name                                     = "Default"
            Ensure                                   = "Absent"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
```

