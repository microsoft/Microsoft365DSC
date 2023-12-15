# EXOTransportRule

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the display name of the transport rule to be created. The maximum length is 64 characters. | |
| **ADComparisonAttribute** | Write | String | This parameter specifies a condition or part of a condition for the rule. The name of the corresponding exception parameter starts with ExceptIf. | |
| **ADComparisonOperator** | Write | String | This parameter specifies a condition or part of a condition for the rule. The name of the corresponding exception parameter starts with ExceptIf. | `Equal`, `NotEqual` |
| **ActivationDate** | Write | String | The ActivationDate parameter specifies when the rule starts processing messages. The rule won't take any action on messages until the specified date/time. | |
| **AddManagerAsRecipientType** | Write | String | The AddManagerAsRecipientType parameter specifies an action that delivers or redirects messages to the user that's defined in the sender's Manager attribute. | `To`, `Cc`, `Bcc`, `Redirect` |
| **AddToRecipients** | Write | StringArray[] | The AddToRecipients parameter specifies an action that adds recipients to the To field of messages. | |
| **AnyOfCcHeader** | Write | StringArray[] | The AnyOfCcHeader parameter specifies a condition that looks for recipients in the Cc field of messages. | |
| **AnyOfCcHeaderMemberOf** | Write | StringArray[] | The AnyOfCcHeaderMemberOf parameter specifies a condition that looks for group members in the Cc field of messages. | |
| **AnyOfRecipientAddressContainsWords** | Write | StringArray[] | The AnyOfRecipientAddressContainsWords parameter specifies a condition that looks for words in recipient email addresses. | |
| **AnyOfRecipientAddressMatchesPatterns** | Write | StringArray[] | The AnyOfRecipientAddressMatchesPatterns parameter specifies a condition that looks for text patterns in recipient email addresses by using regular expressions. | |
| **AnyOfToCcHeader** | Write | StringArray[] | The AnyOfToCcHeader parameter specifies a condition that looks for recipients in the To or Cc fields of messages. | |
| **AnyOfToCcHeaderMemberOf** | Write | StringArray[] | The AnyOfToCcHeaderMemberOf parameter specifies a condition that looks for group members in the To and Cc fields of messages. | |
| **AnyOfToHeader** | Write | StringArray[] | The AnyOfToHeader parameter specifies a condition that looks for recipients in the To field of messages. | |
| **AnyOfToHeaderMemberOf** | Write | StringArray[] | The AnyOfToHeaderMemberOf parameter specifies a condition that looks for group members in the To field of messages. | |
| **ApplyClassification** | Write | String | The ApplyClassification parameter specifies an action that applies a message classification to messages.  | |
| **ApplyHtmlDisclaimerFallbackAction** | Write | String | The ApplyHtmlDisclaimerFallbackAction parameter specifies what to do if the HTML disclaimer can't be added to a message. | `Wrap`, `Ignore`, `Reject` |
| **ApplyHtmlDisclaimerLocation** | Write | String | The ApplyHtmlDisclaimerLocation parameter specifies where to insert the HTML disclaimer text in the body of messages. | `Append`, `Prepend` |
| **ApplyHtmlDisclaimerText** | Write | String | The ApplyHtmlDisclaimerText parameter specifies an action that adds the disclaimer text to messages. | |
| **ApplyOME** | Write | Boolean | The ApplyOME parameter specifies an action that encrypts messages and their attachments by using Office 365 Message Encryption. | |
| **ApplyRightsProtectionCustomizationTemplate** | Write | String | The ApplyRightsProtectionCustomizationTemplate parameter specifies an action that applies a custom branding template for OME encrypted messages. | |
| **ApplyRightsProtectionTemplate** | Write | String | The ApplyRightsProtectionTemplate parameter specifies an action that applies rights management service (RMS) templates to messages.  | |
| **AttachmentContainsWords** | Write | StringArray[] | The AttachmentContainsWords parameter specifies a condition that looks for words in message attachments.  | |
| **AttachmentExtensionMatchesWords** | Write | StringArray[] | The AttachmentExtensionMatchesWords parameter specifies a condition that looks for words in the file name extensions of message attachments. | |
| **AttachmentHasExecutableContent** | Write | Boolean | The AttachmentHasExecutableContent parameter specifies a condition that looks for executable content in message attachments. | |
| **AttachmentIsPasswordProtected** | Write | Boolean | The AttachmentIsPasswordProtected parameter specifies a condition that looks for password protected files in messages (because the contents of the file can't be inspected). | |
| **AttachmentIsUnsupported** | Write | Boolean | The AttachmentIsUnsupported parameter specifies a condition that looks for unsupported file types in messages. | |
| **AttachmentMatchesPatterns** | Write | StringArray[] | The AttachmentMatchesPatterns parameter specifies a condition that looks for text patterns in the content of message attachments by using regular expressions. | |
| **AttachmentNameMatchesPatterns** | Write | StringArray[] | The AttachmentNameMatchesPatterns parameter specifies a condition that looks for text patterns in the file name of message attachments by using regular expressions. | |
| **AttachmentProcessingLimitExceeded** | Write | Boolean | The AttachmentProcessingLimitExceeded parameter specifies a condition that looks for messages where attachment scanning didn't complete. | |
| **AttachmentPropertyContainsWords** | Write | StringArray[] | The AttachmentPropertyContainsWords parameter specifies a condition that looks for words in the properties of attached Office documents. | |
| **AttachmentSizeOver** | Write | String | The AttachmentSizeOver parameter specifies a condition that looks for messages where any attachment is greater than the specified size. | |
| **BetweenMemberOf1** | Write | StringArray[] | The BetweenMemberOf1 parameter specifies a condition that looks for messages that are sent between group members. | |
| **BetweenMemberOf2** | Write | StringArray[] | The BetweenMemberOf2 parameter specifies a condition that looks for messages that are sent between group members. | |
| **BlindCopyTo** | Write | StringArray[] | The BlindCopyTo parameter specifies an action that adds recipients to the Bcc field of messages.  | |
| **Comments** | Write | String | The Comments parameter specifies optional descriptive text for the rule. The length of the comment can't exceed 1024 characters. | |
| **ContentCharacterSetContainsWords** | Write | StringArray[] | The ContentCharacterSetContainsWords parameter specifies a condition that looks for character set names in messages. | |
| **CopyTo** | Write | StringArray[] | The CopyTo parameter specifies an action that adds recipients to the Cc field of messages. | |
| **DeleteMessage** | Write | Boolean | The DeleteMessage parameter specifies an action that silently drops messages without an NDR. | |
| **DlpPolicy** | Write | String | The DlpPolicy parameter specifies the data loss prevention (DLP) policy that's associated with the rule. | |
| **Enabled** | Write | Boolean | The Enabled parameter specifies whether the new rule is created as enabled or disabled. | |
| **ExceptIfADComparisonAttribute** | Write | String | The ExceptIfADComparisonAttribute parameter specifies an exception that compares an Active Directory attribute between the sender and all recipients of the message. | |
| **ExceptIfADComparisonOperator** | Write | String | The ExceptIfADComparisonOperator parameter specifies the comparison operator for the ExceptIfADComparisonAttribute parameter. | `Equal`, `NotEqual` |
| **ExceptIfAnyOfCcHeader** | Write | StringArray[] | The ExceptIfAnyOfCcHeader parameter specifies an exception that looks for recipients in the Cc field of messages. | |
| **ExceptIfAnyOfCcHeaderMemberOf** | Write | StringArray[] | The ExceptIfAnyOfCcHeaderMemberOf parameter specifies an exception that looks for group members in the Cc field of messages. You can use any value that uniquely identifies the group. | |
| **ExceptIfAnyOfRecipientAddressContainsWords** | Write | StringArray[] | The ExceptIfAnyOfRecipientAddressContainsWords parameter specifies an exception that looks for words in recipient email addresses. | |
| **ExceptIfAnyOfRecipientAddressMatchesPatterns** | Write | StringArray[] | The ExceptIfAnyOfRecipientAddressMatchesPatterns parameter specifies an exception that looks for text patterns in recipient email addresses by using regular expressions. | |
| **ExceptIfAnyOfToCcHeader** | Write | StringArray[] | The ExceptIfAnyOfToCcHeader parameter specifies an exception that looks for recipients in the To or Cc fields of messages. | |
| **ExceptIfAnyOfToCcHeaderMemberOf** | Write | StringArray[] | The ExceptIfAnyOfToCcHeaderMemberOf parameter specifies an exception that looks for group members in the To and Cc fields of messages. | |
| **ExceptIfAnyOfToHeader** | Write | StringArray[] | The ExceptIfAnyOfToHeader parameter specifies an exception that looks for recipients in the To field of messages. | |
| **ExceptIfAnyOfToHeaderMemberOf** | Write | StringArray[] | The ExceptIfAnyOfToHeaderMemberOf parameter specifies an exception that looks for group members in the To field of messages. | |
| **ExceptIfAttachmentContainsWords** | Write | StringArray[] | The ExceptIfAttachmentContainsWords parameter specifies an exception that looks for words in message attachments. | |
| **ExceptIfAttachmentExtensionMatchesWords** | Write | StringArray[] | The ExceptIfAttachmentExtensionMatchesWords parameter specifies an exception that looks for words in the file name extensions of message attachments. | |
| **ExceptIfAttachmentHasExecutableContent** | Write | Boolean | The ExceptIfAttachmentHasExecutableContent parameter specifies an exception that looks for executable content in message attachments. | |
| **ExceptIfAttachmentIsPasswordProtected** | Write | Boolean | The ExceptIfAttachmentIsPasswordProtected parameter specifies an exception that looks for password protected files in messages (because the contents of the file can't be inspected). | |
| **ExceptIfAttachmentIsUnsupported** | Write | Boolean | The ExceptIfAttachmentIsUnsupported parameter specifies an exception that looks for unsupported file types in messages. | |
| **ExceptIfAttachmentMatchesPatterns** | Write | StringArray[] | The ExceptIfAttachmentMatchesPatterns parameter specifies an exception that looks for text patterns in the content of message attachments by using regular expressions. | |
| **ExceptIfAttachmentNameMatchesPatterns** | Write | StringArray[] | The ExceptIfAttachmentNameMatchesPatterns parameter specifies an exception that looks for text patterns in the file name of message attachments by using regular expressions. | |
| **ExceptIfAttachmentPropertyContainsWords** | Write | StringArray[] | The ExceptIfAttachmentPropertyContainsWords parameter specifies an exception that looks for words in the properties of attached Office documents.  | |
| **ExceptIfAttachmentProcessingLimitExceeded** | Write | Boolean | The ExceptIfAttachmentProcessingLimitExceeded parameter specifies an exception that looks for messages where attachment scanning didn't complete. | |
| **ExceptIfAttachmentSizeOver** | Write | String | The ExceptIfAttachmentSizeOver parameter specifies an exception that looks for messages where any attachment is greater than the specified size. | |
| **ExceptIfBetweenMemberOf1** | Write | StringArray[] | The ExceptIfBetweenMemberOf1 parameter specifies an exception that looks for messages that are sent between group members.  | |
| **ExceptIfBetweenMemberOf2** | Write | StringArray[] | The ExceptIfBetweenMemberOf2 parameter specifies an exception that looks for messages that are sent between group members. | |
| **ExceptIfContentCharacterSetContainsWords** | Write | StringArray[] | The ExceptIfContentCharacterSetContainsWords parameter specifies an exception that looks for character set names in messages. | |
| **ExceptIfFrom** | Write | StringArray[] | The ExceptIfFrom parameter specifies an exception that looks for messages from specific senders. | |
| **ExceptIfFromAddressContainsWords** | Write | StringArray[] | The ExceptIfFromAddressContainsWords parameter specifies an exception that looks for words in the sender's email address. | |
| **ExceptIfFromAddressMatchesPatterns** | Write | StringArray[] | The ExceptIfFromAddressMatchesPatterns parameter specifies an exception that looks for text patterns in the sender's email address by using regular expressions. | |
| **ExceptIfFromMemberOf** | Write | StringArray[] | The ExceptIfFromMemberOf parameter specifies an exception that looks for messages sent by group members. | |
| **ExceptIfFromScope** | Write | String | The ExceptIfFromScope parameter specifies an exception that looks for the location of message senders. | `InOrganization`, `NotInOrganization` |
| **ExceptIfHasClassification** | Write | String | The ExceptIfHasClassification parameter specifies an exception that looks for messages with the specified message classification. | |
| **ExceptIfHasNoClassification** | Write | Boolean | The ExceptIfHasNoClassification parameter specifies an exception that looks for messages with or without any message classifications. | |
| **ExceptIfHasSenderOverride** | Write | Boolean | The ExceptIfHasSenderOverride parameter specifies an exception that looks for messages where the sender chose to override a DLP policy. | |
| **ExceptIfHeaderContainsMessageHeader** | Write | String | The ExceptIfHeaderContainsMessageHeader parameter specifies the name of header field in the message header when searching for the words specified by the ExceptIfHeaderContainsWords parameter. | |
| **ExceptIfHeaderContainsWords** | Write | StringArray[] | The ExceptIfHeaderContainsWords parameter specifies an exception that looks for words in a header field. | |
| **ExceptIfHeaderMatchesMessageHeader** | Write | String | The ExceptIfHeaderMatchesMessageHeader parameter specifies the name of header field in the message header when searching for the text patterns specified by the ExceptIfHeaderMatchesPatterns parameter. | |
| **ExceptIfHeaderMatchesPatterns** | Write | StringArray[] | The ExceptIfHeaderMatchesPatterns parameter specifies an exception that looks for text patterns in a header field by using regular expressions. | |
| **ExceptIfManagerAddresses** | Write | StringArray[] | The ExceptIfManagerAddresses parameter specifies the users (managers) for the ExceptIfManagerForEvaluatedUser parameter. | |
| **ExceptIfManagerForEvaluatedUser** | Write | String | The ExceptIfManagerForEvaluatedUser parameter specifies an exception that looks for users in the Manager attribute of senders or recipients. | |
| **ExceptIfMessageTypeMatches** | Write | String | The ExceptIfMessageTypeMatches parameter specifies an exception that looks for messages of the specified type. | `OOF`, `AutoForward`, `Encrypted`, `Calendaring`, `PermissionControlled`, `Voicemail`, `Signed`, `ApprovalRequest`, `ReadReceipt` |
| **ExceptIfMessageContainsDataClassifications** | Write | StringArray[] | The ExceptIfMessageContainsDataClassifications parameter specifies an exception that looks for sensitive information types in the body of messages, and in any attachments. | |
| **ExceptIfMessageSizeOver** | Write | String | The ExceptIfMessageSizeOver parameter specifies an exception that looks for messages larger than the specified size.  | |
| **ExceptIfRecipientADAttributeContainsWords** | Write | StringArray[] | The ExceptIfRecipientADAttributeContainsWords parameter specifies an exception that looks for words in the Active Directory attributes of recipients. | |
| **ExceptIfRecipientADAttributeMatchesPatterns** | Write | StringArray[] | The ExceptIfRecipientADAttributeMatchesPatterns parameter specifies an exception that looks for text patterns in the Active Directory attributes of recipients by using regular expressions. | |
| **ExceptIfRecipientAddressContainsWords** | Write | StringArray[] | The ExceptIfRecipientAddressContainsWords parameter specifies an exception that looks for words in recipient email addresses. | |
| **ExceptIfRecipientAddressMatchesPatterns** | Write | StringArray[] | The ExceptIfRecipientAddressMatchesPatterns parameter specifies an exception that looks for text patterns in recipient email addresses by using regular expressions. | |
| **ExceptIfRecipientDomainIs** | Write | StringArray[] | The ExceptIfRecipientDomainIs parameter specifies an exception that looks for recipients with email address in the specified domains. | |
| **ExceptIfRecipientInSenderList** | Write | StringArray[] | This parameter is reserved for internal Microsoft use. | |
| **ExceptIfSCLOver** | Write | String | The ExceptIfSCLOver parameter specifies an exception that looks for the SCL value of messages | |
| **ExceptIfSenderADAttributeContainsWords** | Write | StringArray[] | The ExceptIfSenderADAttributeContainsWords parameter specifies an exception that looks for words in Active Directory attributes of message senders. | |
| **ExceptIfSenderADAttributeMatchesPatterns** | Write | StringArray[] | The ExceptIfSenderADAttributeMatchesPatterns parameter specifies an exception that looks for text patterns in Active Directory attributes of message senders by using regular expressions. | |
| **ExceptIfSenderDomainIs** | Write | StringArray[] | The ExceptIfSenderDomainIs parameter specifies an exception that looks for senders with email address in the specified domains. | |
| **ExceptIfSenderInRecipientList** | Write | StringArray[] | This parameter is reserved for internal Microsoft use. | |
| **ExceptIfSenderIpRanges** | Write | StringArray[] | The ExceptIfSenderIpRanges parameter specifies an exception that looks for senders whose IP addresses matches the specified value, or fall within the specified ranges. | |
| **ExceptIfSenderManagementRelationship** | Write | String | The ExceptIfSenderManagementRelationship parameter specifies an exception that looks for the relationship between the sender and recipients in messages. | `Manager`, `DirectReport` |
| **ExceptIfSentTo** | Write | StringArray[] | The ExceptIfSentTo parameter specifies an exception that looks for recipients in messages. You can use any value that uniquely identifies the recipient. | |
| **ExceptIfSentToMemberOf** | Write | StringArray[] | The ExceptIfSentToMemberOf parameter specifies an exception that looks for messages sent to members of groups. You can use any value that uniquely identifies the group. | |
| **ExceptIfSentToScope** | Write | String | The ExceptIfSentToScope parameter specifies an exception that looks for the location of a recipient.  | `InOrganization`, `NotInOrganization`, `ExternalPartner`, `ExternalNonPartner` |
| **ExceptIfSubjectContainsWords** | Write | StringArray[] | The ExceptIfSubjectContainsWords parameter specifies an exception that looks for words in the Subject field of messages. | |
| **ExceptIfSubjectMatchesPatterns** | Write | StringArray[] | The ExceptIfSubjectMatchesPatterns parameter specifies an exception that looks for text patterns in the Subject field of messages by using regular expressions. | |
| **ExceptIfSubjectOrBodyContainsWords** | Write | StringArray[] | The ExceptIfSubjectOrBodyContainsWords parameter specifies an exception that looks for words in the Subject field or body of messages. | |
| **ExceptIfSubjectOrBodyMatchesPatterns** | Write | StringArray[] | The ExceptIfSubjectOrBodyMatchesPatterns parameter specifies an exception that looks for text patterns in the Subject field or body of messages. | |
| **ExceptIfWithImportance** | Write | String | The ExceptIfWithImportance parameter specifies an exception that looks for messages with the specified importance level. | `Low`, `Normal`, `High` |
| **ExpiryDate** | Write | String | The ExpiryDate parameter specifies when this rule will stop processing messages. The rule won't take any action on messages after the specified date/time. | |
| **From** | Write | StringArray[] | The From parameter specifies a condition that looks for messages from specific senders. You can use any value that uniquely identifies the sender. | |
| **FromAddressContainsWords** | Write | StringArray[] | The FromAddressContainsWords parameter specifies a condition that looks for words in the sender's email address.  | |
| **FromAddressMatchesPatterns** | Write | StringArray[] | The FromAddressMatchesPatterns parameter specifies a condition that looks for text patterns in the sender's email address by using regular expressions. | |
| **FromMemberOf** | Write | StringArray[] | The FromMemberOf parameter specifies a condition that looks for messages sent by group members. | |
| **FromScope** | Write | String | The FromScope parameter specifies a condition that looks for the location of message senders. | `InOrganization`, `NotInOrganization` |
| **GenerateIncidentReport** | Write | String | The GenerateIncidentReport parameter specifies where to send the incident report that's defined by the IncidentReportContent parameter. | |
| **GenerateNotification** | Write | String | The GenerateNotification parameter specifies an action that sends a notification message to recipients. | |
| **HasClassification** | Write | String | The HasClassification parameter specifies a condition that looks for messages with the specified message classification. | |
| **HasNoClassification** | Write | Boolean | The HasNoClassification parameter specifies a condition that looks for messages with or without any message classifications. | |
| **HasSenderOverride** | Write | Boolean | The HasSenderOverride parameter specifies a condition that looks for messages where the sender chose to override a DLP policy. | |
| **HeaderContainsMessageHeader** | Write | String | The HeaderContainsMessageHeader parameter specifies the name of header field in the message header when searching for the words specified by the HeaderContainsWords parameter. | |
| **HeaderContainsWords** | Write | StringArray[] | The HeaderContainsWords parameter specifies a condition that looks for words in a header field. | |
| **HeaderMatchesMessageHeader** | Write | String | The HeaderMatchesMessageHeader parameter specifies the name of header field in the message header when searching for the text patterns specified by the HeaderMatchesPatterns parameter. | |
| **HeaderMatchesPatterns** | Write | StringArray[] | The HeaderMatchesPatterns parameter specifies a condition that looks for text patterns in a header field by using regular expressions.  | |
| **IncidentReportContent** | Write | StringArray[] | The IncidentReportContent parameter specifies the message properties that are included in the incident report that's generated when a message violates a DLP policy.  | |
| **ManagerAddresses** | Write | StringArray[] | The ManagerAddresses parameter specifies the users (managers) for the ExceptIfManagerForEvaluatedUser parameter. | |
| **ManagerForEvaluatedUser** | Write | String | The ManagerForEvaluatedUser parameter specifies a condition that looks for users in the Manager attribute of senders or recipients. | `Recipient`, `Sender` |
| **MessageContainsDataClassifications** | Write | StringArray[] | The MessageContainsDataClassifications parameter specifies a condition that looks for sensitive information types in the body of messages, and in any attachments. | |
| **MessageSizeOver** | Write | String | The MessageSizeOver parameter specifies a condition that looks for messages larger than the specified size. The size includes the message and all attachments. | |
| **MessageTypeMatches** | Write | String | The MessageTypeMatches parameter specifies a condition that looks for messages of the specified type. | `OOF`, `AutoForward`, `Encrypted`, `Calendaring`, `PermissionControlled`, `Voicemail`, `Signed`, `ApprovalRequest`, `ReadReceipt` |
| **Mode** | Write | String | The Mode parameter specifies how the rule operates. | `Audit`, `AuditAndNotify`, `Enforce` |
| **ModerateMessageByManager** | Write | Boolean | The ModerateMessageByManager parameter specifies an action that forwards messages for approval to the user that's specified in the sender's Manager attribute. | |
| **ModerateMessageByUser** | Write | StringArray[] | The ModerateMessageByUser parameter specifies an action that forwards messages for approval to the specified users. | |
| **NotifySender** | Write | String | The NotifySender parameter specifies an action that notifies the sender when messages violate DLP policies. | `NotifyOnly`, `RejectMessage`, `RejectUnlessFalsePositiveOverride`, `RejectUnlessSilentOverride`, `RejectUnlessExplicitOverride` |
| **PrependSubject** | Write | String | The PrependSubject parameter specifies an action that adds text to add to the beginning of the Subject field of messages. | |
| **Priority** | Write | String | The Priority parameter specifies a priority value for the rule that determines the order of rule processing. | |
| **Quarantine** | Write | Boolean | The Quarantine parameter specifies an action that quarantines messages. | |
| **RecipientADAttributeContainsWords** | Write | StringArray[] | The RecipientADAttributeContainsWords parameter specifies a condition that looks for words in the Active Directory attributes of recipients.  | |
| **RecipientADAttributeMatchesPatterns** | Write | StringArray[] | The RecipientADAttributeMatchesPatterns parameter specifies a condition that looks for text patterns in the Active Directory attributes of recipients by using regular expressions. | |
| **RecipientAddressContainsWords** | Write | StringArray[] | The RecipientAddressContainsWords parameter specifies a condition that looks for words in recipient email addresses. | |
| **RecipientAddressMatchesPatterns** | Write | StringArray[] | The RecipientAddressMatchesPatterns parameter specifies a condition that looks for text patterns in recipient email addresses by using regular expressions. | |
| **RecipientAddressType** | Write | String | The RecipientAddressType parameter specifies how conditions and exceptions check recipient email addresses. | `Original`, `Resolved` |
| **RecipientDomainIs** | Write | StringArray[] | The RecipientDomainIs parameter specifies a condition that looks for recipients with email address in the specified domains. | |
| **RecipientInSenderList** | Write | StringArray[] | This parameter is reserved for internal Microsoft use. | |
| **RedirectMessageTo** | Write | StringArray[] | The RedirectMessageTo parameter specifies a rule action that redirects messages to the specified recipients. | |
| **RejectMessageEnhancedStatusCode** | Write | String | The RejectMessageEnhancedStatusCode parameter specifies the enhanced status code that's used when the rule rejects messages. | |
| **RejectMessageReasonText** | Write | String | The RejectMessageReasonText parameter specifies the explanation text that's used when the rule rejects messages. | |
| **RemoveHeader** | Write | String | The RemoveHeader parameter specifies an action that removes a header field from the message header. | |
| **RemoveOME** | Write | Boolean | The RemoveOME parameter specifies an action that removes the previous version of Office 365 Message Encryption from messages and their attachments. | |
| **RemoveOMEv2** | Write | Boolean | The RemoveOMEv2 parameter specifies an action that removes Office 365 Message Encryption from messages and their attachments. | |
| **RemoveRMSAttachmentEncryption** | Write | Boolean | This parameter specifies an action or part of an action for the rule. | |
| **RouteMessageOutboundConnector** | Write | String | The RouteMessageOutboundConnector parameter specifies an action that routes messages through the specified Outbound connector in Office 365. | |
| **RouteMessageOutboundRequireTls** | Write | Boolean | The RouteMessageOutboundRequireTls parameter specifies an action that uses Transport Layer Security (TLS) encryption to deliver messages outside your organization. | |
| **RuleErrorAction** | Write | String | The RuleErrorAction parameter specifies what to do if rule processing can't be completed on messages. | `Ignore`, `Defer` |
| **RuleSubType** | Write | String | The RuleSubType parameter specifies the rule type. | `Dlp`, `None` |
| **SCLOver** | Write | String | The SCLOver parameter specifies a condition that looks for the SCL value of messages | |
| **SenderADAttributeContainsWords** | Write | StringArray[] | The SenderADAttributeContainsWords parameter specifies a condition that looks for words in Active Directory attributes of message senders. | |
| **SenderADAttributeMatchesPatterns** | Write | StringArray[] | The SenderADAttributeMatchesPatterns parameter specifies a condition that looks for text patterns in Active Directory attributes of message senders by using regular expressions. | |
| **SenderAddressLocation** | Write | String | The SenderAddressLocation parameter specifies where to look for sender addresses in conditions and exceptions that examine sender email addresses. | `Header`, `Envelope`, `HeaderOrEnvelope` |
| **SenderDomainIs** | Write | StringArray[] | The SenderDomainIs parameter specifies a condition that looks for senders with email address in the specified domains. | |
| **SenderInRecipientList** | Write | String | This parameter is reserved for internal Microsoft use. | |
| **SenderIpRanges** | Write | StringArray[] | The SenderIpRanges parameter specifies a condition that looks for senders whose IP addresses matches the specified value, or fall within the specified ranges. | |
| **SenderManagementRelationship** | Write | String | The SenderManagementRelationship parameter specifies a condition that looks for the relationship between the sender and recipients in messages. | `Manager`, `DirectReport` |
| **SentTo** | Write | StringArray[] | The SentTo parameter specifies a condition that looks for recipients in messages. | |
| **SentToMemberOf** | Write | StringArray[] | The SentToMemberOf parameter specifies a condition that looks for messages sent to members of distribution groups, dynamic distribution groups, or mail-enabled security groups. | |
| **SentToScope** | Write | String | The SentToScope parameter specifies a condition that looks for the location of recipients. | `InOrganization`, `NotInOrganization`, `ExternalPartner`, `ExternalNonPartner` |
| **SetAuditSeverity** | Write | String | The SetAuditSeverity parameter specifies an action that sets the severity level of the incident report and the corresponding entry that's written to the message tracking log when messages violate DLP policies. | `DoNotAudit`, `Low`, `Medium`, `High` |
| **SetHeaderName** | Write | String | The SetHeaderName parameter specifies an action that adds or modifies a header field in the message header. | |
| **SetHeaderValue** | Write | String | The SetHeaderValue parameter specifies an action that adds or modifies a header field in the message header. | |
| **SetSCL** | Write | String | The SetSCL parameter specifies an action that adds or modifies the SCL value of messages. | |
| **StopRuleProcessing** | Write | Boolean | The StopRuleProcessing parameter specifies an action that stops processing more rules. | |
| **SubjectContainsWords** | Write | StringArray[] | The SubjectContainsWords parameter specifies a condition that looks for words in the Subject field of messages. | |
| **SubjectMatchesPatterns** | Write | StringArray[] | The SubjectMatchesPatterns parameter specifies a condition that looks for text patterns in the Subject field of messages by using regular expressions. | |
| **SubjectOrBodyContainsWords** | Write | StringArray[] | The SubjectOrBodyContainsWords parameter specifies a condition that looks for words in the Subject field or body of messages. | |
| **SubjectOrBodyMatchesPatterns** | Write | StringArray[] | The SubjectOrBodyMatchesPatterns parameter specifies a condition that looks for text patterns in the Subject field or body of messages. | |
| **WithImportance** | Write | String | The WithImportance parameter specifies a condition that looks for messages with the specified importance level. | `Low`, `Normal`, `High` |
| **Ensure** | Write | String | Specify if the Transport Rule should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures Transport Rules in Exchange Online.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Security Admin, Data Loss Prevention, Transport Rules, View-Only Configuration, Security Reader, Information Rights Management

#### Role Groups

- Organization Management

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
        EXOTransportRule 'ConfigureTransportRule'
        {
            Name                                          = "Ethical Wall - Sales and Brokerage Departments"
            BetweenMemberOf1                              = "Sales Department"
            BetweenMemberOf2                              = "Brokerage Department"
            ExceptIfFrom                                  = "Tony Smith","Pilar Ackerman"
            ExceptIfSubjectContainsWords                  = "Press Release","Corporate Communication"
            RejectMessageReasonText                       = "Messages sent between the Sales and Brokerage departments are strictly prohibited."
            Enabled                                       = $True
            Ensure                                        = "Present"
            Credential                                    = $Credscredential
        }
    }
}
```

