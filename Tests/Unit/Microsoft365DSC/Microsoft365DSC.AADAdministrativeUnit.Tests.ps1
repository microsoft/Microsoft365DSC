[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
    -ChildPath "..\..\Unit" `
    -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
        -ChildPath "\Stubs\Microsoft365.psm1" `
        -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
        -ChildPath "\Stubs\Generic.psm1" `
        -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath "\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "AADAdministrativeUnit" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {
            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            $Global:PartialExportFileName = "c:\TestPath"
            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {
                return "FakeDSCContent"
            }
            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {

            }

            Mock -CommandName Remove-PSSession -MockWith {

            }

            Mock -CommandName Update-MgAdministrativeUnit -MockWith {

            }

            Mock -CommandName Remove-MgAdministrativeUnit -MockWith {

            }

            Mock -CommandName New-MgAdministrativeUnit -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }
        }

        # Test contexts
        Context -Name "The instance should exist but it does not" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName                   = "Test-Unit";
                    Ensure                        = "Present";
                    MembershipRule                = "(user.country -eq `"Canada`")";
                    MembershipRuleProcessingState = "On";
                    MembershipType                = "Dynamic";
                    Credential                    = $Credential
                }

                Mock -CommandName Get-MgAdministrativeUnit -MockWith {
                    return $null
                }
            }

            It "Should return values from the get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
                Should -Invoke -CommandName "Get-MgAdministrativeUnit" -Exactly 1
            }
            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should create the instance from the set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName "New-MgAdministrativeUnit" -Exactly 1
            }
        }

        Context -Name "The instance exists but is not in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName                   = "Test-Unit";
                    Ensure                        = "Present";
                    MembershipRule                = "(user.country -eq `"Canada`")";
                    MembershipRuleProcessingState = "On";
                    MembershipType                = "Dynamic";
                    Credential                    = $Credential
                }

                Mock -CommandName Get-MgAdministrativeUnit -MockWith {
                    return @{
                        DisplayName                   = "Test-Unit";
                        AdditionalProperties          = @{
                            MembershipRule                = "(user.country -eq `"US`")"; #Drift
                            MembershipRuleProcessingState = "On";
                            MembershipType                = "Dynamic";
                        }
                    }
                }
            }

            It "Should return values from the get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
                Should -Invoke -CommandName "Get-MgAdministrativeUnit" -Exactly 1
            }

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update the instance from the set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName "Update-MgAdministrativeUnit" -Exactly 1
            }
        }
        Context -Name "The instance exists and values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName                   = "Test-Unit";
                    Ensure                        = "Present";
                    MembershipRule                = "(user.country -eq `"Canada`")";
                    MembershipRuleProcessingState = "On";
                    MembershipType                = "Dynamic";
                    Credential                    = $Credential
                }

                Mock -CommandName Get-MgAdministrativeUnit -MockWith {
                    return @{
                        DisplayName                   = "Test-Unit";
                        AdditionalProperties          = @{
                            MembershipRule                = "(user.country -eq `"Canada`")";
                            MembershipRuleProcessingState = "On";
                            MembershipType                = "Dynamic";
                        }
                    }
                }
            }

            It "Should return Values from the get method" {
                Get-TargetResource @testParams
                Should -Invoke -CommandName "Get-MgAdministrativeUnit" -Exactly 1
            }

            It 'Should return true from the test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "Instance exists but it shouldn't" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName                   = "Test-Unit";
                    Ensure                        = "Absent";
                    MembershipRule                = "(user.country -eq `"Canada`")";
                    MembershipRuleProcessingState = "On";
                    MembershipType                = "Dynamic";
                    Credential                    = $Credential
                }

                Mock -CommandName Get-MgAdministrativeUnit -MockWith {
                    return @{
                        DisplayName                   = "Test-Unit";
                        AdditionalProperties          = @{
                            MembershipRule                = "(user.country -eq `"Canada`")";
                            MembershipRuleProcessingState = "On";
                            MembershipType                = "Dynamic";
                        }
                    }
                }
            }

            It "Should return values from the get method" {
                Get-TargetResource @testParams
                Should -Invoke -CommandName "Get-MgAdministrativeUnit" -Exactly 1
            }

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call the remove method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Remove-MgAdministrativeUnit' -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgAdministrativeUnit -MockWith {
                    return @{
                        DisplayName                   = "Test-Unit";
                        AdditionalProperties          = @{
                            MembershipRule                = "(user.country -eq `"Canada`")";
                            MembershipRuleProcessingState = "On";
                            MembershipType                = "Dynamic";
                        }
                    }
                }
            }

            It "Should reverse engineer resource from the export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
