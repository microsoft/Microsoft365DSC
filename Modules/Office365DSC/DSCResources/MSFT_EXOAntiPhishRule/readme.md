# EXOAntiPhishRule

## Description

This resource configures an Anti-Phish Rule in Exchange Online.
Reference: https://docs.microsoft.com/en-us/powershell/module/exchange/advanced-threat-protection/new-antiphishRule?view=exchange-ps

## Parameters

    AntiPhishPolicy
      - Required: Yes
      - Description: The Identity of the AntiPhish Policy to associate with this AntiPhish Rule.

    Ensure
      - Required: No (Defaults to 'Present')
      - Description: `Present` is the only value accepted.
          Configurations using `Ensure = 'Absent'` will throw an Error!

    GlobalAdminAccount
      - Required: Yes
      - Description: Credentials of an Office365 Global Admin

    Identity
      - Required: Yes
      - Description: Domain name of the AcceptedDomain



## Example

```PowerShell
        EXOAntiPhishRule TestPhishRule {
            Ensure = 'Present'
            Identity = 'TestRule'
            GlobalAdminAccount = $GlobalAdminAccount
            AntiPhishPolicy = 'TestPolicy'
            Enabled = $true
            Priority = 0
            RecipientDomainIs = @('contoso.com')
        }
```
