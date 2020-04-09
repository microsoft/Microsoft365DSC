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
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

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
        New-M365DSCLogEntry -Error $_ -Message $Message -Source $MyInvocation.MyCommand.ModuleName
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
            Ensure             = 'Present'
            Identity           = $Identity
            AdminDisplayName   = $HostedConnectionFilterPolicy.AdminDisplayName
            EnableSafeList     = $HostedConnectionFilterPolicy.EnableSafeList
            IPAllowList        = $HostedConnectionFilterPolicy.IPAllowList
            IPBlockList        = $HostedConnectionFilterPolicy.IPBlockList
            MakeDefault        = $false
            GlobalAdminAccount = $GlobalAdminAccount
        }

        if ($AntiPhishRule.IsDefault)
        {
            $result.MakeDefault = $true
        }

        Write-Verbose -Message "Found HostedConnectionFilterPolicy $($Identity)"
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
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

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

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    $ValuesToCheck.Remove('IsSingleInstance') | Out-Null
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

    $HostedConnectionFilterPolicys = Get-HostedConnectionFilterPolicy
    $content = ''
    foreach ($HostedConnectionFilterPolicy in $HostedConnectionFilterPolicys)
    {
        $params = @{
            GlobalAdminAccount = $GlobalAdminAccount
            Identity           = $HostedConnectionFilterPolicy.Identity
        }
        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content += "        EXOHostedConnectionFilterPolicy " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $content += "        }`r`n"
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
