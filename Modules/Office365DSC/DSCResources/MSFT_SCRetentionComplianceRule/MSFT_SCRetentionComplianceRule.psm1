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
        [ValidateSet("Delete","Keep","KeepAndDelete")]
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

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
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
        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-O365DscHashtableToString -Hashtable $result)"
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
        [ValidateSet("Delete","Keep","KeepAndDelete")]
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

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
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
        [ValidateSet("Delete","Keep","KeepAndDelete")]
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
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
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
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Policy,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"

    if ([System.String]::IsNullOrEmpty($result.ExpirationDateOption))
    {
        $result.Remove("ExpirationDateOption")
    }

    $content = "        SCRetentionComplianceRule " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
