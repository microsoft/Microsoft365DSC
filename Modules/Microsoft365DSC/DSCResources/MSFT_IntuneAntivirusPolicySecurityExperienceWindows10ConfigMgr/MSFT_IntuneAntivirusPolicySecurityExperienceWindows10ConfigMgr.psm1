Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneAntivirusPolicySecurityExperienceWindows10ConfigMgr'

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
        $DisableFamilyUI,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableHealthUI,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableNetworkUI,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableNotifications,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableEnhancedNotifications,

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
        $HideRansomwareDataRecovery,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $HideWindowsSecurityNotificationAreaControl,

        [Parameter()]
        [System.String]
        $CompanyName,

        [Parameter()]
        [System.String]
        $Email,

        [Parameter()]
        [System.String]
        $Phone,

        [Parameter()]
        [System.String]
        $URL,

        [Parameter()]
        [ValidateSet('1', '0')]
        [System.String]
        $TamperProtection,

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

    Write-Verbose -Message "Getting configuration for the Intune Antivirus Policy Security Experience for Windows10 Config Mgr with Id {$Id} and DisplayName {$DisplayName}"

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
                Write-Verbose -Message "Could not find an Intune Antivirus Policy Security Experience for Windows10 Config Mgr with Id {$Id}"

                if (-not [System.String]::IsNullOrEmpty($DisplayName))
                {
                    $getValue = Get-MgBetaDeviceManagementConfigurationPolicy `
                        -All `
                        -Filter "Name eq '$($DisplayName -replace "'", "''")' and creationSource eq 'WindowsSecurity' and technologies eq 'configManager'" `
                        -ErrorAction SilentlyContinue
                }
            }
            #endregion
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Antivirus Policy Security Experience for Windows10 Config Mgr with DisplayName {$DisplayName}."
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Antivirus Policy Security Experience for Windows10 Config Mgr with Id {$Id} and DisplayName {$DisplayName} was found"

        # Retrieve policy specific settings
        [array]$settings = Get-MgBetaDeviceManagementConfigurationPolicySetting `
            -DeviceManagementConfigurationPolicyId $Id `
            -ExpandProperty 'settingDefinitions' `
            -All `
            -ErrorAction Stop

        $policySettings = @{}
        $policySettings = Export-IntuneSettingCatalogPolicySettings -Settings $settings -ReturnHashtable $policySettings

        $disableNotificationsInstance = $settings | Where-Object { $_.SettingInstance.SettingDefinitionId -like '*_disablenotifications' }
        if ($null -ne $disableNotificationsInstance)
        {
            $policySettings.DisableNotifications = [int]$disableNotificationsInstance.SettingInstance.choiceSettingValue.value.Split('_')[-1]
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
        $DisableFamilyUI,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableHealthUI,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableNetworkUI,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableNotifications,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableEnhancedNotifications,

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
        $HideRansomwareDataRecovery,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $HideWindowsSecurityNotificationAreaControl,

        [Parameter()]
        [System.String]
        $CompanyName,

        [Parameter()]
        [System.String]
        $Email,

        [Parameter()]
        [System.String]
        $Phone,

        [Parameter()]
        [System.String]
        $URL,

        [Parameter()]
        [ValidateSet('1', '0')]
        [System.String]
        $TamperProtection,

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

    Write-Verbose -Message "Setting configuration of the Intune Antivirus Policy Security Experience for Windows10 Config Mgr with Id {$Id} and DisplayName {$DisplayName}"

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
    $boundParameters.Remove('TamperProtection') | Out-Null

    $templateReferenceId = 'd948ff9b-99cb-4ee0-8012-1fbc09685377_1'
    $platforms = 'windows10'
    $technologies = 'configManager'

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Antivirus Policy Security Experience for Windows10 Config Mgr with Name {$DisplayName}"
        $boundParameters.Remove('Assignments') | Out-Null

        [array]$settings = Get-IntuneSettingCatalogPolicySetting `
            -DSCParams ([System.Collections.Hashtable]$boundParameters) `
            -TemplateId $templateReferenceId

        if ($PSBoundParameters.ContainsKey('DisableNotifications'))
        {
            $settings += @{
                '@odata.type'   = '#microsoft.graph.deviceManagementConfigurationSetting'
                settingInstance = @{
                    '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                    choiceSettingValue  = @{
                        children = @()
                        value    = "device_vendor_msft_policy_config_windowsdefendersecuritycenter_disablenotifications_$DisableNotifications"
                    }
                    settingDefinitionId = 'device_vendor_msft_policy_config_windowsdefendersecuritycenter_disablenotifications'
                }
            }
        }

        if ($PSBoundParameters.ContainsKey('TamperProtection'))
        {
            $settings += @{
                '@odata.type'   = '#microsoft.graph.deviceManagementConfigurationSetting'
                settingInstance = @{
                    '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                    choiceSettingValue  = @{
                        children = @()
                        value    = "vendor_msft_defender_configuration_tamperprotection_$TamperProtection"
                    }
                    settingDefinitionId = 'vendor_msft_defender_configuration_tamperprotection'
                }
            }
        }

        $createParameters = @{
            name           = $DisplayName
            description    = $Description
            creationSource = 'WindowsSecurity'
            platforms      = $platforms
            technologies   = $technologies
            settings       = $settings
            roleScopeTagIds = $RoleScopeTagIds
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
        Write-Verbose -Message "Updating the Intune Antivirus Policy Security Experience for Windows10 Config Mgr with Id {$($currentInstance.Id)}"
        $boundParameters.Remove('Assignments') | Out-Null

        [array]$settings = Get-IntuneSettingCatalogPolicySetting `
            -DSCParams ([System.Collections.Hashtable]$boundParameters) `
            -TemplateId $templateReferenceId

        if ($PSBoundParameters.ContainsKey('DisableNotifications'))
        {
            $settings += @{
                '@odata.type'   = '#microsoft.graph.deviceManagementConfigurationSetting'
                settingInstance = @{
                    '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                    choiceSettingValue  = @{
                        children = @()
                        value    = "device_vendor_msft_policy_config_windowsdefendersecuritycenter_disablenotifications_$DisableNotifications"
                    }
                    settingDefinitionId = 'device_vendor_msft_policy_config_windowsdefendersecuritycenter_disablenotifications'
                }
            }
        }

        if ($PSBoundParameters.ContainsKey('TamperProtection'))
        {
            $settings += @{
                '@odata.type'   = '#microsoft.graph.deviceManagementConfigurationSetting'
                settingInstance = @{
                    '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                    choiceSettingValue  = @{
                        children = @()
                        value    = "vendor_msft_defender_configuration_tamperprotection_$TamperProtection"
                    }
                    settingDefinitionId = 'vendor_msft_defender_configuration_tamperprotection'
                }
            }
        }

        Update-IntuneDeviceConfigurationPolicy `
            -DeviceConfigurationPolicyId $currentInstance.Id `
            -Name $DisplayName `
            -Description $Description `
            -CreationSource 'WindowsSecurity' `
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
        Write-Verbose -Message "Removing the Intune Antivirus Policy Security Experience for Windows10 Config Mgr with Id {$($currentInstance.Id)}"
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
        $DisableFamilyUI,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableHealthUI,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableNetworkUI,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableNotifications,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $DisableEnhancedNotifications,

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
        $HideRansomwareDataRecovery,

        [Parameter()]
        [ValidateSet(0, 1)]
        [System.Int32]
        $HideWindowsSecurityNotificationAreaControl,

        [Parameter()]
        [System.String]
        $CompanyName,

        [Parameter()]
        [System.String]
        $Email,

        [Parameter()]
        [System.String]
        $Phone,

        [Parameter()]
        [System.String]
        $URL,

        [Parameter()]
        [ValidateSet('1', '0')]
        [System.String]
        $TamperProtection,

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
        $baseFilter = "creationSource eq 'WindowsSecurity' and technologies eq 'configManager'"
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
