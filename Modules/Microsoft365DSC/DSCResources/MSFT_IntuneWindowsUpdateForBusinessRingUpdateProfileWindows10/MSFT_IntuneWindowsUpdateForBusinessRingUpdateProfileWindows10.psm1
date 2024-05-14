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

    try
    {
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

        $nullResult = $PSBoundParameters
        $nullResult.Ensure = 'Absent'

        $getValue = $null
        #region resource generator code
        $getValue = Get-MgBetaDeviceManagementDeviceConfiguration -DeviceConfigurationId $Id  -ErrorAction SilentlyContinue

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Window Update For Business Ring Update Profile for Windows10 with Id {$Id}"

            if (-Not [string]::IsNullOrEmpty($DisplayName))
            {
                $getValue = Get-MgBetaDeviceManagementDeviceConfiguration `
                    -Filter "DisplayName eq '$DisplayName'" `
                    -ErrorAction SilentlyContinue
            }
        }
        #endregion
        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Window Update For Business Ring Update Profile for Windows10 with DisplayName {$DisplayName}"
            return $nullResult
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Window Update For Business Ring Update Profile for Windows10 with Id {$Id} and DisplayName {$DisplayName} was found."

        #region resource generator code
        $complexInstallationSchedule = @{}
        if ($null -ne $getValue.AdditionalProperties.installationSchedule.activeHoursEnd)
        {
            $complexInstallationSchedule.Add('ActiveHoursEnd', ([TimeSpan]$getValue.AdditionalProperties.installationSchedule.activeHoursEnd).ToString())
        }
        if ($null -ne $getValue.AdditionalProperties.installationSchedule.activeHoursStart)
        {
            $complexInstallationSchedule.Add('ActiveHoursStart', ([TimeSpan]$getValue.AdditionalProperties.installationSchedule.activeHoursStart).ToString())
        }
        if ($null -ne $getValue.AdditionalProperties.installationSchedule.scheduledInstallDay)
        {
            $complexInstallationSchedule.Add('ScheduledInstallDay', $getValue.AdditionalProperties.installationSchedule.scheduledInstallDay.toString())
        }
        if ($null -ne $getValue.AdditionalProperties.installationSchedule.scheduledInstallTime)
        {
            $complexInstallationSchedule.Add('ScheduledInstallTime', ([TimeSpan]$getValue.AdditionalProperties.installationSchedule.scheduledInstallTime).ToString())
        }
        if ($null -ne $getValue.AdditionalProperties.installationSchedule.'@odata.type')
        {
            $complexInstallationSchedule.Add('odataType', $getValue.AdditionalProperties.installationSchedule.'@odata.type'.toString())
        }
        if ($complexInstallationSchedule.values.Where({ $null -ne $_ }).count -eq 0)
        {
            $complexInstallationSchedule = $null
        }
        #endregion

        #region resource generator code
        $enumAutomaticUpdateMode = $null
        if ($null -ne $getValue.AdditionalProperties.automaticUpdateMode)
        {
            $enumAutomaticUpdateMode = $getValue.AdditionalProperties.automaticUpdateMode.ToString()
        }

        $enumAutoRestartNotificationDismissal = $null
        if ($null -ne $getValue.AdditionalProperties.autoRestartNotificationDismissal)
        {
            $enumAutoRestartNotificationDismissal = $getValue.AdditionalProperties.autoRestartNotificationDismissal.ToString()
        }

        $enumBusinessReadyUpdatesOnly = $null
        if ($null -ne $getValue.AdditionalProperties.businessReadyUpdatesOnly)
        {
            $enumBusinessReadyUpdatesOnly = $getValue.AdditionalProperties.businessReadyUpdatesOnly.ToString()
        }

        $enumDeliveryOptimizationMode = $null
        if ($null -ne $getValue.AdditionalProperties.deliveryOptimizationMode)
        {
            $enumDeliveryOptimizationMode = $getValue.AdditionalProperties.deliveryOptimizationMode.ToString()
        }

        $enumPrereleaseFeatures = $null
        if ($null -ne $getValue.AdditionalProperties.prereleaseFeatures)
        {
            $enumPrereleaseFeatures = $getValue.AdditionalProperties.prereleaseFeatures.ToString()
        }

        $enumUpdateNotificationLevel = $null
        if ($null -ne $getValue.AdditionalProperties.updateNotificationLevel)
        {
            $enumUpdateNotificationLevel = $getValue.AdditionalProperties.updateNotificationLevel.ToString()
        }

        $enumUpdateWeeks = $null
        if ($null -ne $getValue.AdditionalProperties.updateWeeks)
        {
            $enumUpdateWeeks = $getValue.AdditionalProperties.updateWeeks.ToString()
        }

        $enumUserPauseAccess = $null
        if ($null -ne $getValue.AdditionalProperties.userPauseAccess)
        {
            $enumUserPauseAccess = $getValue.AdditionalProperties.userPauseAccess.ToString()
        }

        $enumUserWindowsUpdateScanAccess = $null
        if ($null -ne $getValue.AdditionalProperties.userWindowsUpdateScanAccess)
        {
            $enumUserWindowsUpdateScanAccess = $getValue.AdditionalProperties.userWindowsUpdateScanAccess.ToString()
        }
        #endregion

        #region resource generator code
        $dateFeatureUpdatesPauseExpiryDateTime = $null
        if ($null -ne $getValue.AdditionalProperties.featureUpdatesPauseExpiryDateTime)
        {
            $dateFeatureUpdatesPauseExpiryDateTime = ([DateTimeOffset]$getValue.AdditionalProperties.featureUpdatesPauseExpiryDateTime).ToString('o')
        }

        $dateFeatureUpdatesPauseStartDate = $null
        if ($null -ne $getValue.AdditionalProperties.featureUpdatesPauseStartDate)
        {
            $dateFeatureUpdatesPauseStartDate = ([DateTime]$getValue.AdditionalProperties.featureUpdatesPauseStartDate).ToString('o')
        }

        $dateFeatureUpdatesRollbackStartDateTime = $null
        if ($null -ne $getValue.AdditionalProperties.featureUpdatesRollbackStartDateTime)
        {
            $dateFeatureUpdatesRollbackStartDateTime = ([DateTimeOffset]$getValue.AdditionalProperties.featureUpdatesRollbackStartDateTime).ToString('o')
        }

        $dateQualityUpdatesPauseExpiryDateTime = $null
        if ($null -ne $getValue.AdditionalProperties.qualityUpdatesPauseExpiryDateTime)
        {
            $dateQualityUpdatesPauseExpiryDateTime = ([DateTimeOffset]$getValue.AdditionalProperties.qualityUpdatesPauseExpiryDateTime).ToString('o')
        }

        $dateQualityUpdatesPauseStartDate = $null
        if ($null -ne $getValue.AdditionalProperties.qualityUpdatesPauseStartDate)
        {
            $dateQualityUpdatesPauseStartDate = ([DateTime]$getValue.AdditionalProperties.qualityUpdatesPauseStartDate).ToString('o')
        }

        $dateQualityUpdatesRollbackStartDateTime = $null
        if ($null -ne $getValue.AdditionalProperties.qualityUpdatesRollbackStartDateTime)
        {
            $dateQualityUpdatesRollbackStartDateTime = ([DateTimeOffset]$getValue.AdditionalProperties.qualityUpdatesRollbackStartDateTime).ToString('o')
        }
        #endregion

        $results = @{
            #region resource generator code
            AllowWindows11Upgrade                   = $getValue.AdditionalProperties.allowWindows11Upgrade
            AutomaticUpdateMode                     = $enumAutomaticUpdateMode
            AutoRestartNotificationDismissal        = $enumAutoRestartNotificationDismissal
            BusinessReadyUpdatesOnly                = $enumBusinessReadyUpdatesOnly
            DeadlineForFeatureUpdatesInDays         = $getValue.AdditionalProperties.deadlineForFeatureUpdatesInDays
            DeadlineForQualityUpdatesInDays         = $getValue.AdditionalProperties.deadlineForQualityUpdatesInDays
            DeadlineGracePeriodInDays               = $getValue.AdditionalProperties.deadlineGracePeriodInDays
            DeliveryOptimizationMode                = $enumDeliveryOptimizationMode
            DriversExcluded                         = $getValue.AdditionalProperties.driversExcluded
            EngagedRestartDeadlineInDays            = $getValue.AdditionalProperties.engagedRestartDeadlineInDays
            EngagedRestartSnoozeScheduleInDays      = $getValue.AdditionalProperties.engagedRestartSnoozeScheduleInDays
            EngagedRestartTransitionScheduleInDays  = $getValue.AdditionalProperties.engagedRestartTransitionScheduleInDays
            FeatureUpdatesDeferralPeriodInDays      = $getValue.AdditionalProperties.featureUpdatesDeferralPeriodInDays
            FeatureUpdatesPaused                    = $getValue.AdditionalProperties.featureUpdatesPaused
            FeatureUpdatesPauseExpiryDateTime       = $dateFeatureUpdatesPauseExpiryDateTime
            FeatureUpdatesPauseStartDate            = $dateFeatureUpdatesPauseStartDate
            FeatureUpdatesRollbackStartDateTime     = $dateFeatureUpdatesRollbackStartDateTime
            FeatureUpdatesRollbackWindowInDays      = $getValue.AdditionalProperties.featureUpdatesRollbackWindowInDays
            InstallationSchedule                    = $complexInstallationSchedule
            MicrosoftUpdateServiceAllowed           = $getValue.AdditionalProperties.microsoftUpdateServiceAllowed
            PostponeRebootUntilAfterDeadline        = $getValue.AdditionalProperties.postponeRebootUntilAfterDeadline
            PrereleaseFeatures                      = $enumPrereleaseFeatures
            QualityUpdatesDeferralPeriodInDays      = $getValue.AdditionalProperties.qualityUpdatesDeferralPeriodInDays
            QualityUpdatesPaused                    = $getValue.AdditionalProperties.qualityUpdatesPaused
            QualityUpdatesPauseExpiryDateTime       = $dateQualityUpdatesPauseExpiryDateTime
            QualityUpdatesPauseStartDate            = $dateQualityUpdatesPauseStartDate
            QualityUpdatesRollbackStartDateTime     = $dateQualityUpdatesRollbackStartDateTime
            ScheduleImminentRestartWarningInMinutes = $getValue.AdditionalProperties.scheduleImminentRestartWarningInMinutes
            ScheduleRestartWarningInHours           = $getValue.AdditionalProperties.scheduleRestartWarningInHours
            SkipChecksBeforeRestart                 = $getValue.AdditionalProperties.skipChecksBeforeRestart
            UpdateNotificationLevel                 = $enumUpdateNotificationLevel
            UpdateWeeks                             = $enumUpdateWeeks
            UserPauseAccess                         = $enumUserPauseAccess
            UserWindowsUpdateScanAccess             = $enumUserWindowsUpdateScanAccess
            Description                             = $getValue.Description
            DisplayName                             = $getValue.DisplayName
            Id                                      = $getValue.Id
            Ensure                                  = 'Present'
            Credential                              = $Credential
            ApplicationId                           = $ApplicationId
            TenantId                                = $TenantId
            ApplicationSecret                       = $ApplicationSecret
            CertificateThumbprint                   = $CertificateThumbprint
            Managedidentity                         = $ManagedIdentity.IsPresent
            AccessTokens                            = $AccessTokens
            #endregion
        }

        $rawAssignments = @()
        $rawAssignments =  Get-MgBetaDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId $Id -All
        $assignmentResult = @()
        if($null -ne $rawAssignments -and $rawAssignments.count -gt 0)
        {
            $assignmentResult += ConvertFrom-IntunePolicyAssignment -Assignments $rawAssignments
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

    $PSBoundParameters.Remove('Ensure') | Out-Null
    $PSBoundParameters.Remove('Credential') | Out-Null
    $PSBoundParameters.Remove('ApplicationId') | Out-Null
    $PSBoundParameters.Remove('ApplicationSecret') | Out-Null
    $PSBoundParameters.Remove('TenantId') | Out-Null
    $PSBoundParameters.Remove('CertificateThumbprint') | Out-Null
    $PSBoundParameters.Remove('ManagedIdentity') | Out-Null
    $PSBoundParameters.Remove('Verbose') | Out-Null
    $PSBoundParameters.Remove('AccessTokens') | Out-Null

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Window Update For Business Ring Update Profile for Windows10 with DisplayName {$DisplayName}"
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $CreateParameters = ([Hashtable]$PSBoundParameters).clone()
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters
        $CreateParameters.Remove('Id') | Out-Null

        $keys = (([Hashtable]$CreateParameters).clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $CreateParameters.$key -and $CreateParameters.$key.getType().Name -like '*cimInstance*')
            {
                $CreateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters.$key
            }
        }
        #region resource generator code
        $CreateParameters.Add("@odata.type", "#microsoft.graph.windowsUpdateForBusinessConfiguration")
        $policy = New-MgBetaDeviceManagementDeviceConfiguration -BodyParameter $CreateParameters
        #endregion
        #region new Intune assignment management
        $intuneAssignments = @()
        if($null -ne $Assignments -and $Assignments.count -gt 0)
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
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $UpdateParameters = ([Hashtable]$PSBoundParameters).clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters

        $UpdateParameters.Remove('Id') | Out-Null

        $keys = (([Hashtable]$UpdateParameters).clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $UpdateParameters.$key -and $UpdateParameters.$key.getType().Name -like '*cimInstance*')
            {
                $UpdateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters.$key
            }
        }
        #region resource generator code
        $UpdateParameters.Add("@odata.type", "#microsoft.graph.windowsUpdateForBusinessConfiguration")
        Update-MgBetaDeviceManagementDeviceConfiguration  `
            -DeviceConfigurationId $currentInstance.id `
            -BodyParameter $UpdateParameters
        #endregion
        #region new Intune assignment management
        $currentAssignments = @()
        $currentAssignments += Get-MgBetaDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId $currentInstance.id

        $intuneAssignments = @()
        if($null -ne $Assignments -and $Assignments.count -gt 0)
        {
            $intuneAssignments += ConvertTo-IntunePolicyAssignment -Assignments $Assignments
        }
        foreach ($assignment in $intuneAssignments)
        {
            if ( $null -eq ($currentAssignments | Where-Object { $_.Target.AdditionalProperties.groupId -eq $assignment.Target.groupId -and $_.Target.AdditionalProperties."@odata.type" -eq $assignment.Target.'@odata.type' }))
            {
                New-MgBetaDeviceManagementDeviceConfigurationAssignment `
                    -DeviceConfigurationId $currentInstance.id `
                    -BodyParameter $assignment
            }
            else
            {
                $currentAssignments = $currentAssignments | Where-Object { -not($_.Target.AdditionalProperties.groupId -eq $assignment.Target.groupId -and $_.Target.AdditionalProperties."@odata.type" -eq $assignment.Target.'@odata.type') }
            }
        }
        if($currentAssignments.count -gt 0)
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

    Write-Verbose -Message "Testing configuration of the Intune Window Update For Business Ring Update Profile for Windows10 with Id {$Id} and DisplayName {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

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

            if( $key -eq "Assignments")
            {
                $testResult = $source.count -eq $target.count
                if (-Not $testResult) { break }
                foreach ($assignment in $source)
                {
                    if ($assignment.dataType -like '*GroupAssignmentTarget')
                    {
                        $testResult = $null -ne ($target | Where-Object {$_.dataType -eq $assignment.DataType -and $_.groupId -eq $assignment.groupId})
                        #Using assignment groupDisplayName only if the groupId is not found in the directory otherwise groupId should be the key
                        if (-not $testResult)
                        {
                            $groupNotFound =  $null -eq (Get-MgGroup -GroupId ($assignment.groupId) -ErrorAction SilentlyContinue)
                        }
                        if (-not $testResult -and $groupNotFound)
                        {
                            $testResult = $null -ne ($target | Where-Object {$_.dataType -eq $assignment.DataType -and $_.groupDisplayName -eq $assignment.groupDisplayName})
                        }
                    }
                    else
                    {
                        $testResult = $null -ne ($target | Where-Object {$_.dataType -eq $assignment.DataType})
                    }
                    if (-Not $testResult) { break }
                }
                if (-Not $testResult) { break }
            }
            if (-Not $testResult) { break }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }
    $ValuesToCheck.Remove('Id') | Out-Null

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

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
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windowsUpdateForBusinessConfiguration' `
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
            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-Host "    |---[$i/$($getValue.Count)] $displayedKey" -NoNewline
            $params = @{
                Id                    = $config.Id
                DisplayName           = $config.displayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results

            if ($null -ne $Results.InstallationSchedule)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.InstallationSchedule `
                    -CIMInstanceName 'MicrosoftGraphwindowsUpdateInstallScheduleType'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
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
                -Credential $Credential
            if ($Results.InstallationSchedule)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'InstallationSchedule' -IsCIMArray:$False
            }
            if ($Results.Assignments)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Assignments' -IsCIMArray:$true
            }
            #removing trailing commas and semi colons between items of an array of cim instances added by Convert-DSCStringParamToVariable
            $currentDSCBlock = $currentDSCBlock.replace( "    ,`r`n" , "    `r`n" )
            $currentDSCBlock = $currentDSCBlock.replace( "`r`n;`r`n" , "`r`n" )
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
