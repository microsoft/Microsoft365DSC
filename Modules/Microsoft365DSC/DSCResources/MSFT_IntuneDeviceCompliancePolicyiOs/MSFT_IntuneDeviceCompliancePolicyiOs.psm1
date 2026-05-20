Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneDeviceCompliancePolicyiOs'

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
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.Boolean]
        $PasscodeBlockSimple,

        [Parameter()]
        [System.Int32]
        $PasscodeExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasscodeMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasscodeMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $passcodeMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $PasscodePreviousPasscodeBlockCount,

        [Parameter()]
        [System.Int32]
        $PasscodeMinimumCharacterSetCount,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'alphanumeric', 'numeric')]
        $PasscodeRequiredType,

        [Parameter()]
        [System.Boolean]
        $PasscodeRequired,

        [Parameter()]
        [System.String]
        $OsMinimumVersion,

        [Parameter()]
        [System.String]
        $OsMaximumVersion,

        [Parameter()]
        [System.String]
        $OsMinimumBuildVersion,

        [Parameter()]
        [System.String]
        $OsMaximumBuildVersion,

        [Parameter()]
        [System.Boolean]
        $SecurityBlockJailbrokenDevices,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('unavailable', 'secured', 'low', 'medium', 'high', 'notSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.String]
        [ValidateSet('unavailable', 'secured', 'low', 'medium', 'high', 'notSet')]
        $AdvancedThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $ManagedEmailProfileRequired,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $RestrictedApps,

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

    Write-Verbose -Message "Getting configuration of the Intune Device Compliance iOS Policy {$DisplayName}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

            $devicePolicy = Get-MgBetaDeviceManagementDeviceCompliancePolicy `
                -All `
                -ErrorAction SilentlyContinue | Where-Object `
                -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.iosCompliancePolicy' -and `
                    $_.displayName -eq $($DisplayName) }
            if (([array]$devicePolicy).Count -gt 1)
            {
                throw "A policy with a duplicated displayName {'$DisplayName'} was found - Ensure displayName is unique"
            }
            if ($null -eq $devicePolicy)
            {
                Write-Verbose -Message "No iOS Device Compliance Policy with displayName {$DisplayName} was found"
                return $nullResult
            }
        }
        else
        {
            $devicePolicy = $Script:exportedInstance
        }

        Write-Verbose -Message "Found iOS Device Compliance Policy with displayName {$DisplayName}"
        $results = @{
            DisplayName                                    = $devicePolicy.DisplayName
            Description                                    = $devicePolicy.Description
            RoleScopeTagIds                                = $devicePolicy.RoleScopeTagIds
            PasscodeBlockSimple                            = $devicePolicy.AdditionalProperties.passcodeBlockSimple
            PasscodeExpirationDays                         = $devicePolicy.AdditionalProperties.passcodeExpirationDays
            PasscodeMinimumLength                          = $devicePolicy.AdditionalProperties.passcodeMinimumLength
            PasscodeMinutesOfInactivityBeforeLock          = $devicePolicy.AdditionalProperties.passcodeMinutesOfInactivityBeforeLock
            PasscodeMinutesOfInactivityBeforeScreenTimeout = $devicePolicy.AdditionalProperties.passcodeMinutesOfInactivityBeforeScreenTimeout
            PasscodePreviousPasscodeBlockCount             = $devicePolicy.AdditionalProperties.passcodePreviousPasscodeBlockCount
            PasscodeMinimumCharacterSetCount               = $devicePolicy.AdditionalProperties.passcodeMinimumCharacterSetCount
            PasscodeRequiredType                           = $devicePolicy.AdditionalProperties.passcodeRequiredType
            PasscodeRequired                               = $devicePolicy.AdditionalProperties.passcodeRequired
            OsMinimumVersion                               = $devicePolicy.AdditionalProperties.osMinimumVersion
            OsMaximumVersion                               = $devicePolicy.AdditionalProperties.osMaximumVersion
            OsMinimumBuildVersion                          = $devicePolicy.AdditionalProperties.osMinimumBuildVersion
            OsMaximumBuildVersion                          = $devicePolicy.AdditionalProperties.osMaximumBuildVersion
            SecurityBlockJailbrokenDevices                 = $devicePolicy.AdditionalProperties.securityBlockJailbrokenDevices
            DeviceThreatProtectionEnabled                  = $devicePolicy.AdditionalProperties.deviceThreatProtectionEnabled
            DeviceThreatProtectionRequiredSecurityLevel    = $devicePolicy.AdditionalProperties.deviceThreatProtectionRequiredSecurityLevel
            AdvancedThreatProtectionRequiredSecurityLevel  = $devicePolicy.AdditionalProperties.advancedThreatProtectionRequiredSecurityLevel
            ManagedEmailProfileRequired                    = $devicePolicy.AdditionalProperties.managedEmailProfileRequired
            RestrictedApps                                 = $devicePolicy.AdditionalProperties.restrictedApps
            Ensure                                         = 'Present'
            Credential                                     = $Credential
            ApplicationId                                  = $ApplicationId
            TenantId                                       = $TenantId
            ApplicationSecret                              = $ApplicationSecret
            CertificateThumbprint                          = $CertificateThumbprint
            ManagedIdentity                                = $ManagedIdentity.IsPresent
            AccessTokens                                   = $AccessTokens
        }

        $returnAssignments = @()
        $graphAssignments = Get-MgBetaDeviceManagementDeviceCompliancePolicyAssignment -DeviceCompliancePolicyId $devicePolicy.Id
        if ($graphAssignments.Count -gt 0)
        {
            $returnAssignments += ConvertFrom-IntunePolicyAssignment `
                -IncludeDeviceFilter:$true `
                -Assignments ($graphAssignments)
        }
        $results.Add('Assignments', $returnAssignments)

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
        $PasscodeBlockSimple,

        [Parameter()]
        [System.Int32]
        $PasscodeExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasscodeMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasscodeMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $passcodeMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $PasscodePreviousPasscodeBlockCount,

        [Parameter()]
        [System.Int32]
        $PasscodeMinimumCharacterSetCount,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'alphanumeric', 'numeric')]
        $PasscodeRequiredType,

        [Parameter()]
        [System.Boolean]
        $PasscodeRequired,

        [Parameter()]
        [System.String]
        $OsMinimumVersion,

        [Parameter()]
        [System.String]
        $OsMaximumVersion,

        [Parameter()]
        [System.String]
        $OsMinimumBuildVersion,

        [Parameter()]
        [System.String]
        $OsMaximumBuildVersion,

        [Parameter()]
        [System.Boolean]
        $SecurityBlockJailbrokenDevices,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('unavailable', 'secured', 'low', 'medium', 'high', 'notSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.String]
        [ValidateSet('unavailable', 'secured', 'low', 'medium', 'high', 'notSet')]
        $AdvancedThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $ManagedEmailProfileRequired,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $RestrictedApps,

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

    Write-Verbose -Message "Intune Device Compliance iOS Policy {$DisplayName}"

    $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

    $currentDeviceiOsPolicy = Get-TargetResource @PSBoundParameters
    $boundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

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

    if ($Ensure -eq 'Present' -and $currentDeviceiOsPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Intune Device Compliance iOS Policy {$DisplayName}"
        $boundParameters.Remove('DisplayName') | Out-Null
        $boundParameters.Remove('Description') | Out-Null
        $boundParameters.Remove('Assignments') | Out-Null
        $boundParameters.Remove('RestrictedApps') | Out-Null

        $AdditionalProperties = Get-M365DSCIntuneDeviceCompliancePolicyiosAdditionalProperties -Properties $boundParameters
        if ($RestrictedApps -and $RestrictedApps.Count -gt 0)
        {
            $AdditionalProperties.Add('restrictedApps', (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $RestrictedApps))
        }

        $policy = New-MgBetaDeviceManagementDeviceCompliancePolicy -DisplayName $DisplayName `
            -Description $Description `
            -AdditionalProperties $AdditionalProperties `
            -ScheduledActionsForRule $scheduledActionsForRule

        #region Assignments
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        if ($policy.id)
        {
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $policy.id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/deviceCompliancePolicies'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentDeviceiOsPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating Intune Device Compliance iOS Policy {$DisplayName}"
        $configDevicePolicy = Get-MgBetaDeviceManagementDeviceCompliancePolicy `
            -ErrorAction Stop | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.iosCompliancePolicy' -and `
                $_.displayName -eq $($DisplayName) }

        $boundParameters.Remove('DisplayName') | Out-Null
        $boundParameters.Remove('Description') | Out-Null
        $boundParameters.Remove('Assignments') | Out-Null
        $boundParameters.Remove('RestrictedApps') | Out-Null

        $AdditionalProperties = Get-M365DSCIntuneDeviceCompliancePolicyiosAdditionalProperties -Properties $boundParameters
        if ($RestrictedApps -and $RestrictedApps.Count -gt 0)
        {
            $AdditionalProperties.Add('restrictedApps', (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $RestrictedApps))
        }

        Update-MgBetaDeviceManagementDeviceCompliancePolicy -AdditionalProperties $AdditionalProperties `
            -Description $Description `
            -DeviceCompliancePolicyId $configDevicePolicy.Id
        #region Assignments
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $configDevicePolicy.id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/deviceCompliancePolicies'
        #endregion

    }
    elseif ($Ensure -eq 'Absent' -and $currentDeviceiOsPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Intune Device Compliance iOS Policy {$DisplayName}"
        $configDevicePolicy = Get-MgBetaDeviceManagementDeviceCompliancePolicy `
            -ErrorAction Stop | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.iosCompliancePolicy' -and `
                $_.displayName -eq $($DisplayName) }

        Remove-MgBetaDeviceManagementDeviceCompliancePolicy -DeviceCompliancePolicyId $configDevicePolicy.Id
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
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
        $PasscodeBlockSimple,

        [Parameter()]
        [System.Int32]
        $PasscodeExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasscodeMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasscodeMinutesOfInactivityBeforeLock,

        [Parameter()]
        [System.Int32]
        $passcodeMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Int32]
        $PasscodePreviousPasscodeBlockCount,

        [Parameter()]
        [System.Int32]
        $PasscodeMinimumCharacterSetCount,

        [Parameter()]
        [System.String]
        [ValidateSet('deviceDefault', 'alphanumeric', 'numeric')]
        $PasscodeRequiredType,

        [Parameter()]
        [System.Boolean]
        $PasscodeRequired,

        [Parameter()]
        [System.String]
        $OsMinimumVersion,

        [Parameter()]
        [System.String]
        $OsMaximumVersion,

        [Parameter()]
        [System.String]
        $OsMinimumBuildVersion,

        [Parameter()]
        [System.String]
        $OsMaximumBuildVersion,

        [Parameter()]
        [System.Boolean]
        $SecurityBlockJailbrokenDevices,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('unavailable', 'secured', 'low', 'medium', 'high', 'notSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.String]
        [ValidateSet('unavailable', 'secured', 'low', 'medium', 'high', 'notSet')]
        $AdvancedThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $ManagedEmailProfileRequired,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $RestrictedApps,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        if (-not [string]::IsNullOrEmpty($Filter))
        {
            $complexFunctions = Get-ComplexFunctionsFromFilterQuery -FilterQuery $Filter
            $Filter = Remove-ComplexFunctionsFromFilterQuery -FilterQuery $Filter
        }
        [array]$configDeviceiOsPolicies = Get-MgBetaDeviceManagementDeviceCompliancePolicy `
            -ErrorAction Stop -All -Filter $Filter | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.iosCompliancePolicy' }
        $configDeviceiOsPolicies = Find-GraphDataUsingComplexFunctions -ComplexFunctions $complexFunctions -Policies $configDeviceiOsPolicies

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        if ($configDeviceiOsPolicies.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($configDeviceiOsPolicy in $configDeviceiOsPolicies)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($configDeviceiOsPolicies.Count)] $($configDeviceiOsPolicy.displayName)" -DeferWrite
            $params = @{
                DisplayName           = $configDeviceiOsPolicy.displayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $configDeviceiOsPolicy
            $Results = Get-TargetResource @params

            if ($Results.RestrictedApps)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ([Array]$Results.RestrictedApps) -CIMInstanceName appListItem

                if ($complexTypeStringResult)
                {
                    $Results.RestrictedApps = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('RestrictedApps') | Out-Null
                }
            }

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
                -NoEscape @('RestrictedApps', 'Assignments')

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

function Get-M365DSCIntuneDeviceCompliancePolicyiosAdditionalProperties
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties
    )

    $results = @{'@odata.type' = '#microsoft.graph.iosCompliancePolicy' }
    foreach ($property in $properties.Keys)
    {
        if ($property -ne 'Verbose')
        {
            $propertyName = $property[0].ToString().ToLower() + $property.Substring(1, $property.Length - 1)
            $propertyValue = $properties.$property
            $results.Add($propertyName, $propertyValue)
        }
    }
    return $results
}

Export-ModuleMember -Function *-TargetResource
