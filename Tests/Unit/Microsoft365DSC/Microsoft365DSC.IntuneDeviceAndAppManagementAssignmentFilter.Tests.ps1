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
    -DscResource "IntuneDeviceAndAppManagementAssignmentFilter" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "Pass@word1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            Mock -CommandName Update-MgDeviceManagementAssignmentFilter -MockWith {
            }
            Mock -CommandName New-MgDeviceManagementAssignmentFilter -MockWith {
            }
            Mock -CommandName Remove-MgDeviceManagementAssignmentFilter -MockWith {
            }

            # Test contexts
            Context -Name "When the Filter doesn't already exist" -Fixture {
                BeforeAll {
                    $testParams = @{
                        Description          = "Test";
                        DisplayName          = "Test Device Filter";
                        Ensure               = "Present";
                        Platform             = "windows10AndLater";
                        Rule                 = "(device.manufacturer -ne `"bibi`")";
                        Credential           = $Credential
                    }

                    Mock -CommandName Get-MgDeviceManagementAssignmentFilter -MockWith {
                        return $null
                    }
                }

                It "Should return absent from the Get method" {
                    (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
                }

                It "Should return false from the Test method" {
                    Test-TargetResource @testParams | Should -Be $false
                }

                It "Should create the Android Device Compliance Policy from the Set method" {
                    Set-TargetResource @testParams
                    Should -Invoke -CommandName "New-MgDeviceManagementAssignmentFilter" -Exactly 1
                }
            }

            Context -Name "When the Filter already exists and is NOT in the Desired State" -Fixture {
                BeforeAll {
                    $testParams = @{
                        Description          = "Test";
                        DisplayName          = "Test Device Filter";
                        Ensure               = "Present";
                        Platform             = "windows10AndLater";
                        Rule                 = "(device.manufacturer -ne `"bibi`")";
                        Credential           = $Credential
                    }

                    Mock -CommandName Get-MgDeviceManagementAssignmentFilter -MockWith {
                        return @{
                            Description          = "Test";
                            DisplayName          = "Test Device Filter";
                            Platform             = "windows10AndLater";
                            Rule                 = "(device.manufacturer -ne `"test`")"; #drift
                        }
                    }
                }

                It "Should return Present from the Get method" {
                    (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
                }

                It "Should return false from the Test method" {
                    Test-TargetResource @testParams | Should -Be $false
                }

                It "Should update the iOS Device Compliance Policy from the Set method" {
                    Set-TargetResource @testParams
                    Should -Invoke -CommandName 'Update-MgDeviceManagementAssignmentFilter' -Exactly 1
                }
            }

            Context -Name "When the filter already exists and IS in the Desired State" -Fixture {
                BeforeAll {
                    $testParams = @{
                        Description          = "Test";
                        DisplayName          = "Test Device Filter";
                        Ensure               = "Present";
                        Platform             = "windows10AndLater";
                        Rule                 = "(device.manufacturer -ne `"bibi`")";
                        Credential           = $Credential
                    }

                    Mock -CommandName Get-MgDeviceManagementAssignmentFilter -MockWith {
                        return @{
                            Description          = "Test";
                            DisplayName          = "Test Device Filter";
                            Platform             = "windows10AndLater";
                            Rule                 = "(device.manufacturer -ne `"bibi`")";
                        }
                    }
                }

                It "Should return true from the Test method" {
                    Test-TargetResource @testParams | Should -Be $true
                }
            }

            Context -Name "When the filter exists and it SHOULD NOT" -Fixture {
                BeforeAll {
                    $testParams = @{
                        Description          = "Test";
                        DisplayName          = "Test Device Filter";
                        Ensure               = "Absent";
                        Platform             = "windows10AndLater";
                        Rule                 = "(device.manufacturer -ne `"bibi`")";
                        Credential           = $Credential
                    }

                    Mock -CommandName Get-MgDeviceManagementAssignmentFilter -MockWith {
                        return @{
                            Description          = "Test";
                            DisplayName          = "Test Device Filter";
                            Platform             = "windows10AndLater";
                            Rule                 = "(device.manufacturer -ne `"bibi`")";
                        }
                    }
                }

                It "Should return Present from the Get method" {
                    (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
                }

                It "Should return true from the Test method" {
                    Test-TargetResource @testParams | Should -Be $false
                }

                It "Should remove the iOS Device Compliance Policy from the Set method" {
                    Set-TargetResource @testParams
                    Should -Invoke -CommandName 'Remove-MgDeviceManagementAssignmentFilter' -Exactly 1
                }
            }

            Context -Name "ReverseDSC Tests" -Fixture {
                BeforeAll {
                    $testParams = @{
                        Credential = $Credential;
                    }

                    Mock -CommandName Get-MgDeviceManagementAssignmentFilter -MockWith {
                        return @{
                            Description          = "Test";
                            DisplayName          = "Test Device Filter";
                            Platform             = "windows10AndLater";
                            Rule                 = "(device.manufacturer -ne `"bibi`")";
                        }
                    }
                }

                It "Should Reverse Engineer resource from the Export method" {
                    Export-TargetResource @testParams
                }
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
