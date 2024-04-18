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
    -DscResource 'TeamsTemplatesPolicy' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'Pass@word1)' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            $Global:PartialExportFileName = 'c:\TestPath'

            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName New-CsTeamsTemplatePermissionPolicy -MockWith {
            }

            Mock -CommandName Set-CsTeamsTemplatePermissionPolicy -MockWith {
            }

            Mock -CommandName Remove-CsTeamsTemplatePermissionPolicy -MockWith {
            }

            Mock -CommandName New-CsTeamsHiddenTemplate -MockWith{
            }

            Mock -CommandName Get-CsTeamTemplateList -MockWith {
                return @{
                    Name = 'Manage a Project'
                    Id = '12345-12345-12345-12345-12345'
                }
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "When Templates Policy doesn't exist but should" -Fixture {
            BeforeAll {
                $testParams = @{
                    Description          = "Test Policy Creation";
                    Ensure               = "Present";
                    HiddenTemplates      = @("Manage a Project","Manage an Event","Adopt Office 365","Organize Help Desk");
                    Identity             = "DSC Test";
                    Credential           = $Credential
                }

                Mock -CommandName Get-CsTeamsTemplatePermissionPolicy -MockWith {
                    return $null
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create the policy in the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-CsTeamsTemplatePermissionPolicy -Exactly 1
            }
        }

        Context -Name 'Policy exists but is not in the Desired State' -Fixture {
            BeforeAll {

                $testParams = @{
                    Description          = "Test Policy Creation";
                    Ensure               = "Present";
                    HiddenTemplates      = @("Manage a Project","Manage an Event","Adopt Office 365","Organize Help Desk");
                    Identity             = "DSC Test";
                    Credential           = $Credential
                }

                Mock -CommandName Get-CsTeamsTemplatePermissionPolicy -MockWith {
                    return @{
                        Description          = "Test Policy Creation";
                        HiddenTemplates      = @(@{
                            Id = "12345-12345-12345-12345-12345"
                            Name = 'Manage a Project'
                        }); # Drift
                        Identity             = "DSC Test";
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update the settings from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-CsTeamsTemplatePermissionPolicy -Exactly 1
            }
        }

        Context -Name 'Policy exists and is already in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description          = "Test Policy Creation";
                    Ensure               = "Present";
                    HiddenTemplates      = @("Manage a Project");
                    Identity             = "DSC Test";
                    Credential           = $Credential
                }

                Mock -CommandName Get-CsTeamsTemplatePermissionPolicy -MockWith {
                    return @{
                        Description          = "Test Policy Creation";
                        HiddenTemplates      = @(@{
                            Id = "12345-12345-12345-12345-12345"
                            Name = 'Manage a Project'
                        });
                        Identity             = "DSC Test";
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'Policy exists but it should not' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description          = "Test Policy Creation";
                    Ensure               = "Absent";
                    HiddenTemplates      = @("Manage a Project");
                    Identity             = "DSC Test";
                    Credential           = $Credential
                }

                Mock -CommandName Get-CsTeamsTemplatePermissionPolicy -MockWith {
                    return @{
                        Description          = "Test Policy Creation";
                        HiddenTemplates      = @(@{
                            Id = "12345-12345-12345-12345-12345"
                            Name = 'Manage a Project'
                        });
                        Identity             = "DSC Test";
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Shouldremove the policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-CsTeamsTemplatePermissionPolicy -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }
                Mock -CommandName Get-CsTeamsTemplatePermissionPolicy -MockWith {
                    return @{
                        Description          = "Test Policy Creation";
                        HiddenTemplates      = @(@{
                            Id = "12345-12345-12345-12345-12345"
                            Name = 'Manage a Project'
                        });
                        Identity             = "DSC Test";
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
