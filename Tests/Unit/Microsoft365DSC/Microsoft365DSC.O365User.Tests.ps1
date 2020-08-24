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
    -DscResource "O365User" -GenericStubModule $GenericStubPath
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

            Mock -CommandName Set-AzureADUser -MockWith {
            }

            Mock -CommandName Set-AzureADUserLicense -MockWith {
            }

            Mock -CommandName Set-AzureADUserPassword -MockWith {
            }
        }
        # Test contexts
        Context -Name "When the user doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    UserPrincipalName  = "JohnSmith@contoso.onmicrosoft.com"
                    DisplayName        = "John Smith"
                    FirstName          = "John"
                    LastName           = "Smith"
                    UsageLocation      = "US"
                    LicenseAssignment  = @("ENTERPRISE_PREMIUM")
                    Password           = $GlobalAdminAccount
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName New-AzureADUser -MockWith {
                    return @{
                        UserPrincipalName = "JohnSmith@contoso.onmicrosoft.com"
                    }
                }

                Mock -CommandName Get-AzureADSubscribedSku -MockWith {
                    return @{
                        SkuPartNumber = "ENTERPRISE_PREMIUM"
                        SkuID = '12345-12345-12345-12345-12345'
                    }
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Absent"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should create the new User in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "When the user already exists" -Fixture {
            BeforeAll {
                $testParams = @{
                    UserPrincipalName  = "JohnSmith@contoso.onmicrosoft.com"
                    DisplayName        = "John Smith"
                    FirstName          = "John"
                    LastName           = "Smith"
                    UsageLocation      = "US"
                    LicenseAssignment  = @("ENTERPRISE_PREMIUM")
                    Password           = $GlobalAdminAccount
                    Ensure             = "Present"
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-AzureADUser -MockWith {
                    return @{
                        UserPrincipalName    = "JohnSmith@contoso.onmicrosoft.com"
                        DisplayName          = "John Smith"
                        GivenName            = "John"
                        Surname             = "Smith"
                        UsageLocation        = "US"
                        PasswordPolicies     = "NONE"
                        Ensure               = "Present"
                    }
                }

                Mock -CommandName Get-AzureADUserLicenseDetail -MockWith {
                    return @(@{
                        SkuPartNumber = 'ENTERPRISE_PREMIUM'
                    })
                }
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $True
            }
        }

        Context -Name "When the user already exists but has a different license assigned" -Fixture {
            BeforeAll {
                $testParams = @{
                    UserPrincipalName    = "JohnSmith@contoso.onmicrosoft.com"
                    DisplayName          = "John Smith"
                    FirstName            = "John"
                    LastName             = "Smith"
                    UsageLocation        = "US"
                    LicenseAssignment    = @()
                    Password             = $GlobalAdminAccount
                    PasswordNeverExpires = $false
                    Ensure               = "Present"
                    GlobalAdminAccount   = $GlobalAdminAccount
                }

                Mock -CommandName Get-AzureADUser -MockWith {
                    return @{
                        UserPrincipalName    = "JohnSmith@contoso.onmicrosoft.com"
                        DisplayName          = "John Smith"
                        GivenName            = "John"
                        Surname             = "Smith"
                        UsageLocation        = "US"
                        PasswordPolicies     = "NONE"
                        Ensure               = "Present"
                    }
                }

                Mock -CommandName Get-AzureADUserLicenseDetail -MockWith {
                    return @(@{
                        SkuPartNumber = 'ENTERPRISE_PREMIUM'
                    })
                }
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }

            It "Should remove the License Assignment in the Set Method" {
                Set-TargetResource @testParams
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-AzureADUser -MockWith {
                    return @{
                        UserPrincipalName    = "JohnSmith@contoso.onmicrosoft.com"
                        DisplayName          = "John Smith"
                        GivenName            = "John"
                        Surname              = "Smith"
                        UsageLocation        = "US"
                        PasswordPolicies     = "NONE"
                        Ensure               = "Present"
                    }
                }
                Mock -CommandName Get-M365DSCExportContentForResource -MockWith {
                    return "O365User Test{Password = `"`$test`"}"
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
