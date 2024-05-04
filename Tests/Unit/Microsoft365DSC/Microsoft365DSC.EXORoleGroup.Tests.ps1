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
    -DscResource 'EXORoleGroup' -GenericStubModule $GenericStubPath
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

            Mock -CommandName New-RoleGroup -MockWith {
            }

            Mock -CommandName Get-RoleGroupMember -MockWith {
            }

            Mock -CommandName Update-RoleGroupMember -MockWith {
            }

            Mock -CommandName Remove-RoleGroup -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'Role Group should exist. Role Group is missing. Test should fail.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name        = 'Contoso Role Group'
                    Members     = 'Exchange Administrator'
                    Roles       = 'Address Lists'
                    Description = 'This is the Contoso Role Group'
                    Ensure      = 'Present'
                    Credential  = $Credential
                }

            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName New-RoleGroup -Exactly 1
            }
        }

        Context -Name 'Role Group should exist. Role Group exists. Test should pass.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name        = 'Contoso Role Group'
                    Members     = 'Exchange Administrator'
                    Roles       = 'Address Lists'
                    Description = 'This is the Contoso Role Group'
                    Ensure      = 'Present'
                    Credential  = $Credential
                }

                Mock -CommandName Get-RoleGroup -MockWith {
                    return @{
                        Name        = 'Contoso Role Group'
                        Members     = 'Exchange Administrator'
                        Roles       = 'Address Lists'
                        Description = 'This is the Contoso Role Group'
                    }
                }

                Mock -Command Get-RoleGroupMember -parameterFilter { $name -eq 'Contoso Role Group'}  -MockWith {
                    [PSCustomObject]@{Displayname = 'Exchange Administrator'}
                }

            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should return Present from the Get Method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name 'Role Group should exist. Role Group exists, Members mismatch. Test should fail.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name        = 'Contoso Role Group'
                    Members     = 'Exchange Administrator'
                    Roles       = 'Address Lists'
                    Description = 'This is the Contoso Role Group'
                    Ensure      = 'Present'
                    Credential  = $Credential
                }
                Mock -CommandName Get-RoleGroup -MockWith {
                    return @{
                        Name        = 'Contoso Role Group'
                        Members     = 'Drift Administrator'
                        Roles       = 'Address Lists'
                        Description = 'This is the Contoso Role Group'
                    }
                }

                Mock -Command Get-RoleGroupMember -MockWith {
                    [PSCustomObject]@{Displayname = 'Drift Administrator'}
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should return Present from the Get Method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should call the Update Members method' {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName Update-RoleGroupMember -Exactly 1
            }
        }
        Context -Name 'Role Group exists and it SHOULD NOT.' -Fixture {
            BeforeAll {
                $testParams = @{
                    Name        = 'Contoso Role Group'
                    Members     = 'Exchange Administrator'
                    Roles       = 'Address Lists'
                    Description = 'This is the Contoso Role Group'
                    Ensure      = 'Absent'
                    Credential  = $Credential
                }
                Mock -CommandName Get-RoleGroup -MockWith {
                    return @{
                        Name        = 'Contoso Role Group'
                        Members     = 'Exchange Administrator'
                        Roles       = 'Address Lists'
                        Description = 'This is the Contoso Role Group'
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should return Present from the Get Method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName Remove-RoleGroup -Exactly 1
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
                    Name        = 'Contoso Role Group'
                }

                Mock -CommandName Get-RoleGroup -MockWith {
                    return @{
                        Name             = 'Contoso Role Group'
                        Members          = 'Exchange Administrator'
                        Roles            = 'Address Lists'
                        Description      = 'This is the Contoso Role Group'
                    }
                }
            }

            It 'Should Reverse Engineer resource from the Export method when single' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
