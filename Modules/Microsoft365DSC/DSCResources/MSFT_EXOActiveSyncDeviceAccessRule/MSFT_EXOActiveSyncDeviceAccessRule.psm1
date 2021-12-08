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
        $Credential,

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

    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters
    }

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

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
                Credential            = $Credential
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
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
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
        $Credential,

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

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $NewActiveSyncDeviceAccessRuleParams = @{
        AccessLevel    = $AccessLevel
        Characteristic = $Characteristic
        QueryString    = $QueryString
        Confirm        = $false
    }

    $SetActiveSyncDeviceAccessRuleParams = @{
        Identity    = $Identity
        AccessLevel = $AccessLevel
        Confirm     = $false
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
        $Credential,

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
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing Active Sync Device Access Rule configuration for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('CertificateThumbprint') | Out-Null
    $ValuesToCheck.Remove('CertificatePath') | Out-Null
    $ValuesToCheck.Remove('CertificatePassword') | Out-Null

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
        $Credential,

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
    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

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
            Write-Host "`r`n" -NoNewline
        }
        foreach ($ActiveSyncDeviceAccessRule in $AllActiveSyncDeviceAccessRules)
        {
            Write-Host "    |---[$i/$($AllActiveSyncDeviceAccessRules.Count)] $($ActiveSyncDeviceAccessRule.Identity)" -NoNewline

            $Params = @{
                Identity              = $ActiveSyncDeviceAccessRule.Identity
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                CertificatePath       = $CertificatePath
            }
            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            Write-Host $Global:M365DSCEmojiGreenCheckMa
            $dscContent += $currentDSCBlock

            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileNamerk
            $i++
        }
        return $dscContent
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
