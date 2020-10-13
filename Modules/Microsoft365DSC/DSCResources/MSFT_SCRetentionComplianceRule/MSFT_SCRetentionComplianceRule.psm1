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
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of RetentionComplianceRule for $Name"
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
            $result = @{
                Name                         = $RuleObject.Name
                Comment                      = $RuleObject.Comment
                Policy                       = $AssociatedPolicy.Name
                ExcludedItemClasses          = $RuleObject.ExcludedItemClasses
                RetentionDuration            = $RuleObject.RetentionDuration
                RetentionDurationDisplayHint = $RuleObject.RetentionDurationDisplayHint
                ContentMatchQuery            = $RuleObject.ContentMatchQuery
                ExpirationDateOption         = $RuleObject.ExpirationDateOption
                RetentionComplianceAction    = $RuleObject.RetentionComplianceAction
                GlobalAdminAccount           = $GlobalAdminAccount
                Ensure                       = 'Present'
            }

            Write-Verbose -Message "Found RetentionComplianceRule $($Name)"
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
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of RetentionComplianceRule for $Name"
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

    $CurrentRule = Get-TargetResource @PSBoundParameters

    if (('Present' -eq $Ensure) -and ('Absent' -eq $CurrentRule.Ensure))
    {
        $CreationParams = $PSBoundParameters
        $CreationParams.Remove("GlobalAdminAccount")
        $CreationParams.Remove("Ensure")
        New-RetentionComplianceRule @CreationParams
    }
    elseif (('Present' -eq $Ensure) -and ('Present' -eq $CurrentRule.Ensure))
    {
        $CreationParams = $PSBoundParameters
        $CreationParams.Remove("GlobalAdminAccount")
        $CreationParams.Remove("Ensure")
        $CreationParams.Remove("Name")
        $CreationParams.Add("Identity", $Name)
        $CreationParams.Remove("Policy")

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
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of RetentionComplianceRule for $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

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

    $ConnectionMode = New-M365DSCConnection -Platform 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

    try
    {
        [array]$policies = Get-RetentionCompliancePolicy -ErrorAction Stop

        $j = 1
        $dscContent = ''
        Write-Host "`r`n" -NoNewLine
        foreach ($policy in $policies)
        {
            [array]$rules = Get-RetentionComplianceRule -Policy $policy.Name
            Write-Host "    Policy [$j/$($policies.Length)] $($policy.Name)"
            $i = 1

            foreach ($rule in $rules)
            {
                Write-Host "        |---[$i/$($rules.Length)] $($rule.Name)" -NoNewLine

                $Params = @{
                    GlobalAdminAccount    = $GlobalAdminAccount
                    Name                  = $rule.Name
                    Policy                = $rule.Policy
                }
                $Results = Get-TargetResource @Params

                if ([System.String]::IsNullOrEmpty($Results.ExpirationDateOption))
                {
                    $Results.Remove("ExpirationDateOption") | Out-Null
                }
                $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                    -Results $Results
                $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -GlobalAdminAccount $GlobalAdminAccount
                Write-Host $Global:M365DSCEmojiGreenCheckMark
                $i++
            }
            $j++
        }
        return $dscContent
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
