# EXOCalendarProcessing

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the resource mailbox that you want to view. You can use any value that uniquely identifies the mailbox. | |
| **AddAdditionalResponse** | Write | Boolean | The AddAdditionalResponse parameter specifies whether additional information (the value of the AdditionalResponse parameter) is added to meeting request responses | |
| **AdditionalResponse** | Write | String | The AdditionalResponse parameter specifies the additional information to be included in responses to meeting requests when the value of the AddAdditionalResponse parameter is $true. If the value contains spaces, enclose the value in quotation marks. | |
| **AddNewRequestsTentatively** | Write | Boolean | The AddNewRequestsTentatively parameter specifies whether new meeting requests are added to the calendar as tentative | |
| **AddOrganizerToSubject** | Write | Boolean | The AddOrganizerToSubject parameter specifies whether the meeting organizer's name is used as the subject of the meeting request. | |
| **AllBookInPolicy** | Write | Boolean | The AllBookInPolicy parameter specifies whether to automatically approve in-policy requests from all users to the resource mailbox. | |
| **AllowConflicts** | Write | Boolean | The AllowConflicts parameter specifies whether to allow conflicting meeting requests. | |
| **AllowRecurringMeetings** | Write | Boolean | The AllowRecurringMeetings parameter specifies whether to allow recurring meetings in meeting requests. | |
| **AllRequestInPolicy** | Write | Boolean | The AllRequestInPolicy parameter specifies whether to allow all users to submit in-policy requests to the resource mailbox. | |
| **AllRequestOutOfPolicy** | Write | Boolean | The AllRequestOutOfPolicy parameter specifies whether to allow all users to submit out-of-policy requests to the resource mailbox. | |
| **AutomateProcessing** | Write | String | The AutomateProcessing parameter enables or disables calendar processing on the mailbox. | `None`, `AutoUpdate`, `AutoAccept` |
| **BookingType** | Write | String | The BookingType parameter specifies how reservations work on the resource mailbox. | `Standard`, `Reserved` |
| **BookingWindowInDays** | Write | UInt32 | The BookingWindowInDays parameter specifies the maximum number of days in advance that the resource can be reserved. A valid value is an integer from 0 through 1080. The default value is 180 days. The value 0 means today. | |
| **BookInPolicy** | Write | StringArray[] | The BookInPolicy parameter specifies users or groups who are allowed to submit in-policy meeting requests to the resource mailbox that are automatically approved. You can use any value that uniquely identifies the user or group. | |
| **ConflictPercentageAllowed** | Write | UInt32 | The ConflictPercentageAllowed parameter specifies the maximum percentage of meeting conflicts for new recurring meeting requests. A valid value is an integer from 0 through 100. The default value is 0. | |
| **DeleteAttachments** | Write | Boolean | The DeleteAttachments parameter specifies whether to remove attachments from all incoming messages. | |
| **DeleteComments** | Write | Boolean | The DeleteComments parameter specifies whether to remove or keep any text in the message body of incoming meeting requests. | |
| **DeleteNonCalendarItems** | Write | Boolean | The DeleteNonCalendarItems parameter specifies whether to remove or keep all non-calendar-related messages that are received by the resource mailbox. | |
| **DeleteSubject** | Write | Boolean | The DeleteSubject parameter specifies whether to remove or keep the subject of incoming meeting requests.  | |
| **EnableAutoRelease** | Write | Boolean | N/A | |
| **EnableResponseDetails** | Write | Boolean | The EnableResponseDetails parameter specifies whether to include the reasons for accepting or declining a meeting in the response email message. | |
| **EnforceCapacity** | Write | Boolean | The EnforceCapacity parameter specifies whether to restrict the number of attendees to the capacity of the workspace. For example, if capacity is set to 10, then only 10 people can book the workspace. | |
| **EnforceSchedulingHorizon** | Write | Boolean | The EnforceSchedulingHorizon parameter controls the behavior of recurring meetings that extend beyond the date specified by the BookingWindowInDays parameter. | |
| **ForwardRequestsToDelegates** | Write | Boolean | The ForwardRequestsToDelegates parameter specifies whether to forward incoming meeting requests to the delegates that are configured for the resource mailbox. | |
| **MaximumConflictInstances** | Write | UInt32 | The MaximumConflictInstances parameter specifies the maximum number of conflicts for new recurring meeting requests when the AllowRecurringMeetings parameter is set to $true. A valid value is an integer from 0 through INT32 (2147483647). The default value is 0. | |
| **MaximumDurationInMinutes** | Write | UInt32 | The MaximumDurationInMinutes parameter specifies the maximum duration in minutes for meeting requests. A valid value is an integer from 0 through INT32 (2147483647). The default value is 1440 (24 hours). | |
| **MinimumDurationInMinutes** | Write | UInt32 | The MinimumDurationInMinutes parameter specifies the minimum duration in minutes for meeting requests in workspace mailboxes. A valid value is an integer from 0 through INT32 (2147483647). The default value is 0, which means there is no minimum duration. | |
| **OrganizerInfo** | Write | Boolean | The OrganizerInfo parameter specifies whether the resource mailbox sends organizer information when a meeting request is declined because of conflicts. | |
| **PostReservationMaxClaimTimeInMinutes** | Write | UInt32 | N/A | |
| **ProcessExternalMeetingMessages** | Write | Boolean | The ProcessExternalMeetingMessages parameter specifies whether to process meeting requests that originate outside the Exchange organization. | |
| **RemoveCanceledMeetings** | Write | Boolean | The RemoveCanceledMeetings parameter specifies whether to automatically delete meetings that were cancelled by the organizer from the resource mailbox's calendar.  | |
| **RemoveForwardedMeetingNotifications** | Write | Boolean | The RemoveForwardedMeetingNotifications parameter specifies whether forwarded meeting notifications are moved to the Deleted Items folder after they're processed by the Calendar Attendant.  | |
| **RemoveOldMeetingMessages** | Write | Boolean | The RemoveOldMeetingMessages parameter specifies whether the Calendar Attendant removes old and redundant updates and responses. | |
| **RemovePrivateProperty** | Write | Boolean | The RemovePrivateProperty parameter specifies whether to clear the private flag for incoming meetings that were sent by the organizer in the original requests.  | |
| **RequestInPolicy** | Write | StringArray[] | The RemovePrivateProperty parameter specifies whether to clear the private flag for incoming meetings that were sent by the organizer in the original requests.  | |
| **RequestOutOfPolicy** | Write | StringArray[] | The RequestOutOfPolicy parameter specifies users who are allowed to submit out-of-policy requests that require approval by a resource mailbox delegate. You can use any value that uniquely identifies the user.  | |
| **ResourceDelegates** | Write | StringArray[] | The ResourceDelegates parameter specifies users can approve or reject requests that are sent to the resource mailbox. You can use any value that uniquely identifies the user.  | |
| **ScheduleOnlyDuringWorkHours** | Write | Boolean | The ScheduleOnlyDuringWorkHours parameter specifies whether to allow meetings to be scheduled outside of the working hours that are defined for the resource mailbox. | |
| **TentativePendingApproval** | Write | Boolean | The TentativePendingApproval parameter specifies whether to mark pending requests as tentative on the calendar. | |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **Ensure** | Write | String | Determines wether or not the instance exist. | `Present` |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures the Calendar Processing settings Exchange Online.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Organization Management, Recipient Management

#### Role Groups

- Organization Management, Help Desk

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsCredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
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
            Identity                             = "admin@$Domain";
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
```

