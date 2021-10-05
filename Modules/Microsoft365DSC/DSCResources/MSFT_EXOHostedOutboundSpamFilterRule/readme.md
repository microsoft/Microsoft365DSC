# EXOHostedOutboundSpamFilterRule

## Description

This resource configures an Hosted Content Filter Rule in Exchange Online.
Reference: https://docs.microsoft.com/en-us/powershell/module/exchange/new-hostedoutboundspamfilterrule?view=exchange-ps

## Parameters

HostedOutboundSpamFilterPolicy

- Required: Yes
- Description: The Identity of the HostedOutboundSpamFilter Policy to
  associate with this HostedOutboundSpamFilter Rule.

Ensure

- Required: No (Defaults to 'Present')
- Description: `Present` is the only value accepted.
    Configurations using `Ensure = 'Absent'` will throw an Error!

Credential

- Required: Yes
- Description: Credentials of the account to authenticate with

Identity

- Required: Yes
- Description: Name of the HostedOutboundSpamFilterRule

## Example

```PowerShell
        EXOHostedOutboundSpamFilterRule TestHostedOutboundSpamFilterRule {
            Ensure = 'Present'
            Identity = 'TestRule'
            Credential = $Credential
            HostedOutboundSpamFilterPolicy = 'TestPolicy'
            Enabled = $true
            Priority = 0
            SenderDomainIs = @('contoso.com')
        }
```
