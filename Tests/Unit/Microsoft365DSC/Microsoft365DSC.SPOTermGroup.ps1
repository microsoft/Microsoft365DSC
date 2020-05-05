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
    -DscResource "SPOTermGroup" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-MSCloudLogin -MockWith {

        }

        # Test contexts
        Context -Name "The term group doesn't exist" -Fixture {
            $testParams = @{
                Identity           = "TestGroup"
                Description        = "Description of TestGroup"
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Absent"
            }

            Mock -CommandName New-PnPTermGroup -MockWith {
                return @{
                    Name = $null
                }
            }

            Mock -CommandName Get-PnPTermGroup -MockWith {
                return $null
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }
            It "Creates the term group in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "The term group already exists" -Fixture {
            $testParams = @{
                Identity           = "TestGroup"
                Description        = "Description of TestGroup"
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Present"
            }

            Mock -CommandName Get-PnPTermGroup -MockWith {
                return @{
                    Name           = "TestGroup"
                }
            }

            It "Should add the new term group from the Set method" {
                Set-TargetResource @testParams
            }

            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present"
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }
        }

        Context -Name "Testing term group removal" -Fixture {
            $testParams = @{
                Identity           = "TestGroup"
                Description        = "Description of TestGroup"
                GlobalAdminAccount = $GlobalAdminAccount
                Ensure             = "Present"
            }

            Mock -CommandName Get-PnPTermGroup -MockWith {
                return @{
                    Name           = "TestGroup"
                }
            }

            Mock -CommandName Remove-PnPTermGroup -MockWith {
                return "The term group has been successfully removed"
            }

            It "Should remove the term group successfully" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-PnPTermGroup -MockWith {
                return @{
                    Identity            = "TestGroup"
                    Description         = "Description of TestGroup"
                    GlobalAdminAccount  = $GlobalAdminAccount
                    Ensure              = "Present"
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
