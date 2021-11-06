# TeamsChannelTab

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | Display Name of the Channel Tab. ||
| **TeamName** | Required | String | Display Name of the Team. ||
| **ChannelName** | Required | String | Display Name of the Channel. ||
| **TeamId** | Write | String | Unique Id of the Team of the instance on the source tenant. ||
| **TeamsApp** | Write | String | Id of the Teams App associated with the custom tab. ||
| **SortOrderIndex** | Write | UInt32 | Index of the sort order for the custom tab. ||
| **WebSiteUrl** | Write | String | Url of the website linked to the Channel Tab. ||
| **ContentUrl** | Write | String | Url of the content linked to the Channel Tab. ||
| **RemoveUrl** | Write | String | Url of the location used to remove the app. ||
| **EntityId** | Write | String | Id of the Entity linked to the Channel Tab. ||
| **Ensure** | Write | String | Present ensures the Tab exists, absent ensures it is removed. |Present, Absent|
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||

# TeamsChannelTab

### Description

This resource configures a new Custom tab in a Channel.

## Azure AD Permissions

To authenticate via Azure Active Directory, this resource
required the following Application permissions:

* **Automate**
  * Microsoft.Graph
    * Channel.ReadBasic.All
    * Group.Read.All
    * Team.ReadBasic.All
    * TeamsTab.ReadWrite.All
* **Export**
  * Microsoft.Graph
    * Channel.ReadBasic.All
    * Group.Read.All
    * Team.ReadBasic.All
    * TeamsTab.Read.All

NOTE: All permisions listed above require admin consent.

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

