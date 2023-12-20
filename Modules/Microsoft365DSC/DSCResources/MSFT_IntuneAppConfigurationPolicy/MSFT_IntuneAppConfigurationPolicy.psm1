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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CustomSettings,

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

    Write-Verbose -Message "Getting configuration of Intune App Configuration Policy {$DisplayName}"
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

    $nullResult = @{
        DisplayName = $DisplayName
    }
    $nullResult.Ensure = 'Absent'
    try
    {
        $configPolicy = Get-MgBetaDeviceAppManagementTargetedManagedAppConfiguration -Filter "displayName eq '$DisplayName'" `
            -ErrorAction Stop

        if ($null -eq $configPolicy)
        {
            Write-Verbose -Message "No App Configuration Policy with displayName {$DisplayName} was found"
            return $nullResult
        }

        Write-Verbose -Message "Found App Configuration Policy with displayName {$DisplayName}"
        $returnHashtable = @{
            DisplayName           = $configPolicy.DisplayName
            Description           = $configPolicy.Description
            CustomSettings        = $configPolicy.customSettings
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            Managedidentity       = $ManagedIdentity.IsPresent
        }

        $returnAssignments = @()
        $returnAssignments += Get-MgBetaDeviceAppManagementTargetedManagedAppConfigurationAssignment -TargetedManagedAppConfigurationId $configPolicy.Id
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
        $returnHashtable.Add('Assignments', $assignmentResult)

        return $returnHashtable
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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CustomSettings,

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

    Write-Verbose -Message "Setting configuration of Intune App Configuration Policy {$DisplayName}"

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

    $currentconfigPolicy = Get-TargetResource @PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentconfigPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Intune App Configuration Policy {$DisplayName}"
        $creationParams = @{
            displayName = $DisplayName
            description = $Description
        }
        if ($null -ne $CustomSettings)
        {
            [System.Object[]]$customSettingsValue = ConvertTo-M365DSCIntuneAppConfigurationPolicyCustomSettings -Settings $CustomSettings
            $creationParams.Add('customSettings', $customSettingsValue)
        }
        $policy = New-MgBetaDeviceAppManagementTargetedManagedAppConfiguration @creationParams

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
                -Repository 'deviceAppManagement/targetedManagedAppConfigurations'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentconfigPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating Intune App Configuration Policy {$DisplayName}"
        $configPolicy = Get-MgBetaDeviceAppManagementTargetedManagedAppConfiguration -Filter "displayName eq '$DisplayName'"

        $updateParams = @{
            targetedManagedAppConfigurationId = $configPolicy.Id
            displayName                       = $DisplayName
            description                       = $Description
        }
        if ($null -ne $CustomSettings)
        {
            $customSettingsValue = ConvertTo-M365DSCIntuneAppConfigurationPolicyCustomSettings -Settings $CustomSettings
            $updateParams.Add('customSettings', $customSettingsValue)
        }
        Update-MgBetaDeviceAppManagementTargetedManagedAppConfiguration @updateParams

        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }
        Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId  $configPolicy.id `
            -Targets $assignmentsHash `
            -Repository 'deviceAppManagement/targetedManagedAppConfigurations'
    }
    elseif ($Ensure -eq 'Absent' -and $currentconfigPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Intune App Configuration Policy {$DisplayName}"
        $configPolicy = Get-MgBetaDeviceAppManagementTargetedManagedAppConfiguration -Filter "displayName eq '$DisplayName'"
        Remove-MgBetaDeviceAppManagementTargetedManagedAppConfiguration -TargetedManagedAppConfigurationId $configPolicy.id
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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CustomSettings,

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
    Write-Verbose -Message "Testing configuration of Intune App Configuration Policy {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    if ($null -ne $CurrentValues.CustomSettings -and $CurrentValues.CustomSettings.Length -gt 0 -and $null -ne $CustomSettings)
    {
        $value = Test-M365DSCAppConfigurationPolicyCustomSetting -Current $CurrentValues.CustomSettings -Desired $CustomSettings
        if ($value -eq $false)
        {
            return $false
        }
    }
    else
    {
        if (($null -eq $CurrentValues.CustomSettings -and $null -ne $CustomSettings) -or
            ($null -ne $CurrentValues.CustomSettings -and $null -eq $CustomSettings))
        {
            return $false
        }
    }

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null
    $ValuesToCheck.Remove('CustomSettings') | Out-Null

    #region Assignments
    $testResult = $true

    if ((-not $CurrentValues.Assignments) -xor (-not $ValuesToCheck.Assignments))
    {
        Write-Verbose -Message 'Configuration drift: one the assignment is null'
        return $false
    }

    if ($CurrentValues.Assignments)
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
        [array]$configPolicies = Get-MgBetaDeviceAppManagementTargetedManagedAppConfiguration -All:$true -Filter $Filter -ErrorAction Stop
        $i = 1
        $dscContent = ''
        if ($configPolicies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($configPolicy in $configPolicies)
        {
            Write-Host "    |---[$i/$($configPolicies.Count)] $($configPolicy.displayName)" -NoNewline
            $params = @{
                DisplayName           = $configPolicy.displayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationID         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity       = $ManagedIdentity.IsPresent
            }
            $Results = Get-TargetResource @params
            if ($Results.CustomSettings.Count -gt 0)
            {
                $Results.CustomSettings = Get-M365DSCIntuneAppConfigurationPolicyCustomSettingsAsString -Settings $Results.CustomSettings
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

            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            if ($null -ne $Results.CustomSettings)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'CustomSettings'
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
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*")
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

function Test-M365DSCAppConfigurationPolicyCustomSetting
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [parameter(Mandatory = $true)]
        [System.Object[]]
        $Current,

        [parameter(Mandatory = $true)]
        [System.Object[]]
        $Desired
    )
    if ($Current.Length -ne $Desired.Length)
    {
        return $false
    }

    foreach ($desiredSetting in $Desired)
    {
        $found = $false
        foreach ($currentSetting in $Current)
        {
            if ($currentSetting.Name -eq $desiredSetting.Name)
            {
                if ($currentSetting.Value -ne $desiredSetting.Value)
                {
                    return $false
                }
                $found = $true
            }
        }
        if (-not $found)
        {
            return $false
        }
    }
    return $true
}

function Get-M365DSCIntuneAppConfigurationPolicyCustomSettingsAsString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.ArrayList]
        $Settings
    )

    $StringContent = '@('
    $space = '                '
    $indent = '    '

    $i = 1
    foreach ($setting in $Settings)
    {
        if ($Settings.Count -gt 1)
        {
            $StringContent += "`r`n"
            $StringContent += "$space"
        }
        $StringContent += "MSFT_IntuneAppConfigurationPolicyCustomSetting { `r`n"
        $StringContent += "$($space)$($indent)name  = '" + $setting.name + "'`r`n"
        $StringContent += "$($space)$($indent)value = '" + $setting.value + "'`r`n"
        $StringContent += "$space}"

        $i++
    }

    $StringContent += ')'
    return $StringContent
}

function ConvertTo-M365DSCIntuneAppConfigurationPolicyCustomSettings
{
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.ArrayList]
        $Settings
    )

    $result = @()
    foreach ($setting in $Settings)
    {
        $currentSetting = @{
            name  = $setting.name
            value = $setting.value
        }
        $result += $currentSetting
    }
    return $result
}

Export-ModuleMember -Function *-TargetResource
