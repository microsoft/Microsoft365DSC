[CmdletBinding()]
param(
    [Parameter()]
    [string]
    $CmdletModule = (Join-Path -Path $PSScriptRoot `
            -ChildPath "..\Stubs\Microsoft365.psm1" `
            -Resolve)
)
$GenericStubPath = (Join-Path -Path $PSScriptRoot `
    -ChildPath "..\Stubs\Generic.psm1" `
    -Resolve)
Import-Module -Name (Join-Path -Path $PSScriptRoot `
        -ChildPath "..\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "O365User" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {

        }

        Mock -CommandName Set-AzureADUser -MockWith {
        }

        Mock -CommandName Set-AzureADUserLicense -MockWith {
        }

        Mock -CommandName Set-AzureADUserPassword -MockWith {
        }
        # Test contexts
        Context -Name "When the user doesn't already exist" -Fixture {
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

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should be $True
            }
        }

        Context -Name "When the user already exists but has a different license assigned" -Fixture {
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

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
