# SCAutoSensitivityLabelRule

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | Name of the Rule. | |
| **Policy** | Required | String | Name of the associated Policy. | |
| **AccessScope** | Write | String | The AccessScope parameter specifies a condition for the auto-labeling policy rule that's based on the access scope of the content. The rule is applied to content that matches the specified access scope. Valid values are: InOrganization, NotInOrganization, None | `InOrganization`, `NotInOrganization`, `None` |
| **AnyOfRecipientAddressContainsWords** | Write | String | The AnyOfRecipientAddressContainsWords parameter specifies a condition for the auto-labeling policy rule that looks for words or phrases in recipient email addresses. You can specify multiple words or phrases separated by commas. | |
| **AnyOfRecipientAddressMatchesPatterns** | Write | String | The AnyOfRecipientAddressMatchesPatterns parameter specifies a condition for the auto-labeling policy rule that looks for text patterns in recipient email addresses by using regular expressions. | |
| **Comment** | Write | String | The Comment parameter specifies an optional comment. | |
| **ContentContainsSensitiveInformation** | Write | MSFT_SCDLPContainsSensitiveInformation | The ContentContainsSensitiveInformation parameter specifies a condition for the rule that's based on a sensitive information type match in content. The rule is applied to content that contains the specified sensitive information type. | |
| **ContentExtensionMatchesWords** | Write | String | The ContentExtensionMatchesWords parameter specifies a condition for the auto-labeling policy rule that looks for words in file name extensions. You can specify multiple words separated by commas. | |
| **Disabled** | Write | Boolean | The Disabled parameter specifies whether the auto-labeling policy rule is enabled or disabled. | |
| **DocumentIsPasswordProtected** | Write | Boolean | The DocumentIsPasswordProtected parameter specifies a condition for the auto-labeling policy rule that looks for password protected files (because the contents of the file can't be inspected). Password detection only works for Office documents and .zip files.  | |
| **DocumentIsUnsupported** | Write | Boolean | The DocumentIsUnsupported parameter specifies a condition for the auto-labeling policy rule that looks for files that can't be scanned. | |
| **ExceptIfAccessScope** | Write | String | The ExceptIfAccessScopeAccessScope parameter specifies an exception for the auto-labeling policy rule that's based on the access scope of the content. The rule isn't applied to content that matches the specified access scope. Valid values are: InOrganization, NotInOrganization, None | `InOrganization`, `NotInOrganization`, `None` |
| **ExceptIfAnyOfRecipientAddressContainsWords** | Write | String | The ExceptIfAnyOfRecipientAddressContainsWords parameter specifies an exception for the auto-labeling policy rule that looks for words or phrases in recipient email addresses. You can specify multiple words separated by commas. | |
| **ExceptIfAnyOfRecipientAddressMatchesPatterns** | Write | String | The ExceptIfAnyOfRecipientAddressMatchesPatterns parameter specifies an exception for the auto-labeling policy rule that looks for text patterns in recipient email addresses by using regular expressions.  | |
| **ExceptIfContentContainsSensitiveInformation** | Write | MSFT_SCDLPContainsSensitiveInformation | The ExceptIfContentContainsSensitiveInformation parameter specifies an exception for the auto-labeling policy rule that's based on a sensitive information type match in content. The rule isn't applied to content that contains the specified sensitive information type. | |
| **ExceptIfContentExtensionMatchesWords** | Write | StringArray[] | The ExceptIfContentExtensionMatchesWords parameter specifies an exception for the auto-labeling policy rule that looks for words in file name extensions. You can specify multiple words separated by commas. | |
| **ExceptIfDocumentIsPasswordProtected** | Write | Boolean | The ExceptIfDocumentIsPasswordProtected parameter specifies an exception for the auto-labeling policy rule that looks for password protected files (because the contents of the file can't be inspected). Password detection only works for Office documents and .zip files.  | |
| **ExceptIfDocumentIsUnsupported** | Write | Boolean | The ExceptIfDocumentIsUnsupported parameter specifies an exception for the auto-labeling policy rule that looks for files that can't be scanned. | |
| **ExceptIfFrom** | Write | StringArray[] | The ExceptIfFrom parameter specifies an exception for the auto-labeling policy rule that looks for messages from specific senders. You can use any value that uniquely identifies the sender. | |
| **ExceptIfFromAddressContainsWords** | Write | String | The ExceptIfFromAddressContainsWords parameter specifies an exception for the auto-labeling policy rule that looks for words or phrases in the sender's email address. You can specify multiple words or phrases separated by commas. | |
| **ExceptIfFromAddressMatchesPatterns** | Write | String | The ExceptIfFromAddressMatchesPatterns parameter specifies an exception for the auto-labeling policy rule that looks for text patterns in the sender's email address by using regular expressions.  | |
| **ExceptIfFromMemberOf** | Write | StringArray[] | The ExceptIfFromMemberOf parameter specifies an exception for the auto-labeling policy rule that looks for messages sent by group members. You identify the group members by their email addresses. You can enter multiple values separated by commas. | |
| **ExceptIfHeaderMatchesPatterns** | Write | StringArray[] | The HeaderMatchesPatterns parameter specifies an exception for the auto-labeling policy rule that looks for text patterns in a header field by using regular expressions. | |
| **ExceptIfProcessingLimitExceeded** | Write | Boolean | The ExceptIfProcessingLimitExceeded parameter specifies an exception for the auto-labeling policy rule that looks for files where scanning couldn't complete. | |
| **ExceptIfRecipientDomainIs** | Write | StringArray[] | The ExceptIfRecipientDomainIs parameter specifies an exception for the auto-labeling policy rule that looks for recipients with email address in the specified domains. You can specify multiple domains separated by commas. | |
| **ExceptIfSenderDomainIs** | Write | StringArray[] | The ExceptIfSenderDomainIs parameter specifies an exception for the auto-labeling policy rule that looks for messages from senders with email address in the specified domains. You can specify multiple values separated by commas. | |
| **ExceptIfSenderIPRanges** | Write | StringArray[] | The ExceptIfSenderIpRanges parameter specifies an exception for the auto-labeling policy rule that looks for senders whose IP addresses matches the specified value, or fall within the specified ranges. | |
| **ExceptIfSentTo** | Write | StringArray[] | The ExceptIfSentTo parameter specifies an exception for the auto-labeling policy rule that looks for recipients in messages. You can use any value that uniquely identifies the recipient.  | |
| **ExceptIfSentToMemberOf** | Write | StringArray[] | The ExceptIfSentToMemberOf parameter specifies an exception for the auto-labeling policy rule that looks for messages sent to members of distribution groups, dynamic distribution groups, or mail-enabled security groups. You identify the groups by email address. You can specify multiple values separated by commas. | |
| **ExceptIfSubjectMatchesPatterns** | Write | String | The ExceptIfSubjectMatchesPatterns parameter specifies an exception for the auto-labeling policy rule that looks for text patterns in the Subject field of messages by using regular expressions. | |
| **FromAddressContainsWords** | Write | String | The FromAddressContainsWords parameter specifies a condition for the auto-labeling policy rule that looks for words or phrases in the sender's email address. You can specify multiple words or phrases separated by commas. | |
| **FromAddressMatchesPatterns** | Write | String | The FromAddressMatchesPatterns parameter specifies a condition for the auto-labeling policy rule that looks for text patterns in the sender's email address by using regular expressions. | |
| **HeaderMatchesPatterns** | Write | MSFT_SCHeaderPattern | The HeaderMatchesPatterns parameter specifies a condition for the auto-labeling policy rule that looks for text patterns in a header field by using regular expressions. | |
| **ProcessingLimitExceeded** | Write | Boolean | The ProcessingLimitExceeded parameter specifies a condition for the auto-labeling policy rule that looks for files where scanning couldn't complete. You can use this condition to create rules that work together to identify and process messages where the content couldn't be fully scanned. | |
| **RecipientDomainIs** | Write | StringArray[] | The RecipientDomainIs parameter specifies a condition for the auto-labeling policy rule that looks for recipients with email address in the specified domains. You can specify multiple domains separated by commas. | |
| **ReportSeverityLevel** | Write | String | The ReportSeverityLevel parameter specifies the severity level of the incident report for content detections based on the rule. Valid values are: None, Low, Medium, High | `None`, `Low`, `Medium`, `High` |
| **RuleErrorAction** | Write | String | The RuleErrorAction parameter specifies what to do if an error is encountered during the evaluation of the rule. Valid values are: Ignore, RetryThenBlock, *blank* | `Ignore`, `RetryThenBlock`, `` |
| **SenderDomainIs** | Write | StringArray[] | The SenderDomainIs parameter specifies a condition for the auto-labeling policy rule that looks for messages from senders with email address in the specified domains.  | |
| **SenderIPRanges** | Write | StringArray[] | The SenderIpRanges parameter specifies a condition for the auto-sensitivity policy rule that looks for senders whose IP addresses matches the specified value, or fall within the specified ranges. | |
| **SentTo** | Write | StringArray[] | The SentTo parameter specifies a condition for the auto-sensitivity policy rule that looks for recipients in messages. You can use any value that uniquely identifies the recipient. | |
| **SentToMemberOf** | Write | StringArray[] | The SentToMemberOf parameter specifies a condition for the auto-labeling policy rule that looks for messages sent to members of distribution groups, dynamic distribution groups, or mail-enabled security groups. You identify the groups by email address. | |
| **SubjectMatchesPatterns** | Write | String | The SubjectMatchesPatterns parameter specifies a condition for the auto-labeling policy rule that looks for text patterns in the Subject field of messages by using regular expressions. | |
| **Workload** | Key | String | Workload the rule is associated with. Value can be: Exchange, SharePoint, OneDriveForBusiness | `Exchange`, `SharePoint`, `OneDriveForBusiness` |
| **Ensure** | Write | String | Specify if this rule should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_SCHeaderPattern

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Required | String | Name of the header pattern | |
| **Values** | Required | StringArray[] | Regular expressions for the pattern | |

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

This resource configures a Auto Sensitivity Label
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
        SCAutoSensitivityLabelRule 'TestRule'
        {
            Comment                             = 'Detects when 1 to 9 credit card numbers are contained in Exchange items'
            ContentContainsSensitiveInformation = MSFT_SCDLPContainsSensitiveInformation
            {
                operator = 'And'
                Groups   =
                @(MSFT_SCDLPContainsSensitiveInformationGroup
                    {
                        operator             = 'And'
                        name                 = 'Default'
                        SensitiveInformation = @(
                            MSFT_SCDLPSensitiveInformation
                            {
                                name           = 'Credit Card Number'
                                id             = '50842eb7-edc8-4019-85dd-5a5c1f2bb085'
                                maxconfidence  = '100'
                                minconfidence  = '85'
                                classifiertype = 'Content'
                                mincount       = '1'
                                maxcount       = '9'
                            }
                        )
                    }
                )
            }
            Credential                          = $Credscredential
            Disabled                            = $False
            DocumentIsPasswordProtected         = $False
            DocumentIsUnsupported               = $False
            Ensure                              = 'Present'
            ExceptIfDocumentIsPasswordProtected = $False
            ExceptIfDocumentIsUnsupported       = $False
            ExceptIfProcessingLimitExceeded     = $False
            Name                                = 'My Test Rule'
            Policy                              = 'My Test Policy'
            ProcessingLimitExceeded             = $False
            ReportSeverityLevel                 = 'Low'
            Workload                            = 'Exchange'
        }
    }
}
```

