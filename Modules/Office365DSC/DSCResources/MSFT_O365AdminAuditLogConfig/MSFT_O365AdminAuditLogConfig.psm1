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

    $nullReturn = @{
        IsSingleInstance                = $IsSingleInstance
        Ensure                          = 'Present'
        GlobalAdminAccount              = $GlobalAdminAccount
        UnifiedAuditLogIngestionEnabled = $UnifiedAuditLogIngestionEnabled
    }

    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount

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

    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount

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
            New-Office365DSCLogEntry -Error $_ -Message $Message
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
            New-Office365DSCLogEntry -Error $_ -Message $Message
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

    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
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
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [string]$Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $UnifiedAuditLogIngestionEnabled,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $result = Get-TargetResource @PSBoundParameters

    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        O365AdminAuditLogConfig " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'GlobalAdminAccount'
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
