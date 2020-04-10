<#
This example adds a new Teams Meeting Policy.
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
        TeamsMeetingPolicy DemoMeetingPolicy
        {
            AllowAnonymousUsersToStartMeeting          = $False;
            AllowChannelMeetingScheduling              = $True;
            AllowCloudRecording                        = $True;
            AllowExternalParticipantGiveRequestControl = $False;
            AllowIPVideo                               = $True;
            AllowMeetNow                               = $True;
            AllowOutlookAddIn                          = $True;
            AllowParticipantGiveRequestControl         = $True;
            AllowPowerPointSharing                     = $True;
            AllowPrivateMeetingScheduling              = $True;
            AllowSharedNotes                           = $True;
            AllowTranscription                         = $False;
            AllowWhiteboard                            = $True;
            AutoAdmittedUsers                          = "Everyone";
            Description                                = "My Demo Meeting Policy";
            Ensure                                     = "Present";
            GlobalAdminAccount                         = $credsglobaladmin;
            Identity                                   = "Demo Policy";
            MediaBitRateKb                             = 50000;
            ScreenSharingMode                          = "EntireScreen";
        }
    }
}
