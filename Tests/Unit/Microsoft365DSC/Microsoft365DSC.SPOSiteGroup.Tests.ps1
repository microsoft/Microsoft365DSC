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
    -DscResource "SPOSiteGroup" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "Pass@word1)" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {

        }
        # Test contexts
        Context -Name "SiteGroup does not exist " -Fixture {
            $testParams = @{
                URL                 = "https://contoso.sharepoint.com/sites/TestSite"
                Identity            = "TestSiteGroup"
                Owner               = "admin@Office365DSC.onmicrosoft.com"
                PermissionLevels    = @("Edit", "Read")
                Ensure              = "Present"
                GlobalAdminAccount  = $GlobalAdminAccount
            }

            Mock -CommandName Get-PnPTenantSite -MockWith{
                return $null
            }

            Mock -CommandName Get-PnPGroup -MockWith {
                return $null
            }

            Mock -CommandName Get-PnPGroup -MockWith {
                return $null
            }

            Mock -CommandName Set-PnPGroup -MockWith {
                return $null
            }

            Mock -CommandName New-PnPGroup -MockWith {
                return $null
            }

            Mock -CommandName Remove-PnPGroup -MockWith {
                return $null
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Adds the SPOSiteGroup in the Set method" {
                Set-TargetResource @testParams
            }

        }

        Context -Name "SiteGroup exists but is not in the desired state (PermissionLevel missing)" -Fixture {
            $testParams = @{
                URL                 = "https://contoso.sharepoint.com/sites/TestSite"
                Identity            = "TestSiteGroup"
                Owner               = "admin@Office365DSC.onmicrosoft.com"
                PermissionLevels    = @("Edit", "Read")
                Ensure              = "Present"
                GlobalAdminAccount  = $GlobalAdminAccount
            }

            Mock -CommandName Get-PnPTenantSite -MockWith {
                return @{
                    Url = 'https://contoso.sharepoint.com/sites/TestSite'
                }
            }

            Mock -CommandName Get-PnPGroup -MockWith {
                return @{
                    URL              = "https://contoso.sharepoint.com/sites/TestSite"
                    Title            = "TestSiteGroup"
                    Owner            = @{
                        LoginName = "admin@Office365DSC.onmicrosoft.com"
                    }
                }
            }

            Mock -CommandName Get-PnPGroupPermissions -MockWith {
                return @{
                    Name = 'Contribute'
                }
            }

            Mock -CommandName Set-PnPGroup -MockWith {
            }

            Mock -CommandName New-PnPGroup -MockWith {
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Updates the site group in the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName Set-PnPGroup -Exactly 1
                Assert-MockCalled -CommandName New-PnPGroup -Exactly 0
            }

        }

        Context -Name "SiteGroup exists and is in the desired state " -Fixture {
            $testParams = @{
                URL                 = "https://contoso.sharepoint.com/sites/TestSite"
                Identity            = "TestSiteGroup"
                Owner               = "admin@Office365DSC.onmicrosoft.com"
                PermissionLevels    = @("Edit", "Read")
                Ensure              = "Present"
                GlobalAdminAccount  = $GlobalAdminAccount
            }

            Mock -CommandName Get-PnPGroup -MockWith {
                return @{
                    URL                 = "https://contoso.sharepoint.com/sites/TestSite"
                    Title               = "TestSiteGroup"
                    Owner               = @{
                        LoginName      = "admin@Office365DSC.onmicrosoft.com"
                    }
                }
            }

            Mock -CommandName Get-PnPGroupPermissions -MockWith {
                return @(@{
                    Name = 'Edit'
                },
                @{
                    Name = 'Read'
                }
                )
            }

            Mock -CommandName Set-PnPGroup -MockWith {
            }

            Mock -CommandName New-PnPGroup -MockWith {
            }

            Mock -CommandName Remove-PnPGroup -MockWith {
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should Be $true
            }

            It "Should not update site group in the Set method" {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName New-PnPGroup -Exactly 0
                Assert-MockCalled -CommandName Remove-PnPGroup -Exactly 0
            }
        }

        Context -Name "SiteGroup exists but should not exist" -Fixture {
            $testParams = @{
                URL                 = "https://contoso.sharepoint.com/sites/TestSite"
                Identity            = "TestSiteGroup"
                Owner               = "admin@Office365DSC.onmicrosoft.com"
                PermissionLevels    = @("Edit", "Read")
                Ensure              = "Absent"
                GlobalAdminAccount  = $GlobalAdminAccount
            }


            Mock -CommandName Get-PnPGroup -MockWith {
                return @{
                    URL              = "https://contoso.sharepoint.com/sites/TestSite"
                    Title            = "TestSiteGroup"
                    OwnerLogin       = "admin@Office365DSC.onmicrosoft.com"
                    Roles            = @("Edit", "Read")
                }
            }

            Mock -CommandName Get-PnPGroupPermissions -MockWith {
                return @(@{
                    Name = 'Edit'
                },
                @{
                    Name = 'Read'
                }
                )
            }

            Mock -CommandName Set-PnPGroup -MockWith{
            }

            Mock -CommandName New-PnPGroup -MockWith{
            }

            Mock -CommandName Remove-PnPGroup -MockWith{
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should remove the site group" {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName Set-PnPGroup -Exactly 0
                Assert-MockCalled -CommandName New-PnPGroup -Exactly 0
                Assert-MockCalled -CommandName Remove-PnPGroup -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-PnPTenantSite -MockWith {
                return @{
                    Url = "https://contoso.sharepoint.com"
                }
            }

            Mock -CommandName Get-PnPGroup -MockWith {
                return @{
                    URL                 = "https://contoso.sharepoint.com/sites/TestSite"
                    Title               = "TestSiteGroup"
                    OwnerLogin          = "admin@Office365DSC.onmicrosoft.com"
                    Roles               = @("Edit", "Read")
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
