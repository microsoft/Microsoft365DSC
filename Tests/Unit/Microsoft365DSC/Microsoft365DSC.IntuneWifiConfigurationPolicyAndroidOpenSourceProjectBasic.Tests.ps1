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
    -DscResource 'IntuneWifiConfigurationPolicyAndroidOpenSourceProjectBasic' -GenericStubModule $GenericStubPath
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
        }

        # Test contexts
        Context -Name 'The IntuneWifiConfigurationPolicyAndroidOpenSourceProjectBasic should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    ConnectAutomatically           = $True
                    ConnectWhenNetworkNameIsHidden = $True
                    Description                    = 'FakeStringValue'
                    DisplayName                    = 'FakeStringValue'
                    Id                             = 'FakeStringValue'
                    NetworkName                    = 'FakeStringValue'
                    PreSharedKey                   = 'FakeStringValue'
                    PreSharedKeyIsSet              = $True
                    Ssid                           = 'FakeStringValue'
                    WiFiSecurityType               = 'open'

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

        Context -Name 'The IntuneWifiConfigurationPolicyAndroidOpenSourceProjectBasic exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    ConnectAutomatically           = $True
                    ConnectWhenNetworkNameIsHidden = $True
                    Description                    = 'FakeStringValue'
                    DisplayName                    = 'FakeStringValue'
                    Id                             = 'FakeStringValue'
                    NetworkName                    = 'FakeStringValue'
                    PreSharedKey                   = 'FakeStringValue'
                    PreSharedKeyIsSet              = $True
                    Ssid                           = 'FakeStringValue'
                    WiFiSecurityType               = 'open'

                    Ensure                         = 'Absent'
                    Credential                     = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            '@odata.type'                  = '#microsoft.graph.aospDeviceOwnerWifiConfiguration'
                            NetworkName                    = 'FakeStringValue'
                            WiFiSecurityType               = 'open'
                            ConnectAutomatically           = $True
                            PreSharedKey                   = 'FakeStringValue'
                            ConnectWhenNetworkNameIsHidden = $True
                            Ssid                           = 'FakeStringValue'
                            PreSharedKeyIsSet              = $True

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
        Context -Name 'The IntuneWifiConfigurationPolicyAndroidOpenSourceProjectBasic exists and values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    ConnectAutomatically           = $True
                    ConnectWhenNetworkNameIsHidden = $True
                    Description                    = 'FakeStringValue'
                    DisplayName                    = 'FakeStringValue'
                    Id                             = 'FakeStringValue'
                    NetworkName                    = 'FakeStringValue'
                    PreSharedKey                   = 'FakeStringValue'
                    PreSharedKeyIsSet              = $True
                    Ssid                           = 'FakeStringValue'
                    WiFiSecurityType               = 'open'

                    Ensure                         = 'Present'
                    Credential                     = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            '@odata.type'                  = '#microsoft.graph.aospDeviceOwnerWifiConfiguration'
                            NetworkName                    = 'FakeStringValue'
                            WiFiSecurityType               = 'open'
                            ConnectAutomatically           = $True
                            PreSharedKey                   = 'FakeStringValue'
                            ConnectWhenNetworkNameIsHidden = $True
                            Ssid                           = 'FakeStringValue'
                            PreSharedKeyIsSet              = $True

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

        Context -Name 'The IntuneWifiConfigurationPolicyAndroidOpenSourceProjectBasic exists and values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    ConnectAutomatically           = $True
                    ConnectWhenNetworkNameIsHidden = $True
                    Description                    = 'FakeStringValue'
                    DisplayName                    = 'FakeStringValue'
                    Id                             = 'FakeStringValue'
                    NetworkName                    = 'FakeStringValue'
                    PreSharedKey                   = 'FakeStringValue'
                    PreSharedKeyIsSet              = $True
                    Ssid                           = 'FakeStringValue'
                    WiFiSecurityType               = 'open'

                    Ensure                         = 'Present'
                    Credential                     = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            Ssid             = 'FakeStringValue'
                            NetworkName      = 'FakeStringValue'
                            WiFiSecurityType = 'open'
                            PreSharedKey     = 'FakeStringValue'
                            '@odata.type'    = '#microsoft.graph.aospDeviceOwnerWifiConfiguration'

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
                            '@odata.type'                  = '#microsoft.graph.aospDeviceOwnerWifiConfiguration'
                            NetworkName                    = 'FakeStringValue'
                            WiFiSecurityType               = 'open'
                            ConnectAutomatically           = $True
                            PreSharedKey                   = 'FakeStringValue'
                            ConnectWhenNetworkNameIsHidden = $True
                            Ssid                           = 'FakeStringValue'
                            PreSharedKeyIsSet              = $True

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
