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
        $ManagedIdentity
    )

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters
    }
    catch
    {
        Write-Verbose -Message 'Connection to the workload failed.'
    }

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
    try
    {
        try
        {
            $getValue = Get-MgBetaDeviceManagementDeviceConfiguration -DeviceConfigurationId $id -ErrorAction Stop
        }
        catch
        {
            $getValue = $null
        }

        #region resource generator code
        if ($null -eq $getValue)
        {
            $getValue = Get-MgBetaDeviceManagementDeviceConfiguration -Filter "DisplayName eq '$Displayname'" -ErrorAction SilentlyContinue | Where-Object `
            -FilterScript { `
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.macOSGeneralDeviceConfiguration' `
            }

        }
        #endregion

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Nothing with id {$id} was found"
            return $nullResult
        }

        Write-Verbose -Message "Found something with id {$($getValue.id)}"
        $results = @{

            #region resource generator code
            Id                                              = $getValue.Id
            Description                                     = $getValue.Description
            DisplayName                                     = $getValue.DisplayName
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
            Managedidentity                                 = $ManagedIdentity.IsPresent
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
        foreach ($assignmentEntry in $AssignmentsValues)
        {
            $assignmentValue = @{
                dataType = $assignmentEntry.Target.AdditionalProperties.'@odata.type'
                deviceAndAppManagementAssignmentFilterType = $(if ($null -ne $assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterType)
                    {$assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterType.ToString()})
                deviceAndAppManagementAssignmentFilterId = $assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterId
                groupId = $assignmentEntry.Target.AdditionalProperties.groupId
            }
            $assignmentResult += $assignmentValue
        }
        $results.Add('Assignments', $assignmentResult)

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
        $ManagedIdentity
    )

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters
    }
    catch
    {
        Write-Verbose -Message $_
    }

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

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating {$DisplayName}"
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $CreateParameters = ([Hashtable]$PSBoundParameters).clone()
        $CreateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $CreateParameters
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters

        <#$AdditionalProperties = Get-M365DSCAdditionalProperties -Properties ($CreateParameters)
        foreach ($key in $AdditionalProperties.keys)
        {
            if ($key -ne '@odata.type')
            {
                $keyName = $key.substring(0, 1).ToUpper() + $key.substring(1, $key.length - 1)
                $CreateParameters.remove($keyName)
            }
        }#>

        $CreateParameters.Remove('Id') | Out-Null

        foreach ($key in ($CreateParameters.clone()).Keys)
        {
            if ($CreateParameters[$key].getType().Fullname -like '*CimInstance*')
            {
                $CreateParameters[$key] = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters[$key]
            }
        }

        <#if ($AdditionalProperties)
        {
            $CreateParameters.add('AdditionalProperties', $AdditionalProperties)
        }#>
        $CreateParameters.add('@odata.type','#microsoft.graph.macOSGeneralDeviceConfiguration')
        #region resource generator code
        $policy = New-MgBetaDeviceManagementDeviceConfiguration -BodyParameter $CreateParameters
        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }

        if ($policy.id)
        {
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId  $policy.id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/deviceConfigurations'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating {$DisplayName}"
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $UpdateParameters = ([Hashtable]$PSBoundParameters).clone()
        $UpdateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $UpdateParameters
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters

        <#$AdditionalProperties = Get-M365DSCAdditionalProperties -Properties ($UpdateParameters)
        foreach ($key in $AdditionalProperties.keys)
        {
            if ($key -ne '@odata.type')
            {
                $keyName = $key.substring(0, 1).ToUpper() + $key.substring(1, $key.length - 1)
                $UpdateParameters.remove($keyName)
            }
        }#>

        $UpdateParameters.Remove('Id') | Out-Null

        foreach ($key in ($UpdateParameters.clone()).Keys)
        {
            if ($UpdateParameters[$key].getType().Fullname -like '*CimInstance*')
            {
                $UpdateParameters[$key] = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters[$key]
            }
        }

        <#if ($AdditionalProperties)
        {
            $UpdateParameters.add('AdditionalProperties', $AdditionalProperties)
        }#>
        $UpdateParameters.add('@odata.type','#microsoft.graph.macOSGeneralDeviceConfiguration')
        #$UpdateParameters.remove('emailInDomainSuffixes')
        #$UpdateParameters.remove('updateDelayPolicy')

        #region resource generator code
        write-verbose ($UpdateParameters | convertTo-Json -depth 100)

        Update-MgBetaDeviceManagementDeviceConfiguration `
            -BodyParameter $UpdateParameters `
            -DeviceConfigurationId $currentInstance.Id

        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }
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
        $ManagedIdentity
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

    Write-Verbose -Message "Testing configuration of {$id}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()
    $ValuesToCheck = Remove-M365DSCAuthenticationParameter -BoundParameters $ValuesToCheck
    $ValuesToCheck.Remove('Id') | Out-Null

    if ($CurrentValues.Ensure -ne $Ensure)
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }
    $testResult = $true

    #Compare Cim instances
    foreach ($key in $PSBoundParameters.Keys)
    {
        $source = $PSBoundParameters.$key
        $target = $CurrentValues.$key
        if ($source.getType().Name -like '*CimInstance*')
        {
            $source = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $source

            $testResult = Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target)

            if (-Not $testResult)
            {
                $testResult = $false
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    #Convert any DateTime to String
    foreach ($key in $ValuesToCheck.Keys)
    {
        if (($null -ne $CurrentValues[$key]) `
                -and ($CurrentValues[$key].getType().Name -eq 'DateTime'))
        {
            $CurrentValues[$key] = $CurrentValues[$key].toString()
        }
    }

    if ($testResult)
    {
        $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
            -Source $($MyInvocation.MyCommand.Source) `
            -DesiredValues $PSBoundParameters `
            -ValuesToCheck $ValuesToCheck.Keys
    }

    Write-Verbose -Message "Test-TargetResource returned $testResult"

    return $testResult
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
        $ManagedIdentity
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
                $_.AdditionalProperties.'@odata.type' -like "#microsoft.graph.macOS*"  `
        }
        #endregion

        $i = 1
        $dscContent = ''
        if ($getValue.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $getValue)
        {
            Write-Host "    |---[$i/$($getValue.Count)] $($config.DisplayName)" -NoNewline
            $params = @{
                Id                    = $config.id
                DisplayName           = $config.DisplayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity       = $ManagedIdentity.IsPresent
            }

            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results

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
                -Credential $Credential

            if ($Results.CompliantAppsList)
            {
                $isCIMArray = $false
                if ($Results.CompliantAppsList.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'CompliantAppsList' -IsCIMArray:$isCIMArray
            }
            if ($Results.PrivacyAccessControls)
            {
                $isCIMArray = $false
                if ($Results.PrivacyAccessControls.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'PrivacyAccessControls' -IsCIMArray:$isCIMArray
            }

            if ($Results.Assignments)
            {
                $isCIMArray = $false
                if ($Results.Assignments.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Assignments' -IsCIMArray:$isCIMArray
            }

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
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*" -or `
        $_.Exception -like "*Request not applicable to target tenant*")
        {
            Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }
        else
        {
            Write-Host $Global:M365DSCEmojiRedX

            New-M365DSCLogEntry -Message 'Error during Export:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential
        }

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
