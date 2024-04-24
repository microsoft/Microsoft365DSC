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
        [System.String]
        $RecipientLimitInternalPerHour,

        [Parameter()]
        [System.String]
        $RecipientLimitPerDay,

        [Parameter()]
        [System.String]
        $RecipientLimitExternalPerHour,

        [Parameter()]
        [System.String]
        $ActionWhenThresholdReached,

        [Parameter()]
        [System.String]
        $AutoForwardingMode,

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
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Testing configuration of HostedOutboundSpamFilterPolicy for $Identity"

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'
    try
    {
        $HostedOutboundSpamFilterPolicies = Get-HostedOutboundSpamFilterPolicy -ErrorAction Stop

        $HostedOutboundSpamFilterPolicy = $HostedOutboundSpamFilterPolicies | Where-Object -FilterScript { $_.Identity -eq $Identity }
        if (-not $HostedOutboundSpamFilterPolicy)
        {
            Write-Verbose -Message "HostedOutboundSpamFilterPolicy $($Identity) does not exist."
            return $nullReturn
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
                RecipientLimitInternalPerHour             = $HostedOutboundSpamFilterPolicy.RecipientLimitInternalPerHour
                RecipientLimitPerDay                      = $HostedOutboundSpamFilterPolicy.RecipientLimitPerDay
                RecipientLimitExternalPerHour             = $HostedOutboundSpamFilterPolicy.RecipientLimitExternalPerHour
                ActionWhenThresholdReached                = $HostedOutboundSpamFilterPolicy.ActionWhenThresholdReached
                AutoForwardingMode                        = $HostedOutboundSpamFilterPolicy.AutoForwardingMode
                Credential                                = $Credential
                ApplicationId                             = $ApplicationId
                CertificateThumbprint                     = $CertificateThumbprint
                CertificatePath                           = $CertificatePath
                CertificatePassword                       = $CertificatePassword
                ManagedIdentity                           = $ManagedIdentity.IsPresent
                TenantId                                  = $TenantId
                AccessTokens                              = $AccessTokens
            }

            Write-Verbose -Message "Found HostedOutboundSpamFilterPolicy $($Identity)"
            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
        }
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

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
        [System.String]
        $RecipientLimitInternalPerHour,

        [Parameter()]
        [System.String]
        $RecipientLimitPerDay,

        [Parameter()]
        [System.String]
        $RecipientLimitExternalPerHour,

        [Parameter()]
        [System.String]
        $ActionWhenThresholdReached,

        [Parameter()]
        [System.String]
        $AutoForwardingMode,

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
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Testing configuration of HostedOutboundSpamFilterPolicy for $Identity"

    $currentHostedOutboundSpamFilterPolicyConfig = Get-TargetResource @PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $HostedOutboundSpamFilterPolicyParams = [System.Collections.Hashtable]($PSBoundParameters)
    $HostedOutboundSpamFilterPolicyParams.Remove('Ensure') | Out-Null
    $HostedOutboundSpamFilterPolicyParams.Remove('Credential') | Out-Null
    $HostedOutboundSpamFilterPolicyParams.Remove('ApplicationId') | Out-Null
    $HostedOutboundSpamFilterPolicyParams.Remove('TenantId') | Out-Null
    $HostedOutboundSpamFilterPolicyParams.Remove('CertificateThumbprint') | Out-Null
    $HostedOutboundSpamFilterPolicyParams.Remove('CertificatePath') | Out-Null
    $HostedOutboundSpamFilterPolicyParams.Remove('CertificatePassword') | Out-Null
    $HostedOutboundSpamFilterPolicyParams.Remove('ManagedIdentity') | Out-Null
    $HostedOutboundSpamFilterPolicyParams.Remove('AccessTokens') | Out-Null

    # CASE: Hosted Outbound Spam Filter Policy doesn't exist but should;
    if ($Ensure -eq 'Present' -and $currentHostedOutboundSpamFilterPolicyConfig.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Hosted Outbound Spam Filter Policy '$($Identity)' does not exist but it should. Create and configure it."
        $HostedOutboundSpamFilterPolicyParams.Add('Name', $Identity)
        $HostedOutboundSpamFilterPolicyParams.Remove('Identity') | Out-Null
        New-HostedOutboundSpamFilterPolicy @HostedOutboundSpamFilterPolicyParams
    }
    # CASE: Hosted Outbound Spam Filter Policy exists but it shouldn't;
    elseif ($Ensure -eq 'Absent' -and $currentHostedOutboundSpamFilterPolicyConfig.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Hosted Outbound Spam Filter Policy '$($Identity)' exists but it shouldn't. Remove it."
        Remove-HostedOutboundSpamFilterPolicy -Identity $Identity -Force
    }
    # CASE: Hosted Outbound Spam Filter Policy exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq 'Present' -and $currentHostedOutboundSpamFilterPolicyConfig.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Hosted Outbound Spam Filter Policy '$($Identity)' already exists, but needs updating."
        Write-Verbose -Message "Setting Hosted Outbound Spam Filter Policy $Identity with values: $(Convert-M365DscHashtableToString -Hashtable $HostedOutboundSpamFilterPolicyParams)"
        Set-HostedOutboundSpamFilterPolicy @HostedOutboundSpamFilterPolicyParams -Confirm:$false
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
        [System.String]
        $RecipientLimitInternalPerHour,

        [Parameter()]
        [System.String]
        $RecipientLimitPerDay,

        [Parameter()]
        [System.String]
        $RecipientLimitExternalPerHour,

        [Parameter()]
        [System.String]
        $ActionWhenThresholdReached,

        [Parameter()]
        [System.String]
        $AutoForwardingMode,

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
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of HostedOutboundSpamFilterPolicy for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters

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
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array]$HostedOutboundSpamFilterPolicies = Get-HostedOutboundSpamFilterPolicy -ErrorAction stop
        $dscContent = ''

        if ($HostedOutboundSpamFilterPolicies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $i = 1
        foreach ($HostedOutboundSpamFilterPolicy in $HostedOutboundSpamFilterPolicies)
        {
            $Params = @{
                Credential            = $Credential
                Identity              = $HostedOutboundSpamFilterPolicy.Identity
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
                AccessTokens          = $AccessTokens
            }
            Write-Host "    |---[$i/$($HostedOutboundSpamFilterPolicies.Length)] $($HostedOutboundSpamFilterPolicy.Identity)" -NoNewline
            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
        }
        return $dscContent
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
