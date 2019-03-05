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

        Mock Invoke-ExoCommand {
            return Invoke-Command -ScriptBlock $ScriptBlock -ArgumentList $Arguments -NoNewScope
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

            }

            It 'Should return true from the Set method' {
                Set-TargetResource @testParams | Should Be $true
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


        }

        Context -Name "Authoritative Accepted Domain should exist.  Domain exists, DomainType mismatch. Test should fail." -Fixture {
            $testParams = @{
                DomainType         = 'Authoritative'
                Ensure             = 'Present'
                GlobalAdminAccount = $GlobalAdminAccount
                Identity           = 'contoso.com'
            }

            Mock -CommandName Get-AcceptedDomain -MockWith {
                return @{
                    DomainType         = 'InternalRelay'
                    Identity           = 'contoso.com'
                    MatchSubDomains    = $false
                    OutboundOnly       = $false
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should Be $false
            }

            Mock -CommandName Set-AcceptedDomain -MockWith {

            }

            It 'Should return true from the Set method' {
                Set-TargetResource @testParams | Should Be $true
            }

        }

    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
