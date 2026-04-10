Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXOMailboxAutoReplyConfiguration'

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
        [ValidateSet('None', 'Known', 'All')]
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
        [ValidateSet('Present')]
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

    try
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

        $config = Get-MailboxAutoReplyConfiguration -Identity $Identity -ErrorAction SilentlyContinue
        if ($null -eq $config)
        {
            Write-Verbose -Message "Mailbox for $($Identity) does not exist."
            return $nullReturn
        }

        Write-Verbose -Message "Found Mailbox $($Identity)"

        $userPrincipalName = $Identity
        if ($userPrincipalName -notlike '*@*')
        {
            $userPrincipalName = (Get-User -Identity $Identity).UserPrincipalName
        }

        $result = @{
            Identity                         = $userPrincipalName
            Owner                            = $userPrincipalName
            AutoDeclineFutureRequestsWhenOOF = [Boolean]$config.AutoDeclineFutureRequestsWhenOOF
            AutoReplyState                   = $config.AutoReplyState
            CreateOOFEvent                   = [Boolean]$config.CreateOOFEvent
            DeclineAllEventsForScheduledOOF  = [Boolean]$config.DeclineAllEventsForScheduledOOF
            DeclineEventsForScheduledOOF     = [Boolean]$config.DeclineEventsForScheduledOOF
            DeclineMeetingMessage            = $config.DeclineMeetingMessage
            EndTime                          = $config.EndTime
            EventsToDeleteIDs                = [System.String[]]$config.EventsToDeleteIDs
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
            ManagedIdentity                  = $ManagedIdentity.IsPresent
            TenantId                         = $TenantId
            AccessTokens                     = $AccessTokens
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
        [ValidateSet('None', 'Known', 'All')]
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
        [ValidateSet('Present')]
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

    $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $updateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $updateParameters.Remove('Owner') | Out-Null

    Set-MailboxAutoReplyConfiguration @updateParameters
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
        [ValidateSet('None', 'Known', 'All')]
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
        [ValidateSet('Present')]
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
        $mailboxes = Get-Mailbox -ResultSize 'Unlimited'
        $dscContent = ''
        $i = 1

        if ($mailboxes.Count -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($mailbox in $mailboxes)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($mailboxes.Length)] $($mailbox.UserPrincipalName)" -DeferWrite

            $Params = @{
                Identity              = $mailbox.UserPrincipalName
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
                AccessTokens          = $AccessTokens
            }
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
