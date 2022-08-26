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
        [ValidateSet("0", "1")]
        [System.String]
        $allowarchivescanning,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowbehaviormonitoring,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowcloudprotection,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowemailscanning,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowfullscanonmappednetworkdrives,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowfullscanremovabledrivescanning,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowintrusionpreventionsystem,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowioavprotection,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowrealtimemonitoring,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowscanningnetworkfiles,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowscriptscanning,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowuseruiaccess,

        [Parameter()]
        [System.int32]
        $avgcpuloadfactor,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $checkforsignaturesbeforerunningscan,

        [Parameter()]
        [ValidateSet("0","2","4","6")]
        [System.String]
        $cloudblocklevel,

        [Parameter()]
        [System.Int32]
        $cloudextendedtimeout,

        [Parameter()]
        [System.Int32]
        $daystoretaincleanedmalware,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $disablecatchupfullscan,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $disablecatchupquickscan,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $enablelowcpupriority,

        [Parameter()]
        [ValidateSet("0", "1", "2")]
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
        [ValidateSet("0", "1", "2")]
        [System.String]
        $puaprotection,

        [Parameter()]
        [ValidateSet("0", "1", "2")]
        [System.String]
        $realtimescandirection,

        [Parameter()]
        [ValidateSet("1", "2")]
        [System.String]
        $scanparameter,

        [Parameter()]
        [System.Int32]
        $schedulequickscantime,

        [Parameter()]
        [ValidateSet("0","1","2","3","4","5","6","7","8")]
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
        [ValidateSet("0", "1", "2", "3")]
        [System.String]
        $submitsamplesconsent,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $disablelocaladminmerge,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowonaccessprotection,

        [Parameter()]
        [ValidateSet("clean", "quarantine","remove", "allow", "userdefined", "block")]
        [System.String]
        $lowseveritythreats,

        [Parameter()]
        [ValidateSet("clean", "quarantine","remove", "allow", "userdefined", "block")]
        [System.String]
        $moderateseveritythreats,

        [Parameter()]
        [ValidateSet("clean", "quarantine","remove", "allow", "userdefined", "block")]
        [System.String]
        $severethreats,

        [Parameter()]
        [ValidateSet("clean", "quarantine","remove", "allow", "userdefined", "block")]
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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Checking for the Intune Endpoint Protection Policy {$DisplayName}"

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -ProfileName 'beta' -ErrorAction Stop

    $context=Get-MgContext
    if($null -eq $context)
    {
        New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters -ErrorAction Stop
    }

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

    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'

    try
    {
        #Retrieve policy general settings
        $policy = Get-MgDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $Identity -ErrorAction Stop

        if ($null -eq $policy)
        {
            Write-Verbose -Message "No Endpoint Protection Policy {$Identity} was found"
            return $nullResult
        }

        #Retrieve policy specific settings
        [array]$settings = Get-MgDeviceManagementConfigurationPolicySetting `
            -DeviceManagementConfigurationPolicyId $Identity `
            -ErrorAction Stop

        $returnHashtable=@{}
        $returnHashtable.Add("Identity",$Identity)
        $returnHashtable.Add("DisplayName",$policy.name)
        $returnHashtable.Add("Description",$policy.description)

        foreach ($setting in $settings.settingInstance)
        {
            $addToParameters = $true
            $settingName = $setting.settingDefinitionId.Split("_")|Select-Object -Last 1

            switch ($setting.AdditionalProperties."@odata.type")
            {
                "#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance"
                {
                    $values = @()
                    foreach($value in $setting.simpleSettingCollectionValue)
                    {
                        $values += Get-DeviceManagementConfigurationSettingInstanceValue -Setting $value
                    }
                    $settingValue = $values
                }

                "#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance"
                {
                    $values = @()
                    foreach ($value in $setting.groupSettingCollectionValue.children)
                    {
                        $settingName = $value.settingDefinitionId.split("_")|Select-Object -Last 1
                        $settingValue = Get-DeviceManagementConfigurationSettingInstanceValue -Setting $value
                        $returnHashtable.Add($settingName,$settingValue)
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
                $returnHashtable.Add($settingName,$settingValue)
            }

        }
        $returnAssignments = @()
        $returnAssignments += Get-MgDeviceManagementConfigurationPolicyAssignment -DeviceManagementConfigurationPolicyId $Identity
        $returnHashtable.Add('Assignments',$returnAssignments)

        Write-Verbose -Message "Found Endpoint Protection Policy {$($policy.name)}"

        $returnHashtable.Add("Ensure","Present")
        $returnHashtable.Add("Credential",$Credential)
        $returnHashtable.Add("ApplicationId",$ApplicationId)
        $returnHashtable.Add("TenantId",$TenantId)
        $returnHashtable.Add("ApplicationSecret",$ApplicationSecret)
        $returnHashtable.Add("CertificateThumbprint",$CertificateThumbprint)

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
        [ValidateSet("0", "1")]
        [System.String]
        $allowarchivescanning,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowbehaviormonitoring,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowcloudprotection,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowemailscanning,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowfullscanonmappednetworkdrives,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowfullscanremovabledrivescanning,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowintrusionpreventionsystem,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowioavprotection,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowrealtimemonitoring,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowscanningnetworkfiles,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowscriptscanning,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowuseruiaccess,

        [Parameter()]
        [System.int32]
        $avgcpuloadfactor,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $checkforsignaturesbeforerunningscan,

        [Parameter()]
        [ValidateSet("0","2","4","6")]
        [System.String]
        $cloudblocklevel,

        [Parameter()]
        [System.Int32]
        $cloudextendedtimeout,

        [Parameter()]
        [System.Int32]
        $daystoretaincleanedmalware,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $disablecatchupfullscan,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $disablecatchupquickscan,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $enablelowcpupriority,

        [Parameter()]
        [ValidateSet("0", "1", "2")]
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
        [ValidateSet("0", "1", "2")]
        [System.String]
        $puaprotection,

        [Parameter()]
        [ValidateSet("0", "1", "2")]
        [System.String]
        $realtimescandirection,

        [Parameter()]
        [ValidateSet("1", "2")]
        [System.String]
        $scanparameter,

        [Parameter()]
        [System.Int32]
        $schedulequickscantime,

        [Parameter()]
        [ValidateSet("0","1","2","3","4","5","6","7","8")]
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
        [ValidateSet("0", "1", "2", "3")]
        [System.String]
        $submitsamplesconsent,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $disablelocaladminmerge,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowonaccessprotection,

        [Parameter()]
        [ValidateSet("clean", "quarantine","remove", "allow", "userdefined", "block")]
        [System.String]
        $lowseveritythreats,

        [Parameter()]
        [ValidateSet("clean", "quarantine","remove", "allow", "userdefined", "block")]
        [System.String]
        $moderateseveritythreats,

        [Parameter()]
        [ValidateSet("clean", "quarantine","remove", "allow", "userdefined", "block")]
        [System.String]
        $severethreats,

        [Parameter()]
        [ValidateSet("clean", "quarantine","remove", "allow", "userdefined", "block")]
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

    $templateReferenceId='804339ad-1553-4478-a742-138fb5807418_1'
    $platforms='windows10'
    $technologies='mdm,microsoftSense'

    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Endpoint Protection Policy {$DisplayName}"

        $settings= Format-M365DSCIntuneSettingCatalogPolicySettings `
            -DSCParams ([System.Collections.Hashtable]$PSBoundParameters)

        $policy=New-MgDeviceManagementConfigurationPolicy `
            -DisplayName $DisplayName `
            -Description $Description `
            -TemplateReferenceId $templateReferenceId `
            -Platforms $platforms `
            -Technologies $technologies `
            -Settings $settings

        $assignmentsHash=Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignments
        Update-MgDeviceManagementConfigurationPolicyAssignments -DeviceManagementConfigurationPolicyId $policy.id -Targets $assignmentsHash

    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Endpoint Protection Policy {$($currentPolicy.DisplayName)}"

        $settings= Format-M365DSCIntuneSettingCatalogPolicySettings `
            -DSCParams ([System.Collections.Hashtable]$PSBoundParameters)

        Update-MgDeviceManagementConfigurationPolicy `
            -Identity $Identity `
            -DisplayName $DisplayName `
            -Description $Description `
            -TemplateReferenceId $templateReferenceId `
            -Platforms $platforms `
            -Technologies $technologies `
            -Settings $settings

        $assignmentsHash=Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignments
        Update-MgDeviceManagementConfigurationPolicyAssignments -DeviceManagementConfigurationPolicyId $currentPolicy.Identity -Targets $assignmentsHash

    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Endpoint Protection Policy {$currentPolicy.DisplayName}"
        Remove-MgDeviceManagementConfigurationPolicy -Identity $Identity
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
        [ValidateSet("0", "1")]
        [System.String]
        $allowarchivescanning,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowbehaviormonitoring,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowcloudprotection,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowemailscanning,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowfullscanonmappednetworkdrives,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowfullscanremovabledrivescanning,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowintrusionpreventionsystem,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowioavprotection,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowrealtimemonitoring,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowscanningnetworkfiles,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowscriptscanning,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowuseruiaccess,

        [Parameter()]
        [System.int32]
        $avgcpuloadfactor,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $checkforsignaturesbeforerunningscan,

        [Parameter()]
        [ValidateSet("0","2","4","6")]
        [System.String]
        $cloudblocklevel,

        [Parameter()]
        [System.Int32]
        $cloudextendedtimeout,

        [Parameter()]
        [System.Int32]
        $daystoretaincleanedmalware,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $disablecatchupfullscan,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $disablecatchupquickscan,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $enablelowcpupriority,

        [Parameter()]
        [ValidateSet("0", "1", "2")]
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
        [ValidateSet("0", "1", "2")]
        [System.String]
        $puaprotection,

        [Parameter()]
        [ValidateSet("0", "1", "2")]
        [System.String]
        $realtimescandirection,

        [Parameter()]
        [ValidateSet("1", "2")]
        [System.String]
        $scanparameter,

        [Parameter()]
        [System.Int32]
        $schedulequickscantime,

        [Parameter()]
        [ValidateSet("0","1","2","3","4","5","6","7","8")]
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
        [ValidateSet("0", "1", "2", "3")]
        [System.String]
        $submitsamplesconsent,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $disablelocaladminmerge,

        [Parameter()]
        [ValidateSet("0", "1")]
        [System.String]
        $allowonaccessprotection,

        [Parameter()]
        [ValidateSet("clean", "quarantine","remove", "allow", "userdefined", "block")]
        [System.String]
        $lowseveritythreats,

        [Parameter()]
        [ValidateSet("clean", "quarantine","remove", "allow", "userdefined", "block")]
        [System.String]
        $moderateseveritythreats,

        [Parameter()]
        [ValidateSet("clean", "quarantine","remove", "allow", "userdefined", "block")]
        [System.String]
        $severethreats,

        [Parameter()]
        [ValidateSet("clean", "quarantine","remove", "allow", "userdefined", "block")]
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
    Write-Verbose -Message "Testing configuration of Endpoint Protection Policy {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    #Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    #Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null

    $testResult=$true
    if([Array]$Assignments.count -ne $CurrentValues.Assignments.count)
    {
        Write-Verbose -Message "Configuration drift:Number of assignments does not match: Source=$([Array]$Assignments.count) Target=$($CurrentValues.Assignments.count)"
        $testResult=$false
    }
    if($testResult)
    {
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
    $ValuesToCheck.Remove('Assignments') | Out-Null

    if($testResult)
    {
        $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
            -Source $($MyInvocation.MyCommand.Source) `
            -DesiredValues $PSBoundParameters `
            -ValuesToCheck $ValuesToCheck.Keys -Verbose
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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload:$true `
        -ProfileName 'Beta'

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
        $policyTemplateID='804339ad-1553-4478-a742-138fb5807418_1'
        [array]$policies = Get-MgDeviceManagementConfigurationPolicy `
            -ErrorAction Stop `
            -All:$true `
            -Filter $Filter
        $policies = $policies | Where-Object -FilterScript {$_.TemplateReference.TemplateId -eq $policyTemplateId}

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
            Write-Host "    |---[$i/$($policies.Count)] $($policy.Name)" -NoNewline

            $params = @{
                Identity                            = $policy.id
                Ensure                              = 'Present'
                Credential                          = $Credential
                ApplicationId                       = $ApplicationId
                TenantId                            = $TenantId
                ApplicationSecret                   = $ApplicationSecret
                CertificateThumbprint               = $CertificateThumbprint
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

function Get-DeviceManagementConfigurationSettingInstanceValue
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Setting
    )

    switch ($setting."@odata.type")
    {
        "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
        {
            $settingValue= $setting.choiceSettingValue.value.split("_")|Select-Object -Last 1

        }
        "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance"
        {
            $settingValue= $setting.simpleSettingValue.value
        }
        Default
        {
            $settingValue=$setting.value
        }
    }
    return $settingValue
}
function Convert-M365DSCParamsToSettingInstance
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $DSCParams,

        [Parameter(Mandatory = 'true')]
        [System.String]
        $SettingDefinitionId,

        [Parameter(Mandatory = 'true')]
        [System.String]
        $SettingDefinitionType,

        [Parameter()]
        [System.String]
        $GroupSettingCollectionDefinitionId,

        [Parameter()]
        [System.String]
        $SettingInstanceTemplateId,

        [Parameter()]
        [System.String]
        $SettingValueType,

        [Parameter()]
        [System.String]
        $SettingValueTemplateId
    )

    $DSCParams.Remove("Verbose") | Out-Null
    $results = @()

    foreach ($param in $DSCParams.Keys)
    {
        $settingDefinitionId=$SettingDefinitionId.ToLower()

        $settingInstance=[ordered]@{}
        $settingInstance.add("@odata.type",$SettingDefinitionType)
        $settingInstance.add("settingDefinitionId",$settingDefinitionId)
        if(-Not [string]::IsNullOrEmpty($settingInstanceTemplateId))
        {
            $settingInstance.add("settingInstanceTemplateReference",@{"settingInstanceTemplateId"=$SettingInstanceTemplateId})
        }
        switch ($SettingDefinitionType)
        {
            "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
            {
                $choiceSettingValue=[ordered]@{}
                $choiceSettingValue.add("children",@())
                $choiceSettingValue.add("@odata.type","#microsoft.graph.deviceManagementConfigurationChoiceSettingValue")
                if(-Not [string]::IsNullOrEmpty($settingValueTemplateId))
                {
                    $choiceSettingValue.add("settingValueTemplateReference",@{"settingValueTemplateId"=$SettingValueTemplateId})
                }
                $choiceSettingValue.add("value","$settingDefinitionId`_$($DSCParams.$param)")
                $settingInstance.add("choiceSettingValue",$choiceSettingValue)
                $results+=$settingInstance
            }
            "#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance"
            {
                $simpleSettingCollectionValues=@()
                foreach($value in $DSCParams.$param)
                {
                    $simpleSettingCollectionValue=@{}
                    $simpleSettingCollectionValue.add("@odata.type","#microsoft.graph.deviceManagementConfigurationStringSettingValue")
                    $simpleSettingCollectionValue.add("value",$value)
                    $simpleSettingCollectionValues+=$simpleSettingCollectionValue
                }
                $settingInstance.add("simpleSettingCollectionValue",$simpleSettingCollectionValues)
                $results+=$settingInstance
            }
            "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance"
            {
                $simpleSettingValue=@{}
                if(-Not [string]::IsNullOrEmpty($SettingValueType))
                {
                    $simpleSettingValue.add("@odata.type",$SettingValueType)
                }
                $simpleSettingValue.add("value",$DSCParams.$param)
                if(-Not [string]::IsNullOrEmpty($settingValueTemplateId))
                {
                    $simpleSettingValue.add("settingValueTemplateReference",@{"settingValueTemplateId"=$settingValueTemplateId})
                }

                $settingInstance.add("simpleSettingValue",$simpleSettingValue)
                $results+=$settingInstance
            }
            "#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance"
            {
                $groupSettingCollectionValues=@()
                $groupSettingCollectionValues+=@{"children"=@()}
                $settingInstance.add("groupSettingCollectionValue",$groupSettingCollectionValues)
                $results += $settingInstance
            }
            Default {}
        }
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
        $DSCParams
    )

    $DSCParams.Remove('Identity') | Out-Null
    $DSCParams.Remove('DisplayName') | Out-Null
    $DSCParams.Remove('Description') | Out-Null

    #Prepare setting definitions mapping
    $settingDefinitions=@(
        @{
            settingName='allowarchivescanning'
            settingDefinitionId='device_vendor_msft_policy_config_defender_allowarchivescanning'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            settingInstanceTemplateId='7c5c9cde-f74d-4d11-904f-de4c27f72d89'
            settingValueTemplateId='9ead75d4-6f30-4bc5-8cc5-ab0f999d79f0'
        }
        @{
            settingName='allowbehaviormonitoring'
            settingDefinitionId='device_vendor_msft_policy_config_defender_allowbehaviormonitoring'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            settingInstanceTemplateId='8eef615a-1aa0-46f4-a25a-12cbe65de5ab'
            settingValueTemplateId='905921da-95e2-4a10-9e30-fe5540002ce1'
        }
        @{
            settingName='allowcloudprotection'
            settingDefinitionId='device_vendor_msft_policy_config_defender_allowcloudprotection'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            settingInstanceTemplateId='7da139f1-9b7e-407d-853a-c2e5037cdc70'
            settingValueTemplateId='16fe8afd-67be-4c50-8619-d535451a500c'
        }
        @{
            settingName='allowemailscanning'
            settingDefinitionId='device_vendor_msft_policy_config_defender_allowemailscanning'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            settingInstanceTemplateId='b0d9ee81-de6a-4750-86d7-9397961c9852'
            settingValueTemplateId='fdf107fd-e13b-4507-9d8f-db4d93476af9'

        }
        @{
            settingName='allowfullscanonmappednetworkdrives'
            settingDefinitionId='device_vendor_msft_policy_config_defender_allowfullscanonmappednetworkdrives'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            settingInstanceTemplateId='dac47505-f072-48d6-9f23-8d93262d58ed'
            settingValueTemplateId='3e920b10-3773-4ac5-957e-e5573aec6d04'
        }
        @{
            settingName='allowfullscanremovabledrivescanning'
            settingDefinitionId='device_vendor_msft_policy_config_defender_allowfullscanremovabledrivescanning'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            settingInstanceTemplateId='fb36e70b-5bc9-488a-a949-8ea3ac1634d5'
            settingValueTemplateId='366c5727-629b-4a81-b50b-52f90282fa2c'
        }
        @{
            settingName='allowintrusionpreventionsystem'
            settingDefinitionId='device_vendor_msft_policy_config_defender_allowintrusionpreventionsystem'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            settingInstanceTemplateId='d47f06e2-5378-43f2-adbc-e924538f1512'
            settingValueTemplateId='03738a99-7065-44cb-ba1e-93530ed906a7'
        }
        @{
            settingName='allowioavprotection'
            settingDefinitionId='device_vendor_msft_policy_config_defender_allowioavprotection'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            settingInstanceTemplateId='fa06231d-aed4-4601-b631-3a37e85b62a0'
            settingValueTemplateId='df4e6cbd-f7ff-41c8-88cd-fa25264a237e'
        }
        @{
            settingName='allowrealtimemonitoring'
            settingDefinitionId='device_vendor_msft_policy_config_defender_allowrealtimemonitoring'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            settingInstanceTemplateId='f0790e28-9231-4d37-8f44-84bb47ca1b3e'
            settingValueTemplateId='0492c452-1069-4b91-9363-93b8e006ab12'
        }
        @{
            settingName='allowscanningnetworkfiles'
            settingDefinitionId='device_vendor_msft_policy_config_defender_allowscanningnetworkfiles'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            settingInstanceTemplateId='f8f28442-0a6b-4b52-b42c-d31d9687c1cf'
            settingValueTemplateId='7b8c858c-a17d-4623-9e20-f34b851670ce'
        }
        @{
            settingName='allowscriptscanning'
            settingDefinitionId='device_vendor_msft_policy_config_defender_allowscriptscanning'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            settingInstanceTemplateId='000cf176-949c-4c08-a5d4-90ed43718db7'
            settingValueTemplateId='ab9e4320-c953-4067-ac9a-be2becd06b4a'
        }
        @{
            settingName='allowuseruiaccess'
            settingDefinitionId='device_vendor_msft_policy_config_defender_allowuseruiaccess'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            settingInstanceTemplateId='0170a900-b0bc-4ccc-b7ce-dda9be49189b'
            settingValueTemplateId='4b6c9739-4449-4006-8e5f-3049136470ea'
        }
        @{
            settingName='avgcpuloadfactor'
            settingDefinitionId='device_vendor_msft_policy_config_defender_avgcpuloadfactor'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
            settingInstanceTemplateId='816cc03e-8f96-4cba-b14f-2658d031a79a'
            settingValueTemplateId='37195fb1-3743-4c8e-a0ce-b6fae6fa3acd'
            settingValueType='#microsoft.graph.deviceManagementConfigurationIntegerSettingValue'
        }
        @{
            settingName='checkforsignaturesbeforerunningscan'
            settingDefinitionId='device_vendor_msft_policy_config_defender_checkforsignaturesbeforerunningscan'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            settingInstanceTemplateId='4fea56e3-7bb6-4ad3-88c6-e364dd2f97b9'
            settingValueTemplateId='010779d1-edd4-441d-8034-89ad57a863fe'
        }
        @{
            settingName='cloudblocklevel'
            settingDefinitionId='device_vendor_msft_policy_config_defender_cloudblocklevel'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            settingInstanceTemplateId='c7a37009-c16e-4145-84c8-89a8c121fb15'
            settingValueTemplateId='517b4e84-e933-42b9-b92f-00e640b1a82d'
        }
        @{
            settingName='cloudextendedtimeout'
            settingDefinitionId='device_vendor_msft_policy_config_defender_cloudextendedtimeout'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
            settingInstanceTemplateId='f61c2788-14e4-4e80-a5a7-bf2ff5052f63'
            settingValueTemplateId='608f1561-b603-46bd-bf5f-0b9872002f75'
            settingValueType='#microsoft.graph.deviceManagementConfigurationIntegerSettingValue'
        }
        @{
            settingName='daystoretaincleanedmalware'
            settingDefinitionId='device_vendor_msft_policy_config_defender_daystoretaincleanedmalware'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
            settingInstanceTemplateId='6f6d741c-1186-42e2-b2f2-8582febcfd60'
            settingValueTemplateId='214b6feb-c9b2-4a17-af54-d51c805473e4'
            settingValueType='#microsoft.graph.deviceManagementConfigurationIntegerSettingValue'
        }
        @{
            settingName='disablecatchupfullscan'
            settingDefinitionId='device_vendor_msft_policy_config_defender_disablecatchupfullscan'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            settingInstanceTemplateId='f881b08c-f047-40d2-b7d9-3dde7ce9ef64'
            settingValueTemplateId='1b26092f-48c4-447b-99d4-e9c501542f1c'
        }
        @{
            settingName='disablecatchupquickscan'
            settingDefinitionId='device_vendor_msft_policy_config_defender_disablecatchupquickscan'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            settingInstanceTemplateId='dabf6781-9d5d-42da-822a-d4327aa2bdd1'
            settingValueTemplateId='d263ced7-0d23-4095-9326-99c8b3f5d35b'
        }
        @{
            settingName='enablelowcpupriority'
            settingDefinitionId='device_vendor_msft_policy_config_defender_enablelowcpupriority'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            settingInstanceTemplateId='cdeb96cf-18f5-4477-a710-0ea9ecc618af'
            settingValueTemplateId='045a4a13-deee-4e24-9fe4-985c9357680d'
        }
        @{
            settingName='enablenetworkprotection'
            settingDefinitionId='device_vendor_msft_policy_config_defender_enablenetworkprotection'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            settingInstanceTemplateId='f53ab20e-8af6-48f5-9fa1-46863e1e517e'
            settingValueTemplateId='ee58fb51-9ae5-408b-9406-b92b643f388a'
        }
        @{
            settingName='excludedextensions'
            settingDefinitionId='device_vendor_msft_policy_config_defender_excludedextensions'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance'
            settingInstanceTemplateId='634df7cc-28ae-438c-81b7-65f2f8ec0c63'
            settingValueType='#microsoft.graph.deviceManagementConfigurationStringSettingValue'
        }
        @{
            settingName='excludedpaths'
            settingDefinitionId='device_vendor_msft_policy_config_defender_excludedpaths'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance'
            settingInstanceTemplateId='867f7498-1484-443f-bf6a-f12abb1f2f60'
            settingValueType='#microsoft.graph.deviceManagementConfigurationStringSettingValue'
        }
        @{
            settingName='excludedprocesses'
            settingDefinitionId='device_vendor_msft_policy_config_defender_excludedprocesses'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance'
            settingInstanceTemplateId='6b54c69b-1686-4088-95bb-62c19817e132'
            settingValueType='#microsoft.graph.deviceManagementConfigurationStringSettingValue'
        }
        @{
            settingName='puaprotection'
            settingDefinitionId='device_vendor_msft_policy_config_defender_puaprotection'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            settingInstanceTemplateId='c0135c2a-f802-44f4-9b71-b0b976411b8c'
            settingValueTemplateId='2d790211-18cb-4e32-b8cc-97407e2c0b45'
        }
        @{
            settingName='realtimescandirection'
            settingDefinitionId='device_vendor_msft_policy_config_defender_realtimescandirection'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            settingInstanceTemplateId='f5ff00a4-e5c7-44cf-a650-9c7619ff1561'
            settingValueTemplateId='6b4e3497-cfbb-4761-a152-de935bbf3f07'
        }
        @{
            settingName='scanparameter'
            settingDefinitionId='device_vendor_msft_policy_config_defender_scanparameter'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            settingInstanceTemplateId='27ca2652-46f3-4cc7-83f2-bf85ff722d84'
            settingValueTemplateId='70c8f42e-ee6a-4ef1-a070-cb0e9d472581'
        }
        @{
            settingName='schedulequickscantime'
            settingDefinitionId='device_vendor_msft_policy_config_defender_schedulequickscantime'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
            settingInstanceTemplateId='784a4af1-33fa-45f2-b945-138b7ff3bcb6'
            settingValueTemplateId='5d5c55c8-1a4e-4272-830d-8dc64cd3ac03'
            settingValueType='#microsoft.graph.deviceManagementConfigurationIntegerSettingValue'
        }
        @{
            settingName='schedulescanday'
            settingDefinitionId='device_vendor_msft_policy_config_defender_schedulescanday'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            settingInstanceTemplateId='087d3362-7e78-4983-96bc-1f4ea183f0e4'
            settingValueTemplateId='7f4d9dda-6d48-4353-90ca-9fa7164c7215'
        }
        @{
            settingName='schedulescantime'
            settingDefinitionId='device_vendor_msft_policy_config_defender_schedulescantime'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
            settingInstanceTemplateId='66d36baa-74ee-498d-958a-af477008c850'
            settingValueTemplateId='a204c511-6130-473a-b05f-93bda521aba9'
            settingValueType='#microsoft.graph.deviceManagementConfigurationIntegerSettingValue'
        }
        @{
            settingName='signatureupdatefallbackorder'
            settingDefinitionId='device_vendor_msft_policy_config_defender_signatureupdatefallbackorder'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance'
            settingInstanceTemplateId='cce4b3e7-b1a5-42a0-ab91-3bb8c68cc670'
            settingValueType='#microsoft.graph.deviceManagementConfigurationStringSettingValue'
        }
        @{
            settingName='signatureupdatefilesharessources'
            settingDefinitionId='device_vendor_msft_policy_config_defender_signatureupdatefilesharessources'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance'
            settingInstanceTemplateId='f8f4d6fc-dcb4-4bf8-b1fb-88942d05bdc8'
            settingValueType='#microsoft.graph.deviceManagementConfigurationStringSettingValue'
        }
        @{
            settingName='signatureupdateinterval'
            settingDefinitionId='device_vendor_msft_policy_config_defender_signatureupdateinterval'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
            settingInstanceTemplateId='89879f27-6b7d-44d4-a08e-0a0de3e9663d'
            settingValueTemplateId='0af6bbed-a74a-4d08-8587-b16b10b774cb'
            settingValueType='#microsoft.graph.deviceManagementConfigurationIntegerSettingValue'
        }
        @{
            settingName='submitsamplesconsent'
            settingDefinitionId='device_vendor_msft_policy_config_defender_submitsamplesconsent'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            settingInstanceTemplateId='bc47ce7d-a251-4cae-a8a2-6e8384904ab7'
            settingValueTemplateId='826ed4b6-e04f-4975-9d23-6f0904b0d87e'
        }
        @{
            settingName='disablelocaladminmerge'
            settingDefinitionId='device_vendor_msft_defender_configuration_disablelocaladminmerge'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            settingInstanceTemplateId='5f9a9c65-dea7-4987-a5f5-b28cfd9762ba'
            settingValueTemplateId='3a9774b2-3143-47eb-bbca-d73c0ace2b7e'
        }
        @{
            settingName='allowonaccessprotection'
            settingDefinitionId='device_vendor_msft_policy_config_defender_allowonaccessprotection'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            settingInstanceTemplateId='afbc322b-083c-4281-8242-ebbb91398b41'
            settingValueTemplateId='ed077fee-9803-44f3-b045-aab34d8e6d52'
        }
        @{
            settingName='threatseveritydefaultaction'
            settingDefinitionId='device_vendor_msft_policy_config_defender_threatseveritydefaultaction'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
            settingInstanceTemplateId='f6394bc5-6486-4728-b510-555f5c161f2b'
        }
        @{
            settingName='severethreats'
            settingDefinitionId='device_vendor_msft_policy_config_defender_threatseveritydefaultaction_severethreats'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId='device_vendor_msft_policy_config_defender_threatseveritydefaultaction'
        }
        @{
            settingName='moderateseveritythreats'
            settingDefinitionId='device_vendor_msft_policy_config_defender_threatseveritydefaultaction_moderateseveritythreats'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId='device_vendor_msft_policy_config_defender_threatseveritydefaultaction'
        }
        @{
            settingName='lowseveritythreats'
            settingDefinitionId='device_vendor_msft_policy_config_defender_threatseveritydefaultaction_lowseveritythreats'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId='device_vendor_msft_policy_config_defender_threatseveritydefaultaction'
        }
        @{
            settingName='highseveritythreats'
            settingDefinitionId='device_vendor_msft_policy_config_defender_threatseveritydefaultaction_highseveritythreats'
            settingDefinitionType='#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            groupSettingCollectionDefinitionId='device_vendor_msft_policy_config_defender_threatseveritydefaultaction'
        }
    )

    #write-verbose -Message ( $DSCParams|out-string)
    $settings=@()
    foreach ($settingDefinition in $settingDefinitions)
    {

        $setting=@{}
        $value=$DSCParams["$($settingDefinition.settingName)"]

        if($value)
        {
            if([string]::IsNullOrEmpty($settingDefinition.groupSettingCollectionDefinitionId))
            {
                $setting.add("@odata.type","#microsoft.graph.deviceManagementConfigurationSetting")
            }
            $formatParams=@{}
            $formatParams.Add('DSCParams',@{$settingDefinition.settingName=$value})
            $formatParams.Add('settingDefinitionId',$settingDefinition.settingDefinitionId)
            $formatParams.Add('settingDefinitionType',$settingDefinition.settingDefinitionType)
            if(-Not [string]::IsNullOrEmpty($settingDefinition.settingInstanceTemplateId))
            {
                $formatParams.Add('settingInstanceTemplateId',$settingDefinition.settingInstanceTemplateId)
            }
            if(-Not [string]::IsNullOrEmpty($settingDefinition.settingValueTemplateId))
            {
                $formatParams.Add('SettingValueTemplateId',$settingDefinition.settingValueTemplateId)
            }
            if(-Not [string]::IsNullOrEmpty($settingDefinition.settingValueType))
            {
                $formatParams.Add('settingValueType',$settingDefinition.settingValueType)
            }
            $myFormattedSetting= Convert-M365DSCParamsToSettingInstance @formatParams


            if(-Not [string]::IsNullOrEmpty($settingDefinition.groupSettingCollectionDefinitionId))
            {
                #write-verbose -message ($formatParams|out-string)
                $mySetting=$settings.settingInstance|Where-Object -FilterScript {$_.settingDefinitionId -eq $settingDefinition.groupSettingCollectionDefinitionId }
                #write-verbose -message $settingDefinition.settingName
                #Adding groupSettingCollectionDefinitionId if not exist
                if($null -eq $mySetting)
                {
                    $parentSetting=@{}
                    $parentSetting.add("@odata.type","#microsoft.graph.deviceManagementConfigurationSetting")
                    $mySettingDefinition=$settingDefinitions|Where-Object -FilterScript {$_.settingDefinitionId -eq $settingDefinition.groupSettingCollectionDefinitionId}
                    $mySettingDefinitionFormatted=Convert-M365DSCParamsToSettingInstance `
                        -DSCParams @{$mySettingDefinition.settingName=@{}} `
                        -SettingDefinitionId $mySettingDefinition.settingDefinitionId `
                        -SettingDefinitionType $mySettingDefinition.settingDefinitionType `
                        -SettingInstanceTemplateId $mySettingDefinition.settingInstanceTemplateId
                    $parentSetting.add('settingInstance',$mySettingDefinitionFormatted)
                    $settings+=$parentSetting
                    $mySetting=$settings.settingInstance|Where-Object -FilterScript {$_.settingDefinitionId -eq $settingDefinition.groupSettingCollectionDefinitionId }

                }
                #write-verbose -message ($myFormattedSetting|out-string)
                $mySetting.groupSettingCollectionValue[0].children+=$myFormattedSetting
            }
            else
            {
                $setting.add('settingInstance',$myFormattedSetting)
                $settings+=$setting
            }

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
        $Uri="https://graph.microsoft.com/beta/deviceManagement/ConfigurationSettings/$($Identity.tolower())"
        $configurationPolicySetting=Invoke-MgGraphRequest -Method GET  -Uri $Uri -ErrorAction Stop
        return $configurationPolicySetting
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

        [System.String]
        $Whitespace="",

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
                -Whitespace "            "

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
    $currentProperty = "MSFT_$CIMInstanceName{`r`n"
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
                $currentProperty += Get-M365DSCDRGSimpleObjectTypeToString -Key $key -Value $ComplexObject[$key]
            }
        }
    }
    $currentProperty += "            }`r`n"

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
        [System.Collections.Hashtable]
        [Parameter()]
        $ComplexObject
    )
    if(-Not $ComplexObject)
    {
        return $false
    }

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
        $Value
    )

    $returnValue=""
    switch -Wildcard ($Value.GetType().Fullname )
    {
        "*.Boolean"
        {
            $returnValue= "                " + $Key + " = `$" + $Value.ToString() + "`r`n"
        }
        "*.String"
        {
            $delimeter="'"
            if($Value.startswith("MSFT_"))
            {
                $delimeter=""
            }
            $returnValue= "                " + $Key + " = $delimeter" + $Value + "$delimeter`r`n"
        }
        "*.DateTime"
        {
            $returnValue= "                " + $Key + " = '" + $Value + "'`r`n"
        }
        "*.Hashtable"
        {
            if($Value.keys.count -eq 0)
            {
                return ""
            }

            $returnValue= "                " + $key + " = @{`r`n"
            $whitespace="                     "
            $newline="`r`n"
            foreach($k in $Value.keys)
            {
                switch -Wildcard ($Value[$k].GetType().Fullname )
                {
                    "*.String"
                    {
                        $returnValue += "$whitespace$k = '$($Value[$k])'$newline"
                    }
                    "*.DateTime"
                    {
                        $returnValue += "$whitespace$k = '$($Value[$k])'$newline"
                    }
                    Default
                    {
                        $returnValue += "$whitespace$k = $($Value[$k])$newline"
                    }
                }
            }

            $returnValue += "                }`r`n"
        }
        "*[[\]]"
        {
            $returnValue= "                " + $key + " = @("
            $whitespace=""
            $newline=""
            if($Value.count -gt 1)
            {
                $returnValue += "`r`n"
                $whitespace="                    "
                $newline="`r`n"
            }
            foreach ($item in $Value)
            {
                switch -Wildcard ($item.GetType().Fullname )
                {
                    "*.String"
                    {
                        $delimeter="'"
                        if($Value.startswith("MSFT_"))
                        {
                            $delimeter=""
                        }
                        $returnValue += "$whitespace$delimeter$item$delimeter$newline"
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
                $returnValue += "                )`r`n"
            }
            else
            {
                $returnValue += ")`r`n"

            }
        }
        Default
        {
            $returnValue= "                " + $Key + " = " + $Value + "`r`n"
        }
    }
    return $returnValue
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

    $results = @{"@odata.type" = "#microsoft.graph.agreement" }
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

    if (($null -eq $Source) -and ($null -eq $Target))
    {
        return $true
    }

    $keys= $Source.Keys|Where-Object -FilterScript {$_ -ne "PSComputerName"}
    foreach ($key in $keys)
    {
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
                "*DateTime"
                {
                    $Target[$key]=$Target[$key].tostring("MM/dd/yyyy HH:mm:ss")
                }
            }
        }

        #One of the item is null
        if (($null -eq $Source[$key]) -xor ($null -eq $Target[$key]))
        {
            if($null -eq $Target[$key])
            {
                $nullKey="Source={$($Source[$key]|out-string)} Target={null}"
            }
            if($null -eq $Source[$key])
            {
                $nullKey="Source={null} Target={$($Target[$key]|out-string)}"
            }
            Write-Verbose -Message "Configuration drift key: $key - one of the object null and not the other: $nullKey"

            return $false
        }
        #Both source and target aren't null or empty
        if(($null -ne $Source[$key]) -and ($null -ne $Target[$key]))
        {
            if($Source[$key].getType().FullName -like "*CimInstance*")
            {
                #Recursive call for complex object
                $itemSource=@()
                $itemSource+= $Source[$key]
                $itemTarget= @()
                $itemTarget+= $Target[$key]

                $i=0
                foreach($item in $itemSource)
                {
                    if(-not ($itemSource[$i].getType().Fullname -like "*.Hashtable"))
                    {
                        $itemSource[$i]=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $itemSource[$i]
                    }
                    if(-not ($itemTarget[$i].getType().Fullname -like "*.Hashtable"))
                    {
                        $itemTarget[$i]=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $itemTarget[$i]
                    }

                    #Recursive call for complex object
                    $compareResult= Compare-M365DSCComplexObject `
                        -Source ($itemSource[$i]) `
                        -Target ($itemTarget[$i])


                    if(-not $compareResult)
                    {
                        Write-Verbose -Message "Complex Object drift key: $key - Source $($itemSource[$i]|out-string)"
                        Write-Verbose -Message "Complex Object drift key: $key - Target $($itemTarget[$i]|out-string)"
                        return $false
                    }
                    $i++
                }
            }
            else
            {
                #Simple object comparison
                $referenceObject=$Target[$key]
                $differenceObject=$Source[$key]

                $compareResult = Compare-Object `
                    -ReferenceObject ($referenceObject) `
                    -DifferenceObject ($differenceObject)

                if ($null -ne $compareResult)
                {
                    Write-Verbose -Message "Simple Object drift key: $key - Source $($referenceObject|out-string)"
                    Write-Verbose -Message "Simple Object drift key: $key - Target $($differenceObject|out-string)"
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
    return $results
}
Export-ModuleMember -Function *-TargetResource,*
