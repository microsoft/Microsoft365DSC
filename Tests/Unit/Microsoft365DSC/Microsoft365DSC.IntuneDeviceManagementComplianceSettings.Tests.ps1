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
    -DscResource 'IntuneDeviceManagementComplianceSettings' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString ((New-Guid).ToString()) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Update-MgBetaDeviceManagement -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }

            Mock -CommandName Write-Verbose -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "The settings are already in the desired state." -Fixture {
            BeforeAll {
                $testParams = @{
                    DeviceComplianceCheckinThresholdDays = 22;
                    IsSingleInstance                     = "Yes";
                    SecureByDefault                      = $True;
                    Credential                           = $Credential
                }

                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                    return @{
                        deviceComplianceCheckinThresholdDays = 22
                        secureByDefault = $true
                    }
                }
            }

            It 'Should return Yes from the Get method' {
                    (Get-TargetResource @testParams).IsSingleInstance | Should -Be 'Yes'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The settings are NOT in the desired state." -Fixture {
            BeforeAll {
                $testParams = @{
                    DeviceComplianceCheckinThresholdDays = 40; #Drift
                    IsSingleInstance                     = "Yes";
                    SecureByDefault                      = $True;
                    Credential                           = $Credential
                }

                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                    return @{
                        deviceComplianceCheckinThresholdDays = 22
                        secureByDefault = $true
                    }
                }
            }

            It 'Should return Yes from the Get method' {
                    (Get-TargetResource @testParams).IsSingleInstance | Should -Be 'Yes'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Update cmdlet from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgBetaDeviceManagement -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"

                $testParams = @{
                    Credential                           = $Credential
                }

                Mock -CommandName Invoke-MgGraphRequest -MockWith {
                    return @{
                        deviceComplianceCheckinThresholdDays = 22
                        secureByDefault = $true
                    }
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams -Verbose
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
