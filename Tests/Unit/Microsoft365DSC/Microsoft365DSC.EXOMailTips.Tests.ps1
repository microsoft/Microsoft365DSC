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
    -DscResource 'EXOMailTips' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'test@password1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@contoso.onmicrosoft.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'MailTips are Disabled and should be Enabled' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance       = 'Yes'
                    MailTipsAllTipsEnabled = $True
                    Ensure                 = 'Present'
                    Credential             = $Credential
                }

                Mock -CommandName Get-OrganizationConfig -MockWith {
                    return @{
                        MailTipsAllTipsEnabled = $False
                    }
                }

                Mock -CommandName Set-OrganizationConfig -MockWith {

                }
            }

            It 'Should return False from the Get method' {
                (Get-TargetResource @testParams).MailTipsAllTipsEnabled | Should -Be $False
            }

            It 'Should set MailTipsAllTipsEnabled to True from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return False from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
        }

        Context -Name 'MailTipsGroupMetricsEnabled are Disabled and should be Enabled' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance            = 'Yes'
                    MailTipsGroupMetricsEnabled = $True
                    Ensure                      = 'Present'
                    Credential                  = $Credential
                }

                Mock -CommandName Get-OrganizationConfig -MockWith {
                    return @{
                        MailTipsGroupMetricsEnabled = $False
                    }
                }

                Mock -CommandName Set-OrganizationConfig -MockWith {

                }
            }

            It 'Should return False from the Get method' {
                (Get-TargetResource @testParams).MailTipsGroupMetricsEnabled | Should -Be $False
            }

            It 'Should set MailTipsGroupMetricsEnabled to True with the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return False from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
        }

        Context -Name 'MailTipsLargeAudienceThreshold are 25 and should be 50' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance               = 'Yes'
                    MailTipsLargeAudienceThreshold = 50
                    Ensure                         = 'Present'
                    Credential                     = $Credential
                }

                Mock -CommandName Get-OrganizationConfig -MockWith {
                    return @{
                        MailTipsLargeAudienceThreshold = 25
                    }
                }

                Mock -CommandName Set-OrganizationConfig -MockWith {

                }
            }

            It 'Should return 25 from the Get method' {
                (Get-TargetResource @testParams).MailTipsLargeAudienceThreshold | Should -Be 25
            }

            It 'Should set MailTipsLargeAudienceThreshold to 50 with the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return False from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
        }

        Context -Name 'MailTipsMailboxSourcedTipsEnabled are Disabled and should be Enabled' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance                  = 'Yes'
                    MailTipsMailboxSourcedTipsEnabled = $True
                    Ensure                            = 'Present'
                    Credential                        = $Credential
                }

                Mock -CommandName Get-OrganizationConfig -MockWith {
                    return @{
                        MailTipsMailboxSourcedTipsEnabled = $False
                    }
                }

                Mock -CommandName Set-OrganizationConfig -MockWith {

                }
            }

            It 'Should return False from the Get method' {
                (Get-TargetResource @testParams).MailTipsMailboxSourcedTipsEnabled | Should -Be $False
            }

            It 'Should set MailTipsMailboxSourcedTipsEnabled to True with the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'MailTipsExternalRecipientsTipsEnabled are Disabled and should be Enabled' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance                      = 'Yes'
                    MailTipsExternalRecipientsTipsEnabled = $True
                    Ensure                                = 'Present'
                    Credential                            = $Credential
                }

                Mock -CommandName Get-OrganizationConfig -MockWith {
                    return @{
                        MailTipsExternalRecipientsTipsEnabled = $False
                    }
                }

                Mock -CommandName Set-OrganizationConfig -MockWith {

                }
            }

            It 'Should return False from the Get method' {
                (Get-TargetResource @testParams).MailTipsExternalRecipientsTipsEnabled | Should -Be $False
            }

            It 'Should set MailTipsExternalRecipientsTipsEnabled to True with the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return False from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
        }

        Context -Name 'MailTips are Enabled and should be Enabled' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance                      = 'Yes'
                    MailTipsAllTipsEnabled                = $True
                    MailTipsLargeAudienceThreshold        = 10
                    MailTipsMailboxSourcedTipsEnabled     = $True
                    MailTipsGroupMetricsEnabled           = $True
                    MailTipsExternalRecipientsTipsEnabled = $True
                    Ensure                                = 'Present'
                    Credential                            = $Credential
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

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return True from the Test method' {
                { Test-TargetResource @testParams } | Should -Be $True
            }
        }

        Context -Name 'Organization Configuration is null' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance       = 'Yes'
                    MailTipsAllTipsEnabled = $True
                    Ensure                 = 'Present'
                    Credential             = $Credential
                }

                Mock -CommandName Get-OrganizationConfig -MockWith {
                    return $null
                }
            }

            It 'Should return Ensure is Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-OrganizationConfig -MockWith {
                    return @{
                        IsSingleInstance                      = 'Yes'
                        MailTipsAllTipsEnabled                = $True
                        MailTipsGroupMetricsEnabled           = $True
                        MailTipsLargeAudienceThreshold        = $True
                        MailTipsMailboxSourcedTipsEnabled     = $True
                        MailTipsExternalRecipientsTipsEnabled = $True
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
