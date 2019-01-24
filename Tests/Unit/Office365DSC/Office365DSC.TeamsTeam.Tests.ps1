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
    -DscResource "TeamsTeam"

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "Pass@word1)" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-TeamsServiceConnection -MockWith {
        }

        # Test contexts 
        Context -Name "When the Team doesnt exist" -Fixture {
            $testParams = @{
                DisplayName        = "Test Team"
                Alias              = "TestTeam"
                Description        = "Test team description"
                AccessType         = "Private"
                Ensure             = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName New-Team -MockWith { 
                return @{DisplayName = $null}
            }

            Mock -CommandName Get-Team -MockWith { 
                return $null
            }
            
            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent" 
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Creates the MS Team in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "The Team already exists" -Fixture {
            $testParams = @{
                DisplayName        = "Test Team"
                Description        = "Test team description"
                Alias              = "TestTeam"
                AccessType         = "Private"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-Team -MockWith { 
                return @{
                    DisplayName = "Test Team"
                    Ensure      = "Present"
                }
            }
            
            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present" 
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should Be $true
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                DisplayName        = "Test Team"
                Description        = "Test team description"
                AccessType         = "Private"
                Alias              = "TestTeam"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-Team -MockWith { 
                return @{
                    DisplayName = "Test Team"
                    Ensure      = "Present"
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
