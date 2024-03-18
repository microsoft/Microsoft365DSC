# TeamsGuestMessagingConfiguration

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The only valid input is Global - the tenant wide configuration | `Global` |
| **AllowUserEditMessage** | Write | Boolean | Determines if a user is allowed to edit their own messages. | |
| **AllowUserDeleteMessage** | Write | Boolean | Determines if a user is allowed to delete their own messages. | |
| **AllowUserChat** | Write | Boolean | Determines if a user is allowed to chat. | |
| **AllowUserDeleteChat** | Write | Boolean | Turn this setting on to allow users to permanently delete their one-on-one chat, group chat, and meeting chat as participants (this deletes the chat only for them, not other users in the chat). | |
| **GiphyRatingType** | Write | String | Determines Giphy content restrictions. Default value is Moderate, other options are Strict and NoRestriction. | `Moderate`, `Strict`, `NoRestriction` |
| **AllowMemes** | Write | Boolean | Determines if memes are available for use. | |
| **AllowStickers** | Write | Boolean | Determines if stickers are available for use. | |
| **AllowGiphy** | Write | Boolean | Determines if Giphy are available for use. | |
| **AllowImmersiveReader** | Write | Boolean | Determines if Immersive Reader is enabled. | |
| **Credential** | Write | PSCredential | Credentials of the Teams Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource is used to configure the Teams Guest Messaging Configuration.

More information: https://docs.microsoft.com/en-us/microsoftteams/set-up-guests

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

This example is used to configure the tenant's Guest Messaging settings for Teams

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
        TeamsGuestMessagingConfiguration 'TeamsGuestMessagingConfig'
        {
            Identity               = "Global"
            AllowGiphy             = $True
            AllowImmersiveReader   = $False
            AllowMemes             = $True
            AllowStickers          = $True
            AllowUserChat          = $True
            AllowUserDeleteMessage = $False
            AllowUserEditMessage   = $True
            GiphyRatingType        = "Moderate"
            Credential             = $Credscredential
        }
    }
}
```

