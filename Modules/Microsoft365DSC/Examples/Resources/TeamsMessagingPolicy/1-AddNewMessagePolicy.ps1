<#
This example adds a new Teams Messaging Policy.
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
        TeamsMessagingPolicy MessagingPolicy
        {
            Identity                      = "TestPolicy"
            Description                   = "My sample policy"
            ReadReceiptsEnabledType       = "UserPreference"
            AllowImmersiveReader          = $True
            AllowGiphy                    = $True
            AllowStickers                 = $True
            AllowUrlPreviews              = $false
            AllowUserChat                 = $True
            AllowUserDeleteMessage        = $false
            AllowUserTranslation          = $True
            AllowRemoveUser               = $false
            AllowPriorityMessages         = $True
            GiphyRatingType               = "MODERATE"
            AllowMemes                    = $False
            AudioMessageEnabledType       = "ChatsOnly"
            AllowOwnerDeleteMessage       = $False
            GlobalAdminAccount            = $credsGlobalAdmin
            Ensure                        = "Present"
        }
    }
}
