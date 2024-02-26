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
                    OutboundOnly = $false
                    Ensure       = "Present"
                    Credential   = $Credscredential
                }
                EXOActiveSyncDeviceAccessRule 'ConfigureActiveSyncDeviceAccessRule'
                {
                    Identity             = "ContosoPhone(DeviceOS)"
                    Characteristic       = "DeviceOS"
                    QueryString          = "iOS 6.1 10B146"
                    AccessLevel          = "Allow"
                    Ensure               = "Present"
                    Credential           = $Credscredential
                }
                EXOAddressBookPolicy 'ConfigureAddressBookPolicy'
                {
                    Name                 = "All Fabrikam ABP"
                    AddressLists         = "\All Distribution Lists"
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
                    ConditionalDepartment      = "HR"
                    ConditionalStateOrProvince = "US"
                    IncludedRecipients         = "AllRecipients"
                    Ensure                     = "Present"
                    Credential                 = $Credscredential
                }
                EXOAntiPhishPolicy 'ConfigureAntiphishPolicy'
                {
                    Identity                              = "Our Rule"
                    MakeDefault                           = $null
                    PhishThresholdLevel                   = 1
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
                    Description          = "Engineering Group Policy"
                    Ensure               = "Present"
                    Credential           = $Credscredential
                }
                EXOAuthenticationPolicy 'ConfigureAuthenticationPolicy'
                {
                    Identity                            = "Block Basic Auth"
                    AllowBasicAuthActiveSync            = $False
                    AllowBasicAuthAutodiscover          = $False
                    AllowBasicAuthImap                  = $False
                    AllowBasicAuthMapi                  = $False
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
                EXOAuthenticationPolicyAssignment 'ConfigureAuthenticationPolicyAssignment'
                {
                    UserName                 = "AdeleV@$Domain"
                    AuthenticationPolicyName = "Block Basic Auth"
                    Ensure                   = "Present"
                    Credential               = $Credscredential
                }
                EXOAvailabilityAddressSpace 'ConfigureAvailabilityAddressSpace'
                {
                    Identity              = 'Contoso.com'
                    AccessMethod          = 'OrgWideFBToken'
                    ForestName            = 'example.contoso.com'
                    TargetServiceEpr      = 'https://contoso.com/autodiscover/autodiscover.xml'
                    TargetTenantId        = 'o365dsc.onmicrosoft.com'
                    Ensure                = 'Present'
                    Credential            = $Credscredential
                }
                EXOAvailabilityConfig 'ConfigureAvailabilityConfig'
                {
                    OrgWideAccount       = "adelev@$Domain"
                    Ensure               = "Present"
                    Credential           = $Credscredential
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
                    Enabled                              = $True
                    ExceptAnyOfProtocols                 = @()
                    ExceptAnyOfClientIPAddressesOrRanges = @()
                    AnyOfClientIPAddressesOrRanges       = @()
                    Ensure                               = "Present"
                    Credential                           = $Credscredential
                }
                EXODistributionGroup 'DemoDG'
                {
                    Alias                              = "demodg";
                    BccBlocked                         = $False;
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
                    Enabled                = $True
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
                    ManagedByFilter                   = ""
                    Priority                          = 1
                    Ensure                            = "Present"
                    Credential                        = $Credscredential
                }
                EXOGlobalAddressList 'ConfigureGlobalAddressList'
                {
                    Name                         = "Contoso Human Resources in Washington"
                    ConditionalCompany           = "Contoso"
                    ConditionalDepartment        = "Human Resources"
                    ConditionalStateOrProvince   = "Washington"
                    IncludedRecipients           = 'AllRecipients'
                    Ensure                       = "Present"
                    Credential                   = $Credscredential
                }
                EXOHostedContentFilterPolicy 'ConfigureHostedContentFilterPolicy'
                {
                    Identity                             = "Integration CFP"
                    AddXHeaderValue                      = ""
                    AdminDisplayName                     = ""
                    BulkSpamAction                       = "MoveToJmf"
                    BulkThreshold                        = 7
                    DownloadLink                         = $False
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
                    Enabled                   = $True
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
                    RecipientLimitInternalPerHour             = 0
                    RecipientLimitPerDay                      = 0
                    Ensure                                    = "Present"
                    Credential                                = $Credscredential
                }
                EXOHostedOutboundSpamFilterRule 'ConfigureHostedOutboundSpamFilterRule'
                {
                    Identity                       = "Contoso Executives"
                    Comments                       = "Does not apply to Executives"
                    Enabled                        = $True
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
                    Enabled                      = $True
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
                    Enabled              = $True
                    Ensure               = "Present"
                    Credential           = $Credscredential
                }
                EXOJournalRule 'CreateJournalRule'
                {
                    Enabled              = $True
                    JournalEmailAddress  = "AdeleV@$Domain"
                    Name                 = "Send to Adele"
                    RuleScope            = "Global"
                    Ensure               = "Present"
                    Credential           = $Credscredential
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
                    UsePreferMessageFormat      = $true
                    CustomAttribute1            = 'Custom Value 1'
                    ExtensionCustomAttribute5   = 'Extension Custom Value 1', 'Extension Custom Value 2'
                }
                EXOMailTips 'OrgWideMailTips'
                {
                    Organization                          = $Domain
                    MailTipsAllTipsEnabled                = $True
                    MailTipsGroupMetricsEnabled           = $True
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
                    ZapEnabled                             = $True
                    Ensure                                 = "Present"
                    Credential                             = $Credscredential
                }
                EXOMalwareFilterRule 'ConfigureMalwareFilterRule'
                {
                    Identity                  = "Contoso Recipients"
                    MalwareFilterPolicy       = "IntegrationMFP"
                    Comments                  = "Apply the filter to all Contoso users"
                    Enabled                   = $True
                    RecipientDomainIs         = "contoso.com"
                    Ensure                    = "Present"
                    Credential                = $Credscredential
                }
                EXOManagementRole 'ConfigureManagementRole'
                {
                    Name                 = "MyDisplayName"
                    Description          = ""
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
                    User                 = "AdeleV@$Domain";
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
                    RetainClassificationEnabled = $True
                    Ensure                      = "Present"
                    Credential                  = $Credscredential
                }
                EXOMobileDeviceMailboxPolicy 'ConfigureMobileDeviceMailboxPolicy'
                {
                    Name                                     = "Default"
                    AllowApplePushNotifications              = $True
                    AllowBluetooth                           = "Allow"
                    AllowBrowser                             = $True
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
                    DiffRetentionPeriod  = "30"
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
                    ExternalMailExpiryInDays = 0
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
                    Comment           = 'Mail for Contoso'
                    HybridDomains     = 'o365dsc.onmicrosoft.com'
                    InboundConnector  = 'Integration Inbound Connector'
                    OrganizationGuid  = 'e7a80bcf-696e-40ca-8775-a7f85fbb3ebc'
                    OrganizationName  = 'O365DSC'
                    OutboundConnector = 'Contoso Outbound Connector'
                    Ensure            = 'Present'
                    Credential        = $Credscredential
                    DependsOn         = "[EXOOutboundConnector]OutboundDependency"
                }
                EXOOutboundConnector 'OutboundDependency'
                {
                    Identity                      = "Contoso Outbound Connector"
                    AllAcceptedDomains            = $False
                    CloudServicesMailEnabled      = $False
                    Comment                       = "Outbound connector to Contoso"
                    ConnectorSource               = "Default"
                    ConnectorType                 = "Partner"
                    Enabled                       = $True
                    IsTransportRuleScoped         = $False
                    RecipientDomains              = "contoso.com"
                    RouteAllMessagesViaOnPremises = $False
                    TlsDomain                     = "*.contoso.com"
                    TlsSettings                   = "DomainValidation"
                    UseMxRecord                   = $True
                    Ensure                        = "Present"
                    Credential                    = $Credscredential
                }
                EXOOrganizationRelationship 'ConfigureOrganizationRelationship'
                {
                    Name                  = "Contoso"
                    ArchiveAccessEnabled  = $True
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
                    DirectFileAccessOnPublicComputersEnabled             = $True
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
                    AcceptSecurityIdentifierInformation = $true
                    Enabled                             = $True
                    Ensure                              = "Present"
                    Credential                          = $Credscredential
                }
                EXOPlace 'TestPlace'
                {
                    AudioDeviceName        = "MyAudioDevice";
                    Capacity               = 15;
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
                    Value                = "This message contains content that is restricted by Contoso company policy."
                    Ensure               = "Present"
                    Credential           = $Credscredential
                }
                EXOQuarantinePolicy 'ConfigureQuarantinePolicy'
                {
                    EndUserQuarantinePermissionsValue = 87;
                    ESNEnabled                        = $False;
                    Identity                          = "$Domain\IntegrationPolicy";
                    Ensure                            = "Present"
                    Credential                        = $Credscredential
                }
                EXORecipientPermission 'AddSendAs'
                {
                    Identity     = "AlexW@$Domain"
                    Trustee      = "admin@$Domain"
                    AccessRights = 'SendAs'
                    Ensure       = 'Present'
                    Credential   = $Credscredential
                }
                EXORemoteDomain '583b0b70-b45d-401f-98a6-0e7fa8434946'
                {
                    Identity                             = "Integration"
                    AllowedOOFType                       = "External"
                    AutoForwardEnabled                   = $True
                    AutoReplyEnabled                     = $True
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
                EXORoleAssignmentPolicy 'ConfigureRoleAssignmentPolicy'
                {
                    Name                 = "Integration Policy"
                    Description          = "This policy grants end users the permission to set their options in Outlook on the web and perform other self-administration tasks."
                    IsDefault            = $True
                    Roles                = @("My Marketplace Apps","MyVoiceMail","MyDistributionGroups","MyRetentionPolicies","MyContactInformation","MyBaseOptions","MyTextMessaging","MyDistributionGroupMembership","MyProfileInformation","My Custom Apps","My ReadWriteMailbox Apps")
                    Ensure               = "Present"
                    Credential           = $Credscredential
                }
                EXORoleGroup 'ConfigureRoleGroup'
                {
                    Name                      = "Contoso Role Group"
                    Description               = "Address Lists Role for Exchange Administrators"
                    Members                   = @("Exchange Administrator")
                    Roles                     = @("Address Lists")
                    Ensure                    = "Present"
                    Credential                = $Credscredential
                }
                EXOSafeAttachmentPolicy 'ConfigureSafeAttachmentPolicy'
                {
                    Identity             = "Marketing Block Attachments"
                    Enable               = $True
                    Redirect             = $True
                    RedirectAddress      = "admin@$Domain"
                    Ensure               = "Present"
                    Credential           = $Credscredential
                }
                EXOSafeAttachmentRule 'ConfigureSafeAttachmentRule'
                {
                    Identity                  = "Research Department Attachment Rule"
                    Comments                  = "Applies to Research Department, except managers"
                    Enabled                   = $True
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
                    EnableOrganizationBranding    = $True
                    EnableSafeLinksForTeams       = $True
                    ScanUrls                      = $True
                    Ensure                        = 'Present'
                    Credential                    = $Credscredential
                }
                EXOSafeLinksRule 'ConfigureSafeLinksRule'
                {
                    Identity                  = "Research Department URL Rule"
                    Comments                  = "Applies to Research Department, except managers"
                    Enabled                   = $True
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
                    EmailAddresses     = @("IntegrationSM@$Domain")
                    Alias              = "IntegrationSM"
                    Ensure             = "Present"
                    Credential         = $Credscredential
                }
                EXOSharingPolicy 'ConfigureSharingPolicy'
                {
                    Name       = "Integration Sharing Policy"
                    Default    = $True
                    Domains    = @("Anonymous:CalendarSharingFreeBusyReviewer", "*:CalendarSharingFreeBusySimple")
                    Enabled    = $True
                    Ensure     = "Present"
                    Credential = $Credscredential
                }
                EXOTransportRule 'ConfigureTransportRule'
                {
                    Name                                          = "Ethical Wall - Sales and Executives Departments"
                    BetweenMemberOf1                              = "SalesTeam@$Domain"
                    BetweenMemberOf2                              = "Executives@$Domain"
                    ExceptIfFrom                                  = "AdeleV@$Domain"
                    ExceptIfSubjectContainsWords                  = "Press Release","Corporate Communication"
                    RejectMessageReasonText                       = "Messages sent between the Sales and Brokerage departments are strictly prohibited."
                    Enabled                                       = $True
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
