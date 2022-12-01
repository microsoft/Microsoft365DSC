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
    -DscResource 'AADEntitlementManagementAccessPackage' -GenericStubModule $GenericStubPath
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

            Mock -CommandName Update-MgEntitlementManagementAccessPackage -MockWith {
            }

            Mock -CommandName New-MgEntitlementManagementAccessPackage -MockWith {
            }

            Mock -CommandName Remove-MgEntitlementManagementAccessPackage -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credential'
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name 'The AADEntitlementManagementAccessPackage should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    CatalogId           = 'FakeStringValue'
                    Description         = 'FakeStringValue'
                    DisplayName         = 'FakeStringValue'
                    Id                  = 'FakeStringValue'
                    IsHidden            = $True
                    IsRoleScopesVisible = $True

                    Ensure              = 'Present'
                    Credential          = $Credential
                }

                Mock -CommandName Get-MgEntitlementManagementAccessPackage -MockWith {
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
                Should -Invoke -CommandName New-MgEntitlementManagementAccessPackage -Exactly 1
            }
        }

        Context -Name 'The AADEntitlementManagementAccessPackage exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    CatalogId           = 'FakeStringValue'
                    Description         = 'FakeStringValue'
                    DisplayName         = 'FakeStringValue'
                    Id                  = 'FakeStringValue'
                    IsHidden            = $True
                    IsRoleScopesVisible = $True

                    Ensure              = 'Absent'
                    Credential          = $Credential
                }

                Mock -CommandName Get-MgEntitlementManagementAccessPackage -MockWith {
                    return @{
                        CatalogId           = 'FakeStringValue'
                        Description         = 'FakeStringValue'
                        DisplayName         = 'FakeStringValue'
                        Id                  = 'FakeStringValue'
                        IsHidden            = $True
                        IsRoleScopesVisible = $True

                    }
                }
                Mock -CommandName Get-MgEntitlementManagementAccessPackageIncompatibleAccessPackage -MockWith {
                    return @()
                }
                Mock -CommandName Get-MgEntitlementManagementAccessPackageIncompatibleWith -MockWith {
                    return @()
                }
                Mock -CommandName Get-MgEntitlementManagementAccessPackageIncompatibleGroup -MockWith {
                    return @()
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
                Should -Invoke -CommandName Remove-MgEntitlementManagementAccessPackage -Exactly 1
            }
        }
        Context -Name 'The AADEntitlementManagementAccessPackage Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    CatalogId                  = 'FakeStringValue'
                    Description                = 'FakeStringValue'
                    DisplayName                = 'FakeStringValue'
                    Id                         = 'FakeStringValue'
                    IsHidden                   = $True
                    IsRoleScopesVisible        = $True
                    IncompatibleAccessPackages = @('packageId1', 'packageId2')
                    IncompatibleGroups         = @('groupId1', 'groupId2')

                    Ensure                     = 'Present'
                    Credential                 = $Credential
                }

                Mock -CommandName Get-MgEntitlementManagementAccessPackage -MockWith {
                    return @{
                        CatalogId           = 'FakeStringValue'
                        Description         = 'FakeStringValue'
                        DisplayName         = 'FakeStringValue'
                        Id                  = 'FakeStringValue'
                        IsHidden            = $True
                        IsRoleScopesVisible = $True

                    }
                }
                Mock -CommandName Get-MgEntitlementManagementAccessPackageIncompatibleAccessPackage -MockWith {
                    return @(
                        @{
                            id = 'packageId1'
                        }
                        @{
                            id = 'packageId2'
                        }
                    )
                }
                Mock -CommandName Get-MgEntitlementManagementAccessPackageIncompatibleWith -MockWith {
                    return @()
                }
                Mock -CommandName Get-MgEntitlementManagementAccessPackageIncompatibleGroup -MockWith {
                    return @(
                        @{
                            id = 'groupId1'
                        }
                        @{
                            id = 'groupId2'
                        }
                    )
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'The AADEntitlementManagementAccessPackage exists and values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    CatalogId           = 'FakeStringValue'
                    Description         = 'FakeStringValue'
                    DisplayName         = 'FakeStringValue'
                    Id                  = 'FakeStringValue'
                    IsHidden            = $True
                    IsRoleScopesVisible = $True

                    Ensure              = 'Present'
                    Credential          = $Credential
                }

                Mock -CommandName Get-MgEntitlementManagementAccessPackage -MockWith {
                    return @{
                        CatalogId           = 'FakeStringValue'
                        Description         = 'FakeStringValue'
                        DisplayName         = 'FakeStringValue'
                        Id                  = 'FakeStringValue'
                        IsHidden            = $False #Drift
                        IsRoleScopesVisible = $True

                    }
                }
                Mock -CommandName Get-MgEntitlementManagementAccessPackageIncompatibleAccessPackage -MockWith {
                    return @()
                }
                Mock -CommandName Get-MgEntitlementManagementAccessPackageIncompatibleWith -MockWith {
                    return @()
                }
                Mock -CommandName Get-MgEntitlementManagementAccessPackageIncompatibleGroup -MockWith {
                    return @()
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
                Should -Invoke -CommandName Update-MgEntitlementManagementAccessPackage -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgEntitlementManagementAccessPackage -MockWith {
                    return @{
                        CatalogId           = 'FakeStringValue'
                        Description         = 'FakeStringValue'
                        DisplayName         = 'FakeStringValue'
                        Id                  = 'FakeStringValue'
                        IsHidden            = $True
                        IsRoleScopesVisible = $True

                    }
                }
                Mock -CommandName Get-MgEntitlementManagementAccessPackageIncompatibleAccessPackage -MockWith {
                    return @()
                }
                Mock -CommandName Get-MgEntitlementManagementAccessPackageIncompatibleWith -MockWith {
                    return @()
                }
                Mock -CommandName Get-MgEntitlementManagementAccessPackageIncompatibleGroup -MockWith {
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
