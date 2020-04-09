# EXOHostedOutboundSpamFilterPolicy

## Description

This resource configures the settings of the outbound spam filter policy
in your cloud-based organization.

## Parameters

Ensure

- Required: No (Defaults to 'Present')
- Description: `Present` is the only value accepted.
  Configurations using `Ensure = 'Absent'` will throw an Error!

IsSingleInstance

- Required: Yes
- Description: Single instance resource, the value must be 'Yes'

GlobalAdminAccount

- Required: Yes
- Description: Credentials of the Office 365 Global Admin

Identity

- Required: No
- Description: The Identity parameter specifies the policy that
  you want to modify. There's only one policy named Default.

AdminDisplayName

- Required: No
- Description: The AdminDisplayName parameter specifies a
  description for the policy.

BccSuspiciousOutboundMail

- Required: No
- Description: The BccSuspiciousOutboundMail parameter enables or
  disables adding recipients to the Bcc field of outgoing spam messages.
  Valid input for this parameter is $true or $false.
  The default value is $false.
  You specify the additional recipients using the
  BccSuspiciousOutboundAdditionalRecipients parameter.

BccSuspiciousOutboundAdditionalRecipients

- Required: No
- Description: The BccSuspiciousOutboundAdditionalRecipients parameter
  specifies the recipients to add to the Bcc field of outgoing
  spam messages. You can specify multiple values separated by commas.

NotifyOutboundSpam

- Required: No
- Description: The NotifyOutboundSpam parameter enables or disables
  sending notification messages to administrators when an outgoing
  message is determined to be spam. Valid input for this parameter is
  $true or $false. The default value is $false.
  You specify the administrators to notify by using the
  NotifyOutboundSpamRecipients parameter.

NotifyOutboundSpamRecipients

- Required: No
- Description: The NotifyOutboundSpamRecipients parameter specifies the
  administrators to notify when an outgoing message is determined to be
  spam. Valid input for this parameter is an email address.
  Separate multiple email addresses with commas.

## Example

```PowerShell
EXOHostedOutboundSpamFilterPolicy HostedOutboundSpamFilterPolicyExample {
  IsSingleInstance                          = 'Yes'
  Ensure                                    = 'Present'
  Identity                                  = 'Default'
  GlobalAdminAccount                        = $GlobalAdminAccount
  AdminDisplayName                          = 'Default Outbound Spam Filter Policy'
  BccSuspiciousOutboundMail                 = $true
  BccSuspiciousOutboundAdditionalRecipients = @('admin@contoso.com')
  NotifyOutboundSpam                        = $true
  NotifyOutboundSpamRecipients              = @('supervisor@contoso.com')
}
```
