# TeamsFilesPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Specifies the policy instance name | |
| **NativeFileEntryPoints** | Write | String | Specifies whether users see the options to upload files from OneDrive for Business, other cloud storage services configured for the user account, and SharePoint Online | `Enabled`, `Disabled` |
| **SPChannelFilesTab** | Write | String | Specifies whether users see the Teams Files channel tab in any channel or in Teams chat. | `Enabled`, `Disabled` |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |


## Description


New-CsTeamsFilesPolicy [-Identity] <string> [-NativeFileEntryPoints <string>] [-SPChannelFilesTab <string>] [-MsftInternalProcessingMode <string>] [-WhatIf] [-Confirm] [<CommonParameters>]


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
        TeamsFilesPolicy 'Example'
        {
            Credential            = $Credscredential;
            Ensure                = "Present";
            Identity              = "Global";
            NativeFileEntryPoints = "Enabled";
            SPChannelFilesTab     = "Enabled";
        }
    }
}
```

