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
    -DscResource "SPOSharingSettings"

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-SPOServiceConnection -MockWith {

        }

        # Test contexts 
        Context -Name "SPOSharing settings are not configured" -Fixture {
            $testParams = @{
                IsSingleInstance   = "Yes"
                SharingCapability  = "Disabled"
                CentralAdminUrl    = "https://o365dsc1-admin.sharepoint.com"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Set-SPOTenant -MockWith { 
                return @{IsSingleInstance = "Yes"
                    SharingCapability = 'Disabled'
                }
            }

            Mock -CommandName Get-SPOTenant -MockWith { 
                return @{IsSingleInstance = "Yes"
                    SharingCapability = 'ExternalUserSharingOnly'
                }
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Sets the tenant sharing settings in Set method" {
                set-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope