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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $LocalUserGroupCollection,

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

    Write-Verbose -Message "Checking for the Intune Account Protection Local User Group Membership Policy {$DisplayName}"

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
            Write-Verbose -Message "No Account Protection Local User Group Membership Policy with identity {$Identity} was found"
            if (-not [String]::IsNullOrEmpty($DisplayName))
            {
                $policy = Get-MgBetaDeviceManagementConfigurationPolicy -Filter "Name eq '$DisplayName'" -ErrorAction SilentlyContinue
            }
        }
        if ($null -eq $policy)
        {
            Write-Verbose -Message "No Account Protection Local User Group Membership Policy with displayName {$DisplayName} was found"
            return $nullResult
        }

        #Retrieve policy specific settings
        [array]$settings = Get-MgBetaDeviceManagementConfigurationPolicySetting `
            -DeviceManagementConfigurationPolicyId $policy.Id `
            -ErrorAction Stop

        $returnHashtable = @{}
        $returnHashtable.Add('Identity', $policy.Id)
        $returnHashtable.Add('DisplayName', $policy.Name)
        $returnHashtable.Add('Description', $policy.Description)

        $groupCollections = @()
        foreach ($setting in $settings)
        {
            foreach ($group in $setting.settingInstance.AdditionalProperties.groupSettingCollectionValue)
            {
                $groupSettings = $group.children[0].groupSettingCollectionValue.children
                $newGroupCollection = @{}
                $userSelectionType = $groupSettings | Where-Object -FilterScript { $_.settingDefinitionId -like '*_userselectiontype*' }
                $newGroupCollection.Add('UserSelectionType', $userSelectionType.choiceSettingValue.value.Split('_')[-1])

                $members = @()
                foreach ($member in $userSelectionType.choiceSettingValue.children[0].simpleSettingCollectionValue)
                {
                    $members += $member.value
                }
                $newGroupCollection.Add('Members', $members)

                $action = $groupSettings | Where-Object -FilterScript { $_.settingDefinitionId -like '*_action*' }
                $newGroupCollection.Add('Action', $($action.choiceSettingValue.value.Split('_')[-2, -1] -join '_'))

                $newLocalGroups = @()
                $localGroups = $groupSettings | Where-Object -FilterScript { $_.settingDefinitionId -like '*_desc*' }
                foreach ($localGroup in $localGroups.choiceSettingCollectionValue)
                {
                    $newLocalGroups += $localGroup.value.Split('_')[-1]
                }
                $newGroupCollection.Add('LocalGroups', $newLocalGroups)
                $groupCollections += $newGroupCollection
            }
        }

        Write-Verbose -Message "Found Account Protection Local User Group Membership Policy {$DisplayName}"

        $returnHashtable.Add('LocalUserGroupCollection', $groupCollections)
        $returnHashtable.Add('Ensure', 'Present')
        $returnHashtable.Add('Credential', $Credential)
        $returnHashtable.Add('ApplicationId', $ApplicationId)
        $returnHashtable.Add('TenantId', $TenantId)
        $returnHashtable.Add('ApplicationSecret', $ApplicationSecret)
        $returnHashtable.Add('CertificateThumbprint', $CertificateThumbprint)
        $returnHashtable.Add('ManagedIdentity', $ManagedIdentity.IsPresent)

        $returnAssignments = @()
        $returnAssignments += Get-MgBetaDeviceManagementConfigurationPolicyAssignment -DeviceManagementConfigurationPolicyId $policy.Id
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
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*" -or `
            $_.Exception -like "*Unable to perform redirect as Location Header is not set in response*")
        {
            if (Assert-M365DSCIsNonInteractiveShell)
            {
                Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
            }
        }
        else
        {
            New-M365DSCLogEntry -Message 'Error retrieving data:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential
        }

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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $LocalUserGroupCollection,

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

    $templateReferenceId = '22968f54-45fa-486c-848e-f8224aa69772_1'
    $platforms = 'windows10'
    $technologies = 'mdm'

    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Account Protection Local User Group Membership Policy {$DisplayName}"
        $PSBoundParameters.Remove('Identity') | Out-Null
        $PSBoundParameters.Remove('Assignments') | Out-Null
        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null

        $settings = Get-M365DSCIntuneDeviceConfigurationSettings -Properties ([System.Collections.Hashtable]$PSBoundParameters)

        $createParameters = @{}
        $createParameters.add('name', $DisplayName)
        $createParameters.add('description', $Description)
        $createParameters.add('settings', @($settings))
        $createParameters.add('platforms', $platforms)
        $createParameters.add('technologies', $technologies)
        $createParameters.add('templateReference', @{
            templateId = $templateReferenceId
        })
        $policy = New-MgBetaDeviceManagementConfigurationPolicy -BodyParameter $createParameters

        #region Assignments
        $assignmentsHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignments
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $policy.Id `
            -Targets $assignmentsHash
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Account Protection Local User Group Membership Policy {$DisplayName}"

        $PSBoundParameters.Remove('Identity') | Out-Null
        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $settings = Get-M365DSCIntuneDeviceConfigurationSettings -Properties ([System.Collections.Hashtable]$PSBoundParameters)

        Update-DeviceManagementConfigurationPolicy `
            -DeviceManagementConfigurationPolicyId $currentPolicy.Identity `
            -DisplayName $DisplayName `
            -Description $Description `
            -TemplateReference $templateReferenceId `
            -Platforms $platforms `
            -Technologies $technologies `
            -Settings $settings

        #region Assignments
        $assignmentsHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignments
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentPolicy.Identity `
            -Targets $assignmentsHash
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Account Protection Local User Group Membership Policy {$DisplayName}"
        Remove-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $currentPolicy.Identity -Confirm:$false
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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $LocalUserGroupCollection,

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
    Write-Verbose -Message "Testing configuration of Account Protection Local User Group Membership Policy {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null
    $ValuesToCheck.Remove('Identity') | Out-Null

    if ($CurrentValues.Ensure -ne $PSBoundParameters.Ensure)
    {
        return $false
    }

    #region LocalUserGroupCollection
    $testResult = $true
    if ((-not $CurrentValues.LocalUserGroupCollection) -xor (-not $ValuesToCheck.LocalUserGroupCollection))
    {
        Write-Verbose -Message 'Configuration drift: one the LocalUserGroupCollection is null'
        return $false
    }

    if ($CurrentValues.LocalUserGroupCollection)
    {
        if ($CurrentValues.LocalUserGroupCollection.count -ne $ValuesToCheck.LocalUserGroupCollection.count)
        {
            Write-Verbose -Message "Configuration drift: Number of LocalUserGroupCollection has changed - current {$($CurrentValues.LocalUserGroupCollection.count)} target {$($ValuesToCheck.LocalUserGroupCollection.count)}"
            return $false
        }
        for ($i = 0; $i -lt $CurrentValues.LocalUserGroupCollection.count; $i++)
        {
            $source = $ValuesToCheck.LocalUserGroupCollection[$i]
            $sourceHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $source
            $testResult = Compare-M365DSCComplexObject -Source $sourceHash -Target $CurrentValues.LocalUserGroupCollection[$i]

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
    $ValuesToCheck.Remove('LocalUserGroupCollection') | Out-Null
    #endregion

    #region Assignments
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

    $dscContent = ''
    $i = 1

    try
    {
        # Local user group membership template, family endpointSecurityAccountProtection
        $policyTemplateID = '22968f54-45fa-486c-848e-f8224aa69772_1'
        [array]$policies = Get-MgBetaDeviceManagementConfigurationPolicy `
            -Filter "templateReference/TemplateId eq '$policyTemplateID'" `
            -ErrorAction Stop `
            -All:$true

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
                Identity              = $policy.Id
                DisplayName           = $policy.Name
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
            }

            $Results = Get-TargetResource @params

            if ($Results.LocalUserGroupCollection)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ([Array]$Results.LocalUserGroupCollection) -CIMInstanceName IntuneAccountProtectionLocalUserGroupCollection

                if ($complexTypeStringResult)
                {
                    $Results.LocalUserGroupCollection = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('LocalUserGroupCollection') | Out-Null
                }
            }

            if ($Results.Assignments)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ([Array]$Results.Assignments) -CIMInstanceName IntuneAccountProtectionLocalUserGroupMembershipPolicyAssignments

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


            if ($Results.LocalUserGroupCollection)
            {
                $isCIMArray = $false
                if ($Results.LocalUserGroupCollection.getType().Fullname -like '*[[\]]')
                {
                    $isCIMArray = $true
                }
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'LocalUserGroupCollection' -IsCIMArray:$isCIMArray
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

            $currentDSCBlock = $currentDSCBlock.Replace("`r`n            `");", "`r`n            );")

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

function Get-M365DSCIntuneDeviceConfigurationSettings
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties
    )

    $settingDefinition = 'device_vendor_msft_policy_config_localusersandgroups_configure'
    $defaultValue = @{
        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSetting'
        'settingInstance' = @{
            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
            'settingDefinitionId' = $settingDefinition
            'groupSettingCollectionValue' = @()
            'settingInstanceTemplateReference' = @{
                'settingInstanceTemplateId' = 'de06bec1-4852-48a0-9799-cf7b85992d45'
             }
        }
    }
    foreach ($groupConfiguration in $Properties.LocalUserGroupCollection)
    {
        $groupDefaultValue = @{
            children = @(
                @{
                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
                    'settingDefinitionId' = $settingDefinition + '_groupconfiguration_accessgroup'
                    'groupSettingCollectionValue' = @(
                        @{
                            'children' = @(
                                @{
                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                    'settingDefinitionId' = $settingDefinition + '_groupconfiguration_accessgroup_userselectiontype'
                                    'choiceSettingValue' = @{
                                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingValue'
                                        'value' = $settingDefinition + '_groupconfiguration_accessgroup_userselectiontype_' + $groupConfiguration.UserSelectionType
                                        'children' = @(
                                            @{
                                                '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance'
                                                'settingDefinitionId' = $settingDefinition + '_groupconfiguration_accessgroup_users'
                                                'simpleSettingCollectionValue' = @()
                                            }
                                        )
                                    }
                                },
                                @{
                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                    'settingDefinitionId' = $settingDefinition + '_groupconfiguration_accessgroup_action'
                                    'choiceSettingValue' = @{
                                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingValue'
                                        'value' = $settingDefinition + '_groupconfiguration_accessgroup_action_' + $groupConfiguration.Action
                                        'children' = @()
                                    }
                                },
                                @{
                                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingCollectionInstance'
                                    'settingDefinitionId' = $settingDefinition + '_groupconfiguration_accessgroup_desc'
                                    'choiceSettingCollectionValue' = @()
                                }
                            )
                        }
                    )
                    'settingInstanceTemplateReference' = @{
                        'settingInstanceTemplateId' = '76fa254e-cbdb-4718-8bdd-cd41e57caa02'
                    }
                }
            )
        }

        foreach ($member in $groupConfiguration.Members)
        {
            $groupDefaultValue.children[0].groupSettingCollectionValue[0].children[0].choiceSettingValue.children[0].simpleSettingCollectionValue += @{
                '@odata.type' = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                'value' = $member
            }
        }

        foreach ($localGroup in $groupConfiguration.LocalGroups)
        {
            $groupDefaultValue.children[0].groupSettingCollectionValue[0].children[2].choiceSettingCollectionValue += @{
                '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingValue'
                'value' = $settingDefinition + '_groupconfiguration_accessgroup_desc_' + $localGroup
                'children' = @()
            }
        }

        $defaultValue.settingInstance.groupSettingCollectionValue += $groupDefaultValue
    }
    return $defaultValue
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
    $policy = @{
        'name'              = $DisplayName
        'description'       = $Description
        'platforms'         = $Platforms
        'technologies'      = $Technologies
        'settings'          = $Settings
        'templateReference' = $templateReference
    }

    Invoke-MgGraphRequest -Method PUT `
        -Uri $Uri `
        -ContentType 'application/json' `
        -Body ($policy | ConvertTo-Json -Depth 20) 4> out-null
}

Export-ModuleMember -Function *-TargetResource
