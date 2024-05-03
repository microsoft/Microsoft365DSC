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
    -DscResource 'SPOSiteGroup' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString ((New-Guid).ToString()) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Set-PnPGroupPermissions -MockWith {
            }

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Get-PnPTenantSite -MockWith {
                return @{
                    URL = 'https://contoso.sharepoint.com/sites/TestSite'
                }
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'SiteGroup does not exist ' -Fixture {
            BeforeAll {
                $testParams = @{
                    URL              = 'https://contoso.sharepoint.com/sites/TestSite'
                    Identity         = 'TestSiteGroup'
                    Owner            = 'admin@Office365DSC.onmicrosoft.com'
                    PermissionLevels = @('Edit', 'Read')
                    Ensure           = 'Present'
                    Credential       = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-PnPTenantSite -MockWith {
                    return $null
                }

                Mock -CommandName Get-PnPGroup -MockWith {
                    return $null
                }

                Mock -CommandName Set-PnPGroup -MockWith {
                    return $null
                }

                Mock -CommandName New-PnPGroup -MockWith {
                    return $null
                }

                Mock -CommandName Remove-PnPGroup -MockWith {
                    return $null
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Adds the SPOSiteGroup in the Set method' {
                Set-TargetResource @testParams
            }
        }

        Context -Name 'SiteGroup exists but is not in the desired state (PermissionLevel missing)' -Fixture {
            BeforeAll {
                $testParams = @{
                    URL              = 'https://contoso.sharepoint.com/sites/TestSite'
                    Identity         = 'TestSiteGroup'
                    Owner            = 'admin@Office365DSC.onmicrosoft.com'
                    PermissionLevels = @('Edit', 'Read')
                    Ensure           = 'Present'
                    Credential       = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-PnPTenantSite -MockWith {
                    return @{
                        Url = 'https://contoso.sharepoint.com/sites/TestSite'
                    }
                }

                Mock -CommandName Get-PnPGroup -MockWith {
                    return @{
                        URL   = 'https://contoso.sharepoint.com/sites/TestSite'
                        Title = 'TestSiteGroup'
                        Owner = @{
                            LoginName = 'admin@Office365DSC.onmicrosoft.com'
                        }
                    }
                }

                Mock -CommandName Get-PnPGroupPermissions -MockWith {
                    return @{
                        Name = 'Contribute'
                    }
                }

                Mock -CommandName Set-PnPGroup -MockWith {
                }

                Mock -CommandName New-PnPGroup -MockWith {
                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Updates the site group in the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-PnPGroup -Exactly 1
                Should -Invoke -CommandName New-PnPGroup -Exactly 0
            }

        }

        Context -Name 'SiteGroup exists and is in the desired state ' -Fixture {
            BeforeAll {
                $testParams = @{
                    URL              = 'https://contoso.sharepoint.com/sites/TestSite'
                    Identity         = 'TestSiteGroup'
                    Owner            = 'admin@Office365DSC.onmicrosoft.com'
                    PermissionLevels = @('Edit', 'Read')
                    Ensure           = 'Present'
                    Credential       = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-PnPGroup -MockWith {
                    return @{
                        URL   = 'https://contoso.sharepoint.com/sites/TestSite'
                        Title = 'TestSiteGroup'
                        Owner = @{
                            LoginName = 'admin@Office365DSC.onmicrosoft.com'
                        }
                    }
                }

                Mock -CommandName Get-PnPGroupPermissions -MockWith {
                    return @(@{
                            Name = 'Edit'
                        },
                        @{
                            Name = 'Read'
                        }
                    )
                }

                Mock -CommandName Set-PnPGroup -MockWith {
                }

                Mock -CommandName New-PnPGroup -MockWith {
                }

                Mock -CommandName Remove-PnPGroup -MockWith {
                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should not update site group in the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-PnPGroup -Exactly 0
                Should -Invoke -CommandName Remove-PnPGroup -Exactly 0
            }
        }

        Context -Name 'SiteGroup exists but should not exist' -Fixture {
            BeforeAll {
                $testParams = @{
                    URL              = 'https://contoso.sharepoint.com/sites/TestSite'
                    Identity         = 'TestSiteGroup'
                    Owner            = 'admin@Office365DSC.onmicrosoft.com'
                    PermissionLevels = @('Edit', 'Read')
                    Ensure           = 'Absent'
                    Credential       = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-PnPGroup -MockWith {
                    return @{
                        URL        = 'https://contoso.sharepoint.com/sites/TestSite'
                        Title      = 'TestSiteGroup'
                        OwnerLogin = 'admin@Office365DSC.onmicrosoft.com'
                        Roles      = @('Edit', 'Read')
                    }
                }

                Mock -CommandName Get-PnPGroupPermissions -MockWith {
                    return @(@{
                            Name = 'Edit'
                        },
                        @{
                            Name = 'Read'
                        }
                    )
                }

                Mock -CommandName Set-PnPGroup -MockWith {
                }

                Mock -CommandName New-PnPGroup -MockWith {
                }

                Mock -CommandName Remove-PnPGroup -MockWith {
                }
            }

            It 'Should return present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the site group' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-PnPGroup -Exactly 0
                Should -Invoke -CommandName New-PnPGroup -Exactly 0
                Should -Invoke -CommandName Remove-PnPGroup -Exactly 1
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

                Mock -CommandName Get-PnPTenantSite -MockWith {
                    return @{
                        Url = 'https://contoso.sharepoint.com'
                    }
                }

                Mock -CommandName Get-PnPGroup -MockWith {
                    return @{
                        URL        = 'https://contoso.sharepoint.com/sites/TestSite'
                        Title      = 'TestSiteGroup'
                        OwnerLogin = 'admin@Office365DSC.onmicrosoft.com'
                        Roles      = @('Edit', 'Read')
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
