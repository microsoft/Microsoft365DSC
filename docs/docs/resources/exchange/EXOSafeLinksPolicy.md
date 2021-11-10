# EXOSafeLinksPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the SafeLinks policy that you want to modify. ||
| **Ensure** | Write | String | Specify if this policy should exist or not. |Present, Absent|
| **AdminDisplayName** | Write | String | The AdminDisplayName parameter specifies a description for the policy. ||
| **CustomNotificationText** | Write | String | The custom notification text specifies the customized notification text to show to users. ||
| **DeliverMessageAfterScan** | Write | Boolean | The DeliverMessageAfterScan parameter specifies whether to deliver email messages only after Safe Links scanning is complete. Valid values are: $true: Wait until Safe Links scanning is complete before delivering the message. $false: If Safe Links scanning can't complete, deliver the message anyway. This is the default value. ||
| **DoNotAllowClickThrough** | Write | Boolean | The DoNotAllowClickThrough parameter specifies whether to allow users to click through to the original URL. Valid values are: $true: The user isn't allowed to click through to the original URL. This is the default value. $false: The user is allowed to click through to the original URL. ||
| **DoNotRewriteUrls** | Write | StringArray[] | The DoNotRewriteUrls parameter specifies a URL that's skipped by Safe Links scanning. You can specify multiple values separated by commas. ||
| **DoNotTrackUserClicks** | Write | Boolean | The DoNotTrackUserClicks parameter specifies whether to track user clicks related to links in email messages. Valid values are: $true: User clicks aren't tracked. This is the default value. $false: User clicks are tracked. ||
| **EnableForInternalSenders** | Write | Boolean | The EnableForInternalSenders parameter specifies whether the Safe Links policy is applied to messages sent between internal senders and internal recipients within the same Exchange Online organization. ||
| **EnableOrganizationBranding** | Write | Boolean | The EnableOrganizationBranding parameter specifies whether your organization's logo is displayed on Safe Links warning and notification pages. ||
| **EnableSafeLinksForTeams** | Write | Boolean | The EnableSafeLinksForTeams parameter specifies whether Safe Links is enabled for Microsoft Teams. Valid values are: $true: Safe Links is enabled for Teams. If a protected user clicks a malicious link in a Teams conversation, group chat, or from channels, a warning page will appear in the default web browser. $false: Safe Links isn't enabled for Teams. This is the default value. ||
| **IsEnabled** | Write | Boolean | This parameter specifies whether the rule or policy is enabled.  ||
| **ScanUrls** | Write | Boolean | The ScanUrls parameter specifies whether to enable or disable the scanning of links in email messages. Valid values are: $true: Scanning links in email messages is enabled. $false: Scanning links in email messages is disabled. This is the default value. ||
| **UseTranslatedNotificationText** | Write | Boolean | The UseTranslatedNotificationText specifies whether to use Microsoft Translator to automatically localize the custom notification text that you specified with the CustomNotificationText parameter. ||
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||

# EXOSafeLinksPolicy

### Description

This resource configures the settings of the SafeLinks policies
in your cloud-based organization.

## Parameters

Ensure

- Required: No (Defaults to 'Present')
- Description: Specifies if the configuration should exist or not

Credential

- Required: Yes
- Description: Credentials of the Office 365 Global Admin

Identity

- Required: Yes
- Description: The Identity parameter specifies the policy that you
  want to modify.

AdminDisplayName

- Required: No
- Description: The AdminDisplayName parameter specifies a
    description for the policy.

CustomNotificationText

- Required: No
- Description: The custom notification text specifies the customized
  notification text to show to users

DeliverMessageAfterScan

- Required: No
- Description: The DeliverMessageAfterScan parameter specifies whether
  to deliver email messages only after Safe Links scanning is complete.
  Valid values are:
      $true: Wait until Safe Links scanning is complete before delivering the message.
      $false: If Safe Links scanning can't complete, deliver the message anyway. This is the default value.

DoNotAllowClickThrough

- Required: No
- Description: The DoNotAllowClickThrough parameter specifies whether to
  allow users to click through to the original URL.
  Valid values are:
      $true: The user isn't allowed to click through to the original URL.
      This is the default value.
      $false: The user is allowed to click through to the original URL.

DoNotRewriteUrls

- Required: No
- Description: The DoNotRewriteUrls parameter specifies a URL that's
  skipped by Safe Links scanning.

DoNotTrackUserClicks

- Required: No
- Description: The DoNotTrackUserClicks parameter specifies whether to
  track user clicks related to links in email messages
  Valid values are:
      $true: User clicks aren't tracked. This is the default value.
      $false: User clicks are tracked.

EnableForInternalSenders

- Required: No
- Description: This parameter specifies whether the policy is enabled
  for internal senders. $true or $false

EnableOrganizationBranding

- Required: No
- Description: The EnableOrganizationBranding parameter specifies whether
  your organization's logo is displayed on Safe Links warning and
  notification pages.

EnableSafeLinksForTeams

- Required: No
- Description: The EnableSafeLinksForTeams parameter specifies whether Safe Links
  is enabled for Microsoft Teams. Valid values are:
  $true: Safe Links is enabled for Teams. If a protected user clicks a malicious link in
  a Teams conversation, group chat, or from channels, a warning page will appear in the default web browser.
  $false: Safe Links isn't enabled for Teams. This is the default value.

IsEnabled

- Required: No
- Description: This parameter specifies whether the rule or policy
  is enabled. $true or $false

ScanUrls

- Required: No
- Description: The ScanUrls parameter specifies whether to enable or
  disable the scanning of links in email messages.
  Valid values are:
      $true: Scanning links in email messages is enabled.
      $false: Scanning links in email messages is disabled.
      This is the default value.

UseTranslatedNotificationText

- Required: No
- Description: The UseTranslatedNotificationText specifies whether to use
  Microsoft Translator to automatically localize the custom notification text
  that you specified with the CustomNotificationText parameter.

## Example

```PowerShell
    EXOSafeLinksPolicy SafeLinksPolicyExample {
        Ensure                   = 'Present'
        Identity                 = 'TestSafeLinksPolicy'
        Credential       = $Credential
        AdminDisplayName         = 'Test SafeLinks Policy'
        DoNotAllowClickThrough   = $true
        DoNotRewriteUrls         = @('test.contoso.com', 'test.fabrikam.com')
        DeliverMessageAfterScan  = $true
        DoNotTrackUserClicks     = $true
        EnableForInternalSenders = $false
        IsEnabled                = $true
        ScanUrls                 = $false
    }
```


