Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneSettingCatalogCustomPolicyWindows10'

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
        $Name,

        [Parameter()]
        [ValidateSet('none', 'android', 'iOS', 'macOS', 'windows10X', 'windows10', 'linux', 'unknownFutureValue')]
        [System.String]
        $Platforms,

        [Parameter()]
        [ValidateSet('none', 'mdm', 'windows10XManagement', 'configManager', 'appleRemoteManagement', 'microsoftSense', 'exchangeOnline', 'linuxMdm', 'enrollment', 'endpointPrivilegeManagement', 'unknownFutureValue')]
        [System.String]
        $Technologies,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $TemplateReference,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Settings,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $Id,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of the Intune Setting Catalog Custom Policy for Windows10 with Id {$Id} and Name {$Name}"

    try
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

        #region resource generator code
        if (-not [string]::IsNullOrEmpty($Id))
        {
            $getValue = Get-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $Id -ExpandProperty 'settings' -ErrorAction SilentlyContinue
        }

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Setting Catalog Custom Policy for Windows10 with Id {$Id}"

            if (-not [string]::IsNullOrEmpty($Name))
            {
                [array]$getValue = Get-MgBetaDeviceManagementConfigurationPolicy `
                    -Filter "Name eq '$($Name -replace "'", "''")' and Platforms eq 'windows10' and Technologies eq 'mdm' and TemplateReference/TemplateFamily eq 'none'" `
                    -All `
                    -ErrorAction SilentlyContinue

                if ($getValue.Count -gt 1)
                {
                    throw "Error: The displayName {$Name} is not unique in the tenant`r`nEnsure the display Name is unique for this type of resource."
                }

                if (-not [string]::IsNullOrEmpty($getValue.Id))
                {
                    $getValue = Get-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $getValue.Id -ExpandProperty 'settings' -ErrorAction SilentlyContinue
                }
            }
        }
        #endregion
        if ([string]::IsNullOrEmpty($getValue.Id))
        {
            Write-Verbose -Message "Could not find an Intune Setting Catalog Custom Policy for Windows10 with Name {$Name}"
            return $nullResult
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Setting Catalog Custom Policy for Windows10 with Id {$Id} and Name {$Name} was found."

        $complexSettings = @()
        foreach ($currentSettings in $getValue.settings)
        {
            $complexSettingInstance = [hashtable]@{}
            if (-not([string]::IsNullOrEmpty($currentSettings.SettingInstance.'@odata.type')) )
            {
                $complexSettingInstance['odataType'] = $currentSettings.SettingInstance.'@odata.type'
            }
            if (-not([string]::IsNullOrEmpty($currentSettings.SettingInstance.settingDefinitionId)) )
            {
                $complexSettingInstance['SettingDefinitionId'] = $currentSettings.settingInstance.settingDefinitionId
            }
            if (-not([string]::IsNullOrEmpty($currentSettings.settingInstance.SettingInstanceTemplateReference.SettingInstanceTemplateId)) )
            {
                $complexSettingInstance['SettingInstanceTemplateReference'] = New-CimInstance -ClassName MSFT_MicrosoftGraphDeviceManagementConfigurationSettingInstanceTemplateReference -Namespace root/Microsoft/Windows/DesiredStateConfiguration -Property @{
                    'SettingInstanceTemplateId' = "$($currentSettings.settingInstance.SettingInstanceTemplateReference.SettingInstanceTemplateId)"
                } -ClientOnly
            }
            $valueName = $currentSettings.settingInstance.keys | Where-Object { @('ChoiceSettingCollectionValue', 'ChoiceSettingValue', 'GroupSettingCollectionValue', 'GroupSettingValue', 'SimpleSettingCollectionValue', 'SimpleSettingValue') -contains $_ }
            $rawValue = $currentSettings.settingInstance.$valueName
            $complexValue = Get-SettingValue -SettingValue $rawValue -SettingValueType $currentSettings.settingInstance.'@odata.type'
            if (('ChoiceSettingCollectionValue', 'GroupSettingCollectionValue', 'SimpleSettingCollectionValue') -contains $valueName )
            {
                $complexSettingInstance[$valueName] = [CimInstance[]]$complexValue
            }
            else
            {
                $complexSettingInstance[$valueName] = $complexValue
            }
            $complexSettings += New-CimInstance -ClassName MSFT_MicrosoftGraphDeviceManagementConfigurationSetting -Namespace root/Microsoft/Windows/DesiredStateConfiguration -Property @{
                'SettingInstance' = New-CimInstance -ClassName MSFT_MicrosoftGraphDeviceManagementConfigurationSettingInstance -Namespace root/Microsoft/Windows/DesiredStateConfiguration -Property $complexSettingInstance -ClientOnly
            } -ClientOnly
        }

        #region resource generator code
        $enumPlatforms = $null
        if ($null -ne $getValue.Platforms)
        {
            $enumPlatforms = $getValue.Platforms.ToString()
        }

        $enumTechnologies = $null
        if ($null -ne $getValue.Technologies)
        {
            $enumTechnologies = $getValue.Technologies.ToString()
        }
        #endregion

        $results = @{
            #region resource generator code
            Description           = $getValue.Description
            Name                  = $getValue.Name
            Platforms             = $enumPlatforms
            RoleScopeTagIds       = $getValue.RoleScopeTagIds
            Technologies          = $enumTechnologies
            Settings              = $complexSettings
            Id                    = $getValue.Id
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            CertificatePath       = $CertificatePath
            CertificatePassword   = $CertificatePassword
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
            #endregion
        }
        $assignmentsValues = Get-MgBetaDeviceManagementConfigurationPolicyAssignment -DeviceManagementConfigurationPolicyId $Id
        $assignmentResult = @()
        if ($assignmentsValues.Count -gt 0)
        {
            $assignmentResult += ConvertFrom-IntunePolicyAssignment `
                -IncludeDeviceFilter:$true `
                -Assignments ($assignmentsValues)
        }
        $results.Add('Assignments', $assignmentResult)

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
        $Name,

        [Parameter()]
        [ValidateSet('none', 'android', 'iOS', 'macOS', 'windows10X', 'windows10', 'linux', 'unknownFutureValue')]
        [System.String]
        $Platforms,

        [Parameter()]
        [ValidateSet('none', 'mdm', 'windows10XManagement', 'configManager', 'appleRemoteManagement', 'microsoftSense', 'exchangeOnline', 'linuxMdm', 'enrollment', 'endpointPrivilegeManagement', 'unknownFutureValue')]
        [System.String]
        $Technologies,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $TemplateReference,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Settings,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $Id,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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
    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $keyToRename = @{
        'odataType'   = '@odata.type'
        'StringValue' = 'value'
        'IntValue'    = 'value'
    }

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Setting Catalog Custom Policy for Windows10 with Name {$Name}"
        $BoundParameters.Remove('Assignments') | Out-Null

        $CreateParameters = ([Hashtable]$BoundParameters).Clone()
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters -KeyMapping $keyToRename
        $CreateParameters.Remove('Id') | Out-Null

        #region resource generator code
        $CreateParameters.Add('@odata.type', '#microsoft.graph.DeviceManagementConfigurationPolicy')
        $policy = New-MgBetaDeviceManagementConfigurationPolicy -BodyParameter $CreateParameters
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments

        if ($policy.Id)
        {
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $policy.Id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/configurationPolicies'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Setting Catalog Custom Policy for Windows10 with Id {$($currentInstance.Id)}"
        $BoundParameters.Remove('Assignments') | Out-Null

        $UpdateParameters = ([Hashtable]$BoundParameters).Clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters -KeyMapping $keyToRename
        $UpdateParameters.Remove('Id') | Out-Null

        #region resource generator code
        Update-IntuneDeviceConfigurationPolicy `
            -DeviceConfigurationPolicyId $currentInstance.Id `
            @UpdateParameters

        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentInstance.Id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/configurationPolicies'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Setting Catalog Custom Policy for Windows10 with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $currentInstance.Id
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
        $Name,

        [Parameter()]
        [ValidateSet('none', 'android', 'iOS', 'macOS', 'windows10X', 'windows10', 'linux', 'unknownFutureValue')]
        [System.String]
        $Platforms,

        [Parameter()]
        [ValidateSet('none', 'mdm', 'windows10XManagement', 'configManager', 'appleRemoteManagement', 'microsoftSense', 'exchangeOnline', 'linuxMdm', 'enrollment', 'endpointPrivilegeManagement', 'unknownFutureValue')]
        [System.String]
        $Technologies,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $TemplateReference,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Settings,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $Id,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '')
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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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
        $baseFilter = "platforms eq 'windows10' and technologies eq 'mdm' and templateReference/templateFamily eq 'none'"
        if (-not [System.String]::IsNullOrEmpty($Filter))
        {
            $Filter = "($Filter) and ($baseFilter)"
        }
        else
        {
            $Filter = $baseFilter
        }
        [array]$getValue = Get-MgBetaDeviceManagementConfigurationPolicy `
            -Filter $Filter `
            -All `
            -ErrorAction Stop
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
            if (-not [String]::IsNullOrEmpty($config.Name))
            {
                $displayedKey = $config.Name
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                Id                    = $config.Id
                Name                  = $config.Name
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Results = Get-TargetResource @Params

            if ($null -ne $Results.Settings)
            {
                $complexMapping = @(
                    @{
                        Name            = 'SettingInstance'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementConfigurationSettingInstance'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'SettingInstanceTemplateReference'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementConfigurationSettingInstanceTemplateReference'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'ChoiceSettingCollectionValue'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementConfigurationChoiceSettingValue'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'Children'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementConfigurationSettingInstance'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'SettingValueTemplateReference'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementConfigurationSettingValueTemplateReference'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'ChoiceSettingValue'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementConfigurationChoiceSettingValue'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'GroupSettingCollectionValue'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementConfigurationGroupSettingValue'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'GroupSettingValue'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementConfigurationGroupSettingValue'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'SimpleSettingCollectionValue'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementConfigurationSimpleSettingValue'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'SimpleSettingValue'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementConfigurationSimpleSettingValue'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.Settings `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementConfigurationSetting' `
                    -ComplexTypeMapping $complexMapping `
                    -IsArray:$true

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.Settings = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Settings') | Out-Null
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
                -NoEscape @('Settings', 'Assignments')

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

function Get-SettingValue
{
    [CmdletBinding()]
    [OutputType([CimInstance[]], [System.Collections.Hashtable], [System.Collections.Hashtable[]])]
    param (
        [Parameter()]
        $SettingValue,
        [Parameter()]
        $SettingValueType

    )

    switch -Wildcard ($SettingValueType)
    {
        '*ChoiceSettingInstance'
        {
            $hash = [hashtable]@{}
            if ($SettingValue.Keys -contains '@odata.type' -and -not([string]::IsNullOrEmpty($SettingValue.'@odata.type')) )
            {
                $hash['odataType'] = $SettingValue.'@odata.type'
            }
            if ($SettingValue.Keys -contains 'value' -and -not([string]::IsNullOrEmpty($SettingValue.value)) )
            {
                $hash['Value'] = $SettingValue.value
            }
            if ($SettingValue.Keys -contains 'SettingValueTemplateReference')
            {
                if (-not [string]::IsNullOrEmpty($SettingValue.SettingValueTemplateReference.SettingInstanceTemplateId) )
                {
                    $hash['SettingValueTemplateReference'] = New-CimInstance -ClassName MSFT_MicrosoftGraphDeviceManagementConfigurationSettingValueTemplateReference -Namespace root/Microsoft/Windows/DesiredStateConfiguration -Property @{
                        'SettingInstanceTemplateId' = $SettingValue.SettingValueTemplateReference.SettingInstanceTemplateId
                    } -ClientOnly
                }
            }
            if (-not [String]::IsNullOrEmpty($SettingValue.children) )
            {
                $children = @()
                foreach ($child in $SettingValue.children)
                {
                    $childHash = [hashtable]@{}
                    if (-not([string]::IsNullOrEmpty($child.'@odata.type')) )
                    {
                        $childHash['odataType'] = $child.'@odata.type'
                    }
                    if (-not([string]::IsNullOrEmpty($child.settingDefinitionId)) )
                    {
                        $childHash['SettingDefinitionId'] = $child.settingDefinitionId
                    }
                    if (-not [string]::IsNullOrEmpty($child.SettingValueTemplateReference.SettingInstanceTemplateId) )
                    {
                        $childHash['SettingValueTemplateReference'] = New-CimInstance -ClassName MSFT_MicrosoftGraphDeviceManagementConfigurationSettingInstanceTemplateReference -Namespace root/Microsoft/Windows/DesiredStateConfiguration -Property $child.SettingValueTemplateReference -ClientOnly
                    }
                    $valueName = $child.keys | Where-Object { @('ChoiceSettingCollectionValue', 'ChoiceSettingValue', 'GroupSettingCollectionValue', 'GroupSettingValue', 'SimpleSettingCollectionValue', 'SimpleSettingValue') -contains $_ }
                    $rawValue = $child.$valueName
                    $childSettingValue = Get-SettingValue -SettingValue $rawValue -SettingValueType $child.'@odata.type'
                    if (('ChoiceSettingCollectionValue', 'GroupSettingCollectionValue', 'SimpleSettingCollectionValue') -contains $valueName )
                    {
                        $childHash.Add($valueName, [CimInstance[]]$childSettingValue )
                    }
                    else
                    {
                        $childHash.Add($valueName, $childSettingValue )
                    }
                    $complexChild = New-CimInstance -ClassName MSFT_MicrosoftGraphDeviceManagementConfigurationSettingInstance -Namespace root/Microsoft/Windows/DesiredStateConfiguration -Property $childHash -ClientOnly
                    $children += $complexChild
                }
                $hash['Children'] = [CimInstance[]]($Children)
            }
            return (New-CimInstance -ClassName MSFT_MicrosoftGraphDeviceManagementConfigurationChoiceSettingValue -Namespace root/Microsoft/Windows/DesiredStateConfiguration -Property $hash -ClientOnly)
        }
        '*ChoiceSettingCollectionInstance'
        {
            $complexCollection = @()
            foreach ($item in $SettingValue)
            {
                $complexCollection += Get-SettingValue -SettingValue $item -SettingValueType '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
            }
            return [CimInstance[]]($complexCollection)
        }
        '*SimpleSettingInstance'
        {
            $hash = [hashtable]@{}
            if ($SettingValue.Keys -contains '@odata.type' -and -not([string]::IsNullOrEmpty($SettingValue.'@odata.type')) )
            {
                $hash['odataType'] = $SettingValue.'@odata.type'
            }
            if ($SettingValue.Keys -contains 'value' -and -not([string]::IsNullOrEmpty($SettingValue.value)) )
            {
                try
                {
                    $hash['IntValue'] = [UInt32]($SettingValue.value)
                }
                catch
                {
                    $hash['StringValue'] = [string]($SettingValue.value)
                }
            }
            if ($SettingValue.Keys -contains 'ValueState' -and -not([string]::IsNullOrEmpty($SettingValue.ValueState)) )
            {
                $hash['ValueState'] = $SettingValue.ValueState
            }
            if ($SettingValue.Keys -contains 'SettingValueTemplateReference')
            {
                if (-not [string]::IsNullOrEmpty($SettingValue.SettingValueTemplateReference.SettingInstanceTemplateId) )
                {
                    $hash['SettingValueTemplateReference'] = New-CimInstance -ClassName MSFT_MicrosoftGraphDeviceManagementConfigurationSettingValueTemplateReference -Namespace root/Microsoft/Windows/DesiredStateConfiguration -Property @{
                        'SettingInstanceTemplateId' = $SettingValue.SettingValueTemplateReference.SettingInstanceTemplateId
                    } -ClientOnly
                }
            }
            if (-not [String]::IsNullOrEmpty($SettingValue.children) )
            {
                $children = @()
                foreach ($child in $SettingValue.children)
                {
                    $childHash = [hashtable]@{}
                    if (-not([string]::IsNullOrEmpty($child.'@odata.type')) )
                    {
                        $childHash['odataType'] = $child.'@odata.type'
                    }
                    if (-not([string]::IsNullOrEmpty($child.settingDefinitionId)) )
                    {
                        $childHash['SettingDefinitionId'] = $child.settingDefinitionId
                    }
                    if (-not [string]::IsNullOrEmpty($child.SettingValueTemplateReference.SettingInstanceTemplateId) )
                    {
                        $childHash['SettingValueTemplateReference'] = New-CimInstance -ClassName MSFT_MicrosoftGraphDeviceManagementConfigurationSettingInstanceTemplateReference -Namespace root/Microsoft/Windows/DesiredStateConfiguration -Property $child.SettingValueTemplateReference -ClientOnly
                    }
                    $valueName = $child.keys | Where-Object { @('ChoiceSettingCollectionValue', 'ChoiceSettingValue', 'GroupSettingCollectionValue', 'GroupSettingValue', 'SimpleSettingCollectionValue', 'SimpleSettingValue') -contains $_ }
                    $rawValue = $child.$valueName
                    $childSettingValue = Get-SettingValue -SettingValue $rawValue -SettingValueType $child.'@odata.type'
                    if (('ChoiceSettingCollectionValue', 'GroupSettingCollectionValue', 'SimpleSettingCollectionValue') -contains $valueName )
                    {
                        $childHash.Add($valueName, [CimInstance[]]$childSettingValue )
                    }
                    else
                    {
                        $childHash.Add($valueName, $childSettingValue )
                    }
                    $complexChild = New-CimInstance -ClassName MSFT_MicrosoftGraphDeviceManagementConfigurationSettingInstance -Namespace root/Microsoft/Windows/DesiredStateConfiguration -Property $childHash -ClientOnly
                    $children += $complexChild
                }
                $hash['Children'] = [CimInstance[]]($Children)
            }
            return (New-CimInstance -ClassName MSFT_MicrosoftGraphDeviceManagementConfigurationSimpleSettingValue -Namespace root/Microsoft/Windows/DesiredStateConfiguration -Property $hash -ClientOnly)

        }
        '*SimpleSettingCollectionInstance'
        {
            $complexCollection = @()
            foreach ($item in $SettingValue)
            {
                $complexCollection += Get-SettingValue -SettingValue $item -SettingValueType '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
            }
            return [CimInstance[]]($complexCollection)
        }
        '*GroupSettingInstance'
        {
            $hash = [hashtable]@{}
            if ($SettingValue.Keys -contains '@odata.type' -and -not([string]::IsNullOrEmpty($SettingValue.'@odata.type')) )
            {
                $hash['odataType'] = $SettingValue.'@odata.type'
            }
            if ($SettingValue.Keys -contains 'value' -and -not([string]::IsNullOrEmpty($SettingValue.value)) )
            {
                $hash['Value'] = $SettingValue.value
            }
            if ($SettingValue.Keys -contains 'SettingValueTemplateReference')
            {
                if (-not [string]::IsNullOrEmpty($SettingValue.SettingValueTemplateReference.SettingInstanceTemplateId) )
                {
                    $hash['SettingValueTemplateReference'] = New-CimInstance -ClassName MSFT_MicrosoftGraphDeviceManagementConfigurationSettingValueTemplateReference -Namespace root/Microsoft/Windows/DesiredStateConfiguration -Property @{
                        'SettingInstanceTemplateId' = $SettingValue.SettingValueTemplateReference.SettingInstanceTemplateId
                    } -ClientOnly
                }
            }
            if (-not [String]::IsNullOrEmpty($SettingValue.children) )
            {
                $children = @()
                foreach ($child in $SettingValue.children)
                {
                    $childHash = [hashtable]@{}
                    if (-not([string]::IsNullOrEmpty($child.'@odata.type')) )
                    {
                        $childHash['odataType'] = $child.'@odata.type'
                    }
                    if (-not([string]::IsNullOrEmpty($child.settingDefinitionId)) )
                    {
                        $childHash['SettingDefinitionId'] = $child.settingDefinitionId
                    }
                    if (-not [string]::IsNullOrEmpty($child.SettingValueTemplateReference.SettingInstanceTemplateId) )
                    {
                        $childHash['SettingValueTemplateReference'] = New-CimInstance -ClassName MSFT_MicrosoftGraphDeviceManagementConfigurationSettingInstanceTemplateReference -Namespace root/Microsoft/Windows/DesiredStateConfiguration -Property $child.SettingValueTemplateReference -ClientOnly
                    }
                    $valueName = $child.keys | Where-Object { @('ChoiceSettingCollectionValue', 'ChoiceSettingValue', 'GroupSettingCollectionValue', 'GroupSettingValue', 'SimpleSettingCollectionValue', 'SimpleSettingValue') -contains $_ }
                    $rawValue = $child.$valueName
                    $childSettingValue = Get-SettingValue -SettingValue $rawValue -SettingValueType $child.'@odata.type'
                    if (('ChoiceSettingCollectionValue', 'GroupSettingCollectionValue', 'SimpleSettingCollectionValue') -contains $valueName )
                    {
                        $childHash.Add($valueName, [CimInstance[]]$childSettingValue )
                    }
                    else
                    {
                        $childHash.Add($valueName, $childSettingValue )
                    }
                    $complexChild = New-CimInstance -ClassName MSFT_MicrosoftGraphDeviceManagementConfigurationSettingInstance -Namespace root/Microsoft/Windows/DesiredStateConfiguration -Property $childHash -ClientOnly
                    $children += $complexChild
                }
                $hash['Children'] = [CimInstance[]]($Children)
            }
            return (New-CimInstance -ClassName MSFT_MicrosoftGraphDeviceManagementConfigurationGroupSettingValue -Namespace root/Microsoft/Windows/DesiredStateConfiguration -Property $hash -ClientOnly)

        }
        '*GroupSettingCollectionInstance'
        {
            $complexCollection = @()
            foreach ($item in $SettingValue)
            {
                $complexCollection += Get-SettingValue -SettingValue $item -SettingValueType '#microsoft.graph.deviceManagementConfigurationGroupSettingInstance'
            }
            return [CimInstance[]]($complexCollection)
        }
    }
}

Export-ModuleMember -Function *-TargetResource
