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
    -DscResource 'IntuneDeviceConfigurationPolicyAndroidDeviceOwner' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString 'test@password1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)


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
            Mock -CommandName Get-MgDeviceManagementDeviceConfigurationAssignment -MockWith {
                return @()
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name "The IntuneDeviceConfigurationPolicyAndroidDeviceOwner should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                        AccountsBlockModification = $True
                        AppsAllowInstallFromUnknownSources = $True
                        AppsAutoUpdatePolicy = "notConfigured"
                        AppsDefaultPermissionPolicy = "deviceDefault"
                        AppsRecommendSkippingFirstUseHints = $True
                        AzureAdSharedDeviceDataClearApps =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                                appId = "FakeStringValue"
                                publisher = "FakeStringValue"
                                appStoreUrl = "FakeStringValue"
                                name = "FakeStringValue"
                                odataType = "#microsoft.graph.appleAppListItem"
                            } -ClientOnly)
                        )
                        BluetoothBlockConfiguration = $True
                        BluetoothBlockContactSharing = $True
                        CameraBlocked = $True
                        CellularBlockWiFiTethering = $True
                        CertificateCredentialConfigurationDisabled = $True
                        CrossProfilePoliciesAllowCopyPaste = $True
                        CrossProfilePoliciesAllowDataSharing = "notConfigured"
                        CrossProfilePoliciesShowWorkContactsInPersonalProfile = $True
                        DataRoamingBlocked = $True
                        DateTimeConfigurationBlocked = $True
                        Description = "FakeStringValue"
                        DetailedHelpText = (New-CimInstance -ClassName MSFT_MicrosoftGraphandroiddeviceowneruserfacingmessage -Property @{
                            defaultMessage = "FakeStringValue"
                            localizedMessages = [CimInstance[]]@()
                        } -ClientOnly)
                        DeviceOwnerLockScreenMessage = (New-CimInstance -ClassName MSFT_MicrosoftGraphandroiddeviceowneruserfacingmessage -Property @{
                            defaultMessage = "FakeStringValue"
                            localizedMessages = [CimInstance[]]@()
                        } -ClientOnly)
                        DisplayName = "FakeStringValue"
                        EnrollmentProfile = "notConfigured"
                        FactoryResetBlocked = $True
                        GlobalProxy = (New-CimInstance -ClassName MSFT_MicrosoftGraphandroiddeviceownerglobalproxy -Property @{
                            proxyAutoConfigURL = "FakeStringValue"
                            odataType = "#microsoft.graph.androidDeviceOwnerGlobalProxyAutoConfig"
                        } -ClientOnly)
                        GoogleAccountsBlocked = $True
                        Id = "FakeStringValue"
                        KioskCustomizationDeviceSettingsBlocked = $True
                        KioskCustomizationPowerButtonActionsBlocked = $True
                        KioskCustomizationStatusBar = "notConfigured"
                        KioskCustomizationSystemErrorWarnings = $True
                        KioskCustomizationSystemNavigation = "notConfigured"
                        KioskModeAppOrderEnabled = $True
                        KioskModeAppPositions =@()
                        KioskModeApps =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                                appId = "FakeStringValue"
                                publisher = "FakeStringValue"
                                appStoreUrl = "FakeStringValue"
                                name = "FakeStringValue"
                                odataType = "#microsoft.graph.appleAppListItem"
                            } -ClientOnly)
                        )
                        KioskModeAppsInFolderOrderedByName = $True
                        KioskModeBluetoothConfigurationEnabled = $True
                        KioskModeDebugMenuEasyAccessEnabled = $True
                        KioskModeExitCode = "FakeStringValue"
                        KioskModeFlashlightConfigurationEnabled = $True
                        KioskModeFolderIcon = "notConfigured"
                        KioskModeGridHeight = 25
                        KioskModeGridWidth = 25
                        KioskModeIconSize = "notConfigured"
                        KioskModeLockHomeScreen = $True
                        KioskModeManagedFolders =@()
                        KioskModeManagedHomeScreenAutoSignout = $True
                        KioskModeManagedHomeScreenInactiveSignOutDelayInSeconds = 25
                        KioskModeManagedHomeScreenInactiveSignOutNoticeInSeconds = 25
                        KioskModeManagedHomeScreenPinComplexity = "notConfigured"
                        KioskModeManagedHomeScreenPinRequired = $True
                        KioskModeManagedHomeScreenPinRequiredToResume = $True
                        KioskModeManagedHomeScreenSignInBackground = "FakeStringValue"
                        KioskModeManagedHomeScreenSignInBrandingLogo = "FakeStringValue"
                        KioskModeManagedHomeScreenSignInEnabled = $True
                        KioskModeManagedSettingsEntryDisabled = $True
                        KioskModeMediaVolumeConfigurationEnabled = $True
                        KioskModeScreenOrientation = "notConfigured"
                        KioskModeScreenSaverConfigurationEnabled = $True
                        KioskModeScreenSaverDetectMediaDisabled = $True
                        KioskModeScreenSaverDisplayTimeInSeconds = 25
                        KioskModeScreenSaverImageUrl = "FakeStringValue"
                        KioskModeScreenSaverStartDelayInSeconds = 25
                        KioskModeShowAppNotificationBadge = $True
                        KioskModeShowDeviceInfo = $True
                        KioskModeUseManagedHomeScreenApp = "notConfigured"
                        KioskModeVirtualHomeButtonEnabled = $True
                        KioskModeVirtualHomeButtonType = "notConfigured"
                        KioskModeWallpaperUrl = "FakeStringValue"
                        KioskModeWiFiConfigurationEnabled = $True
                        MicrophoneForceMute = $True
                        MicrosoftLauncherConfigurationEnabled = $True
                        MicrosoftLauncherCustomWallpaperAllowUserModification = $True
                        MicrosoftLauncherCustomWallpaperEnabled = $True
                        MicrosoftLauncherCustomWallpaperImageUrl = "FakeStringValue"
                        MicrosoftLauncherDockPresenceAllowUserModification = $True
                        MicrosoftLauncherDockPresenceConfiguration = "notConfigured"
                        MicrosoftLauncherFeedAllowUserModification = $True
                        MicrosoftLauncherFeedEnabled = $True
                        MicrosoftLauncherSearchBarPlacementConfiguration = "notConfigured"
                        NetworkEscapeHatchAllowed = $True
                        NfcBlockOutgoingBeam = $True
                        PasswordBlockKeyguard = $True
                        PasswordExpirationDays = 25
                        PasswordMinimumLength = 25
                        PasswordMinimumLetterCharacters = 25
                        PasswordMinimumLowerCaseCharacters = 25
                        PasswordMinimumNonLetterCharacters = 25
                        PasswordMinimumNumericCharacters = 25
                        PasswordMinimumSymbolCharacters = 25
                        PasswordMinimumUpperCaseCharacters = 25
                        PasswordMinutesOfInactivityBeforeScreenTimeout = 25
                        PasswordPreviousPasswordCountToBlock = 25
                        PasswordRequiredType = "deviceDefault"
                        PasswordRequireUnlock = "deviceDefault"
                        PasswordSignInFailureCountBeforeFactoryReset = 25
                        PersonalProfileAppsAllowInstallFromUnknownSources = $True
                        PersonalProfileCameraBlocked = $True
                        PersonalProfilePersonalApplications =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                                appId = "FakeStringValue"
                                publisher = "FakeStringValue"
                                appStoreUrl = "FakeStringValue"
                                name = "FakeStringValue"
                                odataType = "#microsoft.graph.appleAppListItem"
                            } -ClientOnly)
                        )
                        PersonalProfilePlayStoreMode = "notConfigured"
                        PersonalProfileScreenCaptureBlocked = $True
                        PlayStoreMode = "notConfigured"
                        ScreenCaptureBlocked = $True
                        SecurityCommonCriteriaModeEnabled = $True
                        SecurityDeveloperSettingsEnabled = $True
                        SecurityRequireVerifyApps = $True
                        ShortHelpText =(New-CimInstance -ClassName MSFT_MicrosoftGraphandroiddeviceowneruserfacingmessage -Property @{
                            defaultMessage = "FakeStringValue"
                            localizedMessages = [CimInstance[]]@()
                        } -ClientOnly)
                        StatusBarBlocked = $True
                        StorageAllowUsb = $True
                        StorageBlockExternalMedia = $True
                        StorageBlockUsbFileTransfer = $True
                        SystemUpdateFreezePeriods =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphandroiddeviceownersystemupdatefreezeperiod -Property @{
                                endMonth = 25
                                startMonth = 25
                                startDay = 25
                                endDay = 25
                            } -ClientOnly)
                        )
                        SystemUpdateInstallType = "deviceDefault"
                        SystemUpdateWindowEndMinutesAfterMidnight = 25
                        SystemUpdateWindowStartMinutesAfterMidnight = 25
                        SystemWindowsBlocked = $True
                        UsersBlockAdd = $True
                        UsersBlockRemove = $True
                        VolumeBlockAdjustment = $True
                        VpnAlwaysOnLockdownMode = $True
                        VpnAlwaysOnPackageIdentifier = "FakeStringValue"
                        WifiBlockEditConfigurations = $True
                        WifiBlockEditPolicyDefinedConfigurations = $True
                        WorkProfilePasswordExpirationDays = 25
                        WorkProfilePasswordMinimumLength = 25
                        WorkProfilePasswordMinimumLetterCharacters = 25
                        WorkProfilePasswordMinimumLowerCaseCharacters = 25
                        WorkProfilePasswordMinimumNonLetterCharacters = 25
                        WorkProfilePasswordMinimumNumericCharacters = 25
                        WorkProfilePasswordMinimumSymbolCharacters = 25
                        WorkProfilePasswordMinimumUpperCaseCharacters = 25
                        WorkProfilePasswordPreviousPasswordCountToBlock = 25
                        WorkProfilePasswordRequiredType = "deviceDefault"
                        WorkProfilePasswordRequireUnlock = "deviceDefault"
                        WorkProfilePasswordSignInFailureCountBeforeFactoryReset = 25

                    Ensure                        = "Present"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
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
                Should -Invoke -CommandName New-MgDeviceManagementDeviceConfiguration -Exactly 1
            }
        }
        Context -Name "The IntuneDeviceConfigurationPolicyAndroidDeviceOwner exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                        AccountsBlockModification = $True
                        AppsAllowInstallFromUnknownSources = $True
                        AppsAutoUpdatePolicy = "notConfigured"
                        AppsDefaultPermissionPolicy = "deviceDefault"
                        AppsRecommendSkippingFirstUseHints = $True
                        AzureAdSharedDeviceDataClearApps =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                                appId = "FakeStringValue"
                                publisher = "FakeStringValue"
                                appStoreUrl = "FakeStringValue"
                                name = "FakeStringValue"
                                odataType = "#microsoft.graph.appleAppListItem"
                            } -ClientOnly)
                        )
                        BluetoothBlockConfiguration = $True
                        BluetoothBlockContactSharing = $True
                        CameraBlocked = $True
                        CellularBlockWiFiTethering = $True
                        CertificateCredentialConfigurationDisabled = $True
                        CrossProfilePoliciesAllowCopyPaste = $True
                        CrossProfilePoliciesAllowDataSharing = "notConfigured"
                        CrossProfilePoliciesShowWorkContactsInPersonalProfile = $True
                        DataRoamingBlocked = $True
                        DateTimeConfigurationBlocked = $True
                        Description = "FakeStringValue"
                        DetailedHelpText =(New-CimInstance -ClassName MSFT_MicrosoftGraphandroiddeviceowneruserfacingmessage -Property @{
                            defaultMessage = "FakeStringValue"
                            localizedMessages = [CimInstance[]]@()
                        } -ClientOnly)
                        DeviceOwnerLockScreenMessage =(New-CimInstance -ClassName MSFT_MicrosoftGraphandroiddeviceowneruserfacingmessage -Property @{
                            defaultMessage = "FakeStringValue"
                            localizedMessages = [CimInstance[]]@()
                        } -ClientOnly)
                        DisplayName = "FakeStringValue"
                        EnrollmentProfile = "notConfigured"
                        FactoryResetBlocked = $True
                        GlobalProxy =(New-CimInstance -ClassName MSFT_MicrosoftGraphandroiddeviceownerglobalproxy -Property @{
                            proxyAutoConfigURL = "FakeStringValue"
                            odataType = "#microsoft.graph.androidDeviceOwnerGlobalProxyAutoConfig"
                        } -ClientOnly)
                        GoogleAccountsBlocked = $True
                        Id = "FakeStringValue"
                        KioskCustomizationDeviceSettingsBlocked = $True
                        KioskCustomizationPowerButtonActionsBlocked = $True
                        KioskCustomizationStatusBar = "notConfigured"
                        KioskCustomizationSystemErrorWarnings = $True
                        KioskCustomizationSystemNavigation = "notConfigured"
                        KioskModeAppOrderEnabled = $True
                        KioskModeAppPositions =@()
                        KioskModeApps =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                                appId = "FakeStringValue"
                                publisher = "FakeStringValue"
                                appStoreUrl = "FakeStringValue"
                                name = "FakeStringValue"
                                odataType = "#microsoft.graph.appleAppListItem"
                            } -ClientOnly)
                        )
                        KioskModeAppsInFolderOrderedByName = $True
                        KioskModeBluetoothConfigurationEnabled = $True
                        KioskModeDebugMenuEasyAccessEnabled = $True
                        KioskModeExitCode = "FakeStringValue"
                        KioskModeFlashlightConfigurationEnabled = $True
                        KioskModeFolderIcon = "notConfigured"
                        KioskModeGridHeight = 25
                        KioskModeGridWidth = 25
                        KioskModeIconSize = "notConfigured"
                        KioskModeLockHomeScreen = $True
                        KioskModeManagedFolders =@()
                        KioskModeManagedHomeScreenAutoSignout = $True
                        KioskModeManagedHomeScreenInactiveSignOutDelayInSeconds = 25
                        KioskModeManagedHomeScreenInactiveSignOutNoticeInSeconds = 25
                        KioskModeManagedHomeScreenPinComplexity = "notConfigured"
                        KioskModeManagedHomeScreenPinRequired = $True
                        KioskModeManagedHomeScreenPinRequiredToResume = $True
                        KioskModeManagedHomeScreenSignInBackground = "FakeStringValue"
                        KioskModeManagedHomeScreenSignInBrandingLogo = "FakeStringValue"
                        KioskModeManagedHomeScreenSignInEnabled = $True
                        KioskModeManagedSettingsEntryDisabled = $True
                        KioskModeMediaVolumeConfigurationEnabled = $True
                        KioskModeScreenOrientation = "notConfigured"
                        KioskModeScreenSaverConfigurationEnabled = $True
                        KioskModeScreenSaverDetectMediaDisabled = $True
                        KioskModeScreenSaverDisplayTimeInSeconds = 25
                        KioskModeScreenSaverImageUrl = "FakeStringValue"
                        KioskModeScreenSaverStartDelayInSeconds = 25
                        KioskModeShowAppNotificationBadge = $True
                        KioskModeShowDeviceInfo = $True
                        KioskModeUseManagedHomeScreenApp = "notConfigured"
                        KioskModeVirtualHomeButtonEnabled = $True
                        KioskModeVirtualHomeButtonType = "notConfigured"
                        KioskModeWallpaperUrl = "FakeStringValue"
                        KioskModeWiFiConfigurationEnabled = $True
                        MicrophoneForceMute = $True
                        MicrosoftLauncherConfigurationEnabled = $True
                        MicrosoftLauncherCustomWallpaperAllowUserModification = $True
                        MicrosoftLauncherCustomWallpaperEnabled = $True
                        MicrosoftLauncherCustomWallpaperImageUrl = "FakeStringValue"
                        MicrosoftLauncherDockPresenceAllowUserModification = $True
                        MicrosoftLauncherDockPresenceConfiguration = "notConfigured"
                        MicrosoftLauncherFeedAllowUserModification = $True
                        MicrosoftLauncherFeedEnabled = $True
                        MicrosoftLauncherSearchBarPlacementConfiguration = "notConfigured"
                        NetworkEscapeHatchAllowed = $True
                        NfcBlockOutgoingBeam = $True
                        PasswordBlockKeyguard = $True
                        PasswordExpirationDays = 25
                        PasswordMinimumLength = 25
                        PasswordMinimumLetterCharacters = 25
                        PasswordMinimumLowerCaseCharacters = 25
                        PasswordMinimumNonLetterCharacters = 25
                        PasswordMinimumNumericCharacters = 25
                        PasswordMinimumSymbolCharacters = 25
                        PasswordMinimumUpperCaseCharacters = 25
                        PasswordMinutesOfInactivityBeforeScreenTimeout = 25
                        PasswordPreviousPasswordCountToBlock = 25
                        PasswordRequiredType = "deviceDefault"
                        PasswordRequireUnlock = "deviceDefault"
                        PasswordSignInFailureCountBeforeFactoryReset = 25
                        PersonalProfileAppsAllowInstallFromUnknownSources = $True
                        PersonalProfileCameraBlocked = $True
                        PersonalProfilePersonalApplications =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                                appId = "FakeStringValue"
                                publisher = "FakeStringValue"
                                appStoreUrl = "FakeStringValue"
                                name = "FakeStringValue"
                                odataType = "#microsoft.graph.appleAppListItem"
                            } -ClientOnly)
                        )
                        PersonalProfilePlayStoreMode = "notConfigured"
                        PersonalProfileScreenCaptureBlocked = $True
                        PlayStoreMode = "notConfigured"
                        ScreenCaptureBlocked = $True
                        SecurityCommonCriteriaModeEnabled = $True
                        SecurityDeveloperSettingsEnabled = $True
                        SecurityRequireVerifyApps = $True
                        ShortHelpText =(New-CimInstance -ClassName MSFT_MicrosoftGraphandroiddeviceowneruserfacingmessage -Property @{
                            defaultMessage = "FakeStringValue"
                            localizedMessages = [CimInstance[]]@()
                        } -ClientOnly)
                        StatusBarBlocked = $True
                        StorageAllowUsb = $True
                        StorageBlockExternalMedia = $True
                        StorageBlockUsbFileTransfer = $True
                        SystemUpdateFreezePeriods =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphandroiddeviceownersystemupdatefreezeperiod -Property @{
                                endMonth = 25
                                startMonth = 25
                                startDay = 25
                                endDay = 25
                            } -ClientOnly)
                        )
                        SystemUpdateInstallType = "deviceDefault"
                        SystemUpdateWindowEndMinutesAfterMidnight = 25
                        SystemUpdateWindowStartMinutesAfterMidnight = 25
                        SystemWindowsBlocked = $True
                        UsersBlockAdd = $True
                        UsersBlockRemove = $True
                        VolumeBlockAdjustment = $True
                        VpnAlwaysOnLockdownMode = $True
                        VpnAlwaysOnPackageIdentifier = "FakeStringValue"
                        WifiBlockEditConfigurations = $True
                        WifiBlockEditPolicyDefinedConfigurations = $True
                        WorkProfilePasswordExpirationDays = 25
                        WorkProfilePasswordMinimumLength = 25
                        WorkProfilePasswordMinimumLetterCharacters = 25
                        WorkProfilePasswordMinimumLowerCaseCharacters = 25
                        WorkProfilePasswordMinimumNonLetterCharacters = 25
                        WorkProfilePasswordMinimumNumericCharacters = 25
                        WorkProfilePasswordMinimumSymbolCharacters = 25
                        WorkProfilePasswordMinimumUpperCaseCharacters = 25
                        WorkProfilePasswordPreviousPasswordCountToBlock = 25
                        WorkProfilePasswordRequiredType = "deviceDefault"
                        WorkProfilePasswordRequireUnlock = "deviceDefault"
                        WorkProfilePasswordSignInFailureCountBeforeFactoryReset = 25

                    Ensure                        = "Absent"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties =@{
                            VolumeBlockAdjustment = $True
                            ScreenCaptureBlocked = $True
                            KioskModeMediaVolumeConfigurationEnabled = $True
                            KioskModeManagedHomeScreenPinRequired = $True
                            KioskModeBluetoothConfigurationEnabled = $True
                            StorageBlockExternalMedia = $True
                            WorkProfilePasswordMinimumLowerCaseCharacters = 25
                            WorkProfilePasswordRequireUnlock = "deviceDefault"
                            SystemUpdateFreezePeriods =@(
                                @{
                                    endMonth = 25
                                    startMonth = 25
                                    startDay = 25
                                    endDay = 25
                                }
                            )
                            BluetoothBlockConfiguration = $True
                            DeviceOwnerLockScreenMessage =@{
                                defaultMessage = "FakeStringValue"
                                localizedMessages = [CimInstance[]]@()
                            }
                            MicrosoftLauncherDockPresenceAllowUserModification = $True
                            GlobalProxy =@{
                                '@odata.type' = "#microsoft.graph.androidDeviceOwnerGlobalProxyAutoConfig"
                                proxyAutoConfigURL = "FakeStringValue"
                            }
                            KioskModeExitCode = "FakeStringValue"
                            CrossProfilePoliciesShowWorkContactsInPersonalProfile = $True
                            StorageAllowUsb = $True
                            AppsDefaultPermissionPolicy = "deviceDefault"
                            AccountsBlockModification = $True
                            KioskModeShowDeviceInfo = $True
                            KioskModeScreenSaverDetectMediaDisabled = $True
                            PersonalProfileCameraBlocked = $True
                            WifiBlockEditConfigurations = $True
                            KioskModeScreenSaverImageUrl = "FakeStringValue"
                            GoogleAccountsBlocked = $True
                            KioskModeScreenSaverDisplayTimeInSeconds = 25
                            MicrophoneForceMute = $True
                            PasswordMinimumNumericCharacters = 25
                            CrossProfilePoliciesAllowDataSharing = "notConfigured"
                            DetailedHelpText =@{
                                defaultMessage = "FakeStringValue"
                                localizedMessages = [CimInstance[]]@()
                            }
                            WorkProfilePasswordMinimumLength = 25
                            KioskModeManagedHomeScreenPinComplexity = "notConfigured"
                            PasswordMinimumUpperCaseCharacters = 25
                            KioskModeFolderIcon = "notConfigured"
                            KioskModeScreenSaverStartDelayInSeconds = 25
                            MicrosoftLauncherCustomWallpaperAllowUserModification = $True
                            KioskModeAppOrderEnabled = $True
                            KioskModeVirtualHomeButtonEnabled = $True
                            MicrosoftLauncherFeedEnabled = $True
                            BluetoothBlockContactSharing = $True
                            SecurityCommonCriteriaModeEnabled = $True
                            KioskModeGridWidth = 25
                            PersonalProfilePlayStoreMode = "notConfigured"
                            KioskCustomizationStatusBar = "notConfigured"
                            KioskModeWallpaperUrl = "FakeStringValue"
                            NetworkEscapeHatchAllowed = $True
                            KioskModeFlashlightConfigurationEnabled = $True
                            VpnAlwaysOnLockdownMode = $True
                            StatusBarBlocked = $True
                            SystemUpdateWindowStartMinutesAfterMidnight = 25
                            SecurityRequireVerifyApps = $True
                            KioskModeManagedHomeScreenSignInBrandingLogo = "FakeStringValue"
                            KioskModeDebugMenuEasyAccessEnabled = $True
                            WifiBlockEditPolicyDefinedConfigurations = $True
                            PasswordMinimumSymbolCharacters = 25
                            KioskModeScreenOrientation = "notConfigured"
                            PersonalProfileAppsAllowInstallFromUnknownSources = $True
                            CameraBlocked = $True
                            WorkProfilePasswordMinimumSymbolCharacters = 25
                            KioskModeManagedHomeScreenInactiveSignOutDelayInSeconds = 25
                            WorkProfilePasswordRequiredType = "deviceDefault"
                            CertificateCredentialConfigurationDisabled = $True
                            KioskCustomizationSystemNavigation = "notConfigured"
                            WorkProfilePasswordExpirationDays = 25
                            WorkProfilePasswordMinimumLetterCharacters = 25
                            KioskCustomizationSystemErrorWarnings = $True
                            WorkProfilePasswordMinimumNumericCharacters = 25
                            PasswordMinimumLength = 25
                            KioskModeWiFiConfigurationEnabled = $True
                            PasswordMinimumLowerCaseCharacters = 25
                            StorageBlockUsbFileTransfer = $True
                            WorkProfilePasswordPreviousPasswordCountToBlock = 25
                            AppsAllowInstallFromUnknownSources = $True
                            PersonalProfileScreenCaptureBlocked = $True
                            KioskCustomizationPowerButtonActionsBlocked = $True
                            KioskModeManagedSettingsEntryDisabled = $True
                            MicrosoftLauncherCustomWallpaperImageUrl = "FakeStringValue"
                            KioskModeAppsInFolderOrderedByName = $True
                            DataRoamingBlocked = $True
                            MicrosoftLauncherCustomWallpaperEnabled = $True
                            KioskCustomizationDeviceSettingsBlocked = $True
                            UsersBlockAdd = $True
                            PasswordMinutesOfInactivityBeforeScreenTimeout = 25
                            AppsRecommendSkippingFirstUseHints = $True
                            PasswordRequiredType = "deviceDefault"
                            KioskModeManagedHomeScreenSignInEnabled = $True
                            DateTimeConfigurationBlocked = $True
                            KioskModeManagedHomeScreenSignInBackground = "FakeStringValue"
                            FactoryResetBlocked = $True
                            KioskModeLockHomeScreen = $True
                            KioskModeShowAppNotificationBadge = $True
                            SystemWindowsBlocked = $True
                            KioskModeAppPositions =@()
                            AzureAdSharedDeviceDataClearApps =@(
                                @{
                                    name = "FakeStringValue"
                                    appId = "FakeStringValue"
                                    appStoreUrl = "FakeStringValue"
                                    '@odata.type' = "#microsoft.graph.appleAppListItem"
                                    publisher = "FakeStringValue"
                                }
                            )
                            PlayStoreMode = "notConfigured"
                            WorkProfilePasswordMinimumUpperCaseCharacters = 25
                            PasswordPreviousPasswordCountToBlock = 25
                            SystemUpdateInstallType = "deviceDefault"
                            SecurityDeveloperSettingsEnabled = $True
                            MicrosoftLauncherConfigurationEnabled = $True
                            MicrosoftLauncherFeedAllowUserModification = $True
                            KioskModeGridHeight = 25
                            PasswordExpirationDays = 25
                            WorkProfilePasswordMinimumNonLetterCharacters = 25
                            WorkProfilePasswordSignInFailureCountBeforeFactoryReset = 25
                            KioskModeManagedFolders =@()
                            ShortHelpText =@{
                                defaultMessage = "FakeStringValue"
                                localizedMessages = [CimInstance[]]@()
                            }
                            KioskModeIconSize = "notConfigured"
                            AppsAutoUpdatePolicy = "notConfigured"
                            KioskModeScreenSaverConfigurationEnabled = $True
                            PasswordRequireUnlock = "deviceDefault"
                            MicrosoftLauncherDockPresenceConfiguration = "notConfigured"
                            KioskModeManagedHomeScreenInactiveSignOutNoticeInSeconds = 25
                            VpnAlwaysOnPackageIdentifier = "FakeStringValue"
                            CrossProfilePoliciesAllowCopyPaste = $True
                            KioskModeApps =@(
                                @{
                                    name = "FakeStringValue"
                                    appId = "FakeStringValue"
                                    appStoreUrl = "FakeStringValue"
                                    '@odata.type' = "#microsoft.graph.appleAppListItem"
                                    publisher = "FakeStringValue"
                                }
                            )
                            KioskModeManagedHomeScreenAutoSignout = $True
                            KioskModeUseManagedHomeScreenApp = "notConfigured"
                            KioskModeManagedHomeScreenPinRequiredToResume = $True
                            NfcBlockOutgoingBeam = $True
                            '@odata.type' = "#microsoft.graph.androidDeviceOwnerGeneralDeviceConfiguration"
                            PersonalProfilePersonalApplications =@(
                                @{
                                    name = "FakeStringValue"
                                    appId = "FakeStringValue"
                                    appStoreUrl = "FakeStringValue"
                                    '@odata.type' = "#microsoft.graph.appleAppListItem"
                                    publisher = "FakeStringValue"
                                }
                            )
                            PasswordBlockKeyguard = $True
                            MicrosoftLauncherSearchBarPlacementConfiguration = "notConfigured"
                            SystemUpdateWindowEndMinutesAfterMidnight = 25
                            PasswordMinimumLetterCharacters = 25
                            KioskModeVirtualHomeButtonType = "notConfigured"
                            CellularBlockWiFiTethering = $True
                            EnrollmentProfile = "notConfigured"
                            PasswordSignInFailureCountBeforeFactoryReset = 25
                            PasswordMinimumNonLetterCharacters = 25
                            UsersBlockRemove = $True
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

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name "The IntuneDeviceConfigurationPolicyAndroidDeviceOwner Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                        AccountsBlockModification = $True
                        AppsAllowInstallFromUnknownSources = $True
                        AppsAutoUpdatePolicy = "notConfigured"
                        AppsDefaultPermissionPolicy = "deviceDefault"
                        AppsRecommendSkippingFirstUseHints = $True
                        AzureAdSharedDeviceDataClearApps =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                                appId = "FakeStringValue"
                                publisher = "FakeStringValue"
                                appStoreUrl = "FakeStringValue"
                                name = "FakeStringValue"
                                odataType = "#microsoft.graph.appleAppListItem"
                            } -ClientOnly)
                        )
                        BluetoothBlockConfiguration = $True
                        BluetoothBlockContactSharing = $True
                        CameraBlocked = $True
                        CellularBlockWiFiTethering = $True
                        CertificateCredentialConfigurationDisabled = $True
                        CrossProfilePoliciesAllowCopyPaste = $True
                        CrossProfilePoliciesAllowDataSharing = "notConfigured"
                        CrossProfilePoliciesShowWorkContactsInPersonalProfile = $True
                        DataRoamingBlocked = $True
                        DateTimeConfigurationBlocked = $True
                        Description = "FakeStringValue"
                        DetailedHelpText =(New-CimInstance -ClassName MSFT_MicrosoftGraphandroiddeviceowneruserfacingmessage -Property @{
                            defaultMessage = "FakeStringValue"
                            localizedMessages = [CimInstance[]]@()
                        } -ClientOnly)
                        DeviceOwnerLockScreenMessage =(New-CimInstance -ClassName MSFT_MicrosoftGraphandroiddeviceowneruserfacingmessage -Property @{
                            defaultMessage = "FakeStringValue"
                            localizedMessages = [CimInstance[]]@()
                        } -ClientOnly)
                        DisplayName = "FakeStringValue"
                        EnrollmentProfile = "notConfigured"
                        FactoryResetBlocked = $True
                        GlobalProxy =(New-CimInstance -ClassName MSFT_MicrosoftGraphandroiddeviceownerglobalproxy -Property @{
                            proxyAutoConfigURL = "FakeStringValue"
                            odataType = "#microsoft.graph.androidDeviceOwnerGlobalProxyAutoConfig"
                        } -ClientOnly)
                        GoogleAccountsBlocked = $True
                        Id = "FakeStringValue"
                        KioskCustomizationDeviceSettingsBlocked = $True
                        KioskCustomizationPowerButtonActionsBlocked = $True
                        KioskCustomizationStatusBar = "notConfigured"
                        KioskCustomizationSystemErrorWarnings = $True
                        KioskCustomizationSystemNavigation = "notConfigured"
                        KioskModeAppOrderEnabled = $True
                        KioskModeAppPositions =@()
                        KioskModeApps =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                                appId = "FakeStringValue"
                                publisher = "FakeStringValue"
                                appStoreUrl = "FakeStringValue"
                                name = "FakeStringValue"
                                odataType = "#microsoft.graph.appleAppListItem"
                            } -ClientOnly)
                        )
                        KioskModeAppsInFolderOrderedByName = $True
                        KioskModeBluetoothConfigurationEnabled = $True
                        KioskModeDebugMenuEasyAccessEnabled = $True
                        KioskModeExitCode = "FakeStringValue"
                        KioskModeFlashlightConfigurationEnabled = $True
                        KioskModeFolderIcon = "notConfigured"
                        KioskModeGridHeight = 25
                        KioskModeGridWidth = 25
                        KioskModeIconSize = "notConfigured"
                        KioskModeLockHomeScreen = $True
                        KioskModeManagedFolders =@()
                        KioskModeManagedHomeScreenAutoSignout = $True
                        KioskModeManagedHomeScreenInactiveSignOutDelayInSeconds = 25
                        KioskModeManagedHomeScreenInactiveSignOutNoticeInSeconds = 25
                        KioskModeManagedHomeScreenPinComplexity = "notConfigured"
                        KioskModeManagedHomeScreenPinRequired = $True
                        KioskModeManagedHomeScreenPinRequiredToResume = $True
                        KioskModeManagedHomeScreenSignInBackground = "FakeStringValue"
                        KioskModeManagedHomeScreenSignInBrandingLogo = "FakeStringValue"
                        KioskModeManagedHomeScreenSignInEnabled = $True
                        KioskModeManagedSettingsEntryDisabled = $True
                        KioskModeMediaVolumeConfigurationEnabled = $True
                        KioskModeScreenOrientation = "notConfigured"
                        KioskModeScreenSaverConfigurationEnabled = $True
                        KioskModeScreenSaverDetectMediaDisabled = $True
                        KioskModeScreenSaverDisplayTimeInSeconds = 25
                        KioskModeScreenSaverImageUrl = "FakeStringValue"
                        KioskModeScreenSaverStartDelayInSeconds = 25
                        KioskModeShowAppNotificationBadge = $True
                        KioskModeShowDeviceInfo = $True
                        KioskModeUseManagedHomeScreenApp = "notConfigured"
                        KioskModeVirtualHomeButtonEnabled = $True
                        KioskModeVirtualHomeButtonType = "notConfigured"
                        KioskModeWallpaperUrl = "FakeStringValue"
                        KioskModeWiFiConfigurationEnabled = $True
                        MicrophoneForceMute = $True
                        MicrosoftLauncherConfigurationEnabled = $True
                        MicrosoftLauncherCustomWallpaperAllowUserModification = $True
                        MicrosoftLauncherCustomWallpaperEnabled = $True
                        MicrosoftLauncherCustomWallpaperImageUrl = "FakeStringValue"
                        MicrosoftLauncherDockPresenceAllowUserModification = $True
                        MicrosoftLauncherDockPresenceConfiguration = "notConfigured"
                        MicrosoftLauncherFeedAllowUserModification = $True
                        MicrosoftLauncherFeedEnabled = $True
                        MicrosoftLauncherSearchBarPlacementConfiguration = "notConfigured"
                        NetworkEscapeHatchAllowed = $True
                        NfcBlockOutgoingBeam = $True
                        PasswordBlockKeyguard = $True
                        PasswordExpirationDays = 25
                        PasswordMinimumLength = 25
                        PasswordMinimumLetterCharacters = 25
                        PasswordMinimumLowerCaseCharacters = 25
                        PasswordMinimumNonLetterCharacters = 25
                        PasswordMinimumNumericCharacters = 25
                        PasswordMinimumSymbolCharacters = 25
                        PasswordMinimumUpperCaseCharacters = 25
                        PasswordMinutesOfInactivityBeforeScreenTimeout = 25
                        PasswordPreviousPasswordCountToBlock = 25
                        PasswordRequiredType = "deviceDefault"
                        PasswordRequireUnlock = "deviceDefault"
                        PasswordSignInFailureCountBeforeFactoryReset = 25
                        PersonalProfileAppsAllowInstallFromUnknownSources = $True
                        PersonalProfileCameraBlocked = $True
                        PersonalProfilePersonalApplications =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                                appId = "FakeStringValue"
                                publisher = "FakeStringValue"
                                appStoreUrl = "FakeStringValue"
                                name = "FakeStringValue"
                                odataType = "#microsoft.graph.appleAppListItem"
                            } -ClientOnly)
                        )
                        PersonalProfilePlayStoreMode = "notConfigured"
                        PersonalProfileScreenCaptureBlocked = $True
                        PlayStoreMode = "notConfigured"
                        ScreenCaptureBlocked = $True
                        SecurityCommonCriteriaModeEnabled = $True
                        SecurityDeveloperSettingsEnabled = $True
                        SecurityRequireVerifyApps = $True
                        ShortHelpText =(New-CimInstance -ClassName MSFT_MicrosoftGraphandroiddeviceowneruserfacingmessage -Property @{
                            defaultMessage = "FakeStringValue"
                            localizedMessages = [CimInstance[]]@()
                        } -ClientOnly)
                        StatusBarBlocked = $True
                        StorageAllowUsb = $True
                        StorageBlockExternalMedia = $True
                        StorageBlockUsbFileTransfer = $True
                        SystemUpdateFreezePeriods =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphandroiddeviceownersystemupdatefreezeperiod -Property @{
                                endMonth = 25
                                startMonth = 25
                                startDay = 25
                                endDay = 25
                            } -ClientOnly)
                        )
                        SystemUpdateInstallType = "deviceDefault"
                        SystemUpdateWindowEndMinutesAfterMidnight = 25
                        SystemUpdateWindowStartMinutesAfterMidnight = 25
                        SystemWindowsBlocked = $True
                        UsersBlockAdd = $True
                        UsersBlockRemove = $True
                        VolumeBlockAdjustment = $True
                        VpnAlwaysOnLockdownMode = $True
                        VpnAlwaysOnPackageIdentifier = "FakeStringValue"
                        WifiBlockEditConfigurations = $True
                        WifiBlockEditPolicyDefinedConfigurations = $True
                        WorkProfilePasswordExpirationDays = 25
                        WorkProfilePasswordMinimumLength = 25
                        WorkProfilePasswordMinimumLetterCharacters = 25
                        WorkProfilePasswordMinimumLowerCaseCharacters = 25
                        WorkProfilePasswordMinimumNonLetterCharacters = 25
                        WorkProfilePasswordMinimumNumericCharacters = 25
                        WorkProfilePasswordMinimumSymbolCharacters = 25
                        WorkProfilePasswordMinimumUpperCaseCharacters = 25
                        WorkProfilePasswordPreviousPasswordCountToBlock = 25
                        WorkProfilePasswordRequiredType = "deviceDefault"
                        WorkProfilePasswordRequireUnlock = "deviceDefault"
                        WorkProfilePasswordSignInFailureCountBeforeFactoryReset = 25

                    Ensure                        = "Present"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties =@{
                            VolumeBlockAdjustment = $True
                            ScreenCaptureBlocked = $True
                            KioskModeMediaVolumeConfigurationEnabled = $True
                            KioskModeManagedHomeScreenPinRequired = $True
                            KioskModeBluetoothConfigurationEnabled = $True
                            StorageBlockExternalMedia = $True
                            WorkProfilePasswordMinimumLowerCaseCharacters = 25
                            WorkProfilePasswordRequireUnlock = "deviceDefault"
                            SystemUpdateFreezePeriods =@(
                                @{
                                    endMonth = 25
                                    startMonth = 25
                                    startDay = 25
                                    endDay = 25
                                }
                            )
                            BluetoothBlockConfiguration = $True
                            DeviceOwnerLockScreenMessage =@{
                                defaultMessage = "FakeStringValue"
                                localizedMessages = [CimInstance[]]@()
                            }
                            MicrosoftLauncherDockPresenceAllowUserModification = $True
                            GlobalProxy =@{
                                '@odata.type' = "#microsoft.graph.androidDeviceOwnerGlobalProxyAutoConfig"
                                proxyAutoConfigURL = "FakeStringValue"
                            }
                            KioskModeExitCode = "FakeStringValue"
                            CrossProfilePoliciesShowWorkContactsInPersonalProfile = $True
                            StorageAllowUsb = $True
                            AppsDefaultPermissionPolicy = "deviceDefault"
                            AccountsBlockModification = $True
                            KioskModeShowDeviceInfo = $True
                            KioskModeScreenSaverDetectMediaDisabled = $True
                            PersonalProfileCameraBlocked = $True
                            WifiBlockEditConfigurations = $True
                            KioskModeScreenSaverImageUrl = "FakeStringValue"
                            GoogleAccountsBlocked = $True
                            KioskModeScreenSaverDisplayTimeInSeconds = 25
                            MicrophoneForceMute = $True
                            PasswordMinimumNumericCharacters = 25
                            CrossProfilePoliciesAllowDataSharing = "notConfigured"
                            DetailedHelpText =@{
                                defaultMessage = "FakeStringValue"
                                localizedMessages = [CimInstance[]]@()
                            }
                            WorkProfilePasswordMinimumLength = 25
                            KioskModeManagedHomeScreenPinComplexity = "notConfigured"
                            PasswordMinimumUpperCaseCharacters = 25
                            KioskModeFolderIcon = "notConfigured"
                            KioskModeScreenSaverStartDelayInSeconds = 25
                            MicrosoftLauncherCustomWallpaperAllowUserModification = $True
                            KioskModeAppOrderEnabled = $True
                            KioskModeVirtualHomeButtonEnabled = $True
                            MicrosoftLauncherFeedEnabled = $True
                            BluetoothBlockContactSharing = $True
                            SecurityCommonCriteriaModeEnabled = $True
                            KioskModeGridWidth = 25
                            PersonalProfilePlayStoreMode = "notConfigured"
                            KioskCustomizationStatusBar = "notConfigured"
                            KioskModeWallpaperUrl = "FakeStringValue"
                            NetworkEscapeHatchAllowed = $True
                            KioskModeFlashlightConfigurationEnabled = $True
                            VpnAlwaysOnLockdownMode = $True
                            StatusBarBlocked = $True
                            SystemUpdateWindowStartMinutesAfterMidnight = 25
                            SecurityRequireVerifyApps = $True
                            KioskModeManagedHomeScreenSignInBrandingLogo = "FakeStringValue"
                            KioskModeDebugMenuEasyAccessEnabled = $True
                            WifiBlockEditPolicyDefinedConfigurations = $True
                            PasswordMinimumSymbolCharacters = 25
                            KioskModeScreenOrientation = "notConfigured"
                            PersonalProfileAppsAllowInstallFromUnknownSources = $True
                            CameraBlocked = $True
                            WorkProfilePasswordMinimumSymbolCharacters = 25
                            KioskModeManagedHomeScreenInactiveSignOutDelayInSeconds = 25
                            WorkProfilePasswordRequiredType = "deviceDefault"
                            CertificateCredentialConfigurationDisabled = $True
                            KioskCustomizationSystemNavigation = "notConfigured"
                            WorkProfilePasswordExpirationDays = 25
                            WorkProfilePasswordMinimumLetterCharacters = 25
                            KioskCustomizationSystemErrorWarnings = $True
                            WorkProfilePasswordMinimumNumericCharacters = 25
                            PasswordMinimumLength = 25
                            KioskModeWiFiConfigurationEnabled = $True
                            PasswordMinimumLowerCaseCharacters = 25
                            StorageBlockUsbFileTransfer = $True
                            WorkProfilePasswordPreviousPasswordCountToBlock = 25
                            AppsAllowInstallFromUnknownSources = $True
                            PersonalProfileScreenCaptureBlocked = $True
                            KioskCustomizationPowerButtonActionsBlocked = $True
                            KioskModeManagedSettingsEntryDisabled = $True
                            MicrosoftLauncherCustomWallpaperImageUrl = "FakeStringValue"
                            KioskModeAppsInFolderOrderedByName = $True
                            DataRoamingBlocked = $True
                            MicrosoftLauncherCustomWallpaperEnabled = $True
                            KioskCustomizationDeviceSettingsBlocked = $True
                            UsersBlockAdd = $True
                            PasswordMinutesOfInactivityBeforeScreenTimeout = 25
                            AppsRecommendSkippingFirstUseHints = $True
                            PasswordRequiredType = "deviceDefault"
                            KioskModeManagedHomeScreenSignInEnabled = $True
                            DateTimeConfigurationBlocked = $True
                            KioskModeManagedHomeScreenSignInBackground = "FakeStringValue"
                            FactoryResetBlocked = $True
                            KioskModeLockHomeScreen = $True
                            KioskModeShowAppNotificationBadge = $True
                            SystemWindowsBlocked = $True
                            KioskModeAppPositions =@()
                            AzureAdSharedDeviceDataClearApps =@(
                                @{
                                    name = "FakeStringValue"
                                    appId = "FakeStringValue"
                                    appStoreUrl = "FakeStringValue"
                                    '@odata.type' = "#microsoft.graph.appleAppListItem"
                                    publisher = "FakeStringValue"
                                }
                            )
                            PlayStoreMode = "notConfigured"
                            WorkProfilePasswordMinimumUpperCaseCharacters = 25
                            PasswordPreviousPasswordCountToBlock = 25
                            SystemUpdateInstallType = "deviceDefault"
                            SecurityDeveloperSettingsEnabled = $True
                            MicrosoftLauncherConfigurationEnabled = $True
                            MicrosoftLauncherFeedAllowUserModification = $True
                            KioskModeGridHeight = 25
                            PasswordExpirationDays = 25
                            WorkProfilePasswordMinimumNonLetterCharacters = 25
                            WorkProfilePasswordSignInFailureCountBeforeFactoryReset = 25
                            KioskModeManagedFolders =@()
                            ShortHelpText =@{
                                defaultMessage = "FakeStringValue"
                                localizedMessages = [CimInstance[]]@()
                            }
                            KioskModeIconSize = "notConfigured"
                            AppsAutoUpdatePolicy = "notConfigured"
                            KioskModeScreenSaverConfigurationEnabled = $True
                            PasswordRequireUnlock = "deviceDefault"
                            MicrosoftLauncherDockPresenceConfiguration = "notConfigured"
                            KioskModeManagedHomeScreenInactiveSignOutNoticeInSeconds = 25
                            VpnAlwaysOnPackageIdentifier = "FakeStringValue"
                            CrossProfilePoliciesAllowCopyPaste = $True
                            KioskModeApps =@(
                                @{
                                    name = "FakeStringValue"
                                    appId = "FakeStringValue"
                                    appStoreUrl = "FakeStringValue"
                                    '@odata.type' = "#microsoft.graph.appleAppListItem"
                                    publisher = "FakeStringValue"
                                }
                            )
                            KioskModeManagedHomeScreenAutoSignout = $True
                            KioskModeUseManagedHomeScreenApp = "notConfigured"
                            KioskModeManagedHomeScreenPinRequiredToResume = $True
                            NfcBlockOutgoingBeam = $True
                            '@odata.type' = "#microsoft.graph.androidDeviceOwnerGeneralDeviceConfiguration"
                            PersonalProfilePersonalApplications =@(
                                @{
                                    name = "FakeStringValue"
                                    appId = "FakeStringValue"
                                    appStoreUrl = "FakeStringValue"
                                    '@odata.type' = "#microsoft.graph.appleAppListItem"
                                    publisher = "FakeStringValue"
                                }
                            )
                            PasswordBlockKeyguard = $True
                            MicrosoftLauncherSearchBarPlacementConfiguration = "notConfigured"
                            SystemUpdateWindowEndMinutesAfterMidnight = 25
                            PasswordMinimumLetterCharacters = 25
                            KioskModeVirtualHomeButtonType = "notConfigured"
                            CellularBlockWiFiTethering = $True
                            EnrollmentProfile = "notConfigured"
                            PasswordSignInFailureCountBeforeFactoryReset = 25
                            PasswordMinimumNonLetterCharacters = 25
                            UsersBlockRemove = $True
                        }
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"

                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }
        Context -Name "The IntuneDeviceConfigurationPolicyAndroidDeviceOwner exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                        AccountsBlockModification = $True
                        AppsAllowInstallFromUnknownSources = $True
                        AppsAutoUpdatePolicy = "notConfigured"
                        AppsDefaultPermissionPolicy = "deviceDefault"
                        AppsRecommendSkippingFirstUseHints = $True
                        AzureAdSharedDeviceDataClearApps =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                                appId = "FakeStringValue"
                                publisher = "FakeStringValue"
                                appStoreUrl = "FakeStringValue"
                                name = "FakeStringValue"
                                odataType = "#microsoft.graph.appleAppListItem"
                            } -ClientOnly)
                        )
                        BluetoothBlockConfiguration = $True
                        BluetoothBlockContactSharing = $True
                        CameraBlocked = $True
                        CellularBlockWiFiTethering = $True
                        CertificateCredentialConfigurationDisabled = $True
                        CrossProfilePoliciesAllowCopyPaste = $True
                        CrossProfilePoliciesAllowDataSharing = "notConfigured"
                        CrossProfilePoliciesShowWorkContactsInPersonalProfile = $True
                        DataRoamingBlocked = $True
                        DateTimeConfigurationBlocked = $True
                        Description = "FakeStringValue"
                        DetailedHelpText =(New-CimInstance -ClassName MSFT_MicrosoftGraphandroiddeviceowneruserfacingmessage -Property @{
                            defaultMessage = "FakeStringValue"
                            localizedMessages = [CimInstance[]]@()
                        } -ClientOnly)
                        DeviceOwnerLockScreenMessage =(New-CimInstance -ClassName MSFT_MicrosoftGraphandroiddeviceowneruserfacingmessage -Property @{
                            defaultMessage = "FakeStringValue"
                            localizedMessages = [CimInstance[]]@()
                        } -ClientOnly)
                        DisplayName = "FakeStringValue"
                        EnrollmentProfile = "notConfigured"
                        FactoryResetBlocked = $True
                        GlobalProxy =(New-CimInstance -ClassName MSFT_MicrosoftGraphandroiddeviceownerglobalproxy -Property @{
                            proxyAutoConfigURL = "FakeStringValue"
                            odataType = "#microsoft.graph.androidDeviceOwnerGlobalProxyAutoConfig"
                        } -ClientOnly)
                        GoogleAccountsBlocked = $True
                        Id = "FakeStringValue"
                        KioskCustomizationDeviceSettingsBlocked = $True
                        KioskCustomizationPowerButtonActionsBlocked = $True
                        KioskCustomizationStatusBar = "notConfigured"
                        KioskCustomizationSystemErrorWarnings = $True
                        KioskCustomizationSystemNavigation = "notConfigured"
                        KioskModeAppOrderEnabled = $True
                        KioskModeAppPositions =@()
                        KioskModeApps =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                                appId = "FakeStringValue"
                                publisher = "FakeStringValue"
                                appStoreUrl = "FakeStringValue"
                                name = "FakeStringValue"
                                odataType = "#microsoft.graph.appleAppListItem"
                            } -ClientOnly)
                        )
                        KioskModeAppsInFolderOrderedByName = $True
                        KioskModeBluetoothConfigurationEnabled = $True
                        KioskModeDebugMenuEasyAccessEnabled = $True
                        KioskModeExitCode = "FakeStringValue"
                        KioskModeFlashlightConfigurationEnabled = $True
                        KioskModeFolderIcon = "notConfigured"
                        KioskModeGridHeight = 25
                        KioskModeGridWidth = 25
                        KioskModeIconSize = "notConfigured"
                        KioskModeLockHomeScreen = $True
                        KioskModeManagedFolders =@()
                        KioskModeManagedHomeScreenAutoSignout = $True
                        KioskModeManagedHomeScreenInactiveSignOutDelayInSeconds = 25
                        KioskModeManagedHomeScreenInactiveSignOutNoticeInSeconds = 25
                        KioskModeManagedHomeScreenPinComplexity = "notConfigured"
                        KioskModeManagedHomeScreenPinRequired = $True
                        KioskModeManagedHomeScreenPinRequiredToResume = $True
                        KioskModeManagedHomeScreenSignInBackground = "FakeStringValue"
                        KioskModeManagedHomeScreenSignInBrandingLogo = "FakeStringValue"
                        KioskModeManagedHomeScreenSignInEnabled = $True
                        KioskModeManagedSettingsEntryDisabled = $True
                        KioskModeMediaVolumeConfigurationEnabled = $True
                        KioskModeScreenOrientation = "notConfigured"
                        KioskModeScreenSaverConfigurationEnabled = $True
                        KioskModeScreenSaverDetectMediaDisabled = $True
                        KioskModeScreenSaverDisplayTimeInSeconds = 25
                        KioskModeScreenSaverImageUrl = "FakeStringValue"
                        KioskModeScreenSaverStartDelayInSeconds = 25
                        KioskModeShowAppNotificationBadge = $True
                        KioskModeShowDeviceInfo = $True
                        KioskModeUseManagedHomeScreenApp = "notConfigured"
                        KioskModeVirtualHomeButtonEnabled = $True
                        KioskModeVirtualHomeButtonType = "notConfigured"
                        KioskModeWallpaperUrl = "FakeStringValue"
                        KioskModeWiFiConfigurationEnabled = $True
                        MicrophoneForceMute = $True
                        MicrosoftLauncherConfigurationEnabled = $True
                        MicrosoftLauncherCustomWallpaperAllowUserModification = $True
                        MicrosoftLauncherCustomWallpaperEnabled = $True
                        MicrosoftLauncherCustomWallpaperImageUrl = "FakeStringValue"
                        MicrosoftLauncherDockPresenceAllowUserModification = $True
                        MicrosoftLauncherDockPresenceConfiguration = "notConfigured"
                        MicrosoftLauncherFeedAllowUserModification = $True
                        MicrosoftLauncherFeedEnabled = $True
                        MicrosoftLauncherSearchBarPlacementConfiguration = "notConfigured"
                        NetworkEscapeHatchAllowed = $True
                        NfcBlockOutgoingBeam = $True
                        PasswordBlockKeyguard = $True
                        PasswordExpirationDays = 25
                        PasswordMinimumLength = 25
                        PasswordMinimumLetterCharacters = 25
                        PasswordMinimumLowerCaseCharacters = 25
                        PasswordMinimumNonLetterCharacters = 25
                        PasswordMinimumNumericCharacters = 25
                        PasswordMinimumSymbolCharacters = 25
                        PasswordMinimumUpperCaseCharacters = 25
                        PasswordMinutesOfInactivityBeforeScreenTimeout = 25
                        PasswordPreviousPasswordCountToBlock = 25
                        PasswordRequiredType = "deviceDefault"
                        PasswordRequireUnlock = "deviceDefault"
                        PasswordSignInFailureCountBeforeFactoryReset = 25
                        PersonalProfileAppsAllowInstallFromUnknownSources = $True
                        PersonalProfileCameraBlocked = $True
                        PersonalProfilePersonalApplications =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphapplistitem -Property @{
                                appId = "FakeStringValue"
                                publisher = "FakeStringValue"
                                appStoreUrl = "FakeStringValue"
                                name = "FakeStringValue"
                                odataType = "#microsoft.graph.appleAppListItem"
                            } -ClientOnly)
                        )
                        PersonalProfilePlayStoreMode = "notConfigured"
                        PersonalProfileScreenCaptureBlocked = $True
                        PlayStoreMode = "notConfigured"
                        ScreenCaptureBlocked = $True
                        SecurityCommonCriteriaModeEnabled = $True
                        SecurityDeveloperSettingsEnabled = $True
                        SecurityRequireVerifyApps = $True
                        ShortHelpText =(New-CimInstance -ClassName MSFT_MicrosoftGraphandroiddeviceowneruserfacingmessage -Property @{
                            defaultMessage = "FakeStringValue"
                            localizedMessages = [CimInstance[]]@()
                        } -ClientOnly)
                        StatusBarBlocked = $True
                        StorageAllowUsb = $True
                        StorageBlockExternalMedia = $True
                        StorageBlockUsbFileTransfer = $True
                        SystemUpdateFreezePeriods =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphandroiddeviceownersystemupdatefreezeperiod -Property @{
                                endMonth = 25
                                startMonth = 25
                                startDay = 25
                                endDay = 25
                            } -ClientOnly)
                        )
                        SystemUpdateInstallType = "deviceDefault"
                        SystemUpdateWindowEndMinutesAfterMidnight = 25
                        SystemUpdateWindowStartMinutesAfterMidnight = 25
                        SystemWindowsBlocked = $True
                        UsersBlockAdd = $True
                        UsersBlockRemove = $True
                        VolumeBlockAdjustment = $True
                        VpnAlwaysOnLockdownMode = $True
                        VpnAlwaysOnPackageIdentifier = "FakeStringValue"
                        WifiBlockEditConfigurations = $True
                        WifiBlockEditPolicyDefinedConfigurations = $True
                        WorkProfilePasswordExpirationDays = 25
                        WorkProfilePasswordMinimumLength = 25
                        WorkProfilePasswordMinimumLetterCharacters = 25
                        WorkProfilePasswordMinimumLowerCaseCharacters = 25
                        WorkProfilePasswordMinimumNonLetterCharacters = 25
                        WorkProfilePasswordMinimumNumericCharacters = 25
                        WorkProfilePasswordMinimumSymbolCharacters = 25
                        WorkProfilePasswordMinimumUpperCaseCharacters = 25
                        WorkProfilePasswordPreviousPasswordCountToBlock = 25
                        WorkProfilePasswordRequiredType = "deviceDefault"
                        WorkProfilePasswordRequireUnlock = "deviceDefault"
                        WorkProfilePasswordSignInFailureCountBeforeFactoryReset = 25

                    Ensure                = "Present"
                    Credential            = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties =@{
                            WorkProfilePasswordMinimumUpperCaseCharacters = 7
                            WorkProfilePasswordRequireUnlock = "deviceDefault"
                            SystemUpdateFreezePeriods =@(
                                @{
                                    endMonth = 25
                                    startMonth = 25
                                    startDay = 25
                                    endDay = 25
                                }
                            )
                            VpnAlwaysOnPackageIdentifier = "FakeStringValue"
                            DeviceOwnerLockScreenMessage =@{
                                defaultMessage = "FakeStringValue"
                                localizedMessages = [CimInstance[]]@()
                            }
                            WorkProfilePasswordMinimumLowerCaseCharacters = 7
                            GlobalProxy =@{
                                '@odata.type' = "#microsoft.graph.androidDeviceOwnerGlobalProxyAutoConfig"
                                proxyAutoConfigURL = "FakeStringValue"
                            }
                            WorkProfilePasswordRequiredType = "deviceDefault"
                            KioskModeVirtualHomeButtonType = "notConfigured"
                            AppsDefaultPermissionPolicy = "deviceDefault"
                            WorkProfilePasswordMinimumSymbolCharacters = 7
                            '@odata.type' = "#microsoft.graph.androidDeviceOwnerGeneralDeviceConfiguration"
                            KioskModeScreenSaverImageUrl = "FakeStringValue"
                            KioskModeScreenSaverDisplayTimeInSeconds = 7
                            KioskModeGridWidth = 7
                            KioskModeFolderIcon = "notConfigured"
                            PasswordMinimumUpperCaseCharacters = 7
                            ShortHelpText =@{
                                defaultMessage = "FakeStringValue"
                                localizedMessages = [CimInstance[]]@()
                            }
                            PersonalProfilePlayStoreMode = "notConfigured"
                            KioskCustomizationStatusBar = "notConfigured"
                            PasswordPreviousPasswordCountToBlock = 7
                            PasswordMinutesOfInactivityBeforeScreenTimeout = 7
                            KioskModeExitCode = "FakeStringValue"
                            WorkProfilePasswordExpirationDays = 7
                            KioskModeManagedHomeScreenSignInBrandingLogo = "FakeStringValue"
                            PasswordMinimumSymbolCharacters = 7
                            KioskModeScreenOrientation = "notConfigured"
                            KioskModeManagedHomeScreenInactiveSignOutDelayInSeconds = 7
                            KioskCustomizationSystemNavigation = "notConfigured"
                            WorkProfilePasswordPreviousPasswordCountToBlock = 7
                            PasswordMinimumLength = 7
                            PasswordMinimumNumericCharacters = 7
                            CrossProfilePoliciesAllowDataSharing = "notConfigured"
                            EnrollmentProfile = "notConfigured"
                            PasswordSignInFailureCountBeforeFactoryReset = 7
                            PasswordMinimumNonLetterCharacters = 7
                            WorkProfilePasswordMinimumNumericCharacters = 7
                            PasswordMinimumLowerCaseCharacters = 7
                            KioskModeWallpaperUrl = "FakeStringValue"
                            PasswordMinimumLetterCharacters = 7
                            WorkProfilePasswordSignInFailureCountBeforeFactoryReset = 7
                            KioskModeManagedHomeScreenSignInBackground = "FakeStringValue"
                            MicrosoftLauncherCustomWallpaperImageUrl = "FakeStringValue"
                            SystemUpdateWindowStartMinutesAfterMidnight = 7
                            KioskModeAppPositions =@()
                            AzureAdSharedDeviceDataClearApps =@(
                                @{
                                    name = "FakeStringValue"
                                    appId = "FakeStringValue"
                                    appStoreUrl = "FakeStringValue"
                                    '@odata.type' = "#microsoft.graph.appleAppListItem"
                                    publisher = "FakeStringValue"
                                }
                            )
                            PlayStoreMode = "notConfigured"
                            PasswordRequiredType = "deviceDefault"
                            SystemUpdateWindowEndMinutesAfterMidnight = 7
                            WorkProfilePasswordMinimumLength = 7
                            PersonalProfilePersonalApplications =@(
                                @{
                                    name = "FakeStringValue"
                                    appId = "FakeStringValue"
                                    appStoreUrl = "FakeStringValue"
                                    '@odata.type' = "#microsoft.graph.appleAppListItem"
                                    publisher = "FakeStringValue"
                                }
                            )
                            DetailedHelpText =@{
                                defaultMessage = "FakeStringValue"
                                localizedMessages = [CimInstance[]]@()
                            }
                            KioskModeManagedHomeScreenPinComplexity = "notConfigured"
                            KioskModeScreenSaverStartDelayInSeconds = 7
                            SystemUpdateInstallType = "deviceDefault"
                            KioskModeGridHeight = 7
                            PasswordExpirationDays = 7
                            WorkProfilePasswordMinimumNonLetterCharacters = 7
                            KioskModeManagedFolders =@()
                            KioskModeIconSize = "notConfigured"
                            AppsAutoUpdatePolicy = "notConfigured"
                            MicrosoftLauncherDockPresenceConfiguration = "notConfigured"
                            KioskModeManagedHomeScreenInactiveSignOutNoticeInSeconds = 7
                            KioskModeApps =@(
                                @{
                                    name = "FakeStringValue"
                                    appId = "FakeStringValue"
                                    appStoreUrl = "FakeStringValue"
                                    '@odata.type' = "#microsoft.graph.appleAppListItem"
                                    publisher = "FakeStringValue"
                                }
                            )
                            MicrosoftLauncherSearchBarPlacementConfiguration = "notConfigured"
                            KioskModeUseManagedHomeScreenApp = "notConfigured"
                            PasswordRequireUnlock = "deviceDefault"
                            WorkProfilePasswordMinimumLetterCharacters = 7
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
                Should -Invoke -CommandName Update-MgDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties =@{
                            VolumeBlockAdjustment = $True
                            ScreenCaptureBlocked = $True
                            KioskModeMediaVolumeConfigurationEnabled = $True
                            KioskModeManagedHomeScreenPinRequired = $True
                            KioskModeBluetoothConfigurationEnabled = $True
                            StorageBlockExternalMedia = $True
                            WorkProfilePasswordMinimumLowerCaseCharacters = 25
                            WorkProfilePasswordRequireUnlock = "deviceDefault"
                            SystemUpdateFreezePeriods =@(
                                @{
                                    endMonth = 25
                                    startMonth = 25
                                    startDay = 25
                                    endDay = 25
                                }
                            )
                            BluetoothBlockConfiguration = $True
                            DeviceOwnerLockScreenMessage =@{
                                defaultMessage = "FakeStringValue"
                                localizedMessages = [CimInstance[]]@()
                            }
                            MicrosoftLauncherDockPresenceAllowUserModification = $True
                            GlobalProxy =@{
                                '@odata.type' = "#microsoft.graph.androidDeviceOwnerGlobalProxyAutoConfig"
                                proxyAutoConfigURL = "FakeStringValue"
                            }
                            KioskModeExitCode = "FakeStringValue"
                            CrossProfilePoliciesShowWorkContactsInPersonalProfile = $True
                            StorageAllowUsb = $True
                            AppsDefaultPermissionPolicy = "deviceDefault"
                            AccountsBlockModification = $True
                            KioskModeShowDeviceInfo = $True
                            KioskModeScreenSaverDetectMediaDisabled = $True
                            PersonalProfileCameraBlocked = $True
                            WifiBlockEditConfigurations = $True
                            KioskModeScreenSaverImageUrl = "FakeStringValue"
                            GoogleAccountsBlocked = $True
                            KioskModeScreenSaverDisplayTimeInSeconds = 25
                            MicrophoneForceMute = $True
                            PasswordMinimumNumericCharacters = 25
                            CrossProfilePoliciesAllowDataSharing = "notConfigured"
                            DetailedHelpText =@{
                                defaultMessage = "FakeStringValue"
                                localizedMessages = [CimInstance[]]@()
                            }
                            WorkProfilePasswordMinimumLength = 25
                            KioskModeManagedHomeScreenPinComplexity = "notConfigured"
                            PasswordMinimumUpperCaseCharacters = 25
                            KioskModeFolderIcon = "notConfigured"
                            KioskModeScreenSaverStartDelayInSeconds = 25
                            MicrosoftLauncherCustomWallpaperAllowUserModification = $True
                            KioskModeAppOrderEnabled = $True
                            KioskModeVirtualHomeButtonEnabled = $True
                            MicrosoftLauncherFeedEnabled = $True
                            BluetoothBlockContactSharing = $True
                            SecurityCommonCriteriaModeEnabled = $True
                            KioskModeGridWidth = 25
                            PersonalProfilePlayStoreMode = "notConfigured"
                            KioskCustomizationStatusBar = "notConfigured"
                            KioskModeWallpaperUrl = "FakeStringValue"
                            NetworkEscapeHatchAllowed = $True
                            KioskModeFlashlightConfigurationEnabled = $True
                            VpnAlwaysOnLockdownMode = $True
                            StatusBarBlocked = $True
                            SystemUpdateWindowStartMinutesAfterMidnight = 25
                            SecurityRequireVerifyApps = $True
                            KioskModeManagedHomeScreenSignInBrandingLogo = "FakeStringValue"
                            KioskModeDebugMenuEasyAccessEnabled = $True
                            WifiBlockEditPolicyDefinedConfigurations = $True
                            PasswordMinimumSymbolCharacters = 25
                            KioskModeScreenOrientation = "notConfigured"
                            PersonalProfileAppsAllowInstallFromUnknownSources = $True
                            CameraBlocked = $True
                            WorkProfilePasswordMinimumSymbolCharacters = 25
                            KioskModeManagedHomeScreenInactiveSignOutDelayInSeconds = 25
                            WorkProfilePasswordRequiredType = "deviceDefault"
                            CertificateCredentialConfigurationDisabled = $True
                            KioskCustomizationSystemNavigation = "notConfigured"
                            WorkProfilePasswordExpirationDays = 25
                            WorkProfilePasswordMinimumLetterCharacters = 25
                            KioskCustomizationSystemErrorWarnings = $True
                            WorkProfilePasswordMinimumNumericCharacters = 25
                            PasswordMinimumLength = 25
                            KioskModeWiFiConfigurationEnabled = $True
                            PasswordMinimumLowerCaseCharacters = 25
                            StorageBlockUsbFileTransfer = $True
                            WorkProfilePasswordPreviousPasswordCountToBlock = 25
                            AppsAllowInstallFromUnknownSources = $True
                            PersonalProfileScreenCaptureBlocked = $True
                            KioskCustomizationPowerButtonActionsBlocked = $True
                            KioskModeManagedSettingsEntryDisabled = $True
                            MicrosoftLauncherCustomWallpaperImageUrl = "FakeStringValue"
                            KioskModeAppsInFolderOrderedByName = $True
                            DataRoamingBlocked = $True
                            MicrosoftLauncherCustomWallpaperEnabled = $True
                            KioskCustomizationDeviceSettingsBlocked = $True
                            UsersBlockAdd = $True
                            PasswordMinutesOfInactivityBeforeScreenTimeout = 25
                            AppsRecommendSkippingFirstUseHints = $True
                            PasswordRequiredType = "deviceDefault"
                            KioskModeManagedHomeScreenSignInEnabled = $True
                            DateTimeConfigurationBlocked = $True
                            KioskModeManagedHomeScreenSignInBackground = "FakeStringValue"
                            FactoryResetBlocked = $True
                            KioskModeLockHomeScreen = $True
                            KioskModeShowAppNotificationBadge = $True
                            SystemWindowsBlocked = $True
                            KioskModeAppPositions =@()
                            AzureAdSharedDeviceDataClearApps =@(
                                @{
                                    name = "FakeStringValue"
                                    appId = "FakeStringValue"
                                    appStoreUrl = "FakeStringValue"
                                    '@odata.type' = "#microsoft.graph.appleAppListItem"
                                    publisher = "FakeStringValue"
                                }
                            )
                            PlayStoreMode = "notConfigured"
                            WorkProfilePasswordMinimumUpperCaseCharacters = 25
                            PasswordPreviousPasswordCountToBlock = 25
                            SystemUpdateInstallType = "deviceDefault"
                            SecurityDeveloperSettingsEnabled = $True
                            MicrosoftLauncherConfigurationEnabled = $True
                            MicrosoftLauncherFeedAllowUserModification = $True
                            KioskModeGridHeight = 25
                            PasswordExpirationDays = 25
                            WorkProfilePasswordMinimumNonLetterCharacters = 25
                            WorkProfilePasswordSignInFailureCountBeforeFactoryReset = 25
                            KioskModeManagedFolders =@()
                            ShortHelpText =@{
                                defaultMessage = "FakeStringValue"
                                localizedMessages = [CimInstance[]]@()
                            }
                            KioskModeIconSize = "notConfigured"
                            AppsAutoUpdatePolicy = "notConfigured"
                            KioskModeScreenSaverConfigurationEnabled = $True
                            PasswordRequireUnlock = "deviceDefault"
                            MicrosoftLauncherDockPresenceConfiguration = "notConfigured"
                            KioskModeManagedHomeScreenInactiveSignOutNoticeInSeconds = 25
                            VpnAlwaysOnPackageIdentifier = "FakeStringValue"
                            CrossProfilePoliciesAllowCopyPaste = $True
                            KioskModeApps =@(
                                @{
                                    name = "FakeStringValue"
                                    appId = "FakeStringValue"
                                    appStoreUrl = "FakeStringValue"
                                    '@odata.type' = "#microsoft.graph.appleAppListItem"
                                    publisher = "FakeStringValue"
                                }
                            )
                            KioskModeManagedHomeScreenAutoSignout = $True
                            KioskModeUseManagedHomeScreenApp = "notConfigured"
                            KioskModeManagedHomeScreenPinRequiredToResume = $True
                            NfcBlockOutgoingBeam = $True
                            '@odata.type' = "#microsoft.graph.androidDeviceOwnerGeneralDeviceConfiguration"
                            PersonalProfilePersonalApplications =@(
                                @{
                                    name = "FakeStringValue"
                                    appId = "FakeStringValue"
                                    appStoreUrl = "FakeStringValue"
                                    '@odata.type' = "#microsoft.graph.appleAppListItem"
                                    publisher = "FakeStringValue"
                                }
                            )
                            PasswordBlockKeyguard = $True
                            MicrosoftLauncherSearchBarPlacementConfiguration = "notConfigured"
                            SystemUpdateWindowEndMinutesAfterMidnight = 25
                            PasswordMinimumLetterCharacters = 25
                            KioskModeVirtualHomeButtonType = "notConfigured"
                            CellularBlockWiFiTethering = $True
                            EnrollmentProfile = "notConfigured"
                            PasswordSignInFailureCountBeforeFactoryReset = 25
                            PasswordMinimumNonLetterCharacters = 25
                            UsersBlockRemove = $True
                        }
                        Description          = 'FakeStringValue'
                        DisplayName          = 'FakeStringValue'
                        Id                   = 'FakeStringValue'

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
