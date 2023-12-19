function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        [ValidateSet('0', '1')]
        $SampleSharing,

        [Parameter()]
        [System.String]
        [ValidateSet('AutoFromConnector', 'Onboard', 'Offboard')]
        $ConfigurationType,

        [Parameter()]
        [System.String]
        $ConfigurationBlob,

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

    Write-Verbose -Message "Checking for the Intune Endpoint Protection Policy {$DisplayName}"

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -ErrorAction Stop

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
        $policy = Get-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $Identity -ErrorAction SilentlyContinue

        if ($null -eq $policy)
        {
            Write-Verbose -Message "No Endpoint Detection And Response Policy with Id {$Identity} was found"
            $policyTemplateID = '0385b795-0f2f-44ac-8602-9f65bf6adede_1'
            $filter = "name eq '$DisplayName' and templateReference/TemplateId eq '$policyTemplateID'"
            $policy = Get-MgBetaDeviceManagementConfigurationPolicy -Filter $filter -ErrorAction SilentlyContinue
            if ($null -eq $policy)
            {
                Write-Verbose -Message "No Endpoint Detection And Response Policy with displayName {$DisplayName} was found"
                return $nullResult
            }
        }

        $policy = Get-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $policy.Id -ExpandProperty 'settings' -ErrorAction SilentlyContinue

        $Identity = $policy.Id

        Write-Verbose -Message "Found Endpoint Detection And Response Policy with Id {$($policy.id)} and displayName {$($policy.Name)}"

        #Retrieve policy specific settings
        $settings = @()
        $settings += $policy.settings

        $returnHashtable = @{}
        $returnHashtable.Add('Identity', $Identity)
        $returnHashtable.Add('DisplayName', $policy.name)
        $returnHashtable.Add('Description', $policy.description)

        foreach ($setting in $settings.settingInstance)
        {
            $addToParameters = $true
            $settingName = $setting.settingDefinitionId.Split('_') | Select-Object -Last 1

            switch ($setting.AdditionalProperties.'@odata.type')
            {

                '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                {
                    $settingValue = $setting.AdditionalProperties.simpleSettingValue.value
                }
                '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                {
                    $settingValue = $setting.AdditionalProperties.choiceSettingValue.value.split('_') | Select-Object -Last 1
                }
                '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
                {
                    $values = @()
                    foreach ($value in $setting.AdditionalProperties.groupSettingCollectionValue.children)
                    {
                        $settingName = $value.settingDefinitionId.split('_') | Select-Object -Last 1
                        $settingValue = $value.choiceSettingValue.value.split('_') | Select-Object -Last 1
                        $returnHashtable.Add($settingName, $settingValue)
                        $addToParameters = $false
                    }
                }
                '#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance'
                {
                    $values = @()
                    foreach ($value in $setting.AdditionalProperties.simpleSettingCollectionValue.value)
                    {
                        $values += $value
                    }
                    $settingValue = $values
                }
                Default
                {
                    $settingValue = $setting.value
                }
            }

            if ($addToParameters)
            {
                $returnHashtable.Add($settingName, $settingValue)
            }

        }

        #Removing telemetryreportingfrequency as deprecated and doen't need to be evaluated adn enforced
        $returnHashtable.Remove('telemetryreportingfrequency')

        $returnAssignments = @()
        $currentAssignments = Get-MgBetaDeviceManagementConfigurationPolicyAssignment -DeviceManagementConfigurationPolicyId $Identity -All

        if ($null -ne $currentAssignments -and $currentAssignments.count -gt 0 )
        {
            $returnAssignments += ConvertFrom-IntunePolicyAssignment -Assignments ($currentAssignments)
        }

        $returnHashtable.Add('Assignments', $returnAssignments)

        Write-Verbose -Message "Found Endpoint Protection Policy {$($policy.name)}"

        $returnHashtable.Add('Ensure', 'Present')
        $returnHashtable.Add('Credential', $Credential)
        $returnHashtable.Add('ApplicationId', $ApplicationId)
        $returnHashtable.Add('TenantId', $TenantId)
        $returnHashtable.Add('ApplicationSecret', $ApplicationSecret)
        $returnHashtable.Add('CertificateThumbprint', $CertificateThumbprint)
        $returnHashtable.Add('ManagedIdentity', $ManagedIdentity.IsPresent)

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
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        [ValidateSet('0', '1')]
        $SampleSharing,

        [Parameter()]
        [System.String]
        [ValidateSet('AutoFromConnector', 'Onboard', 'Offboard')]
        $ConfigurationType,

        [Parameter()]
        [System.String]
        $ConfigurationBlob,

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

    $currentPolicy = Get-TargetResource @PSBoundParameters
    $PSBoundParameters.Remove('Ensure') | Out-Null
    $PSBoundParameters.Remove('Credential') | Out-Null
    $PSBoundParameters.Remove('ApplicationId') | Out-Null
    $PSBoundParameters.Remove('TenantId') | Out-Null
    $PSBoundParameters.Remove('ApplicationSecret') | Out-Null
    $PSBoundParameters.Remove('CertificateThumbprint') | Out-Null
    $PSBoundParameters.Remove('ManagedIdentity') | Out-Null

    $templateReferenceId = '0385b795-0f2f-44ac-8602-9f65bf6adede_1'
    $platforms = 'windows10'
    $technologies = 'mdm,microsoftSense'

    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Endpoint Protection Policy {$DisplayName}"
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $settings = @()
        $formattedSettings = Get-IntuneSettingCatalogPolicySetting `
            -DSCParams ([System.Collections.Hashtable]$PSBoundParameters) `
            -TemplateId $templateReferenceId

        if ($null -ne $formattedSettings)
        {
            $settings += $formattedSettings
        }

        $createParameters = @{
            name              = $DisplayName
            description       = $Description
            templateReference = @{templateId = $templateReferenceId }
            platforms         = $platforms
            technologies      = $technologies
            settings          = $settings
        }

        write-verbose ($createParameters|convertto-json -depth 100)
        $policy = New-MgBetaDeviceManagementConfigurationPolicy -bodyParameter $createParameters

        $assignmentsHash = @()
        if ($null -ne $Assignments -and $Assignments.count -gt 0 )
        {
            $assignmentsHash +=  Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignments
        }

        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $policy.id `
            -Targets $assignmentsHash

    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Endpoint Protection Policy {$($currentPolicy.DisplayName)}"
        $PSBoundParameters.Remove('Assignments') | Out-Null

        #format settings from PSBoundParameters for update
        $settings = @()
        $formattedSettings = Get-IntuneSettingCatalogPolicySetting `
            -DSCParams ([System.Collections.Hashtable]$PSBoundParameters) `
            -TemplateId $templateReferenceId

        if ($null -ne $formattedSettings)
        {
            $settings += $formattedSettings
        }

        Update-DeviceManagementConfigurationPolicy `
            -DeviceManagementConfigurationPolicyId $currentPolicy.Identity `
            -DisplayName $DisplayName `
            -Description $Description `
            -TemplateReference $templateReferenceId `
            -Platforms $platforms `
            -Technologies $technologies `
            -Settings $settings

        #region update policy assignments
        $assignmentsHash = @()
        if ($null -ne $Assignments -and $Assignments.count -gt 0 )
        {
            $assignmentsHash +=  Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignments
        }

        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentPolicy.Identity `
            -Targets $assignmentsHash
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Endpoint Protection Policy {$($currentPolicy.DisplayName)}"
        Remove-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $currentPolicy.Identity
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
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        [ValidateSet('0', '1')]
        $SampleSharing,

        [Parameter()]
        [System.String]
        [ValidateSet('AutoFromConnector', 'Onboard', 'Offboard')]
        $ConfigurationType,

        [Parameter()]
        [System.String]
        $ConfigurationBlob,

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
    Write-Verbose -Message "Testing configuration of Endpoint Protection Policy {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = ([hashtable]$PSBoundParameters).clone()
    $ValuesToCheck.Remove('Identity') | Out-Null
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null
    $ValuesToCheck.Remove('ConfigurationBlob') | Out-Null

    $source = $PSBoundParameters.Assignments
    $target = $CurrentValues.Assignments
    $ValuesToCheck.Remove('Assignments') | Out-Null

    $testResult = Compare-M365DSCIntunePolicyAssignment -Source $source -Target $target

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
        $policyTemplateID = '0385b795-0f2f-44ac-8602-9f65bf6adede_1'
        [array]$policies = Get-MgBetaDeviceManagementConfigurationPolicy `
            -All:$true `
            -Filter $Filter `
            -ErrorAction Stop | Where-Object -FilterScript { $_.TemplateReference.TemplateId -eq $policyTemplateID } `

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
            Write-Host "    |---[$i/$($policies.Count)] $($policy.Name)" -NoNewline

            $params = @{
                Identity              = $policy.id
                DisplayName           = $policy.Name
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity       = $ManagedIdentity.IsPresent
            }

            $Results = Get-TargetResource @params

            if ($Results.Ensure -eq 'Present')
            {
                $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                    -Results $Results

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

                Write-Host $Global:M365DSCEmojiGreenCheckMark
                $i++
            }
        }
        return $dscContent
    }
    catch
    {
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*" -or `
            $_.Exception -like "*Unable to perform redirect as Location Header is not set in response*")
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

function Get-IntuneSettingCatalogPolicySetting
{
    [CmdletBinding()]
    [OutputType([System.Array])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $DSCParams,
        [Parameter(Mandatory = 'true')]
        [System.String]
        $TemplateId
    )

    $DSCParams.Remove('Identity') | Out-Null
    $DSCParams.Remove('DisplayName') | Out-Null
    $DSCParams.Remove('Description') | Out-Null

    #Prepare setting definitions mapping
    $settingDefinitions = Get-MgBetaDeviceManagementConfigurationPolicyTemplateSettingTemplate -DeviceManagementConfigurationPolicyTemplateId $TemplateId
    $settingInstances = @()
    foreach ($settingDefinition in $settingDefinitions.SettingInstanceTemplate)
    {

        $settingInstance = @{}
        $settingName = $settingDefinition.SettingDefinitionId.split('_') | Select-Object -Last 1
        $settingType = $settingDefinition.AdditionalProperties.'@odata.type'.replace('InstanceTemplate', 'Instance')
        $settingInstance.Add('settingDefinitionId', $settingDefinition.settingDefinitionId)
        $settingInstance.Add('@odata.type', $settingType)
        if (-Not [string]::IsNullOrEmpty($settingDefinition.settingInstanceTemplateId))
        {
            $settingInstance.Add('settingInstanceTemplateReference', @{'settingInstanceTemplateId' = $settingDefinition.settingInstanceTemplateId })
        }
        $settingValueName = $settingType.replace('#microsoft.graph.deviceManagementConfiguration', '').replace('Instance', 'Value')
        $settingValueName = $settingValueName.Substring(0, 1).ToLower() + $settingValueName.Substring(1, $settingValueName.length - 1 )
        $settingValueType = $settingDefinition.AdditionalProperties."$($settingValueName)Template".'@odata.type'
        if ($null -ne $settingValueType)
        {
            $settingValueType = $settingValueType.replace('ValueTemplate', 'Value')
        }
        $settingValueTemplateId = $settingDefinition.AdditionalProperties."$($settingValueName)Template".settingValueTemplateId
        $settingValue = Get-IntuneSettingCatalogPolicySettingInstanceValue `
            -DSCParams $DSCParams `
            -SettingDefinition $settingDefinition `
            -SettingName $settingName `
            -SettingType $settingType `
            -SettingValueName $settingValueName `
            -SettingValueType $settingValueType `
            -SettingValueTemplateId $settingValueTemplateId

        if ($null -ne $settingValue) {
            $childSettingType = ""
            switch ($DSCParams['ConfigurationType'])
            {
                'AutoFromConnector'
                {
                    $childSettingType = 'onboarding_fromconnector'
                }
                'Onboard'
                {
                    $childSettingType = 'onboarding'
                }
                'Offboard'
                {
                    $childSettingType = 'offboarding'
                }
            }

            if ($settingName -eq 'configurationType')
            {
                if ([System.String]::IsNullOrEmpty($DSCParams['ConfigurationBlob']))
                {
                    throw "ConfigurationBlob is required for configurationType '$($DSCParams['ConfigurationType'])'"
                }

                $children = @()
                $children += @{
                    '@odata.type' = "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance"
                    settingDefinitionId = "device_vendor_msft_windowsadvancedthreatprotection_$($childSettingType)"
                    simpleSettingValue = @{
                        '@odata.type' = "#microsoft.graph.deviceManagementConfigurationSecretSettingValue"
                        value = $DSCParams['ConfigurationBlob']
                        valueState = "NotEncrypted"
                    }
                }
                $settingValue.choiceSettingValue.Add("children", $children)
            }
            $settingInstance += ($settingValue)
            $settingInstances += @{
                '@odata.type'     = '#microsoft.graph.deviceManagementConfigurationSetting'
                'settingInstance' = $settingInstance
            }
        } else {
            Continue
        }
    }

    return $settingInstances
}

function Get-IntuneSettingCatalogPolicySettingInstanceValue
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $DSCParams,

        [Parameter()]
        $SettingDefinition,

        [Parameter()]
        [System.String]
        $SettingType,

        [Parameter()]
        [System.String]
        $SettingName,

        [Parameter()]
        [System.String]
        $SettingValueName,

        [Parameter()]
        [System.String]
        $SettingValueType,

        [Parameter()]
        [System.String]
        $SettingValueTemplateId
    )

    $settingValueReturn = @{}
    switch ($settingType)
    {
        '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
        {
            $groupSettingCollectionValue = @{}
            $groupSettingCollectionValueChildren = @()

            $groupSettingCollectionDefinitionChildren = $SettingDefinition.AdditionalProperties.groupSettingCollectionValueTemplate.children
            foreach ($childDefinition in $groupSettingCollectionDefinitionChildren)
            {
                $childSettingName = $childDefinition.settingDefinitionId.split('_') | Select-Object -Last 1
                $childSettingType = $childDefinition.'@odata.type'.replace('InstanceTemplate', 'Instance')
                $childSettingValueName = $childSettingType.replace('#microsoft.graph.deviceManagementConfiguration', '').replace('Instance', 'Value')
                $childSettingValueType = "#microsoft.graph.deviceManagementConfiguration$($childSettingValueName)"
                $childSettingValueName = $childSettingValueName.Substring(0, 1).ToLower() + $childSettingValueName.Substring(1, $childSettingValueName.length - 1 )
                $childSettingValueTemplateId = $childDefinition.$childSettingValueName.settingValueTemplateId
                $childSettingValue = Get-IntuneSettingCatalogPolicySettingInstanceValue `
                    -DSCParams $DSCParams `
                    -SettingDefinition $childDefinition `
                    -SettingName $childSettingName `
                    -SettingType $childDefinition.'@odata.type' `
                    -SettingValueName $childSettingValueName `
                    -SettingValueType $childSettingValueType `
                    -SettingValueTemplateId $childSettingValueTemplateId

                if ($null -ne $childSettingValue)
                {
                    $childSettingValue.add('settingDefinitionId', $childDefinition.settingDefinitionId)
                    $childSettingValue.add('@odata.type', $childSettingType )
                    $groupSettingCollectionValueChildren += $childSettingValue
                }
            }
            $groupSettingCollectionValue.add('children', $groupSettingCollectionValueChildren)
            $settingValueReturn.Add('groupSettingCollectionValue', @($groupSettingCollectionValue))
        }
        '#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance'
        {
            $values = @()
            foreach ( $key in $DSCParams.Keys)
            {
                if ($settingName -eq ($key.tolower()))
                {
                    $values = $DSCParams[$key]
                    break
                }
            }
            $settingValueCollection = @()
            foreach ($v in $values)
            {
                $settingValueCollection += @{
                    value         = $v
                    '@odata.type' = $settingValueType
                }
            }
            $settingValueReturn.Add($settingValueName, $settingValueCollection)
        }
        Default
        {
            $value = $null
            foreach ( $key in $DSCParams.Keys)
            {
                if ($settingName -eq ($key.tolower()))
                {
                    $value = "$($SettingDefinition.settingDefinitionId)_$($DSCParams[$key])"
                    break
                }
            }
            $settingValue = @{}

            if (-Not [string]::IsNullOrEmpty($settingValueType))
            {
                $settingValue.add('@odata.type', $settingValueType)
            }
            if (-Not [string]::IsNullOrEmpty($settingValueTemplateId))
            {
                $settingValue.Add('settingValueTemplateReference', @{'settingValueTemplateId' = $settingValueTemplateId })
            }
            $settingValue.add('value', $value)
            if ($null -eq $value)
            {
                return $null
            }
            $settingValueReturn.Add($settingValueName, $settingValue)
        }
    }
    return $settingValueReturn
}

function Update-DeviceManagementConfigurationPolicy
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceManagementConfigurationPolicyId,

        [Parameter(Mandatory = 'true')]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $TemplateReferenceId,

        [Parameter()]
        [System.String]
        $Platforms,

        [Parameter()]
        [System.String]
        $Technologies,

        [Parameter()]
        [System.Array]
        $Settings
    )

    $templateReference = @{
        'templateId' = $TemplateReferenceId
    }

    $Uri = "https://graph.microsoft.com/beta/deviceManagement/ConfigurationPolicies/$DeviceManagementConfigurationPolicyId"
    $policy = [ordered]@{
        'name'              = $DisplayName
        'description'       = $Description
        'platforms'         = $Platforms
        'technologies'      = $Technologies
        'templateReference' = $templateReference
        'settings'          = $Settings
    }
    #write-verbose (($policy|ConvertTo-Json -Depth 20))
    Invoke-MgGraphRequest -Method PUT `
        -Uri $Uri `
        -ContentType 'application/json' `
        -Body ($policy | ConvertTo-Json -Depth 20) 4> out-null
}

Export-ModuleMember -Function *-TargetResource
