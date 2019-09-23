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
    -DscResource "SPOUserProfileProperty"

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {

        }

        Mock -CommandName Set-PnPUserProfileProperty -MockWith {
            return @{
            }
        }

        # Test contexts
        Context -Name "Properties are already set" -Fixture {
            $testParams = @{
                UserName           = "john.smith@contoso.com"
                Properties         = (New-CimInstance -ClassName MSFT_SPOUserProfileProperty -Property @{
                    Key   = "MyKey"
                    Value = "MyValue"
                } -ClientOnly)
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Present"
            }

            Mock -CommandName Get-PnPUserProfileProperty -MockWith {
                return @{
                    AccountName           = "john.smith@contoso.com"
                    UserProfileProperties = @{"MyKey"="MyValue";}
                }
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should Be $true
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be 'Present'
            }
        }

        Context -Name "Properties need to be set" -Fixture {
            $testParams = @{
                UserName           = "john.smith@contoso.com"
                Properties         = (New-CimInstance -ClassName MSFT_SPOUserProfileProperty -Property @{
                    Key   = "MyNewKey"
                    Value = "MyValue"
                } -ClientOnly)
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Present"
            }

            Mock -CommandName Get-PnPUserProfileProperty -MockWith {
                return @{
                    AccountName           = "john.smith@contoso.com"
                    UserProfileProperties = @{"MyOldKey"="MyValue";}
                }
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should Update the settings from the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-PnPUserProfileProperty -MockWith {
                return @{
                    AccountName           = "john.smith@contoso.com"
                    UserProfileProperties = @{"MyOldKey"="MyValue";}
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }#inmodulescope
}#describe

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
