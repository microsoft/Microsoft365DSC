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
    -DscResource 'TeamsOnlineVoiceUser' -GenericStubModule $GenericStubPath

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

            Mock -CommandName Set-CsPhoneNumberAssignment -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "When the user isn't assigned" -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity        = 'John.Smith@Contoso.com'
                    TelephoneNumber = '+14255043920'
                    LocationId      = 'c7c5a17f-00d7-47c0-9ddb-3383229d606b'
                    Ensure          = 'Present'
                    Credential      = $Credential
                }

                Mock -CommandName Get-CsOnlineUser -MockWith {
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
                Should -Invoke -CommandName 'Set-CsPhoneNumberAssignment' -Exactly 1
            }
        }

        Context -Name 'When the assignment already exists and IS in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity        = 'John.Smith@Contoso.com'
                    TelephoneNumber = '14255043920'
                    LocationId      = 'c7c5a17f-00d7-47c0-9ddb-3383229d606b'
                    Ensure          = 'Present'
                    Credential      = $Credential
                }

                Mock -CommandName Get-CsOnlineUser -MockWith {
                    return @{
                        LineUri           = 'tel:+14255043920'
                        UserPrincipalName = 'John.Smith@Contoso.com'
                    }
                }

                Mock -CommandName Get-CsPhoneNumberAssignment -MockWith {
                    return @{
                        LocationId = 'c7c5a17f-00d7-47c0-9ddb-3383229d606b'
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
                    Identity        = 'John.Smith@Contoso.com'
                    TelephoneNumber = '+14255043920'
                    LocationId      = 'c7c5a17f-00d7-47c0-9ddb-3383229d606b'
                    Ensure          = 'Present'
                    Credential      = $Credential
                }

                Mock -CommandName Get-CsOnlineUser -MockWith {
                    return @{
                        LineUri           = 'tel:+15555555555'
                        UserPrincipalName = 'John.Smith@Contoso.com'
                    }
                }

                Mock -CommandName Get-CsPhoneNumberAssignment -MockWith {
                    return @{
                        LocationId = 'c7c5a17f-00d7-47c0-9ddb-3383229d606b'
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
                    Credential = $Credential
                }

                Mock -CommandName Get-CsOnlineUser -MockWith {
                    return @{
                        LineUri           = 'tel:+15555555555'
                        UserPrincipalName = 'John.Smith@Contoso.com'
                    }
                }

                Mock -CommandName Get-CsPhoneNumberAssignment -MockWith {
                    return @{
                        LocationId = 'c7c5a17f-00d7-47c0-9ddb-3383229d606b'
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
