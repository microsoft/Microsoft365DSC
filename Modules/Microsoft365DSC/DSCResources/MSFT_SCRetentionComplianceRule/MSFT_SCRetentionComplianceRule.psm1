function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Policy,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [System.String[]]
        $ExcludedItemClasses,

        [Parameter()]
        [System.String]
        $RetentionDuration,

        [Parameter()]
        [ValidateSet("Days", "Months", "Years")]
        [System.String]
        $RetentionDurationDisplayHint = "Days",

        [Parameter()]
        [System.String]
        $ContentMatchQuery,

        [Parameter()]
        [ValidateSet("CreationAgeInDays", "ModificationAgeInDays")]
        [System.String]
        $ExpirationDateOption,

        [Parameter()]
        [ValidateSet("Delete", "Keep", "KeepAndDelete")]
        [System.String]
        $RetentionComplianceAction,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Write-Verbose -Message "Getting configuration of RetentionComplianceRule for $Name"
    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
            -InboundParameters $PSBoundParameters
    }

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


    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'
    try
    {
        $RuleObject = Get-RetentionComplianceRule -Identity $Name `
            -ErrorAction SilentlyContinue

        if ($null -eq $RuleObject)
        {
            Write-Verbose -Message "RetentionComplianceRule $($Name) does not exist."
            return $nullReturn
        }
        else
        {
            Write-Verbose "Found existing RetentionComplianceRule $($Name)"
            $AssociatedPolicy = Get-RetentionCompliancePolicy $RuleObject.Policy
            $RetentionComplianceActionValue = $null
            if (-not [System.String]::IsNullOrEmpty($ruleObject.RetentionComplianceAction))
            {
                $RetentionComplianceActionValue = $RuleObject.RetentionComplianceAction
            }
            $result = @{
                Name                         = $RuleObject.Name
                Comment                      = $RuleObject.Comment
                Policy                       = $AssociatedPolicy.Name
                RetentionDuration            = $RuleObject.RetentionDuration
                RetentionComplianceAction    = $RetentionComplianceActionValue
                Credential                   = $Credential
                Ensure                       = 'Present'
            }
            if (-not $associatedPolicy.TeamsPolicy)
            {
                $result.Add('ExpirationDateOption', $RuleObject.ExpirationDateOption)
                $result.Add('ExcludedItemClasses', $RuleObject.ExcludedItemClasses)
                $result.Add('RetentionDurationDisplayHint', $RuleObject.RetentionDurationDisplayHint)
                $result.Add('ContentMatchQuery', $RuleObject.ContentMatchQuery)
            }

            Write-Verbose -Message "Found RetentionComplianceRule $($Name)"
            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $Policy,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [System.String[]]
        $ExcludedItemClasses,

        [Parameter()]
        [System.String]
        $RetentionDuration,

        [Parameter()]
        [ValidateSet("Days", "Months", "Years")]
        [System.String]
        $RetentionDurationDisplayHint = "Days",

        [Parameter()]
        [System.String]
        $ContentMatchQuery,

        [Parameter()]
        [ValidateSet("CreationAgeInDays", "ModificationAgeInDays")]
        [System.String]
        $ExpirationDateOption,

        [Parameter()]
        [ValidateSet("Delete", "Keep", "KeepAndDelete")]
        [System.String]
        $RetentionComplianceAction,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Write-Verbose -Message "Setting configuration of RetentionComplianceRule for $Name"

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

    $ConnectionMode = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters

    $CurrentRule = Get-TargetResource @PSBoundParameters

    if (('Present' -eq $Ensure) -and ('Absent' -eq $CurrentRule.Ensure))
    {
        $CreationParams = $PSBoundParameters
        $CreationParams.Remove("Credential")
        $CreationParams.Remove("Ensure")

        Write-Verbose -Message "Checking to see if the policy is a Teams based one."
        $RuleObject = Get-RetentionComplianceRule -Identity $Name `
            -ErrorAction SilentlyContinue
        $AssociatedPolicy = Get-RetentionCompliancePolicy $RuleObject.Policy

        if ($AssociatedPolicy.TeamsPolicy)
        {
            Write-Verbose -Message "The current policy is a Teams based one, removing invalid parameters."
            if ($CreationParams.ContainsKey('ApplyComplianceTag'))
            {
                $CreationParams.Remove("ApplyComplianceTag") | Out-Null
            }
            if ($CreationParams.ContainsKey('ContentContainsSensitiveInformation'))
            {
                $CreationParams.Remove("ContentContainsSensitiveInformation") | Out-Null
            }
            if ($CreationParams.ContainsKey('ContentMatchQuery'))
            {
                $CreationParams.Remove("ContentMatchQuery") | Out-Null
            }
            if ($CreationParams.ContainsKey('ExcludedItemClasses'))
            {
                $CreationParams.Remove("ExcludedItemClasses") | Out-Null
            }
            if ($CreationParams.ContainsKey('ExpirationDateOption'))
            {
                $CreationParams.Remove("ExpirationDateOption") | Out-Null
            }
            if ($CreationParams.ContainsKey('PublishComplianceTag'))
            {
                $CreationParams.Remove("PublishComplianceTag") | Out-Null
            }
            if ($CreationParams.ContainsKey('RetentionDurationDisplayHint'))
            {
                $CreationParams.Remove("RetentionDurationDisplayHint") | Out-Null
            }
        }

        New-RetentionComplianceRule @CreationParams
    }
    elseif (('Present' -eq $Ensure) -and ('Present' -eq $CurrentRule.Ensure))
    {
        $CreationParams = $PSBoundParameters
        $CreationParams.Remove("Credential")
        $CreationParams.Remove("Ensure")
        $CreationParams.Remove("Name")
        $CreationParams.Add("Identity", $Name)
        $CreationParams.Remove("Policy")

        Write-Verbose -Message "Checking to see if the policy is a Teams based one."
        $RuleObject = Get-RetentionComplianceRule -Identity $Name `
            -ErrorAction SilentlyContinue
        $AssociatedPolicy = Get-RetentionCompliancePolicy $RuleObject.Policy

        if ($AssociatedPolicy.TeamsPolicy)
        {
            Write-Verbose -Message "The current policy is a Teams based one, removing invalid parameters."

            if ($CreationParams.ContainsKey('ApplyComplianceTag'))
            {
                $CreationParams.Remove("ApplyComplianceTag") | Out-Null
            }
            if ($CreationParams.ContainsKey('ContentContainsSensitiveInformation'))
            {
                $CreationParams.Remove("ContentContainsSensitiveInformation") | Out-Null
            }
            if ($CreationParams.ContainsKey('ContentMatchQuery'))
            {
                $CreationParams.Remove("ContentMatchQuery") | Out-Null
            }
            if ($CreationParams.ContainsKey('ExcludedItemClasses'))
            {
                $CreationParams.Remove("ExcludedItemClasses") | Out-Null
            }
            if ($CreationParams.ContainsKey('ExpirationDateOption'))
            {
                $CreationParams.Remove("ExpirationDateOption") | Out-Null
            }
            if ($CreationParams.ContainsKey('PublishComplianceTag'))
            {
                $CreationParams.Remove("PublishComplianceTag") | Out-Null
            }
            if ($CreationParams.ContainsKey('RetentionDurationDisplayHint'))
            {
                $CreationParams.Remove("RetentionDurationDisplayHint") | Out-Null
            }
        }

        Set-RetentionComplianceRule @CreationParams
    }
    elseif (('Absent' -eq $Ensure) -and ('Present' -eq $CurrentPolicy.Ensure))
    {
        # If the Rule exists and it shouldn't, simply remove it;
        Remove-RetentionComplianceRule -Identity $Name
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $Policy,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [System.String[]]
        $ExcludedItemClasses,

        [Parameter()]
        [System.String]
        $RetentionDuration,

        [Parameter()]
        [ValidateSet("Days", "Months", "Years")]
        [System.String]
        $RetentionDurationDisplayHint = "Days",

        [Parameter()]
        [System.String]
        $ContentMatchQuery,

        [Parameter()]
        [ValidateSet("CreationAgeInDays", "ModificationAgeInDays")]
        [System.String]
        $ExpirationDateOption,

        [Parameter()]
        [ValidateSet("Delete", "Keep", "KeepAndDelete")]
        [System.String]
        $RetentionComplianceAction,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
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

    Write-Verbose -Message "Testing configuration of RetentionComplianceRule for $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null

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

    $ConnectionMode = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

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
        [array]$policies = Get-RetentionCompliancePolicy -ErrorAction Stop

        $j = 1
        $dscContent = ''
        if ($policies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($policy in $policies)
        {
            [array]$rules = Get-RetentionComplianceRule -Policy $policy.Name
            Write-Host "    Policy [$j/$($policies.Length)] $($policy.Name)"
            $i = 1

            foreach ($rule in $rules)
            {
                Write-Host "        |---[$i/$($rules.Length)] $($rule.Name)" -NoNewline

                $Params = @{
                    Credential = $Credential
                    Name               = $rule.Name
                    Policy             = $rule.Policy
                }
                $Results = Get-TargetResource @Params

                if ([System.String]::IsNullOrEmpty($Results.ExpirationDateOption))
                {
                    $Results.Remove("ExpirationDateOption") | Out-Null
                }
                $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                    -Results $Results
                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential
                $dscContent += $currentDSCBlock
                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName
                Write-Host $Global:M365DSCEmojiGreenCheckMark
                $i++
            }
            $j++
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

Export-ModuleMember -Function *-TargetResource
