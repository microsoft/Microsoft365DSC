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
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $LocaleSettings,

        [Parameter()]
        [System.String]
        $ParentId,

        [Parameter()]
        [uint32]
        $Priority,

        [Parameter()]
        [System.String]
        $Tooltip,

        [Parameter()]
        [System.Boolean]
        $Disabled,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of Sensitiivity Label for $Name"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Calling Test-SecurityAndComplianceConnection function:"
    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform SecurityComplianceCenter

    try
    {
        $label = Get-Label -Identity $Name -ErrorAction SilentlyContinue
    }
    catch
    {
        Write-Warning "Get-Label is not available in tenant $($GlobalAdminAccount.UserName.Split('@')[0])"
    }

    if ($null -eq $label)
    {
        Write-Verbose -Message "Sensitiivity label $($Name) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        $parentLabelID = $null
        if ($null -ne $label.ParentId)
        {
            $parentLabel = Get-Label -Identity $label.ParentId -ErrorAction SilentlyContinue
            $parentLabelID = $parentLabel.Name
        }
        if ($null -ne $label.LocaleSettings)
        {
            $localeSettingsValue = Convert-JSONToLocaleSettings -JSONLocalSettings $label.LocaleSettings
        }
        if ($null -ne $label.Settings)
        {
            $advancedSettingsValue = Convert-StringToAdvancedSettings -AdvancedSettings $label.Settings
        }
        Write-Verbose "Found existing Sensitiivity Label $($Name)"
        $result = @{
            Name               = $label.Name
            Comment            = $label.Comment
            ParentId           = $parentLabelID
            AdvancedSettings   = $advancedSettingsValue
            DisplayName        = $label.DisplayName
            LocaleSettings     = $localeSettingsValue
            Priority           = $label.Priority
            Tooltip            = $label.Tooltip
            Disabled           = $label.Disabled
            GlobalAdminAccount = $GlobalAdminAccount
            Ensure             = 'Present'
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
        $DisplayName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $LocaleSettings,

        [Parameter()]
        [System.String]
        $ParentId,

        [Parameter()]
        [uint32]
        $Priority,

        [Parameter()]
        [System.String]
        $Tooltip,

        [Parameter()]
        [System.Boolean]
        $Disabled,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of Sensitiivity label for $Name"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform SecurityComplianceCenter

    $label = Get-TargetResource @PSBoundParameters

    if (('Present' -eq $Ensure) -and ('Absent' -eq $label.Ensure))
    {
        if ($null -ne $label.Priority)
        {
            throw "SCSensitivityLabel can't set Priortity property on " + `
                "new label {$Name} to $label.Priority." + `
                "You will need to set priority property once label is created."
        }

        if ($null -ne $label.Disabled)
        {
            throw "SCSensitivityLabel can't set disabled property on " + `
                "new label {$Name} to $label.Disabled." + `
                "You will need to set disabled property once label is created."
        }

        $CreationParams = $PSBoundParameters

        if ($PSBoundParameters.ContainsKey("AdvancedSettings"))
        {
            $advanced = Convert-CIMToAdvancedSettings $AdvancedSettings
            $CreationParams["AdvancedSettings"] = $advanced
        }

        if ($PSBoundParameters.ContainsKey("LocaleSettings"))
        {
            $locale = Convert-CIMToLocaleSettings $LocaleSettings
            $CreationParams["LocaleSettings"] = $locale
        }

        $CreationParams.Remove("GlobalAdminAccount")
        $CreationParams.Remove("Ensure")
        $CreationParams.Remove("Priority")
        $CreationParams.Remove("Disabled")

        Write-Verbose "Creating new Sensitiivity label $Name calling the New-Label cmdlet."

        try
        {
            New-Label @CreationParams
        }
        catch
        {
            Write-Warning "New-Label is not available in tenant $($GlobalAdminAccount.UserName.Split('@')[0])"
        }
    }
    elseif (('Present' -eq $Ensure) -and ('Present' -eq $label.Ensure))
    {
        $SetParams = $PSBoundParameters

        if ($PSBoundParameters.ContainsKey("AdvancedSettings"))
        {
            $advanced = Convert-CIMToAdvancedSettings  $AdvancedSettings
            $SetParams["AdvancedSettings"] = $advanced
        }

        if ($PSBoundParameters.ContainsKey("LocaleSettings"))
        {
            $locale = Convert-CIMToLocaleSettings $LocaleSettings
            $SetParams["LocaleSettings"] = $locale
        }

        #Remove unused parameters for Set-Label cmdlet
        $SetParams.Remove("GlobalAdminAccount")
        $SetParams.Remove("Ensure")
        $SetParams.Remove("Name")

        try
        {
            Set-Label @SetParams -Identity $Name
        }
        catch
        {
            Write-Warning "Set-Label is not available in tenant $($GlobalAdminAccount.UserName.Split('@')[0])"
        }
    }
    elseif (('Absent' -eq $Ensure) -and ('Present' -eq $label.Ensure))
    {
        # If the label exists and it shouldn't, simply remove it;Need to force deletoion
        Write-Verbose -message "Deleting Sensitiivity label $Name."

        try
        {
            Remove-Label -Identity $Name -Confirm:$false
            Remove-Label -Identity $Name -Confirm:$false -forcedeletion:$true
        }
        catch
        {
            Write-Warning "Remove-Label is not available in tenant $($GlobalAdminAccount.UserName.Split('@')[0])"
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
        $DisplayName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $LocaleSettings,

        [Parameter()]
        [System.String]
        $ParentId,

        [Parameter()]
        [uint32]
        $Priority,

        [Parameter()]
        [System.String]
        $Tooltip,

        [Parameter()]
        [System.Boolean]
        $Disabled,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of Sensitiivity label for $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    $ValuesToCheck.Remove('AdvancedSettings') | Out-Null
    $ValuesToCheck.Remove('LocaleSettings') | Out-Null

    if ($null -ne $AdvancedSettings)
    {
        $TestAdvancedSettings = Test-AdvancedSettings -DesiredProperty $AdvancedSettings -CurrentProperty $CurrentValues.AdvancedSettings
        if ($false -eq $TestAdvancedSettings)
        {
            return $false
        }
    }

    if ($null -ne $LocaleSettings)
    {
        $localeSettingsSame = Test-LocaleSettings -DesiredProperty $LocaleSettings -CurrentProperty $CurrentValues.LocaleSettings
        if ($false -eq $localeSettingsSame)
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
    $InformationPreference = 'Continue'
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -Platform 'SecurityComplianceCenter' `
        -CloudCredential $GlobalAdminAccount

    try
    {
        [array]$labels = Get-Label

        $content = ""
        $i = 1
        foreach ($label in $labels)
        {
            Write-Information "    -[$i/$($labels.Count)] $($label.Name)"
            $params = @{
                Name               = $label.Name
                GlobalAdminAccount = $GlobalAdminAccount
            }
            $result = Get-TargetResource @params
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"

            if ($null -ne $result.AdvancedSettings)
            {
                $result.AdvancedSettings = ConvertTo-AdvancedSettingsString -AdvancedSettings $result.AdvancedSettings
            }

            if ($null -ne $result.LocaleSettings)
            {
                $result.LocaleSettings = ConvertTo-LocaleSettingsString -LocaleSettings $result.LocaleSettings
            }
            $content += "        SCSensitivityLabel " + (New-GUID).ToString() + "`r`n"
            $content += "        {`r`n"
            $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
            $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "AdvancedSettings"
            $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "LocaleSettings"
            $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
            $content += $currentDSCBlock
            $content += "        }`r`n"
            $i++
        }
    }
    catch
    {
        Write-Warning "Get-Label is not available in tenant $($GlobalAdminAccount.UserName.Split('@')[0])"
    }
    return $content
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
