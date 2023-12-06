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
        [System.String]
        $companyname,

        [Parameter()]
        [System.Int32]
        $daystoretaincleanedmalware,
        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disableaccountprotectionui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disableappbrowserui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablecleartpmbutton,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disabledevicesecurityui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disableenhancednotifications,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablefamilyui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablehealthui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablenetworkui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disabletpmfirmwareupdatewarning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablevirusui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablecatchupfullscan,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablecatchupquickscan,

        [Parameter()]
        [System.String]
        $email,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $enablecustomizedtoasts,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $enableinappcustomization,

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
        [ValidateSet('0', '1')]
        [System.String]
        $hideransomwaredatarecovery,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $hidewindowssecuritynotificationareacontrol,

        [Parameter()]
        [System.String]
        $phone,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $puaprotection,

        [Parameter()]
        [ValidateSet('0', '2', '3', '4', '5', '6')]
        [System.String]
        $engineupdateschannel,

        [Parameter()]
        [ValidateSet('0', '2', '3', '4', '5', '6')]
        [System.String]
        $platformupdateschannel,

        [Parameter()]
        [ValidateSet('0', '4', '5')]
        [System.String]
        $securityintelligenceupdateschannel,

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
        $tamperprotection,

        [Parameter()]
        [System.String]
        $url,

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
        [ValidateSet('d948ff9b-99cb-4ee0-8012-1fbc09685377_1', 'e3f74c5a-a6de-411d-aef6-eb15628f3a0a_1', '45fea5e9-280d-4da1-9792-fb5736da0ca9_1', '804339ad-1553-4478-a742-138fb5807418_1')]
        [System.String]
        $templateId,

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
            Write-Verbose -Message "No policy with Id {$Identity} was found. Trying to retrieve by name {$DisplayName}."
            $policy = Get-MgBetaDeviceManagementConfigurationPolicy -Filter "Name eq '$DisplayName'"

            if ($null -eq $policy)
            {
                Write-Verbose -Message "No policy with name {$DisplayName} was found."
                return $nullResult
            }
        }

        #Retrieve policy specific settings
        [array]$settings = Get-MgBetaDeviceManagementConfigurationPolicySetting `
            -DeviceManagementConfigurationPolicyId $policy.Id `
            -ErrorAction Stop

        $returnHashtable = @{}
        $returnHashtable.Add('Identity', $policy.id)
        $returnHashtable.Add('DisplayName', $policy.name)
        $returnHashtable.Add('Description', $policy.description)
        $returnHashtable.Add('templateId', $policy.templateReference.templateId)

        foreach ($setting in $settings.settingInstance)
        {
            $addToParameters = $true
            $settingName = $setting.settingDefinitionId.Split('_') | Select-Object -Last 1
            if ($settingName -eq 'options')
            {
                $settingName = 'tamperprotection'
            }

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
        $returnAssignments += Get-MgBetaDeviceManagementConfigurationPolicyAssignment -DeviceManagementConfigurationPolicyId $policy.Id
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
        [System.String]
        $companyname,

        [Parameter()]
        [System.Int32]
        $daystoretaincleanedmalware,
        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disableaccountprotectionui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disableappbrowserui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablecleartpmbutton,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disabledevicesecurityui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disableenhancednotifications,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablefamilyui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablehealthui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablenetworkui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disabletpmfirmwareupdatewarning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablevirusui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablecatchupfullscan,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablecatchupquickscan,

        [Parameter()]
        [System.String]
        $email,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $enablecustomizedtoasts,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $enableinappcustomization,

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
        [ValidateSet('0', '1')]
        [System.String]
        $hideransomwaredatarecovery,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $hidewindowssecuritynotificationareacontrol,

        [Parameter()]
        [System.String]
        $phone,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $puaprotection,

        [Parameter()]
        [ValidateSet('0', '2', '3', '4', '5', '6')]
        [System.String]
        $engineupdateschannel,

        [Parameter()]
        [ValidateSet('0', '2', '3', '4', '5', '6')]
        [System.String]
        $platformupdateschannel,

        [Parameter()]
        [ValidateSet('0', '4', '5')]
        [System.String]
        $securityintelligenceupdateschannel,

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
        $tamperprotection,

        [Parameter()]
        [System.String]
        $url,

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
        [ValidateSet('d948ff9b-99cb-4ee0-8012-1fbc09685377_1', 'e3f74c5a-a6de-411d-aef6-eb15628f3a0a_1', '45fea5e9-280d-4da1-9792-fb5736da0ca9_1', '804339ad-1553-4478-a742-138fb5807418_1')]
        [System.String]
        $templateId,

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
    $PSBoundParameters.Remove('templateId') | Out-Null

    $templateReferenceId = $templateId
    $platforms = 'windows10'
    $technologies = 'mdm,microsoftSense'

    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Endpoint Protection Policy {$DisplayName}"
        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null
        $PSBoundParameters.Remove('Identity') | Out-Null
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $settings = Format-M365DSCIntuneSettingCatalogPolicySettings `
            -DSCParams ([System.Collections.Hashtable]$PSBoundParameters) `
            -TemplateReferenceId $templateReferenceId

        $policy = New-IntuneDeviceConfigurationPolicy `
            -Name $DisplayName `
            -Description $Description `
            -TemplateReferenceId $templateReferenceId `
            -Platforms $platforms `
            -Technologies $technologies `
            -Settings $settings

        $assignmentsHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignments
        Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $policy.id -Targets $assignmentsHash

    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Endpoint Protection Policy {$($currentPolicy.DisplayName)}"
        $PSBoundParameters.Remove('DisplayName') | Out-Null
        $PSBoundParameters.Remove('Description') | Out-Null
        $PSBoundParameters.Remove('Identity') | Out-Null
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $settings = Format-M365DSCIntuneSettingCatalogPolicySettings `
            -DSCParams ([System.Collections.Hashtable]$PSBoundParameters) `
            -TemplateReferenceId $templateReferenceId

        Update-IntuneDeviceConfigurationPolicy `
            -DeviceConfigurationPolicyId $Identity `
            -Name $DisplayName `
            -Description $Description `
            -TemplateReferenceId $templateReferenceId `
            -Platforms $platforms `
            -Technologies $technologies `
            -Settings $settings

        $assignmentsHash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignments
        Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $currentPolicy.Identity -Targets $assignmentsHash

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
        [System.String]
        $companyname,

        [Parameter()]
        [System.Int32]
        $daystoretaincleanedmalware,
        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disableaccountprotectionui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disableappbrowserui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablecleartpmbutton,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disabledevicesecurityui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disableenhancednotifications,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablefamilyui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablehealthui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablenetworkui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disabletpmfirmwareupdatewarning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablevirusui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablecatchupfullscan,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablecatchupquickscan,

        [Parameter()]
        [System.String]
        $email,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $enablecustomizedtoasts,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $enableinappcustomization,

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
        [ValidateSet('0', '1')]
        [System.String]
        $hideransomwaredatarecovery,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $hidewindowssecuritynotificationareacontrol,

        [Parameter()]
        [System.String]
        $phone,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $puaprotection,

        [Parameter()]
        [ValidateSet('0', '2', '3', '4', '5', '6')]
        [System.String]
        $engineupdateschannel,

        [Parameter()]
        [ValidateSet('0', '2', '3', '4', '5', '6')]
        [System.String]
        $platformupdateschannel,

        [Parameter()]
        [ValidateSet('0', '4', '5')]
        [System.String]
        $securityintelligenceupdateschannel,

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
        $tamperprotection,

        [Parameter()]
        [System.String]
        $url,

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
        [ValidateSet('d948ff9b-99cb-4ee0-8012-1fbc09685377_1', 'e3f74c5a-a6de-411d-aef6-eb15628f3a0a_1', '45fea5e9-280d-4da1-9792-fb5736da0ca9_1', '804339ad-1553-4478-a742-138fb5807418_1')]
        [System.String]
        $templateId,

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

    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()
    $ValuesToCheck.Remove('Identity') | Out-Null

    if ($CurrentValues.Ensure -ne $PSBoundParameters.Ensure)
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
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
    $ValuesToCheck.Remove('Assignments') | Out-Null

    if ($testResult)
    {
        foreach ($key in $PSBoundParameters.keys)
        {
            #Removing empty array when not returned from Get-Resource
            $value = $PSBoundParameters.$key
            if ($null -ne $value -and $value.getType().Name -like '*[[\]]' -and $value.count -eq 0 -and $null -eq $CurrentValues.$key)
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
        -SkipModuleReload:$true

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
        $templateFamily = 'endpointSecurityAntivirus'
        $templateReferences = "d948ff9b-99cb-4ee0-8012-1fbc09685377_1", "e3f74c5a-a6de-411d-aef6-eb15628f3a0a_1", "45fea5e9-280d-4da1-9792-fb5736da0ca9_1","804339ad-1553-4478-a742-138fb5807418_1"
        [array]$policies = Get-MgBetaDeviceManagementConfigurationPolicy `
            -ErrorAction Stop `
            -All:$true `
            -Filter $Filter
        $policies = $policies | Where-Object -FilterScript { $_.TemplateReference.TemplateFamily -eq $templateFamily -and $_.TemplateReference.TemplateId -in $templateReferences }

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
                TemplateId            = $policy.templateReference.templateId
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
        $Uri = 'https://graph.microsoft.com/beta/deviceManagement/configurationPolicies'

        $policy = @{
            'name'              = $Name
            'description'       = $Description
            'platforms'         = $Platforms
            'technologies'      = $Technologies
            'templateReference' = @{'templateId' = $TemplateReferenceId }
            'settings'          = $Settings
        }
        $body = $policy | ConvertTo-Json -Depth 20
        #Write-Verbose -Message $body
        Invoke-MgGraphRequest -Method POST -Uri $Uri -Body $body -ErrorAction Stop

    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error updating data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        #write-verbose ($_ | out-string)
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
        $Uri = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/$DeviceConfigurationPolicyId"

        $policy = @{
            'name'              = $Name
            'description'       = $Description
            'platforms'         = $Platforms
            'templateReference' = @{'templateId' = $TemplateReferenceId }
            'technologies'      = $Technologies
            'settings'          = $Settings
        }
        $body = $policy | ConvertTo-Json -Depth 20
        #write-verbose -Message $body
        Invoke-MgGraphRequest -Method PUT -Uri $Uri -Body $body -ErrorAction Stop

    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error updating data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

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
        $IncludeSettingInstanceTemplateId = $true,

        [Parameter()]
        [System.Boolean]
        $IncludeSettingValueTemplateId = $true

    )

    $DSCParams.Remove('Verbose') | Out-Null
    $results = @()

    foreach ($param in $DSCParams.Keys)
    {
        $settingInstance = [ordered]@{}
        $settingInstance.add('settingDefinitionId', $templateSetting.settingDefinitionId)
        if ($IncludeSettingInstanceTemplateId -and -Not [string]::IsNullOrEmpty($templateSetting.settingInstanceTemplateId))
        {
            $settingInstance.add('settingInstanceTemplateReference', @{'settingInstanceTemplateId' = $templateSetting.settingInstanceTemplateId })
        }

        $odataType = $templateSetting.AdditionalProperties.'@odata.type'
        if ([string]::IsNullOrEmpty($odataType))
        {
            $odataType = $templateSetting.'@odata.type'
        }
        $settingInstance.add('@odata.type', $odataType.replace('Template', ''))

        switch ($odataType)
        {
            '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstanceTemplate'
            {
                $choiceSettingValue = [ordered]@{}
                $choiceSettingValue.add('@odata.type', '#microsoft.graph.deviceManagementConfigurationChoiceSettingValue')
                $choiceSettingValue.add('children', @())
                $settingValueTemplateId = $templateSetting.AdditionalProperties.choiceSettingValueTemplate.settingValueTemplateId
                if ($IncludeSettingValueTemplateId -and -Not [string]::IsNullOrEmpty($settingValueTemplateId))
                {
                    $choiceSettingValue.add('settingValueTemplateReference', @{'settingValueTemplateId' = $SettingValueTemplateId })
                }
                $choiceSettingValue.add('value', "$($templateSetting.settingDefinitionId)`_$($DSCParams.$param)")
                $settingInstance.add('choiceSettingValue', $choiceSettingValue)
                $results += $settingInstance
            }
            '#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstanceTemplate'
            {
                $simpleSettingCollectionValues = @()

                foreach ($value in $DSCParams.$param)
                {
                    $simpleSettingCollectionValue = @{}
                    $settingValueTemplateId = $templateSetting.AdditionalProperties.simpleSettingCollectionValueTemplate.settingValueTemplateId
                    if ($IncludeSettingValueTemplateId -and -Not [string]::IsNullOrEmpty($settingValueTemplateId))
                    {
                        $simpleSettingCollectionValue.add('settingValueTemplateReference', @{'settingValueTemplateId' = $SettingValueTemplateId })
                    }
                    $settingValueDataType = $templateSetting.AdditionalProperties.simpleSettingCollectionValueTemplate.'@odata.type'.replace('Template', '')
                    $simpleSettingCollectionValue.add('@odata.type', $settingValueDataType)
                    $simpleSettingCollectionValue.add('value', $value)
                    $simpleSettingCollectionValues += $simpleSettingCollectionValue
                }
                $settingInstance.add('simpleSettingCollectionValue', $simpleSettingCollectionValues)

                $results += $settingInstance
            }
            '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstanceTemplate'
            {
                $simpleSettingValue = @{}
                $SettingValueType = $templateSetting.AdditionalProperties.simpleSettingValueTemplate.'@odata.type'
                if (-Not [string]::IsNullOrEmpty($SettingValueType))
                {
                    $simpleSettingValue.add('@odata.type', $SettingValueType.replace('Template', ''))
                }
                $simpleSettingValue.add('value', $DSCParams.$param)

                $settingValueTemplateId = $templateSetting.AdditionalProperties.simpleSettingValueTemplate.settingValueTemplateId
                if (-Not [string]::IsNullOrEmpty($settingValueTemplateId))
                {
                    $simpleSettingValue.add('settingValueTemplateReference', @{'settingValueTemplateId' = $settingValueTemplateId })
                }

                $settingInstance.add('simpleSettingValue', $simpleSettingValue)
                $results += $settingInstance
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

    $templateSettings = Get-MgBetaDeviceManagementConfigurationPolicyTemplateSettingTemplate -DeviceManagementConfigurationPolicyTemplateId $templateReferenceId -All

    #write-verbose -Message ( $DSCParams|out-string)

    $simpleSettings = @()
    $simpleSettings += $templateSettings.SettingInstanceTemplate | Where-Object -FilterScript `
    { $_.AdditionalProperties.'@odata.type' -ne '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstanceTemplate' }

    $keys = $DSCParams.keys
    $keys = $keys -replace 'tamperprotection', 'options'
    foreach ($templateSetting in $simpleSettings)
    {
        $setting = @{}
        $settingKey = $keys | Where-Object -FilterScript { $templateSetting.settingDefinitionId -like "*$($_)" }
        $originalKey = $settingKey
        if ($settingKey -eq 'options')
        {
            $originalKey = 'tamperprotection'
        }
        if ((-not [String]::IsNullOrEmpty($settingKey)) -and $null -ne $DSCParams."$originalKey")
        {
            $setting.add('@odata.type', '#microsoft.graph.deviceManagementConfigurationSetting')

            $includeValueReference = $true
            $includeSettingInstanceReference = $true
            $doNotIncludesettingInstanceReferenceKeys = @(
                'highseveritythreats'
                'lowseveritythreats'
            )
            $noValueReferenceKeys = @(
                'excludedpaths'
                'excludedprocesses'
                'excludedextensions'
            )
            if ($originalKey -in $noValueReferenceKeys)
            {
                $includeValueReference = $false
            }
            if ($originalKey -in $doNotIncludesettingInstanceReferenceKeys)
            {
                $includeSettingInstanceReference = $false
            }
            $myFormattedSetting = Format-M365DSCParamsToSettingInstance -DSCParams @{$settingKey = $DSCParams."$originalKey" } `
                -TemplateSetting $templateSetting `
                -IncludeSettingValueTemplateId $includeValueReference `
                -IncludeSettingInstanceTemplateId $includeSettingInstanceReference

            $setting.add('settingInstance', $myFormattedSetting)
            $settings += $setting
            $DSCParams.Remove($settingKey) | Out-Null

        }
    }

    $groupCollectionTemplateSettings = @()
    $groupCollectionTemplateSettings += $templateSettings.SettingInstanceTemplate | Where-Object -FilterScript `
    { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstanceTemplate' }

    foreach ($groupCollectionTemplateSetting in $groupCollectionTemplateSettings)
    {
        $setting = @{}
        $setting.add('@odata.type', '#microsoft.graph.deviceManagementConfigurationSetting')
        $settingInstance = [ordered]@{}
        $settingInstance.add('@odata.type', '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance')
        $settingInstance.add('settingDefinitionId', $groupCollectionTemplateSetting.settingDefinitionId)
        $settingInstance.add('settingInstanceTemplateReference', @{
                '@odata.type'               = '#microsoft.graph.deviceManagementConfigurationSettingInstanceTemplateReference'
                'settingInstanceTemplateId' = $groupCollectionTemplateSetting.settingInstanceTemplateId
            })
        $groupSettingCollectionValues = @()
        $groupSettingCollectionValueChildren = @()
        $groupSettingCollectionValue = @{}
        $groupSettingCollectionValue.add('@odata.type', '#microsoft.graph.deviceManagementConfigurationGroupSettingValue')

        $settingValueTemplateId = $groupCollectionTemplateSetting.AdditionalProperties.groupSettingCollectionValueTemplate.settingValueTemplateId
        if (-Not [string]::IsNullOrEmpty($settingValueTemplateId))
        {
            $groupSettingCollectionValue.add('settingValueTemplateReference', @{'settingValueTemplateId' = $SettingValueTemplateId })
        }

        foreach ($key in $DSCParams.keys)
        {
            $templateValue = $groupCollectionTemplateSetting.AdditionalProperties.groupSettingCollectionValueTemplate.children | Where-Object `
                -FilterScript { $_.settingDefinitionId -like "*$key" }
            if ($templateValue)
            {
                $includeValueReference = $true
                $includeSettingInstanceReference = $true
                $doNotIncludesettingInstanceReferenceKeys = @(
                    'highseveritythreats'
                    'lowseveritythreats'
                    'moderateseveritythreats'
                    'severethreats'
                )
                $noValueReferenceKeys = @(
                    'excludedpaths'
                    'excludedprocesses'
                    'excludedextensions'
                    'highseveritythreats'
                    'lowseveritythreats'
                    'moderateseveritythreats'
                    'severethreats'
                )
                if ($key -in $noValueReferenceKeys)
                {
                    $includeValueReference = $false
                }
                if ($key -in $doNotIncludesettingInstanceReferenceKeys)
                {
                    $includeSettingInstanceReference = $false
                }
                $groupSettingCollectionValueChild = Format-M365DSCParamsToSettingInstance `
                    -DSCParams @{$key = $DSCParams."$key" } `
                    -TemplateSetting $templateValue `
                    -IncludeSettingValueTemplateId $includeValueReference `
                    -IncludeSettingInstanceTemplateId $includeSettingInstanceReference

                $groupSettingCollectionValueChildren += $groupSettingCollectionValueChild
            }
        }

        $groupSettingCollectionValue.add('children', $groupSettingCollectionValueChildren)
        $groupSettingCollectionValues += $groupSettingCollectionValue
        $settingInstance.add('groupSettingCollectionValue', $groupSettingCollectionValues)

        $setting.add('settingInstance', $settingInstance)

        if ($setting.settingInstance.groupSettingCollectionValue.children.count -gt 0)
        {
            $settings += $setting
        }
    }

    return $settings
}

Export-ModuleMember -Function *-TargetResource
