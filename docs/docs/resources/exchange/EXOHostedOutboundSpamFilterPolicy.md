# EXOHostedOutboundSpamFilterPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the name of the policy that you want to modify. There is only one policy named 'Default' ||
| **AdminDisplayName** | Write | String | The AdminDisplayName parameter specifies a description for the policy. ||
| **BccSuspiciousOutboundAdditionalRecipients** | Write | StringArray[] | The BccSuspiciousOutboundAdditionalRecipients parameter specifies the recipients to add to the Bcc field of outgoing spam messages. Valid input for this parameter is an email address. Separate multiple email addresses with commas. ||
| **BccSuspiciousOutboundMail** | Write | Boolean | The BccSuspiciousOutboundMail parameter enables or disables adding recipients to the Bcc field of outgoing spam messages. Valid input for this parameter is $true or $false. The default value is $false. You specify the additional recipients using the BccSuspiciousOutboundAdditionalRecipients parameter. ||
| **NotifyOutboundSpam** | Write | Boolean | The NotifyOutboundSpam parameter enables or disables sending notification messages to administrators when an outgoing message is determined to be spam. Valid input for this parameter is $true or $false. The default value is $false. You specify the administrators to notify by using the NotifyOutboundSpamRecipients parameter. ||
| **NotifyOutboundSpamRecipients** | Write | StringArray[] | The NotifyOutboundSpamRecipients parameter specifies the administrators to notify when an outgoing message is determined to be spam. Valid input for this parameter is an email address. Separate multiple email addresses with commas. ||
| **RecipientLimitInternalPerHour** | Write | String | The RecipientLimitInternalPerHour parameter specifies the maximum number of internal recipients that a user can send to within an hour. A valid value is 0 to 10000. The default value is 0, which means the service defaults are used. ||
| **RecipientLimitPerDay** | Write | String | The RecipientLimitPerDay parameter specifies the maximum number of recipients that a user can send to within a day. A valid value is 0 to 10000. The default value is 0, which means the service defaults are used. ||
| **RecipientLimitExternalPerHour** | Write | String | The RecipientLimitExternalPerHour parameter specifies the maximum number of external recipients that a user can send to within an hour. A valid value is 0 to 10000. The default value is 0, which means the service defaults are used. ||
| **ActionWhenThresholdReached** | Write | String | The ActionWhenThresholdReached parameter specifies the action to take when any of the limits specified in the policy are reached. Valid values are: Alert, BlockUser, BlockUserForToday. BlockUserForToday is the default value. ||
| **AutoForwardingMode** | Write | String | The AutoForwardingMode specifies how the policy controls automatic email forwarding to outbound recipients. Valid values are: Automatic, On, Off. ||
| **Ensure** | Write | String | Specify if this rule should exist or not.  This value must be 'Present' as the Default policy cannot be deleted. |Present|
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||

# EXOHostedOutboundSpamFilterPolicy

### Description

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

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOHostedOutboundSpamFilterPolicy 'HostedOutboundSpamFilterPolicy'
        {
            Identity                                  = "Default"
            ActionWhenThresholdReached                = "BlockUserForToday"
            AdminDisplayName                          = ""
            AutoForwardingMode                        = "Automatic"
            BccSuspiciousOutboundAdditionalRecipients = @()
            BccSuspiciousOutboundMail                 = $False
            NotifyOutboundSpam                        = $False
            NotifyOutboundSpamRecipients              = @()
            RecipientLimitExternalPerHour             = 0
            RecipientLimitInternalPerHour             = 0
            RecipientLimitPerDay                      = 0
            Ensure                                    = "Present"
            Credential                                = $credsGlobalAdmin
        }
    }
}
```

