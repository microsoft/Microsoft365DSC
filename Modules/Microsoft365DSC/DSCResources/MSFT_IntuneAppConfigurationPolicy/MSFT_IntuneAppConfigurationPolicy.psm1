function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [System.String]
        $Id,

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

    Write-Verbose -Message "Getting configuration of Intune App Configuration Policy with Id {$Id}"
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

        try {
            $configPolicy = Get-MgBetaDeviceAppManagementTargetedManagedAppConfiguration -TargetedManagedAppConfigurationId $Id `
                -ErrorAction Stop
        }
        catch {
            $configPolicy = $null
        }

        if ($null -eq $configPolicy)
        {
            Write-Verbose -Message "Could not find an Intune App Configuration Policy with Id {$Id}, searching by DisplayName {$DisplayName}"

            try
            {
                $configPolicy = Get-MgBetaDeviceAppManagementTargetedManagedAppConfiguration -Filter "displayName eq '$DisplayName'" `
                    -ErrorAction Stop
            }
            catch
            {
                $configPolicy = $null
            }

            if ($null -eq $configPolicy)
            {
                Write-Verbose -Message "No App Configuration Policy with DisplayName {$DisplayName} was found"
                return $nullResult
            }
        }

        Write-Verbose -Message "Found App Configuration Policy with Id {$($configPolicy.Id)} and DisplayName {$($configPolicy.DisplayName)}"
        $returnHashtable = @{
            Id                    = $configPolicy.Id
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
        [Parameter()]
        [System.String]
        $Id,

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
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $policy.id `
                -Targets $assignmentsHash `
                -Repository 'deviceAppManagement/targetedManagedAppConfigurations'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentconfigPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating Intune App Configuration Policy {$DisplayName}"

        $updateParams = @{
            targetedManagedAppConfigurationId = $currentconfigPolicy.Id
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
        Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $currentconfigPolicy.Id `
            -Targets $assignmentsHash `
            -Repository 'deviceAppManagement/targetedManagedAppConfigurations'
    }
    elseif ($Ensure -eq 'Absent' -and $currentconfigPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Intune App Configuration Policy {$DisplayName}"
        Remove-MgBetaDeviceAppManagementTargetedManagedAppConfiguration -TargetedManagedAppConfigurationId $currentconfigPolicy.Id
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
        $Id,

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
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()
    $ValuesToCheck = Remove-M365DSCAuthenticationParameter -BoundParameters $ValuesToCheck
    $ValuesToCheck.Remove('Id') | Out-Null

    if ($CurrentValues.Ensure -ne $PSBoundParameters.Ensure)
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }
    if ($CurrentValues.Ensure -eq 'Absent' -and $PSBoundParameters.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Test-TargetResource returned $true"
        return $true
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

            if ($key -eq "Assignments")
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

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    if ($TestResult)
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
                Id                    = $configPolicy.Id
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

function Get-M365DSCIntuneAppConfigurationPolicyCustomSettingsAsString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Object[]]
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
