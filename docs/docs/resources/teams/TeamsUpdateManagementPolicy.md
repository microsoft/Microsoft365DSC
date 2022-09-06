# TeamsUpdateManagementPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Identity of the Teams Update Management Policy. ||
| **Description** | Write | String | The description of the Teams Update Management Policy. ||
| **AllowManagedUpdates** | Write | Boolean | Determines if managed updates should be allowed or not. ||
| **AllowPreview** | Write | Boolean | Determines if preview builds should be allowed or not. ||
| **AllowPublicPreview** | Write | String | Determines the ring of public previews to subscribes to. |Disabled, Enabled, FollowOfficePreview|
| **UpdateDayOfWeek** | Write | UInt32 | Determines the day of week to perform the updates. Value shoud be between 0 and 6. ||
| **UpdateTime** | Write | String | Determines the time of day to perform the updates. Must be a valid HH:MM format string with leading 0. For instance 08:30. ||
| **UpdateTimeOfDay** | Write | String | Determines the time of day to perform the updates. Accepts a DateTime as string. Only the time will be considered. ||
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. |Present, Absent|
| **Credential** | Required | PSCredential | Credentials of the Teams Admin ||


# TeamsUpdateManagementPolicy

### Description

This resource configures the Teams Update policies. For additional information, please refer to https://docs.microsoft.com/en-us/MicrosoftTeams/public-preview-doc-updates#set-the-update-policy

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
        }
    }
}
```

