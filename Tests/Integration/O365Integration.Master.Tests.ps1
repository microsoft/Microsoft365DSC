param
(
    [Parameter()]
    [System.String]
    $GlobalAdminUser,

    [Parameter()]
    [System.String]
    $GlobalAdminPassword,

    [Parameter(Mandatory=$true)]
    [System.String]
    $Domain
)

Configuration Master
{
    param
    (
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdmin,

        [Parameter(Mandatory=$true)]
        [System.String]
        $Domain
    )

    Import-DscResource -ModuleName Office365DSC

    Node Localhost
    {
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

        EXOCASMailboxPlan CASMailboxPlan
        {
            ActiveSyncEnabled    = $True;
            OwaMailboxPolicy     = "OwaMailboxPolicy-Default";
            GlobalAdminAccount   = $GlobalAdmin;
            PopEnabled           = $True;
            Identity             = "ExchangeOnlineEssentials-759100cd-4fb6-46db-80ae-bb0ef4bd92b0";
            Ensure               = "Present";
            ImapEnabled          = $True;
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
            DisplayName          = "Office365DSC Core Team"
            MailNickName         = "O365DSCCore"
            ManagedBy            = "admin@$Domain"
            Description          = "Group for all the Core Team members"
            Members              = @("John.Smith@$Domain")
            GlobalAdminAccount   = $GlobalAdmin
            Ensure               = "Present"
            DependsOn            = "[O365User]JohnSmith"
        }

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

        SCComplianceSearchAction DemoSearchActionExport
        {
            IncludeSharePointDocumentVersions   = $False;
            Action                              = "Export";
            SearchName                          = "Integration Compliance Search - EXO";
            GlobalAdminAccount                  = $GlobalAdmin;
            IncludeCredential                   = $False;
            RetryOnError                        = $False;
            ActionScope                         = "IndexedItemsOnly";
            Ensure                              = "Present";
            EnableDedupe                        = $False;
        }

        SCComplianceSearchAction DemoSearchActionRetention
        {
            IncludeSharePointDocumentVersions   = $False;
            Action                              = "Retention";
            SearchName                          = "Integration Compliance Search - EXO";
            GlobalAdminAccount                  = $GlobalAdmin;
            IncludeCredential                   = $False;
            RetryOnError                        = $False;
            ActionScope                         = "IndexedItemsOnly";
            Ensure                              = "Present";
            EnableDedupe                        = $False;
        }

        SCComplianceSearchAction DemoSearchActionPurge
        {
            Action                              = "Purge";
            SearchName                          = "Integration Compliance Search - EXO";
            GlobalAdminAccount                  = $GlobalAdmin;
            IncludeCredential                   = $False;
            RetryOnError                        = $False;
            Ensure                              = "Present";
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
            ExchangeLocation     = "SharePointConference2019@o365dsc.onmicrosoft.com";
            Name                 = "Integration Hold";
            PublicFolderLocation = "All";
            Comment              = "This is a test for integration";
            Ensure               = "Present";
            Enabled              = $True;
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
            FilePlanProperty   = MSFT_SCFilePlanProperty{
                FilePlanPropertyDepartment = "Human resources"
                FilePlanPropertyCategory = "Accounts receivable"
            }
            Ensure             = "Present"
            GlobalAdminAccount = $GlobalAdmin
        }

        SCDLPCompliancePolicy DLPPolicy
        {
            Name               = "MyDLPPolicy"
            Comment            = "Test Policy"
            Priority           = 1
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
            GlobalAdminAccount                  = $GlobalAdmin;
            ContentContainsSensitiveInformation = MSFT_SCDLPSensitiveInformation
                                                  {
                                                      name = "U.S. Social Security Number (SSN)"
                                                  };
        }

        SCRetentionCompliancePolicy RCPolicy
        {
            Name               = "MyRCPolicy"
            Comment            = "Test Policy"
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
            Reviewers          = @("admin@$Domain")
            Ensure             = "Present"
            GlobalAdminAccount = $GlobalAdmin
        }

        SCSupervisoryReviewRule SRRule
        {
            Name               = "DemoRule"
            Condition          = "(Reviewee:adminnonmfa@$Domain)"
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
            Title                = "Classic Site"
            Url                  = "https://$($Domain.Split('.')[0]).sharepoint.com/sites/Classic"
            Owner                = "adminnonMFA@$Domain"
            Template             = "STS#0"
            GlobalAdminAccount   = $GlobalAdmin
            Ensure               = "Present"
        }

        SPOSite ModernSite
        {
            Title                = "Modern Site"
            Url                  = "https://$($Domain.Split('.')[0]).sharepoint.com/sites/Modern"
            Owner                = "adminnonmfa@$Domain"
            Template             = "STS#3"
            GlobalAdminAccount   = $GlobalAdmin
            Ensure               = "Present"
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

        SPOTheme SPTheme01
        {
                GlobalAdminAccount  = $GlobalAdmin
                Name                = "Integration Palette"
                Palette             = @(MSFT_SPOThemePaletteProperty{
                                            Property = "themePrimary"
                                            Value = "#0078d4"
                                      }
                                      MSFT_SPOThemePaletteProperty{
                                          Property = "themeLighterAlt"
                                          Value = "#eff6fc"
                                      }
                )
        }

        <#SPOStorageEntity SiteEntity1
        {
            Key                = "SiteEntity1"
            Value              = "Modern Value"
            Description        = "Entity for Modern Site"
            EntityScope        = "Site"
            SiteUrl            = "https://o365dsc.sharepoint.com/sites/Modern"
            GlobalAdminAccount = $GlobalAdmin
            Ensure             = "Present"
        }

        SPOStorageEntity TenantEntity1
        {
            Key                = "TenantEntity1"
            Value              = "Tenant Value"
            Description        = "Entity for Tenant"
            EntityScope        = "Tenant"
            SiteUrl            = "https://o365dsc-admin.sharepoint.com/"
            GlobalAdminAccount = $GlobalAdmin
            Ensure             = "Present"
        }#>

        <#SPOTenantCDNPolicy PublicCDNPolicies
        {
            IncludeFileExtensions                = @('.jpg', '.png');
            GlobalAdminAccount                   = $GlobalAdmin
            CDNType                              = "Public";
            ExcludeRestrictedSiteClassifications = @();
        }

        SPOTenantCDNPolicy PrivateCDNPolicies
        {
            IncludeFileExtensions                = @('.gif');
            GlobalAdminAccount                   = $GlobalAdmin
            CDNType                              = "Private";
            ExcludeRestrictedSiteClassifications = @();
        }#>

        SPOUserProfileProperty SPOUserProfileProperty
        {
            UserName           = "adminnonmfa@$Domain"
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
            DependsON          = @("[O365User]JohnSmith","[TeamsTeam]TeamAlpha")
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
Master -ConfigurationData $ConfigurationData -GlobalAdmin $credential -Domain $Domain
Start-DscConfiguration Master -Wait -Force -Verbose
