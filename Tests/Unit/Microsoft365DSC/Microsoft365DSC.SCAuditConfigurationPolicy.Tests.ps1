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
    -DscResource "SCAuditConfigurationPolicy" -GenericStubModule $GenericStubPath
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

            Mock -CommandName New-AuditConfigurationPolicy -MockWith {
                return @{

                }
            }

            Mock -CommandName Remove-AuditConfigurationPolicy -MockWith {
            }
        }

        # Test contexts
        Context -Name "Policy doesn't already exists and should" -Fixture {
            BeforeAll {
                $testParams = @{
                    Workload           = "SharePoint"
                    GlobalAdminAccount = $GlobalAdminAccount
                    Ensure             = "Present"
                }

                Mock -CommandName Get-AuditConfigurationPolicy -MockWith {
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
                Should -Invoke -CommandName New-AuditConfigurationPolicy -Exactly 1
            }
        }

        Context -Name "Policy already exists and should - SharePoint" -Fixture {
            BeforeAll {
                $testParams = @{
                    Workload           = "SharePoint"
                    GlobalAdminAccount = $GlobalAdminAccount
                    Ensure             = "Present"
                }

                Mock -CommandName Get-AuditConfigurationPolicy -MockWith {
                    return @{
                        Workload = "SharePoint"
                        Name     = "91f20f6f-7ef9-4561-9a38-d771452d5e45"
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-AuditConfigurationPolicy -Exactly 0
            }
        }

        Context -Name "Policy already exists and should - OneDrive" -Fixture {
            BeforeAll {
                $testParams = @{
                    Workload           = "OneDriveForBusiness"
                    GlobalAdminAccount = $GlobalAdminAccount
                    Ensure             = "Present"
                }

                Mock -CommandName Get-AuditConfigurationPolicy -MockWith {
                    return @{
                        Workload = "SharePoint"
                        Name     = "a415dcce-19a0-4153-b137-eb6fd67995b5"
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-AuditConfigurationPolicy -Exactly 0
            }
        }

        Context -Name "Policy already exists but shouldn't - SharePoint" -Fixture {
            BeforeAll {
                $testParams = @{
                    Workload           = "SharePoint"
                    GlobalAdminAccount = $GlobalAdminAccount
                    Ensure             = "Absent"
                }

                Mock -CommandName Get-AuditConfigurationPolicy -MockWith {
                    return @{
                        Workload = "SharePoint"
                        Identity = '11111111-1111-1111-1111-11111111111'
                        Name     = "91f20f6f-7ef9-4561-9a38-d771452d5e45"
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-AuditConfigurationPolicy -Exactly 1
            }
        }

        Context -Name "Policy already exists but shouldn't - OneDrive" -Fixture {
            BeforeAll {
                $testParams = @{
                    Workload           = "OneDriveForBusiness"
                    GlobalAdminAccount = $GlobalAdminAccount
                    Ensure             = "Absent"
                }

                Mock -CommandName Get-AuditConfigurationPolicy -MockWith {
                    return @{
                        Workload = "SharePoint"
                        Identity = '11111111-1111-1111-1111-11111111111'
                        Name     = "a415dcce-19a0-4153-b137-eb6fd67995b5"
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be "Present"
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-AuditConfigurationPolicy -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName Get-AuditConfigurationPolicy -MockWith {
                    return @{
                        Workload = "SharePoint"
                        Name     = "a415dcce-19a0-4153-b137-eb6fd67995b5"
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
