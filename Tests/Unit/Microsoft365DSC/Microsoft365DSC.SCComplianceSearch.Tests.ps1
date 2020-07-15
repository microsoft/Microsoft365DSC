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
    -DscResource "SCComplianceSearch" -GenericStubModule $GenericStubPath
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

            Mock -CommandName Import-PSSession -MockWith {

            }

            Mock -CommandName New-PSSession -MockWith {

            }

            Mock -CommandName Remove-ComplianceSearch -MockWith {
                return @{

                }
            }

            Mock -CommandName New-ComplianceSearch -MockWith {
                return @{

                }
            }

            Mock -CommandName Set-ComplianceSearch -MockWith {
                return @{

                }
            }
        }

        # Test contexts
        Context -Name "Search doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    Case                                  = "Test Search Case";
                    Name                                  = "Demo Compliance Search";
                    Language                              = "iv";
                    AllowNotFoundExchangeLocationsEnabled = $False;
                    SharePointLocation                    = @("All");
                    GlobalAdminAccount                    = $GlobalAdminAccount
                    Ensure                                = "Present"
                }

                Mock -CommandName Get-ComplianceSearch -MockWith {
                    return $null
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Absent"
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "Search already exists, but need to update properties" -Fixture {
            BeforeAll {
                $testParams = @{
                    Case                                  = "Test Search Case";
                    Name                                  = "Demo Compliance Search";
                    Language                              = "iv";
                    AllowNotFoundExchangeLocationsEnabled = $False;
                    SharePointLocation                    = @("https://contoso.com");
                    GlobalAdminAccount                    = $GlobalAdminAccount
                    Ensure                                = "Present"
                }

                Mock -CommandName Get-ComplianceSearch -MockWith {
                    return @{
                        Name                                  = "Demo Compliance Search";
                        Case                                  = "Test Search Case"
                        Language                              = @{
                            TwoLetterISOLanguageName = "iv";
                        }
                        AllowNotFoundExchangeLocationsEnabled = $False;
                        SharePointLocation                    = @("https://tailspintoys.com")
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }
        }

        Context -Name "Rule should not exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    Case                                  = "Test Search Case";
                    Name                                  = "Demo Compliance Search";
                    Language                              = "iv";
                    AllowNotFoundExchangeLocationsEnabled = $False;
                    SharePointLocation                    = @("All");
                    GlobalAdminAccount                    = $GlobalAdminAccount
                    Ensure                                = "Absent"
                }

                Mock -CommandName Get-ComplianceSearch -MockWith {
                    return @{
                        Name                                  = "Demo Compliance Search";
                        Language                              = @{
                            TwoLetterISOLanguageName = "iv";
                        }
                        AllowNotFoundExchangeLocationsEnabled = $False;
                    }
                }
            }

            It 'Should return False from the Test method' {
                Test-TargetResource @testParams | Should -Be $False
            }

            It 'Should delete from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-ComplianceSearch -MockWith {
                    return @{
                        Name                                  = "Demo Compliance Search";
                        Case                                  = "Test Search Case"
                        Language                              = @{
                            TwoLetterISOLanguageName = "iv";
                        }
                        AllowNotFoundExchangeLocationsEnabled = $False;
                        SharePointLocation                    = @("https://tailspintoys.com")
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
