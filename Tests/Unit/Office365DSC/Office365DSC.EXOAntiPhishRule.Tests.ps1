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
    -DscResource "EXOAntiPhishRule"
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Close-SessionsAndReturnError -MockWith {

        }

        Mock -CommandName Connect-ExchangeOnline -MockWith {

        }

        Mock -CommandName Get-PSSession -MockWith {

        }

        Mock -CommandName Remove-PSSession -MockWith {

        }

        Mock -CommandName New-AntiPhishRule -MockWith {
            return @{

            }
        }

        Mock -CommandName Set-AntiPhishRule -MockWith {
            return @{

            }
        }

        Mock -CommandName Remove-AntiPhishRule -MockWith {
            return @{

            }
        }

        Mock -CommandName New-EXOAntiPhishRule -MockWith {
            return @{

            }
        }

        Mock -CommandName Set-EXOAntiPhishRule -MockWith {
            return @{

            }
        }

        # Test contexts
        Context -Name "AntiPhishRule creation." -Fixture {
            $testParams = @{
                Ensure             = 'Present'
                GlobalAdminAccount = $GlobalAdminAccount
                Identity           = 'TestRule'
                AntiPhishPolicy    = 'TestPolicy'
            }

            Mock -CommandName Get-AntiPhishRule -MockWith {
                return @{
                    Identity = 'SomeOtherPolicy'
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "AntiPhishRule update not required." -Fixture {
            $testParams = @{
                Ensure                    = 'Present'
                Identity                  = 'TestRule'
                GlobalAdminAccount        = $GlobalAdminAccount
                AntiPhishPolicy           = 'TestPolicy'
                Enabled                   = $true
                Priority                  = 0
                ExceptIfRecipientDomainIs = @('dev.contoso.com')
                ExceptIfSentTo            = @('test@contoso.com')
                ExceptIfSentToMemberOf    = @('Special Group')
                RecipientDomainIs         = @('contoso.com')
                SentTo                    = @('someone@contoso.com')
                SentToMemberOf            = @('Some Group', 'Some Other Group')
            }

            Mock -CommandName Get-AntiPhishRule -MockWith {
                return @{
                    Ensure                    = 'Present'
                    Identity                  = 'TestRule'
                    AntiPhishPolicy           = 'TestPolicy'
                    Priority                  = 0
                    ExceptIfRecipientDomainIs = @('dev.contoso.com')
                    ExceptIfSentTo            = @('test@contoso.com')
                    ExceptIfSentToMemberOf    = @('Special Group')
                    RecipientDomainIs         = @('contoso.com')
                    SentTo                    = @('someone@contoso.com')
                    SentToMemberOf            = @('Some Group', 'Some Other Group')
                    State                     = 'Enabled'
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should Be $true
            }
        }

        Context -Name "AntiPhishRule update needed." -Fixture {
            $testParams = @{
                Ensure                    = 'Present'
                Identity                  = 'TestRule'
                GlobalAdminAccount        = $GlobalAdminAccount
                AntiPhishPolicy           = 'TestPolicy'
                Enabled                   = $true
                Priority                  = 0
                ExceptIfRecipientDomainIs = @('dev.contoso.com')
                ExceptIfSentTo            = @('test@contoso.com')
                ExceptIfSentToMemberOf    = @('Special Group')
                RecipientDomainIs         = @('contoso.com')
                SentTo                    = @('someone@contoso.com')
                SentToMemberOf            = @('Some Group', 'Some Other Group')
            }

            Mock -CommandName Get-AntiPhishRule -MockWith {
                return @{
                    Ensure                    = 'Present'
                    Identity                  = 'TestRule'
                    GlobalAdminAccount        = $GlobalAdminAccount
                    AntiPhishPolicy           = 'TestPolicy'
                    Enabled                   = $true
                    Priority                  = 0
                    ExceptIfRecipientDomainIs = @('notdev.contoso.com')
                    ExceptIfSentTo            = @('nottest@contoso.com')
                    ExceptIfSentToMemberOf    = @('UnSpecial Group')
                    RecipientDomainIs         = @('contoso.com')
                    SentTo                    = @('wrongperson@contoso.com', 'someone@contoso.com')
                    SentToMemberOf            = @('Some Group', 'Some Other Group', 'DeletedGroup')
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "AntiPhishRule removal." -Fixture {
            $testParams = @{
                Ensure             = 'Absent'
                GlobalAdminAccount = $GlobalAdminAccount
                Identity           = 'TestRule'
                AntiPhishPolicy    = 'TestPolicy'
            }

            Mock -CommandName Get-AntiPhishRule -MockWith {
                return @{
                    Identity = 'TestRule'
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                Identity           = 'contoso.com'
                AntiPhishPolicy    = 'TestPolicy'
                GlobalAdminAccount           = $GlobalAdminAccount
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
