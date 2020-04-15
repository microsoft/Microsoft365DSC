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
    -DscResource "SPOSiteDesignRights" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "Pass@word1)" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {

        }
        # Test contexts
        Context -Name "Check Site Design Rights" -Fixture {
            $testParams = @{
                SiteDesignTitle    = "Customer List"
                UserPrincipals     = "jdoe@dsazure.com"
                Rights             = "View"
                Ensure             = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Grant-PnPSiteDesignRights -MockWith {
                return @{
                    UserPrincipals = $null
                    Rights         = $null
                    Identity       = $null
                }
            }

            Mock -CommandName Get-PnPSiteDesign -MockWith {
                return @{
                    SiteDesignTitle = "Customer List"
                    Id              = "12345-12345-12345-12345-12345"
                }
            }

            Mock -CommandName Get-PnPSiteDesignRights -MockWith {
                return $null
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }


        }

        Context -Name "Check existing Site Design rights" -Fixture {
            $testParams = @{
                SiteDesignTitle    = "Customer List"
                UserPrincipals     = "jdoe@dsazure.com"
                Rights             = "View"
                Ensure             = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-PnPSiteDesign -MockWith {
                return @{
                    Id = "12345-12345-12345-12345-12345"
                }
            }

            Mock -CommandName Get-PnPSiteDesignRights -MockWith {
                return @{
                    PrincipalName = "i:0#.f|membership|jdoe@dsazure.com"
                    Rights        = "View"
                }
            }

            mock -CommandName Grant-PnPSiteDesignRights -MockWith {
                return $null
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should Be $true
            }

            It "Updates the Team fun settings in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "Adding new user Site Design rights" -Fixture {
            $testParams = @{
                SiteDesignTitle    = "Customer List"
                UserPrincipals     = "jdoe@dsazure.com", "dsmay@dsazure.com"
                Rights             = "View"
                Ensure             = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-PnPSiteDesign -MockWith {
                return @{
                    Id = "12345-12345-12345-12345-12345"
                }
            }

            Mock -CommandName Get-PnPSiteDesignRights -MockWith {
                return @{
                    PrincipalName = "i:0#.f|membership|jdoe@dsazure.com"
                    Rights        = "View"
                }
            }

            Mock -CommandName Grant-PnPSiteDesignRights -MockWith {
                return $null
            }

            Mock -CommandName Revoke-PnPSiteDesignRights -MockWith {
                return $null
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Updates the user design rights in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "Removing a user Site Design rights" -Fixture {
            $testParams = @{
                SiteDesignTitle    = "Customer List"
                UserPrincipals     = "dsmay@dsazure.com"
                Rights             = "View"
                Ensure             = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-PnPSiteDesign -MockWith {
                return @{
                    Id = "12345-12345-12345-12345-12345"
                }
            }

            Mock -CommandName Get-PnPSiteDesignRights -MockWith {
                return @{
                    PrincipalName = "i:0#.f|membership|jdoe@dsazure.com"
                    Rights        = "View"
                }
            }

            Mock -CommandName Grant-PnPSiteDesignRights -MockWith {
                return $null
            }

            Mock -CommandName Revoke-PnPSiteDesignRights -MockWith {
                return $null
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Updates the user design rights in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-PnPSiteDesign -MockWith {
                return @{
                    Title = "Customer List"
                    Id    = "12345-12345-12345-12345-12345"
                }
            }

            Mock -CommandName Get-PnPSiteDesignRights -MockWith {
                return @{
                    PrincipalName = "i:0#.f|membership|john.smith@contoso.com"
                    Rights        = "View"
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }

    }
}


Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
