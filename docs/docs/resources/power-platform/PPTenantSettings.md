# PPTenantSettings

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Should be set to yes | `Yes` |
| **WalkMeOptOut** | Write | Boolean | When set to true this will disable the Walk Me guidance. | |
| **DisableNPSCommentsReachout** | Write | Boolean | When set to true this will disable the NPS Comments Reachout. | |
| **DisableNewsletterSendout** | Write | Boolean | When set to true this will disable the monthly newsletters. | |
| **DisableEnvironmentCreationByNonAdminUsers** | Write | Boolean | When set to true this will disable production environment creation by non-admin users. | |
| **DisablePortalsCreationByNonAdminUsers** | Write | Boolean | When set to true this will disable portal creation by non-admin users. | |
| **DisableSurveyFeedback** | Write | Boolean | When set to true this will disable survey feedback that sometimes pops up on top of an app. | |
| **DisableTrialEnvironmentCreationByNonAdminUsers** | Write | Boolean | When set to true this will disable trial environment creation by non-admin users. | |
| **DisableCapacityAllocationByEnvironmentAdmins** | Write | Boolean | When set to true this will disable capacity allocation by environment admins. | |
| **DisableSupportTicketsVisibleByAllUsers** | Write | Boolean | When set to true this will disable support tickets to be visible by all users. | |
| **DisableDocsSearch** | Write | Boolean | When set to true this will disable docs search in the Office 365 Suite navigation bar. | |
| **DisableCommunitySearch** | Write | Boolean | When set to true this will disable community search in the Office 365 Suite navigation bar. | |
| **DisableBingVideoSearch** | Write | Boolean | When set to true this will disable Bing video search in the Office 365 Suite navigation bar. | |
| **DisableShareWithEveryone** | Write | Boolean | When set to true this will disable the ability to share apps with the whole tenant. | |
| **EnableGuestsToMake** | Write | Boolean | When set to true this will enable the ability for guests in your tenant to create Power Platform resources. | |
| **ShareWithColleaguesUserLimit** | Write | UInt32 | The amount of people an app can be shared with in Dataverse for Teams (maximum is 10,000). | |
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

