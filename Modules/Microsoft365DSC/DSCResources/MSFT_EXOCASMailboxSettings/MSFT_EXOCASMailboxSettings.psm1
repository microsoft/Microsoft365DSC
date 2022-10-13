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
        $ManagedIdentity
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

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'

    try
    {
        $mailboxCasSettings = Get-CASMailbox -Identity $Identity -ErrorAction Stop
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
        Ensure                                  = 'Present'
        Credential                              = $Credential
        ApplicationId                           = $ApplicationId
        CertificateThumbprint                   = $CertificateThumbprint
        CertificatePath                         = $CertificatePath
        CertificatePassword                     = $CertificatePassword
        Managedidentity                         = $ManagedIdentity.IsPresent
        TenantId                                = $TenantId
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
        $ManagedIdentity
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
    $CASMailboxParams.Remove('Managedidentity') | Out-Null

    # CASE: Mailbox doesn't exist but should;
    if ($Ensure -eq 'Present' -and $currentMailbox.Ensure -eq 'Absent')
    {
        throw "The specified mailbox {$($Identity)} does not exist."
    }

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
        $ManagedIdentity
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
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('CertificateThumbprint') | Out-Null
    $ValuesToCheck.Remove('CertificatePath') | Out-Null
    $ValuesToCheck.Remove('CertificatePassword') | Out-Null
    $ValuesToCheck.Remove('Managedidentity') | Out-Null

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
        $ManagedIdentity
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

    [array]$mailboxes = Get-Mailbox -ResultSize 'Unlimited'

    $i = 1
    if ($mailboxes.Length -eq 0)
    {
        Write-Host $Global:M365DSCEmojiGreenCheckMark
    }
    else
    {
        Write-Host "`r`n"-NoNewline
    }
    $dscContent = ''
    foreach ($mailbox in $mailboxes)
    {
        Write-Host "    |---[$i/$($mailboxes.Length)] $($mailbox.Name)" -NoNewline
        $mailboxName = $mailbox.UserPrincipalName
        if (![System.String]::IsNullOrEmpty($mailboxName))
        {
            $Params = @{
                Credential            = $Credential
                Identity              = $mailboxName
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                Managedidentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
            }
            $Results = Get-TargetResource @Params

            if ($Results.Ensure -eq 'Present')
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
            }
        }
        Write-Host $Global:M365DSCEmojiGreenCheckMark
        $i++
    }
    return $dscContent
}

Export-ModuleMember -Function *-TargetResource
