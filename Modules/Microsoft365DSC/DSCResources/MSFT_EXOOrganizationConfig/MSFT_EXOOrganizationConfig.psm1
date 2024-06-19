function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $ActivityBasedAuthenticationTimeoutEnabled,

        [Parameter()]
        [System.String]
        [ValidatePattern('^(0[0-7]:[0-5][0-9]:[0-5][0-9]|08:00:00)$')]
        $ActivityBasedAuthenticationTimeoutInterval,

        [Parameter()]
        [System.Boolean]
        $ActivityBasedAuthenticationTimeoutWithSingleSignOnEnabled,

        [Parameter()]
        [System.Boolean]
        $AppsForOfficeEnabled,

        [Parameter()]
        [System.Boolean]
        $AsyncSendEnabled,

        [Parameter()]
        [System.Boolean]
        $AuditDisabled,

        [Parameter()]
        [System.Boolean]
        $AutodiscoverPartialDirSync,

        [Parameter()]
        [System.Boolean]
        $AutoExpandingArchive,

        [Parameter()]
        [System.Boolean]
        $BlockMoveMessagesForGroupFolders,

        [Parameter()]
        [System.Boolean]
        $BookingsAddressEntryRestricted,

        [Parameter()]
        [System.Boolean]
        $BookingsAuthEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsBlockedWordsEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsCreationOfCustomQuestionsRestricted,

        [Parameter()]
        [System.Boolean]
        $BookingsEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsExposureOfStaffDetailsRestricted,

        [Parameter()]
        [System.Boolean]
        $BookingsMembershipApprovalRequired,

        [Parameter()]
        [System.Boolean]
        $BookingsNamingPolicyEnabled,

        [Parameter()]
        [System.String]
        $BookingsNamingPolicyPrefix,

        [Parameter()]
        [System.Boolean]
        $BookingsNamingPolicyPrefixEnabled,

        [Parameter()]
        [System.String]
        $BookingsNamingPolicySuffix,

        [Parameter()]
        [System.Boolean]
        $BookingsNamingPolicySuffixEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsNotesEntryRestricted,

        [Parameter()]
        [System.Boolean]
        $BookingsPaymentsEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsPhoneNumberEntryRestricted,

        [Parameter()]
        [System.Boolean]
        $BookingsSearchEngineIndexDisabled,

        [Parameter()]
        [System.Boolean]
        $BookingsSmsMicrosoftEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsSocialSharingRestricted,

        [Parameter()]
        [System.UInt32]
        $ByteEncoderTypeFor7BitCharsets,

        [Parameter()]
        [System.Boolean]
        $ComplianceMLBgdCrawlEnabled,

        [Parameter()]
        [System.Boolean]
        $ConnectorsActionableMessagesEnabled,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabled,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabledForOutlook,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabledForSharepoint,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabledForTeams,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabledForYammer,

        [Parameter()]
        [System.Boolean]
        $CustomerLockboxEnabled,

        [Parameter()]
        [System.String]
        $DefaultAuthenticationPolicy,

        [Parameter()]
        [ValidateSet('Private', 'Public')]
        [System.String]
        $DefaultGroupAccessType,

        [Parameter()]
        [ValidateRange(0, 29)]
        [System.UInt32]
        $DefaultMinutesToReduceLongEventsBy,

        [Parameter()]
        [ValidateRange(0, 29)]
        [System.UInt32]
        $DefaultMinutesToReduceShortEventsBy,

        [Parameter()]
        [System.String]
        [ValidatePattern('^([0-9][0-9]|[0-9]).[0-9][0-9]:[0-9][0-9]:[0-9][0-9]$')]
        $DefaultPublicFolderAgeLimit,

        [Parameter()]
        [System.String]
        [ValidatePattern('^([0-9][0-9]|[0-9]).[0-9][0-9]:[0-9][0-9]:[0-9][0-9]$')]
        $DefaultPublicFolderDeletedItemRetention,

        [Parameter()]
        [System.String]
        $DefaultPublicFolderIssueWarningQuota,

        [Parameter()]
        [System.String]
        $DefaultPublicFolderMaxItemSize,

        [Parameter()]
        [System.String]
        [ValidatePattern('^([0-9][0-9]|[0-9]).[0-9][0-9]:[0-9][0-9]:[0-9][0-9]$')]
        $DefaultPublicFolderMovedItemRetention,

        [Parameter()]
        [System.String]
        $DefaultPublicFolderProhibitPostQuota,

        [Parameter()]
        [System.Boolean]
        $DirectReportsGroupAutoCreationEnabled,

        [Parameter()]
        [System.Boolean]
        $DisablePlusAddressInRecipients,

        [Parameter()]
        [System.String]
        $DistributionGroupDefaultOU,

        [Parameter()]
        [System.String[]]
        $DistributionGroupNameBlockedWordsList,

        [Parameter()]
        [System.String]
        $DistributionGroupNamingPolicy,

        [Parameter()]
        [System.Boolean]
        $ElcProcessingDisabled,

        [Parameter()]
        [System.Boolean]
        $EndUserDLUpgradeFlowsDisabled,

        [Parameter()]
        [System.Boolean]
        $EnableOutlookEvents,

        [Parameter()]
        [System.Boolean]
        $EwsAllowEntourage,

        [Parameter()]
        [System.String[]]
        $EwsAllowList,

        [Parameter()]
        [System.Boolean]
        $EwsAllowMacOutlook,

        [Parameter()]
        [System.Boolean]
        $EwsAllowOutlook,

        [Parameter()]
        [ValidateSet('EnforceAllowList', 'EnforceBlockList')]
        [System.String]
        $EwsApplicationAccessPolicy,

        [Parameter()]
        [System.String[]]
        $EwsBlockList,

        [Parameter()]
        [System.Boolean]
        $EwsEnabled,

        [Parameter()]
        [System.Boolean]
        $ExchangeNotificationEnabled,

        [Parameter()]
        [System.String[]]
        $ExchangeNotificationRecipients,

        [Parameter()]
        [System.Boolean]
        $FindTimeAttendeeAuthenticationEnabled,

        [Parameter()]
        [System.Boolean]
        $FindTimeAutoScheduleDisabled,

        [Parameter()]
        [System.Boolean]
        $FindTimeLockPollForAttendeesEnabled,

        [Parameter()]
        [System.Boolean]
        $FindTimeOnlineMeetingOptionDisabled,

        [Parameter()]
        [System.Boolean]
        $FocusedInboxOn,

        [Parameter()]
        [System.String]
        $HierarchicalAddressBookRoot,

        [Parameter()]
        [System.String[]]
        $IPListBlocked,

        [Parameter()]
        [System.Boolean]
        $IsGroupFoldersAndRulesEnabled,

        [Parameter()]
        [System.Boolean]
        $IsGroupMemberAllowedToEditContent,

        [Parameter()]
        [System.Boolean]
        $LeanPopoutEnabled,

        [Parameter()]
        [System.Boolean]
        $LinkPreviewEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsAllTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsExternalRecipientsTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsGroupMetricsEnabled,

        [Parameter()]
        [System.UInt32]
        $MailTipsLargeAudienceThreshold,

        [Parameter()]
        [System.Boolean]
        $MailTipsMailboxSourcedTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MaskClientIpInReceivedHeadersEnabled,

        [Parameter()]
        [System.Boolean]
        $MatchSenderOrganizerProperties,

        [Parameter()]
        [System.Boolean]
        $MessageHighlightsEnabled,

        [Parameter()]
        [System.Boolean]
        $MessageRecallEnabled,

        [Parameter()]
        [System.Boolean]
        $MessageRemindersEnabled,

        [Parameter()]
        [System.Boolean]
        $MobileAppEducationEnabled,

        [Parameter()]
        [System.Boolean]
        $OAuth2ClientProfileEnabled,

        [Parameter()]
        [System.Boolean]
        $OnlineMeetingsByDefaultEnabled,

        [Parameter()]
        [System.Boolean]
        $OutlookGifPickerDisabled,

        [Parameter()]
        [System.Boolean]
        $OutlookMobileGCCRestrictionsEnabled,

        [Parameter()]
        [System.Boolean]
        $OutlookPayEnabled,

        [Parameter()]
        [System.Boolean]
        $OutlookTextPredictionDisabled,

        [Parameter()]
        [System.Boolean]
        $PublicComputersDetectionEnabled,

        [Parameter()]
        [ValidateSet('None', 'Local', 'Remote')]
        [System.String]
        $PublicFoldersEnabled,

        [Parameter()]
        [System.Boolean]
        $PublicFolderShowClientControl,

        [Parameter()]
        [System.Boolean]
        $ReadTrackingEnabled,

        [Parameter()]
        [System.Boolean]
        $RecallReadMessagesEnabled,

        [Parameter()]
        [System.String[]]
        $RemotePublicFolderMailboxes,

        [Parameter()]
        [System.Boolean]
        $SendFromAliasEnabled,

        [Parameter()]
        [System.Boolean]
        $SharedDomainEmailAddressFlowEnabled,

        [Parameter()]
        [System.String]
        $ShortenEventScopeDefault,

        [Parameter()]
        [System.String]
        $SiteMailboxCreationURL,

        [Parameter()]
        [System.Boolean]
        $SmtpActionableMessagesEnabled,

        [Parameter()]
        [System.String]
        $VisibleMeetingUpdateProperties,

        [Parameter()]
        [System.Boolean]
        $WebPushNotificationsDisabled,

        [Parameter()]
        [System.Boolean]
        $WebSuggestedRepliesDisabled,

        [Parameter()]
        [System.Boolean]
        $WorkspaceTenantEnabled,

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

    Write-Verbose -Message 'Getting EXOOrganizationConfig'
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
        IsSingleInstance = 'Yes'
    }

    try
    {
        $ConfigSettings = Get-OrganizationConfig -ErrorAction Stop
        if ($null -eq $ConfigSettings)
        {
            throw 'There was an error retrieving values from the Get function in EXOOrganizationConfig.'
        }

        $results = @{
            IsSingleInstance                                          = 'Yes'
            ActivityBasedAuthenticationTimeoutEnabled                 = $ConfigSettings.ActivityBasedAuthenticationTimeoutEnabled
            ActivityBasedAuthenticationTimeoutInterval                = $ConfigSettings.ActivityBasedAuthenticationTimeoutInterval
            ActivityBasedAuthenticationTimeoutWithSingleSignOnEnabled = $ConfigSettings.ActivityBasedAuthenticationTimeoutWithSingleSignOnEnabled
            AppsForOfficeEnabled                                      = $ConfigSettings.AppsForOfficeEnabled
            AsyncSendEnabled                                          = $ConfigSettings.AsyncSendEnabled
            AuditDisabled                                             = $ConfigSettings.AuditDisabled
            AutodiscoverPartialDirSync                                = $ConfigSettings.AutodiscoverPartialDirSync
            AutoExpandingArchive                                      = $ConfigSettings.AutoExpandingArchiveEnabled
            BlockMoveMessagesForGroupFolders                          = $ConfigSettings.BlockMoveMessagesForGroupFolders
            BookingsAddressEntryRestricted                            = $ConfigSettings.BookingsAddressEntryRestricted
            BookingsAuthEnabled                                       = $ConfigSettings.BookingsAuthEnabled
            BookingsBlockedWordsEnabled                               = $ConfigSettings.BookingsBlockedWordsEnabled
            BookingsCreationOfCustomQuestionsRestricted               = $ConfigSettings.BookingsCreationOfCustomQuestionsRestricted
            BookingsEnabled                                           = $ConfigSettings.BookingsEnabled
            BookingsExposureOfStaffDetailsRestricted                  = $ConfigSettings.BookingsExposureOfStaffDetailsRestricted
            BookingsMembershipApprovalRequired                        = $ConfigSettings.BookingsMembershipApprovalRequired
            BookingsNamingPolicyEnabled                               = $ConfigSettings.BookingsNamingPolicyEnabled
            BookingsNamingPolicyPrefix                                = $ConfigSettings.BookingsNamingPolicyPrefix
            BookingsNamingPolicyPrefixEnabled                         = $ConfigSettings.BookingsNamingPolicyPrefixEnabled
            BookingsNamingPolicySuffix                                = $ConfigSettings.BookingsNamingPolicySuffix
            BookingsNamingPolicySuffixEnabled                         = $ConfigSettings.BookingsNamingPolicySuffixEnabled
            BookingsNotesEntryRestricted                              = $ConfigSettings.BookingsNotesEntryRestricted
            BookingsPaymentsEnabled                                   = $ConfigSettings.BookingsPaymentsEnabled
            BookingsPhoneNumberEntryRestricted                        = $ConfigSettings.BookingsPhoneNumberEntryRestricted
            BookingsSearchEngineIndexDisabled                         = $ConfigSettings.BookingsSearchEngineIndexDisabled
            BookingsSmsMicrosoftEnabled                               = $ConfigSettings.BookingsSmsMicrosoftEnabled
            BookingsSocialSharingRestricted                           = $ConfigSettings.BookingsSocialSharingRestricted
            ByteEncoderTypeFor7BitCharsets                            = $ConfigSettings.ByteEncoderTypeFor7BitCharsets
            ComplianceMLBgdCrawlEnabled                               = $ConfigSettings.ComplianceMLBgdCrawlEnabled
            ConnectorsActionableMessagesEnabled                       = $ConfigSettings.ConnectorsActionableMessagesEnabled
            ConnectorsEnabled                                         = $ConfigSettings.ConnectorsEnabled
            ConnectorsEnabledForOutlook                               = $ConfigSettings.ConnectorsEnabledForOutlook
            ConnectorsEnabledForSharepoint                            = $ConfigSettings.ConnectorsEnabledForSharepoint
            ConnectorsEnabledForTeams                                 = $ConfigSettings.ConnectorsEnabledForTeams
            ConnectorsEnabledForYammer                                = $ConfigSettings.ConnectorsEnabledForYammer
            CustomerLockboxEnabled                                    = $ConfigSettings.CustomerLockboxEnabled
            DefaultAuthenticationPolicy                               = $ConfigSettings.DefaultAuthenticationPolicy
            DefaultGroupAccessType                                    = $ConfigSettings.DefaultGroupAccessType
            DefaultMinutesToReduceLongEventsBy                        = $ConfigSettings.DefaultMinutesToReduceLongEventsBy
            DefaultMinutesToReduceShortEventsBy                       = $ConfigSettings.DefaultMinutesToReduceShortEventsBy
            DefaultPublicFolderAgeLimit                               = $ConfigSettings.DefaultPublicFolderAgeLimit
            DefaultPublicFolderDeletedItemRetention                   = $ConfigSettings.DefaultPublicFolderDeletedItemRetention
            DefaultPublicFolderIssueWarningQuota                      = $ConfigSettings.DefaultPublicFolderIssueWarningQuota
            DefaultPublicFolderMaxItemSize                            = $ConfigSettings.DefaultPublicFolderMaxItemSize
            DefaultPublicFolderMovedItemRetention                     = $ConfigSettings.DefaultPublicFolderMovedItemRetention
            DefaultPublicFolderProhibitPostQuota                      = $ConfigSettings.DefaultPublicFolderProhibitPostQuota
            DirectReportsGroupAutoCreationEnabled                     = $ConfigSettings.DirectReportsGroupAutoCreationEnabled
            DisablePlusAddressInRecipients                            = $ConfigSettings.DisablePlusAddressInRecipients
            DistributionGroupDefaultOU                                = $ConfigSettings.DistributionGroupDefaultOU
            DistributionGroupNameBlockedWordsList                     = $ConfigSettings.DistributionGroupNameBlockedWordsList
            DistributionGroupNamingPolicy                             = $ConfigSettings.DistributionGroupNamingPolicy
            ElcProcessingDisabled                                     = $ConfigSettings.ElcProcessingDisabled
            EnableOutlookEvents                                       = $ConfigSettings.EnableOutlookEvents
            EndUserDLUpgradeFlowsDisabled                             = $ConfigSettings.EndUserDLUpgradeFlowsDisabled
            EwsAllowEntourage                                         = $ConfigSettings.EwsAllowEntourage
            EwsAllowList                                              = $ConfigSettings.EwsAllowList
            EwsAllowMacOutlook                                        = $ConfigSettings.EwsAllowMacOutlook
            EwsAllowOutlook                                           = $ConfigSettings.EwsAllowOutlook
            EwsApplicationAccessPolicy                                = $ConfigSettings.EwsApplicationAccessPolicy
            EwsBlockList                                              = $ConfigSettings.EwsBlockList
            EwsEnabled                                                = $ConfigSettings.EwsEnabled
            ExchangeNotificationEnabled                               = $ConfigSettings.ExchangeNotificationEnabled
            ExchangeNotificationRecipients                            = $ConfigSettings.ExchangeNotificationRecipients
            FindTimeAttendeeAuthenticationEnabled                     = $ConfigSettings.FindTimeAttendeeAuthenticationEnabled
            FindTimeAutoScheduleDisabled                              = $ConfigSettings.FindTimeAutoScheduleDisabled
            FindTimeLockPollForAttendeesEnabled                       = $ConfigSettings.FindTimeLockPollForAttendeesEnabled
            FindTimeOnlineMeetingOptionDisabled                       = $ConfigSettings.FindTimeOnlineMeetingOptionDisabled
            FocusedInboxOn                                            = $ConfigSettings.FocusedInboxOn
            HierarchicalAddressBookRoot                               = $ConfigSettings.HierarchicalAddressBookRoot
            IPListBlocked                                             = $ConfigSettings.IPListBlocked
            IsGroupFoldersAndRulesEnabled                             = $ConfigSettings.IsGroupFoldersAndRulesEnabled
            IsGroupMemberAllowedToEditContent                         = $ConfigSettings.IsGroupMemberAllowedToEditContent
            LeanPopoutEnabled                                         = $ConfigSettings.LeanPopoutEnabled
            LinkPreviewEnabled                                        = $ConfigSettings.LinkPreviewEnabled
            MailTipsAllTipsEnabled                                    = $ConfigSettings.MailTipsAllTipsEnabled
            MailTipsExternalRecipientsTipsEnabled                     = $ConfigSettings.MailTipsExternalRecipientsTipsEnabled
            MailTipsGroupMetricsEnabled                               = $ConfigSettings.MailTipsGroupMetricsEnabled
            MailTipsLargeAudienceThreshold                            = $ConfigSettings.MailTipsLargeAudienceThreshold
            MailTipsMailboxSourcedTipsEnabled                         = $ConfigSettings.MailTipsMailboxSourcedTipsEnabled
            MaskClientIpInReceivedHeadersEnabled                      = $ConfigSettings.MaskClientIpInReceivedHeadersEnabled
            MatchSenderOrganizerProperties                            = $ConfigSettings.MatchSenderOrganizerProperties
            MessageHighlightsEnabled                                  = $ConfigSettings.MessageHighlightsEnabled
            MessageRecallEnabled                                      = $ConfigSettings.MessageRecallEnabled
            MessageRemindersEnabled                                   = $ConfigSettings.MessageRemindersEnabled
            MobileAppEducationEnabled                                 = $ConfigSettings.MobileAppEducationEnabled
            OAuth2ClientProfileEnabled                                = $ConfigSettings.OAuth2ClientProfileEnabled
            OnlineMeetingsByDefaultEnabled                            = $ConfigSettings.OnlineMeetingsByDefaultEnabled
            OutlookMobileGCCRestrictionsEnabled                       = $ConfigSettings.OutlookMobileGCCRestrictionsEnabled
            OutlookGifPickerDisabled                                  = $ConfigSettings.OutlookGifPickerDisabled
            OutlookPayEnabled                                         = $ConfigSettings.OutlookPayEnabled
            OutlookTextPredictionDisabled                             = $ConfigSettings.OutlookTextPredictionDisabled
            PublicComputersDetectionEnabled                           = $ConfigSettings.PublicComputersDetectionEnabled
            PublicFoldersEnabled                                      = $ConfigSettings.PublicFoldersEnabled
            PublicFolderShowClientControl                             = $ConfigSettings.PublicFolderShowClientControl
            ReadTrackingEnabled                                       = $ConfigSettings.ReadTrackingEnabled
            RecallReadMessagesEnabled                                 = $ConfigSettings.RecallReadMessagesEnabled
            RemotePublicFolderMailboxes                               = $ConfigSettings.RemotePublicFolderMailboxes
            SendFromAliasEnabled                                      = $ConfigSettings.SendFromAliasEnabled
            SharedDomainEmailAddressFlowEnabled                       = $ConfigSettings.SharedDomainEmailAddressFlowEnabled
            ShortenEventScopeDefault                                  = $ConfigSettings.ShortenEventScopeDefault
            SiteMailboxCreationURL                                    = $ConfigSettings.SiteMailboxCreationURL
            SmtpActionableMessagesEnabled                             = $ConfigSettings.SmtpActionableMessagesEnabled
            VisibleMeetingUpdateProperties                            = $ConfigSettings.VisibleMeetingUpdateProperties
            WebPushNotificationsDisabled                              = $ConfigSettings.WebPushNotificationsDisabled
            WebSuggestedRepliesDisabled                               = $ConfigSettings.WebSuggestedRepliesDisabled
            WorkspaceTenantEnabled                                    = $ConfigSettings.WorkspaceTenantEnabled
            Credential                                                = $Credential
            ApplicationId                                             = $ApplicationId
            CertificateThumbprint                                     = $CertificateThumbprint
            CertificatePath                                           = $CertificatePath
            CertificatePassword                                       = $CertificatePassword
            Managedidentity                                           = $ManagedIdentity.IsPresent
            TenantId                                                  = $TenantId
            AccessTokens                                              = $AccessTokens
        }

        if ($null -eq $ConfigSettings.AutoExpandingArchiveEnabled)
        {
            $results.AutoExpandingArchive = $false
        }

        if ([System.String]::IsNullOrEmpty($results.EwsApplicationAccessPolicy))
        {
            $results.Remove('EwsApplicationAccessPolicy')
        }

        if ($null -eq $EwsAllowList)
        {
            $results.Remove('EwsAllowList')
        }

        if ($null -eq $EwsBlockList)
        {
            $results.Remove('EwsBlockList')
        }

        return $results
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
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $ActivityBasedAuthenticationTimeoutEnabled,

        [Parameter()]
        [System.String]
        [ValidatePattern('^(0[0-7]:[0-5][0-9]:[0-5][0-9]|08:00:00)$')]
        $ActivityBasedAuthenticationTimeoutInterval,

        [Parameter()]
        [System.Boolean]
        $ActivityBasedAuthenticationTimeoutWithSingleSignOnEnabled,

        [Parameter()]
        [System.Boolean]
        $AppsForOfficeEnabled,

        [Parameter()]
        [System.Boolean]
        $AsyncSendEnabled,

        [Parameter()]
        [System.Boolean]
        $AuditDisabled,

        [Parameter()]
        [System.Boolean]
        $AutodiscoverPartialDirSync,

        [Parameter()]
        [System.Boolean]
        $AutoExpandingArchive,

        [Parameter()]
        [System.Boolean]
        $BlockMoveMessagesForGroupFolders,

        [Parameter()]
        [System.Boolean]
        $BookingsAddressEntryRestricted,

        [Parameter()]
        [System.Boolean]
        $BookingsAuthEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsBlockedWordsEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsCreationOfCustomQuestionsRestricted,

        [Parameter()]
        [System.Boolean]
        $BookingsEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsExposureOfStaffDetailsRestricted,

        [Parameter()]
        [System.Boolean]
        $BookingsMembershipApprovalRequired,

        [Parameter()]
        [System.Boolean]
        $BookingsNamingPolicyEnabled,

        [Parameter()]
        [System.String]
        $BookingsNamingPolicyPrefix,

        [Parameter()]
        [System.Boolean]
        $BookingsNamingPolicyPrefixEnabled,

        [Parameter()]
        [System.String]
        $BookingsNamingPolicySuffix,

        [Parameter()]
        [System.Boolean]
        $BookingsNamingPolicySuffixEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsNotesEntryRestricted,

        [Parameter()]
        [System.Boolean]
        $BookingsPaymentsEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsPhoneNumberEntryRestricted,

        [Parameter()]
        [System.Boolean]
        $BookingsSearchEngineIndexDisabled,

        [Parameter()]
        [System.Boolean]
        $BookingsSmsMicrosoftEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsSocialSharingRestricted,

        [Parameter()]
        [System.UInt32]
        $ByteEncoderTypeFor7BitCharsets,

        [Parameter()]
        [System.Boolean]
        $ComplianceMLBgdCrawlEnabled,

        [Parameter()]
        [System.Boolean]
        $ConnectorsActionableMessagesEnabled,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabled,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabledForOutlook,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabledForSharepoint,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabledForTeams,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabledForYammer,

        [Parameter()]
        [System.Boolean]
        $CustomerLockboxEnabled,

        [Parameter()]
        [System.String]
        $DefaultAuthenticationPolicy,

        [Parameter()]
        [ValidateSet('Private', 'Public')]
        [System.String]
        $DefaultGroupAccessType,

        [Parameter()]
        [ValidateRange(0, 29)]
        [System.UInt32]
        $DefaultMinutesToReduceLongEventsBy,

        [Parameter()]
        [ValidateRange(0, 29)]
        [System.UInt32]
        $DefaultMinutesToReduceShortEventsBy,

        [Parameter()]
        [System.String]
        [ValidatePattern('^([0-9][0-9]|[0-9]).[0-9][0-9]:[0-9][0-9]:[0-9][0-9]$')]
        $DefaultPublicFolderAgeLimit,

        [Parameter()]
        [System.String]
        [ValidatePattern('^([0-9][0-9]|[0-9]).[0-9][0-9]:[0-9][0-9]:[0-9][0-9]$')]
        $DefaultPublicFolderDeletedItemRetention,

        [Parameter()]
        [System.String]
        $DefaultPublicFolderIssueWarningQuota,

        [Parameter()]
        [System.String]
        $DefaultPublicFolderMaxItemSize,

        [Parameter()]
        [System.String]
        [ValidatePattern('^([0-9][0-9]|[0-9]).[0-9][0-9]:[0-9][0-9]:[0-9][0-9]$')]
        $DefaultPublicFolderMovedItemRetention,

        [Parameter()]
        [System.String]
        $DefaultPublicFolderProhibitPostQuota,

        [Parameter()]
        [System.Boolean]
        $DirectReportsGroupAutoCreationEnabled,

        [Parameter()]
        [System.Boolean]
        $DisablePlusAddressInRecipients,

        [Parameter()]
        [System.String]
        $DistributionGroupDefaultOU,

        [Parameter()]
        [System.String[]]
        $DistributionGroupNameBlockedWordsList,

        [Parameter()]
        [System.String]
        $DistributionGroupNamingPolicy,

        [Parameter()]
        [System.Boolean]
        $ElcProcessingDisabled,

        [Parameter()]
        [System.Boolean]
        $EndUserDLUpgradeFlowsDisabled,

        [Parameter()]
        [System.Boolean]
        $EnableOutlookEvents,

        [Parameter()]
        [System.Boolean]
        $EwsAllowEntourage,

        [Parameter()]
        [System.String[]]
        $EwsAllowList,

        [Parameter()]
        [System.Boolean]
        $EwsAllowMacOutlook,

        [Parameter()]
        [System.Boolean]
        $EwsAllowOutlook,

        [Parameter()]
        [ValidateSet('EnforceAllowList', 'EnforceBlockList')]
        [System.String]
        $EwsApplicationAccessPolicy,

        [Parameter()]
        [System.String[]]
        $EwsBlockList,

        [Parameter()]
        [System.Boolean]
        $EwsEnabled,

        [Parameter()]
        [System.Boolean]
        $ExchangeNotificationEnabled,

        [Parameter()]
        [System.String[]]
        $ExchangeNotificationRecipients,

        [Parameter()]
        [System.Boolean]
        $FindTimeAttendeeAuthenticationEnabled,

        [Parameter()]
        [System.Boolean]
        $FindTimeAutoScheduleDisabled,

        [Parameter()]
        [System.Boolean]
        $FindTimeLockPollForAttendeesEnabled,

        [Parameter()]
        [System.Boolean]
        $FindTimeOnlineMeetingOptionDisabled,

        [Parameter()]
        [System.Boolean]
        $FocusedInboxOn,

        [Parameter()]
        [System.String]
        $HierarchicalAddressBookRoot,

        [Parameter()]
        [System.String[]]
        $IPListBlocked,

        [Parameter()]
        [System.Boolean]
        $IsGroupFoldersAndRulesEnabled,

        [Parameter()]
        [System.Boolean]
        $IsGroupMemberAllowedToEditContent,

        [Parameter()]
        [System.Boolean]
        $LeanPopoutEnabled,

        [Parameter()]
        [System.Boolean]
        $LinkPreviewEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsAllTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsExternalRecipientsTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsGroupMetricsEnabled,

        [Parameter()]
        [System.UInt32]
        $MailTipsLargeAudienceThreshold,

        [Parameter()]
        [System.Boolean]
        $MailTipsMailboxSourcedTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MaskClientIpInReceivedHeadersEnabled,

        [Parameter()]
        [System.Boolean]
        $MatchSenderOrganizerProperties,

        [Parameter()]
        [System.Boolean]
        $MessageHighlightsEnabled,

        [Parameter()]
        [System.Boolean]
        $MessageRecallEnabled,

        [Parameter()]
        [System.Boolean]
        $MessageRemindersEnabled,

        [Parameter()]
        [System.Boolean]
        $MobileAppEducationEnabled,

        [Parameter()]
        [System.Boolean]
        $OAuth2ClientProfileEnabled,

        [Parameter()]
        [System.Boolean]
        $OnlineMeetingsByDefaultEnabled,

        [Parameter()]
        [System.Boolean]
        $OutlookGifPickerDisabled,

        [Parameter()]
        [System.Boolean]
        $OutlookMobileGCCRestrictionsEnabled,

        [Parameter()]
        [System.Boolean]
        $OutlookPayEnabled,

        [Parameter()]
        [System.Boolean]
        $OutlookTextPredictionDisabled,

        [Parameter()]
        [System.Boolean]
        $PublicComputersDetectionEnabled,

        [Parameter()]
        [ValidateSet('None', 'Local', 'Remote')]
        [System.String]
        $PublicFoldersEnabled,

        [Parameter()]
        [System.Boolean]
        $PublicFolderShowClientControl,

        [Parameter()]
        [System.Boolean]
        $ReadTrackingEnabled,

        [Parameter()]
        [System.Boolean]
        $RecallReadMessagesEnabled,

        [Parameter()]
        [System.String[]]
        $RemotePublicFolderMailboxes,

        [Parameter()]
        [System.Boolean]
        $SendFromAliasEnabled,

        [Parameter()]
        [System.Boolean]
        $SharedDomainEmailAddressFlowEnabled,

        [Parameter()]
        [System.String]
        $ShortenEventScopeDefault,

        [Parameter()]
        [System.String]
        $SiteMailboxCreationURL,

        [Parameter()]
        [System.Boolean]
        $SmtpActionableMessagesEnabled,

        [Parameter()]
        [System.String]
        $VisibleMeetingUpdateProperties,

        [Parameter()]
        [System.Boolean]
        $WebPushNotificationsDisabled,

        [Parameter()]
        [System.Boolean]
        $WebSuggestedRepliesDisabled,

        [Parameter()]
        [System.Boolean]
        $WorkspaceTenantEnabled,

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

    if ($null -ne $EwsAllowList -and $null -ne $EwsBlockList)
    {
        throw "You can't specify both EWSAllowList and EWSBlockList properties."
    }

    Write-Verbose -Message 'Setting EXOOrganizationConfig'

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters


    Write-Verbose -Message "Setting EXOOrganizationConfig with values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"
    $SetValues = [System.Collections.Hashtable]($PSBoundParameters)
    $SetValues.Remove('IsSingleInstance') | Out-Null
    $SetValues.Remove('Credential') | Out-Null
    $SetValues.Remove('ApplicationId') | Out-Null
    $SetValues.Remove('TenantId') | Out-Null
    $SetValues.Remove('CertificateThumbprint') | Out-Null
    $SetValues.Remove('CertificatePath') | Out-Null
    $SetValues.Remove('CertificatePassword') | Out-Null
    $SetValues.Remove('ManagedIdentity') | Out-Null
    $SetValues.Remove('AccessTokens') | Out-Null

    $isAutoExpandingArchiveEnabled = Get-OrganizationConfig | Select-Object -Property AutoExpandingArchiveEnabled

    if ($isAutoExpandingArchiveEnabled.AutoExpandingArchiveEnabled -eq $True)
    {
        $SetValues.Remove('AutoExpandingArchive') | Out-Null
    }

    Set-OrganizationConfig @SetValues
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $ActivityBasedAuthenticationTimeoutEnabled,

        [Parameter()]
        [System.String]
        [ValidatePattern('^(0[0-7]:[0-5][0-9]:[0-5][0-9]|08:00:00)$')]
        $ActivityBasedAuthenticationTimeoutInterval,

        [Parameter()]
        [System.Boolean]
        $ActivityBasedAuthenticationTimeoutWithSingleSignOnEnabled,

        [Parameter()]
        [System.Boolean]
        $AppsForOfficeEnabled,

        [Parameter()]
        [System.Boolean]
        $AsyncSendEnabled,

        [Parameter()]
        [System.Boolean]
        $AuditDisabled,

        [Parameter()]
        [System.Boolean]
        $AutodiscoverPartialDirSync,

        [Parameter()]
        [System.Boolean]
        $AutoExpandingArchive,

        [Parameter()]
        [System.Boolean]
        $BlockMoveMessagesForGroupFolders,

        [Parameter()]
        [System.Boolean]
        $BookingsAddressEntryRestricted,

        [Parameter()]
        [System.Boolean]
        $BookingsAuthEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsBlockedWordsEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsCreationOfCustomQuestionsRestricted,

        [Parameter()]
        [System.Boolean]
        $BookingsEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsExposureOfStaffDetailsRestricted,

        [Parameter()]
        [System.Boolean]
        $BookingsMembershipApprovalRequired,

        [Parameter()]
        [System.Boolean]
        $BookingsNamingPolicyEnabled,

        [Parameter()]
        [System.String]
        $BookingsNamingPolicyPrefix,

        [Parameter()]
        [System.Boolean]
        $BookingsNamingPolicyPrefixEnabled,

        [Parameter()]
        [System.String]
        $BookingsNamingPolicySuffix,

        [Parameter()]
        [System.Boolean]
        $BookingsNamingPolicySuffixEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsNotesEntryRestricted,

        [Parameter()]
        [System.Boolean]
        $BookingsPaymentsEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsPhoneNumberEntryRestricted,

        [Parameter()]
        [System.Boolean]
        $BookingsSearchEngineIndexDisabled,

        [Parameter()]
        [System.Boolean]
        $BookingsSmsMicrosoftEnabled,

        [Parameter()]
        [System.Boolean]
        $BookingsSocialSharingRestricted,

        [Parameter()]
        [System.UInt32]
        $ByteEncoderTypeFor7BitCharsets,

        [Parameter()]
        [System.Boolean]
        $ComplianceMLBgdCrawlEnabled,

        [Parameter()]
        [System.Boolean]
        $ConnectorsActionableMessagesEnabled,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabled,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabledForOutlook,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabledForSharepoint,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabledForTeams,

        [Parameter()]
        [System.Boolean]
        $ConnectorsEnabledForYammer,

        [Parameter()]
        [System.Boolean]
        $CustomerLockboxEnabled,

        [Parameter()]
        [System.String]
        $DefaultAuthenticationPolicy,

        [Parameter()]
        [ValidateSet('Private', 'Public')]
        [System.String]
        $DefaultGroupAccessType,

        [Parameter()]
        [ValidateRange(0, 29)]
        [System.UInt32]
        $DefaultMinutesToReduceLongEventsBy,

        [Parameter()]
        [ValidateRange(0, 29)]
        [System.UInt32]
        $DefaultMinutesToReduceShortEventsBy,

        [Parameter()]
        [System.String]
        [ValidatePattern('^([0-9][0-9]|[0-9]).[0-9][0-9]:[0-9][0-9]:[0-9][0-9]$')]
        $DefaultPublicFolderAgeLimit,

        [Parameter()]
        [System.String]
        [ValidatePattern('^([0-9][0-9]|[0-9]).[0-9][0-9]:[0-9][0-9]:[0-9][0-9]$')]
        $DefaultPublicFolderDeletedItemRetention,

        [Parameter()]
        [System.String]
        $DefaultPublicFolderIssueWarningQuota,

        [Parameter()]
        [System.String]
        $DefaultPublicFolderMaxItemSize,

        [Parameter()]
        [System.String]
        [ValidatePattern('^([0-9][0-9]|[0-9]).[0-9][0-9]:[0-9][0-9]:[0-9][0-9]$')]
        $DefaultPublicFolderMovedItemRetention,

        [Parameter()]
        [System.String]
        $DefaultPublicFolderProhibitPostQuota,

        [Parameter()]
        [System.Boolean]
        $DirectReportsGroupAutoCreationEnabled,

        [Parameter()]
        [System.Boolean]
        $DisablePlusAddressInRecipients,

        [Parameter()]
        [System.String]
        $DistributionGroupDefaultOU,

        [Parameter()]
        [System.String[]]
        $DistributionGroupNameBlockedWordsList,

        [Parameter()]
        [System.String]
        $DistributionGroupNamingPolicy,

        [Parameter()]
        [System.Boolean]
        $ElcProcessingDisabled,

        [Parameter()]
        [System.Boolean]
        $EndUserDLUpgradeFlowsDisabled,

        [Parameter()]
        [System.Boolean]
        $EnableOutlookEvents,

        [Parameter()]
        [System.Boolean]
        $EwsAllowEntourage,

        [Parameter()]
        [System.String[]]
        $EwsAllowList,

        [Parameter()]
        [System.Boolean]
        $EwsAllowMacOutlook,

        [Parameter()]
        [System.Boolean]
        $EwsAllowOutlook,

        [Parameter()]
        [ValidateSet('EnforceAllowList', 'EnforceBlockList')]
        [System.String]
        $EwsApplicationAccessPolicy,

        [Parameter()]
        [System.String[]]
        $EwsBlockList,

        [Parameter()]
        [System.Boolean]
        $EwsEnabled,

        [Parameter()]
        [System.Boolean]
        $ExchangeNotificationEnabled,

        [Parameter()]
        [System.String[]]
        $ExchangeNotificationRecipients,

        [Parameter()]
        [System.Boolean]
        $FindTimeAttendeeAuthenticationEnabled,

        [Parameter()]
        [System.Boolean]
        $FindTimeAutoScheduleDisabled,

        [Parameter()]
        [System.Boolean]
        $FindTimeLockPollForAttendeesEnabled,

        [Parameter()]
        [System.Boolean]
        $FindTimeOnlineMeetingOptionDisabled,

        [Parameter()]
        [System.Boolean]
        $FocusedInboxOn,

        [Parameter()]
        [System.String]
        $HierarchicalAddressBookRoot,

        [Parameter()]
        [System.String[]]
        $IPListBlocked,

        [Parameter()]
        [System.Boolean]
        $IsGroupFoldersAndRulesEnabled,

        [Parameter()]
        [System.Boolean]
        $IsGroupMemberAllowedToEditContent,

        [Parameter()]
        [System.Boolean]
        $LeanPopoutEnabled,

        [Parameter()]
        [System.Boolean]
        $LinkPreviewEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsAllTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsExternalRecipientsTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsGroupMetricsEnabled,

        [Parameter()]
        [System.UInt32]
        $MailTipsLargeAudienceThreshold,

        [Parameter()]
        [System.Boolean]
        $MailTipsMailboxSourcedTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MaskClientIpInReceivedHeadersEnabled,

        [Parameter()]
        [System.Boolean]
        $MatchSenderOrganizerProperties,

        [Parameter()]
        [System.Boolean]
        $MessageHighlightsEnabled,

        [Parameter()]
        [System.Boolean]
        $MessageRecallEnabled,

        [Parameter()]
        [System.Boolean]
        $MessageRemindersEnabled,

        [Parameter()]
        [System.Boolean]
        $MobileAppEducationEnabled,

        [Parameter()]
        [System.Boolean]
        $OAuth2ClientProfileEnabled,

        [Parameter()]
        [System.Boolean]
        $OnlineMeetingsByDefaultEnabled,

        [Parameter()]
        [System.Boolean]
        $OutlookGifPickerDisabled,

        [Parameter()]
        [System.Boolean]
        $OutlookMobileGCCRestrictionsEnabled,

        [Parameter()]
        [System.Boolean]
        $OutlookPayEnabled,

        [Parameter()]
        [System.Boolean]
        $OutlookTextPredictionDisabled,

        [Parameter()]
        [System.Boolean]
        $PublicComputersDetectionEnabled,

        [Parameter()]
        [ValidateSet('None', 'Local', 'Remote')]
        [System.String]
        $PublicFoldersEnabled,

        [Parameter()]
        [System.Boolean]
        $PublicFolderShowClientControl,

        [Parameter()]
        [System.Boolean]
        $ReadTrackingEnabled,

        [Parameter()]
        [System.Boolean]
        $RecallReadMessagesEnabled,

        [Parameter()]
        [System.String[]]
        $RemotePublicFolderMailboxes,

        [Parameter()]
        [System.Boolean]
        $SendFromAliasEnabled,

        [Parameter()]
        [System.Boolean]
        $SharedDomainEmailAddressFlowEnabled,

        [Parameter()]
        [System.String]
        $ShortenEventScopeDefault,

        [Parameter()]
        [System.String]
        $SiteMailboxCreationURL,

        [Parameter()]
        [System.Boolean]
        $SmtpActionableMessagesEnabled,

        [Parameter()]
        [System.String]
        $VisibleMeetingUpdateProperties,

        [Parameter()]
        [System.Boolean]
        $WebPushNotificationsDisabled,

        [Parameter()]
        [System.Boolean]
        $WebSuggestedRepliesDisabled,

        [Parameter()]
        [System.Boolean]
        $WorkspaceTenantEnabled,

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

    Write-Verbose -Message 'Testing configuration of EXOOrganizationConfig'

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
        if ($null -ne $Global:M365DSCExportResourceInstancesCount)
        {
            $Global:M365DSCExportResourceInstancesCount++
        }

        $Params = @{
            IsSingleInstance      = 'Yes'
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
