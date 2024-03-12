    param
    (
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Configuration Master
    {
        param
        (
            [Parameter(Mandatory = $true)]
            [System.Management.Automation.PSCredential]
            $Credscredential
        )

        Import-DscResource -ModuleName Microsoft365DSC
        $Domain = $Credscredential.Username.Split('@')[1]
        Node Localhost
        {
                EXOAcceptedDomain 'O365DSCDomain'
                {
                    Identity     = $Domain
                    DomainType   = "Authoritative"
                    OutboundOnly = $true # Updated Property
                    Ensure       = "Present"
                    Credential   = $Credscredential
                }
                EXOActiveSyncDeviceAccessRule 'ConfigureActiveSyncDeviceAccessRule'
                {
                    Identity             = "ContosoPhone(DeviceOS)"
                    Characteristic       = "DeviceModel" # Updated Property
                    QueryString          = "iOS 6.1 10B145"
                    AccessLevel          = "Allow"
                    Ensure               = "Present"
                    Credential           = $Credscredential
                }
                EXOAddressBookPolicy 'ConfigureAddressBookPolicy'
                {
                    Name                 = "All Fabrikam ABP"
                    AddressLists         = "\All Users"
                    RoomList             = "\All Rooms"
                    OfflineAddressBook   = "\Default Offline Address Book"
                    GlobalAddressList    = "\Default Global Address List"
                    Ensure               = "Present"
                    Credential           = $Credscredential
                }
                EXOAddressList 'HRUsersAddressList'
                {
                    Name                       = "HR Users"
                    ConditionalCompany         = "Contoso"
                    ConditionalDepartment      = "HR2" # Updated Property
                    ConditionalStateOrProvince = "US"
                    IncludedRecipients         = "AllRecipients"
                    Ensure                     = "Present"
                    Credential                 = $Credscredential
                }
                EXOAntiPhishPolicy 'ConfigureAntiphishPolicy'
                {
                    Identity                              = "Our Rule"
                    MakeDefault                           = $null
                    PhishThresholdLevel                   = 2 # Updated Property
                    EnableTargetedDomainsProtection       = $null
                    Enabled                               = $null
                    TargetedDomainsToProtect              = $null
                    EnableSimilarUsersSafetyTips          = $null
                    ExcludedDomains                       = $null
                    TargetedDomainActionRecipients        = $null
                    EnableMailboxIntelligence             = $null
                    EnableSimilarDomainsSafetyTips        = $null
                    AdminDisplayName                      = ""
                    AuthenticationFailAction              = "MoveToJmf"
                    TargetedUserProtectionAction          = "NoAction"
                    TargetedUsersToProtect                = $null
                    EnableTargetedUserProtection          = $null
                    ExcludedSenders                       = $null
                    EnableOrganizationDomainsProtection   = $null
                    EnableUnusualCharactersSafetyTips     = $null
                    TargetedUserActionRecipients          = $null
                    Ensure                                = "Present"
                    Credential                            = $Credscredential
                }
                EXOAntiPhishRule 'ConfigureAntiPhishRule'
                {
                    Identity                  = "Test Rule"
                    Comments                  = "This is an updated comment." # Updated Property
                    AntiPhishPolicy           = "Our Rule"
                    Enabled                   = $True
                    SentToMemberOf            = @("executives@$Domain")
                    Ensure                    = "Present"
                    Credential                = $Credscredential
                }
                EXOApplicationAccessPolicy 'ConfigureApplicationAccessPolicy'
                {
                    Identity             = "Integration Policy"
                    AccessRight          = "DenyAccess"
                    AppID                = '3dbc2ae1-7198-45ed-9f9f-d86ba3ec35b5'
                    PolicyScopeGroupId   = "IntegrationMailEnabled@$Domain"
                    Description          = "Engineering Group Policy Updated" # Updated Property
                    Ensure               = "Present"
                    Credential           = $Credscredential
                }
                EXOAtpPolicyForO365 'ConfigureAntiPhishPolicy'
                {
                    IsSingleInstance        = "Yes"
                    EnableATPForSPOTeamsODB = $true
                    Ensure                  = "Present"
                    Credential              = $Credscredential
                }
                EXOAuthenticationPolicy 'ConfigureAuthenticationPolicy'
                {
                    Identity                            = "Block Basic Auth"
                    AllowBasicAuthActiveSync            = $False
                    AllowBasicAuthAutodiscover          = $False
                    AllowBasicAuthImap                  = $False
                    AllowBasicAuthMapi                  = $True # Updated Property
                    AllowBasicAuthOfflineAddressBook    = $False
                    AllowBasicAuthOutlookService        = $False
                    AllowBasicAuthPop                   = $False
                    AllowBasicAuthPowerShell            = $False
                    AllowBasicAuthReportingWebServices  = $False
                    AllowBasicAuthRpc                   = $False
                    AllowBasicAuthSmtp                  = $False
                    AllowBasicAuthWebServices           = $False
                    Ensure                              = "Present"
                    Credential                          = $Credscredential
                }
                EXOAvailabilityAddressSpace 'ConfigureAvailabilityAddressSpace'
                {
                    Identity              = 'Contoso.com'
                    AccessMethod          = 'OrgWideFBToken'
                    ForestName            = 'example.contoso.com'
                    TargetServiceEpr      = 'https://contoso.com/autodiscover/autodiscover.xml'
                    TargetTenantId        = 'contoso.onmicrosoft.com' # Updated Property
                    Ensure                = 'Present'
                    Credential            = $Credscredential
                }
                EXOAvailabilityConfig 'ConfigureAvailabilityConfig'
                {
                    OrgWideAccount       = "alexW@$Domain" # Updated Property
                    Ensure               = "Present"
                    Credential           = $Credscredential
                }
                EXOCalendarProcessing 'CalendarProcessing'
                {
                    AddAdditionalResponse                = $False;
                    AddNewRequestsTentatively            = $True;
                    AddOrganizerToSubject                = $False; # Updated Property
                    AllBookInPolicy                      = $True;
                    AllowConflicts                       = $False;
                    AllowRecurringMeetings               = $True;
                    AllRequestInPolicy                   = $False;
                    AllRequestOutOfPolicy                = $False;
                    AutomateProcessing                   = "AutoUpdate";
                    BookingType                          = "Standard";
                    BookingWindowInDays                  = 180;
                    BookInPolicy                         = @();
                    ConflictPercentageAllowed            = 0;
                    Credential                           = $credsCredential;
                    DeleteAttachments                    = $True;
                    DeleteComments                       = $True;
                    DeleteNonCalendarItems               = $True;
                    DeleteSubject                        = $True;
                    EnableAutoRelease                    = $False;
                    EnableResponseDetails                = $True;
                    EnforceCapacity                      = $False;
                    EnforceSchedulingHorizon             = $True;
                    Ensure                               = "Present";
                    ForwardRequestsToDelegates           = $True;
                    Identity                             = "admin@$Domain";
                    MaximumConflictInstances             = 0;
                    MaximumDurationInMinutes             = 1440;
                    MinimumDurationInMinutes             = 0;
                    OrganizerInfo                        = $True;
                    PostReservationMaxClaimTimeInMinutes = 10;
                    ProcessExternalMeetingMessages       = $False;
                    RemoveCanceledMeetings               = $False;
                    RemoveForwardedMeetingNotifications  = $False;
                    RemoveOldMeetingMessages             = $False;
                    RemovePrivateProperty                = $True;
                    RequestInPolicy                      = @("AlexW@$Domain");
                    ResourceDelegates                    = @();
                    ScheduleOnlyDuringWorkHours          = $False;
                    TentativePendingApproval             = $True;
                }
                EXOCASMailboxPlan 'ConfigureCASMailboxPlan'
                {
                    ActiveSyncEnabled = $True
                    OwaMailboxPolicy  = "OwaMailboxPolicy-Default"
                    PopEnabled        = $False # Updated Property
                    Identity          = 'ExchangeOnlineEnterprise'
                    ImapEnabled       = $True
                    Ensure            = "Present"
                    Credential        = $Credscredential
                }
                EXOCASMailboxSettings 'AdeleVCasMailboxSettings'
                {
                    ActiveSyncAllowedDeviceIDs              = @()
                    ActiveSyncBlockedDeviceIDs              = @()
                    ActiveSyncDebugLogging                  = $False
                    ActiveSyncEnabled                       = $True
                    ActiveSyncMailboxPolicy                 = 'Default'
                    ActiveSyncSuppressReadReceipt           = $False
                    EwsEnabled                              = $True
                    Identity                                = "admin@$Domain"
                    ImapEnabled                             = $True # Updated Property
                    ImapForceICalForCalendarRetrievalOption = $False
                    ImapMessagesRetrievalMimeFormat         = 'BestBodyFormat'
                    ImapSuppressReadReceipt                 = $False
                    ImapUseProtocolDefaults                 = $True
                    MacOutlookEnabled                       = $True
                    MAPIEnabled                             = $True
                    OutlookMobileEnabled                    = $True
                    OWAEnabled                              = $True
                    OWAforDevicesEnabled                    = $True
                    OwaMailboxPolicy                        = 'OwaMailboxPolicy-Integration'
                    PopEnabled                              = $False
                    PopForceICalForCalendarRetrievalOption  = $True
                    PopMessagesRetrievalMimeFormat          = 'BestBodyFormat'
                    PopSuppressReadReceipt                  = $False
                    PopUseProtocolDefaults                  = $True
                    PublicFolderClientAccess                = $False
                    ShowGalAsDefaultView                    = $True
                    UniversalOutlookEnabled                 = $True
                    Ensure                                  = 'Present'
                    Credential                              = $Credscredential
                }
                EXOClientAccessRule 'ConfigureClientAccessRule'
                {
                    Action                               = "AllowAccess"
                    UserRecipientFilter                  = $null
                    ExceptAnyOfAuthenticationTypes       = @()
                    ExceptUsernameMatchesAnyOfPatterns   = @()
                    AnyOfAuthenticationTypes             = @()
                    UsernameMatchesAnyOfPatterns         = @()
                    Identity                             = "Always Allow Remote PowerShell"
                    Priority                             = 1
                    AnyOfProtocols                       = @("RemotePowerShell")
                    Enabled                              = $False # Updated Property
                    ExceptAnyOfProtocols                 = @()
                    ExceptAnyOfClientIPAddressesOrRanges = @()
                    AnyOfClientIPAddressesOrRanges       = @()
                    Ensure                               = "Present"
                    Credential                           = $Credscredential
                }
                EXODataClassification 'ConfigureDataClassification'
                {
                    Description          = "Detects formatted and unformatted Canadian social insurance number.";
                    Ensure               = "Present";
                    Identity             = "a2f29c85-ecb8-4514-a610-364790c0773e";
                    IsDefault            = $True;
                    Locale               = "en-US";
                    Name                 = "Canada Social Insurance Number";
                    Credential           = $Credscredential
                }
                EXODistributionGroup 'DemoDG'
                {
                    Alias                              = "demodg";
                    BccBlocked                         = $True; # Updated Property
                    BypassNestedModerationEnabled      = $False;
                    DisplayName                        = "My Demo DG";
                    Ensure                             = "Present";
                    HiddenGroupMembershipEnabled       = $True;
                    ManagedBy                          = @("adeleV@$Domain");
                    MemberDepartRestriction            = "Open";
                    MemberJoinRestriction              = "Closed";
                    ModeratedBy                        = @("alexW@$Domain");
                    ModerationEnabled                  = $False;
                    Identity                           = "DemoDG";
                    Name                               = "DemoDG";
                    PrimarySmtpAddress                 = "demodg@$Domain";
                    RequireSenderAuthenticationEnabled = $True;
                    SendModerationNotifications        = "Always";
                    Credential                         = $Credscredential
                }
                EXODkimSigningConfig 'ConfigureDKIMSigning'
                {
                    KeySize                = 1024
                    Identity               = $Domain
                    HeaderCanonicalization = "Relaxed"
                    Enabled                = $False # Updated Property
                    BodyCanonicalization   = "Relaxed"
                    AdminDisplayName       = ""
                    Ensure                 = "Present"
                    Credential             = $Credscredential
                }
                EXOEmailAddressPolicy 'ConfigureEmailAddressPolicy'
                {
                    Name                              = "Integration Policy"
                    EnabledEmailAddressTemplates      = @("SMTP:@$Domain")
                    EnabledPrimarySMTPAddressTemplate = "@$Domain"
                    ManagedByFilter                   = "Department -eq 'Sales'" # Updated Property
                    Priority                          = 1
                    Ensure                            = "Present"
                    Credential                        = $Credscredential
                }
                EXOGlobalAddressList 'ConfigureGlobalAddressList'
                {
                    Name                         = "Contoso Human Resources in Washington"
                    ConditionalCompany           = "Contoso"
                    ConditionalDepartment        = "Finances" # Updated Property
                    ConditionalStateOrProvince   = "Washington"
                    Ensure                       = "Present"
                    Credential                   = $Credscredential
                }
                EXOGroupSettings 'TestGroup'
                {
                    DisplayName                            = "All Company";
                    AccessType                             = "Public";
                    AlwaysSubscribeMembersToCalendarEvents = $False;
                    AuditLogAgeLimit                       = "90.00:00:00";
                    AutoSubscribeNewMembers                = $False;
                    CalendarMemberReadOnly                 = $False;
                    ConnectorsEnabled                      = $False; # Updated Property
                    Credential                             = $Credscredential;
                    HiddenFromAddressListsEnabled          = $True;
                    HiddenFromExchangeClientsEnabled       = $True;
                    InformationBarrierMode                 = "Open";
                    Language                               = "en-US";
                    MaxReceiveSize                         = "36 MB (37,748,736 bytes)";
                    MaxSendSize                            = "35 MB (36,700,160 bytes)";
                    ModerationEnabled                      = $False;
                    Notes                                  = "My Notes";
                    PrimarySmtpAddress                     = "TestGroup@$Domain";
                    RequireSenderAuthenticationEnabled     = $True;
                    SubscriptionEnabled                    = $False;
                }
                EXOHostedConnectionFilterPolicy 'ConfigureHostedConnectionFilterPolicy'
                {
                    Identity         = "Default"
                    AdminDisplayName = ""
                    EnableSafeList   = $True # Updated Property
                    IPAllowList      = @()
                    IPBlockList      = @()
                    MakeDefault      = $True
                    Ensure           = "Present"
                    Credential       = $Credscredential
                }
                EXOHostedContentFilterPolicy 'ConfigureHostedContentFilterPolicy'
                {
                    Identity                             = "Integration CFP"
                    AddXHeaderValue                      = ""
                    AdminDisplayName                     = ""
                    BulkSpamAction                       = "MoveToJmf"
                    BulkThreshold                        = 7
                    DownloadLink                         = $True # Updated Property
                    EnableLanguageBlockList              = $False
                    EnableRegionBlockList                = $False
                    HighConfidencePhishAction            = "Quarantine"
                    HighConfidenceSpamAction             = "MoveToJmf"
                    IncreaseScoreWithBizOrInfoUrls       = "Off"
                    IncreaseScoreWithImageLinks          = "Off"
                    IncreaseScoreWithNumericIps          = "Off"
                    IncreaseScoreWithRedirectToOtherPort = "Off"
                    InlineSafetyTipsEnabled              = $True
                    LanguageBlockList                    = @()
                    MakeDefault                          = $False
                    MarkAsSpamBulkMail                   = "On"
                    MarkAsSpamEmbedTagsInHtml            = "Off"
                    MarkAsSpamEmptyMessages              = "Off"
                    MarkAsSpamFormTagsInHtml             = "Off"
                    MarkAsSpamFramesInHtml               = "Off"
                    MarkAsSpamFromAddressAuthFail        = "Off"
                    MarkAsSpamJavaScriptInHtml           = "Off"
                    MarkAsSpamNdrBackscatter             = "Off"
                    MarkAsSpamObjectTagsInHtml           = "Off"
                    MarkAsSpamSensitiveWordList          = "Off"
                    MarkAsSpamSpfRecordHardFail          = "Off"
                    MarkAsSpamWebBugsInHtml              = "Off"
                    ModifySubjectValue                   = ""
                    PhishSpamAction                      = "MoveToJmf"
                    PhishZapEnabled                      = $True
                    QuarantineRetentionPeriod            = 15
                    RedirectToRecipients                 = @()
                    RegionBlockList                      = @()
                    SpamAction                           = "MoveToJmf"
                    SpamZapEnabled                       = $True
                    TestModeAction                       = "None"
                    TestModeBccToRecipients              = @()
                    Ensure                               = "Present"
                    Credential                           = $Credscredential
                }
                EXOHostedContentFilterRule 'ConfigureHostedContentFilterRule'
                {
                    Identity                  = "Integration CFR"
                    Comments                  = "Applies to all users, except when member of HR group"
                    Enabled                   = $False # Updated Property
                    ExceptIfSentToMemberOf    = "LegalTeam@$Domain"
                    RecipientDomainIs         = @('contoso.com')
                    HostedContentFilterPolicy = "Integration CFP"
                    Ensure                    = "Present"
                    Credential                = $Credscredential
                }
                EXOHostedOutboundSpamFilterPolicy 'HostedOutboundSpamFilterPolicy'
                {
                    Identity                                  = "Integration SFP"
                    ActionWhenThresholdReached                = "BlockUserForToday"
                    AdminDisplayName                          = ""
                    AutoForwardingMode                        = "Automatic"
                    BccSuspiciousOutboundAdditionalRecipients = @()
                    BccSuspiciousOutboundMail                 = $False
                    NotifyOutboundSpam                        = $False
                    NotifyOutboundSpamRecipients              = @()
                    RecipientLimitExternalPerHour             = 0
                    RecipientLimitInternalPerHour             = 1 # Updated Property
                    RecipientLimitPerDay                      = 0
                    Ensure                                    = "Present"
                    Credential                                = $Credscredential
                }
                EXOHostedOutboundSpamFilterRule 'ConfigureHostedOutboundSpamFilterRule'
                {
                    Identity                       = "Contoso Executives"
                    Comments                       = "Does not apply to Executives"
                    Enabled                        = $False # Updated Property
                    ExceptIfFrom                   = "AdeleV@$Domain"
                    FromMemberOf                   = "Executives@$Domain"
                    HostedOutboundSpamFilterPolicy = "Integration SFP"
                    Ensure                         = "Present"
                    Credential                     = $Credscredential
                }
                EXOInboundConnector 'ConfigureInboundConnector'
                {
                    Identity                     = "Integration Inbound Connector"
                    CloudServicesMailEnabled     = $False
                    Comment                      = "Inbound connector for Integration"
                    ConnectorSource              = "Default"
                    ConnectorType                = "Partner"
                    Enabled                      = $False # Updated Property
                    RequireTls                   = $True
                    SenderDomains                = "*.contoso.com"
                    TlsSenderCertificateName     = "contoso.com"
                    Ensure                       = "Present"
                    Credential                   = $Credscredential
                }
                EXOIntraOrganizationConnector 'ConfigureIntraOrganizationConnector'
                {
                    Identity             = "MainCloudConnector"
                    DiscoveryEndpoint    = "https://ExternalDiscovery.Contoso.com/"
                    TargetAddressDomains = "Cloud1.contoso.com","Cloud2.contoso.com"
                    Enabled              = $False # Updated Property
                    Ensure               = "Present"
                    Credential           = $Credscredential
                }
                EXOIRMConfiguration 'ConfigureIRMConfiguration'
                {
                    IsSingleInstance                           = 'Yes'
                    AutomaticServiceUpdateEnabled              = $True
                    AzureRMSLicensingEnabled                   = $True
                    DecryptAttachmentForEncryptOnly            = $True
                    EDiscoverySuperUserEnabled                 = $True
                    EnablePdfEncryption                        = $True
                    InternalLicensingEnabled                   = $True
                    JournalReportDecryptionEnabled             = $True
                    RejectIfRecipientHasNoRights               = $True
                    SearchEnabled                              = $True
                    SimplifiedClientAccessDoNotForwardDisabled = $True
                    SimplifiedClientAccessEnabled              = $True
                    SimplifiedClientAccessEncryptOnlyDisabled  = $True
                    TransportDecryptionSetting                 = 'Mandatory'
                    Ensure                                     = 'Present'
                    Credential                                 = $Credscredential
                }
                EXOJournalRule 'CreateJournalRule'
                {
                    Enabled              = $False # Updated Property
                    JournalEmailAddress  = "AdeleV@$Domain"
                    Name                 = "Send to Adele"
                    RuleScope            = "Global"
                    Ensure               = "Present"
                    Credential           = $Credscredential
                }
                EXOMailboxAutoReplyConfiguration 'EXOMailboxAutoReplyConfiguration'
                {
                    AutoDeclineFutureRequestsWhenOOF = $False;
                    AutoReplyState                   = "Disabled";
                    CreateOOFEvent                   = $False;
                    Credential                       = $Credscredential;
                    DeclineAllEventsForScheduledOOF  = $False;
                    DeclineEventsForScheduledOOF     = $False;
                    DeclineMeetingMessage            = "";
                    EndTime                          = "1/23/2024 3:00:00 PM";
                    Ensure                           = "Present";
                    ExternalAudience                 = "All";
                    ExternalMessage                  = (New-Guid).ToString(); # Updated Property
                    Identity                         = "AdeleV@$Domain";
                    InternalMessage                  = "";
                    OOFEventSubject                  = "";
                    StartTime                        = "1/22/2024 3:00:00 PM";
                }
                EXOMailboxCalendarFolder 'JohnCalendarFolder'
                {
                    Credential           = $credsCredential;
                    DetailLevel          = "AvailabilityOnly";
                    Ensure               = "Present";
                    Identity             = "AlexW@$Domain" + ":\Calendar";
                    PublishDateRangeFrom = "ThreeMonths";
                    PublishDateRangeTo   = "ThreeMonths";
                    PublishEnabled       = $True; # Updated Property
                    SearchableUrlEnabled = $False;
                }
                EXOMailboxPermission 'TestPermission'
                {
                    AccessRights         = @("FullAccess","ReadPermission");
                    Credential           = $credsCredential;
                    Deny                 = $True; # Updated Property
                    Ensure               = "Present";
                    Identity             = "AlexW@$Domain";
                    InheritanceType      = "All";
                    User                 = "NT AUTHORITY\SELF";
                }
                EXOMailboxPlan 'ConfigureMailboxPlan'
                {
                    Ensure                   = "Present";
                    Identity                 = "ExchangeOnlineEssentials";
                    IssueWarningQuota        = "15 GB (16,106,127,360 bytes)";
                    MaxReceiveSize           = "25 MB (26,214,400 bytes)";
                    MaxSendSize              = "25 MB (26,214,400 bytes)";
                    ProhibitSendQuota        = "15 GB (16,106,127,360 bytes)";
                    ProhibitSendReceiveQuota = "15 GB (16,106,127,360 bytes)"; # Updated Property
                    RetainDeletedItemsFor    = "14.00:00:00";
                    RoleAssignmentPolicy     = "Default Role Assignment Policy";
                    Credential               = $Credscredential
                }
                EXOMailboxSettings 'OttawaTeamMailboxSettings'
                {
                    DisplayName = 'Conf Room Adams'
                    TimeZone    = 'Eastern Standard Time'
                    Locale      = 'en-US' # Updated Property
                    Ensure      = 'Present'
                    Credential  = $Credscredential
                }
                EXOMailContact 'TestMailContact'
                {
                    Alias                       = 'TestMailContact'
                    Credential                  = $Credscredential
                    DisplayName                 = 'My Test Contact'
                    Ensure                      = 'Present'
                    ExternalEmailAddress        = 'SMTP:test@tailspintoys.com'
                    MacAttachmentFormat         = 'BinHex'
                    MessageBodyFormat           = 'TextAndHtml'
                    MessageFormat               = 'Mime'
                    ModeratedBy                 = @()
                    ModerationEnabled           = $false
                    Name                        = 'My Test Contact'
                    OrganizationalUnit          = $Domain
                    SendModerationNotifications = 'Always'
                    UsePreferMessageFormat      = $false # Updated Property
                    CustomAttribute1            = 'Custom Value 1'
                    ExtensionCustomAttribute5   = 'Extension Custom Value 1', 'Extension Custom Value 2'
                }
                EXOMailTips 'OrgWideMailTips'
                {
                    Organization                          = $Domain
                    MailTipsAllTipsEnabled                = $True
                    MailTipsGroupMetricsEnabled           = $False # Updated Property
                    MailTipsLargeAudienceThreshold        = 100
                    MailTipsMailboxSourcedTipsEnabled     = $True
                    MailTipsExternalRecipientsTipsEnabled = $True
                    Ensure                                = "Present"
                    Credential                            = $Credscredential
                }
                EXOMalwareFilterPolicy 'ConfigureMalwareFilterPolicy'
                {
                    Identity                               = "IntegrationMFP"
                    CustomNotifications                    = $False
                    EnableExternalSenderAdminNotifications = $False
                    EnableFileFilter                       = $False
                    EnableInternalSenderAdminNotifications = $False
                    FileTypeAction                         = "Quarantine"
                    FileTypes                              = @("ace", "ani", "app", "cab", "docm", "exe", "iso", "jar", "jnlp", "reg", "scr", "vbe", "vbs")
                    QuarantineTag                          = "AdminOnlyAccessPolicy"
                    ZapEnabled                             = $False # Updated Property
                    Ensure                                 = "Present"
                    Credential                             = $Credscredential
                }
                EXOMalwareFilterRule 'ConfigureMalwareFilterRule'
                {
                    Identity                  = "Contoso Recipients"
                    MalwareFilterPolicy       = "IntegrationMFP"
                    Comments                  = "Apply the filter to all Contoso users"
                    Enabled                   = $False # Updated Property
                    RecipientDomainIs         = "contoso.com"
                    Ensure                    = "Present"
                    Credential                = $Credscredential
                }
                EXOManagementRole 'ConfigureManagementRole'
                {
                    Name                 = "MyDisplayName"
                    Description          = "Updated Description" # Updated Property
                    Parent               = "$Domain\MyProfileInformation"
                    Ensure               = "Present"
                    Credential           = $Credscredential
                }
                EXOManagementRoleAssignment 'AssignManagementRole'
                {
                    Credential           = $credsCredential;
                    Ensure               = "Present";
                    Name                 = "MyManagementRoleAssignment";
                    Role                 = "UserApplication";
                    User                 = "AlexW@$Domain"; # Updated Property
                }
                EXOMessageClassification 'ConfigureMessageClassification'
                {
                    Identity                    = "Contoso Message Classification"
                    Name                        = "Contoso Message Classification"
                    DisplayName                 = "Contoso Message Classification"
                    DisplayPrecedence           = "Highest"
                    PermissionMenuVisible       = $True
                    RecipientDescription        = "Shown to receipients"
                    SenderDescription           = "Shown to senders"
                    RetainClassificationEnabled = $False # Updated Property
                    Ensure                      = "Present"
                    Credential                  = $Credscredential
                }
                EXOMobileDeviceMailboxPolicy 'ConfigureMobileDeviceMailboxPolicy'
                {
                    Name                                     = "Default"
                    AllowApplePushNotifications              = $True
                    AllowBluetooth                           = "Allow"
                    AllowBrowser                             = $False # Updated Property
                    AllowCamera                              = $True
                    AllowConsumerEmail                       = $True
                    AllowDesktopSync                         = $True
                    AllowExternalDeviceManagement            = $False
                    AllowGooglePushNotifications             = $True
                    AllowHTMLEmail                           = $True
                    AllowInternetSharing                     = $True
                    AllowIrDA                                = $True
                    AllowMicrosoftPushNotifications          = $True
                    AllowMobileOTAUpdate                     = $True
                    AllowNonProvisionableDevices             = $True
                    AllowPOPIMAPEmail                        = $True
                    AllowRemoteDesktop                       = $True
                    AllowSimplePassword                      = $True
                    AllowSMIMEEncryptionAlgorithmNegotiation = "AllowAnyAlgorithmNegotiation"
                    AllowSMIMESoftCerts                      = $True
                    AllowStorageCard                         = $True
                    AllowTextMessaging                       = $True
                    AllowUnsignedApplications                = $True
                    AllowUnsignedInstallationPackages        = $True
                    AllowWiFi                                = $True
                    AlphanumericPasswordRequired             = $False
                    ApprovedApplicationList                  = @()
                    AttachmentsEnabled                       = $True
                    DeviceEncryptionEnabled                  = $False
                    DevicePolicyRefreshInterval              = "Unlimited"
                    IrmEnabled                               = $True
                    IsDefault                                = $True
                    MaxAttachmentSize                        = "Unlimited"
                    MaxCalendarAgeFilter                     = "All"
                    MaxEmailAgeFilter                        = "All"
                    MaxEmailBodyTruncationSize               = "Unlimited"
                    MaxEmailHTMLBodyTruncationSize           = "Unlimited"
                    MaxInactivityTimeLock                    = "Unlimited"
                    MaxPasswordFailedAttempts                = "Unlimited"
                    MinPasswordComplexCharacters             = 1
                    PasswordEnabled                          = $False
                    PasswordExpiration                       = "Unlimited"
                    PasswordHistory                          = 0
                    PasswordRecoveryEnabled                  = $False
                    RequireDeviceEncryption                  = $False
                    RequireEncryptedSMIMEMessages            = $False
                    RequireEncryptionSMIMEAlgorithm          = "TripleDES"
                    RequireManualSyncWhenRoaming             = $False
                    RequireSignedSMIMEAlgorithm              = "SHA1"
                    RequireSignedSMIMEMessages               = $False
                    RequireStorageCardEncryption             = $False
                    UnapprovedInROMApplicationList           = @()
                    UNCAccessEnabled                         = $True
                    WSSAccessEnabled                         = $True
                    Ensure                                   = "Present"
                    Credential                               = $Credscredential
                }
                EXOOfflineAddressBook 'ConfigureOfflineAddressBook'
                {
                    Name                 = "Integration Address Book"
                    AddressLists         = @('\All Users')
                    DiffRetentionPeriod  = "60" # Updated Property
                    IsDefault            = $true
                    Ensure               = "Present"
                    Credential           = $Credscredential
                }
                EXOOMEConfiguration 'ConfigureOMEConfiguration'
                {
                    Identity                 = "Contoso Marketing"
                    BackgroundColor          = "0x00FFFF00"
                    DisclaimerText           = "Encryption security disclaimer."
                    EmailText                = "Encrypted message enclosed."
                    ExternalMailExpiryInDays = 1 # Updated Property
                    IntroductionText         = "You have received an encypted message"
                    OTPEnabled               = $True
                    PortalText               = "This portal is encrypted."
                    SocialIdSignIn           = $True
                    Ensure                   = "Present"
                    Credential               = $Credscredential
                }
                EXOOnPremisesOrganization 'ConfigureOnPremisesOrganization'
                {
                    Identity          = 'Integration'
                    Comment           = 'Mail for Contoso - Updated' #Updated Property
                    HybridDomains     = 'o365dsc.onmicrosoft.com'
                    InboundConnector  = 'Integration Inbound Connector'
                    OrganizationGuid  = 'e7a80bcf-696e-40ca-8775-a7f85fbb3ebc'
                    OrganizationName  = 'O365DSC'
                    OutboundConnector = 'Contoso Outbound Connector'
                    Ensure            = 'Present'
                    Credential        = $Credscredential
                }
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
                    Credential                                                = $Credscredential
                }
                EXOOrganizationRelationship 'ConfigureOrganizationRelationship'
                {
                    Name                  = "Contoso"
                    ArchiveAccessEnabled  = $False # Updated Property
                    DeliveryReportEnabled = $True
                    DomainNames           = "mail.contoso.com"
                    Enabled               = $True
                    FreeBusyAccessEnabled = $True
                    FreeBusyAccessLevel   = "AvailabilityOnly"
                    MailboxMoveEnabled    = $True
                    MailTipsAccessEnabled = $True
                    MailTipsAccessLevel   = "None"
                    PhotosEnabled         = $True
                    TargetApplicationUri  = "mail.contoso.com"
                    TargetAutodiscoverEpr = "https://mail.contoso.com/autodiscover/autodiscover.svc/wssecurity"
                    Ensure                = "Present"
                    Credential            = $Credscredential
                }
                EXOOutboundConnector 'ConfigureOutboundConnector'
                {
                    Identity                      = "Contoso Outbound Connector"
                    AllAcceptedDomains            = $False
                    CloudServicesMailEnabled      = $False
                    Comment                       = "Outbound connector to Contoso"
                    ConnectorSource               = "Default"
                    ConnectorType                 = "Partner"
                    Enabled                       = $False # Updated Property
                    IsTransportRuleScoped         = $False
                    RecipientDomains              = "contoso.com"
                    RouteAllMessagesViaOnPremises = $False
                    TlsDomain                     = "*.contoso.com"
                    TlsSettings                   = "DomainValidation"
                    UseMxRecord                   = $True
                    Ensure                        = "Present"
                    Credential                    = $Credscredential
                }
                EXOOwaMailboxPolicy 'ConfigureOwaMailboxPolicy'
                {
                    Name                                                 = "OwaMailboxPolicy-Integration"
                    ActionForUnknownFileAndMIMETypes                     = "ForceSave"
                    ActiveSyncIntegrationEnabled                         = $True
                    AdditionalStorageProvidersAvailable                  = $True
                    AllAddressListsEnabled                               = $True
                    AllowCopyContactsToDeviceAddressBook                 = $True
                    AllowedFileTypes                                     = @(".rpmsg",".xlsx",".xlsm",".xlsb",".tiff",".pptx",".pptm",".ppsx",".ppsm",".docx",".docm",".zip",".xls",".wmv",".wma",".wav",".vsd",".txt",".tif",".rtf",".pub",".ppt",".png",".pdf",".one",".mp3",".jpg",".gif",".doc",".bmp",".avi")
                    AllowedMimeTypes                                     = @("image/jpeg","image/png","image/gif","image/bmp")
                    BlockedFileTypes                                     = @(".settingcontent-ms",".printerexport",".appcontent-ms",".appref-ms",".vsmacros",".website",".msh2xml",".msh1xml",".diagcab",".webpnp",".ps2xml",".ps1xml",".mshxml",".gadget",".theme",".psdm1",".mhtml",".cdxml",".xbap",".vhdx",".pyzw",".pssc",".psd1",".psc2",".psc1",".msh2",".msh1",".jnlp",".aspx",".appx",".xnk",".xml",".xll",".wsh",".wsf",".wsc",".wsb",".vsw",".vst",".vss",".vhd",".vbs",".vbp",".vbe",".url",".udl",".tmp",".shs",".shb",".sct",".scr",".scf",".reg",".pyz",".pyw",".pyo",".pyc",".pst",".ps2",".ps1",".prg",".prf",".plg",".pif",".pcd",".ops",".msu",".mst",".msp",".msi",".msh",".msc",".mht",".mdz",".mdw",".mdt",".mde",".mdb",".mda",".mcf",".maw",".mav",".mau",".mat",".mas",".mar",".maq",".mam",".mag",".maf",".mad",".lnk",".ksh",".jse",".jar",".its",".isp",".ins",".inf",".htc",".hta",".hpj",".hlp",".grp",".fxp",".exe",".der",".csh",".crt",".cpl",".com",".cnt",".cmd",".chm",".cer",".bat",".bas",".asx",".asp",".app",".apk",".adp",".ade",".ws",".vb",".py",".pl",".js")
                    BlockedMimeTypes                                     = @("application/x-javascript","application/javascript","application/msaccess","x-internet-signup","text/javascript","application/xml","application/prg","application/hta","text/scriplet","text/xml")
                    ClassicAttachmentsEnabled                            = $True
                    ConditionalAccessPolicy                              = "Off"
                    DefaultTheme                                         = ""
                    DirectFileAccessOnPrivateComputersEnabled            = $True
                    DirectFileAccessOnPublicComputersEnabled             = $False # Updated Property
                    DisplayPhotosEnabled                                 = $True
                    ExplicitLogonEnabled                                 = $True
                    ExternalImageProxyEnabled                            = $True
                    ForceSaveAttachmentFilteringEnabled                  = $False
                    ForceSaveFileTypes                                   = @(".vsmacros",".ps2xml",".ps1xml",".mshxml",".gadget",".psc2",".psc1",".aspx",".wsh",".wsf",".wsc",".vsw",".vst",".vss",".vbs",".vbe",".url",".tmp",".swf",".spl",".shs",".shb",".sct",".scr",".scf",".reg",".pst",".ps2",".ps1",".prg",".prf",".plg",".pif",".pcd",".ops",".mst",".msp",".msi",".msh",".msc",".mdz",".mdw",".mdt",".mde",".mdb",".mda",".maw",".mav",".mau",".mat",".mas",".mar",".maq",".mam",".mag",".maf",".mad",".lnk",".ksh",".jse",".its",".isp",".ins",".inf",".hta",".hlp",".fxp",".exe",".dir",".dcr",".csh",".crt",".cpl",".com",".cmd",".chm",".cer",".bat",".bas",".asx",".asp",".app",".adp",".ade",".ws",".vb",".js")
                    ForceSaveMimeTypes                                   = @("Application/x-shockwave-flash","Application/octet-stream","Application/futuresplash","Application/x-director")
                    ForceWacViewingFirstOnPrivateComputers               = $False
                    ForceWacViewingFirstOnPublicComputers                = $False
                    FreCardsEnabled                                      = $True
                    GlobalAddressListEnabled                             = $True
                    GroupCreationEnabled                                 = $True
                    InstantMessagingEnabled                              = $True
                    InstantMessagingType                                 = "Ocs"
                    InterestingCalendarsEnabled                          = $True
                    IRMEnabled                                           = $True
                    IsDefault                                            = $True
                    JournalEnabled                                       = $True
                    LocalEventsEnabled                                   = $False
                    LogonAndErrorLanguage                                = 0
                    NotesEnabled                                         = $True
                    NpsSurveysEnabled                                    = $True
                    OnSendAddinsEnabled                                  = $False
                    OrganizationEnabled                                  = $True
                    OutboundCharset                                      = "AutoDetect"
                    OutlookBetaToggleEnabled                             = $True
                    OWALightEnabled                                      = $True
                    PersonalAccountCalendarsEnabled                      = $True
                    PhoneticSupportEnabled                               = $False
                    PlacesEnabled                                        = $True
                    PremiumClientEnabled                                 = $True
                    PrintWithoutDownloadEnabled                          = $True
                    PublicFoldersEnabled                                 = $True
                    RecoverDeletedItemsEnabled                           = $True
                    ReferenceAttachmentsEnabled                          = $True
                    RemindersAndNotificationsEnabled                     = $True
                    ReportJunkEmailEnabled                               = $True
                    RulesEnabled                                         = $True
                    SatisfactionEnabled                                  = $True
                    SaveAttachmentsToCloudEnabled                        = $True
                    SearchFoldersEnabled                                 = $True
                    SetPhotoEnabled                                      = $True
                    SetPhotoURL                                          = ""
                    SignaturesEnabled                                    = $True
                    SkipCreateUnifiedGroupCustomSharepointClassification = $True
                    TeamSnapCalendarsEnabled                             = $True
                    TextMessagingEnabled                                 = $True
                    ThemeSelectionEnabled                                = $True
                    UMIntegrationEnabled                                 = $True
                    UseGB18030                                           = $False
                    UseISO885915                                         = $False
                    UserVoiceEnabled                                     = $True
                    WacEditingEnabled                                    = $True
                    WacExternalServicesEnabled                           = $True
                    WacOMEXEnabled                                       = $False
                    WacViewingOnPrivateComputersEnabled                  = $True
                    WacViewingOnPublicComputersEnabled                   = $True
                    WeatherEnabled                                       = $True
                    WebPartsFrameOptionsType                             = "SameOrigin"
                    Ensure                                               = "Present"
                    Credential                                           = $Credscredential
                }
                EXOPartnerApplication 'ConfigurePartnerApplication'
                {
                    Name                                = "HRApp"
                    ApplicationIdentifier               = "00000006-0000-0dd1-ac00-000000000000"
                    AcceptSecurityIdentifierInformation = $False # Updated Property
                    Enabled                             = $True
                    Ensure                              = "Present"
                    Credential                          = $Credscredential
                }
                EXOPerimeterConfiguration 'ConfigurePerimeterConfiguration'
                {
                    IsSingleInstance   = 'Yes'
                    #GatewayIPAddresses = '123.0.0.1'
                    Ensure             = 'Present'
                    Credential         = $Credscredential
                }
                EXOPlace 'TestPlace'
                {
                    AudioDeviceName        = "MyAudioDevice";
                    Capacity               = 16; # Updated Property
                    City                   = "";
                    Credential             = $Credscredential
                    DisplayDeviceName      = "DisplayDeviceName";
                    Ensure                 = 'Present'
                    Identity               = "Hood@$Domain";
                    IsWheelChairAccessible = $True;
                    MTREnabled             = $False;
                    ParentType             = "None";
                    Phone                  = "555-555-5555";
                    Tags                   = @("Tag1", "Tag2");
                    VideoDeviceName        = "VideoDevice";
                }
                EXOPolicyTipConfig 'ConfigurePolicyTipConfig'
                {
                    Name                 = "en\NotifyOnly"
                    Value                = "This message contains content that is restricted by Contoso company policy. Updated" # Updated Property
                    Ensure               = "Present"
                    Credential           = $Credscredential
                }
                EXOQuarantinePolicy 'ConfigureQuarantinePolicy'
                {
                    EndUserQuarantinePermissionsValue = 87;
                    ESNEnabled                        = $True; # Updated Property
                    Identity                          = "$Domain\IntegrationPolicy";
                    Ensure                            = "Present"
                    Credential                        = $Credscredential
                }
                EXORemoteDomain '583b0b70-b45d-401f-98a6-0e7fa8434946'
                {
                    Identity                             = "Integration"
                    AllowedOOFType                       = "External"
                    AutoForwardEnabled                   = $True
                    AutoReplyEnabled                     = $False # Updated Property
                    ByteEncoderTypeFor7BitCharsets       = "Undefined"
                    CharacterSet                         = "iso-8859-1"
                    ContentType                          = "MimeHtmlText"
                    DeliveryReportEnabled                = $True
                    DisplaySenderName                    = $True
                    DomainName                           = "contoso.com"
                    IsInternal                           = $False
                    LineWrapSize                         = "Unlimited"
                    MeetingForwardNotificationEnabled    = $False
                    Name                                 = "Integration"
                    NonMimeCharacterSet                  = "iso-8859-1"
                    PreferredInternetCodePageForShiftJis = "Undefined"
                    TargetDeliveryDomain                 = $False
                    TrustedMailInboundEnabled            = $False
                    TrustedMailOutboundEnabled           = $False
                    UseSimpleDisplayName                 = $False
                    Ensure                               = "Present"
                    Credential                           = $Credscredential
                }
                EXOReportSubmissionPolicy 'ConfigureReportSubmissionPolicy'
                {
                    IsSingleInstance                       = 'Yes'
                    DisableQuarantineReportingOption       = $False
                    EnableCustomNotificationSender         = $False
                    EnableOrganizationBranding             = $False
                    EnableReportToMicrosoft                = $True
                    EnableThirdPartyAddress                = $False
                    EnableUserEmailNotification            = $False
                    PostSubmitMessageEnabled               = $True
                    PreSubmitMessageEnabled                = $True
                    ReportJunkToCustomizedAddress          = $False
                    ReportNotJunkToCustomizedAddress       = $False
                    ReportPhishToCustomizedAddress         = $False
                    Ensure                                 = "Present"
                    Credential                             = $Credscredential
                }
                EXOReportSubmissionRule 'ConfigureReportSubmissionRule'
                {
                    IsSingleInstance    = 'Yes'
                    Identity            = "DefaultReportSubmissionRule"
                    Comments            = "This is my default rule"
                    SentTo              = "submission@contoso.com"
                    Ensure              = "Present"
                    Credential          = $Credscredential
                }
                EXOResourceConfiguration 'ConfigureResourceConfiguration'
                {
                    IsSingleInstance       = 'Yes'
                    ResourcePropertySchema = @('Room/TV', 'Equipment/Laptop')
                    Ensure                 = 'Present'
                    Credential             = $Credscredential
                }
                EXORoleAssignmentPolicy 'ConfigureRoleAssignmentPolicy'
                {
                    Name                 = "Integration Policy"
                    Description          = "Updated Description"  # Updated Property
                    IsDefault            = $True
                    Roles                = @("My Marketplace Apps","MyVoiceMail","MyDistributionGroups","MyRetentionPolicies","MyContactInformation","MyBaseOptions","MyTextMessaging","MyDistributionGroupMembership","MyProfileInformation","My Custom Apps","My ReadWriteMailbox Apps")
                    Ensure               = "Present"
                    Credential           = $Credscredential
                }
                EXORoleGroup 'ConfigureRoleGroup'
                {
                    Name                      = "Contoso Role Group"
                    Description               = "Address Lists Role for Exchange Administrators. Updated" # Updated Property
                    Members                   = @("Exchange Administrator")
                    Roles                     = @("Address Lists")
                    Ensure                    = "Present"
                    Credential                = $Credscredential
                }
                EXOSafeAttachmentPolicy 'ConfigureSafeAttachmentPolicy'
                {
                    Identity             = "Marketing Block Attachments"
                    Enable               = $False # Updated Property
                    Redirect             = $True
                    RedirectAddress      = "admin@$Domain"
                    Ensure               = "Present"
                    Credential           = $Credscredential
                }
                EXOSafeAttachmentRule 'ConfigureSafeAttachmentRule'
                {
                    Identity                  = "Research Department Attachment Rule"
                    Comments                  = "Applies to Research Department, except managers"
                    Enabled                   = $False # Updated Property
                    ExceptIfSentToMemberOf    = "Executives@$Domain"
                    SafeAttachmentPolicy      = "Marketing Block Attachments"
                    SentToMemberOf            = "LegalTeam@$Domain"
                    Ensure                    = "Present"
                    Credential                = $Credscredential
                }
                EXOSafeLinksPolicy 'ConfigureSafeLinksPolicy'
                {
                    Identity                      = 'Marketing Block URL'
                    AdminDisplayName              = 'Marketing Block URL'
                    CustomNotificationText        = 'Blocked URLs for Marketing'
                    DeliverMessageAfterScan       = $True
                    EnableOrganizationBranding    = $False # Updated Property
                    EnableSafeLinksForTeams       = $True
                    ScanUrls                      = $True
                    Ensure                        = 'Present'
                    Credential                    = $Credscredential
                }
                EXOSafeLinksRule 'ConfigureSafeLinksRule'
                {
                    Identity                  = "Research Department URL Rule"
                    Comments                  = "Applies to Research Department, except managers"
                    Enabled                   = $False # Updated Property
                    ExceptIfSentToMemberOf    = "Executives@$Domain"
                    SafeLinksPolicy           = "Marketing Block URL"
                    SentToMemberOf            = "LegalTeam@$Domain"
                    Ensure                    = "Present"
                    Credential                = $Credscredential
                }
                EXOSharedMailbox 'SharedMailbox'
                {
                    DisplayName        = "Integration"
                    PrimarySMTPAddress = "Integration@$Domain"
                    EmailAddresses     = @("IntegrationSM@$Domain", "IntegrationSM2@$Domain")
                    Alias              = "IntegrationSM"
                    Ensure             = "Present"
                    Credential         = $Credscredential
                }
                EXOSharingPolicy 'ConfigureSharingPolicy'
                {
                    Name       = "Integration Sharing Policy"
                    Default    = $False # Updated Property
                    Domains    = @("Anonymous:CalendarSharingFreeBusyReviewer", "*:CalendarSharingFreeBusySimple")
                    Enabled    = $True
                    Ensure     = "Present"
                    Credential = $Credscredential
                }
                EXOTransportConfig 'EXOTransportConfig '
                {
                    IsSingleInstance                        = "Yes";
                    AddressBookPolicyRoutingEnabled         = $True;
                    ClearCategories                         = $True;
                    ConvertDisclaimerWrapperToEml           = $False;
                    DSNConversionMode                       = "PreserveDSNBody";
                    ExternalDelayDsnEnabled                 = $True;
                    ExternalDsnLanguageDetectionEnabled     = $True;
                    ExternalDsnSendHtml                     = $True;
                    ExternalPostmasterAddress               = "postmaster@contoso.com";
                    HeaderPromotionModeSetting              = "NoCreate";
                    InternalDelayDsnEnabled                 = $True;
                    InternalDsnLanguageDetectionEnabled     = $True;
                    InternalDsnSendHtml                     = $True;
                    JournalingReportNdrTo                   = "<>";
                    JournalMessageExpirationDays            = 0;
                    MaxRecipientEnvelopeLimit               = "Unlimited";
                    ReplyAllStormBlockDurationHours         = 6;
                    ReplyAllStormDetectionMinimumRecipients = 2500;
                    ReplyAllStormDetectionMinimumReplies    = 10;
                    ReplyAllStormProtectionEnabled          = $True;
                    Rfc2231EncodingEnabled                  = $False;
                    SmtpClientAuthenticationDisabled        = $True;
                    Credential                              = $Credscredential
                }
                EXOTransportRule 'ConfigureTransportRule'
                {
                    Name                                          = "Ethical Wall - Sales and Executives Departments"
                    BetweenMemberOf1                              = "SalesTeam@$Domain"
                    BetweenMemberOf2                              = "Executives@$Domain"
                    ExceptIfFrom                                  = "AdeleV@$Domain"
                    ExceptIfSubjectContainsWords                  = "Press Release","Corporate Communication"
                    RejectMessageReasonText                       = "Messages sent between the Sales and Brokerage departments are strictly prohibited."
                    Enabled                                       = $False # Updated Property
                    Ensure                                        = "Present"
                    Credential                                    = $Credscredential
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
    try
    {
        Master -ConfigurationData $ConfigurationData -Credscredential $Credential
        Start-DscConfiguration Master -Wait -Force -Verbose -ErrorAction Stop
    }
    catch
    {
        throw $_
    }
