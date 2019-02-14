# Description

This resource configures Security and Compliance Center Admin Audit Log.

# Example

```PowerShell
        AdminAuditLogConfig EnableUnifiedAuditLog {
            IsSingleInstance                = 'Yes'
            UnifiedAuditLogIngestionEnabled = 'Enabled'
            GlobalAdminAccount              = $GlobalAdminAccount
        }
```
