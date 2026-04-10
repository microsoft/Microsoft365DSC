# Microsoft365DSC – October 2025 Major Release (version 1.25.1001.1)

As defined by our [Breaking Changes Policy](https://microsoft365dsc.com/concepts/breaking-changes/), twice a year we allow for breaking changes to be deployed as part of a release. Our next major release, scheduled to go out on October 21st 2025, will include several breaking changes and will be labeled version 1.25.1001.1. This article provides details on the breaking changes and other important updates that will be included as part of our October 2025 Major release.

## EXOGroupSettings - Renaming the UnifiedGroupWelcomeMessageEnabled Parameter ([#6531](https://github.com/microsoft/Microsoft365DSC/pull/6531))

The UnifiedGroupWelcomeMessageEnabled parameter of the EXOGroupsSettings resource will be renamed to WelcomeMessageEnabled to match the cmdlet's properties. To fix this in your existing configuration, simply search for instance of EXOGroupSettings and do a find and replace for the UnifiedGroupWelcomeMessageEnable property and replace it by WelcomeMessageEnabled.

## EXOHostedContentFilterPolicy - Removed Deprecated Parameters ([#6036](https://github.com/microsoft/Microsoft365DSC/pull/6036))

The following parameters were removed from the EXOHostedContentFIlterPolicy resource given they have been deprecated for some time already:

* DownloadLink
* EnableEndUserSpamNotifications
* EndUserSpamNotificationCustomSubject
* EndUserSpamNotificationFrequency
* EndUserSpamNotificationLanguage

To fix existing configuration files, search for instance of these parameters in the configuration file and remove them.

## Removed 6 Intune Resources ([#6050](https://github.com/microsoft/Microsoft365DSC/pull/6050))

We've removed the following 6 resources due to them being deprecated or because of equivlent resource having been created (in the case of IntuneWifiConfigurationPolicyAndroidForWork):

* IntuneDeviceCompliancePolicyAndroid
* IntuneDeviceConfigurationPolicyAndroidDeviceAdministrator
* IntuneTrustedRootCertificateAndroidEnterprise
* IntuneVPNConfigurationPolicyAndroidEnterprise
* IntuneWifiConfigurationPolicyAndroidDeviceAdministrator
* IntuneWifiConfigurationPolicyAndroidForWork

To fix impacted configurations, simply remove any instances of the listed resources.

## EXORetentionPolicyTag - Changed AgeLimitForRetention from String to Integer ([#6103](https://github.com/microsoft/Microsoft365DSC/pull/6103))

The AgeLimitForRetention property of the EXORetentionPolicyTag was changed from being a String to being an Integer. To fix your configurations, simply search for this parameter and ensure they are specified as an Integer (e.g., remove quotes around the number).

## AADGroupEligibilitySchedule - Changed Mandatory Parameters ([#6124](https://github.com/microsoft/Microsoft365DSC/pull/6124))

In the AADGroupEligibilitySchedule, we've made the AccessId parameter mandatory and we've renamed the PrincipalDisplayName parameter to just principal and also made it mandatory. In order to fix your existing configurations, you need to make sure that every instance of AADGroupEligibilitySchedule specify both the Principal and AccessId parameters.

## IntuneAppProtectionPolicyAndroid and IntuneAppProtectionPolicyiOS Major Refactoring ([#6169](https://github.com/microsoft/Microsoft365DSC/pull/6169)), ([#6170](https://github.com/microsoft/Microsoft365DSC/pull/6170))

The IntuneAppProtectionPolicyAndroid and IntuneAppProtectionPolicyiOS resources underwent major refactoring as part of this major release. These changes were made to account for generic Intune assignments and to streamline its logic to better align it with other resources. Given the number of changes in the resources, it is recommended that existing instance of the resources in old configurations be reviewed manually to ensure alignment with the new changes. One alternative would be to use the Export/Snapshot feature to extract existing instances of these resources in the new proposed shape and include them as part of your configuration files.

## EXOClientAccessRule Deprecation ([#6379](https://github.com/microsoft/Microsoft365DSC/pull/6379))

The cmdlets associated with the EXOClientAccessRule resource have been deprecated as of September 1st, 2025 [Article](https://learn.microsoft.com/en-us/powershell/module/exchangepowershell/set-clientaccessrule?view=exchange-ps). To fix your configuration files, simply remove any instances of this resource.

## Removal of the SupportsScopeTags Parameter Across Intune Resources ([#6180](https://github.com/microsoft/Microsoft365DSC/pull/6180))

The SupportsScopeTags property, which is a read-only property, was removed across all Intune resources. To fix your configuration files, simply search instances of the property and remove them.

## Export-M365DSCConfiguration Behavior Change ([#6458](https://github.com/microsoft/Microsoft365DSC/pull/6458))

When calling the Export-M365DSCConfiguration cmldlet, the output directory will now be required at the beginning of the execution when not explicitely provided and the execution path will be changed to it. Temporary files will also be stored in the specified folder.

## AADEnrichedAuditLogs Deprecation ([#6473](https://github.com/microsoft/Microsoft365DSC/pull/6473))

The Microsoft Graph API endpoints associated with the AADEnrichedAuditLogs resources have been deprecated. As a result the resource was removed from the project. To fix your configuration files, simply remove all instances of the AADEnrichedAuditLogs resource from it.

## IntuneDeviceCleanupRule Deprecation ([#6483](https://github.com/microsoft/Microsoft365DSC/pull/6483))

The IntuneDeviceCleanupRule resource has been deprecated in favor of the IntuneDeviceCleanupRuleV2 resource. To fix your configuration, replace instances of IntuneDeviceCleanupRule resources with IntuneDeviceCleanupRuleV2 ones.

## IntuneASRRulesPolicyWindows10 Deprecation ([#6484](https://github.com/microsoft/Microsoft365DSC/pull/6484))

The IntuneASRRulesPolicyWindows10 resource is being deprecated in favor of the IntuneSettingCatalogASRRulesPolicyWindows10 one. To fix your configuration files, simply replace all instances of IntuneASRRulesPolicyWindows10 it with the new IntuneSettingCatalogASRRulesPolicyWindows10 resource.

## Multiple Deprecated Parameters Removed ([#6510](https://github.com/microsoft/Microsoft365DSC/pull/6510))

Parameters that have been marked deprecated since last release have been removed from the resources. In order to fix your configuration files, simply remove these properties when encountered. Here is the full list of resources and their associated deprecated parameters that are now being removed from the solution:

* **AADApplication:** AvailableToOtherTenants
* **AADAuthenticationMethodPolicy:** PolicyMigrationState
* **AADAuthenticationMethodPolicyAuthenticator:** NumberMatchingRequiredState
* **EXOFocusedInbox:** FocusedInboxOnLastUpdateTime
* **EXOHostedCOntentFilterPolicy:** ActionOnError
* **EXOSafeAttachmentPolicy:** ActionOnError
* **EXOTransportRule:** ApplyOME, ExceptIfHasSenderOverride, ExceptIfMessageContainsDataClassifications, HasSenderOverride, MessageContainsDataClassifications, NotifySender, RemoveOME
* **O365OrgSettings:** MicrosoftVivaBriefingEmail
* **ODSettings:** NotifyOwnersWhenInvitationsAccepted
* **SPOSharingSettings:** RequireAcceptingAccountMatchInvitedAccount
* **SPOTenantSettings:** UserVoiceForFeedbackEnabled
* **TeamsFederationConfiguration:** AllowPublicUsers
* **TeamsMeetingPolicy:** ForceStreamingAttendeeMode
* **TeamsShiftPolicy:** EnableShiftPresence
* **TeamsTenantDialPlan:** ExternalAccessPrefix, OptimizeDeviceDialing

## IntuneAccountProtection Resource is Removed ([#6510](https://github.com/microsoft/Microsoft365DSC/pull/6510))

The IntuneAccountProtection resource has been removed from this release. To fix your configuration files, simply remove any instances of that resource.

## EXOMobileDeviceMailboxPolicy Converted 2 Properties to Type Integer ([#6513](https://github.com/microsoft/Microsoft365DSC/pull/6513))

The MinPasswordComplexCharacters and PasswordHistory parameters of the EXOMobileDeviceMailboxPolicy resource have been converted from being of String type to Inteher type. To fix your existing configuration files, simply make sure that instances of EXOMobiledeviceMailboxPolicy that define these parameters are defining them as numbers instead of string (e.g. don't specify quotes).

## O365AdminAuditLogConfig - Removed the Ensure Parameter ([#6541](https://github.com/microsoft/Microsoft365DSC/pull/6541))

Since O365AdminAuditLogConfig is a tenant-wide resource where there can only ever be one instance, we are removing the Ensure parameter from it. To fix existing configuration files, search for an instance of this resource and make sure the Ensure parameter is removed.
