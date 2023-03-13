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
    -DscResource 'IntuneDeviceConfigurationPolicyWindows10' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'Pass@word1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName New-MgDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName Update-MgDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName Remove-MgDeviceManagementDeviceConfiguration -MockWith {
            }

            Mock -CommandName Get-MGDeviceManagementDeviceConfigurationAssignment -MockWith {

                return @()
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }

        # Test contexts
        Context -Name "When the policy doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    displayName                                           = 'CONTOSO | W10 | Device Restriction'
                    description                                           = 'Default device restriction settings'
                    defenderBlockEndUserAccess                            = $true
                    defenderRequireRealTimeMonitoring                     = $true
                    defenderRequireBehaviorMonitoring                     = $true
                    defenderRequireNetworkInspectionSystem                = $true
                    defenderScanDownloads                                 = $true
                    defenderScanScriptsLoadedInInternetExplorer           = $true
                    defenderSignatureUpdateIntervalInHours                = 8
                    defenderMonitorFileActivity                           = 'monitorIncomingFilesOnly'  # userDefined,monitorAllFiles,monitorIncomingFilesOnly,monitorOutgoingFilesOnly
                    defenderDaysBeforeDeletingQuarantinedMalware          = 3
                    defenderScanMaxCpu                                    = 2
                    defenderScanArchiveFiles                              = $true
                    defenderScanIncomingMail                              = $true
                    defenderScanRemovableDrivesDuringFullScan             = $true
                    defenderScanMappedNetworkDrivesDuringFullScan         = $false
                    defenderScanNetworkFiles                              = $false
                    defenderRequireCloudProtection                        = $true
                    defenderCloudBlockLevel                               = 'high'
                    defenderPromptForSampleSubmission                     = 'alwaysPrompt'
                    defenderScheduledQuickScanTime                        = '13:00:00.0000000'
                    defenderScanType                                      = 'quick'   #quick,full,userDefined
                    defenderSystemScanSchedule                            = 'monday'  #days of week
                    defenderScheduledScanTime                             = '11:00:00.0000000'
                    defenderDetectedMalwareActions                        = (New-CimInstance -ClassName MSFT_IntuneDefenderDetectedMalwareActions -Property @{
                            lowSeverity      = 'clean'
                            moderateSeverity = 'quarantine'
                            highSeverity     = 'remove'
                            severeSeverity   = 'block'
                        } -ClientOnly)
                    defenderFileExtensionsToExclude                       = "[`"csv,jpg,docx`"]"
                    defenderFilesAndFoldersToExclude                      = "[`"c:\\2,C:\\1`"]"
                    defenderProcessesToExclude                            = "[`"notepad.exe,c:\\Windows\\myprocess.exe`"]"
                    lockScreenAllowTimeoutConfiguration                   = $true
                    lockScreenBlockActionCenterNotifications              = $true
                    lockScreenBlockCortana                                = $true
                    lockScreenBlockToastNotifications                     = $false
                    lockScreenTimeoutInSeconds                            = 90
                    passwordBlockSimple                                   = $true
                    passwordExpirationDays                                = 6
                    passwordMinimumLength                                 = 5
                    passwordMinutesOfInactivityBeforeScreenTimeout        = 15
                    passwordMinimumCharacterSetCount                      = 1
                    passwordPreviousPasswordBlockCount                    = 2
                    passwordRequired                                      = $true
                    passwordRequireWhenResumeFromIdleState                = $true
                    passwordRequiredType                                  = 'alphanumeric'
                    passwordSignInFailureCountBeforeFactoryReset          = 12
                    privacyAdvertisingId                                  = 'blocked'
                    privacyAutoAcceptPairingAndConsentPrompts             = $true
                    privacyBlockInputPersonalization                      = $true
                    startBlockUnpinningAppsFromTaskbar                    = $true
                    startMenuAppListVisibility                            = 'collapse'
                    startMenuHideChangeAccountSettings                    = $true
                    startMenuHideFrequentlyUsedApps                       = $true
                    startMenuHideHibernate                                = $true
                    startMenuHideLock                                     = $true
                    startMenuHidePowerButton                              = $true
                    startMenuHideRecentJumpLists                          = $true
                    startMenuHideRecentlyAddedApps                        = $true
                    startMenuHideRestartOptions                           = $true
                    startMenuHideShutDown                                 = $true
                    startMenuHideSignOut                                  = $true
                    startMenuHideSleep                                    = $true
                    startMenuHideSwitchAccount                            = $true
                    startMenuHideUserTile                                 = $true
                    startMenuLayoutXml                                    = '+DQogICAGlmaWNhdGlvblRlbXBsYXRlPg=='
                    startMenuMode                                         = 'fullScreen'
                    startMenuPinnedFolderDocuments                        = 'hide'
                    startMenuPinnedFolderDownloads                        = 'hide'
                    startMenuPinnedFolderFileExplorer                     = 'hide'
                    startMenuPinnedFolderHomeGroup                        = 'hide'
                    startMenuPinnedFolderMusic                            = 'hide'
                    startMenuPinnedFolderNetwork                          = 'hide'
                    startMenuPinnedFolderPersonalFolder                   = 'hide'
                    startMenuPinnedFolderPictures                         = 'hide'
                    startMenuPinnedFolderSettings                         = 'hide'
                    startMenuPinnedFolderVideos                           = 'hide'
                    settingsBlockSettingsApp                              = $true
                    settingsBlockSystemPage                               = $true
                    settingsBlockDevicesPage                              = $true
                    settingsBlockNetworkInternetPage                      = $true
                    settingsBlockPersonalizationPage                      = $true
                    settingsBlockAccountsPage                             = $true
                    settingsBlockTimeLanguagePage                         = $true
                    settingsBlockEaseOfAccessPage                         = $true
                    settingsBlockPrivacyPage                              = $true
                    settingsBlockUpdateSecurityPage                       = $true
                    settingsBlockAppsPage                                 = $true
                    settingsBlockGamingPage                               = $true
                    windowsSpotlightBlockConsumerSpecificFeatures         = $true
                    windowsSpotlightBlocked                               = $true
                    windowsSpotlightBlockOnActionCenter                   = $true
                    windowsSpotlightBlockTailoredExperiences              = $true
                    windowsSpotlightBlockThirdPartyNotifications          = $true
                    windowsSpotlightBlockWelcomeExperience                = $true
                    windowsSpotlightBlockWindowsTips                      = $true
                    windowsSpotlightConfigureOnLockScreen                 = 'disabled'
                    networkProxyApplySettingsDeviceWide                   = $true
                    networkProxyDisableAutoDetect                         = $true
                    networkProxyAutomaticConfigurationUrl                 = 'https://example.com/networkProxyAutomaticConfigurationUrl/'
                    accountsBlockAddingNonMicrosoftAccountEmail           = $true
                    antiTheftModeBlocked                                  = $true
                    bluetoothBlocked                                      = $true
                    bluetoothAllowedServices                              = "[`"8e473eaa-ead4-4c60-ba9c-2c5696d71492`",`"21913f2d-a803-4f36-8039-669fd94ce5b3`"]"
                    bluetoothBlockAdvertising                             = $true
                    bluetoothBlockDiscoverableMode                        = $true
                    bluetoothBlockPrePairing                              = $true
                    cameraBlocked                                         = $true
                    connectedDevicesServiceBlocked                        = $true
                    certificatesBlockManualRootCertificateInstallation    = $true
                    copyPasteBlocked                                      = $true
                    cortanaBlocked                                        = $true
                    deviceManagementBlockFactoryResetOnMobile             = $true
                    deviceManagementBlockManualUnenroll                   = $true
                    safeSearchFilter                                      = 'strict'
                    edgeBlockPopups                                       = $true
                    edgeBlockSearchSuggestions                            = $true
                    edgeBlockSendingIntranetTrafficToInternetExplorer     = $true
                    edgeSendIntranetTrafficToInternetExplorer             = $true
                    edgeRequireSmartScreen                                = $true
                    edgeFirstRunUrl                                       = 'https://contoso.com/'
                    edgeBlockAccessToAboutFlags                           = $true
                    edgeHomepageUrls                                      = "[`"https://microsoft.com`"]"
                    smartScreenBlockPromptOverride                        = $true
                    smartScreenBlockPromptOverrideForFiles                = $true
                    webRtcBlockLocalhostIpAddress                         = $true
                    internetSharingBlocked                                = $true
                    settingsBlockAddProvisioningPackage                   = $true
                    settingsBlockRemoveProvisioningPackage                = $true
                    settingsBlockChangeSystemTime                         = $true
                    settingsBlockEditDeviceName                           = $true
                    settingsBlockChangeRegion                             = $true
                    settingsBlockChangeLanguage                           = $true
                    settingsBlockChangePowerSleep                         = $true
                    locationServicesBlocked                               = $true
                    microsoftAccountBlocked                               = $true
                    microsoftAccountBlockSettingsSync                     = $true
                    nfcBlocked                                            = $true
                    resetProtectionModeBlocked                            = $true
                    screenCaptureBlocked                                  = $true
                    storageBlockRemovableStorage                          = $true
                    storageRequireMobileDeviceEncryption                  = $true
                    usbBlocked                                            = $true
                    voiceRecordingBlocked                                 = $true
                    wiFiBlockAutomaticConnectHotspots                     = $true
                    wiFiBlocked                                           = $true
                    wiFiBlockManualConfiguration                          = $true
                    wiFiScanInterval                                      = 1
                    wirelessDisplayBlockProjectionToThisDevice            = $true
                    wirelessDisplayBlockUserInputFromReceiver             = $true
                    wirelessDisplayRequirePinForPairing                   = $true
                    windowsStoreBlocked                                   = $true
                    appsAllowTrustedAppsSideloading                       = 'blocked'
                    windowsStoreBlockAutoUpdate                           = $true
                    developerUnlockSetting                                = 'blocked'
                    sharedUserAppDataAllowed                              = $true
                    appsBlockWindowsStoreOriginatedApps                   = $true
                    windowsStoreEnablePrivateStoreOnly                    = $true
                    storageRestrictAppDataToSystemVolume                  = $true
                    storageRestrictAppInstallToSystemVolume               = $true
                    gameDvrBlocked                                        = $true
                    edgeSearchEngine                                      = 'bing'
                    #edgeSearchEngine = "https://go.microsoft.com/fwlink/?linkid=842596"  #'Google'
                    experienceBlockDeviceDiscovery                        = $true
                    experienceBlockErrorDialogWhenNoSIM                   = $true
                    experienceBlockTaskSwitcher                           = $true
                    logonBlockFastUserSwitching                           = $true
                    tenantLockdownRequireNetworkDuringOutOfBoxExperience  = $true
                    enterpriseCloudPrintDiscoveryEndPoint                 = 'https://cloudprinterdiscovery.contoso.com'
                    enterpriseCloudPrintDiscoveryMaxLimit                 = 4
                    enterpriseCloudPrintMopriaDiscoveryResourceIdentifier = 'http://mopriadiscoveryservice/cloudprint'
                    enterpriseCloudPrintOAuthClientIdentifier             = '30fbf7e8-321c-40ce-8b9f-160b6b049257'
                    enterpriseCloudPrintOAuthAuthority                    = 'https:/tenant.contoso.com/adfs'
                    enterpriseCloudPrintResourceIdentifier                = 'http://cloudenterpriseprint/cloudPrint'
                    networkProxyServer                                    = @('address=proxy.contoso.com:8080', "exceptions=*.contoso.com`r`n*.internal.local", 'useForLocalAddresses=false')
                    Ensure                                                = 'Present'
                    Credential                                            = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return $null
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create the policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-MgDeviceManagementDeviceConfiguration' -Exactly 1
            }
        }

        Context -Name 'When the policy already exists and is NOT in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    displayName                                           = 'CONTOSO | W10 | Device Restriction'
                    description                                           = 'Default device restriction settings'
                    defenderBlockEndUserAccess                            = $true
                    defenderRequireRealTimeMonitoring                     = $true
                    defenderRequireBehaviorMonitoring                     = $true
                    defenderRequireNetworkInspectionSystem                = $true
                    defenderScanDownloads                                 = $true
                    defenderScanScriptsLoadedInInternetExplorer           = $true
                    defenderSignatureUpdateIntervalInHours                = 8
                    defenderMonitorFileActivity                           = 'monitorIncomingFilesOnly'  # userDefined,monitorAllFiles,monitorIncomingFilesOnly,monitorOutgoingFilesOnly
                    defenderDaysBeforeDeletingQuarantinedMalware          = 3
                    defenderScanMaxCpu                                    = 2
                    defenderScanArchiveFiles                              = $true
                    defenderScanIncomingMail                              = $true
                    defenderScanRemovableDrivesDuringFullScan             = $true
                    defenderScanMappedNetworkDrivesDuringFullScan         = $false
                    defenderScanNetworkFiles                              = $false
                    defenderRequireCloudProtection                        = $true
                    defenderCloudBlockLevel                               = 'high'
                    defenderPromptForSampleSubmission                     = 'alwaysPrompt'
                    defenderScheduledQuickScanTime                        = '13:00:00.0000000'
                    defenderScanType                                      = 'quick'   #quick,full,userDefined
                    defenderSystemScanSchedule                            = 'monday'  #days of week
                    defenderScheduledScanTime                             = '11:00:00.0000000'
                    defenderDetectedMalwareActions                        = (New-CimInstance -ClassName MSFT_IntuneDefenderDetectedMalwareActions -Property @{
                            lowSeverity      = 'clean'
                            moderateSeverity = 'quarantine'
                            highSeverity     = 'remove'
                            severeSeverity   = 'block'
                        } -ClientOnly)
                    defenderFileExtensionsToExclude                       = "[`"csv,jpg,docx`"]"
                    defenderFilesAndFoldersToExclude                      = "[`"c:\\2,C:\\1`"]"
                    defenderProcessesToExclude                            = "[`"notepad.exe,c:\\Windows\\myprocess.exe`"]"
                    lockScreenAllowTimeoutConfiguration                   = $true
                    lockScreenBlockActionCenterNotifications              = $true
                    lockScreenBlockCortana                                = $true
                    lockScreenBlockToastNotifications                     = $false
                    lockScreenTimeoutInSeconds                            = 90
                    passwordBlockSimple                                   = $true
                    passwordExpirationDays                                = 6
                    passwordMinimumLength                                 = 5
                    passwordMinutesOfInactivityBeforeScreenTimeout        = 15
                    passwordMinimumCharacterSetCount                      = 1
                    passwordPreviousPasswordBlockCount                    = 2
                    passwordRequired                                      = $true
                    passwordRequireWhenResumeFromIdleState                = $true
                    passwordRequiredType                                  = 'alphanumeric'
                    passwordSignInFailureCountBeforeFactoryReset          = 12
                    privacyAdvertisingId                                  = 'blocked'
                    privacyAutoAcceptPairingAndConsentPrompts             = $true
                    privacyBlockInputPersonalization                      = $true
                    startBlockUnpinningAppsFromTaskbar                    = $true
                    startMenuAppListVisibility                            = 'collapse'
                    startMenuHideChangeAccountSettings                    = $true
                    startMenuHideFrequentlyUsedApps                       = $true
                    startMenuHideHibernate                                = $true
                    startMenuHideLock                                     = $true
                    startMenuHidePowerButton                              = $true
                    startMenuHideRecentJumpLists                          = $true
                    startMenuHideRecentlyAddedApps                        = $true
                    startMenuHideRestartOptions                           = $true
                    startMenuHideShutDown                                 = $true
                    startMenuHideSignOut                                  = $true
                    startMenuHideSleep                                    = $true
                    startMenuHideSwitchAccount                            = $true
                    startMenuHideUserTile                                 = $true
                    startMenuLayoutXml                                    = '+DQogICAGlmaWNhdGlvblRlbXBsYXRlPg=='
                    startMenuMode                                         = 'fullScreen'
                    startMenuPinnedFolderDocuments                        = 'hide'
                    startMenuPinnedFolderDownloads                        = 'hide'
                    startMenuPinnedFolderFileExplorer                     = 'hide'
                    startMenuPinnedFolderHomeGroup                        = 'hide'
                    startMenuPinnedFolderMusic                            = 'hide'
                    startMenuPinnedFolderNetwork                          = 'hide'
                    startMenuPinnedFolderPersonalFolder                   = 'hide'
                    startMenuPinnedFolderPictures                         = 'hide'
                    startMenuPinnedFolderSettings                         = 'hide'
                    startMenuPinnedFolderVideos                           = 'hide'
                    settingsBlockSettingsApp                              = $true
                    settingsBlockSystemPage                               = $true
                    settingsBlockDevicesPage                              = $true
                    settingsBlockNetworkInternetPage                      = $true
                    settingsBlockPersonalizationPage                      = $true
                    settingsBlockAccountsPage                             = $true
                    settingsBlockTimeLanguagePage                         = $true
                    settingsBlockEaseOfAccessPage                         = $true
                    settingsBlockPrivacyPage                              = $true
                    settingsBlockUpdateSecurityPage                       = $true
                    settingsBlockAppsPage                                 = $true
                    settingsBlockGamingPage                               = $true
                    windowsSpotlightBlockConsumerSpecificFeatures         = $true
                    windowsSpotlightBlocked                               = $true
                    windowsSpotlightBlockOnActionCenter                   = $true
                    windowsSpotlightBlockTailoredExperiences              = $true
                    windowsSpotlightBlockThirdPartyNotifications          = $true
                    windowsSpotlightBlockWelcomeExperience                = $true
                    windowsSpotlightBlockWindowsTips                      = $true
                    windowsSpotlightConfigureOnLockScreen                 = 'disabled'
                    networkProxyApplySettingsDeviceWide                   = $true
                    networkProxyDisableAutoDetect                         = $true
                    networkProxyAutomaticConfigurationUrl                 = 'https://example.com/networkProxyAutomaticConfigurationUrl/'
                    accountsBlockAddingNonMicrosoftAccountEmail           = $true
                    antiTheftModeBlocked                                  = $true
                    bluetoothBlocked                                      = $true
                    bluetoothAllowedServices                              = "[`"8e473eaa-ead4-4c60-ba9c-2c5696d71492`",`"21913f2d-a803-4f36-8039-669fd94ce5b3`"]"
                    bluetoothBlockAdvertising                             = $true
                    bluetoothBlockDiscoverableMode                        = $true
                    bluetoothBlockPrePairing                              = $true
                    cameraBlocked                                         = $true
                    connectedDevicesServiceBlocked                        = $true
                    certificatesBlockManualRootCertificateInstallation    = $true
                    copyPasteBlocked                                      = $true
                    cortanaBlocked                                        = $true
                    deviceManagementBlockFactoryResetOnMobile             = $true
                    deviceManagementBlockManualUnenroll                   = $true
                    safeSearchFilter                                      = 'strict'
                    edgeBlockPopups                                       = $true
                    edgeBlockSearchSuggestions                            = $true
                    edgeBlockSendingIntranetTrafficToInternetExplorer     = $true
                    edgeSendIntranetTrafficToInternetExplorer             = $true
                    edgeRequireSmartScreen                                = $true
                    edgeFirstRunUrl                                       = 'https://contoso.com/'
                    edgeBlockAccessToAboutFlags                           = $true
                    edgeHomepageUrls                                      = "[`"https://microsoft.com`"]"
                    smartScreenBlockPromptOverride                        = $true
                    smartScreenBlockPromptOverrideForFiles                = $true
                    webRtcBlockLocalhostIpAddress                         = $true
                    internetSharingBlocked                                = $true
                    settingsBlockAddProvisioningPackage                   = $true
                    settingsBlockRemoveProvisioningPackage                = $true
                    settingsBlockChangeSystemTime                         = $true
                    settingsBlockEditDeviceName                           = $true
                    settingsBlockChangeRegion                             = $true
                    settingsBlockChangeLanguage                           = $true
                    settingsBlockChangePowerSleep                         = $true
                    locationServicesBlocked                               = $true
                    microsoftAccountBlocked                               = $true
                    microsoftAccountBlockSettingsSync                     = $true
                    nfcBlocked                                            = $true
                    resetProtectionModeBlocked                            = $true
                    screenCaptureBlocked                                  = $true
                    storageBlockRemovableStorage                          = $true
                    storageRequireMobileDeviceEncryption                  = $true
                    usbBlocked                                            = $true
                    voiceRecordingBlocked                                 = $true
                    wiFiBlockAutomaticConnectHotspots                     = $true
                    wiFiBlocked                                           = $true
                    wiFiBlockManualConfiguration                          = $true
                    wiFiScanInterval                                      = 1
                    wirelessDisplayBlockProjectionToThisDevice            = $true
                    wirelessDisplayBlockUserInputFromReceiver             = $true
                    wirelessDisplayRequirePinForPairing                   = $true
                    windowsStoreBlocked                                   = $true
                    appsAllowTrustedAppsSideloading                       = 'blocked'
                    windowsStoreBlockAutoUpdate                           = $true
                    developerUnlockSetting                                = 'blocked'
                    sharedUserAppDataAllowed                              = $true
                    appsBlockWindowsStoreOriginatedApps                   = $true
                    windowsStoreEnablePrivateStoreOnly                    = $true
                    storageRestrictAppDataToSystemVolume                  = $true
                    storageRestrictAppInstallToSystemVolume               = $true
                    gameDvrBlocked                                        = $true
                    edgeSearchEngine                                      = 'bing'
                    experienceBlockDeviceDiscovery                        = $true
                    experienceBlockErrorDialogWhenNoSIM                   = $true
                    experienceBlockTaskSwitcher                           = $true
                    logonBlockFastUserSwitching                           = $true
                    tenantLockdownRequireNetworkDuringOutOfBoxExperience  = $true
                    enterpriseCloudPrintDiscoveryEndPoint                 = 'https://cloudprinterdiscovery.contoso.com'
                    enterpriseCloudPrintDiscoveryMaxLimit                 = 4
                    enterpriseCloudPrintMopriaDiscoveryResourceIdentifier = 'http://mopriadiscoveryservice/cloudprint'
                    enterpriseCloudPrintOAuthClientIdentifier             = '30fbf7e8-321c-40ce-8b9f-160b6b049257'
                    enterpriseCloudPrintOAuthAuthority                    = 'https:/tenant.contoso.com/adfs'
                    enterpriseCloudPrintResourceIdentifier                = 'http://cloudenterpriseprint/cloudPrint'
                    networkProxyServer                                    = @('address=proxy.contoso.com:8080', "exceptions=*.contoso.com`r`n*.internal.local", 'useForLocalAddresses=false')
                    Ensure                                                = 'Present'
                    Credential                                            = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        id                   = '12345-12345-12345-12345-12345'
                        displayName          = 'CONTOSO | W10 | Device Restriction'
                        description          = 'Default device restriction settings'
                        AdditionalProperties = @{
                            '@odata.type'                                         = '#microsoft.graph.windows10GeneralConfiguration'
                            defenderBlockEndUserAccess                            = $true
                            defenderRequireRealTimeMonitoring                     = $true
                            defenderRequireBehaviorMonitoring                     = $true
                            defenderRequireNetworkInspectionSystem                = $true
                            defenderScanDownloads                                 = $true
                            defenderScanScriptsLoadedInInternetExplorer           = $true
                            defenderSignatureUpdateIntervalInHours                = 8
                            defenderMonitorFileActivity                           = 'monitorIncomingFilesOnly'  # userDefined,monitorAllFiles,monitorIncomingFilesOnly,monitorOutgoingFilesOnly
                            defenderDaysBeforeDeletingQuarantinedMalware          = 3
                            defenderScanMaxCpu                                    = 2
                            defenderScanArchiveFiles                              = $true
                            defenderScanIncomingMail                              = $false # Drift
                            defenderScanRemovableDrivesDuringFullScan             = $true
                            defenderScanMappedNetworkDrivesDuringFullScan         = $false
                            defenderScanNetworkFiles                              = $false
                            defenderRequireCloudProtection                        = $true
                            defenderCloudBlockLevel                               = 'high'
                            defenderPromptForSampleSubmission                     = 'alwaysPrompt'
                            defenderScheduledQuickScanTime                        = '13:00:00.0000000'
                            defenderScanType                                      = 'quick'   #quick,full,userDefined
                            defenderSystemScanSchedule                            = 'monday'  #days of week
                            defenderScheduledScanTime                             = '11:00:00.0000000'
                            defenderDetectedMalwareActions                        = @{
                                lowSeverity      = 'clean'
                                moderateSeverity = 'quarantine'
                                highSeverity     = 'remove'
                                severeSeverity   = 'block'
                            }
                            defenderFileExtensionsToExclude                       = "[`"csv,jpg,docx`"]"
                            defenderFilesAndFoldersToExclude                      = "[`"c:\\2,C:\\1`"]"
                            defenderProcessesToExclude                            = "[`"notepad.exe,c:\\Windows\\myprocess.exe`"]"
                            lockScreenAllowTimeoutConfiguration                   = $true
                            lockScreenBlockActionCenterNotifications              = $true
                            lockScreenBlockCortana                                = $true
                            lockScreenBlockToastNotifications                     = $false
                            lockScreenTimeoutInSeconds                            = 90
                            passwordBlockSimple                                   = $true
                            passwordExpirationDays                                = 6
                            passwordMinimumLength                                 = 5
                            passwordMinutesOfInactivityBeforeScreenTimeout        = 15
                            passwordMinimumCharacterSetCount                      = 1
                            passwordPreviousPasswordBlockCount                    = 2
                            passwordRequired                                      = $true
                            passwordRequireWhenResumeFromIdleState                = $true
                            passwordRequiredType                                  = 'alphanumeric'
                            passwordSignInFailureCountBeforeFactoryReset          = 12
                            privacyAdvertisingId                                  = 'blocked'
                            privacyAutoAcceptPairingAndConsentPrompts             = $true
                            privacyBlockInputPersonalization                      = $true
                            startBlockUnpinningAppsFromTaskbar                    = $true
                            startMenuAppListVisibility                            = 'collapse'
                            startMenuHideChangeAccountSettings                    = $true
                            startMenuHideFrequentlyUsedApps                       = $true
                            startMenuHideHibernate                                = $true
                            startMenuHideLock                                     = $true
                            startMenuHidePowerButton                              = $true
                            startMenuHideRecentJumpLists                          = $true
                            startMenuHideRecentlyAddedApps                        = $true
                            startMenuHideRestartOptions                           = $true
                            startMenuHideShutDown                                 = $true
                            startMenuHideSignOut                                  = $true
                            startMenuHideSleep                                    = $true
                            startMenuHideSwitchAccount                            = $true
                            startMenuHideUserTile                                 = $true
                            startMenuLayoutXml                                    = '+DQogICAGlmaWNhdGlvblRlbXBsYXRlPg=='
                            startMenuMode                                         = 'fullScreen'
                            startMenuPinnedFolderDocuments                        = 'hide'
                            startMenuPinnedFolderDownloads                        = 'hide'
                            startMenuPinnedFolderFileExplorer                     = 'hide'
                            startMenuPinnedFolderHomeGroup                        = 'hide'
                            startMenuPinnedFolderMusic                            = 'hide'
                            startMenuPinnedFolderNetwork                          = 'hide'
                            startMenuPinnedFolderPersonalFolder                   = 'hide'
                            startMenuPinnedFolderPictures                         = 'hide'
                            startMenuPinnedFolderSettings                         = 'hide'
                            startMenuPinnedFolderVideos                           = 'hide'
                            settingsBlockSettingsApp                              = $true
                            settingsBlockSystemPage                               = $true
                            settingsBlockDevicesPage                              = $true
                            settingsBlockNetworkInternetPage                      = $true
                            settingsBlockPersonalizationPage                      = $true
                            settingsBlockAccountsPage                             = $true
                            settingsBlockTimeLanguagePage                         = $true
                            settingsBlockEaseOfAccessPage                         = $true
                            settingsBlockPrivacyPage                              = $true
                            settingsBlockUpdateSecurityPage                       = $true
                            settingsBlockAppsPage                                 = $true
                            settingsBlockGamingPage                               = $true
                            windowsSpotlightBlockConsumerSpecificFeatures         = $true
                            windowsSpotlightBlocked                               = $true
                            windowsSpotlightBlockOnActionCenter                   = $true
                            windowsSpotlightBlockTailoredExperiences              = $true
                            windowsSpotlightBlockThirdPartyNotifications          = $true
                            windowsSpotlightBlockWelcomeExperience                = $true
                            windowsSpotlightBlockWindowsTips                      = $true
                            windowsSpotlightConfigureOnLockScreen                 = 'disabled'
                            networkProxyApplySettingsDeviceWide                   = $true
                            networkProxyDisableAutoDetect                         = $true
                            networkProxyAutomaticConfigurationUrl                 = 'https://example.com/networkProxyAutomaticConfigurationUrl/'
                            accountsBlockAddingNonMicrosoftAccountEmail           = $true
                            antiTheftModeBlocked                                  = $true
                            bluetoothBlocked                                      = $true
                            bluetoothAllowedServices                              = "[`"8e473eaa-ead4-4c60-ba9c-2c5696d71492`",`"21913f2d-a803-4f36-8039-669fd94ce5b3`"]"
                            bluetoothBlockAdvertising                             = $true
                            bluetoothBlockDiscoverableMode                        = $true
                            bluetoothBlockPrePairing                              = $true
                            cameraBlocked                                         = $true
                            connectedDevicesServiceBlocked                        = $true
                            certificatesBlockManualRootCertificateInstallation    = $true
                            copyPasteBlocked                                      = $true
                            cortanaBlocked                                        = $true
                            deviceManagementBlockFactoryResetOnMobile             = $true
                            deviceManagementBlockManualUnenroll                   = $true
                            safeSearchFilter                                      = 'strict'
                            edgeBlockPopups                                       = $true
                            edgeBlockSearchSuggestions                            = $true
                            edgeBlockSendingIntranetTrafficToInternetExplorer     = $true
                            edgeSendIntranetTrafficToInternetExplorer             = $true
                            edgeRequireSmartScreen                                = $true
                            edgeFirstRunUrl                                       = 'https://contoso.com/'
                            edgeBlockAccessToAboutFlags                           = $true
                            edgeHomepageUrls                                      = "[`"https://microsoft.com`"]"
                            smartScreenBlockPromptOverride                        = $true
                            smartScreenBlockPromptOverrideForFiles                = $true
                            webRtcBlockLocalhostIpAddress                         = $true
                            internetSharingBlocked                                = $true
                            settingsBlockAddProvisioningPackage                   = $true
                            settingsBlockRemoveProvisioningPackage                = $true
                            settingsBlockChangeSystemTime                         = $true
                            settingsBlockEditDeviceName                           = $true
                            settingsBlockChangeRegion                             = $true
                            settingsBlockChangeLanguage                           = $true
                            settingsBlockChangePowerSleep                         = $true
                            locationServicesBlocked                               = $true
                            microsoftAccountBlocked                               = $true
                            microsoftAccountBlockSettingsSync                     = $true
                            nfcBlocked                                            = $true
                            resetProtectionModeBlocked                            = $true
                            screenCaptureBlocked                                  = $true
                            storageBlockRemovableStorage                          = $true
                            storageRequireMobileDeviceEncryption                  = $true
                            usbBlocked                                            = $true
                            voiceRecordingBlocked                                 = $true
                            wiFiBlockAutomaticConnectHotspots                     = $true
                            wiFiBlocked                                           = $true
                            wiFiBlockManualConfiguration                          = $true
                            wiFiScanInterval                                      = 1
                            wirelessDisplayBlockProjectionToThisDevice            = $true
                            wirelessDisplayBlockUserInputFromReceiver             = $true
                            wirelessDisplayRequirePinForPairing                   = $true
                            windowsStoreBlocked                                   = $true
                            appsAllowTrustedAppsSideloading                       = 'blocked'
                            windowsStoreBlockAutoUpdate                           = $true
                            developerUnlockSetting                                = 'blocked'
                            sharedUserAppDataAllowed                              = $true
                            appsBlockWindowsStoreOriginatedApps                   = $true
                            windowsStoreEnablePrivateStoreOnly                    = $true
                            storageRestrictAppDataToSystemVolume                  = $true
                            storageRestrictAppInstallToSystemVolume               = $true
                            gameDvrBlocked                                        = $true
                            edgeSearchEngine                                      = @{edgeSearchEngineType = 'bing' }
                            experienceBlockDeviceDiscovery                        = $true
                            experienceBlockErrorDialogWhenNoSIM                   = $true
                            experienceBlockTaskSwitcher                           = $true
                            logonBlockFastUserSwitching                           = $true
                            tenantLockdownRequireNetworkDuringOutOfBoxExperience  = $true
                            enterpriseCloudPrintDiscoveryEndPoint                 = 'https://cloudprinterdiscovery.contoso.com'
                            enterpriseCloudPrintDiscoveryMaxLimit                 = 4
                            enterpriseCloudPrintMopriaDiscoveryResourceIdentifier = 'http://mopriadiscoveryservice/cloudprint'
                            enterpriseCloudPrintOAuthClientIdentifier             = '30fbf7e8-321c-40ce-8b9f-160b6b049257'
                            enterpriseCloudPrintOAuthAuthority                    = 'https:/tenant.contoso.com/adfs'
                            enterpriseCloudPrintResourceIdentifier                = 'http://cloudenterpriseprint/cloudPrint'
                            networkProxyServer                                    = @('address=proxy.contoso.com:8080', "exceptions=*.contoso.com`r`n*.internal.local", 'useForLocalAddresses=false')
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

            It 'Should update the policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name 'When the policy already exists and IS in the Desired State' -Fixture {
            BeforeAll {

                $testParams = @{
                    displayName                                           = 'CONTOSO | W10 | Device Restriction'
                    description                                           = 'Default device restriction settings'
                    defenderBlockEndUserAccess                            = $true
                    defenderRequireRealTimeMonitoring                     = $true
                    defenderRequireBehaviorMonitoring                     = $true
                    defenderRequireNetworkInspectionSystem                = $true
                    defenderScanDownloads                                 = $true
                    defenderScanScriptsLoadedInInternetExplorer           = $true
                    defenderSignatureUpdateIntervalInHours                = 8
                    defenderMonitorFileActivity                           = 'monitorIncomingFilesOnly'  # userDefined,monitorAllFiles,monitorIncomingFilesOnly,monitorOutgoingFilesOnly
                    defenderDaysBeforeDeletingQuarantinedMalware          = 3
                    defenderScanMaxCpu                                    = 2
                    defenderScanArchiveFiles                              = $true
                    defenderScanIncomingMail                              = $true
                    defenderScanRemovableDrivesDuringFullScan             = $true
                    defenderScanMappedNetworkDrivesDuringFullScan         = $false
                    defenderScanNetworkFiles                              = $false
                    defenderRequireCloudProtection                        = $true
                    defenderCloudBlockLevel                               = 'high'
                    defenderPromptForSampleSubmission                     = 'alwaysPrompt'
                    defenderScheduledQuickScanTime                        = '13:00:00.0000000'
                    defenderScanType                                      = 'quick'   #quick,full,userDefined
                    defenderSystemScanSchedule                            = 'monday'  #days of week
                    defenderScheduledScanTime                             = '11:00:00.0000000'
                    defenderDetectedMalwareActions                        = (New-CimInstance -ClassName MSFT_IntuneDefenderDetectedMalwareActions -Property @{
                            lowSeverity      = 'clean'
                            moderateSeverity = 'quarantine'
                            highSeverity     = 'remove'
                            severeSeverity   = 'block'
                        } -ClientOnly)
                    defenderFileExtensionsToExclude                       = "[`"csv,jpg,docx`"]"
                    defenderFilesAndFoldersToExclude                      = "[`"c:\\2,C:\\1`"]"
                    defenderProcessesToExclude                            = "[`"notepad.exe,c:\\Windows\\myprocess.exe`"]"
                    lockScreenAllowTimeoutConfiguration                   = $true
                    lockScreenBlockActionCenterNotifications              = $true
                    lockScreenBlockCortana                                = $true
                    lockScreenBlockToastNotifications                     = $false
                    lockScreenTimeoutInSeconds                            = 90
                    passwordBlockSimple                                   = $true
                    passwordExpirationDays                                = 6
                    passwordMinimumLength                                 = 5
                    passwordMinutesOfInactivityBeforeScreenTimeout        = 15
                    passwordMinimumCharacterSetCount                      = 1
                    passwordPreviousPasswordBlockCount                    = 2
                    passwordRequired                                      = $true
                    passwordRequireWhenResumeFromIdleState                = $true
                    passwordRequiredType                                  = 'alphanumeric'
                    passwordSignInFailureCountBeforeFactoryReset          = 12
                    privacyAdvertisingId                                  = 'blocked'
                    privacyAutoAcceptPairingAndConsentPrompts             = $true
                    privacyBlockInputPersonalization                      = $true
                    startBlockUnpinningAppsFromTaskbar                    = $true
                    startMenuAppListVisibility                            = 'collapse'
                    startMenuHideChangeAccountSettings                    = $true
                    startMenuHideFrequentlyUsedApps                       = $true
                    startMenuHideHibernate                                = $true
                    startMenuHideLock                                     = $true
                    startMenuHidePowerButton                              = $true
                    startMenuHideRecentJumpLists                          = $true
                    startMenuHideRecentlyAddedApps                        = $true
                    startMenuHideRestartOptions                           = $true
                    startMenuHideShutDown                                 = $true
                    startMenuHideSignOut                                  = $true
                    startMenuHideSleep                                    = $true
                    startMenuHideSwitchAccount                            = $true
                    startMenuHideUserTile                                 = $true
                    startMenuLayoutXml                                    = '+DQogICAGlmaWNhdGlvblRlbXBsYXRlPg=='
                    startMenuMode                                         = 'fullScreen'
                    startMenuPinnedFolderDocuments                        = 'hide'
                    startMenuPinnedFolderDownloads                        = 'hide'
                    startMenuPinnedFolderFileExplorer                     = 'hide'
                    startMenuPinnedFolderHomeGroup                        = 'hide'
                    startMenuPinnedFolderMusic                            = 'hide'
                    startMenuPinnedFolderNetwork                          = 'hide'
                    startMenuPinnedFolderPersonalFolder                   = 'hide'
                    startMenuPinnedFolderPictures                         = 'hide'
                    startMenuPinnedFolderSettings                         = 'hide'
                    startMenuPinnedFolderVideos                           = 'hide'
                    settingsBlockSettingsApp                              = $true
                    settingsBlockSystemPage                               = $true
                    settingsBlockDevicesPage                              = $true
                    settingsBlockNetworkInternetPage                      = $true
                    settingsBlockPersonalizationPage                      = $true
                    settingsBlockAccountsPage                             = $true
                    settingsBlockTimeLanguagePage                         = $true
                    settingsBlockEaseOfAccessPage                         = $true
                    settingsBlockPrivacyPage                              = $true
                    settingsBlockUpdateSecurityPage                       = $true
                    settingsBlockAppsPage                                 = $true
                    settingsBlockGamingPage                               = $true
                    windowsSpotlightBlockConsumerSpecificFeatures         = $true
                    windowsSpotlightBlocked                               = $true
                    windowsSpotlightBlockOnActionCenter                   = $true
                    windowsSpotlightBlockTailoredExperiences              = $true
                    windowsSpotlightBlockThirdPartyNotifications          = $true
                    windowsSpotlightBlockWelcomeExperience                = $true
                    windowsSpotlightBlockWindowsTips                      = $true
                    windowsSpotlightConfigureOnLockScreen                 = 'disabled'
                    networkProxyApplySettingsDeviceWide                   = $true
                    networkProxyDisableAutoDetect                         = $true
                    networkProxyAutomaticConfigurationUrl                 = 'https://example.com/networkProxyAutomaticConfigurationUrl/'
                    accountsBlockAddingNonMicrosoftAccountEmail           = $true
                    antiTheftModeBlocked                                  = $true
                    bluetoothBlocked                                      = $true
                    bluetoothAllowedServices                              = "[`"8e473eaa-ead4-4c60-ba9c-2c5696d71492`",`"21913f2d-a803-4f36-8039-669fd94ce5b3`"]"
                    bluetoothBlockAdvertising                             = $true
                    bluetoothBlockDiscoverableMode                        = $true
                    bluetoothBlockPrePairing                              = $true
                    cameraBlocked                                         = $true
                    connectedDevicesServiceBlocked                        = $true
                    certificatesBlockManualRootCertificateInstallation    = $true
                    copyPasteBlocked                                      = $true
                    cortanaBlocked                                        = $true
                    deviceManagementBlockFactoryResetOnMobile             = $true
                    deviceManagementBlockManualUnenroll                   = $true
                    safeSearchFilter                                      = 'strict'
                    edgeBlockPopups                                       = $true
                    edgeBlockSearchSuggestions                            = $true
                    edgeBlockSendingIntranetTrafficToInternetExplorer     = $true
                    edgeSendIntranetTrafficToInternetExplorer             = $true
                    edgeRequireSmartScreen                                = $true
                    edgeFirstRunUrl                                       = 'https://contoso.com/'
                    edgeBlockAccessToAboutFlags                           = $true
                    edgeHomepageUrls                                      = "[`"https://microsoft.com`"]"
                    smartScreenBlockPromptOverride                        = $true
                    smartScreenBlockPromptOverrideForFiles                = $true
                    webRtcBlockLocalhostIpAddress                         = $true
                    internetSharingBlocked                                = $true
                    settingsBlockAddProvisioningPackage                   = $true
                    settingsBlockRemoveProvisioningPackage                = $true
                    settingsBlockChangeSystemTime                         = $true
                    settingsBlockEditDeviceName                           = $true
                    settingsBlockChangeRegion                             = $true
                    settingsBlockChangeLanguage                           = $true
                    settingsBlockChangePowerSleep                         = $true
                    locationServicesBlocked                               = $true
                    microsoftAccountBlocked                               = $true
                    microsoftAccountBlockSettingsSync                     = $true
                    nfcBlocked                                            = $true
                    resetProtectionModeBlocked                            = $true
                    screenCaptureBlocked                                  = $true
                    storageBlockRemovableStorage                          = $true
                    storageRequireMobileDeviceEncryption                  = $true
                    usbBlocked                                            = $true
                    voiceRecordingBlocked                                 = $true
                    wiFiBlockAutomaticConnectHotspots                     = $true
                    wiFiBlocked                                           = $true
                    wiFiBlockManualConfiguration                          = $true
                    wiFiScanInterval                                      = 1
                    wirelessDisplayBlockProjectionToThisDevice            = $true
                    wirelessDisplayBlockUserInputFromReceiver             = $true
                    wirelessDisplayRequirePinForPairing                   = $true
                    windowsStoreBlocked                                   = $true
                    appsAllowTrustedAppsSideloading                       = 'blocked'
                    windowsStoreBlockAutoUpdate                           = $true
                    developerUnlockSetting                                = 'blocked'
                    sharedUserAppDataAllowed                              = $true
                    appsBlockWindowsStoreOriginatedApps                   = $true
                    windowsStoreEnablePrivateStoreOnly                    = $true
                    storageRestrictAppDataToSystemVolume                  = $true
                    storageRestrictAppInstallToSystemVolume               = $true
                    gameDvrBlocked                                        = $true
                    edgeSearchEngine                                      = 'bing'
                    experienceBlockDeviceDiscovery                        = $true
                    experienceBlockErrorDialogWhenNoSIM                   = $true
                    experienceBlockTaskSwitcher                           = $true
                    logonBlockFastUserSwitching                           = $true
                    tenantLockdownRequireNetworkDuringOutOfBoxExperience  = $true
                    enterpriseCloudPrintDiscoveryEndPoint                 = 'https://cloudprinterdiscovery.contoso.com'
                    enterpriseCloudPrintDiscoveryMaxLimit                 = 4
                    enterpriseCloudPrintMopriaDiscoveryResourceIdentifier = 'http://mopriadiscoveryservice/cloudprint'
                    enterpriseCloudPrintOAuthClientIdentifier             = '30fbf7e8-321c-40ce-8b9f-160b6b049257'
                    enterpriseCloudPrintOAuthAuthority                    = 'https:/tenant.contoso.com/adfs'
                    enterpriseCloudPrintResourceIdentifier                = 'http://cloudenterpriseprint/cloudPrint'
                    networkProxyServer                                    = @('address=proxy.contoso.com:8080', "exceptions=*.contoso.com`r`n*.internal.local", 'useForLocalAddresses=false')
                    Ensure                                                = 'Present'
                    Credential                                            = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        id                   = '12345-12345-12345-12345-12345'
                        displayName          = 'CONTOSO | W10 | Device Restriction'
                        description          = 'Default device restriction settings'
                        AdditionalProperties = @{
                            '@odata.type'                                         = '#microsoft.graph.windows10GeneralConfiguration'
                            defenderBlockEndUserAccess                            = $true
                            defenderRequireRealTimeMonitoring                     = $true
                            defenderRequireBehaviorMonitoring                     = $true
                            defenderRequireNetworkInspectionSystem                = $true
                            defenderScanDownloads                                 = $true
                            defenderScanScriptsLoadedInInternetExplorer           = $true
                            defenderSignatureUpdateIntervalInHours                = 8
                            defenderMonitorFileActivity                           = 'monitorIncomingFilesOnly'  # userDefined,monitorAllFiles,monitorIncomingFilesOnly,monitorOutgoingFilesOnly
                            defenderDaysBeforeDeletingQuarantinedMalware          = 3
                            defenderScanMaxCpu                                    = 2
                            defenderScanArchiveFiles                              = $true
                            defenderScanIncomingMail                              = $true
                            defenderScanRemovableDrivesDuringFullScan             = $true
                            defenderScanMappedNetworkDrivesDuringFullScan         = $false
                            defenderScanNetworkFiles                              = $false
                            defenderRequireCloudProtection                        = $true
                            defenderCloudBlockLevel                               = 'high'
                            defenderPromptForSampleSubmission                     = 'alwaysPrompt'
                            defenderScheduledQuickScanTime                        = '13:00:00.0000000'
                            defenderScanType                                      = 'quick'   #quick,full,userDefined
                            defenderSystemScanSchedule                            = 'monday'  #days of week
                            defenderScheduledScanTime                             = '11:00:00.0000000'
                            defenderDetectedMalwareActions                        = @{
                                lowSeverity      = 'clean'
                                moderateSeverity = 'quarantine'
                                highSeverity     = 'remove'
                                severeSeverity   = 'block'
                            }
                            defenderFileExtensionsToExclude                       = "[`"csv,jpg,docx`"]"
                            defenderFilesAndFoldersToExclude                      = "[`"c:\\2,C:\\1`"]"
                            defenderProcessesToExclude                            = "[`"notepad.exe,c:\\Windows\\myprocess.exe`"]"
                            lockScreenAllowTimeoutConfiguration                   = $true
                            lockScreenBlockActionCenterNotifications              = $true
                            lockScreenBlockCortana                                = $true
                            lockScreenBlockToastNotifications                     = $false
                            lockScreenTimeoutInSeconds                            = 90
                            passwordBlockSimple                                   = $true
                            passwordExpirationDays                                = 6
                            passwordMinimumLength                                 = 5
                            passwordMinutesOfInactivityBeforeScreenTimeout        = 15
                            passwordMinimumCharacterSetCount                      = 1
                            passwordPreviousPasswordBlockCount                    = 2
                            passwordRequired                                      = $true
                            passwordRequireWhenResumeFromIdleState                = $true
                            passwordRequiredType                                  = 'alphanumeric'
                            passwordSignInFailureCountBeforeFactoryReset          = 12
                            privacyAdvertisingId                                  = 'blocked'
                            privacyAutoAcceptPairingAndConsentPrompts             = $true
                            privacyBlockInputPersonalization                      = $true
                            startBlockUnpinningAppsFromTaskbar                    = $true
                            startMenuAppListVisibility                            = 'collapse'
                            startMenuHideChangeAccountSettings                    = $true
                            startMenuHideFrequentlyUsedApps                       = $true
                            startMenuHideHibernate                                = $true
                            startMenuHideLock                                     = $true
                            startMenuHidePowerButton                              = $true
                            startMenuHideRecentJumpLists                          = $true
                            startMenuHideRecentlyAddedApps                        = $true
                            startMenuHideRestartOptions                           = $true
                            startMenuHideShutDown                                 = $true
                            startMenuHideSignOut                                  = $true
                            startMenuHideSleep                                    = $true
                            startMenuHideSwitchAccount                            = $true
                            startMenuHideUserTile                                 = $true
                            startMenuLayoutXml                                    = '+DQogICAGlmaWNhdGlvblRlbXBsYXRlPg=='
                            startMenuMode                                         = 'fullScreen'
                            startMenuPinnedFolderDocuments                        = 'hide'
                            startMenuPinnedFolderDownloads                        = 'hide'
                            startMenuPinnedFolderFileExplorer                     = 'hide'
                            startMenuPinnedFolderHomeGroup                        = 'hide'
                            startMenuPinnedFolderMusic                            = 'hide'
                            startMenuPinnedFolderNetwork                          = 'hide'
                            startMenuPinnedFolderPersonalFolder                   = 'hide'
                            startMenuPinnedFolderPictures                         = 'hide'
                            startMenuPinnedFolderSettings                         = 'hide'
                            startMenuPinnedFolderVideos                           = 'hide'
                            settingsBlockSettingsApp                              = $true
                            settingsBlockSystemPage                               = $true
                            settingsBlockDevicesPage                              = $true
                            settingsBlockNetworkInternetPage                      = $true
                            settingsBlockPersonalizationPage                      = $true
                            settingsBlockAccountsPage                             = $true
                            settingsBlockTimeLanguagePage                         = $true
                            settingsBlockEaseOfAccessPage                         = $true
                            settingsBlockPrivacyPage                              = $true
                            settingsBlockUpdateSecurityPage                       = $true
                            settingsBlockAppsPage                                 = $true
                            settingsBlockGamingPage                               = $true
                            windowsSpotlightBlockConsumerSpecificFeatures         = $true
                            windowsSpotlightBlocked                               = $true
                            windowsSpotlightBlockOnActionCenter                   = $true
                            windowsSpotlightBlockTailoredExperiences              = $true
                            windowsSpotlightBlockThirdPartyNotifications          = $true
                            windowsSpotlightBlockWelcomeExperience                = $true
                            windowsSpotlightBlockWindowsTips                      = $true
                            windowsSpotlightConfigureOnLockScreen                 = 'disabled'
                            networkProxyApplySettingsDeviceWide                   = $true
                            networkProxyDisableAutoDetect                         = $true
                            networkProxyAutomaticConfigurationUrl                 = 'https://example.com/networkProxyAutomaticConfigurationUrl/'
                            accountsBlockAddingNonMicrosoftAccountEmail           = $true
                            antiTheftModeBlocked                                  = $true
                            bluetoothBlocked                                      = $true
                            bluetoothAllowedServices                              = "[`"8e473eaa-ead4-4c60-ba9c-2c5696d71492`",`"21913f2d-a803-4f36-8039-669fd94ce5b3`"]"
                            bluetoothBlockAdvertising                             = $true
                            bluetoothBlockDiscoverableMode                        = $true
                            bluetoothBlockPrePairing                              = $true
                            cameraBlocked                                         = $true
                            connectedDevicesServiceBlocked                        = $true
                            certificatesBlockManualRootCertificateInstallation    = $true
                            copyPasteBlocked                                      = $true
                            cortanaBlocked                                        = $true
                            deviceManagementBlockFactoryResetOnMobile             = $true
                            deviceManagementBlockManualUnenroll                   = $true
                            safeSearchFilter                                      = 'strict'
                            edgeBlockPopups                                       = $true
                            edgeBlockSearchSuggestions                            = $true
                            edgeBlockSendingIntranetTrafficToInternetExplorer     = $true
                            edgeSendIntranetTrafficToInternetExplorer             = $true
                            edgeRequireSmartScreen                                = $true
                            edgeFirstRunUrl                                       = 'https://contoso.com/'
                            edgeBlockAccessToAboutFlags                           = $true
                            edgeHomepageUrls                                      = "[`"https://microsoft.com`"]"
                            smartScreenBlockPromptOverride                        = $true
                            smartScreenBlockPromptOverrideForFiles                = $true
                            webRtcBlockLocalhostIpAddress                         = $true
                            internetSharingBlocked                                = $true
                            settingsBlockAddProvisioningPackage                   = $true
                            settingsBlockRemoveProvisioningPackage                = $true
                            settingsBlockChangeSystemTime                         = $true
                            settingsBlockEditDeviceName                           = $true
                            settingsBlockChangeRegion                             = $true
                            settingsBlockChangeLanguage                           = $true
                            settingsBlockChangePowerSleep                         = $true
                            locationServicesBlocked                               = $true
                            microsoftAccountBlocked                               = $true
                            microsoftAccountBlockSettingsSync                     = $true
                            nfcBlocked                                            = $true
                            resetProtectionModeBlocked                            = $true
                            screenCaptureBlocked                                  = $true
                            storageBlockRemovableStorage                          = $true
                            storageRequireMobileDeviceEncryption                  = $true
                            usbBlocked                                            = $true
                            voiceRecordingBlocked                                 = $true
                            wiFiBlockAutomaticConnectHotspots                     = $true
                            wiFiBlocked                                           = $true
                            wiFiBlockManualConfiguration                          = $true
                            wiFiScanInterval                                      = 1
                            wirelessDisplayBlockProjectionToThisDevice            = $true
                            wirelessDisplayBlockUserInputFromReceiver             = $true
                            wirelessDisplayRequirePinForPairing                   = $true
                            windowsStoreBlocked                                   = $true
                            appsAllowTrustedAppsSideloading                       = 'blocked'
                            windowsStoreBlockAutoUpdate                           = $true
                            developerUnlockSetting                                = 'blocked'
                            sharedUserAppDataAllowed                              = $true
                            appsBlockWindowsStoreOriginatedApps                   = $true
                            windowsStoreEnablePrivateStoreOnly                    = $true
                            storageRestrictAppDataToSystemVolume                  = $true
                            storageRestrictAppInstallToSystemVolume               = $true
                            gameDvrBlocked                                        = $true
                            edgeSearchEngine                                      = @{edgeSearchEngineType = 'bing' }
                            experienceBlockDeviceDiscovery                        = $true
                            experienceBlockErrorDialogWhenNoSIM                   = $true
                            experienceBlockTaskSwitcher                           = $true
                            logonBlockFastUserSwitching                           = $true
                            tenantLockdownRequireNetworkDuringOutOfBoxExperience  = $true
                            enterpriseCloudPrintDiscoveryEndPoint                 = 'https://cloudprinterdiscovery.contoso.com'
                            enterpriseCloudPrintDiscoveryMaxLimit                 = 4
                            enterpriseCloudPrintMopriaDiscoveryResourceIdentifier = 'http://mopriadiscoveryservice/cloudprint'
                            enterpriseCloudPrintOAuthClientIdentifier             = '30fbf7e8-321c-40ce-8b9f-160b6b049257'
                            enterpriseCloudPrintOAuthAuthority                    = 'https:/tenant.contoso.com/adfs'
                            enterpriseCloudPrintResourceIdentifier                = 'http://cloudenterpriseprint/cloudPrint'
                            networkProxyServer                                    = @('address=proxy.contoso.com:8080', "exceptions=*.contoso.com`r`n*.internal.local", 'useForLocalAddresses=false')
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
                    DisplayName = 'CONTOSO | W10 | Device Restriction'
                    Ensure      = 'Absent'
                    Credential  = $Credential
                }

                Mock -CommandName Get-MgDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        id                                                    = '12345-12345-12345-12345-12345'
                        AdditionalProperties                                  = @{'@odata.type' = '#microsoft.graph.windows10GeneralConfiguration' }
                        displayName                                           = 'CONTOSO | W10 | Device Restriction'
                        description                                           = 'Default device restriction settings'
                        defenderBlockEndUserAccess                            = $true
                        defenderRequireRealTimeMonitoring                     = $true
                        defenderRequireBehaviorMonitoring                     = $true
                        defenderRequireNetworkInspectionSystem                = $true
                        defenderScanDownloads                                 = $true
                        defenderScanScriptsLoadedInInternetExplorer           = $true
                        defenderSignatureUpdateIntervalInHours                = 8
                        defenderMonitorFileActivity                           = 'monitorIncomingFilesOnly'  # userDefined,monitorAllFiles,monitorIncomingFilesOnly,monitorOutgoingFilesOnly
                        defenderDaysBeforeDeletingQuarantinedMalware          = 3
                        defenderScanMaxCpu                                    = 2
                        defenderScanArchiveFiles                              = $true
                        defenderScanIncomingMail                              = $true
                        defenderScanRemovableDrivesDuringFullScan             = $true
                        defenderScanMappedNetworkDrivesDuringFullScan         = $false
                        defenderScanNetworkFiles                              = $false
                        defenderRequireCloudProtection                        = $true
                        defenderCloudBlockLevel                               = 'high'
                        defenderPromptForSampleSubmission                     = 'alwaysPrompt'
                        defenderScheduledQuickScanTime                        = '13:00:00.0000000'
                        defenderScanType                                      = 'quick'   #quick,full,userDefined
                        defenderSystemScanSchedule                            = 'monday'  #days of week
                        defenderScheduledScanTime                             = '11:00:00.0000000'
                        defenderDetectedMalwareActions                        = (New-CimInstance -ClassName MSFT_IntuneDefenderDetectedMalwareActions -Property @{
                                lowSeverity      = 'clean'
                                moderateSeverity = 'quarantine'
                                highSeverity     = 'remove'
                                severeSeverity   = 'block'
                            } -ClientOnly)
                        defenderFileExtensionsToExclude                       = "[`"csv,jpg,docx`"]"
                        defenderFilesAndFoldersToExclude                      = "[`"c:\\2,C:\\1`"]"
                        defenderProcessesToExclude                            = "[`"notepad.exe,c:\\Windows\\myprocess.exe`"]"
                        lockScreenAllowTimeoutConfiguration                   = $true
                        lockScreenBlockActionCenterNotifications              = $true
                        lockScreenBlockCortana                                = $true
                        lockScreenBlockToastNotifications                     = $false
                        lockScreenTimeoutInSeconds                            = 90
                        passwordBlockSimple                                   = $true
                        passwordExpirationDays                                = 6
                        passwordMinimumLength                                 = 5
                        passwordMinutesOfInactivityBeforeScreenTimeout        = 15
                        passwordMinimumCharacterSetCount                      = 1
                        passwordPreviousPasswordBlockCount                    = 2
                        passwordRequired                                      = $true
                        passwordRequireWhenResumeFromIdleState                = $true
                        passwordRequiredType                                  = 'alphanumeric'
                        passwordSignInFailureCountBeforeFactoryReset          = 12
                        privacyAdvertisingId                                  = 'blocked'
                        privacyAutoAcceptPairingAndConsentPrompts             = $true
                        privacyBlockInputPersonalization                      = $true
                        startBlockUnpinningAppsFromTaskbar                    = $true
                        startMenuAppListVisibility                            = 'collapse'
                        startMenuHideChangeAccountSettings                    = $true
                        startMenuHideFrequentlyUsedApps                       = $true
                        startMenuHideHibernate                                = $true
                        startMenuHideLock                                     = $true
                        startMenuHidePowerButton                              = $true
                        startMenuHideRecentJumpLists                          = $true
                        startMenuHideRecentlyAddedApps                        = $true
                        startMenuHideRestartOptions                           = $true
                        startMenuHideShutDown                                 = $true
                        startMenuHideSignOut                                  = $true
                        startMenuHideSleep                                    = $true
                        startMenuHideSwitchAccount                            = $true
                        startMenuHideUserTile                                 = $true
                        startMenuLayoutXml                                    = '+DQogICAGlmaWNhdGlvblRlbXBsYXRlPg=='
                        startMenuMode                                         = 'fullScreen'
                        startMenuPinnedFolderDocuments                        = 'hide'
                        startMenuPinnedFolderDownloads                        = 'hide'
                        startMenuPinnedFolderFileExplorer                     = 'hide'
                        startMenuPinnedFolderHomeGroup                        = 'hide'
                        startMenuPinnedFolderMusic                            = 'hide'
                        startMenuPinnedFolderNetwork                          = 'hide'
                        startMenuPinnedFolderPersonalFolder                   = 'hide'
                        startMenuPinnedFolderPictures                         = 'hide'
                        startMenuPinnedFolderSettings                         = 'hide'
                        startMenuPinnedFolderVideos                           = 'hide'
                        settingsBlockSettingsApp                              = $true
                        settingsBlockSystemPage                               = $true
                        settingsBlockDevicesPage                              = $true
                        settingsBlockNetworkInternetPage                      = $true
                        settingsBlockPersonalizationPage                      = $true
                        settingsBlockAccountsPage                             = $true
                        settingsBlockTimeLanguagePage                         = $true
                        settingsBlockEaseOfAccessPage                         = $true
                        settingsBlockPrivacyPage                              = $true
                        settingsBlockUpdateSecurityPage                       = $true
                        settingsBlockAppsPage                                 = $true
                        settingsBlockGamingPage                               = $true
                        windowsSpotlightBlockConsumerSpecificFeatures         = $true
                        windowsSpotlightBlocked                               = $true
                        windowsSpotlightBlockOnActionCenter                   = $true
                        windowsSpotlightBlockTailoredExperiences              = $true
                        windowsSpotlightBlockThirdPartyNotifications          = $true
                        windowsSpotlightBlockWelcomeExperience                = $true
                        windowsSpotlightBlockWindowsTips                      = $true
                        windowsSpotlightConfigureOnLockScreen                 = 'disabled'
                        networkProxyApplySettingsDeviceWide                   = $true
                        networkProxyDisableAutoDetect                         = $true
                        networkProxyAutomaticConfigurationUrl                 = 'https://example.com/networkProxyAutomaticConfigurationUrl/'
                        accountsBlockAddingNonMicrosoftAccountEmail           = $true
                        antiTheftModeBlocked                                  = $true
                        bluetoothBlocked                                      = $true
                        bluetoothAllowedServices                              = "[`"8e473eaa-ead4-4c60-ba9c-2c5696d71492`",`"21913f2d-a803-4f36-8039-669fd94ce5b3`"]"
                        bluetoothBlockAdvertising                             = $true
                        bluetoothBlockDiscoverableMode                        = $true
                        bluetoothBlockPrePairing                              = $true
                        cameraBlocked                                         = $true
                        connectedDevicesServiceBlocked                        = $true
                        certificatesBlockManualRootCertificateInstallation    = $true
                        copyPasteBlocked                                      = $true
                        cortanaBlocked                                        = $true
                        deviceManagementBlockFactoryResetOnMobile             = $true
                        deviceManagementBlockManualUnenroll                   = $true
                        safeSearchFilter                                      = 'strict'
                        edgeBlockPopups                                       = $true
                        edgeBlockSearchSuggestions                            = $true
                        edgeBlockSendingIntranetTrafficToInternetExplorer     = $true
                        edgeSendIntranetTrafficToInternetExplorer             = $true
                        edgeRequireSmartScreen                                = $true
                        edgeFirstRunUrl                                       = 'https://contoso.com/'
                        edgeBlockAccessToAboutFlags                           = $true
                        edgeHomepageUrls                                      = "[`"https://microsoft.com`"]"
                        smartScreenBlockPromptOverride                        = $true
                        smartScreenBlockPromptOverrideForFiles                = $true
                        webRtcBlockLocalhostIpAddress                         = $true
                        internetSharingBlocked                                = $true
                        settingsBlockAddProvisioningPackage                   = $true
                        settingsBlockRemoveProvisioningPackage                = $true
                        settingsBlockChangeSystemTime                         = $true
                        settingsBlockEditDeviceName                           = $true
                        settingsBlockChangeRegion                             = $true
                        settingsBlockChangeLanguage                           = $true
                        settingsBlockChangePowerSleep                         = $true
                        locationServicesBlocked                               = $true
                        microsoftAccountBlocked                               = $true
                        microsoftAccountBlockSettingsSync                     = $true
                        nfcBlocked                                            = $true
                        resetProtectionModeBlocked                            = $true
                        screenCaptureBlocked                                  = $true
                        storageBlockRemovableStorage                          = $true
                        storageRequireMobileDeviceEncryption                  = $true
                        usbBlocked                                            = $true
                        voiceRecordingBlocked                                 = $true
                        wiFiBlockAutomaticConnectHotspots                     = $true
                        wiFiBlocked                                           = $true
                        wiFiBlockManualConfiguration                          = $true
                        wiFiScanInterval                                      = 1
                        wirelessDisplayBlockProjectionToThisDevice            = $true
                        wirelessDisplayBlockUserInputFromReceiver             = $true
                        wirelessDisplayRequirePinForPairing                   = $true
                        windowsStoreBlocked                                   = $true
                        appsAllowTrustedAppsSideloading                       = 'blocked'
                        windowsStoreBlockAutoUpdate                           = $true
                        developerUnlockSetting                                = 'blocked'
                        sharedUserAppDataAllowed                              = $true
                        appsBlockWindowsStoreOriginatedApps                   = $true
                        windowsStoreEnablePrivateStoreOnly                    = $true
                        storageRestrictAppDataToSystemVolume                  = $true
                        storageRestrictAppInstallToSystemVolume               = $true
                        gameDvrBlocked                                        = $true
                        edgeSearchEngine                                      = @{edgeSearchEngineType = 'bing' }
                        experienceBlockDeviceDiscovery                        = $true
                        experienceBlockErrorDialogWhenNoSIM                   = $true
                        experienceBlockTaskSwitcher                           = $true
                        logonBlockFastUserSwitching                           = $true
                        tenantLockdownRequireNetworkDuringOutOfBoxExperience  = $true
                        enterpriseCloudPrintDiscoveryEndPoint                 = 'https://cloudprinterdiscovery.contoso.com'
                        enterpriseCloudPrintDiscoveryMaxLimit                 = 4
                        enterpriseCloudPrintMopriaDiscoveryResourceIdentifier = 'http://mopriadiscoveryservice/cloudprint'
                        enterpriseCloudPrintOAuthClientIdentifier             = '30fbf7e8-321c-40ce-8b9f-160b6b049257'
                        enterpriseCloudPrintOAuthAuthority                    = 'https:/tenant.contoso.com/adfs'
                        enterpriseCloudPrintResourceIdentifier                = 'http://cloudenterpriseprint/cloudPrint'
                        networkProxyServer                                    = @('address=proxy.contoso.com:8080', "exceptions=*.contoso.com`r`n*.internal.local", 'useForLocalAddresses=false')
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the policy from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgDeviceManagementDeviceConfiguration -Exactly 1
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
                        id                                                    = '12345-12345-12345-12345-12345'
                        AdditionalProperties                                  = @{
                            '@odata.type' = '#microsoft.graph.windows10GeneralConfiguration'
                        }
                        displayName                                           = 'CONTOSO | W10 | Device Restriction'
                        description                                           = 'Default device restriction settings'
                        defenderBlockEndUserAccess                            = $true
                        defenderRequireRealTimeMonitoring                     = $true
                        defenderRequireBehaviorMonitoring                     = $true
                        defenderRequireNetworkInspectionSystem                = $true
                        defenderScanDownloads                                 = $true
                        defenderScanScriptsLoadedInInternetExplorer           = $true
                        defenderSignatureUpdateIntervalInHours                = 8
                        defenderMonitorFileActivity                           = 'monitorIncomingFilesOnly'  # userDefined,monitorAllFiles,monitorIncomingFilesOnly,monitorOutgoingFilesOnly
                        defenderDaysBeforeDeletingQuarantinedMalware          = 3
                        defenderScanMaxCpu                                    = 2
                        defenderScanArchiveFiles                              = $true
                        defenderScanIncomingMail                              = $true
                        defenderScanRemovableDrivesDuringFullScan             = $true
                        defenderScanMappedNetworkDrivesDuringFullScan         = $false
                        defenderScanNetworkFiles                              = $false
                        defenderRequireCloudProtection                        = $true
                        defenderCloudBlockLevel                               = 'high'
                        defenderPromptForSampleSubmission                     = 'alwaysPrompt'
                        defenderScheduledQuickScanTime                        = '13:00:00.0000000'
                        defenderScanType                                      = 'quick'   #quick,full,userDefined
                        defenderSystemScanSchedule                            = 'monday'  #days of week
                        defenderScheduledScanTime                             = '11:00:00.0000000'
                        defenderDetectedMalwareActions                        = @{
                            lowSeverity      = 'clean'
                            moderateSeverity = 'quarantine'
                            highSeverity     = 'remove'
                            severeSeverity   = 'block'
                        }
                        defenderFileExtensionsToExclude                       = "[`"csv,jpg,docx`"]"
                        defenderFilesAndFoldersToExclude                      = "[`"c:\\2,C:\\1`"]"
                        defenderProcessesToExclude                            = "[`"notepad.exe,c:\\Windows\\myprocess.exe`"]"
                        lockScreenAllowTimeoutConfiguration                   = $true
                        lockScreenBlockActionCenterNotifications              = $true
                        lockScreenBlockCortana                                = $true
                        lockScreenBlockToastNotifications                     = $false
                        lockScreenTimeoutInSeconds                            = 90
                        passwordBlockSimple                                   = $true
                        passwordExpirationDays                                = 6
                        passwordMinimumLength                                 = 5
                        passwordMinutesOfInactivityBeforeScreenTimeout        = 15
                        passwordMinimumCharacterSetCount                      = 1
                        passwordPreviousPasswordBlockCount                    = 2
                        passwordRequired                                      = $true
                        passwordRequireWhenResumeFromIdleState                = $true
                        passwordRequiredType                                  = 'alphanumeric'
                        passwordSignInFailureCountBeforeFactoryReset          = 12
                        privacyAdvertisingId                                  = 'blocked'
                        privacyAutoAcceptPairingAndConsentPrompts             = $true
                        privacyBlockInputPersonalization                      = $true
                        startBlockUnpinningAppsFromTaskbar                    = $true
                        startMenuAppListVisibility                            = 'collapse'
                        startMenuHideChangeAccountSettings                    = $true
                        startMenuHideFrequentlyUsedApps                       = $true
                        startMenuHideHibernate                                = $true
                        startMenuHideLock                                     = $true
                        startMenuHidePowerButton                              = $true
                        startMenuHideRecentJumpLists                          = $true
                        startMenuHideRecentlyAddedApps                        = $true
                        startMenuHideRestartOptions                           = $true
                        startMenuHideShutDown                                 = $true
                        startMenuHideSignOut                                  = $true
                        startMenuHideSleep                                    = $true
                        startMenuHideSwitchAccount                            = $true
                        startMenuHideUserTile                                 = $true
                        startMenuLayoutXml                                    = '+DQogICAGlmaWNhdGlvblRlbXBsYXRlPg=='
                        startMenuMode                                         = 'fullScreen'
                        startMenuPinnedFolderDocuments                        = 'hide'
                        startMenuPinnedFolderDownloads                        = 'hide'
                        startMenuPinnedFolderFileExplorer                     = 'hide'
                        startMenuPinnedFolderHomeGroup                        = 'hide'
                        startMenuPinnedFolderMusic                            = 'hide'
                        startMenuPinnedFolderNetwork                          = 'hide'
                        startMenuPinnedFolderPersonalFolder                   = 'hide'
                        startMenuPinnedFolderPictures                         = 'hide'
                        startMenuPinnedFolderSettings                         = 'hide'
                        startMenuPinnedFolderVideos                           = 'hide'
                        settingsBlockSettingsApp                              = $true
                        settingsBlockSystemPage                               = $true
                        settingsBlockDevicesPage                              = $true
                        settingsBlockNetworkInternetPage                      = $true
                        settingsBlockPersonalizationPage                      = $true
                        settingsBlockAccountsPage                             = $true
                        settingsBlockTimeLanguagePage                         = $true
                        settingsBlockEaseOfAccessPage                         = $true
                        settingsBlockPrivacyPage                              = $true
                        settingsBlockUpdateSecurityPage                       = $true
                        settingsBlockAppsPage                                 = $true
                        settingsBlockGamingPage                               = $true
                        windowsSpotlightBlockConsumerSpecificFeatures         = $true
                        windowsSpotlightBlocked                               = $true
                        windowsSpotlightBlockOnActionCenter                   = $true
                        windowsSpotlightBlockTailoredExperiences              = $true
                        windowsSpotlightBlockThirdPartyNotifications          = $true
                        windowsSpotlightBlockWelcomeExperience                = $true
                        windowsSpotlightBlockWindowsTips                      = $true
                        windowsSpotlightConfigureOnLockScreen                 = 'disabled'
                        networkProxyApplySettingsDeviceWide                   = $true
                        networkProxyDisableAutoDetect                         = $true
                        networkProxyAutomaticConfigurationUrl                 = 'https://example.com/networkProxyAutomaticConfigurationUrl/'
                        accountsBlockAddingNonMicrosoftAccountEmail           = $true
                        antiTheftModeBlocked                                  = $true
                        bluetoothBlocked                                      = $true
                        bluetoothAllowedServices                              = "[`"8e473eaa-ead4-4c60-ba9c-2c5696d71492`",`"21913f2d-a803-4f36-8039-669fd94ce5b3`"]"
                        bluetoothBlockAdvertising                             = $true
                        bluetoothBlockDiscoverableMode                        = $true
                        bluetoothBlockPrePairing                              = $true
                        cameraBlocked                                         = $true
                        connectedDevicesServiceBlocked                        = $true
                        certificatesBlockManualRootCertificateInstallation    = $true
                        copyPasteBlocked                                      = $true
                        cortanaBlocked                                        = $true
                        deviceManagementBlockFactoryResetOnMobile             = $true
                        deviceManagementBlockManualUnenroll                   = $true
                        safeSearchFilter                                      = 'strict'
                        edgeBlockPopups                                       = $true
                        edgeBlockSearchSuggestions                            = $true
                        edgeBlockSendingIntranetTrafficToInternetExplorer     = $true
                        edgeSendIntranetTrafficToInternetExplorer             = $true
                        edgeRequireSmartScreen                                = $true
                        edgeFirstRunUrl                                       = 'https://contoso.com/'
                        edgeBlockAccessToAboutFlags                           = $true
                        edgeHomepageUrls                                      = "[`"https://microsoft.com`"]"
                        smartScreenBlockPromptOverride                        = $true
                        smartScreenBlockPromptOverrideForFiles                = $true
                        webRtcBlockLocalhostIpAddress                         = $true
                        internetSharingBlocked                                = $true
                        settingsBlockAddProvisioningPackage                   = $true
                        settingsBlockRemoveProvisioningPackage                = $true
                        settingsBlockChangeSystemTime                         = $true
                        settingsBlockEditDeviceName                           = $true
                        settingsBlockChangeRegion                             = $true
                        settingsBlockChangeLanguage                           = $true
                        settingsBlockChangePowerSleep                         = $true
                        locationServicesBlocked                               = $true
                        microsoftAccountBlocked                               = $true
                        microsoftAccountBlockSettingsSync                     = $true
                        nfcBlocked                                            = $true
                        resetProtectionModeBlocked                            = $true
                        screenCaptureBlocked                                  = $true
                        storageBlockRemovableStorage                          = $true
                        storageRequireMobileDeviceEncryption                  = $true
                        usbBlocked                                            = $true
                        voiceRecordingBlocked                                 = $true
                        wiFiBlockAutomaticConnectHotspots                     = $true
                        wiFiBlocked                                           = $true
                        wiFiBlockManualConfiguration                          = $true
                        wiFiScanInterval                                      = 1
                        wirelessDisplayBlockProjectionToThisDevice            = $true
                        wirelessDisplayBlockUserInputFromReceiver             = $true
                        wirelessDisplayRequirePinForPairing                   = $true
                        windowsStoreBlocked                                   = $true
                        appsAllowTrustedAppsSideloading                       = 'blocked'
                        windowsStoreBlockAutoUpdate                           = $true
                        developerUnlockSetting                                = 'blocked'
                        sharedUserAppDataAllowed                              = $true
                        appsBlockWindowsStoreOriginatedApps                   = $true
                        windowsStoreEnablePrivateStoreOnly                    = $true
                        storageRestrictAppDataToSystemVolume                  = $true
                        storageRestrictAppInstallToSystemVolume               = $true
                        gameDvrBlocked                                        = $true
                        edgeSearchEngine                                      = @{edgeSearchEngineType = 'bing' }
                        experienceBlockDeviceDiscovery                        = $true
                        experienceBlockErrorDialogWhenNoSIM                   = $true
                        experienceBlockTaskSwitcher                           = $true
                        logonBlockFastUserSwitching                           = $true
                        tenantLockdownRequireNetworkDuringOutOfBoxExperience  = $true
                        enterpriseCloudPrintDiscoveryEndPoint                 = 'https://cloudprinterdiscovery.contoso.com'
                        enterpriseCloudPrintDiscoveryMaxLimit                 = 4
                        enterpriseCloudPrintMopriaDiscoveryResourceIdentifier = 'http://mopriadiscoveryservice/cloudprint'
                        enterpriseCloudPrintOAuthClientIdentifier             = '30fbf7e8-321c-40ce-8b9f-160b6b049257'
                        enterpriseCloudPrintOAuthAuthority                    = 'https:/tenant.contoso.com/adfs'
                        enterpriseCloudPrintResourceIdentifier                = 'http://cloudenterpriseprint/cloudPrint'
                        networkProxyServer                                    = @('address=proxy.contoso.com:8080', "exceptions=*.contoso.com`r`n*.internal.local", 'useForLocalAddresses=false')
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
