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
    -DscResource "SPOSiteAuditSettings" -GenericStubModule $GenericStubPath

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

            It "Should return the current resource from the Get method" {
                (Get-TargetResource @testParams).Url | Should Be "https://contoso.com/sites/fakesite"
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

            It "Should return the current resource from the Get method" {
                (Get-TargetResource @testParams).Url | Should Be "https://contoso.com/sites/fakesite"
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
