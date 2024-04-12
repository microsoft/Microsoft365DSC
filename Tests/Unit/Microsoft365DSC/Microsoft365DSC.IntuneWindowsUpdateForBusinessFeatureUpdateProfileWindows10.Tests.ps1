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
    -DscResource 'IntuneWindowsUpdateForBusinessFeatureUpdateProfileWindows10' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString 'f@kepassword1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Update-MgBetaDeviceManagementWindowsFeatureUpdateProfile -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementWindowsFeatureUpdateProfile -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceManagementWindowsFeatureUpdateProfile -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Get-MgBetaDeviceManagementWindowsFeatureUpdateProfileAssignment -MockWith {
            }
            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }
            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }
        # Test contexts
        Context -Name 'The IntuneWindowsUpdateForBusinessFeatureUpdateProfileWindows10 should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description          = 'FakeStringValue'
                    DisplayName          = 'FakeStringValue'
                    FeatureUpdateVersion = 'FakeStringValue'
                    Id                   = 'FakeStringValue'
                    RolloutSettings      = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsUpdateRolloutSettings -Property @{
                            OfferEndDateTimeInUTC   = '2023-01-01T00:00:00.0000000+00:00'
                            OfferStartDateTimeInUTC = '2023-01-01T00:00:00.0000000+00:00'
                            OfferIntervalInDays     = 25
                        } -ClientOnly)
                    Ensure               = 'Present'
                    Credential           = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementWindowsFeatureUpdateProfile -MockWith {
                    return $null
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Create the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgBetaDeviceManagementWindowsFeatureUpdateProfile -Exactly 1
            }
        }

        Context -Name 'The IntuneWindowsUpdateForBusinessFeatureUpdateProfileWindows10 exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description          = 'FakeStringValue'
                    DisplayName          = 'FakeStringValue'
                    FeatureUpdateVersion = 'FakeStringValue'
                    Id                   = 'FakeStringValue'
                    RolloutSettings      = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsUpdateRolloutSettings -Property @{
                            OfferEndDateTimeInUTC   = '2023-01-01T00:00:00.0000000+00:00'
                            OfferStartDateTimeInUTC = '2023-01-01T00:00:00.0000000+00:00'
                            OfferIntervalInDays     = 25
                        } -ClientOnly)
                    Ensure               = 'Absent'
                    Credential           = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementWindowsFeatureUpdateProfile -MockWith {
                    return @{
                        AdditionalProperties = @{
                            '@odata.type' = '#microsoft.graph.WindowsFeatureUpdateProfile'
                        }
                        Description          = 'FakeStringValue'
                        DisplayName          = 'FakeStringValue'
                        FeatureUpdateVersion = 'FakeStringValue'
                        Id                   = 'FakeStringValue'
                        RolloutSettings      = @{
                            OfferEndDateTimeInUTC   = '2023-01-01T00:00:00.0000000+00:00'
                            OfferStartDateTimeInUTC = '2023-01-01T00:00:00.0000000+00:00'
                            OfferIntervalInDays     = 25
                        }

                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementWindowsFeatureUpdateProfile -Exactly 1
            }
        }
        Context -Name 'The IntuneWindowsUpdateForBusinessFeatureUpdateProfileWindows10 Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description          = 'FakeStringValue'
                    DisplayName          = 'FakeStringValue'
                    FeatureUpdateVersion = 'FakeStringValue'
                    Id                   = 'FakeStringValue'
                    RolloutSettings      = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsUpdateRolloutSettings -Property @{
                            OfferEndDateTimeInUTC   = '2023-01-01T00:00:00.0000000+00:00'
                            OfferStartDateTimeInUTC = '2023-01-01T00:00:00.0000000+00:00'
                            OfferIntervalInDays     = 25
                        } -ClientOnly)
                    Ensure               = 'Present'
                    Credential           = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementWindowsFeatureUpdateProfile -MockWith {
                    return @{
                        AdditionalProperties = @{
                            '@odata.type' = '#microsoft.graph.WindowsFeatureUpdateProfile'
                        }
                        Description          = 'FakeStringValue'
                        DisplayName          = 'FakeStringValue'
                        FeatureUpdateVersion = 'FakeStringValue'
                        Id                   = 'FakeStringValue'
                        RolloutSettings      = @{
                            OfferEndDateTimeInUTC   = '2023-01-01T00:00:00.0000000+00:00'
                            OfferStartDateTimeInUTC = '2023-01-01T00:00:00.0000000+00:00'
                            OfferIntervalInDays     = 25
                        }

                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'The IntuneWindowsUpdateForBusinessFeatureUpdateProfileWindows10 exists and values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Description          = 'FakeStringValue'
                    DisplayName          = 'FakeStringValue'
                    FeatureUpdateVersion = 'FakeStringValue'
                    Id                   = 'FakeStringValue'
                    RolloutSettings      = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsUpdateRolloutSettings -Property @{
                            OfferEndDateTimeInUTC   = '2023-01-01T00:00:00.0000000+00:00'
                            OfferStartDateTimeInUTC = '2023-01-01T00:00:00.0000000+00:00'
                            OfferIntervalInDays     = 25
                        } -ClientOnly)
                    Ensure               = 'Present'
                    Credential           = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementWindowsFeatureUpdateProfile -MockWith {
                    return @{
                        Description          = 'FakeStringValue'
                        DisplayName          = 'FakeStringValue'
                        FeatureUpdateVersion = 'FakeStringValue'
                        Id                   = 'FakeStringValue'
                        RolloutSettings      = @{
                            OfferEndDateTimeInUTC   = '2023-01-01T00:00:00.0000000+00:00'
                            OfferStartDateTimeInUTC = '2023-01-01T00:00:00.0000000+00:00'
                            OfferIntervalInDays     = 7
                        }
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
                Should -Invoke -CommandName Update-MgBetaDeviceManagementWindowsFeatureUpdateProfile -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementWindowsFeatureUpdateProfile -MockWith {
                    return @{
                        AdditionalProperties = @{
                            '@odata.type' = '#microsoft.graph.WindowsFeatureUpdateProfile'
                        }
                        Description          = 'FakeStringValue'
                        DisplayName          = 'FakeStringValue'
                        FeatureUpdateVersion = 'FakeStringValue'
                        Id                   = 'FakeStringValue'
                        RolloutSettings      = @{
                            OfferEndDateTimeInUTC   = '2023-01-01T00:00:00.0000000+00:00'
                            OfferStartDateTimeInUTC = '2023-01-01T00:00:00.0000000+00:00'
                            OfferIntervalInDays     = 25
                        }

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
