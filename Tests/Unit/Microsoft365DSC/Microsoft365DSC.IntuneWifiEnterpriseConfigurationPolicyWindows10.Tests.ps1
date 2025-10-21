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

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -ModuleName M365DSCUtil -CommandName Confirm-M365DSCDependencies -MockWith {
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

            Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {

                return @{
                    AdditionalProperties = @{
                        ConnectAutomatically                            = $True
                        ConnectToPreferredNetwork                       = $True
                        ConnectWhenNetworkNameIsHidden                  = $False
                        ForceFIPSCompliance                             = $True
                        MeteredConnectionLimit                          = 'unrestricted'
                        NetworkName                                     = 'FakeWifiName'
                        PreSharedKey                                    = 'FakeKey'
                        ProxyAutomaticConfigurationUrl                  = 'FakeAutoConfigURL'
                        ProxyManualAddress                              = 'FakeManualAddress'
                        ProxyManualPort                                 = 42
                        ProxySetting                                    = 'none'
                        Ssid                                            = 'fakessid'
                        WifiSecurityType                                = 'wpa2Enterprise'
                        NetworkSingleSignOn                             = 'disabled'
                        MaximumAuthenticationTimeoutInSeconds           = 60
                        UserBasedVirtualLan                             = $True
                        PromptForAdditionalAuthenticationCredentials    = $True
                        EnablePairwiseMasterKeyCaching                  = $True
                        MaximumPairwiseMasterKeyCacheTimeInMinutes      = 42
                        MaximumNumberOfPairwiseMasterKeysInCache        = 42
                        EnablePreAuthentication                         = $True
                        MaximumPreAuthenticationAttempts                = 7
                        EapType                                         = 'eapTls'
                        TrustedServerCertificateNames                   = @(
                            'fakecertificate'
                        )
                        AuthenticationMethod                            = 'certificate'
                        InnerAuthenticationProtocolForEAPTTLS           = 'microsoftChap'
                        OuterIdentityPrivacyTemporaryValue              = 'fakeString'
                        RequireCryptographicBinding                     = $True
                        PerformServerValidation                         = $True
                        DisableUserPromptForServerValidation            = $True
                        AuthenticationPeriodInSeconds                   = 42
                        AuthenticationRetryDelayPeriodInSeconds         = 42
                        EapolStartPeriodInSeconds                       = 42
                        MaximumEAPOLStartMessages                       = 42
                        MaximumAuthenticationFailures                   = 42
                        CacheCredentials                                = $False
                        AuthenticationType                              = 'user'
                    }
                    Description          = 'FakeStringValue'
                    DisplayName          = 'FakeStringValue'
                    Id                   = 'FakeStringValue'

                }
            }

            # Mock Write-M365DSCHost to hide output during the tests
            Mock -CommandName Write-M365DSCHost -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'The IntuneWifiEnterpriseConfigurationPolicyWindows10 should exist but it DOES NOT' -Fixture {
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
                    ProxySetting                   = 'automatic'
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

        Context -Name 'The IntuneWifiEnterpriseConfigurationPolicyWindows10 exists but it SHOULD NOT' -Fixture {
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
                    ProxySetting                   = 'automatic'
                    Ssid                           = 'FakeStringValue'
                    WifiSecurityType               = 'open'
                    Ensure                         = 'Absent'
                    Credential                     = $Credential
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
        Context -Name 'The IntuneWifiEnterpriseConfigurationPolicyWindows10 Exists and Values are already in the desired state' -Fixture {
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
                    ProxySetting                   = 'automatic'
                    Ssid                           = 'FakeStringValue'
                    WifiSecurityType               = 'open'
                    Ensure                         = 'Present'
                    Credential                     = $Credential
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
                    ProxyManualPort                = 8443 # Updated property
                    ProxySetting                   = 'automatic'
                    Ssid                           = 'FakeStringValue'
                    WifiSecurityType               = 'open'
                    Ensure                         = 'Present'
                    Credential                     = $Credential
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
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
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
