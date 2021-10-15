# Change log for Microsoft365DSC

1.21.1013.1

* IntuneDeviceCompliancePolicyAndroidDeviceOwner
  Initial release;
* MISC
  * Added support for PowerShell 7 and above;
* DEPENDENCIES
  * Updated Microsoft.PowerApps.Administration.PowerShell to version 2.0.138;
  * Updated MSCloudLoginAssistant to version 1.0.73;
  * Updated PnP.PowerShell to version 1.8.0;

1.21.1006.3

* BREAKING CHANGES

* AADApplication
  * Removed support for the Oauth2AllowImplicitFlow, SamlMetadataUrl and
    Oauth2AllowUrlPathMatching properties;
* AADMSGroup
  * Renamed resource to AADGroup;
* AADMSGroupLifecyclePolicy
  * Renamed resource to AADGroupLifecyclePolicy;
* AADPolicy
  * Replaced resource by the new AADTokenLifetimePolicy one;
* DEPENDENCIES
  * Added dependency on Microsoft.Graph.Applications;
  * Added dependency on Microsoft.Graph.Groups;
  * Added dependency on Microsoft.Graph.Identity.DirectoryManagement;
  * Added dependency on Microsoft.Graph.Identity.SignIns;
  * Removing dependency on AzureADPreview;
  * Updated Microsoft.PowerApps.Administration.PowerShell to version 2.0.137;
  * Updated MicrosoftTeams to version 2.6.0;
  * Updated MSCloudLoginAssistant to version 1.0.72;
* MISC
  * Renamed the GlobalAdminAccount parameter to Credential across all resources;
  * Revamped entire Azure AD Workload to leverage Microsoft Graph;
  * New -LaunchWebUI switch for Export-M365DSCConfiguration will launch the
    new web-based UI. The old GUI has been removed.
  * Removal of the -Quiet switch for the Export-M365DSCConfiguration cmdlet;
  * Renaming the ComponentsToExtract property from the Export-M365DSCConfiguration
    cmdlet to Components;

# 1.21.922.1

* AADApplication
  * Fix issue where export will only export 100 apps

* EXOSafeLinksPolicy
  * Added support for CustomNotificationText, EnableOrganizationBranding, and
    UseTranslatedNotificationText properties;
* SPOSite
  * Fixed issue when deleting site and confirm parameter
* DEPENDENCIES
  * Updated MSCloudLoginAssistant to version 1.0.68;

# 1.21.915.1

* EXOAntiPhishPolicy
  * Added support for EnableFirstContactSafetyTips & EnableViaTag;
* EXOAtpPolicyForO365
  * Added support for AllowSafeDocsOpen;
* EXOHostedContentFilterPolicy
  * Added support for HighConfidencePhishAction;
* EXOHostedOutboundSpamFilterPolicy
  Added support for RecipientLimitInternalPerHour, RecipientLimitPerDay,
  RecipientLimitExternalPerHour, ActionWhenThresholdReached & AutoForwardingMode;
* EXOHostedOutboundSpamFilterRule
  Initial release;
* IntuneAppConfigurationPolicy
  * Added support for the CustomSettings property;
* IntuneDeviceCompliancePolicyWindows10
  * Removed the App Secret and Application ID from the output;
  * Added DefenderEnabled to the Resource;
* IntuneDeviceConfigurationWindows10
  * Initial release;
* DEPENDENCIES;
  * Updated Microsoft.Graph.Authentication to version 1.7.0;
  * Added dependency on Microsoft.Graph.DeviceManagement;
  * Added dependency on Microsoft.Graph.DeviceManagement.Administration;
  * Added dependency on Microsoft.Graph.DeviceManagement.Enrolment;
  * Added dependency on Microsoft.Graph.Devices.CorporateManagement;
  * Updated Microsoft.Graph.Planner to version 1.7.0;
  * Updated Microsoft.Graph.Teams to version 1.7.0;
  * Updated Microsoft.PowerApps.Administration.PowerShell to version 2.0.136;
  * Updated MSCloudLoginAssistant to version 1.0.67;

# 1.21.908.1

* PPTenantSettings
  * Initial Release;
* DEPENDENCIES;
  * Updated MSCloudLoginAssistant to version 1.0.64;
* MISC
  * Fixing duplicate teams names in reports;

# 1.21.901.1

* DEPENDENCIES;
  * Updated Microsoft.PowerApps.Administration.PowerShell to version 2.0.133;
  * Updated MicrosoftTeams to version 2.5.1;
* MISC
  * Additional display alignment fixes for Export;

# 1.21.825.1

* SPOTenantSettings
  * Added the DisabledWebpartIds & ConditionalAccessPolicy properties;
* DEPENDENCIES;
  * Updated AzureADPreview to version 2.0.2.138;
  * Updated Microsoft.PowerApps.Administration.PowerShell to version 2.0.131;
  * Updated Microsoft.Teams to version 2.5.0;
* MISC
  * Additional display alignment fixes for Export;

# 1.21.804.1

* SCDLPComplianceRule
  * Fixed issue where SCDLPCompliance rule failed when using senstitivy labels;
* DEPENDENCIES;
  * Updated MSCloudLoginAssistant to version 1.0.62;
* MISC
  * Added support for ApplicationSecret in SPO resources;
  * Revamped the entire display from an Export;

# 1.21.728.1

* DEPENDENCIES;
  * Updated MSCloudLoginAssistant to version 1.0.59;
  * Updated PnP.PowerShell to version 1.7.0;
* MISC
  * Added support for Service Principal Authentication for all Intune resources;
  * Deprecated GUI and added reference to new Web based GUI;

# 1.21.721.1

* AADMSGroup
  * Fixed an issue where the Visibility parameter was never properly returned
    which always threw a detected drift when used.
* EXOJournalRule
  * Initial Release.
* SPOSite
  * Fixed the StorageQuotaWarningLevel value returned by the Get-TargetResource
    function.

# 1.21.714.1

* EXOHostedContentFilterPolicy
  * Fixed issues with null values falsely detected as drifts;
    ISSUE #1165
* DEPENDENCIES
  * Removed dependency on Microsoft.Graph.Groups.Planner;
  * Updated Microsoft.Graph.Teams to version 1.6.1;
  * Updated MSCloudLoginAssistant to version 1.0.54;
* MISC
  * Allowed for Desired and Current values to be captured by the Telemetry engine
    if an organization is using a custom App Insights account;
    ISSUE #1222

# 1.21.707.1

* EXODkimSigningConfig
  * Change the logic to remove an entry to disable it instead since the
    cmdlet didn't exist to remove it.
    ISSUE #1253
* EXOHostedContentFilterPolicy
  * Fixed the value type for the senders addresses, regions and domains;
    ISSUE #1165
* EXOOutboundConnector
  * Fixed the creation logic to include ValidationRecipients;
    ISSUE #1165
* EXOSharedMailbox
  * Improved speed of extraction and removed warning about maximum 1,000
    items retrieved;
* DEPENDENCIES
  * Updated Microsoft.PowerApps.Administration.PowerShell to 2.0.127;
* MISC
  * Delta Report - Fixes to compare null arrays properly and report as
    a discrepancy.
    ISSUES #1178 & #1249

# 1.21.630.1

* O365User
  * Fix where export was throwing an error about an empty DSCBlock
    ISSUE #1275;
* SPOTenantSettings
  * Added support for specifying MarkNewFilesSensitiveByDefault

# 1.21.616.1

* SPOSiteAuditSettings
  * Fixed issue with Export where property Ensure was added
    when an access forbidden error was encountered;
* DEPENDENCIES
  * Updated Microsoft.Graph.Authentication to version 1.6.0;
  * Updated Microsoft.Graph.Planner to version 1.6.0;
  * Updated Microsoft.Graph.Teams to version 1.6.0;

# 1.21.609.2

* Fixed dependency on Microsoft.Graph.Authentication for
  version 1.5.0.

# 1.21.609.1

* TeamsUpgradePolicy
  * Fixes to how we are retrieving users assigned to the
    Global Upgrade Policy.
* DEPENDENCIES
  * Updated ExchangeOnlineManagement to version 2.0.5;
  * Updated Microsoft.Graph.Planner to version 1.5.0;
  * Updated Microsoft.Graph.Teams to version 1.5.0;
  * Updated Microsoft.PowerApps.Administration.PowerShell
    to version 2.0.126;
  * Updated PnP.PowerShell to version 1.6.0;

# 1.21.602.1

* AADMSGroups
  * Fix for the export where the MailNickName was being prompted;
* EXOManagementRole
  * BREAKING: Now requires the Parent property as Mandatory;
* TeamsChannel
  * Fixed an issue where content was dedup and boolean
    values were appended to the exported content;
* TeamsUpgradePolicy
  * Improved performance retrieving users assigned to policy;
* MISC
  * Fix for Teams authentication. Improvements on session
    reuse.

# 1.21.526.2

*  EXOSafeAttachmentRule
  * Fixed issue #1213 Policy X already has rule Y associated with it
    if rule exists already
* MSFT_IntuneDeviceCompliancePolicyAndroid
  * New resource
* MSFT_IntuneDeviceCompliancePolicyAndroidWorkProfile
  * New resource
* MSFT_IntuneDeviceCompliancePolicyMacOS
  * New resource
* MSFT_IntuneDeviceCompliancePolicyiOs
  * New resource
* EXOTransportRule
  * Fix #1230 Changed ExceptIfSenderInRecipientList to array

# 1.21.519.2

* AzureADRoleDefinition
  * Fix an issue where deprecated roles were not increasing
    the index which resulted in an incorrect count being
    displayed during the extraction.
* EXORoleAssignmentPolicy
  * Added missing ErrorAction value in the Export;
* TeamsTenantDialPlan
  * Fixed issue around normalization rules export;
* SPOTenantSettings
  * Fix issue with typo and dup property issue #1219
* MISC
  * Forces a Global load of the new MicrosoftTeams module for
    Teams resources;

#1.21.519.1

* TeamsClientConfiguration
  * Fixed an issue where the RestrictedSenderList was not properly
    being converted to a comma separated string.
    Issue #1191
* DEPENDENCIES
  * Updated AzureADPreview to version 2.0.2.136;

# 1.21.512.1

* EXOOfflineAddresBook
  * Fixed issue in Set-TargetResource where ConfiguredAttributes
    was passed and resulted in an error.
* SCDLPComplianceRule
  * Added several new parameters
  * Fixed several bugs on extract

# 1.21.505.1

* EXOTransportRule
  * Adding ExceptIfSCLOver and SCLOver.
  * Fixes SubjectOrBodyContainsWords parameter not being an array.
  * Fixes DateTime formating on ExpiryDate and ActivationDate

# 1.21.428.2

* EXOTransportRule
  * Fixed typo in accepted value for ApplyHtmlDisclaimerLocation;
* IntuneAppConfigurationPolicy
  * Revamp of Telemetry;
  * Using shorter cmdlets names;
* IntuneDeviceCompliancePolicyAndroid
  * Initial Release;
* IntuneDeviceCompliancePolicyAndroidWorkProfile
  * InitialRelease
* IntuneDeviceCompliancePolicyiOs
  * Using shorter cmdlet names;
* IntuneDeviceConfigurationPolicyiOS
  * Using shorter cmdlet names;
* IntuneDeviceEnrollmentPlatformRestriction
  * Revamp of Telemetry;
  * Using Shorter cmdlet names;

# 1.21.421.2

* MISC
  * Updated the SkipModuleReload logic for a dozen of EXO modules
    which were failing authentication;

# 1.21.421.1

* AADConditionalAccessPolicy
  * Fix to allow 'undefined' as a value for multiple parameters;
* EXOTransportRule
  * Fixed schema to support Service Principal Auth;
* TeamsChannelTab
  * Fixed typo in parameter 'TeamId';
* MISC
  * Refactor of all EXO resources to fixes for Set-TargetResource
    functions where Service Principal was used to authenticate;
  * Refactored connections across all resources to help with
    Telemetry regarding what auth method users are leveraging.

# 1.21.414.2

* AADConditionalAccessPolicy
  * Fixed an issue with the default values for device states;
* EXOHostedContentFilterPolicy
  * Fixed issue where EndUserSpamNotificationCustomFromName was
    not properly returned from the Get-TargetResource function;
* EXOTransportRule
  * New resource;
* O365AdminAuditLogConfig
  * Fixed issue where the Set-TargetResource stopped being
    executed if an error was encountered;
* TeamsTeam
  * Fix format issue with owner issue # 1143
* DEPENDENCIES
  * Updated AzureADPreview to version 2.0.2.134;
  * Updated Microsoft.Graph.Authentication to version 1.4.2;
  * Updated Microsoft.Graph.Planner to version 1.4.2;
  * Updated Microsoft.Graph.Teams to version 1.4.2;
  * Updated Microsoft.PowerApps.Administration.PowerShell to version
    2.0.112;
  * Updated MSCloudLoginAssistant to version 1.0.51;
  * Updated PnP.PowerShell to version 1.5.0;

# 1.21.407.1

* AADConditionalAccessPolicy
  * BREAKING: Renamed the 'includeDeviceStates' and 'excludeDeviceStates'
    parameters to 'includeDevices' and 'excludeDevices';
* TeamsMeetingPolicy
  * The Set-CsTeamsMeetingPolicy would fail if recording settings are
    changed while the AllowCloudRecording is set to false;
* MISC
  * Fixed issue in most EXO resources where AzureAD App information
    was not returned by the Get-TargetResource function;

# 1.21.331.1

* AADApplication
  * Added support for API Permissions;
* EXOSharedMailbox
  * Improved how we are retrieving all shared mailboxes in the
    Export-TargetResource function.
* ODSettings
  * Fixed and issue with ExcludedFileExtensions;
* SCDLPComplianceRule
  * Fixed issue where only the first SIT Action was exported;
* SPOSiteDesign
  * Added support for GrouplessTeamSite web template.
* SPOSiteScript
  * Fixed issue where an existin site script could not be updated.
  * Made parameter GlobalAdminAccount in Get-TargetResource
    optional.
* SPOTheme
  * Fixed issue where removal of a theme would throw an error.
  * Corrected variable name to properly show the theme name in verbose message
    when removing a theme.
* MISC
  * Fixed issue with ODSettings and ExcludedFileExtensions

# 1.21.317.1

* DEPENDENCIES
  * Updated Exchange Management to version 2.0.4 (REDO);
  * Updated MSCloudLoginAssistant to version 1.0.50;
* MISC
  * Fixed issue when using CertificatePath and CertificatePassword
    for SPO resource;

# 1.21.224.1

* DEPENDENCIES
  * Rolled-back ExchangeOnlineManagement to 2.0.3;

# 1.21.217.1

* SPOSite
  * Fixed an issue related to new cmdlets in PnP.PowerShell;
* DEPENDENCIES
  * Updated ExchangeOnlineManagement to 2.0.4;
  * Updated PNP.PowerShell to 1.3.0;

# 1.21.203.1

* SPOSiteDesignRights
  * Fixed an issue that was preventing this resource from
    being exported;
* SPOBrowserIdleSignout
  * Initial Release;
* TeamsTenantDialPlan
  * Fixed an issue with the way Voice Normalization Rules were handled;
* MISC
  * Fix to the Delta Report Generator to properly handle TeamsPSTNUsage;
  * Fixed various Export Verbose format issues;
* DEPENDENCIES
  * Updated Microsoft.Graph.Authentication to version 1.3.1;
  * Updated Microsoft.Graph.Planner to version 1.3.1;
  * Updated Microsoft.Graph.Teams to version 1.3.1;
  * Updated MSCloudLoginAssistant to version 1.0.48;

# 1.21.127.1

* AADNamedLocation
  * Initial Release;
* DEPENDENCIES
  * Updated PnP.PowerShell to version 1.2.0;
  * Updated Microsoft.PowerApps.Administration.PowerShell to
    1.0.208;

# 1.21.120.1

* DEPENDENCIES
  * Updated MSCloudLoginAssistant to version 1.0.45;
  * Replaced the SharePointPnPPowerShellOnline dependency by the new
    PnP.PowerShell core module;

# 1.21.113.1

* AADTenantDetails
  * Fixes an issue where the Set would fail if Service Principal
   was used.
   (Issue [#1002](https://github.com/microsoft/Microsoft365DSC/issues/1002))
* AADRoleDefinition
  * Filters out role definitions without any assigned permissions.
    Fixes Issue #1007;
* DEPENDENCIES
  * Updated Microsoft.PowerApps.Administration.PowerShell
    to 2.0.104;

# 1.20.1223.1

* SPOHubSite
  * Changed Export logic to make the url parameterized
  * Updated Get method to prevent throwing an exception
    when the specified site doesn't exist
* SPOSite
  * Updated logic to not process the HubUrl parameter
    when this is equal to the Url parameter.
  * Updated export logic to not export the HubUrl
    parameter when this is equal to the Url parameter.
  * Fixed issue with incorrectly applying the LocaleId
* SPOSiteAuditSettings
  * Changed Export logic to make the url parameterized
* SPOSiteGroup
  * Changed Export logic to make the url parameterized
  * Updated logic to output more explainable troubleshooting
    messages
* M365DscReverse
  * Added the GlobalAccount Parameter to the example
    that is outputted after using the Export GUI

# 1.20.1216.1

* AADConditionalAccessPolicy
  * Initial Release;
* EXOSafeLinksRule
  * Fixed typo in a try/catch clause;
* O365User
  * Added support for removing existing users with
    Ensure = 'Absent';
* TeamsChannelTab
  * Initial Release;

# 1.20.1209.1

* IntuneAppProtectionPolicyiOS
  * Initial Release;
* IntuneDeviceCompliancePolicyiOS
  * Initial Release;
* IntuneDeviceConfigurationPolicyiOS
  * Initial Release;
* IntuneDeviceEnrollmentPlatformRestriction
  * Initial Release;
* IntuneDeviceEnrollmentLimitRestriction
  * Initial Release;
* TeamsTenantDialPlan
  * Performance Improvements: retrieve all Voice Normalization
    Rule at once and then iterated through them instead of
    retrieving them for every instance.
* DEPENDENCIES
  * Upgraded ExchangeOnlineManagement to version 2.0.3;
  * Upgraded Microsoft.Graph.Authentication to version 1.2.0;
  * Upgraded Microsoft.Graph.Planner to version 1.2.0;
  * Upgraded SharePointPnPPowerShellOnline to version
    3.28.2012.0;

## 1.20.1202.1

* EXOOwaMailboxPolicy
  * Fixed an issue trying to remove a policy;
* TeamsMessagingPolicy
  * Added AllowUserEditMessage property.
* TeamsMeetingPolicy
  * Added 'OrganizerOnly' as a support value for property
    AutoAdmittedUsers.
  * Temporarly removed the use of AllowAnonymousUsersToDialOut
    since it is currently disabled on the API side.
* EXPORT
  * Fixed an issue where an Export using the -Workloads
    parameter with a Service Principal did not export
    any resource;
* DEPENDENCIES
  * Upgrade AzureADPreview to version 2.0.2.129;

## 1.20.1125.1

* AADRoleDefinition
  * Initial Release;
* O365User
  * Fixes an issue where only the first O365User instance
    extracted had the PSCredential Password property set
    correctly;
* TeamsMeetingPolicy
  * Added the AllowBreakoutRooms, TeamsCameraFarEndPTZMode
    & AllowMeetingReactions parameters;
* DEPENDENCIES
  * MSCloudLoginAssistant Updated to 1.0.42;
  * Microsoft.PowerApps.Administration.PowerShell Updated
    to 2.0.99;
* MISC
  * Moved the check for new version of module into the
    Export-M365DSCConfiguration function for performance
    improvements;

## 1.20.1118.1

* EXOMalwareFilterPolicy
  * Fix an issue when the CustomFromAddress is empty;
    (Issue #901)
* EXORemoteDomain
  * Fixed an issue where only non-null parameters are
    used in the Set-TargetResource resource;
    (Issue #898)
* SCRetentionEventType
  * Initial Release;
* SPOSiteScript
  * BREAKING CHANGE: Title is now the primary key for the
    resource and Service Principal is now supported for
    authentication.
* MODULES
  * M365DSCStringEncoding
    New resource to handle encoding issues in exported content;
    (Issue #904)
  * M365DSCLogEngine
    Added Export-M365DiagnosticData function to export diagnostic
    information to a Zip file.

## 1.20.1111.1

* AADPolicy
  Initial Release;
* Fixes an issue with SCRetentionCompliancePolicy where
  the wrong parameter sets was being passed for creation.
  (Issue #890)

## 1.20.1104.1

* AADMSGroup
  * Added parameter IsAssignableToRole Issue #879
  * Fixed issue on Set Issue #863
* EXOHostedContentFilterPolicy
  * Deprecated ZapEnabled property and added PhishZapEnabled
    and SpamZapEnabled instead.
* MISC
  * Added checks for mandatory Authentication parameters before
    attempting an Export.
  * Deprecated the Assert-M365DSCTemplate cmdlet;
  * Added Telemetry for version of PowerShell used;
  * Added a timeout on new version check from the
    PowerShell Gallery;
  * Fixed Unit Test stubs;

## 1.20.1028.1

* EXOOutboundConnector
  * Fixed issue #821;
* O365OrgCustomizationSetting
  * Fixes an issue where the resource was not being exported;
* O365User
  * Added additional information in the error log for when
    we try to set an invalid license
* ODSettings
  * Removed AD group guid dependency issue # 862
* SPOTenantSettings
  * Parameter RequireAcceptingAccountMatchInvitedAccount
    is now deprecated (Issue #864)
* SPOSharingSettings
  * Fixed issue # 855
  * Fixed issue # 866 changed domains to array
  * Fixed issue where trying to set anonymous link types if
    sharing not properly configured issue #865
* SPOTheme
  * Fixed issue where Palette was not being properly extracted as
    an array of CIMInstances.
* TeamsTeam
  * Added support for visibility HiddenMembership
* MODULES
  * M365DSCUtil
    * Fixed an issue where function Test-M365DSCObjectHasProperty was missing
    (Issue #861)
  * M365DSCReverse
    * Fixed an issue where passing in the file name and using the GUI for
      extraction did not store the file at the specified location (Issue #810)
    * Fixed and issue where the -GenerateInfo parameter would always generate
      a link to the same resource.
    * Added current version module in the Export file.
* MISC
  * Added Authentication Type used to the Telemetry Engine.
* DEPENDENCIES
  * AzureADPreview Updated to 2.0.2.119
  * DSCParser Updated to 1.3.0.0
  * Microsoft.Graph.Authentication Updated to 1.1.0
  * Microsoft.Graph.Planner Updated to 1.1.0
  * Microsoft.PowerApps.Administration.PowerShell Updated
    to 2.0.96;

## 1.20.1021.1

* AADTenantDetails
  * Fixed issue where IsSingleInstance was not returned from
    the Get-TargetResource method;
* MISC
  * Fix to how Telemetry is retrieving module version;
  * Added additional error troubleshooting information
    to telemetry (dependencies version).

## 1.20.1016.1

* Fixed a permissions issue with the
  Install-M365DSCDevBranch cmdlet (Issue #699 & #826)
* DEPENDENCIES
  * MSCloudLoginAssistant Updated to 1.0.41;
  * SharePointPnPPowerShellOnline Updated to 3.26.2010.0;
* MISC
  * Improved Error log to include StackTrace for additional
    info to help troubleshooting errors.

## 1.20.1014.1

* TeamsVoiceRoute
  * Initial Release

## 1.20.1007.1

* TeamsCallingPolicy
  * Added new supported properties;
* TeamsMeetingPolicy
  * Added new supported properties;
* TeamsTeam
  * Added new supported properties;

## 1.20.930.1

* IntuneAppConfigurationPolicy
  * Initial Release;
* DEPENDENCIES
  * Rolled back ExchangeOnlineManagement to 2.0.1
  * Microsoft.PowerApps.Administration.PowerShell updated
    to 2.0.85;
  * Microsoft.Graph.Authentication updated to 1.0.1;
  * Microsoft.Graph.Groups.Planner updated to 1.0.1;
* MISC
  * Refactored error handling to various EXO resources;
  * Renamed method Test-Microsoft365DSCParameterState to
    Test-M365DSCParameterState to align with naming standard;
  * Fixed issue #777 with export of SCDLPComplianceRule;

## 1.20.923.1

* IntuneDeviceCategory
  * Initial Release;
* SPOSite
  * Fixed an issue where updating a site's properties
    would throw an error complaining about the object
    not being in a correct state.
* DEPENDENCIES
  * AADPreview Updated to 2.0.2.117;
  * ExchangeOnlineManagement Updated to 2.0.3;
  * MSCloudLoginAssistant Updated to 1.0.40;
  * ReverseDSC Updated to 2.0.0.7;
* Misc
  * Removed EncryptionTemplateID from SCSensitivityLabel (Issue #758)
  * Added AzureAD app support SPOSiteDesign
  * Added possibility to provide a custom header to Blueprint
    assessment and delta reports.

## 1.20.916.1

* AADServicePrincipal
  * Initial Release (Issue #492)
* EXOAvailabilityAddressSpace
  * Fixed an issue where if the user didn't have proper permissions
    the entire Export process would stop;
* EXOAvailabilityConfig
  * Fixed an issue where if the user didn't have proper permissions
    the entire Export process would stop;
* EXOEmailAddressPolicy
  * Fixed an issue where if the user didn't have proper permissions
    the entire Export process would stop;
* DEPENDENCIES
  * MicrosoftTeams Updated to 1.1.6;
  * MSCloudLoginAssistant Updated to 1.0.38;
  * Updated Microsoft.PowerApps.Administration.PowerShell to 2.0.81;
* MISC
  * Fixed issue with warning about unsupported resources in the
    Export mode based on authentication selected.
  * Fixes an issue in the Install-M365DSCDevBranch function
    where if the manifest file had a leading 0 in the version
    number (e.g. 1.20.0902.1), it would create the folder as
    a version with the '0' where the Gallery trims it.
    (Issue #685)

## 1.20.909.1

* EXOApplicationAccessPolicy
  * Added some error handling around the
    Get-ApplicationAccessPolicy cmdlet
    (Issue #702);
*EXOSharedMailbox
  * Fixed an issue where Aliases were not properly removed
    (Issue #749);
* TeamsCallingPolicy
  * Added support for the AllowWebPSTNCalling and Description
    properties;
* TeamsChannel
  * Fixed an error in the Export when trying to connect using
    only an Azure AD Application without any credentials
    (Issue #754);
* TeamsClientConfiguration
  * Added support for the AllowEgnyte property
  (Issue #744);
* TeamsUser
  * Fixed an issue where for large tenants the Export could
    failed due to a percentage of completion greater than
    100% for the Write-Progress
    (Issue #722);
* MISC
  * Fixed an issue where the OD checkbox was always disabled
    in the GUI;
  * Changed the logic of the Unselect All button in the GUI
    so that it doesn't unselect the authentication checkboxes;
  * Fixed an issue where SPOHubSite was left selected in the
    Export GUI even when unselecting the entire SPO Workload
    (Issue #735);
  * Fixed an issue where if no Destination Path was provided
    after an export, it would fail. It now defaults to the
    current location
    (Issue #698);
  * Fixed issue SCSensitivityLabel on EncryptionRightsDefinitions parameters
    format (Issue #758)
* DEPENDENCIES
  * MSCloudLoginAssistant Updated to 1.0.34;
  * Microsoft.PowerApps.Administration.PowerShell Updated to 2.0.77;
  * SharePointPnPPowerShellOnline Updated to 3.25.2009.1;

## 1.20.902.1

* O365User
  * Fixed an issue where we were trying to assign an empty
    license to a user if an empty array was passed for
    LicenseAssignment.
* SCComplianceSearchAction
  * Added 'Preview' as a supported value for Action;
* ReverseDSC
  * Fixed an issue where a newline was missing in the
    credentials section when a certificate password was
    specified;
* MISC
  * Added a new Assert-M365DSCBlueprint function to generate
    discrepency report between export of tenant and a BluePrint;
* Metadata
  * Updated DSCParser Module to version 1.2.0.0;
  * Updated Microsoft.Graph.Authentication Module to version
    0.9.1;
  * Updated Microsoft.Graph.Groups.Planner Module to version
    0.9.1;
  * Updated Microsoft.Graph.Identity.ConditionalAccess Module
    to version 0.9.1;
  * Updated Microsoft.Graph.Planner Module to version
    0.9.1;
  * Updated Microsoft.PowerApps.Administration.PowerShell Module
    to version 0.9.1;
  * Updated SharePointPnPPowerShellOnline Module to version
    3.24.2008.1;

## 1.20.805.1

* EXOAvailabilityConfig
  * Fixed an issue with the Test-TargetResource where if a full
    username (with '@') was specified for the OrgWideAccount, it
    would always return false;
* EXOMobileDeviceMailboxPolicy
  * Fixed an error where if no MinPasswordLength was specified
    the Set-TargetResource threw n error trying to create a new
    policy;
* EXOInboundConnector
  * Fixed an issue where ResourceName was null during the export;
* EXOOutboundConnector
  * Fixed an issue where ResourceName was null during the export;
* ODSettings
  * Fixed an issue where the GrooveBlockOption setting was never
    set properly;
* SCSensitivityLabel
  * Added new parameters

## 1.20.730.2

* AADMSGroup
  * Fixed an issue where if GroupID was not passed, we could end up
    with duplicate teams.
* MISC
  * If a newer version of the module is available in the PowerShell
    Gallery, a notification will be displayed to the user;

## 1.20.730.1

* AADApplication
  * Removed the ObjectId parameter from the list of parameters
    checked in the Test-TargetResource;
* AADGroupsSettings
  * Fixed an issue where the values returned by Get-TargetResource were
    always set to true due to an invalid cast;
* O365User
  * Fixed an issue where no licenses specified resulted in an error;
* Metadata
  * Updated MSCloudLoginAssistant Module to version 1.0.32;

## 1.20.723.1

* MISC
  * Update to the Telemetry engine to capture information about tenant;

## 1.20.722.1

* AADApplication
  * Fix an issue where a new AzureAD Application was not created
    if ObjectId was speficied;
* O365User
  * Fixed an issue where the PasswordNeverExpires value returned
    was incorrect;
* SPOAPP
  * Added property Path as a key for the SPOApp resource to
    prevent conflict where two solutions could have the same
    name;
* MISC
  * Renamed the event log to M365DSC to avoid journal conflicts;
* Metadata
  * Updated Microsoft.Graph.Authentication module version to 0.7.1;
  * Updated Microsoft.PowerApps.Administration.PowerShell version to
    2.0.72;
  * Updated SharePointPnPPowerShellOnline version to 3.23.2007.1;

* SPOSiteScript;
  * Initial Release;

## 1.20.716.1

* MISC
  * Added visual indicators for the Export feature;
* EXOMalwareFilterPolicy
  * Fixed an issue where the value for the for the Action
    returned by the Get included 'Text' and should not have;
* EXOOutboundConnector
  * Fixed an issue where the ConnectorSource value returned
    was empty. Now defaulting to Default.
* O365User
  * Fixed issue with PasswordNeverExpires having incorrect value
* PlannerBucket
  * Initial Release;
* PlannerPlan
  * Initial Release;
* PlannerTask
  * Initial Release;
* Metadata
  * Updated ExchangeOnline module version to 1.0.1;
  * Updated Microsoft.Graph module version to 0.7.0;
  * Updated Microsoft.Graph.Identity.ConditionalAccess
    module version to 0.7.0;
  * Updated Microsoft.PowerApps.Administration.PowerShell
    module version to 2.0.70;
  * Updated MSCloudLoginAssistant Module to version 1.0.30;
  * Updated SharePointPnPPowerShellOnline module to version 3.23.2007.0;
  * Updated ReverseDSC module version to 2.0.0.4;
  * Updated SharePointPnPPowerShellOnline module to
    version 3.22.2006.2;
  * Updated all Unit Tests to Pester 5;
  * Added support for Service Principal for PowerPlatforms,
    SPO & OneDrive, Exchange Online and Office 365 resources;

## 1.20.0603.1

* Microsoft365Dsc
  * Improved event log function
* EXOEmailAddressPolicy
  * Converted hardcoded tenant name into variables;
* EXOHostedContentFilterPolicy
  * Added 'NoAction' as a valid input for property BulkSpamAction;
* EXOInboundConnector
  * Fixed an issue where if the connector was created with a source
    of 'AdminUI', we now convert it to 'Default' in the Get function;
* EXOOutboundConnector
  * Fixed an issue where if the connector was created with a source
    of 'AdminUI', we now convert it to 'Default' in the Get function;
* TeamsTenantDialPlan
  * Fixed an issue extraction plans without any normalization rules;
* Modules
  * M365DSCUtil:
    * Fixed an issue in Test-Microsoft365DSCParameterState where
      the same array of object was always being compared;
    * Issue 612 - Fixed an extra '}' in the event log output;

* Metadata
  * Updated AzureADPreview to 2.0.2.102;
  * Updated MSCloudLoginAssistant to 1.0.23;
  * Updated Microsoft.PowerApps.Administration.PowerShell
    to 2.0.64;
  * Updated ReverseDSC to 2.0.0.3;
  * Updated SharePointPnPPowerShellOnline to 3.21.2005.2;
* Misc
  * Azure DevOPS Pipelines and AppVeyor Tests converted to GitHub
    Actions;

## 1.0.5.128

* AADGroupsNamingPolicy
  * Added support for AzureAD Application Authentication;
* AADGroupsSettings
  * Added support for AzureAD Application Authentication;
  * Fixed issue where properties were returned as string instead
    of boolean;
* AADMSGroup
  * Initial Release;
* AADMSGroupLifecyclePolicy
  * Added support for AzureAD Application Authentication;
* TeamsChannel
  * Added support for AzureAD Application Authentication;
* TeamsTeam
  * Added support for AzureAD Application Authentication;
* TeamsTenantDialPlan
  * Initial Release;
* TeamsUser
  * Added support for AzureAD Application Authentication;
* Modules
  * Added M365DSCAgent;
  * Added M365DSCReport;
* Metadata
  * Updated Microsoft.PowerApps.Administration.PowerShell to 2.0.57;
  * Updated MicrosoftTeams to 1.0.6;
  * Updated MSCloudLoginAssistant to 1.0.14;
  * Introduced dependency on the EXchangeOnlineManagement module;
  * Introduced dependency on the Microsoft.Graph.Authentication module;
  * Introduced dependency on the Microsoft.Graph.Identity.ConditionalAccess
    module;
  * Introduced dependency on the DSCParser module;

## 1.0.4.39

* Re-branding to Microsoft365DSC
  * All components re-branded;
* AADMSGroupLifecyclePolicy
  * Initial Release;
* AADGroupsNamingPolicy
  * Initial Release;
* AADGroupsSettings
  * Initial Release;
* AADMSGroupLifecyclePolicy
  * Initial Release;
* SCAuditConfigurationPolicy
  * Fix issue with the Remove scenario;
* SCDLPCompliancePolicy
  * Fix issue with the Remove scenario;
* SCFilePropertyAuthority
  * Fix issue with the Remove scenario;
* SCFilePlanPropertyCategory
  * Fix issue with the Remove scenario;
* SCFilePlanPropertyCitation
  * Fix issue with the Remove scenario;
* SCFilePlanPropertyDepartment
  * Fix issue with the Remove scenario;
* SCFilePlanPropertyReferenceId
  * Fix issue with the Remove scenario;
* SCFilePlanPropertySubCategory
  * Fix issue with the Remove scenario
* SCRetentionCompliancePolicy
  * Fix issue with Teams Policy in the Get;
* SPOPropertyBag
  * Fixed an issue where false positive drifts were being detected;
* SPOSiteAuditSettings
  * Generalized the URL not to capture hardcoded dmomains;
* SPOSiteGroup
  * Fixed an issue where now, groups with Null owners are not extracted;
  * Generalized the URL not to capture hardcoded dmomains;
* TeamsCallingPolicy
  * Removed the AllowCalling parameter since it is no longer supported;
  * Fixed an issue with Policies without tags in their name (e.g. Global);
* TeamsMessagingPolicy
  * Fixed and issue where the Global policy was always flagged as having
    a drift;
* TeamsUpgradePolicy
  * Initial Release;
* M365DSCUtil
  * Added the new Assert-M365DSCTemplate cmdlet to assess remote templates;
* ReverseDSC
  * Change to allow ComponentsToExtract without the 'chck' prefix;
  * Introduction of Extraction Modes and Visual Indicators;
  * Major refactoring, having UI dynamic and items displayed by
    Resources' names;
* Metadata
  * Updated Microsoft.PowerApps.Administration.PowerShell to 2.0.56;
  * Updated MicrosoftTeams dependency to 1.0.5;
  * Updated MSCloudLoginAssistant dependency to 1.0.6;
  * Updated SharePointPnPPowerShellOnline dependency to 3.20.2004.0;

## 1.0.3.1723

* EXOHostedOutboundSpamFilterPolicy
  * BREAKING CHANGE: Remove IsSingleInstance and added
    Identity as key;
* SPOSite
  * Refactor to use PnP and expose updated parameters;
* TeamsGuestMessagingConfiguration
  * Added value NoRestriction for GiphyRatingValues;
* Metadata
  * Removed dependencyon MSOnline;
  * Updated MSCloudLoginAssistant dependency to 1.0.2;
  * Updated SharePointPnPPowerShellOnline dependency to 3.18.2002.0;
  * Updated Microsoft.PowerApps.Administration.PowerShell
    dependency to 2.0.42;

## 1.0.2.1583

* EXOAcceptedDomain
  * Fixed an issue where the domains were not properly extracted
    if multiple domain matches a similar pattern;
* EXOHostedOutboundSpamFilterPolicy
  * Fixed an error where the resource was not being extracted via
    the Graphical User Interface;
* SCComplianceTag
  * Fix an issue where FilePlanProperty values returned
    from Get-TargetResource where always empty;
* SCDLPComplianceRule
  * Fixed an issue with multiple SensitiveInformation objects;
  * Fixed an issue where extraction failed if the name of the
    Sensitive Information property contained apostrophes;
* SCFilePlanPropertySubCategory
  * Fixed an issue where the Sub-Categories were not properly extracted,
    whenever the parent category is custom;
* TeamsEmergencyCallingPolicy
  * Initial Release;
* TeamsEmergencyCallRoutingPolicy
  * Initial Release;
* TeamsGuestCallingConfiguration
  * Initial Release;
* TeamsGuestMeetingConfiguration
  * Initial Release;
* TeamsGuestMessagingConfiguration
  * Initial Release;
* TeamsMeetingBroadcastPolicy
  * Initial Release;
* ReverseDSC
  * Updated Graphical User Interface with new resources;
  * Streamlined the looping logic to simplify development process
    for new resources;
* Metadata
  * Updated Microsoft.Online.SharePoint.PowerShell to version
    16.0.19515.12000;
  * Updated ReverseDSC dependency to version 2.0.0.2;
  * Updated SharePointPnPPowerShellOnline to version 3.17.2001.2;
* SPOHomeSite
  * Initial Release;

## 1.0.1.1395

* EXOOrganizationConfig
  * Initial Release;
* EXOClientAccessRule
  * Fixed issue with Get-TargetResource not
    returning all values;
* O365OrgCustomizationSetting
  * Inital Release;
* PPPowerAppsEnvironment
  * Initial Release;
* SCAuditConfigurationSettings
  * Initial Release;
* SCComplianceTag
  * Changed ReviewerEmail to type String array;
* SCDLPComplianceRule
  * Fixed issue with the extraction of NotifyAllowOverride;
* SCFilePlanPropertyAuthority
  * Initial Release;
* SCFilePlanPropertyCategory
  * Initial Release;
* SCFilePlanPropertyCitation
  * Initial Release;
* SCFilePlanPropertyDepartment
  * Initial Release;
* SCFilePlanPropertyReferenceID
  * Initial Release;
* SCFilePlanPropertySubCategory
  * Initial Release;
* SPOPropertyBag
  * Added multithreading;
* SPOSiteGroup
  * Initial Release;
* SPOSharingSettings
  * Added ExistingExternalUserSharingOnly as a supported value
    for SharingCapabilities;
* SPOTheme
  * Fixed an issue with the Set-TargetResource
    still using SPO management shell cmdlets instead of PnP;
* SPOUserProfileProperty
  * Introduced Multi-Threading
* TeamsCallingPolicy
  * Initial Release;
* TeamsMeetingBroadcastConfiguration
  * Initial Release;
* TeamsMeetingConfiguration
  * Initial Release;
* TeamsMeetingPolicy
  * Initial Release;
* TeamsMessagingPolicy
  * Initial Release;
* TeamsUpgradeConfiguration
  * Initial Release;
* TeamsUser
  * Introduced Multi-Threading;
  * Fixed an issue with User's Principal Name;
* Metadata
  * Updated MicrosoftTeams dependency to version 1.0.3;
  * Updated MSCloudLoginAssistant dependency to version
    0.8.2;
  * Updated SharePointPnPPowerShellOnline dependency
    to version 3.16.1912.0;
  * Updated ReverseDSC dependency to version 2.0.0.0;
* Misc
  * Added new Telemetry Engine;
  * Added new Dynamic Stubs Generation feature;

## 1.0.0.1048

* SCCaseHoldPolicy
  * New Resource;
* SCComplianceCase
  * New Resource;
* SCComplianceSearch
  * New Resource;
* SCComplianceSearchAction
  * New Resource;
* SCDLPComplianceRule
  * New Resource;
* SPOPropertyBag
  * New Resource;
* SPOSiteAuditSettings
  * New Resource;
* SPOTenantCDNPolicy
  * New Resource;
* Reverse
  * Added workload selectors to the GUI interface;
* Metadata
  * Updated MSCloudLoginAssistant dependency
    to version 0.8.3;
  * Updated ReverseDSC dependency
    to version 1.9.4.6;
  * Updated Microsoft.Online.SharePoint.PowerShell dependency
    to version 16.0.19223.12000;
  * Updated MicrosoftTeams dependency to version 1.0.0.2;
  * Updated SharePointPnPPowerShellOnline dependency
    to version 3.14.1910.0

## 1.0.0.846

* Modules
  * ReverseDSC
    * Added all missing Security and Compliance items;
* EXOATPPolicyForO365
  * Fixed issue where we now extract any policy,
    not just default;
* SCDLPCompliancePolicy
  * New Resource;
* SCRetentionCompliancePolicy
  * Changed logic to update existing Policy;
* Metadata
  * Updated SharePointPnPPowerShellOnline dependency
    to version 3.12.1908.1;
  * Updated MSCloudLoginAssistant dependency to
    version 0.6;

## 1.0.0.776

* BREAKING CHANGES
  * ODSettings
    * IsSingleInstance is now a Mandatory parameter;
    * Removed CentralAdminUrl as a parameter;
  * SPOAccessControlSettings
    * Removed CentralAdminUrl as a parameter;
  * SPOAPP
    * Removed CentralAdminUrl as a parameter;
  * SPOHubSite
    * Removed CentralAdminUrl as a parameter;
  * SPOSearchManagedProperty
    * Removed CentralAdminUrl as a parameter;
  * SPOSearchResultSource
    * Removed CentralAdminUrl as a parameter;
  * SPOSharingSettings
    * Removed CentralAdminUrl as a parameter;
  * SPOSite
    * Removed CentralAdminUrl as a parameter;
  * SPOSiteDesign
    * Removed CentralAdminUrl as a parameter;
  * SPOSiteDesignRights
    * Removed CentralAdminUrl as a parameter;
  * SPOTenantSettings
    * Removed CentralAdminUrl as a parameter;
  * SPOTheme
    * Removed CentralAdminUrl as a parameter;
* Metadata
  * Updated version dependency for MSCloudLoginAssistant
    to 0.5.8;
* Modules
  * ReverseDSC
    * Fixed some issues with the abstraction of tenant name
      when the -Quiet switch is used;
* SPOApp
  * Change logic for detection when no App Catalog exist;

## 1.0.0.744

* GENERAL
  * Updated Dependency on SharePointPnPPowerShellOnline
    to version 3.11.1907.0
* BREAKING CHANGES
  * O365Group
    * ManagedBy is now a mandatory property;
  * SPOSite
    * Owner is now a mandatory property
* Modules
  * Added embedded Log Engine
* SCRetentionCompliancePolicy
  * Initial Release;
* SCRetentionComplianceRule
  * Initial Release
* SCSupervisoryReviewPolicy
  * Initial Release
* SCSupervisoryReviewRule
  * Initial Release
* SPOSite
  * Added default value for Storage Quota;
  * Fixed an issue with site creation that could result in infinite loops;
