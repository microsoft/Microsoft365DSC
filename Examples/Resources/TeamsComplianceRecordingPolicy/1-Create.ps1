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
        TeamsComplianceRecordingPolicy "TeamsComplianceRecordingPolicy-Tag:MyTeamsComplianceRecordingPolicy"
        {
            Credential                                          = $credsCredential;
            ComplianceRecordingApplications                     = @(
                MSFT_TeamsComplianceRecordingApplication{
                    Id = '00000000-0000-0000-0000-000000000000'
                    ComplianceRecordingPairedApplications = @('00000000-0000-0000-0000-000000000000')
                    ConcurrentInvitationCount = 1
                    RequiredDuringCall = $True
                    RequiredBeforeMeetingJoin = $True
                    RequiredBeforeCallEstablishment = $True
                    RequiredDuringMeeting = $True
                }
                MSFT_TeamsComplianceRecordingApplication{
                    Id = '12345678-0000-0000-0000-000000000000'
                    ComplianceRecordingPairedApplications = @('87654321-0000-0000-0000-000000000000')
                    ConcurrentInvitationCount = 1
                    RequiredDuringCall = $True
                    RequiredBeforeMeetingJoin = $True
                    RequiredBeforeCallEstablishment = $True
                    RequiredDuringMeeting = $True
                }
            );
            Description                                         = "MyTeamsComplianceRecordingPolicy";
            DisableComplianceRecordingAudioNotificationForCalls = $False;
            Enabled                                             = $True;
            Ensure                                              = "Present";
            Identity                                            = "Tag:MyTeamsComplianceRecordingPolicy";
            WarnUserOnRemoval                                   = $True;
        }
    }
}
