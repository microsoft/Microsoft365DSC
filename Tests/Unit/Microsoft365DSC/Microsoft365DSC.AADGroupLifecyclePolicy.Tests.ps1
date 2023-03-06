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
    -DscResource 'AADGroupLifecyclePolicy' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString 'test@password1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgGroupLifecyclePolicy -MockWith {
            }

            Mock -CommandName Remove-MgGroupLifecyclePolicy -MockWith {
            }

            Mock -CommandName New-MgGroupLifecyclePolicy -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name 'The Policy should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    AlternateNotificationEmails = @('john.smith@contoso.com')
                    Ensure                      = 'Present'
                    Credential                  = $Credential
                    GroupLifetimeInDays         = 99
                    IsSingleInstance            = 'Yes'
                    ManagedGroupTypes           = 'Selected'
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-MgGroupLifecyclePolicy -MockWith {
                    return $null
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
                Should -Invoke -CommandName 'Get-MgGroupLifecyclePolicy' -Exactly 1
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            $Script:calledOnceAlready = $false
            It 'Should Create the Policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-MgGroupLifecyclePolicy' -Exactly 1
                Should -Invoke -CommandName 'Update-MgGroupLifecyclePolicy' -Exactly 0
                Should -Invoke -CommandName 'Remove-MgGroupLifecyclePolicy' -Exactly 0
            }
        }

        Context -Name 'The Policy exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    AlternateNotificationEmails = @('john.smith@contoso.com', 'bob.houle@contoso.com')
                    Ensure                      = 'Absent'
                    Credential                  = $Credential
                    GroupLifetimeInDays         = 99
                    IsSingleInstance            = 'Yes'
                    ManagedGroupTypes           = 'Selected'
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-MgGroupLifecyclePolicy -MockWith {
                    return @{
                        AlternateNotificationEmails = @('john.smith@contoso.com', 'bob.houle@contoso.com')
                        GroupLifetimeInDays         = 99
                        ManagedGroupTypes           = 'Selected'
                        Id                          = '12345-12345-12345-12345-12345'
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
                Should -Invoke  -CommandName 'Get-MgGroupLifecyclePolicy' -Exactly 1
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the Policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-MgGroupLifecyclePolicy' -Exactly 0
                Should -Invoke -CommandName 'Update-MgGroupLifecyclePolicy' -Exactly 0
                Should -Invoke -CommandName 'Remove-MgGroupLifecyclePolicy' -Exactly 1
            }
        }

        Context -Name 'The Policy Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    AlternateNotificationEmails = @('john.smith@contoso.com', 'bob.houle@contoso.com')
                    Ensure                      = 'Present'
                    Credential                  = $Credential
                    GroupLifetimeInDays         = 99
                    IsSingleInstance            = 'Yes'
                    ManagedGroupTypes           = 'Selected'
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-MgGroupLifecyclePolicy -MockWith {
                    return @{
                        AlternateNotificationEmails = @('john.smith@contoso.com', 'bob.houle@contoso.com')
                        GroupLifetimeInDays         = 99
                        ManagedGroupTypes           = 'Selected'
                        Id                          = '12345-12345-12345-12345-12345'
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
                Should -Invoke -CommandName 'Get-MgGroupLifecyclePolicy' -Exactly 1
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'Values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    AlternateNotificationEmails = @('john.smith@contoso.com', 'bob.houle@contoso.com')
                    Ensure                      = 'Present'
                    Credential                  = $Credential
                    GroupLifetimeInDays         = 77; #Drift
                    IsSingleInstance            = 'Yes'
                    ManagedGroupTypes           = 'Selected'
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-MgGroupLifecyclePolicy -MockWith {
                    return @{
                        AlternateNotificationEmails = @('john.smith@contoso.com', 'bob.houle@contoso.com')
                        GroupLifetimeInDays         = 99
                        ManagedGroupTypes           = 'Selected'
                        Id                          = '12345-12345-12345-12345-12345'
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
                Should -Invoke -CommandName 'Get-MgGroupLifecyclePolicy' -Exactly 1
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Update the Policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-MgGroupLifecyclePolicy' -Exactly 0
                Should -Invoke -CommandName 'Update-MgGroupLifecyclePolicy' -Exactly 1
                Should -Invoke -CommandName 'Remove-MgGroupLifecyclePolicy' -Exactly 0
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-MgGroupLifecyclePolicy -MockWith {
                    return @{
                        AlternateNotificationEmails = @('john.smith@contoso.com', 'bob.houle@contoso.com')
                        GroupLifetimeInDays         = 99
                        ManagedGroupTypes           = 'Selected'
                        Id                          = '12345-12345-12345-12345-12345'
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
