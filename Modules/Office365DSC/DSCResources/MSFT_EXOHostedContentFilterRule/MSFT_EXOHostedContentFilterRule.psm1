function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $HostedContentFilterPolicy,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentTo = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentToMemberOf = @(),

        [Parameter()]
        [uint32]
        $Priority,

        [Parameter()]
        [System.String[]]
        $RecipientDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $SentTo = @(),

        [Parameter()]
        [System.String[]]
        $SentToMemberOf = @(),

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Write-Verbose "Get-TargetResource will attempt to retrieve HostedContentFilterRule $($Identity)"
    Write-Verbose "Calling Connect-ExchangeOnline function:"
    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
    Write-Verbose "Global ExchangeOnlineSession status:"
    Write-Verbose "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object Name -eq 'ExchangeOnline' | Out-String)"
    try
    {
        $HostedContentFilterRules = Get-HostedContentFilterRule
    }
    catch
    {
        Close-SessionsAndReturnError -ExceptionMessage $_.Exception
    }
    $HostedContentFilterRule = $HostedContentFilterRules | Where-Object Identity -eq $Identity
    if (-NOT $HostedContentFilterRule)
    {
        Write-Verbose "HostedContentFilterRule $($Identity) does not exist."
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
            if ($null -ne $HostedContentFilterRule.$KeyName)
            {
                $result += @{
                    $KeyName = $HostedContentFilterRule.$KeyName
                }
            }
            else
            {
                $result += @{
                    $KeyName = $PSBoundParameters[$KeyName]
                }
            }

        }
        if ('Enabled' -eq $HostedContentFilterRule.State)
        {
            # Accounts for Get-HostedContentFilterRule returning 'State' instead of 'Enabled' used by New/Set
            $result.Enabled = $true
        }
        else
        {
            $result.Enabled = $false
        }

        Write-Verbose "Found HostedContentFilterRule $($Identity)"
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $HostedContentFilterPolicy,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentTo = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentToMemberOf = @(),

        [Parameter()]
        [uint32]
        $Priority,

        [Parameter()]
        [System.String[]]
        $RecipientDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $SentTo = @(),

        [Parameter()]
        [System.String[]]
        $SentToMemberOf = @(),

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Write-Verbose 'Entering Set-TargetResource'
    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
    Write-Verbose "Global ExchangeOnlineSession status:"
    Write-Verbose "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object Name -eq 'ExchangeOnline' | Out-String)"
    $HostedContentFilterRules = Get-HostedContentFilterRule
    $HostedContentFilterRule = $HostedContentFilterRules | Where-Object {$_.Identity -eq $Identity}

    if ( ('Present' -eq $Ensure ) -and (-NOT $HostedContentFilterRule) )
    {
        New-EXOHostedContentFilterRule -HostedContentFilterRuleParams $PSBoundParameters
    }

    if ( ('Present' -eq $Ensure ) -and ($HostedContentFilterRule) )
    {
        if ($PSBoundParameters.Enabled -and ('Disabled' -eq $HostedContentFilterRule.State) )
        {
             # New-HostedContentFilterRule has the Enabled parameter, Set-HostedContentFilterRule does not.
            # There doesn't appear to be any way to change the Enabled state of a rule once created.
            Write-Verbose "Removing HostedContentFilterRule $($Identity) in order to change Enabled state."
            Remove-HostedContentFilterRule -Identity $Identity -Confirm:$false
            New-EXOHostedContentFilterRule -HostedContentFilterRuleParams $PSBoundParameters
        }
        else
        {
            Set-EXOHostedContentFilterRule -HostedContentFilterRuleParams $PSBoundParameters
        }
    }

    if ( ('Absent' -eq $Ensure ) -and ($HostedContentFilterRule) )
    {
        Write-Verbose "Removing HostedContentFilterRule $($Identity) "
        Remove-HostedContentFilterRule -Identity $Identity -Confirm:$false
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $HostedContentFilterPolicy,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentTo = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentToMemberOf = @(),

        [Parameter()]
        [uint32]
        $Priority,

        [Parameter()]
        [System.String[]]
        $RecipientDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $SentTo = @(),

        [Parameter()]
        [System.String[]]
        $SentToMemberOf = @(),

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Write-Verbose -Message "Testing HostedContentFilterRule for $($Identity)"
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
        [System.String]
        $HostedContentFilterPolicy,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        EXOHostedContentFilterRule " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
