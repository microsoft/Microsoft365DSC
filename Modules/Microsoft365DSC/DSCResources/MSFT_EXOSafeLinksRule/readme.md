# EXOSafeLinksRule

## Description

This resource configures an SafeLinks Rule in Exchange Online.

## Parameters

SafeLinksPolicy

- Required: Yes
- Description: The Identity of the SafeLinks Policy to associate with
  this SafeLinks Rule.

Ensure

- Required: No (Defaults to 'Present')
- Description: Specifies if the configuration should be `Present` or `Absent`

Credential

- Required: Yes
- Description: Credentials of the account to authenticate with

Identity

- Required: Yes
- Description: Name of the SafeLinks Rule

## Example

```PowerShell
        EXOSafeLinksRule TestSafeLinksRule {
            Ensure = 'Present'
            Identity = 'TestRule'
            Credential = $Credential
            SafeLinksPolicy = 'TestSafeLinksPolicy'
            Enabled = $true
            Priority = 0
            RecipientDomainIs = @('contoso.com')
        }
```
