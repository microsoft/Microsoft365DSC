# PPPowerAppsEnvironment

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | Display name for the PowerApps environment ||
| **Location** | Required | String | Location of the PowerApps environment. |canada, unitedstates, europe, asia, australia, india, japan, unitedkingdom, unitedstatesfirstrelease, southamerica, france, usgov|
| **EnvironmentSKU** | Required | String | Environment type. |Production, Standard, Trial, Sandbox, SubscriptionBasedTrial, Teams|
| **Ensure** | Write | String | Only accepted value is 'Present'. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Power Platform Admin ||


# PPPowerAppsEnvironment

### Description

This resources configures the PowerApps Environment.

## Examples

### Example 1

This example creates a new PowerApps environment in production.

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
        PPPowerAppsEnvironment 'PowerAppsDemoEnvironment'
        {
            DisplayName        = "My Demo Environment"
            EnvironmentSKU     = "Production"
            Location           = "canada"
            Ensure             = "Present"
            Credential         = $credsGlobalAdmin
        }
    }
}
```

