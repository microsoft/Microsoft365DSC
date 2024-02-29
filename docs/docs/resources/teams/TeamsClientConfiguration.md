# TeamsClientConfiguration

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The only valid input is Global - the tenant wide configuration | `Global` |
| **AllowBox** | Write | Boolean | Designates whether users are able to leverage Box as a third party storage solution in Microsoft Teams. If $true, users will be able to add Box in the client and interact with the files stored there. | |
| **AllowDropBox** | Write | Boolean | Designates whether users are able to leverage DropBox as a third party storage solution in Microsoft Teams. If $true, users will be able to add DropBox in the client and interact with the files stored there. | |
| **AllowEmailIntoChannel** | Write | Boolean | When set to $true, mail hooks are enabled, and users can post messages to a channel by sending an email to the email address of Teams channel. | |
| **AllowGoogleDrive** | Write | Boolean | Designates whether users are able to leverage GoogleDrive as a third party storage solution in Microsoft Teams. If $true, users will be able to add Google Drive in the client and interact with the files stored there. | |
| **AllowGuestUser** | Write | Boolean | Designates whether or not guest users in your organization will have access to the Teams client. If $true, guests in your tenant will be able to access the Teams client. Note that this setting has a core dependency on Guest Access being enabled in your Office 365 tenant. | |
| **AllowOrganizationTab** | Write | Boolean | When set to $true, users will be able to see the organizational chart icon other users' contact cards, and when clicked, this icon will display the detailed organizational chart. | |
| **AllowResourceAccountSendMessage** | Write | Boolean | Surface Hub uses a device account to provide email and collaboration services (IM, video, voice). This device account is used as the originating identity (the from party) when sending email, IM, and placing calls. As this account is not coming from an individual, identifiable user, it is deemed anonymous because it originated from the Surface Hub's device account. If set to $true, these device accounts will be able to send chat messages in Skype for Business Online (does not apply to Microsoft Teams). | |
| **AllowScopedPeopleSearchandAccess** | Write | Boolean | If set to $true, the Exchange address book policy (ABP) will be used to provide customized view of the global address book for each user. This is only a virtual separation and not a legal separation. | |
| **AllowShareFile** | Write | Boolean | Designates whether users are able to leverage ShareFile as a third party storage solution in Microsoft Teams. If $true, users will be able to add ShareFile in the client and interact with the files stored there. | |
| **AllowSkypeBusinessInterop** | Write | Boolean | When set to $true, Teams conversations automatically show up in Skype for Business for users that aren't enabled for Teams. | |
| **AllowEgnyte** | Write | Boolean | Designates whether users are able to leverage Egnyte as a third party storage solution in Microsoft Teams. If $true, users will be able to add Egnyte in the client and interact with the files stored there. | |
| **ContentPin** | Write | String | This setting applies only to Skype for Business Online (not Microsoft Teams) and defines whether the user must provide a secondary form of authentication to access the meeting content from a resource device account. Meeting content is defined as files that are shared to the Content Bin - files that have been attached to the meeting. | `NotRequired`, `RequiredOutsideScheduleMeeting`, `AlwaysRequired` |
| **ResourceAccountContentAccess** | Write | String | Require a secondary form of authentication to access meeting content. | `NoAccess`, `PartialAccess`, `FullAccess` |
| **RestrictedSenderList** | Write | StringArray[] | Senders domains can be further restricted to ensure that only allowed SMTP domains can send emails to the Teams channels. This is a comma-separated string of the domains you'd like to allow to send emails to Teams channels. | |
| **Credential** | Write | PSCredential | Credentials of the Teams Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource is used to configure the Teams client settings.

More information: https://docs.microsoft.com/en-us/microsoftteams/enable-features-office-365#teams-settings-and-teams-upgrade-settings-in-the-microsoft-teams-admin-center

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
        TeamsClientConfiguration 'TeamsClientConfiguration'
        {
            AllowBox                         = $True
            AllowDropBox                     = $True
            AllowEmailIntoChannel            = $True
            AllowGoogleDrive                 = $True
            AllowGuestUser                   = $True
            AllowOrganizationTab             = $True
            AllowResourceAccountSendMessage  = $True
            AllowScopedPeopleSearchandAccess = $False
            AllowShareFile                   = $True
            AllowSkypeBusinessInterop        = $True
            ContentPin                       = "RequiredOutsideScheduleMeeting"
            Identity                         = "Global"
            ResourceAccountContentAccess     = "NoAccess"
            Credential                       = $Credscredential
        }
    }
}
```

