function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1,64)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Policy,

        [Parameter()]
        [System.String]
        $Condition,

        [Parameter()]
        [ValidateRange(0,100)]
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

    Write-Verbose -Message "Calling Test-SecurityAndComplianceConnection function:"
    Test-SecurityAndComplianceConnection -GlobalAdminAccount $GlobalAdminAccount

    $RuleObjects = Get-SupervisoryReviewRule
    $RuleObject = $RuleObjects | Where-Object {$_.Name -eq $Name}

    if ($null -eq $RuleObject)
    {
        Write-Verbose -Message "SupervisoryReviewRule $($Name) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
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
        [ValidateLength(1,64)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Policy,

        [Parameter()]
        [System.String]
        $Condition,

        [Parameter()]
        [ValidateRange(0,100)]
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

    Test-SecurityAndComplianceConnection -GlobalAdminAccount $GlobalAdminAccount
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
        [ValidateLength(1,64)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Policy,

        [Parameter()]
        [System.String]
        $Condition,

        [Parameter()]
        [ValidateRange(0,100)]
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
        [ValidateLength(1,64)]
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
    $content = "        SCSupervisoryReviewRule " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
