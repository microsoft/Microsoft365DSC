# AzureBillingAccountPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **BillingAccount** | Key | String | Unique identifier of the associated billing account. | |
| **Name** | Write | String | Name of the policy. | |
| **EnterpriseAgreementPolicies** | Write | MSFT_AzureBillingAccountPolicyEnterpriseAgreementPolicy | The policies for Enterprise Agreement enrollments. | |
| **MarketplacePurchases** | Write | String | The policy that controls whether Azure marketplace purchases are allowed. | |
| **ReservationPurchases** | Write | String | The policy that controls whether Azure reservation purchases are allowed. | |
| **SavingsPlanPurchases** | Write | String | The policy that controls whether users with Azure savings plan purchase are allowed. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Absent`, `Present` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_AzureBillingAccountPolicyEnterpriseAgreementPolicy

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **accountOwnerViewCharges** | Write | String | The policy that controls whether account owner can view charges. | |
| **authenticationType** | Write | String | The state showing the enrollment auth level. | |
| **departmentAdminViewCharges** | Write | String | The policy that controls whether department admin can view charges. | |


## Description

Configures policies settings for an Azure billing account.

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
        AzureBillingAccountPolicy "MyBillingAccountPolicy"
        {
            BillingAccount        = "1e5b9e50-a1ea-581e-fb3a-xxxxxxxxx:6487d5cf-0a7b-42e6-9549-xxxxxxx_2019-05-31";
            Name                  = "default"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            EnterpriseAgreementPolicies = MSFT_AzureBillingAccountPolicyEnterpriseAgreementPolicy {
                authenticationType = "OrganizationalAccountOnly"
            }
            MarketplacePurchases = "AllAllowed"
            ReservationPurchases = "Allowed"
            SavingsPlanPurchases = "NotAllowed"
        }
    }
}
```

