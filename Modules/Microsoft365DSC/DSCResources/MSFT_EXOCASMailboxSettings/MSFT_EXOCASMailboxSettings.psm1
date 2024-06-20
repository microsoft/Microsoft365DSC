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

    $nullReturn = @{
        Identity = $Identity
    }

    try
    {
        if ($null -ne $Script:exportedInstances -and $Script:ExportMode)
        {
            $mailboxCasSettings = $Script:exportedInstances | Where-Object -FilterScript {$_.Identity -eq $Identity}
        }
        else
        {
            $mailboxCasSettings = Get-CASMailbox -Identity $Identity -ErrorAction Stop
        }
    }
    catch
    {
        return $nullReturn
    }

    if ($null -eq $mailboxCasSettings)
    {
        Write-Verbose -Message 'The specified Mailbox does not exist.'
        return $nullReturn
    }

    $result = @{
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
        Managedidentity                         = $ManagedIdentity.IsPresent
        TenantId                                = $TenantId
        AccessTokens                            = $AccessTokens
    }

    Write-Verbose -Message "Found an existing instance of Mailbox '$($Identity)'"
    return $result
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
    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $currentMailbox = Get-TargetResource @PSBoundParameters

    $CASMailboxParams = [System.Collections.Hashtable]($PSBoundParameters)
    $CASMailboxParams.Remove('Ensure') | Out-Null
    $CASMailboxParams.Remove('Credential') | Out-Null
    $CASMailboxParams.Remove('ApplicationId') | Out-Null
    $CASMailboxParams.Remove('TenantId') | Out-Null
    $CASMailboxParams.Remove('CertificateThumbprint') | Out-Null
    $CASMailboxParams.Remove('CertificatePath') | Out-Null
    $CASMailboxParams.Remove('CertificatePassword') | Out-Null
    $CASMailboxParams.Remove('ManagedIdentity') | Out-Null
    $CASMailboxParams.Remove('AccessTokens') | Out-Null

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

    Write-Verbose -Message "Testing configuration of Exchange Online CAS Mailbox Settings for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Ensure') | Out-Null

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
        $Script:ExportMode = $true
        [array] $Script:exportedInstances = Get-CASMailbox -ResultSize 'Unlimited'

        $i = 1
        if ($Script:exportedInstances.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n"-NoNewline
        }
        $dscContent = ''
        foreach ($mailbox in $Script:exportedInstances)
        {
            Write-Host "    |---[$i/$($Script:exportedInstances.Length)] $($mailbox.Name)" -NoNewline
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
                    Managedidentity       = $ManagedIdentity.IsPresent
                    CertificatePath       = $CertificatePath
                    AccessTokens          = $AccessTokens
                }
                $Results = Get-TargetResource @Params

                if ($Results -is [System.Collections.Hashtable] -and $Results.Count -gt 1)
                {
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
                }
                else
                {
                    Write-Host $Global:M365DSCEmojiRedX
                }
            }

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
