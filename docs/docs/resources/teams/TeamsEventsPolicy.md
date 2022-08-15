# TeamsEventsPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Identity of the Teams Events Policy. ||
| **Description** | Write | String | Description of the Teams Events Policy. ||
| **AllowWebinars** | Write | String | Determines if webinars are allowed by the policy or not. |Disabled, Enabled|
| **EventAccessType** | Write | String | Defines who is allowed to join the event. |Everyone, EveryoneInCompanyExcludingGuests|
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. |Present, Absent|
| **Credential** | Required | PSCredential | Credentials of the Teams Global Admin. ||


# TeamsEventsPolicy

### Description

This resource configures the Teams Events Policies.

## Examples

### Example 1

This example adds a new Teams Events Policy.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsTeamsAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        TeamsEventsPolicy 'ConfigureEventsPolicy'
        {
            Identity             = "My Events Policy";
            Description          = "This is a my Events Policy";
            AllowWebinars        = "Disabled";
            EventAccessType      = "EveryoneInCompanyExcludingGuests";
            Credential           = $credsTeamsAdmin
            Ensure               = "Present";
        }
    }
}
```

