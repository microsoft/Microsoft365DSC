# O365AdminAuditLogConfig

## Description

This resource configures Security and Compliance Center Admin Audit Log.

## Example

```PowerShell
        O365AdminAuditLogConfig EnableUnifiedAuditLog {
            IsSingleInstance                = 'Yes'
            UnifiedAuditLogIngestionEnabled = 'Enabled'
            GlobalAdminAccount              = $GlobalAdminAccount
        }
```
