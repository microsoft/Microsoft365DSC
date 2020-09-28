# Change log for Microsoft365DSC

## 1.20.930.1

* IntuneAppConfigurationPolicy
  * Initial Release;
* DEPENDENCIES
  * Microsoft.PowerApps.Administration.PowerShell updated
    to 2.0.83;
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
