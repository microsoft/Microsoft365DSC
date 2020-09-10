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
        [ValidateSet('Present')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $UnifiedAuditLogIngestionEnabled,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration for Office 365 Audit Log"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = @{
        IsSingleInstance                = $IsSingleInstance
        Ensure                          = 'Present'
        GlobalAdminAccount              = $GlobalAdminAccount
        UnifiedAuditLogIngestionEnabled = $UnifiedAuditLogIngestionEnabled
    }

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $GetResults = Get-AdminAuditLogConfig
    if (-not $GetResults)
    {
        Write-Warning 'Unable to determine Unified Audit Log Ingestion State.'
        Write-Verbose -Message "Returning Get-TargetResource NULL Result"
        return $nullReturn
    }
    else
    {
        if ($GetResults.UnifiedAuditLogIngestionEnabled)
        {
            $UnifiedAuditLogIngestionEnabledReturnValue = 'Enabled'
        }
        else
        {
            $UnifiedAuditLogIngestionEnabledReturnValue = 'Disabled'
        }

        $Result = @{
            IsSingleInstance                = $IsSingleInstance
            Ensure                          = 'Present'
            GlobalAdminAccount              = $GlobalAdminAccount
            UnifiedAuditLogIngestionEnabled = $UnifiedAuditLogIngestionEnabledReturnValue
        }
        return $Result
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
        [ValidateSet('Present')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $UnifiedAuditLogIngestionEnabled,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration for Office 365 Audit Log"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    if ($UnifiedAuditLogIngestionEnabled -eq 'Enabled')
    {
        try
        {
            Set-AdminAuditLogConfig -UnifiedAuditLogIngestionEnabled $true -EA SilentlyContinue
        }
        catch
        {
            $Message = "Couldn't set the Audit Log Ingestion. Please run Enable-OrganizationCustomization first."
            Write-Verbose $Message
            New-M365DSCLogEntry -Error $_ -Message $Message -Source $MyInvocation.MyCommand.ModuleName
        }
    }
    else
    {
        try
        {
            Set-AdminAuditLogConfig -UnifiedAuditLogIngestionEnabled $false -EA SilentlyContinue
        }
        catch
        {
            $Message = "Couldn't set the Audit Log Ingestion. Please run Enable-OrganizationCustomization first."
            Write-Verbose $Message
            New-M365DSCLogEntry -Error $_ -Message $Message -Source $MyInvocation.MyCommand.ModuleName
        }
    }
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
        [ValidateSet('Present')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $UnifiedAuditLogIngestionEnabled,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration for Office 365 Audit Log"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @('UnifiedAuditLogIngestionEnabled')

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

    $O365AdminAuditLogConfig = Get-AdminAuditLogConfig
    $value = "Disabled"
    if ($O365AdminAuditLogConfig.UnifiedAuditLogIngestionEnabled)
    {
        $value = "Enabled"
    }

    $params = @{
        IsSingleInstance                = 'Yes'
        UnifiedAuditLogIngestionEnabled = $value
        GlobalAdminAccount              = $GlobalAdminAccount
    }
    $result = Get-TargetResource @params

    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        O365AdminAuditLogConfig " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'GlobalAdminAccount'
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
