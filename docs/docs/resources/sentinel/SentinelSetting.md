# SentinelSetting

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **ResourceGroupName** | Key | String | The Resource Group Name | |
| **WorkspaceName** | Required | String | The name of the workspace. | |
| **SubscriptionId** | Write | String | Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call. | |
| **AnomaliesIsEnabled** | Write | Boolean | Specififies if Anomaly detection should be enabled or not. | |
| **EntityAnalyticsIsEnabled** | Write | Boolean | Specififies if Entity Analyticsshould be enabled or not. | |
| **EyesOnIsEnabled** | Write | Boolean | Specififies if Auditing and Health Monitoring should be enabled or not. | |
| **UebaDataSource** | Write | StringArray[] | The list of Data sources associated with the UEBA. | |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Configures settings for a Sentinel instance.

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
        
    }
}
```

