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
    -DscResource "SPOUserProfileProperty" -GenericStubModule $GenericStubPath

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

        Mock -CommandName Invoke-M365DSCCommand -MockWith {
        }

        Mock -CommandName Start-Job -MockWith{
        }

        Mock -CommandName Get-Job -MockWith{
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
                    UserProfileProperties = @{'MyOldKey' = 'MyValue' }
                }
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
                    UserProfileProperties = @{'MyOldKey' = 'MyValue' }
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
                    UserProfileProperties = @{MyOldKey = MyValue }
                }
            }

            Mock -CommandName Get-AzureADUser -MockWith {
                return @{
                    UserPrincipalName = "john.smith@contoso.com"
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }#inmodulescope
}#describe

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
