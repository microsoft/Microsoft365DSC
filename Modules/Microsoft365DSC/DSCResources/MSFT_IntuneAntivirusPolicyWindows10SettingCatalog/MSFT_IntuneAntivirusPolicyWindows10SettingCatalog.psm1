Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneAntivirusPolicyWindows10SettingCatalog'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [System.String]
        $Identity,

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
        $AllowDatagramProcessingOnWinServer,

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
        $AllowNetworkProtectionDownLevel,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowOnAccessProtection,

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
        [System.Int32]
        $AvgCPULoadFactor,

        [Parameter()]
        [System.Int32]
        $ArchiveMaxDepth,

        [Parameter()]
        [System.Int32]
        $ArchiveMaxSize,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $CheckForSignaturesBeforeRunningScan,

        [Parameter()]
        [ValidateSet(0, 2, 4, 6)]
        [System.Int32]
        $CloudBlockLevel,

        [Parameter()]
        [System.Int32]
        $CloudExtendedTimeout,

        [Parameter()]
        [System.String]
        $CompanyName,

        [Parameter()]
        [System.Int32]
        $DaysToRetainCleanedMalware,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableAccountProtectionUI,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableAppBrowserUI,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableClearTpmButton,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableDeviceSecurityUI,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableDnsOverTcpParsing,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableEnhancedNotifications,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableFamilyUI,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableHealthUI,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableHttpParsing,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableSshParsing,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableNetworkUI,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableTpmFirmwareUpdateWarning,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableVirusUI,

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
        [System.Int32[]]
        $DisableCoreServiceECSIntegration,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32[]]
        $DisableCoreServiceTelemetry,

        [Parameter()]
        [System.String]
        $Email,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $EnableCustomizedToasts,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $EnableInAppCustomization,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $EnableLowCPUPriority,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $EnableNetworkProtection,

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
        [ValidateSet(0, 1)]
        [System.Int32]
        $HideRansomwareDataRecovery,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $HideWindowsSecurityNotificationAreaControl,

        [Parameter()]
        [System.String]
        $Phone,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $PUAProtection,

        [Parameter()]
        [ValidateSet(0, 2, 3, 4, 5, 6)]
        [System.Int32]
        $EngineUpdatesChannel,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $MeteredConnectionUpdates,

        [Parameter()]
        [ValidateSet(0, 2, 3, 4, 5, 6)]
        [System.Int32]
        $PlatformUpdatesChannel,

        [Parameter()]
        [ValidateSet(0, 4, 5)]
        [System.Int32]
        $SecurityIntelligenceUpdatesChannel,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $RealTimeScanDirection,

        [Parameter()]
        [ValidateSet(1, 2)]
        [System.Int32]
        $ScanParameter,

        [Parameter()]
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
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableTlsParsing,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $RandomizeScheduleTaskTimes,

        [Parameter()]
        [ValidateRange(1, 23)]
        [System.Int32]
        $SchedulerRandomizationTime,

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
        [ValidateSet('Onboarding', 'Offboarding', 'ControlledConfig_Onboarding')]
        [System.String]
        $ControlledConfiguration,

        [Parameter()]
        [ValidateSet('Onboarding', 'Offboarding')]
        [System.String]
        $TamperProtection,

        [Parameter()]
        [System.String]
        $URL,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableLocalAdminMerge,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $LowSeverityThreats,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $ModerateSeverityThreats,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $SevereThreats,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $HighSeverityThreats,

        [Parameter()]
        [ValidateSet('d948ff9b-99cb-4ee0-8012-1fbc09685377_1', 'e3f74c5a-a6de-411d-aef6-eb15628f3a0a_1', '45fea5e9-280d-4da1-9792-fb5736da0ca9_1', '804339ad-1553-4478-a742-138fb5807418_1')]
        [System.String]
        $TemplateId,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of the Intune Antivirus Policy for Windows10 Setting Catalog with Id {$Identity} and DisplayName {$DisplayName}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
                -InboundParameters $PSBoundParameters `
                -ErrorAction Stop

            #Ensure the proper dependencies are installed in the current environment.
            Confirm-M365DSCDependencies

            #region Telemetry
            $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
            $CommandName = $MyInvocation.MyCommand
            $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
                -CommandName $CommandName `
                -Parameters $PSBoundParameters
            Add-M365DSCTelemetryEvent -Data $data
            #endregion

            $nullResult = $PSBoundParameters
            $nullResult.Ensure = 'Absent'

            $templateReferences = 'd948ff9b-99cb-4ee0-8012-1fbc09685377_1', 'e3f74c5a-a6de-411d-aef6-eb15628f3a0a_1', '45fea5e9-280d-4da1-9792-fb5736da0ca9_1', '804339ad-1553-4478-a742-138fb5807418_1'

            # Retrieve policy general settings
            $policy = $null
            if (-not [System.String]::IsNullOrEmpty($Identity))
            {
                $policy = Get-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $Identity -ErrorAction SilentlyContinue
            }

            if ($null -eq $policy)
            {
                Write-Verbose -Message "Could not find an Intune Antivirus Policy for Windows10 Setting Catalog with Id {$Identity}"

                if (-not [System.String]::IsNullOrEmpty($DisplayName))
                {
                    $policy = Get-MgBetaDeviceManagementConfigurationPolicy `
                        -All `
                        -Filter "Name eq '$($DisplayName -replace "'", "''")'" `
                        -ErrorAction SilentlyContinue | Where-Object `
                        -FilterScript {
                            $_.TemplateReference.TemplateId -in $templateReferences
                        }

                    if ($policy.Length -gt 1)
                    {
                        throw "Duplicate Intune Antivirus Policy for Windows10 Setting Catalog named $DisplayName exist in tenant"
                    }
                }
            }

            if ($null -eq $policy)
            {
                Write-Verbose -Message "Could not find an Intune Antivirus Policy for Windows10 Setting Catalog with Name {$DisplayName}"
                return $nullResult
            }
        }
        else
        {
            $policy = $Script:exportedInstance
        }
        $Identity = $policy.Id
        Write-Verbose -Message "An Intune Antivirus Policy for Windows10 Setting Catalog with Id {$Identity} and Name {$DisplayName} was found."

        #Retrieve policy specific settings
        [array]$settings = Get-MgBetaDeviceManagementConfigurationPolicySetting `
            -DeviceManagementConfigurationPolicyId $Identity `
            -ExpandProperty 'settingDefinitions' `
            -All `
            -ErrorAction Stop

        $policySettings = @{}
        $policySettings = Export-IntuneSettingCatalogPolicySettings -Settings $settings -ReturnHashtable $policySettings

        $returnHashtable = @{}
        $returnHashtable.Add('Identity', $Identity)
        $returnHashtable.Add('DisplayName', $policy.name)
        $returnHashtable.Add('Description', $policy.description)
        $returnHashtable.Add('RoleScopeTagIds', $policy.roleScopeTagIds)
        $returnHashtable.Add('TemplateId', $policy.templateReference.TemplateId)

        if ($null -ne $policySettings.SevereThreatDefaultAction)
        {
            $returnHashtable.Add('SevereThreats', $policySettings.SevereThreatDefaultAction)
            $policySettings.Remove('SevereThreatDefaultAction')
        }
        if ($null -ne $policySettings.HighSeverityThreatDefaultAction)
        {
            $returnHashtable.Add('HighSeverityThreats', $policySettings.HighSeverityThreatDefaultAction)
            $policySettings.Remove('HighSeverityThreatDefaultAction')
        }
        if ($null -ne $policySettings.ModerateSeverityThreatDefaultAction)
        {
            $returnHashtable.Add('ModerateSeverityThreats', $policySettings.ModerateSeverityThreatDefaultAction)
            $policySettings.Remove('ModerateSeverityThreatDefaultAction')
        }
        if ($null -ne $policySettings.LowSeverityThreatDefaultAction)
        {
            $returnHashtable.Add('LowSeverityThreats', $policySettings.LowSeverityThreatDefaultAction)
            $policySettings.Remove('LowSeverityThreatDefaultAction')
        }
        if ($policySettings.ContainsKey('EnableDnsSinkhole'))
        {
            Write-Warning -Message "The setting 'EnableDnsSinkhole' is deprecated and will be ignored."
            $policySettings.Remove('EnableDnsSinkhole') | Out-Null
        }
        $returnHashtable += $policySettings

        $returnAssignments = @()
        $graphAssignments = Get-MgBetaDeviceManagementConfigurationPolicyAssignment -DeviceManagementConfigurationPolicyId $Identity
        if ($graphAssignments.Count -gt 0)
        {
            $returnAssignments += ConvertFrom-IntunePolicyAssignment `
                -IncludeDeviceFilter:$true `
                -Assignments ($graphAssignments)
        }
        $returnHashtable.Add('Assignments', $returnAssignments)

        $returnHashtable.Add('Ensure', 'Present')
        $returnHashtable.Add('Credential', $Credential)
        $returnHashtable.Add('ApplicationId', $ApplicationId)
        $returnHashtable.Add('TenantId', $TenantId)
        $returnHashtable.Add('ApplicationSecret', $ApplicationSecret)
        $returnHashtable.Add('CertificateThumbprint', $CertificateThumbprint)
        $returnHashtable.Add('ManagedIdentity', $ManagedIdentity.IsPresent)
        $returnHashtable.Add('AccessTokens', $AccessTokens)

        return $returnHashtable
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
        $Identity,

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
        $AllowDatagramProcessingOnWinServer,

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
        $AllowNetworkProtectionDownLevel,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowOnAccessProtection,

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
        [System.Int32]
        $AvgCPULoadFactor,

        [Parameter()]
        [System.Int32]
        $ArchiveMaxDepth,

        [Parameter()]
        [System.Int32]
        $ArchiveMaxSize,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $CheckForSignaturesBeforeRunningScan,

        [Parameter()]
        [ValidateSet(0, 2, 4, 6)]
        [System.Int32]
        $CloudBlockLevel,

        [Parameter()]
        [System.Int32]
        $CloudExtendedTimeout,

        [Parameter()]
        [System.String]
        $CompanyName,

        [Parameter()]
        [System.Int32]
        $DaysToRetainCleanedMalware,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableAccountProtectionUI,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableAppBrowserUI,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableClearTpmButton,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableDeviceSecurityUI,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableDnsOverTcpParsing,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableEnhancedNotifications,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableFamilyUI,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableHealthUI,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableHttpParsing,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableSshParsing,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableNetworkUI,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableTpmFirmwareUpdateWarning,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableVirusUI,

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
        [System.Int32[]]
        $DisableCoreServiceECSIntegration,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32[]]
        $DisableCoreServiceTelemetry,

        [Parameter()]
        [System.String]
        $Email,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $EnableCustomizedToasts,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $EnableInAppCustomization,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $EnableLowCPUPriority,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $EnableNetworkProtection,

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
        [ValidateSet(0, 1)]
        [System.Int32]
        $HideRansomwareDataRecovery,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $HideWindowsSecurityNotificationAreaControl,

        [Parameter()]
        [System.String]
        $Phone,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $PUAProtection,

        [Parameter()]
        [ValidateSet(0, 2, 3, 4, 5, 6)]
        [System.Int32]
        $EngineUpdatesChannel,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $MeteredConnectionUpdates,

        [Parameter()]
        [ValidateSet(0, 2, 3, 4, 5, 6)]
        [System.Int32]
        $PlatformUpdatesChannel,

        [Parameter()]
        [ValidateSet(0, 4, 5)]
        [System.Int32]
        $SecurityIntelligenceUpdatesChannel,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $RealTimeScanDirection,

        [Parameter()]
        [ValidateSet(1, 2)]
        [System.Int32]
        $ScanParameter,

        [Parameter()]
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
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableTlsParsing,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $RandomizeScheduleTaskTimes,

        [Parameter()]
        [ValidateRange(1, 23)]
        [System.Int32]
        $SchedulerRandomizationTime,

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
        [ValidateSet('Onboarding', 'Offboarding', 'ControlledConfig_Onboarding')]
        [System.String]
        $ControlledConfiguration,

        [Parameter()]
        [ValidateSet('Onboarding', 'Offboarding')]
        [System.String]
        $TamperProtection,

        [Parameter()]
        [System.String]
        $URL,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableLocalAdminMerge,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $LowSeverityThreats,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $ModerateSeverityThreats,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $SevereThreats,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $HighSeverityThreats,

        [Parameter()]
        [ValidateSet('d948ff9b-99cb-4ee0-8012-1fbc09685377_1', 'e3f74c5a-a6de-411d-aef6-eb15628f3a0a_1', '45fea5e9-280d-4da1-9792-fb5736da0ca9_1', '804339ad-1553-4478-a742-138fb5807418_1')]
        [System.String]
        $TemplateId,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration of the Intune Antivirus Policy for Windows10 Setting Catalog with Id {$Identity} and DisplayName {$DisplayName}"

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentPolicy = Get-TargetResource @PSBoundParameters
    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($BoundParameters.ContainsKey('TamperProtection'))
    {
        $BoundParameters['ControlledConfiguration'] = $BoundParameters['TamperProtection']
        $BoundParameters.Remove('TamperProtection')
    }

    if ($BoundParameters.ContainsKey('SevereThreats'))
    {
        $BoundParameters.Add('SevereThreatDefaultAction', $BoundParameters['SevereThreats'])
        $BoundParameters.Remove('SevereThreats')
    }
    if ($BoundParameters.ContainsKey('HighSeverityThreats'))
    {
        $BoundParameters.Add('HighSeverityThreatDefaultAction', $BoundParameters['HighSeverityThreats'])
        $BoundParameters.Remove('HighSeverityThreats')
    }
    if ($BoundParameters.ContainsKey('ModerateSeverityThreats'))
    {
        $BoundParameters.Add('ModerateSeverityThreatDefaultAction', $BoundParameters['ModerateSeverityThreats'])
        $BoundParameters.Remove('ModerateSeverityThreats')
    }
    if ($BoundParameters.ContainsKey('LowSeverityThreats'))
    {
        $BoundParameters.Add('LowSeverityThreatDefaultAction', $BoundParameters['LowSeverityThreats'])
        $BoundParameters.Remove('LowSeverityThreats')
    }

    $templateReferenceId = $TemplateId
    $platforms = 'windows10'
    $technologies = 'mdm,microsoftSense'

    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Endpoint Protection Policy {$DisplayName}"
        $BoundParameters.Remove('Identity') | Out-Null
        $BoundParameters.Remove('Assignments') | Out-Null

        $settings = Get-IntuneSettingCatalogPolicySetting `
            -DSCParams ([System.Collections.Hashtable]$BoundParameters) `
            -TemplateId $templateReferenceId

        $createParameters = @{
            Name              = $DisplayName
            Description       = $Description
            TemplateReference = @{ templateId = $templateReferenceId }
            Platforms         = $platforms
            Technologies      = $technologies
            Settings          = $settings
            RoleScopeTagIds   = $RoleScopeTagIds
        }

        $policy = New-MgBetaDeviceManagementConfigurationPolicy -BodyParameter $createParameters

        if ($policy.Id)
        {
            $assignmentsHash = ConvertTo-IntunePolicyAssignment -Assignments $Assignments -IncludeDeviceFilter:$true
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $policy.Id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/configurationPolicies'
        }
    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Endpoint Protection Policy {$($currentPolicy.DisplayName)}"
        $BoundParameters.Remove('Identity') | Out-Null
        $BoundParameters.Remove('Assignments') | Out-Null
        $BoundParameters.Remove('TemplateId') | Out-Null

        $settings = Get-IntuneSettingCatalogPolicySetting `
            -DSCParams ([System.Collections.Hashtable]$BoundParameters) `
            -TemplateId $templateReferenceId

        Update-IntuneDeviceConfigurationPolicy `
            -DeviceConfigurationPolicyId $currentPolicy.Identity `
            -Name $DisplayName `
            -Description $Description `
            -TemplateReferenceId $templateReferenceId `
            -Platforms $platforms `
            -Technologies $technologies `
            -Settings $settings `
            -RoleScopeTagIds $RoleScopeTagIds

        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentPolicy.Identity `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/configurationPolicies'
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Endpoint Protection Policy {$($currentPolicy.DisplayName)}"
        Remove-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $currentPolicy.Identity
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
        $Identity,

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
        $AllowDatagramProcessingOnWinServer,

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
        $AllowNetworkProtectionDownLevel,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $AllowOnAccessProtection,

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
        [System.Int32]
        $AvgCPULoadFactor,

        [Parameter()]
        [System.Int32]
        $ArchiveMaxDepth,

        [Parameter()]
        [System.Int32]
        $ArchiveMaxSize,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $CheckForSignaturesBeforeRunningScan,

        [Parameter()]
        [ValidateSet(0, 2, 4, 6)]
        [System.Int32]
        $CloudBlockLevel,

        [Parameter()]
        [System.Int32]
        $CloudExtendedTimeout,

        [Parameter()]
        [System.String]
        $CompanyName,

        [Parameter()]
        [System.Int32]
        $DaysToRetainCleanedMalware,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableAccountProtectionUI,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableAppBrowserUI,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableClearTpmButton,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableDeviceSecurityUI,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableDnsOverTcpParsing,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableEnhancedNotifications,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableFamilyUI,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableHealthUI,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableHttpParsing,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableSshParsing,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableNetworkUI,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableTpmFirmwareUpdateWarning,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableVirusUI,

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
        [System.Int32[]]
        $DisableCoreServiceECSIntegration,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32[]]
        $DisableCoreServiceTelemetry,

        [Parameter()]
        [System.String]
        $Email,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $EnableCustomizedToasts,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $EnableInAppCustomization,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $EnableLowCPUPriority,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $EnableNetworkProtection,

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
        [ValidateSet(0, 1)]
        [System.Int32]
        $HideRansomwareDataRecovery,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $HideWindowsSecurityNotificationAreaControl,

        [Parameter()]
        [System.String]
        $Phone,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $PUAProtection,

        [Parameter()]
        [ValidateSet(0, 2, 3, 4, 5, 6)]
        [System.Int32]
        $EngineUpdatesChannel,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $MeteredConnectionUpdates,

        [Parameter()]
        [ValidateSet(0, 2, 3, 4, 5, 6)]
        [System.Int32]
        $PlatformUpdatesChannel,

        [Parameter()]
        [ValidateSet(0, 4, 5)]
        [System.Int32]
        $SecurityIntelligenceUpdatesChannel,

        [Parameter()]
        [ValidateSet(0, 1, 2)]
        [System.Int32]
        $RealTimeScanDirection,

        [Parameter()]
        [ValidateSet(1, 2)]
        [System.Int32]
        $ScanParameter,

        [Parameter()]
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
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableTlsParsing,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $RandomizeScheduleTaskTimes,

        [Parameter()]
        [ValidateRange(1, 23)]
        [System.Int32]
        $SchedulerRandomizationTime,

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
        [ValidateSet('Onboarding', 'Offboarding', 'ControlledConfig_Onboarding')]
        [System.String]
        $ControlledConfiguration,

        [Parameter()]
        [ValidateSet('Onboarding', 'Offboarding')]
        [System.String]
        $TamperProtection,

        [Parameter()]
        [System.String]
        $URL,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableLocalAdminMerge,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $LowSeverityThreats,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $ModerateSeverityThreats,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $SevereThreats,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $HighSeverityThreats,

        [Parameter()]
        [ValidateSet('d948ff9b-99cb-4ee0-8012-1fbc09685377_1', 'e3f74c5a-a6de-411d-aef6-eb15628f3a0a_1', '45fea5e9-280d-4da1-9792-fb5736da0ca9_1', '804339ad-1553-4478-a742-138fb5807418_1')]
        [System.String]
        $TemplateId,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $dscContent = ''
    $i = 1

    try
    {
        $templateFamily = 'endpointSecurityAntivirus'
        $templateReferences = 'd948ff9b-99cb-4ee0-8012-1fbc09685377_1', 'e3f74c5a-a6de-411d-aef6-eb15628f3a0a_1', '45fea5e9-280d-4da1-9792-fb5736da0ca9_1', '804339ad-1553-4478-a742-138fb5807418_1'
        $baseFilter = foreach ($templateReference in $templateReferences)
        {
            "templateReference/templateId eq '$templateReference'"
        }
        $baseFilter = $baseFilter -join ' or '
        $baseFilter = "($baseFilter) and templateReference/templateFamily eq '$templateFamily'"
        if (-not [System.String]::IsNullOrEmpty($Filter))
        {
            $Filter = "($Filter) and ($baseFilter)"
        }
        else
        {
            $Filter = $baseFilter
        }
        [array]$policies = Get-MgBetaDeviceManagementConfigurationPolicy `
            -Filter $Filter `
            -All `
            -ErrorAction Stop

        if ($policies.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($policy in $policies)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($policies.Count)] $($policy.Name)" -DeferWrite

            $params = @{
                Identity              = $policy.Id
                DisplayName           = $policy.Name
                TemplateId            = $policy.TemplateReference.TemplateId
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $policy
            $Results = Get-TargetResource @params

            if ($Results.Assignments)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ([Array]$Results.Assignments) -CIMInstanceName DeviceManagementConfigurationPolicyAssignments
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

            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            $i++
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

function Get-CompareParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    return @{
        PostProcessing     = {
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

            # Map the renaming of TamperProtection to ControlledConfiguration for comparison
            if ($DesiredValues.ContainsKey('TamperProtection'))
            {
                $DesiredValues['ControlledConfiguration'] = $DesiredValues['TamperProtection']
                $DesiredValues.Remove('TamperProtection')
            }
            if ($CurrentValues.ContainsKey('TamperProtection'))
            {
                $CurrentValues['ControlledConfiguration'] = $CurrentValues['TamperProtection']
                $CurrentValues.Remove('TamperProtection')
            }

            return [System.Tuple[Hashtable, Hashtable, Hashtable]]::new($DesiredValues, $CurrentValues, $ValuesToCheck)
        }
        PostProcessingArgs = $MyInvocation.MyCommand.Parameters.GetEnumerator()
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
