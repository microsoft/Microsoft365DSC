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
    -DscResource "EXOAntiPhishPolicy" -GenericStubModule $GenericStubPath
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

            Mock -CommandName New-AntiPhishPolicy -MockWith {
                return @{

                }
            }

            Mock -CommandName Set-AntiPhishPolicy -MockWith {
                return @{

                }
            }

            Mock -CommandName New-EXOAntiPhishPolicy -MockWith {
                return @{

                }
            }

            Mock -CommandName Set-EXOAntiPhishPolicy -MockWith {
                return @{

                }
            }
        }

        # Test contexts
        Context -Name "AntiPhishPolicy creation." -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure             = 'Present'
                    GlobalAdminAccount = $GlobalAdminAccount
                    Identity           = 'TestPolicy'
                }

                Mock -CommandName Get-AntiPhishPolicy -MockWith {
                    return @{
                        Identity = 'SomeOtherPolicy'
                    }
                }
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Absent"
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }

        }

        Context -Name "AntiPhishPolicy update not required." -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                                = 'Present'
                    GlobalAdminAccount                    = $GlobalAdminAccount
                    Identity                              = 'TestPolicy'
                    PhishThresholdLevel                   = '2'
                    AdminDisplayName                      = 'DSC Test Policy'
                    Enabled                               = $true
                    EnableAntispoofEnforcement            = $true
                    EnableMailboxIntelligence             = $true
                    EnableOrganizationDomainsProtection   = $false
                    EnableSimilarDomainsSafetyTips        = $false
                    EnableSimilarUsersSafetyTips          = $false
                    EnableTargetedDomainsProtection       = $false
                    EnableTargetedUserProtection          = $false
                    EnableUnusualCharactersSafetyTips     = $false
                    MakeDefault                           = $false
                    AuthenticationFailAction              = 'Quarantine'
                    TargetedDomainProtectionAction        = 'BccMessage'
                    TargetedDomainActionRecipients        = @('test@contoso.com', 'test@fabrikam.com')
                    TargetedUserProtectionAction          = 'BccMessage'
                    TargetedUserActionRecipients          = @('test@contoso.com', 'test@fabrikam.com')
                    TargetedDomainsToProtect              = @('fabrikam.com', 'contoso.com')
                    TargetedUsersToProtect                = @('fabrikam.com', 'contoso.com')
                }

                Mock -CommandName Get-AntiPhishPolicy -MockWith {
                    return @{
                        Ensure                                = 'Present'
                        Identity                              = 'TestPolicy'
                        PhishThresholdLevel                   = '2'
                        AdminDisplayName                      = 'DSC Test Policy'
                        Enabled                               = $true
                        EnableAntispoofEnforcement            = $true
                        EnableAuthenticationSafetyTip         = $true
                        EnableAuthenticationSoftPassSafetyTip = $false
                        EnableMailboxIntelligence             = $true
                        EnableOrganizationDomainsProtection   = $false
                        EnableSimilarDomainsSafetyTips        = $false
                        EnableSimilarUsersSafetyTips          = $false
                        EnableTargetedDomainsProtection       = $false
                        EnableTargetedUserProtection          = $false
                        EnableUnusualCharactersSafetyTips     = $false
                        MakeDefault                           = $false
                        TreatSoftPassAsAuthenticated          = $true
                        AuthenticationFailAction              = 'Quarantine'
                        TargetedDomainProtectionAction        = 'BccMessage'
                        TargetedDomainActionRecipients        = @('test@contoso.com', 'test@fabrikam.com')
                        TargetedUserProtectionAction          = 'BccMessage'
                        TargetedUserActionRecipients          = @('test@contoso.com', 'test@fabrikam.com')
                        TargetedDomainsToProtect              = @('fabrikam.com', 'contoso.com')
                        TargetedUsersToProtect                = @('fabrikam.com', 'contoso.com')
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "AntiPhishPolicy update needed." -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                                = 'Present'
                    GlobalAdminAccount                    = $GlobalAdminAccount
                    Identity                              = 'TestPolicy'
                    PhishThresholdLevel                   = '2'
                    AdminDisplayName                      = 'DSC Test Policy'
                    Enabled                               = $true
                    EnableAntispoofEnforcement            = $true
                    EnableMailboxIntelligence             = $true
                    EnableOrganizationDomainsProtection   = $false
                    EnableSimilarDomainsSafetyTips        = $false
                    EnableSimilarUsersSafetyTips          = $false
                    EnableTargetedDomainsProtection       = $false
                    EnableTargetedUserProtection          = $false
                    EnableUnusualCharactersSafetyTips     = $false
                    MakeDefault                           = $false
                    AuthenticationFailAction              = 'Quarantine'
                    TargetedDomainProtectionAction        = 'BccMessage'
                    TargetedDomainActionRecipients        = @('test@contoso.com', 'test@fabrikam.com')
                    TargetedUserProtectionAction          = 'BccMessage'
                    TargetedUserActionRecipients          = @('test@contoso.com', 'test@fabrikam.com')
                    TargetedDomainsToProtect              = @('fabrikam.com', 'contoso.com')
                    TargetedUsersToProtect                = @('fabrikam.com', 'contoso.com')
                }

                Mock -CommandName Get-AntiPhishPolicy -MockWith {
                    return @{
                        Identity                              = 'TestPolicy'
                        PhishThresholdLevel                   = '2'
                        AdminDisplayName                      = 'DSC Test Policy'
                        Enabled                               = $false
                        EnableAntispoofEnforcement            = $false
                        EnableMailboxIntelligence             = $false
                        EnableOrganizationDomainsProtection   = $true
                        EnableSimilarDomainsSafetyTips        = $true
                        EnableSimilarUsersSafetyTips          = $true
                        EnableTargetedDomainsProtection       = $true
                        EnableTargetedUserProtection          = $true
                        EnableUnusualCharactersSafetyTips     = $true
                        MakeDefault                           = $true
                        AuthenticationFailAction              = 'MoveToJmf'
                        TargetedDomainProtectionAction        = 'NoAction'
                        TargetedDomainActionRecipients        = @()
                        TargetedUserProtectionAction          = 'NoAction'
                        TargetedUserActionRecipients          = @()
                        TargetedDomainsToProtect              = @()
                        TargetedUsersToProtect                = @()
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

            It "Should Successfully call the Set method" {
                Set-TargetResource @testParams
            }

        }

        Context -Name "AntiPhishPolicy removal." -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure             = 'Absent'
                    GlobalAdminAccount = $GlobalAdminAccount
                    Identity           = 'TestPolicy'
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

            It "Should Remove the Policy in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
                BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-AntiPhishPolicy -MockWith {
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
