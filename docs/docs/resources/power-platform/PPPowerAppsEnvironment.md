# PPPowerAppsEnvironment

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | Display name for the PowerApps environment | |
| **Location** | Required | String | Location of the PowerApps environment. | `canada`, `unitedstates`, `europe`, `asia`, `australia`, `india`, `japan`, `unitedkingdom`, `unitedstatesfirstrelease`, `southamerica`, `france`, `usgov`, `unitedarabemirates`, `germany`, `switzerland`, `norway`, `korea`, `southafrica` |
| **EnvironmentSKU** | Required | String | Environment type. | `Production`, `Standard`, `Trial`, `Sandbox`, `SubscriptionBasedTrial`, `Teams`, `Developer` |
| **Ensure** | Write | String | Only accepted value is 'Present'. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Power Platform Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |


## Description

This resources configures the PowerApps Environment.

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

This example creates a new PowerApps environment in production.

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
        PPPowerAppsEnvironment 'PowerAppsDemoEnvironment'
        {
            DisplayName        = "My Demo Environment"
            EnvironmentSKU     = "Production"
            Location           = "canada"
            Ensure             = "Present"
            Credential         = $Credscredential
        }
    }
}
```

