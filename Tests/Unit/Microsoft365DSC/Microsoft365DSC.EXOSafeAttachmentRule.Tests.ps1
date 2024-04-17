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
    -DscResource 'EXOSafeAttachmentRule' -GenericStubModule $GenericStubPath
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

            Mock -CommandName New-SafeAttachmentRule -MockWith {
                return @{

                }
            }

            Mock -CommandName Set-SafeAttachmentRule -MockWith {
                return @{

                }
            }

            Mock -CommandName Remove-SafeAttachmentRule -MockWith {
                return @{

                }
            }

            Mock -CommandName New-EXOSafeAttachmentRule -MockWith {
                return @{

                }
            }

            Mock -CommandName Set-EXOSafeAttachmentRule -MockWith {
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
        Context -Name 'SafeAttachmentRule creation.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure               = 'Present'
                    Credential           = $Credential
                    Identity             = 'TestRule'
                    SafeAttachmentPolicy = 'TestPolicy'
                }

                Mock -CommandName Get-SafeAttachmentRule -MockWith {
                    return @{
                        Identity = 'SomeOtherPolicy'
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

        Context -Name 'SafeAttachmentRule update not required.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                    = 'Present'
                    Identity                  = 'TestRule'
                    Credential                = $Credential
                    SafeAttachmentPolicy      = 'TestPolicy'
                    Enabled                   = $true
                    Priority                  = 0
                    ExceptIfRecipientDomainIs = @('dev.contoso.com')
                    ExceptIfSentTo            = @('test@contoso.com')
                    ExceptIfSentToMemberOf    = @('Special Group')
                    RecipientDomainIs         = @('contoso.com')
                    SentTo                    = @('someone@contoso.com')
                    SentToMemberOf            = @('Some Group', 'Some Other Group')
                }

                Mock -CommandName Get-SafeAttachmentRule -MockWith {
                    return @{
                        Ensure                    = 'Present'
                        Identity                  = 'TestRule'
                        SafeAttachmentPolicy      = 'TestPolicy'
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
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'SafeAttachmentRule update needed.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                    = 'Present'
                    Identity                  = 'TestRule'
                    Credential                = $Credential
                    SafeAttachmentPolicy      = 'TestPolicy'
                    Enabled                   = $true
                    Priority                  = 0
                    ExceptIfRecipientDomainIs = @('dev.contoso.com')
                    ExceptIfSentTo            = @('test@contoso.com')
                    ExceptIfSentToMemberOf    = @('Special Group')
                    RecipientDomainIs         = @('contoso.com')
                    SentTo                    = @('someone@contoso.com')
                    SentToMemberOf            = @('Some Group', 'Some Other Group')
                }

                Mock -CommandName Get-SafeAttachmentRule -MockWith {
                    return @{
                        Ensure                    = 'Present'
                        Identity                  = 'TestRule'
                        Credential                = $Credential
                        SafeAttachmentPolicy      = 'TestPolicy'
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
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'SafeAttachmentRule removal.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure               = 'Absent'
                    Credential           = $Credential
                    Identity             = 'TestRule'
                    SafeAttachmentPolicy = 'TestPolicy'
                }

                Mock -CommandName Get-SafeAttachmentRule -MockWith {
                    return @{
                        Identity = 'TestRule'
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

                Mock -CommandName Confirm-ImportedCmdletIsAvailable -MockWith {
                    return $true
                }

                Mock -CommandName Get-SafeAttachmentRule -MockWith {
                    return @{
                        Identity             = 'TestRule'
                        SafeAttachmentPolicy = 'TestPolicy'
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
