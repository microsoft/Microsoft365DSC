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
    -DscResource 'TeamsEmergencyCallRoutingPolicy' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'Pass@word1)' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            $Global:PartialExportFileName = 'c:\TestPath'


            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName New-CsTeamsEmergencyCallRoutingPolicy -MockWith {
            }

            Mock -CommandName New-CsTeamsEmergencyNumber -MockWith {
                return New-Object PSObject
            }

            Mock -CommandName Set-CsTeamsEmergencyCallRoutingPolicy -MockWith {
            }

            Mock -CommandName Remove-CsTeamsEmergencyCallRoutingPolicy -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "When Policy doesn't exist but should" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowEnhancedEmergencyServices = $False
                    Description                    = 'Desc'
                    EmergencyNumbers               = (New-CimInstance -ClassName MSFT_TeamsEmergencyNumber -Property @{
                            EmergencyDialString = '123456'
                            EmergencyDialMask   = '123'
                            OnlinePSTNUsage     = ''
                        } -ClientOnly)
                    Ensure                         = 'Present'
                    Credential                     = $Credential
                    Identity                       = 'UnitTest'
                }

                Mock -CommandName Get-CsTeamsMeetingPolicy -MockWith {
                    return $null
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create the policy in the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-CsTeamsEmergencyCallRoutingPolicy -Exactly 1
            }
        }

        Context -Name 'Policy exists but is not in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowEnhancedEmergencyServices = $False
                    Description                    = 'Drifted'; #drift
                    EmergencyNumbers               = (New-CimInstance -ClassName MSFT_TeamsEmergencyNumber -Property @{
                            EmergencyDialString = '123456'
                            EmergencyDialMask   = '123'
                            OnlinePSTNUsage     = ''
                        } -ClientOnly)
                    Ensure                         = 'Present'
                    Credential                     = $Credential
                    Identity                       = 'UnitTest'
                }

                Mock -CommandName Get-CsTeamsEmergencyCallRoutingPolicy -MockWith {
                    return @{
                        AllowEnhancedEmergencyServices = $False
                        Description                    = 'Desc'
                        EmergencyNumbers               = @{
                            EmergencyDialString = '123456'
                            EmergencyDialMask   = '123'
                            OnlinePSTNUsage     = ''
                        }
                        Identity                       = 'UnitTest'
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update the settings from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-CsTeamsEmergencyCallRoutingPolicy -Exactly 1
                Should -Invoke -CommandName New-CsTeamsEmergencyCallRoutingPolicy -Exactly 0
            }
        }

        Context -Name 'Policy exists and is already in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowEnhancedEmergencyServices = $False
                    Description                    = 'Drifted'; #drift
                    EmergencyNumbers               = (New-CimInstance -ClassName MSFT_TeamsEmergencyNumber -Property @{
                            EmergencyDialString = '123456'
                            EmergencyDialMask   = '123'
                            OnlinePSTNUsage     = ''
                        } -ClientOnly)
                    Ensure                         = 'Present'
                    Credential                     = $Credential
                    Identity                       = 'UnitTest'
                }

                Mock -CommandName Get-CsTeamsEmergencyCallRoutingPolicy -MockWith {
                    return @{
                        AllowEnhancedEmergencyServices = $False
                        Description                    = 'Drifted'; #drift
                        EmergencyNumbers               = @{
                            EmergencyDialString = '123456'
                            EmergencyDialMask   = '123'
                            OnlinePSTNUsage     = ''
                        }
                        Identity                       = 'UnitTest'
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'Policy exists but it should not' -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowEnhancedEmergencyServices = $False
                    Description                    = 'Drifted'; #drift
                    EmergencyNumbers               = (New-CimInstance -ClassName MSFT_TeamsEmergencyNumber -Property @{
                            EmergencyDialString = '123456'
                            EmergencyDialMask   = '123'
                            OnlinePSTNUsage     = ''
                        } -ClientOnly)
                    Ensure                         = 'Absent'
                    Credential                     = $Credential
                    Identity                       = 'UnitTest'
                }

                Mock -CommandName Get-CsTeamsEmergencyCallRoutingPolicy -MockWith {
                    return @{
                        AllowEnhancedEmergencyServices = $False
                        Description                    = 'Drifted'; #drift
                        EmergencyNumbers               = @{
                            EmergencyDialString = '123456'
                            EmergencyDialMask   = '123'
                            OnlinePSTNUsage     = ''
                        }
                        Identity                       = 'UnitTest'
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-CsTeamsEmergencyCallRoutingPolicy -Exactly 1
            }
        }

        Context -Name 'When the No Optional Parameters are Specified' -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential = $Credential
                    Identity   = 'UnitTest'
                }
            }

            It 'Should throw an error from the Set method' {
                { Set-TargetResource @testParams } | Should -Throw
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-CsTeamsEmergencyCallRoutingPolicy -MockWith {
                    return @{
                        AllowEnhancedEmergencyServices = $False
                        Description                    = 'Drifted'; #drift
                        EmergencyNumbers               = @{
                            EmergencyDialString = '123456'
                            EmergencyDialMask   = '123'
                            OnlinePSTNUsage     = ''
                        }
                        Identity                       = 'UnitTest'
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
