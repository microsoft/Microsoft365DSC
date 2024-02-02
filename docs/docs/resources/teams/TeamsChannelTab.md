# TeamsChannelTab

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | Display Name of the Channel Tab. | |
| **TeamName** | Key | String | Display Name of the Team. | |
| **ChannelName** | Key | String | Display Name of the Channel. | |
| **TeamId** | Write | String | Unique Id of the Team of the instance on the source tenant. | |
| **TeamsApp** | Write | String | Id of the Teams App associated with the custom tab. | |
| **SortOrderIndex** | Write | UInt32 | Index of the sort order for the custom tab. | |
| **WebSiteUrl** | Write | String | Url of the website linked to the Channel Tab. | |
| **ContentUrl** | Write | String | Url of the content linked to the Channel Tab. | |
| **RemoveUrl** | Write | String | Url of the location used to remove the app. | |
| **EntityId** | Write | String | Id of the Entity linked to the Channel Tab. | |
| **Ensure** | Write | String | Present ensures the Tab exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Teams Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures a new Custom tab in a Channel.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - ChannelSettings.Read.All, Group.Read.All

- **Update**

    - Channel.Delete.All, ChannelSettings.Read.All, TeamsTab.Create, TeamsTab.ReadWrite.All

#### Application permissions

- **Read**

    - ChannelSettings.Read.All, Group.Read.All

- **Update**

    - Channel.Delete.All, ChannelSettings.Read.All, TeamsTab.Create, TeamsTab.ReadWrite.All

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        TeamsChannelTab 'ConfigureChannelTab'
        {
            ChannelName           = "General"
            ContentUrl            = "https://contoso.com"
            DisplayName           = "TestTab"
            SortOrderIndex        = "10100"
            TeamName              = "Contoso Team"
            TeamsApp              = "com.microsoft.teamspace.tab.web"
            WebSiteUrl            = "https://contoso.com"
            Ensure                = "Present"
            ApplicationId         = "12345"
            CertificateThumbprint = "ABCDEF1234567890"
            TenantId              = "contoso.onmicrosoft.com"
        }
    }
}
```

