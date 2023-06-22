# O365OrgSettings

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Specifies the resource is a single instance, the value must be 'Yes' | `Yes` |
| **CortanaEnabled** | Write | Boolean | Allow Cortana in windows 10 (version 1909 and earlier), and the Cortana app on iOS and Android, to access Microsoft-hosted data on behalf of people in your organization. | |
| **M365WebEnableUsersToOpenFilesFrom3PStorage** | Write | Boolean | Let users open files stored in third-party storage services in Microsoft 365 on the Web. | |
| **MicrosoftVivaBriefingEmail** | Write | Boolean | Specifies whether or not to let people in your organization receive Briefing email from Microsoft Viva. | |
| **VivaInsightsWebExperience** | Write | Boolean | Specifies whether or not to allow users to have access to use the Viva Insights web experience. | |
| **VivaInsightsDigestEmail** | Write | Boolean | Specifies whether or not to allow users to have access to use the Viva Insights digest email feature. | |
| **VivaInsightsOutlookAddInAndInlineSuggestions** | Write | Boolean | Specifies whether or not to allow users to have access to use the Viva Insights Outlook add-in and inline suggestions. | |
| **VivaInsightsScheduleSendSuggestions** | Write | Boolean | Specifies whether or not to allow users to have access to use the Viva Insights schedule send suggestions feature. | |
| **PlannerAllowCalendarSharing** | Write | Boolean | Allow Planner users to publish their plans and assigned tasks to Outlook or other calendars through iCalendar feeds. | |
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

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- 

#### Role Groups

- None

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

