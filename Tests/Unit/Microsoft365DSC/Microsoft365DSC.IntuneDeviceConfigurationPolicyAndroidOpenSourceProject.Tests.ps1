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
    -DscResource 'IntuneDeviceConfigurationPolicyAndroidOpenSourceProject' -GenericStubModule $GenericStubPath
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

            Mock -CommandName Update-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
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
        Context -Name 'The IntuneDeviceConfigurationPolicyAndroidOpenSourceProject should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    AppsBlockInstallFromUnknownSources             = $True
                    BluetoothBlockConfiguration                    = $True
                    BluetoothBlocked                               = $True
                    CameraBlocked                                  = $True
                    Description                                    = 'FakeStringValue'
                    DisplayName                                    = 'FakeStringValue'
                    FactoryResetBlocked                            = $True
                    Id                                             = 'FakeStringValue'
                    PasswordMinimumLength                          = 25
                    PasswordMinutesOfInactivityBeforeScreenTimeout = 25
                    PasswordRequiredType                           = 'deviceDefault'
                    PasswordSignInFailureCountBeforeFactoryReset   = 25
                    ScreenCaptureBlocked                           = $True
                    SecurityAllowDebuggingFeatures                 = $True
                    StorageBlockExternalMedia                      = $True
                    StorageBlockUsbFileTransfer                    = $True
                    WifiBlockEditConfigurations                    = $True

                    Ensure                                         = 'Present'
                    Credential                                     = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
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
                Should -Invoke -CommandName New-MgBetaDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name 'The IntuneDeviceConfigurationPolicyAndroidOpenSourceProject exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    AppsBlockInstallFromUnknownSources             = $True
                    BluetoothBlockConfiguration                    = $True
                    BluetoothBlocked                               = $True
                    CameraBlocked                                  = $True
                    Description                                    = 'FakeStringValue'
                    DisplayName                                    = 'FakeStringValue'
                    FactoryResetBlocked                            = $True
                    Id                                             = 'FakeStringValue'
                    PasswordMinimumLength                          = 25
                    PasswordMinutesOfInactivityBeforeScreenTimeout = 25
                    PasswordRequiredType                           = 'deviceDefault'
                    PasswordSignInFailureCountBeforeFactoryReset   = 25
                    ScreenCaptureBlocked                           = $True
                    SecurityAllowDebuggingFeatures                 = $True
                    StorageBlockExternalMedia                      = $True
                    StorageBlockUsbFileTransfer                    = $True
                    WifiBlockEditConfigurations                    = $True

                    Ensure                                         = 'Absent'
                    Credential                                     = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            ScreenCaptureBlocked                           = $True
                            PasswordMinimumLength                          = 25
                            BluetoothBlocked                               = $True
                            '@odata.type'                                  = '#microsoft.graph.'
                            AppsBlockInstallFromUnknownSources             = $True
                            FactoryResetBlocked                            = $True
                            CameraBlocked                                  = $True
                            PasswordRequiredType                           = 'deviceDefault'
                            PasswordMinutesOfInactivityBeforeScreenTimeout = 25
                            StorageBlockUsbFileTransfer                    = $True
                            WifiBlockEditConfigurations                    = $True
                            PasswordSignInFailureCountBeforeFactoryReset   = 25
                            SecurityAllowDebuggingFeatures                 = $True
                            StorageBlockExternalMedia                      = $True
                            BluetoothBlockConfiguration                    = $True

                        }
                        Description          = 'FakeStringValue'
                        DisplayName          = 'FakeStringValue'
                        Id                   = 'FakeStringValue'

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
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementDeviceConfiguration -Exactly 1
            }
        }
        Context -Name 'The IntuneDeviceConfigurationPolicyAndroidOpenSourceProject Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    AppsBlockInstallFromUnknownSources             = $True
                    BluetoothBlockConfiguration                    = $True
                    BluetoothBlocked                               = $True
                    CameraBlocked                                  = $True
                    Description                                    = 'FakeStringValue'
                    DisplayName                                    = 'FakeStringValue'
                    FactoryResetBlocked                            = $True
                    Id                                             = 'FakeStringValue'
                    PasswordMinimumLength                          = 25
                    PasswordMinutesOfInactivityBeforeScreenTimeout = 25
                    PasswordRequiredType                           = 'deviceDefault'
                    PasswordSignInFailureCountBeforeFactoryReset   = 25
                    ScreenCaptureBlocked                           = $True
                    SecurityAllowDebuggingFeatures                 = $True
                    StorageBlockExternalMedia                      = $True
                    StorageBlockUsbFileTransfer                    = $True
                    WifiBlockEditConfigurations                    = $True

                    Ensure                                         = 'Present'
                    Credential                                     = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            ScreenCaptureBlocked                           = $True
                            PasswordMinimumLength                          = 25
                            BluetoothBlocked                               = $True
                            '@odata.type'                                  = '#microsoft.graph.'
                            AppsBlockInstallFromUnknownSources             = $True
                            FactoryResetBlocked                            = $True
                            CameraBlocked                                  = $True
                            PasswordRequiredType                           = 'deviceDefault'
                            PasswordMinutesOfInactivityBeforeScreenTimeout = 25
                            StorageBlockUsbFileTransfer                    = $True
                            WifiBlockEditConfigurations                    = $True
                            PasswordSignInFailureCountBeforeFactoryReset   = 25
                            SecurityAllowDebuggingFeatures                 = $True
                            StorageBlockExternalMedia                      = $True
                            BluetoothBlockConfiguration                    = $True

                        }
                        Description          = 'FakeStringValue'
                        DisplayName          = 'FakeStringValue'
                        Id                   = 'FakeStringValue'
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'The IntuneDeviceConfigurationPolicyAndroidOpenSourceProject exists and values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    AppsBlockInstallFromUnknownSources             = $True
                    BluetoothBlockConfiguration                    = $True
                    BluetoothBlocked                               = $True
                    CameraBlocked                                  = $True
                    Description                                    = 'FakeStringValue'
                    DisplayName                                    = 'FakeStringValue'
                    FactoryResetBlocked                            = $True
                    Id                                             = 'FakeStringValue'
                    PasswordMinimumLength                          = 25
                    PasswordMinutesOfInactivityBeforeScreenTimeout = 25
                    PasswordRequiredType                           = 'deviceDefault'
                    PasswordSignInFailureCountBeforeFactoryReset   = 25
                    ScreenCaptureBlocked                           = $True
                    SecurityAllowDebuggingFeatures                 = $True
                    StorageBlockExternalMedia                      = $True
                    StorageBlockUsbFileTransfer                    = $True
                    WifiBlockEditConfigurations                    = $True

                    Ensure                                         = 'Present'
                    Credential                                     = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            PasswordMinimumLength                          = 7
                            PasswordRequiredType                           = 'deviceDefault'
                            PasswordSignInFailureCountBeforeFactoryReset   = 7
                            PasswordMinutesOfInactivityBeforeScreenTimeout = 7
                            '@odata.type'                                  = '#microsoft.graph.'

                        }
                        Description          = 'FakeStringValue'
                        DisplayName          = 'FakeStringValue'
                        Id                   = 'FakeStringValue'

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
                Should -Invoke -CommandName Update-MgBetaDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            ScreenCaptureBlocked                           = $True
                            PasswordMinimumLength                          = 25
                            BluetoothBlocked                               = $True
                            '@odata.type'                                  = '#microsoft.graph.aospDeviceOwnerDeviceConfiguration'
                            AppsBlockInstallFromUnknownSources             = $True
                            FactoryResetBlocked                            = $True
                            CameraBlocked                                  = $True
                            PasswordRequiredType                           = 'deviceDefault'
                            PasswordMinutesOfInactivityBeforeScreenTimeout = 25
                            StorageBlockUsbFileTransfer                    = $True
                            WifiBlockEditConfigurations                    = $True
                            PasswordSignInFailureCountBeforeFactoryReset   = 25
                            SecurityAllowDebuggingFeatures                 = $True
                            StorageBlockExternalMedia                      = $True
                            BluetoothBlockConfiguration                    = $True

                        }
                        Description          = 'FakeStringValue'
                        DisplayName          = 'FakeStringValue'
                        Id                   = 'FakeStringValue'
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
