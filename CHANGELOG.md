# Change log for Microsoft365DSC

# UNRELEASED

* SCRetentionCompliancePolicy
  * Fixes the Location parameters to be a string array instead of an object array.
    FIXES [#2503](https://github.com/microsoft/Microsoft365DSC/issues/2503)
* MISC
  * Added Application based authentication to Microsoft Teams resources;
  * Added support for Service Principal Auth for the Planner resources;
* DEPENDENCIES
  * Updated Microsoft.Graph.* to version 1.16.0;
  * Updated PnP.PowerShell to version 1.12.0;

# 1.22.1109.1

* EXODataClassification
  * FIXES [#2487](https://github.com/microsoft/Microsoft365DSC/issues/2487)
* EXOHostedOutboundSpamFilterPolicy
  * Add support to create and remove Hosted Outbound Spam Filter Policies
  * FIXES [#2492](https://github.com/microsoft/Microsoft365DSC/issues/2492)
* IntuneAntivirusPolicyWindows10SettingCatalog
  * FIXES [#2463](https://github.com/microsoft/Microsoft365DSC/issues/2463)
  * Returns all type of policies from the template family: endpointSecurityAntivirus
* MISC
  * Fixes and issue with ManagedIdentity Parameter not being not removed correctly in a parameterset.
    * FIXES [#2464](https://github.com/microsoft/Microsoft365DSC/issues/2464)
* DEPENDENCIES
  * Updated Microsoft.Graph.* to version 1.15.0;

# 1.22.1102.1

* AADAdministrativeUnit
  * Initial Release.
* AADEntitlementManagementAccessPackageCatalogResource
  * Initial release;
* DEPENDENCIES
  * Updated MicrosoftTeams to version 4.9.0;
  * Updated MSCloudLoginAssistant to version 1.0.97;

# 1.22.1026.2

* MISC
  * Fixes an issue with the export where the ApplicationSecret was throwing an empty string error when trying to authenticate with Certificate thumbprint.
    * FIXES [#2455](https://github.com/microsoft/Microsoft365DSC/issues/2455)

# 1.22.1026.1

* AADEntitlementManagementAccessPackageCatalog
  * Initial release;
* EXOIntraOrganizationConnector
  * Add TargetSharingEpr parameter
* EXOOwaMailboxPolicy
  * Add 10 new parameters
* EXOTransportRule
  * Add new parmeters: ApplyRightsProtectionCustomizationTemplate, Quarantine, RecipientAddressType, RemoveRMSAttachmentEncryption
  * Deprecated parameters: ExceptIfMessageContainsAllDataClassifications, IncidentReportOriginalMail,MessageContainsAllDataClassifications
* TeamsDialInConferencingTenantSettings
  * Initial release;
    Fixes [#2426](https://github.com/microsoft/Microsoft365DSC/issues/2426)
* DEPENDENCIES
  * Updated MSCloudLoginAssistant to version 1.0.96;
* MISC
  * Add support for ManagedIdentity to the SPO and OD resources.
  * Fixed and issue with Export and ApplicationSecret where it wasn't properly converting to a PSCredential.
    * FIXES [#2447](https://github.com/microsoft/Microsoft365DSC/issues/2447)

# 1.22.1019.1

* AADConditionalAccessPolicy
  * Fixed issue where if ExcludePlatforms was specified and the IncludePlatforms is empty, we need to set the latest to 'all';
  FIXES [#2337](https://github.com/microsoft/Microsoft365DSC/issues/2337)
* EXOAntiPhishPolicy
  * Add new parameters: MailboxIntelligenceQuarantineTag, SpoofQuarantineTag, TargetedDomainQuarantineTag, TargetedUserQuarantine
* EXOHostedContentFilterPolicy
  * Add support for quarantine tags
* EXOOrganizationRelationship
  * Add support for new cross-tenant mailbox migration parameters: MailboxMoveCapability, MailboxMovePublishedScopes, OauthApplicationId
* EXOOutboundConnector
  * Add support for SenderRewritingEnabled parameter
* EXORemoteDomain
  * Add NDREnabled parameter
* EXOSafeAttachmentPolicy
  * Add support for QuarantineTag
* EXOSafeLinksPolicy
  * Add new parameters: AllowClickThrough, EnableSafeLinksForOffice, TrackClicks
* TeamsCallingPolicy
  * Add new parameters: AllowCallRedirect, AllowSIPDevicesCalling, CallRecordingExpirationDays
* TeamsEmergencyCallingPolicy
  * Add new parameters: EnhancedEmergencyServiceDisclaimer, ExternalLocationLookupMode
* DEPENDENCIES
  * Updated Microsoft.PowerApps.Administration.PowerShell to version 2.0.154.
* MISC
  * Added support to register, list and remove custom notification endpoints.
  * Fixes issue with delta report where wrong primary key was detected.
    FIXES [#2008](https://github.com/microsoft/Microsoft365DSC/issues/2008)
  * Fixed an issue where the log engine was throwing an error when trying to write to the event log from an Azure runbook.
    FIXES [#2236](https://github.com/microsoft/Microsoft365DSC/issues/2236)
  * Standardizing the functions to test versions of the module and dependencies.
    FIXES [#2232](https://github.com/microsoft/Microsoft365DSC/issues/2232)
  * Remove the Assert-M365DSCTemplate cmdlet that has been deprecated for several releases.
  * Added support to generate report in JSON format for the New-M365DSCDeltaReport and Assert-M365DSCBlueprint cmdlets.
    FIXES [#2345](https://github.com/microsoft/Microsoft365DSC/issues/2345)
  * Changed the default behavior of the New-M365DSCDeltaReport cmdlet not to automatically open the file when OutputPath is provided

# 1.22.1012.1

* EXOManagementRoleAssignment
  * Initial Release
  FIXES [#2355](https://github.com/microsoft/Microsoft365DSC/issues/2355)
  FIXES [#2356](https://github.com/microsoft/Microsoft365DSC/issues/2356)
* SCRetentionCompliancePolicy
  * Fixed issue where the locations weren't properly returned.
  FIXES [#2338](https://github.com/microsoft/Microsoft365DSC/issues/2338)
  FIXES [#2339](https://github.com/microsoft/Microsoft365DSC/issues/2339)
* TeamsOnlineVoicemailPolicy
  * Initial Release
* TeamsOnlineVoicemailUserSettings
  * Initial Release
* TeamsOnlineVoiceUser
  * Initial Release
* TeamsUserCallingSettings
  * InitialRelease
* EXOOrganizationConfig
  * Added 35 new parameters.
  * Set AllowPlusAddressInRecipients parameter to deprecated. Use DisablePlusAddressInRecipients instead.
* DEPENDENCIES
  * Updated Microsoft.Graph dependencies to version 1.13.0.
  * Updates MicrosoftTeams to version 4.8.0;
  * Updated ReverseDSC to version 2.0.0.13;
  FIXES [#2270](https://github.com/microsoft/Microsoft365DSC/issues/2270)
* MISC
  * EXO Workload
    * Add support for Managed Identity authentication
  * Fixed an issue in in Export-M365DSCConfiguration when used with Service Principal
    FIXES [2374](https://github.com/microsoft/Microsoft365DSC/issues/2374)
    FIXES [2379](https://github.com/microsoft/Microsoft365DSC/issues/2379)
  * Added support for Exchange to the Update-M365DSCAzureAdApplication cmdlet
  * Fixes an issue where filters were ignored on export when specifying the Workloads parameter.

# 1.22.1005.1

* AADUser
  * Renamed from O365User
  * Added support for Roles.
    FIXES [#2288](https://github.com/microsoft/Microsoft365DSC/issues/2288)
* AADGroup
  * Added properties MemberOf and AssignedToRole
    Implements [#2301](https://github.com/microsoft/Microsoft365DSC/issues/2301)
* AADTenantDetails
  * Fixed an issue where ApplicationSecret was send to Update-MgOrganization
  * FIXES [[#2340](https://github.com/microsoft/Microsoft365DSC/issues/2340)]
* EXOATPPolicyForO365
  * [BREAKING] Removed the deprecated BlockURLs, AllowClickThrough, EnableSafeLinksForO365Clients and TrackClicks parameters.
* EXOMailContact
  * Initial Release.
* EXOMailTips
  * Fixes an issue where MailTips weren't extracted when using CertificateThumbprint to authenticate.
    FIXES [#2235](https://github.com/microsoft/Microsoft365DSC/issues/2235)
* O365User
  * [BREAKING] Resource was renamed to AADUser.
    FIXES [#2204](https://github.com/microsoft/Microsoft365DSC/issues/2204)
* IntuneDeviceConfigurationPolicyiOS
  * [Breaking] Changed all the MediaContentRating properties to be CIMInstances.
    FIXES [#1871](https://github.com/microsoft/Microsoft365DSC/issues/1871)
* SCSensitivityLabel
  [BREAKING] Changed Setting attribute in MSFT_SCLabelLocaleSettings to LabelSetting since its resevered word and breaking reporting.
    FIXES #2314
* MISC
  * [BREAKING] Authentication property ApplicationSecret has been changed across all resources to be of type
    PSCredential instead of string. This will ensure that the secrets get encrypted in MOF files
    when compiling with an encryption certificated instead of being exposed as plaintext.
    FIXES [#1714](https://github.com/microsoft/Microsoft365DSC/issues/1714)
  * Fixes issue with DSCParser non-existing resources on one tenant weren't properly captured.
* DEPENDENCIES
  * Updated Microsoft.Graph dependencies to version 1.12.3.
  * Updated MSCloudLoginAssistant dependency to version 1.0.94.
  * Updated Microsoft.PowerApps.Administration.PowerShell to version 2.0.153.
  * Added new dependency on Microsoft.Graph.Users.Actions.

# 1.22.921.1

* AADRoleSetting
  * Fixed an issue if the P2 License is not present on the tenant the Export stop working
    FIXES [#2227](https://github.com/microsoft/Microsoft365DSC/issues/2227)
  * Fixed an issue with approver can be a group
    FIXES [#2283](https://github.com/microsoft/Microsoft365DSC/issues/2283)
* AADConditionalAccessPolicy
  * Added support for the CustomAuthenticationFactors parameter.
  FIXES [#2292](https://github.com/microsoft/Microsoft365DSC/issues/2292)
* O365User
  * Improved extraction performance by leveraging StringBuilder instead of re-assigning string.
* SCAutoSensitivityLabelPolicy
  * Initial Release.
* SCAutoSensitivityLabelRule
  * Initial Release.
* DEPENDENCIES
  * Updated the ExchangeOnlineManagement dependency to version 3.0.0.
  * Updated the MSCloudLoginAssistant dependency to version 1.0.89.

# 1.22.914.1

* AADGroup
  * Changed behavior where if a group has a dynamic membership rule that is active,
    we no longer process members from the export, Get and Set functions.
    FIXES [#2190](https://github.com/microsoft/Microsoft365DSC/issues/2190)
  * Fixed an issue where if the licenses parameter was omitted and another parameter caused
    a drift, that the licenses would get stripped from the group.
    FIXES [#2191](https://github.com/microsoft/Microsoft365DSC/issues/2191)
* AADRoleSetting
  * Fixed an issue where the export wasn't properly passing credential to the Get function.
* TeamsCallingPolicy
  * Added UserOverride as an accepted value for the BusyOnBusyEnabledType parameter.
  FIXES [#2271](https://github.com/microsoft/Microsoft365DSC/issues/2271)

# 1.22.907.1

* EXODistributionGroup
  * Fixes warning issue regarding OrganizationalUnit property
    FIXES [#2252]
* SCRetentionCompliancePolicy
  * Fixes an issue where the TeamsChatLocation, TeamsChatLocationException, TeamsChannelLocation
    and TeamsChannelLocationException properties were not properly set on Update.
    FIXES #2173
* SCRetentionComplianceRule
  * Fixes an issue when trying to create new compliance rule for Teams based policies where invalid
    parameters were passed.
    FIXES #2181
* DEPENDENCIES
  * Updated MicrosoftTeams dependency to version 4.7.0.
* MISC
  * Update settings.json for all SharePoint resources to add SharePoint specific permissions
    FIXES [#2240]
  * Updated website pages with new information (cmdlet and resource documentation)

# 1.22.831.1

* EXOAddressList
  * Ignore precanned filters if recipient filter is used. Precanned filters and recipient filter cannot be used at the same time.
    FIXES [#2194](https://github.com/microsoft/Microsoft365DSC/issues/2194)
* EXOSafeLinksPolicy
  * Add Support for EnableSafeLinksForEmail and DisableUrlRewrite
* EXOInboundConnector
  * Add support for different syntax of SenderDomains parameter
  FIXES [#2180](https://github.com/microsoft/Microsoft365DSC/issues/2180)
* IntuneDeviceConfigurationPolicyAndroidDeviceAdministrator
  * Don't export all policies if none match the type
* IntuneDeviceConfigurationPolicyAndroidOpenSourceProject
  * Don't export all policies if none match the type
  FIXES [#2228](https://github.com/microsoft/Microsoft365DSC/issues/2228)
* PlannerBucket
  * Changed authentication method to Credentials only, since the Planner Graph API
    does not support anything else
  FIXES [#1979](https://github.com/microsoft/Microsoft365DSC/issues/1979)
  * Fixes issue with generating Export output
  FIXES [#2032](https://github.com/microsoft/Microsoft365DSC/issues/2032)
* PlannerPlan
  * Fix export issue where the export wasn't created correctly because of the
    use of an incorrect property name.
  * Changed authentication method to Credentials only, since the Planner Graph API
    does not support anything else
  FIXES [#1979](https://github.com/microsoft/Microsoft365DSC/issues/1979)
* PlannerTask
  * Changed authentication method to Credentials only, since the Planner Graph API
    does not support anything else
  FIXES [#1979](https://github.com/microsoft/Microsoft365DSC/issues/1979)
* TeamsMeetingBroadcastConfiguration
  * Fixing export issue where SdnApiToken is exported as a string instead of
    a variable
  FIXES [#2056](https://github.com/microsoft/Microsoft365DSC/issues/2056)
* MISC
  * Updated Export functionality to only export the LCM settings when the
    executed as Administrator
  FIXES [#2037](https://github.com/microsoft/Microsoft365DSC/issues/2037)
  * Added support for multiple authentication methods to the Export functionality.
    The code now uses the most secure method that is provided in the command line
    and that supported by the specified resources in the following order:
    Certificate Thumbprint, Certificate Path, Application Secret, Credential
  FIXES [#1759](https://github.com/microsoft/Microsoft365DSC/issues/1759)
* MISC
  * Fix issue of running Export-M365DSCConfiguration within Azure Run Book. FIXES [#2233](https://github.com/microsoft/Microsoft365DSC/issues/2233)
  * Fix issue within M365DSCTelemetryEngine when used with ApplicationId. FIXES [#2237](https://github.com/microsoft/Microsoft365DSC/issues/2237)

# 1.22.824.1

* AADApplication
  * Fixed issue where Update-MgApplication could be called with parameter ReplyURLs which is invalid.
  * Added support to export/import app owners.
* EXOTransportRule
  * Fix issue setting IncidentReportContent
  FIXES [#2196](https://github.com/microsoft/Microsoft365DSC/issues/2196)
* O365User
  * Optimize, call Get-MgSubscribedSku only once instead of inside of two loops per each user/license.
* SPOSiteGroup
  * Avoid redefining SiteGroupSettings always to the same value, just define it once, and call it as is on Set-PnPGroup.
  * To keep the same order of updating the group and then its permissions check on which conditions it needs to be updated and at the end call Set-PnPGroup then Set-PnPGroupPermissions.
  * Fix typo in variable, not an issue right now but the group would always be updated even if name and owner were already correct.
* DEPENDENCIES
  * Updated DSCParser dependency to version 1.3.0.6.
  * Updated Microsoft.Graph dependencies to version 1.11.1.
  * Updated ReverseDSC dependency to version 2.0.0.12.
* MISC
  * Fixed issue with Export-M365DSCConfiguration if all components were invalid or if resource files were not found.
  * Updated MicrosoftTeams to version 4.6.0.
* AADRoleSetting
  * New Resource, configure Azure PIM Role like in the UI

# 1.22.727.1

* AADConditionalAccessPolicy
  * DEPRECATED then IncludeDevices and ExcludeDevices parameters.
  * Fixed issue extracting a policy that had invalid users or groups (deleted from AAD).
  FIXES [#2151](https://github.com/microsoft/Microsoft365DSC/issues/2151)
* EXOTransportRule
  * Fixed issue where the MessageContainsDataClassifications property was not properly extracted due to single quote exiting.
  FIXES [#1820](https://github.com/microsoft/Microsoft365DSC/issues/1820)
* IntuneAppProtectionPolicyAndroid
  * Added Configuration Parameters:
    ManagedBrowser
    MinimumRequiredAppVersion
    MinimumRequiredOSVersion
    MinimumRequiredPatchVersion
    MinimumWarningAppVersion
    MinimumWarningOSVersion
    MinimumWarningPatchVersion
    AppGroupType
    IsAssigned
    FIXES [#1955](https://github.com/microsoft/Microsoft365DSC/issues/1955)
* IntuneDeviceConfigurationPolicyWindows10
  * Fixed issue where the edgeSearchEngine value was not properly retrieved.
  FIXES [#1783](https://github.com/microsoft/Microsoft365DSC/issues/1783)
* SCSensitivityLabel
  * Fixed an issue where '$' in the custom wordmark test would cause issue.
  FIXES [#2067](https://github.com/microsoft/Microsoft365DSC/issues/2067)
* SPOSite
  * Fixed owner value for root site.
  FIXES [#2035](https://github.com/microsoft/Microsoft365DSC/issues/2035)
* TeamsEventsPolicy
  * Initial release.
* TeamsUser
  * Fixed the extraction process and removed the multi-threading from the resource.
  FIXES #1883
* DEPENDENCIES
  * Updated MicrosoftTeams to version 4.6.0.
* MISC
  * Added support for filtering resources instances at extraction time.
  FIXES [#1691](https://github.com/microsoft/Microsoft365DSC/issues/1691)
  * REPORT: Fixed an issue where if the ModuleVersion was not specified, that the file would fail to properly get parsed.
  FIXES [#1970](https://github.com/microsoft/Microsoft365DSC/issues/1970)
  * Resources implementing the Ensure parameter now defaults its value to $true.
  FIXES [#1738](https://github.com/microsoft/Microsoft365DSC/issues/1738)

# 1.22.720.1

* EXOTransportRule
  * Fixed issue where the MessageContainsDataClassifications property was not properly extracted due to single quote exiting.
  FIXES [#1820](https://github.com/microsoft/Microsoft365DSC/issues/1820)
* IntuneDeviceConfigurationPolicyWindows10
  * Fixed issue where the edgeSearchEngine value was not properly retrieved.
  FIXES [#1783](https://github.com/microsoft/Microsoft365DSC/issues/1783)
* SCSensitivityLabel
  * Fixed an issue where '$' in the custom wordmark test would cause issue.
  FIXES [#2067](https://github.com/microsoft/Microsoft365DSC/issues/2067)
* SPOSite
  * Fixed owner value for root site.
  FIXES [#2035](https://github.com/microsoft/Microsoft365DSC/issues/2035)
* TeamsUser
  * Fixed the extraction process and removed the multi-threading from the resource.
  FIXES #1883
* MISC
  * Added support for filtering resources instances at extraction time.
  FIXES [#1691](https://github.com/microsoft/Microsoft365DSC/issues/1691)
  * REPORT: Fixed an issue where if the ModuleVersion was not specified, that the file would fail to properly get parsed.
  FIXES [#1970](https://github.com/microsoft/Microsoft365DSC/issues/1970)
  * Resources implementing the Ensure parameter now defaults its value to $true.
  FIXES [#1738](https://github.com/microsoft/Microsoft365DSC/issues/1738)

# 1.22.720.1

* AADAuthorizationPolicy
  * Fixed issue with the DefaultUserRolePermissionGrantPoliciesAssigned property.
* AADGroup
  * Added support for Group Licensing by adding the AssignedLicenses property.
  * Added support for members and owners.
  FIXES [#1066](https://github.com/microsoft/Microsoft365DSC/issues/1066)
* EXOCASMailboxSettings
  * Fixed issue if there are mailboxes with the same name
  FIXES [#2117](https://github.com/microsoft/Microsoft365DSC/issues/2117)
* EXODistributionGroup
  * Initial release.
  FIXES [#1802](https://github.com/microsoft/Microsoft365DSC/issues/1802)
* EXOMalwareFilterPolicy
  * DEPRECATED parameter CustomAlertText.
* IntuneAntivirusPolicyWindows10SettingCatalog
  * Initial release.
* IntuneAttackSurfaceReductionRulesPolicyWindows10ConfigManager
  * Initial release.
* IntuneDeviceCompliancePolicyWindows10
  * Switched to using the beta profile in order to aapture all parameters.
  FIXES [#1998](https://github.com/microsoft/Microsoft365DSC/issues/1998)
* IntuneDeviceConfigurationPolicyWindows10
  * Fixed issue where the value for the DefenderDetectedMalwareActions property wasn't properly handled.
  FIXES [#1479](https://github.com/microsoft/Microsoft365DSC/issues/1479)
* IntuneExploitProtectionPolicyWindows10SettingCatalog
  * Initial release.
* O365OrgCustomizationSetting
  * Added a warning to let users know the changes can take up to 24 hours to be reflected
  FIXES [#1599](https://github.com/microsoft/Microsoft365DSC/issues/1599)
* PPTenantSettings
  * Fixed the way parameters are passed to the Set-TenantSettings cmdlet.
  FIXES [#1914](https://github.com/microsoft/Microsoft365DSC/issues/1914)
* TeamsTenantDialPlan
  * Fixed an issue where the Normalization Rules strings were not properly exited.
    FIXES [#2096](https://github.com/microsoft/Microsoft365DSC/issues/2096)
* TeamsUpdateManagementPolicy
  * Changed the format of the UpdateTimeOfDay parameter to not include date as part of an export.
    FIXES [#2062](https://github.com/microsoft/Microsoft365DSC/issues/2062)
* MISC
  * PowerPlatform: Standardized authentication on Credential and dropped support for Service Principal across resources.
  FIXES [#1979](https://github.com/microsoft/Microsoft365DSC/issues/1979)
  * EXPORT: Changed the way resources' modules are imported to improve startup performance.
  FIXES [#1745](https://github.com/microsoft/Microsoft365DSC/issues/1745)
  * Added a new Test-M365DSCModuleValidity cmdlet.
  * Updated the Uninstall-M365DSCOutdatedDependencies cmdlet to delete module files.

# 1.22.713.1

* AADAuthorizationPolicy
  * Initial release.
* AADConditionalAccessPolicy
  * Fixed issue for Included and Excluded properties where the last instance couldn't be removed.
    FIXES [#2058](https://github.com/microsoft/Microsoft365DSC/issues/2058) & [#2079](https://github.com/microsoft/Microsoft365DSC/issues/2079)
* EXOATPPolicyForO365
  * Deprecated properties AllowClickThrough, EnableSafeLinksForO365Clients & TrackClicks.
* EXOAuthenticationPolicyAssignment
  * Initial release.
* EXOCASMailboxSettings
  * New resource to configure Exchange Online CAS Mailbox settings.
* EXOSafeLinksPolicy
  * Deprecated properties DoNotAllowClickThrough, DoNotTrackUserClicks & IsEnabled.
* IntuneAppProtectionPolicyiOS
  * Fixed issue with creation a new policies where it was complaining about invalid minimum versions.
  * Fixed issues where creating new policies threw an error complaining about an invalid duration format.
     FIXES [#2019](https://github.com/microsoft/Microsoft365DSC/issues/2019)
  * Added the CustomBrowserProtocol parameters.
     FIXES [#2009](https://github.com/microsoft/Microsoft365DSC/issues/2009)
* IntuneDeviceAndAppManagementAssignmentFilter
  * Initial release.
* SCComplianceTag
  * Fixed issue where FilePlanProperty was not properly applied unless another child property was also modified.
* SPOSharingSettings
  * Updated code to remove None as valid value for DefaultLinkPermission. If value is set to None default to Edit.
* DEPENDENCIES
  * Updated Microsoft.PowerApps.Administration.PowerShell to version 2.0.150.
  * Updated MSCloudLoginAssistant to version 1.0.87.
* MISC
  * Made the Compare-M365DSCConfigurations cmdlet public.

# 1.22.706.1

* AADSecurityDefaults
  * Initial release.
* TeamsFederationConfiguration
  * Added support for the AllowedDomains and BlockedDomains properties.
* TeamsVoiceRoutingPolicy
  * Remove unsupported Confirm parameter from Remove-CsOnlineVoiceRoutingPolicy cmdlet (Confirm parameter is no longer available for MicrosoftTeams PowerShell module 4.4.1+).
    FIXES #2055
* DEPENDENCIES
  * Updated MicrosoftTeams to version 4.5.0.
  * Updated Pnp.PowerShell to version 1.11.0.

# 1.22.629.1

* EXOMalwareFilterPolicy
  * Parameters Action, EnableExternalSenderNotifications and EnableInternalSenderNotifications are deprecated and will be removed in future. These parameters are no longer available in EXO, only in onprem Exchange. Please remove these parameters from your configuration.
  FIXES #2025
  * Added support for FileTypeAction parameter.
* EXOSharedMailbox
  * Fix using umlauts in displayname by allowing to set alias.
    FIXES #1921
  * Rename parameter Aliases to EmailAddresses. Aliases is now deprecated.
* DEPENDENCIES
  * Updated DSCParser to version 1.3.0.5
  * Updated Microsoft.Graph.* modules to version 1.10.0.
  * Updated MSCloudLoginAssistant to version 1.0.86.
    Fixes two authentication issues: #2000 and #2007
* MISC
  * New Delta Report: removed mandatory restrictions on the OutputPath parameter.
    FIXES #2029

# 1.22.622.1

* TeamsMessagingPolicy
  * Removed the -force deprecated parameter on New/Set/Remove
* MISC
  * Modified the dependency installation functions to for the AllUsers scope.

# 1.22.615.1

* EXODataClassification
  * Added example
* EXODataEncryptionPolicy
  * Added example
* MISC
  * Added cmdlet (Update-M365DSCAzureAdApplication) to create and manage a
    custom service principal which can be used within Microsoft365DSC
    configurations
  * Extended the permissions in the settings.json file to include delegated,
    application and Exchange permissions
  * Updated Get-M365DSCCompiledPermissionList to include the new permissions in the
    settings.json file
  * Added cmdlet to generate the resource pages on the microsoft365dsc.com website
  * Checked and updated the readme.md files of all resources to make them consistent
    and usable by the new documentation cmdlet
  * Corrected documentation issues on the microsoft365dsc.com website
* DEPENDENCIES
  * Updated Microsoft.PowerApps.Administration.PowerShell to 2.0.148;

# 1.22.608.1

* AADConditionalAccessPolicy
  * Updated settings.json with missing permissions
* DEPENDENCIES
  * Updated MSCloudLoginAssistant to 1.0.85;
* MISC
  * Updated permissions for SharePoint and OneDrive in settings.json files.

# 1.22.601.1

* DEPENDENCIES
  * Updated MicrosoftTeams to version 4.4.1

# 1.22.525.1

* IntuneASRRulesPolicyWindows10
  * Initial release;
* PPowerAppsEnvironment
  * Fixed issue on export to exclude EnvironmentTypes of Notspecified and Developer
  * Updated validation set of EnvironmentTypes to latest values
* DEPENDENCIES
  * Updated MSCloudLoginAssistant module to version 1.0.84.
* MISC
  * Fixed issue in generating a Delta report, where the Resource names were also
    compared, which in case of an export are generated GUIDs.
  * Fixed issue where empty strings or arrays would result in a Delta reports
    with drifted parameters, even though both configs are empty.
  * Added logic to New-M365DSCDeltaReport to check if the files specified in the
    Source, Destination and HeaderFilePath parameters actually exist.
  * Fixed issue where Excel wasn't closed after creating the report.

# 1.22.518.1

* AADConditionalAccessPolicy
  * Fixed export to remove the DeviceFilterMode property
    when empty.
* EXODataClassification
  * Initial release
* EXODataEncryptionPolicy
  * Initial release
* PPTenantIsolationSettings
  * Fixed an issue where credentials weren't passed properly
    during the export.
* SPOSharingSettings
  * Decoupling from SPOSharingSettings: add SharingCapability for "-my sites" aka: OneDrive

# 1.22.511.1

* AADNamedLocationPolicy
  * Added error handling in the Get-TargetResource function.
* EXOIRMConfiguration
  * Initial release.
* EXOMessageClassification
  * Initial release.
* EXOOMEConfiguration
  * Initial release.
* EXOOwaMailboxPolicy
  * Fix where the update scenario was not setting the proper
    values. (FIXES #1868)
* EXOPerimeterConfiguration
  * Initial release.
* EXOResourceConfiguration
  * Initial release.
* IntuneApplicationControlPolicyWindows10
  * Initial release.
* TeamsUpdateManagementPolicy
  * Initial release.
* DEPENDENCIES
  * Updated Microsoft.Graph.* modules to version 1.9.6.
  * Updated ReverseDSC to version 2.0.0.11.
* MISC
  * Updated permissions for SharePoint in settings.json files.
  * Added links to documentation to Teams Readme files
  * Added and corrected some Exchange examples
  * Added progress indicator to the Report generation

# 1.22.504.1

* EXOInboundConnector
  * Added support for EFSkipIPs, EFSkipLastIP and EFUsers properties. (FIXES #1917)
* DEPENDENCIES
  * Updated Microsoft.PowerApps.Administration.PowerShell to version 2.0.147.
  * Updated MicrosoftTeams to version 4.3.0.

# 1.22.427.1

* AADApplication
  * Fix for Permissions with 'Role,Scope' types.
* EXOAuthenticationPolicy
  * Fix schema.mof file (FIXES #1896)
* IntuneAppProtectionPolicyAndroid
  * New resource - (fixes issue #1900 and #1432)
* IntuneAppProtectionPolicyiOS
  * Fixes #1877
* DEPENDENCIES
  * Updated Microsoft.PowerApps.Administration.PowerShell to version 2.0.146.
* MISC
  * Performance updates when doing exports (using StringBuilder over
    appending to string).

# 1.22.420.1

* EXOOutboundConnector
  * Added support for test mode connectors.

# 1.22.413.1

* EXOAuthenticationPolicy
  * Fix typo in AllowBasicAuthOfflineAddressBook (FIXES #1876)
* EXOQuarantinePolicy
  * New resource
* O365Groups
  * Fixed issue on export of O365Groups resource.
* DEPENDENCIES
  * Updated Microsoft.Graph.* to 1.9.5.
  * Updated Microsoft.PowerApps.Administration.PowerShell to 2.0.145.
  * Updated MicrosoftTeams to 4.2.0.

# 1.22.406.1

* EXOMalwareFilterPolicy
  * Add support for property QuarantineTag
* PPTenantIsolationSettings
  * New resource
* MISC
  * Updated Convert-M365DscHashtableToString function to also convert
    Arrays and CimInstances to string.
  * Updated permissions in settings.json files.
* DEPENDENCIES
  * Updated Microsoft.PowerApps.Administration.PowerShell to 2.0.144.
  * Updated MicrosoftTeams to 4.1.0.
  * Updated PnP.PowerShell to 1.10.0.

# 1.22.323.1

* EXOAuthenticationPolicy
  * Initial release;
* EXOOrganizationConfig
  * Added support for CustomerLockboxEnabled and DisablePlusAddressInRecipients parameters.
    FIXES #1831

# 1.22.316.1

* EXOCASMailboxPlan
  * Add support for DisplayName as identifier for CAS mailbox plan.
* EXOTransportSettings
  * New resource for Exchange Online transport configuration.
* IntuneAppProtectionPolicyiOS
  * Add 7 additional parameters to the resource and added parameter
    descriptions.
* DEPENDENCIES
  * Updated DSCParser to 1.3.0.4.
  * Updated Microsoft.Graph.* to 1.9.3.

# 1.22.309.1

* EXOAcceptedDomain
  * Fixes an issue where True was never accepted as a value for parameters
    MatchSubDomains or OutboundOnly.
    FIXES #1779
* EXOMailboxPlan
  * New resource for Exchange Online Mailbox Plans.
* EXOOrganizationConfig
  * Fixes an issue where AutoExpandingArchiveEnabled returned always False.
    FIXES #1789
* IntuneDeviceConfigurationPolicyAndroidDeviceOwner
  * Initial release.
* O365Group
  * Revamped to use Microsoft Graph in the Set;
* TeamsChannel
  * Fix to retrieve the team name without URL encoding.
* TeamsFederationConfiguration
  * New resource for Teams Federation Configuration.
* TeamsTeam
  * Fixed issue where teams were not created when no owners were specified.
    If credentials are used, then the user will be used as owner.
* DEPENDENCIES
  * Updated DSCParser to version 1.3.0.3.
  * Updated MicrosoftTeams to version 4.0.0.
* MISC
  * Added a function to uninstall all outdated dependencies
    and older versions of Microsoft365DSC;
  * M365DSCReport: Adds JSON as an export option.

# 1.22.216.1

* DEPENDENCIES
  * Updated ReverseDSC to version 2.0.0.10.
  * Updated Microsoft.PowerApps.Administration.PowerShell to version 2.0.142.

# 1.22.209.1

* TeamsChannel
  * Fix to allow channels to be extracted properly when two Teams
    have the same name.
    FIXES #1746
* DEPENDENCIES
  * Updated MicrosoftTeams to version 3.1.1;
* MISC
  * Fixed an issue with the Export where the Configuration Data file
    always referenced a certificate file even when none were configured.
    FIXES #1724

# 1.22.202.1

* IntuneAppProtectionPolicyiOS
  * Fixes an issue where an error was thrown when no ExcludedGroups
    were specified.
    FIXES #1719
* MISC
  * Documentation updates

# 1.22.126.1

* TeamsTenantDialPlan
  * Fixed an issue where the Export only extracted the first
    normalization rule.
    FIXES #1695
* DEPENDENCIES
  * Updated all Microsoft.Graph * to 1.9.2;
  * Updated Microsoft.Teams to version 3.1.0;
* MISC
  * Update automatic cmdlet documentation generation functions and prereqs.
  * Adding cmdlet documentation to website
  * Fixed an issue with the Export-M365DSCConfiguration cmdlet where it
    would throw an error if no parameters were passed.

# 1.22.119.2

* EXOOrganizationConfig
  * Fixed issue where the name of the parameter in the module and
    in the schema differed;
    FIXES #1689

# 1.22.119.1

* EXOOrganizationConfig
  * Added support for the new SendFromAliasEnabled parameter;
* EXORoleAssignmentPolicy
  * Fixed logic to update roles assigned to an existing policy;
    FIXES #1538
MISC
  * Updated logic for Report generation so that it no longer requires the
    same module version as defined in the configuration installed on the
    system where the report is being generated from.

# 1.22.112.1

* TeamsMeetingPolicy
  * Added support for property WhoCanRegister;
    FIXES #1483
* DEPENDENCIES
  * Updated MSCloudLoginAssistant to 1.0.83;

# 1.22.105.1

* AADNamedLocationPolicy
  * Throw meaningful error if multiple policies with the same name were retrieved.
* EXOMalwareFilterPolicy
  * Fix for the MakeDefault property where it wasn't properly setting existing
    policies to default.
    FIXES #1648
* IntuneDeviceConfigurationPolicyWindows10
  * Fixed mismatch in property types between the PasswordBlockSimple and
    PasswordSignInFailureCountBeforeFactoryReset properties.
    FIXES #1525
* O365Group
  * Removed support for invalid CertificatePassword and CertificatePath parameters
    and added support for ApplicationSecret;
* O365User
  * Removed support for invalid CertificatePassword and CertificatePath parameters
    and added support for ApplicationSecret;
* TeamsChannel
  * Fixed an issue where special symbols in Teams names would cause the
    Get-TeamByName cmdlet to fail.
    ISSUE #1578
* MISC
  * Error Handling in Delta Report and removal of Authentication mechanism comparison;
    FIXES #1548, #1541
  * Added automatic cmdlet documentation generation functions and prereqs.

# 1.21.1229.1

* DEPENDENCIES
  * Updated all PnP.PowerShell dependencies to version 1.9.0;

# 1.21.1222.1

* AADGroup
  * Default to Unified type if no GroupTypes are provided;
    FIXES #850
* EXOAntiPhishPolicy
  * Deprecated the EnableAntispoofEnforcement and TargetDomainProtectionAction parameters;
    FIXES #1018
* EXOHostedCOntentFilterPolicy
  * Fix for the MakeDefault property where it wasn't properly setting existing
    policies to default.
    FIXES #1635
* SPOSearchManagedProperty
  * Fixed an issue with the Aliases retrieval;
* SPOUserProfileProperty
  * Removed the Required key from the schema.mof file for Credential;
    ISSUE #1632
* DEPENDENCIES
  * Updated all Microsoft.Graph.* dependencies to version 1.9.1;
* MISC
  * Fixed issue where running Export-M365DSCConfiguration with the -LaunchWebUI
    parameter would prompt for credentials;
  * Added warning message when ApplicationSecret is used while attempting
    to export resources for Exchange Online;
    Fixes #1629

# 1.21.1215.1

* AADConditionalAccessPolicy
  * Switched to the beta endpoint to allow the export to capture policies
    with device compliance conditions configured;
* EXOAntiphishPolicy
  * Fixed an issue where trying to create a new policy would result in its
    Identity being set to System.Collections.Hashtable;
    FIXES #1620
  * Fix for the MakeDefault property where it wasn't properly setting existing
    policies to default.
    FIXES #1582
* O365User
  * Fixed issue where the extraction wasn't properly formatting the temporary
    password for a user;
* TeamsChannelPolicy
  * Added support for Shared Channels;
* TeamsMeetingPolicy
  * Added support for value 'EveryoneInCompanyExcludingGuests' for the
    AutoAdmittedUsers property;
* DEPENDENCIES
  * Updated MSCloudLoginAssistant to 1.0.82;

# 1.21.1208.1

* AADConditionalAccessPolicy
  * Added support for Terms of Use;
* AADGroup
  * Fixed issue where not all groups were exported;
* TeamsTeam
  * Fix issue where Credentials weren't extracted as a variable;
* TeamChannel
  * Fixed issue where the exported Team Channel content was empty if
    Credentials were used to authenticate;
* MISC
  * Removed RequiredModules in favor of a new custom dependency manifest;
* DEPENDENCIES
  * Updated MicrosoftTeams to 3.0.0;
  * Updated MSCloudLoginAssistant to 1.0.80;

# 1.21.1124.2

* DEPENDENCIES
  * Updated ReverseDSC to 2.0.0.9;

# 1.21.1124.1

* IntuneAppProtectionPolicyiOS
  * Fixes to the Invoke-MgGraphRequest cmdlets parameters;
* MISC
  * Removed the Quiet switch from the Assert Blueprint cmdlet;
    ISSUE #1563
* DEPENDENCIES
  * Updated Microsoft.Graph.Applications to 1.9.0;
  * Updated Microsoft.Graph.Authentication to 1.9.0;
  * Updated Microsoft.Graph.DeviceManagement to 1.9.0;
  * Updated Microsoft.Graph.DeviceManagement.Administration to 1.9.0;
  * Updated Microsoft.Graph.DeviceManagement.Enrolment to 1.9.0;
  * Updated Microsoft.Graph.Devices.CorporateManagement to 1.9.0;
  * Updated Microsoft.Graph.Groups to 1.9.0;
  * Updated Microsoft.Graph.Identity.DirectoryManagement to 1.9.0;
  * Updated Microsoft.Graph.Identity.SignIns to 1.9.0;
  * Updated Microsoft.Graph.Planner to 1.9.0;
  * Updated Microsoft.Graph.Teams to 1.9.0;
  * Updated Microsoft.Graph.Users to 1.9.0;
  * Updated MSCloudLoginAssistant to 1.0.79;
  * Updated ReverseDSC to 2.0.0.8;

# 1.21.1117.2

* MISC
  * Fixes old Intune Graph Request cmdlet name;

# 1.21.1117.1

* EXOTransportRule
  * Fixed issues with invalid State property and missing Enabled one;
    ISSUE #1554;
* IntuneDeviceCompliancePolicyAndroidDeviceOwner
  * Initial release;
* DEPENDENCIES
  * Updated DSCParser to version 1.3.0.2;
  * Updated MSCloudLoginAssistant to version 1.0.78;

# 1.21.1110.1

* MISC
  * Standardized examples
  * Added missing examples
  * Added settings.json generator cmdlet (Update-M365DSCResourcesSettingsJSON)
  * Added cmdlet to configure delegated permissions to Graph app based on
    settings.json file (Update-M365DSCAllowedGraphScopes)
  * Preparation to run integration tests dynamically using the resource examples
* DEPENDENCIES
  * Updated MSCloudLoginAssistant to version 1.0.76;

# 1.21.1103.1

* TeamsCallingPolicy
  * Added support for value 'Unanswered' for property
    BudyOnBusyEnabledType.
    Fix Issue #1514
* DEPENDENCIES
  * Updated Microsoft.PowerApps.Administration.PowerShell to
    2.0.139;
  * Updated MSCloudLoginAssistant to version 1.0.75;

# 1.21.1027.1

* DEPENDENCIES
  * Updated Microsoft.Graph.Applications to 1.8.0;
  * Updated Microsoft.Graph.Authentication to 1.8.0;
  * Updated Microsoft.Graph.DeviceManagement to 1.8.0;
  * Updated Microsoft.Graph.DeviceManagement.Administration to 1.8.0;
  * Updated Microsoft.Graph.DeviceManagement.Enrolment to 1.8.0;
  * Updated Microsoft.Graph.Devices.CorporateManagement to 1.8.0;
  * Updated Microsoft.Graph.Groups to 1.8.0;
  * Updated Microsoft.Graph.Identity.DirectoryManagement to 1.8.0;
  * Updated Microsoft.Graph.Identity.SignIns to 1.8.0;
  * Updated Microsoft.Graph.Planner to 1.8.0;
  * Updated Microsoft.Graph.Teams to 1.8.0;
  * Updated Microsoft.Graph.Users to 1.8.0;
  * Updated MSCloudLoginAssistant to version 1.0.74;
* MISC
  * Fixed issue generating delta report containing EXOAvailabilityConfig
    resources;

# 1.21.1013.1

* Obfuscating Authentication Secrets from the Verbose output;

# 1.21.1006.3

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
  * Fixed issue where SCDLPCompliance rule failed when using sensitivity labels;
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

* EXOSafeAttachmentRule
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

# 1.21.519.1

* TeamsClientConfiguration
  * Fixed an issue where the RestrictedSenderList was not properly
    being converted to a comma separated string.
    Issue #1191
* DEPENDENCIES
  * Updated AzureADPreview to version 2.0.2.136;

# 1.21.512.1

* EXOOfflineAddressBook
  * Fixed issue in Set-TargetResource where ConfiguredAttributes
    was passed and resulted in an error.
* SCDLPComplianceRule
  * Added several new parameters
  * Fixed several bugs on extract

# 1.21.505.1

* EXOTransportRule
  * Adding ExceptIfSCLOver and SCLOver.
  * Fixes SubjectOrBodyContainsWords parameter not being an array.
  * Fixes DateTime formatting on ExpiryDate and ActivationDate

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
  * Fixed issue where an existing site script could not be updated.
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
  * Temporarily removed the use of AllowAnonymousUsersToDialOut
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
    discrepancy report between export of tenant and a BluePrint;
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
    if ObjectId was specified;
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
  * Generalized the URL not to capture hardcoded domains;
* SPOSiteGroup
  * Fixed an issue where now, groups with Null owners are not extracted;
  * Generalized the URL not to capture hardcoded domains;
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
  * Removed dependency on MSOnline;
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
