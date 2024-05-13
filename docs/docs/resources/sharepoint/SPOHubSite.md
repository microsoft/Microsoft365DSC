# SPOHubSite

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Url** | Key | String | The URL of the site collection | |
| **Title** | Write | String | The title of the hub site | |
| **Description** | Write | String | The description of the hub site | |
| **LogoUrl** | Write | String | The url to the logo of the hub site | |
| **RequiresJoinApproval** | Write | Boolean | Does the hub site require approval to join | |
| **AllowedToJoin** | Write | StringArray[] | The users or mail-enabled security groups which are allowed to associate their site with a hub site | |
| **SiteDesignId** | Write | String | The guid of the site design to link to the hub site | |
| **Ensure** | Write | String | Present ensures the site collection is registered as hub site, absent ensures it is unregistered | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the account to authenticate with. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for certificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

This resource allows users to configure a Site Collection as Hub Site
Collection and configure its properties.

NOTE:
The AllowedToJoin parameter accepts e-mail addresses (for users, Office
365 Groups and Mail-Enabled Security groups) or DisplayName (for
Security groups). However, when using DisplayName it is required that
there is only one group with that name. The resource will throw an
exception if there are multiple groups with that name found!

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Domain.Read.All, Group.Read.All

- **Update**

    - Domain.Read.All, Group.Read.All

#### Application permissions

- **Read**

    - Domain.Read.All, Group.Read.All

- **Update**

    - Domain.Read.All, Group.Read.All

### Microsoft SharePoint

To authenticate with the SharePoint API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Sites.FullControl.All

- **Update**

    - Sites.FullControl.All

#### Application permissions

- **Read**

    - Sites.FullControl.All

- **Update**

    - Sites.FullControl.All

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
        SPOHubSite 'ConfigureHubSite'
        {
            Url                  = "https://contoso.sharepoint.com/sites/Marketing"
            Title                = "Marketing Hub"
            Description          = "Hub for the Marketing division"
            LogoUrl              = "https://contoso.sharepoint.com/sites/Marketing/SiteAssets/hublogo.png"
            RequiresJoinApproval = $true
            AllowedToJoin        = @("admin@contoso.onmicrosoft.com", "superuser@contoso.onmicrosoft.com")
            SiteDesignId         = "f7eba920-9cca-4de8-b5aa-1da75a2a893c"
            Ensure               = "Present"
            Credential           = $Credscredential
        }
    }
}
```

