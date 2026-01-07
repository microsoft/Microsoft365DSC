
Confirm-M365DSCModuleDependency -ModuleName "MSFT_IntuneFirewallPolicySetting"
$Script:PropertiesToRetrieve = @('id', 'displayName', 'description', 'settingDefinitionId', 'settingInstance')

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
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Any', 'All')]
        [System.String]
        $MatchType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $PrinterPolicySettings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $StoragePolicySettings,
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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration for the Intune Firewall Policy Setting with Id {$Id} and Name {$DisplayName}"

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
                $getValue = Invoke-MgGraphRequest `
                    -Uri "/beta/deviceManagement/reusablePolicySettings/$($Id)?`$select=$($Script:PropertiesToRetrieve -join ',')" `
                    -Method GET `
                    -SkipHttpErrorCheck `
                    -ErrorAction SilentlyContinue
                if ($getValue -is [hashtable] -and $getValue.ContainsKey('error'))
                {
                    # Policy does not exist, set it to $null
                    $getValue = $null
                }
            }

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Firewall Policy Setting with Id {$Id}"

                if (-not [System.String]::IsNullOrEmpty($DisplayName))
                {
                    $getValue = (Invoke-MgGraphRequest -Uri "/beta/deviceManagement/reusablePolicySettings?`$filter=DisplayName eq '$($DisplayName -replace "'", "''")' and settingDefinitionId eq 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata'&select=$($Script:PropertiesToRetrieve -join ',')" `
                        -Method GET `
                        -SkipHttpErrorCheck `
                        -ErrorAction SilentlyContinue).value
                    if ($getValue -is [array] -and $getValue.Count -eq 0)
                    {
                        $getValue = $null
                    }
                }
            }
            #endregion
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Firewall Policy Setting with Name {$DisplayName}."
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Firewall Policy Setting with Id {$Id} and Name {$DisplayName} was found"

        $groupObject = $getValue.settingInstance.groupSettingCollectionValue[0]
        $groupSettingsObject = $groupObject.children | Where-Object { $_.settingDefinitionId -like '*descriptoridlist' -or $_.settingDefinitionId -like '*printerdevicesidlist' }
        $matchObject = $groupObject.children | Where-Object { $_.settingDefinitionId -eq 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_matchtype' }

        $storageReusableSettings = @()
        $printerReusableSettings = @()
        foreach ($groupSetting in $groupSettingsObject.groupSettingCollectionValue)
        {
            if ($groupSetting.children[0].settingDefinitionId -like "*descriptoridlist*")
            {
                $serialNumberIdObject = $groupSetting.children | Where-Object { $_.settingDefinitionId -eq 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist_serialnumberid' }
                $deviceIdObject       = $groupSetting.children | Where-Object { $_.settingDefinitionId -eq 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist_deviceid' }
                $pidObject            = $groupSetting.children | Where-Object { $_.settingDefinitionId -eq 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist_pid' }
                $vidObject            = $groupSetting.children | Where-Object { $_.settingDefinitionId -eq 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist_vid' }
                $hardwareIdObject     = $groupSetting.children | Where-Object { $_.settingDefinitionId -eq 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist_hardwareid' }
                $instancePathIdObject = $groupSetting.children | Where-Object { $_.settingDefinitionId -eq 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist_instancepathid' }
                $friendlyNameIdObject = $groupSetting.children | Where-Object { $_.settingDefinitionId -eq 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist_friendlynameid' }
                $nameObject           = $groupSetting.children | Where-Object { $_.settingDefinitionId -eq 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist_name' }
                $busIdObject          = $groupSetting.children | Where-Object { $_.settingDefinitionId -eq 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist_busid' }
                $primaryIdObject      = $groupSetting.children | Where-Object { $_.settingDefinitionId -eq 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist_primaryid' }
                $vid_PidObject        = $groupSetting.children | Where-Object { $_.settingDefinitionId -eq 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist_vid_pid' }

                $policySetting = @{
                    BusId          = $busIdObject.simpleSettingValue.value
                    DeviceId       = $deviceIdObject.simpleSettingValue.value
                    FriendlyNameId = $friendlyNameIdObject.simpleSettingValue.value
                    HardwareId     = $hardwareIdObject.simpleSettingValue.value
                    InstancePathId = $instancePathIdObject.simpleSettingValue.value
                    Name           = $nameObject.simpleSettingValue.value
                    PID            = $pidObject.simpleSettingValue.value
                    PrimaryId      = $primaryIdObject.simpleSettingValue.value
                    SerialNumberId = $serialNumberIdObject.simpleSettingValue.value
                    VID            = $vidObject.simpleSettingValue.value
                    VID_PID        = $vid_PidObject.simpleSettingValue.value
                }
                $policySetting.Keys.Clone().GetEnumerator() | ForEach-Object {
                    if ([System.String]::IsNullOrEmpty($policySetting.$_))
                    {
                        $policySetting.Remove($_) | Out-Null
                    }
                }
                $storageReusableSettings += $policySetting
            }
            else
            {
                $friendlyNameIdObject      = $groupSetting.children | Where-Object { $_.settingDefinitionId -eq 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_printerdevicesidlist_friendlynameid' }
                $nameObject                = $groupSetting.children | Where-Object { $_.settingDefinitionId -eq 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_printerdevicesidlist_name' }
                $printerConnectionIdObject = $groupSetting.children | Where-Object { $_.settingDefinitionId -eq 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_printerdevicesidlist_printerconnectionid' }
                $primaryIdObject           = $groupSetting.children | Where-Object { $_.settingDefinitionId -eq 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_printerdevicesidlist_primaryid' }
                $vid_PidObject             = $groupSetting.children | Where-Object { $_.settingDefinitionId -eq 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_printerdevicesidlist_vid_pid' }

                $policySetting = @{
                    FriendlyNameId      = $friendlyNameIdObject.simpleSettingValue.value
                    Name                = $nameObject.simpleSettingValue.value
                    PrinterConnectionId = [System.Int32]::Parse($printerConnectionIdObject.choiceSettingValue.value.Split("_")[-1])
                    PrimaryId           = [System.Int32]::Parse($primaryIdObject.choiceSettingValue.value.Split("_")[-1])
                    VID_PID             = $vid_PidObject.simpleSettingValue.value
                }
                $policySetting.Keys.Clone().GetEnumerator() | ForEach-Object {
                    if ([System.String]::IsNullOrEmpty($policySetting.$_))
                    {
                        $policySetting.Remove($_) | Out-Null
                    }
                }
                $printerReusableSettings += $policySetting
            }
        }

        $results = @{
            #region resource generator code
            Description                    = $getValue.description
            DisplayName                    = $getValue.displayName
            Id                             = $getValue.id
            MatchType                      = $matchObject.choiceSettingValue.value.Split('_')[-1].Replace("matcha", "A")
            PrinterPolicySettings          = $printerReusableSettings
            StoragePolicySettings          = $storageReusableSettings
            Ensure                         = 'Present'
            Credential                     = $Credential
            ApplicationId                  = $ApplicationId
            TenantId                       = $TenantId
            ApplicationSecret              = $ApplicationSecret
            CertificateThumbprint          = $CertificateThumbprint
            ManagedIdentity                = $ManagedIdentity.IsPresent
            #endregion
        }

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
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Any', 'All')]
        [System.String]
        $MatchType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $PrinterPolicySettings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $StoragePolicySettings,
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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration of the Intune Firewall Policy Setting with Id {$Id} and Name {$DisplayName}"

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
    $boundParameters = @{
        description         = "$Description"
        displayName         = "$DisplayName"
        id                  = $currentInstance.Id
        settingDefinitionId = 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata'
        settingInstance     = @{
            '@odata.type'               = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
            settingDefinitionId         = 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata'
            groupSettingCollectionValue = @(
                @{
                    children      = @(
                        @{
                            '@odata.type'          = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                            settingDefinitionId    = 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_matchtype'
                            choiceSettingValue     = @{
                                '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingValue'
                                value         = 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_matchtype_match' + $MatchType.ToLower()
                            }
                        }
                    )
                }
            )
        }
    }

    $storageSettings = @{
        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
        settingDefinitionId = 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist'
        groupSettingCollectionValue = @()
    }
    $printerSettings = @{
        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
        settingDefinitionId = 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_printerdevicesidlist'
        groupSettingCollectionValue = @()
    }

    foreach ($policySetting in $PrinterPolicySettings)
    {
        $policySettingInitializer = @{
            children = @()
        }
        foreach ($property in $policySetting.CimInstanceProperties.GetEnumerator())
        {
            if ($property.Name -in @('FriendlyNameId', 'Name', 'VID_PID'))
            {
                $policySettingInitializer.children += @{
                    '@odata.type'          = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                    settingDefinitionId    = 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_printerdevicesidlist_' + $property.Name.ToLower()
                    simpleSettingValue     = @{
                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                        value         = $property.Value
                    }
                }
            }
            else
            {
                $policySettingInitializer.children += @{
                    '@odata.type'          = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                    settingDefinitionId    = 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_printerdevicesidlist_' + $property.Name.ToLower()
                    choiceSettingValue     = @{
                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingValue'
                        children      = @()
                        value         = 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_printerdevicesidlist_' + $property.Name.ToLower() + '_' + $property.Value
                    }
                }
            }
        }
        $printerSettings.groupSettingCollectionValue += $policySettingInitializer
    }

    foreach ($policySetting in $StoragePolicySettings)
    {
        $policySettingInitializer = @{
            children = @()
        }
        foreach ($property in $policySetting.CimInstanceProperties.GetEnumerator())
        {
            $policySettingInitializer.children += @{
                '@odata.type'          = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                settingDefinitionId    = 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_descriptoridlist_' + $property.Name.ToLower()
                simpleSettingValue     = @{
                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                    value         = $property.Value
                }
            }
        }
        $storageSettings.groupSettingCollectionValue += $policySettingInitializer
    }

    if ($storageSettings.groupSettingCollectionValue.Count -gt 0)
    {
        $boundParameters.settingInstance.groupSettingCollectionValue[0].children += $storageSettings
    }

    if ($printerSettings.groupSettingCollectionValue.Count -gt 0)
    {
        $boundParameters.settingInstance.groupSettingCollectionValue[0].children += $printerSettings
    }

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Firewall Policy Setting with Name {$DisplayName}"
        $createParameters = ([Hashtable]$boundParameters).Clone()
        $createParameters.Remove('Id') | Out-Null

        #region resource generator code
        $null = Invoke-MgGraphRequest -Uri '/beta/deviceManagement/reusablePolicySettings' -Method POST -Body $($createParameters | ConvertTo-Json -Depth 20)
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Firewall Policy Setting with Id {$($currentInstance.Id)}"
        $updateParameters = ([Hashtable]$boundParameters).Clone()
        $updateParameters.Remove('Id') | Out-Null

        #region resource generator code
        Invoke-MgGraphRequest -Uri "/beta/deviceManagement/reusablePolicySettings/$($currentInstance.Id)" -Method PUT -Body $($updateParameters | ConvertTo-Json -Depth 20)
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Firewall Policy Setting with Id {$($currentInstance.Id)}"
        #region resource generator code
        try
        {
            Invoke-MgGraphRequest -Uri "/beta/deviceManagement/reusablePolicySettings/$($currentInstance.Id)" -Method DELETE
        }
        catch
        {
            $errorMessage = "Failed to remove the Intune Device Control Policy Setting with Id {$($currentInstance.Id)} and Name {$($currentInstance.DisplayName)}."
            $errorMessage += " Please make sure it is not referenced by a Device Control policy."
            throw $errorMessage
        }
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
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Any', 'All')]
        [System.String]
        $MatchType,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $PrinterPolicySettings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $StoragePolicySettings,
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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
                                         -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
                                         -IncludedProperties @('MatchType', 'Name')
    return $result
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
        $baseFilter = "settingDefinitionId eq 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata'"
        if (-not [System.String]::IsNullOrEmpty($Filter))
        {
            $Filter = "($Filter) and ($baseFilter)"
        }
        else
        {
            $Filter = $baseFilter
        }
        [array]$getValue = (Invoke-MgGraphRequest -Uri "/beta/deviceManagement/reusablePolicySettings?`$select=$($Script:PropertiesToRetrieve -join ',')&`$filter=$Filter" `
            -Method GET `
            -SkipHttpErrorCheck `
            -ErrorAction Stop).value
        #endregion

        $i = 1
        $dscContent = ''
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
            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            elseif (-not [string]::IsNullOrEmpty($config.name))
            {
                $displayedKey = $config.name
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $matchObject = $config.settingInstance.groupSettingCollectionValue[0].children | Where-Object { $_.settingDefinitionId -eq 'device_vendor_msft_defender_configuration_devicecontrol_policygroups_{groupid}_groupdata_matchtype' }
            $matchType = $matchObject.choiceSettingValue.value.Split('_')[-1].Replace("matcha", "A")
            $params = @{
                Id                    = $config.Id
                DisplayName           = $config.DisplayName
                MatchType             = $matchType
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
            $Results = Get-TargetResource @Params

            if ($Results.PrinterPolicySettings)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.PrinterPolicySettings -CIMInstanceName ReusablePrinterDeviceControlPolicySetting -IsArray
                if ($complexTypeStringResult)
                {
                    $Results.PrinterPolicySettings = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('PrinterPolicySettings') | Out-Null
                }
            }

            if ($Results.StoragePolicySettings)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.StoragePolicySettings -CIMInstanceName ReusableStorageDeviceControlPolicySetting -IsArray
                if ($complexTypeStringResult)
                {
                    $Results.StoragePolicySettings = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('StoragePolicySettings') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('PrinterPolicySettings', 'StoragePolicySettings')
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

Export-ModuleMember -Function *-TargetResource
