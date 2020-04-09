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
        [ValidateSet('Present')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of HostedOutboundSpamFilterPolicy for $Identity"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $HostedOutboundSpamFilterPolicies = Get-HostedOutboundSpamFilterPolicy

    $HostedOutboundSpamFilterPolicy = $HostedOutboundSpamFilterPolicies | Where-Object -FilterScript { $_.Identity -eq $Identity }
    if (-not $HostedOutboundSpamFilterPolicy)
    {
        Write-Verbose -Message "HostedOutboundSpamFilterPolicy $($Identity) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        $result = @{
            Ensure                                    = 'Present'
            Identity                                  = $Identity
            AdminDisplayName                          = $HostedOutboundSpamFilterPolicy.AdminDisplayName
            BccSuspiciousOutboundAdditionalRecipients = $HostedOutboundSpamFilterPolicy.BccSuspiciousOutboundAdditionalRecipients
            BccSuspiciousOutboundMail                 = $HostedOutboundSpamFilterPolicy.BccSuspiciousOutboundMail
            NotifyOutboundSpamRecipients              = $HostedOutboundSpamFilterPolicy.NotifyOutboundSpamRecipients
            NotifyOutboundSpam                        = $HostedOutboundSpamFilterPolicy.NotifyOutboundSpam
            GlobalAdminAccount                        = $GlobalAdminAccount
        }

        Write-Verbose -Message "Found HostedOutboundSpamFilterPolicy $($Identity)"
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
        [ValidateSet('Present')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of HostedOutboundSpamFilterPolicy for $Identity"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $HostedOutboundSpamFilterPolicyParams = $PSBoundParameters
    $HostedOutboundSpamFilterPolicyParams.Remove('Ensure') | Out-Null
    $HostedOutboundSpamFilterPolicyParams.Remove('GlobalAdminAccount') | Out-Null

    Write-Verbose -Message "Setting HostedOutboundSpamFilterPolicy $Identity with values: $(Convert-M365DscHashtableToString -Hashtable $HostedOutboundSpamFilterPolicyParams)"
    Set-HostedOutboundSpamFilterPolicy @HostedOutboundSpamFilterPolicyParams
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
        [ValidateSet('Present')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of HostedOutboundSpamFilterPolicy for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    $ValuesToCheck.Remove('Verbose') | Out-Null

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
        -Platform ExchangeOnline `
        -ErrorAction SilentlyContinue

    $HostedOutboundSpamFilterPolicies = Get-HostedOutboundSpamFilterPolicy
    $content = ''
    foreach ($HostedOutboundSpamFilterPolicy in $HostedOutboundSpamFilterPolicies)
    {
        $params = @{
            GlobalAdminAccount = $GlobalAdminAccount
            Identity           = $HostedOutboundSpamFilterPolicy.Identity
        }
        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content += "        EXOHostedOutboundSpamFilterPolicy " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'GlobalAdminAccount'
        $content += "        }`r`n"
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
