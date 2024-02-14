# SCDLPComplianceRule

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | Name of the Rule. | |
| **Policy** | Required | String | Name of the associated DLP Compliance Policy. | |
| **AccessScope** | Write | String | The AccessScope parameter specifies a condition for the DLP rule that's based on the access scope of the content. The rule is applied to content that matches the specified access scope. | `InOrganization`, `NotInOrganization`, `None` |
| **BlockAccess** | Write | Boolean | The BlockAccess parameter specifies an action for the DLP rule that blocks access to the source item when the conditions of the rule are met. $true: Blocks further access to the source item that matched the rule. The owner, author, and site owner can still access the item. $false: Allows access to the source item that matched the rule. This is the default value. | |
| **BlockAccessScope** | Write | String | The BlockAccessScope parameter specifies the scope of the block access action. | `All`, `PerUser`, `None` |
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
| **AnyOfRecipientAddressMatchesPatterns** | Write | StringArray[] | The AnyOfRecipientAddressMatchesPatterns parameter specifies a condition for the DLP rule that looks for text patterns in recipient email addresses by using regular expressions. | |
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
| **MessageTypeMatches** | Write | StringArray[] | The MessageTypeMatches parameter specifies a condition for the DLP rule that looks for types of SMIME message patterns. | |
| **FromScope** | Write | StringArray[] | The FromScope parameter specifies wether messages from inside or outside the organisation are in scope for the DLP rule. | |
| **ExceptIfFromScope** | Write | StringArray[] | The ExceptIfFromScope parameter specifies wether messages from inside or outside the organisation are in scope for the DLP rule. | |
| **SubjectContainsWords** | Write | StringArray[] | The SubjectContainsWords parameter specifies a condition for the DLP rule that looks for words or phrases in the Subject field of messages. You can specify multiple words or phrases separated by commas. | |
| **SubjectMatchesPatterns** | Write | StringArray[] | The SubjectMatchesPatterns parameter specifies a condition for the DLP rule that looks for text patterns in the Subject field of messages by using regular expressions. | |
| **SubjectOrBodyContainsWords** | Write | StringArray[] | The SubjectOrBodyContainsWords parameter specifies a condition for the rule that looks for words in the Subject field or body of messages. | |
| **SubjectOrBodyMatchesPatterns** | Write | StringArray[] | The SubjectOrBodyMatchesPatterns parameter specifies a condition for the rule that looks for text patterns in the Subject field or body of messages. | |
| **ContentCharacterSetContainsWords** | Write | StringArray[] | The ContentCharacterSetContainsWords parameter specifies a condition for the rule that looks for character set names in messages. You can specify multiple values separated by commas. | |
| **DocumentNameMatchesPatterns** | Write | StringArray[] | The DocumentNameMatchesPatterns parameter specifies a condition for the DLP rule that looks for text patterns in the name of message attachments by using regular expressions. | |
| **DocumentNameMatchesWords** | Write | StringArray[] | The DocumentNameMatchesWords parameter specifies a condition for the DLP rule that looks for words or phrases in the name of message attachments.  | |
| **ExceptIfAnyOfRecipientAddressContainsWords** | Write | StringArray[] | he ExceptIfAnyOfRecipientAddressContainsWords parameter specifies an exception for the DLP rule that looks for words or phrases in recipient email addresses. | |
| **ExceptIfAnyOfRecipientAddressMatchesPatterns** | Write | StringArray[] | The ExceptIfAnyOfRecipientAddressMatchesPatterns parameter specifies an exception for the DLP rule that looks for text patterns in recipient email addresses by using regular expressions. | |
| **ExceptIfContentCharacterSetContainsWords** | Write | StringArray[] | The ExceptIfContentCharacterSetContainsWords parameter specifies an exception for the rule that looks for character set names in messages. | |
| **ExceptIfContentPropertyContainsWords** | Write | StringArray[] | The ExceptIfContentPropertyContainsWords parameter specifies an exception for the DLP rule that's based on a property match in content. | |
| **ExceptIfDocumentNameMatchesPatterns** | Write | StringArray[] | The ExceptIfDocumentNameMatchesPatterns parameter specifies an exception for the DLP rule that looks for text patterns in the name of message attachments by using regular expressions. | |
| **ExceptIfDocumentNameMatchesWords** | Write | StringArray[] | The ExceptIfDocumentNameMatchesWords parameter specifies an exception for the DLP rule that looks for words or phrases in the name of message attachments. | |
| **ExceptIfFromAddressContainsWords** | Write | StringArray[] | The ExceptIfFromAddressContainsWords parameter specifies an exception for the DLP rule that looks for words or phrases in the sender's email address. | |
| **ExceptIfFromAddressMatchesPatterns** | Write | StringArray[] | The ExceptIfFromAddressMatchesPatterns parameter specifies an exception for the DLP rule that looks for text patterns in the sender's email address by using regular expressions. | |
| **FromAddressContainsWords** | Write | StringArray[] | The FromAddressContainsWords parameter specifies a condition for the DLP rule that looks for words or phrases in the sender's email address. | |
| **FromAddressMatchesPatterns** | Write | StringArray[] | The FromAddressMatchesPatterns parameter specifies a condition for the DLP rule that looks for text patterns in the sender's email address by using regular expressions.  | |
| **ExceptIfMessageTypeMatches** | Write | StringArray[] | The ExceptIfMessageTypeMatches parameter specifies an exception for the rule that looks for messages of the specified type. | |
| **RecipientDomainIs** | Write | StringArray[] | The RecipientDomainIs parameter specifies a condition for the DLP rule that looks for recipients with email addresses in the specified domains. | |
| **ExceptIfRecipientDomainIs** | Write | StringArray[] | The ExceptIfRecipientDomainIs parameter specifies an exception for the DLP rule that looks for recipients with email addresses in the specified domains. | |
| **ExceptIfSenderDomainIs** | Write | StringArray[] | The ExceptIfSenderDomainIs parameter specifies an exception for the DLP rule that looks for messages from senders with email address in the specified domains.  | |
| **ExceptIfSenderIPRanges** | Write | StringArray[] | The ExceptIfSenderIpRanges parameter specifies an exception for the DLP rule that looks for senders whose IP addresses matches the specified value, or fall within the specified ranges. | |
| **ExceptIfSentTo** | Write | StringArray[] | The ExceptIfSentTo parameter specifies an exception for the DLP rule that looks for recipients in messages. You identify the recipients by email address. | |
| **ExceptIfSubjectContainsWords** | Write | StringArray[] | The ExceptIfSubjectContainsWords parameter specifies an exception for the DLP rule that looks for words or phrases in the Subject field of messages. | |
| **ExceptIfSubjectMatchesPatterns** | Write | StringArray[] | The ExceptIfSubjectMatchesPatterns parameter specifies an exception for the DLP rule that looks for text patterns in the Subject field of messages by using regular expressions. | |
| **ExceptIfSubjectOrBodyContainsWords** | Write | StringArray[] | The ExceptIfSubjectOrBodyContainsWords parameter specifies an exception for the rule that looks for words in the Subject field or body of messages. | |
| **ExceptIfSubjectOrBodyMatchesPatterns** | Write | StringArray[] | The ExceptIfSubjectOrBodyMatchesPatterns parameter specifies an exception for the rule that looks for text patterns in the Subject field or body of messages. | |
| **DocumentContainsWords** | Write | StringArray[] | The DocumentContainsWords parameter specifies a condition for the DLP rule that looks for words in message attachments. Only supported attachment types are checked. | |
| **SentToMemberOf** | Write | StringArray[] | The SentToMemberOf parameter specifies a condition for the DLP rule that looks for messages sent to members of distribution groups, dynamic distribution groups, or mail-enabled security groups. | |
| **ContentIsNotLabeled** | Write | Boolean | The ContentIsNotLabeled parameter specifies if the content is labeled. A True or False condition. | |
| **SetHeader** | Write | StringArray[] | The SetHeader The SetHeader parameter specifies an action for the DLP rule that adds or modifies a header field and value in the message header. You can specify multiple header name and value pairs separated by commas | |
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
        $Credscredential
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
            Credential                          = $Credscredential
        }
    }
}
```

