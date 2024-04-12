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
    -DscResource 'AADRoleDefinition' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'test@password1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            $Global:PartialExportFileName = 'c:\TestPath'

            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgBetaRoleManagementDirectoryRoleDefinition -MockWith {
            }

            Mock -CommandName Remove-MgBetaRoleManagementDirectoryRoleDefinition -MockWith {
            }

            Mock -CommandName New-MgBetaRoleManagementDirectoryRoleDefinition -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'The role definition should exist but it does not' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName     = 'Role1'
                    Description     = 'This is a custom role'
                    ResourceScopes  = '/'
                    IsEnabled       = $true
                    RolePermissions = 'microsoft.directory/applicationPolicies/allProperties/read', 'microsoft.directory/applicationPolicies/allProperties/update', 'microsoft.directory/applicationPolicies/basic/update'
                    Version         = '1.0'
                    Ensure          = 'Present'
                    Credential      = $Credential
                }

                Mock -CommandName Get-MgBetaRoleManagementDirectoryRoleDefinition -MockWith {
                    return $null
                }
            }

            It 'Should return values from the get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
                Should -Invoke -CommandName 'Get-MgBetaRoleManagementDirectoryRoleDefinition' -Exactly 1
            }
            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should create the role definition from the set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-MgBetaRoleManagementDirectoryRoleDefinition' -Exactly 1
            }
        }

        Context -Name 'The role definition exists but it should not' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName     = 'Role1'
                    Description     = 'This is a custom role'
                    ResourceScopes  = '/'
                    IsEnabled       = $true
                    RolePermissions = 'microsoft.directory/applicationPolicies/allProperties/read', 'microsoft.directory/applicationPolicies/allProperties/update', 'microsoft.directory/applicationPolicies/basic/update'
                    Version         = '1.0'
                    Ensure          = 'Absent'
                    Credential      = $Credential
                    Id              = '12345-12345-12345-12345-12345'
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-MgBetaRoleManagementDirectoryRoleDefinition -MockWith {
                    $AADRoleDef = New-Object PSCustomObject
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name DisplayName -Value 'Role1'
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name Description -Value 'Role description'
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name ResourceScopes -Value '/'
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name IsEnabled -Value 'True'
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name RolePermissions -Value @{AllowedResourceActions = 'microsoft.directory/applicationPolicies/allProperties/read', 'microsoft.directory/applicationPolicies/allProperties/update', 'microsoft.directory/applicationPolicies/basic/update' }
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name Version -Value '1.0'
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name Id -Value '12345-12345-12345-12345-12345'
                    return $AADRoleDef
                }
            }

            It 'Should return values from the get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
                Should -Invoke -CommandName 'Get-MgBetaRoleManagementDirectoryRoleDefinition' -Exactly 1
            }

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the app from the set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Remove-MgBetaRoleManagementDirectoryRoleDefinition' -Exactly 1
            }
        }
        Context -Name 'The role definition exists and values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName     = 'Role1'
                    Description     = 'This is a custom role'
                    ResourceScopes  = '/'
                    IsEnabled       = $true
                    RolePermissions = 'microsoft.directory/applicationPolicies/allProperties/read'
                    Version         = '1.0'
                    Ensure          = 'Present'
                    Credential      = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-MgBetaRoleManagementDirectoryRoleDefinition -MockWith {
                    $AADRoleDef = New-Object PSCustomObject
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name DisplayName -Value 'Role1'
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name Description -Value 'This is a custom role'
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name ResourceScopes -Value '/'
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name IsEnabled -Value 'True'
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name RolePermissions -Value @{AllowedResourceActions = 'microsoft.directory/applicationPolicies/allProperties/read' }
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name Version -Value '1.0'
                    return $AADRoleDef
                }
            }

            It 'Should return Values from the get method' {
                Get-TargetResource @testParams
                Should -Invoke -CommandName 'Get-MgBetaRoleManagementDirectoryRoleDefinition' -Exactly 1
            }

            It 'Should return true from the test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'Values are not in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName     = 'Role1'
                    Description     = 'This is a custom role created by M365DSC.'#drift
                    ResourceScopes  = '/'
                    IsEnabled       = $true
                    RolePermissions = 'microsoft.directory/applicationPolicies/allProperties/read', 'microsoft.directory/applicationPolicies/allProperties/update', 'microsoft.directory/applicationPolicies/basic/update'
                    Version         = '1.0'
                    Ensure          = 'Present'
                    Credential      = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-MgBetaRoleManagementDirectoryRoleDefinition -MockWith {
                    $AADRoleDef = New-Object PSCustomObject
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name DisplayName -Value 'Role1'
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name Description -Value 'This is a custom role'
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name ResourceScopes -Value '/'
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name IsEnabled -Value 'True'
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name RolePermissions -Value @{AllowedResourceActions = 'microsoft.directory/applicationPolicies/allProperties/read', 'microsoft.directory/applicationPolicies/allProperties/update', 'microsoft.directory/applicationPolicies/basic/update' }
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name Version -Value '1.0'
                    return $AADRoleDef
                }
            }

            It 'Should return values from the get method' {
                Get-TargetResource @testParams
                Should -Invoke -CommandName 'Get-MgBetaRoleManagementDirectoryRoleDefinition' -Exactly 1
            }

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Update-MgBetaRoleManagementDirectoryRoleDefinition' -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-MgBetaRoleManagementDirectoryRoleDefinition -MockWith {
                    $AADRoleDef = New-Object PSCustomObject
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name DisplayName -Value 'Role1'
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name Description -Value 'This is a custom role'
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name ResourceScopes -Value '/'
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name IsEnabled -Value 'True'
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name RolePermissions -Value @{AllowedResourceActions = 'microsoft.directory/applicationPolicies/allProperties/read', 'microsoft.directory/applicationPolicies/allProperties/update', 'microsoft.directory/applicationPolicies/basic/update' }
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name Version -Value '1.0'
                    return $AADRoleDef
                }
            }

            It 'Should reverse engineer resource from the export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
