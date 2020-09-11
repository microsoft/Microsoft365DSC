param
(
    [Parameter()]
    [System.String]
    $GlobalAdminUser,

    [Parameter()]
    [System.String]
    $GlobalAdminPassword,

    [Parameter()]
    [System.String]
    [ValidateSet('Public', 'GCC', 'GCCH', 'Germany', 'China')]
    $Environment = 'Public'
)

Configuration Master
{
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdmin,

        [Parameter()]
        [System.String]
        [ValidateSet('Public', 'GCC', 'GCCH', 'Germany', 'China')]
        $Environment = 'Public'
    )

    Import-DscResource -ModuleName Microsoft365DSC
    $Domain = $GlobalAdmin.Username.Split('@')[1]
    Node Localhost
    {
        AADApplication DSCApp1
        {
            DisplayName                   = "App1"
            AvailableToOtherTenants       = $false
            GroupMembershipClaims         = $null
            Homepage                      = "https://app.contoso.com"
            IdentifierUris                = "https://app.contoso.com"
            KnownClientApplications       = ""
            LogoutURL                     = "https://app.contoso.com/logout"
            Oauth2AllowImplicitFlow       = $false
            Oauth2AllowUrlPathMatching    = $false
            Oauth2RequirePostResponse     = $false
            PublicClient                  = $false
            ReplyURLs                     = "https://app.contoso.com"
            SamlMetadataUrl               = ""
            Ensure                        = "Present"
            GlobalAdminAccount            = $GlobalAdmin
        }

        AADGroupsNamingPolicy GroupsNamingPolicy
        {
            CustomBlockedWordsList        = @("CEO", "President");
            GlobalAdminAccount            = $GlobalAdmin;
            IsSingleInstance              = "Yes";
            PrefixSuffixNamingRequirement = "[Title]Test[Company][GroupName][Office]Redmond";
        }

        AADGroupsSettings GeneralGroupsSettings
        {
            AllowGuestsToAccessGroups     = $True;
            AllowGuestsToBeGroupOwner     = $True;
            AllowToAddGuests              = $True;
            EnableGroupCreation           = $True;
            Ensure                        = "Present";
            GlobalAdminAccount            = $GlobalAdmin;
            GroupCreationAllowedGroupName = "Office365DSC Core Team";
            GuestUsageGuidelinesUrl       = "";
            IsSingleInstance              = "Yes";
            UsageGuidelinesUrl            = "";
        }

        AADMSGroup AzureADMSGroup
        {
            DisplayName                   = "DSCCoreGroup"
            Description                   = "Microsoft DSC Group"
            SecurityEnabled               = $True
            MailEnabled                   = $True
            MailNickname                  = "M365DSCCoreGroup"
            Visibility                    = "Private"
            GroupTypes                    = @("Unified");
            GlobalAdminAccount            = $GlobalAdmin;
            Ensure                        = "Present"
        }

        EXOAcceptedDomain O365DSCDomain
        {
            Identity           = $Domain
            DomainType         = "Authoritative"
            GlobalAdminAccount = $GlobalAdmin
            Ensure             = "Present"
        }
        <#
        EXOAntiPhishPolicy AntiphishPolicy
        {
            MakeDefault                           = $null;
            PhishThresholdLevel                   = 1;
            EnableTargetedDomainsProtection       = $null;
            Identity                              = "Our Rule";
            TreatSoftPassAsAuthenticated          = $True;
            Enabled                               = $null;
            TargetedDomainsToProtect              = $null;
            EnableSimilarUsersSafetyTips          = $null;
            ExcludedDomains                       = $null;
            EnableAuthenticationSafetyTip         = $False;
            Ensure                                = "Present";
            TargetedDomainActionRecipients        = $null;
            EnableMailboxIntelligence             = $null;
            EnableSimilarDomainsSafetyTips        = $null;
            TargetedDomainProtectionAction        = "NoAction";
            AdminDisplayName                      = "";
            AuthenticationFailAction              = "MoveToJmf";
            GlobalAdminAccount                    = $GlobalAdmin;
            TargetedUserProtectionAction          = "NoAction";
            TargetedUsersToProtect                = $null;
            EnableTargetedUserProtection          = $null;
            ExcludedSenders                       = $null;
            EnableAuthenticationSoftPassSafetyTip = $False;
            EnableOrganizationDomainsProtection   = $null;
            EnableUnusualCharactersSafetyTips     = $null;
            TargetedUserActionRecipients          = $null;
            EnableAntispoofEnforcement            = $True;
        }

        EXOAntiPhishRule AntiPhishRule
        {
            ExceptIfSentToMemberOf    = $null;
            GlobalAdminAccount        = $GlobalAdmin;
            ExceptIfSentTo            = $null;
            SentTo                    = $null;
            ExceptIfRecipientDomainIs = $null;
            Identity                  = "Test Rule";
            Comments                  = $null;
            AntiPhishPolicy           = "Our Rule";
            RecipientDomainIs         = $null;
            Ensure                    = "Present";
            Enabled                   = $True;
            SentToMemberOf            = @("msteams_bb15d4@$Domain");
            Priority                  = 1;
        }

        EXOAtpPolicyForO365 AntiPhishPolicy
        {
            IsSingleInstance        = "Yes"
            AllowClickThrough       = $false
            BlockUrls               = "https://badurl.contoso.com"
            EnableATPForSPOTeamsODB = $true
            GlobalAdminAccount      = $GlobalAdmin
            Ensure                  = "Present"
        }#>

        $CASIdentity = 'ExchangeOnlineEssentials-759100cd-4fb6-46db-80ae-bb0ef4bd92b0'
        if ($Environment -eq 'GCC')
        {
            $CASIdentity = 'ExchangeOnlineEssentials-84fb79e4-1527-4f11-b2b9-48635783fcb2'
        }
        EXOCASMailboxPlan CASMailboxPlan
        {
            ActiveSyncEnabled  = $True;
            OwaMailboxPolicy   = "OwaMailboxPolicy-Default";
            GlobalAdminAccount = $GlobalAdmin;
            PopEnabled         = $True;
            Identity           = $CASIdentity;
            Ensure             = "Present";
            ImapEnabled        = $True
        }

        EXOClientAccessRule ClientAccessRule
        {
            Ensure                               = "Present";
            Action                               = "AllowAccess";
            GlobalAdminAccount                   = $GlobalAdmin;
            UserRecipientFilter                  = $null;
            ExceptAnyOfAuthenticationTypes       = @();
            ExceptUsernameMatchesAnyOfPatterns   = @();
            AnyOfAuthenticationTypes             = @();
            UsernameMatchesAnyOfPatterns         = @();
            Identity                             = "Always Allow Remote PowerShell";
            Priority                             = 1;
            AnyOfProtocols                       = @("RemotePowerShell");
            Enabled                              = $True;
            ExceptAnyOfProtocols                 = @();
            ExceptAnyOfClientIPAddressesOrRanges = @();
            AnyOfClientIPAddressesOrRanges       = @();
        }

        <#EXODkimSigningConfig DKIMSigning
        {
            KeySize                = 1024;
            GlobalAdminAccount     = $GlobalAdmin;
            Identity               = $Domain;
            HeaderCanonicalization = "Relaxed";
            Enabled                = $True;
            Ensure                 = "Present";
            BodyCanonicalization   = "Relaxed";
            AdminDisplayName       = "";
        }#>

        EXOOrganizationConfig EXOOrganizationConfig
        {
            ElcProcessingDisabled                                     = $False;
            IsSingleInstance                                          = "Yes";
            DefaultPublicFolderProhibitPostQuota                      = "13 KB (13,312 bytes)";
            VisibleMeetingUpdateProperties                            = "Location,AllProperties:15";
            BookingsEnabled                                           = $True;
            ExchangeNotificationRecipients                            = @();
            EwsEnabled                                                = $null;
            LinkPreviewEnabled                                        = $True;
            FocusedInboxOn                                            = $null;
            AsyncSendEnabled                                          = $True;
            EwsAllowEntourage                                         = $null;
            RemotePublicFolderMailboxes                               = @();
            AuditDisabled                                             = $False;
            EwsAllowMacOutlook                                        = $null;
            ConnectorsEnabledForTeams                                 = $True;
            DefaultPublicFolderIssueWarningQuota                      = "13 KB (13,312 bytes)";
            MailTipsMailboxSourcedTipsEnabled                         = $True;
            EndUserDLUpgradeFlowsDisabled                             = $False;
            DistributionGroupDefaultOU                                = $null;
            OutlookPayEnabled                                         = $True;
            EwsAllowOutlook                                           = $null;
            DefaultAuthenticationPolicy                               = $null;
            DistributionGroupNameBlockedWordsList                     = @();
            ConnectorsEnabled                                         = $True;
            DefaultPublicFolderAgeLimit                               = $null;
            OutlookMobileGCCRestrictionsEnabled                       = $False;
            ActivityBasedAuthenticationTimeoutEnabled                 = $True;
            GlobalAdminAccount                                        = $GlobalAdmin;
            ConnectorsEnabledForYammer                                = $True;
            HierarchicalAddressBookRoot                               = $null;
            DefaultPublicFolderMaxItemSize                            = "13 KB (13,312 bytes)";
            MailTipsLargeAudienceThreshold                            = 25;
            ConnectorsActionableMessagesEnabled                       = $True;
            ExchangeNotificationEnabled                               = $True;
            ActivityBasedAuthenticationTimeoutWithSingleSignOnEnabled = $True;
            DirectReportsGroupAutoCreationEnabled                     = $False;
            OAuth2ClientProfileEnabled                                = $True;
            AppsForOfficeEnabled                                      = $True;
            PublicFoldersEnabled                                      = "Local";
            WebPushNotificationsDisabled                              = $False;
            MailTipsGroupMetricsEnabled                               = $True;
            DefaultPublicFolderMovedItemRetention                     = "7.00:00:00";
            DistributionGroupNamingPolicy                             = "";
            DefaultPublicFolderDeletedItemRetention                   = "30.00:00:00";
            MailTipsAllTipsEnabled                                    = $True;
            LeanPopoutEnabled                                         = $False;
            PublicComputersDetectionEnabled                           = $False;
            ByteEncoderTypeFor7BitCharsets                            = 0;
            ConnectorsEnabledForOutlook                               = $True;
            WebSuggestedRepliesDisabled                               = $False;
            PublicFolderShowClientControl                             = $False;
            ActivityBasedAuthenticationTimeoutInterval                = "06:00:00";
            BookingsSocialSharingRestricted                           = $False;
            DefaultGroupAccessType                                    = "Private";
            IPListBlocked                                             = @();
            SmtpActionableMessagesEnabled                             = $True;
            SiteMailboxCreationURL                                    = $null;
            BookingsPaymentsEnabled                                   = $False;
            MailTipsExternalRecipientsTipsEnabled                     = $False;
            AutoExpandingArchive                                      = $null;
            ConnectorsEnabledForSharepoint                            = $True;
            ReadTrackingEnabled                                       = $False;
        }

        O365User JohnSmith
        {
            UserPrincipalName  = "John.Smith@$Domain"
            DisplayName        = "John Smith"
            FirstName          = "John"
            LastName           = "Smith"
            City               = "Gatineau"
            Country            = "Canada"
            Office             = "HQ"
            PostalCode         = "5K5 K5K"
            GlobalAdminAccount = $GlobalAdmin
            Ensure             = "Present"
        }

        O365Group O365DSCCoreTeam
        {
            DisplayName        = "Office365DSC Core Team"
            MailNickName       = "O365DSCCore"
            ManagedBy          = "admin@$Domain"
            Description        = "Group for all the Core Team members"
            Members            = @("John.Smith@$Domain")
            GlobalAdminAccount = $GlobalAdmin
            Ensure             = "Present"
            DependsOn          = "[O365User]JohnSmith"
        }

        # TODO - Re-assess current issue with PowerApps module
        <#if ($Environment -ne 'GCC')
        {
            $location = 'canada'
            PPPowerAppsEnvironment IntegrationPAEnvironment
            {
                DisplayName          = "Integration PowerApps Environment";
                Ensure               = "Present"
                EnvironmentSKU       = "Production";
                GlobalAdminAccount   = $GlobalAdmin;
                Location             = $location;
            }
        }#>

        SCAuditConfigurationPolicy SharePointAuditPolicy
        {
            Workload           = "SharePoint"
            Ensure             = "Present";
            GlobalAdminAccount = $GlobalAdmin;
        }

        SCAuditConfigurationPolicy OneDriveAuditPolicy
        {
            Workload           = "OneDriveForBusiness"
            Ensure             = "Present";
            GlobalAdminAccount = $GlobalAdmin;
        }

        SCAuditConfigurationPolicy ExchangeAuditPolicy
        {
            Workload           = "Exchange"
            Ensure             = "Present";
            GlobalAdminAccount = $GlobalAdmin;
        }

        SCComplianceSearch DemoSearchSPO
        {
            Case                                  = "Integration Case";
            HoldNames                             = @();
            Name                                  = "Integration Compliance Search - SPO";
            Ensure                                = "Present";
            Language                              = "iv";
            GlobalAdminAccount                    = $GlobalAdmin;
            AllowNotFoundExchangeLocationsEnabled = $False;
            SharePointLocation                    = @("All");
        }

        SCComplianceSearch DemoSearchEXO
        {
            Case                                  = "Integration Case";
            HoldNames                             = @();
            Name                                  = "Integration Compliance Search - EXO";
            Ensure                                = "Present";
            Language                              = "iv";
            GlobalAdminAccount                    = $GlobalAdmin;
            AllowNotFoundExchangeLocationsEnabled = $False;
            ExchangeLocation                      = @("All")
            PublicFolderLocation                  = @("All")
        }

        SCComplianceSearchAction DemoSearchActionRetention
        {
            IncludeSharePointDocumentVersions = $False;
            Action                            = "Retention";
            SearchName                        = "Integration Compliance Search - EXO";
            GlobalAdminAccount                = $GlobalAdmin;
            IncludeCredential                 = $False;
            RetryOnError                      = $False;
            ActionScope                       = "IndexedItemsOnly";
            Ensure                            = "Present";
            EnableDedupe                      = $False;
        }

        SCComplianceSearchAction DemoSearchActionPurge
        {
            Action             = "Purge";
            SearchName         = "Integration Compliance Search - EXO";
            GlobalAdminAccount = $GlobalAdmin;
            IncludeCredential  = $False;
            RetryOnError       = $False;
            Ensure             = "Present";
        }

        SCComplianceCase DemoCase
        {
            Name               = "Integration Case"
            Description        = "This Case is generated by the Integration Tests"
            Status             = "Active"
            Ensure             = "Present"
            GlobalAdminAccount = $GlobalAdmin
        }

        SCCaseHoldPolicy DemoCaseHoldPolicy
        {
            Case                 = "Integration Case";
            ExchangeLocation     = "John.Smith@$Domain";
            Name                 = "Integration Hold"
            PublicFolderLocation = "All";
            Comment              = "This is a test for integration"
            Ensure               = "Present"
            Enabled              = $True
            GlobalAdminAccount   = $GlobalAdmin;
        }

        SCCaseHoldRule DemoHoldRule
        {
            Name               = "Integration Hold"
            Policy             = "Integration Hold"
            Comment            = "This is a demo rule"
            Disabled           = $false
            ContentMatchQuery  = "filename:2016 budget filetype:xlsx"
            Ensure             = "Present"
            GlobalAdminAccount = $GlobalAdmin
        }

        SCComplianceTag DemoRule
        {
            Name               = "DemoTag"
            Comment            = "This is a Demo Tag"
            RetentionAction    = "Keep"
            RetentionDuration  = "1025"
            RetentionType      = "ModificationAgeInDays"
            FilePlanProperty   = MSFT_SCFilePlanProperty
            {
                FilePlanPropertyDepartment = "Human resources"
                FilePlanPropertyCategory   = "Accounts receivable"
            }
            Ensure             = "Present"
            GlobalAdminAccount = $GlobalAdmin
        }

        SCDLPCompliancePolicy DLPPolicy
        {
            Name               = "MyDLPPolicy"
            Comment            = "Test Policy"
            Priority           = 0
            SharePointLocation = "https://$($Domain.Split('.')[0]).sharepoint.com/sites/Classic"
            Ensure             = "Present"
            GlobalAdminAccount = $GlobalAdmin
        }

        SCDLPComplianceRule DLPRule
        {
            Name                                = "MyDLPRule";
            Policy                              = "MyDLPPolicy"
            BlockAccess                         = $True;
            Ensure                              = "Present";
            GlobalAdminAccount                  = $GlobalAdmin
            ContentContainsSensitiveInformation = @(MSFT_SCDLPSensitiveInformation
            {
                name = 'U.S. Social Security Number (SSN)'
                id = 'a44669fe-0d48-453d-a9b1-2cc83f2cba77'
                maxconfidence = '100'
                minconfidence = '-1'
                classifiertype = 'Content'
                mincount = '1'
                maxcount = '-1'
            }
            MSFT_SCDLPSensitiveInformation
            {
                name = 'Azure DocumentDB Auth Key'
                id = '0f587d92-eb28-44a9-bd1c-90f2892b47aa'
                maxconfidence = '100'
                minconfidence = '85'
                classifiertype = 'Content'
                mincount = '1'
                maxcount = '-1'
            })
        }

        SCFilePlanPropertyAuthority FilePlanPropertyAuthority
        {
            Name               = "My Authority"
            Ensure             = "Present"
            GlobalAdminAccount = $GlobalAdmin
        }

        SCFilePlanPropertyCategory FilePlanPropertyCategory
        {
            Name               = "My Category"
            Ensure             = "Present"
            GlobalAdminAccount = $GlobalAdmin
        }

        SCFilePlanPropertyCitation IntegrationCitation
        {
            Name                 = "Integration Citation"
            CitationURL          = "https://contoso.com"
            CitationJurisdiction = "Federal"
            Ensure               = "Present"
            GlobalAdminAccount   = $GlobalAdmin
        }

        SCFilePlanPropertyDepartment FilePlanPropertyDepartment
        {
            Name               = "Demo Department"
            Ensure             = "Present"
            GlobalAdminAccount = $GlobalAdmin
        }

        SCFilePlanPropertyReferenceId FilePlanPropertyReferenceId
        {
            Name               = "My Reference ID"
            Ensure             = "Present"
            GlobalAdminAccount = $GlobalAdmin
        }

        SCRetentionCompliancePolicy RCPolicy
        {
            Name               = "MyRCPolicy"
            Comment            = "Test Policy"
            ExchangeLocation   = @()
            Ensure             = "Present"
            GlobalAdminAccount = $GlobalAdmin
        }

        SCRetentionComplianceRule RCRule
        {
            Name                         = "DemoRule2"
            Policy                       = "MyRCPolicy"
            Comment                      = "This is a Demo Rule"
            RetentionComplianceAction    = "Keep"
            RetentionDuration            = "Unlimited"
            RetentionDurationDisplayHint = "Days"
            GlobalAdminAccount           = $GlobalAdmin
            Ensure                       = "Present"
        }

        SCSupervisoryReviewPolicy SRPolicy
        {
            Name               = "MySRPolicy"
            Comment            = "Test Policy"
            Reviewers          = @($GlobalAdmin.UserName)
            Ensure             = "Present"
            GlobalAdminAccount = $GlobalAdmin
        }

        SCSupervisoryReviewRule SRRule
        {
            Name               = "DemoRule"
            Condition          = "(Reviewee:$($GlobalAdmin.UserName))"
            SamplingRate       = 100
            Policy             = 'MySRPolicy'
            Ensure             = "Present"
            GlobalAdminAccount = $GlobalAdmin
        }

        SPOSearchManagedProperty ManagedProp1
        {
            Name               = "Gilles"
            Type               = "Text"
            GlobalAdminAccount = $GlobalAdmin
            Ensure             = "Present"
        }

        SPOSite ClassicSite
        {
            Title              = "Classic Site"
            Url                = "https://$($Domain.Split('.')[0]).sharepoint.com/sites/Classic"
            Owner              = $GlobalAdmin.UserName
            Template           = "STS#0"
            TimeZoneID         = 13
            GlobalAdminAccount = $GlobalAdmin
            Ensure             = "Present"
        }

        SPOSite ModernSite
        {
            Title              = "Modern Site"
            Url                = "https://$($Domain.Split('.')[0]).sharepoint.com/sites/Modern"
            Owner              = $GlobalAdmin.UserName
            Template           = "STS#3"
            TimeZoneID         = 13
            GlobalAdminAccount = $GlobalAdmin
            Ensure             = "Present"
        }

        SPOSite TestWithoutTemplate
        {
            Title                                       = "No Templates"
            Url                                         = "https://$($Domain.Split('.')[0]).sharepoint.com/sites/NoTemplates"
            Owner                                       = $GlobalAdmin.UserName
            TimeZoneID                                  = 13
            AllowSelfServiceUpgrade                     = $True;
            AnonymousLinkExpirationInDays               = 0;
            CommentsOnSitePagesDisabled                 = $False;
            DefaultLinkPermission                       = "None";
            DefaultSharingLinkType                      = "None";
            DenyAddAndCustomizePages                    = $True;
            DisableAppViews                             = "NotDisabled";
            DisableCompanyWideSharingLinks              = "NotDisabled";
            DisableFlows                                = $False;
            LocaleId                                    = 1033;
            OverrideTenantAnonymousLinkExpirationPolicy = $False;
            ShowPeoplePickerSuggestionsForGuestUsers    = $False;
            SocialBarOnSitePagesDisabled                = $False;
            StorageMaximumLevel                         = 26214400;
            StorageWarningLevel                         = 25574400;
            GlobalAdminAccount = $GlobalAdmin
            Ensure             = "Present"
        }

        SPOPropertyBag MyKey
        {
            Url                = "https://$($Domain.Split('.')[0]).sharepoint.com/sites/Modern"
            Key                = "MyKey"
            Value              = "MyValue#3"
            GlobalAdminAccount = $GlobalAdmin
            Ensure             = "Present"
        }

        SPOSearchResultSource SearchMP
        {
            Name               = "MyResultSource"
            Description        = "Description of item"
            Protocol           = "Local"
            Type               = "SharePoint"
            GlobalAdminAccount = $GlobalAdmin
            Ensure             = "Present"
        }

        SPOSiteAuditSettings MyStorageEntity
        {
            Url                = "https://$($Domain.Split('.')[0]).sharepoint.com/sites/Classic"
            AuditFlags         = "All"
            GlobalAdminAccount = $GlobalAdmin
        }

        SPOSiteGroup TestSiteGroup
        {
            Url                                         = "https://$($Domain.Split('.')[0]).sharepoint.com/sites/Modern"
            Identity                                    = "TestSiteGroup"
            PermissionLevels                            = @("Edit", "Read")
            Ensure                                      = "Present"
            GlobalAdminAccount                          = $GlobalAdmin
        }
        SPOTheme SPTheme01
        {
            GlobalAdminAccount = $GlobalAdmin
            Name               = "Integration Palette"
            Palette            = @(MSFT_SPOThemePaletteProperty
                {
                    Property = "themePrimary"
                    Value    = "#0078d4"
                }
                MSFT_SPOThemePaletteProperty
                {
                    Property = "themeLighterAlt"
                    Value    = "#eff6fc"
                }
            )
        }

        SPOTenantCdnEnabled CDN
        {
            Enable             = $True
            CdnType            = "Public"
            GlobalAdminAccount = $GlobalAdmin;
            Ensure             = "Present"
        }

        SPOOrgAssetsLibrary OrgAssets
        {
            LibraryUrl         = "https://$($Domain.Split('.')[0]).sharepoint.com/sites/Modern/Shared Documents"
            CdnType            = "Public"
            GlobalAdminAccount = $GlobalAdmin;
            Ensure             = "Present"
        }

        # TODO - Investigate this for GCC
        <#if ($Environment -ne 'GCC')
        {
            SPOUserProfileProperty SPOUserProfileProperty
            {
                UserName           = "admin@$Domain"
                Properties         = @(
                    MSFT_SPOUserProfilePropertyInstance
                    {
                        Key   = "FavoriteFood"
                        Value = "Pasta"
                    }
                )
                GlobalAdminAccount = $GlobalAdmin
                Ensure             = "Present"
            }
        }#>

        TeamsUpgradeConfiguration UpgradeConfig
        {
            DownloadTeams        = $True;
            GlobalAdminAccount   = $GlobalAdmin
            IsSingleInstance     = "Yes"
            SfBMeetingJoinUx     = "NativeLimitedClient"
        }

        TeamsMeetingBroadcastPolicy IntegrationBroadcastPolicy
        {
            AllowBroadcastScheduling        = $True;
            AllowBroadcastTranscription     = $False;
            BroadcastAttendeeVisibilityMode = "EveryoneInCompany";
            BroadcastRecordingMode          = "AlwaysEnabled";
            Ensure                          = "Present";
            GlobalAdminAccount              = $GlobalAdmin;
            Identity                        = "IntegrationPolicy";
        }

        TeamsClientConfiguration TeamsClientConfiguration
        {
            AllowBox                         = $True;
            AllowDropBox                     = $True;
            AllowEmailIntoChannel            = $True;
            AllowGoogleDrive                 = $True;
            AllowGuestUser                   = $True;
            AllowOrganizationTab             = $True;
            AllowResourceAccountSendMessage  = $True;
            AllowScopedPeopleSearchandAccess = $False;
            AllowShareFile                   = $True;
            AllowSkypeBusinessInterop        = $True;
            ContentPin                       = "RequiredOutsideScheduleMeeting";
            GlobalAdminAccount               = $GlobalAdmin;
            Identity                         = "Global";
            ResourceAccountContentAccess     = "NoAccess";
            RestrictedSenderList             = $null;
        }

        TeamsChannelsPolicy IntegrationChannelPolicy
        {
            AllowOrgWideTeamCreation    = $True;
            AllowPrivateChannelCreation = $True;
            AllowPrivateTeamDiscovery   = $True;
            Description                 = $null;
            Ensure                      = "Present";
            GlobalAdminAccount          = $GlobalAdmin;
            Identity                    = "Integration Channel Policy";
        }

        TeamsEmergencyCallingPolicy EmergencyCallingPolicy
        {
            Description               = "Integration Test";
            Identity                  = "Integration Emergency Calling Policy";
            NotificationDialOutNumber = "12312345678";
            NotificationGroup         = $GlobalAdmin.UserName;
            NotificationMode          = "NotificationOnly";
            Ensure                    = "Present"
            GlobalAdminAccount        = $GlobalAdmin
        }

        TeamsMeetingBroadcastConfiguration MeetingBroadcastConfiguration
        {
            Identity                            = 'Global'
            AllowSdnProviderForBroadcastMeeting = $True
            SupportURL                          = "https://support.office.com/home/contact"
            SdnProviderName                     = "hive"
            SdnLicenseId                        = "5c12d0-d52950-e03e66-92b587"
            SdnApiTemplateUrl                   = "https://api.hivestreaming.com/v1/eventadmin?partner_token={0}"
            GlobalAdminAccount                  = $GlobalAdmin
        }

        TeamsEmergencyCallRoutingPolicy EmergencyCallRoutingPolicyExample
        {
            AllowEnhancedEmergencyServices = $False;
            Description                    = "Description";
            EmergencyNumbers               = @(
                MSFT_TeamsEmergencyNumber
                {
                    EmergencyDialString = '123456'
                    EmergencyDialMask   = '123'
                    OnlinePSTNUsage     = ''
                }
            );
            Ensure                         = "Present";
            GlobalAdminAccount             = $GlobalAdmin;
            Identity                       = "Integration Test";
        }

        TeamsMeetingPolicy DemoMeetingPolicy
        {
            AllowAnonymousUsersToStartMeeting          = $False;
            AllowChannelMeetingScheduling              = $True;
            AllowCloudRecording                        = $True;
            AllowExternalParticipantGiveRequestControl = $False;
            AllowIPVideo                               = $True;
            AllowMeetNow                               = $True;
            AllowOutlookAddIn                          = $True;
            AllowParticipantGiveRequestControl         = $True;
            AllowPowerPointSharing                     = $True;
            AllowPrivateMeetingScheduling              = $True;
            AllowSharedNotes                           = $True;
            AllowTranscription                         = $False;
            AllowWhiteboard                            = $True;
            AutoAdmittedUsers                          = "Everyone";
            Description                                = "Integration Meeting Policy";
            Ensure                                     = "Present";
            GlobalAdminAccount                         = $GlobalAdmin;
            Identity                                   = "Integration Meeting Policy";
            MediaBitRateKb                             = 50000;
            ScreenSharingMode                          = "EntireScreen";
        }

        TeamsTeam TeamAlpha
        {
            DisplayName          = "Alpha Team"
            AllowAddRemoveApps   = $true
            AllowChannelMentions = $false
            GlobalAdminAccount   = $GlobalAdmin
            Ensure               = "Present"
        }

        TeamsChannel ChannelAlpha1
        {
            DisplayName        = "Channel Alpha"
            Description        = "Test Channel"
            TeamName           = "Alpha Team"
            GlobalAdminAccount = $GlobalAdmin
            Ensure             = "Present"
            DependsON          = "[TeamsTeam]TeamAlpha"
        }

        TeamsUser MemberJohn
        {
            TeamName           = "Alpha Team"
            User               = "John.Smith@$($Domain)"
            GlobalAdminAccount = $GlobalAdmin
            Ensure             = "Present"
            DependsON          = @("[O365User]JohnSmith", "[TeamsTeam]TeamAlpha")
        }

        TeamsMeetingConfiguration MeetingConfiguration
        {
            ClientAppSharingPort        = 50040;
            ClientAppSharingPortRange   = 20;
            ClientAudioPort             = 50000;
            ClientAudioPortRange        = 21;
            ClientMediaPortRangeEnabled = $True;
            ClientVideoPort             = 50020;
            ClientVideoPortRange        = 20;
            CustomFooterText            = "This is some custom footer text";
            DisableAnonymousJoin        = $False;
            EnableQoS                   = $False;
            GlobalAdminAccount          = $GlobalAdmin;
            HelpURL                     = "https://github.com/Microsoft/Microsoft365DSC/Help";
            Identity                    = "Global";
            LegalURL                    = "https://github.com/Microsoft/Microsoft365DSC/Legal";
            LogoURL                     = "https://github.com/Microsoft/Microsoft365DSC/Logo.png";
        }

        TeamsGuestCallingConfiguration GuestCallingConfig
        {
            Identity            = "Global";
            AllowPrivateCalling = $True;
            GlobalAdminAccount  = $GlobalAdmin;
        }

        TeamsMessagingPolicy SampleTeamsMessage
        {
            Identity                      = "TestPolicy"
            Description                   = "My sample policy"
            ReadReceiptsEnabledType       = "UserPreference"
            AllowImmersiveReader          = $True
            AllowGiphy                    = $True
            AllowStickers                 = $True
            AllowUrlPreviews              = $false
            AllowUserChat                 = $True
            AllowUserDeleteMessage        = $false
            AllowUserTranslation          = $True
            AllowRemoveUser               = $false
            AllowPriorityMessages         = $True
            GiphyRatingType               = "MODERATE"
            AllowMemes                    = $False
            AudioMessageEnabledType       = "ChatsOnly"
            AllowOwnerDeleteMessage       = $False
            ChannelsInChatListEnabledType = "EnabledUserOverride"
            GlobalAdminAccount            = $GlobalAdmin
            Ensure                        = "Present"
        }

        TeamsTenantDialPlan TestTenantDialPlan
        {
            Description           = 'This is a demo dial plan';
            Ensure                = "Present";
            GlobalAdminAccount    = $GlobalAdmin;
            Identity              = "DemoPlan";
            NormalizationRules    = MSFT_TeamsVoiceNormalizationRule{
                Pattern = '^00(\d+)$'
                Description = 'LB International Dialing Rule'
                Identity = 'LB Intl Dialing'
                Translation = '+$1'
                Priority = 0
                IsInternalExtension = $False
            };
            OptimizeDeviceDialing = $true;
            SimpleName            = "DemoPlan";
        }

        if ($Environment -ne 'GCC')
        {
            SCSensitivityLabel SCSenLabel
            {
                Name               = "Demo Label"
                Comment            = "Demo label comment"
                ToolTip            = "Demo tool tip"
                DisplayName        = "Demo label"

                LocaleSettings     = @(
                    MSFT_SCLabelLocaleSettings
                    {
                        LocaleKey = "DisplayName"
                        Settings  = @(
                            MSFT_SCLabelSetting
                            {
                                Key   = "en-us"
                                Value = "English Display Names"
                            }
                            MSFT_SCLabelSetting
                            {
                                Key   = "fr-fr"
                                Value = "Nom da'ffichage francais"
                            }
                        )
                    }
                    MSFT_SCLabelLocaleSettings
                    {
                        LocaleKey = "StopColor"
                        Settings  = @(
                            MSFT_SCLabelSetting
                            {
                                Key   = "en-us"
                                Value = "RedGreen"
                            }
                            MSFT_SCLabelSetting
                            {
                                Key   = "fr-fr"
                                Value = "Rouge"
                            }
                        )
                    }
                )
                AdvancedSettings   = @(
                    MSFT_SCLabelSetting
                    {
                        Key   = "AllowedLevel"
                        Value = @("Sensitive", "Classified")
                    }
                    MSFT_SCLabelSetting
                    {
                        Key   = "LabelStatus"
                        Value = "Enabled"
                    }
                )
                GlobalAdminAccount = $GlobalAdmin
                Ensure             = "Present"
            }
        }
    }
}

$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName                    = "Localhost"
            PSDSCAllowPlaintextPassword = $true
        }
    )
}

# Compile and deploy configuration
$password = ConvertTo-SecureString $GlobalAdminPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($GlobalAdminUser, $password)
Master -ConfigurationData $ConfigurationData -GlobalAdmin $credential -Environment $Environment
Start-DscConfiguration Master -Wait -Force -Verbose
