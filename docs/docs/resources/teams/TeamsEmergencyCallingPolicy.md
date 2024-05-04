# TeamsEmergencyCallingPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Identity of the Teams Emergency Calling Policy. | |
| **Description** | Write | String | Description of the Teams Emergency Calling Policy. | |
| **EnhancedEmergencyServiceDisclaimer** | Write | String | Allows the tenant administrator to configure a text string, which is shown at the top of the Calls app. | |
| **ExternalLocationLookupMode** | Write | String | Enables ExternalLocationLookupMode. This mode allows users to set Emergency addresses for remote locations. | `Disabled`, `Enabled` |
| **NotificationDialOutNumber** | Write | String | This parameter represents PSTN number which can be dialed out if NotificationMode is set to either of the two Conference values. | |
| **NotificationGroup** | Write | String | NotificationGroup is a email list of users and groups to be notified of an emergency call. | |
| **NotificationMode** | Write | String | The type of conference experience for security desk notification. | `NotificationOnly`, `ConferenceMuted`, `ConferenceUnMuted` |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Teams Global Admin. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

This resource configures the Teams Emergency Calling Policies.

More information: https://docs.microsoft.com/en-us/microsoftteams/manage-emergency-calling-policies

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

This example adds a new Teams Emergency Calling Policy.

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
        TeamsEmergencyCallingPolicy 'ConfigureEmergencyCallingPolicy'
        {
            Description               = "Demo"
            Identity                  = "Demo Emergency Calling Policy"
            NotificationDialOutNumber = "+1234567890"
            NotificationGroup         = 'john.smith@contoso.com'
            NotificationMode          = "NotificationOnly"
            Ensure                    = 'Present'
            Credential                = $Credscredential
        }
    }
}
```

