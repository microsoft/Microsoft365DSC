[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
                        -ChildPath '..\..\Unit' `
                        -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
            -ChildPath '\Stubs\Microsoft365.psm1' `
            -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
    -ChildPath '\Stubs\Generic.psm1' `
    -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\UnitTestHelper.psm1' `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "AADGroupEligibilityScheduleSettings" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@onmicrosoft.com', $secpasswd)

            Mock -ModuleName M365DSCUtil -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgBetaPolicyRoleManagementPolicyRule -MockWith {
            }

            Mock -CommandName Get-M365DSCUserPrincipalNameById -MockWith {
                return 'FakeStringValue'
            }

            Mock -CommandName Get-M365DSCUserIdByPrincipalName -MockWith {
                return '00000000-0000-0000-0000-000000000001'
            }

            Mock -CommandName Get-MgBetaRoleManagementDirectoryRoleDefinition -MockWith {
                return @{
                    Id = "FakeStringValue"
                }
            }

            Mock -CommandName Get-MgBetaPolicyRoleManagementPolicyAssignment -MockWith {
                return @{
                    PolicyId = "FakeStringValue"
                }
            }

            Mock -CommandName Get-MgBetaPolicyRoleManagementPolicyRule -MockWith {
                return @{
                    '@odata.type' = "#microsoft.graph.unifiedRoleManagementPolicyApprovalRule"
                    setting = @{
                        approvalStages = @(
                            @{
                                approvalStageTimeOutInDays = 1
                                escalationApprovers = @(
                                    @{
                                        '@odata.type' = "#microsoft.graph.singleUser"
                                        id = "FakeStringValue"
                                    }
                                )
                                isEscalationEnabled = $True
                                isApproverJustificationRequired = $True
                                escalationTimeInMinutes = 1
                            }
                        )
                        isApprovalRequired = $True
                        isApprovalRequiredForExtension = $True
                        approvalMode = "FakeStringValue"
                        isRequestorJustificationRequired = $True
                    }
                    id = "FakeStringValue"
                }
            }

            Mock -CommandName New-M365DSCConnection -ModuleName '_Shared' -MockWith {
                return "Credentials"
            }

            # Mock Write-M365DSCHost to hide output during the tests
            Mock -CommandName Write-M365DSCHost -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        Context -Name "The AADGroupEligibilityScheduleSettings Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    id = "FakeStringValue"
                    groupDisplayName = "FakeStringValue"
                    ruleType = "#microsoft.graph.unifiedRoleManagementPolicyApprovalRule"
                    approvalRule = ([MSFT_AADRoleManagementPolicyApprovalRule] @{
                        setting = ([MSFT_AADRoleManagementPolicyApprovalSettings] @{
                            approvalMode = "FakeStringValue"
                            isApprovalRequired = $true
                            isApprovalRequiredForExtension = $true
                            isRequestorJustificationRequired = $true
                            approvalStages = @(
                                ([MSFT_AADRoleManagementPolicyApprovalStage] @{
                                    approvalStageTimeOutInDays = 1
                                    escalationTimeInMinutes = 1
                                    isApproverJustificationRequired = $true
                                    isEscalationEnabled = $true
                                    escalationApprovers = @(
                                        ([MSFT_AADRoleManagementPolicySubjectSet] @{
                                            odataType = "#microsoft.graph.singleUser"
                                            id = "FakeStringValue"
                                        })
                                    )
                                })
                            )
                        })
                    })
                    PIMGroupRole = "member";
                    Credential = $Credential;
                }
            }

            It 'Should return true from the Test method' {
                (New-M365DSCResourceInstance -ResourceName 'AADGroupEligibilityScheduleSettings' -Property $testParams).Test() | Should -Be $true
                Should -Invoke -CommandName Get-M365DSCUserPrincipalNameById
            }
        }

        Context -Name "The AADGroupEligibilityScheduleSettings exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    id = "FakeStringValue"
                    groupDisplayName = "FakeStringValue"
                    ruleType = "#microsoft.graph.unifiedRoleManagementPolicyApprovalRule"
                    approvalRule = ([MSFT_AADRoleManagementPolicyApprovalRule] @{
                        setting = ([MSFT_AADRoleManagementPolicyApprovalSettings] @{
                            approvalMode = "FakeStringValue"
                            isApprovalRequired = $false #drift
                            isApprovalRequiredForExtension = $true
                            isRequestorJustificationRequired = $true
                            approvalStages = @(
                                ([MSFT_AADRoleManagementPolicyApprovalStage] @{
                                    approvalStageTimeOutInDays = 1
                                    escalationTimeInMinutes = 1
                                    isApproverJustificationRequired = $true
                                    isEscalationEnabled = $true
                                    escalationApprovers = @(
                                        ([MSFT_AADRoleManagementPolicySubjectSet] @{
                                            odataType = "#microsoft.graph.singleUser"
                                            id = "FakeStringValue"
                                        })
                                    )
                                })
                            )
                        })
                    })
                    PIMGroupRole = "member";
                    Credential = $Credential;
                }
            }

            It 'Should return false from the Test method' {
                (New-M365DSCResourceInstance -ResourceName 'AADGroupEligibilityScheduleSettings' -Property $testParams).Test() | Should -Be $false
            }

            It 'Should call the Set method' {
                (New-M365DSCResourceInstance -ResourceName 'AADGroupEligibilityScheduleSettings' -Property $testParams).Set()
                Should -Invoke -CommandName Update-MgBetaPolicyRoleManagementPolicyRule -Exactly 1
                Should -Invoke -CommandName Get-M365DSCUserIdByPrincipalName -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-M365DSCExportCachedCollection -ParameterFilter { $Collection -eq 'pimGroups' } -MockWith {
                    return @(
                        [PSCustomObject]@{
                            Id          = 'FakeStringValue'
                            DisplayName = 'FakeStringValue'
                        }
                    )
                }

                Mock -CommandName Invoke-M365DSCGraphBatchRequest -MockWith {
                    return @(
                        @{
                            id = "FakeStringValue"
                            body = @{
                                value = @{
                                    roleDefinitionId = "owner"
                                    policy = @{
                                        rules = @(
                                            @{
                                                id = "FakeStringValue"
                                                '@odata.type' = "#microsoft.graph.unifiedRoleManagementPolicyApprovalRule"
                                                setting = @{
                                                    approvalStages = @(
                                                        @{
                                                            approvalStageTimeOutInDays = 1
                                                            escalationApprovers = @(
                                                                @{
                                                                    '@odata.type' = "#microsoft.graph.singleUser"
                                                                    id = "FakeStringValue"
                                                                }
                                                            )
                                                            isEscalationEnabled = $True
                                                            isApproverJustificationRequired = $True
                                                            escalationTimeInMinutes = 1
                                                        }
                                                    )
                                                    isApprovalRequired = $True
                                                    isApprovalRequiredForExtension = $True
                                                    approvalMode = "FakeStringValue"
                                                    isRequestorJustificationRequired = $True
                                                }
                                            }
                                        )
                                    }
                                }
                            }
                        }
                    )
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                $result = Invoke-M365DSCResourceMethod -ResourceName 'AADGroupEligibilityScheduleSettings' -MethodName 'Export' -Parameters $testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
