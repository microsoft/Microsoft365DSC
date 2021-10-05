# O365AdminAuditLogConfig

## Description

This resource configures Security and Compliance Center Admin Audit Log.

## Parameters

Ensure

- Required: No (Defaults to 'Present')
- Description: `Present` is the only value accepted.
  Configurations using `Ensure = 'Absent'` will throw an Error!

IsSingleInstance

- Required: Yes
- Description: Single instance resource, the value must be 'Yes'

Credential

- Required: Yes
- Description: Credentials of the account to authenticate with

UnifiedAuditLogIngestionEnabled

- Required: Yes
- Description: Determins if Unified Audit Log Ingestion is Enabled or Disabled

## Example

```PowerShell
        O365AdminAuditLogConfig EnableUnifiedAuditLog {
            IsSingleInstance                = 'Yes'
            Ensure                          = 'Present'
            UnifiedAuditLogIngestionEnabled = 'Enabled'
            Credential              = $Credential
        }
```
