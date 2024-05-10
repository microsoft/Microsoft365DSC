# TeamsIPPhonePolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Specifies the policy instance name | |
| **AllowBetterTogether** | Write | String | Determines whether Better Together mode is enabled, phones can lock and unlock in an integrated fashion when connected to their Windows PC running a 64-bit Teams desktop client. | `Enabled`, `Disabled` |
| **AllowHomeScreen** | Write | String | Determines whether the Home Screen feature of the Teams IP Phones is enabled. | `Enabled`, `EnabledUserOverride`, `Disabled` |
| **AllowHotDesking** | Write | Boolean | Determines whether hot desking mode is enabled. | |
| **Description** | Write | String | Specifies the description of the policy | |
| **HotDeskingIdleTimeoutInMinutes** | Write | UInt64 | Determines the idle timeout value in minutes for the signed in user account. When the timeout is reached, the account is logged out. | |
| **SearchOnCommonAreaPhoneMode** | Write | String | Determines whether a user can search the Global Address List in Common Area Phone Mode. | `Enabled`, `Disabled` |
| **SignInMode** | Write | String | Determines the sign in mode for the device when signing in to Teams. | `UserSignIn`, `CommonAreaPhoneSignIn`, `MeetingSignIn` |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

New-CsTeamsIPPhonePolicy allows you to create a policy to manage features related to Teams phone experiences. Teams phone policies determine the features that are available to users.

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
        TeamsIPPhonePolicy 'Example'
        {
            AllowBetterTogether            = "Enabled";
            AllowHomeScreen                = "EnabledUserOverride";
            AllowHotDesking                = $True;
            Credential                     = $Credscredential;
            Ensure                         = "Present";
            HotDeskingIdleTimeoutInMinutes = 120;
            Identity                       = "Global";
            SearchOnCommonAreaPhoneMode    = "Enabled";
            SignInMode                     = "UserSignIn";
        }
    }
}
```

