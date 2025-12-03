Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXOGroupSettings'

$Script:displayNameProperties = @{
    IncludeAcceptMessagesOnlyFromSendersOrMembersWithDisplayNames = $true
    IncludeGrantSendOnBehalfToWithDisplayNames                    = $true
    IncludeModeratedByWithDisplayNames                            = $true
    IncludeRejectMessagesFromSendersOrMembersWithDisplayNames     = $true
}

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String[]]
        $AcceptMessagesOnlyFromSendersOrMembers,

        [Parameter()]
        [ValidateSet('Public', 'Private')]
        [System.String]
        $AccessType,

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
        [System.String[]]
        $ExtensionCustomAttribute1,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute2,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute3,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute4,

        [Parameter()]
        [System.String[]]
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
        [ValidateSet('Explicit', 'Implicit', 'Open', 'OwnerModerated')]
        [System.String]
        $InformationBarrierMode,

        [Parameter()]
        [System.Boolean]
        $IsMemberAllowedToEditContent,

        [Parameter()]
        [System.String]
        $Language,

        [Parameter()]
        [System.String]
        $MailboxRegion,

        [Parameter()]
        [System.String]
        $MailTip,

        [Parameter()]
        [System.String[]]
        $MailTipTranslations,

        [Parameter()]
        [System.String]
        $MaxReceiveSize,

        [Parameter()]
        [System.String]
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
        $WelcomeMessageEnabled,

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

    Write-Verbose -Message "Getting configuration of Office 365 Group Settings for $DisplayName"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
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
                DisplayName = $DisplayName
            }

            Write-Verbose -Message "Retrieving group by id {$Id}"
            [array]$group = Get-UnifiedGroup -Identity $Id -IncludeAllProperties @Script:displayNameProperties -ErrorAction SilentlyContinue

            if ($group.Count -eq 0)
            {
                Write-Verbose -Message "Couldn't retrieve group by ID. Trying by DisplayName {$DisplayName}"
                [array]$group = Get-UnifiedGroup -Identity $DisplayName -IncludeAllProperties @Script:displayNameProperties -ErrorAction SilentlyContinue
            }

            if ($group.Count -gt 1)
            {
                Write-Warning -Message "Multiple instances of a group named {$DisplayName} was discovered which could result in inconsistencies retrieving its values."
            }
            $group = $group[0]
            if ($null -eq $group)
            {
                Write-Verbose -Message "The specified group {$DisplayName} doesn't already exist."
                return $nullReturn
            }
        }
        else
        {
            $group = $Script:exportedInstance
        }

        $ExtensionCustomAttribute1Value = $group.ExtensionCustomAttribute1
        if ($null -eq $group.ExtensionCustomAttribute1)
        {
            $ExtensionCustomAttribute1Value = @()
        }

        $ExtensionCustomAttribute2Value = $group.ExtensionCustomAttribute2
        if ($null -eq $group.ExtensionCustomAttribute2)
        {
            $ExtensionCustomAttribute2Value = @()
        }

        $ExtensionCustomAttribute3Value = $group.ExtensionCustomAttribute3
        if ($null -eq $group.ExtensionCustomAttribute3)
        {
            $ExtensionCustomAttribute3Value = @()
        }

        $ExtensionCustomAttribute4Value = $group.ExtensionCustomAttribute4
        if ($null -eq $group.ExtensionCustomAttribute4)
        {
            $ExtensionCustomAttribute4Value = @()
        }

        $ExtensionCustomAttribute5Value = $group.ExtensionCustomAttribute5
        if ($null -eq $group.ExtensionCustomAttribute5)
        {
            $ExtensionCustomAttribute5Value = @()
        }

        $GrantSendOnBehalfToValue = Get-DisplayNameSimplified -DisplayName $group.GrantSendOnBehalfToWithDisplayNames
        if ($null -eq $group.GrantSendOnBehalfToWithDisplayNames)
        {
            $GrantSendOnBehalfToValue = @()
        }

        $ModeratedByValue = Get-DisplayNameSimplified -DisplayName $group.ModeratedByWithDisplayNames
        if ($null -eq $group.ModeratedByWithDisplayNames)
        {
            $ModeratedByValue = @()
        }

        $AcceptMessagesOnlyFromSendersOrMembersValue = Get-DisplayNameSimplified -DisplayName $group.AcceptMessagesOnlyFromSendersOrMembersWithDisplayNames
        if ($null -eq $group.AcceptMessagesOnlyFromSendersOrMembersWithDisplayNames)
        {
            $AcceptMessagesOnlyFromSendersOrMembersValue = @()
        }

        $MailTipTranslationsValue = $group.MailTipTranslations
        if ($null -eq $group.MailTipTranslations)
        {
            $MailTipTranslationsValue = @()
        }

        $RejectMessagesFromSendersOrMembersValue = Get-DisplayNameSimplified -DisplayName $group.RejectMessagesFromSendersOrMembersWithDisplayNames
        if ($null -eq $group.RejectMessagesFromSendersOrMembersWithDisplayNames)
        {
            $RejectMessagesFromSendersOrMembersValue = @()
        }

        $result = @{
            DisplayName                            = $DisplayName
            Id                                     = $group.Id
            AcceptMessagesOnlyFromSendersOrMembers = $AcceptMessagesOnlyFromSendersOrMembersValue
            AccessType                             = $group.AccessType
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
            ExtensionCustomAttribute1              = $ExtensionCustomAttribute1Value
            ExtensionCustomAttribute2              = $ExtensionCustomAttribute2Value
            ExtensionCustomAttribute3              = $ExtensionCustomAttribute3Value
            ExtensionCustomAttribute4              = $ExtensionCustomAttribute4Value
            ExtensionCustomAttribute5              = $ExtensionCustomAttribute5Value
            GrantSendOnBehalfTo                    = $GrantSendOnBehalfToValue
            HiddenFromAddressListsEnabled          = $group.HiddenFromAddressListsEnabled
            HiddenFromExchangeClientsEnabled       = $group.HiddenFromExchangeClientsEnabled
            InformationBarrierMode                 = $group.InformationBarrierMode
            IsMemberAllowedToEditContent           = $group.IsMemberAllowedToEditContent
            Language                               = $group.Language.Name
            MailboxRegion                          = $group.MailboxRegion
            MailTip                                = $group.MailTip
            MailTipTranslations                    = $MailTipTranslationsValue
            MaxReceiveSize                         = $group.MaxReceiveSize
            MaxSendSize                            = $group.MaxSendSize
            ModeratedBy                            = $ModeratedByValue
            ModerationEnabled                      = $group.ModerationEnabled
            Notes                                  = $group.Notes
            PrimarySmtpAddress                     = $group.PrimarySmtpAddress
            RejectMessagesFromSendersOrMembers     = $RejectMessagesFromSendersOrMembersValue
            RequireSenderAuthenticationEnabled     = $group.RequireSenderAuthenticationEnabled
            SensitivityLabelId                     = $group.SensitivityLabelId
            SubscriptionEnabled                    = $group.SubscriptionEnabled
            WelcomeMessageEnabled                  = $group.WelcomeMessageEnabled
            Credential                             = $Credential
            ApplicationId                          = $ApplicationId
            TenantId                               = $TenantId
            CertificateThumbprint                  = $CertificateThumbprint
            CertificatePath                        = $CertificatePath
            CertificatePassword                    = $CertificatePassword
            ManagedIdentity                        = $ManagedIdentity
            AccessTokens                           = $AccessTokens
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String[]]
        $AcceptMessagesOnlyFromSendersOrMembers,

        [Parameter()]
        [ValidateSet('Public', 'Private')]
        [System.String]
        $AccessType,

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
        [System.String[]]
        $ExtensionCustomAttribute1,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute2,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute3,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute4,

        [Parameter()]
        [System.String[]]
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
        [ValidateSet('Explicit', 'Implicit', 'Open', 'OwnerModerated')]
        $InformationBarrierMode,

        [Parameter()]
        [System.Boolean]
        $IsMemberAllowedToEditContent,

        [Parameter()]
        [System.String]
        $Language,

        [Parameter()]
        [System.String]
        $MailboxRegion,

        [Parameter()]
        [System.String]
        $MailTip,

        [Parameter()]
        [System.String[]]
        $MailTipTranslations,

        [Parameter()]
        [System.String]
        $MaxReceiveSize,

        [Parameter()]
        [System.String]
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
        $WelcomeMessageEnabled,

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

    Write-Verbose -Message "Setting configuration of Office 365 group Settings for $DisplayName"

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

    $CurrentValues = Get-TargetResource @PSBoundParameters

    $UpdateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $UpdateParameters.Add('Identity', $CurrentValues.Id)
    $UpdateParameters.Remove('Id') | Out-Null
    $UpdateParameters.Remove('DisplayName') | Out-Null

    # Cannot use PrimarySmtpAddress and EmailAddresses at the same time. If both are present, then give priority to PrimarySmtpAddress.
    if ($UpdateParameters.ContainsKey('PrimarySmtpAddress') -and $null -ne $UpdateParameters.PrimarySmtpAddress)
    {
        $UpdateParameters.Remove('EmailAddresses') | Out-Null
    }

    # Renaming of WelcomeMessageEnabled to UnifiedGroupWelcomeMessageEnabled
    if ($UpdateParameters.ContainsKey('WelcomeMessageEnabled'))
    {
        $UpdateParameters.Add('UnifiedGroupWelcomeMessageEnabled', $UpdateParameters.WelcomeMessageEnabled)
        $UpdateParameters.Remove('WelcomeMessageEnabled') | Out-Null
    }

    foreach ($key in $Script:displayNameProperties.Keys)
    {
        $key = $key.Replace("Include", "").Replace("WithDisplayNames", "")
        if ($PSBoundParameters.ContainsKey($key))
        {
            if ($null -eq $Script:RecipientsCache2)
            {
                $Script:RecipientsCache2 = [System.Collections.Generic.Dictionary[System.String, System.Object]]::new()
                if ($null -eq $Script:RecipientsCache)
                {
                    $recipients = Get-Recipient -ResultSize Unlimited
                    foreach ($recipient in $recipients)
                    {
                        $Script:RecipientsCache2[$recipient.PrimarySmtpAddress] = @{
                            Name               = $recipient.Name
                            PrimarySmtpAddress = $recipient.PrimarySmtpAddress
                            WindowsLiveID      = $recipient.WindowsLiveID
                        }
                    }
                }
                else
                {
                    foreach ($entry in $Script:RecipientsCache.GetEnumerator())
                    {
                        $Script:RecipientsCache2[$entry.Value.PrimarySmtpAddress] = $entry.Value
                    }
                }
            }

            $convertedList = [System.Collections.Generic.List[System.String]]::new()
            foreach ($member in $UpdateParameters.$key)
            {
                # If member is a GUID, keep as-is
                $guid = [System.Guid]::Empty
                if ([System.Guid]::TryParse($member, [ref]$guid))
                {
                    $convertedList.Add($member)
                    continue
                }

                $entry = $null
                if ($Script:RecipientsCache2.TryGetValue($member, [ref]$entry))
                {
                    $convertedList.Add($entry.Name)
                }
                else
                {
                    $convertedList.Add($member)
                }
            }

            $UpdateParameters[$key] = $convertedList.ToArray()
        }
    }

    Set-UnifiedGroup @UpdateParameters
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String[]]
        $AcceptMessagesOnlyFromSendersOrMembers,

        [Parameter()]
        [ValidateSet('Public', 'Private')]
        [System.String]
        $AccessType,

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
        [System.String[]]
        $ExtensionCustomAttribute1,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute2,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute3,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute4,

        [Parameter()]
        [System.String[]]
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
        [ValidateSet('Explicit', 'Implicit', 'Open', 'OwnerModerated')]
        $InformationBarrierMode,

        [Parameter()]
        [System.Boolean]
        $IsMemberAllowedToEditContent,

        [Parameter()]
        [System.String]
        $Language,

        [Parameter()]
        [System.String]
        $MailboxRegion,

        [Parameter()]
        [System.String]
        $MailTip,

        [Parameter()]
        [System.String[]]
        $MailTipTranslations,

        [Parameter()]
        [System.String]
        $MaxReceiveSize,

        [Parameter()]
        [System.String]
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
        $WelcomeMessageEnabled,

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

    $postProcessingScript = {
        param($DesiredValues, $CurrentValues, $ValuesToCheck, $ignore)
        foreach ($key in $Script:displayNameProperties.Keys)
        {
            $key = $key.Replace("Include", "").Replace("WithDisplayNames", "")
            if ($DesiredValues.ContainsKey($key))
            {
                if ($null -eq $Script:RecipientsCache)
                {
                    $Script:RecipientsCache = [System.Collections.Generic.Dictionary[System.String, System.Object]]::new()
                    Get-Recipient -ResultSize Unlimited | Foreach-Object {
                        $Script:RecipientsCache[$_.Name] = @{
                            Name               = $_.Name
                            PrimarySmtpAddress = $_.PrimarySmtpAddress
                            WindowsLiveID      = $_.WindowsLiveID
                        }
                    }
                }
                $convertedValues = @()
                foreach ($member in $DesiredValues.$key)
                {
                    $guid = [System.Guid]::Empty
                    if ([System.Guid]::TryParse($member, [ref]$guid))
                    {
                        $entry = $null
                        if ($Script:RecipientsCache.TryGetValue($member, [ref]$entry))
                        {
                            $convertedValues += $entry.PrimarySmtpAddress
                        }
                        else
                        {
                            $convertedValues += $member
                        }
                    }
                    else
                    {
                        $convertedValues += $member
                    }
                }
                $DesiredValues.$key = $convertedValues
            }
        }
        return [System.Tuple[Hashtable, Hashtable, Hashtable]]::new($DesiredValues, $CurrentValues, $ValuesToCheck)
    }
    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
                                         -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
                                         -PostProcessing $postProcessingScript
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
        [array] $Script:exportedInstances = Get-UnifiedGroup -ResultSize Unlimited @Script:displayNameProperties -ErrorAction SilentlyContinue

        $i = 1
        if ($Script:exportedInstances.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n"-DeferWrite
        }
        $dscContent = [System.Text.StringBuilder]::New()
        foreach ($group in $Script:exportedInstances)
        {
            Write-M365DSCHost -Message "    |---[$i/$($Script:exportedInstances.Length)] $($group.DisplayName)" -DeferWrite
            $groupName = $group.DisplayName
            if (-not [System.String]::IsNullOrEmpty($groupName))
            {
                if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                {
                    $Global:M365DSCExportResourceInstancesCount++
                }

                $Params = @{
                    Credential            = $Credential
                    DisplayName           = $groupName
                    Id                    = $group.Id
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    CertificatePassword   = $CertificatePassword
                    ManagedIdentity       = $ManagedIdentity.IsPresent
                    CertificatePath       = $CertificatePath
                    AccessTokens          = $AccessTokens
                }
                $Script:exportedInstance = $group
                $Results = Get-TargetResource @Params
                if ($Results -is [System.Collections.Hashtable] -and $Results.Count -gt 1)
                {
                    $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                        -ConnectionMode $ConnectionMode `
                        -ModulePath $PSScriptRoot `
                        -Results $Results `
                        -Credential $Credential
                    $dscContent.Append($currentDSCBlock) | Out-Null
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
        Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

function Get-DisplayNameSimplified
{
    param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [AllowNull()]
        [System.String[]]
        $DisplayName
    )

    $simplifiedNames = @()
    foreach ($name in $DisplayName)
    {
        $simplifiedNames += $name.Split(',')[0].Replace('(','')
    }
    return $simplifiedNames | Sort-Object
}

Export-ModuleMember -Function *-TargetResource
