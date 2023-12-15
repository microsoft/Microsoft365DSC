<#
This example adds a new Teams Messaging Policy.
#>

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
        TeamsMessagingPolicy 'ConfigureMessagingPolicy'
        {
            Identity                = "TestPolicy"
            Description             = "My sample policy"
            ReadReceiptsEnabledType = "UserPreference"
            AllowImmersiveReader    = $True
            AllowGiphy              = $True
            AllowStickers           = $True
            AllowUrlPreviews        = $false
            AllowUserChat           = $True
            AllowUserDeleteMessage  = $false
            AllowUserEditMessage    = $false
            AllowUserTranslation    = $True
            AllowRemoveUser         = $false
            AllowPriorityMessages   = $True
            GiphyRatingType         = "MODERATE"
            AllowMemes              = $False
            AudioMessageEnabledType = "ChatsOnly"
            AllowOwnerDeleteMessage = $False
            Ensure                  = "Present"
            Credential              = $Credscredential
        }
    }
}
