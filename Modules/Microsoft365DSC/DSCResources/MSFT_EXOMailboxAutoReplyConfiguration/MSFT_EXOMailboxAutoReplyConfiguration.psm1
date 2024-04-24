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
        $Owner,

        [Parameter()]
        [System.Boolean]
        $AutoDeclineFutureRequestsWhenOOF,

        [Parameter()]
        [ValidateSet('Enabled', 'Disabled', 'Scheduled')]
        [System.String]
        $AutoReplyState,

        [Parameter()]
        [System.Boolean]
        $CreateOOFEvent,

        [Parameter()]
        [System.Boolean]
        $DeclineAllEventsForScheduledOOF,

        [Parameter()]
        [System.Boolean]
        $DeclineEventsForScheduledOOF,

        [Parameter()]
        [System.String]
        $DeclineMeetingMessage,

        [Parameter()]
        [System.String]
        $EndTime,

        [Parameter()]
        [System.String[]]
        $EventsToDeleteIDs,

        [Parameter()]
        [ValidateSet('None', 'Known','All')]
        [System.String]
        $ExternalAudience,

        [Parameter()]
        [System.String]
        $ExternalMessage,

        [Parameter()]
        [System.String]
        $InternalMessage,

        [Parameter()]
        [System.String]
        $OOFEventSubject,

        [Parameter()]
        [System.String]
        $StartTime,

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

    Write-Verbose -Message "Getting configuration of Mailbox AutoReply Configuration for $Identity"

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
        $config = Get-MailboxAutoReplyConfiguration -Identity $Identity -ErrorAction Stop

        if ($null -eq $config)
        {
            Write-Verbose -Message "Mailbox for $($Identity) does not exist."
            return $nullReturn
        }
        else
        {
            $ownerValue = Get-User -Identity $config.Identity
            $result = @{
                Identity                         = $config.Identity
                Owner                            = $ownerValue.UserPrincipalName
                AutoDeclineFutureRequestsWhenOOF = [Boolean]$config.AutoDeclineFutureRequestsWhenOOF
                AutoReplyState                   = $config.AutoReplyState
                CreateOOFEvent                   = [Boolean]$config.CreateOOFEvent
                DeclineAllEventsForScheduledOOF  = [Boolean]$config.DeclineAllEventsForScheduledOOF
                DeclineEventsForScheduledOOF     = [Boolean]$config.DeclineEventsForScheduledOOF
                DeclineMeetingMessage            = $config.DeclineMeetingMessage
                EndTime                          = $config.EndTime
                EventsToDeleteIDs                = [Array]$config.EventsToDeleteIDs
                ExternalAudience                 = $config.ExternalAudience
                ExternalMessage                  = $config.ExternalMessage
                InternalMessage                  = $config.InternalMessage
                OOFEventSubject                  = $config.OOFEventSubject
                StartTime                        = $config.StartTime
                Credential                       = $Credential
                Ensure                           = 'Present'
                ApplicationId                    = $ApplicationId
                CertificateThumbprint            = $CertificateThumbprint
                CertificatePath                  = $CertificatePath
                CertificatePassword              = $CertificatePassword
                Managedidentity                  = $ManagedIdentity.IsPresent
                TenantId                         = $TenantId
                AccessTokens                     = $AccessTokens
            }

            Write-Verbose -Message "Found Mailbox $($Identity)"
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
        $Owner,

        [Parameter()]
        [System.Boolean]
        $AutoDeclineFutureRequestsWhenOOF,

        [Parameter()]
        [ValidateSet('Enabled', 'Disabled', 'Scheduled')]
        [System.String]
        $AutoReplyState,

        [Parameter()]
        [System.Boolean]
        $CreateOOFEvent,

        [Parameter()]
        [System.Boolean]
        $DeclineAllEventsForScheduledOOF,

        [Parameter()]
        [System.Boolean]
        $DeclineEventsForScheduledOOF,

        [Parameter()]
        [System.String]
        $DeclineMeetingMessage,

        [Parameter()]
        [System.String]
        $EndTime,

        [Parameter()]
        [System.String[]]
        $EventsToDeleteIDs,

        [Parameter()]
        [ValidateSet('None', 'Known','All')]
        [System.String]
        $ExternalAudience,

        [Parameter()]
        [System.String]
        $ExternalMessage,

        [Parameter()]
        [System.String]
        $InternalMessage,

        [Parameter()]
        [System.String]
        $OOFEventSubject,

        [Parameter()]
        [System.String]
        $StartTime,

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

    Write-Verbose -Message "Setting configuration of AntiPhishPolicy for $Identity"

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

    $PSBoundParameters.Remove('Ensure') | Out-Null
    $PSBoundParameters.Remove('ApplicationId') | Out-Null
    $PSBoundParameters.Remove('TenantId') | Out-Null
    $PSBoundParameters.Remove('CertificateThumbprint') | Out-Null
    $PSBoundParameters.Remove('CertificatePassword') | Out-Null
    $PSBoundParameters.Remove('ManagedIdentity') | Out-Null
    $PSBoundParameters.Remove('CertificatePath') | Out-Null
    $PSBoundParameters.Remove('Credential') | Out-Null
    $PSBoundParameters.Remove('Owner') | Out-Null
    $PSBoundParameters.Remove('AccessTokens') | Out-Null

    Set-MailboxAutoReplyConfiguration @PSBoundParameters
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
        $Owner,

        [Parameter()]
        [System.Boolean]
        $AutoDeclineFutureRequestsWhenOOF,

        [Parameter()]
        [ValidateSet('Enabled', 'Disabled', 'Scheduled')]
        [System.String]
        $AutoReplyState,

        [Parameter()]
        [System.Boolean]
        $CreateOOFEvent,

        [Parameter()]
        [System.Boolean]
        $DeclineAllEventsForScheduledOOF,

        [Parameter()]
        [System.Boolean]
        $DeclineEventsForScheduledOOF,

        [Parameter()]
        [System.String]
        $DeclineMeetingMessage,

        [Parameter()]
        [System.String]
        $EndTime,

        [Parameter()]
        [System.String[]]
        $EventsToDeleteIDs,

        [Parameter()]
        [ValidateSet('None', 'Known','All')]
        [System.String]
        $ExternalAudience,

        [Parameter()]
        [System.String]
        $ExternalMessage,

        [Parameter()]
        [System.String]
        $InternalMessage,

        [Parameter()]
        [System.String]
        $OOFEventSubject,

        [Parameter()]
        [System.String]
        $StartTime,

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

    Write-Verbose -Message "Testing Mailbox AutoReply Configuration for $Identity"

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
        $mailboxes = Get-Mailbox -ResultSize 'Unlimited'
        $dscContent = ''
        $i = 1

        if ($AntiphishPolicies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($mailbox in $mailboxes)
        {
            Write-Host "    |---[$i/$($mailboxes.Length)] $($mailbox.UserPrincipalName)" -NoNewline

            $Params = @{
                Identity              = $mailbox.UserPrincipalName
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                Managedidentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
                AccessTokens          = $AccessTokens
            }
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
