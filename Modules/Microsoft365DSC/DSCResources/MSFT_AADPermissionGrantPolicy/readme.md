# AADPermissionGrantPolicy

## Description

This resource configures an Entra Permission Grant Policy with its associated include and exclude condition sets.

Permission Grant Policies allow organizations to delegate admin consent capabilities for specific Microsoft Graph permissions to non-Global Administrator users and groups.

This resource combines the parent policy and its condition sets into a single configuration, managing:
- The parent permission grant policy properties (Id, DisplayName, Description)
- Include condition sets as an embedded CIM instance array
- Exclude condition sets as an embedded CIM instance array

## Example

```powershell
AADPermissionGrantPolicy 'CustomConsentPolicy'
{
    Id           = "my-custom-consent-policy"
    DisplayName  = "My Custom Consent Policy"
    Description  = "Custom policy for app consent with specific conditions"
    Includes     = @(
        MSFT_AADPermissionGrantConditionSet {
            Id                              = "include-low-risk-delegated"
            PermissionType                  = "delegated"
            PermissionClassification        = "low"
            ClientApplicationIds            = @("all")
            ClientApplicationTenantIds      = @($TenantId)
            ClientApplicationPublisherIds   = @("all")
            ClientApplicationsFromVerifiedPublisherOnly = $false
            ResourceApplication             = "00000003-0000-0000-c000-000000000000"
            Permissions                     = @("User.Read", "openid", "profile")
        }
    )
    Excludes     = @(
        MSFT_AADPermissionGrantConditionSet {
            Id                       = "exclude-high-risk-permissions"
            PermissionType           = "delegated"
            PermissionClassification = "high"
            ClientApplicationIds     = @("all")
            ResourceApplication      = "any"
            Permissions              = @("all")
        }
    )
    Ensure                = "Present"
    ApplicationId         = $ApplicationId
    TenantId              = $TenantId
    CertificateThumbprint = $CertificateThumbprint
}
```
