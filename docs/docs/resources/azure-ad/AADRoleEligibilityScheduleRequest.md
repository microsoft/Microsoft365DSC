# AADRoleEligibilityScheduleRequest

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Principal** | Key | String | User Principal Name of the eligibility request. | |
| **RoleDefinition** | Key | String | Role associated with the eligibility request. | |
| **PrincipalType** | Write | String | Represented the type of principal to assign the request to. Accepted values are: Group and User. | `Group`, `User` |
| **DirectoryScopeId** | Write | String | Identifier of the directory object representing the scope of the role eligibility. The scope of an role eligibility determines the set of resources for which the principal has been granted access. Directory scopes are shared scopes stored in the directory that are understood by multiple applications. Use / for tenant-wide scope. Use appScopeId to limit the scope to an application only. Either directoryScopeId or appScopeId is required. | |
| **Id** | Write | String | Identifier for the Role Eligibility Schedule Request. | |
| **AppScopeId** | Write | String | Identifier of the app-specific scope when the role eligibility is scoped to an app. The scope of a role eligibility determines the set of resources for which the principal is eligible to access. App scopes are scopes that are defined and understood by this application only. Use / for tenant-wide app scopes. Use directoryScopeId to limit the scope to particular directory objects, for example, administrative units. Either directoryScopeId or appScopeId is required. | |
| **Action** | Write | String | Represents the type of operation on the role eligibility request.The possible values are: adminAssign, adminUpdate, adminRemove, selfActivate, selfDeactivate, adminExtend, adminRenew, selfExtend, selfRenew, unknownFutureValue. | `adminAssign`, `adminUpdate`, `adminRemove`, `selfActivate`, `selfDeactivate`, `adminExtend`, `adminRenew`, `selfExtend`, `selfRenew`, `unknownFutureValue` |
| **IsValidationOnly** | Write | Boolean | Determines whether the call is a validation or an actual call. Only set this property if you want to check whether an activation is subject to additional rules like MFA before actually submitting the request. | |
| **Justification** | Write | String | A message provided by users and administrators when create they create the unifiedRoleEligibilityScheduleRequest object. Optional when action is adminRemove. Whether this property is required or optional is also dependent on the settings for the Azure AD role. | |
| **ScheduleInfo** | Write | MSFT_AADRoleEligibilityScheduleRequestSchedule | The period of the role eligibility. Optional when action is adminRemove. The period of eligibility is dependent on the settings of the Azure AD role. | |
| **TicketInfo** | Write | MSFT_AADRoleEligibilityScheduleRequestTicketInfo | Ticket details linked to the role eligibility request including details of the ticket number and ticket system. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Intune Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

### MSFT_AADRoleEligibilityScheduleRequestScheduleRecurrenceRange

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **endDate** | Required | String | The date to stop applying the recurrence pattern. Depending on the recurrence pattern of the event, the last occurrence of the meeting may not be this date. | |
| **numberOfOccurrences** | Write | UInt32 | The number of times to repeat the event. Required and must be positive if type is numbered. | |
| **recurrenceTimeZone** | Write | String | Time zone for the startDate and endDate properties. | |
| **startDate** | Required | String | The date to start applying the recurrence pattern. The first occurrence of the meeting may be this date or later, depending on the recurrence pattern of the event. Must be the same value as the start property of the recurring event. | |
| **type** | Required | String | The recurrence range. The possible values are: endDate, noEnd, numbered. | `endDate`, `noEnd`, `numbered` |

### MSFT_AADRoleEligibilityScheduleRequestScheduleRecurrencePattern

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **dayOfMonth** | Write | UInt32 | The day of the month on which the event occurs. | |
| **daysOfWeek** | Write | StringArray[] | A collection of the days of the week on which the event occurs. The possible values are: sunday, monday, tuesday, wednesday, thursday, friday, saturday | `sunday`, `monday`, `tuesday`, `wednesday`, `thursday`, `friday`, `saturday` |
| **firstDayOfWeek** | Write | String | The first day of the week. | `sunday`, `monday`, `tuesday`, `wednesday`, `thursday`, `friday`, `saturday` |
| **index** | Write | String | Specifies on which instance of the allowed days specified in daysOfWeek the event occurs, counted from the first instance in the month. The possible values are: first, second, third, fourth, last. | `first`, `second`, `third`, `fourth`, `last` |
| **interval** | Write | UInt32 | The number of units between occurrences, where units can be in days, weeks, months, or years, depending on the type. | |
| **month** | Write | UInt32 | The month in which the event occurs. This is a number from 1 to 12. | |
| **type** | Write | String | The recurrence pattern type: daily, weekly, absoluteMonthly, relativeMonthly, absoluteYearly, relativeYearly. | `daily`, `weekly`, `absoluteMonthly`, `relativeMonthly`, `absoluteYearly`, `relativeYearly` |

### MSFT_AADRoleEligibilityScheduleRequestScheduleRecurrence

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **pattern** | Write | MSFT_AADRoleEligibilityScheduleRequestScheduleRecurrencePattern | The frequency of an event. | |
| **range** | Write | MSFT_AADRoleEligibilityScheduleRequestScheduleRecurrenceRange | The duration of an event. | |

### MSFT_AADRoleEligibilityScheduleRequestScheduleExpiration

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **duration** | Write | String | The requestor's desired duration of access represented in ISO 8601 format for durations. For example, PT3H refers to three hours. If specified in a request, endDateTime should not be present and the type property should be set to afterDuration. | |
| **endDateTime** | Write | String | Timestamp of date and time information using ISO 8601 format and is always in UTC time. For example, midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z. | |
| **type** | Write | String | The requestor's desired expiration pattern type. The possible values are: notSpecified, noExpiration, afterDateTime, afterDuration. | `notSpecified`, `noExpiration`, `afterDateTime`, `afterDuration` |

### MSFT_AADRoleEligibilityScheduleRequestSchedule

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **expiration** | Write | MSFT_AADRoleEligibilityScheduleRequestScheduleExpiration | When the eligible or active assignment expires. | |
| **recurrence** | Write | MSFT_AADRoleEligibilityScheduleRequestScheduleRecurrence | The frequency of the eligible or active assignment. This property is currently unsupported in PIM. | |
| **startDateTime** | Write | String | When the eligible or active assignment becomes active. | |

### MSFT_AADRoleEligibilityScheduleRequestTicketInfo

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **ticketNumber** | Write | String | The ticket number. | |
| **ticketSystem** | Write | String | The description of the ticket system. | |


## Description

Represents a request for a role eligibility for a principal through PIM. The role eligibility can be permanently eligible without an expiry date or temporarily eligible with an expiry date. Inherits from request.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - None

- **Update**

    - None

#### Application permissions

- **Read**

    - RoleEligibilitySchedule.ReadWrite.Directory

- **Update**

    - RoleEligibilitySchedule.ReadWrite.Directory

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
        $Credscredential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        AADRoleEligibilityScheduleRequest "MyRequest"
        {
            Action               = "AdminAssign";
            Credential           = $Credscredential;
            DirectoryScopeId     = "/";
            Ensure               = "Present";
            IsValidationOnly     = $False;
            Principal            = "AdeleV@$Domain";
            RoleDefinition       = "Teams Communications Administrator";
            ScheduleInfo         = MSFT_AADRoleEligibilityScheduleRequestSchedule {
                startDateTime             = '2023-09-01T02:40:44Z'
                expiration                = MSFT_AADRoleEligibilityScheduleRequestScheduleExpiration
                    {
                        endDateTime = '2025-10-31T02:40:09Z'
                        type        = 'afterDateTime'
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
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        AADRoleEligibilityScheduleRequest "MyRequest"
        {
            Action               = "AdminUpdate";
            Credential           = $Credscredential;
            DirectoryScopeId     = "/";
            Ensure               = "Present";
            IsValidationOnly     = $False;
            Principal            = "AdeleV@$Domain";
            RoleDefinition       = "Teams Communications Administrator";
            ScheduleInfo         = MSFT_AADRoleEligibilityScheduleRequestSchedule {
                startDateTime             = '2023-09-01T02:45:44Z' # Updated Property
                expiration                = MSFT_AADRoleEligibilityScheduleRequestScheduleExpiration
                    {
                        endDateTime = '2025-10-31T02:40:09Z'
                        type        = 'afterDateTime'
                    }
            };
        }
    }
}
```

### Example 3

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADRoleEligibilityScheduleRequest "MyRequest"
        {
            Action               = "AdminAssign";
            Credential           = $Credscredential;
            DirectoryScopeId     = "/";
            Ensure               = "Absent";
            IsValidationOnly     = $True; # Updated Property
            Principal            = "John.Smith@$OrganizationName";
            RoleDefinition       = "Teams Communications Administrator";
            ScheduleInfo         = MSFT_AADRoleEligibilityScheduleRequestSchedule {
                startDateTime             = '2023-09-01T02:40:44Z'
                expiration                = MSFT_AADRoleEligibilityScheduleRequestScheduleExpiration
                    {
                        endDateTime = '2025-10-31T02:40:09Z'
                        type        = 'afterDateTime'
                    }
            };
        }
    }
}
```

