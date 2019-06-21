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
                                                -DscResource "SPOApp"

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-SPOServiceConnection -MockWith {

        }

        # Test contexts
        Context -Name "When the app doesn't already exist in the catalog" -Fixture {
            $testParams = @{
                Identity           = "MyTestApp"
                Path               = "C:\Test\MyTestApp.sppkg"
                CentralAdminUrl    = "https://contoso-admin.sharepoint.com"
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Present"
            }

            Mock -CommandName Get-PnPApp -MockWith {
                return $null
            }

            Mock -CommandName Add-PnPApp -MockWith {
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should add the App in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "The app already exists and it should" -Fixture {
            $testParams = @{
                Identity           = "MyTestApp"
                Path               = "C:\Test\MyTestApp.sppkg"
                CentralAdminUrl    = "https://contoso-admin.sharepoint.com"
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Present"
            }

            Mock -CommandName Get-PnPApp -MockWith {
                return @{
                    Title    = "MyTestApp"
                    Deployed = $true
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should Be $true
            }
        }

        Context -Name "The app already exists and it should not" -Fixture {
            $testParams = @{
                Identity           = "MyTestApp"
                Path               = "C:\Test\MyTestApp.sppkg"
                CentralAdminUrl    = "https://contoso-admin.sharepoint.com"
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Absent"
            }

            Mock -CommandName Get-PnPApp -MockWith {
                return @{
                    Identity = "MyTestApp"
                    Deployed = $true
                }
            }

            Mock -CommandName Remove-PnPApp -MockWith {
            }

            It "Should remove the app from the set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                Ident              = "MyTestApp"
                Path               = "C:\Test\MyTestApp.sppkg"
                CentralAdminUrl    = "https://contoso-admin.sharepoint.com"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-PnPApp -MockWith {
                return @{
                    Identity = "MyTestApp"
                    Deployed = $true
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
