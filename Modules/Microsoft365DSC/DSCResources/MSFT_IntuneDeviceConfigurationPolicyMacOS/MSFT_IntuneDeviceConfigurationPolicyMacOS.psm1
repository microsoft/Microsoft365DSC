Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneDeviceConfigurationPolicyMacOS'

# More information on the properties can be found here:
# - https://learn.microsoft.com/en-us/graph/api/intune-deviceconfig-macosgeneraldeviceconfiguration-create?view=graph-rest-beta
# - https://learn.microsoft.com/en-us/graph/api/resources/intune-deviceconfig-applistitem?view=graph-rest-beta
# - https://learn.microsoft.com/en-us/graph/api/resources/intune-deviceconfig-macosprivacyaccesscontrolitem?view=graph-rest-beta
# - https://learn.microsoft.com/en-us/graph/api/resources/intune-deviceconfig-macosappleeventreceiver?view=graph-rest-beta

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.Boolean]
        $AddingGameCenterFriendsBlocked,

        [Parameter()]
        [System.Boolean]
        $AirDropBlocked,

        [Parameter()]
        [System.Boolean]
        $AppleWatchBlockAutoUnlock,

        [Parameter()]
        [System.Boolean]
        $CameraBlocked,

        [Parameter()]
        [System.Boolean]
        $ClassroomAppBlockRemoteScreenObservation,

        [Parameter()]
        [System.Boolean]
        $ClassroomAppForceUnpromptedScreenObservation,

        [Parameter()]
        [System.Boolean]
        $ClassroomForceAutomaticallyJoinClasses,

        [Parameter()]
        [System.Boolean]
        $ClassroomForceRequestPermissionToLeaveClasses,

        [Parameter()]
        [System.Boolean]
        $ClassroomForceUnpromptedAppAndDeviceLock,

        [Parameter()]
        [ValidateSet('none', 'appsInListCompliant', 'appsNotInListCompliant')]
        [System.String]
        $CompliantAppListType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CompliantAppsList,

        [Parameter()]
        [System.Boolean]
        $ContentCachingBlocked,

        [Parameter()]
        [System.Boolean]
        $DefinitionLookupBlocked,

        [Parameter()]
        [System.String[]]
        $EmailInDomainSuffixes,

        [Parameter()]
        [System.Boolean]
        $EraseContentAndSettingsBlocked,

        [Parameter()]
        [System.Boolean]
        $GameCenterBlocked,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockActivityContinuation,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockAddressBook,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockBookmarks,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockCalendar,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockDocumentSync,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockMail,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockNotes,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockPhotoLibrary,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockReminders,

        [Parameter()]
        [System.Boolean]
        $ICloudDesktopAndDocumentsBlocked,

        [Parameter()]
        [System.Boolean]
        $ICloudPrivateRelayBlocked,

        [Parameter()]
        [System.Boolean]
        $ITunesBlockFileSharing,

        [Parameter()]
        [System.Boolean]
        $ITunesBlockMusicService,

        [Parameter()]
        [System.Boolean]
        $KeyboardBlockDictation,

        [Parameter()]
        [System.Boolean]
        $KeychainBlockCloudSync,

        [Parameter()]
        [System.Boolean]
        $MultiplayerGamingBlocked,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockAirDropSharing,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockAutoFill,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockFingerprintUnlock,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockModification,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockProximityRequests,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockSimple,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMaximumAttemptCount,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumCharacterSetCount,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesUntilFailedLoginReset,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Boolean]
        $PasswordRequired,

        [Parameter()]
        [ValidateSet('deviceDefault', 'alphanumeric', 'numeric')]
        [System.String]
        $PasswordRequiredType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $PrivacyAccessControls,

        [Parameter()]
        [System.Boolean]
        $SafariBlockAutofill,

        [Parameter()]
        [System.Boolean]
        $ScreenCaptureBlocked,

        [Parameter()]
        [System.Int32]
        $SoftwareUpdateMajorOSDeferredInstallDelayInDays,

        [Parameter()]
        [System.Int32]
        $SoftwareUpdateMinorOSDeferredInstallDelayInDays,

        [Parameter()]
        [System.Int32]
        $SoftwareUpdateNonOSDeferredInstallDelayInDays,

        [Parameter()]
        [System.Int32]
        $SoftwareUpdatesEnforcedDelayInDays,

        [Parameter()]
        [System.Boolean]
        $SpotlightBlockInternetResults,

        [Parameter()]
        [System.Int32]
        $TouchIdTimeoutInHours,

        [Parameter()]
        [ValidateSet('none', 'delayOSUpdateVisibility', 'delayAppUpdateVisibility', 'unknownFutureValue', 'delayMajorOsUpdateVisibility')]
        [System.String[]]
        $UpdateDelayPolicy,

        [Parameter()]
        [System.Boolean]
        $WallpaperModificationBlocked,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

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

    Write-Verbose -Message "Getting configuration of the Intune Device Configuration Policy for MacOS with Id {$Id} and DisplayName {$DisplayName}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
                -InboundParameters $PSBoundParameters

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

            $nullResult = $PSBoundParameters
            $nullResult.Ensure = 'Absent'

            $getValue = $null
            if (-not [string]::IsNullOrEmpty($Id))
            {
                $getValue = Get-MgBetaDeviceManagementDeviceConfiguration -Filter "Id eq '$Id'" -All -ErrorAction SilentlyContinue
            }

            #region resource generator code
            if ($null -eq $getValue)
            {
                $getValue = Get-MgBetaDeviceManagementDeviceConfiguration -All -Filter "DisplayName eq '$($Displayname -replace "'", "''")' and isof('microsoft.graph.macOSGeneralDeviceConfiguration')" -ErrorAction SilentlyContinue
            }
            #endregion

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Nothing with id {$Id} was found"
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }

        $updateDelayPolicyValue = @()
        if (-not [System.String]::IsNullOrEmpty($getValue.updateDelayPolicy))
        {
            foreach ($policy in ($getValue.updateDelayPolicy -split "," | Where-Object { -not [System.String]::IsNullOrEmpty($_) }))
            {
                $updateDelayPolicyValue += $policy
            }
        }

        Write-Verbose -Message "Found something with id {$($getValue.Id)}"
        $results = @{

            #region resource generator code
            Id                                              = $getValue.Id
            Description                                     = $getValue.Description
            DisplayName                                     = $getValue.DisplayName
            RoleScopeTagIds                                 = $getValue.RoleScopeTagIds
            AddingGameCenterFriendsBlocked                  = $getValue.addingGameCenterFriendsBlocked
            AirDropBlocked                                  = $getValue.airDropBlocked
            AppleWatchBlockAutoUnlock                       = $getValue.appleWatchBlockAutoUnlock
            CameraBlocked                                   = $getValue.cameraBlocked
            ClassroomAppBlockRemoteScreenObservation        = $getValue.classroomAppBlockRemoteScreenObservation
            ClassroomAppForceUnpromptedScreenObservation    = $getValue.classroomAppForceUnpromptedScreenObservation
            ClassroomForceAutomaticallyJoinClasses          = $getValue.classroomForceAutomaticallyJoinClasses
            ClassroomForceRequestPermissionToLeaveClasses   = $getValue.classroomForceRequestPermissionToLeaveClasses
            ClassroomForceUnpromptedAppAndDeviceLock        = $getValue.classroomForceUnpromptedAppAndDeviceLock
            CompliantAppListType                            = $getValue.compliantAppListType
            ContentCachingBlocked                           = $getValue.contentCachingBlocked
            DefinitionLookupBlocked                         = $getValue.definitionLookupBlocked
            EmailInDomainSuffixes                           = $getValue.emailInDomainSuffixes
            EraseContentAndSettingsBlocked                  = $getValue.eraseContentAndSettingsBlocked
            GameCenterBlocked                               = $getValue.gameCenterBlocked
            ICloudBlockActivityContinuation                 = $getValue.iCloudBlockActivityContinuation
            ICloudBlockAddressBook                          = $getValue.iCloudBlockAddressBook
            ICloudBlockBookmarks                            = $getValue.iCloudBlockBookmarks
            ICloudBlockCalendar                             = $getValue.iCloudBlockCalendar
            ICloudBlockDocumentSync                         = $getValue.iCloudBlockDocumentSync
            ICloudBlockMail                                 = $getValue.iCloudBlockMail
            ICloudBlockNotes                                = $getValue.iCloudBlockNotes
            ICloudBlockPhotoLibrary                         = $getValue.iCloudBlockPhotoLibrary
            ICloudBlockReminders                            = $getValue.iCloudBlockReminders
            ICloudDesktopAndDocumentsBlocked                = $getValue.iCloudDesktopAndDocumentsBlocked
            ICloudPrivateRelayBlocked                       = $getValue.iCloudPrivateRelayBlocked
            ITunesBlockFileSharing                          = $getValue.iTunesBlockFileSharing
            ITunesBlockMusicService                         = $getValue.iTunesBlockMusicService
            KeyboardBlockDictation                          = $getValue.keyboardBlockDictation
            KeychainBlockCloudSync                          = $getValue.keychainBlockCloudSync
            MultiplayerGamingBlocked                        = $getValue.multiplayerGamingBlocked
            PasswordBlockAirDropSharing                     = $getValue.passwordBlockAirDropSharing
            PasswordBlockAutoFill                           = $getValue.passwordBlockAutoFill
            PasswordBlockFingerprintUnlock                  = $getValue.passwordBlockFingerprintUnlock
            PasswordBlockModification                       = $getValue.passwordBlockModification
            PasswordBlockProximityRequests                  = $getValue.passwordBlockProximityRequests
            PasswordBlockSimple                             = $getValue.passwordBlockSimple
            PasswordExpirationDays                          = $getValue.passwordExpirationDays
            PasswordMaximumAttemptCount                     = $getValue.passwordMaximumAttemptCount
            PasswordMinimumCharacterSetCount                = $getValue.passwordMinimumCharacterSetCount
            PasswordMinimumLength                           = $getValue.passwordMinimumLength
            PasswordMinutesOfInactivityBeforeLock           = $getValue.passwordMinutesOfInactivityBeforeLock
            PasswordMinutesOfInactivityBeforeScreenTimeout  = $getValue.passwordMinutesOfInactivityBeforeScreenTimeout
            PasswordMinutesUntilFailedLoginReset            = $getValue.passwordMinutesUntilFailedLoginReset
            PasswordPreviousPasswordBlockCount              = $getValue.passwordPreviousPasswordBlockCount
            PasswordRequired                                = $getValue.passwordRequired
            PasswordRequiredType                            = $getValue.passwordRequiredType
            SafariBlockAutofill                             = $getValue.safariBlockAutofill
            ScreenCaptureBlocked                            = $getValue.screenCaptureBlocked
            SoftwareUpdateMajorOSDeferredInstallDelayInDays = $getValue.softwareUpdateMajorOSDeferredInstallDelayInDays
            SoftwareUpdateMinorOSDeferredInstallDelayInDays = $getValue.softwareUpdateMinorOSDeferredInstallDelayInDays
            SoftwareUpdateNonOSDeferredInstallDelayInDays   = $getValue.softwareUpdateNonOSDeferredInstallDelayInDays
            SoftwareUpdatesEnforcedDelayInDays              = $getValue.softwareUpdatesEnforcedDelayInDays
            SpotlightBlockInternetResults                   = $getValue.spotlightBlockInternetResults
            TouchIdTimeoutInHours                           = $getValue.touchIdTimeoutInHours
            UpdateDelayPolicy                               = $updateDelayPolicyValue
            WallpaperModificationBlocked                    = $getValue.wallpaperModificationBlocked
            Ensure                                          = 'Present'
            Credential                                      = $Credential
            ApplicationId                                   = $ApplicationId
            TenantId                                        = $TenantId
            ApplicationSecret                               = $ApplicationSecret
            CertificateThumbprint                           = $CertificateThumbprint
            CertificatePath                                 = $CertificatePath
            CertificatePassword                             = $CertificatePassword
            ManagedIdentity                                 = $ManagedIdentity.IsPresent
            AccessTokens                                    = $AccessTokens
        }
        if ($getValue.compliantAppsList)
        {
            $results.Add('CompliantAppsList', $getValue.compliantAppsList)
        }
        if ($getValue.privacyAccessControls)
        {
            $results.Add('PrivacyAccessControls', $getValue.privacyAccessControls)
        }

        $assignmentsValues = Get-MgBetaDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId $getValue.Id
        $assignmentResult = @()
        if ($assignmentsValues.Count -gt 0)
        {
            $assignmentResult += ConvertFrom-IntunePolicyAssignment `
                -IncludeDeviceFilter:$true `
                -Assignments ($assignmentsValues)
        }
        $results.Add('Assignments', $assignmentResult)

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
        #region resource generator code
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.Boolean]
        $AddingGameCenterFriendsBlocked,

        [Parameter()]
        [System.Boolean]
        $AirDropBlocked,

        [Parameter()]
        [System.Boolean]
        $AppleWatchBlockAutoUnlock,

        [Parameter()]
        [System.Boolean]
        $CameraBlocked,

        [Parameter()]
        [System.Boolean]
        $ClassroomAppBlockRemoteScreenObservation,

        [Parameter()]
        [System.Boolean]
        $ClassroomAppForceUnpromptedScreenObservation,

        [Parameter()]
        [System.Boolean]
        $ClassroomForceAutomaticallyJoinClasses,

        [Parameter()]
        [System.Boolean]
        $ClassroomForceRequestPermissionToLeaveClasses,

        [Parameter()]
        [System.Boolean]
        $ClassroomForceUnpromptedAppAndDeviceLock,

        [Parameter()]
        [ValidateSet('none', 'appsInListCompliant', 'appsNotInListCompliant')]
        [System.String]
        $CompliantAppListType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CompliantAppsList,

        [Parameter()]
        [System.Boolean]
        $ContentCachingBlocked,

        [Parameter()]
        [System.Boolean]
        $DefinitionLookupBlocked,

        [Parameter()]
        [System.String[]]
        $EmailInDomainSuffixes,

        [Parameter()]
        [System.Boolean]
        $EraseContentAndSettingsBlocked,

        [Parameter()]
        [System.Boolean]
        $GameCenterBlocked,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockActivityContinuation,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockAddressBook,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockBookmarks,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockCalendar,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockDocumentSync,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockMail,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockNotes,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockPhotoLibrary,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockReminders,

        [Parameter()]
        [System.Boolean]
        $ICloudDesktopAndDocumentsBlocked,

        [Parameter()]
        [System.Boolean]
        $ICloudPrivateRelayBlocked,

        [Parameter()]
        [System.Boolean]
        $ITunesBlockFileSharing,

        [Parameter()]
        [System.Boolean]
        $ITunesBlockMusicService,

        [Parameter()]
        [System.Boolean]
        $KeyboardBlockDictation,

        [Parameter()]
        [System.Boolean]
        $KeychainBlockCloudSync,

        [Parameter()]
        [System.Boolean]
        $MultiplayerGamingBlocked,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockAirDropSharing,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockAutoFill,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockFingerprintUnlock,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockModification,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockProximityRequests,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockSimple,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMaximumAttemptCount,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumCharacterSetCount,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesUntilFailedLoginReset,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Boolean]
        $PasswordRequired,

        [Parameter()]
        [ValidateSet('deviceDefault', 'alphanumeric', 'numeric')]
        [System.String]
        $PasswordRequiredType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $PrivacyAccessControls,

        [Parameter()]
        [System.Boolean]
        $SafariBlockAutofill,

        [Parameter()]
        [System.Boolean]
        $ScreenCaptureBlocked,

        [Parameter()]
        [System.Int32]
        $SoftwareUpdateMajorOSDeferredInstallDelayInDays,

        [Parameter()]
        [System.Int32]
        $SoftwareUpdateMinorOSDeferredInstallDelayInDays,

        [Parameter()]
        [System.Int32]
        $SoftwareUpdateNonOSDeferredInstallDelayInDays,

        [Parameter()]
        [System.Int32]
        $SoftwareUpdatesEnforcedDelayInDays,

        [Parameter()]
        [System.Boolean]
        $SpotlightBlockInternetResults,

        [Parameter()]
        [System.Int32]
        $TouchIdTimeoutInHours,

        [Parameter()]
        [ValidateSet('none', 'delayOSUpdateVisibility', 'delayAppUpdateVisibility', 'unknownFutureValue', 'delayMajorOsUpdateVisibility')]
        [System.String[]]
        $UpdateDelayPolicy,

        [Parameter()]
        [System.Boolean]
        $WallpaperModificationBlocked,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

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

    Write-Verbose -Message "Setting configuration of the Intune Device Configuration Policy for MacOS with Id {$Id} and DisplayName {$DisplayName}"

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

    if ($UpdateDelayPolicy.Count -gt 0)
    {
        $PSBoundParameters.UpdateDelayPolicy = $UpdateDelayPolicy -join ','
    }
    else
    {
        $PSBoundParameters.UpdateDelayPolicy = 'none'
    }

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating {$DisplayName}"
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $CreateParameters = ([Hashtable]$PSBoundParameters).Clone()
        $CreateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $CreateParameters
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters
        $CreateParameters.Remove('Id') | Out-Null
        $CreateParameters.Add('@odata.type', '#microsoft.graph.macOSGeneralDeviceConfiguration')

        #region resource generator code
        $policy = New-MgBetaDeviceManagementDeviceConfiguration -BodyParameter $CreateParameters
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments

        if ($policy.id)
        {
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $policy.id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/deviceConfigurations'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating {$DisplayName}"
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $UpdateParameters = ([Hashtable]$PSBoundParameters).Clone()
        $UpdateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $UpdateParameters
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters
        $UpdateParameters.Remove('Id') | Out-Null
        $UpdateParameters.Add('@odata.type', '#microsoft.graph.macOSGeneralDeviceConfiguration')

        #region resource generator code
        Update-MgBetaDeviceManagementDeviceConfiguration `
            -BodyParameter $UpdateParameters `
            -DeviceConfigurationId $currentInstance.Id

        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentInstance.id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/deviceConfigurations'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing {$DisplayName}"

        #region resource generator code
        Remove-MgBetaDeviceManagementDeviceConfiguration -DeviceConfigurationId $currentInstance.Id
        #endregion
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.Boolean]
        $AddingGameCenterFriendsBlocked,

        [Parameter()]
        [System.Boolean]
        $AirDropBlocked,

        [Parameter()]
        [System.Boolean]
        $AppleWatchBlockAutoUnlock,

        [Parameter()]
        [System.Boolean]
        $CameraBlocked,

        [Parameter()]
        [System.Boolean]
        $ClassroomAppBlockRemoteScreenObservation,

        [Parameter()]
        [System.Boolean]
        $ClassroomAppForceUnpromptedScreenObservation,

        [Parameter()]
        [System.Boolean]
        $ClassroomForceAutomaticallyJoinClasses,

        [Parameter()]
        [System.Boolean]
        $ClassroomForceRequestPermissionToLeaveClasses,

        [Parameter()]
        [System.Boolean]
        $ClassroomForceUnpromptedAppAndDeviceLock,

        [Parameter()]
        [ValidateSet('none', 'appsInListCompliant', 'appsNotInListCompliant')]
        [System.String]
        $CompliantAppListType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CompliantAppsList,

        [Parameter()]
        [System.Boolean]
        $ContentCachingBlocked,

        [Parameter()]
        [System.Boolean]
        $DefinitionLookupBlocked,

        [Parameter()]
        [System.String[]]
        $EmailInDomainSuffixes,

        [Parameter()]
        [System.Boolean]
        $EraseContentAndSettingsBlocked,

        [Parameter()]
        [System.Boolean]
        $GameCenterBlocked,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockActivityContinuation,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockAddressBook,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockBookmarks,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockCalendar,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockDocumentSync,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockMail,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockNotes,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockPhotoLibrary,

        [Parameter()]
        [System.Boolean]
        $ICloudBlockReminders,

        [Parameter()]
        [System.Boolean]
        $ICloudDesktopAndDocumentsBlocked,

        [Parameter()]
        [System.Boolean]
        $ICloudPrivateRelayBlocked,

        [Parameter()]
        [System.Boolean]
        $ITunesBlockFileSharing,

        [Parameter()]
        [System.Boolean]
        $ITunesBlockMusicService,

        [Parameter()]
        [System.Boolean]
        $KeyboardBlockDictation,

        [Parameter()]
        [System.Boolean]
        $KeychainBlockCloudSync,

        [Parameter()]
        [System.Boolean]
        $MultiplayerGamingBlocked,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockAirDropSharing,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockAutoFill,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockFingerprintUnlock,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockModification,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockProximityRequests,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockSimple,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMaximumAttemptCount,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumCharacterSetCount,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesUntilFailedLoginReset,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Boolean]
        $PasswordRequired,

        [Parameter()]
        [ValidateSet('deviceDefault', 'alphanumeric', 'numeric')]
        [System.String]
        $PasswordRequiredType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $PrivacyAccessControls,

        [Parameter()]
        [System.Boolean]
        $SafariBlockAutofill,

        [Parameter()]
        [System.Boolean]
        $ScreenCaptureBlocked,

        [Parameter()]
        [System.Int32]
        $SoftwareUpdateMajorOSDeferredInstallDelayInDays,

        [Parameter()]
        [System.Int32]
        $SoftwareUpdateMinorOSDeferredInstallDelayInDays,

        [Parameter()]
        [System.Int32]
        $SoftwareUpdateNonOSDeferredInstallDelayInDays,

        [Parameter()]
        [System.Int32]
        $SoftwareUpdatesEnforcedDelayInDays,

        [Parameter()]
        [System.Boolean]
        $SpotlightBlockInternetResults,

        [Parameter()]
        [System.Int32]
        $TouchIdTimeoutInHours,

        [Parameter()]
        [ValidateSet('none', 'delayOSUpdateVisibility', 'delayAppUpdateVisibility', 'unknownFutureValue', 'delayMajorOsUpdateVisibility')]
        [System.String[]]
        $UpdateDelayPolicy,

        [Parameter()]
        [System.Boolean]
        $WallpaperModificationBlocked,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

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
        [System.String]
        $Filter,

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

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

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

    try
    {
        #region resource generator code
        $baseFilter = "isof('microsoft.graph.macOSGeneralDeviceConfiguration')"
        if (-not [System.String]::IsNullOrEmpty($Filter))
        {
            $Filter = "($baseFilter) and ($Filter)"
        }
        else
        {
            $Filter = $baseFilter
        }
        [array]$getValue = Get-MgBetaDeviceManagementDeviceConfiguration -Filter $Filter -All -ErrorAction Stop
        #endregion

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        if ($getValue.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $getValue)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $($config.DisplayName)" -DeferWrite
            $params = @{
                Id                    = $config.id
                DisplayName           = $config.DisplayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params

            if ($Results.CompliantAppsList)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.CompliantAppsList -CIMInstanceName MicrosoftGraphapplistitemMacOS
                if ($complexTypeStringResult)
                {
                    $Results.CompliantAppsList = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('CompliantAppsList') | Out-Null
                }
            }
            if ($Results.PrivacyAccessControls)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.PrivacyAccessControls -CIMInstanceName MicrosoftGraphmacosprivacyaccesscontrolitem
                if ($complexTypeStringResult)
                {
                    $Results.PrivacyAccessControls = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('PrivacyAccessControls') | Out-Null
                }
            }

            if ($Results.Assignments)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.Assignments -CIMInstanceName DeviceManagementConfigurationPolicyAssignments
                if ($complexTypeStringResult)
                {
                    $Results.Assignments = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Assignments') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('CompliantAppsList', 'PrivacyAccessControls', 'Assignments')

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
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*" -or `
                $_.Exception -like '*Request not applicable to target tenant*')
        {
            Write-M365DSCHost -Message "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }
        else
        {
            New-M365DSCLogEntry -Message 'Error during Export:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential

            throw
        }
    }
}

Export-ModuleMember -Function *-TargetResource
