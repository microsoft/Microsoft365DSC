# TeamsUpdateManagementPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Identity of the Teams Update Management Policy. | |
| **Description** | Write | String | The description of the Teams Update Management Policy. | |
| **AllowManagedUpdates** | Write | Boolean | Determines if managed updates should be allowed or not. | |
| **AllowPreview** | Write | Boolean | Determines if preview builds should be allowed or not. | |
| **AllowPublicPreview** | Write | String | Determines the ring of public previews to subscribes to. | `Disabled`, `Enabled`, `Forced`, `FollowOfficePreview` |
| **UpdateDayOfWeek** | Write | UInt32 | Determines the day of week to perform the updates. Value shoud be between 0 and 6. | |
| **UpdateTime** | Write | String | Determines the time of day to perform the updates. Must be a valid HH:MM format string with leading 0. For instance 08:30. | |
| **UpdateTimeOfDay** | Write | String | Determines the time of day to perform the updates. Accepts a DateTime as string. Only the time will be considered. | |
| **UseNewTeamsClient** | Write | String | Determines whether or not users will use the new Teams client. | `NewTeamsAsDefault`, `UserChoice`, `MicrosoftChoice`, `AdminDisabled` |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Teams Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |


## Description

This resource configures the Teams Update policies. For additional information, please refer to https://docs.microsoft.com/en-us/MicrosoftTeams/public-preview-doc-updates#set-the-update-policy

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

    - Organization.Read.All

- **Update**

    - Organization.Read.All

## Examples

### Example 1

This example demonstrates how to assign users to a Teams Upgrade Policy.

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
        TeamsUpdateManagementPolicy TestPolicy
        {
            AllowManagedUpdates  = $False;
            AllowPreview         = $False;
            AllowPublicPreview   = "Enabled";
            Credential           = $Credscredential;
            Description          = "Test";
            Ensure               = "Present";
            Identity             = "MyTestPolicy";
            UpdateDayOfWeek      = 1;
            UpdateTime           = "18:00";
            UpdateTimeOfDay      = "2022-05-06T18:00:00";
            UseNewTeamsClient    = 'MicrosoftChoice'
        }
    }
}
```

