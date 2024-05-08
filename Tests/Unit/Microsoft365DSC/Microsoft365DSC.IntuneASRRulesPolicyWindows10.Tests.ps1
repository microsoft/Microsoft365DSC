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
    -DscResource 'IntuneASRRulesPolicyWindows10' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString ((New-Guid).ToString()) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@domain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Save-M365DSCPartialExport  -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName New-MgBetaDeviceManagementIntent -MockWith {
            }

            Mock -CommandName Update-MgBetaDeviceManagementIntent -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceManagementIntent -MockWith {
            }

            Mock -CommandName Invoke-MgGraphRequest -MockWith {
            }
            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }
            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "When the instance doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity                                        = '12345-12345-12345-12345-12345'
                    DisplayName                                     = 'Test'
                    Description                                     = 'This is a test'
                    ProcessCreationType                             = 'block'
                    AdvancedRansomewareProtectionType               = 'enable'
                    BlockPersistenceThroughWmiType                  = 'block'
                    ScriptObfuscatedMacroCodeType                   = 'block'
                    OfficeMacroCodeAllowWin32ImportsType            = 'block'
                    OfficeAppsLaunchChildProcessType                = 'warn'
                    GuardMyFoldersType                              = 'auditMode'
                    UntrustedUSBProcessType                         = 'block'
                    AttackSurfaceReductionExcludedPaths             = @('room/telephone')
                    UntrustedExecutableType                         = 'block'
                    OfficeCommunicationAppsLaunchChildProcess       = 'warn'
                    EmailContentExecutionType                       = 'disable'
                    ScriptDownloadedPayloadExecutionType            = 'block'
                    AdditionalGuardedFolders                        = @('main')
                    AdobeReaderLaunchChildProcess                   = 'notConfigured'
                    OfficeAppsExecutableContentCreationOrLaunchType = 'block'
                    PreventCredentialStealingType                   = 'enable'
                    OfficeAppsOtherProcessInjectionType             = 'warn'
                    GuardedFoldersAllowedAppPaths                   = @('main', 'root')
                    Ensure                                          = 'Present'
                    Credential                                      = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntent -MockWith {
                    return $null
                }
                Mock -CommandName Get-MgBetaDeviceManagementIntentSetting -MockWith {
                    return $null
                }
                Mock -CommandName Get-MgBetaDeviceManagementIntentAssignment -MockWith {
                    return @()
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-MgBetaDeviceManagementIntent' -Exactly 1
            }
        }

        Context -Name 'When the instance already exists and is NOT in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity                                        = '12345-12345-12345-12345-12345'
                    DisplayName                                     = 'Test'
                    Description                                     = 'This is a test'
                    ProcessCreationType                             = 'block'
                    AdvancedRansomewareProtectionType               = 'enable'
                    BlockPersistenceThroughWmiType                  = 'block'
                    ScriptObfuscatedMacroCodeType                   = 'block'
                    OfficeMacroCodeAllowWin32ImportsType            = 'block'
                    OfficeAppsLaunchChildProcessType                = 'warn'
                    GuardMyFoldersType                              = 'auditMode'
                    UntrustedUSBProcessType                         = 'block'
                    AttackSurfaceReductionExcludedPaths             = @('room/telephone')
                    UntrustedExecutableType                         = 'block'
                    OfficeCommunicationAppsLaunchChildProcess       = 'warn'
                    EmailContentExecutionType                       = 'disable'
                    ScriptDownloadedPayloadExecutionType            = 'block'
                    AdditionalGuardedFolders                        = @('main')
                    AdobeReaderLaunchChildProcess                   = 'notConfigured'
                    OfficeAppsExecutableContentCreationOrLaunchType = 'block'
                    PreventCredentialStealingType                   = 'enable'
                    OfficeAppsOtherProcessInjectionType             = 'warn'
                    GuardedFoldersAllowedAppPaths                   = @('main', 'root')
                    Ensure                                          = 'Present'
                    Credential                                      = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntent -MockWith {
                    return @{
                        Id          = '12345-12345-12345-12345-12345'
                        Description = 'This is a test'
                        DisplayName = 'Test'
                        TemplateId  = '0e237410-1367-4844-bd7f-15fb0f08943b'
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntentSetting -MockWith {
                    return @(
                        @{
                            Id                   = '12345-12345-12345-12345-12345'
                            DefinitionId         = 'deviceConfiguration--windows10EndpointProtectionConfiguration_defenderOfficeAppsOtherProcessInjectionType'
                            ValueJson            = '"warn"'
                            AdditionalProperties = @{
                                '@odata.type' = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value         = 'warn'
                            }
                        },
                        @{
                            Id                   = '12345-12345-12345-12345-12345'
                            DefinitionId         = 'deviceConfiguration--windows10EndpointProtectionConfiguration_defenderAdobeReaderLaunchChildProcess'
                            ValueJson            = '"notConfigured"'
                            AdditionalProperties = @{
                                '@odata.type' = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value         = 'block' #drift
                            }
                        },
                        @{
                            Id                   = '12345-12345-12345-12345-12345'
                            DefinitionId         = 'deviceConfiguration--windows10EndpointProtectionConfiguration_defenderScriptObfuscatedMacroCodeType'
                            ValueJson            = '"block"'
                            AdditionalProperties = @{
                                '@odata.type' = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value         = 'block'
                            }
                        },
                        @{
                            Id                   = '12345-12345-12345-12345-12345'
                            DefinitionId         = 'deviceConfiguration--windows10EndpointProtectionConfiguration_defenderBlockPersistenceThroughWmiType'
                            ValueJson            = '"block"'
                            AdditionalProperties = @{
                                '@odata.type' = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value         = 'block'
                            }
                        },
                        @{
                            Id                   = '12345-12345-12345-12345-12345'
                            DefinitionId         = 'deviceConfiguration--windows10EndpointProtectionConfiguration_defenderAdditionalGuardedFolders'
                            ValueJson            = '["main","root"]'
                            AdditionalProperties = @{
                                '@odata.type' = '#microsoft.graph.deviceManagementCollectionSettingInstance'
                            }
                        }
                    )
                }
                Mock -CommandName Get-MgBetaDeviceManagementIntentAssignment -MockWith {
                    return @()
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgBetaDeviceManagementIntent -Exactly 1
            }
        }

        Context -Name 'When the instance already exists and IS in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity                            = '12345-12345-12345-12345-12345'
                    DisplayName                         = 'Test'
                    Description                         = 'This is a test'
                    Ensure                              = 'Present'
                    Credential                          = $Credential
                    OfficeAppsOtherProcessInjectionType = 'warn'
                    AdobeReaderLaunchChildProcess       = 'notConfigured'
                    ScriptObfuscatedMacroCodeType       = 'block'
                    AdditionalGuardedFolders            = @('main', 'root')
                    BlockPersistenceThroughWmiType      = 'block'
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntent -MockWith {
                    return @{
                        Id          = '12345-12345-12345-12345-12345'
                        Description = 'This is a test'
                        DisplayName = 'Test'
                        TemplateId  = '0e237410-1367-4844-bd7f-15fb0f08943b'
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntentSetting -MockWith {
                    return @(
                        @{
                            Id                   = '12345-12345-12345-12345-12345'
                            DefinitionId         = 'deviceConfiguration--windows10EndpointProtectionConfiguration_defenderOfficeAppsOtherProcessInjectionType'
                            ValueJson            = '"warn"'
                            AdditionalProperties = @{
                                '@odata.type' = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value         = 'warn'
                            }
                        },
                        @{
                            Id                   = '12345-12345-12345-12345-12345'
                            DefinitionId         = 'deviceConfiguration--windows10EndpointProtectionConfiguration_defenderAdobeReaderLaunchChildProcess'
                            ValueJson            = '"notConfigured"'
                            AdditionalProperties = @{
                                '@odata.type' = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value         = 'notConfigured'
                            }
                        },
                        @{
                            Id                   = '12345-12345-12345-12345-12345'
                            DefinitionId         = 'deviceConfiguration--windows10EndpointProtectionConfiguration_defenderScriptObfuscatedMacroCodeType'
                            ValueJson            = '"block"'
                            AdditionalProperties = @{
                                '@odata.type' = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value         = 'block'
                            }
                        },
                        @{
                            Id                   = '12345-12345-12345-12345-12345'
                            DefinitionId         = 'deviceConfiguration--windows10EndpointProtectionConfiguration_defenderBlockPersistenceThroughWmiType'
                            ValueJson            = '"block"'
                            AdditionalProperties = @{
                                '@odata.type' = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value         = 'block'
                            }
                        },
                        @{
                            Id                   = '12345-12345-12345-12345-12345'
                            DefinitionId         = 'deviceConfiguration--windows10EndpointProtectionConfiguration_defenderAdditionalGuardedFolders'
                            ValueJson            = '["main","root"]'
                            AdditionalProperties = @{
                                '@odata.type' = '#microsoft.graph.deviceManagementCollectionSettingInstance'
                            }
                        }
                    )
                }
                Mock -CommandName Get-MgBetaDeviceManagementIntentAssignment -MockWith {
                    return @()
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'When the instance exists and it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity                                        = '12345-12345-12345-12345-12345'
                    DisplayName                                     = 'Test'
                    Description                                     = 'This is a test'
                    ProcessCreationType                             = 'block'
                    AdvancedRansomewareProtectionType               = 'enable'
                    BlockPersistenceThroughWmiType                  = 'block'
                    ScriptObfuscatedMacroCodeType                   = 'block'
                    OfficeMacroCodeAllowWin32ImportsType            = 'block'
                    OfficeAppsLaunchChildProcessType                = 'warn'
                    GuardMyFoldersType                              = 'auditMode'
                    UntrustedUSBProcessType                         = 'block'
                    AttackSurfaceReductionExcludedPaths             = @('room/telephone')
                    UntrustedExecutableType                         = 'block'
                    OfficeCommunicationAppsLaunchChildProcess       = 'warn'
                    EmailContentExecutionType                       = 'disable'
                    ScriptDownloadedPayloadExecutionType            = 'block'
                    AdditionalGuardedFolders                        = @('main')
                    AdobeReaderLaunchChildProcess                   = 'notConfigured'
                    OfficeAppsExecutableContentCreationOrLaunchType = 'block'
                    PreventCredentialStealingType                   = 'enable'
                    OfficeAppsOtherProcessInjectionType             = 'warn'
                    GuardedFoldersAllowedAppPaths                   = @('main', 'root')
                    Ensure                                          = 'Absent'
                    Credential                                      = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntent -MockWith {
                    return @{
                        Id          = '12345-12345-12345-12345-12345'
                        Description = 'This is a test'
                        DisplayName = 'Test'
                        TemplateId  = '0e237410-1367-4844-bd7f-15fb0f08943b'
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntentSetting -MockWith {
                    return @(
                        @{
                            Id                   = '12345-12345-12345-12345-12345'
                            DefinitionId         = 'deviceConfiguration--windows10EndpointProtectionConfiguration_defenderOfficeAppsOtherProcessInjectionType'
                            ValueJson            = '"warn"'
                            AdditionalProperties = @{
                                '@odata.type' = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value         = 'warn'
                            }
                        },
                        @{
                            Id                   = '12345-12345-12345-12345-12345'
                            DefinitionId         = 'deviceConfiguration--windows10EndpointProtectionConfiguration_defenderAdobeReaderLaunchChildProcess'
                            ValueJson            = '"notConfigured"'
                            AdditionalProperties = @{
                                '@odata.type' = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value         = 'notConfigured'
                            }
                        },
                        @{
                            Id                   = '12345-12345-12345-12345-12345'
                            DefinitionId         = 'deviceConfiguration--windows10EndpointProtectionConfiguration_defenderScriptObfuscatedMacroCodeType'
                            ValueJson            = '"block"'
                            AdditionalProperties = @{
                                '@odata.type' = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value         = 'block'
                            }
                        },
                        @{
                            Id                   = '12345-12345-12345-12345-12345'
                            DefinitionId         = 'deviceConfiguration--windows10EndpointProtectionConfiguration_defenderBlockPersistenceThroughWmiType'
                            ValueJson            = '"block"'
                            AdditionalProperties = @{
                                '@odata.type' = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value         = 'block'
                            }
                        },
                        @{
                            Id                   = '12345-12345-12345-12345-12345'
                            DefinitionId         = 'deviceConfiguration--windows10EndpointProtectionConfiguration_defenderAdditionalGuardedFolders'
                            ValueJson            = '["main","root"]'
                            AdditionalProperties = @{
                                '@odata.type' = '#microsoft.graph.deviceManagementCollectionSettingInstance'
                            }
                        }
                    )
                }
                Mock -CommandName Get-MgBetaDeviceManagementIntentAssignment -MockWith {
                    return @()
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the instance from the Set method' {
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
                        Id          = '12345-12345-12345-12345-12345'
                        Description = 'This is a test'
                        DisplayName = 'Test'
                        TemplateId  = '0e237410-1367-4844-bd7f-15fb0f08943b'
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementIntentSetting -MockWith {
                    return @(
                        @{
                            Id                   = '12345-12345-12345-12345-12345'
                            DefinitionId         = 'deviceConfiguration--windows10EndpointProtectionConfiguration_defenderOfficeAppsOtherProcessInjectionType'
                            ValueJson            = '"block"'
                            AdditionalProperties = @{
                                '@odata.type' = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value         = 'auditMode'
                            }
                        },
                        @{
                            Id                   = '12345-12345-12345-12345-12345'
                            DefinitionId         = 'deviceConfiguration--windows10EndpointProtectionConfiguration_defenderAdobeReaderLaunchChildProcess'
                            ValueJson            = '"notConfigured"'
                            AdditionalProperties = @{
                                '@odata.type' = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value         = 'notConfigured'
                            }
                        },
                        @{
                            Id                   = '12345-12345-12345-12345-12345'
                            DefinitionId         = 'deviceConfiguration--windows10EndpointProtectionConfiguration_defenderScriptObfuscatedMacroCodeType'
                            ValueJson            = '"block"'
                            AdditionalProperties = @{
                                '@odata.type' = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value         = 'block'
                            }
                        },
                        @{
                            Id                   = '12345-12345-12345-12345-12345'
                            DefinitionId         = 'deviceConfiguration--windows10EndpointProtectionConfiguration_defenderBlockPersistenceThroughWmiType'
                            ValueJson            = '"block"'
                            AdditionalProperties = @{
                                '@odata.type' = '#microsoft.graph.deviceManagementStringSettingInstance'
                                value         = 'block'
                            }
                        },
                        @{
                            Id                   = '12345-12345-12345-12345-12345'
                            DefinitionId         = 'deviceConfiguration--windows10EndpointProtectionConfiguration_defenderAdditionalGuardedFolders'
                            ValueJson            = '["main","root"]'
                            AdditionalProperties = @{
                                '@odata.type' = '#microsoft.graph.deviceManagementCollectionSettingInstance'
                            }
                        }
                    )
                }
                Mock -CommandName Get-MgBetaDeviceManagementIntentAssignment -MockWith {
                    return @()
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
