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
    -DscResource 'EXOHostedOutboundSpamFilterRule' -GenericStubModule $GenericStubPath
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

            Mock -CommandName New-HostedOutboundSpamFilterRule -MockWith {
                return @{

                }
            }

            Mock -CommandName Set-HostedOutboundSpamFilterRule -MockWith {
                return @{

                }
            }

            Mock -CommandName Remove-HostedOutboundSpamFilterRule -MockWith {
                return @{

                }
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'HostedOutboundSpamFilterRule creation.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                         = 'Present'
                    Credential                     = $Credential
                    Identity                       = 'TestRule'
                    HostedOutboundSpamFilterPolicy = 'TestPolicy'
                }

                Mock -CommandName Get-HostedOutboundSpamFilterRule -MockWith {
                    return @{
                        Identity = 'SomeOtherPolicy'
                    }
                }

                Mock -CommandName Get-HostedOutboundSpamFilterPolicy -MockWith {
                    return @{
                        Identity = 'TestPolicy'
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

        Context -Name 'HostedOutboundSpamFilterRule update not required.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                         = 'Present'
                    Identity                       = 'TestRule'
                    Credential                     = $Credential
                    HostedOutboundSpamFilterPolicy = 'TestPolicy'
                    Enabled                        = $true
                    Priority                       = 0
                    ExceptIfSenderDomainIs         = @('dev.contoso.com')
                    ExceptIfFrom                   = @('test@contoso.com')
                    ExceptIfFromMemberOf           = @('Special Group')
                    SenderDomainIs                 = @('contoso.com')
                    From                           = @('someone@contoso.com')
                    FromMemberOf                   = @('Some Group', 'Some Other Group')
                }

                Mock -CommandName Get-HostedOutboundSpamFilterRule -MockWith {
                    return @{
                        Ensure                         = 'Present'
                        Identity                       = 'TestRule'
                        HostedOutboundSpamFilterPolicy = 'TestPolicy'
                        Priority                       = 0
                        ExceptIfSenderDomainIs         = @('dev.contoso.com')
                        ExceptIfFrom                   = @('test@contoso.com')
                        ExceptIfFromMemberOf           = @('Special Group')
                        SenderDomainIs                 = @('contoso.com')
                        From                           = @('someone@contoso.com')
                        FromMemberOf                   = @('Some Group', 'Some Other Group')
                        State                          = 'Enabled'
                    }
                }

                Mock -CommandName Get-HostedOutboundSpamFilterPolicy -MockWith {
                    return @{
                        Identity = 'TestPolicy'
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'HostedOutboundSpamFilterRule update needed.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                         = 'Present'
                    Identity                       = 'TestRule'
                    Credential                     = $Credential
                    HostedOutboundSpamFilterPolicy = 'TestPolicy'
                    Enabled                        = $true
                    Priority                       = 0
                    ExceptIfSenderDomainIs         = @('dev.contoso.com')
                    ExceptIfFrom                   = @('test@contoso.com')
                    ExceptIfFromMemberOf           = @('Special Group')
                    SenderDomainIs                 = @('contoso.com')
                    From                           = @('someone@contoso.com')
                    FromMemberOf                   = @('Some Group', 'Some Other Group')
                }

                Mock -CommandName Get-HostedOutboundSpamFilterRule -MockWith {
                    return @{
                        Ensure                         = 'Present'
                        Identity                       = 'TestRule'
                        Credential                     = $Credential
                        HostedOutboundSpamFilterPolicy = 'TestPolicy'
                        Enabled                        = $true
                        Priority                       = 0
                        ExceptIfSenderDomainIs         = @('notdev.contoso.com')
                        ExceptIfFrom                   = @('nottest@contoso.com')
                        ExceptIfFromMemberOf           = @('UnSpecial Group')
                        SenderDomainIs                 = @('contoso.com')
                        From                           = @('wrongperson@contoso.com', 'someone@contoso.com')
                        FromMemberOf                   = @('Some Group', 'Some Other Group', 'DeletedGroup')
                    }
                }

                Mock -CommandName Get-HostedOutboundSpamFilterPolicy -MockWith {
                    return @{
                        Identity = 'TestPolicy'
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

        Context -Name 'HostedOutboundSpamFilterRule removal.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                         = 'Absent'
                    Credential                     = $Credential
                    Identity                       = 'TestRule'
                    HostedOutboundSpamFilterPolicy = 'TestPolicy'
                }

                Mock -CommandName Get-HostedOutboundSpamFilterRule -MockWith {
                    return @{
                        Identity = 'TestRule'
                    }
                }

                Mock -CommandName Get-HostedOutboundSpamFilterPolicy -MockWith {
                    return @{
                        Identity = 'TestPolicy'
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

                Mock -CommandName Get-HostedOutboundSpamFilterRule -MockWith {
                    return @{
                        Identity                       = 'TestRule'
                        HostedOutboundSpamFilterPolicy = 'TestPolicy'
                    }
                }

                Mock -CommandName Get-HostedOutboundSpamFilterPolicy -MockWith {
                    return @{
                        Identity = 'TestPolicy'
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
