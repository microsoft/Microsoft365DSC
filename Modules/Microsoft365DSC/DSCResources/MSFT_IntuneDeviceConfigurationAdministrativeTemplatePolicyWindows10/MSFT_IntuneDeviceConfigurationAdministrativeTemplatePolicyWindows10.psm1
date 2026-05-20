Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneDeviceConfigurationAdministrativeTemplatePolicyWindows10'

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
        [ValidateSet('unknown', 'custom', 'builtIn', 'mixed', 'unknownFutureValue')]
        [System.String]
        $PolicyConfigurationIngestionType,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DefinitionValues,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of the Intune Device Configuration Administrative Template Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName}"

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
                $getValue = Get-MgBetaDeviceManagementGroupPolicyConfiguration -GroupPolicyConfigurationId $Id -ErrorAction SilentlyContinue
            }

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Device Configuration Administrative Template Policy for Windows10 with Id {$Id}"

                if (-not [string]::IsNullOrEmpty($DisplayName))
                {
                    $getValue = Get-MgBetaDeviceManagementGroupPolicyConfiguration `
                        -All `
                        -Filter "DisplayName eq '$($DisplayName -replace "'", "''")'" `
                        -ErrorAction SilentlyContinue
                    if ($null -eq $getValue)
                    {
                        Write-Verbose -Message "Could not find an Intune Device Configuration Administrative Template Policy for Windows10 with DisplayName {$DisplayName}"
                        return $nullResult
                    }
                    if (([array]$getValue).Count -gt 1)
                    {
                        throw "A policy with a duplicated displayName {'$DisplayName'} was found - Ensure displayName is unique"
                    }
                }
            }
            #endregion
        }
        else
        {
            $getValue = $Script:exportedInstance
        }

        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Device Configuration Administrative Template Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName} was found."

        #region
        $settings = Get-MgBetaDeviceManagementGroupPolicyConfigurationDefinitionValue `
            -GroupPolicyConfigurationId $Id

        $complexDefinitionValues = @()
        foreach ($setting in $settings)
        {
            $definitionValue = @{}
            $definitionValue.Add('Id', $setting.Id)
            if ($null -ne $setting.ConfigurationType)
            {
                $definitionValue.Add('ConfigurationType', $setting.ConfigurationType.ToString())
            }
            $definitionValue.Add('Enabled', $setting.Enabled)
            $definition = Get-MgBetaDeviceManagementGroupPolicyConfigurationDefinitionValueDefinition `
                -GroupPolicyConfigurationId $Id `
                -GroupPolicyDefinitionValueId $setting.Id

            $enumClassType = $null
            if ($null -ne $definition.ClassType)
            {
                $enumClassType = $definition.ClassType.ToString()
            }

            $enumPolicyType = $null
            if ($null -ne $definition.PolicyType)
            {
                $enumPolicyType = $definition.PolicyType.ToString()
            }
            $complexDefinition = @{
                CategoryPath = $definition.CategoryPath
                ClassType    = $enumClassType
                DisplayName  = $definition.DisplayName
                PolicyType   = $enumPolicyType
                SupportedOn  = $definition.SupportedOn
                Id           = $definition.Id
            }

            $definitionValue.Add('Definition', $complexDefinition)

            $presentationValues = Get-MgBetaDeviceManagementGroupPolicyConfigurationDefinitionValuePresentationValue `
                -GroupPolicyConfigurationId $Id `
                -GroupPolicyDefinitionValueId $setting.Id `
                -ExpandProperty 'presentation'

            $complexPresentationValues = @()
            foreach ($presentationValue in $presentationValues)
            {
                $complexPresentationValue = [ordered]@{}
                $complexPresentationValue.Add('odataType', $presentationValue.AdditionalProperties.'@odata.type')
                $complexPresentationValue.Add('Id', $presentationValue.Id)
                $complexPresentationValue.Add('presentationDefinitionId', $presentationValue.Presentation.Id)
                $complexPresentationValue.Add('presentationDefinitionLabel', $presentationValue.Presentation.Label)
                switch -Wildcard ($presentationValue.AdditionalProperties.'@odata.type')
                {
                    '*.groupPolicyPresentationValueBoolean'
                    {
                        $complexPresentationValue.Add('BooleanValue', $presentationValue.AdditionalProperties.value)
                    }
                    '*.groupPolicyPresentationValue*Decimal'
                    {
                        $complexPresentationValue.Add('DecimalValue', $presentationValue.AdditionalProperties.value)
                    }
                    '*.groupPolicyPresentationValueList'
                    {
                        $complexKeyValuePairValues = @()
                        foreach ($value in $presentationValue.AdditionalProperties.values)
                        {

                            $complexKeyValuePairValue = @{
                                Name  = $(if ($null -ne $value.name)
                                {
                                    $value.name.Replace('"', '')
                                })
                            }
                            if ($null -ne $value.value)
                            {
                                $complexKeyValuePairValue.Add('Value', $value.value.Replace('"', ''))
                            }
                            $complexKeyValuePairValues += $complexKeyValuePairValue
                        }
                        $complexPresentationValue.Add('KeyValuePairValues', $complexKeyValuePairValues)
                    }
                    '*.groupPolicyPresentationValueMultiText'
                    {
                        $complexPresentationValue.Add('StringValues', $presentationValue.AdditionalProperties.values)
                    }
                    '*.groupPolicyPresentationValueText'
                    {
                        $complexPresentationValue.Add('StringValue', $presentationValue.AdditionalProperties.value)
                    }
                }
                $complexPresentationValues += $complexPresentationValue
            }

            $definitionValue.Add('PresentationValues', $complexPresentationValues)
            $complexDefinitionValues += $definitionValue
        }
        #endregion

        $results = @{
            #region resource generator code
            Description           = $getValue.Description
            DisplayName           = $getValue.DisplayName
            DefinitionValues      = $complexDefinitionValues
            Id                    = $getValue.Id
            RoleScopeTagIds       = $getValue.RoleScopeTagIds
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
            #endregion
        }
        $returnAssignments = @()
        $graphAssignments = Get-MgBetaDeviceManagementGroupPolicyConfigurationAssignment -GroupPolicyConfigurationId $Id
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
        #region resource generator code
        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [ValidateSet('unknown', 'custom', 'builtIn', 'mixed', 'unknownFutureValue')]
        [System.String]
        $PolicyConfigurationIngestionType,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DefinitionValues,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

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

    $keyToRename = @{
        'odataType'          = '@odata.type'
        'BooleanValue'       = 'value'
        'StringValue'        = 'value'
        'DecimalValue'       = 'value'
        'KeyValuePairValues' = 'values'
        'StringValues'       = 'values'
    }
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Device Configuration Administrative Template Policy for Windows10 with DisplayName {$DisplayName}"
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $CreateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters -KeyMapping $keyToRename
        $CreateParameters.Remove('Id') | Out-Null
        $CreateParameters.Remove('DefinitionValues') | Out-Null

        #region resource generator code
        $policy = New-MgBetaDeviceManagementGroupPolicyConfiguration -BodyParameter $CreateParameters
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments

        if ($policy.id)
        {
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $policy.id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/groupPolicyConfigurations'
        }

        #Create DefinitionValues
        [Array]$targetDefinitionValues = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $DefinitionValues
        $formattedDefinitionValuesToAdd = @()
        foreach ($definitionValue in $targetDefinitionValues)
        {
            $definitionValue = Rename-M365DSCCimInstanceParameter -Properties $definitionValue -KeyMapping $keyToRename
            $complexPresentationValues = @()
            if ($null -ne $definitionValue.PresentationValues)
            {
                foreach ($presentationValue in [Hashtable[]]$definitionValue.PresentationValues)
                {
                    $value = $presentationValue.Clone()
                    $value = Rename-M365DSCCimInstanceParameter -Properties $value -KeyMapping $keyToRename
                    $value.Add('presentation@odata.bind', (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/deviceManagement/groupPolicyDefinitions('$($definitionValue.Definition.Id)')/presentations('$($presentationValue.presentationDefinitionId)')")
                    $value.Remove('PresentationDefinitionId')
                    $value.Remove('PresentationDefinitionLabel')
                    $value.Remove('id')
                    $complexPresentationValues += $value
                }
            }
            $complexDefinitionValue = @{
                'definition@odata.bind' = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/deviceManagement/groupPolicyDefinitions('$($definitionValue.Definition.Id)')"
                enabled                 = $definitionValue.Enabled
                presentationValues      = $complexPresentationValues
            }
            $formattedDefinitionValuesToAdd += $complexDefinitionValue
        }

        Update-DeviceConfigurationGroupPolicyDefinitionValue `
            -DeviceConfigurationPolicyId $policy.Id `
            -DefinitionValueToAdd $formattedDefinitionValuesToAdd
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Device Configuration Administrative Template Policy for Windows10 with Id {$($currentInstance.Id)}"
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $UpdateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters -KeyMapping $keyToRename
        $UpdateParameters.Remove('Id') | Out-Null
        $UpdateParameters.Remove('DefinitionValues') | Out-Null

        #region resource generator code
        #Update Core policy
        $UpdateParameters.Add('@odata.type', '#microsoft.graph.GroupPolicyConfiguration')
        Update-MgBetaDeviceManagementGroupPolicyConfiguration `
            -GroupPolicyConfigurationId $currentInstance.Id `
            -BodyParameter $UpdateParameters

        #Update Assignments
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $currentInstance.id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/groupPolicyConfigurations'
        #endregion

        #Update DefinitionValues
        $currentDefinitionValues = @()
        $currentDefinitionValuesIds = @()
        if ($null -ne $currentInstance.DefinitionValues -and $currentInstance.DefinitionValues.Count -gt 0 )
        {
            [Array]$currentDefinitionValues = $currentInstance.DefinitionValues
            [Array]$currentDefinitionValuesIds = $currentDefinitionValues.definition.id
        }
        $targetDefinitionValues = @()
        $targetDefinitionValuesIds = @()
        if ($null -ne $DefinitionValues -and $DefinitionValues.Count -gt 0)
        {
            [Array]$targetDefinitionValues = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $DefinitionValues
            [Array]$targetDefinitionValuesIds = $targetDefinitionValues.Definition.Id
        }

        $comparedDefinitionValues = Compare-Object `
            -ReferenceObject ($currentDefinitionValuesIds) `
            -DifferenceObject ($targetDefinitionValuesIds) `
            -IncludeEqual

        $definitionValuesToAdd = ($comparedDefinitionValues | Where-Object -FilterScript { $_.SideIndicator -eq '=>' }).InputObject
        $definitionValuesToRemove = ($comparedDefinitionValues | Where-Object -FilterScript { $_.SideIndicator -eq '<=' }).InputObject
        $definitionValuesToCheck = ($comparedDefinitionValues | Where-Object -FilterScript { $_.SideIndicator -eq '==' }).InputObject
        #Write-Verbose ("Add: $($definitionValuesToAdd.Count) - Remove: $($definitionValuesToRemove.Count) - Check: $($definitionValuesToCheck.Count)")

        $formattedDefinitionValuesToAdd = @()
        foreach ($definitionValueId in $definitionValuesToAdd)
        {
            $definitionValue = $targetDefinitionValues | Where-Object -FilterScript { $_.Definition.Id -eq $definitionValueId }
            $definitionValue = Rename-M365DSCCimInstanceParameter -Properties $definitionValue -KeyMapping $keyToRename
            $complexPresentationValues = @()
            if ($null -ne $definitionValue.PresentationValues)
            {
                foreach ($presentationValue in [Hashtable[]]$definitionValue.PresentationValues)
                {
                    $value = $presentationValue.Clone()
                    $value = Rename-M365DSCCimInstanceParameter -Properties $value -KeyMapping $keyToRename
                    $value.Add('presentation@odata.bind', "$((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl)beta/deviceManagement/groupPolicyDefinitions('$($definitionValue.Definition.Id)')/presentations('$($presentationValue.presentationDefinitionId)')")
                    $value.Remove('PresentationDefinitionId')
                    $value.Remove('PresentationDefinitionLabel')
                    $value.Remove('id')
                    $complexPresentationValues += $value
                }
            }
            $complexDefinitionValue = @{
                'definition@odata.bind' = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/deviceManagement/groupPolicyDefinitions('$($definitionValue.Definition.Id)')"
                enabled                 = $definitionValue.Enabled
                presentationValues      = $complexPresentationValues
            }
            $formattedDefinitionValuesToAdd += $complexDefinitionValue
        }

        $formattedDefinitionValuesToUpdate = @()
        foreach ($definitionValueId in $definitionValuesToCheck)
        {
            $definitionValue = $targetDefinitionValues | Where-Object -FilterScript { $_.Definition.Id -eq $definitionValueId }
            $currentDefinitionValue = $currentDefinitionValues | Where-Object -FilterScript { $_.definition.id -eq $definitionValueId }
            $definitionValue = Rename-M365DSCCimInstanceParameter -Properties $definitionValue -KeyMapping $keyToRename
            $complexPresentationValues = @()
            if ($null -ne $definitionValue.PresentationValues)
            {
                foreach ($presentationValue in [Hashtable[]]$definitionValue.PresentationValues)
                {
                    $currentPresentationValue = $currentDefinitionValue.PresentationValues | Where-Object { $_.PresentationDefinitionId -eq $presentationValue.presentationDefinitionId }
                    $value = $presentationValue.Clone()
                    $value = Rename-M365DSCCimInstanceParameter -Properties $value -KeyMapping $keyToRename
                    $value.Add('presentation@odata.bind', "$((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl)beta/deviceManagement/groupPolicyDefinitions('$($definitionValue.Definition.Id)')/presentations('$($presentationValue.presentationDefinitionId)')")
                    $value.Remove('PresentationDefinitionId')
                    $value.Remove('PresentationDefinitionLabel')
                    $value.Remove('id')
                    $value.Add('id', $currentPresentationValue.Id)
                    $complexPresentationValues += $value
                }
            }
            $complexDefinitionValue = @{
                id                      = $currentDefinitionValue.Id
                'definition@odata.bind' = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/deviceManagement/groupPolicyDefinitions('$($definitionValue.Definition.Id)')"
                enabled                 = $definitionValue.Enabled
                presentationValues      = $complexPresentationValues
            }
            $formattedDefinitionValuesToUpdate += $complexDefinitionValue
        }

        $formattedDefinitionValuesToRemove = @()
        foreach ($definitionValueId in $definitionValuesToRemove)
        {
            $formattedDefinitionValuesToremove += ($currentDefinitionValues | Where-Object { $_.definition.id -eq $definitionValueId }).id
        }

        Update-DeviceConfigurationGroupPolicyDefinitionValue `
            -DeviceConfigurationPolicyId $currentInstance.Id `
            -DefinitionValueToAdd $formattedDefinitionValuesToAdd `
            -DefinitionValueToUpdate $formattedDefinitionValuesToUpdate `
            -DefinitionValueToRemove $formattedDefinitionValuesToRemove

    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Device Configuration Administrative Template Policy for Windows10 with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaDeviceManagementGroupPolicyConfiguration -GroupPolicyConfigurationId $currentInstance.Id
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
        [ValidateSet('unknown', 'custom', 'builtIn', 'mixed', 'unknownFutureValue')]
        [System.String]
        $PolicyConfigurationIngestionType,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DefinitionValues,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

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

    Write-Verbose -Message "Testing configuration of the Intune Device Configuration Administrative Template Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    $ValuesToCheck = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $testResult = $true

    #Compare Cim instances
    foreach ($key in $PSBoundParameters.Keys)
    {
        $source = $PSBoundParameters.$key
        $target = $CurrentValues.$key
        if ($source.GetType().Name -like '*CimInstance*')
        {
            #Removing Key Definition because it is Read-Only and ID as random
            if ($key -eq 'DefinitionValues')
            {
                $source = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $source
                $target = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $target
                foreach ($definitionValue in $source)
                {
                    $definitionValue.Remove('Definition') | Out-Null
                    $definitionValue.Remove('Id') | Out-Null
                    #Removing Key presentationDefinitionLabel because it is Read-Only and ID as random
                    foreach ($presentationValue in $definitionValue.PresentationValues)
                    {
                        $presentationValue.Remove('presentationDefinitionLabel') | Out-Null
                        $presentationValue.Remove('Id') | Out-Null
                    }
                }
                foreach ($definitionValue in $target)
                {
                    $definitionValue.Remove('Definition') | Out-Null
                    $definitionValue.Remove('Id') | Out-Null
                    #Removing Key presentationDefinitionLabel because it is Read-Only and ID as random
                    foreach ($presentationValue in $definitionValue.PresentationValues)
                    {
                        $presentationValue.Remove('presentationDefinitionLabel') | Out-Null
                        $presentationValue.Remove('Id') | Out-Null
                    }
                }
            }

            $testResult = Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target) `
                -PropertyName $key

            if (-not $testResult)
            {
                $testResult = $false
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    $ValuesToCheck.Remove('Id') | Out-Null
    $ValuesToCheck.Remove('PolicyConfigurationIngestionType') | Out-Null

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
        [array]$getValue = Get-MgBetaDeviceManagementGroupPolicyConfiguration -Filter $Filter -All -ErrorAction Stop
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
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                Id                    = $config.Id
                DisplayName           = $config.DisplayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @params

            if ($Results.DefinitionValues)
            {
                $complexMapping = @(
                    @{
                        Name            = 'Definition'
                        CimInstanceName = 'MSFT_IntuneGroupPolicyDefinitionValueDefinition'
                        IsRequired      = $false
                    }
                    @{
                        Name            = 'PresentationValues'
                        CimInstanceName = 'MSFT_IntuneGroupPolicyDefinitionValuePresentationValue'
                        IsRequired      = $false
                    }
                    @{
                        Name            = 'KeyValuePairValues'
                        CimInstanceName = 'MSFT_IntuneGroupPolicyDefinitionValuePresentationValueKeyValuePair'
                        IsRequired      = $false
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.DefinitionValues `
                    -CIMInstanceName IntuneGroupPolicyDefinitionValue `
                    -ComplexTypeMapping $complexMapping
                if ($complexTypeStringResult)
                {
                    $Results.DefinitionValues = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('DefinitionValues') | Out-Null
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
                -NoEscape @('Assignments', 'DefinitionValues', 'PresentationValues', 'KeyValuePairValues')

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
                $_.Exception -like '*Unable to perform redirect as Location Header is not set in response*' -or `
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

function Update-DeviceConfigurationGroupPolicyDefinitionValue
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceConfigurationPolicyId,

        [Parameter()]
        [Array]
        $DefinitionValueToAdd = @(),

        [Parameter()]
        [Array]
        $DefinitionValueToUpdate = @(),

        [Parameter()]
        [Array]
        $DefinitionValueToRemove = @()
    )
    try
    {
        $Uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/deviceManagement/groupPolicyConfigurations/$DeviceConfigurationPolicyId/updateDefinitionValues"

        $body = @{}
        $DefinitionValueToRemoveIds = @()
        if ($null -ne $DefinitionValueToRemove -and $DefinitionValueToRemove.Count -gt 0)
        {
            $DefinitionValueToRemoveIds = $DefinitionValueToRemove
        }
        $body = @{
            'added'      = $DefinitionValueToAdd
            'updated'    = $DefinitionValueToUpdate
            'deletedIds' = $DefinitionValueToRemoveIds
        }
        #Write-Verbose -Message ($body | ConvertTo-Json -Depth 100)
        Invoke-MgGraphRequest -Method POST -Uri $Uri -Body ($body | ConvertTo-Json -Depth 20) -ErrorAction Stop 4> $null
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error updating data:'
        -Exception $_
        -Source $($MyInvocation.MyCommand.Source)
        -TenantId $TenantId
        -Credential $Credential

        return $null
    }
}

Export-ModuleMember -Function *-TargetResource
