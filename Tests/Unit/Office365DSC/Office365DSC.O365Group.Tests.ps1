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
                                              -DscResource "O365Group"
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
        $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)
        
        Mock -CommandName Test-O365ServiceConnection -MockWith {

        }

        Mock -CommandName New-ExoPSSession -MockWith {

        }

        # Test contexts 
        Context -Name "When the group doesn't already exist" -Fixture {
            $testParams = @{
                DisplayName = "Test Group"
                GroupType = "Security"
                Description = "This is a test"
                ManagedBy = "JohnSmith@contoso.onmicrosoft.com"
                Ensure = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName New-MSOLGroup -MockWith { 
                
            }
            
            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Absent" 
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should be $false
            }

            It "Should create the new Group in the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "When the group already exists" -Fixture {
            $testParams = @{
                DisplayName = "Test Group"
                GroupType = "Office365"
                Description = "This is a test"
                ManagedBy = "JohnSmith@contoso.onmicrosoft.com"
                Ensure = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Mock -CommandName Get-MSOLGroup -MockWith {
                return @{
                    DisplayName = "Test Group"
                    Description = "This is a test"
                    ObjectId = [GUID]"00000000-0000-0000-0000-000000000000"
                }
            }

            Mock -CommandName Get-MsolGroupMember -MockWith {
                return @(
                    @{
                        EmailAddress = "JohnSmith@contoso.onmicrosoft.com"
                    },
                    @{
                        EmailAddress = "SecondUser@contoso.onmicrosoft.com"
                    }
                )
            }
            
            It "Should return present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should Be "Present" 
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should be $true
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
