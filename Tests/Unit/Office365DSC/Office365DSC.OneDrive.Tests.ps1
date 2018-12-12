[CmdletBinding()]
param(
    [Parameter()]
    [string] 
    $CmdletModule = (Join-Path -Path $PSScriptRoot `
                                         -ChildPath "..\Stubs\Office365DSC.psm1" `
                                         -Resolve)
)

Import-Module -Name (Join-Path -Path $PSScriptRoot `
                                -ChildPath "..\UnitTestHelper.psm1" `
                                -Resolve)

$Global:DscHelper = New-O365DscUnitTestHelper -StubModule $CmdletModule `
                                                -DscResource "OneDrive"

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "Peruvian05)" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-SPOServiceConnection -MockWith {

        }

        # Test contexts 
        Context -Name "When the site doesn't already exist" -Fixture {
            $testParams = @{
                OneDriveStorageQuota = 1024
                CentralAdminUrl = "https://smaystate-admin.sharepoint.com"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Set-SPOTenant -MockWith { 
                return @{OneDriveStorageQuota = $null}
            }

            Mock -CommandName Get-SPOTenant -MockWith { 
                return $null
            }
            

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Creates the site collection in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "Set OneDrive Quota" -Fixture {
            $testParams = @{
                OneDriveStorageQuota = 1024
                CentralAdminUrl = "https://smaystate-admin.sharepoint.com"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-SPOTenant -MockWith { 
                return @{
                    OneDriveStorageQuota = "1024"
                }
            }
           

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should Be $true
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                OneDriveStorageQuota = 1024
                CentralAdminUrl = "https://smaystate-admin.sharepoint.com"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-SPOTenant -MockWith { 
                return @{
                    OneDriveStorageQuota = "1024"
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
