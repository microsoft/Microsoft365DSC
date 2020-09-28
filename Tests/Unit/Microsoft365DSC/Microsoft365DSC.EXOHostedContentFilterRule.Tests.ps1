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
    -DscResource "EXOHostedContentFilterRule" -GenericStubModule $GenericStubPath
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

            Mock -CommandName New-HostedContentFilterRule -MockWith {
                return @{

                }
            }

            Mock -CommandName Set-HostedContentFilterRule -MockWith {
                return @{

                }
            }

            Mock -CommandName Remove-HostedContentFilterRule -MockWith {
                return @{

                }
            }
        }

        # Test contexts
        Context -Name "HostedContentFilterRule creation." -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                    = 'Present'
                    GlobalAdminAccount        = $GlobalAdminAccount
                    Identity                  = 'TestRule'
                    HostedContentFilterPolicy = 'TestPolicy'
                }

                Mock -CommandName Get-HostedContentFilterRule -MockWith {
                    return @{
                        Identity = 'SomeOtherPolicy'
                    }
                }

                Mock -CommandName Get-HostedContentFilterPolicy -MockWith {
                    return @{
                        Identity = 'TestPolicy'
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

        Context -Name "HostedContentFilterRule update not required." -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                    = 'Present'
                    Identity                  = 'TestRule'
                    GlobalAdminAccount        = $GlobalAdminAccount
                    HostedContentFilterPolicy = 'TestPolicy'
                    Enabled                   = $true
                    Priority                  = 0
                    ExceptIfRecipientDomainIs = @('dev.contoso.com')
                    ExceptIfSentTo            = @('test@contoso.com')
                    ExceptIfSentToMemberOf    = @('Special Group')
                    RecipientDomainIs         = @('contoso.com')
                    SentTo                    = @('someone@contoso.com')
                    SentToMemberOf            = @('Some Group', 'Some Other Group')
                }

                Mock -CommandName Get-HostedContentFilterRule -MockWith {
                    return @{
                        Ensure                    = 'Present'
                        Identity                  = 'TestRule'
                        HostedContentFilterPolicy = 'TestPolicy'
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

                Mock -CommandName Get-HostedContentFilterPolicy -MockWith {
                    return @{
                        Identity = 'TestPolicy'
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "HostedContentFilterRule update needed." -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                    = 'Present'
                    Identity                  = 'TestRule'
                    GlobalAdminAccount        = $GlobalAdminAccount
                    HostedContentFilterPolicy = 'TestPolicy'
                    Enabled                   = $true
                    Priority                  = 0
                    ExceptIfRecipientDomainIs = @('dev.contoso.com')
                    ExceptIfSentTo            = @('test@contoso.com')
                    ExceptIfSentToMemberOf    = @('Special Group')
                    RecipientDomainIs         = @('contoso.com')
                    SentTo                    = @('someone@contoso.com')
                    SentToMemberOf            = @('Some Group', 'Some Other Group')
                }

                Mock -CommandName Get-HostedContentFilterRule -MockWith {
                    return @{
                        Ensure                    = 'Present'
                        Identity                  = 'TestRule'
                        GlobalAdminAccount        = $GlobalAdminAccount
                        HostedContentFilterPolicy = 'TestPolicy'
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

                Mock -CommandName Get-HostedContentFilterPolicy -MockWith {
                    return @{
                        Identity = 'TestPolicy'
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

        Context -Name "HostedContentFilterRule removal." -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                    = 'Absent'
                    GlobalAdminAccount        = $GlobalAdminAccount
                    Identity                  = 'TestRule'
                    HostedContentFilterPolicy = 'TestPolicy'
                }

                Mock -CommandName Get-HostedContentFilterRule -MockWith {
                    return @{
                        Identity = 'TestRule'
                    }
                }

                Mock -CommandName Get-HostedContentFilterPolicy -MockWith {
                    return @{
                        Identity = 'TestPolicy'
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
                    GlobalAdminAccount        = $GlobalAdminAccount
                }

                Mock -CommandName Get-HostedContentFilterRule -MockWith {
                    return @{
                        Identity                  = 'TestRule'
                        HostedContentFilterPolicy = 'TestPolicy'
                    }
                }

                Mock -CommandName Get-HostedContentFilterPolicy -MockWith {
                    return @{
                        Identity = 'TestPolicy'
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
