<#
This example creates a new General Device Configuration Policy for Windows .
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceConfigurationPolicyWindows10 'ConfigureDeviceConfigurationPolicyWindows10'
        {
            displayName                                           = "CONTOSO | W10 | Device Restriction"
            description                                           = "Default device restriction settings"
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
            defenderDetectedMalwareActions                        = @("lowSeverity=clean", "moderateSeverity=quarantine", "highSeverity=remove", "severeSeverity=block")
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
            passwordRequiredType                                  = "alphanumeric"
            passwordSignInFailureCountBeforeFactoryReset          = 12
            privacyAdvertisingId                                  = "blocked"
            privacyAutoAcceptPairingAndConsentPrompts             = $true
            privacyBlockInputPersonalization                      = $true
            startBlockUnpinningAppsFromTaskbar                    = $true
            startMenuAppListVisibility                            = "collapse"
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
            startMenuLayoutXml                                    = "+DQogICAGlmaWNhdGlvblRlbXBsYXRlPg=="
            startMenuMode                                         = "fullScreen"
            startMenuPinnedFolderDocuments                        = "hide"
            startMenuPinnedFolderDownloads                        = "hide"
            startMenuPinnedFolderFileExplorer                     = "hide"
            startMenuPinnedFolderHomeGroup                        = "hide"
            startMenuPinnedFolderMusic                            = "hide"
            startMenuPinnedFolderNetwork                          = "hide"
            startMenuPinnedFolderPersonalFolder                   = "hide"
            startMenuPinnedFolderPictures                         = "hide"
            startMenuPinnedFolderSettings                         = "hide"
            startMenuPinnedFolderVideos                           = "hide"
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
            windowsSpotlightConfigureOnLockScreen                 = "disabled"
            networkProxyApplySettingsDeviceWide                   = $true
            networkProxyDisableAutoDetect                         = $true
            networkProxyAutomaticConfigurationUrl                 = "https://example.com/networkProxyAutomaticConfigurationUrl/"
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
            safeSearchFilter                                      = "strict"
            edgeBlockPopups                                       = $true
            edgeBlockSearchSuggestions                            = $true
            edgeBlockSendingIntranetTrafficToInternetExplorer     = $true
            edgeSendIntranetTrafficToInternetExplorer             = $true
            edgeRequireSmartScreen                                = $true
            edgeFirstRunUrl                                       = "https://contoso.com/"
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
            appsAllowTrustedAppsSideloading                       = "blocked"
            windowsStoreBlockAutoUpdate                           = $true
            developerUnlockSetting                                = "blocked"
            sharedUserAppDataAllowed                              = $true
            appsBlockWindowsStoreOriginatedApps                   = $true
            windowsStoreEnablePrivateStoreOnly                    = $true
            storageRestrictAppDataToSystemVolume                  = $true
            storageRestrictAppInstallToSystemVolume               = $true
            gameDvrBlocked                                        = $true
            edgeSearchEngine                                      = "bing"
            #edgeSearchEngine                                     = "https://go.microsoft.com/fwlink/?linkid=842596"  #'Google'
            experienceBlockDeviceDiscovery                        = $true
            experienceBlockErrorDialogWhenNoSIM                   = $true
            experienceBlockTaskSwitcher                           = $true
            logonBlockFastUserSwitching                           = $true
            tenantLockdownRequireNetworkDuringOutOfBoxExperience  = $true
            enterpriseCloudPrintDiscoveryEndPoint                 = "https://cloudprinterdiscovery.contoso.com"
            enterpriseCloudPrintDiscoveryMaxLimit                 = 4
            enterpriseCloudPrintMopriaDiscoveryResourceIdentifier = "http://mopriadiscoveryservice/cloudprint"
            enterpriseCloudPrintOAuthClientIdentifier             = "30fbf7e8-321c-40ce-8b9f-160b6b049257"
            enterpriseCloudPrintOAuthAuthority                    = "https:/tenant.contoso.com/adfs"
            enterpriseCloudPrintResourceIdentifier                = "http://cloudenterpriseprint/cloudPrint"
            networkProxyServer                                    = @("address=proxy.contoso.com:8080", "exceptions=*.contoso.com`r`n*.internal.local", "useForLocalAddresses=false")
            Ensure                                                = 'Present'
            Credential                                            = $credsGlobalAdmin
        }
    }
}
