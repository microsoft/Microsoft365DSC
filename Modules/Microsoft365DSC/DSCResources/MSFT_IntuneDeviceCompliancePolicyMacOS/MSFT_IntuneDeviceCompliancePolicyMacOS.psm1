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
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeLock,

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
        $SystemIntegrityProtectionEnabled,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('Unavailable', 'Secured', 'Low', 'Medium', 'High', 'NotSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.String]
        [ValidateSet('Unavailable', 'Secured', 'Low', 'Medium', 'High', 'NotSet')]
        $AdvancedThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $StorageRequireEncryption,

        [Parameter()]
        [System.String]
        [ValidateSet('notConfigured', 'macAppStore', 'macAppStoreAndIdentifiedDevelopers', 'anywhere')]
        $GatekeeperAllowedAppSource,

        [Parameter()]
        [System.Boolean]
        $FirewallEnabled,

        [Parameter()]
        [System.Boolean]
        $FirewallBlockAllIncoming,

        [Parameter()]
        [System.Boolean]
        $FirewallEnableStealthMode,

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
        $ManagedIdentity
    )

    Write-Verbose -Message "Checking for the Intune Device Compliance MacOS Policy {$DisplayName}"
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
            -ErrorAction Stop | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.macOSCompliancePolicy' -and `
                $_.displayName -eq $($DisplayName) }

        if ($null -eq $devicePolicy)
        {
            Write-Verbose -Message "No MacOS Device Compliance Policy with displayName {$DisplayName} was found"
            return $nullResult
        }

        Write-Verbose -Message "Found MacOS Device Compliance Policy with displayName {$DisplayName}"
        $results = @{
            DisplayName                                   = $devicePolicy.DisplayName
            Description                                   = $devicePolicy.Description
            PasswordRequired                              = $devicePolicy.AdditionalProperties.passwordRequired
            PasswordBlockSimple                           = $devicePolicy.AdditionalProperties.passwordBlockSimple
            PasswordExpirationDays                        = $devicePolicy.AdditionalProperties.passwordExpirationDays
            PasswordMinimumLength                         = $devicePolicy.AdditionalProperties.passwordMinimumLength
            PasswordMinutesOfInactivityBeforeLock         = $devicePolicy.AdditionalProperties.passwordMinutesOfInactivityBeforeLock
            PasswordPreviousPasswordBlockCount            = $devicePolicy.AdditionalProperties.passwordPreviousPasswordBlockCount
            PasswordMinimumCharacterSetCount              = $devicePolicy.AdditionalProperties.passwordMinimumCharacterSetCount
            PasswordRequiredType                          = $devicePolicy.AdditionalProperties.passwordRequiredType
            OsMinimumVersion                              = $devicePolicy.AdditionalProperties.osMinimumVersion
            OsMaximumVersion                              = $devicePolicy.AdditionalProperties.osMaximumVersion
            OsMinimumBuildVersion                         = $devicePolicy.AdditionalProperties.osMinimumBuildVersion
            OsMaximumBuildVersion                         = $devicePolicy.AdditionalProperties.osMaximumBuildVersion
            SystemIntegrityProtectionEnabled              = $devicePolicy.AdditionalProperties.systemIntegrityProtectionEnabled
            DeviceThreatProtectionEnabled                 = $devicePolicy.AdditionalProperties.deviceThreatProtectionEnabled
            DeviceThreatProtectionRequiredSecurityLevel   = $devicePolicy.AdditionalProperties.deviceThreatProtectionRequiredSecurityLevel
            AdvancedThreatProtectionRequiredSecurityLevel = $devicePolicy.AdditionalProperties.advancedThreatProtectionRequiredSecurityLevel
            StorageRequireEncryption                      = $devicePolicy.AdditionalProperties.storageRequireEncryption
            GatekeeperAllowedAppSource                    = $devicePolicy.AdditionalProperties.gatekeeperAllowedAppSource
            FirewallEnabled                               = $devicePolicy.AdditionalProperties.firewallEnabled
            FirewallBlockAllIncoming                      = $devicePolicy.AdditionalProperties.firewallBlockAllIncoming
            FirewallEnableStealthMode                     = $devicePolicy.AdditionalProperties.firewallEnableStealthMode
            Ensure                                        = 'Present'
            Credential                                    = $Credential
            ApplicationId                                 = $ApplicationId
            TenantId                                      = $TenantId
            ApplicationSecret                             = $ApplicationSecret
            CertificateThumbprint                         = $CertificateThumbprint
            Managedidentity                               = $ManagedIdentity.IsPresent
        }

        $returnAssignments = @()
        $returnAssignments += Get-MgBetaDeviceManagementDeviceCompliancePolicyAssignment -DeviceCompliancePolicyId  $devicePolicy.Id
        $assignmentResult = @()
        foreach ($assignmentEntry in $returnAssignments)
        {
            $assignmentValue = @{
                dataType                                   = $assignmentEntry.Target.AdditionalProperties.'@odata.type'
                deviceAndAppManagementAssignmentFilterType = $assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterType.toString()
                deviceAndAppManagementAssignmentFilterId   = $assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterId
                groupId                                    = $assignmentEntry.Target.AdditionalProperties.groupId
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
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeLock,

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
        $SystemIntegrityProtectionEnabled,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('Unavailable', 'Secured', 'Low', 'Medium', 'High', 'NotSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.String]
        [ValidateSet('Unavailable', 'Secured', 'Low', 'Medium', 'High', 'NotSet')]
        $AdvancedThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $StorageRequireEncryption,

        [Parameter()]
        [System.String]
        [ValidateSet('notConfigured', 'macAppStore', 'macAppStoreAndIdentifiedDevelopers', 'anywhere')]
        $GatekeeperAllowedAppSource,

        [Parameter()]
        [System.Boolean]
        $FirewallEnabled,

        [Parameter()]
        [System.Boolean]
        $FirewallBlockAllIncoming,

        [Parameter()]
        [System.Boolean]
        $FirewallEnableStealthMode,

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
        $ManagedIdentity
    )


    Write-Verbose -Message "Intune Device Compliance MacOS Policy {$DisplayName}"

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

    $currentDeviceMacOsPolicy = Get-TargetResource @PSBoundParameters

    $PSBoundParameters.Remove('Ensure') | Out-Null
    $PSBoundParameters.Remove('Credential') | Out-Null
    $PSBoundParameters.Remove('ApplicationId') | Out-Null
    $PSBoundParameters.Remove('TenantId') | Out-Null
    $PSBoundParameters.Remove('ApplicationSecret') | Out-Null

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

    if ($Ensure -eq 'Present' -and $currentDeviceMacOsPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Intune Device Compliance MacOS Policy {$DisplayName}"
        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $AdditionalProperties = Get-M365DSCIntuneDeviceCompliancePolicyMacOSAdditionalProperties -Properties ([System.Collections.Hashtable]$PSBoundParameters)
        $policy = New-MgBetaDeviceManagementDeviceCompliancePolicy -DisplayName $DisplayName `
            -Description $Description `
            -AdditionalProperties $AdditionalProperties `
            -ScheduledActionsForRule $scheduledActionsForRule

        #region Assignments
        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }
        if ($policy.id)
        {
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId  $policy.id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/deviceCompliancePolicies'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentDeviceMacOsPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating Intune Device Compliance MacOS Policy {$DisplayName}"
        $configDevicePolicy = Get-MgBetaDeviceManagementDeviceCompliancePolicy `
            -ErrorAction Stop | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.macOSCompliancePolicy' -and `
                $_.displayName -eq $($DisplayName) }

        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $AdditionalProperties = Get-M365DSCIntuneDeviceCompliancePolicyMacOSAdditionalProperties -Properties ([System.Collections.Hashtable]$PSBoundParameters)
        Update-MgBetaDeviceManagementDeviceCompliancePolicy -AdditionalProperties $AdditionalProperties `
            -Description $Description `
            -DeviceCompliancePolicyId $configDevicePolicy.Id

        #region Assignments
        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }
        Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId  $configDevicePolicy.id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/deviceCompliancePolicies'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentDeviceMacOsPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Intune Device Compliance MacOS Policy {$DisplayName}"
        $configDevicePolicy = Get-MgBetaDeviceManagementDeviceCompliancePolicy `
            -ErrorAction Stop | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.macOSCompliancePolicy' -and `
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
        [System.Boolean]
        $PasswordRequired,

        [Parameter()]
        [System.Boolean]
        $PasswordBlockSimple,

        [Parameter()]
        [System.Int32]
        $PasswordExpirationDays,

        [Parameter()]
        [System.Int32]
        $PasswordMinimumLength,

        [Parameter()]
        [System.Int32]
        $PasswordMinutesOfInactivityBeforeLock,

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
        $SystemIntegrityProtectionEnabled,

        [Parameter()]
        [System.Boolean]
        $DeviceThreatProtectionEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet('Unavailable', 'Secured', 'Low', 'Medium', 'High', 'NotSet')]
        $DeviceThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.String]
        [ValidateSet('Unavailable', 'Secured', 'Low', 'Medium', 'High', 'NotSet')]
        $AdvancedThreatProtectionRequiredSecurityLevel,

        [Parameter()]
        [System.Boolean]
        $StorageRequireEncryption,

        [Parameter()]
        [System.String]
        [ValidateSet('notConfigured', 'macAppStore', 'macAppStoreAndIdentifiedDevelopers', 'anywhere')]
        $GatekeeperAllowedAppSource,

        [Parameter()]
        [System.Boolean]
        $FirewallEnabled,

        [Parameter()]
        [System.Boolean]
        $FirewallBlockAllIncoming,

        [Parameter()]
        [System.Boolean]
        $FirewallEnableStealthMode,

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
        $ManagedIdentity
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

    Write-Verbose -Message "Testing configuration of Intune Device Compliance MacOS Policy {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null


    if ($CurrentValues.Ensure -ne $PSBoundParameters.Ensure)
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }
    #region Assignments
    $testResult = $true

    if (($null -ne $CurrentValues.Assignments) -xor ($null -ne $ValuesToCheck.Assignments))
    {
        Write-Verbose -Message 'Configuration drift: one the assignment is null'
        return $false
    }

    if ($null -ne $CurrentValues.Assignments)
    {
        if ($CurrentValues.Assignments.count -ne $ValuesToCheck.Assignments.count)
        {
            Write-Verbose -Message "Configuration drift: Number of assignment has changed - current {$($CurrentValues.Assignments.count)} target {$($ValuesToCheck.Assignments.count)}"
            return $false
        }
        foreach ($assignment in $CurrentValues.Assignments)
        {
            #GroupId Assignment
            if (-not [String]::IsNullOrEmpty($assignment.groupId))
            {
                $source = [Array]$ValuesToCheck.Assignments | Where-Object -FilterScript { $_.groupId -eq $assignment.groupId }
                if (-not $source)
                {
                    Write-Verbose -Message "Configuration drift: groupId {$($assignment.groupId)} not found"
                    $testResult = $false
                    break
                }
                $sourceHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $source
                $testResult = Compare-M365DSCComplexObject -Source $sourceHash -Target $assignment
            }
            #AllDevices/AllUsers assignment
            else
            {
                $source = [Array]$ValuesToCheck.Assignments | Where-Object -FilterScript { $_.dataType -eq $assignment.dataType }
                if (-not $source)
                {
                    Write-Verbose -Message "Configuration drift: {$($assignment.dataType)} not found"
                    $testResult = $false
                    break
                }
                $sourceHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $source
                $testResult = Compare-M365DSCComplexObject -Source $sourceHash -Target $assignment
            }

            if (-not $testResult)
            {
                $testResult = $false
                break
            }

        }
    }
    if (-not $testResult)
    {
        return $false
    }
    $ValuesToCheck.Remove('Assignments') | Out-Null
    #endregion

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

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
        $ManagedIdentity
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
        [array]$configDeviceMacOsPolicies = Get-MgBetaDeviceManagementDeviceCompliancePolicy `
            -ErrorAction Stop -All:$true -Filter $Filter | Where-Object `
            -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.macOSCompliancePolicy' }
        $i = 1
        $dscContent = ''
        if ($configDeviceMacOsPolicies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }

        foreach ($configDeviceMacOsPolicy in $configDeviceMacOsPolicies)
        {
            Write-Host "    |---[$i/$($configDeviceMacOsPolicies.Count)] $($configDeviceMacOsPolicy.displayName)" -NoNewline
            $params = @{
                DisplayName           = $configDeviceMacOsPolicy.displayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity       = $ManagedIdentity.IsPresent
            }
            $results = Get-TargetResource @params

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

            $results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results

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

function Get-M365DSCIntuneDeviceCompliancePolicyMacOSAdditionalProperties
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties
    )

    $results = @{'@odata.type' = '#microsoft.graph.macOSCompliancePolicy' }
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
