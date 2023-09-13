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
    -DscResource 'IntuneRoleDefinition' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString 'test@password1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgBetaDeviceManagementRoleDefinition -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementRoleDefinition -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceManagementRoleDefinition -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name 'The IntuneRoleDefinition should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description               = 'FakeStringValue'
                    DisplayName               = 'FakeStringValue'
                    Id                        = 'FakeStringValue'
                    IsBuiltIn                 = $True
                    allowedResourceActions    = @('Microsoft.Intune_Organization_Read', 'Microsoft.Intune_Roles_Create', 'Microsoft.Intune_Roles_Read', 'Microsoft.Intune_Roles_Update')
                    notallowedResourceActions = @()
                    Ensure                    = 'Present'
                    Credential                = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementRoleDefinition -MockWith {
                    return $null
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Create the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgBetaDeviceManagementRoleDefinition -Exactly 1
            }
        }

        Context -Name 'The IntuneRoleDefinition exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description               = 'FakeStringValue'
                    DisplayName               = 'FakeStringValue'
                    Id                        = 'FakeStringValue'
                    IsBuiltIn                 = $True
                    allowedResourceActions    = @('Microsoft.Intune_Organization_Read', 'Microsoft.Intune_Roles_Create', 'Microsoft.Intune_Roles_Read', 'Microsoft.Intune_Roles_Update')
                    notallowedResourceActions = @()
                    Ensure                    = 'Absent'
                    Credential                = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementRoleDefinition -MockWith {
                    return @{
                        Description     = 'FakeStringValue'
                        DisplayName     = 'FakeStringValue'
                        Id              = 'FakeStringValue'
                        IsBuiltIn       = $True
                        RolePermissions = @{
                            ResourceActions = @{
                                AllowedResourceActions    = @('Microsoft.Intune_Organization_Read', 'Microsoft.Intune_Roles_Create', 'Microsoft.Intune_Roles_Read', 'Microsoft.Intune_Roles_Update')
                                NotAllowedResourceActions = @()
                            }
                        }
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementRoleDefinition -Exactly 1
            }
        }
        Context -Name 'The IntuneRoleDefinition Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description               = 'FakeStringValue'
                    DisplayName               = 'FakeStringValue'
                    Id                        = 'FakeStringValue'
                    IsBuiltIn                 = $True
                    allowedResourceActions    = @('Microsoft.Intune_Organization_Read', 'Microsoft.Intune_Roles_Create', 'Microsoft.Intune_Roles_Read', 'Microsoft.Intune_Roles_Update')
                    notallowedResourceActions = @()
                    Ensure                    = 'Present'
                    Credential                = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementRoleDefinition -MockWith {
                    return @{
                        Description     = 'FakeStringValue'
                        DisplayName     = 'FakeStringValue'
                        Id              = 'FakeStringValue'
                        IsBuiltIn       = $True
                        RolePermissions = @{
                            ResourceActions = @{
                                AllowedResourceActions    = @('Microsoft.Intune_Organization_Read', 'Microsoft.Intune_Roles_Create', 'Microsoft.Intune_Roles_Read', 'Microsoft.Intune_Roles_Update')
                                NotAllowedResourceActions = @()
                            }
                        }
                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'The IntuneRoleDefinition exists and values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description               = 'FakeStringValue'
                    DisplayName               = 'FakeStringValue'
                    Id                        = 'FakeStringValue'
                    IsBuiltIn                 = $True
                    allowedResourceActions    = @('Microsoft.Intune_Roles_Create', 'Microsoft.Intune_Roles_Read', 'Microsoft.Intune_Roles_Update')
                    notallowedResourceActions = @()
                    Ensure                    = 'Present'
                    Credential                = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementRoleDefinition -MockWith {
                    return @{
                        Description     = 'FakeStringValue'
                        DisplayName     = 'FakeStringValue'
                        Id              = 'FakeStringValue'
                        IsBuiltIn       = $True
                        RolePermissions = @{
                            ResourceActions = @{
                                AllowedResourceActions    = @('Microsoft.Intune_Organization_Read', 'Microsoft.Intune_Roles_Create', 'Microsoft.Intune_Roles_Read', 'Microsoft.Intune_Roles_Update')
                                NotAllowedResourceActions = @()
                            }
                        }
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgBetaDeviceManagementRoleDefinition -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementRoleDefinition -MockWith {
                    return @{
                        Description          = 'FakeStringValue'
                        DisplayName          = 'FakeStringValue'
                        Id                   = 'FakeStringValue'
                        IsBuiltIn            = $True
                        RolePermissions      = @{
                            ResourceActions = @{
                                AllowedResourceActions    = @('Microsoft.Intune_Organization_Read', 'Microsoft.Intune_Roles_Create', 'Microsoft.Intune_Roles_Read', 'Microsoft.Intune_Roles_Update')
                                NotAllowedResourceActions = @()
                            }
                        }
                        AdditionalProperties = @{
                            '@odata.type' = '#microsoft.graph.deviceAndAppManagementRoleDefinition'
                        }
                    }
                }
            }
            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
