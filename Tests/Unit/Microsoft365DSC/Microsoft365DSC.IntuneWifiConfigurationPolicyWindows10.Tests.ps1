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
    -DscResource 'IntuneWifiConfigurationPolicyWindows10' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString 'test@password1' -AsPlainText -Force
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
            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }
            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'The IntuneWifiConfigurationPolicyWindows10 should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    ConnectAutomatically           = $True
                    ConnectToPreferredNetwork      = $True
                    ConnectWhenNetworkNameIsHidden = $True
                    Description                    = 'FakeStringValue'
                    DisplayName                    = 'FakeStringValue'
                    ForceFIPSCompliance            = $True
                    Id                             = 'FakeStringValue'
                    MeteredConnectionLimit         = 'unrestricted'
                    NetworkName                    = 'FakeStringValue'
                    PreSharedKey                   = 'FakeStringValue'
                    ProxyAutomaticConfigurationUrl = 'FakeStringValue'
                    ProxyManualAddress             = 'FakeStringValue'
                    ProxyManualPort                = 25
                    ProxySetting                   = 'none'
                    Ssid                           = 'FakeStringValue'
                    WifiSecurityType               = 'open'

                    Ensure                         = 'Present'
                    Credential                     = $Credential
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

        Context -Name 'The IntuneWifiConfigurationPolicyWindows10 exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    ConnectAutomatically           = $True
                    ConnectToPreferredNetwork      = $True
                    ConnectWhenNetworkNameIsHidden = $True
                    Description                    = 'FakeStringValue'
                    DisplayName                    = 'FakeStringValue'
                    ForceFIPSCompliance            = $True
                    Id                             = 'FakeStringValue'
                    MeteredConnectionLimit         = 'unrestricted'
                    NetworkName                    = 'FakeStringValue'
                    PreSharedKey                   = 'FakeStringValue'
                    ProxyAutomaticConfigurationUrl = 'FakeStringValue'
                    ProxyManualAddress             = 'FakeStringValue'
                    ProxyManualPort                = 25
                    ProxySetting                   = 'none'
                    Ssid                           = 'FakeStringValue'
                    WifiSecurityType               = 'open'

                    Ensure                         = 'Absent'
                    Credential                     = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            ForceFIPSCompliance            = $True
                            NetworkName                    = 'FakeStringValue'
                            MeteredConnectionLimit         = 'unrestricted'
                            '@odata.type'                  = '#microsoft.graph.windowsWifiConfiguration'
                            PreSharedKey                   = 'FakeStringValue'
                            WifiSecurityType               = 'open'
                            ProxyManualPort                = 25
                            ProxyManualAddress             = 'FakeStringValue'
                            ConnectWhenNetworkNameIsHidden = $True
                            ProxySetting                   = 'none'
                            ProxyAutomaticConfigurationUrl = 'FakeStringValue'
                            ConnectAutomatically           = $True
                            ConnectToPreferredNetwork      = $True
                            Ssid                           = 'FakeStringValue'

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
        Context -Name 'The IntuneWifiConfigurationPolicyWindows10 Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    ConnectAutomatically           = $True
                    ConnectToPreferredNetwork      = $True
                    ConnectWhenNetworkNameIsHidden = $True
                    Description                    = 'FakeStringValue'
                    DisplayName                    = 'FakeStringValue'
                    ForceFIPSCompliance            = $True
                    Id                             = 'FakeStringValue'
                    MeteredConnectionLimit         = 'unrestricted'
                    NetworkName                    = 'FakeStringValue'
                    PreSharedKey                   = 'FakeStringValue'
                    ProxyAutomaticConfigurationUrl = 'FakeStringValue'
                    ProxyManualAddress             = 'FakeStringValue'
                    ProxyManualPort                = 25
                    ProxySetting                   = 'none'
                    Ssid                           = 'FakeStringValue'
                    WifiSecurityType               = 'open'

                    Ensure                         = 'Present'
                    Credential                     = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            ForceFIPSCompliance            = $True
                            NetworkName                    = 'FakeStringValue'
                            MeteredConnectionLimit         = 'unrestricted'
                            '@odata.type'                  = '#microsoft.graph.windowsWifiConfiguration'
                            PreSharedKey                   = 'FakeStringValue'
                            WifiSecurityType               = 'open'
                            ProxyManualPort                = 25
                            ProxyManualAddress             = 'FakeStringValue'
                            ConnectWhenNetworkNameIsHidden = $True
                            ProxySetting                   = 'none'
                            ProxyAutomaticConfigurationUrl = 'FakeStringValue'
                            ConnectAutomatically           = $True
                            ConnectToPreferredNetwork      = $True
                            Ssid                           = 'FakeStringValue'

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

        Context -Name 'The IntuneWifiConfigurationPolicyWindows10 exists and values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    ConnectAutomatically           = $True
                    ConnectToPreferredNetwork      = $True
                    ConnectWhenNetworkNameIsHidden = $True
                    Description                    = 'FakeStringValue'
                    DisplayName                    = 'FakeStringValue'
                    ForceFIPSCompliance            = $True
                    Id                             = 'FakeStringValue'
                    MeteredConnectionLimit         = 'unrestricted'
                    NetworkName                    = 'FakeStringValue'
                    PreSharedKey                   = 'FakeStringValue'
                    ProxyAutomaticConfigurationUrl = 'FakeStringValue'
                    ProxyManualAddress             = 'FakeStringValue'
                    ProxyManualPort                = 25
                    ProxySetting                   = 'none'
                    Ssid                           = 'FakeStringValue'
                    WifiSecurityType               = 'open'

                    Ensure                         = 'Present'
                    Credential                     = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            '@odata.type'                  = '#microsoft.graph.windowsWifiConfiguration'
                            NetworkName                    = 'FakeStringValue'
                            MeteredConnectionLimit         = 'unrestricted'
                            WifiSecurityType               = 'open'
                            ProxyAutomaticConfigurationUrl = 'FakeStringValue'
                            PreSharedKey                   = 'FakeStringValue'
                            ProxyManualPort                = 7
                            Ssid                           = 'FakeStringValue'
                            ProxyManualAddress             = 'FakeStringValue'
                            ProxySetting                   = 'none'

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
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            ForceFIPSCompliance            = $True
                            NetworkName                    = 'FakeStringValue'
                            MeteredConnectionLimit         = 'unrestricted'
                            '@odata.type'                  = '#microsoft.graph.windowsWifiConfiguration'
                            PreSharedKey                   = 'FakeStringValue'
                            WifiSecurityType               = 'open'
                            ProxyManualPort                = 25
                            ProxyManualAddress             = 'FakeStringValue'
                            ConnectWhenNetworkNameIsHidden = $True
                            ProxySetting                   = 'none'
                            ProxyAutomaticConfigurationUrl = 'FakeStringValue'
                            ConnectAutomatically           = $True
                            ConnectToPreferredNetwork      = $True
                            Ssid                           = 'FakeStringValue'

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
