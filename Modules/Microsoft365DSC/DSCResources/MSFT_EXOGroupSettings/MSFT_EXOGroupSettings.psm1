function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupDisplayName,

        [Parameter()]
        [System.String[]]
        $AcceptMessagesOnlyFromSendersOrMembers,

        [Parameter()]
        [System.Boolean]
        $AlwaysSubscribeMembersToCalendarEvents,

        [Parameter()]
        [System.String]
        $AuditLogAgeLimit,

        [Parameter()]
        [System.Boolean]
        $AutoSubscribeNewMembers,

        [Parameter()]
        [System.Boolean]
        $CalendarMemberReadOnly,

        [Parameter()]
        [System.String]
        $Classification,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabled,

        [Parameter()]
        [System.String]
        $CustomAttribute1,

        [Parameter()]
        [System.String]
        $CustomAttribute2,

        [Parameter()]
        [System.String]
        $CustomAttribute3,

        [Parameter()]
        [System.String]
        $CustomAttribute4,

        [Parameter()]
        [System.String]
        $CustomAttribute5,

        [Parameter()]
        [System.String]
        $CustomAttribute6,

        [Parameter()]
        [System.String]
        $CustomAttribute7,

        [Parameter()]
        [System.String]
        $CustomAttribute8,

        [Parameter()]
        [System.String]
        $CustomAttribute9,

        [Parameter()]
        [System.String]
        $CustomAttribute10,

        [Parameter()]
        [System.String]
        $CustomAttribute11,

        [Parameter()]
        [System.String]
        $CustomAttribute12,

        [Parameter()]
        [System.String]
        $CustomAttribute13,

        [Parameter()]
        [System.String]
        $CustomAttribute14,

        [Parameter()]
        [System.String]
        $CustomAttribute15,

        [Parameter()]
        [System.String]
        $DataEncryptionPolicy,

        [Parameter()]
        [System.String[]]
        $EmailAddresses,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute1,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute2,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute3,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute4,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute5,

        [Parameter()]
        [System.String[]]
        $GrantSendOnBehalfTo,

        [Parameter()]
        [System.Boolean]
        $HiddenFromAddressListsEnabled,

        [Parameter()]
        [System.Boolean]
        $HiddenFromExchangeClientsEnabled,

        [Parameter()]
        [System.String]
        $InformationBarrierMode,

        [Parameter()]
        [System.Boolean]
        $IsMemberAllowedToEditContent,

        [Parameter()]
        [System.String]
        $MailboxRegion,

        [Parameter()]
        [System.String]
        $MailTip,

        [Parameter()]
        [System.String]
        $MailTipTranslations,

        [Parameter()]
        [System.UInt32]
        $MaxReceiveSize,

        [Parameter()]
        [System.UInt32]
        $MaxSendSize,

        [Parameter()]
        [System.String[]]
        $ModeratedBy,

        [Parameter()]
        [System.Boolean]
        $ModerationEnabled,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String]
        $PrimarySmtpAddress,

        [Parameter()]
        [System.String[]]
        $RejectMessagesFromSendersOrMembers,

        [Parameter()]
        [System.Boolean]
        $RequireSenderAuthenticationEnabled,

        [Parameter()]
        [System.String]
        $SensitivityLabelId,

        [Parameter()]
        [System.Boolean]
        $SubscriptionEnabled,

        [Parameter()]
        [System.Boolean]
        $UnifiedGroupWelcomeMessageEnabled,

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

    Write-Verbose -Message "Getting configuration of Office 365 Group Settings for $GroupDisplayName"

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
        GroupDisplayName = $GroupDisplayName
    }

    try
    {
        $group = Get-UnifiedGroup -Identity $GroupDisplayName -IncludeAllProperties -ErrorAction Stop
    }
    catch
    {
        return $nullReturn
    }

    if ($null -eq $group)
    {
        Write-Verbose -Message "The specified group {$GroupDisplayName} doesn't already exist."
        return $nullReturn
    }

    $result = @{
        GroupDisplayName                       = $GroupDisplayName
        AcceptMessagesOnlyFromSendersOrMembers = $group.AcceptMessagesOnlyFromSendersOrMembers
        AlwaysSubscribeMembersToCalendarEvents = $group.AlwaysSubscribeMembersToCalendarEvents
        AuditLogAgeLimit                       = $group.AuditLogAgeLimit
        AutoSubscribeNewMembers                = $group.AutoSubscribeNewMembers
        CalendarMemberReadOnly                 = $group.CalendarMemberReadOnly
        Classification                         = $group.Classification
        ConnectorsEnabled                      = $group.ConnectorsEnabled
        CustomAttribute1                       = $group.CustomAttribute1
        CustomAttribute2                       = $group.CustomAttribute2
        CustomAttribute3                       = $group.CustomAttribute3
        CustomAttribute4                       = $group.CustomAttribute4
        CustomAttribute5                       = $group.CustomAttribute5
        CustomAttribute6                       = $group.CustomAttribute6
        CustomAttribute7                       = $group.CustomAttribute7
        CustomAttribute8                       = $group.CustomAttribute8
        CustomAttribute9                       = $group.CustomAttribute9
        CustomAttribute10                      = $group.CustomAttribute10
        CustomAttribute11                      = $group.CustomAttribute11
        CustomAttribute12                      = $group.CustomAttribute12
        CustomAttribute13                      = $group.CustomAttribute13
        CustomAttribute14                      = $group.CustomAttribute14
        CustomAttribute15                      = $group.CustomAttribute15
        DataEncryptionPolicy                   = $group.DataEncryptionPolicy
        EmailAddresses                         = $group.EmailAddresses
        ExtensionCustomAttribute1              = $group.ExtensionCustomAttribute1
        ExtensionCustomAttribute2              = $group.ExtensionCustomAttribute2
        ExtensionCustomAttribute3              = $group.ExtensionCustomAttribute3
        ExtensionCustomAttribute4              = $group.ExtensionCustomAttribute4
        ExtensionCustomAttribute5              = $group.ExtensionCustomAttribute5
        GrantSendOnBehalfTo                    = $group.GrantSendOnBehalfTo
        HiddenFromAddressListsEnabled          = $group.HiddenFromAddressListsEnabled
        HiddenFromExchangeClientsEnabled       = $group.HiddenFromExchangeClientsEnabled
        InformationBarrierMode                 = $group.InformationBarrierMode
        IsMemberAllowedToEditContent           = $group.IsMemberAllowedToEditContent
        MailboxRegion                          = $group.MailboxRegion
        MailTip                                = $group.MailTip
        MailTipTranslations                    = $group.MailTipTranslations
        MaxReceiveSize                         = $group.MaxReceiveSize
        MaxSendSize                            = $group.MaxSendSize
        ModeratedBy                            = $group.ModeratedBy
        ModerationEnabled                      = $group.ModerationEnabled
        Notes                                  = $group.Notes
        PrimarySmtpAddress                     = $group.PrimarySmtpAddress
        RejectMessagesFromSendersOrMembers     = $group.RejectMessagesFromSendersOrMembers
        RequireSenderAuthenticationEnabled     = $group.RequireSenderAuthenticationEnabled
        SensitivityLabelId                     = $group.SensitivityLabelId
        SubscriptionEnabled                    = $group.SubscriptionEnabled
        UnifiedGroupWelcomeMessageEnabled      = $group.UnifiedGroupWelcomeMessageEnabled
        Ensure                                 = $Ensure
        Credential                             = $Credential
        ApplicationId                          = $ApplicationId
        TenantId                               = $TenantId
        CertificateThumbprint                  = $CertificateThumbprint
        CertificatePath                        = $CertificatePath
        CertificatePassword                    = $CertificatePassword
        ManagedIdentity                        = $ManagedIdentity
    }

    Write-Verbose -Message "Found an existing instance of group '$($GroupDisplayName)'"
    return $result
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupDisplayName,

        [Parameter()]
        [System.String[]]
        $AcceptMessagesOnlyFromSendersOrMembers,

        [Parameter()]
        [System.Boolean]
        $AlwaysSubscribeMembersToCalendarEvents,

        [Parameter()]
        [System.String]
        $AuditLogAgeLimit,

        [Parameter()]
        [System.Boolean]
        $AutoSubscribeNewMembers,

        [Parameter()]
        [System.Boolean]
        $CalendarMemberReadOnly,

        [Parameter()]
        [System.String]
        $Classification,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabled,

        [Parameter()]
        [System.String]
        $CustomAttribute1,

        [Parameter()]
        [System.String]
        $CustomAttribute2,

        [Parameter()]
        [System.String]
        $CustomAttribute3,

        [Parameter()]
        [System.String]
        $CustomAttribute4,

        [Parameter()]
        [System.String]
        $CustomAttribute5,

        [Parameter()]
        [System.String]
        $CustomAttribute6,

        [Parameter()]
        [System.String]
        $CustomAttribute7,

        [Parameter()]
        [System.String]
        $CustomAttribute8,

        [Parameter()]
        [System.String]
        $CustomAttribute9,

        [Parameter()]
        [System.String]
        $CustomAttribute10,

        [Parameter()]
        [System.String]
        $CustomAttribute11,

        [Parameter()]
        [System.String]
        $CustomAttribute12,

        [Parameter()]
        [System.String]
        $CustomAttribute13,

        [Parameter()]
        [System.String]
        $CustomAttribute14,

        [Parameter()]
        [System.String]
        $CustomAttribute15,

        [Parameter()]
        [System.String]
        $DataEncryptionPolicy,

        [Parameter()]
        [System.String[]]
        $EmailAddresses,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute1,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute2,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute3,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute4,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute5,

        [Parameter()]
        [System.String[]]
        $GrantSendOnBehalfTo,

        [Parameter()]
        [System.Boolean]
        $HiddenFromAddressListsEnabled,

        [Parameter()]
        [System.Boolean]
        $HiddenFromExchangeClientsEnabled,

        [Parameter()]
        [System.String]
        $InformationBarrierMode,

        [Parameter()]
        [System.Boolean]
        $IsMemberAllowedToEditContent,

        [Parameter()]
        [System.String]
        $MailboxRegion,

        [Parameter()]
        [System.String]
        $MailTip,

        [Parameter()]
        [System.String]
        $MailTipTranslations,

        [Parameter()]
        [System.UInt32]
        $MaxReceiveSize,

        [Parameter()]
        [System.UInt32]
        $MaxSendSize,

        [Parameter()]
        [System.String[]]
        $ModeratedBy,

        [Parameter()]
        [System.Boolean]
        $ModerationEnabled,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String]
        $PrimarySmtpAddress,

        [Parameter()]
        [System.String[]]
        $RejectMessagesFromSendersOrMembers,

        [Parameter()]
        [System.Boolean]
        $RequireSenderAuthenticationEnabled,

        [Parameter()]
        [System.String]
        $SensitivityLabelId,

        [Parameter()]
        [System.Boolean]
        $SubscriptionEnabled,

        [Parameter()]
        [System.Boolean]
        $UnifiedGroupWelcomeMessageEnabled,

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

    Write-Verbose -Message "Setting configuration of Office 365 Mailbox Settings for $DisplayName"

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

    $AllowedTimeZones = (Get-ChildItem 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Time zones' | `
            ForEach-Object { Get-ItemProperty $_.PSPath }).PSChildName

    if ($AllowedTimeZones.Contains($TimeZone) -eq $false)
    {
        throw "The specified Time Zone {$($TimeZone)} is not valid."
    }

    Set-MailboxRegionalConfiguration -Identity $DisplayName `
        -Language $Locale `
        -TimeZone $TimeZone
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupDisplayName,

        [Parameter()]
        [System.String[]]
        $AcceptMessagesOnlyFromSendersOrMembers,

        [Parameter()]
        [System.Boolean]
        $AlwaysSubscribeMembersToCalendarEvents,

        [Parameter()]
        [System.String]
        $AuditLogAgeLimit,

        [Parameter()]
        [System.Boolean]
        $AutoSubscribeNewMembers,

        [Parameter()]
        [System.Boolean]
        $CalendarMemberReadOnly,

        [Parameter()]
        [System.String]
        $Classification,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabled,

        [Parameter()]
        [System.String]
        $CustomAttribute1,

        [Parameter()]
        [System.String]
        $CustomAttribute2,

        [Parameter()]
        [System.String]
        $CustomAttribute3,

        [Parameter()]
        [System.String]
        $CustomAttribute4,

        [Parameter()]
        [System.String]
        $CustomAttribute5,

        [Parameter()]
        [System.String]
        $CustomAttribute6,

        [Parameter()]
        [System.String]
        $CustomAttribute7,

        [Parameter()]
        [System.String]
        $CustomAttribute8,

        [Parameter()]
        [System.String]
        $CustomAttribute9,

        [Parameter()]
        [System.String]
        $CustomAttribute10,

        [Parameter()]
        [System.String]
        $CustomAttribute11,

        [Parameter()]
        [System.String]
        $CustomAttribute12,

        [Parameter()]
        [System.String]
        $CustomAttribute13,

        [Parameter()]
        [System.String]
        $CustomAttribute14,

        [Parameter()]
        [System.String]
        $CustomAttribute15,

        [Parameter()]
        [System.String]
        $DataEncryptionPolicy,

        [Parameter()]
        [System.String[]]
        $EmailAddresses,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute1,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute2,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute3,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute4,

        [Parameter()]
        [System.String]
        $ExtensionCustomAttribute5,

        [Parameter()]
        [System.String[]]
        $GrantSendOnBehalfTo,

        [Parameter()]
        [System.Boolean]
        $HiddenFromAddressListsEnabled,

        [Parameter()]
        [System.Boolean]
        $HiddenFromExchangeClientsEnabled,

        [Parameter()]
        [System.String]
        $InformationBarrierMode,

        [Parameter()]
        [System.Boolean]
        $IsMemberAllowedToEditContent,

        [Parameter()]
        [System.String]
        $MailboxRegion,

        [Parameter()]
        [System.String]
        $MailTip,

        [Parameter()]
        [System.String]
        $MailTipTranslations,

        [Parameter()]
        [System.UInt32]
        $MaxReceiveSize,

        [Parameter()]
        [System.UInt32]
        $MaxSendSize,

        [Parameter()]
        [System.String[]]
        $ModeratedBy,

        [Parameter()]
        [System.Boolean]
        $ModerationEnabled,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String]
        $PrimarySmtpAddress,

        [Parameter()]
        [System.String[]]
        $RejectMessagesFromSendersOrMembers,

        [Parameter()]
        [System.Boolean]
        $RequireSenderAuthenticationEnabled,

        [Parameter()]
        [System.String]
        $SensitivityLabelId,

        [Parameter()]
        [System.Boolean]
        $SubscriptionEnabled,

        [Parameter()]
        [System.Boolean]
        $UnifiedGroupWelcomeMessageEnabled,

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

    Write-Verbose -Message "Testing configuration of Office 365 Mailbox Settings for $DisplayName"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @('DisplayName', `
            'TimeZone', `
            'Locale')

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

    [array]$groups = Get-UnifiedGroup

    $i = 1
    if ($groups.Length -eq 0)
    {
        Write-Host $Global:M365DSCEmojiGreenCheckMark
    }
    else
    {
        Write-Host "`r`n"-NoNewline
    }
    $dscContent = ''
    foreach ($group in $groups)
    {
        Write-Host "    |---[$i/$($groups.Length)] $($group.DisplayName)" -NoNewline
        $groupName = $group.DisplayName
        if (-not [System.String]::IsNullOrEmpty($groupName))
        {
            $Params = @{
                Credential            = $Credential
                GroupDisplayName      = $groupName
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                Managedidentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
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

Export-ModuleMember -Function *-TargetResource
