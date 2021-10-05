# EXOHostedContentFilterRule

## Description

This resource configures an Hosted Content Filter Rule in Exchange Online.
Reference: https://docs.microsoft.com/en-us/powershell/module/exchange/advanced-threat-protection/new-HostedContentFilterRule?view=exchange-ps

## Parameters

HostedContentFilterPolicy

- Required: Yes
- Description: The Identity of the HostedContentFilter Policy to
  associate with this HostedContentFilter Rule.

Ensure

- Required: No (Defaults to 'Present')
- Description: `Present` is the only value accepted.
    Configurations using `Ensure = 'Absent'` will throw an Error!

Credential

- Required: Yes
- Description: Credentials of the account to authenticate with

Identity

- Required: Yes
- Description: Domain name of the AcceptedDomain

## Example

```PowerShell
        EXOHostedContentFilterRule TestHostedContentFilterRule {
            Ensure = 'Present'
            Identity = 'TestRule'
            Credential = $Credential
            HostedContentFilterPolicy = 'TestPolicy'
            Enabled = $true
            Priority = 0
            RecipientDomainIs = @('contoso.com')
        }
```
