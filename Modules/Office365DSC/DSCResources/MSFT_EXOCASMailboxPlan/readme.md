# EXOCASMailboxPlan

## Description

This resource configures Client Access services (CAS) mailbox plans
in cloud-based organizations.

## Parameters

Ensure

- Required: No (Defaults to 'Present')
- Description: `Present` is the only value accepted.
  Configurations using `Ensure = 'Absent'` will throw an Error!

GlobalAdminAccount

- Required: Yes
- Description: Credentials of the Office 365 Global Admin

Identity

- Required: Yes
- Description: The Identity parameter specifies the CAS mailbox plan that
  you want to modify.

ActiveSyncEnabled

- Required: No
- Description: The ActiveSyncEnabled parameter enables or disables access
  to the mailbox by using Exchange Active Sync. The default is $true.

ImapEnabled

- Required: No
- Description: The ImapEnabled parameter enables or disables access to
  the mailbox by using IMAP4 clients. The default value is $true for all
  CAS mailbox plans except ExchangeOnlineDeskless which is $false by default.

OwaMailboxPolicy

- Required: No
- Description: The OwaMailboxPolicy parameter specifies the Outlook on
  the web (formerly known as Outlook Web App) mailbox policy for the
  mailbox plan. The default value is OwaMailboxPolicy-Default.
  You can use the Get-OwaMailboxPolicy cmdlet to view the available
  Outlook on the web mailbox policies.

PopEnabled

- Required: No
- Description: The PopEnabled parameter enables or disables access to
  the mailbox by using POP3 clients. The default value is $true.

## Example

```PowerShell
        EXOCASMailboxPlan CASMBPExampleConfig {
            Ensure              = 'Present'
            Identity            = 'ExchangeOnlineEnterprise-6f6c267b-f8db-4020-b441-f7bd966a0ca0'
            GlobalAdminAccount  = $GlobalAdminAccount
            ActiveSyncEnabled   = $true
            ImapEnabled         = $true
            OwaMailboxPolicy    = 'OwaMailboxPolicy-Default'
            PopEnabled          = $true
        }
```
