# PPPowerAppPolicyUrlPatterns

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **PolicyName** | Key | String | The policy name identifier. | |
| **PPTenantId** | Key | String | The tenant identifier. | |
| **RuleSet** | Write | MSFT_PPPowerAPpPolicyUrlPatternsRule[] | Set of custom connector pattern rules associated with the policy. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Absent`, `Present` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_PPPowerAPpPolicyUrlPatternsRule

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **order** | Write | String | Rule priority order. | |
| **customConnectorRuleClassification** | Write | String | Rule classification. | |
| **pattern** | Write | String | Rule pattern. | |


## Description

Configures custom connector patterns for Data Loss Prevention policies in Power Platforms.

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
        PPPowerAppPolicyUrlPatterns "PPPowerAppPolicyUrlPatterns"
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            Ensure                = "Present";
            PolicyName            = "DSCPolicy";
            PPTenantId            = "e91d4e0e-d5a5-4e3a-be14-2192592a59af";
            RuleSet               = @(
                MSFT_PPPowerAPpPolicyUrlPatternsRule{
                    pattern = 'https://contoso.com'
                    customConnectorRuleClassification = 'General'
                    order = 1
                }
                MSFT_PPPowerAPpPolicyUrlPatternsRule{
                    pattern = 'https://fabrikam.com'
                    customConnectorRuleClassification = 'General'
                    order = 2
                }
                MSFT_PPPowerAPpPolicyUrlPatternsRule{
                    pattern = '*'
                    customConnectorRuleClassification = 'Ignore'
                    order = 3
                }
            );
            TenantId              = $TenantId;
        }
    }
}
```

### Example 2

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
        PPPowerAppPolicyUrlPatterns "PPPowerAppPolicyUrlPatterns"
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            Ensure                = "Present";
            PolicyName            = "DSCPolicy";
            PPTenantId            = "e91d4e0e-d5a5-4e3a-be14-2192592a59af";
            RuleSet               = @(
                MSFT_PPPowerAPpPolicyUrlPatternsRule{
                    pattern = 'https://contoso.com'
                    customConnectorRuleClassification = 'General'
                    order = 1
                }
                MSFT_PPPowerAPpPolicyUrlPatternsRule{
                    pattern = 'https://tailspintoys.com' # drift
                    customConnectorRuleClassification = 'General'
                    order = 2
                }
                MSFT_PPPowerAPpPolicyUrlPatternsRule{
                    pattern = '*'
                    customConnectorRuleClassification = 'Ignore'
                    order = 3
                }
            );
            TenantId              = $TenantId;
        }
    }
}
```

### Example 3

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
        PPPowerAppPolicyUrlPatterns "PPPowerAppPolicyUrlPatterns"
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            Ensure                = "Absent";
            PolicyName            = "DSCPolicy";
            PPTenantId            = "e91d4e0e-d5a5-4e3a-be14-2192592a59af";
            TenantId              = $TenantId;
        }
    }
}
```

