# TeamsAppPermissionPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Unique identifier to be assigned to the new Teams app permission policy. Use the 'Global' Identity if you wish to assign this policy to the entire tenant. | |
| **Description** | Write | String | Enables administrators to provide explanatory text to accompany a Teams app permission policy. | |
| **GlobalCatalogAppsType** | Write | String | The types of apps for the Global Catalog. | |
| **PrivateCatalogAppsType** | Write | String | The types of apps for the Private Catalog. | |
| **DefaultCatalogAppsType** | Write | String | The types of apps for the Default Catalog. | |
| **GlobalCatalogApps** | Write | StringArray[] | The list of apps for the Global Catalog. | |
| **PrivateCatalogApps** | Write | StringArray[] | The list of apps for the Private Catalog. | |
| **DefaultCatalogApps** | Write | StringArray[] | The list of apps for the Default Catalog. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |


## Description

Manages the Teams App Permission Policies.

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
        TeamsAppPermissionPolicy "TeamsAppPermissionPolicy-Test-Policy"
        {
            Credential             = $Credscredential;
            DefaultCatalogApps     = "com.microsoft.teamspace.tab.vsts";
            DefaultCatalogAppsType = "AllowedAppList";
            Description            = "This is a test policy";
            Ensure                 = "Present";
            GlobalCatalogAppsType  = "BlockedAppList";
            Identity               = "TestPolicy";
            PrivateCatalogAppsType = "BlockedAppList";
        }
    }
}
```

