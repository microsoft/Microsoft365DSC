function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [Boolean]
        $ActiveSyncEnabled = $true,

        [Parameter()]
        [Boolean]
        $ImapEnabled = $false,

        [Parameter()]
        [System.String]
        $OwaMailboxPolicy = 'OwaMailboxPolicy-Default',

        [Parameter()]
        [Boolean]
        $PopEnabled = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    if ('Absent' -eq $Ensure)
    {
        throw "EXOCASMailboxPlan configurations MUST specify Ensure value of 'Present'"
    }

    Write-Verbose "Get-TargetResource will attempt to retrieve CASMailboxPlan $($Identity)"
    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
    $CASMailboxPlans = Get-CASMailboxPlan

    $CASMailboxPlan = $CASMailboxPlans | Where-Object {$_.Identity -eq $Identity}
    if ($null -eq $CASMailboxPlan)
    {
        Write-Verbose "CASMailboxPlan $($Identity) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        $result = @{
            Ensure = 'Present'
        }

        foreach ($KeyName in ($PSBoundParameters.Keys | Where-Object {$_ -ne 'Ensure'}) )
        {
            if ($null -ne $CASMailboxPlan.$KeyName)
            {
                $result += @{
                    $KeyName = $CASMailboxPlan.$KeyName
                }
            }
            else
            {
                $result += @{
                    $KeyName = $PSBoundParameters[$KeyName]
                }
            }
        }

        Write-Verbose "Found CASMailboxPlan $($Identity)"
        Write-Verbose "Get-TargetResource Result: `n $($result | Out-String)"
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
        $Identity,

        [Parameter()]
        [Boolean]
        $ActiveSyncEnabled = $true,

        [Parameter()]
        [Boolean]
        $ImapEnabled = $false,

        [Parameter()]
        [System.String]
        $OwaMailboxPolicy = 'OwaMailboxPolicy-Default',

        [Parameter()]
        [Boolean]
        $PopEnabled = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    if ('Absent' -eq $Ensure)
    {
        throw "EXOCASMailboxPlan configurations MUST specify Ensure value of 'Present'"
    }

    Write-Verbose 'Entering Set-TargetResource'
    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
    $CASMailboxPlanParams = $PSBoundParameters
    $CASMailboxPlanParams.Remove('Ensure') | out-null
    $CASMailboxPlanParams.Remove('GlobalAdminAccount') | out-null

    $CASMailboxPlans = Get-CASMailboxPlan
    $CASMailboxPlan = $CASMailboxPlans | Where-Object {$_.Identity -eq $Identity}

    if ($null -ne $CASMailboxPlan)
    {
        Write-Verbose "Setting CASMailboxPlan $Identity with values: $($CASMailboxPlanParams | Out-String)"
        Set-CASMailboxPlan @CASMailboxPlanParams
    }
    else
    {
        throw "The specified CAS Mailbox Plan {$($Identity)} doesn't exist"
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
        $Identity,

        [Parameter()]
        [Boolean]
        $ActiveSyncEnabled = $true,

        [Parameter()]
        [Boolean]
        $ImapEnabled = $false,

        [Parameter()]
        [System.String]
        $OwaMailboxPolicy = 'OwaMailboxPolicy-Default',

        [Parameter()]
        [Boolean]
        $PopEnabled = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Write-Verbose -Message "Testing CASMailboxPlan for $($Identity)"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | out-null
    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys
    if ($TestResult)
    {
        Write-Verbose 'Test-TargetResource returned True'
    }
    else
    {
        Write-Verbose 'Test-TargetResource returned False'
    }

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
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        EXOCASMailboxPlan " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'GlobalAdminAccount'
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
