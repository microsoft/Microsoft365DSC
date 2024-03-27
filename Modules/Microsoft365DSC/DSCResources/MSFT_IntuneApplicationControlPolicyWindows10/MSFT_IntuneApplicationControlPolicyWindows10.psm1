function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $True)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet('notConfigured', 'enforceComponentsAndStoreApps', 'auditComponentsAndStoreApps', 'enforceComponentsStoreAppsAndSmartlocker', 'auditComponentsStoreAppsAndSmartlocker')]
        [System.String]
        $AppLockerApplicationControl,

        [Parameter()]
        [System.Boolean]
        $SmartScreenBlockOverrideForFiles,

        [Parameter()]
        [System.Boolean]
        $SmartScreenEnableInShell,

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

    Write-Verbose -Message "Checking for the Intune Endpoint Protection Application Control Policy {$DisplayName}"

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters -ErrorAction Stop

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
        #Retrieve policy general settings
        $policy = Get-MgBetaDeviceManagementIntent -Filter "displayName eq '$DisplayName'" -ErrorAction Stop | Where-Object -FilterScript { $_.TemplateId -eq '63be6324-e3c9-4c97-948a-e7f4b96f0f20' }

        if(([array]$policy).count -gt 1)
        {
            throw "A policy with a duplicated displayName {'$DisplayName'} was found - Ensure displayName is unique"
        }

        if ($null -eq $policy)
        {
            Write-Verbose -Message "No Endpoint Protection Application Control Policy {$DisplayName} was found"
            return $nullResult
        }

        #Retrieve policy specific settings
        [array]$settings = Get-MgBetaDeviceManagementIntentSetting -DeviceManagementIntentId $policy.Id -ErrorAction Stop
        $settingAppLockerApplicationControl = ($settings | Where-Object -FilterScript { $_.DefinitionId -like '*appLockerApplicationControl' }).ValueJson.Replace("`"", '')
        $settingSmartScreenBlockOverrideForFiles = [System.Convert]::ToBoolean(($settings | Where-Object -FilterScript { $_.DefinitionId -like '*smartScreenBlockOverrideForFiles' }).ValueJson)
        $settingSmartScreenEnableInShell = [System.Convert]::ToBoolean(($settings | Where-Object -FilterScript { $_.DefinitionId -like '*smartScreenEnableInShell' }).ValueJson)
        Write-Verbose -Message "Found Endpoint Protection Application Control Policy {$DisplayName}"

        $returnHashtable = @{
            Description                      = $policy.Description
            DisplayName                      = $policy.DisplayName
            AppLockerApplicationControl      = $settingAppLockerApplicationControl
            SmartScreenBlockOverrideForFiles = $settingSmartScreenBlockOverrideForFiles
            SmartScreenEnableInShell         = $settingSmartScreenEnableInShell
            Ensure                           = 'Present'
            Credential                       = $Credential
            ApplicationId                    = $ApplicationId
            TenantId                         = $TenantId
            ApplicationSecret                = $ApplicationSecret
            CertificateThumbprint            = $CertificateThumbprint
        }

        $returnAssignments = @()
        $graphAssignments = Get-MgBetaDeviceManagementIntentAssignment -DeviceManagementIntentId $policy.Id
        if ($graphAssignments.count -gt 0)
        {
            $returnAssignments += ConvertFrom-IntunePolicyAssignment -Assignments $graphAssignments -IncludeDeviceFilter:$true
        }
        $returnHashtable.Add('Assignments', $returnAssignments)
        return $returnHashtable
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
    param
    (
        [Parameter(Mandatory = $True)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet('notConfigured', 'enforceComponentsAndStoreApps', 'auditComponentsAndStoreApps', 'enforceComponentsStoreAppsAndSmartlocker', 'auditComponentsStoreAppsAndSmartlocker')]
        [System.String]
        $AppLockerApplicationControl,

        [Parameter()]
        [System.Boolean]
        $SmartScreenBlockOverrideForFiles,

        [Parameter()]
        [System.Boolean]
        $SmartScreenEnableInShell,

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

    $currentPolicy = Get-TargetResource @PSBoundParameters
    $PSBoundParameters.Remove('Ensure') | Out-Null
    $PSBoundParameters.Remove('Credential') | Out-Null
    $PSBoundParameters.Remove('ApplicationId') | Out-Null
    $PSBoundParameters.Remove('TenantId') | Out-Null
    $PSBoundParameters.Remove('ApplicationSecret') | Out-Null
    $PSBoundParameters.Remove('CertificateThumbprint') | Out-Null
    $PSBoundParameters.Remove('ManagedIdentity') | Out-Null
    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Endpoint Protection Application Control Policy {$DisplayName}"
        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $Settings = Get-M365DSCIntuneEndpointProtectionPolicyWindowsSettings -Properties ([System.Collections.Hashtable]$PSBoundParameters)
        $policy = New-MgBetaDeviceManagementIntent -DisplayName $DisplayName `
            -Description $Description `
            -TemplateId '63be6324-e3c9-4c97-948a-e7f4b96f0f20' `
            -Settings $Settings

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
                -Repository 'deviceManagement/intents'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Endpoint Protection Application Control Policy {$DisplayName}"
        $appControlPolicy = Get-MgBetaDeviceManagementIntent `
            -ErrorAction Stop | Where-Object `
            -FilterScript { $_.TemplateId -eq '63be6324-e3c9-4c97-948a-e7f4b96f0f20' -and `
                $_.displayName -eq $($DisplayName) }

        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $Settings = Get-M365DSCIntuneEndpointProtectionPolicyWindowsSettings -Properties ([System.Collections.Hashtable]$PSBoundParameters)
        Update-MgBetaDeviceManagementIntent -ErrorAction Stop `
            -Description $Description `
            -DeviceManagementIntentId $appControlPolicy.Id

        $currentSettings = Get-MgBetaDeviceManagementIntentSetting -DeviceManagementIntentId $appControlPolicy.Id -ErrorAction Stop
        foreach ($setting in $Settings)
        {
            $s = $currentSettings | Where-Object { $_.DefinitionId -eq $setting.DefinitionId }

            Update-MgBetaDeviceManagementIntentSetting -ErrorAction Stop `
                -DeviceManagementIntentId $appControlPolicy.Id `
                -DeviceManagementSettingInstanceId $s.Id `
                -ValueJson ($setting.value | ConvertTo-Json) `
                -AdditionalProperties @{'@odata.type' = $setting.'@odata.type' }
        }

        #region Assignments
        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }
        Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId  $appControlPolicy.id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/intents'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Endpoint Protection Application Control Policy {$DisplayName}"
        $appControlPolicy = Get-MgBetaDeviceManagementIntent `
            -ErrorAction Stop | Where-Object `
            -FilterScript { $_.TemplateId -eq '63be6324-e3c9-4c97-948a-e7f4b96f0f20' -and `
                $_.displayName -eq $($DisplayName) }

        Remove-MgBetaDeviceManagementIntent -DeviceManagementIntentId $appControlPolicy.Id -ErrorAction Stop
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet('notConfigured', 'enforceComponentsAndStoreApps', 'auditComponentsAndStoreApps', 'enforceComponentsStoreAppsAndSmartlocker', 'auditComponentsStoreAppsAndSmartlocker')]
        [System.String]
        $AppLockerApplicationControl,

        [Parameter()]
        [System.Boolean]
        $SmartScreenBlockOverrideForFiles,

        [Parameter()]
        [System.Boolean]
        $SmartScreenEnableInShell,

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
    Write-Verbose -Message "Testing configuration of Endpoint Protection Application Control Policy {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    if (-not (Test-M365DSCAuthenticationParameter -BoundParameters $CurrentValues))
    {
        Write-Verbose "An error occured in Get-TargetResource, the policy {$displayName} will not be processed"
        throw "An error occured in Get-TargetResource, the policy {$displayName} will not be processed. Refer to the event viewer logs for more information."
    }

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"
    $ValuesToCheck = ([hashtable]$PSBoundParameters).clone()
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null

    $testResult = $true
    if ($CurrentValues.Ensure -ne $Ensure)
    {
        $testResult = $false
    }
    #region Assignments
    if ($TestResult)
    {
        $source = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $PSBoundParameters.Assignments
        $target = $CurrentValues.Assignments
        $testResult = Compare-M365DSCIntunePolicyAssignment -Source $source -Target $target
        $ValuesToCheck.Remove('Assignments') | Out-Null
    }
    #endregion

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

    $dscContent = ''
    $i = 1

    try
    {
        [array]$policies = Get-MgBetaDeviceManagementIntent -All:$true -Filter $Filter `
            -ErrorAction Stop | Where-Object -FilterScript { $_.TemplateId -eq '63be6324-e3c9-4c97-948a-e7f4b96f0f20' }
        if ($policies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($policy in $policies)
        {
            Write-Host "    |---[$i/$($policies.Count)] $($policy.DisplayName)" -NoNewline

            $params = @{
                DisplayName           = $policy.DisplayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity       = $ManagedIdentity.IsPresent
            }

            $Results = Get-TargetResource @params
            if (-not (Test-M365DSCAuthenticationParameter -BoundParameters $Results))
            {
                Write-Verbose "An error occured in Get-TargetResource, the policy {$($params.displayName)} will not be processed"
                throw "An error occured in Get-TargetResource, the policy {$($params.displayName)} will not be processed. Refer to the event viewer logs for more information."
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

            if ($Results.Assignments)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Assignments' -IsCIMArray:$true
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
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*" -or `
            $_.Exception -like "*Unable to perform redirect as Location Header is not set in response*" -or `
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

function Get-M365DSCIntuneEndpointProtectionPolicyWindowsSettings
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties
    )

    $results = @()
    foreach ($property in $properties.Keys)
    {
        if ($property -ne 'Verbose')
        {
            $setting = @{}
            $settingType = ($properties.$property.gettype()).name
            switch ($settingType)
            {
                'String'
                {
                    $setting.Add('@odata.type', '#microsoft.graph.deviceManagementStringSettingInstance')
                }
                'Boolean'
                {
                    $setting.Add('@odata.type', '#microsoft.graph.deviceManagementBooleanSettingInstance')
                }
                'Int32'
                {
                    $setting.Add('@odata.type', '#microsoft.graph.deviceManagementIntegerSettingInstance')
                }
                Default
                {
                    $setting.Add('@odata.type', '#microsoft.graph.deviceManagementComplexSettingInstance')
                }
            }
            $settingDefinitionIdPrefix = 'deviceConfiguration--windows10EndpointProtectionConfiguration_'
            $settingDefinitionId = $settingDefinitionIdPrefix + $property[0].ToString().ToLower() + $property.Substring(1, $property.Length - 1)
            $setting.Add('DefinitionId', $settingDefinitionId)
            $settingValue = $properties.$property
            $setting.Add('value', $settingValue)
            $results += $setting
        }
    }
    return $results
}

Export-ModuleMember -Function *-TargetResource
