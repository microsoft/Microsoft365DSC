[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
                        -ChildPath "..\..\Unit" `
                        -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
            -ChildPath "\Stubs\Microsoft365.psm1" `
            -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
    -ChildPath "\Stubs\Generic.psm1" `
    -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath "\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "IntuneWindowUpdateForBusinessRingUpdateProfileWindows10" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString "f@kepassword1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ("tenantadmin@mydomain.com", $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName New-MgDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName Remove-MgDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            Mock -CommandName Get-MgDeviceManagementDeviceConfigurationAssignment -MockWith {
            }

        }
        # Test contexts
        Context -Name "The IntuneWindowUpdateForBusinessRingUpdateProfileWindows10 should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowWindows11Upgrade = $True
                    AutomaticUpdateMode = "userDefined"
                    AutoRestartNotificationDismissal = "notConfigured"
                    BusinessReadyUpdatesOnly = "userDefined"
                    DeadlineForFeatureUpdatesInDays = 25
                    DeadlineForQualityUpdatesInDays = 25
                    DeadlineGracePeriodInDays = 25
                    DeliveryOptimizationMode = "userDefined"
                    description = "FakeStringValue"
                    displayName = "FakeStringValue"
                    DriversExcluded = $True
                    EngagedRestartDeadlineInDays = 25
                    EngagedRestartSnoozeScheduleInDays = 25
                    EngagedRestartTransitionScheduleInDays = 25
                    FeatureUpdatesDeferralPeriodInDays = 25
                    FeatureUpdatesPaused = $True
                    FeatureUpdatesPauseExpiryDateTime = "2023-01-01T00:00:00.0000000+00:00"
                    FeatureUpdatesPauseStartDate = "2023-01-01T00:00:00.0000000"
                    FeatureUpdatesRollbackStartDateTime = "2023-01-01T00:00:00.0000000+00:00"
                    FeatureUpdatesRollbackWindowInDays = 25
                    id = "FakeStringValue"
                    installationSchedule = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsUpdateInstallScheduleType -Property @{
                        activeHoursStart = "00:00:00"
                        scheduledInstallTime = "00:00:00"
                        scheduledInstallDay = "userDefined"
                        activeHoursEnd = "00:00:00"
                        odataType = "#microsoft.graph.windowsUpdateActiveHoursInstall"
                    } -ClientOnly)
                    microsoftUpdateServiceAllowed = $True
                    postponeRebootUntilAfterDeadline = $True
                    prereleaseFeatures = "userDefined"
                    qualityUpdatesDeferralPeriodInDays = 25
                    qualityUpdatesPaused = $True
                    qualityUpdatesPauseExpiryDateTime = "2023-01-01T00:00:00.0000000+00:00"
                    qualityUpdatesPauseStartDate = "2023-01-01T00:00:00.0000000"
                    qualityUpdatesRollbackStartDateTime = "2023-01-01T00:00:00.0000000+00:00"
                    scheduleImminentRestartWarningInMinutes = 25
                    scheduleRestartWarningInHours = 25
                    skipChecksBeforeRestart = $True
                    updateNotificationLevel = "notConfigured"
                    updateWeeks = "userDefined"
                    userPauseAccess = "notConfigured"
                    userWindowsUpdateScanAccess = "notConfigured"
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return $null
                }
            }
            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Create the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name "The IntuneWindowUpdateForBusinessRingUpdateProfileWindows10 exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowWindows11Upgrade = $True
                    AutomaticUpdateMode = "userDefined"
                    AutoRestartNotificationDismissal = "notConfigured"
                    BusinessReadyUpdatesOnly = "userDefined"
                    DeadlineForFeatureUpdatesInDays = 25
                    DeadlineForQualityUpdatesInDays = 25
                    DeadlineGracePeriodInDays = 25
                    DeliveryOptimizationMode = "userDefined"
                    description = "FakeStringValue"
                    displayName = "FakeStringValue"
                    DriversExcluded = $True
                    EngagedRestartDeadlineInDays = 25
                    EngagedRestartSnoozeScheduleInDays = 25
                    EngagedRestartTransitionScheduleInDays = 25
                    FeatureUpdatesDeferralPeriodInDays = 25
                    FeatureUpdatesPaused = $True
                    FeatureUpdatesPauseExpiryDateTime = "2023-01-01T00:00:00.0000000+00:00"
                    FeatureUpdatesPauseStartDate = "2023-01-01T00:00:00.0000000"
                    FeatureUpdatesRollbackStartDateTime = "2023-01-01T00:00:00.0000000+00:00"
                    FeatureUpdatesRollbackWindowInDays = 25
                    id = "FakeStringValue"
                    installationSchedule = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsUpdateInstallScheduleType -Property @{
                        activeHoursStart = "00:00:00"
                        scheduledInstallTime = "00:00:00"
                        scheduledInstallDay = "userDefined"
                        activeHoursEnd = "00:00:00"
                        odataType = "#microsoft.graph.windowsUpdateActiveHoursInstall"
                    } -ClientOnly)
                    microsoftUpdateServiceAllowed = $True
                    postponeRebootUntilAfterDeadline = $True
                    prereleaseFeatures = "userDefined"
                    qualityUpdatesDeferralPeriodInDays = 25
                    qualityUpdatesPaused = $True
                    qualityUpdatesPauseExpiryDateTime = "2023-01-01T00:00:00.0000000+00:00"
                    qualityUpdatesPauseStartDate = "2023-01-01T00:00:00.0000000"
                    qualityUpdatesRollbackStartDateTime = "2023-01-01T00:00:00.0000000+00:00"
                    scheduleImminentRestartWarningInMinutes = 25
                    scheduleRestartWarningInHours = 25
                    skipChecksBeforeRestart = $True
                    updateNotificationLevel = "notConfigured"
                    updateWeeks = "userDefined"
                    userPauseAccess = "notConfigured"
                    userWindowsUpdateScanAccess = "notConfigured"
                    Ensure = "Absent"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            postponeRebootUntilAfterDeadline = $True
                            featureUpdatesPauseExpiryDateTime = "2023-01-01T00:00:00.0000000+00:00"
                            businessReadyUpdatesOnly = "userDefined"
                            updateWeeks = "userDefined"
                            qualityUpdatesPauseStartDate = "2023-01-01T00:00:00.0000000"
                            skipChecksBeforeRestart = $True
                            deadlineForFeatureUpdatesInDays = 25
                            featureUpdatesRollbackStartDateTime = "2023-01-01T00:00:00.0000000+00:00"
                            qualityUpdatesPauseExpiryDateTime = "2023-01-01T00:00:00.0000000+00:00"
                            scheduleImminentRestartWarningInMinutes = 25
                            featureUpdatesDeferralPeriodInDays = 25
                            driversExcluded = $True
                            featureUpdatesPauseStartDate = "2023-01-01T00:00:00.0000000"
                            deadlineForQualityUpdatesInDays = 25
                            deliveryOptimizationMode = "userDefined"
                            scheduleRestartWarningInHours = 25
                            prereleaseFeatures = "userDefined"
                            featureUpdatesPaused = $True
                            updateNotificationLevel = "notConfigured"
                            automaticUpdateMode = "userDefined"
                            allowWindows11Upgrade = $True
                            featureUpdatesRollbackWindowInDays = 25
                            engagedRestartTransitionScheduleInDays = 25
                            engagedRestartDeadlineInDays = 25
                            qualityUpdatesDeferralPeriodInDays = 25
                            qualityUpdatesPaused = $True
                            deadlineGracePeriodInDays = 25
                            autoRestartNotificationDismissal = "notConfigured"
                            installationSchedule = @{
                                activeHoursStart = "00:00:00"
                                scheduledInstallTime = "00:00:00"
                                scheduledInstallDay = "userDefined"
                                activeHoursEnd = "00:00:00"
                                '@odata.type' = "#microsoft.graph.windowsUpdateActiveHoursInstall"
                            }
                            engagedRestartSnoozeScheduleInDays = 25
                            '@odata.type' = "#microsoft.graph.windowsUpdateForBusinessConfiguration"
                            qualityUpdatesRollbackStartDateTime = "2023-01-01T00:00:00.0000000+00:00"
                            userPauseAccess = "notConfigured"
                            userWindowsUpdateScanAccess = "notConfigured"
                            microsoftUpdateServiceAllowed = $True
                        }
                        description = "FakeStringValue"
                        displayName = "FakeStringValue"
                        id = "FakeStringValue"

                    }
                }
            }

            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgDeviceManagementDeviceConfiguration -Exactly 1
            }
        }
        Context -Name "The IntuneWindowUpdateForBusinessRingUpdateProfileWindows10 Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowWindows11Upgrade = $True
                    AutomaticUpdateMode = "userDefined"
                    AutoRestartNotificationDismissal = "notConfigured"
                    BusinessReadyUpdatesOnly = "userDefined"
                    DeadlineForFeatureUpdatesInDays = 25
                    DeadlineForQualityUpdatesInDays = 25
                    DeadlineGracePeriodInDays = 25
                    DeliveryOptimizationMode = "userDefined"
                    description = "FakeStringValue"
                    displayName = "FakeStringValue"
                    DriversExcluded = $True
                    EngagedRestartDeadlineInDays = 25
                    EngagedRestartSnoozeScheduleInDays = 25
                    EngagedRestartTransitionScheduleInDays = 25
                    FeatureUpdatesDeferralPeriodInDays = 25
                    FeatureUpdatesPaused = $True
                    FeatureUpdatesPauseExpiryDateTime = "2023-01-01T00:00:00.0000000+00:00"
                    FeatureUpdatesPauseStartDate = "2023-01-01T00:00:00.0000000"
                    FeatureUpdatesRollbackStartDateTime = "2023-01-01T00:00:00.0000000+00:00"
                    FeatureUpdatesRollbackWindowInDays = 25
                    id = "FakeStringValue"
                    installationSchedule = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsUpdateInstallScheduleType -Property @{
                        activeHoursStart = "00:00:00"
                        scheduledInstallTime = "00:00:00"
                        scheduledInstallDay = "userDefined"
                        activeHoursEnd = "00:00:00"
                        odataType = "#microsoft.graph.windowsUpdateActiveHoursInstall"
                    } -ClientOnly)
                    microsoftUpdateServiceAllowed = $True
                    postponeRebootUntilAfterDeadline = $True
                    prereleaseFeatures = "userDefined"
                    qualityUpdatesDeferralPeriodInDays = 25
                    qualityUpdatesPaused = $True
                    qualityUpdatesPauseExpiryDateTime = "2023-01-01T00:00:00.0000000+00:00"
                    qualityUpdatesPauseStartDate = "2023-01-01T00:00:00.0000000"
                    qualityUpdatesRollbackStartDateTime = "2023-01-01T00:00:00.0000000+00:00"
                    scheduleImminentRestartWarningInMinutes = 25
                    scheduleRestartWarningInHours = 25
                    skipChecksBeforeRestart = $True
                    updateNotificationLevel = "notConfigured"
                    updateWeeks = "userDefined"
                    userPauseAccess = "notConfigured"
                    userWindowsUpdateScanAccess = "notConfigured"
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            postponeRebootUntilAfterDeadline = $True
                            featureUpdatesPauseExpiryDateTime = "2023-01-01T00:00:00.0000000+00:00"
                            businessReadyUpdatesOnly = "userDefined"
                            updateWeeks = "userDefined"
                            qualityUpdatesPauseStartDate = "2023-01-01T00:00:00.0000000"
                            skipChecksBeforeRestart = $True
                            deadlineForFeatureUpdatesInDays = 25
                            featureUpdatesRollbackStartDateTime = "2023-01-01T00:00:00.0000000+00:00"
                            qualityUpdatesPauseExpiryDateTime = "2023-01-01T00:00:00.0000000+00:00"
                            scheduleImminentRestartWarningInMinutes = 25
                            featureUpdatesDeferralPeriodInDays = 25
                            driversExcluded = $True
                            featureUpdatesPauseStartDate = "2023-01-01T00:00:00.0000000"
                            deadlineForQualityUpdatesInDays = 25
                            deliveryOptimizationMode = "userDefined"
                            scheduleRestartWarningInHours = 25
                            prereleaseFeatures = "userDefined"
                            featureUpdatesPaused = $True
                            updateNotificationLevel = "notConfigured"
                            automaticUpdateMode = "userDefined"
                            allowWindows11Upgrade = $True
                            featureUpdatesRollbackWindowInDays = 25
                            engagedRestartTransitionScheduleInDays = 25
                            engagedRestartDeadlineInDays = 25
                            qualityUpdatesDeferralPeriodInDays = 25
                            qualityUpdatesPaused = $True
                            deadlineGracePeriodInDays = 25
                            autoRestartNotificationDismissal = "notConfigured"
                            installationSchedule = @{
                                activeHoursStart = "00:00:00"
                                scheduledInstallTime = "00:00:00"
                                scheduledInstallDay = "userDefined"
                                activeHoursEnd = "00:00:00"
                                '@odata.type' = "#microsoft.graph.windowsUpdateActiveHoursInstall"
                            }
                            engagedRestartSnoozeScheduleInDays = 25
                            '@odata.type' = "#microsoft.graph.windowsUpdateForBusinessConfiguration"
                            qualityUpdatesRollbackStartDateTime = "2023-01-01T00:00:00.0000000+00:00"
                            userPauseAccess = "notConfigured"
                            userWindowsUpdateScanAccess = "notConfigured"
                            microsoftUpdateServiceAllowed = $True
                        }
                        description = "FakeStringValue"
                        displayName = "FakeStringValue"
                        id = "FakeStringValue"

                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The IntuneWindowUpdateForBusinessRingUpdateProfileWindows10 exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowWindows11Upgrade = $True
                    AutomaticUpdateMode = "userDefined"
                    AutoRestartNotificationDismissal = "notConfigured"
                    BusinessReadyUpdatesOnly = "userDefined"
                    DeadlineForFeatureUpdatesInDays = 25
                    DeadlineForQualityUpdatesInDays = 25
                    DeadlineGracePeriodInDays = 25
                    DeliveryOptimizationMode = "userDefined"
                    description = "FakeStringValue"
                    displayName = "FakeStringValue"
                    DriversExcluded = $True
                    EngagedRestartDeadlineInDays = 25
                    EngagedRestartSnoozeScheduleInDays = 25
                    EngagedRestartTransitionScheduleInDays = 25
                    FeatureUpdatesDeferralPeriodInDays = 25
                    FeatureUpdatesPaused = $True
                    FeatureUpdatesPauseExpiryDateTime = "2023-01-01T00:00:00.0000000+00:00"
                    FeatureUpdatesPauseStartDate = "2023-01-01T00:00:00.0000000"
                    FeatureUpdatesRollbackStartDateTime = "2023-01-01T00:00:00.0000000+00:00"
                    FeatureUpdatesRollbackWindowInDays = 25
                    id = "FakeStringValue"
                    installationSchedule = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsUpdateInstallScheduleType -Property @{
                        activeHoursStart = "00:00:00"
                        scheduledInstallTime = "00:00:00"
                        scheduledInstallDay = "userDefined"
                        activeHoursEnd = "00:00:00"
                        odataType = "#microsoft.graph.windowsUpdateActiveHoursInstall"
                    } -ClientOnly)
                    microsoftUpdateServiceAllowed = $True
                    postponeRebootUntilAfterDeadline = $True
                    prereleaseFeatures = "userDefined"
                    qualityUpdatesDeferralPeriodInDays = 25
                    qualityUpdatesPaused = $True
                    qualityUpdatesPauseExpiryDateTime = "2023-01-01T00:00:00.0000000+00:00"
                    qualityUpdatesPauseStartDate = "2023-01-01T00:00:00.0000000"
                    qualityUpdatesRollbackStartDateTime = "2023-01-01T00:00:00.0000000+00:00"
                    scheduleImminentRestartWarningInMinutes = 25
                    scheduleRestartWarningInHours = 25
                    skipChecksBeforeRestart = $True
                    updateNotificationLevel = "notConfigured"
                    updateWeeks = "userDefined"
                    userPauseAccess = "notConfigured"
                    userWindowsUpdateScanAccess = "notConfigured"
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            automaticUpdateMode = "userDefined"
                            deliveryOptimizationMode = "userDefined"
                            deadlineForQualityUpdatesInDays = 7
                            featureUpdatesPauseStartDate = "2023-01-01T00:00:00.0000000"
                            featureUpdatesDeferralPeriodInDays = 7
                            scheduleImminentRestartWarningInMinutes = 7
                            scheduleRestartWarningInHours = 7
                            qualityUpdatesPauseExpiryDateTime = "2023-01-01T00:00:00.0000000+00:00"
                            deadlineForFeatureUpdatesInDays = 7
                            updateWeeks = "userDefined"
                            qualityUpdatesPauseStartDate = "2023-01-01T00:00:00.0000000"
                            businessReadyUpdatesOnly = "userDefined"
                            featureUpdatesPauseExpiryDateTime = "2023-01-01T00:00:00.0000000+00:00"
                            featureUpdatesRollbackStartDateTime = "2023-01-01T00:00:00.0000000+00:00"
                            qualityUpdatesDeferralPeriodInDays = 7
                            updateNotificationLevel = "notConfigured"
                            '@odata.type' = "#microsoft.graph.WindowsUpdateForBusinessConfiguration"
                            engagedRestartSnoozeScheduleInDays = 7
                            installationSchedule = @{
                                activeHoursStart = "00:00:00"
                                scheduledInstallTime = "00:00:00"
                                scheduledInstallDay = "userDefined"
                                activeHoursEnd = "00:00:00"
                                '@odata.type' = "#microsoft.graph.windowsUpdateActiveHoursInstall"
                            }
                            autoRestartNotificationDismissal = "notConfigured"
                            userWindowsUpdateScanAccess = "notConfigured"
                            deadlineGracePeriodInDays = 7
                            engagedRestartDeadlineInDays = 7
                            userPauseAccess = "notConfigured"
                            qualityUpdatesRollbackStartDateTime = "2023-01-01T00:00:00.0000000+00:00"
                            engagedRestartTransitionScheduleInDays = 7
                            prereleaseFeatures = "userDefined"
                            featureUpdatesRollbackWindowInDays = 7
                        }
                        description = "FakeStringValue"
                        displayName = "FakeStringValue"
                        id = "FakeStringValue"
                    }
                }
            }

            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            postponeRebootUntilAfterDeadline = $True
                            featureUpdatesPauseExpiryDateTime = "2023-01-01T00:00:00.0000000+00:00"
                            businessReadyUpdatesOnly = "userDefined"
                            updateWeeks = "userDefined"
                            qualityUpdatesPauseStartDate = "2023-01-01T00:00:00.0000000"
                            skipChecksBeforeRestart = $True
                            deadlineForFeatureUpdatesInDays = 25
                            featureUpdatesRollbackStartDateTime = "2023-01-01T00:00:00.0000000+00:00"
                            qualityUpdatesPauseExpiryDateTime = "2023-01-01T00:00:00.0000000+00:00"
                            scheduleImminentRestartWarningInMinutes = 25
                            featureUpdatesDeferralPeriodInDays = 25
                            driversExcluded = $True
                            featureUpdatesPauseStartDate = "2023-01-01T00:00:00.0000000"
                            deadlineForQualityUpdatesInDays = 25
                            deliveryOptimizationMode = "userDefined"
                            scheduleRestartWarningInHours = 25
                            prereleaseFeatures = "userDefined"
                            featureUpdatesPaused = $True
                            updateNotificationLevel = "notConfigured"
                            automaticUpdateMode = "userDefined"
                            allowWindows11Upgrade = $True
                            featureUpdatesRollbackWindowInDays = 25
                            engagedRestartTransitionScheduleInDays = 25
                            engagedRestartDeadlineInDays = 25
                            qualityUpdatesDeferralPeriodInDays = 25
                            qualityUpdatesPaused = $True
                            deadlineGracePeriodInDays = 25
                            autoRestartNotificationDismissal = "notConfigured"
                            installationSchedule = @{
                                AdditionalProperties = @{
                                    activeHoursStart = "00:00:00"
                                    scheduledInstallTime = "00:00:00"
                                    scheduledInstallDay = "userDefined"
                                    activeHoursEnd = "00:00:00"
                                    '@odata.type' = "#microsoft.graph.windowsUpdateActiveHoursInstall"
                                }
                            }
                            engagedRestartSnoozeScheduleInDays = 25
                            '@odata.type' = "#microsoft.graph.windowsUpdateForBusinessConfiguration"
                            qualityUpdatesRollbackStartDateTime = "2023-01-01T00:00:00.0000000+00:00"
                            userPauseAccess = "notConfigured"
                            userWindowsUpdateScanAccess = "notConfigured"
                            microsoftUpdateServiceAllowed = $True
                        }
                        description = "FakeStringValue"
                        displayName = "FakeStringValue"
                        id = "FakeStringValue"

                    }
                }
            }
            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
