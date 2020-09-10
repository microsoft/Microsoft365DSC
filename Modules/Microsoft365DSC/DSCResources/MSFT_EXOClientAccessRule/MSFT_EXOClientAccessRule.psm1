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
        [ValidateSet('ExchangeActiveSync', 'ExchangeAdminCenter', 'ExchangeWebServices', 'IMAP4', 'OfflineAddressBook', 'OutlookAnywhere', 'OutlookWebApp', 'POP3', 'PowerShellWebServices', 'RemotePowerShell', 'REST', 'UniversalOutlook')]
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
        [ValidateSet('ExchangeActiveSync', 'ExchangeAdminCenter', 'ExchangeWebServices', 'IMAP4', 'OfflineAddressBook', 'OutlookAnywhere', 'OutlookWebApp', 'POP3', 'PowerShellWebServices', 'RemotePowerShell', 'REST', 'UniversalOutlook')]
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

    Write-Verbose -Message "Getting configuration of ClientAccessRule for $Identity"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline


    $ClientAccessRules = Get-ClientAccessRule

    $ClientAccessRule = $ClientAccessRules | Where-Object -FilterScript { $_.Identity -eq $Identity }
    if (-not $ClientAccessRule)
    {
        Write-Verbose -Message "ClientAccessRule $($Identity) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        $result = @{
            Identity                             = $Identity
            Action                               = $ClientAccessRule.Action
            AnyOfAuthenticationTypes             = $ClientAccessRule.AnyOfAuthenticationTypes
            AnyOfClientIPAddressesOrRanges       = $ClientAccessRule.AnyOfClientIPAddressesOrRanges
            AnyOfProtocols                       = $ClientAccessRule.AnyOfProtocols
            Enabled                              = $ClientAccessRule.Enabled
            ExceptAnyOfAuthenticationTypes       = $ClientAccessRule.ExceptAnyOfAuthenticationTypes
            ExceptAnyOfClientIPAddressesOrRanges = $ClientAccessRule.ExceptAnyOfClientIPAddressesOrRanges
            ExceptAnyOfProtocols                 = $ClientAccessRule.ExceptAnyOfProtocols
            ExceptUsernameMatchesAnyOfPatterns   = $ClientAccessRule.ExceptUsernameMatchesAnyOfPatterns
            Priority                             = $ClientAccessRule.Priority
            UserRecipientFilter                  = $ClientAccessRule.UserRecipientFilter
            UsernameMatchesAnyOfPatterns         = $ClientAccessRule.UsernameMatchesAnyOfPatterns
            Ensure                               = 'Present'
            GlobalAdminAccount                   = $GlobalAdminAccount
        }

        if (-not [System.String]::IsNullOrEmpty($ClientAccessRule.RuleScope))
        {
            $result.Add("RuleScope", $ClientAccessRule.RuleScope)
        }

        Write-Verbose -Message "Found ClientAccessRule $($Identity)"
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
        [ValidateSet('ExchangeActiveSync', 'ExchangeAdminCenter', 'ExchangeWebServices', 'IMAP4', 'OfflineAddressBook', 'OutlookAnywhere', 'OutlookWebApp', 'POP3', 'PowerShellWebServices', 'RemotePowerShell', 'REST', 'UniversalOutlook')]
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
        [ValidateSet('ExchangeActiveSync', 'ExchangeAdminCenter', 'ExchangeWebServices', 'IMAP4', 'OfflineAddressBook', 'OutlookAnywhere', 'OutlookWebApp', 'POP3', 'PowerShellWebServices', 'RemotePowerShell', 'REST', 'UniversalOutlook')]
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

    Write-Verbose -Message "Setting configuration of ClientAccessRule for $Identity"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline


    $ClientAccessRules = Get-ClientAccessRule

    $ClientAccessRule = $ClientAccessRules | Where-Object -FilterScript { $_.Identity -eq $Identity }
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

    if (('Present' -eq $Ensure ) -and ($null -eq $ClientAccessRule))
    {
        Write-Verbose -Message "Creating ClientAccessRule $($Identity)."
        $ClientAccessRuleParams.Add("Name", $Identity)
        $ClientAccessRuleParams.Remove('Identity') | Out-Null
        New-ClientAccessRule @ClientAccessRuleParams
    }
    elseif (('Present' -eq $Ensure ) -and ($Null -ne $ClientAccessRule))
    {
        Write-Verbose -Message "Setting ClientAccessRule $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $ClientAccessRuleParams)"
        Set-ClientAccessRule @ClientAccessRuleParams -Confirm:$false
    }
    elseif (('Absent' -eq $Ensure ) -and ($null -ne $ClientAccessRule))
    {
        Write-Verbose -Message "Removing ClientAccessRule $($Identity)"
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
        [ValidateSet('ExchangeActiveSync', 'ExchangeAdminCenter', 'ExchangeWebServices', 'IMAP4', 'OfflineAddressBook', 'OutlookAnywhere', 'OutlookWebApp', 'POP3', 'PowerShellWebServices', 'RemotePowerShell', 'REST', 'UniversalOutlook')]
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
        [ValidateSet('ExchangeActiveSync', 'ExchangeAdminCenter', 'ExchangeWebServices', 'IMAP4', 'OfflineAddressBook', 'OutlookAnywhere', 'OutlookWebApp', 'POP3', 'PowerShellWebServices', 'RemotePowerShell', 'REST', 'UniversalOutlook')]
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

    Write-Verbose -Message "Testing configuration of ClientAccessRule for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
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
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    if (Confirm-ImportedCmdletIsAvailable -CmdletName Get-ClientAccessRule)
    {
        $ClientAccessRules = Get-ClientAccessRule

        $content = ""
        foreach ($ClientAccessRule in $ClientAccessRules)
        {
            $params = @{
                Identity           = $ClientAccessRule.Identity
                Action             = $ClientAccessRule.Action
                GlobalAdminAccount = $GlobalAdminAccount
            }
            $result = Get-TargetResource @params
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
            $content += "        EXOClientAccessRule " + (New-GUID).ToString() + "`r`n"
            $content += "        {`r`n"
            $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
            $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
            $content += "        }`r`n"
        }
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
