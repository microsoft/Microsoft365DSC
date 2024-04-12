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
    -DscResource 'SCAutoSensitivityLabelPolicy' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'test@password1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Import-PSSession -MockWith {
            }

            Mock -CommandName New-PSSession -MockWith {
            }

            Mock -CommandName Remove-AutoSensitivityLabelPolicy -MockWith {
            }

            Mock -CommandName New-AutoSensitivityLabelPolicy -MockWith {
                return @{

                }
            }

            Mock -CommandName Set-AutoSensitivityLabelPolicy -MockWith {
                return @{

                }
            }

            Mock -CommandName Start-Sleep -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "Policy doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    ApplySensitivityLabel = 'TopSecret'
                    Comment               = 'Test'
                    Credential            = $Credential
                    Ensure                = 'Present'
                    ExchangeLocation      = @('All')
                    Mode                  = 'Enable'
                    Name                  = 'TestPolicy'
                    Priority              = 0
                }

                Mock -CommandName Get-AutoSensitivityLabelPolicy -MockWith {
                    return $null
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should return Absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName New-AutoSensitivityLabelPolicy -Exactly 1
            }
        }

        Context -Name 'Policy already exists and is NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    ApplySensitivityLabel = 'TopSecret'
                    Comment               = 'Test'
                    Credential            = $Credential
                    Ensure                = 'Present'
                    ExchangeLocation      = @('All')
                    Mode                  = 'Enable'
                    Name                  = 'TestPolicy'
                    Priority              = 0
                }

                Mock -CommandName Get-AutoSensitivityLabelPolicy -MockWith {
                    return @{
                        ApplySensitivityLabel = 'TopSecret'
                        Comment               = 'Test'
                        ExchangeLocation      = @('All')
                        Mode                  = 'TestWithoutNotifications'; #Drift
                        Name                  = 'TestPolicy'
                        Priority              = 0
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should return update from the Set method' {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName Set-AutoSensitivityLabelPolicy -Exactly 1
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name 'Policy already exists and is in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    ApplySensitivityLabel = 'TopSecret'
                    Comment               = 'Test'
                    Credential            = $Credential
                    Ensure                = 'Present'
                    ExchangeLocation      = @('All')
                    Mode                  = 'Enable'
                    Name                  = 'TestPolicy'
                    Priority              = 0
                }

                Mock -CommandName Get-AutoSensitivityLabelPolicy -MockWith {
                    return @{
                        ApplySensitivityLabel = 'TopSecret'
                        Comment               = 'Test'
                        ExchangeLocation      = @('All')
                        Mode                  = 'Enable'
                        Name                  = 'TestPolicy'
                        Priority              = 0
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

        }

        Context -Name 'Policy should not exist' -Fixture {
            BeforeAll {
                $testParams = @{
                    ApplySensitivityLabel = 'TopSecret'
                    Comment               = 'Test'
                    Credential            = $Credential
                    Ensure                = 'Absent'
                    ExchangeLocation      = @('All')
                    Mode                  = 'Enable'
                    Name                  = 'TestPolicy'
                    Priority              = 0
                }

                Mock -CommandName Get-AutoSensitivityLabelPolicy -MockWith {
                    return @{
                        ApplySensitivityLabel = 'TopSecret'
                        Comment               = 'Test'
                        ExchangeLocation      = @('All')
                        Mode                  = 'Enable'
                        Name                  = 'TestPolicy'
                        Priority              = 0
                    }
                }
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove update from the Set method' {
                Set-TargetResource @testParams
                Assert-MockCalled -CommandName Remove-AutoSensitivityLabelPolicy -Exactly 1
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }
                Mock -CommandName Get-AutoSensitivityLabelPolicy -MockWith {
                    return @{
                        ApplySensitivityLabel = 'TopSecret'
                        Comment               = 'Test'
                        ExchangeLocation      = @('All')
                        Mode                  = 'Enable'
                        Name                  = 'TestPolicy'
                        Priority              = 0
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
