[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
                        -ChildPath "..\..\Unit" `
                        -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
            -ChildPath "\Stubs\Microsoft365.psm1" `
            -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
    -ChildPath "\Stubs\Generic.psm1" `
    -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath "\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "AADEntitlementManagementAccessPackageAssignmentPolicy" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ("tenantadmin@mydomain.com", $secpasswd)


            #Mock -CommandName Get-M365DSCExportContentForResource -MockWith {
            #}

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgEntitlementManagementAccessPackageAssignmentPolicy -MockWith {
            }

            Mock -CommandName New-MgEntitlementManagementAccessPackageAssignmentPolicy -MockWith {
            }

            Mock -CommandName Remove-MgEntitlementManagementAccessPackageAssignmentPolicy -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }
        }
        # Test contexts
        Context -Name "The AADEntitlementManagementAccessPackageAssignmentPolicy should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                        AccessPackageId = "FakeStringValue"
                        AccessReviewSettings =(New-CimInstance -ClassName MSFT_MicrosoftGraphassignmentreviewsettings -Property @{
                            isEnabled = $True
                            isAccessRecommendationEnabled = $True
                            isApprovalJustificationRequired = $True
                            recurrenceType = "FakeStringValue"
                            reviewerType = "FakeStringValue"
                            durationInDays = 25

                        } -ClientOnly)
                        CanExtend = $True
                        CustomExtensionHandlers =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphcustomextensionhandler -Property @{
                            isArray = $True
                            CIMType = "MSFT_MicrosoftGraphcustomextensionhandler"

                            } -ClientOnly)
                        )
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        DurationInDays = 25
                        Id = "FakeStringValue"
                        Questions =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphaccesspackagequestion -Property @{
                                allowsMultipleSelection = $True
                                isAnswerEditable = $True
                                id = "FakeStringValue"
                                regexPattern = "FakeStringValue"
                                isSingleLineQuestion = $True
                                isRequired = $True
                                odataType = "#microsoft.graph.accessPackageMultipleChoiceQuestion"
                                sequence = 25

                            } -ClientOnly)
                        )
                        RequestApprovalSettings =(New-CimInstance -ClassName MSFT_MicrosoftGraphapprovalsettings -Property @{
                            approvalMode = "FakeStringValue"
                            isRequestorJustificationRequired = $True
                            isApprovalRequiredForExtension = $True
                            isApprovalRequired = $True

                        } -ClientOnly)
                        RequestorSettings =(New-CimInstance -ClassName MSFT_MicrosoftGraphrequestorsettings -Property @{
                            scopeType = "FakeStringValue"
                            acceptRequests = $True

                        } -ClientOnly)

                    Ensure                        = "Present"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgEntitlementManagementAccessPackageAssignmentPolicy -MockWith {
                    return $null
                }
            }
            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Create the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgEntitlementManagementAccessPackageAssignmentPolicy -Exactly 1
            }
        }

        Context -Name "The AADEntitlementManagementAccessPackageAssignmentPolicy exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                        AccessPackageId = "FakeStringValue"
                        AccessReviewSettings =(New-CimInstance -ClassName MSFT_MicrosoftGraphassignmentreviewsettings -Property @{
                            isEnabled = $True
                            isAccessRecommendationEnabled = $True
                            isApprovalJustificationRequired = $True
                            recurrenceType = "FakeStringValue"
                            reviewerType = "FakeStringValue"
                            durationInDays = 25

                        } -ClientOnly)
                        CanExtend = $True
                        CustomExtensionHandlers =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphcustomextensionhandler -Property @{
                            isArray = $True
                            CIMType = "MSFT_MicrosoftGraphcustomextensionhandler"

                            } -ClientOnly)
                        )
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        DurationInDays = 25
                        Id = "FakeStringValue"
                        Questions =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphaccesspackagequestion -Property @{
                                allowsMultipleSelection = $True
                                isAnswerEditable = $True
                                id = "FakeStringValue"
                                regexPattern = "FakeStringValue"
                                isSingleLineQuestion = $True
                                isRequired = $True
                                odataType = "#microsoft.graph.accessPackageMultipleChoiceQuestion"
                                sequence = 25

                            } -ClientOnly)
                        )
                        RequestApprovalSettings =(New-CimInstance -ClassName MSFT_MicrosoftGraphapprovalsettings -Property @{
                            approvalMode = "FakeStringValue"
                            isRequestorJustificationRequired = $True
                            isApprovalRequiredForExtension = $True
                            isApprovalRequired = $True

                        } -ClientOnly)
                        RequestorSettings =(New-CimInstance -ClassName MSFT_MicrosoftGraphrequestorsettings -Property @{
                            scopeType = "FakeStringValue"
                            acceptRequests = $True

                        } -ClientOnly)

                    Ensure                        = "Absent"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgEntitlementManagementAccessPackageAssignmentPolicy -MockWith {
                    return @{
                        AccessPackageId = "FakeStringValue"
                        AccessReviewSettings =(New-CimInstance -ClassName MSFT_MicrosoftGraphassignmentreviewsettings -Property @{
                            isEnabled = $True
                            isAccessRecommendationEnabled = $True
                            isApprovalJustificationRequired = $True
                            recurrenceType = "FakeStringValue"
                            reviewerType = "FakeStringValue"
                            durationInDays = 25

                        } -ClientOnly)
                        CanExtend = $True
                        CustomExtensionHandlers =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphcustomextensionhandler -Property @{
                            isArray = $True
                            CIMType = "MSFT_MicrosoftGraphcustomextensionhandler"

                            } -ClientOnly)
                        )
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        DurationInDays = 25
                        Id = "FakeStringValue"
                        Questions =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphaccesspackagequestion -Property @{
                                allowsMultipleSelection = $True
                                isAnswerEditable = $True
                                id = "FakeStringValue"
                                regexPattern = "FakeStringValue"
                                isSingleLineQuestion = $True
                                '@odata.type' = "#microsoft.graph.accessPackageMultipleChoiceQuestion"
                                isRequired = $True
                                sequence = 25

                            } -ClientOnly)
                        )
                        RequestApprovalSettings =(New-CimInstance -ClassName MSFT_MicrosoftGraphapprovalsettings -Property @{
                            approvalMode = "FakeStringValue"
                            isRequestorJustificationRequired = $True
                            isApprovalRequiredForExtension = $True
                            isApprovalRequired = $True

                        } -ClientOnly)
                        RequestorSettings =(New-CimInstance -ClassName MSFT_MicrosoftGraphrequestorsettings -Property @{
                            scopeType = "FakeStringValue"
                            acceptRequests = $True

                        } -ClientOnly)

                    }
                }
            }

            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgEntitlementManagementAccessPackageAssignmentPolicy -Exactly 1
            }
        }
        Context -Name "The AADEntitlementManagementAccessPackageAssignmentPolicy Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                        AccessPackageId = "FakeStringValue"
                        AccessReviewSettings =(New-CimInstance -ClassName MSFT_MicrosoftGraphassignmentreviewsettings -Property @{
                            isEnabled = $True
                            isAccessRecommendationEnabled = $True
                            isApprovalJustificationRequired = $True
                            recurrenceType = "FakeStringValue"
                            reviewerType = "FakeStringValue"
                            durationInDays = 25

                        } -ClientOnly)
                        CanExtend = $True
                        CustomExtensionHandlers =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphcustomextensionhandler -Property @{
                            isArray = $True
                            CIMType = "MSFT_MicrosoftGraphcustomextensionhandler"

                            } -ClientOnly)
                        )
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        DurationInDays = 25
                        Id = "FakeStringValue"
                        Questions =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphaccesspackagequestion -Property @{
                                allowsMultipleSelection = $True
                                isAnswerEditable = $True
                                id = "FakeStringValue"
                                regexPattern = "FakeStringValue"
                                isSingleLineQuestion = $True
                                isRequired = $True
                                odataType = "#microsoft.graph.accessPackageMultipleChoiceQuestion"
                                sequence = 25

                            } -ClientOnly)
                        )
                        RequestApprovalSettings =(New-CimInstance -ClassName MSFT_MicrosoftGraphapprovalsettings -Property @{
                            approvalMode = "FakeStringValue"
                            isRequestorJustificationRequired = $True
                            isApprovalRequiredForExtension = $True
                            isApprovalRequired = $True

                        } -ClientOnly)
                        RequestorSettings =(New-CimInstance -ClassName MSFT_MicrosoftGraphrequestorsettings -Property @{
                            scopeType = "FakeStringValue"
                            acceptRequests = $True

                        } -ClientOnly)

                    Ensure                        = "Present"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgEntitlementManagementAccessPackageAssignmentPolicy -MockWith {
                    return @{
                        AccessPackageId = "FakeStringValue"
                        AccessReviewSettings =(New-CimInstance -ClassName MSFT_MicrosoftGraphassignmentreviewsettings -Property @{
                            isEnabled = $True
                            isAccessRecommendationEnabled = $True
                            isApprovalJustificationRequired = $True
                            recurrenceType = "FakeStringValue"
                            reviewerType = "FakeStringValue"
                            durationInDays = 25

                        } -ClientOnly)
                        CanExtend = $True
                        CustomExtensionHandlers =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphcustomextensionhandler -Property @{
                            isArray = $True
                            CIMType = "MSFT_MicrosoftGraphcustomextensionhandler"

                            } -ClientOnly)
                        )
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        DurationInDays = 25
                        Id = "FakeStringValue"
                        Questions =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphaccesspackagequestion -Property @{
                                allowsMultipleSelection = $True
                                isAnswerEditable = $True
                                id = "FakeStringValue"
                                regexPattern = "FakeStringValue"
                                isSingleLineQuestion = $True
                                '@odata.type' = "#microsoft.graph.accessPackageMultipleChoiceQuestion"
                                isRequired = $True
                                sequence = 25

                            } -ClientOnly)
                        )
                        RequestApprovalSettings =(New-CimInstance -ClassName MSFT_MicrosoftGraphapprovalsettings -Property @{
                            approvalMode = "FakeStringValue"
                            isRequestorJustificationRequired = $True
                            isApprovalRequiredForExtension = $True
                            isApprovalRequired = $True

                        } -ClientOnly)
                        RequestorSettings =(New-CimInstance -ClassName MSFT_MicrosoftGraphrequestorsettings -Property @{
                            scopeType = "FakeStringValue"
                            acceptRequests = $True

                        } -ClientOnly)

                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The AADEntitlementManagementAccessPackageAssignmentPolicy exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                        AccessPackageId = "FakeStringValue"
                        AccessReviewSettings =(New-CimInstance -ClassName MSFT_MicrosoftGraphassignmentreviewsettings -Property @{
                            isEnabled = $True
                            isAccessRecommendationEnabled = $True
                            isApprovalJustificationRequired = $True
                            recurrenceType = "FakeStringValue"
                            reviewerType = "FakeStringValue"
                            durationInDays = 25

                        } -ClientOnly)
                        CanExtend = $True
                        CustomExtensionHandlers =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphcustomextensionhandler -Property @{
                            isArray = $True
                            CIMType = "MSFT_MicrosoftGraphcustomextensionhandler"

                            } -ClientOnly)
                        )
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        DurationInDays = 25
                        Id = "FakeStringValue"
                        Questions =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphaccesspackagequestion -Property @{
                                allowsMultipleSelection = $True
                                isAnswerEditable = $True
                                id = "FakeStringValue"
                                regexPattern = "FakeStringValue"
                                isSingleLineQuestion = $True
                                isRequired = $True
                                odataType = "#microsoft.graph.accessPackageMultipleChoiceQuestion"
                                sequence = 25

                            } -ClientOnly)
                        )
                        RequestApprovalSettings =(New-CimInstance -ClassName MSFT_MicrosoftGraphapprovalsettings -Property @{
                            approvalMode = "FakeStringValue"
                            isRequestorJustificationRequired = $True
                            isApprovalRequiredForExtension = $True
                            isApprovalRequired = $True

                        } -ClientOnly)
                        RequestorSettings =(New-CimInstance -ClassName MSFT_MicrosoftGraphrequestorsettings -Property @{
                            scopeType = "FakeStringValue"
                            acceptRequests = $True

                        } -ClientOnly)

                    Ensure                = "Present"
                    Credential            = $Credential;
                }

                Mock -CommandName Get-MgEntitlementManagementAccessPackageAssignmentPolicy -MockWith {
                    return @{
                        AdditionalProperties =@{
                            '@odata.type' = "#microsoft.graph."
                            AccessReviewSettings =@{
                                isEnabled = $True
                                isAccessRecommendationEnabled = $True
                                isApprovalJustificationRequired = $True
                                recurrenceType = "FakeStringValue"
                                reviewerType = "FakeStringValue"
                                durationInDays = 25

                            }
                            DurationInDays = 7
                            AccessPackageId = "FakeStringValue"
                            RequestApprovalSettings =@{
                                approvalMode = "FakeStringValue"
                                isRequestorJustificationRequired = $True
                                isApprovalRequiredForExtension = $True
                                isApprovalRequired = $True

                            }
                            Questions =@(
                                @{
                                    allowsMultipleSelection = $True
                                    isAnswerEditable = $True
                                    id = "FakeStringValue"
                                    regexPattern = "FakeStringValue"
                                    isSingleLineQuestion = $True
                                    '@odata.type' = "#microsoft.graph.accessPackageMultipleChoiceQuestion"
                                    isRequired = $True
                                    sequence = 25

                                }
                            )
                            RequestorSettings =@{
                                scopeType = "FakeStringValue"
                                acceptRequests = $True

                            }
                            CustomExtensionHandlers =@(
                                @{
                                isArray = $True

                                }
                            )

                        }
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"

                    }
                }
            }

            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgEntitlementManagementAccessPackageAssignmentPolicy -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgEntitlementManagementAccessPackageAssignmentPolicy -MockWith {
                    return @{
                        AccessPackageId = "FakeStringValue"
                        AccessReviewSettings =(New-CimInstance -ClassName MSFT_MicrosoftGraphassignmentreviewsettings -Property @{
                            isEnabled = $True
                            isAccessRecommendationEnabled = $True
                            isApprovalJustificationRequired = $True
                            recurrenceType = "FakeStringValue"
                            reviewerType = "FakeStringValue"
                            durationInDays = 25

                        } -ClientOnly)
                        CanExtend = $True
                        CustomExtensionHandlers =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphcustomextensionhandler -Property @{
                            isArray = $True
                            CIMType = "MSFT_MicrosoftGraphcustomextensionhandler"

                            } -ClientOnly)
                        )
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        DurationInDays = 25
                        Id = "FakeStringValue"
                        Questions =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphaccesspackagequestion -Property @{
                                allowsMultipleSelection = $True
                                isAnswerEditable = $True
                                id = "FakeStringValue"
                                regexPattern = "FakeStringValue"
                                isSingleLineQuestion = $True
                                '@odata.type' = "#microsoft.graph.accessPackageMultipleChoiceQuestion"
                                isRequired = $True
                                sequence = 25

                            } -ClientOnly)
                        )
                        RequestApprovalSettings =(New-CimInstance -ClassName MSFT_MicrosoftGraphapprovalsettings -Property @{
                            approvalMode = "FakeStringValue"
                            isRequestorJustificationRequired = $True
                            isApprovalRequiredForExtension = $True
                            isApprovalRequired = $True

                        } -ClientOnly)
                        RequestorSettings =(New-CimInstance -ClassName MSFT_MicrosoftGraphrequestorsettings -Property @{
                            scopeType = "FakeStringValue"
                            acceptRequests = $True

                        } -ClientOnly)

                    }
                }
            }
            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
