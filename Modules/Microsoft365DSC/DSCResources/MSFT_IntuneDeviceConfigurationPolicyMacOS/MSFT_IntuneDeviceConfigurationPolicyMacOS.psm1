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
        [System.String]
        [ValidateSet('Absent', 'Present')]
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
                $getValue = Get-MgBetaDeviceManagementDeviceConfiguration -All -Filter "DisplayName eq '$($Displayname -replace "'", "''")'" -ErrorAction SilentlyContinue | Where-Object `
                    -FilterScript { `
                        $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.macOSGeneralDeviceConfiguration' `
                }

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

        Write-Verbose -Message "Found something with id {$($getValue.Id)}"
        $results = @{

            #region resource generator code
            Id                                              = $getValue.Id
            Description                                     = $getValue.Description
            DisplayName                                     = $getValue.DisplayName
            RoleScopeTagIds                                 = $getValue.RoleScopeTagIds
            AddingGameCenterFriendsBlocked                  = $getValue.AdditionalProperties.addingGameCenterFriendsBlocked
            AirDropBlocked                                  = $getValue.AdditionalProperties.airDropBlocked
            AppleWatchBlockAutoUnlock                       = $getValue.AdditionalProperties.appleWatchBlockAutoUnlock
            CameraBlocked                                   = $getValue.AdditionalProperties.cameraBlocked
            ClassroomAppBlockRemoteScreenObservation        = $getValue.AdditionalProperties.classroomAppBlockRemoteScreenObservation
            ClassroomAppForceUnpromptedScreenObservation    = $getValue.AdditionalProperties.classroomAppForceUnpromptedScreenObservation
            ClassroomForceAutomaticallyJoinClasses          = $getValue.AdditionalProperties.classroomForceAutomaticallyJoinClasses
            ClassroomForceRequestPermissionToLeaveClasses   = $getValue.AdditionalProperties.classroomForceRequestPermissionToLeaveClasses
            ClassroomForceUnpromptedAppAndDeviceLock        = $getValue.AdditionalProperties.classroomForceUnpromptedAppAndDeviceLock
            CompliantAppListType                            = $getValue.AdditionalProperties.compliantAppListType
            ContentCachingBlocked                           = $getValue.AdditionalProperties.contentCachingBlocked
            DefinitionLookupBlocked                         = $getValue.AdditionalProperties.definitionLookupBlocked
            EmailInDomainSuffixes                           = $getValue.AdditionalProperties.emailInDomainSuffixes
            EraseContentAndSettingsBlocked                  = $getValue.AdditionalProperties.eraseContentAndSettingsBlocked
            GameCenterBlocked                               = $getValue.AdditionalProperties.gameCenterBlocked
            ICloudBlockActivityContinuation                 = $getValue.AdditionalProperties.iCloudBlockActivityContinuation
            ICloudBlockAddressBook                          = $getValue.AdditionalProperties.iCloudBlockAddressBook
            ICloudBlockBookmarks                            = $getValue.AdditionalProperties.iCloudBlockBookmarks
            ICloudBlockCalendar                             = $getValue.AdditionalProperties.iCloudBlockCalendar
            ICloudBlockDocumentSync                         = $getValue.AdditionalProperties.iCloudBlockDocumentSync
            ICloudBlockMail                                 = $getValue.AdditionalProperties.iCloudBlockMail
            ICloudBlockNotes                                = $getValue.AdditionalProperties.iCloudBlockNotes
            ICloudBlockPhotoLibrary                         = $getValue.AdditionalProperties.iCloudBlockPhotoLibrary
            ICloudBlockReminders                            = $getValue.AdditionalProperties.iCloudBlockReminders
            ICloudDesktopAndDocumentsBlocked                = $getValue.AdditionalProperties.iCloudDesktopAndDocumentsBlocked
            ICloudPrivateRelayBlocked                       = $getValue.AdditionalProperties.iCloudPrivateRelayBlocked
            ITunesBlockFileSharing                          = $getValue.AdditionalProperties.iTunesBlockFileSharing
            ITunesBlockMusicService                         = $getValue.AdditionalProperties.iTunesBlockMusicService
            KeyboardBlockDictation                          = $getValue.AdditionalProperties.keyboardBlockDictation
            KeychainBlockCloudSync                          = $getValue.AdditionalProperties.keychainBlockCloudSync
            MultiplayerGamingBlocked                        = $getValue.AdditionalProperties.multiplayerGamingBlocked
            PasswordBlockAirDropSharing                     = $getValue.AdditionalProperties.passwordBlockAirDropSharing
            PasswordBlockAutoFill                           = $getValue.AdditionalProperties.passwordBlockAutoFill
            PasswordBlockFingerprintUnlock                  = $getValue.AdditionalProperties.passwordBlockFingerprintUnlock
            PasswordBlockModification                       = $getValue.AdditionalProperties.passwordBlockModification
            PasswordBlockProximityRequests                  = $getValue.AdditionalProperties.passwordBlockProximityRequests
            PasswordBlockSimple                             = $getValue.AdditionalProperties.passwordBlockSimple
            PasswordExpirationDays                          = $getValue.AdditionalProperties.passwordExpirationDays
            PasswordMaximumAttemptCount                     = $getValue.AdditionalProperties.passwordMaximumAttemptCount
            PasswordMinimumCharacterSetCount                = $getValue.AdditionalProperties.passwordMinimumCharacterSetCount
            PasswordMinimumLength                           = $getValue.AdditionalProperties.passwordMinimumLength
            PasswordMinutesOfInactivityBeforeLock           = $getValue.AdditionalProperties.passwordMinutesOfInactivityBeforeLock
            PasswordMinutesOfInactivityBeforeScreenTimeout  = $getValue.AdditionalProperties.passwordMinutesOfInactivityBeforeScreenTimeout
            PasswordMinutesUntilFailedLoginReset            = $getValue.AdditionalProperties.passwordMinutesUntilFailedLoginReset
            PasswordPreviousPasswordBlockCount              = $getValue.AdditionalProperties.passwordPreviousPasswordBlockCount
            PasswordRequired                                = $getValue.AdditionalProperties.passwordRequired
            PasswordRequiredType                            = $getValue.AdditionalProperties.passwordRequiredType
            SafariBlockAutofill                             = $getValue.AdditionalProperties.safariBlockAutofill
            ScreenCaptureBlocked                            = $getValue.AdditionalProperties.screenCaptureBlocked
            SoftwareUpdateMajorOSDeferredInstallDelayInDays = $getValue.AdditionalProperties.softwareUpdateMajorOSDeferredInstallDelayInDays
            SoftwareUpdateMinorOSDeferredInstallDelayInDays = $getValue.AdditionalProperties.softwareUpdateMinorOSDeferredInstallDelayInDays
            SoftwareUpdateNonOSDeferredInstallDelayInDays   = $getValue.AdditionalProperties.softwareUpdateNonOSDeferredInstallDelayInDays
            SoftwareUpdatesEnforcedDelayInDays              = $getValue.AdditionalProperties.softwareUpdatesEnforcedDelayInDays
            SpotlightBlockInternetResults                   = $getValue.AdditionalProperties.spotlightBlockInternetResults
            TouchIdTimeoutInHours                           = $getValue.AdditionalProperties.touchIdTimeoutInHours
            UpdateDelayPolicy                               = $getValue.AdditionalProperties.updateDelayPolicy -split ','
            WallpaperModificationBlocked                    = $getValue.AdditionalProperties.wallpaperModificationBlocked
            Ensure                                          = 'Present'
            Credential                                      = $Credential
            ApplicationId                                   = $ApplicationId
            TenantId                                        = $TenantId
            ApplicationSecret                               = $ApplicationSecret
            CertificateThumbprint                           = $CertificateThumbprint
            ManagedIdentity                                 = $ManagedIdentity.IsPresent
            AccessTokens                                    = $AccessTokens
        }
        if ($getValue.additionalProperties.compliantAppsList)
        {
            $results.Add('CompliantAppsList', $getValue.additionalProperties.compliantAppsList)
        }
        if ($getValue.additionalProperties.privacyAccessControls)
        {
            $results.Add('PrivacyAccessControls', $getValue.additionalProperties.privacyAccessControls)
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
        [System.String]
        [ValidateSet('Absent', 'Present')]
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

        foreach ($key in ($CreateParameters.Clone()).Keys)
        {
            if ($CreateParameters[$key].GetType().Fullname -like '*CimInstance*')
            {
                $CreateParameters[$key] = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters[$key]
            }
        }

        <#if ($AdditionalProperties)
        {
            $CreateParameters.Add('AdditionalProperties', $AdditionalProperties)
        }#>
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

        foreach ($key in ($UpdateParameters.Clone()).Keys)
        {
            if ($UpdateParameters[$key].GetType().Fullname -like '*CimInstance*')
            {
                $UpdateParameters[$key] = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters[$key]
            }
        }

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
        [System.String]
        [ValidateSet('Absent', 'Present')]
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
        [array]$getValue = Get-MgBetaDeviceManagementDeviceConfiguration -Filter $Filter -All `
            -ErrorAction Stop | Where-Object `
            -FilterScript { `
                $_.AdditionalProperties.'@odata.type' -like '#microsoft.graph.macOS*'  `
        }
        #endregion

        $i = 1
        $dscContent = ''
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

            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent
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
