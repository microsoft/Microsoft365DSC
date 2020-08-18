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
        [Syste.String[]]
        $ExchangeLocationLocation,

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

    if ($null -eq $label)
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
            $advancedSettingsValue = Convert-StringToAdvancedSettings -AdvancedSettings $label.Settings
        }
        Write-Verbose "Found existing Sensitivity Label policy $($Name)"
        $result = @{
            Name                         = $policy.Name
            Comment                      = $policy.Comment
            AdvancedSettings             = $advancedSettingsValue
            GlobalAdminAccount           = $GlobalAdminAccount
            Ensure                       = 'Present'
            Labels                       = $policy.Labels
            ExchangeLocationLocation     = $policy.ExchangeLocationLocation
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
        [System.String]
        $Labels,

        [Parameter()]
        [Syste.String]
        $ExchangeLocationLocation,

        [Parameter()]
        [System.String]
        $ExchangeLocationException,

        [Parameter()]
        [System.String]
        $ModernGroupLocation,

        [Parameter()]
        [System.String]
        $ModernGroupLocationException,


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

    # Exchange Location Exception is specified or already existing, we need to determine
    # the delta.
    if ($null -ne $CurrentPolicy.ExchangeLocationException -or `
            $null -ne $ExchangeLocationException)
    {
        $ToBeRemoved = $CurrentPolicy.ExchangeLocationException | `
            Where-Object { $ExchangeLocationException -NotContains $_ }
        if ($null -ne $ToBeRemoved)
        {
            $CreationParams.Add("RemoveExchangeLocationException", $ToBeRemoved)
        }

        $ToBeAdded = $ExchangeLocationException | `
            Where-Object { $CurrentPolicy.ExchangeLocationException -NotContains $_ }
        if ($null -ne $ToBeAdded)
        {
            $CreationParams.Add("AddExchangeLocationException", $ToBeAdded)
        }
        $CreationParams.Remove("ExchangeLocationException")
    }

     # Exchange Location  is specified or already existing, we need to determine
    # the delta.
    if ($null -ne $CurrentPolicy.ExchangeLocationLocation -or `
            $null -ne $ExchangeLocationLocation)
    {
        $ToBeRemoved = $CurrentPolicy.ExchangeLocationLocation | `
            Where-Object { $ExchangeLocationLocation -NotContains $_ }
        if ($null -ne $ToBeRemoved)
        {
            $CreationParams.Add("ExchangeLocationLocation", $ToBeRemoved)
        }

        $ToBeAdded = $ExchangeLocationLocation | `
            Where-Object { $CurrentPolicy.ExchangeLocationLocation -NotContains $_ }
        if ($null -ne $ToBeAdded)
        {
            $CreationParams.Add("ExchangeLocationLocation", $ToBeAdded)
        }
        $CreationParams.Remove("ExchangeLocationLocation")
    }

    # Modern Group Location Exception is specified or already existing, we need to determine
    # the delta.
    if ($null -ne $CurrentPolicy.ModernGroupLocationException -or `
            $null -ne $ModernGroupLocationException)
    {
        $ToBeRemoved = $CurrentPolicy.ModernGroupLocationException | `
            Where-Object { $ModernGroupLocationException -NotContains $_ }
        if ($null -ne $ToBeRemoved)
        {
            $CreationParams.Add("ModernGroupLocationException", $ToBeRemoved)
        }

        $ToBeAdded = $ModernGroupLocationException | `
            Where-Object { $CurrentPolicy.ModernGroupLocationException -NotContains $_ }
        if ($null -ne $ToBeAdded)
        {
            $CreationParams.Add("ModernGroupLocationException", $ToBeAdded)
        }
        $CreationParams.Remove("ModernGroupLocationException")
    }

     # Modern Group Exception is specified or already existing, we need to determine
    # the delta.
    if ($null -ne $CurrentPolicy.ModernGroupLocation -or `
            $null -ne $ModernGroupLocation)
    {
        $ToBeRemoved = $CurrentPolicy.ModernGroupLocation | `
            Where-Object { $ModernGroupLocation -NotContains $_ }
        if ($null -ne $ToBeRemoved)
        {
            $CreationParams.Add("ModernGroupLocation", $ToBeRemoved)
        }

        $ToBeAdded = $ModernGroupLocation | `
            Where-Object { $CurrentPolicy.ModernGroupLocation -NotContains $_ }
        if ($null -ne $ToBeAdded)
        {
            $CreationParams.Add("ModernGroupLocation", $ToBeAdded)
        }
        $CreationParams.Remove("ModernGroupLocation")
    }


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

        Write-Verbose "Creating new Sensitivity label policy $Name."

        try
        {
            New-LabelPolicy @CreationParams
            ## Can't set priority until label created
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
        [System.String]
        $Labels,

        [Parameter()]
        [Syste.String]
        $ExchangeLocationLocation,

        [Parameter()]
        [System.String]
        $ExchangeLocationException,

        [Parameter()]
        [System.String]
        $ModernGroupLocation,

        [Parameter()]
        [System.String]
        $ModernGroupLocationException,


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

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    $ValuesToCheck.Remove('AdvancedSettings') | Out-Null

    if ($null -ne $AdvancedSettings)
    {
        $TestAdvancedSettings = Test-AdvancedSettings -DesiredProperty $AdvancedSettings -CurrentProperty $CurrentValues.AdvancedSettings
        if ($false -eq $TestAdvancedSettings)
        {
            return $false
        }
    }

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
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
            Write-Host "    |---[$i/$($labels.Count)] $($label.Name)" -NoNewLine

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

function Test-LocaleSettings
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
        $foundKey = $CurrentProperty | Where-Object { $_.LocaleKey -eq $desiredSetting.localeKey }
        foreach ($setting in $desiredSetting.Settings)
        {
            if ($null -ne $foundKey)
            {
                $myLabel = $foundKey.Settings | Where-Object { $_.Key -eq $setting.Key -and $_.Value -eq $setting.Value }

                if ($null -eq $myLabel)
                {
                    $foundSettings = $false
                    break;
                }
            }
            else
            {
                $foundSettings = $false
                break;

            }
        }
    }
    Write-Verbose -Message "Test LocaleSettings returns $foundSettings"
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

Export-ModuleMember -Function *-TargetResource
