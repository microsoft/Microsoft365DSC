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
    -DscResource "IntuneManagedInstallerPolicyWindows10" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -ModuleName M365DSCUtil -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-MSCloudLoginConnectionProfile -MockWith {
            }

            Mock -CommandName Reset-MSCloudLoginConnectionProfileContext -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Invoke-MgGraphRequest -MockWith {
                return @{
                    error = "Forbidden"
                }
            }

            Mock -CommandName Remove-MgBetaDeviceManagementDeviceHealthScript -MockWith {
            }

            Mock -CommandName Update-MgBetaDeviceManagementDeviceHealthScript -MockWith {
            }

            Mock -CommandName Get-MgBetaDeviceManagementDeviceHealthScript -ParameterFilter { $null -ne $DeviceHealthScriptId -or $null -ne $Filter  } -MockWith {
                return @{
                    Description = "FakeStringValue"
                    DetectionScriptContent = $null
                    DetectionScriptParameters = @(
                        @{
                            '@odata.type' = "#microsoft.graph.deviceHealthScriptStringParameter"
                            DefaultValue = $True
                            IsRequired = $True
                            Description = "Enable Managed Installer"
                            Name = "Enabled"
                            ApplyDefaultValueWhenNotAssigned = $True
                        }
                    )
                    DeviceHealthScriptType = "managedInstallerScript"
                    DisplayName = "FakeStringValue"
                    EnforceSignatureCheck = $True
                    Id = "FakeStringValue"
                    IsGlobalScript = $False
                    Publisher = "Microsoft"
                    RemediationScriptContent = $null
                    RemediationScriptParameters = @()
                    RoleScopeTagIds = @("FakeStringValue")
                    RunAs32Bit = $True
                    RunAsAccount = "system"
                }
            }

            Mock -CommandName Get-MgBetaDeviceManagementDeviceHealthScriptAssignment -MockWith {
                return @(
                    @{
                        Id = "FakeStringValue"
                        RunRemediationScript = $False
                        RunSchedule = $null
                        Target = @{
                            '@odata.type' = "#microsoft.graph.groupAssignmentTarget"
                            groupId = "FakeStringValue"
                            "DeviceAndAppManagementAssignmentFilterId" = "FakeStringValue"
                            "DeviceAndAppManagementAssignmentFilterType" = "none"
                        }
                    }
                )
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            # Mock Write-M365DSCHost to hide output during the tests
            Mock -CommandName Write-M365DSCHost -MockWith {
            }
            $Script:exportedInstance = $null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "The IntuneManagedInstallerPolicyWindows10 should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName DeviceManagementConfigurationPolicyAssignments -Property @{
                            deviceAndAppManagementAssignmentFilterId = 'FakeStringValue'
                            deviceAndAppManagementAssignmentFilterType = 'none'
                            dataType = '#microsoft.graph.groupAssignmentTarget'
                            groupId = 'FakeStringValue'
                        } -ClientOnly)
                    )
                    IsIntuneManagedInstaller = $true
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    RoleScopeTagIds = @("FakeStringValue")
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceHealthScript -ParameterFilter { $DeviceHealthScriptId -eq 'FakeStringValue' } -MockWith {
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
                Should -Invoke -CommandName Invoke-MgGraphRequest -Exactly 1
            }
        }

        Context -Name "The IntuneManagedInstallerPolicyWindows10 exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName DeviceManagementConfigurationPolicyAssignments -Property @{
                            deviceAndAppManagementAssignmentFilterId = 'FakeStringValue'
                            deviceAndAppManagementAssignmentFilterType = 'none'
                            dataType = '#microsoft.graph.groupAssignmentTarget'
                            groupId = 'FakeStringValue'
                        } -ClientOnly)
                    )
                    IsIntuneManagedInstaller = $true
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    RoleScopeTagIds = @("FakeStringValue")
                    Ensure = 'Absent'
                    Credential = $Credential;
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementDeviceHealthScript -Exactly 1
            }
        }

        Context -Name "The IntuneManagedInstallerPolicyWindows10 Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName DeviceManagementConfigurationPolicyAssignments -Property @{
                            deviceAndAppManagementAssignmentFilterId = 'FakeStringValue'
                            deviceAndAppManagementAssignmentFilterType = 'none'
                            dataType = '#microsoft.graph.groupAssignmentTarget'
                            groupId = 'FakeStringValue'
                        } -ClientOnly)
                    )
                    IsIntuneManagedInstaller = $true
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    RoleScopeTagIds = @("FakeStringValue")
                    Ensure = 'Present'
                    Credential = $Credential;
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The IntuneManagedInstallerPolicyWindows10 exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName DeviceManagementConfigurationPolicyAssignments -Property @{
                            deviceAndAppManagementAssignmentFilterId = 'FakeStringValue'
                            deviceAndAppManagementAssignmentFilterType = 'none'
                            dataType = '#microsoft.graph.groupAssignmentTarget'
                            groupId = 'FakeStringValue'
                        } -ClientOnly)
                    )
                    IsIntuneManagedInstaller = $false # Drift
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    RoleScopeTagIds = @("FakeStringValue")
                    Ensure = 'Present'
                    Credential = $Credential;
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
                Should -Invoke -CommandName Update-MgBetaDeviceManagementDeviceHealthScript -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
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
