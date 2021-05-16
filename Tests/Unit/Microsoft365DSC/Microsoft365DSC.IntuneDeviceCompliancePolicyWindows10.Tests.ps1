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
    -DscResource "IntuneDeviceCompliancePolicyWindows10" -GenericStubModule $GenericStubPath

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

            Mock -CommandName Update-IntuneDeviceCompliancePolicy -MockWith {
            }
            Mock -CommandName New-IntuneDeviceCompliancePolicy -MockWith {
            }
            Mock -CommandName Remove-IntuneDeviceCompliancePolicy -MockWith {
            }

            # Test contexts
            Context -Name "When the Windows 10  Device Compliance Policy doesn't already exist" -Fixture {
                BeforeAll {
                    $testParams = @{
                        DisplayName                                 = "Windows 10 DSC Policy";
                        Description                                 = "Test policy";
                        PasswordRequired                            = $False;
                        PasswordBlockSimple                         = $False;
                        PasswordRequiredToUnlockFromIdle            = $True;
                        PasswordMinutesOfInactivityBeforeLock       = 15;
                        PasswordExpirationDays                      = 365;
                        PasswordMinimumLength                       = 6;
                        PasswordPreviousPasswordBlockCount          = 13;
                        PasswordMinimumCharacterSetCount            = 1;
                        PasswordRequiredType                        = "Devicedefault";
                        RequireHealthyDeviceReport                  = $True;
                        OsMinimumVersion                            = 10;
                        OsMaximumVersion                            = 10.19;
                        MobileOsMinimumVersion                      = 10;
                        MobileOsMaximumVersion                      = 10.19;
                        EarlyLaunchAntiMalwareDriverEnabled         = $False;
                        BitLockerEnabled                            = $False;
                        SecureBootEnabled                           = $True;
                        CodeIntegrityEnabled                        = $True;
                        StorageRequireEncryption                    = $True;
                        ActiveFirewallRequired                      = $True;
                        DefenderEnabled                             = $True;
                        DefenderVersion                             = "";
                        SignatureOutOfDate                          = $True;
                        RtpEnabled                                  = $True;
                        AntivirusRequired                           = $True;
                        AntiSpywareRequired                         = $True;
                        DeviceThreatProtectionEnabled               = $True;
                        DeviceThreatProtectionRequiredSecurityLevel = "Medium";
                        ConfigurationManagerComplianceRequired      = $False;
                        TPMRequired                                 = $False;
                        DeviceCompliancePolicyScript                = $null;
                        ValidOperatingSystemBuildRanges             = @();
                        RoleScopeTagIds                             = "0"
                        Ensure                                      = 'Present';
                        GlobalAdminAccount                          = $GlobalAdminAccount;
                    }

                    Mock -CommandName Get-IntuneDeviceCompliancePolicy -MockWith {
                        return $null
                    }
                }

                It "Should return absent from the Get method" {
                    (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
                }

                It "Should return false from the Test method" {
                    Test-TargetResource @testParams | Should -Be $false
                }

                It "Should create the Windows 10 Device Compliance Policy from the Set method" {
                    Set-TargetResource @testParams
                    Should -Invoke -CommandName "New-IntuneDeviceCompliancePolicy" -Exactly 1
                }
            }

            Context -Name "When the Windows 10 Device Compliance Policy already exists and is NOT in the Desired State" -Fixture {
                BeforeAll {
                    $testParams = @{
                        DisplayName                                 = "Windows 10 DSC Policy";
                        Description                                 = "Test policy";
                        PasswordRequired                            = $False;
                        PasswordBlockSimple                         = $False;
                        PasswordRequiredToUnlockFromIdle            = $True;
                        PasswordMinutesOfInactivityBeforeLock       = 15;
                        PasswordExpirationDays                      = 365;
                        PasswordMinimumLength                       = 6;
                        PasswordPreviousPasswordBlockCount          = 13;
                        PasswordMinimumCharacterSetCount            = 1;
                        PasswordRequiredType                        = "Devicedefault";
                        RequireHealthyDeviceReport                  = $True;
                        OsMinimumVersion                            = 10;
                        OsMaximumVersion                            = 10.19;
                        MobileOsMinimumVersion                      = 10;
                        MobileOsMaximumVersion                      = 10.19;
                        EarlyLaunchAntiMalwareDriverEnabled         = $False;
                        BitLockerEnabled                            = $False;
                        SecureBootEnabled                           = $True;
                        CodeIntegrityEnabled                        = $True;
                        StorageRequireEncryption                    = $True;
                        ActiveFirewallRequired                      = $True;
                        DefenderEnabled                             = $True;
                        DefenderVersion                             = "";
                        SignatureOutOfDate                          = $True;
                        RtpEnabled                                  = $True;
                        AntivirusRequired                           = $True;
                        AntiSpywareRequired                         = $True;
                        DeviceThreatProtectionEnabled               = $True;
                        DeviceThreatProtectionRequiredSecurityLevel = "Medium";
                        ConfigurationManagerComplianceRequired      = $False;
                        TPMRequired                                 = $False;
                        DeviceCompliancePolicyScript                = $null;
                        ValidOperatingSystemBuildRanges             = @();
                        RoleScopeTagIds                             = "0"
                        Ensure                                      = 'Present';
                        GlobalAdminAccount                          = $GlobalAdminAccount;
                    }

                    Mock -CommandName Get-IntuneDeviceCompliancePolicy -MockWith {
                        return @{
                            DisplayName                                 = "Windows 10 DSC Policy";
                            Description                                 = "Test policy";
                            Id                                          = "f38b283d-d893-4c33-b6d2-d3bcb5f2dcc2";
                            PasswordRequired                            = $False;
                            PasswordBlockSimple                         = $False;
                            PasswordRequiredToUnlockFromIdle            = $True;
                            PasswordMinutesOfInactivityBeforeLock       = 15;
                            PasswordExpirationDays                      = 365;
                            PasswordMinimumLength                       = 6;
                            PasswordPreviousPasswordBlockCount          = 13;
                            PasswordMinimumCharacterSetCount            = 1;
                            PasswordRequiredType                        = "Devicedefault";
                            RequireHealthyDeviceReport                  = $True;
                            OsMinimumVersion                            = 10;
                            OsMaximumVersion                            = 10.19;
                            MobileOsMinimumVersion                      = 10;
                            MobileOsMaximumVersion                      = 10.19;
                            EarlyLaunchAntiMalwareDriverEnabled         = $False;
                            BitLockerEnabled                            = $False;
                            SecureBootEnabled                           = $True;
                            CodeIntegrityEnabled                        = $True;
                            StorageRequireEncryption                    = $True;
                            ActiveFirewallRequired                      = $True;
                            DefenderEnabled                             = $True;
                            DefenderVersion                             = "";
                            SignatureOutOfDate                          = $True;
                            RtpEnabled                                  = $True;
                            AntivirusRequired                           = $True;
                            AntiSpywareRequired                         = $True;
                            DeviceThreatProtectionEnabled               = $True;
                            DeviceThreatProtectionRequiredSecurityLevel = "Medium";
                            ConfigurationManagerComplianceRequired      = $False;
                            TPMRequired                                 = $False;
                            DeviceCompliancePolicyScript                = $null;
                            ValidOperatingSystemBuildRanges             = @();
                            RoleScopeTagIds                             = "0"
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
                    Should -Invoke -CommandName Update-IntuneDeviceCompliancePolicy -Exactly 1
                }
            }

            Context -Name "When the policy already exists and IS in the Desired State" -Fixture {
                BeforeAll {
                    $testParams = @{
                        DisplayName                                 = "Windows 10 DSC Policy";
                        Description                                 = "Test policy";
                        PasswordRequired                            = $False;
                        PasswordBlockSimple                         = $False;
                        PasswordRequiredToUnlockFromIdle            = $True;
                        PasswordMinutesOfInactivityBeforeLock       = 15;
                        PasswordExpirationDays                      = 365;
                        PasswordMinimumLength                       = 6;
                        PasswordPreviousPasswordBlockCount          = 13;
                        PasswordMinimumCharacterSetCount            = 1;
                        PasswordRequiredType                        = "Devicedefault";
                        RequireHealthyDeviceReport                  = $True;
                        OsMinimumVersion                            = 10;
                        OsMaximumVersion                            = 10.19;
                        MobileOsMinimumVersion                      = 10;
                        MobileOsMaximumVersion                      = 10.19;
                        EarlyLaunchAntiMalwareDriverEnabled         = $False;
                        BitLockerEnabled                            = $False;
                        SecureBootEnabled                           = $True;
                        CodeIntegrityEnabled                        = $True;
                        StorageRequireEncryption                    = $True;
                        ActiveFirewallRequired                      = $True;
                        DefenderEnabled                             = $True;
                        DefenderVersion                             = "";
                        SignatureOutOfDate                          = $True;
                        RtpEnabled                                  = $True;
                        AntivirusRequired                           = $True;
                        AntiSpywareRequired                         = $True;
                        DeviceThreatProtectionEnabled               = $True;
                        DeviceThreatProtectionRequiredSecurityLevel = "Medium";
                        ConfigurationManagerComplianceRequired      = $False;
                        TPMRequired                                 = $False;
                        DeviceCompliancePolicyScript                = $null;
                        ValidOperatingSystemBuildRanges             = @();
                        RoleScopeTagIds                             = "0"
                        Ensure                                      = 'Present';
                        GlobalAdminAccount                          = $GlobalAdminAccount;
                    }

                    Mock -CommandName Get-IntuneDeviceCompliancePolicy -MockWith {
                        return @{
                            DisplayName                                 = "Windows 10 DSC Policy";
                            Description                                 = "Test policy";
                            Id                                          = "f38b283d-d893-4c33-b6d2-d3bcb5f2dcc2";
                            PasswordRequired                            = $False;
                            PasswordBlockSimple                         = $False;
                            PasswordRequiredToUnlockFromIdle            = $True;
                            PasswordMinutesOfInactivityBeforeLock       = 15;
                            PasswordExpirationDays                      = 365;
                            PasswordMinimumLength                       = 6;
                            PasswordPreviousPasswordBlockCount          = 13;
                            PasswordMinimumCharacterSetCount            = 1;
                            PasswordRequiredType                        = "Devicedefault";
                            RequireHealthyDeviceReport                  = $True;
                            OsMinimumVersion                            = 10;
                            OsMaximumVersion                            = 10.19;
                            MobileOsMinimumVersion                      = 10;
                            MobileOsMaximumVersion                      = 10.19;
                            EarlyLaunchAntiMalwareDriverEnabled         = $False;
                            BitLockerEnabled                            = $False;
                            SecureBootEnabled                           = $True;
                            CodeIntegrityEnabled                        = $True;
                            StorageRequireEncryption                    = $True;
                            ActiveFirewallRequired                      = $True;
                            DefenderEnabled                             = $True;
                            DefenderVersion                             = "";
                            SignatureOutOfDate                          = $True;
                            RtpEnabled                                  = $True;
                            AntivirusRequired                           = $True;
                            AntiSpywareRequired                         = $True;
                            DeviceThreatProtectionEnabled               = $True;
                            DeviceThreatProtectionRequiredSecurityLevel = "Medium";
                            ConfigurationManagerComplianceRequired      = $False;
                            TPMRequired                                 = $False;
                            DeviceCompliancePolicyScript                = $null;
                            ValidOperatingSystemBuildRanges             = @();
                            RoleScopeTagIds                             = "0"
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
                        DisplayName                                 = "Windows 10 DSC Policy";
                        Description                                 = "Test policy";
                        PasswordRequired                            = $False;
                        PasswordBlockSimple                         = $False;
                        PasswordRequiredToUnlockFromIdle            = $True;
                        PasswordMinutesOfInactivityBeforeLock       = 15;
                        PasswordExpirationDays                      = 365;
                        PasswordMinimumLength                       = 6;
                        PasswordPreviousPasswordBlockCount          = 13;
                        PasswordMinimumCharacterSetCount            = 1;
                        PasswordRequiredType                        = "Devicedefault";
                        RequireHealthyDeviceReport                  = $True;
                        OsMinimumVersion                            = 10;
                        OsMaximumVersion                            = 10.19;
                        MobileOsMinimumVersion                      = 10;
                        MobileOsMaximumVersion                      = 10.19;
                        EarlyLaunchAntiMalwareDriverEnabled         = $False;
                        BitLockerEnabled                            = $False;
                        SecureBootEnabled                           = $True;
                        CodeIntegrityEnabled                        = $True;
                        StorageRequireEncryption                    = $True;
                        ActiveFirewallRequired                      = $True;
                        DefenderEnabled                             = $True;
                        DefenderVersion                             = "";
                        SignatureOutOfDate                          = $True;
                        RtpEnabled                                  = $True;
                        AntivirusRequired                           = $True;
                        AntiSpywareRequired                         = $True;
                        DeviceThreatProtectionEnabled               = $True;
                        DeviceThreatProtectionRequiredSecurityLevel = "Medium";
                        ConfigurationManagerComplianceRequired      = $False;
                        TPMRequired                                 = $False;
                        DeviceCompliancePolicyScript                = $null;
                        ValidOperatingSystemBuildRanges             = @();
                        RoleScopeTagIds                             = "0"
                        Ensure                                      = 'Present';
                        GlobalAdminAccount                          = $GlobalAdminAccount;
                    }

                    Mock -CommandName Get-IntuneDeviceCompliancePolicy -MockWith {
                        return @{
                            DisplayName                                 = "Windows 10 DSC Policy";
                            Description                                 = "Test policy";
                            Id                                          = "f38b283d-d893-4c33-b6d2-d3bcb5f2dcc2";
                            PasswordRequired                            = $False;
                            PasswordBlockSimple                         = $False;
                            PasswordRequiredToUnlockFromIdle            = $True;
                            PasswordMinutesOfInactivityBeforeLock       = 15;
                            PasswordExpirationDays                      = 365;
                            PasswordMinimumLength                       = 6;
                            PasswordPreviousPasswordBlockCount          = 13;
                            PasswordMinimumCharacterSetCount            = 1;
                            PasswordRequiredType                        = "Devicedefault";
                            RequireHealthyDeviceReport                  = $True;
                            OsMinimumVersion                            = 10;
                            OsMaximumVersion                            = 10.19;
                            MobileOsMinimumVersion                      = 10;
                            MobileOsMaximumVersion                      = 10.19;
                            EarlyLaunchAntiMalwareDriverEnabled         = $False;
                            BitLockerEnabled                            = $False;
                            SecureBootEnabled                           = $True;
                            CodeIntegrityEnabled                        = $True;
                            StorageRequireEncryption                    = $True;
                            ActiveFirewallRequired                      = $True;
                            DefenderEnabled                             = $True;
                            DefenderVersion                             = "";
                            SignatureOutOfDate                          = $True;
                            RtpEnabled                                  = $True;
                            AntivirusRequired                           = $True;
                            AntiSpywareRequired                         = $True;
                            DeviceThreatProtectionEnabled               = $True;
                            DeviceThreatProtectionRequiredSecurityLevel = "Medium";
                            ConfigurationManagerComplianceRequired      = $False;
                            TPMRequired                                 = $False;
                            DeviceCompliancePolicyScript                = $null;
                            ValidOperatingSystemBuildRanges             = @();
                            RoleScopeTagIds                             = "0"
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
                    Should -Invoke -CommandName Remove-IntuneDeviceCompliancePolicy -Exactly 1
                }
            }

            Context -Name "ReverseDSC Tests" -Fixture {
                BeforeAll {
                    $testParams = @{
                        GlobalAdminAccount = $GlobalAdminAccount;
                    }

                    Mock -CommandName Get-IntuneDeviceCompliancePolicy -MockWith {
                        return @{
                            DisplayName                                 = "Windows 10 DSC Policy";
                            Description                                 = "Test policy";
                            Id                                          = "f38b283d-d893-4c33-b6d2-d3bcb5f2dcc2";
                            PasswordRequired                            = $False;
                            PasswordBlockSimple                         = $False;
                            PasswordRequiredToUnlockFromIdle            = $True;
                            PasswordMinutesOfInactivityBeforeLock       = 15;
                            PasswordExpirationDays                      = 365;
                            PasswordMinimumLength                       = 6;
                            PasswordPreviousPasswordBlockCount          = 13;
                            PasswordMinimumCharacterSetCount            = 1;
                            PasswordRequiredType                        = "Devicedefault";
                            RequireHealthyDeviceReport                  = $True;
                            OsMinimumVersion                            = 10;
                            OsMaximumVersion                            = 10.19;
                            MobileOsMinimumVersion                      = 10;
                            MobileOsMaximumVersion                      = 10.19;
                            EarlyLaunchAntiMalwareDriverEnabled         = $False;
                            BitLockerEnabled                            = $False;
                            SecureBootEnabled                           = $True;
                            CodeIntegrityEnabled                        = $True;
                            StorageRequireEncryption                    = $True;
                            ActiveFirewallRequired                      = $True;
                            DefenderEnabled                             = $True;
                            DefenderVersion                             = "";
                            SignatureOutOfDate                          = $True;
                            RtpEnabled                                  = $True;
                            AntivirusRequired                           = $True;
                            AntiSpywareRequired                         = $True;
                            DeviceThreatProtectionEnabled               = $True;
                            DeviceThreatProtectionRequiredSecurityLevel = "Medium";
                            ConfigurationManagerComplianceRequired      = $False;
                            TPMRequired                                 = $False;
                            DeviceCompliancePolicyScript                = $null;
                            ValidOperatingSystemBuildRanges             = @();
                            RoleScopeTagIds                             = "0"
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
