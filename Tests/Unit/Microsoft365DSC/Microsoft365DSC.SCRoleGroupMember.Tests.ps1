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
    -DscResource 'SCRoleGroupMember' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            $Global:PartialExportFileName = 'c:\TestPath'

            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Get-RoleGroup -MockWith {
            }

            Mock -CommandName Get-RoleGroupMember -MockWith {
            }

            Mock -CommandName Add-RoleGroupMember -MockWith {
            }

            Mock -CommandName Remove-RoleGroupMember -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name 'Role Group member mismatch, missing member, need to add' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name        = 'Contoso Role Group'
                    Members     = 'Group1', 'User1'
                    Description = 'This is the Contoso Role Group'
                    Ensure      = 'Present'
                    Credential  = $Credential
                }

                Mock -CommandName Get-RoleGroup -MockWith {
                    return @{
                        Name        = 'Contoso Role Group'
                        Members     = 'Group1'
                        Description = 'This is the Contoso Role Group'
                    }
                }
                Mock -Command Get-RoleGroupMember -parameterFilter { $name -eq 'Contoso Role Group'}  -MockWith {
                    [PSCustomObject]@{Name = 'Group1'}
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Add-RoleGroupMember method' {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName Add-RoleGroupMember -Exactly 1
            }
        }

        Context -Name 'Role Group member mismatch, additional members, need to remove one' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name        = 'Contoso Role Group'
                    Members     = 'Group1', 'User1', 'User3'
                    Description = 'This is the Contoso Role Group'
                    Ensure      = 'Present'
                    Credential  = $Credential
                }

                Mock -CommandName Get-RoleGroup -MockWith {
                    return @{
                        Name        = 'Contoso Role Group'
                        Members     = 'Group1', 'User1', 'User2', 'User3'
                        Description = 'This is the Contoso Role Group'
                    }
                }
                Mock -Command Get-RoleGroupMember -parameterFilter { $name -eq 'Contoso Role Group'}  -MockWith {
                    [PSCustomObject]@{Name = 'Group1' }, [PSCustomObject]@{Name = 'User1' }, [PSCustomObject]@{Name = 'User2' }, [PSCustomObject]@{Name = 'User3' }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Remove-RoleGroupMember method' {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName Remove-RoleGroupMember -Exactly 1
            }
        }

        Context -Name 'Configuration set as absent, need to remove all members declared in the configuration' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name        = 'Contoso Role Group'
                    Members     = 'Group1', 'User1', 'User2'
                    Description = 'This is the Contoso Role Group'
                    Ensure      = 'Absent'
                    Credential  = $Credential
                }

                Mock -CommandName Get-RoleGroup -MockWith {
                    return @{
                        Name        = 'Contoso Role Group'
                        Members     = 'Group1', 'User1', 'User2'
                        Description = 'This is the Contoso Role Group'
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Remove-RoleGroupMember method' {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName Remove-RoleGroupMember -Exactly 3
            }
        }

        Context -Name 'Configuration is correct, nothing to do' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name        = 'Contoso Role Group'
                    Members     = 'Group1', 'User1', 'User2'
                    Description = 'This is the Contoso Role Group'
                    Ensure      = 'Present'
                    Credential  = $Credential
                }

                Mock -CommandName Get-RoleGroup -MockWith {
                    return @{
                        Name        = 'Contoso Role Group'
                        Members     = 'Group1', 'User1', 'User2'
                        Description = 'This is the Contoso Role Group'
                    }
                }

                Mock -CommandName Get-RoleGroupMember -MockWith {
                    return @{
                        Name = @('Group1','User1','User2')
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                $RoleGroup = @{
                    Name = 'Contoso Role Group'
                    Members     = 'Group1', 'User1', 'User2'
                    Description = 'This is the Contoso Role Group'
                }

                Mock -CommandName Get-RoleGroup -MockWith {
                    return @{
                        Name        = 'Contoso Role Group'
                        Members     = 'Group1', 'User1', 'User2'
                        Description = 'This is the Contoso Role Group'
                    }
                }
                Mock -Command Get-RoleGroupMember -parameterFilter { $name -eq 'Contoso Role Group'}  -MockWith {
                    [PSCustomObject]@{Name = 'Group1' }, [PSCustomObject]@{Name = 'User1' }, [PSCustomObject]@{Name = 'User2' }
                }
            }

            It 'Should Reverse Engineer resource from the Export method when single' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
            # Remove the unnecessary closing brace
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
