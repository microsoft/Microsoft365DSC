# EXOManagementRole

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the name of the role. The maximum length of the name is 64 characters. ||
| **Parent** | Key | String | The Parent parameter specifies the identity of the role to copy. Mandatory for management role creation/update or when Ensure=Present. Non-mandatory for Ensure=Absent ||
| **Description** | Write | String | The Description parameter specifies the description that's displayed when the management role is viewed using the Get-ManagementRole cmdlet. ||
| **Ensure** | Write | String | Specify if the Management Role should exist or not. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||

# EXOManagementRole

### Description

This resource configures RBAC Management Roles in Exchange Online.

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

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
            Credential                               = $credsGlobalAdmin
        }
    }
}
```

