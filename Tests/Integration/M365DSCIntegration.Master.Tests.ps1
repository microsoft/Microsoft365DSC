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
        #region AAD
        AADAdministrativeUnit AADAdministrativeUnit
        {
            Credential           = $GlobalAdmin;
            DisplayName          = "M365DSC Integration";
            Ensure               = "Present";
            Visibility           = 'HiddenMembership'
        }

        AADApplication 'DSCApp1'
        {
            DisplayName               = "App1"
            AvailableToOtherTenants   = $false
            Homepage                  = "https://app.contoso.com"
            LogoutURL                 = "https://app.contoso.com/logout"
            PublicClient              = $false
            ReplyURLs                 = "https://app.contoso.com"
            Permissions               = @(
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.Read'
                    type                = 'Delegated'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $false
                }
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.ReadWrite.All'
                    type                = 'Delegated'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $True
                }
                MSFT_AADApplicationPermission
                {
                    Name                = 'User.Read.All'
                    type                = 'AppOnly'
                    SourceAPI           = 'Microsoft Graph'
                    AdminConsentGranted = $True
                }
            )
            Ensure                    = "Present"
            Credential                = $GlobalAdmin
        }

        <#AADConditionalAccessPolicy 'DSCConditionalAccessPolicy1'
        {
            BuiltInControls            = @("Mfa", "CompliantDevice", "DomainJoinedDevice", "ApprovedApplication", "CompliantApplication")
            ClientAppTypes             = @("ExchangeActiveSync", "Browser", "MobileAppsAndDesktopClients", "Other")
            CloudAppSecurityIsEnabled  = $True
            CloudAppSecurityType       = "MonitorOnly"
            DisplayName                = "Allin-example"
            ExcludeApplications        = @("803ee9ca-3f7f-4824-bd6e-0b99d720c35c", "00000012-0000-0000-c000-000000000000", "00000007-0000-0000-c000-000000000000", "Office365")
            ExcludeDevices             = @("Compliant", "DomainJoined")
            ExcludeGroups              = @()
            ExcludeLocations           = @("Blocked Countries")
            ExcludePlatforms           = @("Windows", "WindowsPhone", "MacOS")
            ExcludeRoles               = @("Company Administrator", "Application Administrator", "Application Developer", "Cloud Application Administrator", "Cloud Device Administrator")
            ExcludeUsers               = @("admin@$Domain", "GuestsOrExternalUsers")
            GrantControlOperator       = "OR"
            IncludeApplications        = @("All")
            IncludeDevices             = @("All")
            IncludeGroups              = @()
            IncludeLocations           = @("AllTrusted")
            IncludePlatforms           = @("Android", "IOS")
            IncludeRoles               = @("Compliance Administrator")
            IncludeUserActions         = @()
            IncludeUsers               = @("Alexw@$Domain")
            PersistentBrowserIsEnabled = $false
            PersistentBrowserMode      = ""
            SignInFrequencyIsEnabled   = $True
            SignInFrequencyType        = "Hours"
            SignInFrequencyValue       = 5
            SignInRiskLevels           = @("High", "Medium")
            State                      = "disabled"
            UserRiskLevels             = @("High", "Medium")
            Ensure                     = "Present"
            Credential                 = $GlobalAdmin
        }#>

        AADGroup 'DSCAzureADGroup'
        {
            DisplayName     = "DSCCoreGroup"
            Description     = "Microsoft DSC Group"
            SecurityEnabled = $True
            MailEnabled     = $True
            MailNickname    = "M365DSCCoreGroup"
            Visibility      = "Private"
            GroupTypes      = @("Unified")
            Ensure          = "Present"
            Credential      = $GlobalAdmin
        }

        <#AADGroupLifecyclePolicy 'DSCGroupLifecyclePolicy'
        {
            IsSingleInstance            = "Yes"
            AlternateNotificationEmails = @("john.smith@$Domain")
            GroupLifetimeInDays         = 99
            ManagedGroupTypes           = "Selected"
            Ensure                      = "Present"
            Credential                  = $GlobalAdmin
        }

        AADGroupsNamingPolicy 'DSCGroupsNamingPolicy'
        {
            IsSingleInstance              = "Yes"
            CustomBlockedWordsList        = @("CEO", "President")
            PrefixSuffixNamingRequirement = "[Title]Test[Company][GroupName][Office]Redmond"
            Ensure                        = "Present"
            Credential                    = $GlobalAdmin
        }#>

        AADGroupsSettings 'DSCGeneralGroupsSettings'
        {
            IsSingleInstance              = "Yes"
            AllowGuestsToAccessGroups     = $True
            AllowGuestsToBeGroupOwner     = $True
            AllowToAddGuests              = $True
            EnableGroupCreation           = $True
            GroupCreationAllowedGroupName = "Microsoft365DSC Core Team"
            GuestUsageGuidelinesUrl       = "https://contoso.com/guestusage"
            UsageGuidelinesUrl            = "https://contoso.com/usage"
            Ensure                        = "Present"
            Credential                    = $GlobalAdmin
        }

        AADNamedLocationPolicy 'DSCNamedLocationCompanyNetwork'
        {
            DisplayName = "Company Network"
            IpRanges    = @("2.1.1.1/32", "1.2.2.2/32")
            IsTrusted   = $True
            OdataType   = "#microsoft.graph.ipNamedLocation"
            Ensure      = "Present"
            Credential  = $GlobalAdmin
        }

        AADNamedLocationPolicy 'DSCNamedLocationAllowedCountries'
        {
            CountriesAndRegions               = @("GH", "AX", "DZ", "AI", "AM")
            DisplayName                       = "Allowed Countries"
            IncludeUnknownCountriesAndRegions = $False
            OdataType                         = "#microsoft.graph.countryNamedLocation"
            Ensure                            = "Present"
            Credential                        = $GlobalAdmin
        }

        <#AADRoleDefinition 'DSCRoleDefinition1'
        {
            DisplayName     = "DSCRole1"
            Description     = "DSC created role definition"
            ResourceScopes  = "/"
            IsEnabled       = $true
            RolePermissions = "microsoft.directory/applicationPolicies/allProperties/read", "microsoft.directory/applicationPolicies/allProperties/update", "microsoft.directory/applicationPolicies/basic/update"
            Version         = "1.0"
            Ensure          = "Present"
            Credential      = $GlobalAdmin
        }#>

        if ($Environment -eq 'Public')
        {
            AADServicePrincipal 'DSCAADServicePrincipal1'
            {
                AccountEnabled            = $True;
                AlternativeNames          = @();
                AppId                     = "46dc333e-6f5e-4bdd-8f7f-aa0c1fa68acc";
                AppRoleAssignmentRequired = $False;
                Credential                = $GlobalAdmin;
                DisplayName               = "Microsoft365DSC";
                Ensure                    = "Present";
                ObjectID                  = "3c3d9e95-2456-43c8-a3c7-a5879c52a919";
                ReplyURLs                 = @("https://app.getpostman.com/oauth2/callback");
                ServicePrincipalNames     = @("46dc333e-6f5e-4bdd-8f7f-aa0c1fa68acc");
                ServicePrincipalType      = "Application";
                Tags                      = @("WindowsAzureActiveDirectoryIntegratedApp");
            }
        }

        AADTenantDetails 'DSCTenantDetails'
        {
            IsSingleInstance                     = 'Yes'
            TechnicalNotificationMails           = "example@contoso.com"
            SecurityComplianceNotificationPhones = "+1123456789"
            SecurityComplianceNotificationMails  = "example@contoso.com"
            MarketingNotificationEmails          = "example@contoso.com"
            Credential                           = $GlobalAdmin
        }

        AADTokenLifetimePolicy 'DSCTokenLifetimePolicy1'
        {
            DisplayName           = "PolicyDisplayName"
            Definition            = @('{"TokenLifetimePolicy":{"Version":1,"AccessTokenLifetime":"02:00:00"}}')
            IsOrganizationDefault = $false
            Ensure                = "Present"
            Credential            = $GlobalAdmin
        }
        #endregion

        #region EXO
        EXOAcceptedDomain 'O365DSCDomain'
        {
            Identity   = $Domain
            DomainType = "Authoritative"
            Credential = $GlobalAdmin
            Ensure     = "Present"
        }
        <#
        EXOAntiPhishPolicy AntiphishPolicy
        {
            MakeDefault                           = $null
            PhishThresholdLevel                   = 1
            EnableTargetedDomainsProtection       = $null
            Identity                              = "Our Rule"
            TreatSoftPassAsAuthenticated          = $True
            Enabled                               = $null
            TargetedDomainsToProtect              = $null
            EnableSimilarUsersSafetyTips          = $null
            ExcludedDomains                       = $null
            EnableAuthenticationSafetyTip         = $False
            Ensure                                = "Present"
            TargetedDomainActionRecipients        = $null
            EnableMailboxIntelligence             = $null
            EnableSimilarDomainsSafetyTips        = $null
            TargetedDomainProtectionAction        = "NoAction"
            AdminDisplayName                      = ""
            AuthenticationFailAction              = "MoveToJmf"
            Credential                    = $GlobalAdmin
            TargetedUserProtectionAction          = "NoAction"
            TargetedUsersToProtect                = $null
            EnableTargetedUserProtection          = $null
            ExcludedSenders                       = $null
            EnableAuthenticationSoftPassSafetyTip = $False
            EnableOrganizationDomainsProtection   = $null
            EnableUnusualCharactersSafetyTips     = $null
            TargetedUserActionRecipients          = $null
            EnableAntispoofEnforcement            = $True
        }

        EXOAntiPhishRule AntiPhishRule
        {
            ExceptIfSentToMemberOf    = $null
            Credential        = $GlobalAdmin
            ExceptIfSentTo            = $null
            SentTo                    = $null
            ExceptIfRecipientDomainIs = $null
            Identity                  = "Test Rule"
            Comments                  = $null
            AntiPhishPolicy           = "Our Rule"
            RecipientDomainIs         = $null
            Ensure                    = "Present"
            Enabled                   = $True
            SentToMemberOf            = @("msteams_bb15d4@$Domain")
            Priority                  = 1
        }

        EXOAtpPolicyForO365 AntiPhishPolicy
        {
            IsSingleInstance        = "Yes"
            AllowClickThrough       = $false
            BlockUrls               = "https://badurl.contoso.com"
            EnableATPForSPOTeamsODB = $true
            Credential      = $GlobalAdmin
            Ensure                  = "Present"
        }#>

        $CASIdentity = 'ExchangeOnlineEssentials-759100cd-4fb6-46db-80ae-bb0ef4bd92b0'
        if ($Environment -eq 'Public')
        {
            EXOCASMailboxPlan CASMailboxPlan
            {
                ActiveSyncEnabled = $True
                OwaMailboxPolicy  = "OwaMailboxPolicy-Default"
                Credential        = $GlobalAdmin
                PopEnabled        = $True
                Identity          = $CASIdentity
                Ensure            = "Present"
                ImapEnabled       = $True
            }
        }

        EXOClientAccessRule ClientAccessRule
        {
            Ensure                               = "Present"
            Action                               = "AllowAccess"
            Credential                           = $GlobalAdmin
            UserRecipientFilter                  = $null
            ExceptAnyOfAuthenticationTypes       = @()
            ExceptUsernameMatchesAnyOfPatterns   = @()
            AnyOfAuthenticationTypes             = @()
            UsernameMatchesAnyOfPatterns         = @()
            Identity                             = "Always Allow Remote PowerShell"
            Priority                             = 1
            AnyOfProtocols                       = @("RemotePowerShell")
            Enabled                              = $True
            ExceptAnyOfProtocols                 = @()
            ExceptAnyOfClientIPAddressesOrRanges = @()
            AnyOfClientIPAddressesOrRanges       = @()
        }

        <#EXODkimSigningConfig DKIMSigning
        {
            KeySize                = 1024
            Credential     = $GlobalAdmin
            Identity               = $Domain
            HeaderCanonicalization = "Relaxed"
            Enabled                = $True
            Ensure                 = "Present"
            BodyCanonicalization   = "Relaxed"
            AdminDisplayName       = ""
        }#>

        EXOOrganizationConfig EXOOrganizationConfig
        {
            ElcProcessingDisabled                                     = $False
            IsSingleInstance                                          = "Yes"
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
            DefaultPublicFolderMovedItemRetention                     = "7.00:00:00"
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
            Credential                                                = $GlobalAdmin
        }
        #endregion

        #region Intune
        <#
        IntuneDeviceConfigurationPolicyAndroidWorkProfile IntuneDeviceConfigurationPolicyAndroidWorkProfile
        {
            DisplayName                                    = "Android Work Profile - Device Restrictions - Standard"
            PasswordBlockFingerprintUnlock                 = $False
            PasswordBlockTrustAgents                       = $False
            PasswordMinimumLength                          = 6
            PasswordMinutesOfInactivityBeforeScreenTimeout = 15
            PasswordRequiredType                           = "atLeastNumeric"
            SecurityRequireVerifyApps                      = $True
            WorkProfileBlockAddingAccounts                 = $True
            WorkProfileBlockCamera                         = $False
            WorkProfileBlockCrossProfileCallerId           = $False
            WorkProfileBlockCrossProfileContactsSearch     = $False
            WorkProfileBlockCrossProfileCopyPaste          = $True
            WorkProfileBlockNotificationsWhileDeviceLocked = $True
            WorkProfileBlockScreenCapture                  = $True
            WorkProfileBluetoothEnableContactSharing       = $False
            WorkProfileDataSharingType                     = "allowPersonalToWork"
            WorkProfileDefaultAppPermissionPolicy          = "deviceDefault"
            WorkProfilePasswordBlockFingerprintUnlock      = $False
            WorkProfilePasswordBlockTrustAgents            = $False
            WorkProfilePasswordRequiredType                = "deviceDefault"
            WorkProfileRequirePassword                     = $False
            Ensure                                         = "Present"
            Credential                                     = $GlobalAdmin
        }
        #>
        #endregion
        #region O365
        AADUSer JohnSmith
        {
            UserPrincipalName = "John.Smith@$Domain"
            DisplayName       = "John Smith"
            FirstName         = "John"
            LastName          = "Smith"
            City              = "Gatineau"
            Country           = "Canada"
            Office            = "HQ"
            PostalCode        = "5K5 K5K"
            Credential        = $GlobalAdmin
            Ensure            = "Present"
        }

        if ($Environment -eq 'Public')
        {
            O365Group O365DSCCoreTeam
            {
                DisplayName  = "Microsoft365DSC Core Team"
                MailNickName = "O365DSCCore"
                ManagedBy    = "admin@$Domain"
                Description  = "Group for all the Core Team members"
                Members      = @("John.Smith@$Domain")
                Credential   = $GlobalAdmin
                Ensure       = "Present"
                DependsOn    = "[AADUSer]JohnSmith"
            }
        }
        #endregion

        #region PP
        # TODO - Re-assess current issue with PowerApps module
        <#if ($Environment -ne 'GCC')
        {
            $location = 'canada'
            PPPowerAppsEnvironment IntegrationPAEnvironment
            {
                DisplayName          = "Integration PowerApps Environment"
                Ensure               = "Present"
                EnvironmentSKU       = "Production"
                Credential   = $GlobalAdmin
                Location             = $location
            }
        }#>
        #endregion

        #region SC
        if ($Environment -ne 'GCCH')
        {
            SCAuditConfigurationPolicy OneDriveAuditPolicy
            {
                Workload   = "OneDriveForBusiness"
                Ensure     = "Present"
                Credential = $GlobalAdmin
            }

            SCAuditConfigurationPolicy ExchangeAuditPolicy
            {
                Workload   = "Exchange"
                Ensure     = "Present"
                Credential = $GlobalAdmin
            }

            SCComplianceSearch DemoSearchSPO
            {
                Case                                  = "Integration Case"
                HoldNames                             = @()
                Name                                  = "Integration Compliance Search - SPO"
                Ensure                                = "Present"
                Language                              = "iv"
                Credential                            = $GlobalAdmin
                AllowNotFoundExchangeLocationsEnabled = $False
                SharePointLocation                    = @("All")
            }

            SCComplianceSearch DemoSearchEXO
            {
                Case                                  = "Integration Case"
                HoldNames                             = @()
                Name                                  = "Integration Compliance Search - EXO"
                Ensure                                = "Present"
                Language                              = "iv"
                Credential                            = $GlobalAdmin
                AllowNotFoundExchangeLocationsEnabled = $False
                ExchangeLocation                      = @("All")
                PublicFolderLocation                  = @("All")
            }

            SCComplianceSearchAction DemoSearchActionRetention
            {
                IncludeSharePointDocumentVersions = $False
                Action                            = "Retention"
                SearchName                        = "Integration Compliance Search - EXO"
                Credential                        = $GlobalAdmin
                IncludeCredential                 = $False
                RetryOnError                      = $False
                ActionScope                       = "IndexedItemsOnly"
                Ensure                            = "Present"
                EnableDedupe                      = $False
            }

            SCComplianceSearchAction DemoSearchActionPurge
            {
                Action            = "Purge"
                SearchName        = "Integration Compliance Search - EXO"
                Credential        = $GlobalAdmin
                IncludeCredential = $False
                RetryOnError      = $False
                Ensure            = "Present"
            }

            SCComplianceCase DemoCase
            {
                Name        = "Integration Case"
                Description = "This Case is generated by the Integration Tests"
                Status      = "Active"
                Ensure      = "Present"
                Credential  = $GlobalAdmin
            }

            SCCaseHoldPolicy DemoCaseHoldPolicy
            {
                Case                 = "Integration Case"
                ExchangeLocation     = @("John.Smith@$Domain")
                Name                 = "Integration Hold"
                PublicFolderLocation = "All"
                Comment              = "This is a test for integration"
                Ensure               = "Present"
                Enabled              = $True
                Credential           = $GlobalAdmin
            }

            SCCaseHoldRule DemoHoldRule
            {
                Name              = "Integration Hold"
                Policy            = "Integration Hold"
                Comment           = "This is a demo rule"
                Disabled          = $false
                ContentMatchQuery = "filename:2016 budget filetype:xlsx"
                Ensure            = "Present"
                Credential        = $GlobalAdmin
            }

            SCComplianceTag DemoRule
            {
                Name              = "DemoTag"
                Comment           = "This is a Demo Tag"
                RetentionAction   = "Keep"
                RetentionDuration = "1025"
                RetentionType     = "ModificationAgeInDays"
                FilePlanProperty  = MSFT_SCFilePlanProperty
                {
                    FilePlanPropertyDepartment = "Human resources"
                    FilePlanPropertyCategory   = "Accounts receivable"
                }
                Ensure            = "Present"
                Credential        = $GlobalAdmin
            }

            SCDLPCompliancePolicy DLPPolicy
            {
                Name               = "MyDLPPolicy"
                Comment            = "Test Policy"
                Priority           = 0
                SharePointLocation = "https://$($Domain.Split('.')[0]).sharepoint.com/sites/Classic"
                Ensure             = "Present"
                Credential         = $GlobalAdmin
            }

            SCDLPComplianceRule DLPRule
            {
                Name        = "MyDLPRule"
                Policy      = "MyDLPPolicy"
                BlockAccess = $True
                Ensure      = "Present"
                Credential  = $GlobalAdmin
            }

            SCFilePlanPropertyAuthority FilePlanPropertyAuthority
            {
                Name       = "My Authority"
                Ensure     = "Present"
                Credential = $GlobalAdmin
            }

            SCFilePlanPropertyCategory FilePlanPropertyCategory
            {
                Name       = "My Category"
                Ensure     = "Present"
                Credential = $GlobalAdmin
            }

            SCFilePlanPropertyCitation IntegrationCitation
            {
                Name                 = "Integration Citation"
                CitationURL          = "https://contoso.com"
                CitationJurisdiction = "Federal"
                Ensure               = "Present"
                Credential           = $GlobalAdmin
            }

            SCFilePlanPropertyDepartment FilePlanPropertyDepartment
            {
                Name       = "Demo Department"
                Ensure     = "Present"
                Credential = $GlobalAdmin
            }

            SCFilePlanPropertyReferenceId FilePlanPropertyReferenceId
            {
                Name       = "My Reference ID"
                Ensure     = "Present"
                Credential = $GlobalAdmin
            }

            SCRetentionCompliancePolicy RCPolicy
            {
                Name                 = "MyRCPolicy"
                Comment              = "Test Policy"
                RestrictiveRetention = $False;
                Enabled              = $True
                Ensure               = "Present"
                Credential           = $GlobalAdmin
            }

            SCRetentionComplianceRule RCRule
            {
                Name                         = "DemoRule2"
                Policy                       = "MyRCPolicy"
                Comment                      = "This is a Demo Rule"
                RetentionComplianceAction    = "Keep"
                RetentionDuration            = "Unlimited"
                RetentionDurationDisplayHint = "Days"
                Credential                   = $GlobalAdmin
                Ensure                       = "Present"
            }

            SCRetentionEventType SCEventType
            {
                Comment    = "DSC Event Type description."
                Name       = "DSCEventType"
                Ensure     = "Present"
                Credential = $GlobalAdmin

            }

            SCSecurityFilter SCSecFilter
            {
                Action                = "All"
                Description           = "My Desc"
                FilterName            = "MYFILTER"
                Filters               = @("Mailbox_CountryCode -eq '124'")
                Region                = "FRA"
                Users                 = @("John.Smith@$Domain")
                Ensure                = "Present"
                Credential            = $GlobalAdmin
            }
            #endregion

            #region SPO
            SPOSearchManagedProperty ManagedProp1
            {
                Name       = "Gilles"
                type       = "Text"
                Credential = $GlobalAdmin
                Ensure     = "Present"
            }

            SPOSite ClassicSite
            {
                Title      = "Classic Site"
                Url        = "https://$($Domain.Split('.')[0]).sharepoint.com/sites/Classic"
                Owner      = $GlobalAdmin.UserName
                Template   = "STS#0"
                TimeZoneID = 13
                Credential = $GlobalAdmin
                Ensure     = "Present"
            }

            SPOSite ModernSite
            {
                Title      = "Modern Site"
                Url        = "https://$($Domain.Split('.')[0]).sharepoint.com/sites/Modern"
                Owner      = $GlobalAdmin.UserName
                Template   = "STS#3"
                TimeZoneID = 13
                Credential = $GlobalAdmin
                Ensure     = "Present"
            }

            SPOSite TestWithoutTemplate
            {
                Title                                       = "No Templates"
                Url                                         = "https://$($Domain.Split('.')[0]).sharepoint.com/sites/NoTemplates"
                Owner                                       = $GlobalAdmin.UserName
                TimeZoneID                                  = 13
                AllowSelfServiceUpgrade                     = $True
                AnonymousLinkExpirationInDays               = 0
                CommentsOnSitePagesDisabled                 = $False
                DefaultLinkPermission                       = "None"
                DefaultSharingLinkType                      = "None"
                DenyAddAndCustomizePages                    = $True
                DisableAppViews                             = "NotDisabled"
                DisableCompanyWideSharingLinks              = "NotDisabled"
                DisableFlows                                = $False
                LocaleId                                    = 1033
                OverrideTenantAnonymousLinkExpirationPolicy = $False
                ShowPeoplePickerSuggestionsForGuestUsers    = $False
                SocialBarOnSitePagesDisabled                = $False
                StorageMaximumLevel                         = 26214400
                StorageWarningLevel                         = 25574400
                Ensure                                      = "Present"
                Credential                                  = $GlobalAdmin
            }

            SPOPropertyBag MyKey
            {
                Url        = "https://$($Domain.Split('.')[0]).sharepoint.com/sites/Modern"
                Key        = "MyKey"
                Value      = "MyValue#3"
                Ensure     = "Present"
                Credential = $GlobalAdmin
            }

            SPOSearchResultSource SearchMP
            {
                Name        = "MyResultSource"
                Description = "Description of item"
                Protocol    = "Local"
                type        = "SharePoint"
                Ensure      = "Present"
                Credential  = $GlobalAdmin
            }

            SPOSiteAuditSettings MyStorageEntity
            {
                Url        = "https://$($Domain.Split('.')[0]).sharepoint.com/sites/Classic"
                AuditFlags = "All"
                Credential = $GlobalAdmin
            }

            SPOSiteGroup TestSiteGroup
            {
                Url              = "https://$($Domain.Split('.')[0]).sharepoint.com/sites/Modern"
                Identity         = "TestSiteGroup"
                PermissionLevels = @("Edit", "Read")
                Ensure           = "Present"
                Credential       = $GlobalAdmin
            }
            SPOTheme SPTheme01
            {
                Name       = "Integration Palette"
                Palette    = @(MSFT_SPOThemePaletteProperty
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
                Credential = $GlobalAdmin
            }

            SPOTenantCdnEnabled CDN
            {
                Enable     = $True
                CdnType    = "Public"
                Ensure     = "Present"
                Credential = $GlobalAdmin
            }

            SPOOrgAssetsLibrary OrgAssets
            {
                LibraryUrl = "https://$($Domain.Split('.')[0]).sharepoint.com/sites/Modern/Shared Documents"
                CdnType    = "Public"
                Ensure     = "Present"
                Credential = $GlobalAdmin
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
                    Credential = $GlobalAdmin
                    Ensure             = "Present"
                }
            }#>
            #endregion
        }

        #region Teams
        TeamsUpgradeConfiguration UpgradeConfig
        {
            IsSingleInstance = "Yes"
            DownloadTeams    = $True
            SfBMeetingJoinUx = "NativeLimitedClient"
            Credential       = $GlobalAdmin
        }

        TeamsMeetingBroadcastPolicy IntegrationBroadcastPolicy
        {
            AllowBroadcastScheduling        = $True
            AllowBroadcastTranscription     = $False
            BroadcastAttendeeVisibilityMode = "EveryoneInCompany"
            BroadcastRecordingMode          = "AlwaysEnabled"
            Identity                        = "IntegrationPolicy"
            Ensure                          = "Present"
            Credential                      = $GlobalAdmin
        }

        TeamsClientConfiguration TeamsClientConfiguration
        {
            AllowBox                         = $True
            AllowDropBox                     = $True
            AllowEmailIntoChannel            = $True
            AllowGoogleDrive                 = $True
            AllowGuestUser                   = $True
            AllowOrganizationTab             = $True
            AllowResourceAccountSendMessage  = $True
            AllowScopedPeopleSearchandAccess = $False
            AllowShareFile                   = $True
            AllowSkypeBusinessInterop        = $True
            ContentPin                       = "RequiredOutsideScheduleMeeting"
            Identity                         = "Global"
            ResourceAccountContentAccess     = "NoAccess"
            RestrictedSenderList             = $null
            Credential                       = $GlobalAdmin
        }

        TeamsChannelsPolicy IntegrationChannelPolicy
        {
            AllowChannelSharingToExternalUser             = $True;
            AllowOrgWideTeamCreation                      = $True;
            AllowPrivateChannelCreation                   = $True;
            AllowSharedChannelCreation                    = $True;
            AllowUserToParticipateInExternalSharedChannel = $True;
            Identity                                      = "Integration Channel Policy"
            Ensure                                        = "Present"
            Credential                                    = $GlobalAdmin
        }

        TeamsEmergencyCallingPolicy EmergencyCallingPolicy
        {
            Description               = "Integration Test"
            Identity                  = "Integration Emergency Calling Policy"
            NotificationDialOutNumber = "12312345678"
            NotificationGroup         = $GlobalAdmin.UserName
            NotificationMode          = "NotificationOnly"
            Ensure                    = "Present"
            Credential                = $GlobalAdmin
        }

        TeamsMeetingBroadcastConfiguration MeetingBroadcastConfiguration
        {
            Identity                            = 'Global'
            AllowSdnProviderForBroadcastMeeting = $True
            SupportURL                          = "https://support.office.com/home/contact"
            SdnProviderName                     = "hive"
            SdnLicenseId                        = "5c12d0-d52950-e03e66-92b587"
            SdnApiTemplateUrl                   = "https://api.hivestreaming.com/v1/eventadmin?partner_token={0}"
            Credential                          = $GlobalAdmin
        }

        TeamsEmergencyCallRoutingPolicy EmergencyCallRoutingPolicyExample
        {
            AllowEnhancedEmergencyServices = $False
            Description                    = "Description"
            EmergencyNumbers               = @(
                MSFT_TeamsEmergencyNumber
                {
                    EmergencyDialString = '123456'
                    EmergencyDialMask   = '123'
                    OnlinePSTNUsage     = ''
                }
            )
            Identity                       = "Integration Test"
            Ensure                         = "Present"
            Credential                     = $GlobalAdmin
        }

        TeamsTeam TeamAlpha
        {
            DisplayName          = "Alpha Team"
            AllowAddRemoveApps   = $true
            AllowChannelMentions = $false
            Ensure               = "Present"
            Credential           = $GlobalAdmin
        }

        TeamsChannel ChannelAlpha1
        {
            DisplayName = "Channel Alpha"
            Description = "Test Channel"
            TeamName    = "Alpha Team"
            DependsOn   = "[TeamsTeam]TeamAlpha"
            Ensure      = "Present"
            Credential  = $GlobalAdmin
        }

        TeamsUser MemberJohn
        {
            TeamName   = "Alpha Team"
            User       = "John.Smith@$Domain"
            DependsOn  = @("[AADUSer]JohnSmith", "[TeamsTeam]TeamAlpha")
            Ensure     = "Present"
            Credential = $GlobalAdmin
        }

        TeamsMeetingConfiguration MeetingConfiguration
        {
            ClientAppSharingPort        = 50040
            ClientAppSharingPortRange   = 20
            ClientAudioPort             = 50000
            ClientAudioPortRange        = 21
            ClientMediaPortRangeEnabled = $True
            ClientVideoPort             = 50020
            ClientVideoPortRange        = 20
            CustomFooterText            = "This is some custom footer text"
            DisableAnonymousJoin        = $False
            EnableQoS                   = $False
            HelpURL                     = "https://github.com/Microsoft/Microsoft365DSC/Help"
            Identity                    = "Global"
            LegalURL                    = "https://github.com/Microsoft/Microsoft365DSC/Legal"
            LogoURL                     = "https://github.com/Microsoft/Microsoft365DSC/Logo.png"
            Credential                  = $GlobalAdmin
        }

        TeamsFederationConfiguration FederationConfiguration
        {
            AllowFederatedUsers       = $True
            AllowPublicUsers          = $True
            AllowTeamsConsumer        = $False
            AllowTeamsConsumerInbound = $False
            Identity                  = "Global"
            Credential                = $GlobalAdmin
        }

        TeamsGuestCallingConfiguration GuestCallingConfig
        {
            Identity            = "Global"
            AllowPrivateCalling = $True
            Credential          = $GlobalAdmin
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
            Ensure                        = "Present"
            Credential                    = $GlobalAdmin
        }

        TeamsTenantDialPlan TestTenantDialPlan
        {
            Description           = 'This is a demo dial plan'
            Identity              = "DemoPlan"
            NormalizationRules    = MSFT_TeamsVoiceNormalizationRule
            {
                Pattern             = '^00(\d+)$'
                Description         = 'LB International Dialing Rule'
                Identity            = 'LB Intl Dialing'
                Translation         = '+$1'
                Priority            = 0
                IsInternalExtension = $False
            }
            OptimizeDeviceDialing = $true
            SimpleName            = "DemoPlan"
            Ensure                = "Present"
            Credential            = $GlobalAdmin
        }
        #endregion

        #region GCC
        if ($Environment -ne 'GCC')
        {
            <#
            SCSensitivityLabel SCSenLabel
            {
                Name           = "Demo Label"
                Comment        = "Demo label comment"
                ToolTip        = "Demo tool tip"
                DisplayName    = "Demo label"
                LocaleSettings = @(
                    MSFT_SCLabelLocaleSettings
                    {
                        LocaleKey = "DisplayName"
                        Settings = @(
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
                        Settings = @(
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
                Credential = $GlobalAdmin
                Ensure             = "Present"
            }#>
        }
        #endregion
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
