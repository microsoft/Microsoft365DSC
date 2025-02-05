# CommerceSelfServicePurchase

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **ProductId** | Key | String | Unique ID of the product. | |
| **ProductName** | Write | String | Name of the product | |
| **PolicyValue** | Write | String | Can be Enabled or Disabled. | `Enabled`, `Disabled`, `OnlyTrialsWithoutPaymentMethod` |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Absent`, `Present` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Manages the Self Purchase policies in commerce.

## Permissions

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
        CommerceSelfServicePurchase "Power Apps per user"
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            Ensure                = "Present";
            PolicyValue           = "Enabled";
            ProductId             = "CFQ7TTC0LH2H";
            ProductName           = "Power Apps per user";
            TenantId              = $TenantId;
        }
    }
}
```

