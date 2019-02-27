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
        throw "This resource cannot delete Managed Properties. Please make sure you set its Ensure value to Present."
    }

    Open-SecurityAndComplianceCenterConnection -GlobalAdminAccount $GlobalAdminAccount

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
        if ($GetResults.UnifiedAuditLogIngestionEnabled)
        {
            $UnifiedAuditLogIngestionEnabledReturnValue = 'Enabled'
        }
        else
        {
            $UnifiedAuditLogIngestionEnabledReturnValue = 'Disabled'
        }

        [void](Get-PSSession | Remove-PSSession)
        $Result = @{
            IsSingleInstance                = $IsSingleInstance
            Ensure                          = 'Present'
            GlobalAdminAccount              = $GlobalAdminAccount
            UnifiedAuditLogIngestionEnabled = $UnifiedAuditLogIngestionEnabledReturnValue
        }
        Write-Verbose "Returning Get-TargetResource Result"
        return $Result
    }
    catch
    {
        $ExceptionMessage = $_.Exception
        Write-Verbose "Error Caught, exception message is: $ExceptionMessage"
        Write-Warning 'Unable to determine Unified Audit Log Ingestion State.'
        [void](Get-PSSession | Remove-PSSession)
        Write-Verbose "Returning Get-TargetResource NULL Result"
        return $nullReturn
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

    Open-SecurityAndComplianceCenterConnection -GlobalAdminAccount $GlobalAdminAccount

    if ($UnifiedAuditLogIngestionEnabled -eq 'Enabled')
    {
        Set-AdminAuditLogConfig -UnifiedAuditLogIngestionEnabled $true -Confirm:$false -Force
    }
    else
    {
        Set-AdminAuditLogConfig -UnifiedAuditLogIngestionEnabled $false -Confirm:$false -Force
    }

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
    $CurrentValues = Get-TargetResource @PSBoundParameters
    Write-Verbose "Test-TargetResource CurrentValues: "
    Write-Verbose "$($CurrentValues | Out-String)"
    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @('UnifiedAuditLogIngestionEnabled')
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
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName $GlobalAdminAccount.UserName
    $content = "        O365AdminAuditLogConfig " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'GlobalAdminAccount'
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
