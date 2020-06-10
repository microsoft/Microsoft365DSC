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
    -DscResource "SPOTenantCDNPolicy" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "Pass@word1)" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {

        }

        Mock -CommandName Set-PnPTenantCDNPolicy -MockWith {

        }

        # Test contexts
        Context -Name "Update existing Public Policies" -Fixture {
            $testParams = @{
                CDNType                              = "Public"
                ExcludeRestrictedSiteClassifications = @('Sensitive')
                IncludeFileExtensions                = @('.gif')
                GlobalAdminAccount                   = $GlobalAdminAccount
            }

            Mock -CommandName Get-PnPTenantCDNPolicies -MockWith {
                return @{
                    CDNType                              = "Public"
                    ExcludeRestrictedSiteClassifications = @('Secured')
                    IncludeFileExtensions                = @('.php')
                }
            }

            It "Should return $false for the ExcludeIfNoScriptDisabled for the  from the Get method" {
                (Get-TargetResource @testParams).ExcludeRestrictedSiteClassifications | Should Be @('Secured')
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should update the policies from the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "Update existing Private Policies" -Fixture {
            $testParams = @{
                CDNType                              = "Private"
                ExcludeRestrictedSiteClassifications = @('Sensitive')
                IncludeFileExtensions                = @('.gif')
                GlobalAdminAccount                   = $GlobalAdminAccount
            }

            Mock -CommandName Get-PnPTenantCDNPolicies -MockWith {
                return @{
                    CDNType                              = "Private"
                    ExcludeIfNoScriptDisabled            = $false
                    ExcludeRestrictedSiteClassifications = @('Secured')
                    IncludeFileExtensions                = @('.php')
                }
            }

            It "Should return $false for the ExcludeIfNoScriptDisabled for the  from the Get method" {
                (Get-TargetResource @testParams).ExcludeRestrictedSiteClassifications | Should Be @('Secured')
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should update the policies from the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "Policies are already in the desired state" -Fixture {
            $testParams = @{
                CDNType                              = "Public"
                ExcludeRestrictedSiteClassifications = @('Secured')
                IncludeFileExtensions                = @('.php')
                GlobalAdminAccount                   = $GlobalAdminAccount
            }

            Mock -CommandName Get-PnPTenantCDNPolicies -MockWith {
                return @{
                    CDNType                              = "Public"
                    ExcludeIfNoScriptDisabled            = $false
                    ExcludeRestrictedSiteClassifications = @('Secured')
                    IncludeFileExtensions                = @('.php')
                }
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should Be $true
            }

            It "Should not update the policies from the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-PnPTenantCDNPolicies -MockWith {
                return @{
                    CDNType                              = "Public"
                    ExcludeIfNoScriptDisabled            = $false
                    ExcludeRestrictedSiteClassifications = @('Secured')
                    IncludeFileExtensions                = @('.php')
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }

    }
}


Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
