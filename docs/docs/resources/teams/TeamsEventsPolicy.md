# TeamsEventsPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Identity of the Teams Events Policy. | |
| **Description** | Write | String | Description of the Teams Events Policy. | |
| **AllowEmailEditing** | Write | String | This setting governs if a user is allowed to edit the communication emails in Teams Town Hall or Teams Webinar events. | `Disabled`, `Enabled` |
| **AllowEventIntegrations** | Write | Boolean | This setting governs access to the integrations tab in the event creation workflow. | |
| **AllowWebinars** | Write | String | Determines if webinars are allowed by the policy or not. | `Disabled`, `Enabled` |
| **AllowTownhalls** | Write | String | This setting governs if a user can create town halls using Teams Events. | `Disabled`, `Enabled` |
| **AllowedQuestionTypesInRegistrationForm** | Write | String | This setting governs which users in a tenant can add which registration form questions to an event registration page for attendees to answer when registering for the event. | `DefaultOnly`, `DefaultAndPredefinedOnly`, `AllQuestions` |
| **AllowedTownhallTypesForRecordingPublish** | Write | String | This setting describes how IT admins can control which types of Town Hall attendees can have their recordings published. | `None`, `InviteOnly`, `EveryoneInCompanyIncludingGuests`, `Everyone` |
| **AllowedWebinarTypesForRecordingPublish** | Write | String | This setting describes how IT admins can control which types of webinar attendees can have their recordings published. | `None`, `InviteOnly`, `EveryoneInCompanyIncludingGuests`, `Everyone` |
| **EventAccessType** | Write | String | Defines who is allowed to join the event. | `Everyone`, `EveryoneInCompanyExcludingGuests` |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **TownhallChatExperience** | Write | String | This setting governs whether the user can enable the Comment Stream chat experience for Town Halls. | `Optimized`, `None` |
| **UseMicrosoftECDN** | Write | Boolean | This setting governs whether the global admin disables this property and prevents the organizers from creating town halls that use Microsoft eCDN even though they have been assigned a Teams Premium license. | |
| **Credential** | Write | PSCredential | Credentials of the Teams Global Admin. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |


## Description

This resource configures the Teams Events Policies.

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

    - Organization.Read.All

- **Update**

    - Organization.Read.All

## Examples

### Example 1

This example adds a new Teams Events Policy.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsTeamsAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        TeamsEventsPolicy 'ConfigureEventsPolicy'
        {
            Identity             = "My Events Policy";
            Description          = "This is a my Events Policy";
            AllowWebinars        = "Disabled";
            EventAccessType      = "EveryoneInCompanyExcludingGuests";
            Credential           = $credsTeamsAdmin
            Ensure               = "Present";
        }
    }
}
```

