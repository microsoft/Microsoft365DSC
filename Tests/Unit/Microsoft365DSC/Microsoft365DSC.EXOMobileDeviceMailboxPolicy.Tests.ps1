[CmdletBinding()]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '')]

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
    -DscResource 'EXOMobileDeviceMailboxPolicy' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
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
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'Mobile Device Mailbox Policy should exist. Mobile Device Mailbox Policy is missing. Test should fail.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name                         = 'Contoso Mobile Device Policy'
                    AllowBluetooth               = 'Allow'
                    IrmEnabled                   = $true
                    PasswordHistory              = '4'
                    RequireManualSyncWhenRoaming = $false
                    Ensure                       = 'Present'
                    Credential                   = $Credential
                }

                Mock -CommandName Get-MobileDeviceMailboxPolicy -MockWith {
                    return @{
                        Name                         = 'Contoso Different Mobile Device Policy'
                        AllowBluetooth               = 'Allow'
                        IrmEnabled                   = $true
                        PasswordHistory              = '4'
                        RequireManualSyncWhenRoaming = $false
                    }
                }

                Mock -CommandName Set-MobileDeviceMailboxPolicy -MockWith {
                    return @{
                        Name                         = 'Contoso Mobile Device Policy'
                        AllowBluetooth               = 'Allow'
                        IrmEnabled                   = $true
                        PasswordHistory              = '4'
                        RequireManualSyncWhenRoaming = $false
                        Ensure                       = 'Present'
                        Credential                   = $Credential
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

        Context -Name 'Mobile Device Mailbox Policy should exist. Mobile Device Mailbox Policy exists. Test should pass.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name                         = 'Contoso Mobile Device Policy'
                    AllowBluetooth               = 'Allow'
                    IrmEnabled                   = $true
                    PasswordHistory              = '4'
                    RequireManualSyncWhenRoaming = $false
                    Ensure                       = 'Present'
                    Credential                   = $Credential
                }

                Mock -CommandName Get-MobileDeviceMailboxPolicy -MockWith {
                    return @{
                        Name                         = 'Contoso Mobile Device Policy'
                        AllowBluetooth               = 'Allow'
                        IrmEnabled                   = $true
                        PasswordHistory              = '4'
                        RequireManualSyncWhenRoaming = $false
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

        Context -Name 'Mobile Device Mailbox Policy should exist. Mobile Device Mailbox Policy exists, PasswordHistory mismatch. Test should fail.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name                         = 'Contoso Mobile Device Policy'
                    AllowBluetooth               = 'Allow'
                    IrmEnabled                   = $true
                    PasswordHistory              = '4'
                    RequireManualSyncWhenRoaming = $false
                    Ensure                       = 'Present'
                    Credential                   = $Credential
                }

                Mock -CommandName Get-MobileDeviceMailboxPolicy -MockWith {
                    return @{
                        Name                         = 'Contoso Mobile Device Policy'
                        AllowBluetooth               = 'Allow'
                        IrmEnabled                   = $true
                        PasswordHistory              = '2'
                        RequireManualSyncWhenRoaming = $false
                    }
                }

                Mock -CommandName Set-MobileDeviceMailboxPolicy -MockWith {
                    return @{
                        Name                         = 'Contoso Mobile Device Policy'
                        AllowBluetooth               = 'Allow'
                        IrmEnabled                   = $true
                        PasswordHistory              = '4'
                        RequireManualSyncWhenRoaming = $false
                        Ensure                       = 'Present'
                        Credential                   = $Credential
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

                $MobileDeviceMailboxPolicy = @{
                    Name                         = 'Contoso Mobile Device Policy'
                    AllowBluetooth               = 'Allow'
                    IrmEnabled                   = $true
                    PasswordHistory              = '4'
                    RequireManualSyncWhenRoaming = $false
                }
                Mock -CommandName Get-MobileDeviceMailboxPolicy -MockWith {
                    return $MobileDeviceMailboxPolicy
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
