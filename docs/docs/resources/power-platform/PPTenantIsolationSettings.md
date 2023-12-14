# PPTenantIsolationSettings

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Should be set to yes | `Yes` |
| **Enabled** | Write | Boolean | When set to true this will enable the tenant isolation settings. | |
| **Rules** | Write | MSFT_PPTenantRule[] | The exact list of tenant rules to be configured. | |
| **RulesToInclude** | Write | MSFT_PPTenantRule[] | A list of tenant rules that has to be added. | |
| **RulesToExclude** | Write | MSFT_PPTenantRule[] | A list of tenant rules that is now allowed to be added. | |
| **Credential** | Write | PSCredential | Credentials of the Power Platform Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |

### MSFT_PPTenantRule

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **TenantName** | Required | String | Name of the trusted tenant. | |
| **Direction** | Required | String | Direction of tenant trust. | `Inbound`, `Outbound`, `Both` |

# PPTenantSettingsIsolationSettings

## Description

This resource configures the Tenant Isolation settings for a Power Platform Tenant.

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

This example sets Power Platform tenant isolation settings.

```powershell
Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        PPTenantIsolationSettings 'PowerPlatformTenantSettings'
        {
            IsSingleInstance = 'Yes'
            Enabled          = $true
            Rules            = @(
                MSFT_PPTenantRule
                {
                    TenantName = 'contoso.onmicrosoft.com'
                    Direction  = 'Outbound'
                }
                MSFT_PPTenantRule
                {
                    TenantName = 'fabrikam.onmicrosoft.com'
                    Direction  = 'Both'
                }
            )
            Credential       = $Credscredential
        }
    }
}
```

### Example 2

This example sets Power Platform tenant isolation settings.

```powershell
Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        PPTenantIsolationSettings 'PowerPlatformTenantSettings'
        {
            IsSingleInstance = 'Yes'
            Enabled          = $true
            RulesToInclude   = @(
                MSFT_PPTenantRule
                {
                    TenantName = 'contoso.onmicrosoft.com'
                    Direction  = 'Inbound'
                }
            )
            RulesToExclude   = @(
                MSFT_PPTenantRule
                {
                    TenantName = 'fabrikam.onmicrosoft.com'
                    Direction  = 'Both'
                }
            )
            Credential       = $Credscredential
        }
    }
}
```

