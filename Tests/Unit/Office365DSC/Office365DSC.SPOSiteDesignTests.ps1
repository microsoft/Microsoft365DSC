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
    -DscResource "SPOSiteDesign"

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "Pass@word1)" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-PnPOnlineConnection -MockWith {

        }
        # Test contexts
        Context -Name "Check Site Design " -Fixture {
            $testParams = @{
                Title               = "DSC Site Design"
                SiteScriptNames     = "Cust List", "List_Views"
                WebTemplate         = "TeamSite"
                isDefault           = $false
                Description         = "Created by DSC"
                PreviewImageAltText = "Office 365"
                PreviewImageUrl     = ""
                Ensure              = "Present"
                GlobalAdminAccount  = $GlobalAdminAccount
                CentralAdminUrl     = "https://contoso-admin.sharepoint.com"
            }


            Mock -CommandName Get-PnPSiteScript -MockWith {
                return @{
                    SiteDesignTitle = "Cust List", "List_Views"
                    Id              = "12345-12345-12345-12345-12345"
                }
            }

            Mock -CommandName Get-PnPSiteDesign -MockWith {
                return $null
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }


        }

        Context -Name "Check existing Site Design " -Fixture {
            $testParams = @{
                Title               = "DSC Site Design"
                SiteScriptNames     = "Cust List", "List_Views"
                WebTemplate         = "TeamSite"
                isDefault           = $false
                Description         = "Created by DSC"
                PreviewImageAltText = "Office 365"
                PreviewImageUrl     = ""
                Ensure              = "Present"
                GlobalAdminAccount  = $GlobalAdminAccount
                CentralAdminUrl     = "https://contoso-admin.sharepoint.com"
            }

            Mock -CommandName Get-PnPSiteDesign -MockWith {
                return @{
                    Title = "DSC Site Design"
                    Id              = "12345-12345-12345-12345-12345"
                }
            }

            Mock -CommandName Get-PnPSiteScript -MockWith {
                return @{
                    SiteScriptNames = "Cust List", "List_Views"
                }
            }


            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should Be $true
            }

            It "Updates the site design in the Set method" {
                Set-TargetResource @testParams
            }
        }


        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                Title               = "DSC Site Design"
                SiteScriptNames     = "Cust List", "List_Views"
                WebTemplate         = "TeamSite"
                isDefault           = $false
                Description         = "Created by DSC"
                PreviewImageAltText = "Office 365"
                PreviewImageUrl     = ""
                Ensure              = "Present"
                GlobalAdminAccount  = $GlobalAdminAccount
                CentralAdminUrl     = "https://contoso-admin.sharepoint.com"
            }

            Mock -CommandName Get-PnPSiteScript -MockWith {
                return @{
                    SiteDesignTitle = "Cust List", "List_Views"
                    SiteScriptIds             = "12345-12345-12345-12345-12345","22345-12345-12345-12345-12345"
                }
            }

            Mock -CommandName Get-PnPSiteDesign -MockWith {
                return $null
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }

    }
}


Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
