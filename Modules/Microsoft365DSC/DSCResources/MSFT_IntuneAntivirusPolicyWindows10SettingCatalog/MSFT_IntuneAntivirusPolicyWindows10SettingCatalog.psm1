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
        [ValidateSet('0', '1')]
        [System.String]
        $allowarchivescanning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowbehaviormonitoring,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowcloudprotection,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowemailscanning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowfullscanonmappednetworkdrives,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowfullscanremovabledrivescanning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowintrusionpreventionsystem,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowioavprotection,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowrealtimemonitoring,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowscanningnetworkfiles,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowscriptscanning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowuseruiaccess,

        [Parameter()]
        [System.int32]
        $avgcpuloadfactor,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $checkforsignaturesbeforerunningscan,

        [Parameter()]
        [ValidateSet('0', '2', '4', '6')]
        [System.String]
        $cloudblocklevel,

        [Parameter()]
        [System.Int32]
        $cloudextendedtimeout,

        [Parameter()]
        [System.Int32]
        $daystoretaincleanedmalware,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablecatchupfullscan,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablecatchupquickscan,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $enablelowcpupriority,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $enablenetworkprotection,

        [Parameter()]
        [System.String[]]
        $excludedextensions,

        [Parameter()]
        [System.String[]]
        $excludedpaths,

        [Parameter()]
        [System.String[]]
        $excludedprocesses,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $puaprotection,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $realtimescandirection,

        [Parameter()]
        [ValidateSet('1', '2')]
        [System.String]
        $scanparameter,

        [Parameter()]
        [System.Int32]
        $schedulequickscantime,

        [Parameter()]
        [ValidateSet('0', '1', '2', '3', '4', '5', '6', '7', '8')]
        [System.String]
        $schedulescanday,

        [Parameter()]
        [System.Int32]
        $schedulescantime,

        [Parameter()]
        [System.String[]]
        $signatureupdatefallbackorder,

        [Parameter()]
        [System.String[]]
        $signatureupdatefilesharessources,

        [Parameter()]
        [System.Int32]
        $signatureupdateinterval,

        [Parameter()]
        [ValidateSet('0', '1', '2', '3')]
        [System.String]
        $submitsamplesconsent,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablelocaladminmerge,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowonaccessprotection,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $lowseveritythreats,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $moderateseveritythreats,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $severethreats,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $highseveritythreats,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter(Mandatory = $True)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = $true,

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
        -ProfileName 'beta' -ErrorAction Stop

    Select-MgProfile -Name 'beta'
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
        $policy = Get-MgDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $Identity -ErrorAction SilentlyContinue

        if ($null -eq $policy)
        {
            Write-Verbose -Message "No Endpoint Protection Policy {$Identity} was found"

            $policyTemplateId = '804339ad-1553-4478-a742-138fb5807418_1'
            $policy = Get-MgDeviceManagementConfigurationPolicy -All:$true |Where-Object -FilterScript { `
                            $_.name -eq $DisplayName `
                            -and $_.TemplateReference.TemplateId -eq $policyTemplateId }
        }

        if ($null -eq $policy)
        {
            Write-Verbose -Message "No Endpoint Protection Policy {$DisplayName} was found"
            return $nullResult
        }

        #Retrieve policy specific settings
        [array]$settings = Get-MgDeviceManagementConfigurationPolicySetting `
            -DeviceManagementConfigurationPolicyId $policy.Id `
            -ErrorAction Stop

        $returnHashtable = @{}
        $returnHashtable.Add('Identity', $policy.id)
        $returnHashtable.Add('DisplayName', $policy.name)
        $returnHashtable.Add('Description', $policy.description)

        foreach ($setting in $settings.settingInstance)
        {
            $addToParameters = $true
            $settingName = $setting.settingDefinitionId.Split('_') | Select-Object -Last 1

            switch ($setting.AdditionalProperties.'@odata.type')
            {
                '#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance'
                {
                    $values = @()
                    foreach ($value in $setting.AdditionalProperties.simpleSettingCollectionValue)
                    {
                        $values += Get-DeviceManagementConfigurationSettingInstanceValue -Setting $value
                    }
                    $settingValue = $values
                }

                '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
                {
                    $values = @()
                    foreach ($value in $setting.AdditionalProperties.groupSettingCollectionValue.children)
                    {
                        $settingName = $value.settingDefinitionId.split('_') | Select-Object -Last 1
                        $settingValue = Get-DeviceManagementConfigurationSettingInstanceValue -Setting $value
                        $returnHashtable.Add($settingName, $settingValue)
                        $addToParameters = $false
                    }
                }
                Default
                {
                    $settingValue = Get-DeviceManagementConfigurationSettingInstanceValue -Setting $setting.AdditionalProperties
                }
            }
            if ($addToParameters)
            {
                $returnHashtable.Add($settingName, $settingValue)
            }

        }
        $returnAssignments = @()
        $returnAssignments += Get-MgDeviceManagementConfigurationPolicyAssignment -DeviceManagementConfigurationPolicyId $policy.Id
        $assignmentResult = @()
        foreach ($assignmentEntry in $returnAssignments)
        {
            $assignmentValue = @{
                dataType                                   = $assignmentEntry.Target.AdditionalProperties.'@odata.type'
                deviceAndAppManagementAssignmentFilterType = $assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterType.ToString()
                deviceAndAppManagementAssignmentFilterId   = $assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterId
                groupId                                    = $assignmentEntry.Target.AdditionalProperties.groupId
            }
            $assignmentResult += $assignmentValue
        }
        $returnHashtable.Add('Assignments', $assignmentResult)

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
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ''
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
        [ValidateSet('0', '1')]
        [System.String]
        $allowarchivescanning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowbehaviormonitoring,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowcloudprotection,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowemailscanning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowfullscanonmappednetworkdrives,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowfullscanremovabledrivescanning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowintrusionpreventionsystem,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowioavprotection,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowrealtimemonitoring,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowscanningnetworkfiles,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowscriptscanning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowuseruiaccess,

        [Parameter()]
        [System.int32]
        $avgcpuloadfactor,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $checkforsignaturesbeforerunningscan,

        [Parameter()]
        [ValidateSet('0', '2', '4', '6')]
        [System.String]
        $cloudblocklevel,

        [Parameter()]
        [System.Int32]
        $cloudextendedtimeout,

        [Parameter()]
        [System.Int32]
        $daystoretaincleanedmalware,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablecatchupfullscan,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablecatchupquickscan,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $enablelowcpupriority,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $enablenetworkprotection,

        [Parameter()]
        [System.String[]]
        $excludedextensions,

        [Parameter()]
        [System.String[]]
        $excludedpaths,

        [Parameter()]
        [System.String[]]
        $excludedprocesses,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $puaprotection,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $realtimescandirection,

        [Parameter()]
        [ValidateSet('1', '2')]
        [System.String]
        $scanparameter,

        [Parameter()]
        [System.Int32]
        $schedulequickscantime,

        [Parameter()]
        [ValidateSet('0', '1', '2', '3', '4', '5', '6', '7', '8')]
        [System.String]
        $schedulescanday,

        [Parameter()]
        [System.Int32]
        $schedulescantime,

        [Parameter()]
        [System.String[]]
        $signatureupdatefallbackorder,

        [Parameter()]
        [System.String[]]
        $signatureupdatefilesharessources,

        [Parameter()]
        [System.Int32]
        $signatureupdateinterval,

        [Parameter()]
        [ValidateSet('0', '1', '2', '3')]
        [System.String]
        $submitsamplesconsent,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablelocaladminmerge,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowonaccessprotection,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $lowseveritythreats,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $moderateseveritythreats,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $severethreats,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $highseveritythreats,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter(Mandatory = $True)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = $true,

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
        -InboundParameters $PSBoundParameters `
        -ProfileName 'beta'

    Select-MgProfile -Name 'beta'
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

    $templateReferenceId = '804339ad-1553-4478-a742-138fb5807418_1'
    $platforms = 'windows10'
    $technologies = 'mdm,microsoftSense'

    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Endpoint Protection Policy {$DisplayName}"
        $PSBoundParameters.Remove("DisplayName") | Out-Null
        $PSBoundParameters.Remove("Description") | Out-Null
        $PSBoundParameters.Remove("Identity") | Out-Null
        $PSBoundParameters.Remove("Assignments") | Out-Null

        $settings= Format-M365DSCIntuneSettingCatalogPolicySettings `
            -DSCParams ([System.Collections.Hashtable]$PSBoundParameters) `
            -TemplateReferenceId $templateReferenceId

        #$Template = Get-MgDeviceManagementConfigurationPolicyTemplate -DeviceManagementConfigurationPolicyTemplateId $templateReferenceId
        $policy = New-IntuneDeviceConfigurationPolicy `
            -Name $DisplayName `
            -Description $Description `
            -TemplateReferenceId $templateReferenceId `
            -Platforms $platforms `
            -Technologies $technologies `
            -Settings $settings

        $assignmentsHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignments
        Update-ConfigurationPolicyAssignments -DeviceManagementConfigurationPolicyId $policy.id -Targets $assignmentsHash

    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Endpoint Protection Policy {$($currentPolicy.DisplayName)}"
        $PSBoundParameters.Remove("DisplayName") | Out-Null
        $PSBoundParameters.Remove("Description") | Out-Null
        $PSBoundParameters.Remove("Identity") | Out-Null
        $PSBoundParameters.Remove("Assignments") | Out-Null

        $settings= Format-M365DSCIntuneSettingCatalogPolicySettings `
            -DSCParams ([System.Collections.Hashtable]$PSBoundParameters) `
            -TemplateReferenceId $templateReferenceId

        #$Template = Get-MgDeviceManagementConfigurationPolicyTemplate -DeviceManagementConfigurationPolicyTemplateId $templateReferenceId
        Update-IntuneDeviceConfigurationPolicy `
            -DeviceConfigurationPolicyId $Identity `
            -Name $DisplayName `
            -Description $Description `
            -TemplateReferenceId $templateReferenceId `
            -Platforms $platforms `
            -Technologies $technologies `
            -Settings $settings

        $assignmentsHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignments
        Update-ConfigurationPolicyAssignments -DeviceManagementConfigurationPolicyId $currentPolicy.Identity -Targets $assignmentsHash

    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Endpoint Protection Policy {$currentPolicy.DisplayName}"
        Remove-MgDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $Identity
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
        [ValidateSet('0', '1')]
        [System.String]
        $allowarchivescanning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowbehaviormonitoring,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowcloudprotection,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowemailscanning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowfullscanonmappednetworkdrives,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowfullscanremovabledrivescanning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowintrusionpreventionsystem,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowioavprotection,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowrealtimemonitoring,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowscanningnetworkfiles,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowscriptscanning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowuseruiaccess,

        [Parameter()]
        [System.int32]
        $avgcpuloadfactor,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $checkforsignaturesbeforerunningscan,

        [Parameter()]
        [ValidateSet('0', '2', '4', '6')]
        [System.String]
        $cloudblocklevel,

        [Parameter()]
        [System.Int32]
        $cloudextendedtimeout,

        [Parameter()]
        [System.Int32]
        $daystoretaincleanedmalware,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablecatchupfullscan,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablecatchupquickscan,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $enablelowcpupriority,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $enablenetworkprotection,

        [Parameter()]
        [System.String[]]
        $excludedextensions,

        [Parameter()]
        [System.String[]]
        $excludedpaths,

        [Parameter()]
        [System.String[]]
        $excludedprocesses,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $puaprotection,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $realtimescandirection,

        [Parameter()]
        [ValidateSet('1', '2')]
        [System.String]
        $scanparameter,

        [Parameter()]
        [System.Int32]
        $schedulequickscantime,

        [Parameter()]
        [ValidateSet('0', '1', '2', '3', '4', '5', '6', '7', '8')]
        [System.String]
        $schedulescanday,

        [Parameter()]
        [System.Int32]
        $schedulescantime,

        [Parameter()]
        [System.String[]]
        $signatureupdatefallbackorder,

        [Parameter()]
        [System.String[]]
        $signatureupdatefilesharessources,

        [Parameter()]
        [System.Int32]
        $signatureupdateinterval,

        [Parameter()]
        [ValidateSet('0', '1', '2', '3')]
        [System.String]
        $submitsamplesconsent,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablelocaladminmerge,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowonaccessprotection,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $lowseveritythreats,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $moderateseveritythreats,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $severethreats,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $highseveritythreats,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter(Mandatory = $True)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = $true,

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

    #Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    #Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()
    $ValuesToCheck.Remove('Identity') | Out-Null
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null

    if($CurrentValues.Ensure -eq "Absent")
    {
        Write-Verbose -Message "The policy was not found"
        return $false
    }
    $testResult = $true
    if ([Array]$Assignments.count -ne $CurrentValues.Assignments.count)
    {
        Write-Verbose -Message "Configuration drift:Number of assignments does not match: Source=$([Array]$Assignments.count) Target=$($CurrentValues.Assignments.count)"
        $testResult = $false
    }
    if ($testResult)
    {
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
                    break;
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
                    break;
                }
                $sourceHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $source
                $testResult = Compare-M365DSCComplexObject -Source $sourceHash -Target $assignment
            }

            if (-not $testResult)
            {
                $testResult = $false
                break;
            }

        }

    }
    $ValuesToCheck.Remove('Assignments') | Out-Null

    if ($testResult)
    {
        foreach($key in $PSBoundParameters.keys)
        {
            #Removing empty array when not returned from Get-Resource
            $value=$PSBoundParameters.$key
            if ($null -ne $value -and $value.getType().Name -like "*[[\]]" -and $value.count -eq 0 -and $null -eq $CurrentValues.$key)
            {
                $ValuesToCheck.remove($key)
            }
        }

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
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload:$true `
        -ProfileName 'Beta'

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
        $policyTemplateID = '804339ad-1553-4478-a742-138fb5807418_1'
        [array]$policies = Get-MgDeviceManagementConfigurationPolicy `
            -ErrorAction Stop `
            -All:$true `
            -Filter $Filter
        $policies = $policies | Where-Object -FilterScript { $_.TemplateReference.TemplateId -eq $policyTemplateId }

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
                    -Credential $Credential -Verbose

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
        return ''
    }
}

function Get-DeviceManagementConfigurationSettingInstanceValue
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Setting
    )
    #write-verbose -Message ($setting|fl|out-string)
    #write-verbose -Message ("setting: "+$setting.settingDefinitionId+" type: "+$setting.'@odata.type')
    switch ($setting.'@odata.type')
    {
        '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
        {
            $settingValue = $setting.choiceSettingValue.value.split('_') | Select-Object -Last 1

        }
        '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
        {
            $settingValue = $setting.simpleSettingValue.value
        }
        Default
        {
            $settingValue = $setting.value
        }
    }
    return $settingValue
}

function New-IntuneDeviceConfigurationPolicy
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (

        [Parameter(Mandatory = 'true')]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $Platforms,

        [Parameter()]
        [System.String]
        $Technologies,

        [Parameter()]
        [System.String]
        $TemplateReferenceId,

        [Parameter()]
        [Array]
        $Settings

    )
    try
    {
        $Uri="https://graph.microsoft.com/beta/deviceManagement/configurationPolicies"

        $policy=@{
            'name' = $Name
            'description' = $Description
            'platforms' = $Platforms
            "technologies" = $Technologies
            'templateReference' =@{'templateId'=$TemplateReferenceId}
            "settings" = $Settings
        }
        $body=$policy|ConvertTo-Json -Depth 20
        write-verbose -Message $body
        Invoke-MgGraphRequest -Method POST -Uri $Uri -Body $body -ErrorAction Stop

    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ''
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
function Update-IntuneDeviceConfigurationPolicy
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceConfigurationPolicyId,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $Platforms,

        [Parameter()]
        [System.String]
        $Technologies,

        [Parameter()]
        [System.String]
        $TemplateReferenceId,

        [Parameter()]
        [Array]
        $Settings

    )
    try
    {
        $Uri="https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$DeviceConfigurationPolicyId"

        $policy=@{
            'name' = $Name
            'description' = $Description
            'platforms' = $Platforms
            'templateReference' =@{'templateId'=$TemplateReferenceId}
            "technologies" = $Technologies
            "settings" = $Settings
        }
        $body=$policy|ConvertTo-Json -Depth 20
        #write-verbose -Message $body
        Invoke-MgGraphRequest -Method PUT -Uri $Uri -Body $body -ErrorAction Stop

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
function Update-ConfigurationPolicyAssignments
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceManagementConfigurationPolicyId,

        [Parameter()]
        [Array]
        $Targets
    )
    try
    {
        $configurationPolicyAssignments = @()

        $Uri = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$DeviceManagementConfigurationPolicyId/assign"

        foreach ($target in $targets)
        {
            $formattedTarget = @{'@odata.type' = $target.dataType }
            if ($target.groupId)
            {
                $formattedTarget.Add('groupId', $target.groupId)
            }
            if ($target.collectionId)
            {
                $formattedTarget.Add('collectionId', $target.collectionId)
            }
            if ($target.deviceAndAppManagementAssignmentFilterType)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterType', $target.deviceAndAppManagementAssignmentFilterType)
            }
            if ($target.deviceAndAppManagementAssignmentFilterId)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterId', $target.deviceAndAppManagementAssignmentFilterId)
            }
            $configurationPolicyAssignments += @{'target' = $formattedTarget }
        }
        $body = @{'assignments' = $configurationPolicyAssignments } | ConvertTo-Json -Depth 20
        #write-verbose -Message $body
        Invoke-MgGraphRequest -Method POST -Uri $Uri -Body $body -ErrorAction Stop

    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ''
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
function Format-M365DSCParamsToSettingInstance
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $DSCParams,

        [Parameter()]
        $TemplateSetting,

        [Parameter()]
        [System.Boolean]
        $IncludeSettingInstanceTemplateId=$true,

        [Parameter()]
        [System.Boolean]
        $IncludeSettingValueTemplateId=$true

    )

    $DSCParams.Remove('Verbose') | Out-Null
    $results = @()

    foreach ($param in $DSCParams.Keys)
    {
        $settingInstance=[ordered]@{}
        $settingInstance.add("settingDefinitionId",$templateSetting.settingDefinitionId)
        if($IncludeSettingInstanceTemplateId -and -Not [string]::IsNullOrEmpty($templateSetting.settingInstanceTemplateId))
        {
            $settingInstance.add("settingInstanceTemplateReference",@{"settingInstanceTemplateId"=$templateSetting.settingInstanceTemplateId})
        }

        $odataType=$templateSetting.AdditionalProperties."@odata.type"
        if([string]::IsNullOrEmpty($odataType))
        {
            $odataType=$templateSetting."@odata.type"
        }
        $settingInstance.add("@odata.type",$odataType.replace("Template",""))

        switch ($odataType)
        {
            "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstanceTemplate"
            {
                $choiceSettingValue=[ordered]@{}
                $choiceSettingValue.add("@odata.type","#microsoft.graph.deviceManagementConfigurationChoiceSettingValue")
                $choiceSettingValue.add("children",@())
                $settingValueTemplateId=$templateSetting.AdditionalProperties.choiceSettingValueTemplate.settingValueTemplateId
                if($IncludeSettingValueTemplateId -and -Not [string]::IsNullOrEmpty($settingValueTemplateId))
                {
                    $choiceSettingValue.add('settingValueTemplateReference', @{'settingValueTemplateId' = $SettingValueTemplateId })
                }
                $choiceSettingValue.add("value","$($templateSetting.settingDefinitionId)`_$($DSCParams.$param)")
                $settingInstance.add("choiceSettingValue",$choiceSettingValue)
                $results+=$settingInstance
            }
            "#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstanceTemplate"
            {
                $simpleSettingCollectionValues=@()

                foreach($value in $DSCParams.$param)
                {
                    $simpleSettingCollectionValue=@{}
                    $settingValueTemplateId=$templateSetting.AdditionalProperties.simpleSettingCollectionValueTemplate.settingValueTemplateId
                    if($IncludeSettingValueTemplateId -and -Not [string]::IsNullOrEmpty($settingValueTemplateId))
                    {
                        $simpleSettingCollectionValue.add("settingValueTemplateReference",@{"settingValueTemplateId"=$SettingValueTemplateId})
                    }
                    $settingValueDataType=$templateSetting.AdditionalProperties.simpleSettingCollectionValueTemplate."@odata.type".replace("Template","")
                    $simpleSettingCollectionValue.add("@odata.type",$settingValueDataType)
                    $simpleSettingCollectionValue.add("value",$value)
                    $simpleSettingCollectionValues+=$simpleSettingCollectionValue
                }
                $settingInstance.add("simpleSettingCollectionValue",$simpleSettingCollectionValues)

                $results+=$settingInstance
            }
            "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstanceTemplate"
            {
                $simpleSettingValue=@{}
                $SettingValueType=$templateSetting.AdditionalProperties.simpleSettingValueTemplate."@odata.type"
                if(-Not [string]::IsNullOrEmpty($SettingValueType))
                {
                    $simpleSettingValue.add("@odata.type",$SettingValueType.replace("Template",""))
                }
                $simpleSettingValue.add("value",$DSCParams.$param)

                $settingValueTemplateId=$templateSetting.AdditionalProperties.simpleSettingValueTemplate.settingValueTemplateId
                if(-Not [string]::IsNullOrEmpty($settingValueTemplateId))
                {
                    $simpleSettingValue.add("settingValueTemplateReference",@{"settingValueTemplateId"=$settingValueTemplateId})
                }

                $settingInstance.add("simpleSettingValue",$simpleSettingValue)
                $results+=$settingInstance
            }
        }
    }

    if ($results.count -eq 1)
    {
        return $results[0]
    }
    return $results
}

function Format-M365DSCIntuneSettingCatalogPolicySettings
{
    [CmdletBinding()]
    [OutputType([System.Array])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $DSCParams,

        [Parameter(Mandatory = 'true')]
        [System.String]
        $templateReferenceId
    )

    $DSCParams.Remove('Identity') | Out-Null
    $DSCParams.Remove('DisplayName') | Out-Null
    $DSCParams.Remove('Description') | Out-Null

    $settings = @()

    $templateSettings = Get-MgDeviceManagementConfigurationPolicyTemplateSettingTemplate -DeviceManagementConfigurationPolicyTemplateId $templateReferenceId

    #write-verbose -Message ( $DSCParams|out-string)

    $simpleSettings=@()
    $simpleSettings+=$templateSettings.SettingInstanceTemplate|Where-Object -FilterScript `
            {$_.AdditionalProperties."@odata.type" -ne "#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstanceTemplate"}
    foreach ($templateSetting in $simpleSettings)
    {
        $setting=@{}
        $settingKey=$DSCParams.keys|Where-Object -FilterScript {$templateSetting.settingDefinitionId -like "*$($_)"}
        if((-not [String]::IsNullOrEmpty($settingKey)) -and $DSCParams."$settingKey")
        {
            $setting.add("@odata.type","#microsoft.graph.deviceManagementConfigurationSetting")
            $myFormattedSetting= Format-M365DSCParamsToSettingInstance -DSCParams @{$settingKey=$DSCParams."$settingKey"} `
                -TemplateSetting $templateSetting

            $setting.add('settingInstance',$myFormattedSetting)
            $settings+=$setting
            $DSCParams.Remove($settingKey) | Out-Null

        }
    }

    $groupCollectionTemplateSettings=@()
    $groupCollectionTemplateSettings+=$templateSettings.SettingInstanceTemplate|Where-Object -FilterScript `
            {$_.AdditionalProperties."@odata.type" -eq "#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstanceTemplate"}

    foreach ($groupCollectionTemplateSetting in $groupCollectionTemplateSettings)
    {
        $setting=@{}
        $setting.add("@odata.type","#microsoft.graph.deviceManagementConfigurationSetting")
        $settingInstance=[ordered]@{}
        $settingInstance.add("@odata.type","#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance")
        $settingInstance.add("settingDefinitionId",$groupCollectionTemplateSetting.settingDefinitionId)
        $settingInstance.add("settingInstanceTemplateReference",@{
            "@odata.type"="#microsoft.graph.deviceManagementConfigurationSettingInstanceTemplateReference"
            "settingInstanceTemplateId"=$groupCollectionTemplateSetting.settingInstanceTemplateId
        })
        $groupSettingCollectionValues=@()
        $groupSettingCollectionValueChildren=@()
        $groupSettingCollectionValue=@{}
        $groupSettingCollectionValue.add("@odata.type","#microsoft.graph.deviceManagementConfigurationGroupSettingValue")

        $settingValueTemplateId=$groupCollectionTemplateSetting.AdditionalProperties.groupSettingCollectionValueTemplate.settingValueTemplateId
        if(-Not [string]::IsNullOrEmpty($settingValueTemplateId))
        {
            $groupSettingCollectionValue.add("settingValueTemplateReference",@{"settingValueTemplateId"=$SettingValueTemplateId})
        }

        foreach ($key in $DSCParams.keys)
        {
            $templateValue=$groupCollectionTemplateSetting.AdditionalProperties.groupSettingCollectionValueTemplate.children|where-object `
                -filterScript {$_.settingDefinitionId -like "*$key"}
            if($templateValue)
            {
                $groupSettingCollectionValueChild= Format-M365DSCParamsToSettingInstance `
                    -DSCParams @{$key=$DSCParams."$key"} `
                    -TemplateSetting $templateValue

                $groupSettingCollectionValueChildren+=$groupSettingCollectionValueChild
            }
        }

        $groupSettingCollectionValue.add("children",$groupSettingCollectionValueChildren)
        $groupSettingCollectionValues+=$groupSettingCollectionValue
        $settingInstance.add("groupSettingCollectionValue",$groupSettingCollectionValues)

        $setting.add('settingInstance',$settingInstance)

        if($setting.settingInstance.groupSettingCollectionValue.children.count -gt 0)
        {
            $settings+=$setting
        }
    }

    return $settings
}



function Get-MgDeviceManagementConfigurationSettingDefinition
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (

        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity
    )
    try
    {
        $Uri = "https://graph.microsoft.com/beta/deviceManagement/ConfigurationSettings/$($Identity.tolower())"
        $configurationPolicySetting = Invoke-MgGraphRequest -Method GET  -Uri $Uri -ErrorAction Stop
        return $configurationPolicySetting
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ''
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

function Get-M365DSCAdditionalProperties
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties
    )

    $results = @{'@odata.type' = '#microsoft.graph.agreement' }
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
function Get-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    [OutputType([hashtable],[hashtable[]])]
    param(
        [Parameter()]
        $ComplexObject
    )

    if($null -eq $ComplexObject)
    {
        return $null
    }


    if($ComplexObject.getType().Fullname -like "*hashtable")
    {
        return $ComplexObject
    }
    if($ComplexObject.getType().Fullname -like "*hashtable[[\]]")
    {
        return [hashtable[]]$ComplexObject
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

        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return ,[hashtable[]]$results
    }

    $results = @{}
    $keys = $ComplexObject | Get-Member | Where-Object -FilterScript {$_.MemberType -eq 'Property' -and $_.Name -ne 'AdditionalProperties'}

    foreach ($key in $keys)
    {

        if($ComplexObject.$($key.Name))
        {
            $keyName = $key.Name[0].ToString().ToLower() + $key.Name.Substring(1, $key.Name.Length - 1)

            if($ComplexObject.$($key.Name).gettype().fullname -like "*CimInstance*")
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject.$($key.Name)

                $results.Add($keyName, $hash)
            }
            else
            {
                $results.Add($keyName, $ComplexObject.$($key.Name))
            }
        }
    }

    return [hashtable]$results
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
        [Array]
        $ComplexTypeMapping,

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
            $split=@{
                'ComplexObject'=$item
                'CIMInstanceName'=$CIMInstanceName
                'Whitespace'="                $whitespace"
            }
            if ($ComplexTypeMapping)
            {
                $split.add('ComplexTypeMapping',$ComplexTypeMapping)
            }

            $currentProperty += Get-M365DSCDRGComplexTypeToString -isArray:$true @split

        }

        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return ,$currentProperty
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
            if ($ComplexObject[$key].GetType().FullName -like "Microsoft.Graph.PowerShell.Models.*" -or $key -in $ComplexTypeMapping.Name)
            {
                $hashPropertyType=$ComplexObject[$key].GetType().Name.tolower()

                #overwrite type if object defined in mapping complextypemapping
                if($key -in $ComplexTypeMapping.Name)
                {
                    $hashPropertyType=($ComplexTypeMapping|Where-Object -FilterScript {$_.Name -eq $key}).CimInstanceName
                    $hashProperty=$ComplexObject[$key]
                }
                else
                {
                    $hashProperty=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject[$key]
                }

                if($key -notin $ComplexTypeMapping.Name)
                {
                    $Whitespace+="            "
                }

                if(-not $isArray -or ($isArray -and $key -in $ComplexTypeMapping.Name ))
                {
                    $currentProperty += $whitespace + $key + " = "
                    if($ComplexObject[$key].GetType().FullName -like "*[[\]]")
                    {
                        $currentProperty += "@("
                    }
                }

                if($key -in $ComplexTypeMapping.Name)
                {
                    $Whitespace=""

                }
                $currentProperty += Get-M365DSCDRGComplexTypeToString `
                                -ComplexObject $hashProperty `
                                -CIMInstanceName $hashPropertyType `
                                -Whitespace $Whitespace `
                                -ComplexTypeMapping $ComplexTypeMapping

                if($ComplexObject[$key].GetType().FullName -like "*[[\]]")
                {
                    $currentProperty += ")"
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
        else
        {
            $mappedKey=$ComplexTypeMapping|where-object -filterscript {$_.name -eq $key}

            if($mappedKey -and $mappedKey.isRequired)
            {
                if($mappedKey.isArray)
                {
                    $currentProperty += "$Whitespace    $key = @()`r`n"
                }
                else
                {
                    $currentProperty += "$Whitespace    $key = `$null`r`n"
                }
            }
        }
    }
    $currentProperty += "$Whitespace}"

    return $currentProperty
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
        $Source,
        [Parameter()]
        $Target
    )

    #Comparing full objects
    if($null -eq  $Source  -and $null -eq $Target)
    {
        return $true
    }

    $sourceValue=""
    $targetValue=""
    if (($null -eq $Source) -xor ($null -eq $Target))
    {
        if($null -eq $Source)
        {
            $sourceValue="Source is null"
        }

        if($null -eq $Target)
        {
            $targetValue="Target is null"
        }
        Write-Verbose -Message "Configuration drift - Complex object: {$sourceValue$targetValue}"
        return $false
    }

    if($Source.getType().FullName -like "*CimInstance[[\]]" -or $Source.getType().FullName -like "*Hashtable[[\]]")
    {
        if($source.count -ne $target.count)
        {
            Write-Verbose -Message "Configuration drift - The complex array have different number of items: Source {$($source.count)} Target {$($target.count)}"
            return $false
        }
        if($source.count -eq 0)
        {
            return $true
        }

        $i=0
        foreach($item in $Source)
        {

            $compareResult= Compare-M365DSCComplexObject `
                    -Source (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Source[$i]) `
                    -Target $Target[$i]

            if(-not $compareResult)
            {
                Write-Verbose -Message "Configuration drift - The complex array items are not identical"
                return $false
            }
            $i++
        }
        return $true
    }

    $keys= $Source.Keys|Where-Object -FilterScript {$_ -ne "PSComputerName"}
    foreach ($key in $keys)
    {
        #write-verbose -message "Comparing key: {$key}"
        #Matching possible key names between Source and Target
        $skey=$key
        $tkey=$key
        if($key -eq 'odataType')
        {
            $skey='@odata.type'
        }
        else
        {
            $tmpkey=$Target.keys|Where-Object -FilterScript {$_ -eq "$key"}
            if($tkey)
            {
                $tkey=$tmpkey|Select-Object -First 1
            }
        }

        $sourceValue=$Source.$key
        $targetValue=$Target.$tkey
        #One of the item is null and not the other
        if (($null -eq $Source.$skey) -xor ($null -eq $Target.$tkey))
        {

            if($null -eq $Source.$skey)
            {
                $sourceValue="null"
            }

            if($null -eq $Target.$tkey)
            {
                $targetValue="null"
            }

            Write-Verbose -Message "Configuration drift - key: $key Source {$sourceValue} Target {$targetValue}"
            return $false
        }

        #Both keys aren't null or empty
        if(($null -ne $Source.$skey) -and ($null -ne $Target.$tkey))
        {
            if($Source.$skey.getType().FullName -like "*CimInstance*" -or $Source.$skey.getType().FullName -like "*hashtable*"  )
            {
                #Recursive call for complex object
                $compareResult= Compare-M365DSCComplexObject `
                    -Source (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Source.$skey) `
                    -Target $Target.$tkey

                if(-not $compareResult)
                {
                    Write-Verbose -Message "Configuration drift - complex object key: $key Source {$sourceValue} Target {$targetValue}"
                    return $false
                }
            }
            else
            {
                #Simple object comparison
                $referenceObject=$Target.$tkey
                $differenceObject=$Source.$skey

                $compareResult = Compare-Object `
                    -ReferenceObject ($referenceObject) `
                    -DifferenceObject ($differenceObject)

                if ($null -ne $compareResult)
                {
                    Write-Verbose -Message "Configuration drift - simple object key: $key Source {$sourceValue} Target {$targetValue}"
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
    [OutputType([hashtable],[hashtable[]])]
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
            $results+=$hash
        }

        #Write-Verbose -Message ("Convert-M365DSCDRGComplexTypeToHashtable >>> results: "+(convertTo-JSON $results -Depth 20))
        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return ,[hashtable[]]$results
    }
    $hashComplexObject = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject

    if($hashComplexObject)
    {

        $results=$hashComplexObject.clone()
        $keys=$hashComplexObject.Keys|Where-Object -FilterScript {$_ -ne 'PSComputerName'}
        foreach ($key in $keys)
        {
            if($hashComplexObject[$key] -and $hashComplexObject[$key].getType().Fullname -like "*CimInstance*")
            {
                $results[$key]=Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $hashComplexObject[$key]
            }
            else
            {
                $propertyName = $key[0].ToString().ToLower() + $key.Substring(1, $key.Length - 1)
                $propertyValue=$results[$key]
                $results.remove($key)|out-null
                $results.add($propertyName,$propertyValue)
            }
        }
    }
    return [hashtable]$results
}

Export-ModuleMember -Function *-TargetResource
