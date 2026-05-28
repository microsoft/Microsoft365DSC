Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneWindowsUpdateForBusinessRingUpdateProfileWindows10'

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
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.Boolean]
        $AllowWindows11Upgrade,

        [Parameter()]
        [ValidateSet('userDefined', 'notifyDownload', 'autoInstallAtMaintenanceTime', 'autoInstallAndRebootAtMaintenanceTime', 'autoInstallAndRebootAtScheduledTime', 'autoInstallAndRebootWithoutEndUserControl', 'windowsDefault')]
        [System.String]
        $AutomaticUpdateMode,

        [Parameter()]
        [ValidateSet('notConfigured', 'automatic', 'user', 'unknownFutureValue')]
        [System.String]
        $AutoRestartNotificationDismissal,

        [Parameter()]
        [ValidateSet('userDefined', 'all', 'businessReadyOnly', 'windowsInsiderBuildFast', 'windowsInsiderBuildSlow', 'windowsInsiderBuildRelease')]
        [System.String]
        $BusinessReadyUpdatesOnly,

        [Parameter()]
        [System.Int32]
        $DeadlineForFeatureUpdatesInDays,

        [Parameter()]
        [System.Int32]
        $DeadlineForQualityUpdatesInDays,

        [Parameter()]
        [System.Int32]
        $DeadlineGracePeriodInDays,

        [Parameter()]
        [ValidateSet('userDefined', 'httpOnly', 'httpWithPeeringNat', 'httpWithPeeringPrivateGroup', 'httpWithInternetPeering', 'simpleDownload', 'bypassMode')]
        [System.String]
        $DeliveryOptimizationMode,

        [Parameter()]
        [System.Boolean]
        $DriversExcluded,

        [Parameter()]
        [System.Int32]
        $EngagedRestartDeadlineInDays,

        [Parameter()]
        [System.Int32]
        $EngagedRestartSnoozeScheduleInDays,

        [Parameter()]
        [System.Int32]
        $EngagedRestartTransitionScheduleInDays,

        [Parameter()]
        [System.Int32]
        $FeatureUpdatesDeferralPeriodInDays,

        [Parameter()]
        [System.Boolean]
        $FeatureUpdatesPaused,

        [Parameter()]
        [System.String]
        $FeatureUpdatesPauseExpiryDateTime,

        [Parameter()]
        [System.String]
        $FeatureUpdatesPauseStartDate,

        [Parameter()]
        [System.String]
        $FeatureUpdatesRollbackStartDateTime,

        [Parameter()]
        [System.Int32]
        $FeatureUpdatesRollbackWindowInDays,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $InstallationSchedule,

        [Parameter()]
        [System.Boolean]
        $MicrosoftUpdateServiceAllowed,

        [Parameter()]
        [System.Boolean]
        $PostponeRebootUntilAfterDeadline,

        [Parameter()]
        [ValidateSet('userDefined', 'settingsOnly', 'settingsAndExperimentations', 'notAllowed')]
        [System.String]
        $PrereleaseFeatures,

        [Parameter()]
        [System.Int32]
        $QualityUpdatesDeferralPeriodInDays,

        [Parameter()]
        [System.Boolean]
        $QualityUpdatesPaused,

        [Parameter()]
        [System.String]
        $QualityUpdatesPauseExpiryDateTime,

        [Parameter()]
        [System.String]
        $QualityUpdatesPauseStartDate,

        [Parameter()]
        [System.String]
        $QualityUpdatesRollbackStartDateTime,

        [Parameter()]
        [System.Int32]
        $ScheduleImminentRestartWarningInMinutes,

        [Parameter()]
        [System.Int32]
        $ScheduleRestartWarningInHours,

        [Parameter()]
        [System.Boolean]
        $SkipChecksBeforeRestart,

        [Parameter()]
        [ValidateSet('notConfigured', 'defaultNotifications', 'restartWarningsOnly', 'disableAllNotifications', 'unknownFutureValue')]
        [System.String]
        $UpdateNotificationLevel,

        [Parameter()]
        [ValidateSet('userDefined', 'firstWeek', 'secondWeek', 'thirdWeek', 'fourthWeek', 'everyWeek', 'unknownFutureValue')]
        [System.String]
        $UpdateWeeks,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $UserPauseAccess,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $UserWindowsUpdateScanAccess,

        [Parameter()]
        [System.String]
        $Description,

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

    Write-Verbose -Message "Getting configuration of the Intune Window Update For Business Ring Update Profile for Windows10 with Id {$Id} and DisplayName {$DisplayName}"

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
            #region resource generator code
            if (-not [string]::IsNullOrEmpty($Id))
            {
                $getValue = Get-MgBetaDeviceManagementDeviceConfiguration -All -Filter "Id eq '$Id'" -ErrorAction SilentlyContinue
            }

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Window Update For Business Ring Update Profile for Windows10 with Id {$Id}"

                if (-not [string]::IsNullOrEmpty($DisplayName))
                {
                    $getValue = Get-MgBetaDeviceManagementDeviceConfiguration `
                        -All `
                        -Filter "DisplayName eq '$($DisplayName -replace "'", "''")'" `
                        -ErrorAction SilentlyContinue
                }
            }
            #endregion
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Window Update For Business Ring Update Profile for Windows10 with DisplayName {$DisplayName}"
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Window Update For Business Ring Update Profile for Windows10 with Id {$Id} and DisplayName {$DisplayName} was found."

        #region resource generator code
        $complexInstallationSchedule = [ordered]@{}
        if ($null -ne $getValue.installationSchedule.activeHoursEnd)
        {
            $complexInstallationSchedule.Add('ActiveHoursEnd', ([TimeSpan]$getValue.installationSchedule.activeHoursEnd).ToString())
        }
        if ($null -ne $getValue.installationSchedule.activeHoursStart)
        {
            $complexInstallationSchedule.Add('ActiveHoursStart', ([TimeSpan]$getValue.installationSchedule.activeHoursStart).ToString())
        }
        if ($null -ne $getValue.installationSchedule.scheduledInstallDay)
        {
            $complexInstallationSchedule.Add('ScheduledInstallDay', $getValue.installationSchedule.scheduledInstallDay.ToString())
        }
        if ($null -ne $getValue.installationSchedule.scheduledInstallTime)
        {
            $complexInstallationSchedule.Add('ScheduledInstallTime', ([TimeSpan]$getValue.installationSchedule.scheduledInstallTime).ToString())
        }
        if ($null -ne $getValue.installationSchedule.'@odata.type')
        {
            $complexInstallationSchedule.Add('odataType', $getValue.installationSchedule.'@odata.type'.ToString())
        }
        if ($complexInstallationSchedule.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexInstallationSchedule = $null
        }
        #endregion

        #region resource generator code
        $enumAutomaticUpdateMode = $null
        if ($null -ne $getValue.automaticUpdateMode)
        {
            $enumAutomaticUpdateMode = $getValue.automaticUpdateMode.ToString()
        }

        $enumAutoRestartNotificationDismissal = $null
        if ($null -ne $getValue.autoRestartNotificationDismissal)
        {
            $enumAutoRestartNotificationDismissal = $getValue.autoRestartNotificationDismissal.ToString()
        }

        $enumBusinessReadyUpdatesOnly = $null
        if ($null -ne $getValue.businessReadyUpdatesOnly)
        {
            $enumBusinessReadyUpdatesOnly = $getValue.businessReadyUpdatesOnly.ToString()
        }

        $enumDeliveryOptimizationMode = $null
        if ($null -ne $getValue.deliveryOptimizationMode)
        {
            $enumDeliveryOptimizationMode = $getValue.deliveryOptimizationMode.ToString()
        }

        $enumPrereleaseFeatures = $null
        if ($null -ne $getValue.prereleaseFeatures)
        {
            $enumPrereleaseFeatures = $getValue.prereleaseFeatures.ToString()
        }

        $enumUpdateNotificationLevel = $null
        if ($null -ne $getValue.updateNotificationLevel)
        {
            $enumUpdateNotificationLevel = $getValue.updateNotificationLevel.ToString()
        }

        $enumUpdateWeeks = $null
        if ($null -ne $getValue.updateWeeks)
        {
            $enumUpdateWeeks = $getValue.updateWeeks.ToString()
        }

        $enumUserPauseAccess = $null
        if ($null -ne $getValue.userPauseAccess)
        {
            $enumUserPauseAccess = $getValue.userPauseAccess.ToString()
        }

        $enumUserWindowsUpdateScanAccess = $null
        if ($null -ne $getValue.userWindowsUpdateScanAccess)
        {
            $enumUserWindowsUpdateScanAccess = $getValue.userWindowsUpdateScanAccess.ToString()
        }
        #endregion

        #region resource generator code
        $dateFeatureUpdatesPauseExpiryDateTime = $null
        if ($null -ne $getValue.featureUpdatesPauseExpiryDateTime)
        {
            $dateFeatureUpdatesPauseExpiryDateTime = ([DateTimeOffset]$getValue.featureUpdatesPauseExpiryDateTime).ToString('o')
        }

        $dateFeatureUpdatesPauseStartDate = $null
        if ($null -ne $getValue.featureUpdatesPauseStartDate)
        {
            $dateFeatureUpdatesPauseStartDate = ([DateTime]$getValue.featureUpdatesPauseStartDate).ToString('o')
        }

        $dateFeatureUpdatesRollbackStartDateTime = $null
        if ($null -ne $getValue.featureUpdatesRollbackStartDateTime)
        {
            $dateFeatureUpdatesRollbackStartDateTime = ([DateTimeOffset]$getValue.featureUpdatesRollbackStartDateTime).ToString('o')
        }

        $dateQualityUpdatesPauseExpiryDateTime = $null
        if ($null -ne $getValue.qualityUpdatesPauseExpiryDateTime)
        {
            $dateQualityUpdatesPauseExpiryDateTime = ([DateTimeOffset]$getValue.qualityUpdatesPauseExpiryDateTime).ToString('o')
        }

        $dateQualityUpdatesPauseStartDate = $null
        if ($null -ne $getValue.qualityUpdatesPauseStartDate)
        {
            $dateQualityUpdatesPauseStartDate = ([DateTime]$getValue.qualityUpdatesPauseStartDate).ToString('o')
        }

        $dateQualityUpdatesRollbackStartDateTime = $null
        if ($null -ne $getValue.qualityUpdatesRollbackStartDateTime)
        {
            $dateQualityUpdatesRollbackStartDateTime = ([DateTimeOffset]$getValue.qualityUpdatesRollbackStartDateTime).ToString('o')
        }
        #endregion

        $results = @{
            #region resource generator code
            AllowWindows11Upgrade                   = $getValue.allowWindows11Upgrade
            AutomaticUpdateMode                     = $enumAutomaticUpdateMode
            AutoRestartNotificationDismissal        = $enumAutoRestartNotificationDismissal
            BusinessReadyUpdatesOnly                = $enumBusinessReadyUpdatesOnly
            DeadlineForFeatureUpdatesInDays         = $getValue.deadlineForFeatureUpdatesInDays
            DeadlineForQualityUpdatesInDays         = $getValue.deadlineForQualityUpdatesInDays
            DeadlineGracePeriodInDays               = $getValue.deadlineGracePeriodInDays
            DeliveryOptimizationMode                = $enumDeliveryOptimizationMode
            DriversExcluded                         = $getValue.driversExcluded
            EngagedRestartDeadlineInDays            = $getValue.engagedRestartDeadlineInDays
            EngagedRestartSnoozeScheduleInDays      = $getValue.engagedRestartSnoozeScheduleInDays
            EngagedRestartTransitionScheduleInDays  = $getValue.engagedRestartTransitionScheduleInDays
            FeatureUpdatesDeferralPeriodInDays      = $getValue.featureUpdatesDeferralPeriodInDays
            FeatureUpdatesPaused                    = $getValue.featureUpdatesPaused
            FeatureUpdatesPauseExpiryDateTime       = $dateFeatureUpdatesPauseExpiryDateTime
            FeatureUpdatesPauseStartDate            = $dateFeatureUpdatesPauseStartDate
            FeatureUpdatesRollbackStartDateTime     = $dateFeatureUpdatesRollbackStartDateTime
            FeatureUpdatesRollbackWindowInDays      = $getValue.featureUpdatesRollbackWindowInDays
            InstallationSchedule                    = $complexInstallationSchedule
            MicrosoftUpdateServiceAllowed           = $getValue.microsoftUpdateServiceAllowed
            PostponeRebootUntilAfterDeadline        = $getValue.postponeRebootUntilAfterDeadline
            PrereleaseFeatures                      = $enumPrereleaseFeatures
            QualityUpdatesDeferralPeriodInDays      = $getValue.qualityUpdatesDeferralPeriodInDays
            QualityUpdatesPaused                    = $getValue.qualityUpdatesPaused
            QualityUpdatesPauseExpiryDateTime       = $dateQualityUpdatesPauseExpiryDateTime
            QualityUpdatesPauseStartDate            = $dateQualityUpdatesPauseStartDate
            QualityUpdatesRollbackStartDateTime     = $dateQualityUpdatesRollbackStartDateTime
            ScheduleImminentRestartWarningInMinutes = $getValue.scheduleImminentRestartWarningInMinutes
            ScheduleRestartWarningInHours           = $getValue.scheduleRestartWarningInHours
            SkipChecksBeforeRestart                 = $getValue.skipChecksBeforeRestart
            UpdateNotificationLevel                 = $enumUpdateNotificationLevel
            UpdateWeeks                             = $enumUpdateWeeks
            UserPauseAccess                         = $enumUserPauseAccess
            UserWindowsUpdateScanAccess             = $enumUserWindowsUpdateScanAccess
            Description                             = $getValue.Description
            DisplayName                             = $getValue.DisplayName
            Id                                      = $getValue.Id
            RoleScopeTagIds                         = $getValue.RoleScopeTagIds
            Ensure                                  = 'Present'
            Credential                              = $Credential
            ApplicationId                           = $ApplicationId
            TenantId                                = $TenantId
            ApplicationSecret                       = $ApplicationSecret
            CertificateThumbprint                   = $CertificateThumbprint
            CertificatePath                         = $CertificatePath
            CertificatePassword                     = $CertificatePassword
            ManagedIdentity                         = $ManagedIdentity.IsPresent
            AccessTokens                            = $AccessTokens
            #endregion
        }

        $rawAssignments = @()
        $rawAssignments = Get-MgBetaDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId $Id -All
        $assignmentResult = @()
        if ($null -ne $rawAssignments -and $rawAssignments.Count -gt 0)
        {
            $assignmentResult += ConvertFrom-IntunePolicyAssignment -Assignments $rawAssignments
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
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.Boolean]
        $AllowWindows11Upgrade,

        [Parameter()]
        [ValidateSet('userDefined', 'notifyDownload', 'autoInstallAtMaintenanceTime', 'autoInstallAndRebootAtMaintenanceTime', 'autoInstallAndRebootAtScheduledTime', 'autoInstallAndRebootWithoutEndUserControl', 'windowsDefault')]
        [System.String]
        $AutomaticUpdateMode,

        [Parameter()]
        [ValidateSet('notConfigured', 'automatic', 'user', 'unknownFutureValue')]
        [System.String]
        $AutoRestartNotificationDismissal,

        [Parameter()]
        [ValidateSet('userDefined', 'all', 'businessReadyOnly', 'windowsInsiderBuildFast', 'windowsInsiderBuildSlow', 'windowsInsiderBuildRelease')]
        [System.String]
        $BusinessReadyUpdatesOnly,

        [Parameter()]
        [System.Int32]
        $DeadlineForFeatureUpdatesInDays,

        [Parameter()]
        [System.Int32]
        $DeadlineForQualityUpdatesInDays,

        [Parameter()]
        [System.Int32]
        $DeadlineGracePeriodInDays,

        [Parameter()]
        [ValidateSet('userDefined', 'httpOnly', 'httpWithPeeringNat', 'httpWithPeeringPrivateGroup', 'httpWithInternetPeering', 'simpleDownload', 'bypassMode')]
        [System.String]
        $DeliveryOptimizationMode,

        [Parameter()]
        [System.Boolean]
        $DriversExcluded,

        [Parameter()]
        [System.Int32]
        $EngagedRestartDeadlineInDays,

        [Parameter()]
        [System.Int32]
        $EngagedRestartSnoozeScheduleInDays,

        [Parameter()]
        [System.Int32]
        $EngagedRestartTransitionScheduleInDays,

        [Parameter()]
        [System.Int32]
        $FeatureUpdatesDeferralPeriodInDays,

        [Parameter()]
        [System.Boolean]
        $FeatureUpdatesPaused,

        [Parameter()]
        [System.String]
        $FeatureUpdatesPauseExpiryDateTime,

        [Parameter()]
        [System.String]
        $FeatureUpdatesPauseStartDate,

        [Parameter()]
        [System.String]
        $FeatureUpdatesRollbackStartDateTime,

        [Parameter()]
        [System.Int32]
        $FeatureUpdatesRollbackWindowInDays,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $InstallationSchedule,

        [Parameter()]
        [System.Boolean]
        $MicrosoftUpdateServiceAllowed,

        [Parameter()]
        [System.Boolean]
        $PostponeRebootUntilAfterDeadline,

        [Parameter()]
        [ValidateSet('userDefined', 'settingsOnly', 'settingsAndExperimentations', 'notAllowed')]
        [System.String]
        $PrereleaseFeatures,

        [Parameter()]
        [System.Int32]
        $QualityUpdatesDeferralPeriodInDays,

        [Parameter()]
        [System.Boolean]
        $QualityUpdatesPaused,

        [Parameter()]
        [System.String]
        $QualityUpdatesPauseExpiryDateTime,

        [Parameter()]
        [System.String]
        $QualityUpdatesPauseStartDate,

        [Parameter()]
        [System.String]
        $QualityUpdatesRollbackStartDateTime,

        [Parameter()]
        [System.Int32]
        $ScheduleImminentRestartWarningInMinutes,

        [Parameter()]
        [System.Int32]
        $ScheduleRestartWarningInHours,

        [Parameter()]
        [System.Boolean]
        $SkipChecksBeforeRestart,

        [Parameter()]
        [ValidateSet('notConfigured', 'defaultNotifications', 'restartWarningsOnly', 'disableAllNotifications', 'unknownFutureValue')]
        [System.String]
        $UpdateNotificationLevel,

        [Parameter()]
        [ValidateSet('userDefined', 'firstWeek', 'secondWeek', 'thirdWeek', 'fourthWeek', 'everyWeek', 'unknownFutureValue')]
        [System.String]
        $UpdateWeeks,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $UserPauseAccess,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $UserWindowsUpdateScanAccess,

        [Parameter()]
        [System.String]
        $Description,

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
    $boundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Window Update For Business Ring Update Profile for Windows10 with DisplayName {$DisplayName}"
        $boundParameters.Remove('Assignments') | Out-Null
        $createParameters = Rename-M365DSCCimInstanceParameter -Properties $boundParameters
        $createParameters.Remove('Id') | Out-Null

        #region resource generator code
        $createParameters.Add('@odata.type', '#microsoft.graph.windowsUpdateForBusinessConfiguration')
        $policy = New-MgBetaDeviceManagementDeviceConfiguration -BodyParameter $createParameters
        #endregion
        #region new Intune assignment management
        $intuneAssignments = @()
        if ($null -ne $Assignments -and $Assignments.Count -gt 0)
        {
            $intuneAssignments += ConvertTo-IntunePolicyAssignment -Assignments $Assignments
        }
        foreach ($assignment in $intuneAssignments)
        {
            New-MgBetaDeviceManagementDeviceConfigurationAssignment `
                -DeviceConfigurationId $policy.id `
                -BodyParameter $assignment
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Window Update For Business Ring Update Profile for Windows10 with Id {$($currentInstance.Id)}"
        $boundParameters.Remove('Assignments') | Out-Null
        $updateParameters = Rename-M365DSCCimInstanceParameter -Properties $boundParameters
        $updateParameters.Remove('Id') | Out-Null

        #region resource generator code
        $updateParameters.Add('@odata.type', '#microsoft.graph.windowsUpdateForBusinessConfiguration')
        Update-MgBetaDeviceManagementDeviceConfiguration `
            -DeviceConfigurationId $currentInstance.id `
            -BodyParameter $updateParameters
        #endregion
        #region new Intune assignment management
        $currentAssignments = @()
        $currentAssignments += Get-MgBetaDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId $currentInstance.id

        $intuneAssignments = @()
        if ($null -ne $Assignments -and $Assignments.Count -gt 0)
        {
            $intuneAssignments += ConvertTo-IntunePolicyAssignment -Assignments $Assignments
        }
        foreach ($assignment in $intuneAssignments)
        {
            if ( $null -eq ($currentAssignments | Where-Object { $_.Target.groupId -eq $assignment.Target.groupId -and $_.Target.'@odata.type' -eq $assignment.Target.'@odata.type' }))
            {
                New-MgBetaDeviceManagementDeviceConfigurationAssignment `
                    -DeviceConfigurationId $currentInstance.id `
                    -BodyParameter $assignment
            }
            else
            {
                $currentAssignments = $currentAssignments | Where-Object { -not($_.Target.groupId -eq $assignment.Target.groupId -and $_.Target.'@odata.type' -eq $assignment.Target.'@odata.type') }
            }
        }
        if ($currentAssignments.Count -gt 0)
        {
            foreach ($assignment in $currentAssignments)
            {
                Remove-MgBetaDeviceManagementDeviceConfigurationAssignment `
                    -DeviceConfigurationId $currentInstance.Id `
                    -DeviceConfigurationAssignmentId $assignment.Id
            }
        }
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Window Update For Business Ring Update Profile for Windows10 with Id {$($currentInstance.Id)}"
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
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.Boolean]
        $AllowWindows11Upgrade,

        [Parameter()]
        [ValidateSet('userDefined', 'notifyDownload', 'autoInstallAtMaintenanceTime', 'autoInstallAndRebootAtMaintenanceTime', 'autoInstallAndRebootAtScheduledTime', 'autoInstallAndRebootWithoutEndUserControl', 'windowsDefault')]
        [System.String]
        $AutomaticUpdateMode,

        [Parameter()]
        [ValidateSet('notConfigured', 'automatic', 'user', 'unknownFutureValue')]
        [System.String]
        $AutoRestartNotificationDismissal,

        [Parameter()]
        [ValidateSet('userDefined', 'all', 'businessReadyOnly', 'windowsInsiderBuildFast', 'windowsInsiderBuildSlow', 'windowsInsiderBuildRelease')]
        [System.String]
        $BusinessReadyUpdatesOnly,

        [Parameter()]
        [System.Int32]
        $DeadlineForFeatureUpdatesInDays,

        [Parameter()]
        [System.Int32]
        $DeadlineForQualityUpdatesInDays,

        [Parameter()]
        [System.Int32]
        $DeadlineGracePeriodInDays,

        [Parameter()]
        [ValidateSet('userDefined', 'httpOnly', 'httpWithPeeringNat', 'httpWithPeeringPrivateGroup', 'httpWithInternetPeering', 'simpleDownload', 'bypassMode')]
        [System.String]
        $DeliveryOptimizationMode,

        [Parameter()]
        [System.Boolean]
        $DriversExcluded,

        [Parameter()]
        [System.Int32]
        $EngagedRestartDeadlineInDays,

        [Parameter()]
        [System.Int32]
        $EngagedRestartSnoozeScheduleInDays,

        [Parameter()]
        [System.Int32]
        $EngagedRestartTransitionScheduleInDays,

        [Parameter()]
        [System.Int32]
        $FeatureUpdatesDeferralPeriodInDays,

        [Parameter()]
        [System.Boolean]
        $FeatureUpdatesPaused,

        [Parameter()]
        [System.String]
        $FeatureUpdatesPauseExpiryDateTime,

        [Parameter()]
        [System.String]
        $FeatureUpdatesPauseStartDate,

        [Parameter()]
        [System.String]
        $FeatureUpdatesRollbackStartDateTime,

        [Parameter()]
        [System.Int32]
        $FeatureUpdatesRollbackWindowInDays,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $InstallationSchedule,

        [Parameter()]
        [System.Boolean]
        $MicrosoftUpdateServiceAllowed,

        [Parameter()]
        [System.Boolean]
        $PostponeRebootUntilAfterDeadline,

        [Parameter()]
        [ValidateSet('userDefined', 'settingsOnly', 'settingsAndExperimentations', 'notAllowed')]
        [System.String]
        $PrereleaseFeatures,

        [Parameter()]
        [System.Int32]
        $QualityUpdatesDeferralPeriodInDays,

        [Parameter()]
        [System.Boolean]
        $QualityUpdatesPaused,

        [Parameter()]
        [System.String]
        $QualityUpdatesPauseExpiryDateTime,

        [Parameter()]
        [System.String]
        $QualityUpdatesPauseStartDate,

        [Parameter()]
        [System.String]
        $QualityUpdatesRollbackStartDateTime,

        [Parameter()]
        [System.Int32]
        $ScheduleImminentRestartWarningInMinutes,

        [Parameter()]
        [System.Int32]
        $ScheduleRestartWarningInHours,

        [Parameter()]
        [System.Boolean]
        $SkipChecksBeforeRestart,

        [Parameter()]
        [ValidateSet('notConfigured', 'defaultNotifications', 'restartWarningsOnly', 'disableAllNotifications', 'unknownFutureValue')]
        [System.String]
        $UpdateNotificationLevel,

        [Parameter()]
        [ValidateSet('userDefined', 'firstWeek', 'secondWeek', 'thirdWeek', 'fourthWeek', 'everyWeek', 'unknownFutureValue')]
        [System.String]
        $UpdateWeeks,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $UserPauseAccess,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $UserWindowsUpdateScanAccess,

        [Parameter()]
        [System.String]
        $Description,

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
        $baseFilter = "isof('microsoft.graph.windowsUpdateForBusinessConfiguration')"
        if (-not [string]::IsNullOrEmpty($Filter))
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

            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                Id                    = $config.Id
                DisplayName           = $config.displayName
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

            if ($null -ne $Results.InstallationSchedule)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.InstallationSchedule `
                    -CIMInstanceName 'MicrosoftGraphwindowsUpdateInstallScheduleType'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.InstallationSchedule = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('InstallationSchedule') | Out-Null
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
                -NoEscape @('InstallationSchedule', 'Assignments')
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
