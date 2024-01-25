<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
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
            Credential                               = $Credscredential
        }
    }
}
