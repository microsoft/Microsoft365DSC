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

        Mock Invoke-ExoCommand {
            return Invoke-Command -ScriptBlock $ScriptBlock -ArgumentList $Arguments -NoNewScope
        }

        # Test contexts 
        Context -Name "When the Team doesnt exist" -Fixture {
            $testParams = @{
                DisplayName        = "TestTeam"
                Ensure             = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-Team -MockWith { 
                return $null
            }
            
            Mock -CommandName New-Team -MockWith {
                return @{DisplayName = "TestTeam"}
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent" 
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Updates the Team fun settings in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "The Team already exists" -Fixture {
            $testParams = @{
                DisplayName        = "TestTeam"
                Ensure             = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-UnifiedGroup -MockWith { 
                return $null
            }
            Mock -CommandName Get-Team -MockWith { 
                return @{
                    DisplayName = "TestTeam"
                }
            }
         
            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present" 
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should Be $true
            }
        }

        Context -Name "Update existsing team access type" -Fixture {
            $testParams = @{
                DisplayName        = "TestTeam"
                GroupID            = "12345-12345-12345-12345-12345"
                Ensure             = "Present"
                AccessType         = "Public"
                Owner              = "JohnDoe@contoso.com"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-UnifiedGroup -MockWith { 
                return $null
            }

            Mock -CommandName Set-Team -MockWith {
                return $null
            }

            Mock -CommandName Get-Team -MockWith { 
                return @{
                    DisplayName = "TestTeam"
                    GroupID     = "12345-12345-12345-12345-12345"
                    Owner       = "JohnDoe@contoso.com"
                }
            }
         
            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present" 
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }

            It "Should set access type in set command" {
                Set-TargetResource @testParams  
            }
        }

        Context -Name "Failed to get Team when passing in GroupID" -Fixture {
            $testParams = @{
                DisplayName        = "TestTeam"
                GroupID            = "12345-12345-12345-12345-12345"
                Ensure             = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
            }
            Mock -CommandName Get-UnifiedGroup -MockWith { 
                return $null
            }
            Mock -CommandName Get-Team -MockWith { 
                return $null
            }
            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent" 
            }
            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should Be $false
            }
        }

        Context -Name "Update team display name" -Fixture {
            $testParams = @{
                GroupID            = "12345-12345-12345-12345-12345"
                DisplayName        = "Test Team"
                Ensure             = "Present"
                Alias              = "testteam"
                Description        = "Update description"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-UnifiedGroup -MockWith { 
                return $null
            }


            Mock -CommandName Get-Team -MockWith { 
                return @{
                    DisplayName = "Test Team"
                    GroupID     = "12345-12345-12345-12345-12345"
                }
            }

            
            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present" 
            }

            It "Should update display name and description in set method" {
                Set-TargetResource @testParams  
            }
        }

        Context -Name "Cannot only specify group only parameter" -Fixture {
            $testParams = @{
                Group              = "12345-12345-12345-12345-12345"
                DisplayName        = "Test Team"
                Ensure             = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-UnifiedGroup -MockWith { 
                return $null
            }


            Mock -CommandName Get-Team -MockWith { 
                return @{
                    DisplayName = "Test Team"
                    Group       = "12345-12345-12345-12345-12345"
                }
            }



            It "Should throw an error from the Set method" {
                { Set-TargetResource @testParams } | Should Throw "If connected O365Group is passed no other parameters can be passed into New-Team cmdlet"
            }
        }

        Context -Name "Remove the Team" -Fixture {
            $testParams = @{
                GroupID            = "12345-12345-12345-12345-12345"
                DisplayName        = "Test Team"
                Ensure             = "Absent"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-UnifiedGroup -MockWith { 
                return $null
            }

            Mock -CommandName Remove-Team -MockWith { 
                return $null
            }


            Mock -CommandName Get-Team -MockWith { 
                return @{
                    DisplayName = "Test Team"
                    GroupID     = "12345-12345-12345-12345-12345"
                }
            }

            
            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present" 
            }

            It "Should update display name and description in set method" {
                Set-TargetResource @testParams  
            }
        }


        Context -Name "ReverseDSC Tests" -Fixture {
            $testParams = @{
                DisplayName        = "Test Team"
                Description        = "Test team description"
                AccessType         = "Private"
                Alias              = "TestTeam"
                Ensure             = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-Team -MockWith { 
                return @{
                    DisplayName = "Test Team"
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
