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
    -DscResource "IntuneASRRulesPolicyWindows10" -GenericStubModule $GenericStubPath

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

            Mock -CommandName New-MgDeviceManagementIntent -MockWith {
            }
            Mock -CommandName Update-MgDeviceManagementIntent -MockWith {
            }
            Mock -CommandName Remove-MgDeviceManagementIntent -MockWith {
            }
            Mock -CommandName Invoke-MgGraphRequest -MockWith {
            }
        }

        # Test contexts
        Context -Name "When the instance doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity = "12345-12345-12345-12345-12345"
                    DisplayName = "Test"
                    Description = "This is a test"
                    ProcessCreationType = "block"
                    AdvancedRansomewareProtectionType = "enable"
                    BlockPersistenceThroughWmiType = "block"
                    ScriptObfuscatedMacroCodeType = "block"
                    OfficeMacroCodeAllowWin32ImportsType = "block"
                    OfficeAppsLaunchChildProcessType = "warn"
                    GuardMyFoldersType = "auditMode"
                    UntrustedUSBProcessType = "block"
                    AttackSurfaceReductionExcludedPaths = @("room/telephone")
                    UntrustedExecutableType = "block"
                    OfficeCommunicationAppsLaunchChildProcess = "warn"
                    EmailContentExecutionType = "disable"
                    ScriptDownloadedPayloadExecutionType = "block"
                    AdditionalGuardedFolders = @("main")
                    AdobeReaderLaunchChildProcess = "notConfigured"
                    OfficeAppsExecutableContentCreationOrLaunchType = "block"
                    PreventCredentialStealingType = "enable"
                    OfficeAppsOtherProcessInjectionType = "warn"
                    GuardedFoldersAllowedAppPaths = @("main", "root")
                    Ensure = "Present"
                    Credential = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementIntent -MockWith {
                    return $null
                }
                Mock -CommandName Get-MgDeviceManagementIntentSetting -MockWith {
                    return $null
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should create the instance from the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName "New-MgDeviceManagementIntent" -Exactly 1
            }
        }

        Context -Name "When the instance already exists and is NOT in the Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity = "12345-12345-12345-12345-12345"
                    DisplayName = "Test"
                    Description = "This is a test"
                    ProcessCreationType = "block"
                    AdvancedRansomewareProtectionType = "enable"
                    BlockPersistenceThroughWmiType = "block"
                    ScriptObfuscatedMacroCodeType = "block"
                    OfficeMacroCodeAllowWin32ImportsType = "block"
                    OfficeAppsLaunchChildProcessType = "warn"
                    GuardMyFoldersType = "auditMode"
                    UntrustedUSBProcessType = "block"
                    AttackSurfaceReductionExcludedPaths = @("room/telephone")
                    UntrustedExecutableType = "block"
                    OfficeCommunicationAppsLaunchChildProcess = "warn"
                    EmailContentExecutionType = "disable"
                    ScriptDownloadedPayloadExecutionType = "block"
                    AdditionalGuardedFolders = @("main")
                    AdobeReaderLaunchChildProcess = "notConfigured"
                    OfficeAppsExecutableContentCreationOrLaunchType = "block"
                    PreventCredentialStealingType = "enable"
                    OfficeAppsOtherProcessInjectionType = "warn"
                    GuardedFoldersAllowedAppPaths = @("main", "root")
                    Ensure = "Present"
                    Credential = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementIntent -MockWith {
                    return @{
                        Id = "12345-12345-12345-12345-12345"
                        Description = "This is a test"
                        DisplayName = "Test"
                        TemplateId = "0e237410-1367-4844-bd7f-15fb0f08943b"
                    }
                }

                Mock -CommandName Get-MgDeviceManagementIntentSetting -MockWith {
                    return @(
                        @{
                            Id = "12345-12345-12345-12345-12345"
                            DefinitionId = "deviceConfiguration--windows10EndpointProtectionConfiguration_defenderOfficeAppsOtherProcessInjectionType"
                            ValueJson = '"warn"'
                            AdditionalProperties = @{
                                "@odata.type" = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value = "warn"
                            }
                        },
                        @{
                            Id = "12345-12345-12345-12345-12345"
                            DefinitionId = "deviceConfiguration--windows10EndpointProtectionConfiguration_defenderAdobeReaderLaunchChildProcess"
                            ValueJson = '"notConfigured"'
                            AdditionalProperties = @{
                                "@odata.type" = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value = "block" #drift
                            }
                        },
                        @{
                            Id = "12345-12345-12345-12345-12345"
                            DefinitionId = "deviceConfiguration--windows10EndpointProtectionConfiguration_defenderScriptObfuscatedMacroCodeType"
                            ValueJson = '"block"'
                            AdditionalProperties = @{
                                "@odata.type" = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value = "block"
                            }
                        },
                        @{
                            Id = "12345-12345-12345-12345-12345"
                            DefinitionId = "deviceConfiguration--windows10EndpointProtectionConfiguration_defenderBlockPersistenceThroughWmiType"
                            ValueJson = '"block"'
                            AdditionalProperties = @{
                                "@odata.type" = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value = "block"
                            }
                        },
                        @{
                            Id = "12345-12345-12345-12345-12345"
                            DefinitionId = "deviceConfiguration--windows10EndpointProtectionConfiguration_defenderAdditionalGuardedFolders"
                            ValueJson = '["main","root"]'
                            AdditionalProperties = @{
                                "@odata.type" = '#microsoft.graph.deviceManagementCollectionSettingInstance'
                            }
                        }
                    )
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should update the instance from the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgDeviceManagementIntent -Exactly 1
            }
        }

        Context -Name "When the instance already exists and IS in the Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity = "12345-12345-12345-12345-12345"
                    DisplayName = "Test"
                    Description = "This is a test"
                    Ensure = "Present"
                    Credential = $Credential
                    OfficeAppsOtherProcessInjectionType = "warn"
                    AdobeReaderLaunchChildProcess = "notConfigured"
                    ScriptObfuscatedMacroCodeType = "block"
                    AdditionalGuardedFolders = @("main", "root")
                    BlockPersistenceThroughWmiType = "block"
                }

                Mock -CommandName Get-MgDeviceManagementIntent -MockWith {
                    return @{
                        Id = "12345-12345-12345-12345-12345"
                        Description = "This is a test"
                        DisplayName = "Test"
                        TemplateId = "0e237410-1367-4844-bd7f-15fb0f08943b"
                    }
                }

                Mock -CommandName Get-MgDeviceManagementIntentSetting -MockWith {
                    return @(
                        @{
                            Id = "12345-12345-12345-12345-12345"
                            DefinitionId = "deviceConfiguration--windows10EndpointProtectionConfiguration_defenderOfficeAppsOtherProcessInjectionType"
                            ValueJson = '"warn"'
                            AdditionalProperties = @{
                                "@odata.type" = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value = "warn"
                            }
                        },
                        @{
                            Id = "12345-12345-12345-12345-12345"
                            DefinitionId = "deviceConfiguration--windows10EndpointProtectionConfiguration_defenderAdobeReaderLaunchChildProcess"
                            ValueJson = '"notConfigured"'
                            AdditionalProperties = @{
                                "@odata.type" = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value = "notConfigured"
                            }
                        },
                        @{
                            Id = "12345-12345-12345-12345-12345"
                            DefinitionId = "deviceConfiguration--windows10EndpointProtectionConfiguration_defenderScriptObfuscatedMacroCodeType"
                            ValueJson = '"block"'
                            AdditionalProperties = @{
                                "@odata.type" = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value = "block"
                            }
                        },
                        @{
                            Id = "12345-12345-12345-12345-12345"
                            DefinitionId = "deviceConfiguration--windows10EndpointProtectionConfiguration_defenderBlockPersistenceThroughWmiType"
                            ValueJson = '"block"'
                            AdditionalProperties = @{
                                "@odata.type" = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value = "block"
                            }
                        },
                        @{
                            Id = "12345-12345-12345-12345-12345"
                            DefinitionId = "deviceConfiguration--windows10EndpointProtectionConfiguration_defenderAdditionalGuardedFolders"
                            ValueJson = '["main","root"]'
                            AdditionalProperties = @{
                                "@odata.type" = '#microsoft.graph.deviceManagementCollectionSettingInstance'
                            }
                        }
                    )
                }
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "When the instance exists and it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity = "12345-12345-12345-12345-12345"
                    DisplayName = "Test"
                    Description = "This is a test"
                    ProcessCreationType = "block"
                    AdvancedRansomewareProtectionType = "enable"
                    BlockPersistenceThroughWmiType = "block"
                    ScriptObfuscatedMacroCodeType = "block"
                    OfficeMacroCodeAllowWin32ImportsType = "block"
                    OfficeAppsLaunchChildProcessType = "warn"
                    GuardMyFoldersType = "auditMode"
                    UntrustedUSBProcessType = "block"
                    AttackSurfaceReductionExcludedPaths = @("room/telephone")
                    UntrustedExecutableType = "block"
                    OfficeCommunicationAppsLaunchChildProcess = "warn"
                    EmailContentExecutionType = "disable"
                    ScriptDownloadedPayloadExecutionType = "block"
                    AdditionalGuardedFolders = @("main")
                    AdobeReaderLaunchChildProcess = "notConfigured"
                    OfficeAppsExecutableContentCreationOrLaunchType = "block"
                    PreventCredentialStealingType = "enable"
                    OfficeAppsOtherProcessInjectionType = "warn"
                    GuardedFoldersAllowedAppPaths = @("main", "root")
                    Ensure = "Absent"
                    Credential = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementIntent -MockWith {
                    return @{
                        Id = "12345-12345-12345-12345-12345"
                        Description = "This is a test"
                        DisplayName = "Test"
                        TemplateId = "0e237410-1367-4844-bd7f-15fb0f08943b"
                    }
                }

                Mock -CommandName Get-MgDeviceManagementIntentSetting -MockWith {
                    return @(
                        @{
                            Id = "12345-12345-12345-12345-12345"
                            DefinitionId = "deviceConfiguration--windows10EndpointProtectionConfiguration_defenderOfficeAppsOtherProcessInjectionType"
                            ValueJson = '"warn"'
                            AdditionalProperties = @{
                                "@odata.type" = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value = "warn"
                            }
                        },
                        @{
                            Id = "12345-12345-12345-12345-12345"
                            DefinitionId = "deviceConfiguration--windows10EndpointProtectionConfiguration_defenderAdobeReaderLaunchChildProcess"
                            ValueJson = '"notConfigured"'
                            AdditionalProperties = @{
                                "@odata.type" = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value = "notConfigured"
                            }
                        },
                        @{
                            Id = "12345-12345-12345-12345-12345"
                            DefinitionId = "deviceConfiguration--windows10EndpointProtectionConfiguration_defenderScriptObfuscatedMacroCodeType"
                            ValueJson = '"block"'
                            AdditionalProperties = @{
                                "@odata.type" = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value = "block"
                            }
                        },
                        @{
                            Id = "12345-12345-12345-12345-12345"
                            DefinitionId = "deviceConfiguration--windows10EndpointProtectionConfiguration_defenderBlockPersistenceThroughWmiType"
                            ValueJson = '"block"'
                            AdditionalProperties = @{
                                "@odata.type" = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value = "block"
                            }
                        },
                        @{
                            Id = "12345-12345-12345-12345-12345"
                            DefinitionId = "deviceConfiguration--windows10EndpointProtectionConfiguration_defenderAdditionalGuardedFolders"
                            ValueJson = '["main","root"]'
                            AdditionalProperties = @{
                                "@odata.type" = '#microsoft.graph.deviceManagementCollectionSettingInstance'
                            }
                        }
                    )
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should remove the instance from the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgDeviceManagementIntent -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $testParams = @{
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementIntent -MockWith {
                    return @{
                        Id = "12345-12345-12345-12345-12345"
                        Description = "This is a test"
                        DisplayName = "Test"
                        TemplateId = "0e237410-1367-4844-bd7f-15fb0f08943b"
                    }
                }

                Mock -CommandName Get-MgDeviceManagementIntentSetting -MockWith {
                    return @(
                        @{
                            Id = "12345-12345-12345-12345-12345"
                            DefinitionId = "deviceConfiguration--windows10EndpointProtectionConfiguration_defenderOfficeAppsOtherProcessInjectionType"
                            ValueJson = '"warn"'
                            AdditionalProperties = @{
                                "@odata.type" = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value = "warn"
                            }
                        },
                        @{
                            Id = "12345-12345-12345-12345-12345"
                            DefinitionId = "deviceConfiguration--windows10EndpointProtectionConfiguration_defenderAdobeReaderLaunchChildProcess"
                            ValueJson = '"notConfigured"'
                            AdditionalProperties = @{
                                "@odata.type" = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value = "notConfigured"
                            }
                        },
                        @{
                            Id = "12345-12345-12345-12345-12345"
                            DefinitionId = "deviceConfiguration--windows10EndpointProtectionConfiguration_defenderScriptObfuscatedMacroCodeType"
                            ValueJson = '"block"'
                            AdditionalProperties = @{
                                "@odata.type" = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value = "block"
                            }
                        },
                        @{
                            Id = "12345-12345-12345-12345-12345"
                            DefinitionId = "deviceConfiguration--windows10EndpointProtectionConfiguration_defenderBlockPersistenceThroughWmiType"
                            ValueJson = '"block"'
                            AdditionalProperties = @{
                                "@odata.type" = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value = "block"
                            }
                        },
                        @{
                            Id = "12345-12345-12345-12345-12345"
                            DefinitionId = "deviceConfiguration--windows10EndpointProtectionConfiguration_defenderAdditionalGuardedFolders"
                            ValueJson = '["main","root"]'
                            AdditionalProperties = @{
                                "@odata.type" = '#microsoft.graph.deviceManagementCollectionSettingInstance'
                            }
                        }
                    )
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
