<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

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
