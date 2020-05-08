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
    -DscResource "SPOHomeSite" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith { }

        # Test contexts
        Context -Name "When there should be no home site set" -Fixture {
            $testParams = @{
                IsSingleInstance   = "Yes"
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Absent"
            }

            Mock -CommandName Get-PnPHomeSite -MockWith {
                return $null
            }

            It "Should return Absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should Be $true
            }
        }

        Context -Name "When there is a home site and there should not be" -Fixture {
            $testParams = @{
                IsSingleInstance   = "Yes"
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Absent"
            }

            Mock -CommandName Get-PnPHomeSite -MockWith {
                return "https://contoso.sharepoint.com/sites/homesite"
            }

            Mock -CommandName Remove-PnPHomeSite -MockWith {

            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should call Remove-PnPHomeSite" {
                Set-TargetResource @testParams
                Assert-MockCalled  Remove-PnPHomeSite
            }
        }

        Context -Name "When there should be a home site set and there is not or it's the wrong one" -Fixture {
            $testParams = @{
                IsSingleInstance   = "Yes"
                Url                = "https://contoso.sharepoint.com/sites/homesite"
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Present"
            }

            Mock -CommandName Get-PnPHomeSite -MockWith {
                return "https://contoso.sharepoint.com/sites/wrong"
            }

            Mock -CommandName Get-PnPTenantSite -MockWith {
                throw
            }

            Mock -CommandName Set-PnPHomeSite -MockWith {
            }


            Mock -CommandName New-M365DSCLogEntry -MockWith {
            }


            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should throw an error" {
                { Set-TargetResource @testParams } | Should Throw "The specified Site Collection $($testParams.Url) for SPOHomeSite doesn't exist."
                Assert-MockCalled Get-PnPTenantSite
                Assert-MockCalled New-M365DSCLogEntry
            }
        }

        Context -Name "It should set the home site" -Fixture {
            $testParams = @{
                IsSingleInstance   = "Yes"
                Url                = "https://contoso.sharepoint.com/sites/homesite"
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Present"
            }

            Mock -CommandName Get-PnPHomeSite -MockWith {
                return "https://contoso.sharepoint.com/sites/homesite1"
            }

            Mock -CommandName Set-PnPHomeSite -MockWith {
            }

            Mock -CommandName Get-PnPTenantSite -MockWith {

            }

            It "Should set the correct site" {
                Set-TargetResource @testParams
                Assert-MockCalled Get-PnPTenantSite
                Assert-MockCalled Set-PnPHomeSite
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-PnPHomeSite -MockWith {
                return "https://contoso.sharepoint.com/sites/TestSite"
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
