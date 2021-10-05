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

Credential

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

RecipientLimitInternalPerHour

- Required: No
- Description: The RecipientLimitInternalPerHour parameter specifies the
  maximum number of internal recipients that a user can send to within
  an hour. A valid value is 0 to 10000. The default value is 0, which
  means the service defaults are used.

RecipientLimitPerDay

- Required: No
- Description: The RecipientLimitPerDay parameter specifies the maximum
  number of recipients that a user can send to within a day. A valid
  value is 0 to 10000. The default value is 0, which means the service
  defaults are used.

RecipientLimitExternalPerHour

- Required: No
- Description: The RecipientLimitExternalPerHour parameter specifies the
  maximum number of external recipients that a user can send to within
  an hour. A valid value is 0 to 10000. The default value is 0, which
  means the service defaults are used.

ActionWhenThresholdReached

- Required: No
- Description: The ActionWhenThresholdReached parameter specifies the
  action to take when any of the limits specified in the policy are
  reached. Valid values are: Alert, BlockUser, BlockUserForToday.
  BlockUserForToday is the default value.

AutoForwardingMode

- Required: No
- Description: The AutoForwardingMode specifies how the policy controls
  automatic email forwarding to outbound recipients. Valid values are:
  Automatic, On, Off.


## Example

```PowerShell
EXOHostedOutboundSpamFilterPolicy HostedOutboundSpamFilterPolicyExample {
  IsSingleInstance                          = 'Yes'
  Ensure                                    = 'Present'
  Identity                                  = 'Default'
  Credential                                = $Credential
  AdminDisplayName                          = 'Default Outbound Spam Filter Policy'
  BccSuspiciousOutboundMail                 = $true
  BccSuspiciousOutboundAdditionalRecipients = @('admin@contoso.com')
  NotifyOutboundSpam                        = $true
  NotifyOutboundSpamRecipients              = @('supervisor@contoso.com')
  RecipientLimitInternalPerHour             = '0'
  RecipientLimitPerDay                      = '0'
  RecipientLimitExternalPerHour             = '0'
  ActionWhenThresholdReached                = 'BlockUserForToday'
  AutoForwardingMode                        = 'Automatic'
}
```
