﻿# AADEntitlementManagementAccessPackageAssignmentPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | The display name of the policy. | |
| **Id** | Write | String | Id of the access package assignment policy. | |
| **AccessPackageId** | Write | String | Identifier of the access package. | |
| **AccessReviewSettings** | Write | MSFT_MicrosoftGraphassignmentreviewsettings | Who must review, and how often, the assignments to the access package from this policy. This property is null if reviews are not required. | |
| **CanExtend** | Write | Boolean | Indicates whether a user can extend the access package assignment duration after approval. | |
| **Description** | Write | String | The description of the policy. | |
| **DurationInDays** | Write | UInt32 | The number of days in which assignments from this policy last until they are expired. | |
| **ExpirationDateTime** | Write | String | The expiration date for assignments created in this policy. The Timestamp type represents date and time information using ISO 8601 format and is always in UTC time. For example, midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z | |
| **Questions** | Write | MSFT_MicrosoftGraphaccesspackagequestion[] | Questions that are posed to the requestor. | |
| **RequestApprovalSettings** | Write | MSFT_MicrosoftGraphapprovalsettings | Who must approve requests for access package in this policy. | |
| **RequestorSettings** | Write | MSFT_MicrosoftGraphrequestorsettings | Who can request this access package from this policy. | |
| **CustomExtensionHandlers** | Write | MSFT_MicrosoftGraphcustomextensionhandler[] | The collection of stages when to execute one or more custom access package workflow extensions. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Intune Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

### MSFT_MicrosoftGraphassignmentreviewsettings

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **AccessReviewTimeoutBehavior** | Write | String | The default decision to apply if the request is not reviewed within the period specified in durationInDays. | `acceptAccessRecommendation`, `keepAccess`, `removeAccess`, `unknownFutureValue` |
| **DurationInDays** | Write | UInt32 | The number of days within which reviewers should provide input. | |
| **IsAccessRecommendationEnabled** | Write | Boolean | Specifies whether to display recommendations to the reviewer. The default value is true | |
| **IsApprovalJustificationRequired** | Write | Boolean | Specifies whether the reviewer must provide justification for the approval. The default value is true. | |
| **IsEnabled** | Write | Boolean | If true, access reviews are required for assignments from this policy. | |
| **RecurrenceType** | Write | String | The interval for recurrence, such as monthly or quarterly. | |
| **ReviewerType** | Write | String | Who should be asked to do the review, either Self or Reviewers. | |
| **Reviewers** | Write | MSFT_MicrosoftGraphuserset[] | If the reviewerType is Reviewers, this collection specifies the users who will be reviewers, either by ID or as members of a group, using a collection of singleUser and groupMembers. | |
| **StartDateTime** | Write | String | When the first review should start. | |

### MSFT_MicrosoftGraphuserset

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **odataType** | Write | String | The type of the resource | `#microsoft.graph.singleUser`, `#microsoft.graph.groupMembers`, `#microsoft.graph.requestorManager`, `#microsoft.graph.internalSponsors`, `#microsoft.graph.externalSponsors`, `#microsoft.graph.connectedOrganizationMembers` |
| **Id** | Write | String | The id of the resource. | |
| **IsBackup** | Write | Boolean | Indicates whether the resource is a backup fallback approver. | |
| **ManagerLevel** | Write | UInt32 | The hierarchical level of the manager with respect to the requestor. For example, the direct manager of a requestor would have a managerLevel of 1, while the manager of the requestor's manager would have a managerLevel of 2. Default value for managerLevel is 1. Possible values for this property range from 1 to 2. | |

### MSFT_MicrosoftGraphaccesspackagequestion

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **odataType** | Write | String | The type of the resource | `#microsoft.graph.accessPackageMultipleChoiceQuestion`, `#microsoft.graph.accessPackageTextInputQuestion` |
| **Id** | Write | String | ID of the question. | |
| **IsAnswerEditable** | Write | Boolean | Specifies whether the requestor is allowed to edit answers to questions. | |
| **IsRequired** | Write | Boolean | Whether the requestor is required to supply an answer or not. | |
| **Sequence** | Write | UInt32 | Relative position of this question when displaying a list of questions to the requestor. | |
| **QuestionText** | Write | MSFT_MicrosoftGraphaccessPackageLocalizedContent | The text of the question to show to the requestor. | |
| **Choices** | Write | MSFT_MicrosoftGraphaccessPackageAnswerChoice[] | List of answer choices. | |
| **AllowsMultipleSelection** | Write | Boolean | Indicates whether requestor can select multiple choices as their answer. | |
| **RegexPattern** | Write | String | This is the regex pattern that the corresponding text answer must follow. | |
| **IsSingleLineQuestion** | Write | Boolean | Indicates whether the answer will be in single or multiple line format. | |

### MSFT_MicrosoftGraphaccessPackageLocalizedContent

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DefaultText** | Write | String | The fallback string, which is used when a requested localization is not available. Required. | |
| **LocalizedTexts** | Write | MSFT_MicrosoftGraphaccessPackageLocalizedText[] | Content represented in a format for a specific locale. | |

### MSFT_MicrosoftGraphaccessPackageLocalizedText

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Text** | Write | String | The text in the specific language. Required. | |
| **LanguageCode** | Write | String | The ISO code for the intended language. Required. | |

### MSFT_MicrosoftGraphaccessPackageAnswerChoice

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **ActualValue** | Write | String | The actual value of the selected choice. This is typically a string value which is understandable by applications. Required. | |
| **displayValue** | Write | MSFT_MicrosoftGraphaccessPackageLocalizedContent | The localized display values shown to the requestor and approvers. Required. | |

### MSFT_MicrosoftGraphapprovalsettings

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **ApprovalMode** | Write | String | One of SingleStage, Serial, Parallel, NoApproval (default). NoApproval is used when isApprovalRequired is false. | `SingleStage`, `Serial`, `Parallel`, `NoApproval` |
| **ApprovalStages** | Write | MSFT_MicrosoftGraphapprovalstage1[] | If approval is required, the one or two elements of this collection define each of the stages of approval. An empty array if no approval is required. | |
| **IsApprovalRequired** | Write | Boolean | Indicates whether approval is required for requests in this policy. | |
| **IsApprovalRequiredForExtension** | Write | Boolean | Indicates whether approval is required for a user to extend their assignment. | |
| **IsRequestorJustificationRequired** | Write | Boolean | Indicates whether the requestor is required to supply a justification in their request. | |

### MSFT_MicrosoftGraphapprovalstage1

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **ApprovalStageTimeOutInDays** | Write | UInt32 | The number of days that a request can be pending a response before it is automatically denied. | |
| **EscalationTimeInMinutes** | Write | UInt32 | Indicates whether the approver is required to provide a justification for approving a request. | |
| **IsApproverJustificationRequired** | Write | Boolean | If true, then one or more escalation approvers are configured in this approval stage. | |
| **IsEscalationEnabled** | Write | Boolean | If escalation is required, the time a request can be pending a response from a primary approver. | |
| **PrimaryApprovers** | Write | MSFT_MicrosoftGraphuserset[] | The users who will be asked to approve requests. A collection of singleUser, groupMembers, requestorManager, internalSponsors and externalSponsors. When creating or updating a policy, include at least one userSet in this collection. | |
| **EscalationApprovers** | Write | MSFT_MicrosoftGraphuserset[] | If escalation is enabled and the primary approvers do not respond before the escalation time, the escalationApprovers are the users who will be asked to approve requests. This can be a collection of singleUser, groupMembers, requestorManager, internalSponsors and externalSponsors. When creating or updating a policy, if there are no escalation approvers, or escalation approvers are not required for the stage, the value of this property should be an empty collection. | |

### MSFT_MicrosoftGraphrequestorsettings

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **AcceptRequests** | Write | Boolean | Indicates whether new requests are accepted on this policy. | |
| **AllowedRequestors** | Write | MSFT_MicrosoftGraphuserset[] | The users who are allowed to request on this policy, which can be singleUser, groupMembers, and connectedOrganizationMembers. | |
| **ScopeType** | Write | String | Who can request. | `NoSubjects`, `SpecificDirectorySubjects`, `SpecificConnectedOrganizationSubjects`, `AllConfiguredConnectedOrganizationSubjects`, `AllExistingConnectedOrganizationSubjects`, `AllExistingDirectoryMemberUsers`, `AllExistingDirectorySubjects`, `AllExternalSubjects` |

### MSFT_MicrosoftGraphcustomextensionhandler

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **CustomExtensionId** | Write | String | Indicates which custom workflow extension will be executed at this stage. | |
| **Stage** | Write | String | Indicates the stage of the access package assignment request workflow when the access package custom extension runs. | `assignmentRequestCreated`, `assignmentRequestApproved`, `assignmentRequestGranted`, `assignmentRequestRemoved`, `assignmentFourteenDaysBeforeExpiration`, `assignmentOneDayBeforeExpiration`, `unknownFutureValue` |
| **Id** | Write | String | Identifier of the stage. | |


## Description

This resource configures an Azure AD Entitlement Management Access Package Assignment Policy.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - EntitlementManagement.Read.All

- **Update**

    - EntitlementManagement.ReadWrite.All

#### Application permissions

- **Read**

    - EntitlementManagement.Read.All

- **Update**

    - EntitlementManagement.ReadWrite.All

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
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADEntitlementManagementAccessPackageAssignmentPolicy "myAssignmentPolicyWithAccessReviewsSettings"
        {
            AccessPackageId         = "5d05114c-b4d9-4ae7-bda6-4bade48e60f2";
            AccessReviewSettings    = MSFT_MicrosoftGraphassignmentreviewsettings{
                IsEnabled = $True
                StartDateTime = '12/17/2022 23:59:59'
                IsAccessRecommendationEnabled = $True
                AccessReviewTimeoutBehavior = 'keepAccess'
                IsApprovalJustificationRequired = $True
                ReviewerType = 'Self'
                RecurrenceType = 'quarterly'
                Reviewers = @()
                DurationInDays = 25
            };
            CanExtend               = $False;
            Description             = "";
            DisplayName             = "External tenant";
            DurationInDays          = 365;
            Id                      = "0ae0bc7c-bae7-4e3b-9ed3-216b767efbb3";
            RequestApprovalSettings = MSFT_MicrosoftGraphapprovalsettings{
                ApprovalMode = 'NoApproval'
                IsRequestorJustificationRequired = $False
                IsApprovalRequired = $False
                IsApprovalRequiredForExtension = $False
            };
            RequestorSettings       = MSFT_MicrosoftGraphrequestorsettings{
                AllowedRequestors = @(
                    MSFT_MicrosoftGraphuserset{
                        IsBackup = $False
                        Id = 'e27eb9b9-27c3-462d-8d65-3bcd763b0ed0'
                        odataType = '#microsoft.graph.connectedOrganizationMembers'
                    }
                )
                AcceptRequests = $True
                ScopeType = 'SpecificConnectedOrganizationSubjects'
            };
            Ensure                     = "Present"
            Credential                 = $Credscredential
        }
    }
}
```

### Example 2

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADEntitlementManagementAccessPackageAssignmentPolicy "MyAssignmentPolicyWithQuestionsAndCulture"
        {
            AccessPackageId         = "5d05114c-b4d9-4ae7-bda6-4bade48e60f2";
            CanExtend               = $False;
            Credential              = $Credscredential
            Description             = "Initial Policy";
            DisplayName             = "Initial Policy";
            DurationInDays          = 365;
            Ensure                  = "Present";
            Id                      = "d46bda47-ec8e-4b62-8d94-3cd13e267a61";
            Questions               = @(
                MSFT_MicrosoftGraphaccesspackagequestion{
                    AllowsMultipleSelection = $False
                    Id = '8475d987-535d-43a1-a7d7-96b7fd0edda9'
                    QuestionText = MSFT_MicrosoftGraphaccesspackagelocalizedcontent{
                        LocalizedTexts = @(
                            MSFT_MicrosoftGraphaccessPackageLocalizedText{
                                Text = 'My Question'
                                LanguageCode = 'en-GB'
                            }

                            MSFT_MicrosoftGraphaccessPackageLocalizedText{
                                Text = 'Ma question'
                                LanguageCode = 'fr-FR'
                            }
                        )
                        DefaultText = 'My question'
                    }
                    IsRequired = $True
                    Choices = @(
                        MSFT_MicrosoftGraphaccessPackageAnswerChoice{
                            displayValue = MSFT_MicrosoftGraphaccessPackageLocalizedContent{
                                localizedTexts = @(
                                    MSFT_MicrosoftGraphaccessPackageLocalizedText{
                                        text = 'Yes'
                                        languageCode = 'en-GB'
                                    }

                                    MSFT_MicrosoftGraphaccessPackageLocalizedText{
                                        text = 'Oui'
                                        languageCode = 'fr-FR'
                                    }
									MSFT_MicrosoftGraphaccessPackageLocalizedText{
                                        text = 'Ya'
                                        languageCode = 'de'
                                    }
                                )
                                defaultText = 'Yes'
                            }
                            actualValue = 'Yes'
                        }

                        MSFT_MicrosoftGraphaccessPackageAnswerChoice{
                            displayValue = MSFT_MicrosoftGraphaccessPackageLocalizedContent{
                                localizedTexts = @(
                                    MSFT_MicrosoftGraphaccessPackageLocalizedText{
                                        text = 'No'
                                        languageCode = 'en-GB'
                                    }
                                    MSFT_MicrosoftGraphaccessPackageLocalizedText{
                                        text = 'Non'
                                        languageCode = 'fr-FR'
                                    }
									MSFT_MicrosoftGraphaccessPackageLocalizedText{
                                        text = 'Nein'
                                        languageCode = 'de'
                                    }
                                )
                                defaultText = 'No'
                            }
                            actualValue = 'No'
                        }
                    )
                    Sequence = 0
                    odataType = '#microsoft.graph.accessPackageMultipleChoiceQuestion'
                }
            );
            RequestApprovalSettings = MSFT_MicrosoftGraphapprovalsettings{
                ApprovalMode = 'NoApproval'
                IsRequestorJustificationRequired = $False
                IsApprovalRequired = $False
                IsApprovalRequiredForExtension = $False
            };
            RequestorSettings       = MSFT_MicrosoftGraphrequestorsettings{
                AcceptRequests = $False
                ScopeType = 'NoSubjects'
            };
        }
    }
}
```

