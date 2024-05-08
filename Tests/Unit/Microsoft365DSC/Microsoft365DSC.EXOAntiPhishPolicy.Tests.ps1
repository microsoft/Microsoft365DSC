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
    -DscResource 'EXOAntiPhishPolicy' -GenericStubModule $GenericStubPath
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

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName New-AntiPhishPolicy -MockWith {
                return @{

                }
            }

            Mock -CommandName Set-AntiPhishPolicy -MockWith {
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
        Context -Name 'AntiPhishPolicy creation.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure     = 'Present'
                    Credential = $Credential
                    Identity   = 'TestPolicy'
                }

                Mock -CommandName Get-AntiPhishPolicy -MockWith {
                    return @{
                        Identity = 'SomeOtherPolicy'
                    }
                }
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
            }

        }

        Context -Name 'AntiPhishPolicy update not required.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                              = 'Present'
                    Credential                          = $Credential
                    Identity                            = 'TestPolicy'
                    PhishThresholdLevel                 = '2'
                    AdminDisplayName                    = 'DSC Test Policy'
                    Enabled                             = $true
                    EnableFirstContactSafetyTips        = $false
                    EnableMailboxIntelligence           = $true
                    EnableOrganizationDomainsProtection = $false
                    EnableSimilarDomainsSafetyTips      = $false
                    EnableSimilarUsersSafetyTips        = $false
                    EnableTargetedDomainsProtection     = $false
                    EnableTargetedUserProtection        = $false
                    EnableUnusualCharactersSafetyTips   = $false
                    EnableViaTag                        = $false
                    MakeDefault                         = $false
                    AuthenticationFailAction            = 'Quarantine'
                    TargetedDomainActionRecipients      = @('test@contoso.com', 'test@fabrikam.com')
                    TargetedUserProtectionAction        = 'BccMessage'
                    TargetedUserActionRecipients        = @('test@contoso.com', 'test@fabrikam.com')
                    TargetedDomainsToProtect            = @('fabrikam.com', 'contoso.com')
                    TargetedUsersToProtect              = @('fabrikam.com', 'contoso.com')
                }

                Mock -CommandName Get-AntiPhishPolicy -MockWith {
                    return @{
                        Ensure                              = 'Present'
                        Identity                            = 'TestPolicy'
                        PhishThresholdLevel                 = '2'
                        AdminDisplayName                    = 'DSC Test Policy'
                        Enabled                             = $true
                        EnableFirstContactSafetyTips        = $false
                        EnableAuthenticationSafetyTip       = $true
                        EnableMailboxIntelligence           = $true
                        EnableOrganizationDomainsProtection = $false
                        EnableSimilarDomainsSafetyTips      = $false
                        EnableSimilarUsersSafetyTips        = $false
                        EnableTargetedDomainsProtection     = $false
                        EnableTargetedUserProtection        = $false
                        EnableUnusualCharactersSafetyTips   = $false
                        EnableViaTag                        = $false
                        IsDefault                           = $false
                        TreatSoftPassAsAuthenticated        = $true
                        AuthenticationFailAction            = 'Quarantine'
                        TargetedDomainActionRecipients      = @('test@contoso.com', 'test@fabrikam.com')
                        TargetedUserProtectionAction        = 'BccMessage'
                        TargetedUserActionRecipients        = @('test@contoso.com', 'test@fabrikam.com')
                        TargetedDomainsToProtect            = @('fabrikam.com', 'contoso.com')
                        TargetedUsersToProtect              = @('fabrikam.com', 'contoso.com')
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'AntiPhishPolicy update needed.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                              = 'Present'
                    Credential                          = $Credential
                    Identity                            = 'TestPolicy'
                    PhishThresholdLevel                 = '2'
                    AdminDisplayName                    = 'DSC Test Policy'
                    Enabled                             = $true
                    EnableFirstContactSafetyTips        = $false
                    EnableMailboxIntelligence           = $true
                    EnableOrganizationDomainsProtection = $false
                    EnableSimilarDomainsSafetyTips      = $false
                    EnableSimilarUsersSafetyTips        = $false
                    EnableTargetedDomainsProtection     = $false
                    EnableTargetedUserProtection        = $false
                    EnableUnusualCharactersSafetyTips   = $false
                    EnableViaTag                        = $false
                    MakeDefault                         = $false
                    AuthenticationFailAction            = 'Quarantine'
                    TargetedDomainActionRecipients      = @('test@contoso.com', 'test@fabrikam.com')
                    TargetedUserProtectionAction        = 'BccMessage'
                    TargetedUserActionRecipients        = @('test@contoso.com', 'test@fabrikam.com')
                    TargetedDomainsToProtect            = @('fabrikam.com', 'contoso.com')
                    TargetedUsersToProtect              = @('fabrikam.com', 'contoso.com')
                }

                Mock -CommandName Get-AntiPhishPolicy -MockWith {
                    return @{
                        Identity                            = 'TestPolicy'
                        PhishThresholdLevel                 = '2'
                        AdminDisplayName                    = 'DSC Test Policy'
                        Enabled                             = $false
                        EnableFirstContactSafetyTips        = $true
                        EnableMailboxIntelligence           = $false
                        EnableOrganizationDomainsProtection = $true
                        EnableSimilarDomainsSafetyTips      = $true
                        EnableSimilarUsersSafetyTips        = $true
                        EnableTargetedDomainsProtection     = $true
                        EnableTargetedUserProtection        = $true
                        EnableUnusualCharactersSafetyTips   = $true
                        EnableViaTag                        = $true
                        MakeDefault                         = $true
                        AuthenticationFailAction            = 'MoveToJmf'
                        TargetedDomainActionRecipients      = @()
                        TargetedUserProtectionAction        = 'NoAction'
                        TargetedUserActionRecipients        = @()
                        TargetedDomainsToProtect            = @()
                        TargetedUsersToProtect              = @()
                    }
                }

                Mock -CommandName Set-AntiPhishPolicy -MockWith {
                    return @{

                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Successfully call the Set method' {
                Set-TargetResource @testParams
            }

        }

        Context -Name 'AntiPhishPolicy removal.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure     = 'Absent'
                    Credential = $Credential
                    Identity   = 'TestPolicy'
                }

                Mock -CommandName Get-AntiPhishPolicy -MockWith {
                    return @{
                        Identity = 'TestPolicy'
                    }
                }

                Mock -CommandName Remove-AntiPhishPolicy -MockWith {
                    return @{

                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the Policy in the Set method' {
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

                Mock -CommandName Get-AntiPhishPolicy -MockWith {
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
