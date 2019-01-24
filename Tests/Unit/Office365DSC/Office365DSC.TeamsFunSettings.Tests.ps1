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
                                                -DscResource "TeamsFunSettings"

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "Pass@word1)" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

        Mock -CommandName Test-TeamsServiceConnection -MockWith {
        }

        # Test contexts 
        Context -Name "Check Team Fun settings" -Fixture {
            $testParams = @{
                GroupID = "12345-12345-12345-12345-12345"
                AllowGiphy = $true
                GiphyContentRating = "Moderate"
                AllowStickersAndMemes = $true 
                AllowCustomMemes = $true
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Set-TeamFunSettings -MockWith { 
                return @{AllowGiphy = $null
                        GilphyContentRating = $null
                        AllowStickersAndMemes = $null
                        AllowCustomMemes = $null
                    }
            }

            Mock -CommandName Get-TeamFunSettings -MockWith { 
                return $null
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

        Context -Name "Set Team Fun settings" -Fixture {
            $testParams = @{
                GroupID = "12345-12345-12345-12345-12345"
                AllowGiphy = $true
                GiphyContentRating = "Moderate"
                AllowStickersAndMemes = $true 
                AllowCustomMemes = $true
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-TeamFunSettings -MockWith { 
                return @{
                    GroupID = "12345-12345-12345-12345-12345"
                    AllowGiphy = $true
                    GiphyContentRating = "Moderate"
                    AllowStickersAndMemes = $true 
                    AllowCustomMemes = $true
                    Ensure = "Present"
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
                GroupID = "12345-12345-12345-12345-12345"
                AllowGiphy = $true
                GiphyContentRating = "Moderate"
                AllowStickersAndMemes = $true 
                AllowCustomMemes = $true
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-TeamFunSettings -MockWith { 
                return @{
                    GroupID = "12345-12345-12345-12345-12345"
                    AllowGiphy = $true
                    GiphyContentRating = "Moderate"
                    AllowStickersAndMemes = $true 
                    AllowCustomMemes = $true
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
