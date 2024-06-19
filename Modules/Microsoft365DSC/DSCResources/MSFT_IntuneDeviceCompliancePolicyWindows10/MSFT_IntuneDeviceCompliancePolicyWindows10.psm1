function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $PasswordRequired,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockSimple,

        [Parameter()]
        [System.Boolean]
        $PasswordRequiredToUnlockFromIdle,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumCharacterSetCount,

        [Parameter()]
        [System.String]
        [ValidateSet('DeviceDefault', 'Alphanumeric', 'Numeric')]
        $PasswordRequiredType,

        [Parameter()]
        [System.Boolean]
        $RequireHealthyDeviceReport,

        [Parameter()]
        [System.String]
        $OsMinimumVersion,

        [Parameter()]
        [System.String]
        $OsMaximumVersion,

        [Parameter()]
        [System.String]
        $MobileOsMinimumVersion,

        [Parameter()]
        [System.String]
        $MobileOsMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $EarlyLaunchAntiMalwareDriverEnabled,

        [Parameter()]
        [System.Boolean]
        $BitLockerEnabled,

        [Parameter()]
        [System.Boolean]
        $SecureBootEnabled,

        [Parameter()]
        [System.Boolean]
        $CodeIntegrityEnabled,

        [Parameter()]
        [System.Boolean]
        $StorageRequireEncryption,

        [Parameter()]
        [System.Boolean]
        $ActiveFirewallRequired,

        [Parameter()]
        [System.Boolean]
        $DefenderEnabled,

        [Parameter()]
        [System.String]
        $DefenderVersion,

        [Parameter()]
        [System.Boolean]
        $SignatureOutOfDate,

        [Parameter()]
        [System.Boolean]
        $RtpEnabled,

        [Parameter()]
        [System.Boolean]
        $AntivirusRequired,

        [Parameter()]
        [System.Boolean]
        $AntiSpywareRequired,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('Unavailable', 'Secured', 'Low', 'Medium', 'High', 'NotSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $ConfigurationManagerComplianceRequired,

        [Parameter()]
        [System.Boolean]
        $TPMRequired,

        [Parameter()]
        [System.String]
        $DeviceCompliancePolicyScript,

        [Parameter()]
        [System.Array]
        $ValidOperatingSystemBuildRanges,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

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

    Write-Verbose -Message "Checking for the Intune Device Compliance Windows 10 Policy {$DisplayName}"
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

    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'
    try
    {
        $devicePolicy = Get-MgBetaDeviceManagementDeviceCompliancePolicy `
            -ErrorAction SilentlyContinue | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windows10CompliancePolicy' -and `
                $_.displayName -eq $($DisplayName) }
        if(([array]$devicePolicy).count -gt 1)
        {
            throw "A policy with a duplicated displayName {'$DisplayName'} was found - Ensure displayName is unique"
        }
        if ($null -eq $devicePolicy)
        {
            Write-Verbose -Message "No Windows 10 Device Compliance Policy with displayName {$DisplayName} was found"
            return $nullResult
        }

        Write-Verbose -Message "Found Windows 10 Device Compliance Policy with displayName {$DisplayName}"
        $results = @{
            DisplayName                                 = $devicePolicy.DisplayName
            Description                                 = $devicePolicy.Description
            PasswordRequired                            = $devicePolicy.AdditionalProperties.passwordRequired
            PasswordBlockSimple                         = $devicePolicy.AdditionalProperties.passwordBlockSimple
            PasswordRequiredToUnlockFromIdle            = $devicePolicy.AdditionalProperties.passwordRequiredToUnlockFromIdle
            PasswordMinutesOfInactivityBeforeLock       = $devicePolicy.AdditionalProperties.passwordMinutesOfInactivityBeforeLock
            PasswordExpirationDays                      = $devicePolicy.AdditionalProperties.passwordExpirationDays
            PasswordMinimumLength                       = $devicePolicy.AdditionalProperties.passwordMinimumLength
            PasswordMinimumCharacterSetCount            = $devicePolicy.AdditionalProperties.passwordMinimumCharacterSetCount
            PasswordRequiredType                        = $devicePolicy.AdditionalProperties.passwordRequiredType
            PasswordPreviousPasswordBlockCount          = $devicePolicy.AdditionalProperties.passwordPreviousPasswordBlockCount
            RequireHealthyDeviceReport                  = $devicePolicy.AdditionalProperties.requireHealthyDeviceReport
            OsMinimumVersion                            = $devicePolicy.AdditionalProperties.osMinimumVersion
            OsMaximumVersion                            = $devicePolicy.AdditionalProperties.osMaximumVersion
            MobileOsMinimumVersion                      = $devicePolicy.AdditionalProperties.mobileOsMinimumVersion
            MobileOsMaximumVersion                      = $devicePolicy.AdditionalProperties.mobileOsMaximumVersion
            EarlyLaunchAntiMalwareDriverEnabled         = $devicePolicy.AdditionalProperties.earlyLaunchAntiMalwareDriverEnabled
            BitLockerEnabled                            = $devicePolicy.AdditionalProperties.bitLockerEnabled
            SecureBootEnabled                           = $devicePolicy.AdditionalProperties.secureBootEnabled
            CodeIntegrityEnabled                        = $devicePolicy.AdditionalProperties.codeIntegrityEnabled
            StorageRequireEncryption                    = $devicePolicy.AdditionalProperties.storageRequireEncryption
            ActiveFirewallRequired                      = $devicePolicy.AdditionalProperties.activeFirewallRequired
            DefenderEnabled                             = $devicePolicy.AdditionalProperties.defenderEnabled
            DefenderVersion                             = $devicePolicy.AdditionalProperties.defenderVersion
            SignatureOutOfDate                          = $devicePolicy.AdditionalProperties.signatureOutOfDate
            RTPEnabled                                  = $devicePolicy.AdditionalProperties.rtpEnabled
            AntivirusRequired                           = $devicePolicy.AdditionalProperties.antivirusRequired
            AntiSpywareRequired                         = $devicePolicy.AdditionalProperties.antiSpywareRequired
            DeviceThreatProtectionEnabled               = $devicePolicy.AdditionalProperties.deviceThreatProtectionEnabled
            DeviceThreatProtectionRequiredSecurityLevel = $devicePolicy.AdditionalProperties.deviceThreatProtectionRequiredSecurityLevel
            ConfigurationManagerComplianceRequired      = $devicePolicy.AdditionalProperties.configurationManagerComplianceRequired
            TPMRequired                                 = $devicePolicy.AdditionalProperties.tPMRequired
            DeviceCompliancePolicyScript                = $devicePolicy.AdditionalProperties.deviceCompliancePolicyScript
            ValidOperatingSystemBuildRanges             = $devicePolicy.AdditionalProperties.validOperatingSystemBuildRanges
            Ensure                                      = 'Present'
            Credential                                  = $Credential
            ApplicationId                               = $ApplicationId
            TenantId                                    = $TenantId
            ApplicationSecret                           = $ApplicationSecret
            CertificateThumbprint                       = $CertificateThumbprint
            Managedidentity                             = $ManagedIdentity.IsPresent
            AccessTokens                                = $AccessTokens
        }

        $returnAssignments = @()
        $graphAssignments = Get-MgBetaDeviceManagementDeviceCompliancePolicyAssignment -DeviceCompliancePolicyId  $devicePolicy.Id
        if ($graphAssignments.count -gt 0)
        {
            $returnAssignments += ConvertFrom-IntunePolicyAssignment `
                                -IncludeDeviceFilter:$true `
                                -Assignments ($graphAssignments)
        }
        $results.Add('Assignments', $returnAssignments)

        return [System.Collections.Hashtable] $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential
        $nullResult = Clear-M365DSCAuthenticationParameter -BoundParameters $nullResult
        return $nullResult
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $PasswordRequired,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockSimple,

        [Parameter()]
        [System.Boolean]
        $PasswordRequiredToUnlockFromIdle,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumCharacterSetCount,

        [Parameter()]
        [System.String]
        [ValidateSet('DeviceDefault', 'Alphanumeric', 'Numeric')]
        $PasswordRequiredType,

        [Parameter()]
        [System.Boolean]
        $RequireHealthyDeviceReport,

        [Parameter()]
        [System.String]
        $OsMinimumVersion,

        [Parameter()]
        [System.String]
        $OsMaximumVersion,

        [Parameter()]
        [System.String]
        $MobileOsMinimumVersion,

        [Parameter()]
        [System.String]
        $MobileOsMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $EarlyLaunchAntiMalwareDriverEnabled,

        [Parameter()]
        [System.Boolean]
        $BitLockerEnabled,

        [Parameter()]
        [System.Boolean]
        $SecureBootEnabled,

        [Parameter()]
        [System.Boolean]
        $CodeIntegrityEnabled,

        [Parameter()]
        [System.Boolean]
        $StorageRequireEncryption,

        [Parameter()]
        [System.Boolean]
        $ActiveFirewallRequired,

        [Parameter()]
        [System.Boolean]
        $DefenderEnabled,

        [Parameter()]
        [System.String]
        $DefenderVersion,

        [Parameter()]
        [System.Boolean]
        $SignatureOutOfDate,

        [Parameter()]
        [System.Boolean]
        $RtpEnabled,

        [Parameter()]
        [System.Boolean]
        $AntivirusRequired,

        [Parameter()]
        [System.Boolean]
        $AntiSpywareRequired,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('Unavailable', 'Secured', 'Low', 'Medium', 'High', 'NotSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $ConfigurationManagerComplianceRequired,

        [Parameter()]
        [System.Boolean]
        $TPMRequired,

        [Parameter()]
        [System.String]
        $DeviceCompliancePolicyScript,

        [Parameter()]
        [System.Array]
        $ValidOperatingSystemBuildRanges,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

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

    Write-Verbose -Message "Intune Device Compliance Windows 10 Policy {$DisplayName}"
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

    $currentDeviceWindows10Policy = Get-TargetResource @PSBoundParameters

    $PSBoundParameters.Remove('Ensure') | Out-Null
    $PSBoundParameters.Remove('Credential') | Out-Null
    $PSBoundParameters.Remove('ApplicationId') | Out-Null
    $PSBoundParameters.Remove('TenantId') | Out-Null
    $PSBoundParameters.Remove('ApplicationSecret') | Out-Null
    $PSBoundParameters.Remove('AccessTokens') | Out-Null

    $scheduledActionsForRule = @{
        '@odata.type'                 = '#microsoft.graph.deviceComplianceScheduledActionForRule'
        ruleName                      = 'PasswordRequired'
        scheduledActionConfigurations = @(
            @{
                '@odata.type' = '#microsoft.graph.deviceComplianceActionItem'
                actionType    = 'block'
            }
        )
    }

    if ($Ensure -eq 'Present' -and $currentDeviceWindows10Policy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Intune Device Compliance Windows 10 Policy {$DisplayName}"
        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $AdditionalProperties = Get-M365DSCIntuneDeviceCompliancePolicyWindows10AdditionalProperties -Properties ([System.Collections.Hashtable]$PSBoundParameters)
        $policy = New-MgBetaDeviceManagementDeviceCompliancePolicy -DisplayName $DisplayName `
            -Description $Description `
            -AdditionalProperties $AdditionalProperties `
            -ScheduledActionsForRule $scheduledActionsForRule

        if ($Assignments.Count -gt 0)
        {
            $assignmentsHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignments
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $policy.id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/deviceCompliancePolicies'
        }
    }
    elseif ($Ensure -eq 'Present' -and $currentDeviceWindows10Policy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating Intune Device Compliance Windows 10 Policy {$DisplayName}"
        $configDevicePolicy = Get-MgBetaDeviceManagementDeviceCompliancePolicy `
            -ErrorAction Stop | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windows10CompliancePolicy' -and `
                $_.displayName -eq $($DisplayName) }

        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $AdditionalProperties = Get-M365DSCIntuneDeviceCompliancePolicyWindows10AdditionalProperties -Properties ([System.Collections.Hashtable]$PSBoundParameters)
        Update-MgBetaDeviceManagementDeviceCompliancePolicy -AdditionalProperties $AdditionalProperties `
            -Description $Description `
            -DeviceCompliancePolicyId $configDevicePolicy.Id

        if ($Assignments.Count -gt 0)
        {
            $assignmentsHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignments
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $configDevicePolicy.id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/deviceCompliancePolicies'
        }
    }
    elseif ($Ensure -eq 'Absent' -and $currentDeviceWindows10Policy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Intune Device Compliance Windows 10 Policy {$DisplayName}"
        $configDevicePolicy = Get-MgBetaDeviceManagementDeviceCompliancePolicy `
            -ErrorAction Stop | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windows10CompliancePolicy' -and `
                $_.displayName -eq $($DisplayName) }

        Remove-MgBetaDeviceManagementDeviceCompliancePolicy -DeviceCompliancePolicyId $configDevicePolicy.Id
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $PasswordRequired,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockSimple,

        [Parameter()]
        [System.Boolean]
        $PasswordRequiredToUnlockFromIdle,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumCharacterSetCount,

        [Parameter()]
        [System.String]
        [ValidateSet('DeviceDefault', 'Alphanumeric', 'Numeric')]
        $PasswordRequiredType,

        [Parameter()]
        [System.Boolean]
        $RequireHealthyDeviceReport,

        [Parameter()]
        [System.String]
        $OsMinimumVersion,

        [Parameter()]
        [System.String]
        $OsMaximumVersion,

        [Parameter()]
        [System.String]
        $MobileOsMinimumVersion,

        [Parameter()]
        [System.String]
        $MobileOsMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $EarlyLaunchAntiMalwareDriverEnabled,

        [Parameter()]
        [System.Boolean]
        $BitLockerEnabled,

        [Parameter()]
        [System.Boolean]
        $SecureBootEnabled,

        [Parameter()]
        [System.Boolean]
        $CodeIntegrityEnabled,

        [Parameter()]
        [System.Boolean]
        $StorageRequireEncryption,

        [Parameter()]
        [System.Boolean]
        $ActiveFirewallRequired,

        [Parameter()]
        [System.Boolean]
        $DefenderEnabled,

        [Parameter()]
        [System.String]
        $DefenderVersion,

        [Parameter()]
        [System.Boolean]
        $SignatureOutOfDate,

        [Parameter()]
        [System.Boolean]
        $RtpEnabled,

        [Parameter()]
        [System.Boolean]
        $AntivirusRequired,

        [Parameter()]
        [System.Boolean]
        $AntiSpywareRequired,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('Unavailable', 'Secured', 'Low', 'Medium', 'High', 'NotSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $ConfigurationManagerComplianceRequired,

        [Parameter()]
        [System.Boolean]
        $TPMRequired,

        [Parameter()]
        [System.String]
        $DeviceCompliancePolicyScript,

        [Parameter()]
        [System.Array]
        $ValidOperatingSystemBuildRanges,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of Intune Device Compliance Windows 10 Policy {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    if (-not (Test-M365DSCAuthenticationParameter -BoundParameters $CurrentValues))
    {
        Write-Verbose "An error occured in Get-TargetResource, the policy {$displayName} will not be processed"
        throw "An error occured in Get-TargetResource, the policy {$displayName} will not be processed. Refer to the event viewer logs for more information."
    }

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters

    $testResult = $true
    if ($CurrentValues.Ensure -ne $Ensure)
    {
        $testResult = $false
    }
    #region Assignments
    if ($testResult)
    {
        $source = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $PSBoundParameters.Assignments
        $target = $CurrentValues.Assignments
        $testResult = Compare-M365DSCIntunePolicyAssignment -Source $source -Target $target
        $ValuesToCheck.Remove('Assignments') | Out-Null
    }
    #endregion

    if ($testResult)
    {
        $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
            -Source $($MyInvocation.MyCommand.Source) `
            -DesiredValues $PSBoundParameters `
            -ValuesToCheck $ValuesToCheck.Keys
    }
    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult
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

    try
    {
        [array]$configDeviceWindowsPolicies = Get-MgBetaDeviceManagementDeviceCompliancePolicy `
            -ErrorAction Stop -All:$true -Filter $Filter | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windows10CompliancePolicy' }
        $i = 1
        $dscContent = ''
        if ($configDeviceWindowsPolicies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }

        foreach ($configDeviceWindowsPolicy in $configDeviceWindowsPolicies)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-Host "    |---[$i/$($configDeviceWindowsPolicies.Count)] $($configDeviceWindowsPolicy.displayName)" -NoNewline
            $params = @{
                DisplayName           = $configDeviceWindowsPolicy.displayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }
            $Results = Get-TargetResource @params
            if (-not (Test-M365DSCAuthenticationParameter -BoundParameters $Results))
            {
                Write-Verbose "An error occured in Get-TargetResource, the policy {$($params.displayName)} will not be processed"
                throw "An error occured in Get-TargetResource, the policy {$($params.displayName)} will not be processed. Refer to the event viewer logs for more information."
            }

            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            if ($Results.Assignments)
            {
                $complexTypeStringResult = Get-M365DSCAssignmentsAsString -Params $Results.Assignments
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

function Get-M365DSCIntuneDeviceCompliancePolicyWindows10AdditionalProperties
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties
    )

    $results = @{'@odata.type' = '#microsoft.graph.windows10CompliancePolicy' }
    foreach ($property in $properties.Keys)
    {
        if ($property -ne 'Verbose')
        {
            $propertyName = $property[0].ToString().ToLower() + $property.Substring(1, $property.Length - 1)
            $propertyValue = $properties.$property
            $results.Add($propertyName, $propertyValue)
        }
    }
    Write-Verbose -Message ($results | Out-String)
    return $results
}

function Get-M365DSCAssignmentsAsString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter()]
        [System.Object[]]
        $Params
    )

    if ($null -eq $params)
    {
        return $null
    }
    $currentProperty = "@(`r`n"
    $space = '                '
    $nbParam = 0
    $hasValue = $false
    foreach ($rule in $params)
    {

        $currentProperty += "$($space)MSFT_DeviceManagementConfigurationPolicyAssignments{`r`n"
        foreach ($key in $rule.Keys)
        {
            $value = $rule[$key]
            if (-not [System.String]::IsNullOrEmpty($value))
            {
                $currentProperty += '                    ' + $key + " = '" + $value + "'`r`n"
                $hasValue = $true
            }

        }
        $currentProperty += '                }'
        if ($nbParam -lt ($params.Count - 1) )
        {
            $nbParam++
            $currentProperty += "`r`n"
        }

    }
    $currentProperty += ')'
    if (-not $hasValue)
    {
        return '@()'
    }
    return $currentProperty
}

function Get-M365DSCAssignmentsAsHashtable
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $CIMAssignment
    )

    if ($null -eq $CIMAssignment)
    {
        return $null
    }
    $CIMAssignmentAsHash = @{}
    $keys = $CIMAssignment | Get-Member -MemberType Properties

    foreach ($key in $keys)
    {
        if ($CIMAssignment.$($key.Name))
        {
            $CIMAssignmentAsHash.Add($key.Name, $CIMAssignment.$($key.Name))
        }
    }
    if ($CIMAssignmentAsHash.Count -eq 0)
    {
        return $null
    }
    return $CIMAssignmentAsHash
}

Export-ModuleMember -Function *-TargetResource
