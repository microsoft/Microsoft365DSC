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
        [ValidateSet('Allow', 'Block', 'Quarantine')]
        [System.String]
        $AccessLevel,

        [Parameter()]
        [ValidateSet('DeviceModel', 'DeviceType', 'DeviceOS', 'UserAgent', 'XMSWLHeader')]
        [System.String]
        $Characteristic,

        [Parameter()]
        [System.String]
        $QueryString,

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

    Write-Verbose -Message "Getting Active Sync Device Access Rule configuration for $Identity"
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
    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"
    try
    {
        $AllActiveSyncDeviceAccessRules = Get-ActiveSyncDeviceAccessRule -ErrorAction Stop

        $ActiveSyncDeviceAccessRule = $AllActiveSyncDeviceAccessRules | Where-Object -FilterScript { $_.Identity -eq $Identity }

        if ($null -eq $ActiveSyncDeviceAccessRule)
        {
            Write-Verbose -Message "Active Sync Device Access Rule $($Identity) does not exist."
            return $nullReturn
        }
        else
        {
            $result = @{
                Identity              = $ActiveSyncDeviceAccessRule.Identity
                AccessLevel           = $ActiveSyncDeviceAccessRule.AccessLevel
                Characteristic        = $ActiveSyncDeviceAccessRule.Characteristic
                QueryString           = $ActiveSyncDeviceAccessRule.QueryString
                Ensure                = 'Present'
                GlobalAdminAccount    = $GlobalAdminAccount
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
            }

            Write-Verbose -Message "Found Active Sync Device Access Rule $($Identity)"
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

        [Parameter()]
        [ValidateSet('Allow', 'Block', 'Quarantine')]
        [System.String]
        $AccessLevel,

        [Parameter()]
        [ValidateSet('DeviceModel', 'DeviceType', 'DeviceOS', 'UserAgent', 'XMSWLHeader')]
        [System.String]
        $Characteristic,

        [Parameter()]
        [System.String]
        $QueryString,

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

    Write-Verbose -Message "Setting Active Sync Device Access Rule configuration for $Identity"

    $currentActiveSyncDeviceAccessRuleConfig = Get-TargetResource @PSBoundParameters

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

    $NewActiveSyncDeviceAccessRuleParams = @{
        AccessLevel    = $AccessLevel
        Characteristic = $Characteristic
        QueryString    = $QueryString
        Confirm        = $false
    }

    $SetActiveSyncDeviceAccessRuleParams = @{
        Identity       = $Identity
        AccessLevel    = $AccessLevel
        Confirm        = $false
    }

    # CASE: Active Sync Device Access Rule doesn't exist but should;
    if ($Ensure -eq "Present" -and $currentActiveSyncDeviceAccessRuleConfig.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Active Sync Device Access Rule '$($Identity)' does not exist but it should. Create and configure it."
        # Create Active Sync Device Access Rule
        New-ActiveSyncDeviceAccessRule @NewActiveSyncDeviceAccessRuleParams

    }
    # CASE: Active Sync Device Access Rule exists but it shouldn't;
    elseif ($Ensure -eq "Absent" -and $currentActiveSyncDeviceAccessRuleConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Active Sync Device Access Rule '$($Identity)' exists but it shouldn't. Remove it."
        Remove-ActiveSyncDeviceAccessRule -Identity $Identity -Confirm:$false
    }
    # CASE: Active Sync Device Access Rule exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq "Present" -and $currentActiveSyncDeviceAccessRuleConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Active Sync Device Access Rule '$($Identity)' already exists, but needs updating."
        Write-Verbose -Message "Setting Active Sync Device Access Rule $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $SetActiveSyncDeviceAccessRuleParams)"
        Set-ActiveSyncDeviceAccessRule @SetActiveSyncDeviceAccessRuleParams
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
        [ValidateSet('Allow', 'Block', 'Quarantine')]
        [System.String]
        $AccessLevel,

        [Parameter()]
        [ValidateSet('DeviceModel', 'DeviceType', 'DeviceOS', 'UserAgent', 'XMSWLHeader')]
        [System.String]
        $Characteristic,

        [Parameter()]
        [System.String]
        $QueryString,

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

    Write-Verbose -Message "Testing Active Sync Device Access Rule configuration for $Identity"

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

    try
    {
        [array]$AllActiveSyncDeviceAccessRules = Get-ActiveSyncDeviceAccessRule -ErrorAction Stop

        $dscContent = ""
        $i = 1
        if ($AllActiveSyncDeviceAccessRules.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewLine
        }
        foreach ($ActiveSyncDeviceAccessRule in $AllActiveSyncDeviceAccessRules)
        {
            Write-Host "    |---[$i/$($AllActiveSyncDeviceAccessRules.Count)] $($ActiveSyncDeviceAccessRule.Identity)" -NoNewLine

            $Params = @{
                Identity              = $ActiveSyncDeviceAccessRule.Identity
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

