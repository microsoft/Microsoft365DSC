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
    -DscResource 'EXOOwaMailboxPolicy' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'test@password1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name 'OWA Mailbox Policy should exist. OWA Mailbox Policy is missing. Test should fail.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name                    = 'Contoso OWA Mailbox Policy'
                    InstantMessagingEnabled = $true
                    Ensure                  = 'Present'
                    Credential              = $Credential
                }

                Mock -CommandName Get-OwaMailboxPolicy -MockWith {
                    return @{
                        Name                    = 'Contoso OWA Mailbox Policy Different'
                        InstantMessagingEnabled = $true
                        FreeBusyAccessLevel     = 'AvailabilityOnly'
                    }
                }

                Mock -CommandName Set-OwaMailboxPolicy -MockWith {
                    return @{
                        Name                    = 'Contoso OWA Mailbox Policy'
                        InstantMessagingEnabled = $true
                        Ensure                  = 'Present'
                        Credential              = $Credential
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
        }

        Context -Name 'OWA Mailbox Policy should exist. OWA Mailbox Policy exists. Test should pass.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name                    = 'Contoso OWA Mailbox Policy'
                    InstantMessagingEnabled = $true
                    Ensure                  = 'Present'
                    Credential              = $Credential
                }

                Mock -CommandName Get-OwaMailboxPolicy -MockWith {
                    return @{
                        Name                    = 'Contoso OWA Mailbox Policy'
                        InstantMessagingEnabled = $true
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should return Present from the Get Method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name 'OWA Mailbox Policy should exist. OWA Mailbox Policy exists, InstantMessagingEnabled mismatch. Test should fail.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name                    = 'Contoso OWA Mailbox Policy'
                    InstantMessagingEnabled = $true
                    Ensure                  = 'Present'
                    Credential              = $Credential
                }

                Mock -CommandName Get-OwaMailboxPolicy -MockWith {
                    return @{
                        Name                    = 'Contoso OWA Mailbox Policy'
                        InstantMessagingEnabled = $false

                    }
                }

                Mock -CommandName Set-OwaMailboxPolicy -MockWith {
                    return @{
                        Name                    = 'Contoso OWA Mailbox Policy'
                        InstantMessagingEnabled = $true
                        Ensure                  = 'Present'
                        Credential              = $Credential
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                $OwaMailboxPolicy = @{
                    Name                    = 'Contoso OWA Mailbox Policy'
                    InstantMessagingEnabled = $true
                }

                Mock -CommandName Get-OwaMailboxPolicy -MockWith {
                    return $OwaMailboxPolicy
                }
            }

            It 'Should Reverse Engineer resource from the Export method when single' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
