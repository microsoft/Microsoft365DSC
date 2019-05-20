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
    if ('Absent' -eq $Ensure)
    {
        throw "O365AdminAuditLogConfig configurations MUST specify Ensure value of 'Present'"
    }

    $nullReturn = @{
        IsSingleInstance                = $IsSingleInstance
        Ensure                          = 'Present'
        GlobalAdminAccount              = $GlobalAdminAccount
        UnifiedAuditLogIngestionEnabled = $UnifiedAuditLogIngestionEnabled
    }

    Write-Verbose -Message 'Getting O365AdminAuditLogConfig'
    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
    $GetResults = Get-AdminAuditLogConfig
    if (-NOT $GetResults)
    {
        Write-Warning 'Unable to determine Unified Audit Log Ingestion State.'
        Write-Verbose "Returning Get-TargetResource NULL Result"
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
    Write-Verbose -Message 'Setting O365AdminAuditLogConfig'
    if ('Absent' -eq $Ensure)
    {
        throw "O365AdminAuditLogConfig configurations MUST specify Ensure value of 'Present'"
    }

    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
    if ($UnifiedAuditLogIngestionEnabled -eq 'Enabled')
    {
        try
        {
            Set-AdminAuditLogConfig -UnifiedAuditLogIngestionEnabled $true -EA SilentlyContinue
        }
        catch
        {
            Write-Verbose -Message "Couldn't set the Audit Log Ingestion. Please run Enable-OrganizationCustomization first."
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
            Write-Verbose -Message "Couldn't set the Audit Log Ingestion. Please run Enable-OrganizationCustomization first."
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

    Write-Verbose -Message "Testing Office 365 Audit Log Config"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
                                                  -DesiredValues $PSBoundParameters `
                                                  -ValuesToCheck @('UnifiedAuditLogIngestionEnabled')

    Write-Verbose "Test-TargetResource returned $TestResult"

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
