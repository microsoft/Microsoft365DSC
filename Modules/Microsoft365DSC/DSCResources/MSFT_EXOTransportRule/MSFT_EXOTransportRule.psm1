function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $ADComparisonAttribute,

        [Parameter()]
        [ValidateSet('Equal', 'NotEqual')]
        [System.String]
        $ADComparisonOperator,

        [Parameter()]
        [System.String]
        $ActivationDate,

        [Parameter()]
        [ValidateSet('To', 'Cc', 'Bcc', 'Redirect')]
        [System.String]
        $AddManagerAsRecipientType,

        [Parameter()]
        [System.String[]]
        $AddToRecipients = @(),

        [Parameter()]
        [System.String[]]
        $AnyOfCcHeader = @(),

        [Parameter()]
        [System.String[]]
        $AnyOfCcHeaderMemberOf = @(),

        [Parameter()]
        [System.String[]]
        $AnyOfRecipientAddressContainsWords,

        [Parameter()]
        [System.String[]]
        $AnyOfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $AnyOfToCcHeader = @(),

        [Parameter()]
        [System.String[]]
        $AnyOfToCcHeaderMemberOf = @(),

        [Parameter()]
        [System.String[]]
        $AnyOfToHeader = @(),

        [Parameter()]
        [System.String[]]
        $AnyOfToHeaderMemberOf = @(),

        [Parameter()]
        [System.String]
        $ApplyClassification,

        [Parameter()]
        [ValidateSet('Wrap', 'Ignore', 'Reject')]
        [System.String]
        $ApplyHtmlDisclaimerFallbackAction,

        [Parameter()]
        [ValidateSet('Append', 'Prepand')]
        [System.String]
        $ApplyHtmlDisclaimerLocation,

        [Parameter()]
        [System.String]
        $ApplyHtmlDisclaimerText,

        [Parameter()]
        [System.Boolean]
        $ApplyOME,

        [Parameter()]
        [System.String]
        $ApplyRightsProtectionTemplate,

        [Parameter()]
        [System.String[]]
        $AttachmentContainsWords,

        [Parameter()]
        [System.String[]]
        $AttachmentExtensionMatchesWords,

        [Parameter()]
        [System.Boolean]
        $AttachmentHasExecutableContent,

        [Parameter()]
        [System.Boolean]
        $AttachmentIsPasswordProtected,

        [Parameter()]
        [System.Boolean]
        $AttachmentIsUnsupported,

        [Parameter()]
        [System.String[]]
        $AttachmentMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $AttachmentNameMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $AttachmentPropertyContainsWords,

        [Parameter()]
        [System.Boolean]
        $AttachmentProcessingLimitExceeded,

        [Parameter()]
        [System.String]
        $AttachmentSizeOver,

        [Parameter()]
        [System.String[]]
        $BetweenMemberOf1 = @(),

        [Parameter()]
        [System.String[]]
        $BetweenMemberOf2 = @(),

        [Parameter()]
        [System.String[]]
        $BlindCopyTo = @(),

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $Comments,

        [Parameter()]
        [System.String[]]
        $ContentCharacterSetContainsWords,

        [Parameter()]
        [System.String[]]
        $CopyTo = @(),

        [Parameter()]
        [System.Boolean]
        $DeleteMessage,

        [Parameter()]
        [System.String]
        $DlpPolicy,

        [Parameter()]
        [System.String]
        $ExceptIfADComparisonAttribute,

        [Parameter()]
        [ValidateSet('Equal', 'NotEqual')]
        [System.String]
        $ExceptIfADComparisonOperator,

        [Parameter()]
        [System.String[]]
        $ExceptIfAnyOfCcHeader = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfAnyOfCcHeaderMemberOf = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfAnyOfRecipientAddressContainsWords,

        [Parameter()]
        [System.String[]]
        $ExceptIfAnyOfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ExceptIfAnyOfToCcHeader = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfAnyOfToCcHeaderMemberOf = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfAnyOfToHeader = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfAnyOfToHeaderMemberOf = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfAttachmentContainsWords,

        [Parameter()]
        [System.String[]]
        $ExceptIfAttachmentExtensionMatchesWords,

        [Parameter()]
        [System.Boolean]
        $ExceptIfAttachmentHasExecutableContent,

        [Parameter()]
        [System.Boolean]
        $ExceptIfAttachmentIsPasswordProtected,

        [Parameter()]
        [System.Boolean]
        $ExceptIfAttachmentIsUnsupported,

        [Parameter()]
        [System.String[]]
        $ExceptIfAttachmentMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ExceptIfAttachmentNameMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ExceptIfAttachmentPropertyContainsWords,

        [Parameter()]
        [System.Boolean]
        $ExceptIfAttachmentProcessingLimitExceeded,

        [Parameter()]
        [System.String]
        $ExceptIfAttachmentSizeOver,

        [Parameter()]
        [System.String[]]
        $ExceptIfBetweenMemberOf1 = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfBetweenMemberOf2 = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfContentCharacterSetContainsWords = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfFrom = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfFromAddressContainsWords,

        [Parameter()]
        [System.String[]]
        $ExceptIfFromAddressMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ExceptIfFromMemberOf = @(),

        [Parameter()]
        [ValidateSet('InOrganization', 'NotInOrganization')]
        [System.String]
        $ExceptIfFromScope,

        [Parameter()]
        [System.String]
        $ExceptIfHasClassification,

        [Parameter()]
        [System.Boolean]
        $ExceptIfHasNoClassification,

        [Parameter()]
        [System.Boolean]
        $ExceptIfHasSenderOverride,

        [Parameter()]
        [System.String]
        $ExceptIfHeaderContainsMessageHeader,

        [Parameter()]
        [System.String[]]
        $ExceptIfHeaderContainsWords,

        [Parameter()]
        [System.String]
        $ExceptIfHeaderMatchesMessageHeader,

        [Parameter()]
        [System.String[]]
        $ExceptIfHeaderMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ExceptIfManagerAddresses = @(),

        [Parameter()]
        [System.String]
        $ExceptIfManagerForEvaluatedUser,

        [Parameter()]
        [ValidateSet('OOF', 'AutoForward', 'Encrypted', 'Calendaring', 'PermissionControlled', 'Voicemail', 'Signed', 'ApprovalRequest', 'ReadReceipt')]
        [System.String]
        $ExceptIfMessageTypeMatches,

        [Parameter()]
        [System.String[]]
        $ExceptIfMessageContainsAllDataClassifications = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfMessageContainsDataClassifications = @(),

        [Parameter()]
        [System.String]
        $ExceptIfMessageSizeOver,

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientADAttributeContainsWords,

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientADAttributeMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientAddressContainsWords,

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientInSenderList,

        [Parameter()]
        [System.String[]]
        $ExceptIfSenderADAttributeContainsWords,

        [Parameter()]
        [System.String[]]
        $ExceptIfSenderADAttributeMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ExceptIfSenderDomainIs,

        [Parameter()]
        [System.String[]]
        $ExceptIfSenderInRecipientList,

        [Parameter()]
        [System.String[]]
        $ExceptIfSenderIpRanges,

        [Parameter()]
        [ValidateSet('Manager', 'DirectReport')]
        [System.String]
        $ExceptIfSenderManagementRelationship,

        [Parameter()]
        [System.String[]]
        $ExceptIfSentTo = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentToMemberOf = @(),

        [Parameter()]
        [ValidateSet('InOrganization', 'NotInOrganization', 'ExternalPartner', 'ExternalNonPartner')]
        [System.String]
        $ExceptIfSentToScope,

        [Parameter()]
        [System.String[]]
        $ExceptIfSubjectContainsWords,

        [Parameter()]
        [System.String[]]
        $ExceptIfSubjectMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ExceptIfSubjectOrBodyContainsWords,

        [Parameter()]
        [System.String[]]
        $ExceptIfSubjectOrBodyMatchesPatterns,

        [Parameter()]
        [ValidateSet('Low', 'Normal', 'High')]
        [System.String]
        $ExceptIfWithImportance,

        [Parameter()]
        [System.String]
        $ExpiryDate,

        [Parameter()]
        [System.String[]]
        $From = @(),

        [Parameter()]
        [System.String[]]
        $FromAddressContainsWords,

        [Parameter()]
        [System.String[]]
        $FromAddressMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $FromMemberOf = @(),

        [Parameter()]
        [ValidateSet('InOrganization', 'NotInOrganization')]
        [System.String]
        $FromScope,

        [Parameter()]
        [System.String]
        $GenerateIncidentReport,

        [Parameter()]
        [System.String]
        $GenerateNotification,

        [Parameter()]
        [System.String]
        $HasClassification,

        [Parameter()]
        [System.Boolean]
        $HasNoClassification,

        [Parameter()]
        [System.Boolean]
        $HasSenderOverride,

        [Parameter()]
        [System.String]
        $HeaderContainsMessageHeader,

        [Parameter()]
        [System.String[]]
        $HeaderContainsWords,

        [Parameter()]
        [System.String]
        $HeaderMatchesMessageHeader,

        [Parameter()]
        [System.String[]]
        $HeaderMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $IncidentReportContent,

        [Parameter()]
        [System.String[]]
        $IncidentReportOriginalMail,

        [Parameter()]
        [System.String[]]
        $ManagerAddresses = @(),

        [Parameter()]
        [ValidateSet('Recipient', 'Sender')]
        [System.String]
        $ManagerForEvaluatedUser,

        [Parameter()]
        [System.String[]]
        $MessageContainsAllDataClassifications,

        [Parameter()]
        [System.String[]]
        $MessageContainsDataClassifications,

        [Parameter()]
        [System.String]
        $MessageSizeOver,

        [Parameter()]
        [ValidateSet('OOF', 'AutoForward', 'Encrypted', 'Calendaring', 'PermissionControlled', 'Voicemail', 'Signed', 'ApprovalRequest', 'ReadReceipt')]
        [System.String]
        $MessageTypeMatches,

        [Parameter()]
        [ValidateSet('Audit', 'AuditAndNotify', 'Enforce')]
        [System.String]
        $Mode,

        [Parameter()]
        [System.Boolean]
        $ModerateMessageByManager,

        [Parameter()]
        [System.String[]]
        $ModerateMessageByUser = @(),

        [Parameter()]
        [ValidateSet('NotifyOnly', 'RejectMessage', 'RejectUnlessFalsePositiveOverride', 'RejectUnlessSilentOverride', 'RejectUnlessExplicitOverride')]
        [System.String]
        $NotifySender,

        [Parameter()]
        [System.String]
        $PrependSubject,

        [Parameter()]
        [System.String]
        $Priority,

        [Parameter()]
        [System.String[]]
        $RecipientADAttributeContainsWords,

        [Parameter()]
        [System.String[]]
        $RecipientADAttributeMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $RecipientAddressContainsWords,

        [Parameter()]
        [System.String[]]
        $RecipientAddressMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $RecipientDomainIs,

        [Parameter()]
        [System.String[]]
        $RecipientInSenderList,

        [Parameter()]
        [System.String[]]
        $RedirectMessageTo = @(),

        [Parameter()]
        [System.String]
        $RejectMessageEnhancedStatusCode,

        [Parameter()]
        [System.String]
        $RejectMessageReasonText,

        [Parameter()]
        [System.String]
        $RemoveHeader,

        [Parameter()]
        [System.Boolean]
        $RemoveOME,

        [Parameter()]
        [System.Boolean]
        $RemoveOMEv2,

        [Parameter()]
        [System.String]
        $RouteMessageOutboundConnector,

        [Parameter()]
        [System.Boolean]
        $RouteMessageOutboundRequireTls,

        [Parameter()]
        [ValidateSet('Ignore', 'Defer')]
        [System.String]
        $RuleErrorAction,

        [Parameter()]
        [ValidateSet('Dlp', 'None')]
        [System.String]
        $RuleSubType,

        [Parameter()]
        [System.String[]]
        $SenderADAttributeContainsWords,

        [Parameter()]
        [System.String[]]
        $SenderADAttributeMatchesPatterns,

        [Parameter()]
        [ValidateSet('Header', 'Envelope', 'HeaderOrEnvelope')]
        [System.String]
        $SenderAddressLocation,

        [Parameter()]
        [System.String[]]
        $SenderDomainIs,

        [Parameter()]
        [System.String[]]
        $SenderInRecipientList,

        [Parameter()]
        [System.String[]]
        $SenderIpRanges,

        [Parameter()]
        [ValidateSet('Manager', 'DirectReport')]
        [System.String]
        $SenderManagementRelationship,

        [Parameter()]
        [System.String[]]
        $SentTo = @(),

        [Parameter()]
        [System.String[]]
        $SentToMemberOf = @(),

        [Parameter()]
        [ValidateSet('InOrganization', 'NotInOrganization', 'ExternalPartner', 'ExternalNonPartner')]
        [System.String]
        $SentToScope,

        [Parameter()]
        [ValidateSet('DoNotAudit', 'Low', 'Medium', 'High')]
        [System.String]
        $SetAuditSeverity,

        [Parameter()]
        [System.String]
        $SetHeaderName,

        [Parameter()]
        [System.String]
        $SetHeaderValue,

        [Parameter()]
        [System.String]
        $SetSCL,

        [Parameter()]
        [System.Boolean]
        $StopRuleProcessing,

        [Parameter()]
        [System.String[]]
        $SubjectContainsWords,

        [Parameter()]
        [System.String[]]
        $SubjectMatchesPatterns,

        [Parameter()]
        [System.String]
        $SubjectOrBodyContainsWords,

        [Parameter()]
        [System.String[]]
        $SubjectOrBodyMatchesPatterns,

        [Parameter()]
        [ValidateSet('Low', 'Normal', 'High')]
        [System.String]
        $WithImportance,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting Transport Rule configuration for $Name"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $AllTransportRules = Get-TransportRule

    $TransportRule = $AllTransportRules | Where-Object -FilterScript { $_.Name -eq $Name }

    if ($null -eq $TransportRule)
    {
        Write-Verbose -Message "Transport Rule $($Name) does not exist."

        $nullReturn = @{
            Name                                          = $Name
            ADComparisonAttribute                         = $ADComparisonAttribute
            ADComparisonOperator                          = $ADComparisonOperator
            ActivationDate                                = $ActivationDate
            AddManagerAsRecipientType                     = $AddManagerAsRecipientType
            AddToRecipients                               = $AddToRecipients
            AnyOfCcHeader                                 = $AnyOfCcHeader
            AnyOfCcHeaderMemberOf                         = $AnyOfCcHeaderMemberOf
            AnyOfRecipientAddressContainsWords            = $AnyOfRecipientAddressContainsWords
            AnyOfRecipientAddressMatchesPatterns          = $AnyOfRecipientAddressMatchesPatterns
            AnyOfToCcHeader                               = $AnyOfToCcHeader
            AnyOfToCcHeaderMemberOf                       = $AnyOfToCcHeaderMemberOf
            AnyOfToHeader                                 = $AnyOfToHeader
            AnyOfToHeaderMemberOf                         = $AnyOfToHeaderMemberOf
            ApplyClassification                           = $ApplyClassification
            ApplyHtmlDisclaimerFallbackAction             = $ApplyHtmlDisclaimerFallbackAction
            ApplyHtmlDisclaimerLocation                   = $ApplyHtmlDisclaimerLocation
            ApplyHtmlDisclaimerText                       = $ApplyHtmlDisclaimerText
            ApplyOME                                      = $ApplyOME
            ApplyRightsProtectionTemplate                 = $ApplyRightsProtectionTemplate
            AttachmentContainsWords                       = $AttachmentContainsWords
            AttachmentExtensionMatchesWords               = $AttachmentExtensionMatchesWords
            AttachmentHasExecutableContent                = $AttachmentHasExecutableContent
            AttachmentIsPasswordProtected                 = $AttachmentIsPasswordProtected
            AttachmentIsUnsupported                       = $AttachmentIsUnsupported
            AttachmentMatchesPatterns                     = $AttachmentMatchesPatterns
            AttachmentNameMatchesPatterns                 = $AttachmentNameMatchesPatterns
            AttachmentPropertyContainsWords               = $AttachmentPropertyContainsWords
            AttachmentProcessingLimitExceeded             = $AttachmentProcessingLimitExceeded
            AttachmentSizeOver                            = $AttachmentSizeOver
            BetweenMemberOf1                              = $BetweenMemberOf1
            BetweenMemberOf2                              = $BetweenMemberOf2
            BlindCopyTo                                   = $BlindCopyTo
            Comments                                      = $Comments
            ContentCharacterSetContainsWords              = $ContentCharacterSetContainsWords
            CopyTo                                        = $CopyTo
            DeleteMessage                                 = $DeleteMessage
            DlpPolicy                                     = $DlpPolicy
            ExceptIfADComparisonAttribute                 = $ExceptIfADComparisonAttribute
            ExceptIfADComparisonOperator                  = $ExceptIfADComparisonOperator
            ExceptIfAnyOfCcHeader                         = $ExceptIfAnyOfCcHeader
            ExceptIfAnyOfCcHeaderMemberOf                 = $ExceptIfAnyOfCcHeaderMemberOf
            ExceptIfAnyOfRecipientAddressContainsWords    = $ExceptIfAnyOfRecipientAddressContainsWords
            ExceptIfAnyOfRecipientAddressMatchesPatterns  = $ExceptIfAnyOfRecipientAddressMatchesPatterns
            ExceptIfAnyOfToCcHeader                       = $ExceptIfAnyOfToCcHeader
            ExceptIfAnyOfToCcHeaderMemberOf               = $ExceptIfAnyOfToCcHeaderMemberOf
            ExceptIfAnyOfToHeader                         = $ExceptIfAnyOfToHeader
            ExceptIfAnyOfToHeaderMemberOf                 = $ExceptIfAnyOfToHeaderMemberOf
            ExceptIfAttachmentContainsWords               = $ExceptIfAttachmentContainsWords
            ExceptIfAttachmentExtensionMatchesWords       = $ExceptIfAttachmentExtensionMatchesWords
            ExceptIfAttachmentHasExecutableContent        = $ExceptIfAttachmentHasExecutableContent
            ExceptIfAttachmentIsPasswordProtected         = $ExceptIfAttachmentIsPasswordProtected
            ExceptIfAttachmentIsUnsupported               = $ExceptIfAttachmentIsUnsupported
            ExceptIfAttachmentMatchesPatterns             = $ExceptIfAttachmentMatchesPatterns
            ExceptIfAttachmentNameMatchesPatterns         = $ExceptIfAttachmentNameMatchesPatterns
            ExceptIfAttachmentPropertyContainsWords       = $ExceptIfAttachmentPropertyContainsWords
            ExceptIfAttachmentProcessingLimitExceeded     = $ExceptIfAttachmentProcessingLimitExceeded
            ExceptIfAttachmentSizeOver                    = $ExceptIfAttachmentSizeOver
            ExceptIfBetweenMemberOf1                      = $ExceptIfBetweenMemberOf1
            ExceptIfBetweenMemberOf2                      = $ExceptIfBetweenMemberOf2
            ExceptIfContentCharacterSetContainsWords      = $ExceptIfContentCharacterSetContainsWords
            ExceptIfFrom                                  = $ExceptIfFrom
            ExceptIfFromAddressContainsWords              = $ExceptIfFromAddressContainsWords
            ExceptIfFromAddressMatchesPatterns            = $ExceptIfFromAddressMatchesPatterns
            ExceptIfFromMemberOf                          = $ExceptIfFromMemberOf
            ExceptIfFromScope                             = $ExceptIfFromScope
            ExceptIfHasClassification                     = $ExceptIfHasClassification
            ExceptIfHasNoClassification                   = $ExceptIfHasNoClassification
            ExceptIfHasSenderOverride                     = $ExceptIfHasSenderOverride
            ExceptIfHeaderContainsMessageHeader           = $ExceptIfHeaderContainsMessageHeader
            ExceptIfHeaderContainsWords                   = $ExceptIfHeaderContainsWords
            ExceptIfHeaderMatchesMessageHeader            = $ExceptIfHeaderMatchesMessageHeader
            ExceptIfHeaderMatchesPatterns                 = $ExceptIfHeaderMatchesPatterns
            ExceptIfManagerAddresses                      = $ExceptIfManagerAddresses
            ExceptIfManagerForEvaluatedUser               = $ExceptIfManagerForEvaluatedUser
            ExceptIfMessageTypeMatches                    = $ExceptIfMessageTypeMatches
            ExceptIfMessageContainsAllDataClassifications = $ExceptIfMessageContainsAllDataClassifications
            ExceptIfMessageContainsDataClassifications    = $ExceptIfMessageContainsDataClassifications
            ExceptIfMessageSizeOver                       = $ExceptIfMessageSizeOver
            ExceptIfRecipientADAttributeContainsWords     = $ExceptIfRecipientADAttributeContainsWords
            ExceptIfRecipientADAttributeMatchesPatterns   = $ExceptIfRecipientADAttributeMatchesPatterns
            ExceptIfRecipientAddressContainsWords         = $ExceptIfRecipientAddressContainsWords
            ExceptIfRecipientAddressMatchesPatterns       = $ExceptIfRecipientAddressMatchesPatterns
            ExceptIfRecipientDomainIs                     = $ExceptIfRecipientDomainIs
            ExceptIfRecipientInSenderList                 = $ExceptIfRecipientInSenderList
            ExceptIfSenderADAttributeContainsWords        = $ExceptIfSenderADAttributeContainsWords
            ExceptIfSenderADAttributeMatchesPatterns      = $ExceptIfSenderADAttributeMatchesPatterns
            ExceptIfSenderDomainIs                        = $ExceptIfSenderDomainIs
            ExceptIfSenderInRecipientList                 = $ExceptIfSenderInRecipientList
            ExceptIfSenderIpRanges                        = $ExceptIfSenderIpRanges
            ExceptIfSenderManagementRelationship          = $ExceptIfSenderManagementRelationship
            ExceptIfSentTo                                = $ExceptIfSentTo
            ExceptIfSentToMemberOf                        = $ExceptIfSentToMemberOf
            ExceptIfSentToScope                           = $ExceptIfSentToScope
            ExceptIfSubjectContainsWords                  = $ExceptIfSubjectContainsWords
            ExceptIfSubjectMatchesPatterns                = $ExceptIfSubjectMatchesPatterns
            ExceptIfSubjectOrBodyContainsWords            = $ExceptIfSubjectOrBodyContainsWords
            ExceptIfSubjectOrBodyMatchesPatterns          = $ExceptIfSubjectOrBodyMatchesPatterns
            ExceptIfWithImportance                        = $ExceptIfWithImportance
            ExpiryDate                                    = $ExpiryDate
            From                                          = $From
            FromAddressContainsWords                      = $FromAddressContainsWords
            FromAddressMatchesPatterns                    = $FromAddressMatchesPatterns
            FromMemberOf                                  = $FromMemberOf
            FromScope                                     = $FromScope
            GenerateIncidentReport                        = $GenerateIncidentReport
            GenerateNotification                          = $GenerateNotification
            HasClassification                             = $HasClassification
            HasNoClassification                           = $HasNoClassification
            HasSenderOverride                             = $HasSenderOverride
            HeaderContainsMessageHeader                   = $HeaderContainsMessageHeader
            HeaderContainsWords                           = $HeaderContainsWords
            HeaderMatchesMessageHeader                    = $HeaderMatchesMessageHeader
            HeaderMatchesPatterns                         = $HeaderMatchesPatterns
            IncidentReportContent                         = $IncidentReportContent
            IncidentReportOriginalMail                    = $IncidentReportOriginalMail
            ManagerAddresses                              = $ManagerAddresses
            ManagerForEvaluatedUser                       = $ManagerForEvaluatedUser
            MessageContainsAllDataClassifications         = $MessageContainsAllDataClassifications
            MessageContainsDataClassifications            = $MessageContainsDataClassifications
            MessageSizeOver                               = $MessageSizeOver
            MessageTypeMatches                            = $MessageTypeMatches
            Mode                                          = $Mode
            ModerateMessageByManager                      = $ModerateMessageByManager
            ModerateMessageByUser                         = $ModerateMessageByUser
            NotifySender                                  = $NotifySender
            PrependSubject                                = $PrependSubject
            Priority                                      = $Priority
            RecipientADAttributeContainsWords             = $RecipientADAttributeContainsWords
            RecipientADAttributeMatchesPatterns           = $RecipientADAttributeMatchesPatterns
            RecipientAddressContainsWords                 = $RecipientAddressContainsWords
            RecipientAddressMatchesPatterns               = $RecipientAddressMatchesPatterns
            RecipientDomainIs                             = $RecipientDomainIs
            RecipientInSenderList                         = $RecipientInSenderList
            RedirectMessageTo                             = $RedirectMessageTo
            RejectMessageEnhancedStatusCode               = $RejectMessageEnhancedStatusCode
            RejectMessageReasonText                       = $RejectMessageReasonText
            RemoveHeader                                  = $RemoveHeader
            RemoveOME                                     = $RemoveOME
            RemoveOMEv2                                   = $RemoveOMEv2
            RouteMessageOutboundConnector                 = $RouteMessageOutboundConnector
            RouteMessageOutboundRequireTls                = $RouteMessageOutboundRequireTls
            RuleErrorAction                               = $RuleErrorAction
            RuleSubType                                   = $RuleSubType
            SenderADAttributeContainsWords                = $SenderADAttributeContainsWords
            SenderADAttributeMatchesPatterns              = $SenderADAttributeMatchesPatterns
            SenderAddressLocation                         = $SenderAddressLocation
            SenderDomainIs                                = $SenderDomainIs
            SenderInRecipientList                         = $SenderInRecipientList
            SenderIpRanges                                = $SenderIpRanges
            SenderManagementRelationship                  = $SenderManagementRelationship
            SentTo                                        = $SentTo
            SentToMemberOf                                = $SentToMemberOf
            SentToScope                                   = $SentToScope
            SetAuditSeverity                              = $SetAuditSeverity
            SetHeaderName                                 = $SetHeaderName
            SetHeaderValue                                = $SetHeaderValue
            SetSCL                                        = $SetSCL
            StopRuleProcessing                            = $StopRuleProcessing
            SubjectContainsWords                          = $SubjectContainsWords
            SubjectMatchesPatterns                        = $SubjectMatchesPatterns
            SubjectOrBodyContainsWords                    = $SubjectOrBodyContainsWords
            SubjectOrBodyMatchesPatterns                  = $SubjectOrBodyMatchesPatterns
            WithImportance                                = $WithImportance
            Ensure                                        = 'Absent'
            GlobalAdminAccount                            = $GlobalAdminAccount
        }

        return $nullReturn
    }
    else
    {
        $result = @{
            Name                                          = $TransportRule.Name
            ADComparisonAttribute                         = $TransportRule.ADComparisonAttribute
            ADComparisonOperator                          = $TransportRule.ADComparisonOperator
            ActivationDate                                = $TransportRule.ActivationDate
            AddManagerAsRecipientType                     = $TransportRule.AddManagerAsRecipientType
            AddToRecipients                               = $TransportRule.AddToRecipients
            AnyOfCcHeader                                 = $TransportRule.AnyOfCcHeader
            AnyOfCcHeaderMemberOf                         = $TransportRule.AnyOfCcHeaderMemberOf
            AnyOfRecipientAddressContainsWords            = $TransportRule.AnyOfRecipientAddressContainsWords
            AnyOfRecipientAddressMatchesPatterns          = $TransportRule.AnyOfRecipientAddressMatchesPatterns
            AnyOfToCcHeader                               = $TransportRule.AnyOfToCcHeader
            AnyOfToCcHeaderMemberOf                       = $TransportRule.AnyOfToCcHeaderMemberOf
            AnyOfToHeader                                 = $TransportRule.AnyOfToHeader
            AnyOfToHeaderMemberOf                         = $TransportRule.AnyOfToHeaderMemberOf
            ApplyClassification                           = $TransportRule.ApplyClassification
            ApplyHtmlDisclaimerFallbackAction             = $TransportRule.ApplyHtmlDisclaimerFallbackAction
            ApplyHtmlDisclaimerLocation                   = $TransportRule.ApplyHtmlDisclaimerLocation
            ApplyHtmlDisclaimerText                       = $TransportRule.ApplyHtmlDisclaimerText
            ApplyOME                                      = $TransportRule.ApplyOME
            ApplyRightsProtectionTemplate                 = $TransportRule.ApplyRightsProtectionTemplate
            AttachmentContainsWords                       = $TransportRule.AttachmentContainsWords
            AttachmentExtensionMatchesWords               = $TransportRule.AttachmentExtensionMatchesWords
            AttachmentHasExecutableContent                = $TransportRule.AttachmentHasExecutableContent
            AttachmentIsPasswordProtected                 = $TransportRule.AttachmentIsPasswordProtected
            AttachmentIsUnsupported                       = $TransportRule.AttachmentIsUnsupported
            AttachmentMatchesPatterns                     = $TransportRule.AttachmentMatchesPatterns
            AttachmentNameMatchesPatterns                 = $TransportRule.AttachmentNameMatchesPatterns
            AttachmentPropertyContainsWords               = $TransportRule.AttachmentPropertyContainsWords
            AttachmentProcessingLimitExceeded             = $TransportRule.AttachmentProcessingLimitExceeded
            AttachmentSizeOver                            = $TransportRule.AttachmentSizeOver
            BetweenMemberOf1                              = $TransportRule.BetweenMemberOf1
            BetweenMemberOf2                              = $TransportRule.BetweenMemberOf2
            BlindCopyTo                                   = $TransportRule.BlindCopyTo
            Comments                                      = $TransportRule.Comments
            ContentCharacterSetContainsWords              = $TransportRule.ContentCharacterSetContainsWords
            CopyTo                                        = $TransportRule.CopyTo
            DeleteMessage                                 = $TransportRule.DeleteMessage
            DlpPolicy                                     = $TransportRule.DlpPolicy
            ExceptIfADComparisonAttribute                 = $TransportRule.ExceptIfADComparisonAttribute
            ExceptIfADComparisonOperator                  = $TransportRule.ExceptIfADComparisonOperator
            ExceptIfAnyOfCcHeader                         = $TransportRule.ExceptIfAnyOfCcHeader
            ExceptIfAnyOfCcHeaderMemberOf                 = $TransportRule.ExceptIfAnyOfCcHeaderMemberOf
            ExceptIfAnyOfRecipientAddressContainsWords    = $TransportRule.ExceptIfAnyOfRecipientAddressContainsWords
            ExceptIfAnyOfRecipientAddressMatchesPatterns  = $TransportRule.ExceptIfAnyOfRecipientAddressMatchesPatterns
            ExceptIfAnyOfToCcHeader                       = $TransportRule.ExceptIfAnyOfToCcHeader
            ExceptIfAnyOfToCcHeaderMemberOf               = $TransportRule.ExceptIfAnyOfToCcHeaderMemberOf
            ExceptIfAnyOfToHeader                         = $TransportRule.ExceptIfAnyOfToHeader
            ExceptIfAnyOfToHeaderMemberOf                 = $TransportRule.ExceptIfAnyOfToHeaderMemberOf
            ExceptIfAttachmentContainsWords               = $TransportRule.ExceptIfAttachmentContainsWords
            ExceptIfAttachmentExtensionMatchesWords       = $TransportRule.ExceptIfAttachmentExtensionMatchesWords
            ExceptIfAttachmentHasExecutableContent        = $TransportRule.ExceptIfAttachmentHasExecutableContent
            ExceptIfAttachmentIsPasswordProtected         = $TransportRule.ExceptIfAttachmentIsPasswordProtected
            ExceptIfAttachmentIsUnsupported               = $TransportRule.ExceptIfAttachmentIsUnsupported
            ExceptIfAttachmentMatchesPatterns             = $TransportRule.ExceptIfAttachmentMatchesPatterns
            ExceptIfAttachmentNameMatchesPatterns         = $TransportRule.ExceptIfAttachmentNameMatchesPatterns
            ExceptIfAttachmentPropertyContainsWords       = $TransportRule.ExceptIfAttachmentPropertyContainsWords
            ExceptIfAttachmentProcessingLimitExceeded     = $TransportRule.ExceptIfAttachmentProcessingLimitExceeded
            ExceptIfAttachmentSizeOver                    = $TransportRule.ExceptIfAttachmentSizeOver
            ExceptIfBetweenMemberOf1                      = $TransportRule.ExceptIfBetweenMemberOf1
            ExceptIfBetweenMemberOf2                      = $TransportRule.ExceptIfBetweenMemberOf2
            ExceptIfContentCharacterSetContainsWords      = $TransportRule.ExceptIfContentCharacterSetContainsWords
            ExceptIfFrom                                  = $TransportRule.ExceptIfFrom
            ExceptIfFromAddressContainsWords              = $TransportRule.ExceptIfFromAddressContainsWords
            ExceptIfFromAddressMatchesPatterns            = $TransportRule.ExceptIfFromAddressMatchesPatterns
            ExceptIfFromMemberOf                          = $TransportRule.ExceptIfFromMemberOf
            ExceptIfFromScope                             = $TransportRule.ExceptIfFromScope
            ExceptIfHasClassification                     = $TransportRule.ExceptIfHasClassification
            ExceptIfHasNoClassification                   = $TransportRule.ExceptIfHasNoClassification
            ExceptIfHasSenderOverride                     = $TransportRule.ExceptIfHasSenderOverride
            ExceptIfHeaderContainsMessageHeader           = $TransportRule.ExceptIfHeaderContainsMessageHeader
            ExceptIfHeaderContainsWords                   = $TransportRule.ExceptIfHeaderContainsWords
            ExceptIfHeaderMatchesMessageHeader            = $TransportRule.ExceptIfHeaderMatchesMessageHeader
            ExceptIfHeaderMatchesPatterns                 = $TransportRule.ExceptIfHeaderMatchesPatterns
            ExceptIfManagerAddresses                      = $TransportRule.ExceptIfManagerAddresses
            ExceptIfManagerForEvaluatedUser               = $TransportRule.ExceptIfManagerForEvaluatedUser
            ExceptIfMessageTypeMatches                    = $TransportRule.ExceptIfMessageTypeMatches
            ExceptIfMessageContainsAllDataClassifications = $TransportRule.ExceptIfMessageContainsAllDataClassifications
            ExceptIfMessageContainsDataClassifications    = $TransportRule.ExceptIfMessageContainsDataClassifications
            ExceptIfMessageSizeOver                       = $TransportRule.ExceptIfMessageSizeOver
            ExceptIfRecipientADAttributeContainsWords     = $TransportRule.ExceptIfRecipientADAttributeContainsWords
            ExceptIfRecipientADAttributeMatchesPatterns   = $TransportRule.ExceptIfRecipientADAttributeMatchesPatterns
            ExceptIfRecipientAddressContainsWords         = $TransportRule.ExceptIfRecipientAddressContainsWords
            ExceptIfRecipientAddressMatchesPatterns       = $TransportRule.ExceptIfRecipientAddressMatchesPatterns
            ExceptIfRecipientDomainIs                     = $TransportRule.ExceptIfRecipientDomainIs
            ExceptIfRecipientInSenderList                 = $TransportRule.ExceptIfRecipientInSenderList
            ExceptIfSenderADAttributeContainsWords        = $TransportRule.ExceptIfSenderADAttributeContainsWords
            ExceptIfSenderADAttributeMatchesPatterns      = $TransportRule.ExceptIfSenderADAttributeMatchesPatterns
            ExceptIfSenderDomainIs                        = $TransportRule.ExceptIfSenderDomainIs
            ExceptIfSenderInRecipientList                 = $TransportRule.ExceptIfSenderInRecipientList
            ExceptIfSenderIpRanges                        = $TransportRule.ExceptIfSenderIpRanges
            ExceptIfSenderManagementRelationship          = $TransportRule.ExceptIfSenderManagementRelationship
            ExceptIfSentTo                                = $TransportRule.ExceptIfSentTo
            ExceptIfSentToMemberOf                        = $TransportRule.ExceptIfSentToMemberOf
            ExceptIfSentToScope                           = $TransportRule.ExceptIfSentToScope
            ExceptIfSubjectContainsWords                  = $TransportRule.ExceptIfSubjectContainsWords
            ExceptIfSubjectMatchesPatterns                = $TransportRule.ExceptIfSubjectMatchesPatterns
            ExceptIfSubjectOrBodyContainsWords            = $TransportRule.ExceptIfSubjectOrBodyContainsWords
            ExceptIfSubjectOrBodyMatchesPatterns          = $TransportRule.ExceptIfSubjectOrBodyMatchesPatterns
            ExceptIfWithImportance                        = $TransportRule.ExceptIfWithImportance
            ExpiryDate                                    = $TransportRule.ExpiryDate
            From                                          = $TransportRule.From
            FromAddressContainsWords                      = $TransportRule.FromAddressContainsWords
            FromAddressMatchesPatterns                    = $TransportRule.FromAddressMatchesPatterns
            FromMemberOf                                  = $TransportRule.FromMemberOf
            FromScope                                     = $TransportRule.FromScope
            GenerateIncidentReport                        = $TransportRule.GenerateIncidentReport
            GenerateNotification                          = $TransportRule.GenerateNotification
            HasClassification                             = $TransportRule.HasClassification
            HasNoClassification                           = $TransportRule.HasNoClassification
            HasSenderOverride                             = $TransportRule.HasSenderOverride
            HeaderContainsMessageHeader                   = $TransportRule.HeaderContainsMessageHeader
            HeaderContainsWords                           = $TransportRule.HeaderContainsWords
            HeaderMatchesMessageHeader                    = $TransportRule.HeaderMatchesMessageHeader
            HeaderMatchesPatterns                         = $TransportRule.HeaderMatchesPatterns
            IncidentReportContent                         = $TransportRule.IncidentReportContent
            IncidentReportOriginalMail                    = $TransportRule.IncidentReportOriginalMail
            ManagerAddresses                              = $TransportRule.ManagerAddresses
            ManagerForEvaluatedUser                       = $TransportRule.ManagerForEvaluatedUser
            MessageContainsAllDataClassifications         = $TransportRule.MessageContainsAllDataClassifications
            MessageContainsDataClassifications            = $TransportRule.MessageContainsDataClassifications
            MessageSizeOver                               = $TransportRule.MessageSizeOver
            MessageTypeMatches                            = $TransportRule.MessageTypeMatches
            Mode                                          = $TransportRule.Mode
            ModerateMessageByManager                      = $TransportRule.ModerateMessageByManager
            ModerateMessageByUser                         = $TransportRule.ModerateMessageByUser
            NotifySender                                  = $TransportRule.NotifySender
            PrependSubject                                = $TransportRule.PrependSubject
            Priority                                      = $TransportRule.Priority
            RecipientADAttributeContainsWords             = $TransportRule.RecipientADAttributeContainsWords
            RecipientADAttributeMatchesPatterns           = $TransportRule.RecipientADAttributeMatchesPatterns
            RecipientAddressContainsWords                 = $TransportRule.RecipientAddressContainsWords
            RecipientAddressMatchesPatterns               = $TransportRule.RecipientAddressMatchesPatterns
            RecipientDomainIs                             = $TransportRule.RecipientDomainIs
            RecipientInSenderList                         = $TransportRule.RecipientInSenderList
            RedirectMessageTo                             = $TransportRule.RedirectMessageTo
            RejectMessageEnhancedStatusCode               = $TransportRule.RejectMessageEnhancedStatusCode
            RejectMessageReasonText                       = $TransportRule.RejectMessageReasonText
            RemoveHeader                                  = $TransportRule.RemoveHeader
            RemoveOME                                     = $TransportRule.RemoveOME
            RemoveOMEv2                                   = $TransportRule.RemoveOMEv2
            RouteMessageOutboundConnector                 = $TransportRule.RouteMessageOutboundConnector
            RouteMessageOutboundRequireTls                = $TransportRule.RouteMessageOutboundRequireTls
            RuleErrorAction                               = $TransportRule.RuleErrorAction
            RuleSubType                                   = $TransportRule.RuleSubType
            SenderADAttributeContainsWords                = $TransportRule.SenderADAttributeContainsWords
            SenderADAttributeMatchesPatterns              = $TransportRule.SenderADAttributeMatchesPatterns
            SenderAddressLocation                         = $TransportRule.SenderAddressLocation
            SenderDomainIs                                = $TransportRule.SenderDomainIs
            SenderInRecipientList                         = $TransportRule.SenderInRecipientList
            SenderIpRanges                                = $TransportRule.SenderIpRanges
            SenderManagementRelationship                  = $TransportRule.SenderManagementRelationship
            SentTo                                        = $TransportRule.SentTo
            SentToMemberOf                                = $TransportRule.SentToMemberOf
            SentToScope                                   = $TransportRule.SentToScope
            SetAuditSeverity                              = $TransportRule.SetAuditSeverity
            SetHeaderName                                 = $TransportRule.SetHeaderName
            SetHeaderValue                                = $TransportRule.SetHeaderValue
            SetSCL                                        = $TransportRule.SetSCL
            StopRuleProcessing                            = $TransportRule.StopRuleProcessing
            SubjectContainsWords                          = $TransportRule.SubjectContainsWords
            SubjectMatchesPatterns                        = $TransportRule.SubjectMatchesPatterns
            SubjectOrBodyContainsWords                    = $TransportRule.SubjectOrBodyContainsWords
            SubjectOrBodyMatchesPatterns                  = $TransportRule.SubjectOrBodyMatchesPatterns
            WithImportance                                = $TransportRule.WithImportance
            Ensure                                        = 'Present'
            GlobalAdminAccount                            = $GlobalAdminAccount
        }

        Write-Verbose -Message "Found Transport Rule $($Name)"
        return $result
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $ADComparisonAttribute,

        [Parameter()]
        [ValidateSet('Equal', 'NotEqual')]
        [System.String]
        $ADComparisonOperator,

        [Parameter()]
        [System.String]
        $ActivationDate,

        [Parameter()]
        [ValidateSet('To', 'Cc', 'Bcc', 'Redirect')]
        [System.String]
        $AddManagerAsRecipientType,

        [Parameter()]
        [System.String[]]
        $AddToRecipients = @(),

        [Parameter()]
        [System.String[]]
        $AnyOfCcHeader = @(),

        [Parameter()]
        [System.String[]]
        $AnyOfCcHeaderMemberOf = @(),

        [Parameter()]
        [System.String[]]
        $AnyOfRecipientAddressContainsWords,

        [Parameter()]
        [System.String[]]
        $AnyOfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $AnyOfToCcHeader = @(),

        [Parameter()]
        [System.String[]]
        $AnyOfToCcHeaderMemberOf = @(),

        [Parameter()]
        [System.String[]]
        $AnyOfToHeader = @(),

        [Parameter()]
        [System.String[]]
        $AnyOfToHeaderMemberOf = @(),

        [Parameter()]
        [System.String]
        $ApplyClassification,

        [Parameter()]
        [ValidateSet('Wrap', 'Ignore', 'Reject')]
        [System.String]
        $ApplyHtmlDisclaimerFallbackAction,

        [Parameter()]
        [ValidateSet('Append', 'Prepand')]
        [System.String]
        $ApplyHtmlDisclaimerLocation,

        [Parameter()]
        [System.String]
        $ApplyHtmlDisclaimerText,

        [Parameter()]
        [System.Boolean]
        $ApplyOME,

        [Parameter()]
        [System.String]
        $ApplyRightsProtectionTemplate,

        [Parameter()]
        [System.String[]]
        $AttachmentContainsWords,

        [Parameter()]
        [System.String[]]
        $AttachmentExtensionMatchesWords,

        [Parameter()]
        [System.Boolean]
        $AttachmentHasExecutableContent,

        [Parameter()]
        [System.Boolean]
        $AttachmentIsPasswordProtected,

        [Parameter()]
        [System.Boolean]
        $AttachmentIsUnsupported,

        [Parameter()]
        [System.String[]]
        $AttachmentMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $AttachmentNameMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $AttachmentPropertyContainsWords,

        [Parameter()]
        [System.Boolean]
        $AttachmentProcessingLimitExceeded,

        [Parameter()]
        [System.String]
        $AttachmentSizeOver,

        [Parameter()]
        [System.String[]]
        $BetweenMemberOf1 = @(),

        [Parameter()]
        [System.String[]]
        $BetweenMemberOf2 = @(),

        [Parameter()]
        [System.String[]]
        $BlindCopyTo = @(),

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $Comments,

        [Parameter()]
        [System.String[]]
        $ContentCharacterSetContainsWords,

        [Parameter()]
        [System.String[]]
        $CopyTo = @(),

        [Parameter()]
        [System.Boolean]
        $DeleteMessage,

        [Parameter()]
        [System.String]
        $DlpPolicy,

        [Parameter()]
        [System.String]
        $ExceptIfADComparisonAttribute,

        [Parameter()]
        [ValidateSet('Equal', 'NotEqual')]
        [System.String]
        $ExceptIfADComparisonOperator,

        [Parameter()]
        [System.String[]]
        $ExceptIfAnyOfCcHeader = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfAnyOfCcHeaderMemberOf = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfAnyOfRecipientAddressContainsWords,

        [Parameter()]
        [System.String[]]
        $ExceptIfAnyOfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ExceptIfAnyOfToCcHeader = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfAnyOfToCcHeaderMemberOf = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfAnyOfToHeader = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfAnyOfToHeaderMemberOf = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfAttachmentContainsWords,

        [Parameter()]
        [System.String[]]
        $ExceptIfAttachmentExtensionMatchesWords,

        [Parameter()]
        [System.Boolean]
        $ExceptIfAttachmentHasExecutableContent,

        [Parameter()]
        [System.Boolean]
        $ExceptIfAttachmentIsPasswordProtected,

        [Parameter()]
        [System.Boolean]
        $ExceptIfAttachmentIsUnsupported,

        [Parameter()]
        [System.String[]]
        $ExceptIfAttachmentMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ExceptIfAttachmentNameMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ExceptIfAttachmentPropertyContainsWords,

        [Parameter()]
        [System.Boolean]
        $ExceptIfAttachmentProcessingLimitExceeded,

        [Parameter()]
        [System.String]
        $ExceptIfAttachmentSizeOver,

        [Parameter()]
        [System.String[]]
        $ExceptIfBetweenMemberOf1 = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfBetweenMemberOf2 = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfContentCharacterSetContainsWords = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfFrom = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfFromAddressContainsWords,

        [Parameter()]
        [System.String[]]
        $ExceptIfFromAddressMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ExceptIfFromMemberOf = @(),

        [Parameter()]
        [ValidateSet('InOrganization', 'NotInOrganization')]
        [System.String]
        $ExceptIfFromScope,

        [Parameter()]
        [System.String]
        $ExceptIfHasClassification,

        [Parameter()]
        [System.Boolean]
        $ExceptIfHasNoClassification,

        [Parameter()]
        [System.Boolean]
        $ExceptIfHasSenderOverride,

        [Parameter()]
        [System.String]
        $ExceptIfHeaderContainsMessageHeader,

        [Parameter()]
        [System.String[]]
        $ExceptIfHeaderContainsWords,

        [Parameter()]
        [System.String]
        $ExceptIfHeaderMatchesMessageHeader,

        [Parameter()]
        [System.String[]]
        $ExceptIfHeaderMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ExceptIfManagerAddresses = @(),

        [Parameter()]
        [System.String]
        $ExceptIfManagerForEvaluatedUser,

        [Parameter()]
        [ValidateSet('OOF', 'AutoForward', 'Encrypted', 'Calendaring', 'PermissionControlled', 'Voicemail', 'Signed', 'ApprovalRequest', 'ReadReceipt')]
        [System.String]
        $ExceptIfMessageTypeMatches,

        [Parameter()]
        [System.String[]]
        $ExceptIfMessageContainsAllDataClassifications = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfMessageContainsDataClassifications = @(),

        [Parameter()]
        [System.String]
        $ExceptIfMessageSizeOver,

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientADAttributeContainsWords,

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientADAttributeMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientAddressContainsWords,

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientInSenderList,

        [Parameter()]
        [System.String[]]
        $ExceptIfSenderADAttributeContainsWords,

        [Parameter()]
        [System.String[]]
        $ExceptIfSenderADAttributeMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ExceptIfSenderDomainIs,

        [Parameter()]
        [System.String[]]
        $ExceptIfSenderInRecipientList,

        [Parameter()]
        [System.String[]]
        $ExceptIfSenderIpRanges,

        [Parameter()]
        [ValidateSet('Manager', 'DirectReport')]
        [System.String]
        $ExceptIfSenderManagementRelationship,

        [Parameter()]
        [System.String[]]
        $ExceptIfSentTo = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentToMemberOf = @(),

        [Parameter()]
        [ValidateSet('InOrganization', 'NotInOrganization', 'ExternalPartner', 'ExternalNonPartner')]
        [System.String]
        $ExceptIfSentToScope,

        [Parameter()]
        [System.String[]]
        $ExceptIfSubjectContainsWords,

        [Parameter()]
        [System.String[]]
        $ExceptIfSubjectMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ExceptIfSubjectOrBodyContainsWords,

        [Parameter()]
        [System.String[]]
        $ExceptIfSubjectOrBodyMatchesPatterns,

        [Parameter()]
        [ValidateSet('Low', 'Normal', 'High')]
        [System.String]
        $ExceptIfWithImportance,

        [Parameter()]
        [System.String]
        $ExpiryDate,

        [Parameter()]
        [System.String[]]
        $From = @(),

        [Parameter()]
        [System.String[]]
        $FromAddressContainsWords,

        [Parameter()]
        [System.String[]]
        $FromAddressMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $FromMemberOf = @(),

        [Parameter()]
        [ValidateSet('InOrganization', 'NotInOrganization')]
        [System.String]
        $FromScope,

        [Parameter()]
        [System.String]
        $GenerateIncidentReport,

        [Parameter()]
        [System.String]
        $GenerateNotification,

        [Parameter()]
        [System.String]
        $HasClassification,

        [Parameter()]
        [System.Boolean]
        $HasNoClassification,

        [Parameter()]
        [System.Boolean]
        $HasSenderOverride,

        [Parameter()]
        [System.String]
        $HeaderContainsMessageHeader,

        [Parameter()]
        [System.String[]]
        $HeaderContainsWords,

        [Parameter()]
        [System.String]
        $HeaderMatchesMessageHeader,

        [Parameter()]
        [System.String[]]
        $HeaderMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $IncidentReportContent,

        [Parameter()]
        [System.String[]]
        $IncidentReportOriginalMail,

        [Parameter()]
        [System.String[]]
        $ManagerAddresses = @(),

        [Parameter()]
        [ValidateSet('Recipient', 'Sender')]
        [System.String]
        $ManagerForEvaluatedUser,

        [Parameter()]
        [System.String[]]
        $MessageContainsAllDataClassifications,

        [Parameter()]
        [System.String[]]
        $MessageContainsDataClassifications,

        [Parameter()]
        [System.String]
        $MessageSizeOver,

        [Parameter()]
        [ValidateSet('OOF', 'AutoForward', 'Encrypted', 'Calendaring', 'PermissionControlled', 'Voicemail', 'Signed', 'ApprovalRequest', 'ReadReceipt')]
        [System.String]
        $MessageTypeMatches,

        [Parameter()]
        [ValidateSet('Audit', 'AuditAndNotify', 'Enforce')]
        [System.String]
        $Mode,

        [Parameter()]
        [System.Boolean]
        $ModerateMessageByManager,

        [Parameter()]
        [System.String[]]
        $ModerateMessageByUser = @(),

        [Parameter()]
        [ValidateSet('NotifyOnly', 'RejectMessage', 'RejectUnlessFalsePositiveOverride', 'RejectUnlessSilentOverride', 'RejectUnlessExplicitOverride')]
        [System.String]
        $NotifySender,

        [Parameter()]
        [System.String]
        $PrependSubject,

        [Parameter()]
        [System.String]
        $Priority,

        [Parameter()]
        [System.String[]]
        $RecipientADAttributeContainsWords,

        [Parameter()]
        [System.String[]]
        $RecipientADAttributeMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $RecipientAddressContainsWords,

        [Parameter()]
        [System.String[]]
        $RecipientAddressMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $RecipientDomainIs,

        [Parameter()]
        [System.String[]]
        $RecipientInSenderList,

        [Parameter()]
        [System.String[]]
        $RedirectMessageTo = @(),

        [Parameter()]
        [System.String]
        $RejectMessageEnhancedStatusCode,

        [Parameter()]
        [System.String]
        $RejectMessageReasonText,

        [Parameter()]
        [System.String]
        $RemoveHeader,

        [Parameter()]
        [System.Boolean]
        $RemoveOME,

        [Parameter()]
        [System.Boolean]
        $RemoveOMEv2,

        [Parameter()]
        [System.String]
        $RouteMessageOutboundConnector,

        [Parameter()]
        [System.Boolean]
        $RouteMessageOutboundRequireTls,

        [Parameter()]
        [ValidateSet('Ignore', 'Defer')]
        [System.String]
        $RuleErrorAction,

        [Parameter()]
        [ValidateSet('Dlp', 'None')]
        [System.String]
        $RuleSubType,

        [Parameter()]
        [System.String[]]
        $SenderADAttributeContainsWords,

        [Parameter()]
        [System.String[]]
        $SenderADAttributeMatchesPatterns,

        [Parameter()]
        [ValidateSet('Header', 'Envelope', 'HeaderOrEnvelope')]
        [System.String]
        $SenderAddressLocation,

        [Parameter()]
        [System.String[]]
        $SenderDomainIs,

        [Parameter()]
        [System.String[]]
        $SenderInRecipientList,

        [Parameter()]
        [System.String[]]
        $SenderIpRanges,

        [Parameter()]
        [ValidateSet('Manager', 'DirectReport')]
        [System.String]
        $SenderManagementRelationship,

        [Parameter()]
        [System.String[]]
        $SentTo = @(),

        [Parameter()]
        [System.String[]]
        $SentToMemberOf = @(),

        [Parameter()]
        [ValidateSet('InOrganization', 'NotInOrganization', 'ExternalPartner', 'ExternalNonPartner')]
        [System.String]
        $SentToScope,

        [Parameter()]
        [ValidateSet('DoNotAudit', 'Low', 'Medium', 'High')]
        [System.String]
        $SetAuditSeverity,

        [Parameter()]
        [System.String]
        $SetHeaderName,

        [Parameter()]
        [System.String]
        $SetHeaderValue,

        [Parameter()]
        [System.String]
        $SetSCL,

        [Parameter()]
        [System.Boolean]
        $StopRuleProcessing,

        [Parameter()]
        [System.String[]]
        $SubjectContainsWords,

        [Parameter()]
        [System.String[]]
        $SubjectMatchesPatterns,

        [Parameter()]
        [System.String]
        $SubjectOrBodyContainsWords,

        [Parameter()]
        [System.String[]]
        $SubjectOrBodyMatchesPatterns,

        [Parameter()]
        [ValidateSet('Low', 'Normal', 'High')]
        [System.String]
        $WithImportance,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting Transport Rule configuration for $Name"

    $currentTransportRuleConfig = Get-TargetResource @PSBoundParameters

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $NewTransportRuleParams = @{
        Name                                          = $Name
        ADComparisonAttribute                         = $ADComparisonAttribute
        ADComparisonOperator                          = $ADComparisonOperator
        ActivationDate                                = $ActivationDate
        AddManagerAsRecipientType                     = $AddManagerAsRecipientType
        AddToRecipients                               = $AddToRecipients
        AnyOfCcHeader                                 = $AnyOfCcHeader
        AnyOfCcHeaderMemberOf                         = $AnyOfCcHeaderMemberOf
        AnyOfRecipientAddressContainsWords            = $AnyOfRecipientAddressContainsWords
        AnyOfRecipientAddressMatchesPatterns          = $AnyOfRecipientAddressMatchesPatterns
        AnyOfToCcHeader                               = $AnyOfToCcHeader
        AnyOfToCcHeaderMemberOf                       = $AnyOfToCcHeaderMemberOf
        AnyOfToHeader                                 = $AnyOfToHeader
        AnyOfToHeaderMemberOf                         = $AnyOfToHeaderMemberOf
        ApplyClassification                           = $ApplyClassification
        ApplyHtmlDisclaimerFallbackAction             = $ApplyHtmlDisclaimerFallbackAction
        ApplyHtmlDisclaimerLocation                   = $ApplyHtmlDisclaimerLocation
        ApplyHtmlDisclaimerText                       = $ApplyHtmlDisclaimerText
        ApplyOME                                      = $ApplyOME
        ApplyRightsProtectionTemplate                 = $ApplyRightsProtectionTemplate
        AttachmentContainsWords                       = $AttachmentContainsWords
        AttachmentExtensionMatchesWords               = $AttachmentExtensionMatchesWords
        AttachmentHasExecutableContent                = $AttachmentHasExecutableContent
        AttachmentIsPasswordProtected                 = $AttachmentIsPasswordProtected
        AttachmentIsUnsupported                       = $AttachmentIsUnsupported
        AttachmentMatchesPatterns                     = $AttachmentMatchesPatterns
        AttachmentNameMatchesPatterns                 = $AttachmentNameMatchesPatterns
        AttachmentPropertyContainsWords               = $AttachmentPropertyContainsWords
        AttachmentProcessingLimitExceeded             = $AttachmentProcessingLimitExceeded
        AttachmentSizeOver                            = $AttachmentSizeOver
        BetweenMemberOf1                              = $BetweenMemberOf1
        BetweenMemberOf2                              = $BetweenMemberOf2
        BlindCopyTo                                   = $BlindCopyTo
        Comments                                      = $Comments
        ContentCharacterSetContainsWords              = $ContentCharacterSetContainsWords
        CopyTo                                        = $CopyTo
        DeleteMessage                                 = $DeleteMessage
        DlpPolicy                                     = $DlpPolicy
        ExceptIfADComparisonAttribute                 = $ExceptIfADComparisonAttribute
        ExceptIfADComparisonOperator                  = $ExceptIfADComparisonOperator
        ExceptIfAnyOfCcHeader                         = $ExceptIfAnyOfCcHeader
        ExceptIfAnyOfCcHeaderMemberOf                 = $ExceptIfAnyOfCcHeaderMemberOf
        ExceptIfAnyOfRecipientAddressContainsWords    = $ExceptIfAnyOfRecipientAddressContainsWords
        ExceptIfAnyOfRecipientAddressMatchesPatterns  = $ExceptIfAnyOfRecipientAddressMatchesPatterns
        ExceptIfAnyOfToCcHeader                       = $ExceptIfAnyOfToCcHeader
        ExceptIfAnyOfToCcHeaderMemberOf               = $ExceptIfAnyOfToCcHeaderMemberOf
        ExceptIfAnyOfToHeader                         = $ExceptIfAnyOfToHeader
        ExceptIfAnyOfToHeaderMemberOf                 = $ExceptIfAnyOfToHeaderMemberOf
        ExceptIfAttachmentContainsWords               = $ExceptIfAttachmentContainsWords
        ExceptIfAttachmentExtensionMatchesWords       = $ExceptIfAttachmentExtensionMatchesWords
        ExceptIfAttachmentHasExecutableContent        = $ExceptIfAttachmentHasExecutableContent
        ExceptIfAttachmentIsPasswordProtected         = $ExceptIfAttachmentIsPasswordProtected
        ExceptIfAttachmentIsUnsupported               = $ExceptIfAttachmentIsUnsupported
        ExceptIfAttachmentMatchesPatterns             = $ExceptIfAttachmentMatchesPatterns
        ExceptIfAttachmentNameMatchesPatterns         = $ExceptIfAttachmentNameMatchesPatterns
        ExceptIfAttachmentPropertyContainsWords       = $ExceptIfAttachmentPropertyContainsWords
        ExceptIfAttachmentProcessingLimitExceeded     = $ExceptIfAttachmentProcessingLimitExceeded
        ExceptIfAttachmentSizeOver                    = $ExceptIfAttachmentSizeOver
        ExceptIfBetweenMemberOf1                      = $ExceptIfBetweenMemberOf1
        ExceptIfBetweenMemberOf2                      = $ExceptIfBetweenMemberOf2
        ExceptIfContentCharacterSetContainsWords      = $ExceptIfContentCharacterSetContainsWords
        ExceptIfFrom                                  = $ExceptIfFrom
        ExceptIfFromAddressContainsWords              = $ExceptIfFromAddressContainsWords
        ExceptIfFromAddressMatchesPatterns            = $ExceptIfFromAddressMatchesPatterns
        ExceptIfFromMemberOf                          = $ExceptIfFromMemberOf
        ExceptIfFromScope                             = $ExceptIfFromScope
        ExceptIfHasClassification                     = $ExceptIfHasClassification
        ExceptIfHasNoClassification                   = $ExceptIfHasNoClassification
        ExceptIfHasSenderOverride                     = $ExceptIfHasSenderOverride
        ExceptIfHeaderContainsMessageHeader           = $ExceptIfHeaderContainsMessageHeader
        ExceptIfHeaderContainsWords                   = $ExceptIfHeaderContainsWords
        ExceptIfHeaderMatchesMessageHeader            = $ExceptIfHeaderMatchesMessageHeader
        ExceptIfHeaderMatchesPatterns                 = $ExceptIfHeaderMatchesPatterns
        ExceptIfManagerAddresses                      = $ExceptIfManagerAddresses
        ExceptIfManagerForEvaluatedUser               = $ExceptIfManagerForEvaluatedUser
        ExceptIfMessageTypeMatches                    = $ExceptIfMessageTypeMatches
        ExceptIfMessageContainsAllDataClassifications = $ExceptIfMessageContainsAllDataClassifications
        ExceptIfMessageContainsDataClassifications    = $ExceptIfMessageContainsDataClassifications
        ExceptIfMessageSizeOver                       = $ExceptIfMessageSizeOver
        ExceptIfRecipientADAttributeContainsWords     = $ExceptIfRecipientADAttributeContainsWords
        ExceptIfRecipientADAttributeMatchesPatterns   = $ExceptIfRecipientADAttributeMatchesPatterns
        ExceptIfRecipientAddressContainsWords         = $ExceptIfRecipientAddressContainsWords
        ExceptIfRecipientAddressMatchesPatterns       = $ExceptIfRecipientAddressMatchesPatterns
        ExceptIfRecipientDomainIs                     = $ExceptIfRecipientDomainIs
        ExceptIfRecipientInSenderList                 = $ExceptIfRecipientInSenderList
        ExceptIfSenderADAttributeContainsWords        = $ExceptIfSenderADAttributeContainsWords
        ExceptIfSenderADAttributeMatchesPatterns      = $ExceptIfSenderADAttributeMatchesPatterns
        ExceptIfSenderDomainIs                        = $ExceptIfSenderDomainIs
        ExceptIfSenderInRecipientList                 = $ExceptIfSenderInRecipientList
        ExceptIfSenderIpRanges                        = $ExceptIfSenderIpRanges
        ExceptIfSenderManagementRelationship          = $ExceptIfSenderManagementRelationship
        ExceptIfSentTo                                = $ExceptIfSentTo
        ExceptIfSentToMemberOf                        = $ExceptIfSentToMemberOf
        ExceptIfSentToScope                           = $ExceptIfSentToScope
        ExceptIfSubjectContainsWords                  = $ExceptIfSubjectContainsWords
        ExceptIfSubjectMatchesPatterns                = $ExceptIfSubjectMatchesPatterns
        ExceptIfSubjectOrBodyContainsWords            = $ExceptIfSubjectOrBodyContainsWords
        ExceptIfSubjectOrBodyMatchesPatterns          = $ExceptIfSubjectOrBodyMatchesPatterns
        ExceptIfWithImportance                        = $ExceptIfWithImportance
        ExpiryDate                                    = $ExpiryDate
        From                                          = $From
        FromAddressContainsWords                      = $FromAddressContainsWords
        FromAddressMatchesPatterns                    = $FromAddressMatchesPatterns
        FromMemberOf                                  = $FromMemberOf
        FromScope                                     = $FromScope
        GenerateIncidentReport                        = $GenerateIncidentReport
        GenerateNotification                          = $GenerateNotification
        HasClassification                             = $HasClassification
        HasNoClassification                           = $HasNoClassification
        HasSenderOverride                             = $HasSenderOverride
        HeaderContainsMessageHeader                   = $HeaderContainsMessageHeader
        HeaderContainsWords                           = $HeaderContainsWords
        HeaderMatchesMessageHeader                    = $HeaderMatchesMessageHeader
        HeaderMatchesPatterns                         = $HeaderMatchesPatterns
        IncidentReportContent                         = $IncidentReportContent
        IncidentReportOriginalMail                    = $IncidentReportOriginalMail
        ManagerAddresses                              = $ManagerAddresses
        ManagerForEvaluatedUser                       = $ManagerForEvaluatedUser
        MessageContainsAllDataClassifications         = $MessageContainsAllDataClassifications
        MessageContainsDataClassifications            = $MessageContainsDataClassifications
        MessageSizeOver                               = $MessageSizeOver
        MessageTypeMatches                            = $MessageTypeMatches
        Mode                                          = $Mode
        ModerateMessageByManager                      = $ModerateMessageByManager
        ModerateMessageByUser                         = $ModerateMessageByUser
        NotifySender                                  = $NotifySender
        PrependSubject                                = $PrependSubject
        Priority                                      = $Priority
        RecipientADAttributeContainsWords             = $RecipientADAttributeContainsWords
        RecipientADAttributeMatchesPatterns           = $RecipientADAttributeMatchesPatterns
        RecipientAddressContainsWords                 = $RecipientAddressContainsWords
        RecipientAddressMatchesPatterns               = $RecipientAddressMatchesPatterns
        RecipientDomainIs                             = $RecipientDomainIs
        RecipientInSenderList                         = $RecipientInSenderList
        RedirectMessageTo                             = $RedirectMessageTo
        RejectMessageEnhancedStatusCode               = $RejectMessageEnhancedStatusCode
        RejectMessageReasonText                       = $RejectMessageReasonText
        RemoveHeader                                  = $RemoveHeader
        RemoveOME                                     = $RemoveOME
        RemoveOMEv2                                   = $RemoveOMEv2
        RouteMessageOutboundConnector                 = $RouteMessageOutboundConnector
        RouteMessageOutboundRequireTls                = $RouteMessageOutboundRequireTls
        RuleErrorAction                               = $RuleErrorAction
        RuleSubType                                   = $RuleSubType
        SenderADAttributeContainsWords                = $SenderADAttributeContainsWords
        SenderADAttributeMatchesPatterns              = $SenderADAttributeMatchesPatterns
        SenderAddressLocation                         = $SenderAddressLocation
        SenderDomainIs                                = $SenderDomainIs
        SenderInRecipientList                         = $SenderInRecipientList
        SenderIpRanges                                = $SenderIpRanges
        SenderManagementRelationship                  = $SenderManagementRelationship
        SentTo                                        = $SentTo
        SentToMemberOf                                = $SentToMemberOf
        SentToScope                                   = $SentToScope
        SetAuditSeverity                              = $SetAuditSeverity
        SetHeaderName                                 = $SetHeaderName
        SetHeaderValue                                = $SetHeaderValue
        SetSCL                                        = $SetSCL
        StopRuleProcessing                            = $StopRuleProcessing
        SubjectContainsWords                          = $SubjectContainsWords
        SubjectMatchesPatterns                        = $SubjectMatchesPatterns
        SubjectOrBodyContainsWords                    = $SubjectOrBodyContainsWords
        SubjectOrBodyMatchesPatterns                  = $SubjectOrBodyMatchesPatterns
        WithImportance                                = $WithImportance
        Confirm                                       = $false
    }

    $SetTransportRuleParams = $NewTransportRuleParams.Clone()
    $SetTransportRuleParams.Add('Identity', $Name)

    # CASE: Transport Rule doesn't exist but should;
    if ($Ensure -eq "Present" -and $currentTransportRuleConfig.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Transport Rule '$($Name)' does not exist but it should. Create and configure it."
        # Create Transport Rule
        New-TransportRule @NewTransportRuleParams

    }
    # CASE: Transport Rule exists but it shouldn't;
    elseif ($Ensure -eq "Absent" -and $currentTransportRuleConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Transport Rule '$($Name)' exists but it shouldn't. Remove it."
        Remove-TransportRule -Identity $Name -Confirm:$false
    }
    # CASE: Transport Rule exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq "Present" -and $currentTransportRuleConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Transport Rule '$($Name)' already exists, but needs updating."
        Write-Verbose -Message "Setting Transport Rule $($Name) with values: $(Convert-M365DscHashtableToString  -Hashtable $SetTransportRuleParams)"
        Set-TransportRule @SetTransportRuleParams
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $ADComparisonAttribute,

        [Parameter()]
        [ValidateSet('Equal', 'NotEqual')]
        [System.String]
        $ADComparisonOperator,

        [Parameter()]
        [System.String]
        $ActivationDate,

        [Parameter()]
        [ValidateSet('To', 'Cc', 'Bcc', 'Redirect')]
        [System.String]
        $AddManagerAsRecipientType,

        [Parameter()]
        [System.String[]]
        $AddToRecipients = @(),

        [Parameter()]
        [System.String[]]
        $AnyOfCcHeader = @(),

        [Parameter()]
        [System.String[]]
        $AnyOfCcHeaderMemberOf = @(),

        [Parameter()]
        [System.String[]]
        $AnyOfRecipientAddressContainsWords,

        [Parameter()]
        [System.String[]]
        $AnyOfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $AnyOfToCcHeader = @(),

        [Parameter()]
        [System.String[]]
        $AnyOfToCcHeaderMemberOf = @(),

        [Parameter()]
        [System.String[]]
        $AnyOfToHeader = @(),

        [Parameter()]
        [System.String[]]
        $AnyOfToHeaderMemberOf = @(),

        [Parameter()]
        [System.String]
        $ApplyClassification,

        [Parameter()]
        [ValidateSet('Wrap', 'Ignore', 'Reject')]
        [System.String]
        $ApplyHtmlDisclaimerFallbackAction,

        [Parameter()]
        [ValidateSet('Append', 'Prepand')]
        [System.String]
        $ApplyHtmlDisclaimerLocation,

        [Parameter()]
        [System.String]
        $ApplyHtmlDisclaimerText,

        [Parameter()]
        [System.Boolean]
        $ApplyOME,

        [Parameter()]
        [System.String]
        $ApplyRightsProtectionTemplate,

        [Parameter()]
        [System.String[]]
        $AttachmentContainsWords,

        [Parameter()]
        [System.String[]]
        $AttachmentExtensionMatchesWords,

        [Parameter()]
        [System.Boolean]
        $AttachmentHasExecutableContent,

        [Parameter()]
        [System.Boolean]
        $AttachmentIsPasswordProtected,

        [Parameter()]
        [System.Boolean]
        $AttachmentIsUnsupported,

        [Parameter()]
        [System.String[]]
        $AttachmentMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $AttachmentNameMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $AttachmentPropertyContainsWords,

        [Parameter()]
        [System.Boolean]
        $AttachmentProcessingLimitExceeded,

        [Parameter()]
        [System.String]
        $AttachmentSizeOver,

        [Parameter()]
        [System.String[]]
        $BetweenMemberOf1 = @(),

        [Parameter()]
        [System.String[]]
        $BetweenMemberOf2 = @(),

        [Parameter()]
        [System.String[]]
        $BlindCopyTo = @(),

        [Parameter()]
        [ValidateLength(0, 1024)]
        [System.String]
        $Comments,

        [Parameter()]
        [System.String[]]
        $ContentCharacterSetContainsWords,

        [Parameter()]
        [System.String[]]
        $CopyTo = @(),

        [Parameter()]
        [System.Boolean]
        $DeleteMessage,

        [Parameter()]
        [System.String]
        $DlpPolicy,

        [Parameter()]
        [System.String]
        $ExceptIfADComparisonAttribute,

        [Parameter()]
        [ValidateSet('Equal', 'NotEqual')]
        [System.String]
        $ExceptIfADComparisonOperator,

        [Parameter()]
        [System.String[]]
        $ExceptIfAnyOfCcHeader = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfAnyOfCcHeaderMemberOf = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfAnyOfRecipientAddressContainsWords,

        [Parameter()]
        [System.String[]]
        $ExceptIfAnyOfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ExceptIfAnyOfToCcHeader = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfAnyOfToCcHeaderMemberOf = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfAnyOfToHeader = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfAnyOfToHeaderMemberOf = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfAttachmentContainsWords,

        [Parameter()]
        [System.String[]]
        $ExceptIfAttachmentExtensionMatchesWords,

        [Parameter()]
        [System.Boolean]
        $ExceptIfAttachmentHasExecutableContent,

        [Parameter()]
        [System.Boolean]
        $ExceptIfAttachmentIsPasswordProtected,

        [Parameter()]
        [System.Boolean]
        $ExceptIfAttachmentIsUnsupported,

        [Parameter()]
        [System.String[]]
        $ExceptIfAttachmentMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ExceptIfAttachmentNameMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ExceptIfAttachmentPropertyContainsWords,

        [Parameter()]
        [System.Boolean]
        $ExceptIfAttachmentProcessingLimitExceeded,

        [Parameter()]
        [System.String]
        $ExceptIfAttachmentSizeOver,

        [Parameter()]
        [System.String[]]
        $ExceptIfBetweenMemberOf1 = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfBetweenMemberOf2 = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfContentCharacterSetContainsWords = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfFrom = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfFromAddressContainsWords,

        [Parameter()]
        [System.String[]]
        $ExceptIfFromAddressMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ExceptIfFromMemberOf = @(),

        [Parameter()]
        [ValidateSet('InOrganization', 'NotInOrganization')]
        [System.String]
        $ExceptIfFromScope,

        [Parameter()]
        [System.String]
        $ExceptIfHasClassification,

        [Parameter()]
        [System.Boolean]
        $ExceptIfHasNoClassification,

        [Parameter()]
        [System.Boolean]
        $ExceptIfHasSenderOverride,

        [Parameter()]
        [System.String]
        $ExceptIfHeaderContainsMessageHeader,

        [Parameter()]
        [System.String[]]
        $ExceptIfHeaderContainsWords,

        [Parameter()]
        [System.String]
        $ExceptIfHeaderMatchesMessageHeader,

        [Parameter()]
        [System.String[]]
        $ExceptIfHeaderMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ExceptIfManagerAddresses = @(),

        [Parameter()]
        [System.String]
        $ExceptIfManagerForEvaluatedUser,

        [Parameter()]
        [ValidateSet('OOF', 'AutoForward', 'Encrypted', 'Calendaring', 'PermissionControlled', 'Voicemail', 'Signed', 'ApprovalRequest', 'ReadReceipt')]
        [System.String]
        $ExceptIfMessageTypeMatches,

        [Parameter()]
        [System.String[]]
        $ExceptIfMessageContainsAllDataClassifications = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfMessageContainsDataClassifications = @(),

        [Parameter()]
        [System.String]
        $ExceptIfMessageSizeOver,

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientADAttributeContainsWords,

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientADAttributeMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientAddressContainsWords,

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientAddressMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientInSenderList,

        [Parameter()]
        [System.String[]]
        $ExceptIfSenderADAttributeContainsWords,

        [Parameter()]
        [System.String[]]
        $ExceptIfSenderADAttributeMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ExceptIfSenderDomainIs,

        [Parameter()]
        [System.String[]]
        $ExceptIfSenderInRecipientList,

        [Parameter()]
        [System.String[]]
        $ExceptIfSenderIpRanges,

        [Parameter()]
        [ValidateSet('Manager', 'DirectReport')]
        [System.String]
        $ExceptIfSenderManagementRelationship,

        [Parameter()]
        [System.String[]]
        $ExceptIfSentTo = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentToMemberOf = @(),

        [Parameter()]
        [ValidateSet('InOrganization', 'NotInOrganization', 'ExternalPartner', 'ExternalNonPartner')]
        [System.String]
        $ExceptIfSentToScope,

        [Parameter()]
        [System.String[]]
        $ExceptIfSubjectContainsWords,

        [Parameter()]
        [System.String[]]
        $ExceptIfSubjectMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $ExceptIfSubjectOrBodyContainsWords,

        [Parameter()]
        [System.String[]]
        $ExceptIfSubjectOrBodyMatchesPatterns,

        [Parameter()]
        [ValidateSet('Low', 'Normal', 'High')]
        [System.String]
        $ExceptIfWithImportance,

        [Parameter()]
        [System.String]
        $ExpiryDate,

        [Parameter()]
        [System.String[]]
        $From = @(),

        [Parameter()]
        [System.String[]]
        $FromAddressContainsWords,

        [Parameter()]
        [System.String[]]
        $FromAddressMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $FromMemberOf = @(),

        [Parameter()]
        [ValidateSet('InOrganization', 'NotInOrganization')]
        [System.String]
        $FromScope,

        [Parameter()]
        [System.String]
        $GenerateIncidentReport,

        [Parameter()]
        [System.String]
        $GenerateNotification,

        [Parameter()]
        [System.String]
        $HasClassification,

        [Parameter()]
        [System.Boolean]
        $HasNoClassification,

        [Parameter()]
        [System.Boolean]
        $HasSenderOverride,

        [Parameter()]
        [System.String]
        $HeaderContainsMessageHeader,

        [Parameter()]
        [System.String[]]
        $HeaderContainsWords,

        [Parameter()]
        [System.String]
        $HeaderMatchesMessageHeader,

        [Parameter()]
        [System.String[]]
        $HeaderMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $IncidentReportContent,

        [Parameter()]
        [System.String[]]
        $IncidentReportOriginalMail,

        [Parameter()]
        [System.String[]]
        $ManagerAddresses = @(),

        [Parameter()]
        [ValidateSet('Recipient', 'Sender')]
        [System.String]
        $ManagerForEvaluatedUser,

        [Parameter()]
        [System.String[]]
        $MessageContainsAllDataClassifications,

        [Parameter()]
        [System.String[]]
        $MessageContainsDataClassifications,

        [Parameter()]
        [System.String]
        $MessageSizeOver,

        [Parameter()]
        [ValidateSet('OOF', 'AutoForward', 'Encrypted', 'Calendaring', 'PermissionControlled', 'Voicemail', 'Signed', 'ApprovalRequest', 'ReadReceipt')]
        [System.String]
        $MessageTypeMatches,

        [Parameter()]
        [ValidateSet('Audit', 'AuditAndNotify', 'Enforce')]
        [System.String]
        $Mode,

        [Parameter()]
        [System.Boolean]
        $ModerateMessageByManager,

        [Parameter()]
        [System.String[]]
        $ModerateMessageByUser = @(),

        [Parameter()]
        [ValidateSet('NotifyOnly', 'RejectMessage', 'RejectUnlessFalsePositiveOverride', 'RejectUnlessSilentOverride', 'RejectUnlessExplicitOverride')]
        [System.String]
        $NotifySender,

        [Parameter()]
        [System.String]
        $PrependSubject,

        [Parameter()]
        [System.String]
        $Priority,

        [Parameter()]
        [System.String[]]
        $RecipientADAttributeContainsWords,

        [Parameter()]
        [System.String[]]
        $RecipientADAttributeMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $RecipientAddressContainsWords,

        [Parameter()]
        [System.String[]]
        $RecipientAddressMatchesPatterns,

        [Parameter()]
        [System.String[]]
        $RecipientDomainIs,

        [Parameter()]
        [System.String[]]
        $RecipientInSenderList,

        [Parameter()]
        [System.String[]]
        $RedirectMessageTo = @(),

        [Parameter()]
        [System.String]
        $RejectMessageEnhancedStatusCode,

        [Parameter()]
        [System.String]
        $RejectMessageReasonText,

        [Parameter()]
        [System.String]
        $RemoveHeader,

        [Parameter()]
        [System.Boolean]
        $RemoveOME,

        [Parameter()]
        [System.Boolean]
        $RemoveOMEv2,

        [Parameter()]
        [System.String]
        $RouteMessageOutboundConnector,

        [Parameter()]
        [System.Boolean]
        $RouteMessageOutboundRequireTls,

        [Parameter()]
        [ValidateSet('Ignore', 'Defer')]
        [System.String]
        $RuleErrorAction,

        [Parameter()]
        [ValidateSet('Dlp', 'None')]
        [System.String]
        $RuleSubType,

        [Parameter()]
        [System.String[]]
        $SenderADAttributeContainsWords,

        [Parameter()]
        [System.String[]]
        $SenderADAttributeMatchesPatterns,

        [Parameter()]
        [ValidateSet('Header', 'Envelope', 'HeaderOrEnvelope')]
        [System.String]
        $SenderAddressLocation,

        [Parameter()]
        [System.String[]]
        $SenderDomainIs,

        [Parameter()]
        [System.String[]]
        $SenderInRecipientList,

        [Parameter()]
        [System.String[]]
        $SenderIpRanges,

        [Parameter()]
        [ValidateSet('Manager', 'DirectReport')]
        [System.String]
        $SenderManagementRelationship,

        [Parameter()]
        [System.String[]]
        $SentTo = @(),

        [Parameter()]
        [System.String[]]
        $SentToMemberOf = @(),

        [Parameter()]
        [ValidateSet('InOrganization', 'NotInOrganization', 'ExternalPartner', 'ExternalNonPartner')]
        [System.String]
        $SentToScope,

        [Parameter()]
        [ValidateSet('DoNotAudit', 'Low', 'Medium', 'High')]
        [System.String]
        $SetAuditSeverity,

        [Parameter()]
        [System.String]
        $SetHeaderName,

        [Parameter()]
        [System.String]
        $SetHeaderValue,

        [Parameter()]
        [System.String]
        $SetSCL,

        [Parameter()]
        [System.Boolean]
        $StopRuleProcessing,

        [Parameter()]
        [System.String[]]
        $SubjectContainsWords,

        [Parameter()]
        [System.String[]]
        $SubjectMatchesPatterns,

        [Parameter()]
        [System.String]
        $SubjectOrBodyContainsWords,

        [Parameter()]
        [System.String[]]
        $SubjectOrBodyMatchesPatterns,

        [Parameter()]
        [ValidateSet('Low', 'Normal', 'High')]
        [System.String]
        $WithImportance,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing Transport Rule configuration for $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString  -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString  -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $InformationPreference = 'Continue'
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    [array]$AllTransportRules = Get-TransportRule

    $dscContent = ""
    $i = 1
    foreach ($TransportRule in $AllTransportRules)
    {
        Write-Information "    [$i/$($AllTransportRules.Count)] $($TransportRule.Name)"

        $Params = @{
            Name               = $TransportRule.Name
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @Params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content = "        EXOTransportRule " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $content += "        }`r`n"
        $dscContent += $content
        $i++
    }
    return $dscContent
}

Export-ModuleMember -Function *-TargetResource

