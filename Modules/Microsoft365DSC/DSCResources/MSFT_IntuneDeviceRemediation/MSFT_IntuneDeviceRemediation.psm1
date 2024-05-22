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

        [Parameter()]
        [System.String]
        $DetectionScriptContent,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DetectionScriptParameters,

        [Parameter()]
        [ValidateSet('deviceHealthScript','managedInstallerScript')]
        [System.String]
        $DeviceHealthScriptType,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $EnforceSignatureCheck,

        [Parameter()]
        [System.String]
        $Publisher,

        [Parameter()]
        [System.String]
        $RemediationScriptContent,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $RemediationScriptParameters,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.Boolean]
        $RunAs32Bit,

        [Parameter()]
        [ValidateSet('system','user')]
        [System.String]
        $RunAsAccount,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

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
        $ManagedIdentity
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
        $getValue = Get-MgBetaDeviceManagementDeviceHealthScript -DeviceHealthScriptId $Id -ErrorAction SilentlyContinue

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Device Remediation with Id {$Id}"

            if (-Not [string]::IsNullOrEmpty($DisplayName))
            {
                $getValue = Get-MgBetaDeviceManagementDeviceHealthScript `
                    -Filter "DisplayName eq '$DisplayName'" `
                    -ErrorAction SilentlyContinue | Where-Object `
                    -FilterScript { `
                        $_.DeviceHealthScriptType -eq "deviceHealthScript" `
                    }
                if ($null -ne $getValue)
                {
                    $getValue = Get-MgBetaDeviceManagementDeviceHealthScript -DeviceHealthScriptId $getValue.Id
                }
            }
        }
        #endregion
        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Device Remediation with DisplayName {$DisplayName}"
            return $nullResult
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Device Remediation with Id {$Id} and DisplayName {$DisplayName} was found."

        #region resource generator code
        $complexDetectionScriptParameters = @()
        foreach ($currentDetectionScriptParameters in $getValue.detectionScriptParameters)
        {
            $myDetectionScriptParameters = @{}
            $myDetectionScriptParameters.Add('ApplyDefaultValueWhenNotAssigned', $currentDetectionScriptParameters.applyDefaultValueWhenNotAssigned)
            $myDetectionScriptParameters.Add('Description', $currentDetectionScriptParameters.description)
            $myDetectionScriptParameters.Add('IsRequired', $currentDetectionScriptParameters.isRequired)
            $myDetectionScriptParameters.Add('Name', $currentDetectionScriptParameters.name)
            $myDetectionScriptParameters.Add('DefaultValue', $currentDetectionScriptParameters.defaultValue)
            if ($null -ne $currentDetectionScriptParameters.'@odata.type')
            {
                $myDetectionScriptParameters.Add('odataType', $currentDetectionScriptParameters.'@odata.type'.toString())
            }
            if ($myDetectionScriptParameters.values.Where({$null -ne $_}).count -gt 0)
            {
                $complexDetectionScriptParameters += $myDetectionScriptParameters
            }
        }

        $complexRemediationScriptParameters = @()
        foreach ($currentRemediationScriptParameters in $getValue.remediationScriptParameters)
        {
            $myRemediationScriptParameters = @{}
            $myRemediationScriptParameters.Add('ApplyDefaultValueWhenNotAssigned', $currentRemediationScriptParameters.applyDefaultValueWhenNotAssigned)
            $myRemediationScriptParameters.Add('Description', $currentRemediationScriptParameters.description)
            $myRemediationScriptParameters.Add('IsRequired', $currentRemediationScriptParameters.isRequired)
            $myRemediationScriptParameters.Add('Name', $currentRemediationScriptParameters.name)
            $myRemediationScriptParameters.Add('DefaultValue', $currentRemediationScriptParameters.defaultValue)
            if ($null -ne $currentRemediationScriptParameters.'@odata.type')
            {
                $myRemediationScriptParameters.Add('odataType', $currentRemediationScriptParameters.'@odata.type'.toString())
            }
            if ($myRemediationScriptParameters.values.Where({$null -ne $_}).count -gt 0)
            {
                $complexRemediationScriptParameters += $myRemediationScriptParameters
            }
        }
        #endregion

        #region resource generator code
        $enumDeviceHealthScriptType = $null
        if ($null -ne $getValue.DeviceHealthScriptType)
        {
            $enumDeviceHealthScriptType = $getValue.DeviceHealthScriptType.ToString()
        }

        $enumRunAsAccount = $null
        if ($null -ne $getValue.RunAsAccount)
        {
            $enumRunAsAccount = $getValue.RunAsAccount.ToString()
        }
        #endregion

        $results = @{
            #region resource generator code
            Description                 = $getValue.Description
            DetectionScriptContent      = [System.Convert]::ToBase64String($getValue.DetectionScriptContent)
            DetectionScriptParameters   = $complexDetectionScriptParameters
            DeviceHealthScriptType      = $enumDeviceHealthScriptType
            DisplayName                 = $getValue.DisplayName
            EnforceSignatureCheck       = $getValue.EnforceSignatureCheck
            Publisher                   = $getValue.Publisher
            RemediationScriptContent    = [System.Convert]::ToBase64String($getValue.RemediationScriptContent)
            RemediationScriptParameters = $complexRemediationScriptParameters
            RoleScopeTagIds             = $getValue.RoleScopeTagIds
            RunAs32Bit                  = $getValue.RunAs32Bit
            RunAsAccount                = $enumRunAsAccount
            Id                          = $getValue.Id
            Ensure                      = 'Present'
            Credential                  = $Credential
            ApplicationId               = $ApplicationId
            TenantId                    = $TenantId
            ApplicationSecret           = $ApplicationSecret
            CertificateThumbprint       = $CertificateThumbprint
            Managedidentity             = $ManagedIdentity.IsPresent
            #endregion
        }
        $assignmentsValues = Get-MgBetaDeviceManagementDeviceHealthScriptAssignment -DeviceHealthScriptId $Id
        $assignmentResult = @()
        foreach ($assignmentEntry in $AssignmentsValues)
        {
            $assignmentValue = @{
                dataType = $assignmentEntry.Target.AdditionalProperties.'@odata.type'
                deviceAndAppManagementAssignmentFilterType = $(if ($null -ne $assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterType)
                    {$assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterType.ToString()})
                deviceAndAppManagementAssignmentFilterId = $assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterId
                groupId = $assignmentEntry.Target.AdditionalProperties.groupId
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
        #region resource generator code
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DetectionScriptContent,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DetectionScriptParameters,

        [Parameter()]
        [ValidateSet('deviceHealthScript','managedInstallerScript')]
        [System.String]
        $DeviceHealthScriptType,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $EnforceSignatureCheck,

        [Parameter()]
        [System.String]
        $Publisher,

        [Parameter()]
        [System.String]
        $RemediationScriptContent,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $RemediationScriptParameters,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.Boolean]
        $RunAs32Bit,

        [Parameter()]
        [ValidateSet('system','user')]
        [System.String]
        $RunAsAccount,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

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
        $ManagedIdentity
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

    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Device Remediation with DisplayName {$DisplayName}"
        $BoundParameters.Remove("Assignments") | Out-Null

        $CreateParameters = ([Hashtable]$BoundParameters).clone()
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters
        $CreateParameters.Add('IsGlobalScript', $false) | Out-Null
        $CreateParameters.DetectionScriptContent = [System.Convert]::FromBase64String($CreateParameters.DetectionScriptContent)
        $CreateParameters.RemediationScriptContent = [System.Convert]::FromBase64String($CreateParameters.RemediationScriptContent)
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
        $CreateParameters.Add("@odata.type", "#microsoft.graph.DeviceHealthScript")
        $policy = New-MgBetaDeviceManagementDeviceHealthScript -BodyParameter $CreateParameters
        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }

        if ($policy.id)
        {
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId  $policy.id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/deviceHealthScripts'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Device Remediation with Id {$($currentInstance.Id)}"
        $BoundParameters.Remove("Assignments") | Out-Null

        $UpdateParameters = ([Hashtable]$BoundParameters).clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters
        $UpdateParameters.DetectionScriptContent = [System.Convert]::FromBase64String($UpdateParameters.DetectionScriptContent)
        $UpdateParameters.RemediationScriptContent = [System.Convert]::FromBase64String($UpdateParameters.RemediationScriptContent)
        $UpdateParameters.Remove('DeviceHealthScriptType') | Out-Null
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
        $UpdateParameters.Add("@odata.type", "#microsoft.graph.DeviceHealthScript")
        Update-MgBetaDeviceManagementDeviceHealthScript  `
            -DeviceHealthScriptId $currentInstance.Id `
            -BodyParameter $UpdateParameters
        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentInstance.id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/deviceHealthScripts'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Device Remediation with Id {$($currentInstance.Id)}" 
        #region resource generator code
        Remove-MgBetaDeviceManagementDeviceHealthScript -DeviceHealthScriptId $currentInstance.Id
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

        [Parameter()]
        [System.String]
        $DetectionScriptContent,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DetectionScriptParameters,

        [Parameter()]
        [ValidateSet('deviceHealthScript','managedInstallerScript')]
        [System.String]
        $DeviceHealthScriptType,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $EnforceSignatureCheck,

        [Parameter()]
        [System.String]
        $Publisher,

        [Parameter()]
        [System.String]
        $RemediationScriptContent,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $RemediationScriptParameters,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.Boolean]
        $RunAs32Bit,

        [Parameter()]
        [ValidateSet('system','user')]
        [System.String]
        $RunAsAccount,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

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
        $ManagedIdentity
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

    Write-Verbose -Message "Testing configuration of the Intune Device Remediation with Id {$Id} and DisplayName {$DisplayName}"

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

            if (-Not $testResult)
            {
                $testResult = $false
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    $ValuesToCheck.remove('Id') | Out-Null
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null

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
        $ManagedIdentity
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
        # Only export scripts that are not from Microsoft
        [array]$getValue = Get-MgBetaDeviceManagementDeviceHealthScript `
            -Filter $Filter `
            -All `
            -ErrorAction Stop | Where-Object -FilterScript {
                $_.IsGlobalScript -eq $false
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
                Id = $config.Id
                DisplayName           =  $config.DisplayName
                Ensure = 'Present'
                Credential = $Credential
                ApplicationId = $ApplicationId
                TenantId = $TenantId
                ApplicationSecret = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity = $ManagedIdentity.IsPresent
            }

            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            if ($null -ne $Results.DetectionScriptParameters)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.DetectionScriptParameters `
                    -CIMInstanceName 'MicrosoftGraphdeviceHealthScriptParameter'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.DetectionScriptParameters = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('DetectionScriptParameters') | Out-Null
                }
            }
            if ($null -ne $Results.RemediationScriptParameters)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.RemediationScriptParameters `
                    -CIMInstanceName 'MicrosoftGraphdeviceHealthScriptParameter'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.RemediationScriptParameters = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('RemediationScriptParameters') | Out-Null
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
            if ($Results.DetectionScriptParameters)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "DetectionScriptParameters" -isCIMArray:$True
            }
            if ($Results.RemediationScriptParameters)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "RemediationScriptParameters" -isCIMArray:$True
            }
            if ($Results.Assignments)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "Assignments" -isCIMArray:$true
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
        Write-Host $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
