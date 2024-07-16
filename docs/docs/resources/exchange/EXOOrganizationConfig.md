# EXOOrganizationConfig

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Only valid value is 'Yes'. | `Yes` |
| **ActivityBasedAuthenticationTimeoutEnabled** | Write | Boolean | The ActivityBasedAuthenticationTimeoutEnabled parameter specifies whether the timed logoff feature is enabled. The default value is $true | |
| **ActivityBasedAuthenticationTimeoutInterval** | Write | String | The ActivityBasedAuthenticationTimeoutInterval parameter specifies the time span for logoff. You enter this value as a time span: hh:mm:ss where hh = hours, mm = minutes and ss = seconds. Valid values for this parameter are from 00:05:00 to 08:00:00 (5 minutes to 8 hours). The default value is 06:00:00 (6 hours). | |
| **ActivityBasedAuthenticationTimeoutWithSingleSignOnEnabled** | Write | Boolean | The ActivityBasedAuthenticationTimeoutWithSingleSignOnEnabled parameter specifies whether to keep single sign-on enabled. The default value is $true. | |
| **AppsForOfficeEnabled** | Write | Boolean | The AppsForOfficeEnabled parameter specifies whether to enable apps for Outlook features. By default, the parameter is set to $true. If the flag is set to $false, no new apps can be activated for any user in the organization. | |
| **AsyncSendEnabled** | Write | Boolean | The AsyncSendEnabled parameter specifies whether to enable or disable async send in Outlook on the web. | |
| **AuditDisabled** | Write | Boolean | The AuditDisabled parameter specifies whether to disable or enable mailbox auditing for the organization. | |
| **AutodiscoverPartialDirSync** | Write | Boolean | Setting this parameter to $true will cause unknown users to be redirected to the on-premises endpoint and will allow on-premises users to discover their mailbox automatically. | |
| **AutoExpandingArchive** | Write | Boolean | The AutoExpandingArchive switch enables the unlimited archiving feature (called auto-expanding archiving) in an Exchange Online organization. You don't need to specify a value with this switch. | |
| **BlockMoveMessagesForGroupFolders** | Write | Boolean | No description available for BlockMoveMessagesForGroupFolders | |
| **BookingsAddressEntryRestricted** | Write | Boolean | The BookingsAddressEntryRestricted parameter specifies whether addresses can be collected from Bookings customers. | |
| **BookingsAuthEnabled** | Write | Boolean | The BookingsAuthEnabled parameter specifies whether to enforce authentication to access all published Bookings pages. | |
| **BookingsBlockedWordsEnabled** | Write | Boolean | No description available for BookingsBlockedWordsEnabled | |
| **BookingsCreationOfCustomQuestionsRestricted** | Write | Boolean | The BookingsCreationOfCustomQuestionsRestricted parameter specifies whether Bookings admins can add custom questions. | |
| **BookingsEnabled** | Write | Boolean | The BookingsEnabled parameter specifies whether to enable Microsoft Bookings in an organization. | |
| **BookingsExposureOfStaffDetailsRestricted** | Write | Boolean | The BookingsExposureOfStaffDetailsRestricted parameter specifies whether the attributes of internal Bookings staff members are visible to external Bookings customers. | |
| **BookingsMembershipApprovalRequired** | Write | Boolean | The BookingsMembershipApprovalRequired parameter enables a membership approval requirement when new staff members are added to Bookings calendars. | |
| **BookingsNamingPolicyEnabled** | Write | Boolean | No description available for BookingsNamingPolicyEnabled | |
| **BookingsNamingPolicyPrefix** | Write | String | No description available for BookingsNamingPolicyPrefix | |
| **BookingsNamingPolicyPrefixEnabled** | Write | Boolean | No description available for BookingsNamingPolicyPrefixEnabled | |
| **BookingsNamingPolicySuffix** | Write | String | No description available for BookingsNamingPolicySuffix | |
| **BookingsNamingPolicySuffixEnabled** | Write | Boolean | No description available for BookingsNamingPolicySuffixEnabled | |
| **BookingsNotesEntryRestricted** | Write | Boolean | The BookingsNotesEntryRestricted parameter specifies whether appointment notes can be collected from Bookings customers. | |
| **BookingsPaymentsEnabled** | Write | Boolean | The BookingsPaymentsEnabled parameter specifies whether to enable online payment node inside Bookings. | |
| **BookingsPhoneNumberEntryRestricted** | Write | Boolean | The BookingsPhoneNumberEntryRestricted parameter specifies whether phone numbers can be collected from Bookings customers. | |
| **BookingsSearchEngineIndexDisabled** | Write | Boolean | No description available for BookingsSearchEngineIndexDisabled | |
| **BookingsSmsMicrosoftEnabled** | Write | Boolean | No description available for BookingsSmsMicrosoftEnabled | |
| **BookingsSocialSharingRestricted** | Write | Boolean | The BookingsSocialSharingRestricted parameter allows you to control whether, or not, your users can see social sharing options inside Bookings. | |
| **ByteEncoderTypeFor7BitCharsets** | Write | UInt32 | The ByteEncoderTypeFor7BitCharsets parameter specifies the 7-bit transfer encoding method for MIME format for messages sent to this remote domain. | |
| **ComplianceMLBgdCrawlEnabled** | Write | Boolean | No description available for ComplianceMLBgdCrawlEnabled | |
| **ConnectorsActionableMessagesEnabled** | Write | Boolean | The ConnectorsActionableMessagesEnabled parameter specifies whether to enable or disable actionable buttons in messages (connector cards) from connected apps on Outlook on the web. | |
| **ConnectorsEnabled** | Write | Boolean | The ConnectorsEnabled parameter specifies whether to enable or disable all connected apps in organization. | |
| **ConnectorsEnabledForOutlook** | Write | Boolean | The ConnectorsEnabledForOutlook parameter specifies whether to enable or disable connected apps in Outlook on the web.  | |
| **ConnectorsEnabledForSharepoint** | Write | Boolean | The ConnectorsEnabledForSharepoint parameter specifies whether to enable or disable connected apps on Sharepoint. | |
| **ConnectorsEnabledForTeams** | Write | Boolean | The ConnectorsEnabledForTeams parameter specifies whether to enable or disable connected apps on Teams. | |
| **ConnectorsEnabledForYammer** | Write | Boolean | The ConnectorsEnabledForYammer parameter specifies whether to enable or disable connected apps on Yammer. | |
| **CustomerLockboxEnabled** | Write | Boolean | Enable Customer Lockbox. | |
| **DefaultAuthenticationPolicy** | Write | String | The DefaultAuthenticationPolicy parameter specifies the authentication policy that's used for the whole organization. You can use any value that uniquely identifies the policy. | |
| **DefaultGroupAccessType** | Write | String | The DefaultGroupAccessType parameter specifies the default access type for Office 365 groups. | `Private`, `Public` |
| **DefaultMinutesToReduceLongEventsBy** | Write | UInt32 | The DefaultMinutesToReduceLongEventsBy parameter specifies the number of minutes to reduce calendar events by if the events are 60 minutes or longer. | |
| **DefaultMinutesToReduceShortEventsBy** | Write | UInt32 | The DefaultMinutesToReduceShortEventsBy parameter specifies the number of minutes to reduce calendar events by if the events are less than 60 minutes long. | |
| **DefaultPublicFolderAgeLimit** | Write | String | The DefaultPublicFolderAgeLimit parameter specifies the default age limit for the contents of public folders across the entire organization. Content in a public folder is automatically deleted when this age limit is exceeded. This attribute applies to all public folders in the organization that don't have their own AgeLimit setting. To specify a value, enter it as a time span: dd.hh:mm:ss where d = days, h = hours, m = minutes, and s = seconds. Or, enter the value $null. The default value is blank ($null). | |
| **DefaultPublicFolderDeletedItemRetention** | Write | String | The DefaultPublicFolderDeletedItemRetention parameter specifies the default value of the length of time to retain deleted items for public folders across the entire organization. This attribute applies to all public folders in the organization that don't have their own RetainDeletedItemsFor attribute set. | |
| **DefaultPublicFolderIssueWarningQuota** | Write | String | The DefaultPublicFolderIssueWarningQuota parameter specifies the default value across the entire organization for the public folder size at which a warning message is sent to this folder's owners, warning that the public folder is almost full. This attribute applies to all public folders within the organization that don't have their own warning quota attribute set. The default value of this attribute is unlimited. The valid input range for this parameter is from 0 through 2199023254529 bytes(2 TB). If you enter a value of unlimited, no size limit is imposed on the public folder. | |
| **DefaultPublicFolderMaxItemSize** | Write | String | The DefaultPublicFolderMaxItemSize parameter specifies the default maximum size for posted items within public folders across the entire organization. Items larger than the value of the DefaultPublicFolderMaxItemSize parameter are rejected. This attribute applies to all public folders within the organization that don't have their own MaxItemSize attribute set. The default value of this attribute is unlimited. | |
| **DefaultPublicFolderMovedItemRetention** | Write | String | The DefaultPublicFolderMovedItemRetention parameter specifies how long items that have been moved between mailboxes are kept in the source mailbox for recovery purposes before being removed by the Public Folder Assistant. | |
| **DefaultPublicFolderProhibitPostQuota** | Write | String | The DefaultPublicFolderProhibitPostQuota parameter specifies the size of a public folder at which users are notified that the public folder is full. Users can't post to a folder whose size is larger than the DefaultPublicFolderProhibitPostQuota parameter value. The default value of this attribute is unlimited. | |
| **DirectReportsGroupAutoCreationEnabled** | Write | Boolean | The DirectReportsGroupAutoCreationEnabled parameter specifies whether to enable or disable the automatic creation of direct report Office 365 groups. | |
| **DisablePlusAddressInRecipients** | Write | Boolean | The DisablePlusAddressInRecipients parameter specifies whether to enable or disable plus addressing (also known as subaddressing) for Exchange Online mailboxes. | |
| **DistributionGroupDefaultOU** | Write | String | The DistributionGroupDefaultOU parameter specifies the container where distribution groups are created by default. | |
| **DistributionGroupNameBlockedWordsList** | Write | StringArray[] | The DistributionGroupNameBlockedWordsList parameter specifies words that can't be included in the names of distribution groups. Separate multiple values with commas. | |
| **DistributionGroupNamingPolicy** | Write | String | The DistributionGroupNamingPolicy parameter specifies the template applied to the name of distribution groups that are created in the organization. You can enforce that a prefix or suffix be applied to all distribution groups. Prefixes and suffixes can be either a string or an attribute, and you can combine strings and attributes. | |
| **ElcProcessingDisabled** | Write | Boolean | The ElcProcessingDisabled parameter specifies whether to enable or disable the processing of mailboxes by the Managed Folder Assistant. | |
| **EnableOutlookEvents** | Write | Boolean | The EnableOutlookEvents parameter specifies whether Outlook or Outlook on the web automatically discovers events from email messages and adds them to user calendars. | |
| **EndUserDLUpgradeFlowsDisabled** | Write | Boolean | The EndUserDLUpgradeFlowsDisabled parameter specifies whether to prevent users from upgrading their own distribution groups to Office 365 groups in an Exchange Online organization. | |
| **EwsAllowEntourage** | Write | Boolean | The EwsAllowEntourage parameter specifies whether to enable or disable Entourage 2008 to access Exchange Web Services (EWS) for the entire organization. | |
| **EwsAllowList** | Write | StringArray[] | The EwsAllowList parameter specifies the applications that are allowed to access EWS or REST when the EwsApplicationAccessPolicy parameter is set to EwsAllowList. Other applications that aren't specified by this parameter aren't allowed to access EWS or REST. You identify the application by its user agent string value. Wildcard characters (*) are supported. | |
| **EwsAllowMacOutlook** | Write | Boolean | The EwsAllowMacOutlook parameter enables or disables access to mailboxes by Outlook for Mac clients that use Exchange Web Services (for example, Outlook for Mac 2011 or later). | |
| **EwsAllowOutlook** | Write | Boolean | The EwsAllowOutlook parameter enables or disables access to mailboxes by Outlook clients that use Exchange Web Services. Outlook uses Exchange Web Services for free/busy, out-of-office settings, and calendar sharing. | |
| **EwsApplicationAccessPolicy** | Write | String | The EwsApplicationAccessPolicy parameter specifies the client applications that have access to EWS and REST. | `EnforceAllowList`, `EnforceBlockList` |
| **EwsBlockList** | Write | StringArray[] | The EwsBlockList parameter specifies the applications that aren't allowed to access EWS or REST when the EwsApplicationAccessPolicy parameter is set to EnforceBlockList. All other applications that aren't specified by this parameter are allowed to access EWS or REST. You identify the application by its user agent string value. Wildcard characters (*) are supported. | |
| **EwsEnabled** | Write | Boolean | The EwsEnabled parameter specifies whether to globally enable or disable EWS access for the entire organization, regardless of what application is making the request. | |
| **ExchangeNotificationEnabled** | Write | Boolean | The ExchangeNotificationEnabled parameter enables or disables Exchange notifications sent to administrators regarding their organizations. Valid input for this parameter is $true or $false. | |
| **ExchangeNotificationRecipients** | Write | StringArray[] | The ExchangeNotificationRecipients parameter specifies the recipients for Exchange notifications sent to administrators regarding their organizations. If the ExchangeNotificationEnabled parameter is set to $false, no notification messages are sent. Be sure to enclose values that contain spaces in quotation marks and separate multiple values with commas. If this parameter isn't set, Exchange notifications are sent to all administrators. | |
| **FindTimeAttendeeAuthenticationEnabled** | Write | Boolean | The FindTimeAttendeeAuthenticationEnabled parameter controls whether attendees are required to verify their identity in meeting polls using the FindTime Outlook add-in. | |
| **FindTimeAutoScheduleDisabled** | Write | Boolean | The FindTimeAutoScheduleDisabled parameter controls automatically scheduling the meeting once a consensus is reached in meeting polls using the FindTime Outlook add-in. | |
| **FindTimeLockPollForAttendeesEnabled** | Write | Boolean | The FindTimeLockPollForAttendeesEnabled controls whether the Lock poll for attendees setting is managed by the organization. | |
| **FindTimeOnlineMeetingOptionDisabled** | Write | Boolean | The FindTimeOnlineMeetingOptionDisabled parameter controls the availability of the Online meeting checkbox for Teams in meeting polls using the FindTime Outlook add-in. | |
| **FocusedInboxOn** | Write | Boolean | The FocusedInboxOn parameter enables or disables Focused Inbox for the organization. | |
| **HierarchicalAddressBookRoot** | Write | String | The HierarchicalAddressBookRoot parameter specifies the user, contact, or group to be used as the root organization for a hierarchical address book in the Exchange organization. You can use any value that uniquely identifies the recipient. | |
| **IPListBlocked** | Write | StringArray[] | The IPListBlocked parameter specifies the blocked IP addresses that aren't allowed to connect to Exchange Online organization. These settings affect client connections that use Basic authentication where on-premises Active Directory Federation Services (ADFS) servers federate authentication with Azure Active Directory. Note that the new settings might take up to 4 hours to fully propagate across the service. | |
| **IsGroupFoldersAndRulesEnabled** | Write | Boolean | No description available for IsGroupFoldersAndRulesEnabled | |
| **IsGroupMemberAllowedToEditContent** | Write | Boolean | No description available for IsGroupMemberAllowedToEditContent | |
| **LeanPopoutEnabled** | Write | Boolean | The LeanPopoutEnabled parameter specifies whether to enable faster loading of pop-out messages in Outlook on the web for Internet Explorer and Microsoft Edge. | |
| **LinkPreviewEnabled** | Write | Boolean | The LinkPreviewEnabled parameter specifies whether link preview of URLs in email messages is allowed for the organization. | |
| **MailTipsAllTipsEnabled** | Write | Boolean | The MailTipsAllTipsEnabled parameter specifies whether MailTips are enabled. The default value is $true. | |
| **MailTipsExternalRecipientsTipsEnabled** | Write | Boolean | The MailTipsExternalRecipientsTipsEnabled parameter specifies whether MailTips for external recipients are enabled. The default value is $false. | |
| **MailTipsGroupMetricsEnabled** | Write | Boolean | The MailTipsGroupMetricsEnabled parameter specifies whether MailTips that rely on group metrics data are enabled. The default value is $true. | |
| **MailTipsLargeAudienceThreshold** | Write | UInt32 | The MailTipsLargeAudienceThreshold parameter specifies what a large audience is. The default value is 25. | |
| **MailTipsMailboxSourcedTipsEnabled** | Write | Boolean | The MailTipsMailboxSourcedTipsEnabled parameter specifies whether MailTips that rely on mailbox data (out-of-office or full mailbox) are enabled. | |
| **MaskClientIpInReceivedHeadersEnabled** | Write | Boolean | No description available for MaskClientIpInReceivedHeadersEnabled. | |
| **MatchSenderOrganizerProperties** | Write | Boolean | No description available for MatchSenderOrganizerProperties. | |
| **MessageHighlightsEnabled** | Write | Boolean | No description available for MessageHighlightsEnabled. | |
| **MessageRecallEnabled** | Write | Boolean | The MessageRecallEnabled parameter enables or disables the message recall feature in the organization. | |
| **MessageRemindersEnabled** | Write | Boolean | The MessageRemindersEnabled parameter enables or disables the message reminders feature in the organization. | |
| **MobileAppEducationEnabled** | Write | Boolean | The MobileAppEducationEnabled specifies whether to show or hide the Outlook for iOS and Android education reminder in Outlook on the web. | |
| **OAuth2ClientProfileEnabled** | Write | Boolean | The OAuth2ClientProfileEnabled parameter enables or disables modern authentication in the Exchange organization. | |
| **OnlineMeetingsByDefaultEnabled** | Write | Boolean | The OnlineMeetingsByDefaultEnabled parameter specifies whether to set all meetings as Teams by default during meeting creation. | |
| **OutlookGifPickerDisabled** | Write | Boolean | The OutlookGifPickerDisabled parameter disables the GIF Search (powered by Bing) feature that's built into the Compose page in Outlook on the web. | |
| **OutlookMobileGCCRestrictionsEnabled** | Write | Boolean | The OutlookMobileGCCRestrictionsEnabled parameter specifies whether to enable or disable features within Outlook for iOS and Android that are not FedRAMP compliant for Office 365 US Government Community Cloud (GCC) customers. | |
| **OutlookPayEnabled** | Write | Boolean | The OutlookPayEnabled parameter enables or disables Payments in Outlook in the Office 365 organization. | |
| **OutlookTextPredictionDisabled** | Write | Boolean | No description available for OutlookTextPredictionDisabled. | |
| **PublicComputersDetectionEnabled** | Write | Boolean | The PublicComputersDetectionEnabled parameter specifies whether Outlook on the web will detect when a user signs from a public or private computer or network, and then enforces the attachment handling settings from public networks. The default is $false. However, if you set this parameter to $true, Outlook on the web will determine if the user is signing in from a public computer, and all public attachment handling rules will be applied and enforced. | |
| **PublicFoldersEnabled** | Write | String | The PublicFoldersEnabled parameter specifies how public folders are deployed in your organization. | `None`, `Local`, `Remote` |
| **PublicFolderShowClientControl** | Write | Boolean | The PublicFolderShowClientControl parameter enables or disables access to public folders in Microsoft Outlook. | |
| **ReadTrackingEnabled** | Write | Boolean | The ReadTrackingEnabled parameter specifies whether the tracking for read status for messages in an organization is enabled. The default value is $false. | |
| **RecallReadMessagesEnabled** | Write | Boolean | No description available for RecallReadMessagesEnabled. | |
| **RemotePublicFolderMailboxes** | Write | StringArray[] | The RemotePublicFolderMailboxes parameter specifies the identities of the public folder objects (represented as mail user objects locally) corresponding to the public folder mailboxes created in the remote forest. The public folder values set here are used only if the public folder deployment is a remote deployment. | |
| **SendFromAliasEnabled** | Write | Boolean | The SendFromAliasEnabled parameter allows mailbox users to send messages using aliases (proxy addresses). It does this by disabling the rewriting of aliases to their primary SMTP address. This change is implemented in the Exchange Online service | |
| **SharedDomainEmailAddressFlowEnabled** | Write | Boolean | No description available for SharedDomainEmailAddressFlowEnabled. | |
| **ShortenEventScopeDefault** | Write | String | The ShortenEventScopeDefault parameter specifies whether calendar events start late or end early in the organization. | |
| **SiteMailboxCreationURL** | Write | String | The SiteMailboxCreationURL parameter specifies the URL that's used to create site mailboxes. Site mailboxes improve collaboration and user productivity by allowing access to both SharePoint documents and Exchange email in Outlook 2013 or later. | |
| **SmtpActionableMessagesEnabled** | Write | Boolean | The SmtpActionableMessagesEnabled parameter specifies whether to enable or disable action buttons in email messages in Outlook on the web. | |
| **VisibleMeetingUpdateProperties** | Write | String | The VisibleMeetingUpdateProperties parameter specifies whether meeting message updates will be auto-processed on behalf of attendees. Auto-processed updates are applied to the attendee's calendar item, and then the meeting message is moved to the deleted items. The attendee never sees the update in their inbox, but their calendar is updated. | |
| **WebPushNotificationsDisabled** | Write | Boolean | The WebPushNotificationsDisabled parameter specifies whether to enable or disable Web Push Notifications in Outlook on the Web. This feature provides web push notifications which appear on a user's desktop while the user is not using Outlook on the Web. This brings awareness of incoming messages while they are working elsewhere on their computer. | |
| **WebSuggestedRepliesDisabled** | Write | Boolean | The WebSuggestedRepliesDisabled parameter specifies whether to enable or disable Suggested Replies in Outlook on the web. This feature provides suggested replies to emails so users can easily and quickly respond to messages. | |
| **WorkspaceTenantEnabled** | Write | Boolean | The WorkspaceTenantEnabled parameter enables or disables workspace booking in the organization. | |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

This resource configures the Exchange Online organization-wide
settings.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Mail Tips, View-Only Configuration, Organization Configuration, Federated Sharing, Public Folders, Team Mailboxes, Compliance Admin, Recipient Policies, Remote and Accepted Domains, Distribution Groups, Mail Recipients

#### Role Groups

- Organization Management

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOOrganizationConfig 'EXOOrganizationConfig'
        {
            IsSingleInstance                                          = "Yes"
            ElcProcessingDisabled                                     = $False
            DefaultPublicFolderProhibitPostQuota                      = "13 KB (13,312 bytes)"
            VisibleMeetingUpdateProperties                            = "Location,AllProperties:15"
            BookingsEnabled                                           = $True
            ExchangeNotificationRecipients                            = @()
            EwsEnabled                                                = $null
            LinkPreviewEnabled                                        = $True
            FocusedInboxOn                                            = $null
            AsyncSendEnabled                                          = $True
            EwsAllowEntourage                                         = $null
            RemotePublicFolderMailboxes                               = @()
            AuditDisabled                                             = $False
            EwsAllowMacOutlook                                        = $null
            ConnectorsEnabledForTeams                                 = $True
            DefaultPublicFolderIssueWarningQuota                      = "13 KB (13,312 bytes)"
            MailTipsMailboxSourcedTipsEnabled                         = $True
            EndUserDLUpgradeFlowsDisabled                             = $False
            DistributionGroupDefaultOU                                = $null
            OutlookPayEnabled                                         = $True
            EwsAllowOutlook                                           = $null
            DefaultAuthenticationPolicy                               = $null
            DistributionGroupNameBlockedWordsList                     = @()
            ConnectorsEnabled                                         = $True
            DefaultPublicFolderAgeLimit                               = $null
            OutlookMobileGCCRestrictionsEnabled                       = $False
            ActivityBasedAuthenticationTimeoutEnabled                 = $True
            ConnectorsEnabledForYammer                                = $True
            HierarchicalAddressBookRoot                               = $null
            DefaultPublicFolderMaxItemSize                            = "13 KB (13,312 bytes)"
            MailTipsLargeAudienceThreshold                            = 25
            ConnectorsActionableMessagesEnabled                       = $True
            ExchangeNotificationEnabled                               = $True
            ActivityBasedAuthenticationTimeoutWithSingleSignOnEnabled = $True
            DirectReportsGroupAutoCreationEnabled                     = $False
            OAuth2ClientProfileEnabled                                = $True
            AppsForOfficeEnabled                                      = $True
            PublicFoldersEnabled                                      = "Local"
            WebPushNotificationsDisabled                              = $False
            MailTipsGroupMetricsEnabled                               = $True
            DefaultPublicFolderMovedItemRetention                     = "07.00:00:00"
            DistributionGroupNamingPolicy                             = ""
            DefaultPublicFolderDeletedItemRetention                   = "30.00:00:00"
            MailTipsAllTipsEnabled                                    = $True
            LeanPopoutEnabled                                         = $False
            PublicComputersDetectionEnabled                           = $False
            ByteEncoderTypeFor7BitCharsets                            = 0
            ConnectorsEnabledForOutlook                               = $True
            WebSuggestedRepliesDisabled                               = $False
            PublicFolderShowClientControl                             = $False
            ActivityBasedAuthenticationTimeoutInterval                = "06:00:00"
            BookingsSocialSharingRestricted                           = $False
            DefaultGroupAccessType                                    = "Private"
            IPListBlocked                                             = @()
            SmtpActionableMessagesEnabled                             = $True
            SiteMailboxCreationURL                                    = $null
            BookingsPaymentsEnabled                                   = $False
            MailTipsExternalRecipientsTipsEnabled                     = $False
            AutoExpandingArchive                                      = $null
            ConnectorsEnabledForSharepoint                            = $True
            ReadTrackingEnabled                                       = $False
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
```

