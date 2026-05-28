Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXOActiveSyncMailboxPolicy'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Boolean]
        $AllowApplePushNotifications,

        [Parameter()]
        [System.String]
        [ValidateSet('Disable', 'HandsfreeOnly', 'Allow')]
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
        $AllowGooglePushNotifications,

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
        $AllowMicrosoftPushNotifications,

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
        $ApprovedApplicationList,

        [Parameter()]
        [System.Boolean]
        $AttachmentsEnabled,

        [Parameter()]
        [System.Boolean]
        $DeviceEncryptionEnabled,

        [Parameter()]
        [System.Boolean]
        $PasswordEnabled,

        [Parameter()]
        [System.String]
        $PasswordExpiration,

        [Parameter()]
        [System.Int32]
        $PasswordHistory,

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
        [System.Boolean]
        $IsDefaultPolicy,

        [Parameter()]
        [System.String]
        $MaxAttachmentSize,

        [Parameter()]
        [System.String]
        [ValidateSet('All', 'TwoWeeks', 'OneMonth', 'ThreeMonths', 'SixMonths')]
        $MaxCalendarAgeFilter,

        [Parameter()]
        [System.String]
        $MaxPasswordFailedAttempts,

        [Parameter()]
        [System.String]
        [ValidateSet('All', 'OneDay', 'ThreeDays', 'OneWeek', 'TwoWeeks', 'OneMonth', 'ThreeMonths', 'SixMonths')]
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
        [System.Int32]
        $MinPasswordComplexCharacters,

        [Parameter()]
        [System.Int32]
        $MinPasswordLength,

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
        [System.String]
        $RequireEncryptionSMIMEAlgorithm,

        [Parameter()]
        [System.Boolean]
        $RequireManualSyncWhenRoaming,

        [Parameter()]
        [System.String]
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration for ActiveSync Mailbox Policy with Identity $Identity"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Identity -ne $Identity)
        {

            $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
                -InboundParameters $PSBoundParameters

            Confirm-M365DSCDependencies

            $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
            $CommandName = $MyInvocation.MyCommand
            $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
                -CommandName $CommandName `
                -Parameters $PSBoundParameters
            Add-M365DSCTelemetryEvent -Data $data

            $nullResult = $PSBoundParameters
            $nullResult.Ensure = 'Absent'

            $instance = Get-MobileDeviceMailboxPolicy -Identity $Identity -ErrorAction SilentlyContinue

            if ($null -eq $instance)
            {
                Write-Verbose -Message "An EXO ActiveSync Mailbox Policy with Identity $Identity was not found."
                return $nullResult
            }
        }
        else
        {
            $instance = $Script:exportedInstance
        }

        Write-Verbose -Message "An EXO ActiveSync Mailbox Policy with Identity $Identity was found."

        $results = @{
            Ensure                                   = 'Present'
            Name                                     = [System.String]$instance.Name
            AllowApplePushNotifications              = [System.Boolean]$instance.AllowApplePushNotifications
            AllowBluetooth                           = [System.String]$instance.AllowBluetooth
            AllowBrowser                             = [System.Boolean]$instance.AllowBrowser
            AllowCamera                              = [System.Boolean]$instance.AllowCamera
            AllowConsumerEmail                       = [System.Boolean]$instance.AllowConsumerEmail
            AllowDesktopSync                         = [System.Boolean]$instance.AllowDesktopSync
            AllowExternalDeviceManagement            = [System.Boolean]$instance.AllowExternalDeviceManagement
            AllowGooglePushNotifications             = [System.Boolean]$instance.AllowGooglePushNotifications
            AllowHTMLEmail                           = [System.Boolean]$instance.AllowHTMLEmail
            AllowInternetSharing                     = [System.Boolean]$instance.AllowInternetSharing
            AllowIrDA                                = [System.Boolean]$instance.AllowIrDA
            AllowMicrosoftPushNotifications          = [System.Boolean]$instance.AllowMicrosoftPushNotifications
            AllowMobileOTAUpdate                     = [System.Boolean]$instance.AllowMobileOTAUpdate
            AllowNonProvisionableDevices             = [System.Boolean]$instance.AllowNonProvisionableDevices
            AllowPOPIMAPEmail                        = [System.Boolean]$instance.AllowPOPIMAPEmail
            AllowRemoteDesktop                       = [System.Boolean]$instance.AllowRemoteDesktop
            AllowSimplePassword                      = [System.Boolean]$instance.AllowSimplePassword
            AllowSMIMEEncryptionAlgorithmNegotiation = [System.String]$instance.AllowSMIMEEncryptionAlgorithmNegotiation
            AllowSMIMESoftCerts                      = [System.Boolean]$instance.AllowSMIMESoftCerts
            AllowStorageCard                         = [System.Boolean]$instance.AllowStorageCard
            AllowTextMessaging                       = [System.Boolean]$instance.AllowTextMessaging
            AllowUnsignedApplications                = [System.Boolean]$instance.AllowUnsignedApplications
            AllowUnsignedInstallationPackages        = [System.Boolean]$instance.AllowUnsignedInstallationPackages
            AllowWiFi                                = [System.Boolean]$instance.AllowWiFi
            AlphanumericPasswordRequired             = [System.Boolean]$instance.AlphanumericPasswordRequired
            ApprovedApplicationList                  = [System.String[]]$instance.ApprovedApplicationList
            AttachmentsEnabled                       = [System.Boolean]$instance.AttachmentsEnabled
            DeviceEncryptionEnabled                  = [System.Boolean]$instance.DeviceEncryptionEnabled
            PasswordEnabled                          = [System.Boolean]$instance.PasswordEnabled
            PasswordExpiration                       = [System.String]$instance.PasswordExpiration
            PasswordHistory                          = [System.Int32]$instance.PasswordHistory
            DevicePolicyRefreshInterval              = [System.String]$instance.DevicePolicyRefreshInterval
            IrmEnabled                               = [System.Boolean]$instance.IrmEnabled
            IsDefault                                = [System.Boolean]$instance.IsDefault
            IsDefaultPolicy                          = [System.Boolean]$instance.IsDefaultPolicy
            MaxAttachmentSize                        = [System.String]$instance.MaxAttachmentSize
            MaxCalendarAgeFilter                     = [System.String]$instance.MaxCalendarAgeFilter
            MaxPasswordFailedAttempts                = [System.String]$instance.MaxPasswordFailedAttempts
            MaxEmailAgeFilter                        = [System.String]$instance.MaxEmailAgeFilter
            MaxEmailBodyTruncationSize               = [System.String]$instance.MaxEmailBodyTruncationSize
            MaxEmailHTMLBodyTruncationSize           = [System.String]$instance.MaxEmailHTMLBodyTruncationSize
            MaxInactivityTimeLock                    = [System.String]$instance.MaxInactivityTimeLock
            MinPasswordComplexCharacters             = [System.Int32]$instance.MinPasswordComplexCharacters
            MinPasswordLength                        = [System.Int32]$instance.MinPasswordLength
            PasswordRecoveryEnabled                  = [System.Boolean]$instance.PasswordRecoveryEnabled
            RequireDeviceEncryption                  = [System.Boolean]$instance.RequireDeviceEncryption
            RequireEncryptedSMIMEMessages            = [System.Boolean]$instance.RequireEncryptedSMIMEMessages
            RequireEncryptionSMIMEAlgorithm          = [System.String]$instance.RequireEncryptionSMIMEAlgorithm
            RequireManualSyncWhenRoaming             = [System.Boolean]$instance.RequireManualSyncWhenRoaming
            RequireSignedSMIMEAlgorithm              = [System.String]$instance.RequireSignedSMIMEAlgorithm
            RequireSignedSMIMEMessages               = [System.Boolean]$instance.RequireSignedSMIMEMessages
            RequireStorageCardEncryption             = [System.Boolean]$instance.RequireStorageCardEncryption
            UnapprovedInROMApplicationList           = [System.String[]]$instance.UnapprovedInROMApplicationList
            UNCAccessEnabled                         = [System.Boolean]$instance.UNCAccessEnabled
            WSSAccessEnabled                         = [System.Boolean]$instance.WSSAccessEnabled
            Identity                                 = [System.String]$Identity
            Credential                               = $Credential
            ApplicationId                            = $ApplicationId
            TenantId                                 = $TenantId
            CertificateThumbprint                    = $CertificateThumbprint
            CertificatePath                          = $CertificatePath
            CertificatePassword                      = $CertificatePassword
            ManagedIdentity                          = $ManagedIdentity.IsPresent
            AccessTokens                             = $AccessTokens
        }
        return $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Boolean]
        $AllowApplePushNotifications,

        [Parameter()]
        [System.String]
        [ValidateSet('Disable', 'HandsfreeOnly', 'Allow')]
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
        $AllowGooglePushNotifications,

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
        $AllowMicrosoftPushNotifications,

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
        $ApprovedApplicationList,

        [Parameter()]
        [System.Boolean]
        $AttachmentsEnabled,

        [Parameter()]
        [System.Boolean]
        $DeviceEncryptionEnabled,

        [Parameter()]
        [System.Boolean]
        $PasswordEnabled,

        [Parameter()]
        [System.String]
        $PasswordExpiration,

        [Parameter()]
        [System.Int32]
        $PasswordHistory,

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
        [System.Boolean]
        $IsDefaultPolicy,

        [Parameter()]
        [System.String]
        $MaxAttachmentSize,

        [Parameter()]
        [System.String]
        [ValidateSet('All', 'TwoWeeks', 'OneMonth', 'ThreeMonths', 'SixMonths')]
        $MaxCalendarAgeFilter,

        [Parameter()]
        [System.String]
        $MaxPasswordFailedAttempts,

        [Parameter()]
        [System.String]
        [ValidateSet('All', 'OneDay', 'ThreeDays', 'OneWeek', 'TwoWeeks', 'OneMonth', 'ThreeMonths', 'SixMonths')]
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
        [System.Int32]
        $MinPasswordComplexCharacters,

        [Parameter()]
        [System.Int32]
        $MinPasswordLength,

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
        [System.String]
        $RequireEncryptionSMIMEAlgorithm,

        [Parameter()]
        [System.Boolean]
        $RequireManualSyncWhenRoaming,

        [Parameter()]
        [System.String]
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration for ActiveSync Mailbox Policy with Identity $Identity"

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
        $setParameters.Remove('Identity')
        New-MobileDeviceMailboxPolicy @SetParameters
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Set-MobileDeviceMailboxPolicy @SetParameters
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Remove-MobileDeviceMailboxPolicy -Identity $Identity
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Boolean]
        $AllowApplePushNotifications,

        [Parameter()]
        [System.String]
        [ValidateSet('Disable', 'HandsfreeOnly', 'Allow')]
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
        $AllowGooglePushNotifications,

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
        $AllowMicrosoftPushNotifications,

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
        $ApprovedApplicationList,

        [Parameter()]
        [System.Boolean]
        $AttachmentsEnabled,

        [Parameter()]
        [System.Boolean]
        $DeviceEncryptionEnabled,

        [Parameter()]
        [System.Boolean]
        $PasswordEnabled,

        [Parameter()]
        [System.String]
        $PasswordExpiration,

        [Parameter()]
        [System.Int32]
        $PasswordHistory,

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
        [System.Boolean]
        $IsDefaultPolicy,

        [Parameter()]
        [System.String]
        $MaxAttachmentSize,

        [Parameter()]
        [System.String]
        [ValidateSet('All', 'TwoWeeks', 'OneMonth', 'ThreeMonths', 'SixMonths')]
        $MaxCalendarAgeFilter,

        [Parameter()]
        [System.String]
        $MaxPasswordFailedAttempts,

        [Parameter()]
        [System.String]
        [ValidateSet('All', 'OneDay', 'ThreeDays', 'OneWeek', 'TwoWeeks', 'OneMonth', 'ThreeMonths', 'SixMonths')]
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
        [System.Int32]
        $MinPasswordComplexCharacters,

        [Parameter()]
        [System.Int32]
        $MinPasswordLength,

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
        [System.String]
        $RequireEncryptionSMIMEAlgorithm,

        [Parameter()]
        [System.Boolean]
        $RequireManualSyncWhenRoaming,

        [Parameter()]
        [System.String]
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '')
    return $result
}

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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
        [array]$policies = Get-MobileDeviceMailboxPolicy -ErrorAction Stop

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        if ($policies.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $policies)
        {
            $displayedKey = $config.Name
            Write-M365DSCHost -Message "    |---[$i/$($policies.Count)] $displayedKey" -DeferWrite
            $params = @{
                Identity              = $config.Name
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            [void]$dscContent.Append($currentDSCBlock)
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent.ToString()
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

Export-ModuleMember -Function *-TargetResource
