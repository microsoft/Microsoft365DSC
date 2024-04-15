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
    -DscResource 'EXOHostedOutboundSpamFilterPolicy' -GenericStubModule $GenericStubPath
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

            Mock -CommandName Get-HostedOutboundSpamFilterPolicy -MockWith {
            }

            Mock -CommandName Set-HostedOutboundSpamFilterPolicy -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'HostedOutboundSpamFilterPolicy update not required.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                                    = 'Present'
                    Identity                                  = 'Default'
                    Credential                                = $Credential
                    AdminDisplayName                          = 'Default Outbound Spam Filter Policy'
                    BccSuspiciousOutboundMail                 = $true
                    BccSuspiciousOutboundAdditionalRecipients = @()
                    NotifyOutboundSpam                        = $true
                    NotifyOutboundSpamRecipients              = @()
                    RecipientLimitInternalPerHour             = '0'
                    RecipientLimitPerDay                      = '0'
                    RecipientLimitExternalPerHour             = '0'
                    ActionWhenThresholdReached                = 'BlockUserForToday'
                    AutoForwardingMode                        = 'Off'
                }

                Mock -CommandName Get-HostedOutboundSpamFilterPolicy -MockWith {
                    return @{
                        Identity                                  = 'Default'
                        AdminDisplayName                          = 'Default Outbound Spam Filter Policy'
                        BccSuspiciousOutboundMail                 = $true
                        BccSuspiciousOutboundAdditionalRecipients = @()
                        NotifyOutboundSpam                        = $true
                        NotifyOutboundSpamRecipients              = @()
                        RecipientLimitInternalPerHour             = '0'
                        RecipientLimitPerDay                      = '0'
                        RecipientLimitExternalPerHour             = '0'
                        ActionWhenThresholdReached                = 'BlockUserForToday'
                        AutoForwardingMode                        = 'Off'
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should not update anything in the Set Method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'HostedOutboundSpamFilterPolicy update needed.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                                    = 'Present'
                    Identity                                  = 'Default'
                    Credential                                = $Credential
                    AdminDisplayName                          = 'Default Outbound Spam Filter Policy'
                    BccSuspiciousOutboundMail                 = $true
                    BccSuspiciousOutboundAdditionalRecipients = @('admin@contoso.com')
                    NotifyOutboundSpam                        = $true
                    NotifyOutboundSpamRecipients              = @('supervisor@contoso.com')
                    RecipientLimitInternalPerHour             = '15'
                    RecipientLimitPerDay                      = '100'
                    RecipientLimitExternalPerHour             = '25'
                    ActionWhenThresholdReached                = 'BlockUser'
                    AutoForwardingMode                        = 'On'
                }
                Mock -CommandName Get-HostedOutboundSpamFilterPolicy -MockWith {
                    return @{
                        Identity                                  = 'Default'
                        AdminDisplayName                          = $null
                        BccSuspiciousOutboundMail                 = $false
                        BccSuspiciousOutboundAdditionalRecipients = @()
                        NotifyOutboundSpam                        = $false
                        NotifyOutboundSpamRecipients              = @()
                        RecipientLimitInternalPerHour             = '0'
                        RecipientLimitPerDay                      = '0'
                        RecipientLimitExternalPerHour             = '0'
                        ActionWhenThresholdReached                = 'BlockUserForToday'
                        AutoForwardingMode                        = 'Off'
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
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-HostedOutboundSpamFilterPolicy -MockWith {
                    return @{
                        Identity                                  = 'Default'
                        AdminDisplayName                          = 'Default Outbound Spam Filter Policy'
                        BccSuspiciousOutboundMail                 = $true
                        BccSuspiciousOutboundAdditionalRecipients = @()
                        NotifyOutboundSpam                        = $true
                        NotifyOutboundSpamRecipients              = @()
                        RecipientLimitInternalPerHour             = '0'
                        RecipientLimitPerDay                      = '0'
                        RecipientLimitExternalPerHour             = '0'
                        ActionWhenThresholdReached                = 'BlockUserForToday'
                        AutoForwardingMode                        = 'Off'
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
