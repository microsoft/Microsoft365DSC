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
    -DscResource "IntuneWindowsUpdateForBusinessQualityUpdateProfileWindows10" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgBetaDeviceManagementWindowsQualityUpdateProfile -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementWindowsQualityUpdateProfile -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceManagementWindowsQualityUpdateProfile -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false

            Mock -CommandName Get-MgBetaDeviceManagementWindowsQualityUpdateProfileAssignment -MockWith {
                return @(@{
                    Id       = '12345-12345-12345-12345-12345'
                    Source   = 'direct'
                    SourceId = '12345-12345-12345-12345-12345'
                    Target   = @{
                        DeviceAndAppManagementAssignmentFilterId   = $null
                        DeviceAndAppManagementAssignmentFilterType = 'none'
                        AdditionalProperties                       = @(
                            @{
                                '@odata.type' = '#microsoft.graph.exclusionGroupAssignmentTarget'
                                groupId       = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                            }
                        )
                    }
                })
            }

            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }

        }
        # Test contexts
        Context -Name "The IntuneWindowsUpdateForBusinessQualityUpdateProfileWindows10 should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            dataType     = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            groupId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                            deviceAndAppManagementAssignmentFilterType = 'none'
                        } -ClientOnly)
                    )
                    Description = "Description"
                    DisplayName = "IntuneQualityUpdate"
                    ExpeditedUpdateSettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphExpeditedWindowsQualityUpdateSettings -Property @{
                        DaysUntilForcedReboot = 0
                        QualityUpdateRelease = "2024-06-11T00:00:00Z"
                    } -ClientOnly)
                    Id = "FakeStringValue"
                    RoleScopeTagIds = @("0")
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementWindowsQualityUpdateProfile -MockWith {
                    return $null
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Create the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgBetaDeviceManagementWindowsQualityUpdateProfile -Exactly 1
            }
        }

        Context -Name "The IntuneWindowsUpdateForBusinessQualityUpdateProfileWindows10 exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            dataType     = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            groupId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                            deviceAndAppManagementAssignmentFilterType = 'none'
                        } -ClientOnly)
                    )
                    Description = "Description"
                    DisplayName = "IntuneQualityUpdate"
                    ExpeditedUpdateSettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphExpeditedWindowsQualityUpdateSettings -Property @{
                        DaysUntilForcedReboot = 0
                        QualityUpdateRelease = "2024-06-11T00:00:00Z"
                    } -ClientOnly)
                    Id = "FakeStringValue"
                    RoleScopeTagIds = @("0")
                    Ensure = 'Absent'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementWindowsQualityUpdateProfile -MockWith {
                    return @{
                        Description = "Description"
                        DisplayName = "IntuneQualityUpdate"
                        ExpeditedUpdateSettings = @{
                            DaysUntilForcedReboot = 0
                            QualityUpdateRelease = "2024-06-11T00:00:00Z"
                        }
                        Id = "FakeStringValue"
                        RoleScopeTagIds = @("0")
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementWindowsQualityUpdateProfile -Exactly 1
            }
        }
        Context -Name "The IntuneWindowsUpdateForBusinessQualityUpdateProfileWindows10 Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            dataType     = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            groupId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                            deviceAndAppManagementAssignmentFilterType = 'none'
                        } -ClientOnly)
                    )
                    Description = "Description"
                    DisplayName = "IntuneQualityUpdate"
                    ExpeditedUpdateSettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphExpeditedWindowsQualityUpdateSettings -Property @{
                        DaysUntilForcedReboot = 0
                        QualityUpdateRelease = "2024-06-11T00:00:00Z"
                    } -ClientOnly)
                    Id = "FakeStringValue"
                    RoleScopeTagIds = @("0")
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementWindowsQualityUpdateProfile -MockWith {
                    return @{
                        Description = "Description"
                        DisplayName = "IntuneQualityUpdate"
                        ExpeditedUpdateSettings = @{
                            DaysUntilForcedReboot = 0
                            QualityUpdateRelease = "2024-06-11T00:00:00Z"
                        }
                        Id = "FakeStringValue"
                        RoleScopeTagIds = @("0")
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The IntuneWindowsUpdateForBusinessQualityUpdateProfileWindows10 exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            dataType     = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            groupId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                            deviceAndAppManagementAssignmentFilterType = 'none'
                        } -ClientOnly)
                    )
                    Description = "Description"
                    DisplayName = "IntuneQualityUpdate"
                    ExpeditedUpdateSettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphExpeditedWindowsQualityUpdateSettings -Property @{
                        DaysUntilForcedReboot = 0
                        QualityUpdateRelease = "2024-06-11T00:00:00Z"
                    } -ClientOnly)
                    Id = "FakeStringValue"
                    RoleScopeTagIds = @("0")
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementWindowsQualityUpdateProfile -MockWith {
                    return @{
                        Description = "Description"
                        DisplayName = "IntuneQualityUpdate"
                        ExpeditedUpdateSettings = @{
                            DaysUntilForcedReboot = 1 #drift
                            QualityUpdateRelease = "2024-06-11T00:00:00Z"
                        }
                        Id = "FakeStringValue"
                        RoleScopeTagIds = @("0")
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgBetaDeviceManagementWindowsQualityUpdateProfile -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementWindowsQualityUpdateProfile -MockWith {
                    return @{
                        Description = "Description"
                        DisplayName = "IntuneQualityUpdate"
                        ExpeditedUpdateSettings = @{
                            DaysUntilForcedReboot = 0
                            QualityUpdateRelease = "2024-06-11T00:00:00Z"
                        }
                        Id = "FakeStringValue"
                        RoleScopeTagIds = @("0")
                    }
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
