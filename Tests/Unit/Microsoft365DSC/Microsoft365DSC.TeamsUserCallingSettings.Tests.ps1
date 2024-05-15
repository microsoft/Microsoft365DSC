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
    -DscResource 'TeamsUserCallingSettings' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString ((New-Guid).ToString()) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            $Global:PartialExportFileName = 'c:\TestPath'

            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Set-CsUserCallingSettings -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'When no settings are assigned to a user' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity        = 'Test Settings'
                    CallGroupOrder  = 'Simultaneous'
                    Ensure          = 'Present'
                    Credential      = $Credential
                    UnansweredDelay = '00:00:20'
                }

                Mock -CommandName Get-CsUserCallingSettings -MockWith {
                    return $null
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should assign settings in the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-CsUserCallingSettings -Exactly 1
            }
        }

        Context -Name 'Settings exists but is not in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity        = 'Test Settings'
                    CallGroupOrder  = 'Simultaneous'
                    Ensure          = 'Present'
                    Credential      = $Credential
                    UnansweredDelay = '00:00:20'
                }

                Mock -CommandName Get-CsUserCallingSettings -MockWith {
                    return @{
                        CallGroupOrder  = 'Simultaneous'
                        UnansweredDelay = '00:00:30'; # Drift
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
                Should -Invoke -CommandName Set-CsUserCallingSettings -Exactly 1
            }
        }

        Context -Name 'Settings exists and is already in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity        = 'Test Settings'
                    CallGroupOrder  = 'Simultaneous'
                    Ensure          = 'Present'
                    Credential      = $Credential
                    UnansweredDelay = '00:00:20'
                }

                Mock -CommandName Get-CsUserCallingSettings -MockWith {
                    return @{
                        CallGroupOrder  = 'Simultaneous'
                        UnansweredDelay = '00:00:20'
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

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }


                Mock -CommandName Get-MgUser -MockWith {
                    return @(
                        @{
                            UserPrincipalName = 'John.Smith@contoso.onmicrosoft.com'
                        }
                    )
                }

                Mock -CommandName Get-CsUserCallingSettings -MockWith {
                    return @{
                        CallGroupOrder  = 'Simultaneous'
                        UnansweredDelay = '00:00:20'
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
