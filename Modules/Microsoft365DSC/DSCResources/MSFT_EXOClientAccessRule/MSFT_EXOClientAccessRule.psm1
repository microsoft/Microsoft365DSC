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

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword
    )

    Write-Verbose -Message "Getting configuration of ClientAccessRule for $Identity"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'
    try
    {
        $ClientAccessRules = Get-ClientAccessRule -ErrorAction Stop

        $ClientAccessRule = $ClientAccessRules | Where-Object -FilterScript { $_.Identity -eq $Identity }
        if (-not $ClientAccessRule)
        {
            Write-Verbose -Message "ClientAccessRule $($Identity) does not exist."
            return $nullReturn
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
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return $nullReturn
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

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword
    )

    Write-Verbose -Message "Setting configuration of ClientAccessRule for $Identity"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters
    }

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

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword
    )

    Write-Verbose -Message "Testing configuration of ClientAccessRule for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
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
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

    $dscContent = ""
    try
    {
        if (Confirm-ImportedCmdletIsAvailable -CmdletName Get-ClientAccessRule)
        {
            [array]$ClientAccessRules = Get-ClientAccessRule -ErrorAction Stop
            $i = 1
            if ($ClientAccessRules.Length -eq 0)
            {
                Write-Host $Global:M365DSCEmojiGreenCheckMark
            }
            else
            {
                Write-Host "`r`n" -NoNewLine
            }
            foreach ($ClientAccessRule in $ClientAccessRules)
            {
                Write-Host "    |---[$i/$($ClientAccessRules.Length)] $($ClientAccessRule.Identity)" -NoNewLine
                $Params = @{
                    Identity              = $ClientAccessRule.Identity
                    Action                = $ClientAccessRule.Action
                    GlobalAdminAccount    = $GlobalAdminAccount
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    CertificatePassword   = $CertificatePassword
                    CertificatePath       = $CertificatePath
                }
                $Results = Get-TargetResource @Params
                $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                    -Results $Results
                $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -GlobalAdminAccount $GlobalAdminAccount
                Write-Host $Global:M365DSCEmojiGreenCheckMark
                $i++
            }
        }
        else
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        return $dscContent
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
