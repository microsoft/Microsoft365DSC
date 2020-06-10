[CmdletBinding()]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "")]
param(
    [Parameter()]
    [string]
    $CmdletModule = (Join-Path -Path $PSScriptRoot `
            -ChildPath "..\Stubs\Microsoft365.psm1" `
            -Resolve)
)

$GenericStubPath = (Join-Path -Path $PSScriptRoot `
        -ChildPath "..\Stubs\Generic.psm1" `
        -Resolve)
Import-Module -Name (Join-Path -Path $PSScriptRoot `
        -ChildPath "..\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "EXOMobileDeviceMailboxPolicy" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {

        }

        Mock -CommandName Get-PSSession -MockWith {

        }

        Mock -CommandName Remove-PSSession -MockWith {

        }

        # Test contexts
        Context -Name "Mobile Device Mailbox Policy should exist. Mobile Device Mailbox Policy is missing. Test should fail." -Fixture {
            $testParams = @{
                Name                         = 'Contoso Mobile Device Policy'
                AllowBluetooth               = 'Allow'
                IrmEnabled                   = $true
                PasswordHistory              = "4"
                RequireManualSyncWhenRoaming = $false
                Ensure                       = 'Present'
                GlobalAdminAccount           = $GlobalAdminAccount
            }

            Mock -CommandName Get-MobileDeviceMailboxPolicy -MockWith {
                return @{
                    Name                         = 'Contoso Different Mobile Device Policy'
                    AllowBluetooth               = 'Allow'
                    IrmEnabled                   = $true
                    PasswordHistory              = "4"
                    RequireManualSyncWhenRoaming = $false
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            Mock -CommandName Set-MobileDeviceMailboxPolicy -MockWith {
                return @{
                    Name                         = 'Contoso Mobile Device Policy'
                    AllowBluetooth               = 'Allow'
                    IrmEnabled                   = $true
                    PasswordHistory              = "4"
                    RequireManualSyncWhenRoaming = $false
                    Ensure                       = 'Present'
                    GlobalAdminAccount           = $GlobalAdminAccount
                }
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }

            It "Should return Absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }
        }

        Context -Name "Mobile Device Mailbox Policy should exist. Mobile Device Mailbox Policy exists. Test should pass." -Fixture {
            $testParams = @{
                Name                         = 'Contoso Mobile Device Policy'
                AllowBluetooth               = 'Allow'
                IrmEnabled                   = $true
                PasswordHistory              = "4"
                RequireManualSyncWhenRoaming = $false
                Ensure                       = 'Present'
                GlobalAdminAccount           = $GlobalAdminAccount
            }

            Mock -CommandName Get-MobileDeviceMailboxPolicy -MockWith {
                return @{
                    Name                         = 'Contoso Mobile Device Policy'
                    AllowBluetooth               = 'Allow'
                    IrmEnabled                   = $true
                    PasswordHistory              = "4"
                    RequireManualSyncWhenRoaming = $false
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should Be $true
            }

            It 'Should return Present from the Get Method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }
        }

        Context -Name "Mobile Device Mailbox Policy should exist. Mobile Device Mailbox Policy exists, PasswordHistory mismatch. Test should fail." -Fixture {
            $testParams = @{
                Name                         = 'Contoso Mobile Device Policy'
                AllowBluetooth               = 'Allow'
                IrmEnabled                   = $true
                PasswordHistory              = "4"
                RequireManualSyncWhenRoaming = $false
                Ensure                       = 'Present'
                GlobalAdminAccount           = $GlobalAdminAccount
            }

            Mock -CommandName Get-MobileDeviceMailboxPolicy -MockWith {
                return @{
                    Name                         = 'Contoso Mobile Device Policy'
                    AllowBluetooth               = 'Allow'
                    IrmEnabled                   = $true
                    PasswordHistory              = "2"
                    RequireManualSyncWhenRoaming = $false
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            Mock -CommandName Set-MobileDeviceMailboxPolicy -MockWith {
                return @{
                    Name                         = 'Contoso Mobile Device Policy'
                    AllowBluetooth               = 'Allow'
                    IrmEnabled                   = $true
                    PasswordHistory              = "4"
                    RequireManualSyncWhenRoaming = $false
                    Ensure                       = 'Present'
                    GlobalAdminAccount           = $GlobalAdminAccount
                }
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            $MobileDeviceMailboxPolicy = @{
                Name                         = 'Contoso Mobile Device Policy'
                AllowBluetooth               = 'Allow'
                IrmEnabled                   = $true
                PasswordHistory              = "4"
                RequireManualSyncWhenRoaming = $false
            }

            It "Should Reverse Engineer resource from the Export method when single" {
                Mock -CommandName Get-MobileDeviceMailboxPolicy -MockWith {
                    return $MobileDeviceMailboxPolicy
                }

                $exported = Export-TargetResource @testParams
                ([regex]::Matches($exported, " EXOMobileDeviceMailboxPolicy " )).Count | Should Be 1
                $exported.Contains("Allow") | Should Be $true
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
