function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Policy,

        [Parameter()]
        [System.String]
        $Condition,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.UInt32]
        $SamplingRate,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of SupervisoryReviewRule for $Name"
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
        $RuleObjects = Get-SupervisoryReviewRule -ErrorAction Stop
        $RuleObject = $RuleObjects | Where-Object { $_.Name -eq $Name }

        if ($null -eq $RuleObject)
        {
            Write-Verbose -Message "SupervisoryReviewRule $($Name) does not exist."
            return $nullReturn
        }
        else
        {
            Write-Verbose "Found existing SupervisoryReviewRule $($Name)"
            $PolicyName = (Get-SupervisoryReviewPolicyV2 -Identity $RuleObject.Policy).Name

            $result = @{
                Name               = $RuleObject.Name
                Policy             = $PolicyName
                Condition          = $RuleObject.Condition
                SamplingRate       = $RuleObject.SamplingRate
                Ensure             = 'Present'
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Write-Verbose -Message "Found SupervisoryReviewRule $($Name)"
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
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Policy,

        [Parameter()]
        [System.String]
        $Condition,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.UInt32]
        $SamplingRate,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of SupervisoryReviewRule for $Name"
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
        New-SupervisoryReviewRule @CreationParams
    }
    elseif (('Present' -eq $Ensure) -and ('Present' -eq $CurrentRule.Ensure))
    {
        Set-SupervisoryReviewRule -Identity $CurrentRule.Name `
            -Condition $CurrentRule.Condition `
            -SamplingRate $CurrentRule.SamplingRate
    }
    elseif ('Absent' -eq $Ensure)
    {
        throw "The SCSupervisoryReviewRule resource doesn't not support deleting Rules. " + `
            "Instead try removing the associated policy, or modifying the existing rule."
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Policy,

        [Parameter()]
        [System.String]
        $Condition,

        [Parameter()]
        [ValidateRange(0, 100)]
        [System.UInt32]
        $SamplingRate,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of SupervisoryReviewRule for $Name"

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
        [array]$rules = Get-SupervisoryReviewRule -ErrorAction Stop
        $i = 1
        $dscContent = ''
        Write-Host "`r`n" -NoNewLine
        foreach ($rule in $rules)
        {
            Write-Host "    |---[$i/$($rules.Length)] $($rule.Name)" -NoNewLine
            $Params = @{
                GlobalAdminAccount    = $GlobalAdminAccount
                Name                  = $rule.Name
                Policy                = $rule.Policy
            }
            $Results = Get-TargetResource @Params
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
