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
    -DscResource "IntuneWifiConfigurationPolicyIOS" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)


            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {
            }

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName New-MgDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName Remove-MgDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }
        }
        # Test contexts
        Context -Name "The IntuneWifiConfigurationPolicyIOS should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                        ConnectAutomatically = $True
                        ConnectWhenNetworkNameIsHidden = $True
                        Description = "FakeStringValue"
                        DisableMacAddressRandomization = $True
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"
                        NetworkName = "FakeStringValue"
                        PreSharedKey = "FakeStringValue"
                        ProxyAutomaticConfigurationUrl = "FakeStringValue"
                        ProxyManualAddress = "FakeStringValue"
                        ProxyManualPort = 25
                        ProxySettings = "none"
                        Ssid = "FakeStringValue"
                        WiFiSecurityType = "open"

                    Ensure                        = "Present"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return $null
                }
            }
            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Create the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name "The IntuneWifiConfigurationPolicyIOS exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                        ConnectAutomatically = $True
                        ConnectWhenNetworkNameIsHidden = $True
                        Description = "FakeStringValue"
                        DisableMacAddressRandomization = $True
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"
                        NetworkName = "FakeStringValue"
                        PreSharedKey = "FakeStringValue"
                        ProxyAutomaticConfigurationUrl = "FakeStringValue"
                        ProxyManualAddress = "FakeStringValue"
                        ProxyManualPort = 25
                        ProxySettings = "none"
                        Ssid = "FakeStringValue"
                        WiFiSecurityType = "open"

                    Ensure                        = "Absent"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties =@{
                            ProxyManualPort = 25
                            '@odata.type' = "#microsoft.graph.iosWifiConfiguration"
                            NetworkName = "FakeStringValue"
                            WiFiSecurityType = "open"
                            DisableMacAddressRandomization = $True
                            ConnectAutomatically = $True
                            ProxyAutomaticConfigurationUrl = "FakeStringValue"
                            PreSharedKey = "FakeStringValue"
                            ConnectWhenNetworkNameIsHidden = $True
                            ProxySettings = "none"
                            Ssid = "FakeStringValue"
                            ProxyManualAddress = "FakeStringValue"

                        }
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"

                    }
                }
            }

            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgDeviceManagementDeviceConfiguration -Exactly 1
            }
        }
        Context -Name "The IntuneWifiConfigurationPolicyIOS Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                        ConnectAutomatically = $True
                        ConnectWhenNetworkNameIsHidden = $True
                        Description = "FakeStringValue"
                        DisableMacAddressRandomization = $True
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"
                        NetworkName = "FakeStringValue"
                        PreSharedKey = "FakeStringValue"
                        ProxyAutomaticConfigurationUrl = "FakeStringValue"
                        ProxyManualAddress = "FakeStringValue"
                        ProxyManualPort = 25
                        ProxySettings = "none"
                        Ssid = "FakeStringValue"
                        WiFiSecurityType = "open"

                    Ensure                        = "Present"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties =@{
                            ProxyManualPort = 25
                            '@odata.type' = "#microsoft.graph.iosWifiConfiguration"
                            NetworkName = "FakeStringValue"
                            WiFiSecurityType = "open"
                            DisableMacAddressRandomization = $True
                            ConnectAutomatically = $True
                            ProxyAutomaticConfigurationUrl = "FakeStringValue"
                            PreSharedKey = "FakeStringValue"
                            ConnectWhenNetworkNameIsHidden = $True
                            ProxySettings = "none"
                            Ssid = "FakeStringValue"
                            ProxyManualAddress = "FakeStringValue"

                        }
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"

                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The IntuneWifiConfigurationPolicyIOS exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                        ConnectAutomatically = $True
                        ConnectWhenNetworkNameIsHidden = $True
                        Description = "FakeStringValue"
                        DisableMacAddressRandomization = $True
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"
                        NetworkName = "FakeStringValue"
                        PreSharedKey = "FakeStringValue"
                        ProxyAutomaticConfigurationUrl = "FakeStringValue"
                        ProxyManualAddress = "FakeStringValue"
                        ProxyManualPort = 25
                        ProxySettings = "none"
                        Ssid = "FakeStringValue"
                        WiFiSecurityType = "open"

                    Ensure                = "Present"
                    Credential            = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties =@{
                            '@odata.type' = "#microsoft.graph.iosWifiConfiguration"
                            NetworkName = "FakeStringValue"
                            WiFiSecurityType = "open"
                            ProxyAutomaticConfigurationUrl = "FakeStringValue"
                            PreSharedKey = "FakeStringValue"
                            ProxyManualPort = 7
                            ProxySettings = "none"
                            Ssid = "FakeStringValue"
                            ProxyManualAddress = "FakeStringValue"

                        }
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"

                    }
                }
            }

            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties =@{
                            ProxyManualPort = 25
                            '@odata.type' = "#microsoft.graph.iosWifiConfiguration"
                            NetworkName = "FakeStringValue"
                            WiFiSecurityType = "open"
                            DisableMacAddressRandomization = $True
                            ConnectAutomatically = $True
                            ProxyAutomaticConfigurationUrl = "FakeStringValue"
                            PreSharedKey = "FakeStringValue"
                            ConnectWhenNetworkNameIsHidden = $True
                            ProxySettings = "none"
                            Ssid = "FakeStringValue"
                            ProxyManualAddress = "FakeStringValue"

                        }
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"

                    }
                }
            }
            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
