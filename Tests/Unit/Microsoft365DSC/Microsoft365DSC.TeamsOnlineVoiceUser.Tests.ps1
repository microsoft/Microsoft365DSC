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
    -DscResource 'TeamsOnlineVoiceUser' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'Pass@word1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin', $secpasswd)

            $Global:PartialExportFileName = "c:\TestPath"
            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {
                return "FakeDSCContent"
            }
            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            Mock -CommandName Set-CsPhoneNumberAssignment -MockWith {
            }
        }

        # Test contexts
        Context -Name "When the user isn't assigned" -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity        = "John.Smith@Contoso.com"
                    TelephoneNumber = '+14255043920'
                    LocationId      = "c7c5a17f-00d7-47c0-9ddb-3383229d606b"
                    Ensure          = 'Present'
                    Credential      = $Credential;
                }

                Mock -CommandName Get-CsOnlineVOiceUser -MockWith {
                    return $null
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should create the policy from the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Set-CsPhoneNumberAssignment' -Exactly 1
            }
        }

        Context -Name 'When the assignment already exists and IS in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity        = "John.Smith@Contoso.com"
                    TelephoneNumber = '+14255043920'
                    LocationId      = "c7c5a17f-00d7-47c0-9ddb-3383229d606b"
                    Ensure          = 'Present'
                    Credential      = $Credential;
                }

                Mock -CommandName Get-CsOnlineVOiceUser -MockWith {
                    return @{
                        Number = '+14255043920'
                        Location      = "c7c5a17f-00d7-47c0-9ddb-3383229d606b"
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'When the assignment already exists but is NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity        = "John.Smith@Contoso.com"
                    TelephoneNumber = '+14255043920'
                    LocationId      = "c7c5a17f-00d7-47c0-9ddb-3383229d606b"
                    Ensure          = 'Present'
                    Credential      = $Credential;
                }

                Mock -CommandName Get-CsOnlineVOiceUser -MockWith {
                    return @{
                        Number   = '+15555555555' #Drift
                        Location = "c7c5a17f-00d7-47c0-9ddb-3383229d606b"
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
                Should -Invoke -CommandName Set-CsPhoneNumberAssignment -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential     = $Credential;
                }

                Mock -CommandName Get-CsOnlineVOiceUser -MockWith {
                    return @{
                        Number = '+14255043920'
                        Location      = "c7c5a17f-00d7-47c0-9ddb-3383229d606b"
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
