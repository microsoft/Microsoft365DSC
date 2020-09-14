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
    -DscResource "EXOSafeLinksRule" -GenericStubModule $GenericStubPath
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

            Mock -CommandName New-SafeLinksRule -MockWith {
                return @{

                }
            }

            Mock -CommandName Set-SafeLinksRule -MockWith {
                return @{

                }
            }

            Mock -CommandName Remove-SafeLinksRule -MockWith {
                return @{

                }
            }

            Mock -CommandName New-EXOSafeLinksRule -MockWith {
                return @{

                }
            }

            Mock -CommandName Set-EXOSafeLinksRule -MockWith {
                return @{

                }
            }
        }

        # Test contexts
        Context -Name "SafeLinksRule creation." -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure             = 'Present'
                    Identity           = 'TestRule'
                    GlobalAdminAccount = $GlobalAdminAccount
                    SafeLinksPolicy    = 'TestSafeLinksPolicy'
                    Enabled            = $true
                    Priority           = 0
                    RecipientDomainIs  = @('contoso.com')
                }

                Mock -CommandName Get-SafeLinksRule -MockWith {
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

        Context -Name "SafeLinksRule update not required." -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure             = 'Present'
                    Identity           = 'TestRule'
                    GlobalAdminAccount = $GlobalAdminAccount
                    SafeLinksPolicy    = 'TestSafeLinksPolicy'
                    Enabled            = $true
                    Priority           = 0
                    RecipientDomainIs  = @('contoso.com')
                }

                Mock -CommandName Get-SafeLinksRule -MockWith {
                    return @{
                        Ensure             = 'Present'
                        Identity           = 'TestRule'
                        GlobalAdminAccount = $GlobalAdminAccount
                        SafeLinksPolicy    = 'TestSafeLinksPolicy'
                        Enabled            = $true
                        Priority           = 0
                        RecipientDomainIs  = @('contoso.com')
                        State              = 'Enabled'
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "SafeLinksRule update needed." -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure             = 'Present'
                    Identity           = 'TestRule'
                    GlobalAdminAccount = $GlobalAdminAccount
                    SafeLinksPolicy    = 'TestSafeLinksPolicy'
                    Enabled            = $true
                    Priority           = 0
                    RecipientDomainIs  = @('contoso.com')
                }

                Mock -CommandName Get-SafeLinksRule -MockWith {
                    return @{
                        Ensure             = 'Present'
                        Identity           = 'TestRule'
                        GlobalAdminAccount = $GlobalAdminAccount
                        SafeLinksPolicy    = 'TestSafeLinksPolicy'
                        State              = 'Disabled'
                        Priority           = 0
                        RecipientDomainIs  = @('fabrikam.com')
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

        Context -Name "SafeLinksRule removal." -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure             = 'Absent'
                    Identity           = 'TestRule'
                    GlobalAdminAccount = $GlobalAdminAccount
                    SafeLinksPolicy    = 'TestSafeLinksPolicy'
                    Enabled            = $true
                    Priority           = 0
                    RecipientDomainIs  = @('contoso.com')
                }

                Mock -CommandName Get-SafeLinksRule -MockWith {
                    return @{
                        Identity = 'TestRule'
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

                Mock -CommandName Get-SafeLinksRule -MockWith {
                    return @{
                        Identity = 'TestRule'
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
