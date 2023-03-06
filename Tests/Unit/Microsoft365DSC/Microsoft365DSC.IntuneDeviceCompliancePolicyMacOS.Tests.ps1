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
    -DscResource 'IntuneDeviceCompliancePolicyMacOs' -GenericStubModule $GenericStubPath

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

            Mock -CommandName Update-MgDeviceManagementDeviceCompliancePolicy -MockWith {
            }

            Mock -CommandName New-MgDeviceManagementDeviceCompliancePolicy -MockWith {
            }

            Mock -CommandName Remove-MgDeviceManagementDeviceCompliancePolicy -MockWith {
            }

            Mock -CommandName Get-MGDeviceManagementDeviceCompliancePolicyAssignment -MockWith {

                return @()
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name "When the iOS Device Compliance Policy doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName                                 = 'MacOS DSC Policy'
                    Description                                 = 'Test policy'
                    PasswordRequired                            = $False
                    PasswordBlockSimple                         = $False
                    PasswordExpirationDays                      = 365
                    PasswordMinimumLength                       = 6
                    PasswordMinutesOfInactivityBeforeLock       = 5
                    PasswordPreviousPasswordBlockCount          = 13
                    PasswordMinimumCharacterSetCount            = 1
                    PasswordRequiredType                        = 'DeviceDefault'
                    OsMinimumVersion                            = 10
                    OsMaximumVersion                            = 13
                    SystemIntegrityProtectionEnabled            = $False
                    DeviceThreatProtectionEnabled               = $False
                    DeviceThreatProtectionRequiredSecurityLevel = 'Unavailable'
                    StorageRequireEncryption                    = $False
                    FirewallEnabled                             = $False
                    FirewallBlockAllIncoming                    = $False
                    FirewallEnableStealthMode                   = $False
                    Ensure                                      = 'Present'
                    Credential                                  = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementDeviceCompliancePolicy -MockWith {
                    return $null
                }
            }

            It 'Should return absent from the Get method' {
                    (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create the iOS Device Compliance Policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-MgDeviceManagementDeviceCompliancePolicy' -Exactly 1
            }
        }

        Context -Name 'When the iOS Device Compliance Policy already exists and is NOT in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName                                 = 'MacOS DSC Policy'
                    Description                                 = 'Test policy'
                    PasswordRequired                            = $False
                    PasswordBlockSimple                         = $False
                    PasswordExpirationDays                      = 365
                    PasswordMinimumLength                       = 6
                    PasswordMinutesOfInactivityBeforeLock       = 5
                    PasswordPreviousPasswordBlockCount          = 13
                    PasswordMinimumCharacterSetCount            = 1
                    PasswordRequiredType                        = 'DeviceDefault'
                    OsMinimumVersion                            = 10
                    OsMaximumVersion                            = 13
                    SystemIntegrityProtectionEnabled            = $False
                    DeviceThreatProtectionEnabled               = $False
                    DeviceThreatProtectionRequiredSecurityLevel = 'Unavailable'
                    StorageRequireEncryption                    = $False
                    FirewallEnabled                             = $False
                    FirewallBlockAllIncoming                    = $False
                    FirewallEnableStealthMode                   = $False
                    Ensure                                      = 'Present'
                    Credential                                  = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementDeviceCompliancePolicy -MockWith {
                    return @{
                        DisplayName          = 'MacOS DSC Policy'
                        Description          = 'Test policy with different value'
                        Id                   = 'd95e706d-c92c-410d-a132-09e0b1032dbd'
                        AdditionalProperties = @{
                            '@odata.type'                               = '#microsoft.graph.macOSCompliancePolicy'
                            PasswordRequired                            = $False
                            PasswordBlockSimple                         = $False
                            PasswordExpirationDays                      = 365
                            PasswordMinimumLength                       = 6
                            PasswordMinutesOfInactivityBeforeLock       = 5
                            PasswordPreviousPasswordBlockCount          = 13
                            PasswordMinimumCharacterSetCount            = 1
                            PasswordRequiredType                        = 'DeviceDefault'
                            OsMinimumVersion                            = 10
                            OsMaximumVersion                            = 13
                            SystemIntegrityProtectionEnabled            = $False
                            DeviceThreatProtectionEnabled               = $False
                            DeviceThreatProtectionRequiredSecurityLevel = 'Unavailable'
                            StorageRequireEncryption                    = $False
                            FirewallEnabled                             = $False
                            FirewallBlockAllIncoming                    = $False
                            FirewallEnableStealthMode                   = $False
                            RoleScopeTagIds                             = '0'
                        }
                    }
                }
            }

            It 'Should return Present from the Get method' {
                    (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update the iOS Device Compliance Policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgDeviceManagementDeviceCompliancePolicy -Exactly 1
            }
        }

        Context -Name 'When the policy already exists and IS in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName                                 = 'MacOS DSC Policy'
                    Description                                 = 'Test policy'
                    PasswordRequired                            = $False
                    PasswordBlockSimple                         = $False
                    PasswordExpirationDays                      = 365
                    PasswordMinimumLength                       = 6
                    PasswordMinutesOfInactivityBeforeLock       = 5
                    PasswordPreviousPasswordBlockCount          = 13
                    PasswordMinimumCharacterSetCount            = 1
                    PasswordRequiredType                        = 'DeviceDefault'
                    OsMinimumVersion                            = 10
                    OsMaximumVersion                            = 13
                    SystemIntegrityProtectionEnabled            = $False
                    DeviceThreatProtectionEnabled               = $False
                    DeviceThreatProtectionRequiredSecurityLevel = 'Unavailable'
                    StorageRequireEncryption                    = $False
                    FirewallEnabled                             = $False
                    FirewallBlockAllIncoming                    = $False
                    FirewallEnableStealthMode                   = $False
                    Assignments                                 = @()
                    Ensure                                      = 'Present'
                    Credential                                  = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementDeviceCompliancePolicy -MockWith {
                    return @{
                        DisplayName          = 'MacOS DSC Policy'
                        Description          = 'Test policy'
                        Id                   = 'd95e706d-c92c-410d-a132-09e0b1032dbd'
                        AdditionalProperties = @{
                            '@odata.type'                               = '#microsoft.graph.macOSCompliancePolicy'
                            PasswordRequired                            = $False
                            PasswordBlockSimple                         = $False
                            PasswordExpirationDays                      = 365
                            PasswordMinimumLength                       = 6
                            PasswordMinutesOfInactivityBeforeLock       = 5
                            PasswordPreviousPasswordBlockCount          = 13
                            PasswordMinimumCharacterSetCount            = 1
                            PasswordRequiredType                        = 'DeviceDefault'
                            OsMinimumVersion                            = 10
                            OsMaximumVersion                            = 13
                            SystemIntegrityProtectionEnabled            = $False
                            DeviceThreatProtectionEnabled               = $False
                            DeviceThreatProtectionRequiredSecurityLevel = 'Unavailable'
                            StorageRequireEncryption                    = $False
                            FirewallEnabled                             = $False
                            FirewallBlockAllIncoming                    = $False
                            FirewallEnableStealthMode                   = $False
                        }
                    }
                }
                Mock -CommandName Get-MgDeviceManagementDeviceCompliancePolicyAssignment -MockWith {
                    return @()
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'When the policy exists and it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName                                 = 'MacOS DSC Policy'
                    Description                                 = 'Test policy'
                    PasswordRequired                            = $False
                    PasswordBlockSimple                         = $False
                    PasswordExpirationDays                      = 365
                    PasswordMinimumLength                       = 6
                    PasswordMinutesOfInactivityBeforeLock       = 5
                    PasswordPreviousPasswordBlockCount          = 13
                    PasswordMinimumCharacterSetCount            = 1
                    PasswordRequiredType                        = 'DeviceDefault'
                    OsMinimumVersion                            = 10
                    OsMaximumVersion                            = 13
                    SystemIntegrityProtectionEnabled            = $False
                    DeviceThreatProtectionEnabled               = $False
                    DeviceThreatProtectionRequiredSecurityLevel = 'Unavailable'
                    StorageRequireEncryption                    = $False
                    FirewallEnabled                             = $False
                    FirewallBlockAllIncoming                    = $False
                    FirewallEnableStealthMode                   = $False
                    Ensure                                      = 'Absent'
                    Credential                                  = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementDeviceCompliancePolicy -MockWith {
                    return @{
                        DisplayName          = 'MacOS DSC Policy'
                        Description          = 'Test policy'
                        Id                   = 'd95e706d-c92c-410d-a132-09e0b1032dbd'
                        AdditionalProperties = @{
                            '@odata.type'                               = '#microsoft.graph.macOSCompliancePolicy'
                            PasswordRequired                            = $False
                            PasswordBlockSimple                         = $False
                            PasswordExpirationDays                      = 365
                            PasswordMinimumLength                       = 6
                            PasswordMinutesOfInactivityBeforeLock       = 5
                            PasswordPreviousPasswordBlockCount          = 13
                            PasswordMinimumCharacterSetCount            = 1
                            PasswordRequiredType                        = 'DeviceDefault'
                            OsMinimumVersion                            = 10
                            OsMaximumVersion                            = 13
                            SystemIntegrityProtectionEnabled            = $False
                            DeviceThreatProtectionEnabled               = $False
                            DeviceThreatProtectionRequiredSecurityLevel = 'Unavailable'
                            StorageRequireEncryption                    = $False
                            FirewallEnabled                             = $False
                            FirewallBlockAllIncoming                    = $False
                            FirewallEnableStealthMode                   = $False
                            RoleScopeTagIds                             = '0'
                        }
                    }
                }
            }

            It 'Should return Present from the Get method' {
                    (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the iOS Device Compliance Policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgDeviceManagementDeviceCompliancePolicy -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementDeviceCompliancePolicy -MockWith {
                    return @{
                        DisplayName          = 'MacOS DSC Policy'
                        Description          = 'Test policy'
                        Id                   = 'd95e706d-c92c-410d-a132-09e0b1032dbd'
                        AdditionalProperties = @{
                            '@odata.type'                               = '#microsoft.graph.macOSCompliancePolicy'
                            PasswordRequired                            = $False
                            PasswordBlockSimple                         = $False
                            PasswordExpirationDays                      = 365
                            PasswordMinimumLength                       = 6
                            PasswordMinutesOfInactivityBeforeLock       = 5
                            PasswordPreviousPasswordBlockCount          = 13
                            PasswordMinimumCharacterSetCount            = 1
                            PasswordRequiredType                        = 'DeviceDefault'
                            OsMinimumVersion                            = 10
                            OsMaximumVersion                            = 13
                            SystemIntegrityProtectionEnabled            = $False
                            DeviceThreatProtectionEnabled               = $False
                            DeviceThreatProtectionRequiredSecurityLevel = 'Unavailable'
                            StorageRequireEncryption                    = $False
                            FirewallEnabled                             = $False
                            FirewallBlockAllIncoming                    = $False
                            FirewallEnableStealthMode                   = $False
                            RoleScopeTagIds                             = '0'
                        }
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
