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
    -DscResource 'TeamsNetworkRoamingPolicy' -GenericStubModule $GenericStubPath
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

            Mock -CommandName Set-CsTeamsNetworkRoamingPolicy -MockWith {
            }

            Mock -CommandName New-CsTeamsNetworkRoamingPolicy -MockWith {
            }

            Mock -CommandName Remove-CsTeamsNetworkRoamingPolicy -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'The TeamsNetworkRoamingPolicy should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowIPVideo   = $True
                    Description    = 'FakeStringValue'
                    MediaBitRateKb = 5000
                    Identity       = 'FakeStringValue'
                    Ensure         = 'Present'
                    Credential     = $Credential
                }

                Mock -CommandName Get-CsTeamsNetworkRoamingPolicy -MockWith {
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
                Should -Invoke -CommandName New-CsTeamsNetworkRoamingPolicy -Exactly 1
            }
        }

        Context -Name 'The TeamsNetworkRoamingPolicy exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowIPVideo   = $True
                    Description    = 'FakeStringValue'
                    MediaBitRateKb = 5000
                    Identity       = 'FakeStringValue'
                    Ensure         = 'Absent'
                    Credential     = $Credential
                }

                Mock -CommandName Get-CsTeamsNetworkRoamingPolicy -MockWith {
                    return @{
                        AllowIPVideo   = $True
                        Description    = 'FakeStringValue'
                        MediaBitRateKb = 5000
                        Identity       = 'FakeStringValue'
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
                Should -Invoke -CommandName Remove-CsTeamsNetworkRoamingPolicy -Exactly 1
            }
        }

        Context -Name 'The TeamsNetworkRoamingPolicy Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowIPVideo   = $True
                    Description    = 'FakeStringValue'
                    MediaBitRateKb = 5000
                    Identity       = 'FakeStringValue'
                    Ensure         = 'Present'
                    Credential     = $Credential
                }

                Mock -CommandName Get-CsTeamsNetworkRoamingPolicy -MockWith {
                    return @{
                        AllowIPVideo   = $True
                        Description    = 'FakeStringValue'
                        MediaBitRateKb = 5000
                        Identity       = 'FakeStringValue'
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'The TeamsNetworkRoamingPolicy exists and values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowIPVideo   = $True
                    Description    = 'FakeStringValue'
                    MediaBitRateKb = 5000
                    Identity       = 'FakeStringValue'
                    Ensure         = 'Present'
                    Credential     = $Credential
                }

                Mock -CommandName Get-CsTeamsNetworkRoamingPolicy -MockWith {
                    return @{
                        AllowIPVideo   = $False
                        Description    = 'FakeStringValueDrift #Drift'
                        MediaBitRateKb = 5000
                        Identity       = 'FakeStringValue'
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
                Should -Invoke -CommandName Set-CsTeamsNetworkRoamingPolicy -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-CsTeamsNetworkRoamingPolicy -MockWith {
                    return @{
                        AllowIPVideo   = $True
                        Description    = 'FakeStringValue'
                        MediaBitRateKb = 5000
                        Identity       = 'FakeStringValue'

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
