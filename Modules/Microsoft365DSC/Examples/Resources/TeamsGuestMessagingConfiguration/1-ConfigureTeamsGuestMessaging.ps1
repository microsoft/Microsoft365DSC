<#
This example is used to configure the tenant's Guest Messaging settings for Teams
#>

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
        TeamsGuestMessagingConfiguration TeamsGuestMessagingConfig
        {
            AllowGiphy             = $True;
            AllowImmersiveReader   = $False;
            AllowMemes             = $True;
            AllowStickers          = $True;
            AllowUserChat          = $True;
            AllowUserDeleteMessage = $False;
            AllowUserEditMessage   = $True;
            GiphyRatingType        = "Moderate";
            GlobalAdminAccount     = $credsglobaladmin;
            Identity               = "Global";
        }
    }
}
