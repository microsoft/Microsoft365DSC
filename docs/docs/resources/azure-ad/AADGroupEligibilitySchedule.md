# AADGroupEligibilitySchedule

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **AccessId** | Write | String | The identifier of the membership or ownership eligibility to the group that is governed by PIM. Required. The possible values are: owner, member. Supports $filter (eq). | `owner`, `member`, `unknownFutureValue` |
| **GroupId** | Write | String | The identifier of the group representing the scope of the membership or ownership eligibility through PIM for groups. Required. Supports $filter (eq). | |
| **GroupDisplayName** | Key | String | Displayname of the group representing the scope of the membership or ownership eligibility through PIM for groups. | |
| **MemberType** | Write | String | Indicates whether the assignment is derived from a group assignment. It can further imply whether the caller can manage the schedule. Required. The possible values are: direct, group, unknownFutureValue. Supports $filter (eq). | `direct`, `group`, `unknownFutureValue` |
| **PrincipalId** | Write | String | The identifier of the principal whose membership or ownership eligibility is granted through PIM for groups. Required. Supports $filter (eq). | |
| **PrincipalType** | Write | String | Principal type user or group | `user`, `group` |
| **PrincipalDisplayName** | Write | String | Displayname of the Principal | |
| **ScheduleInfo** | Write | MSFT_MicrosoftGraphrequestSchedule | Represents the period of the access assignment or eligibility. The scheduleInfo can represent a single occurrence or multiple recurring instances. Required. | |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_MicrosoftGraphRequestSchedule

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Expiration** | Write | MSFT_MicrosoftGraphExpirationPattern | When the eligible or active assignment expires. | |
| **Recurrence** | Write | MSFT_MicrosoftGraphPatternedRecurrence1 | The frequency of the  eligible or active assignment. This property is currently unsupported in PIM. | |
| **StartDateTime** | Write | String | When the  eligible or active assignment becomes active. | |

### MSFT_MicrosoftGraphExpirationPattern

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Duration** | Write | String | The requestor's desired duration of access represented in ISO 8601 format for durations. For example, PT3H refers to three hours.  If specified in a request, endDateTime should not be present and the type property should be set to afterDuration. | |
| **EndDateTime** | Write | String | Timestamp of date and time information using ISO 8601 format and is always in UTC time. For example, midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z. | |
| **Type** | Write | String | The requestor's desired expiration pattern type. The possible values are: notSpecified, noExpiration, afterDateTime, afterDuration. | `notSpecified`, `noExpiration`, `afterDateTime`, `afterDuration` |

### MSFT_MicrosoftGraphPatternedRecurrence1

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Pattern** | Write | MSFT_MicrosoftGraphRecurrencePattern1 | The frequency of an event.  For access reviews: Do not specify this property for a one-time access review.  Only interval, dayOfMonth, and type (weekly, absoluteMonthly) properties of recurrencePattern are supported. | |
| **Range** | Write | MSFT_MicrosoftGraphRecurrenceRange1 | The duration of an event. | |

### MSFT_MicrosoftGraphRecurrencePattern1

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DayOfMonth** | Write | UInt32 | The day of the month on which the event occurs. Required if type is absoluteMonthly or absoluteYearly. | |
| **DaysOfWeek** | Write | StringArray[] | A collection of the days of the week on which the event occurs. The possible values are: sunday, monday, tuesday, wednesday, thursday, friday, saturday. If type is relativeMonthly or relativeYearly, and daysOfWeek specifies more than one day, the event falls on the first day that satisfies the pattern.  Required if type is weekly, relativeMonthly, or relativeYearly. | `sunday`, `monday`, `tuesday`, `wednesday`, `thursday`, `friday`, `saturday` |
| **FirstDayOfWeek** | Write | String | The first day of the week. The possible values are: sunday, monday, tuesday, wednesday, thursday, friday, saturday. Default is sunday. Required if type is weekly. | `sunday`, `monday`, `tuesday`, `wednesday`, `thursday`, `friday`, `saturday` |
| **Index** | Write | String | Specifies on which instance of the allowed days specified in daysOfWeek the event occurs, counted from the first instance in the month. The possible values are: first, second, third, fourth, last. Default is first. Optional and used if type is relativeMonthly or relativeYearly. | `first`, `second`, `third`, `fourth`, `last` |
| **Interval** | Write | UInt32 | The number of units between occurrences, where units can be in days, weeks, months, or years, depending on the type. Required. | |
| **Month** | Write | UInt32 | The month in which the event occurs.  This is a number from 1 to 12. | |
| **Type** | Write | String | The recurrence pattern type: daily, weekly, absoluteMonthly, relativeMonthly, absoluteYearly, relativeYearly. Required. For more information, see values of type property. | `daily`, `weekly`, `absoluteMonthly`, `relativeMonthly`, `absoluteYearly`, `relativeYearly` |

### MSFT_MicrosoftGraphRecurrenceRange1

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **EndDate** | Write | String | The date to stop applying the recurrence pattern. Depending on the recurrence pattern of the event, the last occurrence of the meeting may not be this date. Required if type is endDate. | |
| **NumberOfOccurrences** | Write | UInt32 | The number of times to repeat the event. Required and must be positive if type is numbered. | |
| **RecurrenceTimeZone** | Write | String | Time zone for the startDate and endDate properties. Optional. If not specified, the time zone of the event is used. | |
| **StartDate** | Write | String | The date to start applying the recurrence pattern. The first occurrence of the meeting may be this date or later, depending on the recurrence pattern of the event. Must be the same value as the start property of the recurring event. Required. | |
| **Type** | Write | String | The recurrence range. The possible values are: endDate, noEnd, numbered. Required. | `endDate`, `noEnd`, `numbered` |


## Description

Azure AD Group Eligibility Schedule

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - PrivilegedEligibilitySchedule.Read.AzureADGroup

- **Update**

    - None

#### Application permissions

- **Read**

    - PrivilegedEligibilitySchedule.Read.AzureADGroup

- **Update**

    - None

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
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
        AADGroupEligibilitySchedule 'Example'
        {
            AccessId              = "member";
            Ensure                = "Present";
            GroupDisplayName      = "MyPIMGroup";
            MemberType            = "direct";
            PrincipalDisplayname  = "MyPrincipalGroup";
            PrincipalType         = "group";
            ScheduleInfo          = MSFT_MicrosoftGraphrequestSchedule{
                StartDateTime = '2024-12-23T08:59:28.1200000+00:00'
                Expiration = MSFT_MicrosoftGraphExpirationPattern{
                    EndDateTime = '12/23/2025 8:59:00 AM +00:00'
                    Type = 'afterDateTime'
                }
            };
        }
    }
}
```

### Example 2

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
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
        AADGroupEligibilitySchedule 'Example'
        {
            AccessId              = "member";
            Ensure                = "Present";
            GroupDisplayName      = "MyPIMGroup";
            MemberType            = "direct";
            PrincipalDisplayname  = "MyPrincipalGroup";
            PrincipalType         = "group";
            ScheduleInfo          = MSFT_MicrosoftGraphrequestSchedule{
                Expiration = MSFT_MicrosoftGraphExpirationPattern{
                    Type = 'noExpiration'
                }
            };
        }
    }
}
```

