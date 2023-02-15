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
    -DscResource 'IntuneDeviceManagementDeviceEnrollmentConfigurationWindows10' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString 'f@kepassword1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgDeviceManagementDeviceEnrollmentConfiguration -MockWith {
            }

            Mock -CommandName New-MgDeviceManagementDeviceEnrollmentConfiguration -MockWith {
            }

            Mock -CommandName Remove-MgDeviceManagementDeviceEnrollmentConfiguration -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }
        }
        # Test contexts
        Context -Name 'The IntuneDeviceManagementDeviceEnrollmentConfigurationWindows10 should exist but it DOES NOT' -Fixture {
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

                Mock -CommandName Get-MgDeviceManagementDeviceEnrollmentConfiguration -MockWith {
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
                Should -Invoke -CommandName New-MgDeviceManagementDeviceEnrollmentConfiguration -Exactly 1
            }
        }

        Context -Name 'The IntuneDeviceManagementDeviceEnrollmentConfigurationWindows10 exists but it SHOULD NOT' -Fixture {
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

                Mock -CommandName Get-MgDeviceManagementDeviceEnrollmentConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            trackInstallProgressForAutopilotOnly    = $True
                            '@odata.type'                           = '#microsoft.graph.windows10EnrollmentCompletionPageConfiguration'
                            disableUserStatusTrackingAfterFirstUser = $True
                            installQualityUpdates                   = $True
                            showInstallationProgress                = $True
                            selectedMobileAppIds                    = @('FakeStringValue')
                            blockDeviceSetupRetryByUser             = $True
                            allowDeviceUseOnInstallFailure          = $True
                            customErrorMessage                      = 'FakeStringValue'
                            allowNonBlockingAppInstallation         = $True
                            allowLogCollectionOnInstallFailure      = $True
                            allowDeviceResetOnInstallFailure        = $True
                            installProgressTimeoutInMinutes         = 25
                        }
                        Description          = 'FakeStringValue'
                        DisplayName          = @('FakeStringValue')
                        Id                   = @('FakeStringValue')
                        Priority             = @('25')

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
                Should -Invoke -CommandName Remove-MgDeviceManagementDeviceEnrollmentConfiguration -Exactly 1
            }
        }
        Context -Name 'The IntuneDeviceManagementDeviceEnrollmentConfigurationWindows10 Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowDeviceResetOnInstallFailure        = $True
                    AllowDeviceUseOnInstallFailure          = $True
                    AllowLogCollectionOnInstallFailure      = $True
                    AllowNonBlockingAppInstallation         = $True
                    BlockDeviceSetupRetryByUser             = $True
                    CustomErrorMessage                      = 'FakeStringValue'
                    Description                             = @('FakeStringValue')
                    DeviceEnrollmentConfigurationType       = @('unknown')
                    DisableUserStatusTrackingAfterFirstUser = $True
                    DisplayName                             = @('FakeStringValue')
                    Id                                      = @('FakeStringValue')
                    InstallProgressTimeoutInMinutes         = 25
                    InstallQualityUpdates                   = $True
                    Priority                                = @('25')
                    SelectedMobileAppIds                    = @('FakeStringValue')
                    ShowInstallationProgress                = @('True')
                    TrackInstallProgressForAutopilotOnly    = @('True')
                    Ensure                                  = 'Present'
                    Credential                              = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementDeviceEnrollmentConfiguration -MockWith {
                    return @{
                        AdditionalProperties              = @{
                            trackInstallProgressForAutopilotOnly    = @('True')
                            '@odata.type'                           = '#microsoft.graph.windows10EnrollmentCompletionPageConfiguration'
                            disableUserStatusTrackingAfterFirstUser = $True
                            installQualityUpdates                   = $True
                            showInstallationProgress                = @('True')
                            selectedMobileAppIds                    = @('FakeStringValue')
                            blockDeviceSetupRetryByUser             = $True
                            allowDeviceUseOnInstallFailure          = $True
                            customErrorMessage                      = 'FakeStringValue'
                            allowNonBlockingAppInstallation         = $True
                            allowLogCollectionOnInstallFailure      = $True
                            allowDeviceResetOnInstallFailure        = $True
                            installProgressTimeoutInMinutes         = 25
                        }
                        Description                       = @('FakeStringValue')
                        DeviceEnrollmentConfigurationType = @('unknown')
                        DisplayName                       = @('FakeStringValue')
                        Id                                = @('FakeStringValue')
                        Priority                          = @('25')

                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'The IntuneDeviceManagementDeviceEnrollmentConfigurationWindows10 exists and values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowDeviceResetOnInstallFailure        = $True
                    AllowDeviceUseOnInstallFailure          = $True
                    AllowLogCollectionOnInstallFailure      = $True
                    AllowNonBlockingAppInstallation         = $True
                    BlockDeviceSetupRetryByUser             = $True
                    CustomErrorMessage                      = 'FakeStringValue'
                    Description                             = @('FakeStringValue')
                    DeviceEnrollmentConfigurationType       = @('unknown')
                    DisableUserStatusTrackingAfterFirstUser = $True
                    DisplayName                             = @('FakeStringValue')
                    Id                                      = @('FakeStringValue')
                    InstallProgressTimeoutInMinutes         = 25
                    InstallQualityUpdates                   = $True
                    Priority                                = @('25')
                    SelectedMobileAppIds                    = @('FakeStringValue')
                    ShowInstallationProgress                = @('True')
                    TrackInstallProgressForAutopilotOnly    = @('True')
                    Ensure                                  = 'Present'
                    Credential                              = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementDeviceEnrollmentConfiguration -MockWith {
                    return @{
                        AdditionalProperties              = @{
                            installProgressTimeoutInMinutes      = 7
                            customErrorMessage                   = 'FakeStringValue'
                            trackInstallProgressForAutopilotOnly = @('False')
                            selectedMobileAppIds                 = @('FakeStringValue')
                            showInstallationProgress             = @('False')
                        }
                        Description                       = @('FakeStringValue')
                        DeviceEnrollmentConfigurationType = @('unknown')
                        DisplayName                       = @('FakeStringValue')
                        Id                                = @('FakeStringValue')
                        Priority                          = @('7')
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
                Should -Invoke -CommandName Update-MgDeviceManagementDeviceEnrollmentConfiguration -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementDeviceEnrollmentConfiguration -MockWith {
                    return @{
                        AdditionalProperties              = @{
                            trackInstallProgressForAutopilotOnly    = @('True')
                            '@odata.type'                           = '#microsoft.graph.windows10EnrollmentCompletionPageConfiguration'
                            disableUserStatusTrackingAfterFirstUser = $True
                            installQualityUpdates                   = $True
                            showInstallationProgress                = @('True')
                            selectedMobileAppIds                    = @('FakeStringValue')
                            blockDeviceSetupRetryByUser             = $True
                            allowDeviceUseOnInstallFailure          = $True
                            customErrorMessage                      = 'FakeStringValue'
                            allowNonBlockingAppInstallation         = $True
                            allowLogCollectionOnInstallFailure      = $True
                            allowDeviceResetOnInstallFailure        = $True
                            installProgressTimeoutInMinutes         = 25
                        }
                        Description                       = @('FakeStringValue')
                        DeviceEnrollmentConfigurationType = @('unknown')
                        DisplayName                       = @('FakeStringValue')
                        Id                                = @('FakeStringValue')
                        Priority                          = @('25')

                    }
                }
            }
            It 'Should Reverse Engineer resource from the Export method' {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
