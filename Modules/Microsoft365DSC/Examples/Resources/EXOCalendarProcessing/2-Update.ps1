<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsCredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        $Domain = $Credscredential.Username.Split('@')[1]
        EXOCalendarProcessing "CalendarProcessing"
        {
            AddAdditionalResponse                = $False;
            AddNewRequestsTentatively            = $True;
            AddOrganizerToSubject                = $False; # Updated Property
            AllBookInPolicy                      = $True;
            AllowConflicts                       = $False;
            AllowRecurringMeetings               = $True;
            AllRequestInPolicy                   = $False;
            AllRequestOutOfPolicy                = $False;
            AutomateProcessing                   = "AutoUpdate";
            BookingType                          = "Standard";
            BookingWindowInDays                  = 180;
            BookInPolicy                         = @();
            ConflictPercentageAllowed            = 0;
            Credential                           = $credsCredential;
            DeleteAttachments                    = $True;
            DeleteComments                       = $True;
            DeleteNonCalendarItems               = $True;
            DeleteSubject                        = $True;
            EnableAutoRelease                    = $False;
            EnableResponseDetails                = $True;
            EnforceCapacity                      = $False;
            EnforceSchedulingHorizon             = $True;
            Ensure                               = "Present";
            ForwardRequestsToDelegates           = $True;
            Identity                             = "AdeleV";
            MaximumConflictInstances             = 0;
            MaximumDurationInMinutes             = 1440;
            MinimumDurationInMinutes             = 0;
            OrganizerInfo                        = $True;
            PostReservationMaxClaimTimeInMinutes = 10;
            ProcessExternalMeetingMessages       = $False;
            RemoveCanceledMeetings               = $False;
            RemoveForwardedMeetingNotifications  = $False;
            RemoveOldMeetingMessages             = $False;
            RemovePrivateProperty                = $True;
            RequestInPolicy                      = @("AlexW@$Domain");
            ResourceDelegates                    = @();
            ScheduleOnlyDuringWorkHours          = $False;
            TentativePendingApproval             = $True;
        }
    }
}
