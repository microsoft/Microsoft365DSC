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
    -DscResource 'SPOStorageEntity' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'Pass@word1)' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Get-M365DSCOrganization -MockWith {
                return 'contoso.com'
            }

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Get-SPOAdministrationUrl -MockWith {
                return 'https://contoso-admin.sharepoint.com'
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'Check SPOStorageEntity' -Fixture {
            BeforeAll {
                $testParams = @{
                    Key         = 'DSCKey'
                    Value       = 'Test storage entity'
                    EntityScope = 'Site'
                    Description = 'Description created by DSC'
                    Comment     = 'Comment from DSC'
                    Ensure      = 'Present'
                    Credential  = $Credential
                    SiteUrl     = 'https://contoso-admin.sharepoint.com'
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-PnPStorageEntity -MockWith {
                    return $null
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
        }

        Context -Name 'Check existing Storage Entity' -Fixture {
            BeforeAll {
                $testParams = @{
                    Key         = 'DSCKey'
                    Value       = 'Test storage entity'
                    EntityScope = 'Site'
                    Description = 'Description created by DSC'
                    Comment     = 'Comment from DSC'
                    Ensure      = 'Present'
                    SiteUrl     = 'https://contoso-admin.sharepoint.com'
                    Credential  = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-PnPStorageEntity -MockWith {
                    return @{
                        Key         = 'DSCKey'
                        Value       = 'Test storage entity'
                        EntityScope = 'Site'
                        Description = 'Description created by DSC'
                        Comment     = 'Comment from DSC'
                    }
                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'Adding storage entity' -Fixture {
            BeforeAll {
                $testParams = @{
                    Key         = 'DSCKey'
                    Value       = 'Test storage entity'
                    EntityScope = 'Site'
                    Description = 'Description created by DSC'
                    Comment     = 'Comment from DSC'
                    Ensure      = 'Present'
                    SiteUrl     = 'https://contoso-admin.sharepoint.com'
                    Credential  = $Credential
                }
                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-PnPStorageEntity -MockWith {
                    return @{
                        Key         = 'DSCKey'
                        Value       = 'Updated test storage entity'
                        EntityScope = 'Site'
                        Description = 'Description created by DSC'
                        Comment     = 'Comment from DSC'
                    }
                }

                Mock -CommandName Set-PnPStorageEntity -MockWith {
                    return @{
                        Key         = 'DSCKey'
                        Value       = 'Updated test storage entity'
                        EntityScope = 'Site'
                        Description = 'Updated description created by DSC'
                        Comment     = 'Comment from DSC'
                    }
                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Updates storage entity in the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'Removing a storage entity' -Fixture {
            BeforeAll {
                $testParams = @{
                    Key         = 'DSCKey'
                    Value       = 'Test storage entity'
                    EntityScope = 'Site'
                    Description = 'Description created by DSC'
                    Comment     = 'Comment from DSC'
                    Ensure      = 'Absent'
                    SiteUrl     = 'https://contoso-admin.sharepoint.com'
                    Credential  = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-PnPStorageEntity -MockWith {
                    return @{
                        Key         = 'DSCKey'
                        Value       = 'Test storage entity'
                        EntityScope = 'Site'
                        Description = 'Description created by DSC'
                        Comment     = 'Comment from DSC'
                    }
                }

                Mock -CommandName Remove-PnPStorageEntity -MockWith {
                    return $null
                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Remove storage entity in the Set method' {
                Set-TargetResource @testParams
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

                Mock -CommandName Get-PnPStorageEntity -MockWith {
                    return @{
                        Key         = 'DSCKey'
                        Value       = 'Test storage entity'
                        EntityScope = 'Site'
                        Description = 'Description created by DSC'
                        Comment     = 'Comment from DSC'
                        Ensure      = 'Present'
                        SiteUrl     = 'https://contoso-admin.sharepoint.com'
                        Credential  = $Credential
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
