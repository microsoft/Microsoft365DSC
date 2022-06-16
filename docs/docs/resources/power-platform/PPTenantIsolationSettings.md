﻿# PPTenantIsolationSettings

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **TenantName** | Required | String | Name of the trusted tenant. ||
| **Direction** | Required | String | Direction of tenant trust. |Inbound, Outbound, Both|
| **IsSingleInstance** | Key | String | Should be set to yes |Yes|
| **Enabled** | Write | Boolean | When set to true this will enable the tenant isolation settings. ||
| **Rules** | Write | InstanceArray[] | The exact list of tenant rules to be configured. ||
| **RulesToInclude** | Write | InstanceArray[] | A list of tenant rules that has to be added. ||
| **RulesToExclude** | Write | InstanceArray[] | A list of tenant rules that is now allowed to be added. ||
| **Credential** | Write | PSCredential | Credentials of the Power Platform Admin ||

# PPTenantSettingsIsolationSettings

### Description

This resource configures the Tenant Isolation settings for a Power Platform Tenant.

## Examples

### Example 1

This example sets Power Platform tenant isolation settings.

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
        PPTenantIsolationSettings 'PowerPlatformTenantSettings'
        {
            IsSingleInstance = 'Yes'
            Enable           = $true
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
            Credential       = $credsGlobalAdmin
        }
    }
}
```

### Example 2

This example sets Power Platform tenant isolation settings.

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
        PPTenantIsolationSettings 'PowerPlatformTenantSettings'
        {
            IsSingleInstance = 'Yes'
            Enable           = $true
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
            Credential       = $credsGlobalAdmin
        }
    }
}
```

