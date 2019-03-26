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
                                              -DscResource "O365User"
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-O365ServiceConnection -MockWith {

        }

        Mock -CommandName Connect-ExchangeOnline -MockWith {

        }

        # Test contexts
        Context -Name "When the user doesn't already exist" -Fixture {
            $testParams = @{
                UserPrincipalName = "JohnSmith@contoso.onmicrosoft.com"
                DisplayName = "John Smith"
                FirstName = "John"
                LastName = "Smith"
                UsageLocation = "US"
                LicenseAssignment = @("CONTOSO:ENTERPRISE_PREMIUM")
                Password = $GlobalAdminAccount
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName New-MSOLUser -MockWith {
                return @{
                    UserPrincipalName = "JohnSmith@contoso.onmicrosoft.com"
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should be $false
            }

            It "Should create the new User in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "When the user already exists" -Fixture {
            $testParams = @{
                UserPrincipalName = "JohnSmith@contoso.onmicrosoft.com"
                DisplayName = "John Smith"
                FirstName = "John"
                LastName = "Smith"
                UsageLocation = "US"
                LicenseAssignment = @("CONTOSO:ENTERPRISE_PREMIUM")
                Password = $GlobalAdminAccount
                Ensure = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-MSOLUser -MockWith {
                return @{
                    UserPrincipalName = "JohnSmith@contoso.onmicrosoft.com"
                    DisplayName = "John Smith"
                    FirstName = "John"
                    LastName = "Smith"
                    UsageLocation = "US"
                    Licenses= @(@{
                        AccountSkuID = "CONTOSO:ENTERPRISE_PREMIUM"
                    })
                    PasswordNeverExpires = $False
                    Ensure = "Present"
                }
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should be $True
            }
        }

        Context -Name "When the user already exists but has a different license assigned" -Fixture {
            $testParams = @{
                UserPrincipalName = "JohnSmith@contoso.onmicrosoft.com"
                DisplayName = "John Smith"
                FirstName = "John"
                LastName = "Smith"
                UsageLocation = "US"
                LicenseAssignment = @()
                Password = $GlobalAdminAccount
                PasswordNeverExpires = $false
                Ensure = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-MSOLUser -MockWith {
                return @{
                    UserPrincipalName = "JohnSmith@contoso.onmicrosoft.com"
                    DisplayName = "John Smith"
                    FirstName = "John"
                    LastName = "Smith"
                    UsageLocation = "US"
                    Licenses = @(@{
                        AccountSkuID = "CONTOSO:ENTERPRISE_PREMIUM"
                    })
                    PasswordNeverExpires = $false
                    Ensure = "Present"
                }
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should remove the License Assignment in the Set Method" {
                Set-TargetResource @testParams
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should be $false
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                UserPrincipalName = "JohnSmith@contoso.onmicrosoft.com"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-MSOLUser -MockWith {
                return @{
                    UserPrincipalName = "JohnSmith@contoso.onmicrosoft.com"
                    DisplayName = "John Smith"
                    FirstName = "John"
                    LastName = "Smith"
                    UsageLocation = "US"
                    Licenses = @(@{
                        AccountSkuID = "CONTOSO:ENTERPRISE_PREMIUM"
                    })
                    PasswordNeverExpires = $false
                    Ensure = "Present"
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
