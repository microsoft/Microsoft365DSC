function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $True)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $ProcessCreationType,

        [Parameter()]
        [ValidateSet("notConfigured","userDefined", "enable","auditMode")]
        [System.String]
        $AdvancedRansomewareProtectionType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $BlockPersistenceThroughWmiType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $ScriptObfuscatedMacroCodeType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $OfficeMacroCodeAllowWin32ImportsType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $OfficeAppsLaunchChildProcessType,

        [Parameter()]
        [ValidateSet("userDefined", "enable","auditMode", "blockDiskModification", "auditDiskModification")]
        [System.String]
        $GuardMyFoldersType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $UntrustedUSBProcessType,

        [Parameter()]
        [System.String[]]
        $AttackSurfaceReductionExcludedPaths,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $UntrustedExecutableType,

        [Parameter()]
        [ValidateSet("notConfigured", "enable","auditMode", "warn", "disable")]
        [System.String]
        $OfficeCommunicationAppsLaunchChildProcess,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $EmailContentExecutionType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $ScriptDownloadedPayloadExecutionType,

        [Parameter()]
        [System.String[]]
        $AdditionalGuardedFolders,

        [Parameter()]
        [ValidateSet("notConfigured","userDefined", "enable","auditMode", "warn")]
        [System.String]
        $AdobeReaderLaunchChildProcess,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $OfficeAppsExecutableContentCreationOrLaunchType,

        [Parameter()]
        [ValidateSet("notConfigured","userDefined", "enable","auditMode", "warn")]
        [System.String]
        $PreventCredentialStealingType,

        [Parameter()]
        [ValidateSet("userDefined","block","auditMode", "warn", "disable")]
        [System.String]
        $OfficeAppsOtherProcessInjectionType,

        [Parameter()]
        [System.String[]]
        $GuardedFoldersAllowedAppPaths,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter(Mandatory = $True)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = "Present",

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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Checking for the Intune Endpoint Protection Attack Surface Protection rules Policy {$DisplayName}"

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -ProfileName 'beta' -ErrorAction Stop

    $context=Get-MgContext
    if($null -eq $context)
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters -ProfileName 'beta' -ErrorAction Stop
    }

    Write-Verbose -Message "Select-MgProfile"
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'

    try
    {
        #Retrieve policy general settings
        try
        {
            $policy = Get-MgDeviceManagementIntent -DeviceManagementIntentId $Identity -ErrorAction Stop
        }
        catch
        {
            Write-Verbose -Message "No Endpoint Protection Attack Surface Protection rules Policy {$DisplayName} was found"
            return $nullResult
        }

        if ($null -eq $policy)
        {
            Write-Verbose -Message "No Endpoint Protection Attack Surface Protection rules Policy {$DisplayName} was found"
            return $nullResult
        }

        #Retrieve policy specific settings
        [array]$settings = Get-MgDeviceManagementIntentSetting `
            -DeviceManagementIntentId $Identity `
            -ErrorAction Stop

        $definitionIdPrefix="windows10EndpointProtectionConfiguration_defender"
        $returnHashtable=@{}
        $returnHashtable.Add("Identity",$Identity)
        $returnHashtable.Add("DisplayName",$policy.DisplayName)
        $returnHashtable.Add("Description",$policy.Description)

        foreach ($setting in $settings)
        {
            $settingName=$setting.definitionId.replace("deviceConfiguration--$definitionIdPrefix","")
            $settingValue= ($settings|Where-Object `
                -FilterScript {$_.DefinitionId -like "*$settingName"}).ValueJson| ConvertFrom-Json
            $returnHashtable.Add($settingName,$settingValue)
        }

        Write-Verbose -Message "Found Endpoint Protection Attack Surface Protection rules Policy {$DisplayName}"

        $returnHashtable.Add("Ensure","Present")
        $returnHashtable.Add("Credential",$Credential)
        $returnHashtable.Add("ApplicationId",$ApplicationId)
        $returnHashtable.Add("TenantId",$TenantId)
        $returnHashtable.Add("ApplicationSecret",$ApplicationSecret)
        $returnHashtable.Add("CertificateThumbprint",$CertificateThumbprint)

        $returnAssignments=@()
        $returnAssignments+=Get-MgDeviceManagementIntentAssignment -DeviceManagementIntentId $policy.Id
        $assignmentResult = @()
        foreach ($assignmentEntry in $returnAssignments)
        {
            $assignmentValue = @{
                dataType = $assignmentEntry.Target.AdditionalProperties.'@odata.type'
                deviceAndAppManagementAssignmentFilterType = $assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterType.toString()
                deviceAndAppManagementAssignmentFilterId = $assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterId
                groupId = $assignmentEntry.Target.AdditionalProperties.groupId
            }
            $assignmentResult += $assignmentValue
        }
        $returnHashtable.Add('Assignments',$assignmentResult)

        return $returnHashtable
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            $tenantIdValue = $Credential.UserName.Split('@')[1]
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return $nullResult
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $True)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $ProcessCreationType,

        [Parameter()]
        [ValidateSet("notConfigured","userDefined", "enable","auditMode")]
        [System.String]
        $AdvancedRansomewareProtectionType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $BlockPersistenceThroughWmiType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $ScriptObfuscatedMacroCodeType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $OfficeMacroCodeAllowWin32ImportsType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $OfficeAppsLaunchChildProcessType,

        [Parameter()]
        [ValidateSet("userDefined", "enable","auditMode", "blockDiskModification", "auditDiskModification")]
        [System.String]
        $GuardMyFoldersType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $UntrustedUSBProcessType,

        [Parameter()]
        [System.String[]]
        $AttackSurfaceReductionExcludedPaths,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $UntrustedExecutableType,

        [Parameter()]
        [ValidateSet("notConfigured", "enable","auditMode", "warn", "disable")]
        [System.String]
        $OfficeCommunicationAppsLaunchChildProcess,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $EmailContentExecutionType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $ScriptDownloadedPayloadExecutionType,

        [Parameter()]
        [System.String[]]
        $AdditionalGuardedFolders,

        [Parameter()]
        [ValidateSet("notConfigured","userDefined", "enable","auditMode", "warn")]
        [System.String]
        $AdobeReaderLaunchChildProcess,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $OfficeAppsExecutableContentCreationOrLaunchType,

        [Parameter()]
        [ValidateSet("notConfigured","userDefined", "enable","auditMode", "warn")]
        [System.String]
        $PreventCredentialStealingType,

        [Parameter()]
        [ValidateSet("userDefined","block","auditMode", "warn", "disable")]
        [System.String]
        $OfficeAppsOtherProcessInjectionType,

        [Parameter()]
        [System.String[]]
        $GuardedFoldersAllowedAppPaths,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter(Mandatory = $True)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = "Present",

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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -ProfileName 'beta'

    Select-MgProfile -Name 'beta'
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentPolicy = Get-TargetResource @PSBoundParameters
    $PSBoundParameters.Remove("Ensure") | Out-Null
    $PSBoundParameters.Remove("Credential") | Out-Null
    $PSBoundParameters.Remove("ApplicationId") | Out-Null
    $PSBoundParameters.Remove("TenantId") | Out-Null
    $PSBoundParameters.Remove("ApplicationSecret") | Out-Null
    $PSBoundParameters.Remove("CertificateThumbprint") | Out-Null

    $policyTemplateID='0e237410-1367-4844-bd7f-15fb0f08943b'
    $definitionIdPrefix="windows10EndpointProtectionConfiguration_defender"

    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Endpoint Protection Attack Surface Protection rules Policy {$DisplayName}"
        $PSBoundParameters.Remove('Identity') | Out-Null
        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $settings = Get-M365DSCIntuneDeviceConfigurationSettings `
            -Properties ([System.Collections.Hashtable]$PSBoundParameters) `
            -DefinitionIdPrefix $definitionIdPrefix

        $policy=New-MgDeviceManagementIntent -DisplayName $DisplayName `
            -Description $Description `
            -TemplateId $policyTemplateID `
            -Settings $settings

        #region Assignments
        $assignmentsHash=@()
        foreach($assignment in $Assignments)
        {
            $assignmentsHash+=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }
        if($policy.id)
        {
            Update-DeviceManagementIntentAssignments -DeviceManagementIntentId $policy.id `
                -Targets $assignmentsHash
        }
        #endregion

    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Endpoint Protection Attack Surface Protection rules Policy {$DisplayName}"

        $PSBoundParameters.Remove('Identity') | Out-Null
        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $settings = Get-M365DSCIntuneDeviceConfigurationSettings `
            -Properties ([System.Collections.Hashtable]$PSBoundParameters) `
            -DefinitionIdPrefix $definitionIdPrefix

        Update-MgDeviceManagementIntent -ErrorAction Stop `
            -DisplayName $DisplayName `
            -Description $Description `
            -DeviceManagementIntentId $Identity

        $currentSettings=Get-MgDeviceManagementIntentSetting `
            -DeviceManagementIntentId $Identity `
            -ErrorAction Stop

        foreach($setting in $settings)
        {
            $mySetting=$currentSettings|Where-Object{$_.DefinitionId -eq $setting.DefinitionId}
            $setting.add("id",$mySetting.Id)
        }
        $Uri="https://graph.microsoft.com/beta/deviceManagement/intents/$Identity/updateSettings"
        $body=@{"settings"=$settings}
        write-verbose -message ($body|ConvertTo-Json -Depth 20)
        Invoke-MgGraphRequest -Method POST -Uri $Uri -Body ($body|ConvertTo-Json -Depth 20) -ContentType "application/json" -ErrorAction Stop

        #region Assignments
        $assignmentsHash=@()
        foreach($assignment in $Assignments)
        {
            $assignmentsHash+=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }
        Update-DeviceManagementIntentAssignments -DeviceManagementIntentId $Identity `
            -Targets $assignmentsHash
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Endpoint Protection Attack Surface Protection rules Policy {$DisplayName}"
        Remove-MgDeviceManagementIntent -DeviceManagementIntentId $Identity -Confirm:$false -ErrorAction Stop
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $True)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $ProcessCreationType,

        [Parameter()]
        [ValidateSet("notConfigured","userDefined", "enable","auditMode")]
        [System.String]
        $AdvancedRansomewareProtectionType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $BlockPersistenceThroughWmiType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $ScriptObfuscatedMacroCodeType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $OfficeMacroCodeAllowWin32ImportsType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $OfficeAppsLaunchChildProcessType,

        [Parameter()]
        [ValidateSet("userDefined", "enable","auditMode", "blockDiskModification", "auditDiskModification")]
        [System.String]
        $GuardMyFoldersType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $UntrustedUSBProcessType,

        [Parameter()]
        [System.String[]]
        $AttackSurfaceReductionExcludedPaths,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $UntrustedExecutableType,

        [Parameter()]
        [ValidateSet("notConfigured", "enable","auditMode", "warn", "disable")]
        [System.String]
        $OfficeCommunicationAppsLaunchChildProcess,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $EmailContentExecutionType,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $ScriptDownloadedPayloadExecutionType,

        [Parameter()]
        [System.String[]]
        $AdditionalGuardedFolders,

        [Parameter()]
        [ValidateSet("notConfigured","userDefined", "enable","auditMode", "warn")]
        [System.String]
        $AdobeReaderLaunchChildProcess,

        [Parameter()]
        [ValidateSet("userDefined", "block","auditMode", "warn", "disable")]
        [System.String]
        $OfficeAppsExecutableContentCreationOrLaunchType,

        [Parameter()]
        [ValidateSet("notConfigured","userDefined", "enable","auditMode", "warn")]
        [System.String]
        $PreventCredentialStealingType,

        [Parameter()]
        [ValidateSet("userDefined","block","auditMode", "warn", "disable")]
        [System.String]
        $OfficeAppsOtherProcessInjectionType,

        [Parameter()]
        [System.String[]]
        $GuardedFoldersAllowedAppPaths,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter(Mandatory = $True)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = "Present",

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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    Write-Verbose -Message "Testing configuration of Endpoint Protection Attack Surface Protection rules Policy {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null

    #region Assignments
    $testResult=$true

    if((-not $CurrentValues.Assignments) -xor (-not $ValuesToCheck.Assignments))
    {
        Write-Verbose -Message "Configuration drift: one the assignment is null"
        return $false
    }

    if($CurrentValues.Assignments)
    {
        if($CurrentValues.Assignments.count -ne $ValuesToCheck.Assignments.count)
        {
            Write-Verbose -Message "Configuration drift: Number of assignment has changed - current {$($CurrentValues.Assignments.count)} target {$($ValuesToCheck.Assignments.count)}"
            return $false
        }
        foreach($assignment in $CurrentValues.Assignments)
        {
            #GroupId Assignment
            if(-not [String]::IsNullOrEmpty($assignment.groupId))
            {
                $source=[Array]$ValuesToCheck.Assignments|Where-Object -FilterScript {$_.groupId -eq $assignment.groupId}
                if(-not $source)
                {
                    Write-Verbose -Message "Configuration drift: groupId {$($assignment.groupId)} not found"
                    $testResult=$false
                    break;
                }
                $sourceHash=Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $source
                $testResult=Compare-M365DSCComplexObject -Source $sourceHash -Target $assignment
            }
            #AllDevices/AllUsers assignment
            else
            {
                $source=[Array]$ValuesToCheck.Assignments|Where-Object -FilterScript {$_.dataType -eq $assignment.dataType}
                if(-not $source)
                {
                    Write-Verbose -Message "Configuration drift: {$($assignment.dataType)} not found"
                    $testResult=$false
                    break;
                }
                $sourceHash=Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $source
                $testResult=Compare-M365DSCComplexObject -Source $sourceHash -Target $assignment
            }

            if(-not $testResult)
            {
                $testResult=$false
                break;
            }

        }
    }
    if(-not $testResult)
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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload:$true

    Select-MgProfile -Name 'Beta'
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $dscContent = ''
    $i = 1

    try
    {
        $policyTemplateID = '0e237410-1367-4844-bd7f-15fb0f08943b'
        [array]$policies = Get-MgDeviceManagementIntent `
            -ErrorAction Stop `
            -All:$true `
            -Filter $Filter `
            | Where-Object -FilterScript {$_.TemplateId -eq $policyTemplateID}

        if ($policies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewLine
        }
        foreach ($policy in $policies)
        {
            Write-Host "    |---[$i/$($policies.Count)] $($policy.DisplayName)" -NoNewline

            $params = @{
                Identity                            = $policy.Id
                Ensure                              = 'Present'
                Credential                          = $Credential
                ApplicationId                       = $ApplicationId
                TenantId                            = $TenantId
                ApplicationSecret                   = $ApplicationSecret
                CertificateThumbprint               = $CertificateThumbprint
            }

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

            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential

            if ($Results.Assignments)
            {
                $isCIMArray=$false
                if($Results.Assignments.getType().Fullname -like "*[[\]]")
                {
                    $isCIMArray=$true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "Assignments" -isCIMArray:$isCIMArray
            }

            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName

            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++

        }
        return $dscContent
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX
        if ($_.Exception -like '*401*')
        {
            Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = $Credential.UserName.Split('@')[1]

            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return ""
    }
}

function Get-M365DSCIntuneDeviceConfigurationSettings
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties,
        [Parameter()]
        [System.String]
        $DefinitionIdPrefix
    )

    $results = @()
    foreach ($property in $properties.Keys)
    {
        if ($property -ne 'Verbose')
        {
            $setting=@{}
            switch (($properties.$property.gettype()).name) {
                "String" {$settingType="#microsoft.graph.deviceManagementStringSettingInstance"}
                "Boolean" {$settingType="#microsoft.graph.deviceManagementBooleanSettingInstance"}
                "Int32" {$settingType="#microsoft.graph.deviceManagementIntegerSettingInstance"}
                "String[]" {$settingType="#microsoft.graph.deviceManagementCollectionSettingInstance"}
                Default {$settingType="#microsoft.graph.deviceManagementComplexSettingInstance"}
            }
            $settingDefinitionIdPrefix="deviceConfiguration--$DefinitionIdPrefix"
            $settingDefinitionId =$settingDefinitionIdPrefix + $property
            $setting.Add("@odata.type",$settingType)
            $setting.Add("definitionId", $settingDefinitionId)
            if("String[]" -eq ($properties.$property.gettype()).name -and $properties.$property.count -eq 0 )
            {
                $setting.Add("valueJson", "[]")
            }
            else
            {
                $setting.Add("valueJson", ($properties.$property|ConvertTo-Json))
            }

            $results+=$setting
        }
    }
    return $results
}

function Update-DeviceManagementIntentAssignments
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceManagementIntentId,

        [Parameter()]
        [Array]
        $Targets
    )
    try
    {
        $configurationPolicyAssignments=@()

        $Uri="https://graph.microsoft.com/beta/deviceManagement/intents/$DeviceManagementIntentId/assign"

        foreach($target in $targets)
        {
            $formattedTarget=@{"@odata.type"=$target.dataType}
            if($target.groupId)
            {
                $formattedTarget.Add('groupId',$target.groupId)
            }
            if($target.collectionId)
            {
                $formattedTarget.Add('collectionId',$target.collectionId)
            }
            if($target.deviceAndAppManagementAssignmentFilterType)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterType',$target.deviceAndAppManagementAssignmentFilterType)
            }
            if($target.deviceAndAppManagementAssignmentFilterId)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterId',$target.deviceAndAppManagementAssignmentFilterId)
            }
            $configurationPolicyAssignments+=@{'target'= $formattedTarget}
        }
        $body=@{'assignments'=$configurationPolicyAssignments}|ConvertTo-Json -Depth 20
        #write-verbose -Message $body
        Invoke-MgGraphRequest -Method POST -Uri $Uri -Body $body -ErrorAction Stop

    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            $tenantIdValue = $Credential.UserName.Split('@')[1]
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return $null
    }


}

function Get-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    param(
        [Parameter()]
        $ComplexObject
    )

    if($null -eq $ComplexObject)
    {
        return $null
    }

    if($ComplexObject.gettype().fullname -like "*[[\]]")
    {
        $results=@()

        foreach($item in $ComplexObject)
        {
            if($item)
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
                $results+=$hash
            }
        }
        if($results.count -eq 0)
        {
            return $null
        }
        return $results
    }

    $results = @{}
    $keys = $ComplexObject | Get-Member | Where-Object -FilterScript {$_.MemberType -eq 'Property' -and $_.Name -ne 'AdditionalProperties'}

    foreach ($key in $keys)
    {
        if($ComplexObject.$($key.Name))
        {
            $results.Add($key.Name, $ComplexObject.$($key.Name))
        }
    }
    if($results.count -eq 0)
    {
        return $null
    }
    return $results
}

function Get-M365DSCDRGComplexTypeToString
{
    [CmdletBinding()]
    #[OutputType([System.String])]
    param(
        [Parameter()]
        $ComplexObject,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CIMInstanceName,

        [Parameter()]
        [System.String]
        $Whitespace="",

        [Parameter()]
        [switch]
        $isArray=$false
    )
    if ($null -eq $ComplexObject)
    {
        return $null
    }

    #If ComplexObject  is an Array
    if ($ComplexObject.GetType().FullName -like "*[[\]]")
    {
        $currentProperty=@()
        foreach ($item in $ComplexObject)
        {
            $currentProperty += Get-M365DSCDRGComplexTypeToString `
                -ComplexObject $item `
                -isArray:$true `
                -CIMInstanceName $CIMInstanceName `
                -Whitespace "                "

        }
        if ([string]::IsNullOrEmpty($currentProperty))
        {
            return $null
        }
        return $currentProperty

    }

    #If ComplexObject is a single CIM Instance
    if(-Not (Test-M365DSCComplexObjectHasValues -ComplexObject $ComplexObject))
    {
        return $null
    }
    $currentProperty=""
    if($isArray)
    {
        $currentProperty += "`r`n"
    }
    $currentProperty += "$whitespace`MSFT_$CIMInstanceName{`r`n"
    $keyNotNull = 0
    foreach ($key in $ComplexObject.Keys)
    {
        if ($ComplexObject[$key])
        {
            $keyNotNull++

            if ($ComplexObject[$key].GetType().FullName -like "Microsoft.Graph.PowerShell.Models.*")
            {
                $hashPropertyType=$ComplexObject[$key].GetType().Name.tolower()
                $hashProperty=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject[$key]

                if (Test-M365DSCComplexObjectHasValues -ComplexObject $hashProperty)
                {
                    $Whitespace+="            "
                    if(-not $isArray)
                    {
                        $currentProperty += "                " + $key + " = "
                    }
                    $currentProperty += Get-M365DSCDRGComplexTypeToString `
                                    -ComplexObject $hashProperty `
                                    -CIMInstanceName $hashPropertyType `
                                    -Whitespace $Whitespace
                }
            }
            else
            {
                if(-not $isArray)
                {
                    $Whitespace= "            "
                }
                $currentProperty += Get-M365DSCDRGSimpleObjectTypeToString -Key $key -Value $ComplexObject[$key] -Space ($Whitespace+"    ")
            }
        }
    }
    $currentProperty += "            }"

    if ($keyNotNull -eq 0)
    {
        $currentProperty = $null
    }

    return $currentProperty
}
function Test-M365DSCComplexObjectHasValues
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $ComplexObject
    )
    $keys=$ComplexObject.keys
    $hasValue=$false
    foreach($key in $keys)
    {
        if($ComplexObject[$key])
        {
            if($ComplexObject[$key].GetType().FullName -like "Microsoft.Graph.PowerShell.Models.*")
            {
                $hash=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject[$key]
                if(-Not $hash)
                {
                    return $false
                }
                $hasValue=Test-M365DSCComplexObjectHasValues -ComplexObject ($hash)
            }
            else
            {
                $hasValue=$true
                return $hasValue
            }
        }
    }
    return $hasValue
}
Function Get-M365DSCDRGSimpleObjectTypeToString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.String]
        $Key,

        [Parameter(Mandatory = 'true')]
        $Value,

        [Parameter()]
        [System.String]
        $Space="                "

    )

    $returnValue=""
    switch -Wildcard ($Value.GetType().Fullname )
    {
        "*.Boolean"
        {
            $returnValue= $Space + $Key + " = `$" + $Value.ToString() + "`r`n"
        }
        "*.String"
        {
            if($key -eq '@odata.type')
            {
                $key='odataType'
            }
            $returnValue= $Space + $Key + " = '" + $Value + "'`r`n"
        }
        "*.DateTime"
        {
            $returnValue= $Space + $Key + " = '" + $Value + "'`r`n"
        }
        "*[[\]]"
        {
            $returnValue= $Space + $key + " = @("
            $whitespace=""
            $newline=""
            if($Value.count -gt 1)
            {
                $returnValue += "`r`n"
                $whitespace=$Space+"    "
                $newline="`r`n"
            }
            foreach ($item in $Value)
            {
                switch -Wildcard ($item.GetType().Fullname )
                {
                    "*.String"
                    {
                        $returnValue += "$whitespace'$item'$newline"
                    }
                    "*.DateTime"
                    {
                        $returnValue += "$whitespace'$item'$newline"
                    }
                    Default
                    {
                        $returnValue += "$whitespace$item$newline"
                    }
                }
            }
            if($Value.count -gt 1)
            {
                $returnValue += "$Space)`r`n"
            }
            else
            {
                $returnValue += ")`r`n"

            }
        }
        Default
        {
            $returnValue= $Space + $Key + " = " + $Value + "`r`n"
        }
    }
    return $returnValue
}
function Compare-M365DSCComplexObject
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [Parameter()]
        [System.Collections.Hashtable]
        $Source,
        [Parameter()]
        [System.Collections.Hashtable]
        $Target
    )

    $keys= $Source.Keys|Where-Object -FilterScript {$_ -ne "PSComputerName"}
    foreach ($key in $keys)
    {
        write-verbose -message "Comparing key: {$key}"
        $skey=$key
        if($key -eq 'odataType')
        {
            $skey='@odata.type'
        }

        #Marking Target[key] to null if empty complex object or array
        if($null -ne $Target[$key])
        {
            switch -Wildcard ($Target[$key].getType().Fullname )
            {
                "Microsoft.Graph.PowerShell.Models.*"
                {
                    $hashProperty=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Target[$key]
                    if(-not (Test-M365DSCComplexObjectHasValues -ComplexObject $hashProperty))
                    {
                        $Target[$key]=$null
                    }
                }
                "*[[\]]"
                {
                    if($Target[$key].count -eq 0)
                    {
                        $Target[$key]=$null
                    }
                }
            }
        }
        $sourceValue=$Source[$key]
        $targetValue=$Target[$key]
        #One of the item is null
        if (($null -eq $Source[$skey]) -xor ($null -eq $Target[$key]))
        {
            if($null -eq $Source[$skey])
            {
                $sourceValue="null"
            }

            if($null -eq $Target[$key])
            {
                $targetValue="null"
            }
            Write-Verbose -Message "Configuration drift - key: $key Source{$sourceValue} Target{$targetValue}"
            return $false
        }
        #Both source and target aren't null or empty
        if(($null -ne $Source[$skey]) -and ($null -ne $Target[$key]))
        {
            if($Source[$skey].getType().FullName -like "*CimInstance*")
            {
                #Recursive call for complex object
                $compareResult= Compare-M365DSCComplexObject `
                    -Source (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Source[$skey]) `
                    -Target (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Target[$key])

                if(-not $compareResult)
                {
                    Write-Verbose -Message "Configuration drift - key: $key Source{$sourceValue} Target{$targetValue}"
                    return $false
                }
            }
            else
            {
                #Simple object comparison
                $referenceObject=$Target[$key]
                $differenceObject=$Source[$skey]

                $compareResult = Compare-Object `
                    -ReferenceObject ($referenceObject) `
                    -DifferenceObject ($differenceObject)

                if ($null -ne $compareResult)
                {
                    Write-Verbose -Message "Configuration drift - key: $key Source{$sourceValue} Target{$targetValue}"
                    return $false
                }

            }
        }
    }

    return $true
}

function Convert-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = 'true')]
        $ComplexObject
    )

    if($ComplexObject.getType().Fullname -like "*[[\]]")
    {
        $results=@()
        foreach($item in $ComplexObject)
        {
            $hash=Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
            if(Test-M365DSCComplexObjectHasValues -ComplexObject $hash)
            {
                $results+=$hash
            }
        }
        if($results.count -eq 0)
        {
            return $null
        }
        return $Results
    }
    $hashComplexObject = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject
    if($hashComplexObject)
    {
        $results=$hashComplexObject.clone()
        $keys=$hashComplexObject.Keys|Where-Object -FilterScript {$_ -ne 'PSComputerName'}
        foreach ($key in $keys)
        {
            if(($null -ne $hashComplexObject[$key]) -and ($hashComplexObject[$key].getType().Fullname -like "*CimInstance*"))
            {
                $results[$key]=Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $hashComplexObject[$key]
            }
            if($null -eq $results[$key])
            {
                $results.remove($key)|out-null
            }

        }
    }
    return $results
}

Export-ModuleMember -Function *-TargetResource
