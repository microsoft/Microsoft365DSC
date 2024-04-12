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
    -DscResource 'TeamsUpgradePolicy' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'Pass@word1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            $Global:PartialExportFileName = 'c:\TestPath'

            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Grant-CsTeamsUpgradePolicy -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "When the policy doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity               = 'Test Policy'
                    Users                  = @('john.smith@contoso.onmicrosoft.com')
                    MigrateMeetingsToTeams = $false
                    Credential             = $Credential
                }

                Mock -CommandName Get-CsTeamsUpgradePolicy -MockWith {
                    return $null
                }
            }

            It 'Should return absent from the Get method' {
                Get-TargetResource @testParams | Should -BeOfType "System.Collections.Hashtable"
            }
        }

        Context -Name 'When the policy already exists and is NOT in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity               = 'Test Policy'
                    Users                  = @('john.smith@contoso.onmicrosoft.com')
                    MigrateMeetingsToTeams = $false
                    Credential             = $Credential
                }

                Mock -CommandName Get-CsTeamsUpgradePolicy -MockWith {
                    return @{
                        Identity       = 'Test Policy'
                        Description    = 'This is a configuration drift'
                        NotifySfBUsers = $false
                    }
                }

                Mock -CommandName Get-CsOnlineUser -MockWith {
                    return @{
                        UserPrincipalName  = 'Bob.Houle@contoso.onmicrosoft.com'
                        TeamsUpgradePolicy = 'Global'
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update the policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Grant-CsTeamsUpgradePolicy -Exactly 1
            }
        }

        Context -Name 'When the policy already exists and IS in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity               = 'Islands'
                    Users                  = @('john.smith@contoso.onmicrosoft.com')
                    MigrateMeetingsToTeams = $false
                    Credential             = $Credential
                }

                Mock -CommandName Get-CsTeamsUpgradePolicy -MockWith {
                    return @{
                        Identity       = 'Islands'
                        Description    = 'This is a test policy'
                        NotifySfBUsers = $false
                    }
                }

                Mock -CommandName Get-CsOnlineUser -MockWith {
                    return @{
                        UserPrincipalName  = 'John.Smith@contoso.onmicrosoft.com'
                        TeamsUpgradePolicy = 'Islands'
                    }
                }
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

                Mock -CommandName Get-CsTeamsUpgradePolicy -MockWith {
                    return @{
                        Identity       = 'Islands'
                        Description    = 'Test Description'
                        NotifySfBUsers = $false
                    }
                }

                Mock -CommandName Get-CsOnlineUser -MockWith {
                    return @{
                        UserPrincipalName  = 'John.Smith@contoso.onmicrosoft.com'
                        TeamsUpgradePolicy = 'Islands'
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
