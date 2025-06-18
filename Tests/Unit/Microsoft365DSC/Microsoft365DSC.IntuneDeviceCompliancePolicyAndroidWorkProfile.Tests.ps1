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
    -DscResource 'IntuneDeviceCompliancePolicyAndroidWorkProfile' -GenericStubModule $GenericStubPath

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

            Mock -CommandName Update-MgBetaDeviceManagementDeviceCompliancePolicy -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementDeviceCompliancePolicy -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceManagementDeviceCompliancePolicy -MockWith {
            }

            Mock -CommandName Get-MgBetaDeviceManagementDeviceCompliancePolicyAssignment -MockWith {

                return @()
            }
            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }
            # Mock Write-M365DSCHost to hide output during the tests
            Mock -CommandName Write-M365DSCHost -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "When the Android Work Profile Device Compliance Policy doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName                                        = 'Test Android Work Profile Device Compliance Policy'
                    Description                                        = 'Test Android Work Profile Device Compliance Policy Description'
                    PasswordRequired                                   = $True
                    PasswordMinimumLength                              = 6
                    PasswordRequiredType                               = 'DeviceDefault'
                    PasswordMinutesOfInactivityBeforeLock              = 5
                    PasswordExpirationDays                             = 365
                    PasswordPreviousPasswordBlockCount                 = 10
                    PasswordSignInFailureCountBeforeFactoryReset       = 11
                    SecurityPreventInstallAppsFromUnknownSources       = $True
                    SecurityDisableUsbDebugging                        = $True
                    SecurityRequireVerifyApps                          = $True
                    DeviceThreatProtectionEnabled                      = $True
                    DeviceThreatProtectionRequiredSecurityLevel        = 'Unavailable'
                    AdvancedThreatProtectionRequiredSecurityLevel      = 'Unavailable'
                    SecurityBlockJailbrokenDevices                     = $True
                    OsMinimumVersion                                   = 7
                    OsMaximumVersion                                   = 11
                    StorageRequireEncryption                           = $True
                    SecurityRequireSafetyNetAttestationBasicIntegrity  = $True
                    SecurityRequireSafetyNetAttestationCertifiedDevice = $True
                    SecurityRequireGooglePlayServices                  = $True
                    SecurityRequireUpToDateSecurityProviders           = $True
                    SecurityRequireCompanyPortalAppIntegrity           = $True
                    MinAndroidSecurityPatchLevel                       = "2024-01-01";
                    RequiredPasswordComplexity                         = "medium";
                    SecurityRequiredAndroidSafetyNetEvaluationType     = "hardwareBacked"
                    WorkProfileInactiveBeforeScreenLockInMinutes       = 480
                    WorkProfilePasswordExpirationInDays                = 30
                    WorkProfilePasswordMinimumLength                   = 12
                    WorkProfilePasswordRequiredType                    = "atLeastNumeric"
                    WorkProfilePreviousPasswordBlockCount              = 5
                    WorkProfileRequiredPasswordComplexity              = "high"
                    WorkProfileRequirePassword                         = $True
                    Ensure                                             = 'Present'
                    Credential                                         = $Credential
                    ScheduledActionsForRule = [CimInstance[]]@(
                                                (New-CimInstance `
                                                -ClassName MSFT_scheduledActionConfigurations `
                                                -Property @{
                                                    actionType = 'block'
                                                    gracePeriodHours = 0
                                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                                } -ClientOnly)
                                                (New-CimInstance `
                                                -ClassName MSFT_scheduledActionConfigurations `
                                                -Property @{
                                                    actionType = 'pushNotification'
                                                    gracePeriodHours = 0
                                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                                } -ClientOnly)
                                                (New-CimInstance `
                                                -ClassName MSFT_scheduledActionConfigurations `
                                                -Property @{
                                                    actionType = 'remoteLock'
                                                    gracePeriodHours = 0
                                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                                } -ClientOnly)
                                                (New-CimInstance `
                                                -ClassName MSFT_scheduledActionConfigurations `
                                                -Property @{
                                                    actionType = 'Notification'
                                                    gracePeriodHours = 0
                                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                                    notificationMessageCCList = @('00000000-0000-0000-0000-000000000000','00000000-0000-0000-0000-000000000000')
                                                } -ClientOnly)
                        )
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceCompliancePolicy -MockWith {
                    return $null
                }
            }

            It 'Should return absent from the Get method' {
                    (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create the Android Device Compliance Policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-MgBetaDeviceManagementDeviceCompliancePolicy' -Exactly 1
            }
        }

        Context -Name 'When the Android Device Compliance Policy already exists and is NOT in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName                                        = 'Test Android Work Profile Device Compliance Policy'
                    Description                                        = 'Different Value'
                    PasswordRequired                                   = $True
                    PasswordMinimumLength                              = 6
                    PasswordRequiredType                               = 'DeviceDefault'
                    PasswordMinutesOfInactivityBeforeLock              = 5
                    PasswordExpirationDays                             = 365
                    PasswordPreviousPasswordBlockCount                 = 10
                    PasswordSignInFailureCountBeforeFactoryReset       = 11
                    SecurityPreventInstallAppsFromUnknownSources       = $True
                    SecurityDisableUsbDebugging                        = $True
                    SecurityRequireVerifyApps                          = $True
                    DeviceThreatProtectionEnabled                      = $True
                    DeviceThreatProtectionRequiredSecurityLevel        = 'Unavailable'
                    AdvancedThreatProtectionRequiredSecurityLevel      = 'Unavailable'
                    SecurityBlockJailbrokenDevices                     = $True
                    OsMinimumVersion                                   = 7
                    OsMaximumVersion                                   = 11
                    StorageRequireEncryption                           = $True
                    SecurityRequireSafetyNetAttestationBasicIntegrity  = $True
                    SecurityRequireSafetyNetAttestationCertifiedDevice = $True
                    SecurityRequireGooglePlayServices                  = $True
                    SecurityRequireUpToDateSecurityProviders           = $True
                    SecurityRequireCompanyPortalAppIntegrity           = $True
                    MinAndroidSecurityPatchLevel                       = "2024-01-01";
                    SecurityRequiredAndroidSafetyNetEvaluationType     = "hardwareBacked"
                    WorkProfileInactiveBeforeScreenLockInMinutes       = 480
                    WorkProfilePasswordExpirationInDays                = 30
                    WorkProfilePasswordMinimumLength                   = 12
                    WorkProfilePasswordRequiredType                    = "atLeastNumeric"
                    WorkProfilePreviousPasswordBlockCount              = 5
                    WorkProfileRequiredPasswordComplexity              = "high"
                    WorkProfileRequirePassword                         = $True
                    Ensure                                             = 'Present'
                    Credential                                         = $Credential
                    RequiredPasswordComplexity                         = 'low'
                    SecurityBlockDeviceAdministratorManagedDevices     = $true
                    RestrictedApps                                     = @('App1', 'App2', 'App3')
                    ScheduledActionsForRule = [CimInstance[]]@(
                                                (New-CimInstance `
                                                -ClassName MSFT_scheduledActionConfigurations `
                                                -Property @{
                                                    actionType = 'block'
                                                    gracePeriodHours = 0
                                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                                } -ClientOnly)
                                                (New-CimInstance `
                                                -ClassName MSFT_scheduledActionConfigurations `
                                                -Property @{
                                                    actionType = 'pushNotification'
                                                    gracePeriodHours = 0
                                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                                } -ClientOnly)
                                                (New-CimInstance `
                                                -ClassName MSFT_scheduledActionConfigurations `
                                                -Property @{
                                                    actionType = 'remoteLock'
                                                    gracePeriodHours = 0
                                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                                } -ClientOnly)
                                                (New-CimInstance `
                                                -ClassName MSFT_scheduledActionConfigurations `
                                                -Property @{
                                                    actionType = 'Notification'
                                                    gracePeriodHours = 0
                                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                                    notificationMessageCCList = @('00000000-0000-0000-0000-000000000000','00000000-0000-0000-0000-000000000000')
                                                } -ClientOnly)
                        )

                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceCompliancePolicy -MockWith {
                    return @{
                        DisplayName                                    = 'Test Android Work Profile Device Compliance Policy'
                        Description                                    = 'Test Android Work Profile Device Compliance Policy Description'
                        Id                                             = '9c4e2ed7-706e-4874-a826-0c2778352d47'
                        ScheduledActionsForRule =@(
                        @{
                            ruleName = ''
                            scheduledActionConfigurations = @(
                                @{
                                    actionType = 'block'
                                    gracePeriodHours = 0
                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                    notificationMessageCCList = @()
                                },
                                @{
                                    actionType = 'pushNotification'
                                    gracePeriodHours = 0
                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                    notificationMessageCCList = @()
                                },
                                @{
                                    actionType = 'remoteLock'
                                    gracePeriodHours = 0
                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                    notificationMessageCCList = @()
                                },
                                @{
                                    actionType = 'Notification'
                                    gracePeriodHours = 0
                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                    notificationMessageCCList = @('00000000-0000-0000-0000-000000000000','00000000-0000-0000-0000-000000000000')
                                }
                            )
                          }
                        )
                        AdditionalProperties = @{
                            '@odata.type'                                      = '#microsoft.graph.androidWorkProfileCompliancePolicy'
                            PasswordRequired                                   = $True
                            PasswordMinimumLength                              = 6
                            PasswordRequiredType                               = 'DeviceDefault'
                            RequiredPasswordComplexity                         = 'low'
                            PasswordMinutesOfInactivityBeforeLock              = 5
                            PasswordExpirationDays                             = 365
                            PasswordPreviousPasswordBlockCount                 = 10
                            PasswordSignInFailureCountBeforeFactoryReset       = 11
                            SecurityPreventInstallAppsFromUnknownSources       = $True
                            SecurityDisableUsbDebugging                        = $True
                            SecurityRequireVerifyApps                          = $True
                            DeviceThreatProtectionEnabled                      = $True
                            DeviceThreatProtectionRequiredSecurityLevel        = 'Unavailable'
                            AdvancedThreatProtectionRequiredSecurityLevel      = 'Unavailable'
                            SecurityBlockJailbrokenDevices                     = $True
                            OsMinimumVersion                                   = 7
                            OsMaximumVersion                                   = 11
                            StorageRequireEncryption                           = $True
                            SecurityRequireSafetyNetAttestationBasicIntegrity  = $True
                            SecurityRequireSafetyNetAttestationCertifiedDevice = $True
                            SecurityRequireGooglePlayServices                  = $True
                            SecurityRequireUpToDateSecurityProviders           = $True
                            SecurityRequireCompanyPortalAppIntegrity           = $True
                            RoleScopeTagIds                                    = '0'
                            MinAndroidSecurityPatchLevel                       = "2024-01-01";
                            SecurityRequiredAndroidSafetyNetEvaluationType     = "hardwareBacked"
                            WorkProfileInactiveBeforeScreenLockInMinutes       = 480
                            WorkProfilePasswordExpirationInDays                = 30
                            WorkProfilePasswordMinimumLength                   = 12
                            WorkProfilePasswordRequiredType                    = "atLeastNumeric"
                            WorkProfilePreviousPasswordBlockCount              = 5
                            WorkProfileRequiredPasswordComplexity              = "high"
                            WorkProfileRequirePassword                         = $True
                            SecurityBlockDeviceAdministratorManagedDevices     = $true
                            RestrictedApps                                     = @('App1', 'App2', 'App3')
                        }
                    }
                }
            }

            It 'Should return Present from the Get method' {
                    (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update the iOS Device Compliance Policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgBetaDeviceManagementDeviceCompliancePolicy -Exactly 1
            }
        }

        Context -Name 'When the policy already exists and IS in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName                                        = 'Test Android Work Profile Device Compliance Policy'
                    Description                                        = 'Test Android Work Profile Device Compliance Policy Description'
                    PasswordRequired                                   = $True
                    PasswordMinimumLength                              = 6
                    PasswordRequiredType                               = 'DeviceDefault'
                    PasswordMinutesOfInactivityBeforeLock              = 5
                    PasswordExpirationDays                             = 365
                    PasswordPreviousPasswordBlockCount                 = 10
                    PasswordSignInFailureCountBeforeFactoryReset       = 11
                    SecurityPreventInstallAppsFromUnknownSources       = $True
                    SecurityDisableUsbDebugging                        = $True
                    SecurityRequireVerifyApps                          = $True
                    DeviceThreatProtectionEnabled                      = $True
                    DeviceThreatProtectionRequiredSecurityLevel        = 'Unavailable'
                    AdvancedThreatProtectionRequiredSecurityLevel      = 'Unavailable'
                    SecurityBlockJailbrokenDevices                     = $True
                    OsMinimumVersion                                   = 7
                    OsMaximumVersion                                   = 11
                    StorageRequireEncryption                           = $True
                    SecurityRequireSafetyNetAttestationBasicIntegrity  = $True
                    SecurityRequireSafetyNetAttestationCertifiedDevice = $True
                    SecurityRequireGooglePlayServices                  = $True
                    SecurityRequireUpToDateSecurityProviders           = $True
                    SecurityRequireCompanyPortalAppIntegrity           = $True
                    MinAndroidSecurityPatchLevel                       = "2024-01-01";
                    SecurityRequiredAndroidSafetyNetEvaluationType     = "hardwareBacked"
                    WorkProfileInactiveBeforeScreenLockInMinutes       = 480
                    WorkProfilePasswordExpirationInDays                = 30
                    WorkProfilePasswordMinimumLength                   = 12
                    WorkProfilePasswordRequiredType                    = "atLeastNumeric"
                    WorkProfilePreviousPasswordBlockCount              = 5
                    WorkProfileRequiredPasswordComplexity              = "high"
                    WorkProfileRequirePassword                         = $True
                    Ensure                                             = 'Present'
                    Credential                                         = $Credential
                    RequiredPasswordComplexity                         = 'low'
                    SecurityBlockDeviceAdministratorManagedDevices     = $true
                    RestrictedApps                                     = @('App1', 'App2', 'App3')
                    ScheduledActionsForRule = [CimInstance[]]@(
                                                (New-CimInstance `
                                                -ClassName MSFT_scheduledActionConfigurations `
                                                -Property @{
                                                    actionType = 'block'
                                                    gracePeriodHours = 0
                                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                                } -ClientOnly)
                                                (New-CimInstance `
                                                -ClassName MSFT_scheduledActionConfigurations `
                                                -Property @{
                                                    actionType = 'pushNotification'
                                                    gracePeriodHours = 0
                                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                                } -ClientOnly)
                                                (New-CimInstance `
                                                -ClassName MSFT_scheduledActionConfigurations `
                                                -Property @{
                                                    actionType = 'remoteLock'
                                                    gracePeriodHours = 0
                                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                                } -ClientOnly)
                                                (New-CimInstance `
                                                -ClassName MSFT_scheduledActionConfigurations `
                                                -Property @{
                                                    actionType = 'Notification'
                                                    gracePeriodHours = 0
                                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                                    notificationMessageCCList = @('00000000-0000-0000-0000-000000000000','00000000-0000-0000-0000-000000000000')
                                                } -ClientOnly)
                        )
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceCompliancePolicy -MockWith {
                    return @{
                        DisplayName                                    = 'Test Android Work Profile Device Compliance Policy'
                        Description                                    = 'Test Android Work Profile Device Compliance Policy Description'
                        Id                                             = '9c4e2ed7-706e-4874-a826-0c2778352d46'
                        ScheduledActionsForRule =@(
                        @{
                            ruleName = ''
                            scheduledActionConfigurations = @(
                                @{
                                    actionType = 'block'
                                    gracePeriodHours = 0
                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                    notificationMessageCCList = @()
                                },
                                @{
                                    actionType = 'pushNotification'
                                    gracePeriodHours = 0
                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                    notificationMessageCCList = @()
                                },
                                @{
                                    actionType = 'remoteLock'
                                    gracePeriodHours = 0
                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                    notificationMessageCCList = @()
                                },
                                @{
                                    actionType = 'Notification'
                                    gracePeriodHours = 0
                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                    notificationMessageCCList = @('00000000-0000-0000-0000-000000000000','00000000-0000-0000-0000-000000000000')
                                }
                            )
                          }
                        )
                        AdditionalProperties = @{
                            '@odata.type'                                      = '#microsoft.graph.androidWorkProfileCompliancePolicy'
                            PasswordRequired                                   = $True
                            PasswordMinimumLength                              = 6
                            PasswordRequiredType                               = 'DeviceDefault'
                            RequiredPasswordComplexity                         = 'low'
                            PasswordMinutesOfInactivityBeforeLock              = 5
                            PasswordExpirationDays                             = 365
                            PasswordPreviousPasswordBlockCount                 = 10
                            PasswordSignInFailureCountBeforeFactoryReset       = 11
                            SecurityPreventInstallAppsFromUnknownSources       = $True
                            SecurityDisableUsbDebugging                        = $True
                            SecurityRequireVerifyApps                          = $True
                            DeviceThreatProtectionEnabled                      = $True
                            DeviceThreatProtectionRequiredSecurityLevel        = 'Unavailable'
                            AdvancedThreatProtectionRequiredSecurityLevel      = 'Unavailable'
                            SecurityBlockJailbrokenDevices                     = $True
                            OsMinimumVersion                                   = 7
                            OsMaximumVersion                                   = 11
                            StorageRequireEncryption                           = $True
                            SecurityRequireSafetyNetAttestationBasicIntegrity  = $True
                            SecurityRequireSafetyNetAttestationCertifiedDevice = $True
                            SecurityRequireGooglePlayServices                  = $True
                            SecurityRequireUpToDateSecurityProviders           = $True
                            SecurityRequireCompanyPortalAppIntegrity           = $True
                            RoleScopeTagIds                                    = '0'
                            MinAndroidSecurityPatchLevel                       = "2024-01-01";
                            SecurityRequiredAndroidSafetyNetEvaluationType     = "hardwareBacked"
                            WorkProfileInactiveBeforeScreenLockInMinutes       = 480
                            WorkProfilePasswordExpirationInDays                = 30
                            WorkProfilePasswordMinimumLength                   = 12
                            WorkProfilePasswordRequiredType                    = "atLeastNumeric"
                            WorkProfilePreviousPasswordBlockCount              = 5
                            WorkProfileRequiredPasswordComplexity              = "high"
                            WorkProfileRequirePassword                         = $True
                            SecurityBlockDeviceAdministratorManagedDevices     = $true
                            RestrictedApps                                     = @('App1', 'App2', 'App3')
                        }
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'When the policy exists and it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    DisplayName                                        = 'Test Android Work Profile Device Compliance Policy'
                    Description                                        = 'Test Android Work Profile Device Compliance Policy Description'
                    PasswordRequired                                   = $True
                    PasswordMinimumLength                              = 6
                    PasswordRequiredType                               = 'DeviceDefault'
                    PasswordMinutesOfInactivityBeforeLock              = 5
                    PasswordExpirationDays                             = 365
                    PasswordPreviousPasswordBlockCount                 = 10
                    PasswordSignInFailureCountBeforeFactoryReset       = 11
                    SecurityPreventInstallAppsFromUnknownSources       = $True
                    SecurityDisableUsbDebugging                        = $True
                    SecurityRequireVerifyApps                          = $True
                    DeviceThreatProtectionEnabled                      = $True
                    DeviceThreatProtectionRequiredSecurityLevel        = 'Unavailable'
                    AdvancedThreatProtectionRequiredSecurityLevel      = 'Unavailable'
                    SecurityBlockJailbrokenDevices                     = $True
                    OsMinimumVersion                                   = 7
                    OsMaximumVersion                                   = 11
                    StorageRequireEncryption                           = $True
                    SecurityRequireSafetyNetAttestationBasicIntegrity  = $True
                    SecurityRequireSafetyNetAttestationCertifiedDevice = $True
                    SecurityRequireGooglePlayServices                  = $True
                    SecurityRequireUpToDateSecurityProviders           = $True
                    SecurityRequireCompanyPortalAppIntegrity           = $True
                    Ensure                                             = 'Absent'
                    Credential                                         = $Credential
                    RequiredPasswordComplexity                         = 'low'
                    SecurityBlockDeviceAdministratorManagedDevices     = $true
                    RestrictedApps                                     = @('App1', 'App2', 'App3')
                    ScheduledActionsForRule = [CimInstance[]]@(
                                                (New-CimInstance `
                                                -ClassName MSFT_scheduledActionConfigurations `
                                                -Property @{
                                                    actionType = 'block'
                                                    gracePeriodHours = 0
                                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                                } -ClientOnly)
                                                (New-CimInstance `
                                                -ClassName MSFT_scheduledActionConfigurations `
                                                -Property @{
                                                    actionType = 'pushNotification'
                                                    gracePeriodHours = 0
                                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                                } -ClientOnly)
                                                (New-CimInstance `
                                                -ClassName MSFT_scheduledActionConfigurations `
                                                -Property @{
                                                    actionType = 'remoteLock'
                                                    gracePeriodHours = 0
                                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                                } -ClientOnly)
                                                (New-CimInstance `
                                                -ClassName MSFT_scheduledActionConfigurations `
                                                -Property @{
                                                    actionType = 'Notification'
                                                    gracePeriodHours = 0
                                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                                    notificationMessageCCList = @('00000000-0000-0000-0000-000000000000','00000000-0000-0000-0000-000000000000')
                                                } -ClientOnly)
                        )
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceCompliancePolicy -MockWith {
                    return @{
                        DisplayName                                    = 'Test Android Work Profile Device Compliance Policy'
                        Description                                    = 'Test Android Work Profile Device Compliance Policy Description'
                        Id                                             = '9c4e2ed7-706e-4874-a826-0c2778352d46'
                        ScheduledActionsForRule =@(
                        @{
                            ruleName = ''
                            scheduledActionConfigurations = @(
                                @{
                                    actionType = 'block'
                                    gracePeriodHours = 0
                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                    notificationMessageCCList = @()
                                },
                                @{
                                    actionType = 'pushNotification'
                                    gracePeriodHours = 0
                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                    notificationMessageCCList = @()
                                },
                                @{
                                    actionType = 'remoteLock'
                                    gracePeriodHours = 0
                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                    notificationMessageCCList = @()
                                },
                                @{
                                    actionType = 'Notification'
                                    gracePeriodHours = 0
                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                    notificationMessageCCList = @('00000000-0000-0000-0000-000000000000','00000000-0000-0000-0000-000000000000')
                                }
                            )
                          }
                        )
                        AdditionalProperties = @{
                            '@odata.type'                                      = '#microsoft.graph.androidWorkProfileCompliancePolicy'
                            PasswordRequired                                   = $True
                            PasswordMinimumLength                              = 6
                            PasswordRequiredType                               = 'DeviceDefault'
                            RequiredPasswordComplexity                         = 'low'
                            PasswordMinutesOfInactivityBeforeLock              = 5
                            PasswordExpirationDays                             = 365
                            PasswordPreviousPasswordBlockCount                 = 10
                            PasswordSignInFailureCountBeforeFactoryReset       = 11
                            SecurityPreventInstallAppsFromUnknownSources       = $True
                            SecurityDisableUsbDebugging                        = $True
                            SecurityRequireVerifyApps                          = $True
                            DeviceThreatProtectionEnabled                      = $True
                            DeviceThreatProtectionRequiredSecurityLevel        = 'Unavailable'
                            AdvancedThreatProtectionRequiredSecurityLevel      = 'Unavailable'
                            SecurityBlockJailbrokenDevices                     = $True
                            OsMinimumVersion                                   = 7
                            OsMaximumVersion                                   = 11
                            StorageRequireEncryption                           = $True
                            SecurityRequireSafetyNetAttestationBasicIntegrity  = $True
                            SecurityRequireSafetyNetAttestationCertifiedDevice = $True
                            SecurityRequireGooglePlayServices                  = $True
                            SecurityRequireUpToDateSecurityProviders           = $True
                            SecurityRequireCompanyPortalAppIntegrity           = $True
                            RoleScopeTagIds                                    = '0'
                            SecurityBlockDeviceAdministratorManagedDevices     = $true
                            RestrictedApps                                     = @('App1', 'App2', 'App3')
                        }
                    }
                }
            }

            It 'Should return Present from the Get method' {
                    (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the iOS Device Compliance Policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementDeviceCompliancePolicy -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceCompliancePolicy -MockWith {
                    return @{
                        DisplayName                                    = 'Test Android Device Compliance Policy'
                        Description                                    = 'Test Android Device Compliance Policy Description'
                        Id                                             = '9c4e2ed7-706e-4874-a826-0c2778352d46'
                        ScheduledActionsForRule =@(
                        @{
                            ruleName = ''
                            scheduledActionConfigurations = @(
                                @{
                                    actionType = 'block'
                                    gracePeriodHours = 0
                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                    notificationMessageCCList = @()
                                },
                                @{
                                    actionType = 'pushNotification'
                                    gracePeriodHours = 0
                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                    notificationMessageCCList = @()
                                },
                                @{
                                    actionType = 'remoteLock'
                                    gracePeriodHours = 0
                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                    notificationMessageCCList = @()
                                },
                                @{
                                    actionType = 'Notification'
                                    gracePeriodHours = 0
                                    notificationTemplateId = '00000000-0000-0000-0000-000000000000'
                                    notificationMessageCCList = @('00000000-0000-0000-0000-000000000000','00000000-0000-0000-0000-000000000000')
                                }
                            )
                          }
                        )
                        AdditionalProperties = @{
                            '@odata.type'                                      = '#microsoft.graph.androidWorkProfileCompliancePolicy'
                            PasswordRequired                                   = $True
                            PasswordMinimumLength                              = 6
                            PasswordRequiredType                               = 'DeviceDefault'
                            RequiredPasswordComplexity                         = 'low'
                            PasswordMinutesOfInactivityBeforeLock              = 5
                            PasswordExpirationDays                             = 365
                            PasswordPreviousPasswordBlockCount                 = 10
                            PasswordSignInFailureCountBeforeFactoryReset       = 11
                            SecurityPreventInstallAppsFromUnknownSources       = $True
                            SecurityDisableUsbDebugging                        = $True
                            SecurityRequireVerifyApps                          = $True
                            DeviceThreatProtectionEnabled                      = $True
                            DeviceThreatProtectionRequiredSecurityLevel        = 'Unavailable'
                            AdvancedThreatProtectionRequiredSecurityLevel      = 'Unavailable'
                            SecurityBlockJailbrokenDevices                     = $True
                            OsMinimumVersion                                   = 7
                            OsMaximumVersion                                   = 11
                            StorageRequireEncryption                           = $True
                            SecurityRequireSafetyNetAttestationBasicIntegrity  = $True
                            SecurityRequireSafetyNetAttestationCertifiedDevice = $True
                            SecurityRequireGooglePlayServices                  = $True
                            SecurityRequireUpToDateSecurityProviders           = $True
                            SecurityRequireCompanyPortalAppIntegrity           = $True
                            SecurityBlockDeviceAdministratorManagedDevices     = $true
                            RestrictedApps                                     = @('App1', 'App2', 'App3')
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
