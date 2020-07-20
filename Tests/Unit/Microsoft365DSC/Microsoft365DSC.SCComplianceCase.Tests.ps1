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
    -DscResource "SCComplianceCase" -GenericStubModule $GenericStubPath
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

            Mock -CommandName Remove-ComplianceCase -MockWith {
                return @{

                }
            }

            Mock -CommandName New-ComplianceCase -MockWith {
                return @{

                }
            }

            Mock -CommandName Set-ComplianceCase -MockWith {
                return @{

                }
            }
        }

        # Test contexts
        Context -Name "Case doesn't already exists and should be Active" -Fixture {
            BeforeAll {
                $testParams = @{
                    Name               = "TestCase"
                    Description        = "This is a test Case"
                    Status             = "Active"
                    GlobalAdminAccount = $GlobalAdminAccount
                    Ensure             = "Present"
                }

                Mock -CommandName Get-ComplianceCase -MockWith {
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

        Context -Name "Case doesn't already exist and should be Closed" -Fixture {
            BeforeAll {
                $testParams = @{
                    Name               = "TestCase"
                    Description        = "This is a test Case"
                    Status             = "Closed"
                    GlobalAdminAccount = $GlobalAdminAccount
                    Ensure             = "Present"
                }

                Mock -CommandName Get-ComplianceCase -MockWith {
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

        Context -Name "Case already exists, is Active, but should be closed" -Fixture {
            BeforeAll {
                $testParams = @{
                    Name               = "TestCase"
                    Description        = "This is a test Case"
                    Status             = "Closed"
                    GlobalAdminAccount = $GlobalAdminAccount
                    Ensure             = "Present"
                }

                Mock -CommandName Get-ComplianceCase -MockWith {
                    return @{
                        Name        = "TestCase"
                        Description = ""
                        Status      = "Active"
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $False
            }

            It 'Should update from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }
        }

        Context -Name "Case already exists, is Closed, but should be Active" -Fixture {
            BeforeAll {
                $testParams = @{
                    Name               = "TestCase"
                    Description        = "This is a test Case"
                    Status             = "Active"
                    GlobalAdminAccount = $GlobalAdminAccount
                    Ensure             = "Present"
                }

                Mock -CommandName Get-ComplianceCase -MockWith {
                    return @{
                        Name        = "TestCase"
                        Description = "This is a test Case"
                        Status      = "Closed"
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $False
            }

            It 'Should update from the Set method' {
                Set-TargetResource @testParams
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }
        }

        Context -Name "Case should not exist, but is does" -Fixture {
            BeforeAll {
                $testParams = @{
                    Ensure             = "Absent"
                    Name               = "TestCase"
                    Status             = "Active"
                    Description        = "This is a test Case"
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-ComplianceCase -MockWith {
                    return @{
                        Name        = "TestCase"
                        Status      = "Active"
                        Description = "This is a test Case"
                    }
                }
            }

            It 'Should return False from the Test method' {
                Test-TargetResource @testParams | Should -Be $False
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

                $testCase = @{
                    Name        = "TestCase1"
                    Status      = "Active"
                    Description = "This is a test Case (1)"
                }

                Mock -CommandName Get-ComplianceCase -MockWith {
                    return $testCase
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
