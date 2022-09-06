# TeamsPstnUsage

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Usage** | Key | String | An online PSTN usage (such as Local or Long Distance) that can be used in conjunction with voice routes and voice routing policies. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Required | PSCredential | Credentials of the Teams Global Admin | |


## Description

This resource configures a Teams PSTN Usage.

More information: https://docs.microsoft.com/en-us/microsoftteams/direct-routing-voice-routing

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

    - None

- **Update**

    - None

## Examples

### Example 1

This example adds a new Teams PSTN Usage.

```powershell
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
        TeamsPstnUsage 'ConfigurePstnUsage'
        {
            Usage      = 'Long Distance'
            Ensure     = 'Present'
            Credential = $credsGlobalAdmin
        }
    }
}
```

