[CmdletBinding()]
param(
    [Parameter()]
    [string]
    $CmdletModule = (Join-Path -Path $PSScriptRoot `
            -ChildPath "..\Stubs\Office365.psm1" `
            -Resolve)
)
$GenericStubPath = (Join-Path -Path $PSScriptRoot `
    -ChildPath "..\Stubs\Generic.psm1" `
    -Resolve)
Import-Module -Name (Join-Path -Path $PSScriptRoot `
        -ChildPath "..\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-O365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "SPOStorageEntity" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "Pass@word1)" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {

        }

        Mock -CommandName Get-SPOAdminUrl -MockWith {
            return 'https://contoso-admin.sharepoint.com'
        }

        # Test contexts
        Context -Name "Check SPOStorageEntity" -Fixture {
            $testParams = @{
                Key                = "DSCKey"
                Value              = "Test storage entity"
                EntityScope        = "Site"
                Description        = "Description created by DSC"
                Comment            = "Comment from DSC"
                Ensure             = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
                SiteUrl            = "https://contoso-admin.sharepoint.com"
            }

            Mock -CommandName Get-PnPStorageEntity -MockWith {
                return $null
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }


        }

        Context -Name "Check existing Storage Entity" -Fixture {
            $testParams = @{
                Key                = "DSCKey"
                Value              = "Test storage entity"
                EntityScope        = "Site"
                Description        = "Description created by DSC"
                Comment            = "Comment from DSC"
                Ensure             = "Present"
                SiteUrl            = "https://contoso-admin.sharepoint.com"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-PnPStorageEntity -MockWith {
                return @{
                    Key         = "DSCKey"
                    Value       = "Test storage entity"
                    EntityScope = "Site"
                    Description = "Description created by DSC"
                    Comment     = "Comment from DSC"
                }
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should Be $true
            }
        }

        Context -Name "Adding storage entity" -Fixture {
            $testParams = @{
                Key                = "DSCKey"
                Value              = "Test storage entity"
                EntityScope        = "Site"
                Description        = "Description created by DSC"
                Comment            = "Comment from DSC"
                Ensure             = "Present"
                SiteUrl            = "https://contoso-admin.sharepoint.com"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-PnPStorageEntity -MockWith {
                return @{
                    Key         = "DSCKey"
                    Value       = "Updated test storage entity"
                    EntityScope = "Site"
                    Description = "Description created by DSC"
                    Comment     = "Comment from DSC"
                }
            }

            Mock -CommandName Set-PnPStorageEntity -MockWith {
                return @{
                    Key         = "DSCKey"
                    Value       = "Updated test storage entity"
                    EntityScope = "Site"
                    Description = "Updated description created by DSC"
                    Comment     = "Comment from DSC"
                }
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Updates storage entity in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "Removing a storage entity" -Fixture {
            $testParams = @{
                Key                = "DSCKey"
                Value              = "Test storage entity"
                EntityScope        = "Site"
                Description        = "Description created by DSC"
                Comment            = "Comment from DSC"
                Ensure             = "Absent"
                SiteUrl            = "https://contoso-admin.sharepoint.com"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-PnPStorageEntity -MockWith {
                return @{
                    Key         = "DSCKey"
                    Value       = "Test storage entity"
                    EntityScope = "Site"
                    Description = "Description created by DSC"
                    Comment     = "Comment from DSC"
                }
            }

            Mock -CommandName Remove-PnPStorageEntity -MockWith {
                return $null
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Remove storage entity in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-PnPStorageEntity -MockWith {
                return @{
                    Key                = "DSCKey"
                    Value              = "Test storage entity"
                    EntityScope        = "Site"
                    Description        = "Description created by DSC"
                    Comment            = "Comment from DSC"
                    Ensure             = "Present"
                    SiteUrl            = "https://contoso-admin.sharepoint.com"
                    GlobalAdminAccount = $GlobalAdminAccount
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }

    }
}


Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
