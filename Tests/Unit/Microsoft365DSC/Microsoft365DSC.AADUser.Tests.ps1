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
    -DscResource 'AADUSer' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'test@password1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin', $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {
            }

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Update-MgUser -MockWith {
            }

            Mock -CommandName Update-MgUserLicenseDetail -MockWith {
            }

            Mock -CommandName Get-MgRoleManagementDirectoryRoleAssignment -MockWith {
                return @()
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name "When the user doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    UserPrincipalName = 'JohnSmith@contoso.onmicrosoft.com'
                    DisplayName       = 'John Smith'
                    FirstName         = 'John'
                    LastName          = 'Smith'
                    UsageLocation     = 'US'
                    LicenseAssignment = @('ENTERPRISE_PREMIUM')
                    Password          = $Credential
                    Credential        = $Credential
                }

                Mock -CommandName New-MgUser -MockWith {
                    return @{
                        UserPrincipalName = 'JohnSmith@contoso.onmicrosoft.com'
                    }
                }

                Mock -CommandName Get-MgSubscribedSku -MockWith {
                    return @{
                        SkuPartNumber = 'ENTERPRISE_PREMIUM'
                        SkuID         = '12345-12345-12345-12345-12345'
                    }
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create the new User in the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'When the user already exists' -Fixture {
            BeforeAll {
                $testParams = @{
                    UserPrincipalName = 'JohnSmith@contoso.onmicrosoft.com'
                    DisplayName       = 'John Smith'
                    FirstName         = 'John'
                    LastName          = 'Smith'
                    UsageLocation     = 'US'
                    LicenseAssignment = @('ENTERPRISE_PREMIUM')
                    Password          = $Credential
                    Ensure            = 'Present'
                    Credential        = $Credential
                }

                Mock -CommandName Get-MgUser -MockWith {
                    return @{
                        UserPrincipalName = 'JohnSmith@contoso.onmicrosoft.com'
                        DisplayName       = 'John Smith'
                        GivenName         = 'John'
                        Surname           = 'Smith'
                        UsageLocation     = 'US'
                        PasswordPolicies  = 'NONE'
                        Ensure            = 'Present'
                    }
                }

                Mock -CommandName Get-MgUserLicenseDetail -MockWith {
                    return @(@{
                            SkuPartNumber = 'ENTERPRISE_PREMIUM'
                        })
                }

                Mock -CommandName Get-MgSubscribedSku -MockWith {
                    return @{
                        SkuPartNumber = 'ENTERPRISE_PREMIUM'
                        SkuID         = '12345-12345-12345-12345-12345'
                    }
                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $True
            }
        }

        Context -Name 'When the user already exists but has a different license assigned' -Fixture {
            BeforeAll {
                $testParams = @{
                    UserPrincipalName    = 'JohnSmith@contoso.onmicrosoft.com'
                    DisplayName          = 'John Smith'
                    FirstName            = 'John'
                    LastName             = 'Smith'
                    UsageLocation        = 'US'
                    LicenseAssignment    = @()
                    Password             = $Credential
                    PasswordNeverExpires = $false
                    Ensure               = 'Present'
                    Credential           = $Credential
                }

                Mock -CommandName Get-MgUser -MockWith {
                    return @{
                        UserPrincipalName = 'JohnSmith@contoso.onmicrosoft.com'
                        DisplayName       = 'John Smith'
                        GivenName         = 'John'
                        Surname           = 'Smith'
                        UsageLocation     = 'US'
                        PasswordPolicies  = 'NONE'
                        Ensure            = 'Present'
                    }
                }

                Mock -CommandName Get-MgUserLicenseDetail -MockWith {
                    return @(@{
                            SkuPartNumber = 'ENTERPRISE_PREMIUM'
                        })
                }

                Mock -CommandName Get-MgSubscribedSku -MockWith {
                    return @{
                        SkuPartNumber = 'ENTERPRISE_PREMIUM'
                        SkuID         = '12345-12345-12345-12345-12345'
                    }
                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should remove the License Assignment in the Set Method' {
                Set-TargetResource @testParams
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgUser -MockWith {
                    return @{
                        UserPrincipalName = 'JohnSmith@contoso.onmicrosoft.com'
                        DisplayName       = 'John Smith'
                        GivenName         = 'John'
                        Surname           = 'Smith'
                        UsageLocation     = 'US'
                        PasswordPolicies  = 'NONE'
                        Ensure            = 'Present'
                    }
                }
                Mock -CommandName Get-M365DSCExportContentForResource -MockWith {
                    return "AADUSer Test{Password = `"`$test`"}"
                }

                Mock -CommandName Get-MgSubscribedSku -MockWith {
                    return @{
                        SkuPartNumber = 'ENTERPRISE_PREMIUM'
                        SkuID         = '12345-12345-12345-12345-12345'
                    }
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
