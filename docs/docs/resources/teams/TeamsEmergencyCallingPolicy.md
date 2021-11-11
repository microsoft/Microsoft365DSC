# TeamsEmergencyCallingPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Identity of the Teams Emergency Calling Policy. ||
| **Description** | Write | String | Description of the Teams Emergency Calling Policy. ||
| **NotificationDialOutNumber** | Write | String | This parameter represents PSTN number which can be dialed out if NotificationMode is set to either of the two Conference values. ||
| **NotificationGroup** | Write | String | NotificationGroup is a email list of users and groups to be notified of an emergency call. ||
| **NotificationMode** | Write | String | The type of conference experience for security desk notification. |NotificationOnly, ConferenceMuted, ConferenceUnMuted|
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. |Present, Absent|
| **Credential** | Required | PSCredential | Credentials of the Teams Global Admin. ||


# TeamsEmergencyCallingPolicy

This resource configures the Teams Emergency Calling Policies.

## Examples

### Example 1

This example adds a new Teams Emergency Calling Policy.

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
        TeamsEmergencyCallingPolicy 'ConfigureEmergencyCallingPolicy'
        {
            Description               = "Demo"
            Identity                  = "Demo Emergency Calling Policy"
            NotificationDialOutNumber = "+1234567890"
            NotificationGroup         = 'john.smith@contoso.com'
            NotificationMode          = "NotificationOnly"
            Ensure                    = 'Present'
            Credential                = $credsGlobalAdmin
        }
    }
}
```

