# TeamsAudioConferencingPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Specify the name of the policy that you are creating | |
| **AllowTollFreeDialin** | Write | Boolean | Determines whether users of the Policy can have Toll free numbers | |
| **MeetingInvitePhoneNumbers** | Write | String | Determines the list of audio-conferencing Toll- and Toll-free telephone numbers that will be included in meetings invites created by users of this policy. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |


## Description

Configures a Teams Audio Conferencing Policy.

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
        TeamsAudioConferencingPolicy 'Example'
        {
            AllowTollFreeDialin       = $True
            Credential                = $Credscredential
            Ensure                    = 'Present'
            Identity                  = 'Global'
            MeetingInvitePhoneNumbers = @()
        }
    }
}
```

