[CmdletBinding()]
param(
    [Parameter()]
    [string]
    $CmdletModule = (Join-Path -Path $PSScriptRoot `
                                         -ChildPath "..\Stubs\Office365.psm1" `
                                         -Resolve)
)

Import-Module -Name (Join-Path -Path $PSScriptRoot `
                                -ChildPath "..\UnitTestHelper.psm1" `
                                -Resolve)

$Global:DscHelper = New-O365DscUnitTestHelper -StubModule $CmdletModule `
                                              -DscResource "EXOAcceptedDomain"
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Close-SessionsAndReturnError -MockWith {

        }

        Mock -CommandName Connect-ExchangeOnline -MockWith {

        }

        Mock -CommandName Test-O365ServiceConnection -MockWith {

        }

        Mock -CommandName Get-PSSession -MockWith {

        }

        Mock -CommandName Remove-PSSession -MockWith {

        }

        # Test contexts
        Context -Name "Authoritative Accepted Domain should exist.  Domain is missing. Test should fail." -Fixture {
            $testParams = @{
                DomainType         = 'Authoritative'
                Ensure             = 'Present'
                GlobalAdminAccount = $GlobalAdminAccount
                Identity           = 'contoso.com'
            }

            Mock -CommandName Get-AzureADDomain -MockWith {
                return @{
                    Name = 'different.contoso.com'
                    IsVerified = $true
                }
            }

            Mock -CommandName Get-AcceptedDomain -MockWith {
                return @{
                    DomainType         = 'Authoritative'
                    Identity           = 'different.contoso.com'
                    MatchSubDomains    = $false
                    OutboundOnly       = $false
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            Mock -CommandName Set-AcceptedDomain -MockWith {
                return @{
                    DomainType         = 'Authoritative'
                    Ensure             = 'Present'
                    GlobalAdminAccount = $GlobalAdminAccount
                    Identity           = 'contoso.com'
                }
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }
        }

        Context -Name "Authoritative Accepted Domain should exist.  Domain exists. Test should pass." -Fixture {
            $testParams = @{
                DomainType         = 'Authoritative'
                Ensure             = 'Present'
                GlobalAdminAccount = $GlobalAdminAccount
                Identity           = 'contoso.com'
            }

            Mock -CommandName Get-AzureADDomain -MockWith {
                return @{
                    Name = 'contoso.com'
                    IsVerified = $true
                }

            }

            Mock -CommandName Get-AcceptedDomain -MockWith {
                return @{
                    DomainType         = 'Authoritative'
                    Identity           = 'contoso.com'
                    MatchSubDomains    = $false
                    OutboundOnly       = $false
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should Be $true
            }

            It 'Should return Present from the Get Method' {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }
        }

        Context -Name "Authoritative Accepted Domain should exist.  Domain exists, DomainType and MatchSubDomains mismatch. Test should fail." -Fixture {
            $testParams = @{
                DomainType         = 'Authoritative'
                Ensure             = 'Present'
                GlobalAdminAccount = $GlobalAdminAccount
                Identity           = 'contoso.com'
            }

            Mock -CommandName Get-AzureADDomain -MockWith {
                return @{
                    Name = 'contoso.com'
                    IsVerified = $true
                }

            }

            Mock -CommandName Get-AcceptedDomain -MockWith {
                return @{
                    DomainType         = 'InternalRelay'
                    Identity           = 'contoso.com'
                    MatchSubDomains    = $true
                    OutboundOnly       = $false
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            Mock -CommandName Set-AcceptedDomain -MockWith {

            }

            Mock -CommandName Set-AcceptedDomain -MockWith {
                return @{
                    DomainType         = 'Authoritative'
                    Ensure             = 'Present'
                    GlobalAdminAccount = $GlobalAdminAccount
                    Identity           = 'contoso.com'
                }
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
                Identity           = "contoso.com"
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
