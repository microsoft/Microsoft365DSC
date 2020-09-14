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
    -DscResource "EXOActiveSyncDeviceAccessRule" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll{
            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }

            Mock -CommandName Get-PSSession -MockWith {

            }

            Mock -CommandName Remove-PSSession -MockWith {

            }
        }

        # Test contexts
        Context -Name "Active Sync Device Access Rule should exist. Active Sync Device Access Rule is missing. Test should fail." -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity           = 'ContosoPhone'
                    AccessLevel        = 'Allow'
                    Characteristic     = 'DeviceOS'
                    QueryString        = 'iOS 6.1 10B145'
                    Ensure             = 'Present'
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-ActiveSyncDeviceAccessRule -MockWith {
                    return @{
                        Identity       = 'ContosoDifferentPhone'
                        AccessLevel    = 'Allow'
                        Characteristic = 'DeviceOS'
                        QueryString    = 'iOS 6.1 10B145'
                    }
                }
                Mock -CommandName Set-ActiveSyncDeviceAccessRule -MockWith {
                    return @{
                        Identity           = 'ContosoPhone'
                        AccessLevel        = 'Allow'
                        Characteristic     = 'DeviceOS'
                        QueryString        = 'iOS 6.1 10B145'
                        Ensure             = 'Present'
                        GlobalAdminAccount = $GlobalAdminAccount
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }

            It "Should return Absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Absent"
            }
        }

        Context -Name "Active Sync Device Access Rule should exist. Active Sync Device Access Rule exists. Test should pass." -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity           = 'ContosoPhone'
                    AccessLevel        = 'Allow'
                    Characteristic     = 'DeviceOS'
                    QueryString        = 'iOS 6.1 10B145'
                    Ensure             = 'Present'
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-ActiveSyncDeviceAccessRule -MockWith {
                    return @{
                        Identity       = 'ContosoPhone'
                        AccessLevel    = 'Allow'
                        Characteristic = 'DeviceOS'
                        QueryString    = 'iOS 6.1 10B145'
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should return Present from the Get Method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }
        }

        Context -Name "Active Sync Device Access Rule should exist. Active Sync Device Access Rule exists, AccessLevel mismatch. Test should fail." -Fixture {
            BeforeAll {
                $testParams = @{
                    Identity           = 'ContosoPhone'
                    AccessLevel        = 'Allow'
                    Characteristic     = 'DeviceOS'
                    QueryString        = 'iOS 6.1 10B145'
                    Ensure             = 'Present'
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-ActiveSyncDeviceAccessRule -MockWith {
                    return @{
                        Identity       = 'ContosoPhone'
                        AccessLevel    = 'Block'
                        Characteristic = 'DeviceOS'
                        QueryString    = 'iOS 6.1 10B145'
                    }
                }
                Mock -CommandName Set-ActiveSyncDeviceAccessRule -MockWith {
                    return @{
                        Identity           = 'ContosoPhone'
                        AccessLevel        = 'Allow'
                        Characteristic     = 'DeviceOS'
                        QueryString        = 'iOS 6.1 10B145'
                        Ensure             = 'Present'
                        GlobalAdminAccount = $GlobalAdminAccount
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                $ActiveSyncDeviceAccessRule = @{
                    Identity       = 'ContosoPhone'
                    AccessLevel    = 'Allow'
                    Characteristic = 'DeviceOS'
                    QueryString    = 'iOS 6.1 10B145'
                }
                Mock -CommandName Get-ActiveSyncDeviceAccessRule -MockWith {
                    return $ActiveSyncDeviceAccessRule
                }
            }

            It "Should Reverse Engineer resource from the Export method when single" {

                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
