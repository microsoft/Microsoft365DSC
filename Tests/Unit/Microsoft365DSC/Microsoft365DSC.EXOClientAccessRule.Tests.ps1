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
    -DscResource "EXOClientAccessRule" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {
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

            Mock -CommandName New-ClientAccessRule -MockWith {

            }

            Mock -CommandName Set-ClientAccessRule -MockWith {

            }

            Mock -CommandName Remove-ClientAccessRule -MockWith {

            }
        }

        # Test contexts
        Context -Name "ClientAccessRule creation." -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                               = 'Present'
                    Identity                             = 'ExampleCASRule'
                    GlobalAdminAccount                   = $GlobalAdminAccount
                    Action                               = 'AllowAccess'
                    AnyOfAuthenticationTypes             = @('AdfsAuthentication', 'BasicAuthentication')
                    AnyOfClientIPAddressesOrRanges       = @('192.168.1.100', '10.1.1.0/24', '172.16.5.1-172.16.5.150')
                    AnyOfProtocols                       = @('ExchangeAdminCenter', 'OutlookWebApp')
                    Enabled                              = $false
                    ExceptAnyOfClientIPAddressesOrRanges = @('10.1.1.13', '172.16.5.2')
                    ExceptUsernameMatchesAnyOfPatterns   = @('*ThatGuy*', 'contoso\JohnDoe')
                    Priority                             = 1
                    RuleScope                            = 'Users'
                    UserRecipientFilter                  = '{City -eq "Redmond"}'
                }

                Mock -CommandName Get-ClientAccessRule -MockWith {
                    return @{
                        Identity = 'SomeOtherPolicy'
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

        Context -Name "ClientAccessRule update not required." -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                               = 'Present'
                    Identity                             = 'ExampleCASRule'
                    GlobalAdminAccount                   = $GlobalAdminAccount
                    Action                               = 'AllowAccess'
                    AnyOfAuthenticationTypes             = @('AdfsAuthentication', 'BasicAuthentication')
                    AnyOfClientIPAddressesOrRanges       = @('192.168.1.100', '10.1.1.0/24', '172.16.5.1-172.16.5.150')
                    AnyOfProtocols                       = @('ExchangeAdminCenter', 'OutlookWebApp')
                    Enabled                              = $false
                    ExceptAnyOfClientIPAddressesOrRanges = @('10.1.1.13', '172.16.5.2')
                    ExceptUsernameMatchesAnyOfPatterns   = @('*ThatGuy*', 'contoso\JohnDoe')
                    Priority                             = 1
                    RuleScope                            = 'Users'
                    UserRecipientFilter                  = '{City -eq "Redmond"}'
                }

                Mock -CommandName Get-ClientAccessRule -MockWith {
                    return @{
                        Ensure                               = 'Present'
                        Identity                             = 'ExampleCASRule'
                        GlobalAdminAccount                   = $GlobalAdminAccount
                        Action                               = 'AllowAccess'
                        AnyOfAuthenticationTypes             = @('AdfsAuthentication', 'BasicAuthentication')
                        AnyOfClientIPAddressesOrRanges       = @('192.168.1.100', '10.1.1.0/24', '172.16.5.1-172.16.5.150')
                        AnyOfProtocols                       = @('ExchangeAdminCenter', 'OutlookWebApp')
                        Enabled                              = $false
                        ExceptAnyOfClientIPAddressesOrRanges = @('10.1.1.13', '172.16.5.2')
                        ExceptUsernameMatchesAnyOfPatterns   = @('*ThatGuy*', 'contoso\JohnDoe')
                        Priority                             = 1
                        RuleScope                            = 'Users'
                        UserRecipientFilter                  = '{City -eq "Redmond"}'
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "ClientAccessRule update needed." -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                               = 'Present'
                    Identity                             = 'ExampleCASRule'
                    GlobalAdminAccount                   = $GlobalAdminAccount
                    Action                               = 'AllowAccess'
                    AnyOfAuthenticationTypes             = @('AdfsAuthentication', 'BasicAuthentication')
                    AnyOfClientIPAddressesOrRanges       = @('192.168.1.100', '10.1.1.0/24', '172.16.5.1-172.16.5.150')
                    AnyOfProtocols                       = @('ExchangeAdminCenter', 'OutlookWebApp')
                    Enabled                              = $false
                    ExceptAnyOfClientIPAddressesOrRanges = @('10.1.1.13', '172.16.5.2')
                    ExceptUsernameMatchesAnyOfPatterns   = @('*ThatGuy*', 'contoso\JohnDoe')
                    Priority                             = 1
                    RuleScope                            = 'Users'
                    UserRecipientFilter                  = '{City -eq "Redmond"}'
                }

                Mock -CommandName Get-ClientAccessRule -MockWith {
                    return @{
                        Ensure                               = 'Present'
                        Identity                             = 'ExampleCASRule'
                        GlobalAdminAccount                   = $GlobalAdminAccount
                        Action                               = 'DenyAccess'
                        AnyOfAuthenticationTypes             = @('AdfsAuthentication')
                        AnyOfClientIPAddressesOrRanges       = @('192.168.1.100')
                        AnyOfProtocols                       = @('ExchangeAdminCenter', 'OutlookWebApp')
                        Enabled                              = $false
                        ExceptAnyOfClientIPAddressesOrRanges = @('10.1.1.13', '172.16.5.2')
                        ExceptUsernameMatchesAnyOfPatterns   = @('*ThatGuy*', 'contoso\JohnDoe')
                        Priority                             = 1
                        RuleScope                            = 'All'
                        UserRecipientFilter                  = '{}'
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

        Context -Name "ClientAccessRule removal." -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure             = 'Absent'
                    Identity           = 'ExampleCASRule'
                    GlobalAdminAccount = $GlobalAdminAccount
                    Action             = 'DenyAccess'
                }

                Mock -CommandName Get-ClientAccessRule -MockWith {
                    return @{
                        Identity = 'ExampleCASRule'
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

                Mock -CommandName Get-ClientAccessRule -MockWith {
                    return @{
                        Identity = 'ExampleCASRule'
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
