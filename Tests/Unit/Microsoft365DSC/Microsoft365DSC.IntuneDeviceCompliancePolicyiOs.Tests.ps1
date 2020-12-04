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
    -DscResource "IntuneDeviceCompliancePolicyiOs" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "Pass@word1" -AsPlainText -Force
            $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }

            Mock -CommandName Update-DeviceManagement_DeviceCompliancePolicies -MockWith {
            }
            Mock -CommandName New-DeviceManagement_DeviceCompliancePolicies -MockWith {
            }
            Mock -CommandName Remove-DeviceManagement_DeviceCompliancePolicies -MockWith {
            }

            # Test contexts
            Context -Name "When the iOS Device Compliance Policy doesn't already exist" -Fixture {
                BeforeAll {
                    $testParams = @{
                        DisplayName                                 = 'Test iOS Device Compliance Policy'
                        Description                                 = 'Test iOS Device Compliance Policy Description'
                        passcodeBlockSimple                         = $True
                        passcodeExpirationDays                      = 365
                        passcodeMinimumLength                       = 6
                        passcodeMinutesOfInactivityBeforeLock       = 5
                        passcodePreviousPasscodeBlockCount          = 3
                        passcodeMinimumCharacterSetCount            = 2
                        passcodeRequiredType                        = 'numeric'
                        passcodeRequired                            = $True
                        osMinimumVersion                            = 10
                        osMaximumVersion                            = 12
                        securityBlockJailbrokenDevices              = $True
                        deviceThreatProtectionEnabled               = $True
                        deviceThreatProtectionRequiredSecurityLevel = 'medium'
                        managedEmailProfileRequired                 = $True
                        Ensure                                      = 'Present'
                        GlobalAdminAccount                          = $GlobalAdminAccount
                    }

                    Mock -CommandName Get-DeviceManagement_DeviceCompliancePolicies -MockWith {
                        return $null
                    }
                }

                It "Should return absent from the Get method" {
                    (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
                }

                It "Should return false from the Test method" {
                    Test-TargetResource @testParams | Should -Be $false
                }

                It "Should create the iOS Device Compliance Policy from the Set method" {
                    Set-TargetResource @testParams
                    Should -Invoke -CommandName "New-DeviceManagement_DeviceCompliancePolicies" -Exactly 1
                }
            }

            Context -Name "When the iOS Device Compliance Policy already exists and is NOT in the Desired State" -Fixture {
                BeforeAll {
                    $testParams = @{
                        DisplayName                                 = 'Test iOS Device Compliance Policy'
                        Description                                 = 'Test iOS Device Compliance Policy Description'
                        passcodeBlockSimple                         = $True
                        passcodeExpirationDays                      = 365
                        passcodeMinimumLength                       = 6
                        passcodeMinutesOfInactivityBeforeLock       = 5
                        passcodePreviousPasscodeBlockCount          = 3
                        passcodeMinimumCharacterSetCount            = 2
                        passcodeRequiredType                        = 'numeric'
                        passcodeRequired                            = $True
                        osMinimumVersion                            = 10
                        osMaximumVersion                            = 12
                        securityBlockJailbrokenDevices              = $True
                        deviceThreatProtectionEnabled               = $True
                        deviceThreatProtectionRequiredSecurityLevel = 'medium'
                        managedEmailProfileRequired                 = $True
                        Ensure                                      = 'Present'
                        GlobalAdminAccount                          = $GlobalAdminAccount
                    }

                    Mock -CommandName Get-DeviceManagement_DeviceCompliancePolicies -MockWith {
                        return @{
                            DisplayName                                 = 'Test iOS Device Compliance Policy'
                            Description                                 = 'Different Value'
                            id                                          = '9c4e2ed7-706e-4874-a826-0c2778352d45'
                            deviceCompliancePolicyId                    = '9c4e2ed7-706e-4874-a826-0c2778352d45'
                            passcodeBlockSimple                         = $True
                            passcodeExpirationDays                      = 365
                            passcodeMinimumLength                       = 6
                            passcodeMinutesOfInactivityBeforeLock       = 5
                            passcodePreviousPasscodeBlockCount          = 3
                            passcodeMinimumCharacterSetCount            = 2
                            passcodeRequiredType                        = 'numeric'
                            passcodeRequired                            = $True
                            osMinimumVersion                            = 10
                            osMaximumVersion                            = 12
                            securityBlockJailbrokenDevices              = $True
                            deviceThreatProtectionEnabled               = $True
                            deviceThreatProtectionRequiredSecurityLevel = 'medium'
                            managedEmailProfileRequired                 = $True
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
                    Should -Invoke -CommandName Update-DeviceManagement_DeviceCompliancePolicies -Exactly 1
                }
            }

            Context -Name "When the policy already exists and IS in the Desired State" -Fixture {
                BeforeAll {
                    $testParams = @{
                        DisplayName                                 = 'Test iOS Device Compliance Policy'
                        Description                                 = 'Test iOS Device Compliance Policy Description'
                        passcodeBlockSimple                         = $True
                        passcodeExpirationDays                      = 365
                        passcodeMinimumLength                       = 6
                        passcodeMinutesOfInactivityBeforeLock       = 5
                        passcodePreviousPasscodeBlockCount          = 3
                        passcodeMinimumCharacterSetCount            = 2
                        passcodeRequiredType                        = 'numeric'
                        passcodeRequired                            = $True
                        osMinimumVersion                            = 10
                        osMaximumVersion                            = 12
                        securityBlockJailbrokenDevices              = $True
                        deviceThreatProtectionEnabled               = $True
                        deviceThreatProtectionRequiredSecurityLevel = 'medium'
                        managedEmailProfileRequired                 = $True
                        Ensure                                      = 'Present'
                        GlobalAdminAccount                          = $GlobalAdminAccount
                    }

                    Mock -CommandName Get-DeviceManagement_DeviceCompliancePolicies -MockWith {
                        return @{
                            DisplayName                                 = 'Test iOS Device Compliance Policy'
                            Description                                 = 'Test iOS Device Compliance Policy Description'
                            id                                          = '9c4e2ed7-706e-4874-a826-0c2778352d45'
                            deviceCompliancePolicyId                    = '9c4e2ed7-706e-4874-a826-0c2778352d45'
                            passcodeBlockSimple                         = $True
                            passcodeExpirationDays                      = 365
                            passcodeMinimumLength                       = 6
                            passcodeMinutesOfInactivityBeforeLock       = 5
                            passcodePreviousPasscodeBlockCount          = 3
                            passcodeMinimumCharacterSetCount            = 2
                            passcodeRequiredType                        = 'numeric'
                            passcodeRequired                            = $True
                            osMinimumVersion                            = 10
                            osMaximumVersion                            = 12
                            securityBlockJailbrokenDevices              = $True
                            deviceThreatProtectionEnabled               = $True
                            deviceThreatProtectionRequiredSecurityLevel = 'medium'
                            managedEmailProfileRequired                 = $True
                        }
                    }
                }

                It "Should return true from the Test method" {
                    Test-TargetResource @testParams | Should -Be $true
                }
            }

            Context -Name "When the policy exists and it SHOULD NOT" -Fixture {
                BeforeAll {
                    $testParams = @{
                        DisplayName                                 = 'Test iOS Device Compliance Policy'
                        Description                                 = 'Test iOS Device Compliance Policy Description'
                        passcodeBlockSimple                         = $True
                        passcodeExpirationDays                      = 365
                        passcodeMinimumLength                       = 6
                        passcodeMinutesOfInactivityBeforeLock       = 5
                        passcodePreviousPasscodeBlockCount          = 3
                        passcodeMinimumCharacterSetCount            = 2
                        passcodeRequiredType                        = 'numeric'
                        passcodeRequired                            = $True
                        osMinimumVersion                            = 10
                        osMaximumVersion                            = 12
                        securityBlockJailbrokenDevices              = $True
                        deviceThreatProtectionEnabled               = $True
                        deviceThreatProtectionRequiredSecurityLevel = 'medium'
                        managedEmailProfileRequired                 = $True
                        Ensure                                      = 'Absent'
                        GlobalAdminAccount                          = $GlobalAdminAccount
                    }

                    Mock -CommandName Get-DeviceManagement_DeviceCompliancePolicies -MockWith {
                        return @{
                            DisplayName                                 = 'Test iOS Device Compliance Policy'
                            Description                                 = 'Test iOS Device Compliance Policy Description'
                            id                                          = '9c4e2ed7-706e-4874-a826-0c2778352d45'
                            deviceCompliancePolicyId                    = '9c4e2ed7-706e-4874-a826-0c2778352d45'
                            passcodeBlockSimple                         = $True
                            passcodeExpirationDays                      = 365
                            passcodeMinimumLength                       = 6
                            passcodeMinutesOfInactivityBeforeLock       = 5
                            passcodePreviousPasscodeBlockCount          = 3
                            passcodeMinimumCharacterSetCount            = 2
                            passcodeRequiredType                        = 'numeric'
                            passcodeRequired                            = $True
                            osMinimumVersion                            = 10
                            osMaximumVersion                            = 12
                            securityBlockJailbrokenDevices              = $True
                            deviceThreatProtectionEnabled               = $True
                            deviceThreatProtectionRequiredSecurityLevel = 'medium'
                            managedEmailProfileRequired                 = $True
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
                    Should -Invoke -CommandName Remove-DeviceManagement_DeviceCompliancePolicies -Exactly 1
                }
            }

            Context -Name "ReverseDSC Tests" -Fixture {
                BeforeAll {
                    $testParams = @{
                        GlobalAdminAccount = $GlobalAdminAccount;
                    }

                    Mock -CommandName Get-DeviceManagement_DeviceCompliancePolicies -MockWith {
                        return @{
                            DisplayName                                 = 'Test iOS Device Compliance Policy'
                            Description                                 = 'Test iOS Device Compliance Policy Description'
                            id                                          = '9c4e2ed7-706e-4874-a826-0c2778352d45'
                            deviceCompliancePolicyId                    = '9c4e2ed7-706e-4874-a826-0c2778352d45'
                            passcodeBlockSimple                         = $True
                            passcodeExpirationDays                      = 365
                            passcodeMinimumLength                       = 6
                            passcodeMinutesOfInactivityBeforeLock       = 5
                            passcodePreviousPasscodeBlockCount          = 3
                            passcodeMinimumCharacterSetCount            = 2
                            passcodeRequiredType                        = 'numeric'
                            passcodeRequired                            = $True
                            osMinimumVersion                            = 10
                            osMaximumVersion                            = 12
                            securityBlockJailbrokenDevices              = $True
                            deviceThreatProtectionEnabled               = $True
                            deviceThreatProtectionRequiredSecurityLevel = 'medium'
                            managedEmailProfileRequired                 = $True
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
