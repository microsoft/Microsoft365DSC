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
    -DscResource 'IntuneApplicationControlPolicyWindows10' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {

            $secpasswd = ConvertTo-SecureString 'Pass@word1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Remove-MgBetaDeviceManagementIntent -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementIntent -MockWith {
            }

            Mock -CommandName Update-MgBetaDeviceManagementIntent -MockWith {
            }
            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }
            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name "When the App Configuration Policy doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName = 'Test App Configuration Policy'
                    Description = 'Test Definition'
                    Ensure      = 'Present'
                    Credential  = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntentSetting -MockWith {
                    return $null
                }
                Mock -CommandName Get-MgBetaDeviceManagementIntentAssignment -MockWith {
                    return $null
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create the App Configuration Policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-MgBetaDeviceManagementIntent' -Exactly 1
            }
        }

        Context -Name 'When the policy already exists and is NOT in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName = 'Test App Configuration Policy'
                    Description = 'Test Definition'
                    Assignments = [CimInstance[]]@(New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                        groupId  = '123456789'
                        dataType = '#microsoft.graph.groupAssignmentTarget'
                        deviceAndAppManagementAssignmentFilterType = 'include'
                        deviceAndAppManagementAssignmentFilterId = '123456789'
                    } -ClientOnly)
                    Ensure      = 'Present'
                    Credential  = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntent -MockWith {
                    return @{
                        Id          = 'A_19dbaff5-9aff-48b0-a60d-d0471ddaf141'
                        TemplateId  = '63be6324-e3c9-4c97-948a-e7f4b96f0f20'
                        DisplayName = 'Test App Configuration Policy'
                        Description = 'Different Value'
                    }
                }
                Mock -CommandName Get-MgBetaDeviceManagementIntentSetting -MockWith {
                    return @(@{
                        #DisplayName  = 'Test App Configuration Policy'
                        #Description  = 'Different Value'
                        #Id           = 'A_19dbaff5-9aff-48b0-a60d-d0471ddaf141'
                        DefinitionId = 'appLockerApplicationControl'
                        ValueJSON    = "'true'"
                    })
                }
                Mock -CommandName Get-MgBetaDeviceManagementIntentAssignment -MockWith {
                    return @(
                        @{
                            Target = @{
                                AdditionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.groupAssignmentTarget'
                                    groupId       = '123456789'
                                }
                                DeviceAndAppManagementAssignmentFilterType = 'include'
                                DeviceAndAppManagementAssignmentFilterId   = '123456789'
                            }
                        }
                    )
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update the App Configuration Policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgBetaDeviceManagementIntent -Exactly 1
            }
        }

        Context -Name 'When the policy already exists and IS in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName = 'Test App Configuration Policy'
                    Description = 'Test Definition'
                    Assignments = (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                        groupId  = '123456789'
                        dataType = '#microsoft.graph.groupAssignmentTarget'
                        deviceAndAppManagementAssignmentFilterType = 'include'
                        deviceAndAppManagementAssignmentFilterId = '123456789'
                    } -ClientOnly)
                    Ensure      = 'Present'
                    Credential  = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntent -MockWith {
                    return @{
                        DisplayName = 'Test App Configuration Policy'
                        Description = 'Test Definition'
                        Id          = 'A_19dbaff5-9aff-48b0-a60d-d0471ddaf141'
                        TemplateId  = '63be6324-e3c9-4c97-948a-e7f4b96f0f20'
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntentSetting -MockWith {
                    return @(@{
                        DisplayName  = 'Test App Configuration Policy'
                        Description  = 'Test Definition'
                        Id           = 'A_19dbaff5-9aff-48b0-a60d-d0471ddaf141'
                        DefinitionId = 'appLockerApplicationControl'
                        ValueJSON    = "'true'"
                    })
                }
                Mock -CommandName Get-MgBetaDeviceManagementIntentAssignment -MockWith {
                    return @(
                        @{
                            Target = @{
                                AdditionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.groupAssignmentTarget'
                                    groupId       = '123456789'
                                }
                                DeviceAndAppManagementAssignmentFilterType = 'include'
                                DeviceAndAppManagementAssignmentFilterId   = '123456789'
                            }
                        }
                    )
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'When the policy exists and it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName = 'Test App Configuration Policy'
                    Description = 'Test Definition'
                    Assignments = (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                        groupId  = '123456789'
                        dataType = '#microsoft.graph.groupAssignmentTarget'
                        deviceAndAppManagementAssignmentFilterType = 'include'
                        deviceAndAppManagementAssignmentFilterId = '123456789'
                    } -ClientOnly)
                    Ensure      = 'Absent'
                    Credential  = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntent -MockWith {
                    return @{
                        DisplayName = 'Test App Configuration Policy'
                        Description = 'Test Definition'
                        Id          = 'A_19dbaff5-9aff-48b0-a60d-d0471ddaf141'
                        TemplateId  = '63be6324-e3c9-4c97-948a-e7f4b96f0f20'
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntentSetting -MockWith {
                    return @{
                        DisplayName  = 'Test App Configuration Policy'
                        Description  = 'Test Definition'
                        Id           = 'A_19dbaff5-9aff-48b0-a60d-d0471ddaf141'
                        DefinitionId = 'appLockerApplicationControl'
                        ValueJSON    = "'true'"
                    }
                }
                Mock -CommandName Get-MgBetaDeviceManagementIntentAssignment -MockWith {
                    return @(
                        @{
                            Target = @{
                                AdditionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.groupAssignmentTarget'
                                    groupId       = '123456789'
                                }
                                DeviceAndAppManagementAssignmentFilterType = 'include'
                                DeviceAndAppManagementAssignmentFilterId   = '123456789'
                            }
                        }
                    )
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the App Configuration Policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementIntent -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntent -MockWith {
                    return @{
                        DisplayName = 'Test App Configuration Policy'
                        Description = 'Test Definition'
                        Id          = 'A_19dbaff5-9aff-48b0-a60d-d0471ddaf141'
                        TemplateId  = '63be6324-e3c9-4c97-948a-e7f4b96f0f20'
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntentSetting -MockWith {
                    return @{
                        DisplayName  = 'Test App Configuration Policy'
                        Description  = 'Test Definition'
                        Id           = 'A_19dbaff5-9aff-48b0-a60d-d0471ddaf141'
                        DefinitionId = 'appLockerApplicationControl'
                        ValueJSON    = "'true'"
                    }
                }
                Mock -CommandName Get-MgBetaDeviceManagementIntentAssignment -MockWith {
                    return @(
                        @{
                            Target = @{
                                AdditionalProperties = @{
                                    '@odata.type' = '#microsoft.graph.groupAssignmentTarget'
                                    groupId       = '123456789'
                                }
                                DeviceAndAppManagementAssignmentFilterType = 'include'
                                DeviceAndAppManagementAssignmentFilterId   = '123456789'
                            }
                        }
                    )
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
