# PPTenantSettings

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Should be set to yes | `Yes` |
| **DisableCopilotFeedback** | Write | Boolean | When using Copilot in Power Apps, allow users to submit feedback to Microsoft. Default value is false. | |
| **DisableMakerMatch** | Write | Boolean | TBD | |
| **DisableUnusedLicenseAssignment** | Write | Boolean | TBD | |
| **DisableCreateFromImage** | Write | Boolean | Allow people to use AI to generate an app based on an image. Default value is false. | |
| **DisableConnectionSharingWithEveryone** | Write | Boolean | Gets or sets a value indicating whether non-admin users in the tenant can share connections with everyone. Default value is false. | |
| **AllowNewOrgChannelDefault** | Write | Boolean | TBD | |
| **DisableCopilot** | Write | Boolean | Disables cloud flows copilot in Power Automate.

It doesn't control the ability to add AI-related connectors or actions in the flow designer. For example, the Skills connector or AI Builder creates text with a GPT action. Default value is false. | |
| **DisableCopilotWithBing** | Write | Boolean | Disables the copilot-enhanced help feature within Power Automate to enhance answers on product documentation through Bing Search. Default value is false. | |
| **DisableAdminDigest** | Write | Boolean | Disables the weekly admin digest email for Managed Environments. Default value is false. | |
| **DisablePreferredDataLocationForTeamsEnvironment** | Write | Boolean | Ignore the Teams group-preferred data location when provisioning a Teams environment. Default value is false. | |
| **DisableDeveloperEnvironmentCreationByNonAdminUsers** | Write | Boolean | Restrict all developer environments to be created by tenant admins, Power Platform admins, or Dynamics 365 service admins. Default is false. | |
| **EnvironmentRoutingAllMakers** | Write | Boolean | TBD | |
| **EnableDefaultEnvironmentRouting** | Write | Boolean | Enables the Default Environment routing feature that creates personal, developer environments for new makers. Default value is false. | |
| **EnableDesktopFlowDataPolicyManagement** | Write | String | When this setting is true, admins can view and manage desktop flow action groups in DLP policies in the Power Platform admin center. Default value is false. | |
| **EnableCanvasAppInsights** | Write | Boolean | Allow users to collect telemetry data about their app in Azure Application Insights. Setting this to False blocks the transmission of this data. | |
| **DisableCreateFromFigma** | Write | Boolean | Allow people to create a canvas app based on a Figma file. Default value is false. | |
| **DisableBillingPolicyCreationByNonAdminUsers** | Write | Boolean | This is a legacy setting that is no longer used by the platform. Default value is false. | |
| **StorageCapacityConsumptionWarningThreshold** | Write | UInt32 | This setting isn't currently used by the platform but might be used in the future. | |
| **EnableTenantCapacityReportForEnvironmentAdmins** | Write | Boolean | Ability to allow tenant, Power Platform, or Dynamics 365 admins to grant permissions to an environment administrator to view the Capacity summary tab. Default value is false. | |
| **EnableTenantLicensingReportForEnvironmentAdmins** | Write | Boolean | Ability to allow tenant, Power Platform, or Dynamics 365 admins to grant permissions to an environment administrator to view the tenant-scoped license reports. Default value is false. | |
| **DisableUseOfUnassignedAIBuilderCredits** | Write | Boolean | Ability to use unallocated AI Builder credits in environments without allocated credits. Default value is true. | |
| **EnableGenerativeAIFeaturesForSiteUsers** | Write | String | TBD | |
| **EnableExternalAuthenticationProvidersInPowerPages** | Write | String | TBD | |
| **DisableChampionsInvitationReachout** | Write | Boolean | This setting isn't currently used by the platform but might be used in the future. | |
| **DisableSkillsMatchInvitationReachout** | Write | Boolean | This setting isn't currently used by the platform but might be used in the future. | |
| **EnableOpenAiBotPublishing** | Write | Boolean | This setting isn't currently used by the platform but might be used in the future. | |
| **DisableAiPrompts** | Write | Boolean | TBD | |
| **DisableCopilotFeedbackMetadata** | Write | Boolean | When using Copilot in Power Apps, allow users to share their prompts, questions, and requests with Microsoft. Default value is true. | |
| **EnableModelDataSharing** | Write | Boolean | Ability to allow Microsoft to read Power Automate Copilot AI feature customer data (inputs and outputs) and provide improved models. Default value is false. | |
| **DisableDataLogging** | Write | Boolean | Ability to disable data logging and remove all data logged for Power Automate Copilot AI feature customer data (inputs and outputs). Default value is false. | |
| **PowerCatalogAudienceSetting** | Write | String | This setting is reserved for future use. No enforcement is driven by this setting at the current time. | |
| **EnableDeleteDisabledUserinAllEnvironments** | Write | Boolean | TBD | |
| **DisableHelpSupportCopilot** | Write | Boolean | TBD | |
| **DisableSurveyScreenshots** | Write | Boolean | TBD | |
| **WalkMeOptOut** | Write | Boolean | This is a legacy setting that is no longer used by the platform. Default value is false. | |
| **useSupportBingSearchByAllUsers** | Write | Boolean | TBD | |
| **DisableNPSCommentsReachout** | Write | Boolean | Ability to disable re-surveying users who left prior feedback via NPS prompts in Power Platform. Default value is false. | |
| **DisableNewsletterSendout** | Write | Boolean | Ability to disable the newsletter sendout feature. Default value is false. | |
| **DisableEnvironmentCreationByNonAdminUsers** | Write | Boolean | Restrict all environments to be created by tenant admins, Power Platform admins, or Dynamics 365 service admins. Default value is false. | |
| **DisablePortalsCreationByNonAdminUsers** | Write | Boolean | Restrict all portals to be created by tenant admins, Power Platform admins, or Dynamics 365 service admins. Default value is false. | |
| **DisableSurveyFeedback** | Write | Boolean | Ability to disable all NPS survey feedback prompts in Power Platform. Default value is false. | |
| **DisableTrialEnvironmentCreationByNonAdminUsers** | Write | Boolean | Restrict all trial environments to be created by tenant admins, Power Platform admins, or Dynamics 365 service admins. Default value is false. | |
| **DisableCapacityAllocationByEnvironmentAdmins** | Write | Boolean | Ability to disable capacity allocation by environment administrators. Default value is false. | |
| **DisableSupportTicketsVisibleByAllUsers** | Write | Boolean | Allows users, who already have access to the Help + Support page in Power Platform admin center, to see support requests created by other users in the tenant. Default value is True, which means this feature is turned off by default. | |
| **DisableDocsSearch** | Write | Boolean | When this setting is true, users in the environment can see a message that indicates Microsoft Learn and documentation search categories have been turned off by the administrator. Default value is false. | |
| **DisableCommunitySearch** | Write | Boolean | When this setting is true, users in the environment can see a message that indicates community and blog search categories have been turned off by the administrator. Default value is false. | |
| **DisableBingVideoSearch** | Write | Boolean | When this setting is true, users in the environment can see a message that indicates video search categories have been turned off by the administrator. Default value is false. | |
| **DisableShareWithEveryone** | Write | Boolean | 	Ability to turn off the Share with Everyone capability for nonadmin users in all Power Apps. Default value is true. | |
| **EnableGuestsToMake** | Write | Boolean | When set to true this will enable the ability for guests in your tenant to create Power Platform resources. | |
| **ShareWithColleaguesUserLimit** | Write | UInt32 | Maximum value setting for the number of users in a security group used to share an app built using Power Apps on Microsoft Teams. Default value is 10000 but can be increased or decreased, as required. | |
| **Credential** | Write | PSCredential | Credentials of the Power Platform Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |

## Description

This resource configures a Power Platform Tenant.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - None

- **Update**

    - None

#### Application permissions

- **Read**

    - None

- **Update**

    - None

## Examples

### Example 1

This example sets Power Platform tenant settings.

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
    PPTenantSettings 'PowerPlatformTenantSettings'
    {
      IsSingleInstance                               = 'Yes'
      WalkMeOptOut                                   = $false
      DisableNPSCommentsReachout                     = $false
      DisableNewsletterSendout                       = $false
      DisableEnvironmentCreationByNonAdminUsers      = $true
      DisablePortalsCreationByNonAdminUsers          = $false
      DisableSurveyFeedback                          = $false
      DisableTrialEnvironmentCreationByNonAdminUsers = $false
      DisableCapacityAllocationByEnvironmentAdmins   = $true
      DisableSupportTicketsVisibleByAllUsers         = $false
      DisableDocsSearch                              = $false
      DisableCommunitySearch                         = $false
      DisableBingVideoSearch                         = $false
      DisableShareWithEveryone                       = $false
      EnableGuestsToMake                             = $false
      ShareWithColleaguesUserLimit                   = 10000
      Credential                                     = $Credscredential
    }
  }
}
```

