﻿# SCDLPComplianceRule

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | Name of the Rule. | |
| **Policy** | Required | String | Name of the associated DLP Compliance Policy. | |
| **AccessScope** | Write | StringArray[] | The AccessScope parameter specifies a condition for the DLP rule that's based on the access scope of the content. The rule is applied to content that matches the specified access scope. | `InOrganization`, `NotInOrganization`, `None` |
| **BlockAccess** | Write | Boolean | The BlockAccess parameter specifies an action for the DLP rule that blocks access to the source item when the conditions of the rule are met. $true: Blocks further access to the source item that matched the rule. The owner, author, and site owner can still access the item. $false: Allows access to the source item that matched the rule. This is the default value. | |
| **BlockAccessScope** | Write | String | The BlockAccessScope parameter specifies the scope of the block access action. | `All`, `PerUser` |
| **Comment** | Write | String | The Comment parameter specifies an optional comment. If you specify a value that contains spaces, enclose the value in quotation marks. | |
| **ContentContainsSensitiveInformation** | Write | MSFT_SCDLPContainsSensitiveInformation | The ContentContainsSensitiveInformation parameter specifies a condition for the rule that's based on a sensitive information type match in content. The rule is applied to content that contains the specified sensitive information type. | |
| **ExceptIfContentContainsSensitiveInformation** | Write | MSFT_SCDLPContainsSensitiveInformation | The ExceptIfContentContainsSensitiveInformation parameter specifies an exception for the rule that's based on a sensitive information type match in content. The rule isn't applied to content that contains the specified sensitive information type. | |
| **ContentPropertyContainsWords** | Write | StringArray[] | The ContentPropertyContainsWords parameter specifies a condition for the DLP rule that's based on a property match in content. The rule is applied to content that contains the specified property. | |
| **Disabled** | Write | Boolean | The Disabled parameter specifies whether the DLP rule is disabled. | |
| **GenerateAlert** | Write | StringArray[] | The GenerateAlert parameter specifies an action for the DLP rule that notifies the specified users when the conditions of the rule are met. | |
| **GenerateIncidentReport** | Write | StringArray[] | The GenerateIncidentReport parameter specifies an action for the DLP rule that sends an incident report to the specified users when the conditions of the rule are met. | |
| **IncidentReportContent** | Write | StringArray[] | The IncidentReportContent parameter specifies the content to include in the report when you use the GenerateIncidentReport parameter. | `All`, `Default`, `DetectionDetails`, `Detections`, `DocumentAuthor`, `DocumentLastModifier`, `MatchedItem`, `OriginalContent`, `RulesMatched`, `Service`, `Severity`, `Title`, `RetentionLabel`, `SensitivityLabel` |
| **NotifyAllowOverride** | Write | StringArray[] | The NotifyAllowOverride parameter specifies the notification override options when the conditions of the rule are met. | `FalsePositive`, `WithoutJustification`, `WithJustification` |
| **NotifyEmailCustomText** | Write | String | The NotifyEmailCustomText parameter specifies the custom text in the email notification message that's sent to recipients when the conditions of the rule are met. | |
| **NotifyPolicyTipCustomText** | Write | String | The NotifyPolicyTipCustomText parameter specifies the custom text in the Policy Tip notification message that's shown to recipients when the conditions of the rule are met. The maximum length is 256 characters. HTML tags and tokens (variables) aren't supported. | |
| **NotifyUser** | Write | StringArray[] | The NotifyUser parameter specifies an action for the DLP rule that notifies the specified users when the conditions of the rule are met. | |
| **ReportSeverityLevel** | Write | String | The ReportSeverityLevel parameter specifies the severity level of the incident report for content detections based on the rule. | `Low`, `Medium`, `High`, `None` |
| **RuleErrorAction** | Write | String | The RuleErrorAction parameter specifies what to do if an error is encountered during the evaluation of the rule. | `Ignore`, `RetryThenBlock` |
| **Ensure** | Write | String | Specify if this rule should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **AnyOfRecipientAddressContainsWords** | Write | StringArray[] | The AnyOfRecipientAddressContainsWords parameter specifies a condition for the DLP rule that looks for words or phrases in recipient email addresses. | |
| **AnyOfRecipientAddressMatchesPatterns** | Write | StringArray[] | The AnyOfRecipientAddressMatchesPatterns parameter specifies a condition for the DLP rule that looks for text patterns in recipient email addresses by using regular expressions.. | |
| **RemoveRMSTemplate** | Write | Boolean | The RemoveRMSTemplate parameter specifies an action for the DLP rule that removes Office 365 Message Encryption from messages and their attachments. | |
| **StopPolicyProcessing** | Write | Boolean | The StopPolicyProcessing parameter specifies an action that stops processing more DLP policy rules. | |
| **DocumentIsUnsupported** | Write | Boolean | The DocumentIsUnsupported parameter specifies a condition for the DLP rule that looks for files that can't be scanned. | |
| **ExceptIfDocumentIsUnsupported** | Write | Boolean | The ExceptIfDocumentIsUnsupported parameter specifies an exception for the DLP rule that looks for files that can't be scanned. | |
| **HasSenderOverride** | Write | Boolean | The SenderOverride parameter specifies a condition for the rule that looks for messages where the sender chose to override a DLP policy. | |
| **ExceptIfHasSenderOverride** | Write | Boolean | The ExceptIfHasSenderOverride parameter specifies an exception for the rule that looks for messages where the sender chose to override a DLP policy. | |
| **ProcessingLimitExceeded** | Write | Boolean | The ProcessingLimitExceeded parameter specifies a condition for the DLP rule that looks for files where scanning couldn't complete. | |
| **ExceptIfProcessingLimitExceeded** | Write | Boolean | The ExceptIfProcessingLimitExceeded parameter specifies an exception for the DLP rule that looks for files where scanning couldn't complete. | |
| **DocumentIsPasswordProtected** | Write | Boolean | The DocumentIsPasswordProtected parameter specifies a condition for the DLP rule that looks for password protected files (because the contents of the file can't be inspected). Password detection only works for Office documents and .zip files. | |
| **ExceptIfDocumentIsPasswordProtected** | Write | Boolean | The ExceptIfDocumentIsPasswordProtected parameter specifies an exception for the DLP rule that looks for password protected files (because the contents of the file can't be inspected). Password detection only works for Office documents and .zip files.  | |
| **ContentExtensionMatchesWords** | Write | StringArray[] | The ContentExtensionMatchesWords parameter specifies a condition for the DLP rule that looks for words in file name extensions. You can specify multiple words separated by commas. | |
| **ExceptIfContentExtensionMatchesWords** | Write | StringArray[] | The ExceptIfContentExtensionMatchesWords parameter specifies an exception for the DLP rule that looks for words in file name extensions. You can specify multiple words separated by commas. | |

### MSFT_SCDLPSensitiveInformation

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **name** | Required | String | Name of the Sensitive Information Content | |
| **id** | Write | String | Id of the Sensitive Information Content | |
| **maxconfidence** | Write | String | Maximum Confidence level value for the Sensitive Information | |
| **minconfidence** | Write | String | Minimum Confidence level value for the Sensitive Information | |
| **classifiertype** | Write | String | Type of Classifier value for the Sensitive Information | |
| **mincount** | Write | String | Minimum Count value for the Sensitive Information | |
| **maxcount** | Write | String | Maximum Count value for the Sensitive Information | |

### MSFT_SCDLPLabel

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **name** | Required | String | Name of the Sensitive Label | |
| **id** | Write | String | Id of the Sensitive Information label | |
| **type** | Write | String | Type of the Sensitive Information label | |

### MSFT_SCDLPContainsSensitiveInformationGroup

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **SensitiveInformation** | Write | MSFT_SCDLPSensitiveInformation[] | Sensitive Information Content Types | |
| **Labels** | Write | MSFT_SCDLPLabel[] | Sensitive Information Labels | |
| **Name** | Required | String | Name of the group | |
| **Operator** | Required | String | Operator | `And`, `Or` |

### MSFT_SCDLPContainsSensitiveInformation

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **SensitiveInformation** | Write | MSFT_SCDLPSensitiveInformation[] | Sensitive Information Content Types | |
| **Groups** | Write | MSFT_SCDLPContainsSensitiveInformationGroup[] | Groups of sensitive information types. | |
| **Operator** | Write | String | Operator | `And`, `Or` |

## Description

This resource configures a Data Loss Prevention Compliance
Rule in Security and Compliance Center.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - None

- **Update**

    - None

#### Application permissions

- **Read**

    - None

- **Update**

    - None

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SCDLPComplianceRule 'ConfigureDLPComplianceRule'
        {
            Name                                = 'Low volume EU Sensitive content found'
            Policy                              = 'General Data Protection Regulation (GDPR)'
            AccessScope                         = 'InOrganization'
            BlockAccess                         = $True
            BlockAccessScope                    = 'All'
            ContentContainsSensitiveInformation = MSFT_SCDLPContainsSensitiveInformation
            {
                SensitiveInformation = @(
                    MSFT_SCDLPSensitiveInformation
                    {
                        name           = 'EU Debit Card Number'
                        id             = '0e9b3178-9678-47dd-a509-37222ca96b42'
                        maxconfidence  = '100'
                        minconfidence  = '75'
                        classifiertype = 'Content'
                        mincount       = '1'
                        maxcount       = '9'
                    }
                )
            }
            Disabled                            = $False
            DocumentIsPasswordProtected         = $False
            DocumentIsUnsupported               = $False
            ExceptIfDocumentIsPasswordProtected = $False
            ExceptIfDocumentIsUnsupported       = $False
            ExceptIfHasSenderOverride           = $False
            ExceptIfProcessingLimitExceeded     = $False
            GenerateIncidentReport              = @('SiteAdmin')
            HasSenderOverride                   = $False
            IncidentReportContent               = @('DocumentLastModifier', 'Detections', 'Severity', 'DetectionDetails', 'OriginalContent')
            NotifyUser                          = @('LastModifier')
            ProcessingLimitExceeded             = $False
            RemoveRMSTemplate                   = $False
            ReportSeverityLevel                 = 'Low'
            StopPolicyProcessing                = $False
            Ensure                              = 'Present'
            Credential                          = $credsGlobalAdmin
        }
    }
}
```

