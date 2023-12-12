# EXOOwaMailboxPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the unique name for the policy. The maximum length is 64 characters. | |
| **ActionForUnknownFileAndMIMETypes** | Write | String | The ActionForUnknownFileAndMIMETypes parameter specifies how to handle file types that aren't specified in the Allow, Block, and Force Save lists for file types and MIME types | `Allow`, `ForceSave`, `Block` |
| **ActiveSyncIntegrationEnabled** | Write | Boolean | The ActiveSyncIntegrationEnabled parameter specifies whether to enable or disable Exchange ActiveSync settings in Outlook on the web.  | |
| **AdditionalAccountsEnabled** | Write | Boolean | No description available. | |
| **AdditionalStorageProvidersAvailable** | Write | Boolean | The AdditionalStorageProvidersAvailable parameter specifies whether to allow additional storage providers (for example, Box, Dropbox, Facebook, Google Drive, Egnyte, personal OneDrive) attachments in Outlook on the web. | |
| **AllAddressListsEnabled** | Write | Boolean | The AllAddressListsEnabled parameter specifies which address lists are available in Outlook on the web. | |
| **AllowCopyContactsToDeviceAddressBook** | Write | Boolean | The AllowCopyContactsToDeviceAddressBook parameter specifies whether users can copy the contents of their Contacts folder to a mobile device's native address book when using Outlook on the web for devices. | |
| **AllowedFileTypes** | Write | StringArray[] | The AllowedFileTypes parameter specifies the attachment file types (file extensions) that can be saved locally or viewed from Outlook on the web. | |
| **AllowedMimeTypes** | Write | StringArray[] | The AllowedMimeTypes parameter specifies the MIME extensions of attachments that allow the attachments to be saved locally or viewed from Outlook on the web. | |
| **BlockedFileTypes** | Write | StringArray[] | The BlockedFileTypes parameter specifies a list of attachment file types (file extensions) that can't be saved locally or viewed from Outlook on the web. | |
| **BlockedMimeTypes** | Write | StringArray[] | The BlockedMimeTypes parameter specifies MIME extensions in attachments that prevent the attachments from being saved locally or viewed from Outlook on the web. | |
| **BookingsMailboxCreationEnabled** | Write | Boolean | No description available. | |
| **ChangeSettingsAccountEnabled** | Write | Boolean | No description available. | |
| **ClassicAttachmentsEnabled** | Write | Boolean | The ClassicAttachmentsEnabled parameter specifies whether users can attach local files as regular email attachments in Outlook on the web. | |
| **ConditionalAccessPolicy** | Write | String | The ConditionalAccessPolicy parameter specifies the Outlook on the Web Policy for limited access. For this feature to work properly, you also need to configure a Conditional Access policy in the Azure Active Directory Portal. | `Off`, `ReadOnly`, `ReadOnlyPlusAttachmentsBlocked` |
| **DefaultTheme** | Write | String | The DefaultTheme parameter specifies the default theme that's used in Outlook on the web when the user hasn't selected a theme. The default value is blank ($null). | |
| **DirectFileAccessOnPrivateComputersEnabled** | Write | Boolean | The DirectFileAccessOnPrivateComputersEnabled parameter specifies the left-click options for attachments in Outlook on the web for private computer sessions.  | |
| **DirectFileAccessOnPublicComputersEnabled** | Write | Boolean | The DirectFileAccessOnPrivateComputersEnabled parameter specifies the left-click options for attachments in Outlook on the web for public computer sessions. | |
| **DisableFacebook** | Write | Boolean | The DisableFacebook switch specifies whether users can synchronize their Facebook contacts to their Contacts folder in Outlook on the web. By default, Facebook integration is enabled. | |
| **DisplayPhotosEnabled** | Write | Boolean | The DisplayPhotosEnabled parameter specifies whether users see sender photos in Outlook on the web. | |
| **ExplicitLogonEnabled** | Write | Boolean | The ExplicitLogonEnabled parameter specifies whether to allow a user to open someone else's mailbox in Outlook on the web (provided that user has permissions to the mailbox). | |
| **ExternalImageProxyEnabled** | Write | Boolean | The ExternalImageProxyEnabled parameter specifies whether to load all external images through the Outlook external image proxy. | |
| **ExternalSPMySiteHostURL** | Write | String | The ExternalSPMySiteHostURL specifies the My Site Host URL for external users. | |
| **FeedbackEnabled** | Write | Boolean | The FeedbackEnabled parameter specifies whether to enable or disable inline feedback surveys in Outlook on the web. | |
| **ForceSaveAttachmentFilteringEnabled** | Write | Boolean | The ForceSaveAttachmentFilteringEnabled parameter specifies whether files are filtered before they can be saved from Outlook on the web. | |
| **ForceSaveFileTypes** | Write | StringArray[] | The ForceSaveFileTypes parameter specifies the attachment file types (file extensions) that can only be saved from Outlook on the web (not opened). | |
| **ForceSaveMimeTypes** | Write | StringArray[] | The ForceSaveMimeTypes parameter specifies the MIME extensions in attachments that only allow the attachments to be saved locally (not opened). | |
| **ForceWacViewingFirstOnPrivateComputers** | Write | Boolean | The ForceWacViewingFirstOnPrivateComputers parameter specifies whether private computers must first preview an Office file as a web page in Office Online Server (formerly known as Office Web Apps Server and Web Access Companion Server) before opening the file in the local application. | |
| **ForceWacViewingFirstOnPublicComputers** | Write | Boolean | The ForceWacViewingFirstOnPublicComputers parameter specifies whether public computers must first preview an Office file as a web page in Office Online Server before opening the file in the local application. | |
| **FreCardsEnabled** | Write | Boolean | The FreCardsEnabled parameter specifies whether the theme, signature, and phone cards are available in Outlook on the web. | |
| **GlobalAddressListEnabled** | Write | Boolean | The GlobalAddressListEnabled parameter specifies whether the global address list is available in Outlook on the web. | |
| **GroupCreationEnabled** | Write | Boolean | The GroupCreationEnabled parameter specifies whether Office 365 group creation is available in Outlook on the web. | |
| **InstantMessagingEnabled** | Write | Boolean | The InstantMessagingEnabled parameter specifies whether instant messaging is available in Outlook on the web. | |
| **InstantMessagingType** | Write | String | The InstantMessagingType parameter specifies the type of instant messaging provider in Outlook on the web. | `None`, `Ocs` |
| **InterestingCalendarsEnabled** | Write | Boolean | The InterestingCalendarsEnabled parameter specifies whether interesting calendars are available in Outlook on the web. | |
| **InternalSPMySiteHostURL** | Write | String | The InternalSPMySiteHostURL specifies the My Site Host URL for internal users. | |
| **IRMEnabled** | Write | Boolean | The IRMEnabled parameter specifies whether Information Rights Management (IRM) features are available in Outlook on the web. | |
| **ItemsToOtherAccountsEnabled** | Write | Boolean | No description available. | |
| **IsDefault** | Write | Boolean | The IsDefault switch specifies whether the Outlook on the web policy is the default policy that's used to configure the Outlook on the web settings for new mailboxes. | |
| **JournalEnabled** | Write | Boolean | The JournalEnabled parameter specifies whether the Journal folder is available in Outlook on the web. | |
| **LocalEventsEnabled** | Write | Boolean | The LocalEventsEnabled parameter specifies whether local events calendars are available in Outlook on the web. | |
| **LogonAndErrorLanguage** | Write | SInt32 | The LogonAndErrorLanguage parameter specifies the language that used in Outlook on the web for forms-based authentication and for error messages when a user's current language setting can't be read. A valid value is a supported Microsoft Windows Language Code Identifier (LCID). For example, 1033 is US English. | |
| **MessagePreviewsDisabled** | Write | Boolean | No description available. | |
| **NotesEnabled** | Write | Boolean | The NotesEnabled parameter specifies whether the Notes folder is available in Outlook on the web. | |
| **NpsSurveysEnabled** | Write | Boolean | The NpsSurveysEnabled parameter specifies whether to enable or disable the Net Promoter Score (NPS) survey in Outlook on the web. The survey allows uses to rate Outlook on the web on a scale of 1 to 5, and to provide feedback and suggested improvements in free text. | |
| **OneWinNativeOutlookEnabled** | Write | Boolean | The OneWinNativeOutlookEnabled parameter controls the availability of the new Outlook for Windows App. | |
| **OrganizationEnabled** | Write | Boolean | When the OrganizationEnabled parameter is set to $false, the Automatic Reply option doesn't include external and internal options, the address book doesn't show the organization hierarchy, and the Resources tab in Calendar forms is disabled. | |
| **OnSendAddinsEnabled** | Write | Boolean | The OnSendAddinsEnabled parameter specifies whether to enable or disable on send add-ins in Outlook on the web (add-ins that support events when a user clicks Send). | |
| **OutboundCharset** | Write | String | The OutboundCharset parameter specifies the character set that's used for outgoing messages in Outlook on the web. | `AutoDetect`, `AlwaysUTF8`, `UserLanguageChoice` |
| **OutlookBetaToggleEnabled** | Write | Boolean | The OutlookBetaToggleEnabled parameter specifies whether to enable or disable the Outlook on the web Preview toggle. The Preview toggle allows users to try the new Outlook on the web experience. | |
| **OWALightEnabled** | Write | Boolean | The OWALightEnabled parameter controls the availability of the light version of Outlook on the web. | |
| **PersonalAccountsEnabled** | Write | Boolean | No description available. | |
| **PersonalAccountCalendarsEnabled** | Write | Boolean | The PersonalAccountCalendarsEnabled parameter specifies whether to allow users to connect to their personal Outlook.com or Google Calendar in Outlook on the web. | |
| **PhoneticSupportEnabled** | Write | Boolean | The PhoneticSupportEnabled parameter specifies phonetically spelled entries in the address book. This parameter is available for use in Japan. | |
| **PlacesEnabled** | Write | Boolean | The PlacesEnabled parameter specifies whether to enable or disable Places in Outlook on the web. Places lets users search, share, and map location details by using Bing. | |
| **PremiumClientEnabled** | Write | Boolean | The PremiumClientEnabled parameter controls the availability of the full version of Outlook Web App. | |
| **PrintWithoutDownloadEnabled** | Write | Boolean | The PrintWithoutDownloadEnabled specifies whether to allow printing of supported files without downloading the attachment in Outlook on the web. | |
| **ProjectMocaEnabled** | Write | Boolean | The ProjectMocaEnabled parameter enables or disables access to Project Moca in Outlook on the web. | |
| **PublicFoldersEnabled** | Write | Boolean | The PublicFoldersEnabled parameter specifies whether a user can browse or read items in public folders in Outlook Web App. | |
| **RecoverDeletedItemsEnabled** | Write | Boolean | The RecoverDeletedItemsEnabled parameter specifies whether a user can use Outlook Web App to view, recover, or delete permanently items that have been deleted from the Deleted Items folder. | |
| **ReferenceAttachmentsEnabled** | Write | Boolean | The ReferenceAttachmentsEnabled parameter specifies whether users can attach files from the cloud as linked attachments in Outlook on the web. | |
| **RemindersAndNotificationsEnabled** | Write | Boolean | The RemindersAndNotificationsEnabled parameter specifies whether notifications and reminders are enabled in Outlook on the web. | |
| **ReportJunkEmailEnabled** | Write | Boolean | The ReportJunkEmailEnabled parameter specifies whether users can report messages to Microsoft or unsubscribe from messages in Outlook on the web.  | |
| **RulesEnabled** | Write | Boolean | The RulesEnabled parameter specifies whether a user can view, create, or modify server-side rules in Outlook on the web. | |
| **SatisfactionEnabled** | Write | Boolean | The SatisfactionEnabled parameter specifies whether to enable or disable the satisfaction survey. | |
| **SaveAttachmentsToCloudEnabled** | Write | Boolean | The SaveAttachmentsToCloudEnabled parameter specifies whether users can save regular email attachments to the cloud. | |
| **SearchFoldersEnabled** | Write | Boolean | The SearchFoldersEnabled parameter specifies whether Search Folders are available in Outlook on the web. | |
| **SetPhotoEnabled** | Write | Boolean | The SetPhotoEnabled parameter specifies whether users can add, change, and remove their sender photo in Outlook on the web. | |
| **SetPhotoURL** | Write | String | The SetPhotoURL parameter controls where users go to select their photo. Note that you can't specify a URL that contains one or more picture files, as there is no mechanism to copy a URL photo to the properties of the users' Exchange Online mailboxes. | |
| **ShowOnlineArchiveEnabled** | Write | Boolean | No description available. | |
| **SignaturesEnabled** | Write | Boolean | The SignaturesEnabled parameter specifies whether to enable or disable the use of signatures in Outlook on the web. | |
| **SkipCreateUnifiedGroupCustomSharepointClassification** | Write | Boolean | The SkipCreateUnifiedGroupCustomSharepointClassification parameter specifies whether to skip a custom SharePoint page during the creation of Office 365 Groups in Outlook web app. | |
| **TeamSnapCalendarsEnabled** | Write | Boolean | The TeamSnapCalendarsEnabled parameter specifies whether to allow users to connect to their personal TeamSnap calendars in Outlook on the web. | |
| **TextMessagingEnabled** | Write | Boolean | The TextMessagingEnabled parameter specifies whether users can send and receive text messages in Outlook on the web. | |
| **ThemeSelectionEnabled** | Write | Boolean | The ThemeSelectionEnabled parameter specifies whether users can change the theme in Outlook on the web. | |
| **UMIntegrationEnabled** | Write | Boolean | The UMIntegrationEnabled parameter specifies whether Unified Messaging (UM) integration is enabled in Outlook on the web. | |
| **UseGB18030** | Write | Boolean | The UseGB18030 parameter specifies whether to use the GB18030 character set instead of GB2312 in Outlook on the web. | |
| **UseISO885915** | Write | Boolean | The UseISO885915 parameter specifies whether to use the character set ISO8859-15 instead of ISO8859-1 in Outlook on the web. | |
| **UserVoiceEnabled** | Write | Boolean | The UserVoiceEnabled parameter specifies whether to enable or disable Outlook UserVoice in Outlook on the web. Outlook UserVoice is a customer feedback area that's available in Office 365. | |
| **WacEditingEnabled** | Write | Boolean | The WacEditingEnabled parameter specifies whether to enable or disable editing documents in Outlook on the web by using Office Online Server (formerly known as Office Web Apps Server and Web Access Companion Server).  | |
| **WacExternalServicesEnabled** | Write | Boolean | The WacExternalServicesEnabled parameter specifies whether to enable or disable external services when viewing documents in Outlook on the web (for example, machine translation) by using Office Online Server. | |
| **WacOMEXEnabled** | Write | Boolean | The WacOMEXEnabled parameter specifies whether to enable or disable apps for Outlook in Outlook on the web in Office Online Server. | |
| **WacViewingOnPrivateComputersEnabled** | Write | Boolean | The WacViewingOnPrivateComputersEnabled parameter specifies whether to enable or disable web viewing of supported Office documents private computer sessions in Office Online Server (formerly known as Office Web Apps Server and Web Access Companion Server). By default, all Outlook on the web sessions are considered to be on private computers. | |
| **WacViewingOnPublicComputersEnabled** | Write | Boolean | The WacViewingOnPublicComputersEnabled parameter specifies whether to enable or disable web viewing of supported Office documents in public computer sessions in Office Online Server.  | |
| **WeatherEnabled** | Write | Boolean | The WeatherEnabled parameter specifies whether to enable or disable weather information in the calendar in Outlook on the web. | |
| **WebPartsFrameOptionsType** | Write | String | The WebPartsFrameOptionsType parameter specifies what sources can access web parts in IFRAME or FRAME elements in Outlook on the web. | `None`, `SameOrigin`, `Deny` |
| **Ensure** | Write | String | Specify if the OWA Mailbox Policy should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures OWA Mailbox Policies in Exchange Online.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Recipient Policies, View-Only Configuration, Mail Recipients

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
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOOwaMailboxPolicy 'ConfigureOwaMailboxPolicy'
        {
            Name                                                 = "OwaMailboxPolicy-Default"
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
    }
}
```

