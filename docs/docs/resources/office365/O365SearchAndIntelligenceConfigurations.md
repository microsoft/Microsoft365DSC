# O365SearchAndIntelligenceConfigurations

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Specifies the resource is a single instance, the value must be 'Yes' | `Yes` |
| **ItemInsightsIsEnabledInOrganization** | Write | Boolean | Specifies whether or not Item Insights should be available for the organization. | |
| **ItemInsightsDisabledForGroup** | Write | String | Specifies a single Azure AD Group for which Item Insights needs to be disabled. | |
| **PersonInsightsIsEnabledInOrganization** | Write | Boolean | Specifies whether or not Person Insights should be available for the organization. | |
| **PersonInsightsDisabledForGroup** | Write | String | Specifies a single Azure AD Group for which Person Insights needs to be disabled. | |
| **Credential** | Write | PSCredential | Credentials of the Global Admin | |

## Description

This resource configures the Search And Intelligence configuration settings.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- 

#### Role Groups

- None

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

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
        O365SearchAndIntelligenceConfigurations 'SearchAndIntelligenceConfigurations'
        {
            Credential                            = $Credscredential;
            IsSingleInstance                      = "Yes";
            ItemInsightsIsEnabledInOrganization   = $False;
            ItemInsightsDisabledForGroup          = "TestGroup"
            PersonInsightsIsEnabledInOrganization = $True;
        }
    }
}
```

