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
    -DscResource "SCDLPComplianceRule" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $GlobalAdminAccount = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }

            Mock -CommandName Import-PSSession -MockWith {

            }

            Mock -CommandName New-PSSession -MockWith {

            }

            Mock -CommandName Remove-DLPComplianceRule -MockWith {

            }

            Mock -CommandName New-DLPComplianceRule -MockWith {
                return @{

                }
            }
        }

        # Test contexts
        Context -Name "Rule doesn't already exist but should" -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                              = 'Present'
                    Policy                              = "MyParentPolicy"
                    Comment                             = "";
                    ContentContainsSensitiveInformation = (New-CimInstance -ClassName MSFT_SCDLPSensitiveInformation -Property @{
                            name     = "rulename"
                            maxcount = "10"
                            mincount = "0"
                        } -ClientOnly)
                    BlockAccess                         = $False;
                    Name                                = 'TestPolicy'
                    GlobalAdminAccount                  = $GlobalAdminAccount
                }

                Mock -CommandName Get-DLPComplianceRule -MockWith {
                    return $null
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Absent"
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
            }
        }

        Context -Name "Rule already exists, and should" -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                              = 'Present'
                    Policy                              = "MyParentPolicy"
                    Comment                             = "New comment";
                    ContentContainsSensitiveInformation = (New-CimInstance -ClassName MSFT_SCDLPSensitiveInformation -Property @{
                            maxconfidence  = "100";
                            id             = "eefbb00e-8282-433c-8620-8f1da3bffdb2";
                            minconfidence  = "75";
                            rulePackId     = "00000000-0000-0000-0000-000000000000";
                            classifiertype = "Content";
                            name           = "Argentina National Identity (DNI) Number";
                            mincount       = "1";
                            maxcount       = "9";
                        } -ClientOnly)
                    BlockAccess                         = $False;
                    Name                                = 'TestPolicy'
                    GlobalAdminAccount                  = $GlobalAdminAccount
                }

                Mock -CommandName Get-DLPComplianceRule -MockWith {
                    return @{
                        Name                                = "TestPolicy"
                        Comment                             = "New Comment"
                        ParentPolicyName                    = "MyParentPolicy"
                        ContentContainsSensitiveInformation = @(@{maxconfidence = "100"; id = "eefbb00e-8282-433c-8620-8f1da3bffdb2"; minconfidence = "75"; rulePackId = "00000000-0000-0000-0000-000000000000"; classifiertype = "Content"; name = "Argentina National Identity (DNI) Number"; mincount = "1"; maxcount = "9"; })
                        BlockAccess                         = $False;
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should recreate from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }
        }

        Context -Name "Rule should not exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure             = 'Absent'
                    Policy             = "MyParentPolicy"
                    Comment            = "";
                    BlockAccess        = $False;
                    Name               = 'TestPolicy'
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-DLPComplianceRule -MockWith {
                    return @{
                        Name                                = "TestPolicy"
                        ParentPolicyName                    = "MyParentPolicy"
                        ContentContainsSensitiveInformation = @(@{maxconfidence = "100"; id = "eefbb00e-8282-433c-8620-8f1da3bffdb2"; minconfidence = "75"; rulePackId = "00000000-0000-0000-0000-000000000000"; classifiertype = "Content"; name = "Argentina National Identity (DNI) Number"; mincount = "1"; maxcount = "9"; })
                        Comment                             = "";
                        BlockAccess                         = $False;
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should delete from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-M365DSCExportContentForResource -MockWith {
                    return "SCDLPComplianceRule Test{ContentContainsSensitiveInformation = `"`$Test`"}"
                }

                Mock -CommandName Get-DLPComplianceRule -MockWith {
                    return @{
                        Name                                = "TestPolicy"
                        ParentPolicyName                    = "MyParentPolicy"
                        ContentContainsSensitiveInformation = @(@{maxconfidence = "100"; id = "eefbb00e-8282-433c-8620-8f1da3bffdb2"; minconfidence = "75"; rulePackId = "00000000-0000-0000-0000-000000000000"; classifiertype = "Content"; name = "Argentina National Identity (DNI) Number"; mincount = "1"; maxcount = "9"; })
                        Comment                             = "";
                        BlockAccess                         = $False;
                    }
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
