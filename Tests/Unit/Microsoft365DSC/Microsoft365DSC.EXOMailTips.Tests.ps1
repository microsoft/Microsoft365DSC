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
    -DscResource "EXOMailTips" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin@contoso.onmicrosoft.com", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }
        }

        # Test contexts
        Context -Name "MailTips are Disabled and should be Enabled" -Fixture {
            BeforeAll {
                $testParams = @{
                    Organization           = "contoso.onmicrosoft.com"
                    MailTipsAllTipsEnabled = $True
                    Ensure                 = "Present"
                    GlobalAdminAccount     = $GlobalAdminAccount
                }

                Mock -CommandName Get-OrganizationConfig -MockWith {
                    return @{
                        MailTipsAllTipsEnabled = $False
                    }
                }

                Mock -CommandName Set-OrganizationConfig -MockWith {

                }
            }

            It "Should return False from the Get method" {
                (Get-TargetResource @testParams).MailTipsAllTipsEnabled | Should -Be $False
            }

            It "Should set MailTipsAllTipsEnabled to True with the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "MailTipsGroupMetricsEnabled are Disabled and should be Enabled" -Fixture {
            BeforeAll {
                $testParams = @{
                    Organization                = "contoso.onmicrosoft.com"
                    MailTipsGroupMetricsEnabled = $True
                    Ensure                      = "Present"
                    GlobalAdminAccount          = $GlobalAdminAccount
                }

                Mock -CommandName Get-OrganizationConfig -MockWith {
                    return @{
                        MailTipsGroupMetricsEnabled = $False
                    }
                }

                Mock -CommandName Set-OrganizationConfig -MockWith {

                }
            }

            It "Should return False from the Get method" {
                (Get-TargetResource @testParams).MailTipsGroupMetricsEnabled | Should -Be $False
            }

            It "Should set MailTipsGroupMetricsEnabled to True with the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "MailTipsLargeAudienceThreshold are 25 and should be 50" -Fixture {
            BeforeAll {
                $testParams = @{
                    Organization                   = "contoso.onmicrosoft.com"
                    MailTipsLargeAudienceThreshold = 50
                    Ensure                         = "Present"
                    GlobalAdminAccount             = $GlobalAdminAccount
                }

                Mock -CommandName Get-OrganizationConfig -MockWith {
                    return @{
                        MailTipsLargeAudienceThreshold = 25
                    }
                }

                Mock -CommandName Set-OrganizationConfig -MockWith {

                }
            }

            It "Should return 25 from the Get method" {
                (Get-TargetResource @testParams).MailTipsLargeAudienceThreshold | Should -Be 25
            }

            It "Should set MailTipsLargeAudienceThreshold to 50 with the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "MailTipsMailboxSourcedTipsEnabled are Disabled and should be Enabled" -Fixture {
            BeforeAll {
                $testParams = @{
                    Organization                      = "contoso.onmicrosoft.com"
                    MailTipsMailboxSourcedTipsEnabled = $True
                    Ensure                            = "Present"
                    GlobalAdminAccount                = $GlobalAdminAccount
                }

                Mock -CommandName Get-OrganizationConfig -MockWith {
                    return @{
                        MailTipsMailboxSourcedTipsEnabled = $False
                    }
                }

                Mock -CommandName Set-OrganizationConfig -MockWith {

                }
            }

            It "Should return False from the Get method" {
                (Get-TargetResource @testParams).MailTipsMailboxSourcedTipsEnabled | Should -Be $False
            }

            It "Should set MailTipsMailboxSourcedTipsEnabled to True with the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "MailTipsExternalRecipientsTipsEnabled are Disabled and should be Enabled" -Fixture {
            BeforeAll {
                $testParams = @{
                    Organization                          = "contoso.onmicrosoft.com"
                    MailTipsExternalRecipientsTipsEnabled = $True
                    Ensure                                = "Present"
                    GlobalAdminAccount                    = $GlobalAdminAccount
                }

                Mock -CommandName Get-OrganizationConfig -MockWith {
                    return @{
                        MailTipsExternalRecipientsTipsEnabled = $False
                    }
                }

                Mock -CommandName Set-OrganizationConfig -MockWith {

                }
            }

            It "Should return False from the Get method" {
                (Get-TargetResource @testParams).MailTipsExternalRecipientsTipsEnabled | Should -Be $False
            }

            It "Should set MailTipsExternalRecipientsTipsEnabled to True with the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "MailTips are Enabled and should be Enabled" -Fixture {
            BeforeAll {
                $testParams = @{
                    Organization                          = "contoso.onmicrosoft.com"
                    MailTipsAllTipsEnabled                = $True
                    MailTipsLargeAudienceThreshold        = 10
                    MailTipsMailboxSourcedTipsEnabled     = $True
                    MailTipsGroupMetricsEnabled           = $True
                    MailTipsExternalRecipientsTipsEnabled = $True
                    Ensure                                = "Present"
                    GlobalAdminAccount                    = $GlobalAdminAccount
                }

                Mock -CommandName Get-OrganizationConfig -MockWith {
                    return @{
                        MailTipsAllTipsEnabled                = $True
                        MailTipsLargeAudienceThreshold        = 10
                        MailTipsMailboxSourcedTipsEnabled     = $True
                        MailTipsGroupMetricsEnabled           = $True
                        MailTipsExternalRecipientsTipsEnabled = $True
                    }
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }

            It "Should return True from the Test method" {
                { Test-TargetResource @testParams } | Should -Be $True
            }
        }

        Context -Name "Organization Configuration is null" -Fixture {
            BeforeAll {
                $testParams = @{
                    Organization           = "contoso.onmicrosoft.com"
                    MailTipsAllTipsEnabled = $True
                    Ensure                 = "Present"
                    GlobalAdminAccount     = $GlobalAdminAccount
                }

                Mock -CommandName Get-OrganizationConfig -MockWith {
                    return $null
                }
            }

            It "Should return Ensure is Absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Absent"
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-OrganizationConfig -MockWith {
                    return @{
                        Organization                          = "contoso.onmicrosoft.com"
                        MailTipsAllTipsEnabled                = $True
                        MailTipsGroupMetricsEnabled           = $True
                        MailTipsLargeAudienceThreshold        = $True
                        MailTipsMailboxSourcedTipsEnabled     = $True
                        MailTipsExternalRecipientsTipsEnabled = $True
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
