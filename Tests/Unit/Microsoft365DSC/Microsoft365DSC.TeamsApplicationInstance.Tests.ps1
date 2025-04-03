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

            Mock -CommandName New-CsOnlineApplicationInstance -MockWith {
            }

            Mock -CommandName Set-CsOnlineApplicationInstance -MockWith {
            }

            # Mock Write-M365DSCHost to hide output during the tests
            Mock -CommandName Write-M365DSCHost -MockWith {
            }
            $Script:exportedInstances = $null
            $Script:ExportMode = $false
        }
        # Test contexts
        Context -Name "The instance should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName         = 'john.smith@contoso.com'
                    UserPrincipalName   = 'john.smith@contoso.com'
                    ResourceAccountType = 'AutoAttendant'
                    Ensure              = 'Present'
                    Credential          = $Credential;
                }

                Mock -CommandName Get-CsOnlineApplicationInstance -MockWith {
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
                Should -Invoke -CommandName New-CsOnlineApplicationInstance -Exactly 1
            }
        }

        Context -Name "The instance exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName         = 'john.smith@contoso.com'
                    UserPrincipalName   = 'john.smith@contoso.com'
                    ResourceAccountType = 'AutoAttendant'
                    Ensure              = 'Absent'
                    Credential          = $Credential;
                }

                Mock -CommandName Get-CsOnlineApplicationInstance -MockWith {
                    return @{
                        DisplayName         = 'john.smith@contoso.com'
                        UserPrincipalName   = 'john.smith@contoso.com'
                        ApplicationId       = 'ce933385-9390-45d1-9512-c8d228074e07'
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
                {Set-TargetResource @testParams} | Should -Throw 'Resource instances of type {TeamsApplicationInstance} cannot be removed.'
            }
        }

        Context -Name "The instance exists and values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName         = 'john.smith@contoso.com'
                    UserPrincipalName   = 'john.smith@contoso.com'
                    ResourceAccountType = 'AutoAttendant'
                    Ensure              = 'Present'
                    Credential          = $Credential;
                }

                Mock -CommandName Get-CsOnlineApplicationInstance -MockWith {
                    return @{
                        DisplayName         = 'john.smith@contoso.com'
                        UserPrincipalName   = 'john.smith@contoso.com'
                        ApplicationId       = 'ce933385-9390-45d1-9512-c8d228074e07'
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
                    DisplayName         = 'john.smith@contoso.com'
                    UserPrincipalName   = 'john.smith@contoso.com'
                    ResourceAccountType = 'AutoAttendant'
                    Ensure              = 'Present'
                    Credential          = $Credential;
                }

                Mock -CommandName Get-CsOnlineApplicationInstance -MockWith {
                    return @{
                        DisplayName         = 'john.smith@contoso.com'
                        UserPrincipalName   = 'john.smith@contoso.com'
                        ApplicationId       = '11cd3e2e-fccb-42ad-ad00-878b93575e07' # Drift
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
                Should -Invoke -CommandName Set-CsOnlineApplicationInstance -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential  = $Credential;
                }

                Mock -CommandName Get-CsOnlineApplicationInstance -MockWith {
                    return @{
                        DisplayName         = 'john.smith@contoso.com'
                        UserPrincipalName   = 'john.smith@contoso.com'
                        ApplicationId       = '11cd3e2e-fccb-42ad-ad00-878b93575e07' # Drift
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
