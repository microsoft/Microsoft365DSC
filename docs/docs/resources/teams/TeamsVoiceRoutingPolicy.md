# TeamsVoiceRoutingPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Identity of the Teams Voice Routing Policy. ||
| **OnlinePstnUsages** | Write | StringArray[] | A list of online PSTN usages (such as Local or Long Distance) that can be applied to this online voice routing policy. The online PSTN usage must be an existing usage (PSTN usages can be retrieved by calling the Get-CsOnlinePstnUsage cmdlet). ||
| **Description** | Write | String | Enables administrators to provide explanatory text to accompany an online voice routing policy. For example, the Description might include information about the users the policy should be assigned to. ||
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. |Present, Absent|
| **Credential** | Required | PSCredential | Credentials of the Teams Global Admin ||


# TeamsVoiceRoutingPolicy

This resource configures a Teams Voice Routing Policy.

## Examples

### Example 1

This example adds a new Teams Voice Routing Policy.

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
        TeamsVoiceRoutingPolicy 'ConfigureVoiceRoutingPolicy'
        {
            Identity         = 'NewVoiceRoutingPolicy'
            OnlinePstnUsages = @('Long Distance', 'Local', 'Internal')
            Description      = 'This is a sample Voice Routing Policy'
            Ensure           = 'Present'
            Credential       = $credsGlobalAdmin
        }
    }
}
```

