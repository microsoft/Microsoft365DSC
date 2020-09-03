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
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
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
            ExchangeLocation             = $policy.ExchangeLocation
            ExchangeLocationException    = $policy.ExchangeLocationException
            ModernGroupLocation          = $policy.ModernGroupLocation
            ModernGroupLocationException = $policy.ModernGroupLocationException
        }

        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
        return $result
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

        $CreationParams.Remove("GlobalAdminAccount")
        $CreationParams.Remove("Ensure")
        $CreationParams.Remove("AddLabels")
        $CreationParams.Remove("AddExchangeLocation")
        $CreationParams.Remove("AddExchangeLocationException")
        $CreationParams.Remove("AddModernGroupLocation")
        $CreationParams.Remove("AddModernGroupLocationException")
        $CreationParams.Remove("RemoveLabels")
        $CreationParams.Remove("RemoveExchangeLocation")
        $CreationParams.Remove("RemoveExchangeLocationException")
        $CreationParams.Remove("RemoveModernGroupLocation")
        $CreationParams.Remove("RemoveModernGroupLocationException")
        Write-Verbose "Creating new Sensitivity label policy $Name."

        try
        {
            New-LabelPolicy @CreationParams
        }
        catch
        {
            Write-Warning "New-LabelPolicy is not available in tenant $($GlobalAdminAccount.UserName.Split('@')[0])"
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
        $SetParams.Remove("GlobalAdminAccount")
        $SetParams.Remove("Ensure")
        $SetParams.Remove("Name")
        $SetParams.Remove("ExchangeLocationException")
        $SetParams.Remove("Labels")
        $SetParams.Remove("ExchangeLocation")
        $SetParams.Remove("ModernGroupLocation")
        $SetParams.Remove("ModernGroupLocationException")

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
            Remove-LabelPolicy -Identity $Name -Confirm:$false -forcedeletion:$true
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
    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    if ($null -ne $AdvancedSettings)
    {
        $TestAdvancedSettings = Test-AdvancedSettings -DesiredProperty $AdvancedSettings -CurrentProperty $CurrentValues.AdvancedSettings
        if ($false -eq $TestAdvancedSettings)
        {
            return $false
        }
    }

    if ($null -ne $CurrentValues.ModernGroupLocation)
    {
        $configData = New-PolicyData -configData $ModernGroupLocation -currentData $CurrentValues.ModernGroupLocation `
            -removedData $RemoveModernGroupLocation -additionalData $AddModernGroupLocation
        $different = Test-Location -DesiredProperty $configData -CurrentPropert $CurrentValues.ModernGroupLocation
        if ($false -eq $different)
        {
            return $false
        }
    }

    if ($null -ne $CurrentValues.ModernGroupLocationException)
    {
        $configData = New-PolicyData -configData $ModernGroupLocationException -currentData $CurrentValues.ModernGroupLocationException `
            -removedData $RemoveModernGroupLocationException -additionalData $AddModernGroupLocationException
        $different = Test-Location -DesiredProperty $configData -CurrentPropert $CurrentValues.ModernGroupLocationException
        if ($false -eq $different)
        {
            return $false
        }
    }

    if ($null -ne $CurrentValues.ExchangeLocation)
    {
        $configData = New-PolicyData -configData $ExchangeLocation -currentData $CurrentValues.ExchangeLocation `
            -removedData $RemoveExchangeLocation -additionalData $AddExchangeLocation
        $different = Test-Location -DesiredProperty $configData -CurrentPropert $CurrentValues.ExchangeLocation
        if ($false -eq $different)
        {
            return $false
        }
    }

    if ($null -ne $CurrentValues.ExchangeLocationException )
    {
        $configData = New-PolicyData -configData $ExchangeLocationException -currentData $CurrentValues.ExchangeLocationException `
            -removedData $RemoveExchangeLocationException -additionalData $AddExchangeLocationException
        $different = Test-Location -DesiredProperty $configData -CurrentPropert $CurrentValues.ExchangeLocationException
        if ($false -eq $different)
        {
            return $false
        }
    }


    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("Name", `
            "Comment", `
            "Labels", `
            "Ensure")

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
        [array]$policies = Get-LabelPolicy

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
        Write-Warning "Get-LabelPolicy is not available in tenant $($GlobalAdminAccount.UserName.Split('@')[0])"
    }
    return $dscContent
}

function Convert-JSONToLocaleSettings
{
    [CmdletBinding()]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance[]])]
    Param(
        [parameter(Mandatory = $true)]
        $JSONLocalSettings
    )
    $localeSettings = $JSONLocalSettings | Convertfrom-Json

    $entries = @()
    $settings = @()
    foreach ($localeSetting in $localeSettings)
    {
        $result = @{
            localeKey = $localeSetting.LocaleKey
        }
        foreach ($setting in $localeSetting.Settings)
        {
            $entry = @{
                Key   = $setting.Key
                Value = $setting.Value
            }
            $settings += $entry
        }
        $result.Add("Settings", $settings)
        $settings = @()
        $entries += $result
        $result = @{ }

    }
    return $entries
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


function Convert-CIMToLocaleSettings
{
    [CmdletBinding()]
    [OutputType([System.Collections.ArrayList])]
    Param(
        [parameter(Mandatory = $true)]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $localeSettings
    )
    $entry = [System.Collections.ArrayList]@()
    foreach ($localset in $localeSettings)
    {
        $localeEntries = [ordered]@{
            localeKey = $localset.LocaleKey
        }
        $settings = @()
        foreach ($setting in $localset.Settings)
        {
            $settingEntry = @{
                Key   = $setting.Key
                Value = $setting.Value
            }
            $settings += $settingEntry
        }
        $localeEntries.Add("Settings", $settings)
        [void]$entry.Add(($localeEntries | ConvertTo-Json))
        $localeEntries = @{ }
        $settings = @( )
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

function ConvertTo-LocaleSettingsString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        $LocaleSettings
    )

    $StringContent = "@(`r`n"
    foreach ($LocaleSetting in $LocaleSettings)
    {
        $StringContent += "                MSFT_SCLabelLocaleSettings`r`n"
        $StringContent += "                {`r`n"
        $StringContent += "                    LocaleKey = '$($LocaleSetting.LocaleKey.Replace("'", "''"))'`r`n"
        $StringContent += "                    Settings  = @(`r`n"
        foreach ($Setting in $LocaleSetting.Settings)
        {
            $StringContent += "                        MSFT_SCLabelSetting`r`n"
            $StringContent += "                        {`r`n"
            $StringContent += "                            Key   = '$($Setting.Key.Replace("'", "''"))'`r`n"
            $StringContent += "                            Value = '$($Setting.Value.Replace("'", "''"))'`r`n"
            $StringContent += "                        }`r`n"
        }
        $StringContent += "                    )`r`n"
        $StringContent += "                }`r`n"
    }
    $StringContent += "            )"
    return $StringContent
}

function Test-Location
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [Parameter ()]
        $DesiredProperty,

        [Parameter (Mandatory = $true)]
        $CurrentProperty
    )
    [System.Collections.ArrayList]$currentLocations = @()
    foreach ($location in $CurrentProperty)
    {
        $currentLocations.Add($location.Name)
    }

    if ($null -ne $DesiredProperty)
    {
        $diff = Compare-Object -ReferenceObject $currentLocations -DifferenceObject $DesiredProperty
    }
    else
    {
        return $false
    }
    if ($null -eq $diff)
    {
        return $true
    }
    else
    {
        return $false
    }

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
        $desiredData.add($currItem.Name)
    }

    foreach ($currItem in $configData)
    {
        $desiredData.add($currItem)
    }

    foreach ($currItem in $removedData)
    {
        $desiredData.remove($currItem)
    }

    foreach ($currItem in $additionalData)
    {
        $desiredData.add($currItem)
    }

    return $desiredData
}

Export-ModuleMember -Function *-TargetResource
