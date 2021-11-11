# TeamsGuestMessagingConfiguration

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The only valid input is Global - the tenant wide configuration |Global|
| **AllowUserEditMessage** | Write | Boolean | Determines if a user is allowed to edit their own messages. ||
| **AllowUserDeleteMessage** | Write | Boolean | Determines if a user is allowed to delete their own messages. ||
| **AllowUserChat** | Write | Boolean | Determines if a user is allowed to chat. ||
| **GiphyRatingType** | Write | String | Determines Giphy content restrictions. Default value is Moderate, other options are Strict and NoRestriction. |Moderate, Strict, NoRestriction|
| **AllowMemes** | Write | Boolean | Determines if memes are available for use. ||
| **AllowStickers** | Write | Boolean | Determines if stickers are available for use. ||
| **AllowGiphy** | Write | Boolean | Determines if Giphy are available for use. ||
| **AllowImmersiveReader** | Write | Boolean | Determines if Immersive Reader is enabled. ||
| **Credential** | Required | PSCredential | Credentials of the Teams Admin ||

## Description

This resource is used to configure the Teams Guest Messaging Configuration.

## Examples

### Example 1

This example is used to configure the tenant's Guest Messaging settings for Teams

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
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
            Credential             = $credsglobaladmin
        }
    }
}
```

