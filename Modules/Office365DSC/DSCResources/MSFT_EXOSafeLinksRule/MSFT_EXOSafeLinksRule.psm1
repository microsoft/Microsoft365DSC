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
        $SafeLinksPolicy,

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

    Write-Verbose -Message "Setting configuration of SafeLinksRule for $Identity"

    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount

    $SafeLinksRules = Get-SafeLinksRule
    $SafeLinksRule = $SafeLinksRules | Where-Object -FilterScript { $_.Identity -eq $Identity }

    if (-not $SafeLinksRule)
    {
        Write-Verbose -Message "SafeLinksRule $($Identity) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        $result = @{
            Ensure = 'Present'
        }
        foreach ($KeyName in ($PSBoundParameters.Keys | Where-Object -FilterScript { $_ -ne 'Ensure' }))
        {
            if ($null -ne $SafeLinksRule.$KeyName)
            {
                $result += @{
                    $KeyName = $SafeLinksRule.$KeyName
                }
            }
            else
            {
                $result += @{
                    $KeyName = $PSBoundParameters[$KeyName]
                }
            }

        }
        if ('Enabled' -eq $SafeLinksRule.State)
        {
            # Accounts for Get-SafeLinksRule returning 'State' instead of 'Enabled' used by New/Set
            $result.Enabled = $true
        }
        else
        {
            $result.Enabled = $false
        }

        Write-Verbose -Message "Found SafeLinksRule $($Identity)"
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $SafeLinksPolicy,

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

    Write-Verbose -Message "Setting configuration of SafeLinksRule for $Identity"

    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount

    $SafeLinksRules = Get-SafeLinksRule

    $SafeLinksRule = $SafeLinksRules | Where-Object -FilterScript { $_.Identity -eq $Identity }

    if (('Present' -eq $Ensure ) -and (-not $SafeLinksRule))
    {
        New-EXOSafeLinksRule -SafeLinksRuleParams $PSBoundParameters
    }

    if (('Present' -eq $Ensure ) -and ($SafeLinksRule))
    {
        if ($PSBoundParameters.Enabled -and ('Disabled' -eq $SafeLinksRule.State))
        {
            # New-SafeLinksRule has the Enabled parameter, Set-SafeLinksRule does not.
            # There doesn't appear to be any way to change the Enabled state of a rule once created.
            Write-Verbose -Message "Removing SafeLinksRule $($Identity) in order to change Enabled state."
            Remove-SafeLinksRule -Identity $Identity -Confirm:$false
            New-EXOSafeLinksRule -SafeLinksRuleParams $PSBoundParameters
        }
        else
        {
            Set-EXOSafeLinksRule -SafeLinksRuleParams $PSBoundParameters
        }
    }

    if (('Absent' -eq $Ensure ) -and ($SafeLinksRule))
    {
        Write-Verbose -Message "Removing SafeLinksRule $($Identity)"
        Remove-SafeLinksRule -Identity $Identity -Confirm:$false
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
        $SafeLinksPolicy,

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

    Write-Verbose -Message "Testing configuration of SafeLinksRule for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
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
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $SafeLinksPolicy,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        EXOSafeLinksRule " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
