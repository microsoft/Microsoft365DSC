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
    -DscResource "TeamsChannel"

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "Pass@word1)" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-TeamsServiceConnection -MockWith {
        }

        # Test contexts 
        Context -Name "When a channel doesnt exist" -Fixture {
            $testParams = @{
                GroupID            = "12345-12345-12345-12345-12345"
                DisplayName        = "Test Channel"
                Description        = "Test description"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-TeamChannel -MockWith { 
                return $null
            }

            Mock -CommandName New-TeamChannel -MockWith { 
                return @{GroupID = $null
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent" 
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Creates the MS Team channel in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "Channel already exists" -Fixture {
            $testParams = @{
                GroupID            = "12345-12345-12345-12345-12345"
                DisplayName        = "Test Channel"
                NewDisplayName     = "Test Channel 1"
                Description        = "Test description"
                Ensure = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-TeamChannel -MockWith { 
                return @{
                    GroupID            = "12345-12345-12345-12345-12345"
                    DisplayName        = "Test Channel"
                    NewDisplayName     = "Test Channel 1"
                    Description        = "Test description"
                    Ensure = "Present"
                }
            }   

            Mock -CommandName Set-TeamChannel -MockWith{

            }
                     
            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present" 
            }
            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }
            It "Set the MS Team channel in the Set method" {
                Set-TargetResource @testParams | Should be $true 
            }
        }
        

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                GroupID            = "12345-12345-12345-12345-12345"
                DisplayName        = "Test Channel"
                Description        = "Test description"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-TeamChannel -MockWith { 
                return @{
                    DisplayName = "Test Channel"
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
