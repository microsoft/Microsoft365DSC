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
    -DscResource "SPOSiteDesign" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "Pass@word1)" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {

        }
        # Test contexts
        Context -Name "Check Site Design " -Fixture {
            $testParams = @{
                Title               = "DSC Site Design"
                SiteScriptNames     = @("Cust List", "List_Views")
                WebTemplate         = "TeamSite"
                IsDefault           = $false
                Description         = "Created by DSC"
                PreviewImageAltText = "Office 365"
                PreviewImageUrl     = ""
                Ensure              = "Present"
                GlobalAdminAccount  = $GlobalAdminAccount
            }


            Mock -CommandName Get-PnPSiteScript -MockWith {
                return @(
                    @{
                        Id    = "12345678-1234-1234-1234-123456789012"
                        Title = "Cust List"
                    },
                    @{
                        Id    = "12345678-1234-1234-1234-123456789011"
                        Title = "List_Views"
                    }
                )
            }

            Mock -CommandName Get-PnPSiteDesign -MockWith {
                return $null
            }

            Mock -CommandName Add-PnPSiteDesign -MockWith {
                return $null
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Adds the site design in the Set method" {
                Set-TargetResource @testParams
            }

        }

        Context -Name "Check existing Site Design " -Fixture {
            $testParams = @{
                Title               = "DSC Site Design"
                SiteScriptNames     = "Cust List"
                WebTemplate         = "TeamSite"
                Description         = "Created by DSC"
                PreviewImageAltText = "Office 365"
                Ensure              = "Present"
                GlobalAdminAccount  = $GlobalAdminAccount
            }


            Mock -CommandName Get-PnPSiteDesign -MockWith {
                return @{
                    Title               = "DSC Site Design"
                    Id                  = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
                    SiteScriptNames     = "Cust List"
                    WebTemplate         = "TeamSite"
                    Description         = "Updated by DSC"
                    PreviewImageAltText = "Office"
                }
            }

            Mock -CommandName Set-PnPSiteDesign -MockWith {
                return $null
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Updates the site design in the Set method" {
                Set-TargetResource @testParams
            }

        }


        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-PnPSiteDesign -MockWith {
                return @{
                    Title = "DSC Site Design"
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }

    }
}


Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
