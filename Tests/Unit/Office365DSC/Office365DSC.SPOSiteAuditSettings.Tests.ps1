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
    -DscResource "SPOSiteAuditSettings"

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "Pass@word1)" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {

        }

        Mock -CommandName Set-PnPAuditing -MockWith {

        }

        # Test contexts
        Context -Name "Set SPOSiteAuditSettings to All" -Fixture {
            $testParams = @{
                Url                = "https://contoso.com/sites/fakesite"
                AuditFlags         = "All"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-PnPAuditing -MockWith {
                return @{
                    AuditFlags = "None"
                }
            }

            Mock -CommandName Get-PnPTenantSite -MockWith {
                return @{
                    Url = "https://contoso.com/sites/fakesite"
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should set settings from the Set method" {
                Set-TargetResource @testParams
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }
        }

        Context -Name "Set SPOSiteAuditSettings to None" -Fixture {
            $testParams = @{
                Url                = "https://contoso.com/sites/fakesite"
                AuditFlags         = "None"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-PnPAuditing -MockWith {
                return @{
                    AuditFlags = "All"
                }
            }

            Mock -CommandName Get-PnPTenantSite -MockWith {
                return @{
                    Url = "https://contoso.com/sites/fakesite"
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should set settings from the Set method" {
                Set-TargetResource @testParams
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-PnPAuditing -MockWith {
                return @{
                    AuditFlags = "None"
                }
            }

            Mock -CommandName Get-PnPTenantSite -MockWith {
                return @{
                    Url = "https://contoso.com/sites/fakesite"
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }

    }
}


Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
