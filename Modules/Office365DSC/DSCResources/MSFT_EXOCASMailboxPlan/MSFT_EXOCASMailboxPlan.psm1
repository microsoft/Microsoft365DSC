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
    Write-Verbose 'Calling Connect-ExchangeOnline function:'
    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount -CommandsToImport '*CASMailboxPlan'
    Write-Verbose 'Global ExchangeOnlineSession status:'
    Write-Verbose "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object Name -eq 'ExchangeOnline' | Out-String)"
    $CmdletIsAvailable = Confirm-ImportedCmdletIsAvailable -CmdletName 'Get-CASMailboxPlan'
    try
    {
        $CASMailboxPlans = Get-CASMailboxPlan
    }
    catch
    {
        Close-SessionsAndReturnError -ExceptionMessage $_.Exception
    }

    $CASMailboxPlan = $CASMailboxPlans | Where-Object Identity -eq $Identity
    if (-NOT $CASMailboxPlan)
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

    Write-Verbose 'Entering Set-TargetResource'
    Write-Verbose 'Calling Connect-ExchangeOnline function:'
    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount -CommandsToImport '*CASMailboxPlan'
    Write-Verbose 'Global ExchangeOnlineSession status:'
    Write-Verbose "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object Name -eq 'ExchangeOnline' | Out-String)"
    $CmdletIsAvailable = Confirm-ImportedCmdletIsAvailable -CmdletName 'Set-CASMailboxPlan'
    $CASMailboxPlanParams = $PSBoundParameters
    $CASMailboxPlanParams.Remove('Ensure') | out-null
    $CASMailboxPlanParams.Remove('GlobalAdminAccount') | out-null
    try
    {
        Write-Verbose "Setting CASMailboxPlan $Identity with values: $($CASMailboxPlanParams | Out-String)"
        Set-CASMailboxPlan @CASMailboxPlanParams
    }
    catch
    {
        Close-SessionsAndReturnError -ExceptionMessage $_.Exception
    }

    Write-Verbose 'Closing Remote PowerShell Sessions'
    $ClosedPSSessions = (Get-PSSession | Remove-PSSession)
    Write-Verbose 'Global ExchangeOnlineSession status: '
    Write-Verbose "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object Name -eq 'ExchangeOnline' | Out-String)"
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
        Write-Verbose 'Closing Remote PowerShell Sessions'
        $ClosedPSSessions = (Get-PSSession | Remove-PSSession)
        Write-Verbose 'Global ExchangeOnlineSession status: '
        Write-Verbose "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object Name -eq 'ExchangeOnline' | Out-String)"
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
    Write-Verbose 'Closing Remote PowerShell Sessions'
    $ClosedPSSessions = (Get-PSSession | Remove-PSSession)
    $result.GlobalAdminAccount = Resolve-Credentials -UserName $GlobalAdminAccount.UserName
    $content = "        EXOCASMailboxPlan " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'GlobalAdminAccount'
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
