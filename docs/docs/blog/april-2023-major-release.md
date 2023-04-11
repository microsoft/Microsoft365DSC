# Microsoft365DSC – April 2023 Major Release (version 1.23.405.1)

As defined by our [Breaking Changes Policy](https://microsoft365dsc.com/concepts/breaking-changes/), twice a year we allow for breaking changes to be deployed as part of a release. Our next major release, scheduled to go out on April 5th 2023, will include several breaking changes and will be labeled version 1.23.405.1. This article provides details on the breaking changes and other important updates that will be included as part of our April 2023 Major release.

## IntuneDeviceEnrollmentPlatformRestriction ([#2431](https://github.com/microsoft/Microsoft365DSC/pull/2431))

As part of the April 2023 major release, this resource is being re-written almost entirely to account for new properties. The recommendation is to stop using old instances of it and start fresh by using this new updated version. One option would be to use the **Export-M365DSCConfiguration** cmdlet and target only this resource. Then, replace the existing instances in your configurations with the newly extracted content.

## Primary Keys of Multiple Resources ([#2968](https://github.com/microsoft/Microsoft365DSC/pull/2968))

We have modified the logic of all the resources below to ensure we have a primary key defined. In most cases we have marked the Identity or DisplayName properties as now being mandatory. While we don't believe this change will have a major impact on most existing configuration since they probably already defined these properties, there is a small chance that customers omitted to include them. The recommendation in this case is to ensure you add the new required properties to your resources. Resources impacted are:

* AADAdministrativeUnit
* AADConditionalAccessPolicy
* AADEntitlementManagementAccessPackage
* AADEntitlementManagementAccessPackageAssignmentPolicy
* AADEntitlementManagementAccessPackageCatalog
* AADEntitlementManagementAccessPackageCatalogResource
* AADEntitlementManagementAccessPackageCatalogResource
* AADEntitlementManagementConnectedOrganization
* AADRoleSetting
* IntuneDeviceConfigurationPolicyAndroidDeviceAdministrator
* IntuneDeviceConfigurationPolicyAndroidDeviceOwner
* IntuneDeviceConfigurationPolicyAndroidOpenSourceProject
* IntuneDeviceConfigurationPolicyMacOS
* IntuneDeviceConfigurationPolicyiOS
* IntuneExploitProtectionPolicyWindows10SettingCatalog
* IntuneWifiConfigurationPolicyAndroidDeviceAdministrator
* IntuneWifiConfigurationPolicyAndroidEnterpriseDeviceOwner
* IntuneWifiConfigurationPolicyAndroidEnterpriseWorkProfile
* IntuneWifiConfigurationPolicyAndroidForWork
* IntuneWifiConfigurationPolicyAndroidOpenSourceProject
* IntuneWifiConfigurationPolicyIOS,
* IntuneWifiConfigurationPolicyMacOS
* IntuneWifiConfigurationPolicyWindows10
* IntuneWindowUpdateForBusinessRingUpdateProfileWindows10
* IntuneWindowsUpdateForBusinessRingUpdateProfileWindows10
* IntuneWindowsInformationProtectionPolicyWindows10MdmEnrolled
* IntuneWindowsUpdateForBusinessFeatureUpdateProfileWindows10

## Removed the Identity Parameters from EXOIRMConfiguration, EXOPerimeterConfiguration & EXOResourceConfiguraton

The Identity parameter, which was the primary key for the resources listed, has been replaced by the IsSingleInstance parameter. This is because there could only ever be one instance of these resources on the tenants and in order to align with other tenant-wide resources, the IsSingleInstance parameter needs to be present. This parameter only ever accepts a value of 'Yes' and its sole purpose is to ensure there isn't more than one instance of the given resource per configuration file.

## IntuneAttackSurfaceReductionRulesPolicyWindows10ConfigManager ([#3003](https://github.com/microsoft/Microsoft365DSC/pull/3003))

As part of this release, we are changing the DisplayName parameter to be required. Current configurations should make sure to include this parameter to avoid any conflicts when upgrading.

## Corrected typos in resource names ([#3024](https://github.com/microsoft/Microsoft365DSC/pull/3024))

Three resources had typos in their names. With this release these typos are now corrected:

* IntuneWifiConfigurationPolicyAndroidEntrepriseDeviceOwner: Changed Entreprise into Enterprise
* IntuneWifiConfigurationPolicyAndroidEntrepriseWorkProfile: Changed Entreprise into Enterprise
* IntuneWindowUpdateForBusinessRingUpdateProfileWindows10: Changed Window into Windows

## Removal of Deprecated Parameters ([#3040](https://github.com/microsoft/Microsoft365DSC/pull/3040))

We are removing parameters that have been deprecated from various resources as part of this major update. As a reminder, parameters that become deprecated on Microsoft 365 are being marked as deprecated in Microsoft365DSC until the next major release. In the past, using these parameters would have resulted in a warning letting the users know that they are using a deprecated parameter and that it would simply be ignored. Starting with this release, using these deprecated parameters will generate an error. It is recommended to scan existing configurations and remove deprecated parameters. The following resources have deprecated parameters that have been removed as part of this release, along with the parameters that have been removed:

<ul>
 <li>AADApplication
  <ul>
   <li>Oauth2RequirePostResponse</li>
  </ul>
 </li>
 <li>AADConditionalAccessPolicy
  <ul>
  <li>IncludeDevices</li>
  <li>ExcludeDevices</li>
   </ul></li>
 <li>AADUser
  <ul>
  <li>PreferredDataLocation</li>
   </ul></li>
 <li>EXOAntiPhishPolicy
  <ul>
  <li>EnableAntispoofEnforcement</li>
  <li>TargetedDomainProtectionAction</li>
   </ul></li>
 <li>EXOHostedContentFilterPolicy
  <ul>
  <li>EndUserSpamNotificationCustomFromAddress</li>
  <li>EndUserSpamNotificationCustomFromName</li>
   </ul></li>
 <li>EXOMalwareFilterPolicy
  <ul>
  <li>Action</li>
  <li>CustomAlertText</li>
  <li>EnableExternalSenderNotifications</li>
  <li>EnableInternalSenderNotifications</li>
   </ul></li>
 <li>EXOOrganizationConfig
  <ul>
  <li>AllowPlusAddressInRecipients</li>
  </ul>
 <li>EXOSaveLinksPolicy
  <ul>
 <li>DoNotAllowClickThrough</li>
  <li>DoNotTrackUserClicks</li>
  <li>IsEnabled</li>
   </ul></li>
 <li>EXOSharedMailbox
  <ul>
  <li>Aliases</li>
   </ul></li>
 <li>EXOTransportRule
  <ul>
  <li>ExceptIfMessageContainsAllDataClassifications</li>
  <li>IncidentReportOriginalMail</li>
  <li>MessageContainsAllDataClassifications</li>
   </ul></li>
 <li>SCSensitivityLabel
  <ul>
  <li>Disabled
  <li>ApplyContentMarkingFooterFontName</li>
  <li>ApplyContentMarkingHeaderFontName</li>
  <li>ApplyWaterMarkingFontName</li>
  <li>EncryptionAipTemplateScopes</li>
   </ul></li>
 <li>SPOTenantSettings
  <ul>
  <li>RequireAcceptingAccountMatchInvitedAccount</li>
   </ul></li>
 <li>TeamsMeetingPolicy
  <ul>
   <li>RecordingStorageMode</li>
  </ul>
  </li>
</ul>

## TeamsGroupPolicyAssignment: New Key Parameters ([3054](https://github.com/microsoft/Microsoft365DSC/issues/3054))

TeamsGroupPolicyAssignment used to have the Priority as key parameter. This could cause issues due to duplicate keys. With this release the previous key is now replaced by the following three parameters: GroupId, GroupDisplayName and PolicyType. This will ensure that the resource is unique and will not cause any issues. If the GroupId is not known or no group with the given id exists, the display name will be used instead.

## AADGroup - Added SecurityEnabled and MailEnabled as Mandatory Parameters ([#3077](https://github.com/microsoft/Microsoft365DSC/pull/3077))

We've updated the AADGroup resource to enforce the MailEnabled and SecurityEnabled parameters as mandatory. Omitting these parameters was throwing an error since they were required by the Microsoft Graph API associated with it. To update existing configurations, simply make sure that every instances of the AADGroup resource includes both the MailEnabled and SecurityEnabled parameters.

## Export - Resource Instance Logical Naming ([#3087](https://github.com/microsoft/Microsoft365DSC/pull/3087))

In order to make it easier for folks to follow the execution process of the Start-DSCConfiguration cmdlet and to keep the exported configuration files cleaner, we've changed the extraction logic to provide meaningful names to the extracted components. In the past, every instance extracted used to be assigned a GUID as its instance name. Starting with this release, extracted resources will be named based on the following logic:

1. If the resource implements the **IsSingleInstance** property, the resource instance's will simply take the resource's name. E.g.,

    ```powershell
      SPOTenantSettings 'SPOTenantSettings'
      {
          ...
      }
    ```

2. Otherwise, the resource will always be named following the "[ResourceName]-[PrimaryKey]" pattern. E.g.,

    ```powershell
      TeamsMeetingPolicy 'TeamsMeetingPolicy-MyPolicy'
      {
          DisplayName = 'MyPolicy'
          ...
      }
    ```

    The primary key will always give priority to the following properties in order:

    * DisplayName
    * Identity
    * Id
    * Name

    This means that if a resource instance defines both DisplayName and Id, that the DisplayName value will be used to name the instance.

## Logging Improvements for Non-Drifted Resource Instances ([#3090](https://github.com/microsoft/Microsoft365DSC/pull/3099))

Starting with this version of M365DSC, users can decide to also include information about resources that don't have any detected drifts in them by setting the logging settings with the new Set-M365DSCLoggingOption. E.g.,

```powershell
Set-M365DSCLoggingOption -IncludeNonDrifted $True
```

These events will be reported as Information entries having an Event ID of 2.
![image](https://raw.githubusercontent.com/microsoft/Microsoft365DSC/Dev/docs/docs/Images/April2023MR-EventViewer.png)

## Enforcing Tenant ID to be in Format '.onmicrosoft.' ([#3137](https://github.com/microsoft/Microsoft365DSC/pull/3137))

Starting with this version, the TenantID property will no longer be accepting GUIDs. Instead customers should provide their tenants' name, ideally in the format of <tenant>.onmicrosoft.<extension>.
