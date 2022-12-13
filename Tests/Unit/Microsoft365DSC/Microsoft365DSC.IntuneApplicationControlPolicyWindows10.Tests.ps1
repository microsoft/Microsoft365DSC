[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
    -ChildPath '..\..\Unit' `
    -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\Stubs\Microsoft365.psm1' `
        -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\Stubs\Generic.psm1' `
        -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\UnitTestHelper.psm1' `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource 'IntuneApplicationControlPolicyWindows10' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {

            $secpasswd = ConvertTo-SecureString 'Pass@word1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin', $secpasswd)

            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {
                return 'Content'
            }

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Remove-MgDeviceManagementIntent -MockWith {
            }

            Mock -CommandName New-MgDeviceManagementIntent -MockWith {
            }

            Mock -CommandName Update-MgDeviceManagementIntent -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name "When the App Configuration Policy doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName = 'Test App Configuration Policy'
                    Description = 'Test Definition'
                    Ensure      = 'Present'
                    Credential  = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementIntentSetting -MockWith {
                    return $null
                }
                Mock -CommandName Get-MgDeviceManagementIntentAssignment -MockWith {
                    return @()
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create the App Configuration Policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-MgDeviceManagementIntent' -Exactly 1
            }
        }

        Context -Name 'When the policy already exists and is NOT in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName = 'Test App Configuration Policy'
                    Description = 'Test Definition'
                    Ensure      = 'Present'
                    Credential  = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementIntent -MockWith {
                    return @{
                        Id          = 'A_19dbaff5-9aff-48b0-a60d-d0471ddaf141'
                        TemplateId  = '63be6324-e3c9-4c97-948a-e7f4b96f0f20'
                        DisplayName = 'Test App Configuration Policy'
                        Description = 'Different Value'
                    }
                }
                Mock -CommandName Get-MgDeviceManagementIntentSetting -MockWith {
                    return @{
                        DisplayName  = 'Test App Configuration Policy'
                        Description  = 'Different Value'
                        Id           = 'A_19dbaff5-9aff-48b0-a60d-d0471ddaf141'
                        DefinitionId = 'appLockerApplicationControl'
                        ValueJSON    = "'true'"
                    }
                }
                Mock -CommandName Get-MgDeviceManagementIntentAssignment -MockWith {
                    return @()
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update the App Configuration Policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgDeviceManagementIntent -Exactly 1
            }
        }

        Context -Name 'When the policy already exists and IS in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName = 'Test App Configuration Policy'
                    Description = 'Test Definition'
                    Ensure      = 'Present'
                    Credential  = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementIntent -MockWith {
                    return @{
                        DisplayName = 'Test App Configuration Policy'
                        Description = 'Test Definition'
                        Id          = 'A_19dbaff5-9aff-48b0-a60d-d0471ddaf141'
                        TemplateId  = '63be6324-e3c9-4c97-948a-e7f4b96f0f20'
                    }
                }

                Mock -CommandName Get-MgDeviceManagementIntentSetting -MockWith {
                    return @{
                        DisplayName  = 'Test App Configuration Policy'
                        Description  = 'Test Definition'
                        Id           = 'A_19dbaff5-9aff-48b0-a60d-d0471ddaf141'
                        DefinitionId = 'appLockerApplicationControl'
                        ValueJSON    = "'true'"
                    }
                }
                Mock -CommandName Get-MgDeviceManagementIntentAssignment -MockWith {
                    return @()
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'When the policy exists and it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName = 'Test App Configuration Policy'
                    Description = 'Test Definition'
                    Ensure      = 'Absent'
                    Credential  = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementIntent -MockWith {
                    return @{
                        DisplayName = 'Test App Configuration Policy'
                        Description = 'Test Definition'
                        Id          = 'A_19dbaff5-9aff-48b0-a60d-d0471ddaf141'
                        TemplateId  = '63be6324-e3c9-4c97-948a-e7f4b96f0f20'
                    }
                }

                Mock -CommandName Get-MgDeviceManagementIntentSetting -MockWith {
                    return @{
                        DisplayName  = 'Test App Configuration Policy'
                        Description  = 'Test Definition'
                        Id           = 'A_19dbaff5-9aff-48b0-a60d-d0471ddaf141'
                        DefinitionId = 'appLockerApplicationControl'
                        ValueJSON    = "'true'"
                    }
                }
                Mock -CommandName Get-MgDeviceManagementIntentAssignment -MockWith {
                    return @()
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the App Configuration Policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgDeviceManagementIntent -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementIntent -MockWith {
                    return @{
                        DisplayName = 'Test App Configuration Policy'
                        Description = 'Test Definition'
                        Id          = 'A_19dbaff5-9aff-48b0-a60d-d0471ddaf141'
                        TemplateId  = '63be6324-e3c9-4c97-948a-e7f4b96f0f20'
                    }
                }

                Mock -CommandName Get-MgDeviceManagementIntentSetting -MockWith {
                    return @{
                        DisplayName  = 'Test App Configuration Policy'
                        Description  = 'Test Definition'
                        Id           = 'A_19dbaff5-9aff-48b0-a60d-d0471ddaf141'
                        DefinitionId = 'appLockerApplicationControl'
                        ValueJSON    = "'true'"
                    }
                }
                Mock -CommandName Get-MgDeviceManagementIntentAssignment -MockWith {
                    return @()
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
