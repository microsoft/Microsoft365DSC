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
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform SecurityComplianceCenter

    $RuleObject = Get-RetentionComplianceRule -Identity $Name -ErrorAction SilentlyContinue

    if ($null -eq $RuleObject)
    {
        Write-Verbose -Message "RetentionComplianceRule $($Name) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
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
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform SecurityComplianceCenter

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

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform SecurityComplianceCenter `
        -ErrorAction SilentlyContinue

    $organization = ""
    $principal = "" # Principal represents the "NetBios" name of the tenant (e.g. the M365DSC part of M365DSC.onmicrosoft.com)
    if ($GlobalAdminAccount.UserName.Contains("@"))
    {
        $organization = $GlobalAdminAccount.UserName.Split("@")[1]

        if ($organization.IndexOf(".") -gt 0)
        {
            $principal = $organization.Split(".")[0]
        }
    }
    $policies = Get-RetentionCompliancePolicy

    $j = 1
    $content = ''
    $policiesLength = $policies.Length
    if ($null -eq $policiesLength)
    {
        $policiesLength = 1
    }
    foreach ($policy in $policies)
    {
        $rules = Get-RetentionComplianceRule -Policy $policy.Name
        Write-Information "    Policy [$j/$($policiesLength)] $($policy.Name)"
        $i = 1
        $rulesLength = $rules.Length
        if ($null -eq $rulesLength)
        {
            $rulesLength = 1
        }
        foreach ($rule in $rules)
        {
            Write-Information "        [$i/$($rulesLength)] $($rule.Name)"
            $params = @{
                GlobalAdminAccount = $GlobalAdminAccount
                Name               = $rule.Name
                Policy             = $rule.Policy
            }
            $result = Get-TargetResource @params
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"

            if ([System.String]::IsNullOrEmpty($result.ExpirationDateOption))
            {
                $result.Remove("ExpirationDateOption")
            }

            $content += "        SCRetentionComplianceRule " + (New-GUID).ToString() + "`r`n"
            $content += "        {`r`n"
            $partialContent = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
            $partialContent = Convert-DSCStringParamToVariable -DSCBlock $partialContent -ParameterName "GlobalAdminAccount"
            if ($partialContent.ToLower().Contains($organization.ToLower()) -or `
                    $partialContent.ToLower().Contains($principal.ToLower()))
            {
                $partialContent = $partialContent -ireplace [regex]::Escape("@" + $organization), "@`$(`$OrganizationName)"
            }
            $content += $partialContent
            $content += "        }`r`n"
            $i++
        }
        $j++
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
