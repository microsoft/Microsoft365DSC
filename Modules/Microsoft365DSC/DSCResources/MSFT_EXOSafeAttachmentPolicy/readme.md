# EXOSafeAttachmentPolicy

## Description

This resource configures the settings of the Safe Attachments policies
in your cloud-based organization.

## Parameters

Ensure

- Required: No (Defaults to 'Present')
- Description: Specifies if the configuration should exist or not

GlobalAdminAccount

- Required: Yes
- Description: Credentials of the Office 365 Global Admin

Identity

- Required: Yes
- Description: The Identity parameter specifies the policy
  that you want to modify.

AdminDisplayName

- Required: No
- Description: The AdminDisplayName parameter specifies a
  description for the policy.

Action

- Required: No
- Description: The Action parameter specifies the action for the
  Safe Attachments policy.
  Valid values are:
    Allow: Deliver the email message, including the malware attachment
    Block: Block the email message that contains the malware attachment
    This is the default value.
    Replace: Deliver the email message, but remove the malware
    attachment and replace it with warning text

ActionOnError

- Required: No
- Description: The ActionOnError parameter specifies the error handling
  option for Safe Attachments scanning (what to do if scanning times out
  or an error occurs).
  Valid values are:
  - $true: The action specified by the Action parameter is applied
    to messages even when the attachments aren't successfully scanned.
  - $false: The action specified by the Action parameter isn't
    applied to messages when the attachments aren't successfully
    scanned. This is the default value.

Enable

- Required: No
- Description: This parameter specifies whether the rule or policy is
  enabled. $true of $false.  $false is the default.

Redirect

- Required: No
- Description: The Redirect parameter specifies whether to send detected
  malware attachments to another email address.
  Valid values are:
      $true: Malware attachments are sent to the email address
      specified by the RedirectAddress parameter.
      $false: Malware attachments aren't sent to another email address.
      This is the default value.

RedirectAddress

- Required: No
- Description: The RedirectAddress parameter specifies the email
  address where detected malware attachments are sent when
  the Redirect parameter is set to the value $true.

## Example

```PowerShell
        EXOSafeAttachmentPolicy SafeAttachmentPolicyExample {
                Ensure             = 'Present'
                Identity           = 'TestSafeAttachmentPolicy'
                GlobalAdminAccount = $GlobalAdminAccount
                AdminDisplayName   = 'Test Safe Attachment Policy'
                Action             = 'Block'
                Enable             = $true
                Redirect           = $true
                RedirectAddress    = 'test@contoso.com'
        }
```
