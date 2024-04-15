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
    -DscResource 'IntuneRoleAssignment' -GenericStubModule $GenericStubPath
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

            Mock -CommandName Update-MgBetaDeviceManagementRoleAssignment -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementRoleAssignment -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceManagementRoleAssignment -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Get-MgDeviceManagementRoleDefinition -MockWith {
                return @()
            }

            Mock -CommandName Get-MgDeviceManagementRoleDefinitionRoleAssignment -MockWith {
                return @()
            }
            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }
        # Test contexts
        Context -Name 'The IntuneRoleAssignment should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description = 'FakeStringValue'
                    DisplayName = 'FakeStringValue'
                    Id          = 'FakeStringValue'
                    Ensure      = 'Present'
                    Credential  = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementRoleAssignment -MockWith {
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
                Should -Invoke -CommandName New-MgBetaDeviceManagementRoleAssignment -Exactly 1
            }
        }

        Context -Name 'The IntuneRoleAssignment exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description                = 'FakeStringValue'
                    DisplayName                = 'FakeStringValue'
                    Id                         = ''
                    Ensure                     = 'Absent'
                    RoleDefinition             = '7fbbd347-98de-431d-942b-cf5bea92998d'
                    MembersDisplayNames        = @('FakeStringValue')
                    resourceScopesDisplayNames = @('FakeStringValue')
                    ScopeType                  = 'resourceScope'
                    Credential                 = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementRoleAssignment -MockWith {
                    return @{
                        Description = 'FakeStringValue'
                        DisplayName = 'FakeStringValue'
                        Id          = 'FakeStringValue'
                        ScopeType   = 'resourceScope'
                    }
                }
                Mock -CommandName Get-MgDeviceManagementRoleDefinition -MockWith {
                    return @()
                }
                Mock -CommandName Get-MgDeviceManagementRoleDefinitionRoleAssignment -MockWith {
                    return @()
                }
                Mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        Displayname = 'FakeStringValue'
                        Id          = 'FakeStringValue'
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
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementRoleAssignment -Exactly 1
            }
        }
        Context -Name 'The IntuneRoleAssignment Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description                = 'FakeStringValue'
                    DisplayName                = 'FakeStringValue'
                    Id                         = 'FakeStringValue'
                    Ensure                     = 'Present'
                    RoleDefinition             = '7fbbd347-98de-431d-942b-cf5bea92998d'
                    MembersDisplayNames        = @('FakeStringValue')
                    resourceScopesDisplayNames = @('FakeStringValue')
                    ScopeType                  = 'resourceScope'
                    Credential                 = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementRoleAssignment -MockWith {
                    return @{
                        Description    = 'FakeStringValue'
                        DisplayName    = 'FakeStringValue'
                        Id             = 'FakeStringValue'
                        Members        = @('FakeStringValue')
                        resourceScopes = @('FakeStringValue')
                        ScopeType      = 'resourceScope'

                    }
                }
                Mock -CommandName Get-MgDeviceManagementRoleDefinition -MockWith {
                    return @()
                }
                Mock -CommandName Get-MgDeviceManagementRoleDefinitionRoleAssignment -MockWith {
                    return @()
                }
                Mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        Displayname = 'FakeStringValue'
                        Id          = 'FakeStringValue'
                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'The IntuneRoleAssignment exists and values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description                = 'FakeStringValue'
                    DisplayName                = 'FakeStringValue'
                    Id                         = 'FakeStringValue'
                    Ensure                     = 'Present'
                    RoleDefinition             = '7fbbd347-98de-431d-942b-cf5bea92998d'
                    MembersDisplayNames        = @('FakeStringValue')
                    resourceScopesDisplayNames = @('FakeStringValue')
                    ScopeType                  = 'resourceScope'
                    Credential                 = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementRoleAssignment -MockWith {
                    return @{
                        AdditionalProperties = @{
                            '@odata.type' = '#microsoft.graph.'

                        }
                        Description          = 'StringValue'
                        DisplayName          = 'StringValue'
                        Id                   = 'StringValue'
                        ScopeType            = 'resourceScope'

                    }
                }
                Mock -CommandName Get-MgDeviceManagementRoleDefinition -MockWith {
                    return @()
                }
                Mock -CommandName Get-MgDeviceManagementRoleDefinitionRoleAssignment -MockWith {
                    return @()
                }
                Mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        Displayname = 'FakeStringValue'
                        Id          = 'FakeStringValue'
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
                Should -Invoke -CommandName Update-MgBetaDeviceManagementRoleAssignment -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementRoleAssignment -MockWith {
                    return @{
                        Description = 'FakeStringValue'
                        DisplayName = 'FakeStringValue'
                        Id          = 'FakeStringValue'
                        ScopeType   = 'resourceScope'
                    }
                }
                Mock -CommandName Get-MgDeviceManagementRoleDefinition -MockWith {
                    return @()
                }
                Mock -CommandName Get-MgDeviceManagementRoleDefinitionRoleAssignment -MockWith {
                    return @()
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
