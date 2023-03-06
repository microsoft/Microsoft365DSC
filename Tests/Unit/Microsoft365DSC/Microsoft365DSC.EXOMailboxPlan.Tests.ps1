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
    -DscResource 'EXOMailboxPlan' -GenericStubModule $GenericStubPath
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

            Mock -CommandName Set-MailboxPlan -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name 'MailboxPlan update not required.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                   = 'Present'
                    Credential               = $Credential
                    Identity                 = 'ExchangeOnlineEnterprise'
                    IssueWarningQuota        = '98 GB (105,226,698,752 bytes)'
                    MaxReceiveSize           = '25 MB (26,214,400 bytes)'
                    MaxSendSize              = '25 MB (26,214,400 bytes)'
                    ProhibitSendQuota        = '99 GB (106,300,440,576 bytes)'
                    ProhibitSendReceiveQuota = '100 GB (107,374,182,400 bytes)'
                    RetainDeletedItemsFor    = '14.00:00:00'
                    RoleAssignmentPolicy     = 'Default Role Assignment Policy'
                }

                Mock -CommandName Get-MailboxPlan -MockWith {
                    return @{
                        Ensure                   = 'Present'
                        Credential               = $Credential
                        Identity                 = 'ExchangeOnlineEnterprise'
                        IssueWarningQuota        = '98 GB (105,226,698,752 bytes)'
                        MaxReceiveSize           = '25 MB (26,214,400 bytes)'
                        MaxSendSize              = '25 MB (26,214,400 bytes)'
                        ProhibitSendQuota        = '99 GB (106,300,440,576 bytes)'
                        ProhibitSendReceiveQuota = '100 GB (107,374,182,400 bytes)'
                        RetainDeletedItemsFor    = '14.00:00:00'
                        RoleAssignmentPolicy     = 'Default Role Assignment Policy'
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should not update anything in the Set Method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'MailboxPlan update needed.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                   = 'Present'
                    Credential               = $Credential
                    Identity                 = 'ExchangeOnlineEnterprise'
                    IssueWarningQuota        = '98 GB (105,226,698,752 bytes)'
                    MaxReceiveSize           = '25 MB (26,214,400 bytes)'
                    MaxSendSize              = '25 MB (26,214,400 bytes)'
                    ProhibitSendQuota        = '99 GB (106,300,440,576 bytes)'
                    ProhibitSendReceiveQuota = '100 GB (107,374,182,400 bytes)'
                    RetainDeletedItemsFor    = '14.00:00:00'
                    RoleAssignmentPolicy     = 'Default Role Assignment Policy'
                }
                Mock -CommandName Get-MailboxPlan -MockWith {
                    return @{
                        Ensure                   = 'Present'
                        Credential               = $Credential
                        Identity                 = 'ExchangeOnlineEnterprise'
                        IssueWarningQuota        = '98 GB (105,226,698,752 bytes)'
                        MaxReceiveSize           = '25 MB (26,214,400 bytes)'
                        MaxSendSize              = '25 MB (26,214,400 bytes)'
                        ProhibitSendQuota        = '99 GB (106,300,440,576 bytes)'
                        ProhibitSendReceiveQuota = '100 GB (107,374,182,400 bytes)'
                        RetainDeletedItemsFor    = '30.00:00:00'
                        RoleAssignmentPolicy     = 'Default Role Assignment Policy'
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

                Mock -CommandName Get-MailboxPlan -MockWith {
                    return @{
                        Identity                 = 'ExchangeOnlineEnterprise'
                        IssueWarningQuota        = '98 GB (105,226,698,752 bytes)'
                        MaxReceiveSize           = '25 MB (26,214,400 bytes)'
                        MaxSendSize              = '25 MB (26,214,400 bytes)'
                        ProhibitSendQuota        = '99 GB (106,300,440,576 bytes)'
                        ProhibitSendReceiveQuota = '100 GB (107,374,182,400 bytes)'
                        RetainDeletedItemsFor    = '14.00:00:00'
                        RoleAssignmentPolicy     = 'Default Role Assignment Policy'
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
