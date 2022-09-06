# TeamsGuestCallingConfiguration

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The only valid input is Global - the tenant wide configuration | `Global` |
| **AllowPrivateCalling** | Required | Boolean | Designates whether guests who have been enabled for Teams can use calling functionality. If $false, guests cannot call. | |
| **Credential** | Required | PSCredential | Credentials of the Teams Admin | |

## Description

This resource is used to configure the Teams guest calling configuration.

More information: https://docs.microsoft.com/en-us/microsoftteams/set-up-guests

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

This example configures the Teams Guest Calling Configuration.

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
        TeamsGuestCallingConfiguration 'ConfigureGuestCalling'
        {
            Identity            = "Global"
            AllowPrivateCalling = $True
            Credential          = $credsGlobalAdmin
        }
    }
}
```

