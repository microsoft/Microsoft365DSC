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
    -DscResource 'IntuneDeviceEnrollmentStatusPageWindows10' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString 'f@kepassword1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {}

            Mock -CommandName Get-PSSession -MockWith {}

            Mock -CommandName Remove-PSSession -MockWith {}

            Mock -CommandName Update-MgBetaDeviceManagementDeviceEnrollmentConfiguration -MockWith {}

            Mock -CommandName Remove-MgBetaDeviceManagementDeviceEnrollmentConfiguration -MockWith {}

            Mock -CommandName Get-MgBetaDeviceAppManagementMobileApp -MockWith {
                return @{
                    DisplayName = 'FakeStringValue'
                }
            } -ParameterFilter { $MobileAppId }

            Mock -CommandName Get-MgBetaDeviceAppManagementMobileApp -MockWith {
                return @{
                    Id = 'FakeGuidValue'
                }
            } -ParameterFilter { $Filter}

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock Get-MgBetaDeviceManagementDeviceEnrollmentConfigurationAssignment {
                return @()
            }

            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {}

            Mock Update-DeviceEnrollmentConfigurationPriority {}

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'The IntuneDeviceEnrollmentStatusPageWindows10 should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    Id                                      = 'FakeStringValue'
                    DisplayName                             = 'EnrollmentSettings'
                    Description                             = 'Description of Enrollment settings'
                    ShowInstallationProgress                = $True
                    AllowDeviceResetOnInstallFailure        = $True
                    AllowDeviceUseOnInstallFailure          = $True
                    AllowLogCollectionOnInstallFailure      = $True
                    AllowNonBlockingAppInstallation         = $True
                    BlockDeviceSetupRetryByUser             = $True
                    CustomErrorMessage                      = 'This is a custom error'
                    DisableUserStatusTrackingAfterFirstUser = $True
                    InstallProgressTimeoutInMinutes         = 65
                    InstallQualityUpdates                   = $True
                    SelectedMobileAppIds                    = @()
                    TrackInstallProgressForAutopilotOnly    = $True
                    Ensure                                  = 'Present'
                    Credential                              = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceEnrollmentConfiguration -MockWith {
                    return $null
                }

                Mock -CommandName New-MgBetaDeviceManagementDeviceEnrollmentConfiguration -MockWith {
                    return  @{
                        Id       = 'FakeStringValue'
                        Priority = 1
                    }
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
                Should -Invoke -CommandName New-MgBetaDeviceManagementDeviceEnrollmentConfiguration -Exactly 1
            }
        }

        Context -Name 'The IntuneDeviceEnrollmentStatusPageWindows10 exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    Id                                      = 'FakeStringValue'
                    DisplayName                             = 'EnrollmentSettings'
                    Description                             = 'Description of Enrollment settings'
                    ShowInstallationProgress                = $True
                    AllowDeviceResetOnInstallFailure        = $True
                    AllowDeviceUseOnInstallFailure          = $True
                    AllowLogCollectionOnInstallFailure      = $True
                    AllowNonBlockingAppInstallation         = $True
                    BlockDeviceSetupRetryByUser             = $True
                    CustomErrorMessage                      = 'This is a custom error'
                    DisableUserStatusTrackingAfterFirstUser = $True
                    InstallProgressTimeoutInMinutes         = 65
                    InstallQualityUpdates                   = $True
                    SelectedMobileAppIds                    = @()
                    TrackInstallProgressForAutopilotOnly    = $True
                    Ensure                                  = 'Absent'
                    Credential                              = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceEnrollmentConfiguration -MockWith {
                    return @{
                        Id                   = 'FakeStringValue'
                        DisplayName          = 'FakeStringValue'
                        Description          = 'FakeStringValue'
                        AdditionalProperties = @{
                            trackInstallProgressForAutopilotOnly    = $True
                            '@odata.type'                           = '#microsoft.graph.windows10EnrollmentCompletionPageConfiguration'
                            disableUserStatusTrackingAfterFirstUser = $True
                            installQualityUpdates                   = $True
                            showInstallationProgress                = $True
                            selectedMobileAppIds                    = @('FakeGuidValue')
                            blockDeviceSetupRetryByUser             = $True
                            allowDeviceUseOnInstallFailure          = $True
                            customErrorMessage                      = 'FakeStringValue'
                            allowNonBlockingAppInstallation         = $True
                            allowLogCollectionOnInstallFailure      = $True
                            allowDeviceResetOnInstallFailure        = $True
                            installProgressTimeoutInMinutes         = 25
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
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementDeviceEnrollmentConfiguration -Exactly 1
            }
        }

        Context -Name 'The IntuneDeviceEnrollmentStatusPageWindows10 Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Id                                      = 'FakeStringValue'
                    DisplayName                             = 'FakeStringValue'
                    Description                             = 'FakeStringValue'
                    AllowDeviceResetOnInstallFailure        = $True
                    AllowDeviceUseOnInstallFailure          = $True
                    AllowLogCollectionOnInstallFailure      = $True
                    AllowNonBlockingAppInstallation         = $True
                    BlockDeviceSetupRetryByUser             = $True
                    CustomErrorMessage                      = 'FakeStringValue'
                    DisableUserStatusTrackingAfterFirstUser = $True
                    InstallProgressTimeoutInMinutes         = 25
                    InstallQualityUpdates                   = $True
                    SelectedMobileAppIds                    = @('FakeGuidValue')
                    ShowInstallationProgress                = $True
                    TrackInstallProgressForAutopilotOnly    = $True
                    Ensure                                  = 'Present'
                    Credential                              = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceEnrollmentConfiguration -MockWith {
                    return @{
                        Id                   = 'FakeStringValue'
                        DisplayName          = 'FakeStringValue'
                        Description          = 'FakeStringValue'
                        AdditionalProperties = @{
                            trackInstallProgressForAutopilotOnly    = $True
                            '@odata.type'                           = '#microsoft.graph.windows10EnrollmentCompletionPageConfiguration'
                            disableUserStatusTrackingAfterFirstUser = $True
                            installQualityUpdates                   = $True
                            showInstallationProgress                = $True
                            selectedMobileAppIds                    = @('FakeGuidValue')
                            blockDeviceSetupRetryByUser             = $True
                            allowDeviceUseOnInstallFailure          = $True
                            customErrorMessage                      = 'FakeStringValue'
                            allowNonBlockingAppInstallation         = $True
                            allowLogCollectionOnInstallFailure      = $True
                            allowDeviceResetOnInstallFailure        = $True
                            installProgressTimeoutInMinutes         = 25
                        }
                        Priority             = 25
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'The IntuneDeviceEnrollmentStatusPageWindows10 Exists and Values are already in the desired state, using SelectedMobileAppNames' -Fixture {
            BeforeAll {
                $testParams = @{
                    Id                                      = 'FakeStringValue'
                    DisplayName                             = 'FakeStringValue'
                    Description                             = 'FakeStringValue'
                    AllowDeviceResetOnInstallFailure        = $True
                    AllowDeviceUseOnInstallFailure          = $True
                    AllowLogCollectionOnInstallFailure      = $True
                    AllowNonBlockingAppInstallation         = $True
                    BlockDeviceSetupRetryByUser             = $True
                    CustomErrorMessage                      = 'FakeStringValue'
                    DisableUserStatusTrackingAfterFirstUser = $True
                    InstallProgressTimeoutInMinutes         = 25
                    InstallQualityUpdates                   = $True
                    SelectedMobileAppNames                  = @('FakeStringValue')
                    ShowInstallationProgress                = $True
                    TrackInstallProgressForAutopilotOnly    = $True
                    Ensure                                  = 'Present'
                    Credential                              = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceEnrollmentConfiguration -MockWith {
                    return @{
                        Id                   = 'FakeStringValue'
                        DisplayName          = 'FakeStringValue'
                        Description          = 'FakeStringValue'
                        AdditionalProperties = @{
                            trackInstallProgressForAutopilotOnly    = $True
                            '@odata.type'                           = '#microsoft.graph.windows10EnrollmentCompletionPageConfiguration'
                            disableUserStatusTrackingAfterFirstUser = $True
                            installQualityUpdates                   = $True
                            showInstallationProgress                = $True
                            selectedMobileAppIds                    = @('FakeGuidValue')
                            blockDeviceSetupRetryByUser             = $True
                            allowDeviceUseOnInstallFailure          = $True
                            customErrorMessage                      = 'FakeStringValue'
                            allowNonBlockingAppInstallation         = $True
                            allowLogCollectionOnInstallFailure      = $True
                            allowDeviceResetOnInstallFailure        = $True
                            installProgressTimeoutInMinutes         = 25
                        }
                        Priority             = 25
                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'The IntuneDeviceEnrollmentStatusPageWindows10 exists and values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    Id                                      = 'FakeStringValue'
                    DisplayName                             = 'FakeStringValue'
                    Description                             = 'FakeStringValue'
                    AllowDeviceResetOnInstallFailure        = $True
                    AllowDeviceUseOnInstallFailure          = $True
                    AllowLogCollectionOnInstallFailure      = $True
                    AllowNonBlockingAppInstallation         = $True
                    BlockDeviceSetupRetryByUser             = $True
                    CustomErrorMessage                      = 'FakeStringValue'
                    DisableUserStatusTrackingAfterFirstUser = $True
                    InstallProgressTimeoutInMinutes         = 25
                    InstallQualityUpdates                   = $True
                    SelectedMobileAppIds                    = @('FakeGuidValue')
                    ShowInstallationProgress                = $True
                    TrackInstallProgressForAutopilotOnly    = $True
                    Ensure                                  = 'Present'
                    Credential                              = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceEnrollmentConfiguration -MockWith {
                    return @{
                        Id                   = 'FakeStringValue'
                        DisplayName          = 'FakeStringValue'
                        Description          = 'FakeStringValue'
                        AdditionalProperties = @{
                            installProgressTimeoutInMinutes      = 7
                            customErrorMessage                   = 'FakeStringValue'
                            trackInstallProgressForAutopilotOnly = $False
                            selectedMobileAppIds                 = @('FakeGuidValue')
                            showInstallationProgress             = $False
                        }
                        Priority             = 7
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
                Should -Invoke -CommandName Update-MgBetaDeviceManagementDeviceEnrollmentConfiguration -Exactly 1
            }
        }

        Context -Name 'The IntuneDeviceEnrollmentStatusPageWindows10 exists and values are NOT in the desired state, using SelectedMobileAppNames' -Fixture {
            BeforeAll {
                $testParams = @{
                    Id                                      = 'FakeStringValue'
                    DisplayName                             = 'FakeStringValue'
                    Description                             = 'FakeStringValue'
                    AllowDeviceResetOnInstallFailure        = $True
                    AllowDeviceUseOnInstallFailure          = $True
                    AllowLogCollectionOnInstallFailure      = $True
                    AllowNonBlockingAppInstallation         = $True
                    BlockDeviceSetupRetryByUser             = $True
                    CustomErrorMessage                      = 'FakeStringValue'
                    DisableUserStatusTrackingAfterFirstUser = $True
                    InstallProgressTimeoutInMinutes         = 25
                    InstallQualityUpdates                   = $True
                    SelectedMobileAppNames                  = @('FakeStringValue')
                    ShowInstallationProgress                = $True
                    TrackInstallProgressForAutopilotOnly    = $True
                    Ensure                                  = 'Present'
                    Credential                              = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceEnrollmentConfiguration -MockWith {
                    return @{
                        Id                   = 'FakeStringValue'
                        DisplayName          = 'FakeStringValue'
                        Description          = 'FakeStringValue'
                        AdditionalProperties = @{
                            installProgressTimeoutInMinutes      = 7
                            customErrorMessage                   = 'FakeStringValue'
                            trackInstallProgressForAutopilotOnly = $False
                            selectedMobileAppIds                 = @('FakeGuidValue')
                            showInstallationProgress             = $False
                        }
                        Priority             = 7
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
                Should -Invoke -CommandName Update-MgBetaDeviceManagementDeviceEnrollmentConfiguration -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceEnrollmentConfiguration -MockWith {
                    return @{
                        Id                   = 'FakeStringValue'
                        DisplayName          = 'FakeStringValue'
                        Description          = 'FakeStringValue'
                        AdditionalProperties = @{
                            trackInstallProgressForAutopilotOnly    = $True
                            '@odata.type'                           = '#microsoft.graph.windows10EnrollmentCompletionPageConfiguration'
                            disableUserStatusTrackingAfterFirstUser = $True
                            installQualityUpdates                   = $True
                            showInstallationProgress                = $True
                            selectedMobileAppIds                    = @('FakeGuidValue')
                            blockDeviceSetupRetryByUser             = $True
                            allowDeviceUseOnInstallFailure          = $True
                            customErrorMessage                      = 'FakeStringValue'
                            allowNonBlockingAppInstallation         = $True
                            allowLogCollectionOnInstallFailure      = $True
                            allowDeviceResetOnInstallFailure        = $True
                            installProgressTimeoutInMinutes         = 25
                        }
                        Priority             = 25
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
