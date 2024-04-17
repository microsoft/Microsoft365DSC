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
    -DscResource 'EXOAcceptedDomain' -GenericStubModule $GenericStubPath
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

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'Authoritative Accepted Domain should exist.  Domain is missing. Test should fail.' -Fixture {
            BeforeAll {
                $testParams = @{
                    DomainType = 'Authoritative'
                    Ensure     = 'Present'
                    Credential = $Credential
                    Identity   = 'contoso.com'
                }
                Mock -CommandName Get-AcceptedDomain -MockWith {
                    return $null
                }
                Mock -CommandName Set-AcceptedDomain -MockWith {
                    return @{
                        DomainType = 'Authoritative'
                        Ensure     = 'Present'
                        Credential = $Credential
                        Identity   = 'contoso.com'
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
        }

        Context -Name "Verified domain doesn't exist in the tenant." -Fixture {
            BeforeAll {
                $testParams = @{
                    DomainType     = 'Authoritative'
                    Ensure         = 'Absent'
                    MatchSubDomain = $false
                    OutboundOnly   = $false
                    Credential     = $Credential
                    Identity       = 'contoso.com'
                }

                Mock -CommandName Get-AcceptedDomain -MockWith {
                    return $null
                }
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
        }

        Context -Name 'Authoritative Accepted Domain should exist.  Domain exists. Test should pass.' -Fixture {
            BeforeAll {
                $testParams = @{
                    DomainType     = 'Authoritative'
                    Ensure         = 'Present'
                    MatchSubDomain = $false
                    OutboundOnly   = $false
                    Credential     = $Credential
                    Identity       = 'contoso.com'
                }

                Mock -CommandName Get-AcceptedDomain -MockWith {
                    return @{
                        DomainType      = 'Authoritative'
                        Identity        = 'contoso.com'
                        MatchSubDomains = $false
                        OutboundOnly    = $false
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should return Present from the Get Method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name 'Authoritative Accepted Domain should exist.  Domain exists, DomainType and MatchSubDomains mismatch. Test should fail.' -Fixture {
            BeforeAll {
                $testParams = @{
                    DomainType = 'Authoritative'
                    Ensure     = 'Present'
                    Credential = $Credential
                    Identity   = 'contoso.com'
                }

                Mock -CommandName Get-AcceptedDomain -MockWith {
                    return @{
                        DomainType      = 'InternalRelay'
                        Identity        = 'contoso.com'
                        MatchSubDomains = $true
                        OutboundOnly    = $false
                    }
                }
                Mock -CommandName Set-AcceptedDomain -MockWith {
                    return @{
                        DomainType = 'Authoritative'
                        Ensure     = 'Present'
                        Credential = $Credential
                        Identity   = 'contoso.com'
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

                $acceptedDomain1 = @{
                    DomainType      = 'Authoritative'
                    Identity        = 'different1.tailspin.com'
                    MatchSubDomains = $false
                    OutboundOnly    = $false
                }

                $acceptedDomain2 = @{
                    DomainType      = 'Authoritative'
                    Identity        = 'different2.tailspin.com'
                    MatchSubDomains = $false
                    OutboundOnly    = $false
                }
            }

            It 'Should Reverse Engineer resource from the Export method when single' {
                Mock -CommandName Get-AcceptedDomain -MockWith {
                    return $acceptedDomain1
                }
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }

            It 'Should Reverse Engineer resource from the Export method when multiple' {
                Mock -CommandName Get-AcceptedDomain -MockWith {
                    return @($acceptedDomain1, $acceptedDomain2)
                }
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
