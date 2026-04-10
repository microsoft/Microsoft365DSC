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
        TeamsCallQueue "TestQueue"
        {
            AgentAlertTime                             = 114;
            AllowOptOut                                = $True;
            AuthorizedUsers                            = @("9abce74d-d108-475f-a2cb-bbb82f484982");
            ChannelId                                  = "19:Y6MG7XdME2Cf9IRmU8PUXNfA1OtqmjyBgCmCGBN2tzY1@thread.tacv2";
            ConferenceMode                             = $True;
            Credential                                 = $Credscredential;
            DistributionLists                          = @("36c88f29-faba-4f4a-89a7-e5af29e7095e");
            EnableOverflowSharedVoicemailTranscription = $False;
            EnableTimeoutSharedVoicemailTranscription  = $False;
            Ensure                                     = "Present";
            LanguageId                                 = "fr-CA";
            Name                                       = "TestQueue";
            OverflowAction                             = "Forward";
            OverflowActionTarget                       = "9abce74d-d108-475f-a2cb-bbb82f484982";
            OverflowThreshold                          = 50;
            PresenceBasedRouting                       = $True;
            RoutingMethod                              = "RoundRobin";
            TimeoutAction                              = "Forward";
            TimeoutActionTarget                        = "9abce74d-d108-475f-a2cb-bbb82f484982";
            TimeoutThreshold                           = 1200;
            UseDefaultMusicOnHold                      = $False;
        }
    }
}
