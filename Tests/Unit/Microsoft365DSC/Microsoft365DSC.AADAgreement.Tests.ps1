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

            Mock -CommandName Get-MSCloudLoginConnectionProfile -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            # Mock Remove-M365DSCAuthenticationParameter to return hashtable without authentication parameters
            Mock -CommandName Remove-M365DSCAuthenticationParameter -MockWith {
                return $BoundParameters
            }

            # Mock Write-Host to prevent console output during tests
            Mock -CommandName Write-Host -MockWith {
            }

            # Mock Export-related functions
            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {
                return "AADAgreement 'TestAgreement' { Id = '12345-12345-12345-12345-12345'; DisplayName = 'Test'; }"
            }
            
            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return $Results
            }
            
            # Set global variables for export
            $Global:M365DSCEmojiGreenCheckMark = "[OK]"
            $Global:M365DSCEmojiRedX = "[ERROR]"
            $Global:M365DSCExportResourceInstancesCount = 0
            $Global:PartialExportFileName = "partial.ps1"
        }
        # Test contexts

        Context -Name "The instance exists and values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Id                               = '12345-12345-12345-12345-12345'
                    DisplayName                      = 'Terms of Use Agreement Test'
                    IsPerDeviceAcceptanceRequired    = $true
                    IsViewingBeforeAcceptanceRequired = $true
                    UserReacceptRequiredFrequency    = 'P30D'
                    Ensure                           = 'Present'
                    Credential                       = $Credential
                }

                Mock -CommandName Get-MgAgreement -MockWith {
                    return @{
                        Id                               = '12345-12345-12345-12345-12345'
                        DisplayName                      = 'Terms of Use Agreement Test'
                        IsPerDeviceAcceptanceRequired    = $true
                        IsViewingBeforeAcceptanceRequired = $true
                        UserReacceptRequiredFrequency    = 'P30D'
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The instance exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Id                               = '12345-12345-12345-12345-12345'
                    DisplayName                      = 'Terms of Use Agreement Test'
                    IsPerDeviceAcceptanceRequired    = $false
                    IsViewingBeforeAcceptanceRequired = $false
                    UserReacceptRequiredFrequency    = 'P60D'
                    Ensure                           = 'Present'
                    Credential                       = $Credential
                }

                Mock -CommandName Get-MgAgreement -MockWith {
                    return @{
                        Id                               = '12345-12345-12345-12345-12345'
                        DisplayName                      = 'Terms of Use Agreement Test'
                        IsPerDeviceAcceptanceRequired    = $true
                        IsViewingBeforeAcceptanceRequired = $true
                        UserReacceptRequiredFrequency    = 'P30D'
                    }
                }
                
                Mock -CommandName Update-MgAgreement -MockWith {
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
                Should -Invoke -CommandName Update-MgAgreement -Exactly 1
            }
        }

        Context -Name "The instance does not exist but it should" -Fixture {
            BeforeAll {
                $testParams = @{
                    Id                               = '12345-12345-12345-12345-12345'
                    DisplayName                      = 'Terms of Use Agreement Test'
                    IsPerDeviceAcceptanceRequired    = $true
                    IsViewingBeforeAcceptanceRequired = $true
                    UserReacceptRequiredFrequency    = 'P30D'
                    Ensure                           = 'Present'
                    Credential                       = $Credential
                }

                Mock -CommandName Get-MgAgreement -MockWith {
                    return $null
                }

                Mock -CommandName New-MgAgreement -MockWith {
                    return @{
                        Id = '12345-12345-12345-12345-12345'
                    }
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
                Should -Invoke -CommandName New-MgAgreement -Exactly 1
            }
        }

        Context -Name "The instance exists but it should not" -Fixture {
            BeforeAll {
                $testParams = @{
                    Id                               = '12345-12345-12345-12345-12345'
                    DisplayName                      = 'Terms of Use Agreement Test'
                    Ensure                           = 'Absent'
                    Credential                       = $Credential
                }

                Mock -CommandName Get-MgAgreement -MockWith {
                    return @{
                        Id                               = '12345-12345-12345-12345-12345'
                        DisplayName                      = 'Terms of Use Agreement Test'
                        IsPerDeviceAcceptanceRequired    = $true
                        IsViewingBeforeAcceptanceRequired = $true
                        UserReacceptRequiredFrequency    = 'P30D'
                    }
                }

                Mock -CommandName Remove-MgAgreement -MockWith {
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
                Should -Invoke -CommandName Remove-MgAgreement -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgAgreement -MockWith {
                    return @(
                        @{
                            Id                               = '12345-12345-12345-12345-12345'
                            DisplayName                      = 'Terms of Use Agreement Test'
                            IsPerDeviceAcceptanceRequired    = $true
                            IsViewingBeforeAcceptanceRequired = $true
                            UserReacceptRequiredFrequency    = 'P30D'
                        }
                    )
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}