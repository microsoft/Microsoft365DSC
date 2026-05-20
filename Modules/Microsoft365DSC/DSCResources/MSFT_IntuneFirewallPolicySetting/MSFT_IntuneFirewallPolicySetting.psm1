
Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneFirewallPolicySetting'
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

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $PolicySettings,
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
                    $getValue = (Invoke-MgGraphRequest -Uri "/beta/deviceManagement/reusablePolicySettings?`$filter=DisplayName eq '$($DisplayName -replace "'", "''")' and settingDefinitionId eq 'vendor_msft_firewall_mdmstore_dynamickeywords_addresses_{id}'&select=$($Script:PropertiesToRetrieve -join ',')" `
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

        $reusableSettings = @()
        foreach ($groupSetting in $getValue.settingInstance.groupSettingCollectionValue)
        {
            $autoResolveObject = $groupSetting.children | Where-Object { $_.settingDefinitionId -eq 'vendor_msft_firewall_mdmstore_dynamickeywords_addresses_{id}_autoresolve' }
            $autoResolveValue = [System.Boolean]::Parse($autoResolveObject.choiceSettingValue.value.Split('_')[-1])
            $keywordObject = $groupSetting.children | Where-Object { $_.settingDefinitionId -eq 'vendor_msft_firewall_mdmstore_dynamickeywords_addresses_{id}_keyword' }
            $policySetting = @{
                AutoResolve = $autoResolveValue
                Keyword     = $keywordObject.simpleSettingValue.value
            }

            if (-not $autoResolveValue)
            {
                $addressObject = $autoResolveObject.choiceSettingValue.children.simpleSettingCollectionValue.value
                $policySetting.Add('Addresses', $addressObject)
            }
            $reusableSettings += $policySetting
        }

        $results = @{
            #region resource generator code
            Description           = $getValue.description
            DisplayName           = $getValue.displayName
            Id                    = $getValue.id
            PolicySettings        = $reusableSettings
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
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

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $PolicySettings,
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
        '@odata.type'       = '#microsoft.graph.deviceManagementReusablePolicySetting'
        description         = "$Description"
        displayName         = "$DisplayName"
        id                  = $currentInstance.Id
        settingDefinitionId = 'vendor_msft_firewall_mdmstore_dynamickeywords_addresses_{id}'
        settingInstance     = @{
            '@odata.type'               = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
            settingDefinitionId         = 'vendor_msft_firewall_mdmstore_dynamickeywords_addresses_{id}'
            groupSettingCollectionValue = @()
        }
    }

    foreach ($policySetting in $PolicySettings)
    {
        $groupSettingCollectionChildren = @()

        $autoResolveChildren = @()
        if (-not $policySetting.AutoResolve)
        {
            $autoResolveChild += @{
                '@odata.type'                = '#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance'
                settingDefinitionId          = 'vendor_msft_firewall_mdmstore_dynamickeywords_addresses_{id}_addresses'
                simpleSettingCollectionValue = @()
            }
            foreach ($address in $policySetting.Addresses)
            {
                $autoResolveChild.simpleSettingCollectionValue += @{
                    '@odata.type' = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                    value         = $address
                }
            }
            $autoResolveChildren += $autoResolveChild
        }

        $autoResolveValue = 'vendor_msft_firewall_mdmstore_dynamickeywords_addresses_{id}_autoresolve_' + $policySetting.AutoResolve.ToString().ToLower()
        $autoResolveObject = @{
            '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            settingDefinitionId = 'vendor_msft_firewall_mdmstore_dynamickeywords_addresses_{id}_autoresolve'
            choiceSettingValue  = @{
                '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingValue'
                value         = $autoResolveValue
                children      = $autoResolveChildren
            }
        }
        $groupSettingCollectionChildren += $autoResolveObject

        $keywordObject = @{
            '@odata.type'       = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
            settingDefinitionId = 'vendor_msft_firewall_mdmstore_dynamickeywords_addresses_{id}_keyword'
            simpleSettingValue  = @{
                '@odata.type' = '#microsoft.graph.deviceManagementConfigurationStringSettingValue'
                value         = $policySetting.Keyword
            }
        }
        $groupSettingCollectionChildren += $keywordObject

        $boundParameters.settingInstance.groupSettingCollectionValue += @{
            children = $groupSettingCollectionChildren
        }
    }

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Firewall Policy Setting with Name {$DisplayName}"

        $createParameters = ([Hashtable]$boundParameters).Clone()
        $createParameters.Remove('Id') | Out-Null

        #region resource generator code
        $null = Invoke-MgGraphRequest -Uri '/beta/deviceManagement/reusablePolicySettings' -Method POST -Body $($createParameters | ConvertTo-Json -Depth 10)
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Firewall Policy Setting with Id {$($currentInstance.Id)}"

        $updateParameters = ([Hashtable]$boundParameters).Clone()
        $updateParameters.Id = $currentInstance.Id

        #region resource generator code
        Invoke-MgGraphRequest -Uri "/beta/deviceManagement/reusablePolicySettings/$($currentInstance.Id)" -Method PUT -Body $($updateParameters | ConvertTo-Json -Depth 10)
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
            $errorMessage = "Failed to remove the Intune Firewall Policy Setting with Id {$($currentInstance.Id)} and Name {$($currentInstance.DisplayName)}."
            $errorMessage += ' Please make sure it is not referenced by a Firewall policy.'
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

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $PolicySettings,
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

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $compareParameters = Get-CompareParameters
    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
        @compareParameters
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
        $baseFilter = "settingDefinitionId eq 'vendor_msft_firewall_mdmstore_dynamickeywords_addresses_{id}'"
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
            $Results = Get-TargetResource @Params

            if ($Results.PolicySettings)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.PolicySettings -CIMInstanceName ReusableFirewallPolicySetting
                if ($complexTypeStringResult)
                {
                    $Results.PolicySettings = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('PolicySettings') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('PolicySettings')
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
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

function Get-CompareParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    return @{
        IncludedProperties = @('PolicySettings', 'Addresses', 'AutoResolve', 'Keyword')
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
