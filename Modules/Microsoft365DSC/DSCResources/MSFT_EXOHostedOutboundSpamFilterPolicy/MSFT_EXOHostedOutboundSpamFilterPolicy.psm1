Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXOHostedOutboundSpamFilterPolicy'

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
        [System.UInt32]
        $RecipientLimitInternalPerHour,

        [Parameter()]
        [System.UInt32]
        $RecipientLimitPerDay,

        [Parameter()]
        [System.UInt32]
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

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Identity -ne $Identity)
        {
            $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
                -InboundParameters $PSBoundParameters

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

            $HostedOutboundSpamFilterPolicy = Get-HostedOutboundSpamFilterPolicy -Identity $Identity -ErrorAction SilentlyContinue
            if (-not $HostedOutboundSpamFilterPolicy)
            {
                Write-Verbose -Message "HostedOutboundSpamFilterPolicy $($Identity) does not exist."
                return $nullReturn
            }
        }
        else
        {
            $HostedOutboundSpamFilterPolicy = $Script:exportedInstance
        }

        Write-Verbose -Message "Found HostedOutboundSpamFilterPolicy $($Identity)"

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

        return $result
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
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
        [System.UInt32]
        $RecipientLimitInternalPerHour,

        [Parameter()]
        [System.UInt32]
        $RecipientLimitPerDay,

        [Parameter()]
        [System.UInt32]
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

    $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $HostedOutboundSpamFilterPolicyParams = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

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
        [System.UInt32]
        $RecipientLimitInternalPerHour,

        [Parameter()]
        [System.UInt32]
        $RecipientLimitPerDay,

        [Parameter()]
        [System.UInt32]
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

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
                                         -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '')
    return $result
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
        -InboundParameters $PSBoundParameters

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

        if ($HostedOutboundSpamFilterPolicies.Count -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        $i = 1
        foreach ($HostedOutboundSpamFilterPolicy in $HostedOutboundSpamFilterPolicies)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

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
            $Script:exportedInstance = $HostedOutboundSpamFilterPolicy
            Write-M365DSCHost -Message "    |---[$i/$($HostedOutboundSpamFilterPolicies.Length)] $($HostedOutboundSpamFilterPolicy.Identity)" -DeferWrite
            $Results = Get-TargetResource @Params
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            $i++
        }
        return $dscContent
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

Export-ModuleMember -Function *-TargetResource
