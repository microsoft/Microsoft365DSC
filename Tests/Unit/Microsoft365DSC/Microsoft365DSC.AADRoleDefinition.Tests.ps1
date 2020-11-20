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
    -DscResource "AADRoleDefinition" -GenericStubModule $GenericStubPath
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

            Mock -CommandName Get-PSSession -MockWith {

            }

            Mock -CommandName Remove-PSSession -MockWith {

            }

            Mock -CommandName Set-AzureADMSRoleDefinition -MockWith {

            }

            Mock -CommandName Remove-AzureADMSRoleDefinition -MockWith {

            }

            Mock -CommandName New-AzureADMSRoleDefinition -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }
        }

        # Test contexts
        Context -Name "The role definition should exist but it does not" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName                   = "Role1"
                    Description                   = "This is a custom role"
                    ResourceScopes                = "/"
                    IsEnabled                     = $true
                    RolePermissions               = "microsoft.directory/applicationPolicies/allProperties/read","microsoft.directory/applicationPolicies/allProperties/update","microsoft.directory/applicationPolicies/basic/update"
                    Version                       = "1.0"
                    Ensure                        = "Present"
                    GlobalAdminAccount            = $GlobalAdminAccount
                }

                Mock -CommandName Get-AzureADMSRoleDefinition -MockWith {
                    return $null
                }
            }

            It "Should return values from the get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
                Should -Invoke -CommandName "Get-AzureADMSRoleDefinition" -Exactly 2
            }
            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should create the role definition from the set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName "New-AzureADMSRoleDefinition" -Exactly 1
            }
        }

        Context -Name "The role definition exists but it should not" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName                   = "Role1"
                    Description                   = "This is a custom role"
                    ResourceScopes                = "/"
                    IsEnabled                     = $true
                    RolePermissions               = "microsoft.directory/applicationPolicies/allProperties/read","microsoft.directory/applicationPolicies/allProperties/update","microsoft.directory/applicationPolicies/basic/update"
                    Version                       = "1.0"
                    Ensure                        = "Absent"
                    GlobalAdminAccount            = $GlobalAdminAccount
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-AzureADMSRoleDefinition -MockWith {
                    $AADRoleDef = New-Object PSCustomObject
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name DisplayName -Value "Role1"
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name Description -Value "Role description"
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name ResourceScopes -Value "/"
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name IsEnabled -Value "True"
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name RolePermissions -Value @{AllowedResourceActions = "microsoft.directory/applicationPolicies/allProperties/read","microsoft.directory/applicationPolicies/allProperties/update","microsoft.directory/applicationPolicies/basic/update"}
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name Version -Value "1.0"
                    return $AADRoleDef
                }
            }

            It "Should return values from the get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
                Should -Invoke -CommandName "Get-AzureADMSRoleDefinition" -Exactly 1
            }

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the app from the set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName "Remove-AzureADMSRoleDefinition" -Exactly 1
            }
        }
        Context -Name "The role definition exists and values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName                   = "Role1"
                    Description                   = "This is a custom role"
                    ResourceScopes                = "/"
                    IsEnabled                     = $true
                    RolePermissions               = "microsoft.directory/applicationPolicies/allProperties/read"
                    Version                       = "1.0"
                    Ensure                        = "Present"
                    GlobalAdminAccount            = $GlobalAdminAccount
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-AzureADMSRoleDefinition -MockWith {
                    $AADRoleDef = New-Object PSCustomObject
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name DisplayName -Value "Role1"
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name Description -Value "This is a custom role"
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name ResourceScopes -Value "/"
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name IsEnabled -Value "True"
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name RolePermissions -Value @{AllowedResourceActions = "microsoft.directory/applicationPolicies/allProperties/read"}
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name Version -Value "1.0"
                    return $AADRoleDef
                }
            }

            It "Should return Values from the get method" {
                Get-TargetResource @testParams
                Should -Invoke -CommandName "Get-AzureADMSRoleDefinition" -Exactly 1
            }

            It 'Should return true from the test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "Values are not in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName                   = "Role1"
                    Description                   = "This is a custom role created by M365DSC."#drift
                    ResourceScopes                = "/"
                    IsEnabled                     = $true
                    RolePermissions               = "microsoft.directory/applicationPolicies/allProperties/read","microsoft.directory/applicationPolicies/allProperties/update","microsoft.directory/applicationPolicies/basic/update"
                    Version                       = "1.0"
                    Ensure                        = "Present"
                    GlobalAdminAccount            = $GlobalAdminAccount
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-AzureADMSRoleDefinition -MockWith {
                    $AADRoleDef = New-Object PSCustomObject
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name DisplayName -Value "Role1"
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name Description -Value "This is a custom role"
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name ResourceScopes -Value "/"
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name IsEnabled -Value "True"
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name RolePermissions -Value @{AllowedResourceActions = "microsoft.directory/applicationPolicies/allProperties/read","microsoft.directory/applicationPolicies/allProperties/update","microsoft.directory/applicationPolicies/basic/update"}
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name Version -Value "1.0"
                    return $AADRoleDef
                }
            }

            It "Should return values from the get method" {
                Get-TargetResource @testParams
                Should -Invoke -CommandName "Get-AzureADMSRoleDefinition" -Exactly 1
            }

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call the set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Set-AzureADMSRoleDefinition' -Exactly 1
            }
        }

        Context -Name "ReverseDSC tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    GlobalAdminAccount = $GlobalAdminAccount
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return "Credential"
                }

                Mock -CommandName Get-AzureADMSRoleDefinition -MockWith {
                    $AADRoleDef = New-Object PSCustomObject
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name DisplayName -Value "Role1"
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name Description -Value "This is a custom role"
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name ResourceScopes -Value "/"
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name IsEnabled -Value "True"
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name RolePermissions -Value @{AllowedResourceActions = "microsoft.directory/applicationPolicies/allProperties/read","microsoft.directory/applicationPolicies/allProperties/update","microsoft.directory/applicationPolicies/basic/update"}
                    $AADRoleDef | Add-Member -MemberType NoteProperty -Name Version -Value "1.0"
                    return $AADRoleDef
                }
            }

            It "Should reverse engineer resource from the export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
