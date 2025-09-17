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
    -DscResource "IntuneDeviceComplianceScriptLinux" -GenericStubModule $GenericStubPath
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

            Mock -CommandName Invoke-MgGraphRequest -ParameterFilter { $Uri -like "*/reusablePolicySettings/*" } -MockWith {
                return @{
                    id = 'FakeStringValue'
                    displayName = 'FakeStringValue'
                    description = 'FakeStringValue'
                    settingDefinitionId = 'linux_customcompliance_discoveryscript_reusablesetting'
                    settingInstance = @{
                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                        settingInstanceTemplateReference = $null
                        simpleSettingValue = @{
                            value = 'I2Jpbi9iYXNoCmVjaG8gZmFsc2U='
                        }
                    }
                }
            }

            Mock -CommandName Invoke-MgGraphRequest -MockWith {
                return @{
                    value = @(
                        @{
                            id = 'FakeStringValue'
                            displayName = 'FakeStringValue'
                            description = 'FakeStringValue'
                            settingDefinitionId = 'linux_customcompliance_discoveryscript_reusablesetting'
                            settingInstance = @{
                                '@odata.type' = '#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance'
                                settingInstanceTemplateReference = $null
                                simpleSettingValue = @{
                                    value = 'I2Jpbi9iYXNoCmVjaG8gZmFsc2U='
                                }
                            }
                        }
                    )
                }
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
        Context -Name "The IntuneDeviceComplianceScriptLinux should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Id = "FakeStringValue"
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    DiscoveryScript = '#bin/bash
echo false'
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                    return $null
                }

                Mock -CommandName Invoke-MgGraphRequest -ParameterFilter { $Uri -like "*/reusablePolicySettings?*" } -MockWith {
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
                Should -Invoke -CommandName Invoke-MgGraphRequest -Exactly 3
            }
        }

        Context -Name "The IntuneDeviceComplianceScriptLinux exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Id = "FakeStringValue"
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    DiscoveryScript = '#bin/bash
echo false'
                    Ensure = "Absent"
                    Credential = $Credential;
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Invoke-MgGraphRequest -Exactly 2
            }
        }

        Context -Name "The IntuneDeviceComplianceScriptLinux Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Id = "FakeStringValue"
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    DiscoveryScript = '#bin/bash
echo false'
                    Ensure = "Present"
                    Credential = $Credential;
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The IntuneDeviceComplianceScriptLinux exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Id = "FakeStringValue"
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    DiscoveryScript = '#bin/bash
echo true'
                    Ensure = "Present"
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
                Should -Invoke -CommandName Invoke-MgGraphRequest -Exactly 2
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
