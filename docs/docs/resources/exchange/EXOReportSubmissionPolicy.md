# EXOReportSubmissionPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Specifies the resource is a single instance, the value must be 'Yes'. | `Yes` |
| **DisableQuarantineReportingOption** | Write | Boolean | The DisableQuarantineReportingOption parameter allows or prevents users from reporting messages in quarantine. | |
| **EnableCustomNotificationSender** | Write | Boolean | The EnableCustomNotificationSender parameter specifies whether a custom sender email address is used for result messages after an admin reviews and marks the reported messages as junk, not junk, or phishing. | |
| **EnableOrganizationBranding** | Write | Boolean | The EnableOrganizationBranding parameter specifies whether to show the company logo in the footer of result messages that users receive after an admin reviews and marks the reported messages as junk, not junk, or phishing. | |
| **EnableReportToMicrosoft** | Write | Boolean | The EnableReportToMicrosoft parameter specifies whether Microsoft integrated reporting experience is enabled or disabled. | |
| **EnableThirdPartyAddress** | Write | Boolean | The EnableThirdPartyAddress parameter specifies whether you're using third-party reporting tools in Outlook instead of Microsoft tools to send messages to the reporting mailbox in Exchange Online. | |
| **EnableUserEmailNotification** | Write | Boolean | The EnableUserEmailNotification parameter species whether users receive result messages after an admin reviews and marks the reported messages as junk, not junk, or phishing. | |
| **JunkReviewResultMessage** | Write | String | The JunkReviewResultMessage parameter specifies the custom text to use in result messages after an admin reviews and marks the reported messages as junk. | |
| **NotJunkReviewResultMessage** | Write | String | The NotJunkReviewResultMessage parameter specifies the custom text to use in result messages after an admin reviews and marks the reported messages as not junk. | |
| **NotificationFooterMessage** | Write | String | The NotificationFooterMessage parameter specifies the custom footer text to use in email notifications after an admin reviews and marks the reported messages as junk, not junk, or phishing. | |
| **NotificationSenderAddress** | Write | String | The NotificationSenderAddress parameter specifies the sender email address to use in result messages after an admin reviews and marks the reported messages as junk, not junk, or phishing. | |
| **PhishingReviewResultMessage** | Write | String | The PhishingReviewResultMessage parameter specifies the custom text to use in result messages after an admin reviews and marks the reported messages as phishing. | |
| **PostSubmitMessage** | Write | String | The PostSubmitMessage parameter specifies the custom pop-up message text to use in Outlook notifications after users report messages. | |
| **PostSubmitMessageEnabled** | Write | Boolean | The PostSubmitMessageEnabled parameter enables or disables the pop-up Outlook notifications that users see after they report messages using Microsoft reporting tools. | |
| **PostSubmitMessageTitle** | Write | String | The PostSubmitMessage parameter parameter specifies the custom pop-up message title to use in Outlook notifications after users report messages. | |
| **PreSubmitMessage** | Write | String | The PreSubmitMessage parameter specifies the custom pop-up message text to use in Outlook notifications before users report messages.  | |
| **PreSubmitMessageEnabled** | Write | Boolean | The PreSubmitMessageEnabled parameter enables or disables the pop-up Outlook notifications that users see before they report messages using Microsoft reporting tools. | |
| **PreSubmitMessageTitle** | Write | String | The PreSubmitMessage parameter parameter specifies the custom pop-up message title to use in Outlook notifications before users report messages. | |
| **ReportJunkAddresses** | Write | StringArray[] | The ReportJunkAddresses parameter specifies the email address of the reporting mailbox in Exchange Online to receive user reported messages in reporting in Outlook using Microsoft or third-party reporting tools in Outlook. | |
| **ReportJunkToCustomizedAddress** | Write | Boolean | The ReportJunkToCustomizedAddress parameter specifies whether to send user reported messages from Outlook (using Microsoft or third-party reporting tools) to the reporting mailbox as part of reporting in Outlook.  | |
| **ReportNotJunkAddresses** | Write | StringArray[] | The ReportNotJunkAddresses parameter specifies the email address of the reporting mailbox in Exchange Online to receive user reported messages in reporting in Outlook using Microsoft or third-party reporting tools in Outlook. | |
| **ReportNotJunkToCustomizedAddress** | Write | Boolean | The ReportNotJunkToCustomizedAddress parameter specifies whether to send user reported messages from Outlook (using Microsoft or third-party reporting tools) to the reporting mailbox as part of reporting in Outlook. | |
| **ReportPhishAddresses** | Write | StringArray[] | The ReportPhishAddresses parameter specifies the email address of the reporting mailbox in Exchange Online to receive user reported messages in reporting in Outlook using Microsoft or third-party reporting tools in Outlook. | |
| **ReportPhishToCustomizedAddress** | Write | Boolean | The ReportPhishToCustomizedAddress parameter specifies whether to send user reported messages from Outlook (using Microsoft or third-party reporting tools) to the reporting mailbox as part of reporting in Outlook. | |
| **ThirdPartyReportAddresses** | Write | StringArray[] | Use the ThirdPartyReportAddresses parameter to specify the email address of the reporting mailbox when you're using a third-party product for user submissions instead of reporting in Outlook. | |
| **Ensure** | Write | String | Specifies if this report submission policy should exist. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

Create or modify an EXOReportSubmissionPolicy in your cloud-based organization.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Transport Hygiene, Security Admin, View-Only Configuration, Security Reader

#### Role Groups

- Organization Management

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOReportSubmissionPolicy 'ConfigureReportSubmissionPolicy'
        {
            IsSingleInstance                       = 'Yes'
            DisableQuarantineReportingOption       = $False
            EnableCustomNotificationSender         = $False
            EnableOrganizationBranding             = $False
            EnableReportToMicrosoft                = $True
            EnableThirdPartyAddress                = $False
            EnableUserEmailNotification            = $False
            PostSubmitMessageEnabled               = $True
            PreSubmitMessageEnabled                = $True
            ReportJunkToCustomizedAddress          = $False
            ReportNotJunkToCustomizedAddress       = $False
            ReportPhishToCustomizedAddress         = $False
            Ensure                                 = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
```

