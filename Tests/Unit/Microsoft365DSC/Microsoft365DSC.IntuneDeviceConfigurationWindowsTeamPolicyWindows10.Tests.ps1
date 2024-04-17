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
    -DscResource "IntuneDeviceConfigurationWindowsTeamPolicyWindows10" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString "f@kepassword1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }
            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }
            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false

            Mock -CommandName Get-MgBetaDeviceManagementDeviceConfigurationAssignment -MockWith {
            }

        }
        # Test contexts
        Context -Name "The IntuneDeviceConfigurationWindowsTeamPolicyWindows10 should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AzureOperationalInsightsBlockTelemetry = $True
                    AzureOperationalInsightsWorkspaceId = "FakeStringValue"
                    AzureOperationalInsightsWorkspaceKey = "FakeStringValue"
                    ConnectAppBlockAutoLaunch = $True
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    MaintenanceWindowBlocked = $True
                    MaintenanceWindowDurationInHours = 25
                    MaintenanceWindowStartTime = "00:00:00"
                    MiracastBlocked = $True
                    MiracastChannel = "userDefined"
                    MiracastRequirePin = $True
                    SettingsBlockMyMeetingsAndFiles = $True
                    SettingsBlockSessionResume = $True
                    SettingsBlockSigninSuggestions = $True
                    SettingsDefaultVolume = 25
                    SettingsScreenTimeoutInMinutes = 25
                    SettingsSessionTimeoutInMinutes = 25
                    SettingsSleepTimeoutInMinutes = 25
                    SupportsScopeTags = $True
                    WelcomeScreenBackgroundImageUrl = "FakeStringValue"
                    WelcomeScreenBlockAutomaticWakeUp = $True
                    WelcomeScreenMeetingInformation = "userDefined"
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
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
                Should -Invoke -CommandName New-MgBetaDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name "The IntuneDeviceConfigurationWindowsTeamPolicyWindows10 exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AzureOperationalInsightsBlockTelemetry = $True
                    AzureOperationalInsightsWorkspaceId = "FakeStringValue"
                    AzureOperationalInsightsWorkspaceKey = "FakeStringValue"
                    ConnectAppBlockAutoLaunch = $True
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    MaintenanceWindowBlocked = $True
                    MaintenanceWindowDurationInHours = 25
                    MaintenanceWindowStartTime = "00:00:00"
                    MiracastBlocked = $True
                    MiracastChannel = "userDefined"
                    MiracastRequirePin = $True
                    SettingsBlockMyMeetingsAndFiles = $True
                    SettingsBlockSessionResume = $True
                    SettingsBlockSigninSuggestions = $True
                    SettingsDefaultVolume = 25
                    SettingsScreenTimeoutInMinutes = 25
                    SettingsSessionTimeoutInMinutes = 25
                    SettingsSleepTimeoutInMinutes = 25
                    SupportsScopeTags = $True
                    WelcomeScreenBackgroundImageUrl = "FakeStringValue"
                    WelcomeScreenBlockAutomaticWakeUp = $True
                    WelcomeScreenMeetingInformation = "userDefined"
                    Ensure = 'Absent'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            settingsDefaultVolume = 25
                            welcomeScreenMeetingInformation = "userDefined"
                            settingsScreenTimeoutInMinutes = 25
                            settingsBlockMyMeetingsAndFiles = $True
                            '@odata.type' = "#microsoft.graph.windows10TeamGeneralConfiguration"
                            maintenanceWindowDurationInHours = 25
                            azureOperationalInsightsBlockTelemetry = $True
                            miracastChannel = "userDefined"
                            welcomeScreenBackgroundImageUrl = "FakeStringValue"
                            settingsBlockSessionResume = $True
                            settingsSessionTimeoutInMinutes = 25
                            azureOperationalInsightsWorkspaceKey = "FakeStringValue"
                            welcomeScreenBlockAutomaticWakeUp = $True
                            miracastRequirePin = $True
                            maintenanceWindowStartTime = "00:00:00"
                            settingsBlockSigninSuggestions = $True
                            maintenanceWindowBlocked = $True
                            miracastBlocked = $True
                            settingsSleepTimeoutInMinutes = 25
                            azureOperationalInsightsWorkspaceId = "FakeStringValue"
                            connectAppBlockAutoLaunch = $True
                        }
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"
                        SupportsScopeTags = $True

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
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementDeviceConfiguration -Exactly 1
            }
        }
        Context -Name "The IntuneDeviceConfigurationWindowsTeamPolicyWindows10 Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AzureOperationalInsightsBlockTelemetry = $True
                    AzureOperationalInsightsWorkspaceId = "FakeStringValue"
                    AzureOperationalInsightsWorkspaceKey = "FakeStringValue"
                    ConnectAppBlockAutoLaunch = $True
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    MaintenanceWindowBlocked = $True
                    MaintenanceWindowDurationInHours = 25
                    MaintenanceWindowStartTime = "00:00:00"
                    MiracastBlocked = $True
                    MiracastChannel = "userDefined"
                    MiracastRequirePin = $True
                    SettingsBlockMyMeetingsAndFiles = $True
                    SettingsBlockSessionResume = $True
                    SettingsBlockSigninSuggestions = $True
                    SettingsDefaultVolume = 25
                    SettingsScreenTimeoutInMinutes = 25
                    SettingsSessionTimeoutInMinutes = 25
                    SettingsSleepTimeoutInMinutes = 25
                    SupportsScopeTags = $True
                    WelcomeScreenBackgroundImageUrl = "FakeStringValue"
                    WelcomeScreenBlockAutomaticWakeUp = $True
                    WelcomeScreenMeetingInformation = "userDefined"
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            settingsDefaultVolume = 25
                            welcomeScreenMeetingInformation = "userDefined"
                            settingsScreenTimeoutInMinutes = 25
                            settingsBlockMyMeetingsAndFiles = $True
                            '@odata.type' = "#microsoft.graph.windows10TeamGeneralConfiguration"
                            maintenanceWindowDurationInHours = 25
                            azureOperationalInsightsBlockTelemetry = $True
                            miracastChannel = "userDefined"
                            welcomeScreenBackgroundImageUrl = "FakeStringValue"
                            settingsBlockSessionResume = $True
                            settingsSessionTimeoutInMinutes = 25
                            azureOperationalInsightsWorkspaceKey = "FakeStringValue"
                            welcomeScreenBlockAutomaticWakeUp = $True
                            miracastRequirePin = $True
                            maintenanceWindowStartTime = "00:00:00"
                            settingsBlockSigninSuggestions = $True
                            maintenanceWindowBlocked = $True
                            miracastBlocked = $True
                            settingsSleepTimeoutInMinutes = 25
                            azureOperationalInsightsWorkspaceId = "FakeStringValue"
                            connectAppBlockAutoLaunch = $True
                        }
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"
                        SupportsScopeTags = $True

                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The IntuneDeviceConfigurationWindowsTeamPolicyWindows10 exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AzureOperationalInsightsBlockTelemetry = $True
                    AzureOperationalInsightsWorkspaceId = "FakeStringValue"
                    AzureOperationalInsightsWorkspaceKey = "FakeStringValue"
                    ConnectAppBlockAutoLaunch = $True
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    Id = "FakeStringValue"
                    MaintenanceWindowBlocked = $True
                    MaintenanceWindowDurationInHours = 25
                    MaintenanceWindowStartTime = "00:00:00"
                    MiracastBlocked = $True
                    MiracastChannel = "userDefined"
                    MiracastRequirePin = $True
                    SettingsBlockMyMeetingsAndFiles = $True
                    SettingsBlockSessionResume = $True
                    SettingsBlockSigninSuggestions = $True
                    SettingsDefaultVolume = 25
                    SettingsScreenTimeoutInMinutes = 25
                    SettingsSessionTimeoutInMinutes = 25
                    SettingsSleepTimeoutInMinutes = 25
                    SupportsScopeTags = $True
                    WelcomeScreenBackgroundImageUrl = "FakeStringValue"
                    WelcomeScreenBlockAutomaticWakeUp = $True
                    WelcomeScreenMeetingInformation = "userDefined"
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            maintenanceWindowDurationInHours = 7
                            settingsScreenTimeoutInMinutes = 7
                            welcomeScreenMeetingInformation = "userDefined"
                            settingsDefaultVolume = 7
                            azureOperationalInsightsWorkspaceId = "FakeStringValue"
                            miracastChannel = "userDefined"
                            azureOperationalInsightsWorkspaceKey = "FakeStringValue"
                            settingsSessionTimeoutInMinutes = 7
                            maintenanceWindowStartTime = "00:00:00"
                            '@odata.type' = "#microsoft.graph.windows10TeamGeneralConfiguration"
                            welcomeScreenBackgroundImageUrl = "FakeStringValue"
                            settingsSleepTimeoutInMinutes = 7
                        }
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"
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
                Should -Invoke -CommandName Update-MgBetaDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            settingsDefaultVolume = 25
                            welcomeScreenMeetingInformation = "userDefined"
                            settingsScreenTimeoutInMinutes = 25
                            settingsBlockMyMeetingsAndFiles = $True
                            '@odata.type' = "#microsoft.graph.windows10TeamGeneralConfiguration"
                            maintenanceWindowDurationInHours = 25
                            azureOperationalInsightsBlockTelemetry = $True
                            miracastChannel = "userDefined"
                            welcomeScreenBackgroundImageUrl = "FakeStringValue"
                            settingsBlockSessionResume = $True
                            settingsSessionTimeoutInMinutes = 25
                            azureOperationalInsightsWorkspaceKey = "FakeStringValue"
                            welcomeScreenBlockAutomaticWakeUp = $True
                            miracastRequirePin = $True
                            maintenanceWindowStartTime = "00:00:00"
                            settingsBlockSigninSuggestions = $True
                            maintenanceWindowBlocked = $True
                            miracastBlocked = $True
                            settingsSleepTimeoutInMinutes = 25
                            azureOperationalInsightsWorkspaceId = "FakeStringValue"
                            connectAppBlockAutoLaunch = $True
                        }
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"
                        SupportsScopeTags = $True

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
