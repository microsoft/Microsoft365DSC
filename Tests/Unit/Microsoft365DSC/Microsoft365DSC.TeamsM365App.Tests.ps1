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
    -DscResource 'TeamsM365App' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString ((New-Guid).ToString()) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            $Global:PartialExportFileName = 'c:\TestPath'

            Mock -CommandName Save-M365DSCPartialExport -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Update-M365TeamsApp -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "The instance is already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AssignmentType       = "UsersAndGroups";
                    Groups               = @("Finance Team");
                    Id                   = "95de633a-083e-42f5-b444-a4295d8e9314";
                    IsBlocked            = $False;
                    Users                = @();
                    Credential = $Credential
                }

                Mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        DisplayName = "Finance Team"
                        Id = "12345-12345-12345-12345-12345"
                    }
                }

                Mock -CommandName Get-M365TeamsApp -MockWith {
                    return @{
                        IsBlocked = $false
                        AvailableTo = @{
                            AssignmentType = "UsersAndGroups"
                            Groups = @("12345-12345-12345-12345-12345")
                        }
                        Id = "95de633a-083e-42f5-b444-a4295d8e9314"
                    }
                }
            }

            It 'Should return true from the Test method' {
                [boolean] $result = Test-TargetResource @testParams
                $result | Should -Be $true
            }
        }

        Context -Name "The instance is NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AssignmentType       = "UsersAndGroups";
                    Groups               = @();
                    Id                   = "95de633a-083e-42f5-b444-a4295d8e9314";
                    IsBlocked            = $False;
                    Users                = @("john.smith@contoso.com");
                    Credential           = $Credential
                }

                Mock -CommandName Get-MgUser -MockWith {
                    return @{
                        UserPrincipalName = "john.smith@contoso.com"
                        Id = "12345-12345-12345-12345-12345"
                    }
                }
                Mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        DisplayName = "Finance Team"
                        Id = "12345-12345-12345-12345-12345"
                    }
                }

                Mock -CommandName Get-M365TeamsApp -MockWith {
                    return @{
                        IsBlocked = $false
                        AvailableTo = @{
                            AssignmentType = "UsersAndGroups"
                            Groups = @("12345-12345-12345-12345-12345")
                        }
                        Id = "95de633a-083e-42f5-b444-a4295d8e9314"
                    }
                }
            }

            It 'Should return false from the Test method' {
                [boolean] $result = Test-TargetResource @testParams
                $result | Should -Be $false
            }

            It 'Update the instance in the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-M365TeamsApp -Exactly 2
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-AllM365TeamsApps -MockWith {
                    return @{
                        IsBlocked = $false
                        AvailableTo = @{
                            AssignmentType = "UsersAndGroups"
                            Groups = @("12345-12345-12345-12345-12345")
                        }
                        Id = "95de633a-083e-42f5-b444-a4295d8e9314"
                    }
                }
                Mock -CommandName Get-M365TeamsApp -MockWith {
                    return @{
                        IsBlocked = $false
                        AvailableTo = @{
                            AssignmentType = "UsersAndGroups"
                            Groups = @("12345-12345-12345-12345-12345")
                        }
                        Id = "95de633a-083e-42f5-b444-a4295d8e9314"
                    }
                }
                Mock -CommandName Get-MgGroup -MockWith {
                    return @{
                        DisplayName = "Finance Team"
                        Id = "12345-12345-12345-12345-12345"
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
