<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

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
