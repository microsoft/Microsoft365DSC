#NewFile
```powershell
function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        [ValidateSet("Disable", "HandsfreeOnly", "Allow")]
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
        $AllowSimpleDevicePassword,

        [Parameter()]
        [System.Object]
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
        $AlphanumericDevicePasswordRequired,

        [Parameter()]
        [System.Boolean]
        $AttachmentsEnabled,

        [Parameter()]
        [System.Boolean]
        $DeviceEncryptionEnabled,

        [Parameter()]
        [System.Boolean]
        $DevicePasswordEnabled,

        [Parameter()]
        [System.Object]
        $DevicePasswordExpiration,

        [Parameter()]
        [System.Int32]
        $DevicePasswordHistory,

        [Parameter()]
        [System.Object]
        $DevicePolicyRefreshInterval,

        [Parameter()]
        [System.Boolean]
        $IrmEnabled,

        [Parameter()]
        [System.Boolean]
        $IsDefault,

        [Parameter()]
        [System.Object]
        $MaxAttachmentSize,

        [Parameter()]
        [System.String]
        [ValidateSet("All", "TwoWeeks", "OneMonth", "ThreeMonths", "SixMonths")]
        $MaxCalendarAgeFilter,

        [Parameter()]
        [System.Object]
        $MaxDevicePasswordFailedAttempts,

        [Parameter()]
        [System.String]
        [ValidateSet("All", "OneDay", "ThreeDays", "OneWeek", "TwoWeeks", "OneMonth", "ThreeMonths", "SixMonths")]
        $MaxEmailAgeFilter,

        [Parameter()]
        [System.Object]
        $MaxEmailBodyTruncationSize,

        [Parameter()]
        [System.Object]
        $MaxEmailHTMLBodyTruncationSize,

        [Parameter()]
        [System.Object]
        $MaxInactivityTimeDeviceLock,

        [Parameter()]
        [System.Int32]
        $MinDevicePasswordComplexCharacters,

        [Parameter()]
        [System.Int32]
        $MinDevicePasswordLength,

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
        [System.Object]
        $RequireEncryptionSMIMEAlgorithm,

        [Parameter()]
        [System.Boolean]
        $RequireManualSyncWhenRoaming,

        [Parameter()]
        [System.Object]
        $RequireSignedSMIMEAlgorithm,

        [Parameter()]
        [System.Boolean]
        $RequireSignedSMIMEMessages,

        [Parameter()]
        [System.Boolean]
        $RequireStorageCardEncryption,

        [Parameter()]
        [System.Boolean]
        $UNCAccessEnabled,

        [Parameter()]
        [System.Boolean]
        $WSSAccessEnabled,

        [Parameter(Mandatory = $true)]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $AllowApplePushNotifications,

        [Parameter()]
        [System.Object]
        $AllowSMIMEEncryptionAlgorithmNegotiation,

        [Parameter()]
        [System.Object]
        $ApprovedApplicationList,

        [Parameter()]
        [System.Object]
        $DevicePasswordExpiration,

        [Parameter()]
        [System.Int32]
        $DevicePasswordHistory,

        [Parameter()]
        [System.Object]
        $DevicePolicyRefreshInterval,

        [Parameter()]
        [System.Boolean]
        $IsDefaultPolicy,

        [Parameter()]
        [System.Object]
        $MaxAttachmentSize,

        [Parameter()]
        [System.String]
        [ValidateSet("All", "OneDay", "ThreeDays", "OneWeek", "TwoWeeks", "OneMonth")]
        $MaxCalendarAgeFilter,

        [Parameter()]
        [System.Object]
        $MaxDevicePasswordFailedAttempts,

        [Parameter()]
        [System.String]
        [ValidateSet("All", "OneDay", "ThreeDays", "OneWeek", "TwoWeeks", "OneMonth")]
        $MaxEmailAgeFilter,

        [Parameter()]
        [System.Object]
        $MaxEmailBodyTruncationSize,

        [Parameter()]
        [System.Object]
        $MaxEmailHTMLBodyTruncationSize,

        [Parameter()]
        [System.Object]
        $MaxInactivityTimeDeviceLock,

        [Parameter()]
        [System.Int32]
        $MinDevicePasswordComplexCharacters,

        [Parameter()]
        [System.Int32]
        $MinDevicePasswordLength,

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
        [System.Object]
        $RequireEncryptionSMIMEAlgorithm,

        [Parameter()]
        [System.Boolean]
        $RequireManualSyncWhenRoaming,

        [Parameter()]
        [System.Object]
        $RequireSignedSMIMEAlgorithm,

        [Parameter()]
        [System.Boolean]
        $RequireSignedSMIMEMessages,

        [Parameter()]
        [System.Boolean]
        $RequireStorageCardEncryption,

        [Parameter()]
        [System.String[]]
        $UnapprovedInROMApplicationList,

        [Parameter()]
        [System.Boolean]
        $UNCAccessEnabled,

        [Parameter()]
        [System.Boolean]
        $WSSAccessEnabled,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters | Out-Null

    Confirm-M365DSCDependencies

    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data

    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'
    try
    {
        if ($null -ne $Script:exportedInstances -and $Script:ExportMode)
        {
            $instance = $Script:exportedInstances | Where-Object -FilterScript {$_.Name -eq $Name}
        }
        else
        {
            $instance = Get-ActiveSyncMailboxPolicy -Name $Name -ErrorAction Stop
        }
        if ($null -eq $instance)
        {
            return $nullResult
        }

        $results = @{
            Ensure                = 'Present'
            Name                  = [System.String]$instance.Name
            AllowBluetooth        = [System.String]$instance.AllowBluetooth
            AllowBrowser          = [System.Boolean]$instance.AllowBrowser
            AllowCamera           = [System.Boolean]$instance.AllowCamera
            AllowConsumerEmail    = [System.Boolean]$instance.AllowConsumerEmail
            AllowDesktopSync      = [System.Boolean]$instance.AllowDesktopSync
            AllowExternalDeviceManagement = [System.Boolean]$instance.AllowExternalDeviceManagement
            AllowHTMLEmail        = [System.Boolean]$instance.AllowHTMLEmail
            AllowInternetSharing  = [System.Boolean]$instance.AllowInternetSharing
            AllowIrDA             = [System.Boolean]$instance.AllowIrDA
            AllowMobileOTAUpdate  = [System.Boolean]$instance.AllowMobileOTAUpdate
            AllowNonProvisionableDevices = [System.Boolean]$instance.AllowNonProvisionableDevices
            AllowPOPIMAPEmail     = [System.Boolean]$instance.AllowPOPIMAPEmail
            AllowRemoteDesktop    = [System.Boolean]$instance.AllowRemoteDesktop
            AllowSimpleDevicePassword = [System.Boolean]$instance.AllowSimpleDevicePassword
            AllowSMIMEEncryptionAlgorithmNegotiation = $instance.AllowSMIMEEncryptionAlgorithmNegotiation
            AllowSMIMESoftCerts   = [System.Boolean]$instance.AllowSMIMESoftCerts
            AllowStorageCard      = [System.Boolean]$instance.AllowStorageCard
            AllowTextMessaging    = [System.Boolean]$instance.AllowTextMessaging
            AllowUnsignedApplications = [System.Boolean]$instance.AllowUnsignedApplications
            AllowUnsignedInstallationPackages = [System.Boolean]$instance.AllowUnsignedInstallationPackages
            AllowWiFi             = [System.Boolean]$instance.AllowWiFi
            AlphanumericDevicePasswordRequired = [System.Boolean]$instance.AlphanumericDevicePasswordRequired
            AttachmentsEnabled    = [System.Boolean]$instance.AttachmentsEnabled
            DeviceEncryptionEnabled = [System.Boolean]$instance.DeviceEncryptionEnabled
            DevicePasswordEnabled = [System.Boolean]$instance.DevicePasswordEnabled
            DevicePasswordExpiration = $instance.DevicePasswordExpiration
            DevicePasswordHistory = [System.Int32]$instance.DevicePasswordHistory
            DevicePolicyRefreshInterval = $instance.DevicePolicyRefreshInterval
            IrmEnabled            = [System.Boolean]$instance.IrmEnabled
            IsDefault             = [System.Boolean]$instance.IsDefault
            MaxAttachmentSize     = $instance.MaxAttachmentSize
            MaxCalendarAgeFilter  = [System.String]$instance.MaxCalendarAgeFilter
            MaxDevicePasswordFailedAttempts = $instance.MaxDevicePasswordFailedAttempts
            MaxEmailAgeFilter     = [System.String]$instance.MaxEmailAgeFilter
            MaxEmailBodyTruncationSize = $instance.MaxEmailBodyTruncationSize
            MaxEmailHTMLBodyTruncationSize = $instance.MaxEmailHTMLBodyTruncationSize
            MaxInactivityTimeDeviceLock = $instance.MaxInactivityTimeDeviceLock
            MinDevicePasswordComplexCharacters = [System.Int32]$instance.MinDevicePasswordComplexCharacters
            MinDevicePasswordLength = [System.Int32]$instance.MinDevicePasswordLength
            PasswordRecoveryEnabled = [System.Boolean]$instance.PasswordRecoveryEnabled
            RequireDeviceEncryption = [System.Boolean]$instance.RequireDeviceEncryption
            RequireEncryptedSMIMEMessages = [System.Boolean]$instance.RequireEncryptedSMIMEMessages
            RequireEncryptionSMIMEAlgorithm = $instance.RequireEncryptionSMIMEAlgorithm
            RequireManualSyncWhenRoaming = [System.Boolean]$instance.RequireManualSyncWhenRoaming
            RequireSignedSMIMEAlgorithm = $instance.RequireSignedSMIMEAlgorithm
            RequireSignedSMIMEMessages = [System.Boolean]$instance.RequireSignedSMIMEMessages
            RequireStorageCardEncryption = [System.Boolean]$instance.RequireStorageCardEncryption
            UNCAccessEnabled      = [System.Boolean]$instance.UNCAccessEnabled
            WSSAccessEnabled      = [System.Boolean]$instance.WSSAccessEnabled
            Identity              = $instance.Identity
            AllowApplePushNotifications = [System.Boolean]$instance.AllowApplePushNotifications
            AllowSMIMEEncryptionAlgorithmNegotiation = $instance.AllowSMIMEEncryptionAlgorithmNegotiation
            ApprovedApplicationList = $instance.ApprovedApplicationList
            DevicePasswordExpiration = $instance.DevicePasswordExpiration
            DevicePasswordHistory = [System.Int32]$instance.DevicePasswordHistory
            DevicePolicyRefreshInterval = $instance.DevicePolicyRefreshInterval
            IsDefaultPolicy       = [System.Boolean]$instance.IsDefaultPolicy
            MaxAttachmentSize     = $instance.MaxAttachmentSize
            MaxCalendarAgeFilter  = [System.String]$instance.MaxCalendarAgeFilter
            MaxDevicePasswordFailedAttempts = $instance.MaxDevicePasswordFailedAttempts
            MaxEmailAgeFilter     = [System.String]$instance.MaxEmailAgeFilter
            MaxEmailBodyTruncationSize = $instance.MaxEmailBodyTruncationSize
            MaxEmailHTMLBodyTruncationSize = $instance.MaxEmailHTMLBodyTruncationSize
            MaxInactivityTimeDeviceLock = $instance.MaxInactivityTimeDeviceLock
            MinDevicePasswordComplexCharacters = [System.Int32]$instance.MinDevicePasswordComplexCharacters
            MinDevicePasswordLength = [System.Int32]$instance.MinDevicePasswordLength
            PasswordRecoveryEnabled = [System.Boolean]$instance.PasswordRecoveryEnabled
            RequireDeviceEncryption = [System.Boolean]$instance.RequireDeviceEncryption
            RequireEncryptedSMIMEMessages = [System.Boolean]$instance.RequireEncryptedSMIMEMessages
            RequireEncryptionSMIMEAlgorithm = $instance.RequireEncryptionSMIMEAlgorithm
            RequireManualSyncWhenRoaming = [System.Boolean]$instance.RequireManualSyncWhenRoaming
            RequireSignedSMIMEAlgorithm = $instance.RequireSignedSMIMEAlgorithm
            RequireSignedSMIMEMessages = [System.Boolean]$instance.RequireSignedSMIMEMessages
            RequireStorageCardEncryption = [System.Boolean]$instance.RequireStorageCardEncryption
            UnapprovedInROMApplicationList = [System.String[]]$instance.UnapprovedInROMApplicationList
            UNCAccessEnabled      = [System.Boolean]$instance.UNCAccessEnabled
            WSSAccessEnabled      = [System.Boolean]$instance.WSSAccessEnabled
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
        }
        return [System.Collections.Hashtable] $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullResult
    }
}
```
```
function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        ##PrimaryKey
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        ##Parameters
        [Parameter()]  
        [System.String]  
        [ValidateSet("Disable", "HandsfreeOnly", "Allow")]
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
        $AllowSimpleDevicePassword,  

        [Parameter()]  
        [System.Object]  
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
        $AlphanumericDevicePasswordRequired,  

        [Parameter()]  
        [System.Boolean]  
        $AttachmentsEnabled,  

        [Parameter()]  
        [System.Boolean]  
        $DeviceEncryptionEnabled,  

        [Parameter()]  
        [System.Boolean]  
        $DevicePasswordEnabled,  

        [Parameter()]  
        [System.Object]  
        $DevicePasswordExpiration,  

        [Parameter()]  
        [System.Int32]  
        $DevicePasswordHistory,  

        [Parameter()]  
        [System.Object]  
        $DevicePolicyRefreshInterval,  

        [Parameter()]  
        [System.Boolean]  
        $IrmEnabled,  

        [Parameter()]  
        [System.Boolean]  
        $IsDefault,  

        [Parameter()]  
        [System.Object]  
        $MaxAttachmentSize,  

        [Parameter()]  
        [System.String]  
        [ValidateSet("All", "TwoWeeks", "OneMonth", "ThreeMonths", "SixMonths")]
        $MaxCalendarAgeFilter,  

        [Parameter()]  
        [System.Object]  
        $MaxDevicePasswordFailedAttempts,  

        [Parameter()]  
        [System.String]  
        [ValidateSet("All", "OneDay", "ThreeDays", "OneWeek", "TwoWeeks", "OneMonth", "ThreeMonths", "SixMonths")]
        $MaxEmailAgeFilter,  

        [Parameter()]  
        [System.Object]  
        $MaxEmailBodyTruncationSize,  

        [Parameter()]  
        [System.Object]  
        $MaxEmailHTMLBodyTruncationSize,  

        [Parameter()]  
        [System.Object]  
        $MaxInactivityTimeDeviceLock,  

        [Parameter()]  
        [System.Int32]  
        $MinDevicePasswordComplexCharacters,  

        [Parameter()]  
        [System.Int32]  
        $MinDevicePasswordLength,  

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
        [System.Object]  
        $RequireEncryptionSMIMEAlgorithm,  

        [Parameter()]  
        [System.Boolean]  
        $RequireManualSyncWhenRoaming,  

        [Parameter()]  
        [System.Object]  
        $RequireSignedSMIMEAlgorithm,  

        [Parameter()]  
        [System.Boolean]  
        $RequireSignedSMIMEMessages,  

        [Parameter()]  
        [System.Boolean]  
        $RequireStorageCardEncryption,  

        [Parameter()]  
        [System.Boolean]  
        $UNCAccessEnabled,  

        [Parameter()]  
        [System.Boolean]  
        $WSSAccessEnabled,  

        [Parameter(Mandatory=$true)]  
        [System.Object]  
        $Identity,  

        [Parameter()]  
        [System.Boolean]  
        $AllowApplePushNotifications,  

        [Parameter()]  
        [System.Object]  
        $AllowSMIMEEncryptionAlgorithmNegotiation,  

        [Parameter()]  
        [System.Object]  
        $ApprovedApplicationList,  

        [Parameter()]  
        [System.Object]  
        $DevicePasswordExpiration,  

        [Parameter()]  
        [System.Int32]  
        $DevicePasswordHistory,  

        [Parameter()]  
        [System.Object]  
        $DevicePolicyRefreshInterval,  

        [Parameter()]  
        [System.Boolean]  
        $IsDefaultPolicy,  

        [Parameter()]  
        [System.Object]  
        $MaxAttachmentSize,  

        [Parameter()]  
        [System.String]  
        [ValidateSet("All", "OneDay", "ThreeDays", "OneWeek", "TwoWeeks", "OneMonth")]
        $MaxCalendarAgeFilter,  

        [Parameter()]  
        [System.Object]  
        $MaxDevicePasswordFailedAttempts,  

        [Parameter()]  
        [System.String]  
        [ValidateSet("All", "OneDay", "ThreeDays", "OneWeek", "TwoWeeks", "OneMonth")]
        $MaxEmailAgeFilter,  

        [Parameter()]  
        [System.Object]  
        $MaxEmailBodyTruncationSize,  

        [Parameter()]  
        [System.Object]  
        $MaxEmailHTMLBodyTruncationSize,  

        [Parameter()]  
        [System.Object]  
        $MaxInactivityTimeDeviceLock,  

        [Parameter()]  
        [System.Int32]  
        $MinDevicePasswordComplexCharacters,  

        [Parameter()]  
        [System.Int32]  
        $MinDevicePasswordLength,  

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
        [System.Object]  
        $RequireEncryptionSMIMEAlgorithm,  

        [Parameter()]  
        [System.Boolean]  
        $RequireManualSyncWhenRoaming,  

        [Parameter()]  
        [System.Object]  
        $RequireSignedSMIMEAlgorithm,  

        [Parameter()]  
        [System.Boolean]  
        $RequireSignedSMIMEMessages,  

        [Parameter()]  
        [System.Boolean]  
        $RequireStorageCardEncryption,  

        [Parameter()]  
        [System.String[]]  
        $UnapprovedInROMApplicationList,  

        [Parameter()]  
        [System.Boolean]  
        $UNCAccessEnabled,  

        [Parameter()]  
        [System.Boolean]  
        $WSSAccessEnabled  
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentInstance = Get-TargetResource @PSBoundParameters

    $setParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        New-ActiveSyncMailboxPolicy @SetParameters
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Set-ActiveSyncMailboxPolicy @SetParameters
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Remove-ActiveSyncMailboxPolicy -Identity $Name
    }
}
```

```
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        [ValidateSet("Disable", "HandsfreeOnly", "Allow")]
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
        $AllowSimpleDevicePassword,

        [Parameter()]
        [System.Object]
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
        $AlphanumericDevicePasswordRequired,

        [Parameter()]
        [System.Boolean]
        $AttachmentsEnabled,

        [Parameter()]
        [System.Boolean]
        $DeviceEncryptionEnabled,

        [Parameter()]
        [System.Boolean]
        $DevicePasswordEnabled,

        [Parameter()]
        [System.Object]
        $DevicePasswordExpiration,

        [Parameter()]
        [System.Int32]
        $DevicePasswordHistory,

        [Parameter()]
        [System.Object]
        $DevicePolicyRefreshInterval,

        [Parameter()]
        [System.Boolean]
        $IrmEnabled,

        [Parameter()]
        [System.Boolean]
        $IsDefault,

        [Parameter()]
        [System.Object]
        $MaxAttachmentSize,

        [Parameter()]
        [System.String]
        [ValidateSet("All", "TwoWeeks", "OneMonth", "ThreeMonths", "SixMonths")]
        $MaxCalendarAgeFilter,

        [Parameter()]
        [System.Object]
        $MaxDevicePasswordFailedAttempts,

        [Parameter()]
        [System.String]
        [ValidateSet("All", "OneDay", "ThreeDays", "OneWeek", "TwoWeeks", "OneMonth", "ThreeMonths", "SixMonths")]
        $MaxEmailAgeFilter,

        [Parameter()]
        [System.Object]
        $MaxEmailBodyTruncationSize,

        [Parameter()]
        [System.Object]
        $MaxEmailHTMLBodyTruncationSize,

        [Parameter()]
        [System.Object]
        $MaxInactivityTimeDeviceLock,

        [Parameter()]
        [System.Int32]
        $MinDevicePasswordComplexCharacters,

        [Parameter()]
        [System.Int32]
        $MinDevicePasswordLength,

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
        [System.Object]
        $RequireEncryptionSMIMEAlgorithm,

        [Parameter()]
        [System.Boolean]
        $RequireManualSyncWhenRoaming,

        [Parameter()]
        [System.Object]
        $RequireSignedSMIMEAlgorithm,

        [Parameter()]
        [System.Boolean]
        $RequireSignedSMIMEMessages,

        [Parameter()]
        [System.Boolean]
        $RequireStorageCardEncryption,

        [Parameter()]
        [System.Boolean]
        $UNCAccessEnabled,

        [Parameter()]
        [System.Boolean]
        $WSSAccessEnabled,

        [Parameter(Mandatory=$true)]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $AllowApplePushNotifications,

        [Parameter()]
        [System.Object]
        $AllowSMIMEEncryptionAlgorithmNegotiation,

        [Parameter()]
        [System.Object]
        $ApprovedApplicationList,

        [Parameter()]
        [System.Object]
        $DevicePasswordExpiration,

        [Parameter()]
        [System.Int32]
        $DevicePasswordHistory,

        [Parameter()]
        [System.Object]
        $DevicePolicyRefreshInterval,

        [Parameter()]
        [System.Boolean]
        $IsDefaultPolicy,

        [Parameter()]
        [System.Object]
        $MaxAttachmentSize,

        [Parameter()]
        [System.String]
        [ValidateSet("All", "OneDay", "ThreeDays", "OneWeek", "TwoWeeks", "OneMonth")]
        $MaxCalendarAgeFilter,

        [Parameter()]
        [System.Object]
        $MaxDevicePasswordFailedAttempts,

        [Parameter()]
        [System.String]
        [ValidateSet("All", "OneDay", "ThreeDays", "OneWeek", "TwoWeeks", "OneMonth")]
        $MaxEmailAgeFilter,

        [Parameter()]
        [System.Object]
        $MaxEmailBodyTruncationSize,

        [Parameter()]
        [System.Object]
        $MaxEmailHTMLBodyTruncationSize,

        [Parameter()]
        [System.Object]
        $MaxInactivityTimeDeviceLock,

        [Parameter()]
        [System.Int32]
        $MinDevicePasswordComplexCharacters,

        [Parameter()]
        [System.Int32]
        $MinDevicePasswordLength,

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
        [System.Object]
        $RequireEncryptionSMIMEAlgorithm,

        [Parameter()]
        [System.Boolean]
        $RequireManualSyncWhenRoaming,

        [Parameter()]
        [System.Object]
        $RequireSignedSMIMEAlgorithm,

        [Parameter()]
        [System.Boolean]
        $RequireSignedSMIMEMessages,

        [Parameter()]
        [System.Boolean]
        $RequireStorageCardEncryption,

        [Parameter()]
        [System.String[]]
        $UnapprovedInROMApplicationList,

        [Parameter()]
        [System.Boolean]
        $UNCAccessEnabled,

        [Parameter()]
        [System.Boolean]
        $WSSAccessEnabled,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).Clone()

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $testResult"

    return $testResult
}
```
```powershell
function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        $Script:ExportMode = $true
        [array] $Script:exportedInstances = Get-ActiveSyncMailboxPolicy -ErrorAction Stop

        $i = 1
        $dscContent = ''
        if ($Script:exportedInstances.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $Script:exportedInstances)
        {
            $displayedKey = $config.Name
            Write-Host "    |---[$i/$($Script:exportedInstances.Count)] $displayedKey" -NoNewline
            $params = @{
                Name                   = $config.Name
                Credential             = $Credential
                ApplicationId          = $ApplicationId
                TenantId               = $TenantId
                CertificateThumbprint  = $CertificateThumbprint
                ManagedIdentity        = $ManagedIdentity.IsPresent
                AccessTokens           = $AccessTokens
            }

            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        return $dscContent
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}
```
In the updated script, the 'Workload' value in New-M365DSCConnection cmdlet has been replaced with 'ExchangeOnline'. The Get-cmdlet has been updated with the corresponding Get cmdlet from the cmdlets list of the resource template, which is 'Get-ActiveSyncMailboxPolicy'. The PrimaryKey has been selected as 'Name' from the argument list provided in the resource template. The $primaryKey has been updated with the actual primaryKey 'Name'. All the TODO comments have been removed as per the instructions.