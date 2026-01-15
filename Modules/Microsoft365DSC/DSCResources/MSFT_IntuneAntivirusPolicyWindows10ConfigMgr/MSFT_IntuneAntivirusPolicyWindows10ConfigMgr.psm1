Confirm-M365DSCModuleDependency -ModuleName "MSFT_IntuneAntivirusPolicyWindows10ConfigMgr"

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowArchiveScanning,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowBehaviorMonitoring,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowCloudProtection,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowEmailScanning,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowFullScanOnMappedNetworkDrives,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowFullScanRemovableDriveScanning,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowIntrusionPreventionSystem,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowIOAVProtection,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowRealtimeMonitoring,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowScanningNetworkFiles,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowScriptScanning,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowUserUIAccess,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.Int32]
        $AvgCPULoadFactor,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $CheckForSignaturesBeforeRunningScan,

        [Parameter()]
        [ValidateSet(0, 2, 4, 6)]
        [System.Int32]
        $CloudBlockLevel,

        [Parameter()]
        [ValidateRange(0, 50)]
        [System.Int32]
        $CloudExtendedTimeout,

        [Parameter()]
        [ValidateRange(0, 90)]
        [System.Int32]
        $DaysToRetainCleanedMalware,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableCatchupFullScan,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableCatchupQuickScan,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $EnableLowCPUPriority,

        [Parameter()]
        [System.String[]]
        $ExcludedExtensions,

        [Parameter()]
        [System.String[]]
        $ExcludedPaths,

        [Parameter()]
        [System.String[]]
        $ExcludedProcesses,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $PUAProtection,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $RealTimeScanDirection,

        [Parameter()]
        [ValidateSet(1, 2)]
        [System.Int32]
        $ScanParameter,

        [Parameter()]
        [ValidateRange(0, 1380)]
        [System.Int32]
        $ScheduleQuickScanTime,

        [Parameter()]
        [ValidateSet(0, 1, 2, 3, 4, 5, 6, 7, 8)]
        [System.Int32]
        $ScheduleScanDay,

        [Parameter()]
        [ValidateRange(0, 1380)]
        [System.Int32]
        $ScheduleScanTime,

        [Parameter()]
        [System.String[]]
        $SignatureUpdateFallbackOrder,

        [Parameter()]
        [System.String[]]
        $SignatureUpdateFileSharesSources,

        [Parameter()]
        [ValidateRange(0, 24)]
        [System.Int32]
        $SignatureUpdateInterval,

        [Parameter()]
        [ValidateSet(0, 1, 2, 3)]
        [System.Int32]
        $SubmitSamplesConsent,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowOnAccessProtection,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $HighSeverityThreatDefaultAction,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $SevereThreatDefaultAction,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $LowSeverityThreatDefaultAction,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $ModerateSeverityThreatDefaultAction,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableRestorePoint,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $RandomizeScheduleTaskTimes,

        [Parameter()]
        [System.String]
        $SecurityIntelligenceLocation,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisablePrivacyMode,

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

    Write-Verbose -Message "Getting configuration for the Intune Antivirus Policy for Windows10 Config Mgr with Id {$Id} and DisplayName {$DisplayName}"

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
            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                $getValue = Get-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $Id -ErrorAction SilentlyContinue
            }

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Antivirus Policy for Windows10 Config Mgr with Id {$Id}"

                if (-not [System.String]::IsNullOrEmpty($DisplayName))
                {
                    $getValue = Get-MgBetaDeviceManagementConfigurationPolicy `
                        -All `
                        -Filter "Name eq '$($DisplayName -replace "'", "''")' and creationSource eq 'SccmAV' and technologies eq 'configManager'" `
                        -ErrorAction SilentlyContinue
                }
            }
            #endregion
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Antivirus Policy for Windows10 Config Mgr with DisplayName {$DisplayName}."
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Antivirus Policy for Windows10 Config Mgr with Id {$Id} and DisplayName {$DisplayName} was found"

        # Retrieve policy specific settings
        [array]$settings = Get-MgBetaDeviceManagementConfigurationPolicySetting `
            -DeviceManagementConfigurationPolicyId $Id `
            -ExpandProperty 'settingDefinitions' `
            -All `
            -ErrorAction Stop

        $policySettings = @{}
        $policySettings = Export-IntuneSettingCatalogPolicySettings -Settings $settings -ReturnHashtable $policySettings

        $disableRestorePointInstance = $settings | Where-Object { $_.SettingInstance.SettingDefinitionId -like "*_disablerestorepoint" }
        if ($null -ne $disableRestorePointInstance)
        {
            $policySettings.DisableRestorePoint = [int]$disableRestorePointInstance.SettingInstance.AdditionalProperties.choiceSettingValue.value.Split("_")[-1]
        }

        $results = @{
            #region resource generator code
            Description           = $getValue.Description
            DisplayName           = $getValue.Name
            RoleScopeTagIds       = $getValue.RoleScopeTagIds
            Id                    = $getValue.Id
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            #endregion
        }
        $results += $policySettings

        $assignmentsValues = Get-MgBetaDeviceManagementConfigurationPolicyAssignment -DeviceManagementConfigurationPolicyId $Id
        $assignmentResult = @()
        if ($assignmentsValues.Count -gt 0)
        {
            $assignmentResult += ConvertFrom-IntunePolicyAssignment -Assignments $assignmentsValues -IncludeDeviceFilter $true
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
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowArchiveScanning,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowBehaviorMonitoring,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowCloudProtection,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowEmailScanning,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowFullScanOnMappedNetworkDrives,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowFullScanRemovableDriveScanning,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowIntrusionPreventionSystem,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowIOAVProtection,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowRealtimeMonitoring,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowScanningNetworkFiles,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowScriptScanning,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowUserUIAccess,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.Int32]
        $AvgCPULoadFactor,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $CheckForSignaturesBeforeRunningScan,

        [Parameter()]
        [ValidateSet(0, 2, 4, 6)]
        [System.Int32]
        $CloudBlockLevel,

        [Parameter()]
        [ValidateRange(0, 50)]
        [System.Int32]
        $CloudExtendedTimeout,

        [Parameter()]
        [ValidateRange(0, 90)]
        [System.Int32]
        $DaysToRetainCleanedMalware,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableCatchupFullScan,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableCatchupQuickScan,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $EnableLowCPUPriority,

        [Parameter()]
        [System.String[]]
        $ExcludedExtensions,

        [Parameter()]
        [System.String[]]
        $ExcludedPaths,

        [Parameter()]
        [System.String[]]
        $ExcludedProcesses,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $PUAProtection,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $RealTimeScanDirection,

        [Parameter()]
        [ValidateSet(1, 2)]
        [System.Int32]
        $ScanParameter,

        [Parameter()]
        [ValidateRange(0, 1380)]
        [System.Int32]
        $ScheduleQuickScanTime,

        [Parameter()]
        [ValidateSet(0, 1, 2, 3, 4, 5, 6, 7, 8)]
        [System.Int32]
        $ScheduleScanDay,

        [Parameter()]
        [ValidateRange(0, 1380)]
        [System.Int32]
        $ScheduleScanTime,

        [Parameter()]
        [System.String[]]
        $SignatureUpdateFallbackOrder,

        [Parameter()]
        [System.String[]]
        $SignatureUpdateFileSharesSources,

        [Parameter()]
        [ValidateRange(0, 24)]
        [System.Int32]
        $SignatureUpdateInterval,

        [Parameter()]
        [ValidateSet(0, 1, 2, 3)]
        [System.Int32]
        $SubmitSamplesConsent,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowOnAccessProtection,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $HighSeverityThreatDefaultAction,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $SevereThreatDefaultAction,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $LowSeverityThreatDefaultAction,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $ModerateSeverityThreatDefaultAction,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableRestorePoint,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $RandomizeScheduleTaskTimes,

        [Parameter()]
        [System.String]
        $SecurityIntelligenceLocation,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisablePrivacyMode,

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

    Write-Verbose -Message "Setting configuration of the Intune Antivirus Policy for Windows10 Config Mgr with Id {$Id} and DisplayName {$DisplayName}"

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
    $boundParameters.Remove('RandomizeScheduleTaskTimes') | Out-Null

    $templateReferenceId = '804339ad-1553-4478-a742-138fb5807418_1'
    $platforms = 'windows10'
    $technologies = 'configManager'

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Antivirus Policy for Windows10 Config Mgr with DisplayName {$DisplayName}"
        $boundParameters.Remove("Assignments") | Out-Null

        [array]$settings = Get-IntuneSettingCatalogPolicySetting `
            -DSCParams ([System.Collections.Hashtable]$boundParameters) `
            -TemplateId $templateReferenceId

        if ($PSBoundParameters.ContainsKey('DisableRestorePoint')) {
            $settings += @{
                '@odata.type'     = '#microsoft.graph.deviceManagementConfigurationSetting'
                settingInstance = @{
                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                    choiceSettingValue = @{
                        children = @()
                        value = "defender_disablerestorepoint_$DisableRestorePoint"
                    }
                    settingDefinitionId = 'defender_disablerestorepoint'
                }
            }
        }

        if ($PSBoundParameters.ContainsKey('RandomizeScheduleTaskTimes')) {
            $settings += @{
                '@odata.type'     = '#microsoft.graph.deviceManagementConfigurationSetting'
                settingInstance = @{
                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                    choiceSettingValue = @{
                        children = @()
                        value = "defender_randomizescheduletasktimes_$RandomizeScheduleTaskTimes"
                    }
                    settingDefinitionId = 'defender_randomizescheduletasktimes'
                }
            }
        }

        if ($PSBoundParameters.ContainsKey('SecurityIntelligenceLocation')) {
            $settings += @{
                '@odata.type'     = '#microsoft.graph.deviceManagementConfigurationSetting'
                settingInstance = @{
                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                    simpleSettingValue = @{
                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                        value = "$SecurityIntelligenceLocation"
                    }
                    settingDefinitionId = 'device_vendor_msft_policy_config_defender_securityintelligencelocation'
                }
            }
        }

        if ($PSBoundParameters.ContainsKey('DisablePrivacyMode')) {
            $settings += @{
                '@odata.type'     = '#microsoft.graph.deviceManagementConfigurationSetting'
                settingInstance = @{
                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                    choiceSettingValue = @{
                        children = @()
                        value = "defender_disableprivacymode_$DisablePrivacyMode"
                    }
                    settingDefinitionId = 'defender_disableprivacymode'
                }
            }
        }

        $createParameters = @{
            Name              = $DisplayName
            Description       = $Description
            CreationSource    = 'SccmAV'
            Platforms         = $platforms
            Technologies      = $technologies
            Settings          = $settings
        }

        #region resource generator code
        $policy = New-MgBetaDeviceManagementConfigurationPolicy -BodyParameter $createParameters

        if ($policy.Id)
        {
            $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
            Update-DeviceConfigurationPolicyAssignment `
                -DeviceConfigurationPolicyId $policy.Id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/configurationPolicies'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Antivirus Policy for Windows10 Config Mgr with Id {$($currentInstance.Id)}"
        $boundParameters.Remove("Assignments") | Out-Null

        [array]$settings = Get-IntuneSettingCatalogPolicySetting `
            -DSCParams ([System.Collections.Hashtable]$boundParameters) `
            -TemplateId $templateReferenceId

        if ($PSBoundParameters.ContainsKey('DisableRestorePoint')) {
            $settings += @{
                '@odata.type'     = '#microsoft.graph.deviceManagementConfigurationSetting'
                settingInstance = @{
                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                    choiceSettingValue = @{
                        children = @()
                        value = "defender_disablerestorepoint_$DisableRestorePoint"
                    }
                    settingDefinitionId = 'defender_disablerestorepoint'
                }
            }
        }

        if ($PSBoundParameters.ContainsKey('RandomizeScheduleTaskTimes')) {
            $settings += @{
                '@odata.type'     = '#microsoft.graph.deviceManagementConfigurationSetting'
                settingInstance = @{
                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                    choiceSettingValue = @{
                        children = @()
                        value = "defender_randomizescheduletasktimes_$RandomizeScheduleTaskTimes"
                    }
                    settingDefinitionId = 'defender_randomizescheduletasktimes'
                }
            }
        }

        if ($PSBoundParameters.ContainsKey('SecurityIntelligenceLocation')) {
            $settings += @{
                '@odata.type'     = '#microsoft.graph.deviceManagementConfigurationSetting'
                settingInstance = @{
                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                    simpleSettingValue = @{
                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                        value = "$SecurityIntelligenceLocation"
                    }
                    settingDefinitionId = 'device_vendor_msft_policy_config_defender_securityintelligencelocation'
                }
            }
        }

        if ($PSBoundParameters.ContainsKey('DisablePrivacyMode')) {
            $settings += @{
                '@odata.type'     = '#microsoft.graph.deviceManagementConfigurationSetting'
                settingInstance = @{
                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                    choiceSettingValue = @{
                        children = @()
                        value = "defender_disableprivacymode_$DisablePrivacyMode"
                    }
                    settingDefinitionId = 'defender_disableprivacymode'
                }
            }
        }

        Update-IntuneDeviceConfigurationPolicy `
            -DeviceConfigurationPolicyId $currentInstance.Id `
            -Name $DisplayName `
            -Description $Description `
            -CreationSource 'SccmAV' `
            -Platforms $platforms `
            -Technologies $technologies `
            -Settings $settings `
            -RoleScopeTagIds $RoleScopeTagIds

        #region resource generator code

        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentInstance.Id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/configurationPolicies'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Antivirus Policy for Windows10 Config Mgr with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $currentInstance.Id
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
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowArchiveScanning,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowBehaviorMonitoring,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowCloudProtection,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowEmailScanning,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowFullScanOnMappedNetworkDrives,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowFullScanRemovableDriveScanning,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowIntrusionPreventionSystem,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowIOAVProtection,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowRealtimeMonitoring,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowScanningNetworkFiles,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowScriptScanning,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowUserUIAccess,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.Int32]
        $AvgCPULoadFactor,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $CheckForSignaturesBeforeRunningScan,

        [Parameter()]
        [ValidateSet(0, 2, 4, 6)]
        [System.Int32]
        $CloudBlockLevel,

        [Parameter()]
        [ValidateRange(0, 50)]
        [System.Int32]
        $CloudExtendedTimeout,

        [Parameter()]
        [ValidateRange(0, 90)]
        [System.Int32]
        $DaysToRetainCleanedMalware,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableCatchupFullScan,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableCatchupQuickScan,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $EnableLowCPUPriority,

        [Parameter()]
        [System.String[]]
        $ExcludedExtensions,

        [Parameter()]
        [System.String[]]
        $ExcludedPaths,

        [Parameter()]
        [System.String[]]
        $ExcludedProcesses,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $PUAProtection,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $RealTimeScanDirection,

        [Parameter()]
        [ValidateSet(1, 2)]
        [System.Int32]
        $ScanParameter,

        [Parameter()]
        [ValidateRange(0, 1380)]
        [System.Int32]
        $ScheduleQuickScanTime,

        [Parameter()]
        [ValidateSet(0, 1, 2, 3, 4, 5, 6, 7, 8)]
        [System.Int32]
        $ScheduleScanDay,

        [Parameter()]
        [ValidateRange(0, 1380)]
        [System.Int32]
        $ScheduleScanTime,

        [Parameter()]
        [System.String[]]
        $SignatureUpdateFallbackOrder,

        [Parameter()]
        [System.String[]]
        $SignatureUpdateFileSharesSources,

        [Parameter()]
        [ValidateRange(0, 24)]
        [System.Int32]
        $SignatureUpdateInterval,

        [Parameter()]
        [ValidateSet(0, 1, 2, 3)]
        [System.Int32]
        $SubmitSamplesConsent,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowOnAccessProtection,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $HighSeverityThreatDefaultAction,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $SevereThreatDefaultAction,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $LowSeverityThreatDefaultAction,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $ModerateSeverityThreatDefaultAction,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableRestorePoint,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $RandomizeScheduleTaskTimes,

        [Parameter()]
        [System.String]
        $SecurityIntelligenceLocation,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisablePrivacyMode,

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

    $compareParameters = Get-CompareParameters
    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
                                             -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
                                             @compareParameters
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
        $baseFilter = "creationSource eq 'SccmAV' and technologies eq 'configManager'"
        if (-not [System.String]::IsNullOrEmpty($Filter))
        {
            $Filter = "($Filter) and ($baseFilter)"
        }
        else
        {
            $Filter = $baseFilter
        }
        [array]$getValue = Get-MgBetaDeviceManagementConfigurationPolicy `
            -Filter $Filter `
            -All `
            -ErrorAction Stop
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
            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            elseif (-not [string]::IsNullOrEmpty($config.name))
            {
                $displayedKey = $config.name
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                Id                    = $config.Id
                DisplayName           = $config.Name
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
                -NoEscape @('Assignments')
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
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

function Get-CompareParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    return @{
        PostProcessing = {
            param($DesiredValues, $CurrentValues, $ValuesToCheck, $PostProcessingArgs)
            $PostProcessingArgs[0] | ForEach-Object {
                if ($_.Key -notlike '*Variable' -or $_.Key -notin @('Verbose', 'Debug', 'ErrorAction', 'WarningAction', 'InformationAction'))
                {
                    if ($null -ne $CurrentValues[$_.Key] -or $null -ne $DesiredValues[$_.Key])
                    {
                        $ValuesToCheck[$_.Key] = $null
                        if (-not $DesiredValues.ContainsKey($_.Key))
                        {
                            $DesiredValues.Add($_.Key, $null)
                        }
                    }
                }
            }

            return [System.Tuple[Hashtable, Hashtable, Hashtable]]::new($DesiredValues, $CurrentValues, $ValuesToCheck)
        }
        PostProcessingArgs = $MyInvocation.MyCommand.Parameters.GetEnumerator()
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
