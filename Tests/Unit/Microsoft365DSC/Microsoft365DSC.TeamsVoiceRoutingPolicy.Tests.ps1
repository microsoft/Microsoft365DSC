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
    -DscResource 'TeamsVoiceRoutingPolicy' -GenericStubModule $GenericStubPath

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

            Mock -CommandName New-CsOnlineVoiceRoutingPolicy -MockWith {
            }

            Mock -CommandName Set-CsOnlineVoiceRoutingPolicy -MockWith {
            }

            Mock -CommandName Remove-CsOnlineVoiceRoutingPolicy -MockWith {
            }

            Mock -CommandName Get-CsOnlinePstnUsage -MockWith {
                return New-Object PSObject -Property @{
                    Identity = 'Global'
                    Usage    = @('Local', 'Long Distance')
                }
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name "When the policy doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity         = 'Test Policy'
                    OnlinePstnUsages = @('Local', 'Long Distance')
                    Description      = 'My Test Policy'
                    Ensure           = 'Present'
                    Credential       = $Credential
                }

                Mock -CommandName Get-CsOnlineVoiceRoutingPolicy -MockWith {
                    return $null
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create the policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-CsOnlineVoiceRoutingPolicy' -Exactly 1
            }
        }

        Context -Name 'When the policy already exists and is NOT in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity         = 'Test Policy'
                    OnlinePstnUsages = @('Local', 'Long Distance')
                    Description      = 'My Test Policy'
                    Ensure           = 'Present'
                    Credential       = $Credential
                }

                Mock -CommandName Get-CsOnlineVoiceRoutingPolicy -MockWith {
                    return @{
                        Identity         = 'Test Policy'
                        OnlinePstnUsages = @('Local') #Drift
                        Description      = 'My Test Policy'
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update the policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-CsOnlineVoiceRoutingPolicy -Exactly 1
            }
        }

        Context -Name 'When the policy already exists and IS in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity         = 'Test Policy'
                    OnlinePstnUsages = @('Local', 'Long Distance')
                    Description      = 'My Test Policy'
                    Ensure           = 'Present'
                    Credential       = $Credential
                }

                Mock -CommandName Get-CsOnlineVoiceRoutingPolicy -MockWith {
                    return @{
                        Identity         = 'Test Policy'
                        OnlinePstnUsages = @('Local', 'Long Distance')
                        Description      = 'My Test Policy'
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'When the policy already exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity   = 'Test Policy'
                    Ensure     = 'Absent'
                    Credential = $Credential
                }

                Mock -CommandName Get-CsOnlineVoiceRoutingPolicy -MockWith {
                    return @{
                        Identity         = 'Test Policy'
                        OnlinePstnUsages = @('Local')
                        Description      = 'My Test Policy'
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
                Should -Invoke -CommandName Remove-CsOnlineVoiceRoutingPolicy -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-CsOnlineVoiceRoutingPolicy -MockWith {
                    return @{
                        Identity         = 'Test Policy'
                        OnlinePstnUsages = @('Local')
                        Description      = 'My Test Policy'
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
