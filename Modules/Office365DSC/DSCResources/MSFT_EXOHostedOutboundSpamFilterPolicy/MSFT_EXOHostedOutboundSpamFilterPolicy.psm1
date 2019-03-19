function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $Identity = 'Default',

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [System.String[]]
        $BccSuspiciousOutboundAdditionalRecipients = @(),

        [Parameter()]
        [Boolean]
        $BccSuspiciousOutboundMail = $true,

        [Parameter()]
        [System.String[]]
        $NotifyOutboundSpamRecipients = @(),

        [Parameter()]
        [Boolean]
        $NotifyOutboundSpam = $true,

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
        throw "EXOHostedOutboundSpamFilterPolicy configurations MUST specify Ensure value of 'Present'"
    }

    if ('Default' -ne $Identity)
    {
        throw "EXOHostedOutboundSpamFilterPolicy configurations MUST specify Identity value of 'Default'"
    }

    Write-Verbose "Get-TargetResource will attempt to retrieve HostedOutboundSpamFilterPolicy $($Identity)"
    Write-Verbose 'Calling Connect-ExchangeOnline function:'
    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
    Write-Verbose 'Global ExchangeOnlineSession status:'
    Write-Verbose "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object Name -eq 'ExchangeOnline' | Out-String)"
    $CmdletIsAvailable = Confirm-ImportedCmdletIsAvailable -CmdletName 'Get-HostedOutboundSpamFilterPolicy'
    try
    {
        $HostedOutboundSpamFilterPolicies = Get-HostedOutboundSpamFilterPolicy
    }
    catch
    {
        Close-SessionsAndReturnError -ExceptionMessage $_.Exception
    }

    $HostedOutboundSpamFilterPolicy = $HostedOutboundSpamFilterPolicies | Where-Object Identity -eq $Identity
    if (-NOT $HostedOutboundSpamFilterPolicy)
    {
        Write-Verbose "HostedOutboundSpamFilterPolicy $($Identity) does not exist."
        $result = @{
            Ensure             = 'Absent'
            GlobalAdminAccount = $GlobalAdminAccount
            Identity           = $Identity
        }
        return $result
    }
    else
    {
        $result = @{
            Ensure = 'Present'
        }

        foreach ($KeyName in ($PSBoundParameters.Keys | Where-Object {$_ -ne 'Ensure'}) )
        {
            if ($null -ne $HostedOutboundSpamFilterPolicy.$KeyName)
            {
                $result += @{
                    $KeyName = $HostedOutboundSpamFilterPolicy.$KeyName
                }
            }
            else
            {
                $result += @{
                    $KeyName = $PSBoundParameters[$KeyName]
                }
            }
        }

        Write-Verbose "Found HostedOutboundSpamFilterPolicy $($Identity)"
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
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $Identity = 'Default',

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [System.String[]]
        $BccSuspiciousOutboundAdditionalRecipients = @(),

        [Parameter()]
        [Boolean]
        $BccSuspiciousOutboundMail = $true,

        [Parameter()]
        [System.String[]]
        $NotifyOutboundSpamRecipients = @(),

        [Parameter()]
        [Boolean]
        $NotifyOutboundSpam = $true,

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
        throw "EXOHostedOutboundSpamFilterPolicy configurations MUST specify Ensure value of 'Present'"
    }

    if ('Default' -ne $Identity)
    {
        throw "EXOHostedOutboundSpamFilterPolicy configurations MUST specify Identity value of 'Default'"
    }

    Write-Verbose 'Entering Set-TargetResource'
    Write-Verbose 'Calling Connect-ExchangeOnline function:'
    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
    Write-Verbose 'Global ExchangeOnlineSession status:'
    Write-Verbose "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object Name -eq 'ExchangeOnline' | Out-String)"
    $CmdletIsAvailable = Confirm-ImportedCmdletIsAvailable -CmdletName 'Set-HostedOutboundSpamFilterPolicy'
    $HostedOutboundSpamFilterPolicyParams = $PSBoundParameters
    $HostedOutboundSpamFilterPolicyParams.Remove('Ensure') | out-null
    $HostedOutboundSpamFilterPolicyParams.Remove('GlobalAdminAccount') | out-null
    $HostedOutboundSpamFilterPolicyParams.Remove('IsSingleInstance') | out-null
    try
    {
        Write-Verbose "Setting HostedOutboundSpamFilterPolicy $Identity with values: $($HostedOutboundSpamFilterPolicyParams | Out-String)"
        Set-HostedOutboundSpamFilterPolicy @HostedOutboundSpamFilterPolicyParams
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
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $Identity = 'Default',

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [System.String[]]
        $BccSuspiciousOutboundAdditionalRecipients = @(),

        [Parameter()]
        [Boolean]
        $BccSuspiciousOutboundMail = $true,

        [Parameter()]
        [System.String[]]
        $NotifyOutboundSpamRecipients = @(),

        [Parameter()]
        [Boolean]
        $NotifyOutboundSpam = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Write-Verbose -Message "Testing HostedOutboundSpamFilterPolicy for $($Identity)"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    $HostedOutboundSpamFilterPolicyTestParams = $PSBoundParameters
    $HostedOutboundSpamFilterPolicyTestParams.Remove('GlobalAdminAccount') | out-null
    $HostedOutboundSpamFilterPolicyTestParams.Remove('IsSingleInstance') | out-null
    $HostedOutboundSpamFilterPolicyTestParams.Remove('Verbose') | out-null
    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $HostedOutboundSpamFilterPolicyTestParams.Keys
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
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $IsSingleInstance = 'Yes'
    $result = Get-TargetResource @PSBoundParameters
    Write-Verbose 'Closing Remote PowerShell Sessions'
    $ClosedPSSessions = (Get-PSSession | Remove-PSSession)
    $result.GlobalAdminAccount = Resolve-Credentials -UserName $GlobalAdminAccount.UserName
    $content = "        EXOHostedOutboundSpamFilterPolicy " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'GlobalAdminAccount'
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
