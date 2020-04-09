function Get-TargetResource
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "")]
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.Boolean]
        $AllowApplePushNotifications,

        [Parameter()]
        [System.Boolean]
        $AllowGooglePushNotifications,

        [Parameter()]
        [System.Boolean]
        $AllowMicrosoftPushNotifications,

        [Parameter()]
        [ValidateSet('Disable', 'HandsfreeOnly', 'Allow')]
        [System.String]
        $AllowBluetooth,

        [Parameter()]
        [System.Boolean]
        $AllowBrowser,

        [Parameter()]
        [System.Boolean]
        $AllowCamera,

        [Parameter()]
        [System.Boolean]
        $AllowConsumerEmail,

        [Parameter()]
        [System.Boolean]
        $AllowDesktopSync,

        [Parameter()]
        [System.Boolean]
        $AllowExternalDeviceManagement,

        [Parameter()]
        [System.Boolean]
        $AllowHTMLEmail,

        [Parameter()]
        [System.Boolean]
        $AllowInternetSharing,

        [Parameter()]
        [System.Boolean]
        $AllowIrDA,

        [Parameter()]
        [System.Boolean]
        $AllowMobileOTAUpdate,

        [Parameter()]
        [System.Boolean]
        $AllowNonProvisionableDevices,

        [Parameter()]
        [System.Boolean]
        $AllowPOPIMAPEmail,

        [Parameter()]
        [System.Boolean]
        $AllowRemoteDesktop,

        [Parameter()]
        [System.Boolean]
        $AllowSimplePassword,

        [Parameter()]
        [ValidateSet('AllowAnyAlgorithmNegotiation', 'BlockNegotiation', 'OnlyStrongAlgorithmNegotiation')]
        [System.String]
        $AllowSMIMEEncryptionAlgorithmNegotiation,

        [Parameter()]
        [System.Boolean]
        $AllowSMIMESoftCerts,

        [Parameter()]
        [System.Boolean]
        $AllowStorageCard,

        [Parameter()]
        [System.Boolean]
        $AllowTextMessaging,

        [Parameter()]
        [System.Boolean]
        $AllowUnsignedApplications,

        [Parameter()]
        [System.Boolean]
        $AllowUnsignedInstallationPackages,

        [Parameter()]
        [System.Boolean]
        $AllowWiFi,

        [Parameter()]
        [System.Boolean]
        $AlphanumericPasswordRequired,

        [Parameter()]
        [System.String[]]
        $ApprovedApplicationList = @(),

        [Parameter()]
        [System.Boolean]
        $AttachmentsEnabled,

        [Parameter()]
        [System.Boolean]
        $DeviceEncryptionEnabled,

        [Parameter()]
        [System.String]
        $DevicePolicyRefreshInterval,

        [Parameter()]
        [System.Boolean]
        $IrmEnabled,

        [Parameter()]
        [System.Boolean]
        $IsDefault,

        [Parameter()]
        [System.String]
        $MaxAttachmentSize,

        [Parameter()]
        [ValidateSet('All', 'TwoWeeks', 'OneMonth', 'ThreeMonths', 'SixMonths')]
        [System.String]
        $MaxCalendarAgeFilter,

        [Parameter()]
        [ValidateSet('All', 'OneDay', 'ThreeDays', 'OneWeek', 'TwoWeeks', 'OneMonth')]
        [System.String]
        $MaxEmailAgeFilter,

        [Parameter()]
        [System.String]
        $MaxEmailBodyTruncationSize,

        [Parameter()]
        [System.String]
        $MaxEmailHTMLBodyTruncationSize,

        [Parameter()]
        [System.String]
        $MaxInactivityTimeLock,

        [Parameter()]
        [System.String]
        $MaxPasswordFailedAttempts,

        [Parameter()]
        [System.String]
        $MinPasswordComplexCharacters,

        [Parameter()]
        [System.String]
        $MinPasswordLength,

        [Parameter()]
        [System.Boolean]
        $PasswordEnabled,

        [Parameter()]
        [System.String]
        $PasswordExpiration,

        [Parameter()]
        [System.String]
        $PasswordHistory,

        [Parameter()]
        [System.Boolean]
        $PasswordRecoveryEnabled,

        [Parameter()]
        [System.Boolean]
        $RequireDeviceEncryption,

        [Parameter()]
        [System.Boolean]
        $RequireEncryptedSMIMEMessages,

        [Parameter()]
        [ValidateSet('DES', 'TripleDES', 'RC240bit', 'RC264bit', 'RC2128bit')]
        [System.String]
        $RequireEncryptionSMIMEAlgorithm,

        [Parameter()]
        [System.Boolean]
        $RequireManualSyncWhenRoaming,

        [Parameter()]
        [System.String]
        [ValidateSet('SHA1', 'MD5')]
        $RequireSignedSMIMEAlgorithm,

        [Parameter()]
        [System.Boolean]
        $RequireSignedSMIMEMessages,

        [Parameter()]
        [System.Boolean]
        $RequireStorageCardEncryption,

        [Parameter()]
        [System.String[]]
        $UnapprovedInROMApplicationList = @(),

        [Parameter()]
        [System.Boolean]
        $UNCAccessEnabled,

        [Parameter()]
        [System.Boolean]
        $WSSAccessEnabled,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting Mobile Device Mailbox Policy configuration for $Name"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $AllMobileDeviceMailboxPolicies = Get-MobileDeviceMailboxPolicy

    $MobileDeviceMailboxPolicy = $AllMobileDeviceMailboxPolicies | Where-Object -FilterScript { $_.Name -eq $Name }

    if ($null -eq $MobileDeviceMailboxPolicy)
    {
        Write-Verbose -Message "Mobile Device Mailbox Policy $($Name) does not exist."

        $nullReturn = @{
            Name                                     = $Name
            AllowApplePushNotifications              = $AllowApplePushNotifications
            AllowGooglePushNotifications             = $AllowGooglePushNotifications
            AllowMicrosoftPushNotifications          = $AllowMicrosoftPushNotifications
            AllowBluetooth                           = $AllowBluetooth
            AllowBrowser                             = $AllowBrowser
            AllowCamera                              = $AllowCamera
            AllowConsumerEmail                       = $AllowConsumerEmail
            AllowDesktopSync                         = $AllowDesktopSync
            AllowExternalDeviceManagement            = $AllowExternalDeviceManagement
            AllowHTMLEmail                           = $AllowHTMLEmail
            AllowInternetSharing                     = $AllowInternetSharing
            AllowIrDA                                = $AllowIrDA
            AllowMobileOTAUpdate                     = $AllowMobileOTAUpdate
            AllowNonProvisionableDevices             = $AllowNonProvisionableDevices
            AllowPOPIMAPEmail                        = $AllowPOPIMAPEmail
            AllowRemoteDesktop                       = $AllowRemoteDesktop
            AllowSimplePassword                      = $AllowSimplePassword
            AllowSMIMEEncryptionAlgorithmNegotiation = $AllowSMIMEEncryptionAlgorithmNegotiation
            AllowSMIMESoftCerts                      = $AllowSMIMESoftCerts
            AllowStorageCard                         = $AllowStorageCard
            AllowTextMessaging                       = $AllowTextMessaging
            AllowUnsignedApplications                = $AllowUnsignedApplications
            AllowUnsignedInstallationPackages        = $AllowUnsignedInstallationPackages
            AllowWiFi                                = $AllowWiFi
            AlphanumericPasswordRequired             = $AlphanumericPasswordRequired
            ApprovedApplicationList                  = $ApprovedApplicationList
            AttachmentsEnabled                       = $AttachmentsEnabled
            DeviceEncryptionEnabled                  = $DeviceEncryptionEnabled
            DevicePolicyRefreshInterval              = $DevicePolicyRefreshInterval
            IrmEnabled                               = $IrmEnabled
            IsDefault                                = $IsDefault
            MaxAttachmentSize                        = $MaxAttachmentSize
            MaxCalendarAgeFilter                     = $MaxCalendarAgeFilter
            MaxEmailAgeFilter                        = $MaxEmailAgeFilter
            MaxEmailBodyTruncationSize               = $MaxEmailBodyTruncationSize
            MaxEmailHTMLBodyTruncationSize           = $MaxEmailHTMLBodyTruncationSize
            MaxInactivityTimeLock                    = $MaxInactivityTimeLock
            MaxPasswordFailedAttempts                = $MaxPasswordFailedAttempts
            MinPasswordComplexCharacters             = $MinPasswordComplexCharacters
            MinPasswordLength                        = $MinPasswordLength
            PasswordEnabled                          = $PasswordEnabled
            PasswordExpiration                       = $PasswordExpiration
            PasswordHistory                          = $PasswordHistory
            PasswordRecoveryEnabled                  = $PasswordRecoveryEnabled
            RequireDeviceEncryption                  = $RequireDeviceEncryption
            RequireEncryptedSMIMEMessages            = $RequireSignedSMIMEMessages
            RequireEncryptionSMIMEAlgorithm          = $RequireEncryptionSMIMEAlgorithm
            RequireManualSyncWhenRoaming             = $RequireManualSyncWhenRoaming
            RequireSignedSMIMEAlgorithm              = $RequireSignedSMIMEAlgorithm
            RequireSignedSMIMEMessages               = $RequireSignedSMIMEMessages
            RequireStorageCardEncryption             = $RequireStorageCardEncryption
            UnapprovedInROMApplicationList           = $UnapprovedInROMApplicationList
            UNCAccessEnabled                         = $UNCAccessEnabled
            WSSAccessEnabled                         = $WSSAccessEnabled
            Ensure                                   = 'Absent'
            GlobalAdminAccount                       = $GlobalAdminAccount
        }

        return $nullReturn
    }
    else
    {
        $result = @{
            Name                                     = $MobileDeviceMailboxPolicy.Name
            AllowApplePushNotifications              = $MobileDeviceMailboxPolicy.AllowApplePushNotifications
            AllowGooglePushNotifications             = $MobileDeviceMailboxPolicy.AllowGooglePushNotifications
            AllowMicrosoftPushNotifications          = $MobileDeviceMailboxPolicy.AllowMicrosoftPushNotifications
            AllowBluetooth                           = $MobileDeviceMailboxPolicy.AllowBluetooth
            AllowBrowser                             = $MobileDeviceMailboxPolicy.AllowBrowser
            AllowCamera                              = $MobileDeviceMailboxPolicy.AllowCamera
            AllowConsumerEmail                       = $MobileDeviceMailboxPolicy.AllowConsumerEmail
            AllowDesktopSync                         = $MobileDeviceMailboxPolicy.AllowDesktopSync
            AllowExternalDeviceManagement            = $MobileDeviceMailboxPolicy.AllowExternalDeviceManagement
            AllowHTMLEmail                           = $MobileDeviceMailboxPolicy.AllowHTMLEmail
            AllowInternetSharing                     = $MobileDeviceMailboxPolicy.AllowInternetSharing
            AllowIrDA                                = $MobileDeviceMailboxPolicy.AllowIrDA
            AllowMobileOTAUpdate                     = $MobileDeviceMailboxPolicy.AllowMobileOTAUpdate
            AllowNonProvisionableDevices             = $MobileDeviceMailboxPolicy.AllowNonProvisionableDevices
            AllowPOPIMAPEmail                        = $MobileDeviceMailboxPolicy.AllowPOPIMAPEmail
            AllowRemoteDesktop                       = $MobileDeviceMailboxPolicy.AllowRemoteDesktop
            AllowSimplePassword                      = $MobileDeviceMailboxPolicy.AllowSimplePassword
            AllowSMIMEEncryptionAlgorithmNegotiation = $MobileDeviceMailboxPolicy.AllowSMIMEEncryptionAlgorithmNegotiation
            AllowSMIMESoftCerts                      = $MobileDeviceMailboxPolicy.AllowSMIMESoftCerts
            AllowStorageCard                         = $MobileDeviceMailboxPolicy.AllowStorageCard
            AllowTextMessaging                       = $MobileDeviceMailboxPolicy.AllowTextMessaging
            AllowUnsignedApplications                = $MobileDeviceMailboxPolicy.AllowUnsignedApplications
            AllowUnsignedInstallationPackages        = $MobileDeviceMailboxPolicy.AllowUnsignedInstallationPackages
            AllowWiFi                                = $MobileDeviceMailboxPolicy.AllowWiFi
            AlphanumericPasswordRequired             = $MobileDeviceMailboxPolicy.AlphanumericPasswordRequired
            ApprovedApplicationList                  = $MobileDeviceMailboxPolicy.ApprovedApplicationList
            AttachmentsEnabled                       = $MobileDeviceMailboxPolicy.AttachmentsEnabled
            DeviceEncryptionEnabled                  = $MobileDeviceMailboxPolicy.DeviceEncryptionEnabled
            DevicePolicyRefreshInterval              = $MobileDeviceMailboxPolicy.DevicePolicyRefreshInterval
            IrmEnabled                               = $MobileDeviceMailboxPolicy.IrmEnabled
            IsDefault                                = $MobileDeviceMailboxPolicy.IsDefault
            MaxAttachmentSize                        = $MobileDeviceMailboxPolicy.MaxAttachmentSize
            MaxCalendarAgeFilter                     = $MobileDeviceMailboxPolicy.MaxCalendarAgeFilter
            MaxEmailAgeFilter                        = $MobileDeviceMailboxPolicy.MaxEmailAgeFilter
            MaxEmailBodyTruncationSize               = $MobileDeviceMailboxPolicy.MaxEmailBodyTruncationSize
            MaxEmailHTMLBodyTruncationSize           = $MobileDeviceMailboxPolicy.MaxEmailHTMLBodyTruncationSize
            MaxInactivityTimeLock                    = $MobileDeviceMailboxPolicy.MaxInactivityTimeLock
            MaxPasswordFailedAttempts                = $MobileDeviceMailboxPolicy.MaxPasswordFailedAttempts
            MinPasswordComplexCharacters             = $MobileDeviceMailboxPolicy.MinPasswordComplexCharacters
            MinPasswordLength                        = $MobileDeviceMailboxPolicy.MinPasswordLength
            PasswordEnabled                          = $MobileDeviceMailboxPolicy.PasswordEnabled
            PasswordExpiration                       = $MobileDeviceMailboxPolicy.PasswordExpiration
            PasswordHistory                          = $MobileDeviceMailboxPolicy.PasswordHistory
            PasswordRecoveryEnabled                  = $MobileDeviceMailboxPolicy.PasswordRecoveryEnabled
            RequireDeviceEncryption                  = $MobileDeviceMailboxPolicy.RequireDeviceEncryption
            RequireEncryptedSMIMEMessages            = $MobileDeviceMailboxPolicy.RequireSignedSMIMEMessages
            RequireEncryptionSMIMEAlgorithm          = $MobileDeviceMailboxPolicy.RequireEncryptionSMIMEAlgorithm
            RequireManualSyncWhenRoaming             = $MobileDeviceMailboxPolicy.RequireManualSyncWhenRoaming
            RequireSignedSMIMEAlgorithm              = $MobileDeviceMailboxPolicy.RequireSignedSMIMEAlgorithm
            RequireSignedSMIMEMessages               = $MobileDeviceMailboxPolicy.RequireSignedSMIMEMessages
            RequireStorageCardEncryption             = $MobileDeviceMailboxPolicy.RequireStorageCardEncryption
            UnapprovedInROMApplicationList           = $MobileDeviceMailboxPolicy.UnapprovedInROMApplicationList
            UNCAccessEnabled                         = $MobileDeviceMailboxPolicy.UNCAccessEnabled
            WSSAccessEnabled                         = $MobileDeviceMailboxPolicy.WSSAccessEnabled
            Ensure                                   = 'Present'
            GlobalAdminAccount                       = $GlobalAdminAccount
        }

        Write-Verbose -Message "Found Mobile Device Mailbox Policy $($Name)"
        return $result
    }
}

function Set-TargetResource
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "")]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.Boolean]
        $AllowApplePushNotifications,

        [Parameter()]
        [System.Boolean]
        $AllowGooglePushNotifications,

        [Parameter()]
        [System.Boolean]
        $AllowMicrosoftPushNotifications,

        [Parameter()]
        [ValidateSet('Disable', 'HandsfreeOnly', 'Allow')]
        [System.String]
        $AllowBluetooth,

        [Parameter()]
        [System.Boolean]
        $AllowBrowser,

        [Parameter()]
        [System.Boolean]
        $AllowCamera,

        [Parameter()]
        [System.Boolean]
        $AllowConsumerEmail,

        [Parameter()]
        [System.Boolean]
        $AllowDesktopSync,

        [Parameter()]
        [System.Boolean]
        $AllowExternalDeviceManagement,

        [Parameter()]
        [System.Boolean]
        $AllowHTMLEmail,

        [Parameter()]
        [System.Boolean]
        $AllowInternetSharing,

        [Parameter()]
        [System.Boolean]
        $AllowIrDA,

        [Parameter()]
        [System.Boolean]
        $AllowMobileOTAUpdate,

        [Parameter()]
        [System.Boolean]
        $AllowNonProvisionableDevices,

        [Parameter()]
        [System.Boolean]
        $AllowPOPIMAPEmail,

        [Parameter()]
        [System.Boolean]
        $AllowRemoteDesktop,

        [Parameter()]
        [System.Boolean]
        $AllowSimplePassword,

        [Parameter()]
        [ValidateSet('AllowAnyAlgorithmNegotiation', 'BlockNegotiation', 'OnlyStrongAlgorithmNegotiation')]
        [System.String]
        $AllowSMIMEEncryptionAlgorithmNegotiation,

        [Parameter()]
        [System.Boolean]
        $AllowSMIMESoftCerts,

        [Parameter()]
        [System.Boolean]
        $AllowStorageCard,

        [Parameter()]
        [System.Boolean]
        $AllowTextMessaging,

        [Parameter()]
        [System.Boolean]
        $AllowUnsignedApplications,

        [Parameter()]
        [System.Boolean]
        $AllowUnsignedInstallationPackages,

        [Parameter()]
        [System.Boolean]
        $AllowWiFi,

        [Parameter()]
        [System.Boolean]
        $AlphanumericPasswordRequired,

        [Parameter()]
        [System.String[]]
        $ApprovedApplicationList = @(),

        [Parameter()]
        [System.Boolean]
        $AttachmentsEnabled,

        [Parameter()]
        [System.Boolean]
        $DeviceEncryptionEnabled,

        [Parameter()]
        [System.String]
        $DevicePolicyRefreshInterval,

        [Parameter()]
        [System.Boolean]
        $IrmEnabled,

        [Parameter()]
        [System.Boolean]
        $IsDefault,

        [Parameter()]
        [System.String]
        $MaxAttachmentSize,

        [Parameter()]
        [ValidateSet('All', 'TwoWeeks', 'OneMonth', 'ThreeMonths', 'SixMonths')]
        [System.String]
        $MaxCalendarAgeFilter,

        [Parameter()]
        [ValidateSet('All', 'OneDay', 'ThreeDays', 'OneWeek', 'TwoWeeks', 'OneMonth')]
        [System.String]
        $MaxEmailAgeFilter,

        [Parameter()]
        [System.String]
        $MaxEmailBodyTruncationSize,

        [Parameter()]
        [System.String]
        $MaxEmailHTMLBodyTruncationSize,

        [Parameter()]
        [System.String]
        $MaxInactivityTimeLock,

        [Parameter()]
        [System.String]
        $MaxPasswordFailedAttempts,

        [Parameter()]
        [System.String]
        $MinPasswordComplexCharacters,

        [Parameter()]
        [System.String]
        $MinPasswordLength,

        [Parameter()]
        [System.Boolean]
        $PasswordEnabled,

        [Parameter()]
        [System.String]
        $PasswordExpiration,

        [Parameter()]
        [System.String]
        $PasswordHistory,

        [Parameter()]
        [System.Boolean]
        $PasswordRecoveryEnabled,

        [Parameter()]
        [System.Boolean]
        $RequireDeviceEncryption,

        [Parameter()]
        [System.Boolean]
        $RequireEncryptedSMIMEMessages,

        [Parameter()]
        [ValidateSet('DES', 'TripleDES', 'RC240bit', 'RC264bit', 'RC2128bit')]
        [System.String]
        $RequireEncryptionSMIMEAlgorithm,

        [Parameter()]
        [System.Boolean]
        $RequireManualSyncWhenRoaming,

        [Parameter()]
        [System.String]
        [ValidateSet('SHA1', 'MD5')]
        $RequireSignedSMIMEAlgorithm,

        [Parameter()]
        [System.Boolean]
        $RequireSignedSMIMEMessages,

        [Parameter()]
        [System.Boolean]
        $RequireStorageCardEncryption,

        [Parameter()]
        [System.String[]]
        $UnapprovedInROMApplicationList = @(),

        [Parameter()]
        [System.Boolean]
        $UNCAccessEnabled,

        [Parameter()]
        [System.Boolean]
        $WSSAccessEnabled,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting Mobile Device Mailbox Policy configuration for $Name"

    $currentMobileDeviceMailboxPolicyConfig = Get-TargetResource @PSBoundParameters

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $NewMobileDeviceMailboxPolicyParams = @{
        Name                                     = $Name
        AllowApplePushNotifications              = $AllowApplePushNotifications
        AllowGooglePushNotifications             = $AllowGooglePushNotifications
        AllowMicrosoftPushNotifications          = $AllowMicrosoftPushNotifications
        AllowBluetooth                           = $AllowBluetooth
        AllowBrowser                             = $AllowBrowser
        AllowCamera                              = $AllowCamera
        AllowConsumerEmail                       = $AllowConsumerEmail
        AllowDesktopSync                         = $AllowDesktopSync
        AllowExternalDeviceManagement            = $AllowExternalDeviceManagement
        AllowHTMLEmail                           = $AllowHTMLEmail
        AllowInternetSharing                     = $AllowInternetSharing
        AllowIrDA                                = $AllowIrDA
        AllowMobileOTAUpdate                     = $AllowMobileOTAUpdate
        AllowNonProvisionableDevices             = $AllowNonProvisionableDevices
        AllowPOPIMAPEmail                        = $AllowPOPIMAPEmail
        AllowRemoteDesktop                       = $AllowRemoteDesktop
        AllowSimplePassword                      = $AllowSimplePassword
        AllowSMIMEEncryptionAlgorithmNegotiation = $AllowSMIMEEncryptionAlgorithmNegotiation
        AllowSMIMESoftCerts                      = $AllowSMIMESoftCerts
        AllowStorageCard                         = $AllowStorageCard
        AllowTextMessaging                       = $AllowTextMessaging
        AllowUnsignedApplications                = $AllowUnsignedApplications
        AllowUnsignedInstallationPackages        = $AllowUnsignedInstallationPackages
        AllowWiFi                                = $AllowWiFi
        AlphanumericPasswordRequired             = $AlphanumericPasswordRequired
        ApprovedApplicationList                  = $ApprovedApplicationList
        AttachmentsEnabled                       = $AttachmentsEnabled
        DeviceEncryptionEnabled                  = $DeviceEncryptionEnabled
        DevicePolicyRefreshInterval              = $DevicePolicyRefreshInterval
        IrmEnabled                               = $IrmEnabled
        IsDefault                                = $IsDefault
        MaxAttachmentSize                        = $MaxAttachmentSize
        MaxCalendarAgeFilter                     = $MaxCalendarAgeFilter
        MaxEmailAgeFilter                        = $MaxEmailAgeFilter
        MaxEmailBodyTruncationSize               = $MaxEmailBodyTruncationSize
        MaxEmailHTMLBodyTruncationSize           = $MaxEmailHTMLBodyTruncationSize
        MaxInactivityTimeLock                    = $MaxInactivityTimeLock
        MaxPasswordFailedAttempts                = $MaxPasswordFailedAttempts
        MinPasswordComplexCharacters             = $MinPasswordComplexCharacters
        MinPasswordLength                        = $MinPasswordLength
        PasswordEnabled                          = $PasswordEnabled
        PasswordExpiration                       = $PasswordExpiration
        PasswordHistory                          = $PasswordHistory
        PasswordRecoveryEnabled                  = $PasswordRecoveryEnabled
        RequireDeviceEncryption                  = $RequireDeviceEncryption
        RequireEncryptedSMIMEMessages            = $RequireSignedSMIMEMessages
        RequireEncryptionSMIMEAlgorithm          = $RequireEncryptionSMIMEAlgorithm
        RequireManualSyncWhenRoaming             = $RequireManualSyncWhenRoaming
        RequireSignedSMIMEAlgorithm              = $RequireSignedSMIMEAlgorithm
        RequireSignedSMIMEMessages               = $RequireSignedSMIMEMessages
        RequireStorageCardEncryption             = $RequireStorageCardEncryption
        UnapprovedInROMApplicationList           = $UnapprovedInROMApplicationList
        UNCAccessEnabled                         = $UNCAccessEnabled
        WSSAccessEnabled                         = $WSSAccessEnabled
        Confirm                                  = $false
    }

    $SetMobileDeviceMailboxPolicyParams = $NewMobileDeviceMailboxPolicyParams.Clone()
    $SetMobileDeviceMailboxPolicyParams.Add('Identity', $Name)

    # CASE: Mobile Device Mailbox Policy doesn't exist but should;
    if ($Ensure -eq "Present" -and $currentMobileDeviceMailboxPolicyConfig.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Mobile Device Mailbox Policy '$($Name)' does not exist but it should. Create and configure it."
        # Create Mobile Device Mailbox Policy
        New-MobileDeviceMailboxPolicy @NewMobileDeviceMailboxPolicyParams

    }
    # CASE: Mobile Device Mailbox Policy exists but it shouldn't;
    elseif ($Ensure -eq "Absent" -and $currentMobileDeviceMailboxPolicyConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Mobile Device Mailbox Policy '$($Name)' exists but it shouldn't. Remove it."
        Remove-MobileDeviceMailboxPolicy -Identity $Name -Confirm:$false
    }
    # CASE: Mobile Device Mailbox Policy exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq "Present" -and $currentMobileDeviceMailboxPolicyConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Mobile Device Mailbox Policy '$($Name)' already exists, but needs updating."
        Write-Verbose -Message "Setting Mobile Device Mailbox Policy $($Name) with values: $(Convert-M365DscHashtableToString -Hashtable $SetMobileDeviceMailboxPolicyParams)"
        Set-MobileDeviceMailboxPolicy @SetMobileDeviceMailboxPolicyParams
    }
}

function Test-TargetResource
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "")]
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.Boolean]
        $AllowApplePushNotifications,

        [Parameter()]
        [System.Boolean]
        $AllowGooglePushNotifications,

        [Parameter()]
        [System.Boolean]
        $AllowMicrosoftPushNotifications,

        [Parameter()]
        [ValidateSet('Disable', 'HandsfreeOnly', 'Allow')]
        [System.String]
        $AllowBluetooth,

        [Parameter()]
        [System.Boolean]
        $AllowBrowser,

        [Parameter()]
        [System.Boolean]
        $AllowCamera,

        [Parameter()]
        [System.Boolean]
        $AllowConsumerEmail,

        [Parameter()]
        [System.Boolean]
        $AllowDesktopSync,

        [Parameter()]
        [System.Boolean]
        $AllowExternalDeviceManagement,

        [Parameter()]
        [System.Boolean]
        $AllowHTMLEmail,

        [Parameter()]
        [System.Boolean]
        $AllowInternetSharing,

        [Parameter()]
        [System.Boolean]
        $AllowIrDA,

        [Parameter()]
        [System.Boolean]
        $AllowMobileOTAUpdate,

        [Parameter()]
        [System.Boolean]
        $AllowNonProvisionableDevices,

        [Parameter()]
        [System.Boolean]
        $AllowPOPIMAPEmail,

        [Parameter()]
        [System.Boolean]
        $AllowRemoteDesktop,

        [Parameter()]
        [System.Boolean]
        $AllowSimplePassword,

        [Parameter()]
        [ValidateSet('AllowAnyAlgorithmNegotiation', 'BlockNegotiation', 'OnlyStrongAlgorithmNegotiation')]
        [System.String]
        $AllowSMIMEEncryptionAlgorithmNegotiation,

        [Parameter()]
        [System.Boolean]
        $AllowSMIMESoftCerts,

        [Parameter()]
        [System.Boolean]
        $AllowStorageCard,

        [Parameter()]
        [System.Boolean]
        $AllowTextMessaging,

        [Parameter()]
        [System.Boolean]
        $AllowUnsignedApplications,

        [Parameter()]
        [System.Boolean]
        $AllowUnsignedInstallationPackages,

        [Parameter()]
        [System.Boolean]
        $AllowWiFi,

        [Parameter()]
        [System.Boolean]
        $AlphanumericPasswordRequired,

        [Parameter()]
        [System.String[]]
        $ApprovedApplicationList = @(),

        [Parameter()]
        [System.Boolean]
        $AttachmentsEnabled,

        [Parameter()]
        [System.Boolean]
        $DeviceEncryptionEnabled,

        [Parameter()]
        [System.String]
        $DevicePolicyRefreshInterval,

        [Parameter()]
        [System.Boolean]
        $IrmEnabled,

        [Parameter()]
        [System.Boolean]
        $IsDefault,

        [Parameter()]
        [System.String]
        $MaxAttachmentSize,

        [Parameter()]
        [ValidateSet('All', 'TwoWeeks', 'OneMonth', 'ThreeMonths', 'SixMonths')]
        [System.String]
        $MaxCalendarAgeFilter,

        [Parameter()]
        [ValidateSet('All', 'OneDay', 'ThreeDays', 'OneWeek', 'TwoWeeks', 'OneMonth')]
        [System.String]
        $MaxEmailAgeFilter,

        [Parameter()]
        [System.String]
        $MaxEmailBodyTruncationSize,

        [Parameter()]
        [System.String]
        $MaxEmailHTMLBodyTruncationSize,

        [Parameter()]
        [System.String]
        $MaxInactivityTimeLock,

        [Parameter()]
        [System.String]
        $MaxPasswordFailedAttempts,

        [Parameter()]
        [System.String]
        $MinPasswordComplexCharacters,

        [Parameter()]
        [System.String]
        $MinPasswordLength,

        [Parameter()]
        [System.Boolean]
        $PasswordEnabled,

        [Parameter()]
        [System.String]
        $PasswordExpiration,

        [Parameter()]
        [System.String]
        $PasswordHistory,

        [Parameter()]
        [System.Boolean]
        $PasswordRecoveryEnabled,

        [Parameter()]
        [System.Boolean]
        $RequireDeviceEncryption,

        [Parameter()]
        [System.Boolean]
        $RequireEncryptedSMIMEMessages,

        [Parameter()]
        [ValidateSet('DES', 'TripleDES', 'RC240bit', 'RC264bit', 'RC2128bit')]
        [System.String]
        $RequireEncryptionSMIMEAlgorithm,

        [Parameter()]
        [System.Boolean]
        $RequireManualSyncWhenRoaming,

        [Parameter()]
        [System.String]
        [ValidateSet('SHA1', 'MD5')]
        $RequireSignedSMIMEAlgorithm,

        [Parameter()]
        [System.Boolean]
        $RequireSignedSMIMEMessages,

        [Parameter()]
        [System.Boolean]
        $RequireStorageCardEncryption,

        [Parameter()]
        [System.String[]]
        $UnapprovedInROMApplicationList = @(),

        [Parameter()]
        [System.Boolean]
        $UNCAccessEnabled,

        [Parameter()]
        [System.Boolean]
        $WSSAccessEnabled,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing Mobile Device Mailbox Policy configuration for $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $InformationPreference = 'Continue'
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    [array]$AllMobileDeviceMailboxPolicies = Get-MobileDeviceMailboxPolicy

    $dscContent = ""
    $i = 1
    foreach ($MobileDeviceMailboxPolicy in $AllMobileDeviceMailboxPolicies)
    {
        Write-Information "    [$i/$($AllMobileDeviceMailboxPolicies.Count)] $($MobileDeviceMailboxPolicy.Name)"

        $Params = @{
            Name               = $MobileDeviceMailboxPolicy.Name
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @Params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content = "        EXOMobileDeviceMailboxPolicy " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $content += "        }`r`n"
        $dscContent += $content
        $i++
    }
    return $dscContent
}

Export-ModuleMember -Function *-TargetResource

