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
    -DscResource 'TeamsTenantNetworkSite' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString 'f@kepassword1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Set-CsTenantNetworkSite -MockWith {
            }

            Mock -CommandName New-CsTenantNetworkSite -MockWith {
            }

            Mock -CommandName Remove-CsTenantNetworkSite -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name 'The TeamsTenantNetworkSite should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity                   = 'FakeStringValue'
                    EnableLocationBasedRouting = $False
                    Ensure                     = 'Present'
                    Credential                 = $Credential
                }

                Mock -CommandName Get-CsTenantNetworkSite -MockWith {
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
                Should -Invoke -CommandName New-CsTenantNetworkSite -Exactly 1
            }
        }

        Context -Name 'The TeamsTenantNetworkSite exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity                   = 'FakeStringValue'
                    EnableLocationBasedRouting = $False
                    Ensure                     = 'Absent'
                    Credential                 = $Credential
                }

                Mock -CommandName Get-CsTenantNetworkSite -MockWith {
                    return @{
                        LocationPolicy             = 'FakeStringValue'
                        EmergencyCallRoutingPolicy = 'FakeStringValue'
                        Description                = 'FakeStringValue'
                        SiteAddress                = 'FakeStringValue'
                        NetworkRegionID            = 'FakeStringValue'
                        EnableLocationBasedRouting = $True
                        Identity                   = 'FakeStringValue'
                        NetworkRoamingPolicy       = 'FakeStringValue'
                        EmergencyCallingPolicy     = 'FakeStringValue'
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
                Should -Invoke -CommandName Remove-CsTenantNetworkSite -Exactly 1
            }
        }

        Context -Name 'The TeamsTenantNetworkSite Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity                   = 'FakeStringValue'
                    EnableLocationBasedRouting = $True
                    Ensure                     = 'Present'
                    Credential                 = $Credential
                }

                Mock -CommandName Get-CsTenantNetworkSite -MockWith {
                    return @{
                        LocationPolicy             = 'FakeStringValue'
                        EmergencyCallRoutingPolicy = 'FakeStringValue'
                        Description                = 'FakeStringValue'
                        SiteAddress                = 'FakeStringValue'
                        NetworkRegionID            = 'FakeStringValue'
                        EnableLocationBasedRouting = $True
                        Identity                   = 'FakeStringValue'
                        NetworkRoamingPolicy       = 'FakeStringValue'
                        EmergencyCallingPolicy     = 'FakeStringValue'
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'The TeamsTenantNetworkSite exists and values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity                   = 'FakeStringValue'
                    EnableLocationBasedRouting = $False
                    Ensure                     = 'Present'
                    Credential                 = $Credential
                }

                Mock -CommandName Get-CsTenantNetworkSite -MockWith {
                    return @{
                        LocationPolicy             = 'FakeStringValueDrift #Drift'
                        EmergencyCallRoutingPolicy = 'FakeStringValueDrift #Drift'
                        Description                = 'FakeStringValueDrift #Drift'
                        SiteAddress                = 'FakeStringValueDrift #Drift'
                        NetworkRegionID            = 'FakeStringValueDrift #Drift'
                        EnableLocationBasedRouting = $True
                        Identity                   = 'FakeStringValue'
                        NetworkRoamingPolicy       = 'FakeStringValueDrift #Drift'
                        EmergencyCallingPolicy     = 'FakeStringValueDrift #Drift'
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
                Should -Invoke -CommandName Set-CsTenantNetworkSite -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-CsTenantNetworkSite -MockWith {
                    return @{
                        LocationPolicy             = 'FakeStringValue'
                        EmergencyCallRoutingPolicy = 'FakeStringValue'
                        Description                = 'FakeStringValue'
                        SiteAddress                = 'FakeStringValue'
                        NetworkRegionID            = 'FakeStringValue'
                        EnableLocationBasedRouting = $True
                        Identity                   = 'FakeStringValue'
                        NetworkRoamingPolicy       = 'FakeStringValue'
                        EmergencyCallingPolicy     = 'FakeStringValue'

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
