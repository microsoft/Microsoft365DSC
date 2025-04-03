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

$CurrentScriptPath = $PSCommandPath.Split('\')
$CurrentScriptName = $CurrentScriptPath[$CurrentScriptPath.Length -1]
$ResourceName      = $CurrentScriptName.Split('.')[1]
$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource $ResourceName -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            Mock -CommandName Get-MgGroup -MockWith {
                return @{
                    DisplayName = "MyGroup"
                    Id = "12345"
                }
            }

            # Mock Write-M365DSCHost to hide output during the tests
            Mock -CommandName Write-M365DSCHost -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }
        # Test contexts
        Context -Name "The instance should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    SpaceName           = "Test"
                    GroupName           = "MyGroup"
                    Ensure              = 'Present'
                    Credential          = $Credential;
                }

                Mock -CommandName Invoke-M365DSCServicesHubWebRequest -MockWith {
                    return $null
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create a new instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Invoke-M365DSCServicesHubWebRequest -Exactly 3
            }
        }

        Context -Name "The instance exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    SpaceName           = "Test"
                    GroupName           = "MyGroup"
                    Ensure              = 'Absent'
                    Credential          = $Credential;
                }

                Mock -CommandName Invoke-M365DSCServicesHubWebRequest -MockWith {
                    return @{
                        value = @(
                            @{
                                groupName = "MyGroup"
                                name      = "Test"
                            }
                        )
                    }
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Invoke-M365DSCServicesHubWebRequest -Exactly 5
            }
        }

        Context -Name "The instance exists and values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    SpaceName           = "Test"
                    GroupName           = "MyGroup"
                    Roles               = @("Role1", "Role2")
                    Ensure              = 'Present'
                    Credential          = $Credential;
                }

                Mock -CommandName Invoke-M365DSCServicesHubWebRequest -MockWith {
                    return @{
                        value = @(
                            @{
                                groupName = "MyGroup"
                                roles     = @("Role1", "Role2")
                                name      = "Test"
                            }
                        )
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The instance exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    SpaceName           = "Test"
                    GroupName           = "MyGroup"
                    Roles               = @("Role1", "Role2")
                    Ensure              = 'Absent'
                    Credential          = $Credential;
                }

                Mock -CommandName Invoke-M365DSCServicesHubWebRequest -MockWith {
                    return @{
                        value = @(
                            @{
                                groupName = "MyGroup"
                                roles     = @("Role1") # Drift
                                name      = "Test"
                            }
                        )
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
                Should -Invoke -CommandName Invoke-M365DSCServicesHubWebRequest -Exactly 5
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential          = $Credential;
                }

                Mock -CommandName Invoke-M365DSCServicesHubWebRequest -MockWith {
                    return @{
                        value = @(
                            @{
                                groupName = "MyGroup"
                                roles     = @("Role1")
                                name      = "Test"
                            }
                        )
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
