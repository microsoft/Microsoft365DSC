Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXOCASMailboxSettings'

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
        [System.String[]]
        $ActiveSyncAllowedDeviceIDs = @(),

        [Parameter()]
        [System.String[]]
        $ActiveSyncBlockedDeviceIDs = @(),

        [Parameter()]
        [System.Boolean]
        $ActiveSyncDebugLogging,

        [Parameter()]
        [System.Boolean]
        $ActiveSyncEnabled,

        [Parameter()]
        [System.String]
        $ActiveSyncMailboxPolicy,

        [Parameter()]
        [System.Boolean]
        $ActiveSyncSuppressReadReceipt,

        [Parameter()]
        [System.Boolean]
        $EwsAllowEntourage,

        [Parameter()]
        [System.String[]]
        $EwsAllowList = @(),

        [Parameter()]
        [System.Boolean]
        $EwsAllowMacOutlook,

        [Parameter()]
        [System.Boolean]
        $EwsAllowOutlook,

        [Parameter()]
        [System.String]
        $EwsApplicationAccessPolicy,

        [Parameter()]
        [System.String[]]
        $EwsBlockList = @(),

        [Parameter()]
        [System.Boolean]
        $EwsEnabled,

        [Parameter()]
        [System.Boolean]
        $ImapEnabled,

        [Parameter()]
        [System.String]
        $ImapMessagesRetrievalMimeFormat,

        [Parameter()]
        [System.Boolean]
        $ImapForceICalForCalendarRetrievalOption,

        [Parameter()]
        [System.Boolean]
        $ImapSuppressReadReceipt,

        [Parameter()]
        [System.Boolean]
        $ImapUseProtocolDefaults,

        [Parameter()]
        [System.Boolean]
        $MacOutlookEnabled,

        [Parameter()]
        [System.Boolean]
        $MAPIEnabled,

        [Parameter()]
        [System.Boolean]
        $OneWinNativeOutlookEnabled,

        [Parameter()]
        [System.Boolean]
        $OutlookMobileEnabled,

        [Parameter()]
        [System.Boolean]
        $OWAEnabled,

        [Parameter()]
        [System.Boolean]
        $OWAforDevicesEnabled,

        [Parameter()]
        [System.String]
        $OwaMailboxPolicy,

        [Parameter()]
        [System.Boolean]
        $PopEnabled,

        [Parameter()]
        [System.Boolean]
        $PopForceICalForCalendarRetrievalOption,

        [Parameter()]
        [System.String]
        $PopMessagesRetrievalMimeFormat,

        [Parameter()]
        [System.Boolean]
        $PopSuppressReadReceipt,

        [Parameter()]
        [System.Boolean]
        $PopUseProtocolDefaults,

        [Parameter()]
        [System.Boolean]
        $PublicFolderClientAccess,

        [Parameter()]
        [System.Boolean]
        $ShowGalAsDefaultView,

        [Parameter()]
        [System.Boolean]
        $SmtpClientAuthenticationDisabled,

        [Parameter()]
        [System.Boolean]
        $UniversalOutlookEnabled,

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

    Write-Verbose -Message "Getting configuration of Exchange Online CAS Mailbox Settings for $Identity"

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

            $nullReturn = @{
                Identity = $Identity
                Ensure   = 'Absent'
            }

            $mailboxCasSettings = Get-CASMailbox -Identity $Identity -ErrorAction SilentlyContinue
            if ($null -eq $mailboxCasSettings)
            {
                Write-Verbose -Message 'The specified Mailbox does not exist.'
                return $nullReturn
            }
        }
        else
        {
            $mailboxCasSettings = $Script:exportedInstance
        }

        Write-Verbose -Message "Found an existing instance of Mailbox '$($Identity)'"

        $result = @{
            Ensure                                  = 'Present'
            Identity                                = $Identity
            ActiveSyncAllowedDeviceIDs              = $mailboxCasSettings.ActiveSyncAllowedDeviceIDs
            ActiveSyncBlockedDeviceIDs              = $mailboxCasSettings.ActiveSyncBlockedDeviceIDs
            ActiveSyncDebugLogging                  = $mailboxCasSettings.ActiveSyncDebugLogging
            ActiveSyncEnabled                       = $mailboxCasSettings.ActiveSyncEnabled
            ActiveSyncMailboxPolicy                 = $mailboxCasSettings.ActiveSyncMailboxPolicy
            ActiveSyncSuppressReadReceipt           = $mailboxCasSettings.ActiveSyncSuppressReadReceipt
            EwsAllowEntourage                       = $mailboxCasSettings.EwsAllowEntourage
            EwsAllowList                            = $mailboxCasSettings.EwsAllowList
            EwsAllowMacOutlook                      = $mailboxCasSettings.EwsAllowMacOutlook
            EwsAllowOutlook                         = $mailboxCasSettings.EwsAllowOutlook
            EwsApplicationAccessPolicy              = $mailboxCasSettings.EwsApplicationAccessPolicy
            EwsBlockList                            = $mailboxCasSettings.EwsBlockList
            EwsEnabled                              = $mailboxCasSettings.EwsEnabled
            ImapEnabled                             = $mailboxCasSettings.ImapEnabled
            ImapMessagesRetrievalMimeFormat         = $mailboxCasSettings.ImapMessagesRetrievalMimeFormat
            ImapForceICalForCalendarRetrievalOption = $mailboxCasSettings.ImapForceICalForCalendarRetrievalOption
            ImapSuppressReadReceipt                 = $mailboxCasSettings.ImapSuppressReadReceipt
            ImapUseProtocolDefaults                 = $mailboxCasSettings.ImapUseProtocolDefaults
            MacOutlookEnabled                       = $mailboxCasSettings.MacOutlookEnabled
            MAPIEnabled                             = $mailboxCasSettings.MAPIEnabled
            OneWinNativeOutlookEnabled              = $mailboxCasSettings.OneWinNativeOutlookEnabled
            OutlookMobileEnabled                    = $mailboxCasSettings.OutlookMobileEnabled
            OWAEnabled                              = $mailboxCasSettings.OWAEnabled
            OWAforDevicesEnabled                    = $mailboxCasSettings.OWAforDevicesEnabled
            OwaMailboxPolicy                        = $mailboxCasSettings.OwaMailboxPolicy
            PopEnabled                              = $mailboxCasSettings.PopEnabled
            PopForceICalForCalendarRetrievalOption  = $mailboxCasSettings.PopForceICalForCalendarRetrievalOption
            PopMessagesRetrievalMimeFormat          = $mailboxCasSettings.PopMessagesRetrievalMimeFormat
            PopSuppressReadReceipt                  = $mailboxCasSettings.PopSuppressReadReceipt
            PopUseProtocolDefaults                  = $mailboxCasSettings.PopUseProtocolDefaults
            PublicFolderClientAccess                = $mailboxCasSettings.PublicFolderClientAccess
            ShowGalAsDefaultView                    = $mailboxCasSettings.ShowGalAsDefaultView
            SmtpClientAuthenticationDisabled        = $mailboxCasSettings.SmtpClientAuthenticationDisabled
            UniversalOutlookEnabled                 = $mailboxCasSettings.UniversalOutlookEnabled
            Credential                              = $Credential
            ApplicationId                           = $ApplicationId
            CertificateThumbprint                   = $CertificateThumbprint
            CertificatePath                         = $CertificatePath
            CertificatePassword                     = $CertificatePassword
            ManagedIdentity                         = $ManagedIdentity.IsPresent
            TenantId                                = $TenantId
            AccessTokens                            = $AccessTokens
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
        [System.String[]]
        $ActiveSyncAllowedDeviceIDs = @(),

        [Parameter()]
        [System.String[]]
        $ActiveSyncBlockedDeviceIDs = @(),

        [Parameter()]
        [System.Boolean]
        $ActiveSyncDebugLogging,

        [Parameter()]
        [System.Boolean]
        $ActiveSyncEnabled,

        [Parameter()]
        [System.String]
        $ActiveSyncMailboxPolicy,

        [Parameter()]
        [System.Boolean]
        $ActiveSyncSuppressReadReceipt,

        [Parameter()]
        [System.Boolean]
        $EwsAllowEntourage,

        [Parameter()]
        [System.String[]]
        $EwsAllowList = @(),

        [Parameter()]
        [System.Boolean]
        $EwsAllowMacOutlook,

        [Parameter()]
        [System.Boolean]
        $EwsAllowOutlook,

        [Parameter()]
        [System.String]
        $EwsApplicationAccessPolicy,

        [Parameter()]
        [System.String[]]
        $EwsBlockList = @(),

        [Parameter()]
        [System.Boolean]
        $EwsEnabled,

        [Parameter()]
        [System.Boolean]
        $ImapEnabled,

        [Parameter()]
        [System.String]
        $ImapMessagesRetrievalMimeFormat,

        [Parameter()]
        [System.Boolean]
        $ImapForceICalForCalendarRetrievalOption,

        [Parameter()]
        [System.Boolean]
        $ImapSuppressReadReceipt,

        [Parameter()]
        [System.Boolean]
        $ImapUseProtocolDefaults,

        [Parameter()]
        [System.Boolean]
        $MacOutlookEnabled,

        [Parameter()]
        [System.Boolean]
        $MAPIEnabled,

        [Parameter()]
        [System.Boolean]
        $OneWinNativeOutlookEnabled,

        [Parameter()]
        [System.Boolean]
        $OutlookMobileEnabled,

        [Parameter()]
        [System.Boolean]
        $OWAEnabled,

        [Parameter()]
        [System.Boolean]
        $OWAforDevicesEnabled,

        [Parameter()]
        [System.String]
        $OwaMailboxPolicy,

        [Parameter()]
        [System.Boolean]
        $PopEnabled,

        [Parameter()]
        [System.Boolean]
        $PopForceICalForCalendarRetrievalOption,

        [Parameter()]
        [System.String]
        $PopMessagesRetrievalMimeFormat,

        [Parameter()]
        [System.Boolean]
        $PopSuppressReadReceipt,

        [Parameter()]
        [System.Boolean]
        $PopUseProtocolDefaults,

        [Parameter()]
        [System.Boolean]
        $PublicFolderClientAccess,

        [Parameter()]
        [System.Boolean]
        $ShowGalAsDefaultView,

        [Parameter()]
        [System.Boolean]
        $SmtpClientAuthenticationDisabled,

        [Parameter()]
        [System.Boolean]
        $UniversalOutlookEnabled,

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

    Write-Verbose -Message "Setting configuration of Exchange Online CAS Mailbox settings for $Identity"

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

    $null = Get-TargetResource @PSBoundParameters
    $CASMailboxParams = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    # CASE: Mailbox exists;
    Write-Verbose -Message "Setting CAS Mailbox settings for $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $CASMailboxParams)"
    Set-CASMailbox @CASMailboxParams -Confirm:$false
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
        [System.String[]]
        $ActiveSyncAllowedDeviceIDs = @(),

        [Parameter()]
        [System.String[]]
        $ActiveSyncBlockedDeviceIDs = @(),

        [Parameter()]
        [System.Boolean]
        $ActiveSyncDebugLogging,

        [Parameter()]
        [System.Boolean]
        $ActiveSyncEnabled,

        [Parameter()]
        [System.String]
        $ActiveSyncMailboxPolicy,

        [Parameter()]
        [System.Boolean]
        $ActiveSyncSuppressReadReceipt,

        [Parameter()]
        [System.Boolean]
        $EwsAllowEntourage,

        [Parameter()]
        [System.String[]]
        $EwsAllowList = @(),

        [Parameter()]
        [System.Boolean]
        $EwsAllowMacOutlook,

        [Parameter()]
        [System.Boolean]
        $EwsAllowOutlook,

        [Parameter()]
        [System.String]
        $EwsApplicationAccessPolicy,

        [Parameter()]
        [System.String[]]
        $EwsBlockList = @(),

        [Parameter()]
        [System.Boolean]
        $EwsEnabled,

        [Parameter()]
        [System.Boolean]
        $ImapEnabled,

        [Parameter()]
        [System.String]
        $ImapMessagesRetrievalMimeFormat,

        [Parameter()]
        [System.Boolean]
        $ImapForceICalForCalendarRetrievalOption,

        [Parameter()]
        [System.Boolean]
        $ImapSuppressReadReceipt,

        [Parameter()]
        [System.Boolean]
        $ImapUseProtocolDefaults,

        [Parameter()]
        [System.Boolean]
        $MacOutlookEnabled,

        [Parameter()]
        [System.Boolean]
        $MAPIEnabled,

        [Parameter()]
        [System.Boolean]
        $OneWinNativeOutlookEnabled,

        [Parameter()]
        [System.Boolean]
        $OutlookMobileEnabled,

        [Parameter()]
        [System.Boolean]
        $OWAEnabled,

        [Parameter()]
        [System.Boolean]
        $OWAforDevicesEnabled,

        [Parameter()]
        [System.String]
        $OwaMailboxPolicy,

        [Parameter()]
        [System.Boolean]
        $PopEnabled,

        [Parameter()]
        [System.Boolean]
        $PopForceICalForCalendarRetrievalOption,

        [Parameter()]
        [System.String]
        $PopMessagesRetrievalMimeFormat,

        [Parameter()]
        [System.Boolean]
        $PopSuppressReadReceipt,

        [Parameter()]
        [System.Boolean]
        $PopUseProtocolDefaults,

        [Parameter()]
        [System.Boolean]
        $PublicFolderClientAccess,

        [Parameter()]
        [System.Boolean]
        $ShowGalAsDefaultView,

        [Parameter()]
        [System.Boolean]
        $SmtpClientAuthenticationDisabled,

        [Parameter()]
        [System.Boolean]
        $UniversalOutlookEnabled,

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
        [array]$mailboxes = Get-CASMailbox -ResultSize 'Unlimited'

        $i = 1
        if ($mailboxes.Count -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n"-DeferWrite
        }
        $dscContent = [System.Text.StringBuilder]::new()
        foreach ($mailbox in $mailboxes)
        {
            Write-M365DSCHost -Message "    |---[$i/$($mailboxes.Count)] $($mailbox.Name)" -DeferWrite
            $mailboxName = $mailbox.Identity
            if (![System.String]::IsNullOrEmpty($mailboxName))
            {
                if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                {
                    $Global:M365DSCExportResourceInstancesCount++
                }

                $Params = @{
                    Credential            = $Credential
                    Identity              = $mailboxName
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    CertificatePassword   = $CertificatePassword
                    ManagedIdentity       = $ManagedIdentity.IsPresent
                    CertificatePath       = $CertificatePath
                    AccessTokens          = $AccessTokens
                }
                $Script:exportedInstance = $mailbox
                $Results = Get-TargetResource @Params
                if ($Results -is [System.Collections.Hashtable] -and $Results.Count -gt 1)
                {
                    $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                        -ConnectionMode $ConnectionMode `
                        -ModulePath $PSScriptRoot `
                        -Results $Results `
                        -Credential $Credential
                    [void]$dscContent.Append($currentDSCBlock)
                    Save-M365DSCPartialExport -Content $currentDSCBlock `
                        -FileName $Global:PartialExportFileName

                    Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
                }
                else
                {
                    Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite
                }
            }

            $i++
        }

        return $dscContent.ToString()
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
