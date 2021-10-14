# AADTenantDetails

## Parameters

| Parameter        | Attribute | DataType | Description                | Allowed Values |
| ---------------- | --------- | -------- | -------------------------- | -------------- |
| IsSingleInstance | Key       | String   | Only valid value is 'Yes'. | Yes            |

## AAD Tenant Details

### Description

This resource configures the Azure AD Tenant Details

## Azure AD Permissions

To authenticate via Azure Active Directory, this resource required the following Application permissions:

| Operation | Permissions                                                                                    |
| --------- | ---------------------------------------------------------------------------------------------- |
| Automate  | Organization.Read.All, Directory.Read.All, Organization.ReadWrite.All, Directory.ReadWrite.All |
| Export    | None                                                                                           |

> **NOTE:** All permisions listed above require admin consent.

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on. It is not meant to use as a production baseline.

```powershell
Configuration Example {
    param(
        [System.Management.Automation.PSCredential]
        $GlobalAdmin
    )

    Import-DscResource -ModuleName Microsoft365DSC

    Node Localhost
    {
        AADTenantDetails TenantDetailsg
        {
            TechnicalNotificationMails             = "example@contoso.com"
            SecurityComplianceNotificationPhones   = "+1123456789"
            SecurityComplianceNotificationMails    = "example@contoso.com"
            MarketingNotificationEmails            = "example@contoso.com"
            Credential                             = $GlobalAdmin
            IsSingleInstance                       = 'Yes'
        }
    }
}

```
