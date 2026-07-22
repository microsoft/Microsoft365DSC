Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneAntivirusPolicyLinux'

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
        [ValidateSet('false', 'true')]
        [System.String]
        $enabled,

        [Parameter()]
        [ValidateSet('none', 'safe', 'all')]
        [System.String]
        $automaticSampleSubmissionConsent,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $diagnosticLevel,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $automaticDefinitionUpdateEnabled,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $enableRealTimeProtection,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $passiveMode,

        [Parameter()]
        [ValidateRange(5000, 15000)]
        [System.Int32]
        $scanHistoryMaximumItems,

        [Parameter()]
        [ValidateRange(1, 180)]
        [System.Int32]
        $scanResultsRetentionDays,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $exclusionsMergePolicy,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $exclusions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $threatTypeSettings,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $threatTypeSettingsMergePolicy,

        [Parameter()]
        [System.String[]]
        $allowedThreats,

        [Parameter()]
        [System.String[]]
        $disallowedThreatActions,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $scanArchives,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $scanAfterDefinitionUpdate,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $enableFileHashComputation,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $behaviorMonitoring,

        [Parameter()]
        [ValidateSet('normal', 'moderate', 'high', 'plus', 'tolerance')]
        [System.String]
        $cloudBlockLevel,

        [Parameter()]
        [ValidateRange(1, 64)]
        [System.Int32]
        $maximumOnDemandScanThreads,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $networkprotection_enforcementLevel,

        [Parameter()]
        [System.String[]]
        $unmonitoredFilesystems,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $nonExecMountPolicy,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $antivirusengine_enforcementLevel,

        [Parameter()]
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $antivirusengine_offlineDefinitionUpdate,

        [Parameter()]
        [ValidateRange(0, 86400)]
        [System.Int32]
        $definitionUpdatesInterval,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $offlinedefinitionupdatefallbacktocloud,

        [Parameter()]
        [System.String]
        $offlinedefinitionupdateurl,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $scheduledScan_checkForDefinitionsUpdate,

        [Parameter()]
        [ValidateRange(0, 1380)]
        [System.Int32]
        $scheduledScan_dailyConfiguration_timeOfDay,

        [Parameter()]
        [ValidateSet('0', '1', '2', '3', '4', '5', '6', '7', '8')]
        [System.String]
        $scheduledScan_dayOfWeek,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $scheduledScan_ignoreExclusions,

        [Parameter()]
        [ValidateRange(0, 24)]
        [System.Int32]
        $scheduledScan_interval,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $scheduledScan_lowPriorityScheduledScan,

        [Parameter()]
        [ValidateRange(0, 23)]
        [System.Int32]
        $scheduledScan_randomizeScanStartTime,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $scheduledScan_runScanWhenIdle,

        [Parameter()]
        [ValidateSet('quick', 'full')]
        [System.String]
        $scheduledScan_scanType,

        [Parameter()]
        [ValidateRange(0, 1380)]
        [System.Int32]
        $scheduledScan_weeklyConfiguration_timeOfDay,

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

    Write-Verbose -Message "Getting configuration of the Intune Antivirus Policy for Linux with Id {$Id} and DisplayName {$DisplayName}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Name -ne $DisplayName)
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
                $getValue = Get-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $Id -ErrorAction SilentlyContinue `
                    -ExpandProperty 'settings($expand=settingDefinitions)'
                $settings = $getValue.settings
            }

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Antivirus Policy for Linux with Id {$Id}"

                if (-not [System.String]::IsNullOrEmpty($DisplayName))
                {
                    $getValue = Get-MgBetaDeviceManagementConfigurationPolicy `
                        -All `
                        -Filter "Name eq '$($DisplayName -replace "'", "''")'" `
                        -ErrorAction SilentlyContinue

                    if ($getValue.Length -gt 1)
                    {
                        throw "Duplicate Intune Antivirus Policy for Linux named $DisplayName exist in tenant"
                    }
                }
            }
            #endregion
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Antivirus Policy for Linux with Name {$DisplayName}."
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
            $settings = $getValue.settings
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Antivirus Policy for Linux with Id {$Id} and Name {$DisplayName} was found"

        # Retrieve policy specific settings
        if ($null -eq $settings)
        {
            [array]$settings = Get-MgBetaDeviceManagementConfigurationPolicySetting `
                -DeviceManagementConfigurationPolicyId $Id `
                -ExpandProperty 'settingDefinitions' `
                -All `
                -ErrorAction Stop
        }
        [array]$settingDefinitions = (Get-MgBetaDeviceManagementConfigurationPolicyTemplateSettingTemplate `
            -DeviceManagementConfigurationPolicyTemplateId $getValue.TemplateReference.TemplateId `
            -ExpandProperty 'settingDefinitions' `
            -All `
            -ErrorAction Stop).SettingDefinitions

        $policySettings = @{}
        $policySettings = Export-IntuneSettingCatalogPolicySettings -Settings $settings -ReturnHashtable $policySettings -AllSettingDefinitions $settingDefinitions

        #region resource generator code
        $complexExclusions = @()
        foreach ($currentExclusions in $policySettings.exclusions)
        {
            $myExclusions = [ordered]@{}
            if ($null -ne $currentExclusions.exclusions_item_type)
            {
                $myExclusions.Add('Exclusions_item_type', $currentExclusions.exclusions_item_type)
            }
            if ($null -ne $currentExclusions.exclusions_item_extension)
            {
                $myExclusions.Add('Exclusions_item_extension', $currentExclusions.exclusions_item_extension)
            }
            if ($null -ne $currentExclusions.exclusions_item_name)
            {
                $myExclusions.Add('Exclusions_item_name', $currentExclusions.exclusions_item_name)
            }
            if ($null -ne $currentExclusions.exclusions_item_path)
            {
                $myExclusions.Add('Exclusions_item_path', $currentExclusions.exclusions_item_path)
            }
            if ($null -ne $currentExclusions.exclusions_item_isDirectory)
            {
                $myExclusions.Add('Exclusions_item_isDirectory', $currentExclusions.exclusions_item_isDirectory)
            }
            if ($myExclusions.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexExclusions += $myExclusions
            }
        }
        $policySettings.Remove('exclusions') | Out-Null

        $complexThreatTypeSettings = @()
        foreach ($currentThreatTypeSettings in $policySettings.threatTypeSettings)
        {
            $myThreatTypeSettings = [ordered]@{}
            if ($null -ne $currentThreatTypeSettings.threatTypeSettings_item_key)
            {
                $myThreatTypeSettings.Add('ThreatTypeSettings_item_key', $currentThreatTypeSettings.threatTypeSettings_item_key)
            }
            if ($null -ne $currentThreatTypeSettings.threatTypeSettings_item_value)
            {
                $myThreatTypeSettings.Add('ThreatTypeSettings_item_value', $currentThreatTypeSettings.threatTypeSettings_item_value)
            }
            if ($myThreatTypeSettings.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexThreatTypeSettings += $myThreatTypeSettings
            }
        }
        $policySettings.Remove('threatTypeSettings') | Out-Null
        #endregion

        # TODO: Remove during next breaking change and update mof schema
        if ($policySettings.ContainsKey('diagnosticLevel'))
        {
            switch ($policySettings.diagnosticLevel)
            {
                'optional' { $policySettings.diagnosticLevel = '0' }
                'required' { $policySettings.diagnosticLevel = '1' }
            }
        }
        if ($policySettings.ContainsKey('exclusionsMergePolicy'))
        {
            switch ($policySettings.exclusionsMergePolicy)
            {
                'merge' { $policySettings.exclusionsMergePolicy = '0' }
                'admin_only' { $policySettings.exclusionsMergePolicy = '1' }
            }
        }
        if ($policySettings.ContainsKey('threatTypeSettingsMergePolicy'))
        {
            switch ($policySettings.threatTypeSettingsMergePolicy)
            {
                'merge' { $policySettings.threatTypeSettingsMergePolicy = '0' }
                'admin_only' { $policySettings.threatTypeSettingsMergePolicy = '1' }
            }
        }
        if ($policySettings.ContainsKey('behaviorMonitoring'))
        {
            switch ($policySettings.behaviorMonitoring)
            {
                'disabled' { $policySettings.behaviorMonitoring = '0' }
                'enabled' { $policySettings.behaviorMonitoring = '1' }
            }
        }
        if ($policySettings.ContainsKey('networkprotection_enforcementLevel'))
        {
            switch ($policySettings.networkprotection_enforcementLevel)
            {
                'disabled' { $policySettings.networkprotection_enforcementLevel = '0' }
                'audit' { $policySettings.networkprotection_enforcementLevel = '1' }
                'block' { $policySettings.networkprotection_enforcementLevel = '2' }
            }
        }
        if ($policySettings.ContainsKey('nonExecMountPolicy'))
        {
            switch ($policySettings.nonExecMountPolicy)
            {
                'unmute' { $policySettings.nonExecMountPolicy = '0' }
                'mute' { $policySettings.nonExecMountPolicy = '1' }
            }
        }
        if ($policySettings.ContainsKey('antivirusengine_enforcementLevel'))
        {
            switch ($policySettings.antivirusengine_enforcementLevel)
            {
                'real_time' { $policySettings.antivirusengine_enforcementLevel = '0' }
                'on_demand' { $policySettings.antivirusengine_enforcementLevel = '1' }
                'passive' { $policySettings.antivirusengine_enforcementLevel = '2' }
            }
        }

        $results = @{
            #region resource generator code
            Description           = $getValue.Description
            DisplayName           = $getValue.Name
            RoleScopeTagIds       = $getValue.RoleScopeTagIds
            Id                    = $getValue.Id
            exclusions            = $complexExclusions
            threatTypeSettings    = $complexThreatTypeSettings
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            CertificatePath       = $CertificatePath
            CertificatePassword   = $CertificatePassword
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
        [ValidateSet('false', 'true')]
        [System.String]
        $enabled,

        [Parameter()]
        [ValidateSet('none', 'safe', 'all')]
        [System.String]
        $automaticSampleSubmissionConsent,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $diagnosticLevel,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $automaticDefinitionUpdateEnabled,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $enableRealTimeProtection,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $passiveMode,

        [Parameter()]
        [ValidateRange(5000, 15000)]
        [System.Int32]
        $scanHistoryMaximumItems,

        [Parameter()]
        [ValidateRange(1, 180)]
        [System.Int32]
        $scanResultsRetentionDays,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $exclusionsMergePolicy,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $exclusions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $threatTypeSettings,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $threatTypeSettingsMergePolicy,

        [Parameter()]
        [System.String[]]
        $allowedThreats,

        [Parameter()]
        [System.String[]]
        $disallowedThreatActions,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $scanArchives,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $scanAfterDefinitionUpdate,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $enableFileHashComputation,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $behaviorMonitoring,

        [Parameter()]
        [ValidateSet('normal', 'moderate', 'high', 'plus', 'tolerance')]
        [System.String]
        $cloudBlockLevel,

        [Parameter()]
        [ValidateRange(1, 64)]
        [System.Int32]
        $maximumOnDemandScanThreads,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $networkprotection_enforcementLevel,

        [Parameter()]
        [System.String[]]
        $unmonitoredFilesystems,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $nonExecMountPolicy,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $antivirusengine_enforcementLevel,

        [Parameter()]
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $antivirusengine_offlineDefinitionUpdate,

        [Parameter()]
        [ValidateRange(0, 86400)]
        [System.Int32]
        $definitionUpdatesInterval,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $offlinedefinitionupdatefallbacktocloud,

        [Parameter()]
        [System.String]
        $offlinedefinitionupdateurl,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $scheduledScan_checkForDefinitionsUpdate,

        [Parameter()]
        [ValidateRange(0, 1380)]
        [System.Int32]
        $scheduledScan_dailyConfiguration_timeOfDay,

        [Parameter()]
        [ValidateSet('0', '1', '2', '3', '4', '5', '6', '7', '8')]
        [System.String]
        $scheduledScan_dayOfWeek,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $scheduledScan_ignoreExclusions,

        [Parameter()]
        [ValidateRange(0, 24)]
        [System.Int32]
        $scheduledScan_interval,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $scheduledScan_lowPriorityScheduledScan,

        [Parameter()]
        [ValidateRange(0, 23)]
        [System.Int32]
        $scheduledScan_randomizeScanStartTime,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $scheduledScan_runScanWhenIdle,

        [Parameter()]
        [ValidateSet('quick', 'full')]
        [System.String]
        $scheduledScan_scanType,

        [Parameter()]
        [ValidateRange(0, 1380)]
        [System.Int32]
        $scheduledScan_weeklyConfiguration_timeOfDay,

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

    $templateReferenceId = '4cfd164c-5e8a-4ea9-b15d-9aa71e4ffff4_1'
    $platforms = 'linux'
    $technologies = 'microsoftSense'

    # TODO: Remove during next breaking change and update mof schema
    if ($boundParameters.ContainsKey('diagnosticLevel'))
    {
        switch ($boundParameters.diagnosticLevel)
        {
            '0' { $boundParameters.diagnosticLevel = 'optional' }
            '1' { $boundParameters.diagnosticLevel = 'required' }
        }
    }
    if ($boundParameters.ContainsKey('exclusionsMergePolicy'))
    {
        switch ($boundParameters.exclusionsMergePolicy)
        {
            '0' { $boundParameters.exclusionsMergePolicy = 'merge' }
            '1' { $boundParameters.exclusionsMergePolicy = 'admin_only' }
        }
    }
    if ($boundParameters.ContainsKey('threatTypeSettingsMergePolicy'))
    {
        switch ($boundParameters.threatTypeSettingsMergePolicy)
        {
            '0' { $boundParameters.threatTypeSettingsMergePolicy = 'merge' }
            '1' { $boundParameters.threatTypeSettingsMergePolicy = 'admin_only' }
        }
    }
    if ($boundParameters.ContainsKey('behaviorMonitoring'))
    {
        switch ($boundParameters.behaviorMonitoring)
        {
            '0' { $boundParameters.behaviorMonitoring = 'disabled' }
            '1' { $boundParameters.behaviorMonitoring = 'enabled' }
        }
    }
    if ($boundParameters.ContainsKey('networkprotection_enforcementLevel'))
    {
        switch ($boundParameters.networkprotection_enforcementLevel)
        {
            '0' { $boundParameters.networkprotection_enforcementLevel = 'disabled' }
            '1' { $boundParameters.networkprotection_enforcementLevel = 'audit' }
            '2' { $boundParameters.networkprotection_enforcementLevel = 'block' }
        }
    }
    if ($boundParameters.ContainsKey('nonExecMountPolicy'))
    {
        switch ($boundParameters.nonExecMountPolicy)
        {
            '0' { $boundParameters.nonExecMountPolicy = 'unmute' }
            '1' { $boundParameters.nonExecMountPolicy = 'mute' }
        }
    }
    if ($boundParameters.ContainsKey('antivirusengine_enforcementLevel'))
    {
        switch ($boundParameters.antivirusengine_enforcementLevel)
        {
            '0' { $boundParameters.antivirusengine_enforcementLevel = 'real_time' }
            '1' { $boundParameters.antivirusengine_enforcementLevel = 'on_demand' }
            '2' { $boundParameters.antivirusengine_enforcementLevel = 'passive' }
        }
    }

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Antivirus Policy for Linux with Name {$DisplayName}"
        $BoundParameters.Remove('Assignments') | Out-Null

        $settings = Get-IntuneSettingCatalogPolicySetting `
            -DSCParams ([System.Collections.Hashtable]$BoundParameters) `
            -TemplateId $templateReferenceId

        $createParameters = @{
            name              = $DisplayName
            description       = $Description
            templateReference = @{ templateId = $templateReferenceId }
            platforms         = $platforms
            technologies      = $technologies
            settings          = $settings
            roleScopeTagIds   = $RoleScopeTagIds
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
        Write-Verbose -Message "Updating the Intune Antivirus Policy for Linux with Id {$($currentInstance.Id)}"
        $BoundParameters.Remove('Assignments') | Out-Null

        $settings = Get-IntuneSettingCatalogPolicySetting `
            -DSCParams ([System.Collections.Hashtable]$BoundParameters) `
            -TemplateId $templateReferenceId

        Update-IntuneDeviceConfigurationPolicy `
            -DeviceConfigurationPolicyId $currentInstance.Id `
            -Name $DisplayName `
            -Description $Description `
            -TemplateReferenceId $templateReferenceId `
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
        Write-Verbose -Message "Removing the Intune Antivirus Policy for Linux with Id {$($currentInstance.Id)}"
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
        [ValidateSet('false', 'true')]
        [System.String]
        $enabled,

        [Parameter()]
        [ValidateSet('none', 'safe', 'all')]
        [System.String]
        $automaticSampleSubmissionConsent,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $diagnosticLevel,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $automaticDefinitionUpdateEnabled,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $enableRealTimeProtection,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $passiveMode,

        [Parameter()]
        [ValidateRange(5000, 15000)]
        [System.Int32]
        $scanHistoryMaximumItems,

        [Parameter()]
        [ValidateRange(1, 180)]
        [System.Int32]
        $scanResultsRetentionDays,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $exclusionsMergePolicy,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $exclusions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $threatTypeSettings,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $threatTypeSettingsMergePolicy,

        [Parameter()]
        [System.String[]]
        $allowedThreats,

        [Parameter()]
        [System.String[]]
        $disallowedThreatActions,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $scanArchives,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $scanAfterDefinitionUpdate,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $enableFileHashComputation,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $behaviorMonitoring,

        [Parameter()]
        [ValidateSet('normal', 'moderate', 'high', 'plus', 'tolerance')]
        [System.String]
        $cloudBlockLevel,

        [Parameter()]
        [ValidateRange(1, 64)]
        [System.Int32]
        $maximumOnDemandScanThreads,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $networkprotection_enforcementLevel,

        [Parameter()]
        [System.String[]]
        $unmonitoredFilesystems,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $nonExecMountPolicy,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $antivirusengine_enforcementLevel,

        [Parameter()]
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $antivirusengine_offlineDefinitionUpdate,

        [Parameter()]
        [ValidateRange(0, 86400)]
        [System.Int32]
        $definitionUpdatesInterval,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $offlinedefinitionupdatefallbacktocloud,

        [Parameter()]
        [System.String]
        $offlinedefinitionupdateurl,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $scheduledScan_checkForDefinitionsUpdate,

        [Parameter()]
        [ValidateRange(0, 1380)]
        [System.Int32]
        $scheduledScan_dailyConfiguration_timeOfDay,

        [Parameter()]
        [ValidateSet('0', '1', '2', '3', '4', '5', '6', '7', '8')]
        [System.String]
        $scheduledScan_dayOfWeek,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $scheduledScan_ignoreExclusions,

        [Parameter()]
        [ValidateRange(0, 24)]
        [System.Int32]
        $scheduledScan_interval,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $scheduledScan_lowPriorityScheduledScan,

        [Parameter()]
        [ValidateRange(0, 23)]
        [System.Int32]
        $scheduledScan_randomizeScanStartTime,

        [Parameter()]
        [ValidateSet('false', 'true')]
        [System.String]
        $scheduledScan_runScanWhenIdle,

        [Parameter()]
        [ValidateSet('quick', 'full')]
        [System.String]
        $scheduledScan_scanType,

        [Parameter()]
        [ValidateRange(0, 1380)]
        [System.Int32]
        $scheduledScan_weeklyConfiguration_timeOfDay,

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
        $policyTemplateID = '4cfd164c-5e8a-4ea9-b15d-9aa71e4ffff4_1'
        $baseFilter = "templateReference/templateId eq '$policyTemplateID'"
        if (-not [System.String]::IsNullOrEmpty($Filter))
        {
            $Filter = "($Filter) and ($baseFilter)"
        }
        else
        {
            $Filter = $baseFilter
        }
        [array]$getValue = Get-M365DSCExportCachedConfigurationPolicies `
            -TemplateId $policyTemplateID `
            -Filter $Filter
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
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params
            $rawResults = $Results.Clone()

            if ($null -ne $Results.exclusions)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.exclusions `
                    -CIMInstanceName 'MicrosoftGraphIntuneSettingsCatalogExclusions' -IsArray
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.exclusions = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('exclusions') | Out-Null
                }
            }
            if ($null -ne $Results.threatTypeSettings)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.threatTypeSettings `
                    -CIMInstanceName 'MicrosoftGraphIntuneSettingsCatalogThreatTypeSettings' -IsArray
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.threatTypeSettings = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('threatTypeSettings') | Out-Null
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
                -NoEscape @('exclusions', 'threatTypeSettings', 'Assignments') `
                -RawResults $rawResults

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

            return [System.Tuple[Hashtable, Hashtable, Hashtable]]::new($DesiredValues, $CurrentValues, $ValuesToCheck)
        }
        PostProcessingArgs = $MyInvocation.MyCommand.Parameters.GetEnumerator()
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
