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
    Import-DscResource -ModuleName Office365DSC

    node localhost
    {
        TeamsMeetingPolicy DemoMeetingPolicy
        {
            AllowAnonymousUsersToDialOut               = $False;
            AllowAnonymousUsersToStartMeeting          = $False;
            AllowChannelMeetingScheduling              = $True;
            AllowCloudRecording                        = $True;
            AllowExternalParticipantGiveRequestControl = $False;
            AllowIPAudio                               = $True;
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
