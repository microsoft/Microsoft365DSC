function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CustomSettings,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure,

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
    Write-Verbose -Message "Checking for the Intune App Configuration Policy {$DisplayName}"
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

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
        $configPolicy = Get-MgDeviceAppManagementTargetedManagedAppConfiguration -Filter "displayName eq '$DisplayName'" `
            -ErrorAction Stop

        if ($null -eq $configPolicy)
        {
            Write-Verbose -Message "No App Configuration Policy with displayName {$DisplayName} was found"
            return $nullResult
        }
        Write-Verbose -Message "Found App Configuration Policy with displayName {$DisplayName}"
        return @{
            DisplayName           = $configPolicy.DisplayName
            Description           = $configPolicy.Description
            CustomSettings        = $configPolicy.customSettings
            Ensure                = 'Present'
            Credential    = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
        }
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
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
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CustomSettings,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure,

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

    Write-Verbose -Message "Intune App Configuration Policy {$DisplayName}"

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

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

    $currentconfigPolicy = Get-TargetResource @PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentconfigPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Intune App Configuration Policy {$DisplayName}"
        $creationParams = @{
            displayName = $DisplayName
            description = $Description
        }
        if ($null -ne $CustomSettings)
        {
            [System.Object[]]$customSettingsValue = ConvertTo-M365DSCIntuneAppConfigurationPolicyCustomSettings -Settings $CustomSettings
            $creationParams.Add("customSettings", $customSettingsValue)
        }
        New-MgDeviceAppManagementTargetedManagedAppConfiguration @creationParams
    }
    elseif ($Ensure -eq 'Present' -and $currentconfigPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating Intune App Configuration Policy {$DisplayName}"
        $configPolicy = Get-MgDeviceAppManagementTargetedManagedAppConfiguration -Filter "displayName eq '$DisplayName'"

        $updateParams = @{
            targetedManagedAppConfigurationId = $configPolicy.Id
            displayName                       = $DisplayName
            description                       = $Description
        }
        if ($null -ne $CustomSettings)
        {
            $customSettingsValue = ConvertTo-M365DSCIntuneAppConfigurationPolicyCustomSettings -Settings $CustomSettings
            $updateParams.Add("customSettings", $customSettingsValue)
        }
        Update-MgDeviceAppManagementTargetedManagedAppConfiguration @updateParams
    }
    elseif ($Ensure -eq 'Absent' -and $currentconfigPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Intune App Configuration Policy {$DisplayName}"
        $configPolicy = Get-MgDeviceAppManagementTargetedManagedAppConfiguration -Filter "displayName eq '$DisplayName'"
        Remove-MgDeviceAppManagementTargetedManagedAppConfiguration -TargetedManagedAppConfigurationId $configPolicy.id
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CustomSettings,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure,

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
    Write-Verbose -Message "Testing configuration of Intune App Configuration Policy {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    if ($null -ne $CurrentValues.CustomSettings -and $null -ne $CustomSettings)
    {
        $value = Test-M365DSCAppConfigurationPolicyCustomSetting -Current $CurrentValues.CustomSettings -Desired $CustomSettings
        if ($value -eq $false)
        {
            return $false
        }
    }
    else
    {
        if (($null -eq $CurrentValues.CustomSettings -and $null -ne $CustomSettings) -or
            ($null -ne $CurrentValues.CustomSettings -and $null -eq $CustomSettings))
        {
            return $false
        }
    }

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null
    $ValuesToCheck.Remove('CustomSettings') | Out-Null

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
        -InboundParameters $PSBoundParameters

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

    try
    {
        [array]$configPolicies = Get-MgDeviceAppManagementTargetedManagedAppConfiguration -ErrorAction Stop
        $i = 1
        $dscContent = ''
        if ($configPolicies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewLine
        }
        foreach ($configPolicy in $configPolicies)
        {
            Write-Host "    |---[$i/$($configPolicies.Count)] $($configPolicy.displayName)" -NoNewLine
            $params = @{
                DisplayName           = $configPolicy.displayName
                Ensure                = 'Present'
                Credential    = $Credential
                ApplicationID         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
            }
            $Results = Get-TargetResource @params
            if ($Results.CustomSettings.Count -gt 0)
            {
                $Results.CustomSettings = Get-M365DSCIntuneAppConfigurationPolicyCustomSettingsAsString -Settings $Results.CustomSettings
            }
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            if ($null -ne $Results.CustomSettings)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "CustomSettings"
            }
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        return $dscContent
    }
    catch
    {
        if ($_.Exception -like '*401*')
        {
            Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }
        else
        {
            Write-Host $Global:M365DSCEmojiRedX
        }

        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
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

function Test-M365DSCAppConfigurationPolicyCustomSetting
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [parameter(Mandatory = $true)]
        [System.Object[]]
        $Current,

        [parameter(Mandatory = $true)]
        [System.Object[]]
        $Desired
    )
    if ($Current.Length -ne $Desired.Length)
    {
        return $false
    }

    foreach ($desiredSetting in $Desired)
    {
        $found = $false
        foreach ($currentSetting in $Current)
        {
            if ($currentSetting.Name -eq $desiredSetting.Name)
            {
                if ($currentSetting.Value -ne $desiredSetting.Value)
                {
                    return $false
                }
                $found = $true
            }
        }
        if (-not $found)
        {
            return $false
        }
    }
    return $true
}

function Get-M365DSCIntuneAppConfigurationPolicyCustomSettingsAsString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.ArrayList]
        $Settings
    )

    $StringContent = "@("
    foreach ($setting in $Settings)
    {
        $StringContent += "MSFT_IntuneAppConfigurationPolicyCustomSetting { `r`n"
        $StringContent += "                name  = '" + $setting.name + "'`r`n"
        $StringContent += "                value = '" + $setting.value + "'`r`n"
        $StringContent += "            }`r`n"
    }
    $StringContent += "            )"
    return $StringContent
}

function ConvertTo-M365DSCIntuneAppConfigurationPolicyCustomSettings
{
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.ArrayList]
        $Settings
    )

    $result = @()
    foreach ($setting in $Settings)
    {
        $currentSetting = @{
            name  = $setting.name
            value = $setting.value
        }
        $result += $currentSetting
    }
    return $result
}

Export-ModuleMember -Function *-TargetResource
