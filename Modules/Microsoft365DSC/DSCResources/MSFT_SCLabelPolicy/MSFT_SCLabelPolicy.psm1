function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AdvancedSettings,

        [Parameter()]
        [System.String[]]
        $Labels,

        [Parameter()]
        [System.String[]]
        $ExchangeLocation,

        [Parameter()]
        [System.String[]]
        $ExchangeLocationException,

        [Parameter()]
        [System.String[]]
        $ModernGroupLocation,

        [Parameter()]
        [System.String[]]
        $ModernGroupLocationException,

        [Parameter()]
        [System.String[]]
        $AddLabels,

        [Parameter()]
        [System.String[]]
        $AddExchangeLocation,

        [Parameter()]
        [System.String[]]
        $AddExchangeLocationException,

        [Parameter()]
        [System.String[]]
        $AddModernGroupLocation,

        [Parameter()]
        [System.String[]]
        $AddModernGroupLocationException,

        [Parameter()]
        [System.String[]]
        $RemoveLabels,

        [Parameter()]
        [System.String[]]
        $RemoveExchangeLocation,

        [Parameter()]
        [System.String[]]
        $RemoveExchangeLocationException,

        [Parameter()]
        [System.String[]]
        $RemoveModernGroupLocation,

        [Parameter()]
        [System.String[]]
        $RemoveModernGroupLocationException,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of Sensitivity Label Policy for $Name"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'SecurityComplianceCenter' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'SecurityComplianceCenter' `
            -InboundParameters $PSBoundParameters
    }

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'
    try
    {
        try
        {
            $policy = Get-LabelPolicy -Identity $Name -ErrorAction SilentlyContinue
        }
        catch
        {
            throw $_
        }

        if ($null -eq $policy)
        {
            Write-Verbose -Message "Sensitivity label policy $($Name) does not exist."
            return $nullReturn
        }
        else
        {
            if ($null -ne $policy.Settings)
            {
                $advancedSettingsValue = Convert-StringToAdvancedSettings -AdvancedSettings $policy.Settings
            }

            Write-Verbose "Found existing Sensitivity Label policy $($Name)"
            $result = @{
                Name                         = $policy.Name
                Comment                      = $policy.Comment
                AdvancedSettings             = $advancedSettingsValue
                GlobalAdminAccount           = $GlobalAdminAccount
                Ensure                       = 'Present'
                Labels                       = $policy.Labels
                ExchangeLocation             = Convert-ArrayList -CurrentProperty $policy.ExchangeLocation
                ExchangeLocationException    = Convert-ArrayList -CurrentProperty $policy.ExchangeLocationException
                ModernGroupLocation          = Convert-ArrayList -CurrentProperty $policy.ModernGroupLocation
                ModernGroupLocationException = Convert-ArrayList -CurrentProperty $policy.ModernGroupLocationException
            }

            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
        }
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return $nullReturn
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AdvancedSettings,

        [Parameter()]
        [System.String[]]
        $Labels,

        [Parameter()]
        [System.String[]]
        $ExchangeLocation,

        [Parameter()]
        [System.String[]]
        $ExchangeLocationException,

        [Parameter()]
        [System.String[]]
        $ModernGroupLocation,

        [Parameter()]
        [System.String[]]
        $ModernGroupLocationException,

        [Parameter()]
        [System.String[]]
        $AddLabels,

        [Parameter()]
        [System.String[]]
        $AddExchangeLocation,

        [Parameter()]
        [System.String[]]
        $AddExchangeLocationException,

        [Parameter()]
        [System.String[]]
        $AddModernGroupLocation,

        [Parameter()]
        [System.String[]]
        $AddModernGroupLocationException,

        [Parameter()]
        [System.String[]]
        $RemoveLabels,

        [Parameter()]
        [System.String[]]
        $RemoveExchangeLocation,

        [Parameter()]
        [System.String[]]
        $RemoveExchangeLocationException,

        [Parameter()]
        [System.String[]]
        $RemoveModernGroupLocation,

        [Parameter()]
        [System.String[]]
        $RemoveModernGroupLocationException,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of Sensitivity label policy for $Name"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters

    $CurrentPolicy = Get-TargetResource @PSBoundParameters

    if (('Present' -eq $Ensure) -and ('Absent' -eq $CurrentPolicy.Ensure))
    {
        $CreationParams = $PSBoundParameters

        if ($PSBoundParameters.ContainsKey("AdvancedSettings"))
        {
            $advanced = Convert-CIMToAdvancedSettings $AdvancedSettings
            $CreationParams["AdvancedSettings"] = $advanced
        }
        #Remove parameters not used in New-LabelPolicy
        $CreationParams.Remove("GlobalAdminAccount") | Out-Null
        $CreationParams.Remove("Ensure") | Out-Null
        $CreationParams.Remove("AddLabels") | Out-Null
        $CreationParams.Remove("AddExchangeLocation") | Out-Null
        $CreationParams.Remove("AddExchangeLocationException") | Out-Null
        $CreationParams.Remove("AddModernGroupLocation") | Out-Null
        $CreationParams.Remove("AddModernGroupLocationException") | Out-Null
        $CreationParams.Remove("RemoveLabels") | Out-Null
        $CreationParams.Remove("RemoveExchangeLocation") | Out-Null
        $CreationParams.Remove("RemoveExchangeLocationException") | Out-Null
        $CreationParams.Remove("RemoveModernGroupLocation") | Out-Null
        $CreationParams.Remove("RemoveModernGroupLocationException") | Out-Null
        Write-Verbose "Creating new Sensitivity label policy $Name."

        try
        {
            New-LabelPolicy @CreationParams
        }
        catch
        {
            Write-Warning "New-LabelPolicy is not available in tenant $($GlobalAdminAccount.UserName.Split('@')[0])"
        }
        try
        {
            Start-Sleep 5
            $SetParams = $PSBoundParameters

            if ($PSBoundParameters.ContainsKey("AdvancedSettings"))
            {
                $advanced = Convert-CIMToAdvancedSettings  $AdvancedSettings
                $SetParams["AdvancedSettings"] = $advanced
            }
            #Remove unused parameters for Set-Label cmdlet
            $SetParams.Remove("GlobalAdminAccount") | Out-Null
            $SetParams.Remove("Ensure") | Out-Null
            $SetParams.Remove("Name") | Out-Null
            $SetParams.Remove("ExchangeLocationException") | Out-Null
            $SetParams.Remove("Labels") | Out-Null
            $SetParams.Remove("ExchangeLocation") | Out-Null
            $SetParams.Remove("ModernGroupLocation") | Out-Null
            $SetParams.Remove("ModernGroupLocationException") | Out-Null

            Set-LabelPolicy @SetParams -Identity $Name
        }
        catch
        {
            Write-Warning "Set-LabelPolicy is not available in tenant $($GlobalAdminAccount.UserName.Split('@')[0])"
        }
    }
    elseif (('Present' -eq $Ensure) -and ('Present' -eq $CurrentPolicy.Ensure))
    {
        $SetParams = $PSBoundParameters

        if ($PSBoundParameters.ContainsKey("AdvancedSettings"))
        {
            $advanced = Convert-CIMToAdvancedSettings  $AdvancedSettings
            $SetParams["AdvancedSettings"] = $advanced
        }
        #Remove unused parameters for Set-Label cmdlet
        $SetParams.Remove("GlobalAdminAccount") | Out-Null
        $SetParams.Remove("Ensure") | Out-Null
        $SetParams.Remove("Name") | Out-Null
        $SetParams.Remove("ExchangeLocationException") | Out-Null
        $SetParams.Remove("Labels") | Out-Null
        $SetParams.Remove("ExchangeLocation") | Out-Null
        $SetParams.Remove("ModernGroupLocation") | Out-Null
        $SetParams.Remove("ModernGroupLocationException") | Out-Null

        try
        {
            Set-LabelPolicy @SetParams -Identity $Name
        }
        catch
        {
            Write-Warning "Set-LabelPolicy is not available in tenant $($GlobalAdminAccount.UserName.Split('@')[0])"
        }
    }
    elseif (('Absent' -eq $Ensure) -and ('Present' -eq $CurrentPolicy.Ensure))
    {
        # If the label exists and it shouldn't, simply remove it;Need to force deletoion
        Write-Verbose -message "Deleting Sensitivity label policy $Name."

        try
        {
            Remove-LabelPolicy -Identity $Name -Confirm:$false
        }
        catch
        {
            Write-Warning "Remove-LabelPolicy is not available in tenant $($GlobalAdminAccount.UserName.Split('@')[0])"
        }
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
        $Name,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AdvancedSettings,

        [Parameter()]
        [System.String[]]
        $Labels,

        [Parameter()]
        [System.String[]]
        $ExchangeLocation,

        [Parameter()]
        [System.String[]]
        $ExchangeLocationException,

        [Parameter()]
        [System.String[]]
        $ModernGroupLocation,

        [Parameter()]
        [System.String[]]
        $ModernGroupLocationException,

        [Parameter()]
        [System.String[]]
        $AddLabels,

        [Parameter()]
        [System.String[]]
        $AddExchangeLocation,

        [Parameter()]
        [System.String[]]
        $AddExchangeLocationException,

        [Parameter()]
        [System.String[]]
        $AddModernGroupLocation,

        [Parameter()]
        [System.String[]]
        $AddModernGroupLocationException,

        [Parameter()]
        [System.String[]]
        $RemoveLabels,

        [Parameter()]
        [System.String[]]
        $RemoveExchangeLocation,

        [Parameter()]
        [System.String[]]
        $RemoveExchangeLocationException,

        [Parameter()]
        [System.String[]]
        $RemoveModernGroupLocation,

        [Parameter()]
        [System.String[]]
        $RemoveModernGroupLocationException,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of Sensitivity label for $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters


    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    $ValuesToCheck.Remove("AddLabels") | Out-Null
    $ValuesToCheck.Remove("AddExchangeLocation") | Out-Null
    $ValuesToCheck.Remove("AddExchangeLocationException") | Out-Null
    $ValuesToCheck.Remove("AddModernGroupLocation") | Out-Null
    $ValuesToCheck.Remove("AddModernGroupLocationException") | Out-Null
    $ValuesToCheck.Remove("RemoveLabels") | Out-Null
    $ValuesToCheck.Remove("RemoveExchangeLocation") | Out-Null
    $ValuesToCheck.Remove("RemoveExchangeLocationException") | Out-Null
    $ValuesToCheck.Remove("RemoveModernGroupLocation") | Out-Null
    $ValuesToCheck.Remove("RemoveModernGroupLocationException") | Out-Null

    if ($null -ne $AdvancedSettings)
    {
        $TestAdvancedSettings = Test-AdvancedSettings -DesiredProperty $AdvancedSettings -CurrentProperty $CurrentValues.AdvancedSettings
        if ($false -eq $TestAdvancedSettings)
        {
            return $false
        }
    }

    if ($null -ne $RemoveModernGroupLocation -or $null -ne $AddModernGroupLocation -or $null -ne $ModernGroupLocation)
    {
        $configData = New-PolicyData -configData $ModernGroupLocation -currentData $CurrentValues.ModernGroupLocation `
            -removedData $RemoveModernGroupLocation -additionalData $AddModernGroupLocation
        if ($null -ne $configData)
        {
            $ValuesToCheck["ModernGroupLocation"] = $configData
        }
        if ($null -eq $configData -and $null -ne $CurrentValues.ModernGroupLocation `
                -and $null -ne $RemoveModernGroupLocation)
        {
            #last entry removed so trigger drift
            return $false
        }
    }

    if ($null -ne $RemoveModernGroupLocationException -or $null -ne $AddModernGroupLocationException `
            -or $null -ne $ModernGroupLocationException)
    {
        $configData = New-PolicyData -configData $ModernGroupLocationException -currentData $CurrentValues.ModernGroupLocationException `
            -removedData $RemoveModernGroupLocationException -additionalData $AddModernGroupLocationException

        if ($null -ne $configData)
        {
            $ValuesToCheck["ModernGroupLocationException"] = $configData
        }
        if ($null -eq $configData -and $null -ne $CurrentValues.ModernGroupLocationException `
                -and $null -ne $RemoveModernGroupLocationException)
        {
            #last entry removed so trigger drift
            return $false
        }
    }

    if ($null -ne $RemoveExchangeLocation -or $null -ne $AddExchangeLocation -or $null -ne $ExchangeLocation)
    {
        $configData = New-PolicyData -configData $ExchangeLocation -currentData $CurrentValues.ExchangeLocation `
            -removedData $RemoveExchangeLocation -additionalData $AddExchangeLocation
        if ($null -ne $configData)
        {
            $ValuesToCheck["ExchangeLocation"] = $configData
        }
        if ($null -eq $configData -and $null -ne $CurrentValues.ExchangeLocation `
                -and $null -ne $RemoveExchangeLocation)
        {
            #last entry removed so trigger drift
            return $false
        }
    }

    if ($null -ne $RemoveExchangeLocationException -or $null -ne $AddExchangeLocationException -or $null -ne $ExchangeLocationException)
    {
        $configData = New-PolicyData -configData $ExchangeLocationException -currentData $CurrentValues.ExchangeLocationException `
            -removedData $RemoveExchangeLocationException -additionalData $AddExchangeLocationException

        if ($null -ne $configData)
        {
            $ValuesToCheck["ExchangeLocationException"] = $configData
        }

        if ($null -eq $configData -and $null -ne $CurrentValues.ExchangeLocationException `
                -and $null -ne $RemoveExchangeLocationException)
        {
            #last entry removed so trigger drift
            return $false
        }
    }

    if ($null -ne $RemoveLabels -or $null -ne $AddLabels -or $null -ne $Labels)
    {
        $configData = New-PolicyData -configData $Labels -currentData $CurrentValues.Labels `
            -removedData $RemoveLabels -additionalData $AddLabels

        if ($null -ne $configData)
        {
            $ValuesToCheck["Labels"] = $configData
        }

        if ($null -eq $configData -and $null -ne $CurrentValues.Labels `
                -and $null -ne $RemoveLabels)
        {
            #last entry removed so trigger drift
            return $false
        }
    }

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $ValuesToCheck `
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
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

    try
    {
        [array]$policies = Get-LabelPolicy -ErrorAction Stop

        $dscContent = ""
        $i = 1
        Write-Host "`r`n" -NoNewLine
        foreach ($policy in $policies)
        {
            Write-Host "    |---[$i/$($policies.Count)] $($policy.Name)" -NoNewLine

            $Params = @{
                Name               = $policy.Name
                GlobalAdminAccount = $GlobalAdminAccount
            }
            $Results = Get-TargetResource @Params

            if ($null -ne $Results.AdvancedSettings)
            {
                $Results.AdvancedSettings = ConvertTo-AdvancedSettingsString -AdvancedSettings $Results.AdvancedSettings
            }

            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -GlobalAdminAccount $GlobalAdminAccount
            if ($null -ne $Results.AdvancedSettings)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "AdvancedSettings"
            }

            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $dscContent += $currentDSCBlock
            $i++
        }
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return ""
    }
    return $dscContent
}

function Convert-StringToAdvancedSettings
{
    [CmdletBinding()]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    Param(
        [parameter(Mandatory = $true)]
        [System.String[]]
        $AdvancedSettings
    )
    $settings = @()
    foreach ($setting in $AdvancedSettings)
    {
        $settingString = $setting.Replace("[", "").Replace("]", "")
        $settingKey = $settingString.Split(",")[0]

        if ($settingKey -ne 'displayname')
        {
            $startPos = $settingString.IndexOf(",", 0) + 1
            $valueString = $settingString.Substring($startPos, $settingString.Length - $startPos).Trim()
            $values = $valueString.Split(",")

            $entry = @{
                Key   = $settingKey
                Value = $values
            }
            $settings += $entry
        }
    }
    return $settings
}
function Convert-CIMToAdvancedSettings
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    Param(
        [parameter(Mandatory = $true)]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AdvancedSettings
    )

    $entry = @{ }
    foreach ($obj in $AdvancedSettings)
    {
        $settingsValues = ""
        foreach ($objVal in $obj.Value)
        {
            $settingsValues += $objVal
            $settingsValues += ","
        }
        $entry[$obj.Key] = $settingsValues.Substring(0, ($settingsValues.Length - 1))
    }

    return $entry
}

function Test-AdvancedSettings
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [Parameter (Mandatory = $true)]
        $DesiredProperty,

        [Parameter (Mandatory = $true)]
        $CurrentProperty
    )

    $foundSettings = $true
    foreach ($desiredSetting in $DesiredProperty)
    {
        $foundKey = $CurrentProperty | Where-Object { $_.Key -eq $desiredSetting.Key }
        if ($null -ne $foundKey)
        {
            if ($foundKey.Value.ToString() -ne $desiredSetting.Value.ToString())
            {
                $foundSettings = $false
                break;
            }
        }
    }

    Write-Verbose -Message "Test AdvancedSettings  returns $foundSettings"
    return $foundSettings
}

function ConvertTo-AdvancedSettingsString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        $AdvancedSettings
    )

    $StringContent = "@(`r`n"
    foreach ($advancedSetting in $AdvancedSettings)
    {
        $StringContent += "                MSFT_SCLabelSetting`r`n"
        $StringContent += "                {`r`n"
        $StringContent += "                    Key   = '$($advancedSetting.Key.Replace("'", "''"))'`r`n"
        $StringContent += "                    Value = '$($advancedSetting.Value.Replace("'", "''"))'`r`n"
        $StringContent += "                }`r`n"
    }
    $StringContent += "            )"
    return $StringContent
}

function Convert-ArrayList
{
    [CmdletBinding()]
    [OutputType([System.Collections.ArrayList])]
    param(
        [Parameter ()]
        $CurrentProperty
    )
    [System.Collections.ArrayList]$currentItems = @()
    foreach ($currentProp in $CurrentProperty)
    {
        $currentItems.Add($currentProp.Name) | Out-Null
    }

    return $currentItems

}

function New-PolicyData
{
    [CmdletBinding()]
    [OutputType([System.Collections.ArrayList])]
    param(
        [Parameter ()]
        $configData,

        [Parameter ()]
        $currentData,

        [Parameter ()]
        $removedData,

        [Parameter ()]
        $additionalData
    )
    [System.Collections.ArrayList]$desiredData = @()
    foreach ($currItem in $currentData)
    {
        if (!$desiredData.Contains($currItem))
        {
            $desiredData.add($currItem) | Out-Null
        }
    }

    foreach ($currItem in $configData)
    {
        if (!$desiredData.Contains("$curritem"))
        {
            $desiredData.add($currItem) | Out-Null
        }
    }

    foreach ($currItem in $removedData)
    {
        $desiredData.remove($currItem) | Out-Null
    }

    foreach ($currItem in $additionalData)
    {
        if (!$desiredData.Contains("$curritem"))
        {
            $desiredData.add($currItem) | Out-Null
        }
    }

    return $desiredData
}

Export-ModuleMember -Function *-TargetResource
