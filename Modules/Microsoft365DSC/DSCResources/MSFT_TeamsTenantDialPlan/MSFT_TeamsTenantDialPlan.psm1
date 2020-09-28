function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1,49)]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateLength(1,512)]
        [System.String]
        $Description,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $NormalizationRules,

        [Parameter()]
        [System.String]
        $ExternalAccessPrefix,

        [Parameter()]
        [System.Boolean]
        $OptimizeDeviceDialing = $false,

        [Parameter()]
        [ValidateLength(1,49)]
        [System.String]
        $SimpleName,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of Teams Tenant Dial Plan"

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'SkypeForBusiness' `
        -InboundParameters $PSBoundParameters

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"
    try
    {
        $config = Get-CsTenantDialPlan -Identity $Identity -ErrorAction 'SilentlyContinue'

        if ($null -eq $config)
        {
            Write-Verbose -Message "Could not find existing Dial Plan {$Identity}"
            return $nullReturn
        }
        else
        {
            Write-Verbose -Message "Found existing Dial Plan {$Identity}"
            $rules = @()
            if ($config.NormalizationRules.Count -gt 0)
            {
                $rules = Get-M365DSCNormalizationRules -Rules $config.NormalizationRules
            }
            $result = @{
                Identity              = $Identity.Replace("Tag:", "")
                Description           = $config.Description
                NormalizationRules    = $rules
                ExternalAccessPrefix  = $config.ExternalAccessPrefix
                OptimizeDeviceDialing = $config.OptimizeDeviceDialing
                SimpleName            = $config.SimpleName
                GlobalAdminAccount    = $GlobalAdminAccount
                Ensure                = 'Present'
            }
        }
        return $result
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return $_
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1,49)]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateLength(1,512)]
        [System.String]
        $Description,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $NormalizationRules,

        [Parameter()]
        [System.String]
        $ExternalAccessPrefix,

        [Parameter()]
        [System.Boolean]
        $OptimizeDeviceDialing = $false,

        [Parameter()]
        [ValidateLength(1,49)]
        [System.String]
        $SimpleName,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of Teams Guest Calling"

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $CurrentValues = Get-TargetResource @PSBoundParameters

    #region VoiceNormalizationRules
    $AllRules = @()
    if ($Ensure -eq 'Present')
    {
        # Ensure the VoiceNormalizationRules all exist
        foreach ($rule in $CurrentValues.NormalizationRules)
        {
            $ruleName = $rule.Identity.Replace("Tag:", "")
            $ruleObject = Get-CsVoiceNormalizationRule | Where-Object -FilterScript {$_.Name -eq $ruleName}
            if ($null -eq $ruleObject)
            {
                # Need to create the rule
                $ruleObject = New-CSVoiceNormalizationRule @rule
            }
            $AllRules += $rueObject
        }
    }
    #endregion

    if ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Tenant Dial Plan {$Identity} doesn't exist. Creating it."
        $NewParameters = $PSBoundParameters
        $NewParameters.Remove("GlobalAdminAccount")
        $NewParameters.Remove("Ensure")
        $NewParameters.NormalizationRules = @{Add=$AllRules}

        New-CSTenantDialPlan @NewParameters
    }
    elseif ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Tenant Dial Plan {$Identity} already exists. Updating it."
        $SetParameters = $PSBoundParameters
        $SetParameters.Remove("GlobalAdminAccount")
        $SetParameters.Remove("Ensure")
        $SetParameters.Remove("SimpleName")

        $differences = Get-M365DSCNormalizationRulesDifference -Current $CurrentValues -Desired $PSBoundParameters

        $rulesToRemove = @()
        $rulesToAdd    = @()

        foreach ($entry in $differences)
        {
            $rule = Get-CsVoiceNormalizationRule | Where-Object -FilterScript {$_.Name -eq $entry.InputObject}
            if ($entry.SideIndicator -eq '=>')
            {
                $rulesToAdd += $rule
            }
            elseif ($entry.SideIndicator -eq '<=')
            {
                $rulesToRemove += $rule
            }
        }

        $SetParameters.NormalizationRules = @{Add=$rulesToAdd;Remove=$rulesToRemove}

        Set-CSTenantDialPlan @SetParameters
    }
    elseif ($Ensure -eq 'Absent' -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Tenant Dial Plan {$Identity} exists and shouldn't. Removing it."
        Remove-CSTenantDialPlan -Identity $Identity -Confirm:$false
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1,49)]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateLength(1,512)]
        [System.String]
        $Description,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $NormalizationRules,

        [Parameter()]
        [System.String]
        $ExternalAccessPrefix,

        [Parameter()]
        [System.Boolean]
        $OptimizeDeviceDialing = $false,

        [Parameter()]
        [ValidateLength(1,49)]
        [System.String]
        $SimpleName,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Write-Verbose -Message "Testing configuration of Teams Guest Calling"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    if ($null -ne $NormalizationRules)
    {
        $differences = Get-M365DSCNormalizationRulesDifference -Current $CurrentValues -Desired $ValuesToCheck
        if ($null -ne $differences)
        {
            return $false
        }
    }

    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    $ValuesToCheck.Remove("NormalizationRules") | Out-Null

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

    try
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'SkypeForBusiness' `
            -InboundParameters $PSBoundParameters
        [array]$tenantDialPlans = Get-CsTenantDialPlan -ErrorAction Stop

        $content = ''
        $i = 1
        Write-Host "`r`n" -NoNewLine
        foreach ($plan in $tenantDialPlans)
        {
            Write-Host "    |---[$i/$($tenantDialPlans.Count)] $($plan.Identity)" -NoNewLine
            $params = @{
                Identity            = $plan.Identity
                GlobalAdminAccount  = $GlobalAdminAccount
            }
            $result = Get-TargetResource @params
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"

            if ($result.NormalizationRules.Count -gt 0)
            {
                $result.NormalizationRules = Get-M365DSCNormalizationRulesAsString $result.NormalizationRules
            }
            $content += "        TeamsTenantDialPlan " + (New-GUID).ToString() + "`r`n"
            $content += "        {`r`n"
            $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
            $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "NormalizationRules"
            $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
            $content += "        }`r`n"
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        return $content
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return ""
    }
}

function Get-M365DSCNormalizationRules
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory = $true)]
        $Rules
    )

    if ($null -eq $Rules)
    {
        return $null
    }

    $result = @()
    foreach ($rule in $Rules)
    {
        $ruleName = $rule.Name.Replace("Tag:", "")
        $ruleObject = Get-CsVoiceNormalizationRule | Where-Object -FilterScript {$_.Name -eq $ruleName}
        $currentRule = @{
            Identity            = $ruleName
            Priority            = $ruleObject.Priority
            Description         = $ruleObject.Description
            Pattern             = $ruleObject.Pattern
            Translation         = $ruleObject.Translation
            IsInternalExtension = $ruleObject.IsInternalExtension
        }
        $result += $currentRule
    }

    return $result
}

function Get-M365DSCNormalizationRulesAsString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Params
    )

    if ($null -eq $params)
    {
        return $null
    }
    $currentProperty = "MSFT_TeamsVoiceNormalizationRule{`r`n"
    foreach ($key in $params.Keys)
    {
        if ($key -eq 'Priority')
        {
            $currentProperty += "                " + $key + " = " + $params[$key] + "`r`n"
        }
        elseif ($key -eq "IsInternalExtension")
        {
            $currentProperty += "                " + $key + " = `$" + $params[$key] + "`r`n"
        }
        else
        {
            $currentProperty += "                " + $key + " = '" + $params[$key] + "'`r`n"
        }
    }
    $currentProperty += "            }"
    return $currentProperty
}

function Get-M365DSCNormalizationRulesDifference
{
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    param (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Current,

        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Desired
    )
    $currentRulesId = @()
    foreach ($currentRule in $CurrentValues.NormalizationRules)
    {
        Write-Verbose -Message "Adding {$($currentRule.Identity)} to current Rules"
        $currentRulesId += $currentRule.Identity
    }

    $desiredRules = @()
    foreach ($desiredRule in $NormalizationRules)
    {
        Write-Verbose -Message "Adding {$($desiredRule.Identity)} to desired Rules"
        $desiredRules += $desiredRule.Identity
    }

    $differences = Compare-Object -ReferenceObject $currentRulesId -DifferenceObject $desiredRules
    return $differences
}

Export-ModuleMember -Function *-TargetResource
