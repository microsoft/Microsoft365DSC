# EXOMailboxCalendarConfiguration

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |
| **Identity** | Key | String | Specifies the mailbox identity. | |
| **AgendaMailIntroductionEnabled** | Write | Boolean | Enables or disables agenda mail introduction. | |
| **AutoDeclineWhenBusy** | Write | Boolean | Automatically declines meeting requests when the user is busy. | |
| **CalendarFeedsPreferredLanguage** | Write | String | Preferred language for calendar feeds. | |
| **CalendarFeedsPreferredRegion** | Write | String | Preferred region for calendar feeds. | |
| **CalendarFeedsRootPageId** | Write | String | Root page ID for calendar feeds. | |
| **ConversationalSchedulingEnabled** | Write | Boolean | Enables or disables conversational scheduling. | |
| **CreateEventsFromEmailAsPrivate** | Write | Boolean | Creates events from email as private. | |
| **DefaultMinutesToReduceLongEventsBy** | Write | UInt32 | Default minutes to reduce long events by. | |
| **DefaultMinutesToReduceShortEventsBy** | Write | UInt32 | Default minutes to reduce short events by. | |
| **DefaultOnlineMeetingProvider** | Write | String | Default online meeting provider. | |
| **DefaultReminderTime** | Write | String | Default reminder time. | |
| **DeleteMeetingRequestOnRespond** | Write | Boolean | Deletes meeting request on respond. | |
| **DiningEventsFromEmailEnabled** | Write | Boolean | Enables or disables dining events from email. | |
| **EntertainmentEventsFromEmailEnabled** | Write | Boolean | Enables or disables entertainment events from email. | |
| **EventsFromEmailEnabled** | Write | Boolean | Enables or disables events from email. | |
| **FirstWeekOfYear** | Write | String | Specifies the first week of the year. | |
| **FlightEventsFromEmailEnabled** | Write | Boolean | Enables or disables flight events from email. | |
| **HotelEventsFromEmailEnabled** | Write | Boolean | Enables or disables hotel events from email. | |
| **InvoiceEventsFromEmailEnabled** | Write | Boolean | Enables or disables invoice events from email. | |
| **LocationDetailsInFreeBusy** | Write | String | Specifies location details in free/busy information. | |
| **MailboxLocation** | Write | String | Specifies the mailbox location. | |
| **OnlineMeetingsByDefaultEnabled** | Write | Boolean | Enables or disables online meetings by default. | |
| **PackageDeliveryEventsFromEmailEnabled** | Write | Boolean | Enables or disables package delivery events from email. | |
| **PreserveDeclinedMeetings** | Write | Boolean | Preserves declined meetings. | |
| **RemindersEnabled** | Write | Boolean | Enables or disables reminders. | |
| **ReminderSoundEnabled** | Write | Boolean | Enables or disables reminder sound. | |
| **RentalCarEventsFromEmailEnabled** | Write | Boolean | Enables or disables rental car events from email. | |
| **ServiceAppointmentEventsFromEmailEnabled** | Write | Boolean | Enables or disables service appointment events from email. | |
| **ShortenEventScopeDefault** | Write | String | Specifies the default scope for shortening events. | |
| **ShowWeekNumbers** | Write | Boolean | Shows or hides week numbers. | |
| **TimeIncrement** | Write | String | Specifies the time increment for calendar events. | |
| **UseBrightCalendarColorThemeInOwa** | Write | Boolean | Uses a bright calendar color theme in Outlook on the web. | |
| **WeatherEnabled** | Write | String | Enables or disables weather information. | |
| **WeatherLocationBookmark** | Write | UInt32 | Specifies the weather location bookmark. | |
| **WeatherLocations** | Write | StringArray[] | Specifies the weather locations. | |
| **WeatherUnit** | Write | String | Specifies the weather unit. | |
| **WeekStartDay** | Write | String | Specifies the start day of the week. | |
| **WorkDays** | Write | String | Specifies the work days. | |
| **WorkingHoursEndTime** | Write | String | Specifies the end time of working hours. | |
| **WorkingHoursStartTime** | Write | String | Specifies the start time of working hours. | |
| **WorkingHoursTimeZone** | Write | String | Specifies the time zone for working hours. | |
| **WorkspaceUserEnabled** | Write | Boolean | Enables or disables workspace user. | |
| **Ensure** | Write | String | Ensures the presence or absence of the configuration. | |


## Description

This resource allows users to manage mailbox calendar settings. 

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
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC
    node localhost
    {
        EXOMailboxCalendarConfiguration "EXOMailboxCalendarConfiguration-Test"
        {
            AgendaMailIntroductionEnabled            = $True;
            AutoDeclineWhenBusy                      = $False;
            ConversationalSchedulingEnabled          = $True;
            CreateEventsFromEmailAsPrivate           = $True;
            DefaultMinutesToReduceLongEventsBy       = 10;
            DefaultMinutesToReduceShortEventsBy      = 6; # Updated Property
            DefaultOnlineMeetingProvider             = "TeamsForBusiness";
            DefaultReminderTime                      = "00:15:00";
            DeleteMeetingRequestOnRespond            = $True;
            DiningEventsFromEmailEnabled             = $True;
            Ensure                                   = "Present";
            EntertainmentEventsFromEmailEnabled      = $True;
            EventsFromEmailEnabled                   = $True;
            FirstWeekOfYear                          = "FirstDay";
            FlightEventsFromEmailEnabled             = $True;
            HotelEventsFromEmailEnabled              = $True;
            Identity                                 = "admin@$TenantId";
            InvoiceEventsFromEmailEnabled            = $True;
            LocationDetailsInFreeBusy                = "Desk";
            PackageDeliveryEventsFromEmailEnabled    = $False;
            PreserveDeclinedMeetings                 = $False;
            RemindersEnabled                         = $True;
            ReminderSoundEnabled                     = $True;
            RentalCarEventsFromEmailEnabled          = $True;
            ServiceAppointmentEventsFromEmailEnabled = $True;
            ShortenEventScopeDefault                 = "None";
            ShowWeekNumbers                          = $False;
            TimeIncrement                            = "ThirtyMinutes";
            UseBrightCalendarColorThemeInOwa         = $False;
            WeatherEnabled                           = "FirstRun";
            WeatherLocationBookmark                  = 0;
            WeatherLocations                         = @();
            WeatherUnit                              = "Default";
            WeekStartDay                             = "Sunday";
            WorkDays                                 = "Monday, Tuesday";
            WorkingHoursEndTime                      = "17:00:00";
            WorkingHoursStartTime                    = "08:00:00";
            WorkingHoursTimeZone                     = "Pacific Standard Time";
            WorkspaceUserEnabled                     = $False;
            ApplicationId                            = $ApplicationId
            TenantId                                 = $TenantId
            CertificateThumbprint                    = $CertificateThumbprint
        }
    }
}
```

