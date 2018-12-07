[CmdletBinding()]
param(
    [Parameter()]
    [string] 
    $CmdletModule = (Join-Path -Path $PSScriptRoot `
                                         -ChildPath "..\Stubs\Office365.psm1" `
                                         -Resolve)
)

Import-Module -Name (Join-Path -Path $PSScriptRoot `
                                -ChildPath "..\UnitTestHelper.psm1" `
                                -Resolve)

$Global:DscHelper = New-O365DscUnitTestHelper -StubModule $CmdletModule `
                                              -DscResource "EXOMailTips"
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock Invoke-ExoCommand {
            return Invoke-Command -ScriptBlock $ScriptBlock -ArgumentList $Arguments -NoNewScope
        }

        # Test contexts 
        Context -Name "MailTips are Disabled and should be Enabled" -Fixture {
            $testParams = @{
                Organization = "contoso.onmicrosoft.com"
                MailTipsAllTipsEnabled = $True
                Ensure = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-OrganizationConfig -MockWith { 
                return @{
                    MailTipsAllTipsEnabled = $False
                }
            }

            Mock -CommandName Set-OrganizationConfig -MockWith {

            }

            It "Should return False from the Get method" {
                (Get-TargetResource @testParams).MailTipsAllTipsEnabled | Should Be $False
            }

            It "Should set MailTipsAllTipsEnabled to True with the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "Mailbox already exists and it should" -Fixture {
            $testParams = @{
                DisplayName = "Test Shared Mailbox"
                PrimarySMTPAddress = "Testh@contoso.onmicrosoft.com"
                Ensure = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-Mailbox -MockWith { 
                return @{
                    Identity = "Test Shared Mailbox"
                    RecipientTypeDetails = "SharedMailbox"
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should return True from the Test method" {
                { Test-TargetResource @testParams } | Should Be $True
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                DisplayName = "Test Shared Mailbox"
                PrimarySMTPAddress = "Testh@contoso.onmicrosoft.com"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-Mailbox -MockWith {
                return @{
                    Name = "Test Shared Mailbox"
                    DisplayName = "Test Shared Mailbox"
                    PrimarySMTPAddress = "Testh@contoso.onmicrosoft.com"
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
