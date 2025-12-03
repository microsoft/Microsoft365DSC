<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
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
        TeamsMessagingConfiguration 'Global'
        {
            ContentBasedPhishingCheck         = "Disabled";
            CustomEmojis                      = $True;
            EnableInOrganizationChatControl   = $False;
            EnableVideoMessageCaptions        = $True;
            FileTypeCheck                     = "Disabled";
            IsSingleInstance                  = "Yes";
            MessagingNotes                    = "Enabled";
            ReportIncorrectSecurityDetections = "Disabled";
            Storyline                         = "Enabled";
            Credential                        = $Credscredential;
            UrlReputationCheck                = "Disabled";
        }
    }
}
