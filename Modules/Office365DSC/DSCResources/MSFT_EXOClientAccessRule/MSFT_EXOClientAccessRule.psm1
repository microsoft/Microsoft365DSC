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
        [ValidateSet('AllowAccess', 'DenyAccess')]
        [System.String]
        $Action,

        [Parameter()]
        [ValidateSet('AdfsAuthentication', 'BasicAuthentication', 'CertificateBasedAuthentication', 'NonBasicAuthentication', 'OAuthAuthentication')]
        [System.String[]]
        $AnyOfAuthenticationTypes = @(),

        [Parameter()]
        [System.String[]]
        $AnyOfClientIPAddressesOrRanges = @(),

        [Parameter()]
        [ValidateSet('ExchangeActiveSync','ExchangeAdminCenter','ExchangeWebServices','IMAP4','OfflineAddressBook','OutlookAnywhere','OutlookWebApp','POP3','PowerShellWebServices','RemotePowerShell','REST','UniversalOutlook')]
        [System.String[]]
        $AnyOfProtocols = @(),

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [ValidateSet('AdfsAuthentication', 'BasicAuthentication', 'CertificateBasedAuthentication', 'NonBasicAuthentication', 'OAuthAuthentication')]
        [System.String[]]
        $ExceptAnyOfAuthenticationTypes = @(),

        [Parameter()]
        [System.String[]]
        $ExceptAnyOfClientIPAddressesOrRanges = @(),

        [Parameter()]
        [ValidateSet('ExchangeActiveSync','ExchangeAdminCenter','ExchangeWebServices','IMAP4','OfflineAddressBook','OutlookAnywhere','OutlookWebApp','POP3','PowerShellWebServices','RemotePowerShell','REST','UniversalOutlook')]
        [System.String[]]
        $ExceptAnyOfProtocols = @(),

        [Parameter()]
        [System.String[]]
        $ExceptUsernameMatchesAnyOfPatterns = @(),

        [Parameter()]
        [uint32]
        $Priority,

        [Parameter()]
        [ValidateSet('All', 'Users')]
        [System.String]
        $RuleScope,

        [Parameter()]
        [System.String]
        $UserRecipientFilter,

        [Parameter()]
        [System.String[]]
        $UsernameMatchesAnyOfPatterns = @(),

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Write-Verbose "Get-TargetResource will attempt to retrieve ClientAccessRule $($Identity)"
    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
    $ClientAccessRules = Get-ClientAccessRule

    $ClientAccessRule = $ClientAccessRules | Where-Object Identity -eq $Identity
    if (-NOT $ClientAccessRule)
    {
        Write-Verbose "ClientAccessRule $($Identity) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        $result = @{
            Ensure = 'Present'
        }

        $PSBoundParameters += @{
            Scope = $RuleScope
        }

        foreach ($KeyName in ($PSBoundParameters.Keys | Where-Object {$_ -ne 'Ensure'}) )
        {
            if ($null -ne $ClientAccessRule.$KeyName)
            {
                $result += @{
                    $KeyName = $ClientAccessRule.$KeyName
                }
            }
            else
            {
                $result += @{
                    $KeyName = $PSBoundParameters[$KeyName]
                }
            }

        }

        $result.Remove('Scope') | Out-Null
        Write-Verbose "Found ClientAccessRule $($Identity)"
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
        [ValidateSet('AllowAccess', 'DenyAccess')]
        [System.String]
        $Action,

        [Parameter()]
        [ValidateSet('AdfsAuthentication', 'BasicAuthentication', 'CertificateBasedAuthentication', 'NonBasicAuthentication', 'OAuthAuthentication')]
        [System.String[]]
        $AnyOfAuthenticationTypes = @(),

        [Parameter()]
        [System.String[]]
        $AnyOfClientIPAddressesOrRanges = @(),

        [Parameter()]
        [ValidateSet('ExchangeActiveSync','ExchangeAdminCenter','ExchangeWebServices','IMAP4','OfflineAddressBook','OutlookAnywhere','OutlookWebApp','POP3','PowerShellWebServices','RemotePowerShell','REST','UniversalOutlook')]
        [System.String[]]
        $AnyOfProtocols = @(),

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [ValidateSet('AdfsAuthentication', 'BasicAuthentication', 'CertificateBasedAuthentication', 'NonBasicAuthentication', 'OAuthAuthentication')]
        [System.String[]]
        $ExceptAnyOfAuthenticationTypes = @(),

        [Parameter()]
        [System.String[]]
        $ExceptAnyOfClientIPAddressesOrRanges = @(),

        [Parameter()]
        [ValidateSet('ExchangeActiveSync','ExchangeAdminCenter','ExchangeWebServices','IMAP4','OfflineAddressBook','OutlookAnywhere','OutlookWebApp','POP3','PowerShellWebServices','RemotePowerShell','REST','UniversalOutlook')]
        [System.String[]]
        $ExceptAnyOfProtocols = @(),

        [Parameter()]
        [System.String[]]
        $ExceptUsernameMatchesAnyOfPatterns = @(),

        [Parameter()]
        [uint32]
        $Priority,

        [Parameter()]
        [ValidateSet('All', 'Users')]
        [System.String]
        $RuleScope,

        [Parameter()]
        [System.String]
        $UserRecipientFilter,

        [Parameter()]
        [System.String[]]
        $UsernameMatchesAnyOfPatterns = @(),

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Write-Verbose 'Entering Set-TargetResource'
    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
    $ClientAccessRules = Get-ClientAccessRule

    $ClientAccessRule = $ClientAccessRules | Where-Object {$_.Identity -eq $Identity}
    $ClientAccessRuleParams = $PSBoundParameters
    $ClientAccessRuleParams.Remove('Ensure') | Out-Null
    $ClientAccessRuleParams.Remove('GlobalAdminAccount') | Out-Null
    if ($ClientAccessRuleParams.RuleScope)
    {
        $ClientAccessRuleParams += @{
            Scope = $ClientAccessRuleParams.RuleScope
        }
        $ClientAccessRuleParams.Remove('RuleScope') | Out-Null
    }

    if ( ('Present' -eq $Ensure ) -and ($null -eq $ClientAccessRule) )
    {
        Write-Verbose "Creating ClientAccessRule $($Identity)."
        $ClientAccessRuleParams.Add("Name", $Identity)
        $ClientAccessRuleParams.Remove('Identity') | Out-Null
        New-ClientAccessRule @ClientAccessRuleParams
    }
    elseif ( ('Present' -eq $Ensure ) -and ($Null -ne $ClientAccessRule) )
    {
        Write-Verbose "Setting ClientAccessRule $($Identity) with values: $($ClientAccessRuleParams | Out-String)"
        Set-ClientAccessRule @ClientAccessRuleParams -Confirm:$false
    }
    elseif ( ('Absent' -eq $Ensure ) -and ($null -ne $ClientAccessRule) )
    {
        Write-Verbose "Removing ClientAccessRule $($Identity)"
        Remove-ClientAccessRule -Identity $Identity -Confirm:$false
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
        [ValidateSet('AllowAccess', 'DenyAccess')]
        [System.String]
        $Action,

        [Parameter()]
        [ValidateSet('AdfsAuthentication', 'BasicAuthentication', 'CertificateBasedAuthentication', 'NonBasicAuthentication', 'OAuthAuthentication')]
        [System.String[]]
        $AnyOfAuthenticationTypes = @(),

        [Parameter()]
        [System.String[]]
        $AnyOfClientIPAddressesOrRanges = @(),

        [Parameter()]
        [ValidateSet('ExchangeActiveSync','ExchangeAdminCenter','ExchangeWebServices','IMAP4','OfflineAddressBook','OutlookAnywhere','OutlookWebApp','POP3','PowerShellWebServices','RemotePowerShell','REST','UniversalOutlook')]
        [System.String[]]
        $AnyOfProtocols = @(),

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [ValidateSet('AdfsAuthentication', 'BasicAuthentication', 'CertificateBasedAuthentication', 'NonBasicAuthentication', 'OAuthAuthentication')]
        [System.String[]]
        $ExceptAnyOfAuthenticationTypes = @(),

        [Parameter()]
        [System.String[]]
        $ExceptAnyOfClientIPAddressesOrRanges = @(),

        [Parameter()]
        [ValidateSet('ExchangeActiveSync','ExchangeAdminCenter','ExchangeWebServices','IMAP4','OfflineAddressBook','OutlookAnywhere','OutlookWebApp','POP3','PowerShellWebServices','RemotePowerShell','REST','UniversalOutlook')]
        [System.String[]]
        $ExceptAnyOfProtocols = @(),

        [Parameter()]
        [System.String[]]
        $ExceptUsernameMatchesAnyOfPatterns = @(),

        [Parameter()]
        [uint32]
        $Priority,

        [Parameter()]
        [ValidateSet('All', 'Users')]
        [System.String]
        $RuleScope,

        [Parameter()]
        [System.String]
        $UserRecipientFilter,

        [Parameter()]
        [System.String[]]
        $UsernameMatchesAnyOfPatterns = @(),

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Write-Verbose -Message "Testing ClientAccessRule for $($Identity)"
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
        [ValidateSet('AllowAccess', 'DenyAccess')]
        [System.String]
        $Action,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName $GlobalAdminAccount.UserName
    $content = "        EXOClientAccessRule " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
