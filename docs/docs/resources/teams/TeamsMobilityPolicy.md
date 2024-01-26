# TeamsMobilityPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Specify the name of the Teams Mobility Policy. | |
| **Description** | Write | String | Enables administrators to provide explanatory text about the policy. For example, the Description might indicate the users the policy should be assigned to. | |
| **IPAudioMobileMode** | Write | String | When set to WifiOnly, prohibits the user from making and receiving calls or joining meetings using VoIP calls on the mobile device while on a cellular data connection. Possible values are: WifiOnly, AllNetworks. | `WifiOnly`, `AllNetworks` |
| **IPVideoMobileMode** | Write | String | When set to WifiOnly, prohibits the user from making and receiving video calls or enabling video in meetings using VoIP calls on the mobile device while on a cellular data connection. Possible values are: WifiOnly, AllNetworks. | `WifiOnly`, `AllNetworks` |
| **MobileDialerPreference** | Write | String | Determines the mobile dialer preference, possible values are: Teams, Native, UserOverride. | `Teams`, `Native`, `UserOverride` |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |


## Description

The TeamsMobilityPolicy allows Admins to control Teams mobile usage for users.

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

    - Organization.Read.All, User.Read.All, Group.ReadWrite.All, AppCatalog.ReadWrite.All, TeamSettings.ReadWrite.All, Channel.Delete.All, ChannelSettings.ReadWrite.All, ChannelMember.ReadWrite.All

- **Update**

    - Organization.Read.All, User.Read.All, Group.ReadWrite.All, AppCatalog.ReadWrite.All, TeamSettings.ReadWrite.All, Channel.Delete.All, ChannelSettings.ReadWrite.All, ChannelMember.ReadWrite.All

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
        TeamsMobilityPolicy 'Example'
        {
            Credential             = $Credscredential;
            Ensure                 = "Present";
            Identity               = "Global";
            IPAudioMobileMode      = "AllNetworks";
            IPVideoMobileMode      = "AllNetworks";
            MobileDialerPreference = "Teams";
        }
    }
}
```

