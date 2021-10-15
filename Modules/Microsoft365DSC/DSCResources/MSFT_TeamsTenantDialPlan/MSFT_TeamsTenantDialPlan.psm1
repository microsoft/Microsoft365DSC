function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 49)]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateLength(1, 512)]
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
        [ValidateLength(1, 49)]
        [System.String]
        $SimpleName,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Write-Verbose -Message "Getting configuration of Teams Tenant Dial Plan"

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

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
                Credential    = $Credential
                Ensure                = 'Present'
            }
        }
        return $result
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
        return $_
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 49)]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateLength(1, 512)]
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
        [ValidateLength(1, 49)]
        [System.String]
        $SimpleName,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Write-Verbose -Message "Setting configuration of Teams Guest Calling"

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $CurrentValues = Get-TargetResource @PSBoundParameters

    if ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
    {
        Write-Verbose "Tenant Dial Plan {$Identity} doesn't exist but it should. Creating it."
        #region VoiceNormalizationRules
        $AllRules = @()
        # Ensure the VoiceNormalizationRules all exist
        foreach ($rule in $NormalizationRules)
        {
            # Need to create the rule
            Write-Verbose "Creating VoiceNormalizationRule {$($rule.Identity)}"
            $ruleObject = New-CsVoiceNormalizationRule -Identity "Global/$($rule.Identity.Replace('Tag:', ''))" `
                -Description $rule.Description `
                -Pattern $rule.Pattern `
                -Translation $rule.Translation `
                -InMemory

            $AllRules += $ruleObject
        }

        $NewParameters = $PSBoundParameters
        $NewParameters.Remove("Credential")
        $NewParameters.Remove("Ensure")
        $NewParameters.NormalizationRules = @{Add = $AllRules }

        New-CsTenantDialPlan @NewParameters
    }
    elseif ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Tenant Dial Plan {$Identity} already exists. Updating it."
        $SetParameters = $PSBoundParameters
        $SetParameters.Remove("Credential")
        $SetParameters.Remove("Ensure")
        $SetParameters.Remove("SimpleName")

        $desiredRules = @()
        foreach ($rule in $NormalizationRules)
        {
            $desiredRule = @{
                Identity            = $rule.Identity
                Description         = $rule.Description
                Pattern             = $rule.Pattern
                IsExternalExtension = $rule.IsExternalExtension
                Translation         = $rule.Translation
            }
            $desiredRules += $desiredRule
        }

        $differences = Get-M365DSCVoiceNormalizationRulesDifference -CurrentRules $CurrentValues.NormalizationRules -DesiredRules $desiredRules

        $rulesToRemove = @()
        $rulesToAdd = @()

        foreach ($ruleToAdd in $differences.RulesToAdd)
        {
            Write-Verbose "Adding new VoiceNormalizationRule {$($ruleToAdd.Identity)}"
            $ruleObject = New-CsVoiceNormalizationRule -Identity "Global/$($ruleToAdd.Identity.Replace('Tag:', ''))" `
                -Description $ruleToAdd.Description `
                -Pattern $ruleToAdd.Pattern `
                -Translation $ruleToAdd.Translation `
                -InMemory
            Write-Verbose "VoiceNormalizationRule created"
            Set-CsTenantDialPlan -Identity $Identity -NormalizationRules @{Add = $ruleObject }
            Write-Verbose "Updated the Tenant Dial Plan"
        }
        foreach ($ruleToRemove in $differences.RulesToRemove)
        {
            if ($null -eq $plan)
            {
                $plan = Get-CsTenantDialPlan -Identity $Identity
            }
            $ruleObject = $plan.NormalizationRules | Where-Object -FilterScript { $_.Name -eq $ruleToRemove.Identity }

            if ($null -ne $ruleObject)
            {
                Write-Verbose "Removing VoiceNormalizationRule {$($ruleToRemove.Identity)}"
                Write-Verbose "VoiceNormalizationRule created"
                Set-CsTenantDialPlan -Identity $Identity -NormalizationRules @{Remove = $ruleObject }
                Write-Verbose "Updated the Tenant Dial Plan"
            }
        }
        foreach ($ruleToUpdate in $differences.RulesToUpdate)
        {
            if ($null -eq $plan)
            {
                $plan = Get-CsTenantDialPlan -Identity $Identity
            }
            $ruleObject = $plan.NormalizationRules | Where-Object -FilterScript { $_.Name -eq $ruleToUpdate.Identity }

            if ($null -ne $ruleObject)
            {
                Write-Verbose "Updating VoiceNormalizationRule {$($ruleToUpdate.Identity)}"
                Set-CsTenantDialPlan -Identity $Identity -NormalizationRules @{Remove = $ruleObject }
                $ruleObject = New-CsVoiceNormalizationRule -Identity "Global/$($ruleToUpdate.Identity.Replace('Tag:', ''))" `
                    -Description $ruleToUpdate.Description `
                    -Pattern $ruleToUpdate.Pattern `
                    -Translation $ruleToUpdate.Translation `
                    -InMemory
                Write-Verbose "VoiceNormalizationRule Updated"
                Set-CsTenantDialPlan -Identity $Identity -NormalizationRules @{Add = $ruleObject }
                Write-Verbose "Updated the Tenant Dial Plan"
            }
        }
    }
    elseif ($Ensure -eq 'Absent' -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Tenant Dial Plan {$Identity} exists and shouldn't. Removing it."
        Remove-CsTenantDialPlan -Identity $Identity -Confirm:$false
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 49)]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateLength(1, 512)]
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
        [ValidateLength(1, 49)]
        [System.String]
        $SimpleName,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    Write-Verbose -Message "Testing configuration of Teams Guest Calling"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    if ($null -ne $NormalizationRules)
    {
        $desiredRules = @()
        foreach ($rule in $NormalizationRules)
        {
            $desiredRule = @{
                Identity            = $rule.Identity
                Description         = $rule.Description
                Pattern             = $rule.Pattern
                IsExternalExtension = $rule.IsExternalExtension
                Translation         = $rule.Translation
            }
            $desiredRules += $desiredRule
        }

        if (-not $null -eq $CurrentValues.NormalizationRules)
        {
            $differences = Get-M365DSCVoiceNormalizationRulesDifference -CurrentRules $CurrentValues.NormalizationRules `
                -DesiredRules $desiredRules
        }
        elseif ($NormalizationRules.Length -gt 0)
        {
            return $false
        }
    }

    if ($differences.RulesToAdd.Length -gt 0 -or $differences.RulesToUpdate.Length -gt 0 -or $differences.RulesToRemove.Length -gt 0)
    {
        return $false
    }

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
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
        $Credential
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

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
        [array]$tenantDialPlans = Get-CsTenantDialPlan -ErrorAction Stop

        $dscContent = ''
        $i = 1
        Write-Host "`r`n" -NoNewline
        foreach ($plan in $tenantDialPlans)
        {
            Write-Host "    |---[$i/$($tenantDialPlans.Count)] $($plan.Identity)" -NoNewline
            $params = @{
                Identity           = $plan.Identity
                Credential = $Credential
            }
            $results = Get-TargetResource @params
            $results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results

            if ($results.NormalizationRules.Count -gt 0)
            {
                if ($results.NormalizationRules.GetType().Name -eq "Hashtable")
                {
                    $results.NormalizationRules = Get-M365DSCNormalizationRulesAsString $results.NormalizationRules
                }
                else
                {
                    $results.NormalizationRules = Get-M365DSCNormalizationRulesAsString $results.NormalizationRules[0]
                }
            }
            $currentDSCBlock = "        TeamsTenantDialPlan " + (New-Guid).ToString() + "`r`n"
            $currentDSCBlock += "        {`r`n"
            $content = Get-DSCBlock -Params $results -ModulePath $PSScriptRoot

            $content = Convert-DSCStringParamToVariable -DSCBlock $content -ParameterName "NormalizationRules"
            $currentDSCBlock += Convert-DSCStringParamToVariable -DSCBlock $content -ParameterName "Credential"
            $currentDSCBlock += "        }`r`n"
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
        Write-Host $Global:M365DSCEmojiRedX
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

function Get-M365DSCVoiceNormalizationRulesDifference
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Object[]]
        $CurrentRules,

        [Parameter(Mandatory = $true)]
        [System.Object[]]
        $DesiredRules
    )

    $differences = @{}
    $rulesToRemove = @()
    $rulesToAdd = @()
    $rulesToUpdate = @()
    foreach ($currentRule in $CurrentRules)
    {
        $equivalentDesiredRule = $DesiredRules | Where-Object -FilterScript { $_.Identity -eq $currentRule.Identity }

        # Case the current rule is not listed in the Desired rules, we need to remove it
        if ($null -eq $equivalentDesiredRule)
        {
            Write-Verbose "Adding Rule {$($currentRule.Identity)} to the RulesToRemove"
            $rulesToRemove += $currentRule
        }
        # Case the rule exists but is not in the desired state
        else
        {
            $differenceFound = $false
            foreach ($key in $currentRule.Keys)
            {
                if (-not [System.String]::IsNullOrEmpty($equivalentDesiredRule.$key) -and $currentRule.$key -ne $equivalentDesiredRule.$key)
                {
                    $differenceFound = $true
                }
            }

            if ($differenceFound)
            {
                Write-Verbose "Adding Rule {$($currentRule.Identity)} to the RulesToUpdate"
                $rulesToUpdate += $equivalentDesiredRule
            }
        }
    }

    foreach ($desiredRule in $DesiredRules)
    {
        $equivalentCurrentRule = $CurrentRules | Where-Object -FilterScript { $_.Identity -eq $desiredRule.Identity }

        # Case the desired rule doesn't exist, we need to create it
        if ($null -eq $equivalentCurrentRule)
        {
            Write-Verbose "Adding Rule {$($desiredRule.Identity)} to the RulesToAdd"
            $rulesToAdd += $desiredRule
        }
    }
    $differences.Add("RulesToAdd", $rulesToAdd)
    $differences.Add("RulesToUpdate", $rulesToUpdate)
    $differences.Add("RulesToRemove", $rulesToRemove)
    return $differences
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
        $currentRule = @{
            Identity            = $ruleName
            Priority            = $rule.Priority
            Description         = $rule.Description
            Pattern             = $rule.Pattern
            Translation         = $rule.Translation
            IsInternalExtension = $rule.IsInternalExtension
        }
        if ([System.String]::IsNullOrEmpty($rule.Priority))
        {
            $currentRule.Remove("Priority") | Out-Null
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

Export-ModuleMember -Function *-TargetResource
