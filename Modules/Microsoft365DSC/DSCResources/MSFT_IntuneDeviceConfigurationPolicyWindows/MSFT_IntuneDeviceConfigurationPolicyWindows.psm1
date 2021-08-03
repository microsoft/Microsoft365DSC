function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $enterpriseCloudPrintDiscoveryEndPoint,

        [Parameter()]
        [System.String]
        $enterpriseCloudPrintOAuthAuthority,

        [Parameter()]
        [System.String]
        $enterpriseCloudPrintOAuthClientIdentifier,

        [Parameter()]
        [System.Integer]
        $enterpriseCloudPrintDiscoveryMaxLimit,

        [Parameter()]
        [System.String]
        $enterpriseCloudPrintMopriaDiscoveryResourceIdentifier,

        [Parameter()]
        [System.Boolean]
        $searchBlockDiacritics,

        [Parameter()]
        [System.Boolean]
        $searchDisableIndexingEncryptedItems,

        [Parameter()]
        [System.Boolean]
        $searchEnableRemoteQueries,

        [Parameter()]
        [System.String]
        $searchDisableIndexerBackoff,

        [Parameter()]
        [System.Boolean]
        $searchDisableIndexingRemovableDrive,

        [Parameter()]
        [System.Boolean]
        $searchEnableAutomaticIndexSizeManangement,

        [Parameter()]
        [System.String]
        $diagnosticsDataSubmissionMode= 'none',

        [Parameter()]
        [System.Boolean]
        $oneDriveDisableFileSync,

        [Parameter()]
        [System.Boolean]
        $smartScreenEnableAppInstallControl,

        [Parameter()]
        [System.String]
        $personalizationDesktopImageUrl,

        [Parameter()]
        [System.String]
        $personalizationLockScreenImageUrl,

        [Parameter()]
        #[System.String]
        $bluetoothAllowedServices,

        [Parameter()]
        [System.Boolean]
        $bluetoothBlockAdvertising,

        [Parameter()]
        [System.Boolean]
        $bluetoothBlockDiscoverableMode,

        [Parameter()]
        [System.Boolean]
        $bluetoothBlockPrePairing,

        [Parameter()]
        [System.Boolean]
        $edgeBlockAutofill,

        [Parameter()]
        [System.Boolean]
        $edgeBlocked,

        [Parameter()]
        [System.Boolean]
        $edgeCookiePolicy,

        [Parameter()]
        [System.String[]]
        $edgeBlockDeveloperTools,

        [Parameter()]
        [System.Boolean]
        $edgeBlockSendingDoNotTrackHeader,

        [Parameter()]
        [System.Boolean]
        $edgeBlockExtensions,

        [Parameter()]
        [System.Boolean]
        $edgeBlockInPrivateBrowsing,

        [Parameter()]
        [System.Boolean]
        $edgeBlockJavaScript,

        [Parameter()]
        [System.Boolean]
        $edgeBlockPasswordManager,

        [Parameter()]
        [System.Boolean]
        $edgeBlockAddressBarDropdown,

        [Parameter()]
        [System.Boolean]
        $edgeBlockCompatibilityList,

        [Parameter()]
        [System.Boolean]
        $edgeClearBrowsingDataOnExit,

        [Parameter()]
        [System.Boolean]
        $edgeAllowStartPagesModification,

        [Parameter()]
        [System.Boolean]
        $DocumentsBlockUnmanagedDocumentsInManagedApps,

        [Parameter()]
        [System.String[]]
        $edgeDisableFirstRunPage,

        [Parameter()]
        [System.Boolean]
        $edgeBlockLiveTileDataCollection,

        [Parameter()]
        [System.Boolean]
        $edgeSyncFavoritesWithInternetExplorer,

        [Parameter()]
        [System.Boolean]
        $cellularBlockDataWhenRoaming,

        [Parameter()]
        [System.Boolean]
        $cellularBlockVpn,

        [Parameter()]
        [System.Boolean]
        $cellularBlockVpnWhenRoaming,

        [Parameter()]
        [System.Boolean]
        $defenderRequireRealTimeMonitoring,

        [Parameter()]
        [System.Boolean]
        $defenderRequireBehaviorMonitoring,

        [Parameter()]
        [System.Boolean]
        $defenderRequireNetworkInspectionSystem,

        [Parameter()]
        [System.Boolean]
        $defenderScanDownloads,

        [Parameter()]
        [System.Boolean]
        $defenderScanScriptsLoadedInInternetExplorer,

        [Parameter()]
        [System.Boolean]
        $defenderBlockEndUserAccess,

        [Parameter()]
        [System.Uint64]
        $defenderSignatureUpdateIntervalInHours,

        [Parameter()]
        [System.String]
        $defenderMonitorFileActivity,

        [Parameter()]
        [System.Uint64]
        $defenderDaysBeforeDeletingQuarantinedMalware,

        [Parameter()]
        [System.Uint64]
        $defenderScanMaxCpu,

        [Parameter()]
        [System.Boolean]
        $defenderScanArchiveFiles,

        [Parameter()]
        [System.Boolean]
        $defenderScanIncomingMail,

        [Parameter()]
        [System.Boolean]
        $defenderScanRemovableDrivesDuringFullScan,

        [Parameter()]
        [System.Boolean]
        $defenderScanMappedNetworkDrivesDuringFullScan,

        [Parameter()]
        [System.Boolean]
        $defenderScanNetworkFiles,

        [Parameter()]
        [System.Boolean]
        $defenderRequireCloudProtection,

        [Parameter()]
        [System.String]
        $defenderCloudBlockLevel,

        [Parameter()]
        [System.String]
        $defenderPromptForSampleSubmission,

        [Parameter()]
        [System.String]
        $defenderScheduledQuickScanTime,

        [Parameter()]
        [System.String]
        $defenderScanType,

        [Parameter()]
        [System.string]
        $defenderSystemScanSchedule,

        [Parameter()]
        [System.String]
        $defenderScheduledScanTime,

        [Parameter()]
        [System.String]
        $defenderFileExtensionsToExclude,

        [Parameter()]
        [System.String]
        $defenderFilesAndFoldersToExclude,

        [Parameter()]
        [System.String]
        $defenderProcessesToExclude,

        [Parameter()]
        [System.Boolean]
        $lockScreenAllowTimeoutConfiguration,

        [Parameter()]
        [System.Boolean]
        $lockScreenBlockActionCenterNotifications,

        [Parameter()]
        [System.Boolean]
        $lockScreenBlockCortana,

        [Parameter()]
        [System.Boolean]
        $lockScreenBlockToastNotifications,

        [Parameter()]
        [System.Uint64]
        $lockScreenTimeoutInSeconds,

        [Parameter()]
        [System.Boolean]
        $passwordBlockSimple,

        [Parameter()]
        [System.Uint64]
        $passwordExpirationDays,

        [Parameter()]
        [System.Uint64]
        $passwordMinimumLength,

        [Parameter()]
        [System.Uint64]
        $passwordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Uint64]
        $passwordMinimumCharacterSetCount,

        [Parameter()]
        [System.Uint64]
        $passwordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Boolean]
        $passwordRequired,

        [Parameter()]
        [System.Boolean]
        $passwordRequireWhenResumeFromIdleState,

        [Parameter()]
        [System.String]
        $passwordRequiredType,

        [Parameter()]
        [System.Uint64]
        $passwordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [System.String]
        $privacyAdvertisingId,

        [Parameter()]
        [System.Boolean]
        $privacyBlockInputPersonalization,

        [Parameter()]
        [System.String]
        $startBlockUnpinningAppsFromTaskbar,

        [Parameter()]
        [System.String]
        $startMenuAppListVisibility,

        [Parameter()]
        [System.String]
        $startMenuHideChangeAccountSettings,

        [Parameter()]
        [System.String]
        $startMenuHideFrequentlyUsedApps,

        [Parameter()]
        [System.String]
        $startMenuHideHibernate,

        [Parameter()]
        [System.String]
        $startMenuHideLock,

        [Parameter()]
        [System.String]
        $startMenuHidePowerButton,

        [Parameter()]
        [System.String]
        $startMenuHideRecentJumpLists,

        [Parameter()]
        [System.String]
        $startMenuHideRecentlyAddedApps,

        [Parameter()]
        [System.String]
        $startMenuHideRestartOptions,

        [Parameter()]
        [System.Boolean]
        $startMenuHideShutDown,

        [Parameter()]
        [System.Boolean]
        $startMenuHideSignOut,

        [Parameter()]
        [System.Boolean]
        $startMenuHideSleep,

        [Parameter()]
        [System.Boolean]
        $startMenuHideSwitchAccount,

        [Parameter()]
        [System.Boolean]
        $startMenuHideUserTile,

        [Parameter()]
        [System.String]
        $startMenuMode,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderDocuments,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderDownloads,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderFileExplorer,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderHomeGroup,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderMusic,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderNetwork,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderPersonalFolder,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderPictures,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderSettings,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderVideos,

        [Parameter()]
        [System.Boolean]
        $settingsBlockSettingsApp,

        [Parameter()]
        [System.Boolean]
        $settingsBlockDevicesPage,

        [Parameter()]
        [System.Boolean]
        $settingsBlockNetworkInternetPage,

        [Parameter()]
        [System.Boolean]
        $settingsBlockPersonalizationPage,

        [Parameter()]
        [System.Boolean]
        $settingsBlockAccountsPage,

        [Parameter()]
        [System.Boolean]
        $settingsBlockTimeLanguagePage,

        [Parameter()]
        [System.Boolean]
        $settingsBlockEaseOfAccessPage,

        [Parameter()]
        [System.Boolean]
        $settingsBlockPrivacyPage,

        [Parameter()]
        [System.Boolean]
        $settingsBlockUpdateSecurityPage,

        [Parameter()]
        [System.Boolean]
        $settingsBlockAppsPage,

        [Parameter()]
        [System.Boolean]
        $settingsBlockGamingPage,

        [Parameter()]
        [System.Boolean]
        $windowsSpotlightBlockConsumerSpecificFeatures,

        [Parameter()]
        [System.Boolean]
        $windowsSpotlightBlocked,

        [Parameter()]
        [System.Boolean]
        $windowsSpotlightBlockOnActionCenter,

        [Parameter()]
        [System.Boolean]
        $windowsSpotlightBlockTailoredExperiences,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $ApplicationSecret
    )

    Write-Verbose -Message "Checking for the Intune Device Configuration Policy {$DisplayName}"
    $ConnectionMode = New-M365DSCConnection -Workload 'Intune' `
        -InboundParameters $PSBoundParameters
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    $data.Add("ConnectionMode", $ConnectionMode)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'

    try
    {
        $policyInfo = Get-IntuneDeviceConfigurationPolicy -Filter "displayName eq '$DisplayName'" `
            -ErrorAction Stop | Where-Object -FilterScript { $_.'@odata.type' -eq '#microsoft.graph.windows10GeneralConfiguration' }

        if ($null -eq $policyInfo)
        {
            Write-Verbose -Message "No Device Configuration Policy {$DisplayName} was found"
            return $nullResult
        }

        $policy = Get-M365DSCIntuneDeviceConfigurationPolicyWindows -PolicyId $policyInfo.Id
        Write-Verbose -Message "Found Device Configuration Policy {$DisplayName}"
        return @{
            description                                           	= $policy.description                                           
            displayName                                           	= $policy.displayName                                           
            enterpriseCloudPrintDiscoveryEndPoint                 	= $policy.enterpriseCloudPrintDiscoveryEndPoint                 
            enterpriseCloudPrintOAuthAuthority                    	= $policy.enterpriseCloudPrintOAuthAuthority                    
            enterpriseCloudPrintOAuthClientIdentifier             	= $policy.enterpriseCloudPrintOAuthClientIdentifier             
            enterpriseCloudPrintResourceIdentifier                	= $policy.enterpriseCloudPrintResourceIdentifier                
            enterpriseCloudPrintDiscoveryMaxLimit                 	= $policy.enterpriseCloudPrintDiscoveryMaxLimit                 
            enterpriseCloudPrintMopriaDiscoveryResourceIdentifier 	= $policy.enterpriseCloudPrintMopriaDiscoveryResourceIdentifier 
            searchBlockDiacritics                                 	= $policy.searchBlockDiacritics                                 
            searchDisableAutoLanguageDetection                    	= $policy.searchDisableAutoLanguageDetection                    
            searchDisableIndexingEncryptedItems                   	= $policy.searchDisableIndexingEncryptedItems                   
            searchEnableRemoteQueries                             	= $policy.searchEnableRemoteQueries                             
            searchDisableIndexerBackoff                           	= $policy.searchDisableIndexerBackoff                           
            searchDisableIndexingRemovableDrive                   	= $policy.searchDisableIndexingRemovableDrive                   
            searchEnableAutomaticIndexSizeManangement             	= $policy.searchEnableAutomaticIndexSizeManangement             
            diagnosticsDataSubmissionMode                         	= $policy.diagnosticsDataSubmissionMode                         
            oneDriveDisableFileSync                               	= $policy.oneDriveDisableFileSync                               
            smartScreenEnableAppInstallControl                    	= $policy.smartScreenEnableAppInstallControl                    
            personalizationDesktopImageUrl                        	= $policy.personalizationDesktopImageUrl                        
            personalizationLockScreenImageUrl                     	= $policy.personalizationLockScreenImageUrl                     
            bluetoothAllowedServices                              	= $policy.bluetoothAllowedServices                              
            bluetoothBlockAdvertising                             	= $policy.bluetoothBlockAdvertising                             
            bluetoothBlockDiscoverableMode                        	= $policy.bluetoothBlockDiscoverableMode                        
            bluetoothBlockPrePairing                              	= $policy.bluetoothBlockPrePairing                              
            edgeBlockAutofill                                     	= $policy.edgeBlockAutofill                                     
            edgeBlocked                                           	= $policy.edgeBlocked                                           
            edgeCookiePolicy                                      	= $policy.edgeCookiePolicy                                      
            edgeBlockDeveloperTools                               	= $policy.edgeBlockDeveloperTools                               
            edgeBlockSendingDoNotTrackHeader                      	= $policy.edgeBlockSendingDoNotTrackHeader                      
            edgeBlockExtensions                                   	= $policy.edgeBlockExtensions                                   
            edgeBlockInPrivateBrowsing                            	= $policy.edgeBlockInPrivateBrowsing                            
            edgeBlockJavaScript                                   	= $policy.edgeBlockJavaScript                                   
            edgeBlockPasswordManager                              	= $policy.edgeBlockPasswordManager                              
            edgeBlockAddressBarDropdown                           	= $policy.edgeBlockAddressBarDropdown                           
            edgeBlockCompatibilityList                            	= $policy.edgeBlockCompatibilityList                            
            edgeClearBrowsingDataOnExit                           	= $policy.edgeClearBrowsingDataOnExit                           
            edgeAllowStartPagesModification                       	= $policy.edgeAllowStartPagesModification                       
            edgeDisableFirstRunPage                               	= $policy.edgeDisableFirstRunPage                               
            edgeBlockLiveTileDataCollection                       	= $policy.edgeBlockLiveTileDataCollection                       
            edgeSyncFavoritesWithInternetExplorer                 	= $policy.edgeSyncFavoritesWithInternetExplorer                 
            cellularBlockDataWhenRoaming                          	= $policy.cellularBlockDataWhenRoaming                          
            cellularBlockVpn                                      	= $policy.cellularBlockVpn                                      
            cellularBlockVpnWhenRoaming                           	= $policy.cellularBlockVpnWhenRoaming                           
            defenderRequireRealTimeMonitoring                     	= $policy.defenderRequireRealTimeMonitoring                     
            defenderRequireBehaviorMonitoring                     	= $policy.defenderRequireBehaviorMonitoring                     
            defenderRequireNetworkInspectionSystem                	= $policy.defenderRequireNetworkInspectionSystem                
            defenderScanDownloads                                 	= $policy.defenderScanDownloads                                 
            defenderScanScriptsLoadedInInternetExplorer           	= $policy.defenderScanScriptsLoadedInInternetExplorer           
            defenderBlockEndUserAccess                            	= $policy.defenderBlockEndUserAccess                            
            defenderSignatureUpdateIntervalInHours                	= $policy.defenderSignatureUpdateIntervalInHours                
            defenderMonitorFileActivity                           	= $policy.defenderMonitorFileActivity                           
            defenderDaysBeforeDeletingQuarantinedMalware          	= $policy.defenderDaysBeforeDeletingQuarantinedMalware          
            defenderScanMaxCpu                                    	= $policy.defenderScanMaxCpu                                    
            defenderScanArchiveFiles                              	= $policy.defenderScanArchiveFiles                              
            defenderScanIncomingMail                              	= $policy.defenderScanIncomingMail                              
            defenderScanRemovableDrivesDuringFullScan             	= $policy.defenderScanRemovableDrivesDuringFullScan             
            defenderScanMappedNetworkDrivesDuringFullScan         	= $policy.defenderScanMappedNetworkDrivesDuringFullScan         
            defenderScanNetworkFiles                              	= $policy.defenderScanNetworkFiles                              
            defenderRequireCloudProtection                        	= $policy.defenderRequireCloudProtection                        
            defenderCloudBlockLevel                               	= $policy.defenderCloudBlockLevel                               
            defenderPromptForSampleSubmission                     	= $policy.defenderPromptForSampleSubmission                     
            defenderScheduledQuickScanTime                        	= $policy.defenderScheduledQuickScanTime                        
            defenderScanType                                      	= $policy.defenderScanType                                      
            defenderSystemScanSchedule                            	= $policy.defenderSystemScanSchedule                            
            defenderScheduledScanTime                             	= $policy.defenderScheduledScanTime                             
            defenderDetectedMalwareActions                        	= $policy.defenderDetectedMalwareActions                        
            defenderFileExtensionsToExclude                       	= $policy.defenderFileExtensionsToExclude                       
            defenderFilesAndFoldersToExclude                      	= $policy.defenderFilesAndFoldersToExclude                      
            defenderProcessesToExclude                            	= $policy.defenderProcessesToExclude                            
            lockScreenAllowTimeoutConfiguration                   	= $policy.lockScreenAllowTimeoutConfiguration                   
            lockScreenBlockActionCenterNotifications              	= $policy.lockScreenBlockActionCenterNotifications              
            lockScreenBlockCortana                                	= $policy.lockScreenBlockCortana                                
            lockScreenBlockToastNotifications                     	= $policy.lockScreenBlockToastNotifications                     
            lockScreenTimeoutInSeconds                            	= $policy.lockScreenTimeoutInSeconds                            
            passwordBlockSimple                                   	= $policy.passwordBlockSimple                                   
            passwordExpirationDays                                	= $policy.passwordExpirationDays                                
            passwordMinimumLength                                 	= $policy.passwordMinimumLength                                 
            passwordMinutesOfInactivityBeforeScreenTimeout        	= $policy.passwordMinutesOfInactivityBeforeScreenTimeout        
            passwordMinimumCharacterSetCount                      	= $policy.passwordMinimumCharacterSetCount                      
            passwordPreviousPasswordBlockCount                    	= $policy.passwordPreviousPasswordBlockCount                    
            passwordRequired                                      	= $policy.passwordRequired                                      
            passwordRequireWhenResumeFromIdleState                	= $policy.passwordRequireWhenResumeFromIdleState                
            passwordRequiredType                                  	= $policy.passwordRequiredType                                  
            passwordSignInFailureCountBeforeFactoryReset          	= $policy.passwordSignInFailureCountBeforeFactoryReset          
            privacyAdvertisingId                                  	= $policy.privacyAdvertisingId                                  
            privacyAutoAcceptPairingAndConsentPrompts             	= $policy.privacyAutoAcceptPairingAndConsentPrompts             
            privacyBlockInputPersonalization                      	= $policy.privacyBlockInputPersonalization                      
            startBlockUnpinningAppsFromTaskbar                    	= $policy.startBlockUnpinningAppsFromTaskbar                    
            startMenuAppListVisibility                            	= $policy.startMenuAppListVisibility                            
            startMenuHideChangeAccountSettings                    	= $policy.startMenuHideChangeAccountSettings                    
            startMenuHideFrequentlyUsedApps                       	= $policy.startMenuHideFrequentlyUsedApps                       
            startMenuHideHibernate                                	= $policy.startMenuHideHibernate                                
            startMenuHideLock                                     	= $policy.startMenuHideLock                                     
            startMenuHidePowerButton                              	= $policy.startMenuHidePowerButton                              
            startMenuHideRecentJumpLists                          	= $policy.startMenuHideRecentJumpLists                          
            startMenuHideRecentlyAddedApps                        	= $policy.startMenuHideRecentlyAddedApps                        
            startMenuHideRestartOptions                           	= $policy.startMenuHideRestartOptions                           
            startMenuHideShutDown                                 	= $policy.startMenuHideShutDown                                 
            startMenuHideSignOut                                  	= $policy.startMenuHideSignOut                                  
            startMenuHideSleep                                    	= $policy.startMenuHideSleep                                    
            startMenuHideSwitchAccount                            	= $policy.startMenuHideSwitchAccount                            
            startMenuHideUserTile                                 	= $policy.startMenuHideUserTile                                 
            startMenuLayoutEdgeAssetsXml                          	= $policy.startMenuLayoutEdgeAssetsXml                          
            startMenuLayoutXml                                    	= $policy.startMenuLayoutXml                                    
            startMenuMode                                         	= $policy.startMenuMode                                         
            startMenuPinnedFolderDocuments                        	= $policy.startMenuPinnedFolderDocuments                        
            startMenuPinnedFolderDownloads                        	= $policy.startMenuPinnedFolderDownloads                        
            startMenuPinnedFolderFileExplorer                     	= $policy.startMenuPinnedFolderFileExplorer                     
            startMenuPinnedFolderHomeGroup                        	= $policy.startMenuPinnedFolderHomeGroup                        
            startMenuPinnedFolderMusic                            	= $policy.startMenuPinnedFolderMusic                            
            startMenuPinnedFolderNetwork                          	= $policy.startMenuPinnedFolderNetwork                          
            startMenuPinnedFolderPersonalFolder                   	= $policy.startMenuPinnedFolderPersonalFolder                   
            startMenuPinnedFolderPictures                         	= $policy.startMenuPinnedFolderPictures                         
            startMenuPinnedFolderSettings                         	= $policy.startMenuPinnedFolderSettings                         
            startMenuPinnedFolderVideos                           	= $policy.startMenuPinnedFolderVideos                           
            settingsBlockSettingsApp                              	= $policy.settingsBlockSettingsApp                              
            settingsBlockSystemPage                               	= $policy.settingsBlockSystemPage                               
            settingsBlockDevicesPage                              	= $policy.settingsBlockDevicesPage                              
            settingsBlockNetworkInternetPage                      	= $policy.settingsBlockNetworkInternetPage                      
            settingsBlockPersonalizationPage                      	= $policy.settingsBlockPersonalizationPage                      
            settingsBlockAccountsPage                             	= $policy.settingsBlockAccountsPage                             
            settingsBlockTimeLanguagePage                         	= $policy.settingsBlockTimeLanguagePage                         
            settingsBlockEaseOfAccessPage                         	= $policy.settingsBlockEaseOfAccessPage                         
            settingsBlockPrivacyPage                              	= $policy.settingsBlockPrivacyPage                              
            settingsBlockUpdateSecurityPage                       	= $policy.settingsBlockUpdateSecurityPage                       
            settingsBlockAppsPage                                 	= $policy.settingsBlockAppsPage                                 
            settingsBlockGamingPage                               	= $policy.settingsBlockGamingPage                               
            windowsSpotlightBlockConsumerSpecificFeatures         	= $policy.windowsSpotlightBlockConsumerSpecificFeatures         
            windowsSpotlightBlocked                               	= $policy.windowsSpotlightBlocked                               
            windowsSpotlightBlockOnActionCenter                   	= $policy.windowsSpotlightBlockOnActionCenter                   
            windowsSpotlightBlockTailoredExperiences              	= $policy.windowsSpotlightBlockTailoredExperiences              
            windowsSpotlightBlockThirdPartyNotifications          	= $policy.windowsSpotlightBlockThirdPartyNotifications          
            windowsSpotlightBlockWelcomeExperience                	= $policy.windowsSpotlightBlockWelcomeExperience                
            windowsSpotlightBlockWindowsTips                      	= $policy.windowsSpotlightBlockWindowsTips                      
            windowsSpotlightConfigureOnLockScreen                 	= $policy.windowsSpotlightConfigureOnLockScreen                 
            networkProxyApplySettingsDeviceWide                   	= $policy.networkProxyApplySettingsDeviceWide                   
            networkProxyDisableAutoDetect                         	= $policy.networkProxyDisableAutoDetect                         
            networkProxyAutomaticConfigurationUrl                 	= $policy.networkProxyAutomaticConfigurationUrl                 
            networkProxyServer                                    	= $policy.networkProxyServer                                    
            accountsBlockAddingNonMicrosoftAccountEmail           	= $policy.accountsBlockAddingNonMicrosoftAccountEmail           
            antiTheftModeBlocked                                  	= $policy.antiTheftModeBlocked                                  
            bluetoothBlocked                                      	= $policy.bluetoothBlocked                                      
            cameraBlocked                                         	= $policy.cameraBlocked                                         
            connectedDevicesServiceBlocked                        	= $policy.connectedDevicesServiceBlocked                        
            certificatesBlockManualRootCertificateInstallation    	= $policy.certificatesBlockManualRootCertificateInstallation    
            copyPasteBlocked                                      	= $policy.copyPasteBlocked                                      
            cortanaBlocked                                        	= $policy.cortanaBlocked                                        
            deviceManagementBlockFactoryResetOnMobile             	= $policy.deviceManagementBlockFactoryResetOnMobile             
            deviceManagementBlockManualUnenroll                   	= $policy.deviceManagementBlockManualUnenroll                   
            safeSearchFilter                                      	= $policy.safeSearchFilter                                      
            edgeBlockPopups                                       	= $policy.edgeBlockPopups                                       
            edgeBlockSearchSuggestions                            	= $policy.edgeBlockSearchSuggestions                            
            edgeBlockSendingIntranetTrafficToInternetExplorer     	= $policy.edgeBlockSendingIntranetTrafficToInternetExplorer     
            edgeSendIntranetTrafficToInternetExplorer             	= $policy.edgeSendIntranetTrafficToInternetExplorer             
            edgeRequireSmartScreen                                	= $policy.edgeRequireSmartScreen                                
            edgeEnterpriseModeSiteListLocation                    	= $policy.edgeEnterpriseModeSiteListLocation                    
            edgeFirstRunUrl                                       	= $policy.edgeFirstRunUrl                                       
            edgeSearchEngine                                      	= $policy.edgeSearchEngine                                      
            edgeHomepageUrls                                      	= $policy.edgeHomepageUrls                                      
            edgeBlockAccessToAboutFlags                           	= $policy.edgeBlockAccessToAboutFlags                           
            smartScreenBlockPromptOverride                        	= $policy.smartScreenBlockPromptOverride                        
            smartScreenBlockPromptOverrideForFiles                	= $policy.smartScreenBlockPromptOverrideForFiles                
            webRtcBlockLocalhostIpAddress                         	= $policy.webRtcBlockLocalhostIpAddress                         
            internetSharingBlocked                                	= $policy.internetSharingBlocked                                
            settingsBlockAddProvisioningPackage                   	= $policy.settingsBlockAddProvisioningPackage                   
            settingsBlockRemoveProvisioningPackage                	= $policy.settingsBlockRemoveProvisioningPackage                
            settingsBlockChangeSystemTime                         	= $policy.settingsBlockChangeSystemTime                         
            settingsBlockEditDeviceName                           	= $policy.settingsBlockEditDeviceName                           
            settingsBlockChangeRegion                             	= $policy.settingsBlockChangeRegion                             
            settingsBlockChangeLanguage                           	= $policy.settingsBlockChangeLanguage                           
            settingsBlockChangePowerSleep                         	= $policy.settingsBlockChangePowerSleep                         
            locationServicesBlocked                               	= $policy.locationServicesBlocked                               
            microsoftAccountBlocked                               	= $policy.microsoftAccountBlocked                               
            microsoftAccountBlockSettingsSync                     	= $policy.microsoftAccountBlockSettingsSync                     
            nfcBlocked                                            	= $policy.nfcBlocked                                            
            resetProtectionModeBlocked                            	= $policy.resetProtectionModeBlocked                            
            screenCaptureBlocked                                  	= $policy.screenCaptureBlocked                                  
            storageBlockRemovableStorage                          	= $policy.storageBlockRemovableStorage                          
            storageRequireMobileDeviceEncryption                  	= $policy.storageRequireMobileDeviceEncryption                  
            usbBlocked                                            	= $policy.usbBlocked                                            
            voiceRecordingBlocked                                 	= $policy.voiceRecordingBlocked                                 
            wiFiBlockAutomaticConnectHotspots                     	= $policy.wiFiBlockAutomaticConnectHotspots                     
            wiFiBlocked                                           	= $policy.wiFiBlocked                                           
            wiFiBlockManualConfiguration                          	= $policy.wiFiBlockManualConfiguration                          
            wiFiScanInterval                                      	= $policy.wiFiScanInterval                                      
            wirelessDisplayBlockProjectionToThisDevice            	= $policy.wirelessDisplayBlockProjectionToThisDevice            
            wirelessDisplayBlockUserInputFromReceiver             	= $policy.wirelessDisplayBlockUserInputFromReceiver             
            wirelessDisplayRequirePinForPairing                   	= $policy.wirelessDisplayRequirePinForPairing                   
            windowsStoreBlocked                                   	= $policy.windowsStoreBlocked                                   
            appsAllowTrustedAppsSideloading                       	= $policy.appsAllowTrustedAppsSideloading                       
            windowsStoreBlockAutoUpdate                           	= $policy.windowsStoreBlockAutoUpdate                           
            developerUnlockSetting                                	= $policy.developerUnlockSetting                                
            sharedUserAppDataAllowed                              	= $policy.sharedUserAppDataAllowed                              
            appsBlockWindowsStoreOriginatedApps                   	= $policy.appsBlockWindowsStoreOriginatedApps                   
            windowsStoreEnablePrivateStoreOnly                    	= $policy.windowsStoreEnablePrivateStoreOnly                    
            storageRestrictAppDataToSystemVolume                  	= $policy.storageRestrictAppDataToSystemVolume                  
            storageRestrictAppInstallToSystemVolume               	= $policy.storageRestrictAppInstallToSystemVolume               
            gameDvrBlocked                                        	= $policy.gameDvrBlocked                                        
            experienceBlockDeviceDiscovery                        	= $policy.experienceBlockDeviceDiscovery                        
            experienceBlockErrorDialogWhenNoSIM                   	= $policy.experienceBlockErrorDialogWhenNoSIM                   
            experienceBlockTaskSwitcher                           	= $policy.experienceBlockTaskSwitcher                           
            logonBlockFastUserSwitching                           	= $policy.logonBlockFastUserSwitching                           
            tenantLockdownRequireNetworkDuringOutOfBoxExperience  	= $policy.tenantLockdownRequireNetworkDuringOutOfBoxExperience  
            Ensure                                                  = "Present"
            GlobalAdminAccount                                      = $GlobalAdminAccount
            ApplicationId                                           = $ApplicationId
            TenantId                                                = $TenantId
            ApplicationSecret                                       = $ApplicationSecret
        }
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return $nullResult
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $enterpriseCloudPrintDiscoveryEndPoint,

        [Parameter()]
        [System.String]
        $enterpriseCloudPrintOAuthAuthority,

        [Parameter()]
        [System.String]
        $enterpriseCloudPrintOAuthClientIdentifier,

        [Parameter()]
        [System.Integer]
        $enterpriseCloudPrintDiscoveryMaxLimit,

        [Parameter()]
        [System.String]
        $enterpriseCloudPrintMopriaDiscoveryResourceIdentifier,

        [Parameter()]
        [System.Boolean]
        $searchBlockDiacritics,

        [Parameter()]
        [System.Boolean]
        $searchDisableIndexingEncryptedItems,

        [Parameter()]
        [System.Boolean]
        $searchEnableRemoteQueries,

        [Parameter()]
        [System.String]
        $searchDisableIndexerBackoff,

        [Parameter()]
        [System.Boolean]
        $searchDisableIndexingRemovableDrive,

        [Parameter()]
        [System.Boolean]
        $searchEnableAutomaticIndexSizeManangement,

        [Parameter()]
        [System.String]
        $diagnosticsDataSubmissionMode= 'none',

        [Parameter()]
        [System.Boolean]
        $oneDriveDisableFileSync,

        [Parameter()]
        [System.Boolean]
        $smartScreenEnableAppInstallControl,

        [Parameter()]
        [System.String]
        $personalizationDesktopImageUrl,

        [Parameter()]
        [System.String]
        $personalizationLockScreenImageUrl,

        [Parameter()]
        [System.String]
        $bluetoothAllowedServices,

        [Parameter()]
        [System.Boolean]
        $bluetoothBlockAdvertising,

        [Parameter()]
        [System.Boolean]
        $bluetoothBlockDiscoverableMode,

        [Parameter()]
        [System.Boolean]
        $bluetoothBlockPrePairing,

        [Parameter()]
        [System.Boolean]
        $edgeBlockAutofill,

        [Parameter()]
        [System.Boolean]
        $edgeBlocked,

        [Parameter()]
        [System.String]
        $edgeCookiePolicy,

        [Parameter()]
        [System.Boolean]
        $edgeBlockDeveloperTools,

        [Parameter()]
        [System.Boolean]
        $edgeBlockSendingDoNotTrackHeader,

        [Parameter()]
        [System.Boolean]
        $edgeBlockExtensions,

        [Parameter()]
        [System.Boolean]
        $edgeBlockInPrivateBrowsing,

        [Parameter()]
        [System.Boolean]
        $edgeBlockJavaScript,

        [Parameter()]
        [System.Boolean]
        $edgeBlockPasswordManager,

        [Parameter()]
        [System.Boolean]
        $edgeBlockAddressBarDropdown,

        [Parameter()]
        [System.Boolean]
        $edgeBlockCompatibilityList,

        [Parameter()]
        [System.Boolean]
        $edgeClearBrowsingDataOnExit,

        [Parameter()]
        [System.Boolean]
        $edgeAllowStartPagesModification,

        [Parameter()]
        [System.Boolean]
        $edgeDisableFirstRunPage,

        [Parameter()]
        [System.Boolean]
        $edgeBlockLiveTileDataCollection,

        [Parameter()]
        [System.Boolean]
        $edgeSyncFavoritesWithInternetExplorer,

        [Parameter()]
        [System.Boolean]
        $cellularBlockDataWhenRoaming,

        [Parameter()]
        [System.Boolean]
        $cellularBlockVpn,

        [Parameter()]
        [System.Boolean]
        $cellularBlockVpnWhenRoaming,

        [Parameter()]
        [System.Boolean]
        $defenderRequireRealTimeMonitoring,

        [Parameter()]
        [System.Boolean]
        $defenderRequireBehaviorMonitoring,

        [Parameter()]
        [System.Boolean]
        $defenderRequireNetworkInspectionSystem,

        [Parameter()]
        [System.Boolean]
        $defenderScanDownloads,

        [Parameter()]
        [System.Boolean]
        $defenderScanScriptsLoadedInInternetExplorer,

        [Parameter()]
        [System.Boolean]
        $defenderBlockEndUserAccess,

        [Parameter()]
        [System.Uint64]
        $defenderSignatureUpdateIntervalInHours,

        [Parameter()]
        [System.String]
        $defenderMonitorFileActivity,

        [Parameter()]
        [System.Uint64]
        $defenderDaysBeforeDeletingQuarantinedMalware,

        [Parameter()]
        [System.Uint64]
        $defenderScanMaxCpu,

        [Parameter()]
        [System.Boolean]
        $defenderScanArchiveFiles,

        [Parameter()]
        [System.Boolean]
        $defenderScanIncomingMail,

        [Parameter()]
        [System.Boolean]
        $defenderScanRemovableDrivesDuringFullScan,

        [Parameter()]
        [System.Boolean]
        $defenderScanMappedNetworkDrivesDuringFullScan,

        [Parameter()]
        [System.Boolean]
        $defenderScanNetworkFiles,

        [Parameter()]
        [System.Boolean]
        $defenderRequireCloudProtection,

        [Parameter()]
        [System.String]
        $defenderCloudBlockLevel,

        [Parameter()]
        [System.String]
        $defenderPromptForSampleSubmission,

        [Parameter()]
        [System.String]
        $defenderScheduledQuickScanTime,

        [Parameter()]
        [System.String]
        $defenderScanType,

        [Parameter()]
        [System.string]
        $defenderSystemScanSchedule,

        [Parameter()]
        [System.String]
        $defenderScheduledScanTime,

        [Parameter()]
        [System.String]
        $defenderFileExtensionsToExclude,

        [Parameter()]
        [System.String]
        $defenderFilesAndFoldersToExclude,

        [Parameter()]
        [System.String]
        $defenderProcessesToExclude,

        [Parameter()]
        [System.Boolean]
        $lockScreenAllowTimeoutConfiguration,

        [Parameter()]
        [System.Boolean]
        $lockScreenBlockActionCenterNotifications,

        [Parameter()]
        [System.Boolean]
        $lockScreenBlockCortana,

        [Parameter()]
        [System.Boolean]
        $lockScreenBlockToastNotifications,

        [Parameter()]
        [System.Uint64]
        $lockScreenTimeoutInSeconds,

        [Parameter()]
        [System.Boolean]
        $passwordBlockSimple,

        [Parameter()]
        [System.Uint64]
        $passwordExpirationDays,

        [Parameter()]
        [System.Uint64]
        $passwordMinimumLength,

        [Parameter()]
        [System.Uint64]
        $passwordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Uint64]
        $passwordMinimumCharacterSetCount,

        [Parameter()]
        [System.Uint64]
        $passwordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Boolean]
        $passwordRequired,

        [Parameter()]
        [System.Boolean]
        $passwordRequireWhenResumeFromIdleState,

        [Parameter()]
        [System.String]
        $passwordRequiredType,

        [Parameter()]
        [System.Uint64]
        $passwordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [System.String]
        $privacyAdvertisingId,

        [Parameter()]
        [System.Boolean]
        $privacyBlockInputPersonalization,

        [Parameter()]
        [System.String]
        $startBlockUnpinningAppsFromTaskbar,

        [Parameter()]
        [System.String]
        $startMenuAppListVisibility,

        [Parameter()]
        [System.String]
        $startMenuHideChangeAccountSettings,

        [Parameter()]
        [System.String]
        $startMenuHideFrequentlyUsedApps,

        [Parameter()]
        [System.String]
        $startMenuHideHibernate,

        [Parameter()]
        [System.String]
        $startMenuHideLock,

        [Parameter()]
        [System.String]
        $startMenuHidePowerButton,

        [Parameter()]
        [System.String]
        $startMenuHideRecentJumpLists,

        [Parameter()]
        [System.String]
        $startMenuHideRecentlyAddedApps,

        [Parameter()]
        [System.String]
        $startMenuHideRestartOptions,

        [Parameter()]
        [System.Boolean]
        $startMenuHideShutDown,

        [Parameter()]
        [System.Boolean]
        $startMenuHideSignOut,

        [Parameter()]
        [System.Boolean]
        $startMenuHideSleep,

        [Parameter()]
        [System.Boolean]
        $startMenuHideSwitchAccount,

        [Parameter()]
        [System.Boolean]
        $startMenuHideUserTile,

        [Parameter()]
        [System.String]
        $startMenuMode,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderDocuments,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderDownloads,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderFileExplorer,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderHomeGroup,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderMusic,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderNetwork,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderPersonalFolder,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderPictures,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderSettings,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderVideos,

        [Parameter()]
        [System.Boolean]
        $settingsBlockSettingsApp,

        [Parameter()]
        [System.Boolean]
        $settingsBlockDevicesPage,

        [Parameter()]
        [System.Boolean]
        $settingsBlockNetworkInternetPage,

        [Parameter()]
        [System.Boolean]
        $settingsBlockPersonalizationPage,

        [Parameter()]
        [System.Boolean]
        $settingsBlockAccountsPage,

        [Parameter()]
        [System.Boolean]
        $settingsBlockTimeLanguagePage,

        [Parameter()]
        [System.Boolean]
        $settingsBlockEaseOfAccessPage,

        [Parameter()]
        [System.Boolean]
        $settingsBlockPrivacyPage,

        [Parameter()]
        [System.Boolean]
        $settingsBlockUpdateSecurityPage,

        [Parameter()]
        [System.Boolean]
        $settingsBlockAppsPage,

        [Parameter()]
        [System.Boolean]
        $settingsBlockGamingPage,

        [Parameter()]
        [System.Boolean]
        $windowsSpotlightBlockConsumerSpecificFeatures,

        [Parameter()]
        [System.Boolean]
        $windowsSpotlightBlocked,

        [Parameter()]
        [System.Boolean]
        $windowsSpotlightBlockOnActionCenter,

        [Parameter()]
        [System.Boolean]
        $windowsSpotlightBlockTailoredExperiences,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $ApplicationSecret
    )


    $ConnectionMode = New-M365DSCConnection -Workload 'Intune' `
        -InboundParameters $PSBoundParameters

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    $data.Add("ConnectionMode", $ConnectionMode)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentPolicy = Get-TargetResource @PSBoundParameters
    $setParams = $PSBoundParameters
    $setParams.Remove("Ensure") | Out-Null
    $setParams.Remove("GlobalAdminAccount") | Out-Null
    $setParams.Remove("ApplicationId") | Out-Null
    $setParams.Remove("TenantId") | Out-Null
    $setParams.Remove("ApplicationSecret") | Out-Null
    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Device Configuration Policy {$DisplayName}"
        New-M365DSCIntuneDeviceConfigurationPolicyWindows -Parameters $setParams
    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Device Configuration Policy {$DisplayName}"
        $policy = Get-IntuneDeviceConfigurationPolicy -Filter "displayName eq '$DisplayName'"
        Set-M365DSCIntuneDeviceConfigurationPolicyWindows -Parameters $setParams -PolicyId ($policy.id)
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Device Configuration Policy {$DisplayName}"
        $policy = Get-IntuneDeviceConfigurationPolicy -Filter "displayName eq '$DisplayName'"
        Remove-IntuneDeviceConfigurationPolicy -deviceConfigurationId $policy.id
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $enterpriseCloudPrintDiscoveryEndPoint,

        [Parameter()]
        [System.String]
        $enterpriseCloudPrintOAuthAuthority,

        [Parameter()]
        [System.String]
        $enterpriseCloudPrintOAuthClientIdentifier,

        [Parameter()]
        [System.Integer]
        $enterpriseCloudPrintDiscoveryMaxLimit,

        [Parameter()]
        [System.String]
        $enterpriseCloudPrintMopriaDiscoveryResourceIdentifier,

        [Parameter()]
        [System.Boolean]
        $searchBlockDiacritics,

        [Parameter()]
        [System.Boolean]
        $searchDisableIndexingEncryptedItems,

        [Parameter()]
        [System.Boolean]
        $searchEnableRemoteQueries,

        [Parameter()]
        [System.String]
        $searchDisableIndexerBackoff,

        [Parameter()]
        [System.Boolean]
        $searchDisableIndexingRemovableDrive,

        [Parameter()]
        [System.Boolean]
        $searchEnableAutomaticIndexSizeManangement,

        [Parameter()]
        [System.String]
        $diagnosticsDataSubmissionMode= 'none',

        [Parameter()]
        [System.Boolean]
        $oneDriveDisableFileSync,

        [Parameter()]
        [System.Boolean]
        $smartScreenEnableAppInstallControl,

        [Parameter()]
        [System.String]
        $personalizationDesktopImageUrl,

        [Parameter()]
        [System.String]
        $personalizationLockScreenImageUrl,

        [Parameter()]
        #[System.String]
        $bluetoothAllowedServices,

        [Parameter()]
        [System.Boolean]
        $bluetoothBlockAdvertising,

        [Parameter()]
        [System.Boolean]
        $bluetoothBlockDiscoverableMode,

        [Parameter()]
        [System.Boolean]
        $bluetoothBlockPrePairing,

        [Parameter()]
        [System.Boolean]
        $edgeBlockAutofill,

        [Parameter()]
        [System.Boolean]
        $edgeBlocked,

        [Parameter()]
        [System.Boolean]
        $edgeCookiePolicy,

        [Parameter()]
        [System.String[]]
        $edgeBlockDeveloperTools,

        [Parameter()]
        [System.Boolean]
        $edgeBlockSendingDoNotTrackHeader,

        [Parameter()]
        [System.Boolean]
        $edgeBlockExtensions,

        [Parameter()]
        [System.Boolean]
        $edgeBlockInPrivateBrowsing,

        [Parameter()]
        [System.Boolean]
        $edgeBlockJavaScript,

        [Parameter()]
        [System.Boolean]
        $edgeBlockPasswordManager,

        [Parameter()]
        [System.Boolean]
        $edgeBlockAddressBarDropdown,

        [Parameter()]
        [System.Boolean]
        $edgeBlockCompatibilityList,

        [Parameter()]
        [System.Boolean]
        $edgeClearBrowsingDataOnExit,

        [Parameter()]
        [System.Boolean]
        $edgeAllowStartPagesModification,

        [Parameter()]
        [System.Boolean]
        $DocumentsBlockUnmanagedDocumentsInManagedApps,

        [Parameter()]
        [System.String[]]
        $edgeDisableFirstRunPage,

        [Parameter()]
        [System.Boolean]
        $edgeBlockLiveTileDataCollection,

        [Parameter()]
        [System.Boolean]
        $edgeSyncFavoritesWithInternetExplorer,

        [Parameter()]
        [System.Boolean]
        $cellularBlockDataWhenRoaming,

        [Parameter()]
        [System.Boolean]
        $cellularBlockVpn,

        [Parameter()]
        [System.Boolean]
        $cellularBlockVpnWhenRoaming,

        [Parameter()]
        [System.Boolean]
        $defenderRequireRealTimeMonitoring,

        [Parameter()]
        [System.Boolean]
        $defenderRequireBehaviorMonitoring,

        [Parameter()]
        [System.Boolean]
        $defenderRequireNetworkInspectionSystem,

        [Parameter()]
        [System.Boolean]
        $defenderScanDownloads,

        [Parameter()]
        [System.Boolean]
        $defenderScanScriptsLoadedInInternetExplorer,

        [Parameter()]
        [System.Boolean]
        $defenderBlockEndUserAccess,

        [Parameter()]
        [System.Uint64]
        $defenderSignatureUpdateIntervalInHours,

        [Parameter()]
        [System.String]
        $defenderMonitorFileActivity,

        [Parameter()]
        [System.Uint64]
        $defenderDaysBeforeDeletingQuarantinedMalware,

        [Parameter()]
        [System.Uint64]
        $defenderScanMaxCpu,

        [Parameter()]
        [System.Boolean]
        $defenderScanArchiveFiles,

        [Parameter()]
        [System.Boolean]
        $defenderScanIncomingMail,

        [Parameter()]
        [System.Boolean]
        $defenderScanRemovableDrivesDuringFullScan,

        [Parameter()]
        [System.Boolean]
        $defenderScanMappedNetworkDrivesDuringFullScan,

        [Parameter()]
        [System.Boolean]
        $defenderScanNetworkFiles,

        [Parameter()]
        [System.Boolean]
        $defenderRequireCloudProtection,

        [Parameter()]
        [System.String]
        $defenderCloudBlockLevel,

        [Parameter()]
        [System.String]
        $defenderPromptForSampleSubmission,

        [Parameter()]
        [System.String]
        $defenderScheduledQuickScanTime,

        [Parameter()]
        [System.String]
        $defenderScanType,

        [Parameter()]
        [System.string]
        $defenderSystemScanSchedule,

        [Parameter()]
        [System.String]
        $defenderScheduledScanTime,

        [Parameter()]
        [System.String]
        $defenderFileExtensionsToExclude,

        [Parameter()]
        [System.String]
        $defenderFilesAndFoldersToExclude,

        [Parameter()]
        [System.String]
        $defenderProcessesToExclude,

        [Parameter()]
        [System.Boolean]
        $lockScreenAllowTimeoutConfiguration,

        [Parameter()]
        [System.Boolean]
        $lockScreenBlockActionCenterNotifications,

        [Parameter()]
        [System.Boolean]
        $lockScreenBlockCortana,

        [Parameter()]
        [System.Boolean]
        $lockScreenBlockToastNotifications,

        [Parameter()]
        [System.Uint64]
        $lockScreenTimeoutInSeconds,

        [Parameter()]
        [System.Boolean]
        $passwordBlockSimple,

        [Parameter()]
        [System.Uint64]
        $passwordExpirationDays,

        [Parameter()]
        [System.Uint64]
        $passwordMinimumLength,

        [Parameter()]
        [System.Uint64]
        $passwordMinutesOfInactivityBeforeScreenTimeout,

        [Parameter()]
        [System.Uint64]
        $passwordMinimumCharacterSetCount,

        [Parameter()]
        [System.Uint64]
        $passwordPreviousPasswordBlockCount,

        [Parameter()]
        [System.Boolean]
        $passwordRequired,

        [Parameter()]
        [System.Boolean]
        $passwordRequireWhenResumeFromIdleState,

        [Parameter()]
        [System.String]
        $passwordRequiredType,

        [Parameter()]
        [System.Uint64]
        $passwordSignInFailureCountBeforeFactoryReset,

        [Parameter()]
        [System.String]
        $privacyAdvertisingId,

        [Parameter()]
        [System.Boolean]
        $privacyBlockInputPersonalization,

        [Parameter()]
        [System.String]
        $startBlockUnpinningAppsFromTaskbar,

        [Parameter()]
        [System.String]
        $startMenuAppListVisibility,

        [Parameter()]
        [System.String]
        $startMenuHideChangeAccountSettings,

        [Parameter()]
        [System.String]
        $startMenuHideFrequentlyUsedApps,

        [Parameter()]
        [System.String]
        $startMenuHideHibernate,

        [Parameter()]
        [System.String]
        $startMenuHideLock,

        [Parameter()]
        [System.String]
        $startMenuHidePowerButton,

        [Parameter()]
        [System.String]
        $startMenuHideRecentJumpLists,

        [Parameter()]
        [System.String]
        $startMenuHideRecentlyAddedApps,

        [Parameter()]
        [System.String]
        $startMenuHideRestartOptions,

        [Parameter()]
        [System.Boolean]
        $startMenuHideShutDown,

        [Parameter()]
        [System.Boolean]
        $startMenuHideSignOut,

        [Parameter()]
        [System.Boolean]
        $startMenuHideSleep,

        [Parameter()]
        [System.Boolean]
        $startMenuHideSwitchAccount,

        [Parameter()]
        [System.Boolean]
        $startMenuHideUserTile,

        [Parameter()]
        [System.String]
        $startMenuMode,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderDocuments,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderDownloads,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderFileExplorer,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderHomeGroup,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderMusic,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderNetwork,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderPersonalFolder,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderPictures,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderSettings,

        [Parameter()]
        [System.String]
        $startMenuPinnedFolderVideos,

        [Parameter()]
        [System.Boolean]
        $settingsBlockSettingsApp,

        [Parameter()]
        [System.Boolean]
        $settingsBlockDevicesPage,

        [Parameter()]
        [System.Boolean]
        $settingsBlockNetworkInternetPage,

        [Parameter()]
        [System.Boolean]
        $settingsBlockPersonalizationPage,

        [Parameter()]
        [System.Boolean]
        $settingsBlockAccountsPage,

        [Parameter()]
        [System.Boolean]
        $settingsBlockTimeLanguagePage,

        [Parameter()]
        [System.Boolean]
        $settingsBlockEaseOfAccessPage,

        [Parameter()]
        [System.Boolean]
        $settingsBlockPrivacyPage,

        [Parameter()]
        [System.Boolean]
        $settingsBlockUpdateSecurityPage,

        [Parameter()]
        [System.Boolean]
        $settingsBlockAppsPage,

        [Parameter()]
        [System.Boolean]
        $settingsBlockGamingPage,

        [Parameter()]
        [System.Boolean]
        $windowsSpotlightBlockConsumerSpecificFeatures,

        [Parameter()]
        [System.Boolean]
        $windowsSpotlightBlocked,

        [Parameter()]
        [System.Boolean]
        $windowsSpotlightBlockOnActionCenter,

        [Parameter()]
        [System.Boolean]
        $windowsSpotlightBlockTailoredExperiences,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $ApplicationSecret
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    Write-Verbose -Message "Testing configuration of Device Configuration Policy {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $ApplicationSecret
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'Intune' `
        -InboundParameters $PSBoundParameters

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    $data.Add("ConnectionMode", $ConnectionMode)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array]$policies = Get-IntuneDeviceConfigurationPolicy -ErrorAction Stop | Where-Object -FilterScript { $_.'@odata.type' -eq '#microsoft.graph.Windows10GeneralConfiguration' }
        $i = 1
        $dscContent = ''
        if ($policies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewLine
        }
        foreach ($policy in $policies)
        {
            Write-Host "    |---[$i/$($policies.Count)] $($policy.displayName)" -NoNewline
            $params = @{
                DisplayName        = $policy.displayName
                Ensure             = 'Present'
                GlobalAdminAccount = $GlobalAdminAccount
                ApplicationId      = $ApplicationId
                TenantId           = $TenantId
                ApplicationSecret  = $ApplicationSecret
            }
            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -GlobalAdminAccount $GlobalAdminAccount
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        return $dscContent
    }
    catch
    {
        if ($_.Exception -like '*401*')
        {
            Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]

            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return ""
    }
}

function Get-M365DSCIntuneDeviceConfigurationPolicyWindows
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $PolicyId
    )
    try
    {
        $Url = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/$PolicyId"
        $response = Invoke-MSGraphRequest -HttpMethod Get `
            -Url $Url
        return $response
    }
    catch
    {
        Write-Verbose -Message $_
        $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $tenantIdValue
    }
    return $null
}

function New-M365DSCIntuneDeviceConfigurationPolicyWindows
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Parameters
    )
    try
    {
        if ($Parameters.ContainsKey("Verbose"))
        {
            $Parameters.Remove("Verbose") | Out-Null
        }
        # replace the first letter of each key by a lower case;
        $jsonString = "{`r`n`"@odata.type`":`"#microsoft.graph.Windows10GeneralConfiguration`",`r`n"
        foreach ($key in $Parameters.Keys)
        {
            $length = $key.Length
            $fixedKeyName = $key[0].ToString().ToLower() + $key.Substring(1, $length - 1)
            $jsonString += "`"$fixedKeyName`": "
            if ($Parameters.$key.GetType().Name -eq "String")
            {
                $jsonString += "`"$($Parameters.$key)`",`r`n"
            }
            elseif ($Parameters.$key.GetType().Name -eq "Boolean")
            {
                $jsonString += "$(($Parameters.$key).ToString().ToLower()),`r`n"
            }
            else
            {
                $jsonString += "$($Parameters.$key),`r`n"
            }
        }
        $jsonString = $jsonString.TrimEnd(",`r`n")
        $jsonString += "`r`n}"
        $Url = 'https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/'
        Write-Verbose -Message "Creating new Device config policy with JSON payload: `r`n$jsonString"
        Invoke-MSGraphRequest -HttpMethod POST `
            -Url $Url `
            -Content $jsonString `
            -Headers @{"Content-Type" = "application/json" } | Out-Null
    }
    catch
    {
        Write-Verbose -Message $_
        $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $tenantIdValue
    }
}

function Set-M365DSCIntuneDeviceConfigurationPolicyWindows
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Parameters,

        [Parameter(Mandatory = $true)]
        [System.String]
        $PolicyId
    )
    try
    {
        if ($Parameters.ContainsKey("Verbose"))
        {
            $Parameters.Remove("Verbose") | Out-Null
        }
        # replace the first letter of each key by a lower case;
        $jsonString = "{`r`n`"@odata.type`":`"#microsoft.graph.Windows10GeneralConfiguration`",`r`n"
        foreach ($key in $Parameters.Keys)
        {
            $length = $key.Length
            $fixedKeyName = $key[0].ToString().ToLower() + $key.Substring(1, $length - 1)
            $jsonString += "`"$fixedKeyName`": "
            if ($Parameters.$key.GetType().Name -eq "String")
            {
                $jsonString += "`"$($Parameters.$key)`",`r`n"
            }
            elseif ($Parameters.$key.GetType().Name -eq "Boolean")
            {
                $jsonString += "$(($Parameters.$key).ToString().ToLower()),`r`n"
            }
            else
            {
                $jsonString += "$($Parameters.$key),`r`n"
            }
        }
        $jsonString = $jsonString.TrimEnd(",`r`n")
        $jsonString += "`r`n}"
        $Url = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations/$PolicyId"
        Write-Verbose -Message "Updating Device config policy with JSON payload: `r`n$jsonString"
        Invoke-MSGraphRequest -HttpMethod PATCH `
            -Url $Url `
            -Content $jsonString `
            -Headers @{"Content-Type" = "application/json" } | Out-Null
    }
    catch
    {
        Write-Verbose -Message $_
        $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $tenantIdValue
    }
}

Export-ModuleMember -Function *-TargetResource
