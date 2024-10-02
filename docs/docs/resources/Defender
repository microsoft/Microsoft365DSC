# DefenderSubscriptionPlan

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **SubscriptionName** | Key | String | The display name of the subscription. | |
| **PlanName** | Key | String | The Defender plan name, for the list all of possible Defender plans refer to Defender for Cloud documentation | |
| **SubscriptionId** | Write | String | The unique identifier of the Azure subscription. | |
| **PricingTier** | Write | String | The pricing tier ('Standard' or 'Free') | |
| **SubPlanName** | Write | String | The Defender sub plan name, for the list all of possible sub plans refer to Defender for Cloud documentation | |
| **Extensions** | Write | String | The extensions offered under the plan, for more information refer to Defender for Cloud documentation | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Enables or disables Microsoft Defender plans for a subscription in Microsoft Defender for Cloud.
For more information about the available Defender plans, sub plans and plan extensions refer to Defender for Cloud onboarding API documentation.
https://learn.microsoft.com/en-us/rest/api/defenderforcloud/pricings/update?view=rest-defenderforcloud-2024-01-01&tabs=HTTP


To have all security features enabled during plan enablement, make sure to assign the required Azure RBAC permissions to the application running this module.
For more information about the required permissions refer to the documentation https://learn.microsoft.com/en-us/azure/defender-for-cloud/permissions.

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

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC
    node localhost
    {
        DefenderSubscriptionPlan 'TestSubscription'
        {
            SubscriptionName      = 'MyTestSubscription'
            PlanName              = 'VirtualMachines'
            SubPlanName           = 'P2'
            PricingTier           = 'Standard'
            SubscriptionId        = 'd620d94d-916d-4dd9-9de5-179292873e20'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
```

