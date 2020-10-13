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
    -DscResource "SCRetentionComplianceRule" -GenericStubModule $GenericStubPath
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

            Mock -CommandName Remove-RetentionComplianceRule -MockWith {

            }

            Mock -CommandName New-RetentionComplianceRule -MockWith {
                return @{

                }
            }
        }

        # Test contexts
        Context -Name "Rule doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                    = 'Present'
                    GlobalAdminAccount        = $GlobalAdminAccount
                    Comment                   = "This is a Demo Rule"
                    RetentionComplianceAction = "Keep"
                    RetentionDuration         = "Unlimited"
                    Name                      = 'TestRule'
                    Policy                    = 'TestPolicy'
                }

                Mock -CommandName Get-RetentionComplianceRule -MockWith {
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

        Context -Name "Rule already exists" -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure                    = 'Present'
                    GlobalAdminAccount        = $GlobalAdminAccount
                    Comment                   = "This is a Demo Rule"
                    RetentionComplianceAction = "Keep"
                    RetentionDuration         = "Unlimited"
                    Name                      = 'TestRule'
                    Policy                    = 'TestPolicy'
                }

                Mock -CommandName Get-RetentionCompliancePolicy -MockWith {
                    return @{
                        Name = "TestPolicy"
                    }
                }

                Mock -CommandName Get-RetentionComplianceRule -MockWith {
                    return @{
                        Name                      = "TestRule"
                        Comment                   = "This is a Demo Rule"
                        RetentionComplianceAction = "Keep"
                        RetentionDuration         = "Unlimited"
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
                    Ensure                    = 'Absent'
                    GlobalAdminAccount        = $GlobalAdminAccount
                    Comment                   = "This is a Demo Rule"
                    RetentionComplianceAction = "Keep"
                    RetentionDuration         = "Unlimited"
                    Name                      = 'TestRule'
                    Policy                    = 'TestPolicy'
                }

                Mock -CommandName Get-RetentionCompliancePolicy -MockWith {
                    return @{
                        Name = "TestPolicy"
                    }
                }

                Mock -CommandName Get-RetentionComplianceRule -MockWith {
                    return @{
                        Name = "TestRule"
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

                Mock -CommandName Get-RetentionCompliancePolicy -MockWith {
                    return @{
                        Name = "TestPolicy"
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
