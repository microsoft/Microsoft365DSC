# O365OrgSettings

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Specifies the resource is a single instance, the value must be 'Yes' | `Yes` |
| **AppsAndServicesIsAppAndServicesTrialEnabled** | Write | Boolean | Allow people in your organization to start trial subscriptions for apps and services that support trials. Admins manage licenses for these trials in the same way as other licenses in your organization. Only admins can upgrade these trials to paid subscriptions, so they wonât affect your billing. | |
| **AppsAndServicesIsOfficeStoreEnabled** | Write | Boolean | Allow people in your organization to access the Office Store using their work account. The Office Store provides access to apps that aren't curated or managed by Microsoft. | |
| **CortanaEnabled** | Write | Boolean | Allow Cortana in windows 10 (version 1909 and earlier), and the Cortana app on iOS and Android, to access Microsoft-hosted data on behalf of people in your organization. | |
| **DynamicsCustomerVoiceIsInOrgFormsPhishingScanEnabled** | Write | Boolean | Automatically block any internal surveys that request confidential information. Admins will be notified in the Message Center when a survey is blocked. | |
| **DynamicsCustomerVoiceIsRecordIdentityByDefaultEnabled** | Write | Boolean | Capture the first and last names of respondents in your organization that complete a survey. You can still change this for individual surveys. | |
| **DynamicsCustomerVoiceIsRestrictedSurveyAccessEnabled** | Write | Boolean | Capture the first and last names of respondents in your organization that complete a survey. You can still change this for individual surveys. | |
| **FormsIsBingImageSearchEnabled** | Write | Boolean | Allow YouTube and Bing. | |
| **FormsIsExternalSendFormEnabled** | Write | Boolean | External Sharing - Send a link to the form and collect responses. | |
| **FormsIsExternalShareCollaborationEnabled** | Write | Boolean | External Sharing - Share to collaborate on the form layout and structure. | |
| **FormsIsExternalShareResultEnabled** | Write | Boolean | External Sharing - Share form result summary. | |
| **FormsIsExternalShareTemplateEnabled** | Write | Boolean | External Sharing - Share the form as a template that can be duplicated. | |
| **FormsIsInOrgFormsPhishingScanEnabled** | Write | Boolean | Phishing protection. | |
| **FormsIsRecordIdentityByDefaultEnabled** | Write | Boolean | Record names of people in your org. | |
| **M365WebEnableUsersToOpenFilesFrom3PStorage** | Write | Boolean | Let users open files stored in third-party storage services in Microsoft 365 on the Web. | |
| **MicrosoftVivaBriefingEmail** | Write | Boolean | Specifies whether or not to let people in your organization receive Briefing email from Microsoft Viva. | |
| **VivaInsightsWebExperience** | Write | Boolean | Specifies whether or not to allow users to have access to use the Viva Insights web experience. | |
| **VivaInsightsDigestEmail** | Write | Boolean | Specifies whether or not to allow users to have access to use the Viva Insights digest email feature. | |
| **VivaInsightsOutlookAddInAndInlineSuggestions** | Write | Boolean | Specifies whether or not to allow users to have access to use the Viva Insights Outlook add-in and inline suggestions. | |
| **VivaInsightsScheduleSendSuggestions** | Write | Boolean | Specifies whether or not to allow users to have access to use the Viva Insights schedule send suggestions feature. | |
| **PlannerAllowCalendarSharing** | Write | Boolean | Allow Planner users to publish their plans and assigned tasks to Outlook or other calendars through iCalendar feeds. | |
| **ToDoIsExternalJoinEnabled** | Write | Boolean | To Do - Allow external users to join. | |
| **ToDoIsExternalShareEnabled** | Write | Boolean | To Do - Allow sharing with external users. | |
| **ToDoIsPushNotificationEnabled** | Write | Boolean | To Do - Allow your users to receive push notifications. | |
| **AdminCenterReportDisplayConcealedNames** | Write | Boolean | Controls whether or not the Admin Center reports will conceale user, group and site names. | |
| **InstallationOptionsUpdateChannel** | Write | String | Defines how often you want your users to get feature updates for Microsoft 365 apps installed on devices running Windows | `current`, `monthlyEnterprise`, `semiAnnual` |
| **InstallationOptionsAppsForWindows** | Write | StringArray[] | Defines the apps users can install on Windows and mobile devices. | `isVisioEnabled`, `isSkypeForBusinessEnabled`, `isProjectEnabled`, `isMicrosoft365AppsEnabled` |
| **InstallationOptionsAppsForMac** | Write | StringArray[] | Defines the apps users can install on Mac devices. | `isSkypeForBusinessEnabled`, `isMicrosoft365AppsEnabled` |
| **Credential** | Write | PSCredential | Credentials of the Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures the Org settings for a Microsoft 365 tenant.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Application.ReadWrite.All, ReportSettings.Read.All, OrgSettings-Microsoft365Install.Read.All, OrgSettings-Forms.Read.All, OrgSettings-Todo.Read.All, OrgSettings-AppsAndServices.Read.All, OrgSettings-DynamicsVoice.Read.All

- **Update**

    - Application.ReadWrite.All, ReportSettings.ReadWrite.All, OrgSettings-Microsoft365Install.ReadWrite.All, OrgSettings-Forms.ReadWrite.All, OrgSettings-Todo.ReadWrite.All, OrgSettings-DynamicsVoice.ReadWrite.All, OrgSettings-AppsAndServices.Read.All

#### Application permissions

- **Read**

    - Application.ReadWrite.All, ReportSettings.Read.All, OrgSettings-Microsoft365Install.Read.All, OrgSettings-Forms.Read.All, OrgSettings-Todo.Read.All, OrgSettings-AppsAndServices.Read.All, OrgSettings-DynamicsVoice.Read.All, Tasks.Read.All

- **Update**

    - Application.ReadWrite.All, ReportSettings.ReadWrite.All, OrgSettings-Microsoft365Install.ReadWrite.All, OrgSettings-Forms.ReadWrite.All, OrgSettings-Todo.ReadWrite.All, OrgSettings-AppsAndServices.ReadWrite.All, OrgSettings-DynamicsVoice.ReadWrite.All, Tasks.ReadWrite.All

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
        O365OrgSettings 'O365OrgSettings'
        {
            AdminCenterReportDisplayConcealedNames     = $True;
            Credential                                 = $Credscredential;
            IsSingleInstance                           = "Yes";
            M365WebEnableUsersToOpenFilesFrom3PStorage = $False;
            PlannerAllowCalendarSharing                = $False
        }
    }
}
```

