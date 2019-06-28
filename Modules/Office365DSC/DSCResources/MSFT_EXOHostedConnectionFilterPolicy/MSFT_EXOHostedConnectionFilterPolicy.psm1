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

    Write-Verbose -Message "Setting configuration of HostedConnectionFilterPolicy for $Identity"

    Write-Verbose -Message "Calling Connect-ExchangeOnline function:"
    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount

    Write-Verbose -Message "Global ExchangeOnlineSession status:"
    Write-Verbose -Message "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object -FilterScript { $_.Name -eq 'ExchangeOnline' } | Out-String)"

    try
    {
        $HostedConnectionFilterPolicys = Get-HostedConnectionFilterPolicy
    }
    catch
    {
        Close-SessionsAndReturnError -ExceptionMessage $_.Exception
        $Message = "Error calling {Get-HostedConnectionFilterPolicy}"
        New-Office365DSCLogEntry -Error $_ -Message $Message
    }

    $HostedConnectionFilterPolicy = $HostedConnectionFilterPolicys | Where-Object -FilterScript { $_. Identity -eq $Identity }
    if (-not $HostedConnectionFilterPolicy)
    {
        Write-Verbose -Message "HostedConnectionFilterPolicy $($Identity) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        $result = @{
            Ensure = 'Present'
        }

        foreach ($KeyName in ($PSBoundParameters.Keys | Where-Object -FilterScript { $_ -inotmatch 'Ensure|MakeDefault' }))
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

        Write-Verbose -Message "Found HostedConnectionFilterPolicy $($Identity)"
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

    Write-Verbose -Message "Setting configuration of HostedConnectionFilterPolicy for $Identity"

    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount

    $HostedConnectionFilterPolicys = Get-HostedConnectionFilterPolicy

    $HostedConnectionFilterPolicy = $HostedConnectionFilterPolicys | Where-Object -FilterScript { $_.Identity -eq $Identity }

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

    if (('Present' -eq $Ensure ) -and ($null -eq $HostedConnectionFilterPolicy))
    {
        $HostedConnectionFilterPolicyParams += @{
            Name = $HostedConnectionFilterPolicyParams.Identity
        }
        $HostedConnectionFilterPolicyParams.Remove('Identity') | Out-Null
        if ($PSBoundParameters.MakeDefault)
        {
            New-HostedConnectionFilterPolicy @HostedConnectionFilterPolicyParams -MakeDefault
        }
        else
        {
            New-HostedConnectionFilterPolicy @HostedConnectionFilterPolicyParams
        }
    }
    elseif (('Present' -eq $Ensure ) -and ($HostedConnectionFilterPolicy))
    {
        if ($PSBoundParameters.MakeDefault)
        {
            Set-HostedConnectionFilterPolicy @HostedConnectionFilterPolicyParams -MakeDefault -Confirm:$false
        }
        else
        {
            Set-HostedConnectionFilterPolicy @HostedConnectionFilterPolicyParams -Confirm:$false
        }
    }
    elseif (('Absent' -eq $Ensure ) -and ($HostedConnectionFilterPolicy))
    {
        Write-Verbose -Message "Removing HostedConnectionFilterPolicy $($Identity) "
        Remove-HostedConnectionFilterPolicy -Identity $Identity -Confirm:$false
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

    Write-Verbose -Message "Testing configuration of HostedConnectionFilterPolicy for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    $ValuesToCheck.Remove('IsSingleInstance') | Out-Null
    $ValuesToCheck.Remove('Verbose') | Out-Null

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
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        EXOHostedConnectionFilterPolicy " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
