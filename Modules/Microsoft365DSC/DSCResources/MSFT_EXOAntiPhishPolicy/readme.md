# EXOAntiPhishPolicy

## Description

This resource configures an Anti-Phish Policy in Exchange Online.
Reference: https://docs.microsoft.com/en-us/powershell/module/exchange/advanced-threat-protection/new-antiphishpolicy?view=exchange-ps

## Parameters

Ensure

- Required: No (Defaults to 'Present')
- Description: Specifies if the configuration should be `Present` or `Absent`

Credential

- Required: Yes
- Description: Credentials of the account to authenticate with

Identity

- Required: Yes
- Description: Name of the Anti-Phish Policy

## Example

```PowerShell
EXOAntiPhishPolicy TestPhishPolicy {
    Ensure = 'Present'
    Identity = 'TestPolicy'
    Credential = $Credential
}
```
