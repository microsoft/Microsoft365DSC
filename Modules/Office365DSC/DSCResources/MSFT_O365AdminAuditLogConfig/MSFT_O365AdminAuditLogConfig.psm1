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

    try
    {
        Write-Verbose -Message 'Getting O365AdminAuditLogConfig'
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
            Write-Verbose "Returning Get-TargetResource Result"
            return $Result
        }

    }
    catch
    {
        [void](Get-PSSession | Remove-PSSession)
        $ExceptionMessage = $_.Exception
        throw $ExceptionMessage
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
        throw "This resource cannot delete Managed Properties. Please make sure you set its Ensure value to Present."
    }

    if ($UnifiedAuditLogIngestionEnabled -eq 'Enabled')
    {
        Set-AdminAuditLogConfig -UnifiedAuditLogIngestionEnabled $true
    }
    else
    {
        Set-AdminAuditLogConfig -UnifiedAuditLogIngestionEnabled $false
    }

    Write-Verbose "Closing Remote PowerShell Sessions"
    [void](Get-PSSession | Remove-PSSession)
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
    Write-Verbose -Message 'Testing O365AdminAuditLogConfig'
    Open-SecurityAndComplianceCenterConnection -GlobalAdminAccount $GlobalAdminAccount
    $CurrentValues = Get-TargetResource @PSBoundParameters
    Write-Verbose "Test-TargetResource CurrentValues: "
    Write-Verbose "$($CurrentValues | Out-String)"
    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @('UnifiedAuditLogIngestionEnabled')
    if ($TestResult)
    {
        Write-Verbose "Closing Remote PowerShell Sessions"
        [void](Get-PSSession | Remove-PSSession)
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
    $IsSingleInstance = 'Yes'
    Open-SecurityAndComplianceCenterConnection -GlobalAdminAccount $GlobalAdminAccount
    $result = Get-TargetResource @PSBoundParameters
    Write-Verbose "Closing Remote PowerShell Sessions"
    [void](Get-PSSession | Remove-PSSession)
    $result.GlobalAdminAccount = Resolve-Credentials -UserName $GlobalAdminAccount.UserName
    $content = "        O365AdminAuditLogConfig " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'GlobalAdminAccount'
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
