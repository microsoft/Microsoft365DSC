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
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [Boolean]
        $EnableSafeList = $false,

        [Parameter()]
        [System.String[]]
        $IPAllowList = @(),

        [Parameter()]
        [System.String[]]
        $IPBlockList = @(),

        [Parameter()]
        [Boolean]
        $MakeDefault = $false,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Write-Verbose "Get-TargetResource will attempt to retrieve HostedConnectionFilterPolicy $($Identity)"
    Write-Verbose "Calling Connect-ExchangeOnline function:"
    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
    Write-Verbose "Global ExchangeOnlineSession status:"
    Write-Verbose "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object Name -eq 'ExchangeOnline' | Out-String)"
    try
    {
        $HostedConnectionFilterPolicys = Get-HostedConnectionFilterPolicy
    }
    catch
    {
        Close-SessionsAndReturnError -ExceptionMessage $_.Exception
    }

    $HostedConnectionFilterPolicy = $HostedConnectionFilterPolicys | Where-Object Identity -eq $Identity
    if (-NOT $HostedConnectionFilterPolicy)
    {
        Write-Verbose "HostedConnectionFilterPolicy $($Identity) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        $result = @{
            Ensure = 'Present'
        }

        foreach ($KeyName in ($PSBoundParameters.Keys | Where-Object {$_ -inotmatch 'Ensure|MakeDefault'}) )
        {
            if ($null -ne $HostedConnectionFilterPolicy.$KeyName)
            {
                $result += @{
                    $KeyName = $HostedConnectionFilterPolicy.$KeyName
                }
            }
            else
            {
                $result += @{
                    $KeyName = $PSBoundParameters[$KeyName]
                }
            }

        }

        if ($AntiPhishRule.IsDefault)
        {
            $result += @{
                MakeDefault = $true
            }
        }
        else
        {
            $result += @{
                MakeDefault = $false
            }
        }

        Write-Verbose "Found HostedConnectionFilterPolicy $($Identity)"
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
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [Boolean]
        $EnableSafeList = $false,

        [Parameter()]
        [System.String[]]
        $IPAllowList = @(),

        [Parameter()]
        [System.String[]]
        $IPBlockList = @(),

        [Parameter()]
        [Boolean]
        $MakeDefault = $false,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Write-Verbose 'Entering Set-TargetResource'
    Write-Verbose 'Retrieving information about HostedConnectionFilterPolicy configuration'
    Write-Verbose "Calling Connect-ExchangeOnline function:"
    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
    Write-Verbose "Global ExchangeOnlineSession status:"
    Write-Verbose "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object Name -eq 'ExchangeOnline' | Out-String)"
    try
    {
        $HostedConnectionFilterPolicys = Get-HostedConnectionFilterPolicy
    }
    catch
    {
        Close-SessionsAndReturnError -ExceptionMessage $_.Exception
    }

    $HostedConnectionFilterPolicy = $HostedConnectionFilterPolicys | Where-Object Identity -eq $Identity
    $HostedConnectionFilterPolicyParams = $PSBoundParameters
    $HostedConnectionFilterPolicyParams.Remove('Ensure') | Out-Null
    $HostedConnectionFilterPolicyParams.Remove('GlobalAdminAccount') | Out-Null
    $HostedConnectionFilterPolicyParams.Remove('MakeDefault') | Out-Null
    if ($HostedConnectionFilterPolicyParams.RuleScope)
    {
        $HostedConnectionFilterPolicyParams += @{
            Scope = $HostedConnectionFilterPolicyParams.RuleScope
        }
        $HostedConnectionFilterPolicyParams.Remove('RuleScope') | Out-Null
    }

    if ( ('Present' -eq $Ensure ) -and (-NOT $HostedConnectionFilterPolicy) )
    {
        try
        {
            $HostedConnectionFilterPolicyParams += @{
                Name = $HostedConnectionFilterPolicyParams.Identity
            }
            $HostedConnectionFilterPolicyParams.Remove('Identity') | Out-Null
            if ($PSBoundParameters.MakeDefault) {
                New-HostedConnectionFilterPolicy @HostedConnectionFilterPolicyParams -MakeDefault -Confirm:$false
            }
            else
            {
                New-HostedConnectionFilterPolicy @HostedConnectionFilterPolicyParams -Confirm:$false
            }
        }
        catch
        {
            Close-SessionsAndReturnError -ExceptionMessage $_.Exception
        }
    }
    elseif ( ('Present' -eq $Ensure ) -and ($HostedConnectionFilterPolicy) )
    {
        try
        {
            if ($PSBoundParameters.MakeDefault) {
                Set-HostedConnectionFilterPolicy @HostedConnectionFilterPolicyParams -MakeDefault -Confirm:$false
            }
            else
            {
                Set-HostedConnectionFilterPolicy @HostedConnectionFilterPolicyParams -Confirm:$false
            }
        }
        catch
        {
            Close-SessionsAndReturnError -ExceptionMessage $_.Exception
        }
    }
    elseif ( ('Absent' -eq $Ensure ) -and ($HostedConnectionFilterPolicy) )
    {
        Write-Verbose "Removing HostedConnectionFilterPolicy $($Identity) "
        try
        {
            Remove-HostedConnectionFilterPolicy -Identity $Identity -Confirm:$false
        }
        catch
        {
            Close-SessionsAndReturnError -ExceptionMessage $_.Exception
        }
    }

    Write-Verbose "Closing Remote PowerShell Sessions"
    $ClosedPSSessions = (Get-PSSession | Remove-PSSession)
    Write-Verbose "Global ExchangeOnlineSession status: `n"
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
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [Boolean]
        $EnableSafeList = $false,

        [Parameter()]
        [System.String[]]
        $IPAllowList = @(),

        [Parameter()]
        [System.String[]]
        $IPBlockList = @(),

        [Parameter()]
        [Boolean]
        $MakeDefault = $false,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Write-Verbose -Message "Testing HostedConnectionFilterPolicy for $($Identity)"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    $HostedConnectionFilterPolicyTestParams = $PSBoundParameters
    $HostedConnectionFilterPolicyTestParams.Remove("GlobalAdminAccount") | out-null
    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $HostedConnectionFilterPolicyTestParams.Keys
    if ($TestResult)
    {
        Write-Verbose "Closing Remote PowerShell Sessions"
        $ClosedPSSessions = (Get-PSSession | Remove-PSSession)
        Write-Verbose "Global ExchangeOnlineSession status: `n"
        Write-Verbose "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object Name -eq 'ExchangeOnline' | Out-String)"
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
    Write-Verbose "Closing Remote PowerShell Sessions"
    $ClosedPSSessions = (Get-PSSession | Remove-PSSession)
    Write-Verbose "Global ExchangeOnlineSession status: `n"
    Write-Verbose "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object Name -eq 'ExchangeOnline' | Out-String)"
    $result.GlobalAdminAccount = Resolve-Credentials -UserName $GlobalAdminAccount.UserName
    $content = "        EXOHostedConnectionFilterPolicy " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
