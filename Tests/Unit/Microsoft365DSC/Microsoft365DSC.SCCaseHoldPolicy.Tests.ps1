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
    -DscResource "SCCaseHoldPolicy" -GenericStubModule $GenericStubPath
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

            Mock -CommandName Remove-CaseHoldPolicy -MockWith {
                return @{

                }
            }

            Mock -CommandName New-CaseHoldPolicy -MockWith {
                return @{

                }
            }

            Mock -CommandName Set-CaseHoldPolicy -MockWith {
                return @{

                }
            }
        }

        # Test contexts
        Context -Name "Policy doesn't already exists and should be Active" -Fixture {
            BeforeAll {
                $testParams = @{
                    Name               = "Test Policy"
                    Case               = "Test Case"
                    Comment            = "This is a test Case"
                    Enabled            = $true
                    GlobalAdminAccount = $GlobalAdminAccount
                    Ensure             = "Present"
                }

                Mock -CommandName Get-CaseHoldPolicy -MockWith {
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


        Context -Name "Policy already exists" -Fixture {
            BeforeAll {
                $testParams = @{
                    Name                 = "Test Policy"
                    Case                 = "Test Case"
                    Comment              = "This is a test Case"
                    Enabled              = $true
                    SharePointLocation   = @("https://contoso.com", "https://northwind.com")
                    ExchangeLocation     = @("admin@contoso.com", "admin@northwind.com")
                    PublicFolderLocation = @("contoso.com", "northwind.com")
                    GlobalAdminAccount   = $GlobalAdminAccount
                    Ensure               = "Present"
                }

                Mock -CommandName Get-CaseHoldPolicy -MockWith {
                    return @{
                        Name                 = "Test Policy"
                        Comment              = "Different Comment"
                        Enabled              = $true
                        SharePointLocation   = @(
                            @{
                                Name = "https://contoso.com"
                            },
                            @{
                                Name = "https://tailspintoys.com"
                            }
                        )
                        ExchangeLocation     = @(
                            @{
                                Name = "admin@contoso.com"
                            },
                            @{
                                Name = "admin@tailspintoys.com"
                            }
                        )
                        PublicFolderLocation = @(
                            @{
                                Name = "contoso.com"
                            },
                            @{
                                Name = "tailspintoys.com"
                            }
                        )
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $False
            }

            It 'Should update from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }
        }

        Context -Name "Policy already exists but shouldn't" -Fixture {
            BeforeAll {
                $testParams = @{
                    Name               = "Test Policy"
                    Case               = "Test Case"
                    Comment            = "This is a test Case"
                    GlobalAdminAccount = $GlobalAdminAccount
                    Ensure             = "Absent"
                }

                Mock -CommandName Get-CaseHoldPolicy -MockWith {
                    return @{
                        Name        = "Test Policy"
                        Description = "This is a test Case"
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $False
            }

            It 'Should remove it from the Set method' {
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

                $caseHoldPolicy1 = @{
                    Name                 = "Test Policy1"
                    Comment              = "Different Comment"
                    Enabled              = $true
                    SharePointLocation   = @(
                        @{
                            Name = "https://contoso.com"
                        },
                        @{
                            Name = "https://tailspintoys.com"
                        }
                    )
                    ExchangeLocation     = @(
                        @{
                            Name = "admin@contoso.com"
                        },
                        @{
                            Name = "admin@tailspintoys.com"
                        }
                    )
                    PublicFolderLocation = @(
                        @{
                            Name = "contoso.com"
                        },
                        @{
                            Name = "tailspintoys.com"
                        }
                    )
                }

                $caseHoldPolicy2 = @{
                    Name                 = "Test Policy2"
                    Comment              = "Different Comment"
                    Enabled              = $true
                    SharePointLocation   = @(
                        @{
                            Name = "https://contoso.com"
                        },
                        @{
                            Name = "https://tailspintoys.com"
                        }
                    )
                    ExchangeLocation     = @(
                        @{
                            Name = "admin@contoso.com"
                        },
                        @{
                            Name = "admin@tailspintoys.com"
                        }
                    )
                    PublicFolderLocation = @(
                        @{
                            Name = "contoso.com"
                        },
                        @{
                            Name = "tailspintoys.com"
                        }
                    )
                }

                Mock -CommandName Get-CaseHoldPolicy -ParameterFilter { $Case -eq "Case1" } -MockWith {
                    return $caseHoldPolicy1
                }

                Mock -CommandName Get-CaseHoldPolicy -ParameterFilter { $Case -eq "Case2" } -MockWith {
                    return $caseHoldPolicy2
                }
            }

            It "Should Reverse Engineer resource from the Export method when single compliance case" {
                Mock -CommandName Get-ComplianceCase -MockWith {
                    return @{Name = "Case1" }
                }

                Export-TargetResource @testParams
            }

            It "Should Reverse Engineer resource from the Export method when multiple compliance case" {
                Mock -CommandName Get-ComplianceCase -MockWith {
                    return @(@{Name = "Case1" }, @{Name = "Case2" })
                }

                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
