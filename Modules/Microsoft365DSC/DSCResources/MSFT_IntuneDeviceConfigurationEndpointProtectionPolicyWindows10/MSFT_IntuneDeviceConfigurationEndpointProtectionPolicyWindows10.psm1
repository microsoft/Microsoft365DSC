Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneDeviceConfigurationEndpointProtectionPolicyWindows10'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.Boolean]
        $ApplicationGuardAllowCameraMicrophoneRedirection,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardAllowFileSaveOnHost,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardAllowPersistence,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardAllowPrintToLocalPrinters,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardAllowPrintToNetworkPrinters,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardAllowPrintToPDF,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardAllowPrintToXPS,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardAllowVirtualGPU,

        [Parameter()]
        [ValidateSet('notConfigured', 'blockBoth', 'blockHostToContainer', 'blockContainerToHost', 'blockNone')]
        [System.String]
        $ApplicationGuardBlockClipboardSharing,

        [Parameter()]
        [ValidateSet('notConfigured', 'blockImageAndTextFile', 'blockImageFile', 'blockNone', 'blockTextFile')]
        [System.String]
        $ApplicationGuardBlockFileTransfer,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardBlockNonEnterpriseContent,

        [Parameter()]
        [System.String[]]
        $ApplicationGuardCertificateThumbprints,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardEnabled,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabledForEdge', 'enabledForOffice', 'enabledForEdgeAndOffice')]
        [System.String]
        $ApplicationGuardEnabledOptions,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardForceAuditing,

        [Parameter()]
        [ValidateSet('notConfigured', 'enforceComponentsAndStoreApps', 'auditComponentsAndStoreApps', 'enforceComponentsStoreAppsAndSmartlocker', 'auditComponentsStoreAppsAndSmartlocker')]
        [System.String]
        $AppLockerApplicationControl,

        [Parameter()]
        [System.Boolean]
        $BitLockerAllowStandardUserEncryption,

        [Parameter()]
        [System.Boolean]
        $BitLockerDisableWarningForOtherDiskEncryption,

        [Parameter()]
        [System.Boolean]
        $BitLockerEnableStorageCardEncryptionOnMobile,

        [Parameter()]
        [System.Boolean]
        $BitLockerEncryptDevice,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $BitLockerFixedDrivePolicy,

        [Parameter()]
        [ValidateSet('notConfigured', 'disabled', 'enabledForAzureAd', 'enabledForAzureAdAndHybrid')]
        [System.String]
        $BitLockerRecoveryPasswordRotation,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $BitLockerRemovableDrivePolicy,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $BitLockerSystemDrivePolicy,

        [Parameter()]
        [System.String[]]
        $DefenderAdditionalGuardedFolders,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderAdobeReaderLaunchChildProcess,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderAdvancedRansomewareProtectionType,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowBehaviorMonitoring,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowCloudProtection,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowEndUserAccess,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowIntrusionPreventionSystem,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowOnAccessProtection,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowRealTimeMonitoring,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowScanArchiveFiles,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowScanDownloads,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowScanNetworkFiles,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowScanRemovableDrivesDuringFullScan,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowScanScriptsLoadedInInternetExplorer,

        [Parameter()]
        [System.String[]]
        $DefenderAttackSurfaceReductionExcludedPaths,

        [Parameter()]
        [System.Boolean]
        $DefenderBlockEndUserAccess,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderBlockPersistenceThroughWmiType,

        [Parameter()]
        [System.Boolean]
        $DefenderCheckForSignaturesBeforeRunningScan,

        [Parameter()]
        [ValidateSet('notConfigured', 'high', 'highPlus', 'zeroTolerance')]
        [System.String]
        $DefenderCloudBlockLevel,

        [Parameter()]
        [System.Int32]
        $DefenderCloudExtendedTimeoutInSeconds,

        [Parameter()]
        [System.Int32]
        $DefenderDaysBeforeDeletingQuarantinedMalware,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DefenderDetectedMalwareActions,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableBehaviorMonitoring,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableCatchupFullScan,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableCatchupQuickScan,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableCloudProtection,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableIntrusionPreventionSystem,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableOnAccessProtection,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableRealTimeMonitoring,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableScanArchiveFiles,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableScanDownloads,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableScanNetworkFiles,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableScanRemovableDrivesDuringFullScan,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableScanScriptsLoadedInInternetExplorer,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderEmailContentExecution,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderEmailContentExecutionType,

        [Parameter()]
        [System.Boolean]
        $DefenderEnableLowCpuPriority,

        [Parameter()]
        [System.Boolean]
        $DefenderEnableScanIncomingMail,

        [Parameter()]
        [System.Boolean]
        $DefenderEnableScanMappedNetworkDrivesDuringFullScan,

        [Parameter()]
        [System.String]
        $DefenderExploitProtectionXml,

        [Parameter()]
        [System.String]
        $DefenderExploitProtectionXmlFileName,

        [Parameter()]
        [System.String[]]
        $DefenderFileExtensionsToExclude,

        [Parameter()]
        [System.String[]]
        $DefenderFilesAndFoldersToExclude,

        [Parameter()]
        [System.String[]]
        $DefenderGuardedFoldersAllowedAppPaths,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'blockDiskModification', 'auditDiskModification')]
        [System.String]
        $DefenderGuardMyFoldersType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderNetworkProtectionType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderOfficeAppsExecutableContentCreationOrLaunch,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderOfficeAppsExecutableContentCreationOrLaunchType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderOfficeAppsLaunchChildProcess,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderOfficeAppsLaunchChildProcessType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderOfficeAppsOtherProcessInjection,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderOfficeAppsOtherProcessInjectionType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderOfficeCommunicationAppsLaunchChildProcess,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderOfficeMacroCodeAllowWin32Imports,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderOfficeMacroCodeAllowWin32ImportsType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderPotentiallyUnwantedAppAction,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderPreventCredentialStealingType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderProcessCreation,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderProcessCreationType,

        [Parameter()]
        [System.String[]]
        $DefenderProcessesToExclude,

        [Parameter()]
        [ValidateSet('monitorAllFiles', 'monitorIncomingFilesOnly', 'monitorOutgoingFilesOnly')]
        [System.String]
        $DefenderScanDirection,

        [Parameter()]
        [System.Int32]
        $DefenderScanMaxCpuPercentage,

        [Parameter()]
        [ValidateSet('userDefined', 'disabled', 'quick', 'full')]
        [System.String]
        $DefenderScanType,

        [Parameter()]
        [System.TimeSpan]
        $DefenderScheduledQuickScanTime,

        [Parameter()]
        [ValidateSet('userDefined', 'everyday', 'sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'noScheduledScan')]
        [System.String]
        $DefenderScheduledScanDay,

        [Parameter()]
        [System.TimeSpan]
        $DefenderScheduledScanTime,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderScriptDownloadedPayloadExecution,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderScriptDownloadedPayloadExecutionType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderScriptObfuscatedMacroCode,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderScriptObfuscatedMacroCodeType,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterBlockExploitProtectionOverride,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableAccountUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableAppBrowserUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableClearTpmUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableFamilyUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableHardwareUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableHealthUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableNetworkUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableNotificationAreaUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableRansomwareUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableSecureBootUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableTroubleshootingUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableVirusUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableVulnerableTpmFirmwareUpdateUI,

        [Parameter()]
        [System.String]
        $DefenderSecurityCenterHelpEmail,

        [Parameter()]
        [System.String]
        $DefenderSecurityCenterHelpPhone,

        [Parameter()]
        [System.String]
        $DefenderSecurityCenterHelpURL,

        [Parameter()]
        [ValidateSet('notConfigured', 'displayInAppAndInNotifications', 'displayOnlyInApp', 'displayOnlyInNotifications')]
        [System.String]
        $DefenderSecurityCenterITContactDisplay,

        [Parameter()]
        [ValidateSet('notConfigured', 'blockNoncriticalNotifications', 'blockAllNotifications')]
        [System.String]
        $DefenderSecurityCenterNotificationsFromApp,

        [Parameter()]
        [System.String]
        $DefenderSecurityCenterOrganizationDisplayName,

        [Parameter()]
        [System.Int32]
        $DefenderSignatureUpdateIntervalInHours,

        [Parameter()]
        [ValidateSet('sendSafeSamplesAutomatically', 'alwaysPrompt', 'neverSend', 'sendAllSamplesAutomatically')]
        [System.String]
        $DefenderSubmitSamplesConsentType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderUntrustedExecutable,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderUntrustedExecutableType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderUntrustedUSBProcess,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderUntrustedUSBProcessType,

        [Parameter()]
        [System.Boolean]
        $DeviceGuardEnableSecureBootWithDMA,

        [Parameter()]
        [System.Boolean]
        $DeviceGuardEnableVirtualizationBasedSecurity,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $DeviceGuardLaunchSystemGuard,

        [Parameter()]
        [ValidateSet('notConfigured', 'enableWithUEFILock', 'enableWithoutUEFILock', 'disable')]
        [System.String]
        $DeviceGuardLocalSystemAuthorityCredentialGuardSettings,

        [Parameter()]
        [ValidateSet('notConfigured', 'withoutDMA', 'withDMA')]
        [System.String]
        $DeviceGuardSecureBootWithDMA,

        [Parameter()]
        [ValidateSet('deviceDefault', 'blockAll', 'allowAll')]
        [System.String]
        $DmaGuardDeviceEnumerationPolicy,

        [Parameter()]
        [System.Boolean]
        $FirewallBlockStatefulFTP,

        [Parameter()]
        [ValidateSet('deviceDefault', 'none', 'attempt', 'require')]
        [System.String]
        $FirewallCertificateRevocationListCheckMethod,

        [Parameter()]
        [System.Int32]
        $FirewallIdleTimeoutForSecurityAssociationInSeconds,

        [Parameter()]
        [System.Boolean]
        $FirewallIPSecExemptionsAllowDHCP,

        [Parameter()]
        [System.Boolean]
        $FirewallIPSecExemptionsAllowICMP,

        [Parameter()]
        [System.Boolean]
        $FirewallIPSecExemptionsAllowNeighborDiscovery,

        [Parameter()]
        [System.Boolean]
        $FirewallIPSecExemptionsAllowRouterDiscovery,

        [Parameter()]
        [System.Boolean]
        $FirewallIPSecExemptionsNone,

        [Parameter()]
        [System.Boolean]
        $FirewallMergeKeyingModuleSettings,

        [Parameter()]
        [ValidateSet('deviceDefault', 'disabled', 'queueInbound', 'queueOutbound', 'queueBoth')]
        [System.String]
        $FirewallPacketQueueingMethod,

        [Parameter()]
        [ValidateSet('deviceDefault', 'none', 'utF8')]
        [System.String]
        $FirewallPreSharedKeyEncodingMethod,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FirewallProfileDomain,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FirewallProfilePrivate,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FirewallProfilePublic,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $FirewallRules,

        [Parameter()]
        [ValidateSet('lmAndNltm', 'lmNtlmAndNtlmV2', 'lmAndNtlmOnly', 'lmAndNtlmV2', 'lmNtlmV2AndNotLm', 'lmNtlmV2AndNotLmOrNtm')]
        [System.String]
        $LanManagerAuthenticationLevel,

        [Parameter()]
        [System.Boolean]
        $LanManagerWorkstationDisableInsecureGuestLogons,

        [Parameter()]
        [System.String]
        $LocalSecurityOptionsAdministratorAccountName,

        [Parameter()]
        [ValidateSet('notConfigured', 'elevateWithoutPrompting', 'promptForCredentialsOnTheSecureDesktop', 'promptForConsentOnTheSecureDesktop', 'promptForCredentials', 'promptForConsent', 'promptForConsentForNonWindowsBinaries')]
        [System.String]
        $LocalSecurityOptionsAdministratorElevationPromptBehavior,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsAllowAnonymousEnumerationOfSAMAccountsAndShares,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsAllowPKU2UAuthenticationRequests,

        [Parameter()]
        [System.String]
        $LocalSecurityOptionsAllowRemoteCallsToSecurityAccountsManager,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsAllowRemoteCallsToSecurityAccountsManagerHelperBool,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsAllowSystemToBeShutDownWithoutHavingToLogOn,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsAllowUIAccessApplicationElevation,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsAllowUIAccessApplicationsForSecureLocations,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsAllowUndockWithoutHavingToLogon,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsBlockMicrosoftAccounts,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsBlockRemoteLogonWithBlankPassword,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsBlockRemoteOpticalDriveAccess,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsBlockUsersInstallingPrinterDrivers,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsClearVirtualMemoryPageFile,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsClientDigitallySignCommunicationsAlways,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsClientSendUnencryptedPasswordToThirdPartySMBServers,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsDetectApplicationInstallationsAndPromptForElevation,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsDisableAdministratorAccount,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsDisableClientDigitallySignCommunicationsIfServerAgrees,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsDisableGuestAccount,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsDisableServerDigitallySignCommunicationsAlways,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsDisableServerDigitallySignCommunicationsIfClientAgrees,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsDoNotAllowAnonymousEnumerationOfSAMAccounts,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsDoNotRequireCtrlAltDel,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsDoNotStoreLANManagerHashValueOnNextPasswordChange,

        [Parameter()]
        [ValidateSet('notConfigured', 'administrators', 'administratorsAndPowerUsers', 'administratorsAndInteractiveUsers')]
        [System.String]
        $LocalSecurityOptionsFormatAndEjectOfRemovableMediaAllowedUser,

        [Parameter()]
        [System.String]
        $LocalSecurityOptionsGuestAccountName,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsHideLastSignedInUser,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsHideUsernameAtSignIn,

        [Parameter()]
        [ValidateSet('notConfigured', 'administrators', 'administratorsAndPowerUsers', 'administratorsAndInteractiveUsers')]
        [System.String]
        $LocalSecurityOptionsInformationDisplayedOnLockScreen,

        [Parameter()]
        [ValidateSet('notConfigured', 'userDisplayNameDomainUser', 'userDisplayNameOnly', 'doNotDisplayUser')]
        [System.String]
        $LocalSecurityOptionsInformationShownOnLockScreen,

        [Parameter()]
        [System.String]
        $LocalSecurityOptionsLogOnMessageText,

        [Parameter()]
        [System.String]
        $LocalSecurityOptionsLogOnMessageTitle,

        [Parameter()]
        [System.Int32]
        $LocalSecurityOptionsMachineInactivityLimit,

        [Parameter()]
        [System.Int32]
        $LocalSecurityOptionsMachineInactivityLimitInMinutes,

        [Parameter()]
        [ValidateSet('none', 'requireNtmlV2SessionSecurity', 'require128BitEncryption', 'ntlmV2And128BitEncryption')]
        [System.String]
        $LocalSecurityOptionsMinimumSessionSecurityForNtlmSspBasedClients,

        [Parameter()]
        [ValidateSet('none', 'requireNtmlV2SessionSecurity', 'require128BitEncryption', 'ntlmV2And128BitEncryption')]
        [System.String]
        $LocalSecurityOptionsMinimumSessionSecurityForNtlmSspBasedServers,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsOnlyElevateSignedExecutables,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsRestrictAnonymousAccessToNamedPipesAndShares,

        [Parameter()]
        [ValidateSet('noAction', 'lockWorkstation', 'forceLogoff', 'disconnectRemoteDesktopSession')]
        [System.String]
        $LocalSecurityOptionsSmartCardRemovalBehavior,

        [Parameter()]
        [ValidateSet('notConfigured', 'automaticallyDenyElevationRequests', 'promptForCredentialsOnTheSecureDesktop', 'promptForCredentials')]
        [System.String]
        $LocalSecurityOptionsStandardUserElevationPromptBehavior,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsSwitchToSecureDesktopWhenPromptingForElevation,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsUseAdminApprovalMode,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsUseAdminApprovalModeForAdministrators,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsVirtualizeFileAndRegistryWriteFailuresToPerUserLocations,

        [Parameter()]
        [System.Boolean]
        $SmartScreenBlockOverrideForFiles,

        [Parameter()]
        [System.Boolean]
        $SmartScreenEnableInShell,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsAccessCredentialManagerAsTrustedCaller,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsActAsPartOfTheOperatingSystem,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsAllowAccessFromNetwork,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsBackupData,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsBlockAccessFromNetwork,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsChangeSystemTime,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsCreateGlobalObjects,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsCreatePageFile,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsCreatePermanentSharedObjects,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsCreateSymbolicLinks,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsCreateToken,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsDebugPrograms,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsDelegation,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsDenyLocalLogOn,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsGenerateSecurityAudits,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsImpersonateClient,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsIncreaseSchedulingPriority,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsLoadUnloadDrivers,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsLocalLogOn,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsLockMemory,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsManageAuditingAndSecurityLogs,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsManageVolumes,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsModifyFirmwareEnvironment,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsModifyObjectLabels,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsProfileSingleProcess,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsRemoteDesktopServicesLogOn,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsRemoteShutdown,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsRestoreData,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsTakeOwnership,

        [Parameter()]
        [ValidateSet('notConfigured', 'enable', 'disable')]
        [System.String]
        $WindowsDefenderTamperProtection,

        [Parameter()]
        [ValidateSet('manual', 'automatic', 'disabled')]
        [System.String]
        $XboxServicesAccessoryManagementServiceStartupMode,

        [Parameter()]
        [System.Boolean]
        $XboxServicesEnableXboxGameSaveTask,

        [Parameter()]
        [ValidateSet('manual', 'automatic', 'disabled')]
        [System.String]
        $XboxServicesLiveAuthManagerServiceStartupMode,

        [Parameter()]
        [ValidateSet('manual', 'automatic', 'disabled')]
        [System.String]
        $XboxServicesLiveGameSaveServiceStartupMode,

        [Parameter()]
        [ValidateSet('manual', 'automatic', 'disabled')]
        [System.String]
        $XboxServicesLiveNetworkingServiceStartupMode,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of the Intune Device Configuration Endpoint Protection Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName}."

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
                -InboundParameters $PSBoundParameters

            #Ensure the proper dependencies are installed in the current environment.
            Confirm-M365DSCDependencies

            #region Telemetry
            $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
            $CommandName = $MyInvocation.MyCommand
            $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
                -CommandName $CommandName `
                -Parameters $PSBoundParameters
            Add-M365DSCTelemetryEvent -Data $data
            #endregion

            $nullResult = $PSBoundParameters
            $nullResult.Ensure = 'Absent'

            $getValue = $null
            #region resource generator code
            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                $getValue = Get-MgBetaDeviceManagementDeviceConfiguration -All -Filter "Id eq '$Id'" -ErrorAction SilentlyContinue
            }

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Device Configuration Endpoint Protection Policy for Windows10 with Id {$Id}"

                if (-not [string]::IsNullOrEmpty($DisplayName))
                {
                    $getValue = Get-MgBetaDeviceManagementDeviceConfiguration `
                        -All `
                        -Filter "DisplayName eq '$($DisplayName -replace "'", "''")'" `
                        -ErrorAction SilentlyContinue | Where-Object `
                        -FilterScript {
                        $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windows10EndpointProtectionConfiguration'
                    }

                    if ($null -eq $getValue)
                    {
                        Write-Verbose -Message "Could not find an Intune Device Configuration Endpoint Protection Policy for Windows10 with DisplayName {$DisplayName}"
                        return $nullResult
                    }
                    if (([array]$getValue).Count -gt 1)
                    {
                        throw "A policy with a duplicated displayName {'$DisplayName'} was found - Ensure displayName is unique"
                    }
                }
            }
            #endregion
        }
        else
        {
            $getValue = $Script:exportedInstance
        }

        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Device Configuration Endpoint Protection Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName} was found."

        #region resource generator code
        $complexBitLockerFixedDrivePolicy = [ordered]@{}
        if ($null -ne $getValue.AdditionalProperties.bitLockerFixedDrivePolicy.encryptionMethod)
        {
            $complexBitLockerFixedDrivePolicy.Add('EncryptionMethod', $getValue.AdditionalProperties.bitLockerFixedDrivePolicy.encryptionMethod.ToString())
        }
        $complexRecoveryOptions = [ordered]@{}
        $complexRecoveryOptions.Add('BlockDataRecoveryAgent', $getValue.AdditionalProperties.bitLockerFixedDrivePolicy.recoveryOptions.blockDataRecoveryAgent)
        $complexRecoveryOptions.Add('EnableBitLockerAfterRecoveryInformationToStore', $getValue.AdditionalProperties.bitLockerFixedDrivePolicy.recoveryOptions.enableBitLockerAfterRecoveryInformationToStore)
        $complexRecoveryOptions.Add('EnableRecoveryInformationSaveToStore', $getValue.AdditionalProperties.bitLockerFixedDrivePolicy.recoveryOptions.enableRecoveryInformationSaveToStore)
        $complexRecoveryOptions.Add('HideRecoveryOptions', $getValue.AdditionalProperties.bitLockerFixedDrivePolicy.recoveryOptions.hideRecoveryOptions)
        if ($null -ne $getValue.AdditionalProperties.bitLockerFixedDrivePolicy.recoveryOptions.recoveryInformationToStore)
        {
            $complexRecoveryOptions.Add('RecoveryInformationToStore', $getValue.AdditionalProperties.bitLockerFixedDrivePolicy.recoveryOptions.recoveryInformationToStore.ToString())
        }
        if ($null -ne $getValue.AdditionalProperties.bitLockerFixedDrivePolicy.recoveryOptions.recoveryKeyUsage)
        {
            $complexRecoveryOptions.Add('RecoveryKeyUsage', $getValue.AdditionalProperties.bitLockerFixedDrivePolicy.recoveryOptions.recoveryKeyUsage.ToString())
        }
        if ($null -ne $getValue.AdditionalProperties.bitLockerFixedDrivePolicy.recoveryOptions.recoveryPasswordUsage)
        {
            $complexRecoveryOptions.Add('RecoveryPasswordUsage', $getValue.AdditionalProperties.bitLockerFixedDrivePolicy.recoveryOptions.recoveryPasswordUsage.ToString())
        }
        if ($complexRecoveryOptions.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexRecoveryOptions = $null
        }
        $complexBitLockerFixedDrivePolicy.Add('RecoveryOptions', $complexRecoveryOptions)
        $complexBitLockerFixedDrivePolicy.Add('RequireEncryptionForWriteAccess', $getValue.AdditionalProperties.bitLockerFixedDrivePolicy.requireEncryptionForWriteAccess)
        if ($complexBitLockerFixedDrivePolicy.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexBitLockerFixedDrivePolicy = $null
        }

        $complexBitLockerRemovableDrivePolicy = [ordered]@{}
        $complexBitLockerRemovableDrivePolicy.Add('BlockCrossOrganizationWriteAccess', $getValue.AdditionalProperties.bitLockerRemovableDrivePolicy.blockCrossOrganizationWriteAccess)
        if ($null -ne $getValue.AdditionalProperties.bitLockerRemovableDrivePolicy.encryptionMethod)
        {
            $complexBitLockerRemovableDrivePolicy.Add('EncryptionMethod', $getValue.AdditionalProperties.bitLockerRemovableDrivePolicy.encryptionMethod.ToString())
        }
        $complexBitLockerRemovableDrivePolicy.Add('RequireEncryptionForWriteAccess', $getValue.AdditionalProperties.bitLockerRemovableDrivePolicy.requireEncryptionForWriteAccess)
        if ($complexBitLockerRemovableDrivePolicy.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexBitLockerRemovableDrivePolicy = $null
        }

        $complexBitLockerSystemDrivePolicy = [ordered]@{}
        if ($null -ne $getValue.AdditionalProperties.bitLockerSystemDrivePolicy.encryptionMethod)
        {
            $complexBitLockerSystemDrivePolicy.Add('EncryptionMethod', $getValue.AdditionalProperties.bitLockerSystemDrivePolicy.encryptionMethod.ToString())
        }
        $complexBitLockerSystemDrivePolicy.Add('MinimumPinLength', $getValue.AdditionalProperties.bitLockerSystemDrivePolicy.minimumPinLength)
        $complexBitLockerSystemDrivePolicy.Add('PrebootRecoveryEnableMessageAndUrl', $getValue.AdditionalProperties.bitLockerSystemDrivePolicy.prebootRecoveryEnableMessageAndUrl)
        $complexBitLockerSystemDrivePolicy.Add('PrebootRecoveryMessage', $getValue.AdditionalProperties.bitLockerSystemDrivePolicy.prebootRecoveryMessage)
        $complexBitLockerSystemDrivePolicy.Add('PrebootRecoveryUrl', $getValue.AdditionalProperties.bitLockerSystemDrivePolicy.prebootRecoveryUrl)
        $complexRecoveryOptions = [ordered]@{}
        $complexRecoveryOptions.Add('BlockDataRecoveryAgent', $getValue.AdditionalProperties.bitLockerSystemDrivePolicy.recoveryOptions.blockDataRecoveryAgent)
        $complexRecoveryOptions.Add('EnableBitLockerAfterRecoveryInformationToStore', $getValue.AdditionalProperties.bitLockerSystemDrivePolicy.recoveryOptions.enableBitLockerAfterRecoveryInformationToStore)
        $complexRecoveryOptions.Add('EnableRecoveryInformationSaveToStore', $getValue.AdditionalProperties.bitLockerSystemDrivePolicy.recoveryOptions.enableRecoveryInformationSaveToStore)
        $complexRecoveryOptions.Add('HideRecoveryOptions', $getValue.AdditionalProperties.bitLockerSystemDrivePolicy.recoveryOptions.hideRecoveryOptions)
        if ($null -ne $getValue.AdditionalProperties.bitLockerSystemDrivePolicy.recoveryOptions.recoveryInformationToStore)
        {
            $complexRecoveryOptions.Add('RecoveryInformationToStore', $getValue.AdditionalProperties.bitLockerSystemDrivePolicy.recoveryOptions.recoveryInformationToStore.ToString())
        }
        if ($null -ne $getValue.AdditionalProperties.bitLockerSystemDrivePolicy.recoveryOptions.recoveryKeyUsage)
        {
            $complexRecoveryOptions.Add('RecoveryKeyUsage', $getValue.AdditionalProperties.bitLockerSystemDrivePolicy.recoveryOptions.recoveryKeyUsage.ToString())
        }
        if ($null -ne $getValue.AdditionalProperties.bitLockerSystemDrivePolicy.recoveryOptions.recoveryPasswordUsage)
        {
            $complexRecoveryOptions.Add('RecoveryPasswordUsage', $getValue.AdditionalProperties.bitLockerSystemDrivePolicy.recoveryOptions.recoveryPasswordUsage.ToString())
        }
        if ($complexRecoveryOptions.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexRecoveryOptions = $null
        }
        $complexBitLockerSystemDrivePolicy.Add('RecoveryOptions', $complexRecoveryOptions)
        $complexBitLockerSystemDrivePolicy.Add('StartupAuthenticationBlockWithoutTpmChip', $getValue.AdditionalProperties.bitLockerSystemDrivePolicy.startupAuthenticationBlockWithoutTpmChip)
        $complexBitLockerSystemDrivePolicy.Add('StartupAuthenticationRequired', $getValue.AdditionalProperties.bitLockerSystemDrivePolicy.startupAuthenticationRequired)
        if ($null -ne $getValue.AdditionalProperties.bitLockerSystemDrivePolicy.startupAuthenticationTpmKeyUsage)
        {
            $complexBitLockerSystemDrivePolicy.Add('StartupAuthenticationTpmKeyUsage', $getValue.AdditionalProperties.bitLockerSystemDrivePolicy.startupAuthenticationTpmKeyUsage.ToString())
        }
        if ($null -ne $getValue.AdditionalProperties.bitLockerSystemDrivePolicy.startupAuthenticationTpmPinAndKeyUsage)
        {
            $complexBitLockerSystemDrivePolicy.Add('StartupAuthenticationTpmPinAndKeyUsage', $getValue.AdditionalProperties.bitLockerSystemDrivePolicy.startupAuthenticationTpmPinAndKeyUsage.ToString())
        }
        if ($null -ne $getValue.AdditionalProperties.bitLockerSystemDrivePolicy.startupAuthenticationTpmPinUsage)
        {
            $complexBitLockerSystemDrivePolicy.Add('StartupAuthenticationTpmPinUsage', $getValue.AdditionalProperties.bitLockerSystemDrivePolicy.startupAuthenticationTpmPinUsage.ToString())
        }
        if ($null -ne $getValue.AdditionalProperties.bitLockerSystemDrivePolicy.startupAuthenticationTpmUsage)
        {
            $complexBitLockerSystemDrivePolicy.Add('StartupAuthenticationTpmUsage', $getValue.AdditionalProperties.bitLockerSystemDrivePolicy.startupAuthenticationTpmUsage.ToString())
        }
        if ($complexBitLockerSystemDrivePolicy.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexBitLockerSystemDrivePolicy = $null
        }

        $complexDefenderDetectedMalwareActions = [ordered]@{}
        if ($null -ne $getValue.AdditionalProperties.defenderDetectedMalwareActions.highSeverity)
        {
            $complexDefenderDetectedMalwareActions.Add('HighSeverity', $getValue.AdditionalProperties.defenderDetectedMalwareActions.highSeverity.ToString())
        }
        if ($null -ne $getValue.AdditionalProperties.defenderDetectedMalwareActions.lowSeverity)
        {
            $complexDefenderDetectedMalwareActions.Add('LowSeverity', $getValue.AdditionalProperties.defenderDetectedMalwareActions.lowSeverity.ToString())
        }
        if ($null -ne $getValue.AdditionalProperties.defenderDetectedMalwareActions.moderateSeverity)
        {
            $complexDefenderDetectedMalwareActions.Add('ModerateSeverity', $getValue.AdditionalProperties.defenderDetectedMalwareActions.moderateSeverity.ToString())
        }
        if ($null -ne $getValue.AdditionalProperties.defenderDetectedMalwareActions.severeSeverity)
        {
            $complexDefenderDetectedMalwareActions.Add('SevereSeverity', $getValue.AdditionalProperties.defenderDetectedMalwareActions.severeSeverity.ToString())
        }
        if ($complexDefenderDetectedMalwareActions.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexDefenderDetectedMalwareActions = $null
        }

        $complexFirewallProfileDomain = [ordered]@{}
        $complexFirewallProfileDomain.Add('AuthorizedApplicationRulesFromGroupPolicyMerged', $getValue.AdditionalProperties.firewallProfileDomain.authorizedApplicationRulesFromGroupPolicyMerged)
        $complexFirewallProfileDomain.Add('AuthorizedApplicationRulesFromGroupPolicyNotMerged', $getValue.AdditionalProperties.firewallProfileDomain.authorizedApplicationRulesFromGroupPolicyNotMerged)
        $complexFirewallProfileDomain.Add('ConnectionSecurityRulesFromGroupPolicyMerged', $getValue.AdditionalProperties.firewallProfileDomain.connectionSecurityRulesFromGroupPolicyMerged)
        $complexFirewallProfileDomain.Add('ConnectionSecurityRulesFromGroupPolicyNotMerged', $getValue.AdditionalProperties.firewallProfileDomain.connectionSecurityRulesFromGroupPolicyNotMerged)
        if ($null -ne $getValue.AdditionalProperties.firewallProfileDomain.firewallEnabled)
        {
            $complexFirewallProfileDomain.Add('FirewallEnabled', $getValue.AdditionalProperties.firewallProfileDomain.firewallEnabled.ToString())
        }
        $complexFirewallProfileDomain.Add('GlobalPortRulesFromGroupPolicyMerged', $getValue.AdditionalProperties.firewallProfileDomain.globalPortRulesFromGroupPolicyMerged)
        $complexFirewallProfileDomain.Add('GlobalPortRulesFromGroupPolicyNotMerged', $getValue.AdditionalProperties.firewallProfileDomain.globalPortRulesFromGroupPolicyNotMerged)
        $complexFirewallProfileDomain.Add('InboundConnectionsBlocked', $getValue.AdditionalProperties.firewallProfileDomain.inboundConnectionsBlocked)
        $complexFirewallProfileDomain.Add('InboundConnectionsRequired', $getValue.AdditionalProperties.firewallProfileDomain.inboundConnectionsRequired)
        $complexFirewallProfileDomain.Add('InboundNotificationsBlocked', $getValue.AdditionalProperties.firewallProfileDomain.inboundNotificationsBlocked)
        $complexFirewallProfileDomain.Add('InboundNotificationsRequired', $getValue.AdditionalProperties.firewallProfileDomain.inboundNotificationsRequired)
        $complexFirewallProfileDomain.Add('IncomingTrafficBlocked', $getValue.AdditionalProperties.firewallProfileDomain.incomingTrafficBlocked)
        $complexFirewallProfileDomain.Add('IncomingTrafficRequired', $getValue.AdditionalProperties.firewallProfileDomain.incomingTrafficRequired)
        $complexFirewallProfileDomain.Add('OutboundConnectionsBlocked', $getValue.AdditionalProperties.firewallProfileDomain.outboundConnectionsBlocked)
        $complexFirewallProfileDomain.Add('OutboundConnectionsRequired', $getValue.AdditionalProperties.firewallProfileDomain.outboundConnectionsRequired)
        $complexFirewallProfileDomain.Add('PolicyRulesFromGroupPolicyMerged', $getValue.AdditionalProperties.firewallProfileDomain.policyRulesFromGroupPolicyMerged)
        $complexFirewallProfileDomain.Add('PolicyRulesFromGroupPolicyNotMerged', $getValue.AdditionalProperties.firewallProfileDomain.policyRulesFromGroupPolicyNotMerged)
        $complexFirewallProfileDomain.Add('SecuredPacketExemptionAllowed', $getValue.AdditionalProperties.firewallProfileDomain.securedPacketExemptionAllowed)
        $complexFirewallProfileDomain.Add('SecuredPacketExemptionBlocked', $getValue.AdditionalProperties.firewallProfileDomain.securedPacketExemptionBlocked)
        $complexFirewallProfileDomain.Add('StealthModeBlocked', $getValue.AdditionalProperties.firewallProfileDomain.stealthModeBlocked)
        $complexFirewallProfileDomain.Add('StealthModeRequired', $getValue.AdditionalProperties.firewallProfileDomain.stealthModeRequired)
        $complexFirewallProfileDomain.Add('UnicastResponsesToMulticastBroadcastsBlocked', $getValue.AdditionalProperties.firewallProfileDomain.unicastResponsesToMulticastBroadcastsBlocked)
        $complexFirewallProfileDomain.Add('UnicastResponsesToMulticastBroadcastsRequired', $getValue.AdditionalProperties.firewallProfileDomain.unicastResponsesToMulticastBroadcastsRequired)
        if ($complexFirewallProfileDomain.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexFirewallProfileDomain = $null
        }

        $complexFirewallProfilePrivate = [ordered]@{}
        $complexFirewallProfilePrivate.Add('AuthorizedApplicationRulesFromGroupPolicyMerged', $getValue.AdditionalProperties.firewallProfilePrivate.authorizedApplicationRulesFromGroupPolicyMerged)
        $complexFirewallProfilePrivate.Add('AuthorizedApplicationRulesFromGroupPolicyNotMerged', $getValue.AdditionalProperties.firewallProfilePrivate.authorizedApplicationRulesFromGroupPolicyNotMerged)
        $complexFirewallProfilePrivate.Add('ConnectionSecurityRulesFromGroupPolicyMerged', $getValue.AdditionalProperties.firewallProfilePrivate.connectionSecurityRulesFromGroupPolicyMerged)
        $complexFirewallProfilePrivate.Add('ConnectionSecurityRulesFromGroupPolicyNotMerged', $getValue.AdditionalProperties.firewallProfilePrivate.connectionSecurityRulesFromGroupPolicyNotMerged)
        if ($null -ne $getValue.AdditionalProperties.firewallProfilePrivate.firewallEnabled)
        {
            $complexFirewallProfilePrivate.Add('FirewallEnabled', $getValue.AdditionalProperties.firewallProfilePrivate.firewallEnabled.ToString())
        }
        $complexFirewallProfilePrivate.Add('GlobalPortRulesFromGroupPolicyMerged', $getValue.AdditionalProperties.firewallProfilePrivate.globalPortRulesFromGroupPolicyMerged)
        $complexFirewallProfilePrivate.Add('GlobalPortRulesFromGroupPolicyNotMerged', $getValue.AdditionalProperties.firewallProfilePrivate.globalPortRulesFromGroupPolicyNotMerged)
        $complexFirewallProfilePrivate.Add('InboundConnectionsBlocked', $getValue.AdditionalProperties.firewallProfilePrivate.inboundConnectionsBlocked)
        $complexFirewallProfilePrivate.Add('InboundConnectionsRequired', $getValue.AdditionalProperties.firewallProfilePrivate.inboundConnectionsRequired)
        $complexFirewallProfilePrivate.Add('InboundNotificationsBlocked', $getValue.AdditionalProperties.firewallProfilePrivate.inboundNotificationsBlocked)
        $complexFirewallProfilePrivate.Add('InboundNotificationsRequired', $getValue.AdditionalProperties.firewallProfilePrivate.inboundNotificationsRequired)
        $complexFirewallProfilePrivate.Add('IncomingTrafficBlocked', $getValue.AdditionalProperties.firewallProfilePrivate.incomingTrafficBlocked)
        $complexFirewallProfilePrivate.Add('IncomingTrafficRequired', $getValue.AdditionalProperties.firewallProfilePrivate.incomingTrafficRequired)
        $complexFirewallProfilePrivate.Add('OutboundConnectionsBlocked', $getValue.AdditionalProperties.firewallProfilePrivate.outboundConnectionsBlocked)
        $complexFirewallProfilePrivate.Add('OutboundConnectionsRequired', $getValue.AdditionalProperties.firewallProfilePrivate.outboundConnectionsRequired)
        $complexFirewallProfilePrivate.Add('PolicyRulesFromGroupPolicyMerged', $getValue.AdditionalProperties.firewallProfilePrivate.policyRulesFromGroupPolicyMerged)
        $complexFirewallProfilePrivate.Add('PolicyRulesFromGroupPolicyNotMerged', $getValue.AdditionalProperties.firewallProfilePrivate.policyRulesFromGroupPolicyNotMerged)
        $complexFirewallProfilePrivate.Add('SecuredPacketExemptionAllowed', $getValue.AdditionalProperties.firewallProfilePrivate.securedPacketExemptionAllowed)
        $complexFirewallProfilePrivate.Add('SecuredPacketExemptionBlocked', $getValue.AdditionalProperties.firewallProfilePrivate.securedPacketExemptionBlocked)
        $complexFirewallProfilePrivate.Add('StealthModeBlocked', $getValue.AdditionalProperties.firewallProfilePrivate.stealthModeBlocked)
        $complexFirewallProfilePrivate.Add('StealthModeRequired', $getValue.AdditionalProperties.firewallProfilePrivate.stealthModeRequired)
        $complexFirewallProfilePrivate.Add('UnicastResponsesToMulticastBroadcastsBlocked', $getValue.AdditionalProperties.firewallProfilePrivate.unicastResponsesToMulticastBroadcastsBlocked)
        $complexFirewallProfilePrivate.Add('UnicastResponsesToMulticastBroadcastsRequired', $getValue.AdditionalProperties.firewallProfilePrivate.unicastResponsesToMulticastBroadcastsRequired)
        if ($complexFirewallProfilePrivate.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexFirewallProfilePrivate = $null
        }

        $complexFirewallProfilePublic = [ordered]@{}
        $complexFirewallProfilePublic.Add('AuthorizedApplicationRulesFromGroupPolicyMerged', $getValue.AdditionalProperties.firewallProfilePublic.authorizedApplicationRulesFromGroupPolicyMerged)
        $complexFirewallProfilePublic.Add('AuthorizedApplicationRulesFromGroupPolicyNotMerged', $getValue.AdditionalProperties.firewallProfilePublic.authorizedApplicationRulesFromGroupPolicyNotMerged)
        $complexFirewallProfilePublic.Add('ConnectionSecurityRulesFromGroupPolicyMerged', $getValue.AdditionalProperties.firewallProfilePublic.connectionSecurityRulesFromGroupPolicyMerged)
        $complexFirewallProfilePublic.Add('ConnectionSecurityRulesFromGroupPolicyNotMerged', $getValue.AdditionalProperties.firewallProfilePublic.connectionSecurityRulesFromGroupPolicyNotMerged)
        if ($null -ne $getValue.AdditionalProperties.firewallProfilePublic.firewallEnabled)
        {
            $complexFirewallProfilePublic.Add('FirewallEnabled', $getValue.AdditionalProperties.firewallProfilePublic.firewallEnabled.ToString())
        }
        $complexFirewallProfilePublic.Add('GlobalPortRulesFromGroupPolicyMerged', $getValue.AdditionalProperties.firewallProfilePublic.globalPortRulesFromGroupPolicyMerged)
        $complexFirewallProfilePublic.Add('GlobalPortRulesFromGroupPolicyNotMerged', $getValue.AdditionalProperties.firewallProfilePublic.globalPortRulesFromGroupPolicyNotMerged)
        $complexFirewallProfilePublic.Add('InboundConnectionsBlocked', $getValue.AdditionalProperties.firewallProfilePublic.inboundConnectionsBlocked)
        $complexFirewallProfilePublic.Add('InboundConnectionsRequired', $getValue.AdditionalProperties.firewallProfilePublic.inboundConnectionsRequired)
        $complexFirewallProfilePublic.Add('InboundNotificationsBlocked', $getValue.AdditionalProperties.firewallProfilePublic.inboundNotificationsBlocked)
        $complexFirewallProfilePublic.Add('InboundNotificationsRequired', $getValue.AdditionalProperties.firewallProfilePublic.inboundNotificationsRequired)
        $complexFirewallProfilePublic.Add('IncomingTrafficBlocked', $getValue.AdditionalProperties.firewallProfilePublic.incomingTrafficBlocked)
        $complexFirewallProfilePublic.Add('IncomingTrafficRequired', $getValue.AdditionalProperties.firewallProfilePublic.incomingTrafficRequired)
        $complexFirewallProfilePublic.Add('OutboundConnectionsBlocked', $getValue.AdditionalProperties.firewallProfilePublic.outboundConnectionsBlocked)
        $complexFirewallProfilePublic.Add('OutboundConnectionsRequired', $getValue.AdditionalProperties.firewallProfilePublic.outboundConnectionsRequired)
        $complexFirewallProfilePublic.Add('PolicyRulesFromGroupPolicyMerged', $getValue.AdditionalProperties.firewallProfilePublic.policyRulesFromGroupPolicyMerged)
        $complexFirewallProfilePublic.Add('PolicyRulesFromGroupPolicyNotMerged', $getValue.AdditionalProperties.firewallProfilePublic.policyRulesFromGroupPolicyNotMerged)
        $complexFirewallProfilePublic.Add('SecuredPacketExemptionAllowed', $getValue.AdditionalProperties.firewallProfilePublic.securedPacketExemptionAllowed)
        $complexFirewallProfilePublic.Add('SecuredPacketExemptionBlocked', $getValue.AdditionalProperties.firewallProfilePublic.securedPacketExemptionBlocked)
        $complexFirewallProfilePublic.Add('StealthModeBlocked', $getValue.AdditionalProperties.firewallProfilePublic.stealthModeBlocked)
        $complexFirewallProfilePublic.Add('StealthModeRequired', $getValue.AdditionalProperties.firewallProfilePublic.stealthModeRequired)
        $complexFirewallProfilePublic.Add('UnicastResponsesToMulticastBroadcastsBlocked', $getValue.AdditionalProperties.firewallProfilePublic.unicastResponsesToMulticastBroadcastsBlocked)
        $complexFirewallProfilePublic.Add('UnicastResponsesToMulticastBroadcastsRequired', $getValue.AdditionalProperties.firewallProfilePublic.unicastResponsesToMulticastBroadcastsRequired)
        if ($complexFirewallProfilePublic.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexFirewallProfilePublic = $null
        }

        $complexFirewallRules = @()
        foreach ($currentfirewallRules in $getValue.AdditionalProperties.firewallRules)
        {
            $myfirewallRules = [ordered]@{}
            if ($null -ne $currentfirewallRules.action)
            {
                $myfirewallRules.Add('Action', $currentfirewallRules.action.ToString())
            }
            $myfirewallRules.Add('Description', $currentfirewallRules.description)
            $myfirewallRules.Add('DisplayName', $currentfirewallRules.displayName)
            if ($null -ne $currentfirewallRules.edgeTraversal)
            {
                $myfirewallRules.Add('EdgeTraversal', $currentfirewallRules.edgeTraversal.ToString())
            }
            $myfirewallRules.Add('FilePath', $currentfirewallRules.filePath)
            if ($null -ne $currentfirewallRules.interfaceTypes)
            {
                $myfirewallRules.Add('InterfaceTypes', $currentfirewallRules.interfaceTypes.ToString() -split ',')
            }
            $myfirewallRules.Add('LocalAddressRanges', $currentfirewallRules.localAddressRanges)
            $myfirewallRules.Add('LocalPortRanges', $currentfirewallRules.localPortRanges)
            $myfirewallRules.Add('LocalUserAuthorizations', $currentfirewallRules.localUserAuthorizations)
            $myfirewallRules.Add('PackageFamilyName', $currentfirewallRules.packageFamilyName)
            if ($null -ne $currentfirewallRules.profileTypes)
            {
                $myfirewallRules.Add('ProfileTypes', $currentfirewallRules.profileTypes.ToString())
            }
            $myfirewallRules.Add('Protocol', $currentfirewallRules.protocol)
            $myfirewallRules.Add('RemoteAddressRanges', $currentfirewallRules.remoteAddressRanges)
            $myfirewallRules.Add('RemotePortRanges', $currentfirewallRules.remotePortRanges)
            $myfirewallRules.Add('ServiceName', $currentfirewallRules.serviceName)
            if ($null -ne $currentfirewallRules.trafficDirection)
            {
                $myfirewallRules.Add('TrafficDirection', $currentfirewallRules.trafficDirection.ToString())
            }
            if ($myfirewallRules.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexFirewallRules += $myfirewallRules
            }
        }

        $complexUserRightsAccessCredentialManagerAsTrustedCaller = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.AdditionalProperties.userRightsAccessCredentialManagerAsTrustedCaller.localUsersOrGroups)
        {
            $myLocalUsersOrGroups = [ordered]@{}
            $myLocalUsersOrGroups.Add('Description', $currentLocalUsersOrGroups.description)
            $myLocalUsersOrGroups.Add('Name', $currentLocalUsersOrGroups.name)
            $myLocalUsersOrGroups.Add('SecurityIdentifier', $currentLocalUsersOrGroups.securityIdentifier)
            if ($myLocalUsersOrGroups.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexLocalUsersOrGroups += $myLocalUsersOrGroups
            }
        }
        $complexUserRightsAccessCredentialManagerAsTrustedCaller.Add('LocalUsersOrGroups', $complexLocalUsersOrGroups)
        if ($null -ne $getValue.AdditionalProperties.userRightsAccessCredentialManagerAsTrustedCaller.state)
        {
            $complexUserRightsAccessCredentialManagerAsTrustedCaller.Add('State', $getValue.AdditionalProperties.userRightsAccessCredentialManagerAsTrustedCaller.state.ToString())
        }
        if ($complexUserRightsAccessCredentialManagerAsTrustedCaller.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsAccessCredentialManagerAsTrustedCaller = $null
        }

        $complexUserRightsActAsPartOfTheOperatingSystem = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.AdditionalProperties.userRightsActAsPartOfTheOperatingSystem.localUsersOrGroups)
        {
            $myLocalUsersOrGroups = [ordered]@{}
            $myLocalUsersOrGroups.Add('Description', $currentLocalUsersOrGroups.description)
            $myLocalUsersOrGroups.Add('Name', $currentLocalUsersOrGroups.name)
            $myLocalUsersOrGroups.Add('SecurityIdentifier', $currentLocalUsersOrGroups.securityIdentifier)
            if ($myLocalUsersOrGroups.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexLocalUsersOrGroups += $myLocalUsersOrGroups
            }
        }
        $complexUserRightsActAsPartOfTheOperatingSystem.Add('LocalUsersOrGroups', $complexLocalUsersOrGroups)
        if ($null -ne $getValue.AdditionalProperties.userRightsActAsPartOfTheOperatingSystem.state)
        {
            $complexUserRightsActAsPartOfTheOperatingSystem.Add('State', $getValue.AdditionalProperties.userRightsActAsPartOfTheOperatingSystem.state.ToString())
        }
        if ($complexUserRightsActAsPartOfTheOperatingSystem.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsActAsPartOfTheOperatingSystem = $null
        }

        $complexUserRightsAllowAccessFromNetwork = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.AdditionalProperties.userRightsAllowAccessFromNetwork.localUsersOrGroups)
        {
            $myLocalUsersOrGroups = [ordered]@{}
            $myLocalUsersOrGroups.Add('Description', $currentLocalUsersOrGroups.description)
            $myLocalUsersOrGroups.Add('Name', $currentLocalUsersOrGroups.name)
            $myLocalUsersOrGroups.Add('SecurityIdentifier', $currentLocalUsersOrGroups.securityIdentifier)
            if ($myLocalUsersOrGroups.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexLocalUsersOrGroups += $myLocalUsersOrGroups
            }
        }
        $complexUserRightsAllowAccessFromNetwork.Add('LocalUsersOrGroups', $complexLocalUsersOrGroups)
        if ($null -ne $getValue.AdditionalProperties.userRightsAllowAccessFromNetwork.state)
        {
            $complexUserRightsAllowAccessFromNetwork.Add('State', $getValue.AdditionalProperties.userRightsAllowAccessFromNetwork.state.ToString())
        }
        if ($complexUserRightsAllowAccessFromNetwork.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsAllowAccessFromNetwork = $null
        }

        $complexUserRightsBackupData = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.AdditionalProperties.userRightsBackupData.localUsersOrGroups)
        {
            $myLocalUsersOrGroups = [ordered]@{}
            $myLocalUsersOrGroups.Add('Description', $currentLocalUsersOrGroups.description)
            $myLocalUsersOrGroups.Add('Name', $currentLocalUsersOrGroups.name)
            $myLocalUsersOrGroups.Add('SecurityIdentifier', $currentLocalUsersOrGroups.securityIdentifier)
            if ($myLocalUsersOrGroups.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexLocalUsersOrGroups += $myLocalUsersOrGroups
            }
        }
        $complexUserRightsBackupData.Add('LocalUsersOrGroups', $complexLocalUsersOrGroups)
        if ($null -ne $getValue.AdditionalProperties.userRightsBackupData.state)
        {
            $complexUserRightsBackupData.Add('State', $getValue.AdditionalProperties.userRightsBackupData.state.ToString())
        }
        if ($complexUserRightsBackupData.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsBackupData = $null
        }

        $complexUserRightsBlockAccessFromNetwork = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.AdditionalProperties.userRightsBlockAccessFromNetwork.localUsersOrGroups)
        {
            $myLocalUsersOrGroups = [ordered]@{}
            $myLocalUsersOrGroups.Add('Description', $currentLocalUsersOrGroups.description)
            $myLocalUsersOrGroups.Add('Name', $currentLocalUsersOrGroups.name)
            $myLocalUsersOrGroups.Add('SecurityIdentifier', $currentLocalUsersOrGroups.securityIdentifier)
            if ($myLocalUsersOrGroups.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexLocalUsersOrGroups += $myLocalUsersOrGroups
            }
        }
        $complexUserRightsBlockAccessFromNetwork.Add('LocalUsersOrGroups', $complexLocalUsersOrGroups)
        if ($null -ne $getValue.AdditionalProperties.userRightsBlockAccessFromNetwork.state)
        {
            $complexUserRightsBlockAccessFromNetwork.Add('State', $getValue.AdditionalProperties.userRightsBlockAccessFromNetwork.state.ToString())
        }
        if ($complexUserRightsBlockAccessFromNetwork.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsBlockAccessFromNetwork = $null
        }

        $complexUserRightsChangeSystemTime = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.AdditionalProperties.userRightsChangeSystemTime.localUsersOrGroups)
        {
            $myLocalUsersOrGroups = [ordered]@{}
            $myLocalUsersOrGroups.Add('Description', $currentLocalUsersOrGroups.description)
            $myLocalUsersOrGroups.Add('Name', $currentLocalUsersOrGroups.name)
            $myLocalUsersOrGroups.Add('SecurityIdentifier', $currentLocalUsersOrGroups.securityIdentifier)
            if ($myLocalUsersOrGroups.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexLocalUsersOrGroups += $myLocalUsersOrGroups
            }
        }
        $complexUserRightsChangeSystemTime.Add('LocalUsersOrGroups', $complexLocalUsersOrGroups)
        if ($null -ne $getValue.AdditionalProperties.userRightsChangeSystemTime.state)
        {
            $complexUserRightsChangeSystemTime.Add('State', $getValue.AdditionalProperties.userRightsChangeSystemTime.state.ToString())
        }
        if ($complexUserRightsChangeSystemTime.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsChangeSystemTime = $null
        }

        $complexUserRightsCreateGlobalObjects = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.AdditionalProperties.userRightsCreateGlobalObjects.localUsersOrGroups)
        {
            $myLocalUsersOrGroups = [ordered]@{}
            $myLocalUsersOrGroups.Add('Description', $currentLocalUsersOrGroups.description)
            $myLocalUsersOrGroups.Add('Name', $currentLocalUsersOrGroups.name)
            $myLocalUsersOrGroups.Add('SecurityIdentifier', $currentLocalUsersOrGroups.securityIdentifier)
            if ($myLocalUsersOrGroups.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexLocalUsersOrGroups += $myLocalUsersOrGroups
            }
        }
        $complexUserRightsCreateGlobalObjects.Add('LocalUsersOrGroups', $complexLocalUsersOrGroups)
        if ($null -ne $getValue.AdditionalProperties.userRightsCreateGlobalObjects.state)
        {
            $complexUserRightsCreateGlobalObjects.Add('State', $getValue.AdditionalProperties.userRightsCreateGlobalObjects.state.ToString())
        }
        if ($complexUserRightsCreateGlobalObjects.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsCreateGlobalObjects = $null
        }

        $complexUserRightsCreatePageFile = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.AdditionalProperties.userRightsCreatePageFile.localUsersOrGroups)
        {
            $myLocalUsersOrGroups = [ordered]@{}
            $myLocalUsersOrGroups.Add('Description', $currentLocalUsersOrGroups.description)
            $myLocalUsersOrGroups.Add('Name', $currentLocalUsersOrGroups.name)
            $myLocalUsersOrGroups.Add('SecurityIdentifier', $currentLocalUsersOrGroups.securityIdentifier)
            if ($myLocalUsersOrGroups.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexLocalUsersOrGroups += $myLocalUsersOrGroups
            }
        }
        $complexUserRightsCreatePageFile.Add('LocalUsersOrGroups', $complexLocalUsersOrGroups)
        if ($null -ne $getValue.AdditionalProperties.userRightsCreatePageFile.state)
        {
            $complexUserRightsCreatePageFile.Add('State', $getValue.AdditionalProperties.userRightsCreatePageFile.state.ToString())
        }
        if ($complexUserRightsCreatePageFile.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsCreatePageFile = $null
        }

        $complexUserRightsCreatePermanentSharedObjects = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.AdditionalProperties.userRightsCreatePermanentSharedObjects.localUsersOrGroups)
        {
            $myLocalUsersOrGroups = [ordered]@{}
            $myLocalUsersOrGroups.Add('Description', $currentLocalUsersOrGroups.description)
            $myLocalUsersOrGroups.Add('Name', $currentLocalUsersOrGroups.name)
            $myLocalUsersOrGroups.Add('SecurityIdentifier', $currentLocalUsersOrGroups.securityIdentifier)
            if ($myLocalUsersOrGroups.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexLocalUsersOrGroups += $myLocalUsersOrGroups
            }
        }
        $complexUserRightsCreatePermanentSharedObjects.Add('LocalUsersOrGroups', $complexLocalUsersOrGroups)
        if ($null -ne $getValue.AdditionalProperties.userRightsCreatePermanentSharedObjects.state)
        {
            $complexUserRightsCreatePermanentSharedObjects.Add('State', $getValue.AdditionalProperties.userRightsCreatePermanentSharedObjects.state.ToString())
        }
        if ($complexUserRightsCreatePermanentSharedObjects.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsCreatePermanentSharedObjects = $null
        }

        $complexUserRightsCreateSymbolicLinks = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.AdditionalProperties.userRightsCreateSymbolicLinks.localUsersOrGroups)
        {
            $myLocalUsersOrGroups = [ordered]@{}
            $myLocalUsersOrGroups.Add('Description', $currentLocalUsersOrGroups.description)
            $myLocalUsersOrGroups.Add('Name', $currentLocalUsersOrGroups.name)
            $myLocalUsersOrGroups.Add('SecurityIdentifier', $currentLocalUsersOrGroups.securityIdentifier)
            if ($myLocalUsersOrGroups.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexLocalUsersOrGroups += $myLocalUsersOrGroups
            }
        }
        $complexUserRightsCreateSymbolicLinks.Add('LocalUsersOrGroups', $complexLocalUsersOrGroups)
        if ($null -ne $getValue.AdditionalProperties.userRightsCreateSymbolicLinks.state)
        {
            $complexUserRightsCreateSymbolicLinks.Add('State', $getValue.AdditionalProperties.userRightsCreateSymbolicLinks.state.ToString())
        }
        if ($complexUserRightsCreateSymbolicLinks.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsCreateSymbolicLinks = $null
        }

        $complexUserRightsCreateToken = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.AdditionalProperties.userRightsCreateToken.localUsersOrGroups)
        {
            $myLocalUsersOrGroups = [ordered]@{}
            $myLocalUsersOrGroups.Add('Description', $currentLocalUsersOrGroups.description)
            $myLocalUsersOrGroups.Add('Name', $currentLocalUsersOrGroups.name)
            $myLocalUsersOrGroups.Add('SecurityIdentifier', $currentLocalUsersOrGroups.securityIdentifier)
            if ($myLocalUsersOrGroups.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexLocalUsersOrGroups += $myLocalUsersOrGroups
            }
        }
        $complexUserRightsCreateToken.Add('LocalUsersOrGroups', $complexLocalUsersOrGroups)
        if ($null -ne $getValue.AdditionalProperties.userRightsCreateToken.state)
        {
            $complexUserRightsCreateToken.Add('State', $getValue.AdditionalProperties.userRightsCreateToken.state.ToString())
        }
        if ($complexUserRightsCreateToken.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsCreateToken = $null
        }

        $complexUserRightsDebugPrograms = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.AdditionalProperties.userRightsDebugPrograms.localUsersOrGroups)
        {
            $myLocalUsersOrGroups = [ordered]@{}
            $myLocalUsersOrGroups.Add('Description', $currentLocalUsersOrGroups.description)
            $myLocalUsersOrGroups.Add('Name', $currentLocalUsersOrGroups.name)
            $myLocalUsersOrGroups.Add('SecurityIdentifier', $currentLocalUsersOrGroups.securityIdentifier)
            if ($myLocalUsersOrGroups.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexLocalUsersOrGroups += $myLocalUsersOrGroups
            }
        }
        $complexUserRightsDebugPrograms.Add('LocalUsersOrGroups', $complexLocalUsersOrGroups)
        if ($null -ne $getValue.AdditionalProperties.userRightsDebugPrograms.state)
        {
            $complexUserRightsDebugPrograms.Add('State', $getValue.AdditionalProperties.userRightsDebugPrograms.state.ToString())
        }
        if ($complexUserRightsDebugPrograms.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsDebugPrograms = $null
        }

        $complexUserRightsDelegation = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.AdditionalProperties.userRightsDelegation.localUsersOrGroups)
        {
            $myLocalUsersOrGroups = [ordered]@{}
            $myLocalUsersOrGroups.Add('Description', $currentLocalUsersOrGroups.description)
            $myLocalUsersOrGroups.Add('Name', $currentLocalUsersOrGroups.name)
            $myLocalUsersOrGroups.Add('SecurityIdentifier', $currentLocalUsersOrGroups.securityIdentifier)
            if ($myLocalUsersOrGroups.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexLocalUsersOrGroups += $myLocalUsersOrGroups
            }
        }
        $complexUserRightsDelegation.Add('LocalUsersOrGroups', $complexLocalUsersOrGroups)
        if ($null -ne $getValue.AdditionalProperties.userRightsDelegation.state)
        {
            $complexUserRightsDelegation.Add('State', $getValue.AdditionalProperties.userRightsDelegation.state.ToString())
        }
        if ($complexUserRightsDelegation.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsDelegation = $null
        }

        $complexUserRightsDenyLocalLogOn = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.AdditionalProperties.userRightsDenyLocalLogOn.localUsersOrGroups)
        {
            $myLocalUsersOrGroups = [ordered]@{}
            $myLocalUsersOrGroups.Add('Description', $currentLocalUsersOrGroups.description)
            $myLocalUsersOrGroups.Add('Name', $currentLocalUsersOrGroups.name)
            $myLocalUsersOrGroups.Add('SecurityIdentifier', $currentLocalUsersOrGroups.securityIdentifier)
            if ($myLocalUsersOrGroups.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexLocalUsersOrGroups += $myLocalUsersOrGroups
            }
        }
        $complexUserRightsDenyLocalLogOn.Add('LocalUsersOrGroups', $complexLocalUsersOrGroups)
        if ($null -ne $getValue.AdditionalProperties.userRightsDenyLocalLogOn.state)
        {
            $complexUserRightsDenyLocalLogOn.Add('State', $getValue.AdditionalProperties.userRightsDenyLocalLogOn.state.ToString())
        }
        if ($complexUserRightsDenyLocalLogOn.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsDenyLocalLogOn = $null
        }

        $complexUserRightsGenerateSecurityAudits = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.AdditionalProperties.userRightsGenerateSecurityAudits.localUsersOrGroups)
        {
            $myLocalUsersOrGroups = [ordered]@{}
            $myLocalUsersOrGroups.Add('Description', $currentLocalUsersOrGroups.description)
            $myLocalUsersOrGroups.Add('Name', $currentLocalUsersOrGroups.name)
            $myLocalUsersOrGroups.Add('SecurityIdentifier', $currentLocalUsersOrGroups.securityIdentifier)
            if ($myLocalUsersOrGroups.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexLocalUsersOrGroups += $myLocalUsersOrGroups
            }
        }
        $complexUserRightsGenerateSecurityAudits.Add('LocalUsersOrGroups', $complexLocalUsersOrGroups)
        if ($null -ne $getValue.AdditionalProperties.userRightsGenerateSecurityAudits.state)
        {
            $complexUserRightsGenerateSecurityAudits.Add('State', $getValue.AdditionalProperties.userRightsGenerateSecurityAudits.state.ToString())
        }
        if ($complexUserRightsGenerateSecurityAudits.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsGenerateSecurityAudits = $null
        }

        $complexUserRightsImpersonateClient = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.AdditionalProperties.userRightsImpersonateClient.localUsersOrGroups)
        {
            $myLocalUsersOrGroups = [ordered]@{}
            $myLocalUsersOrGroups.Add('Description', $currentLocalUsersOrGroups.description)
            $myLocalUsersOrGroups.Add('Name', $currentLocalUsersOrGroups.name)
            $myLocalUsersOrGroups.Add('SecurityIdentifier', $currentLocalUsersOrGroups.securityIdentifier)
            if ($myLocalUsersOrGroups.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexLocalUsersOrGroups += $myLocalUsersOrGroups
            }
        }
        $complexUserRightsImpersonateClient.Add('LocalUsersOrGroups', $complexLocalUsersOrGroups)
        if ($null -ne $getValue.AdditionalProperties.userRightsImpersonateClient.state)
        {
            $complexUserRightsImpersonateClient.Add('State', $getValue.AdditionalProperties.userRightsImpersonateClient.state.ToString())
        }
        if ($complexUserRightsImpersonateClient.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsImpersonateClient = $null
        }

        $complexUserRightsIncreaseSchedulingPriority = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.AdditionalProperties.userRightsIncreaseSchedulingPriority.localUsersOrGroups)
        {
            $myLocalUsersOrGroups = [ordered]@{}
            $myLocalUsersOrGroups.Add('Description', $currentLocalUsersOrGroups.description)
            $myLocalUsersOrGroups.Add('Name', $currentLocalUsersOrGroups.name)
            $myLocalUsersOrGroups.Add('SecurityIdentifier', $currentLocalUsersOrGroups.securityIdentifier)
            if ($myLocalUsersOrGroups.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexLocalUsersOrGroups += $myLocalUsersOrGroups
            }
        }
        $complexUserRightsIncreaseSchedulingPriority.Add('LocalUsersOrGroups', $complexLocalUsersOrGroups)
        if ($null -ne $getValue.AdditionalProperties.userRightsIncreaseSchedulingPriority.state)
        {
            $complexUserRightsIncreaseSchedulingPriority.Add('State', $getValue.AdditionalProperties.userRightsIncreaseSchedulingPriority.state.ToString())
        }
        if ($complexUserRightsIncreaseSchedulingPriority.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsIncreaseSchedulingPriority = $null
        }

        $complexUserRightsLoadUnloadDrivers = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.AdditionalProperties.userRightsLoadUnloadDrivers.localUsersOrGroups)
        {
            $myLocalUsersOrGroups = [ordered]@{}
            $myLocalUsersOrGroups.Add('Description', $currentLocalUsersOrGroups.description)
            $myLocalUsersOrGroups.Add('Name', $currentLocalUsersOrGroups.name)
            $myLocalUsersOrGroups.Add('SecurityIdentifier', $currentLocalUsersOrGroups.securityIdentifier)
            if ($myLocalUsersOrGroups.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexLocalUsersOrGroups += $myLocalUsersOrGroups
            }
        }
        $complexUserRightsLoadUnloadDrivers.Add('LocalUsersOrGroups', $complexLocalUsersOrGroups)
        if ($null -ne $getValue.AdditionalProperties.userRightsLoadUnloadDrivers.state)
        {
            $complexUserRightsLoadUnloadDrivers.Add('State', $getValue.AdditionalProperties.userRightsLoadUnloadDrivers.state.ToString())
        }
        if ($complexUserRightsLoadUnloadDrivers.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsLoadUnloadDrivers = $null
        }

        $complexUserRightsLocalLogOn = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.AdditionalProperties.userRightsLocalLogOn.localUsersOrGroups)
        {
            $myLocalUsersOrGroups = [ordered]@{}
            $myLocalUsersOrGroups.Add('Description', $currentLocalUsersOrGroups.description)
            $myLocalUsersOrGroups.Add('Name', $currentLocalUsersOrGroups.name)
            $myLocalUsersOrGroups.Add('SecurityIdentifier', $currentLocalUsersOrGroups.securityIdentifier)
            if ($myLocalUsersOrGroups.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexLocalUsersOrGroups += $myLocalUsersOrGroups
            }
        }
        $complexUserRightsLocalLogOn.Add('LocalUsersOrGroups', $complexLocalUsersOrGroups)
        if ($null -ne $getValue.AdditionalProperties.userRightsLocalLogOn.state)
        {
            $complexUserRightsLocalLogOn.Add('State', $getValue.AdditionalProperties.userRightsLocalLogOn.state.ToString())
        }
        if ($complexUserRightsLocalLogOn.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsLocalLogOn = $null
        }

        $complexUserRightsLockMemory = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.AdditionalProperties.userRightsLockMemory.localUsersOrGroups)
        {
            $myLocalUsersOrGroups = [ordered]@{}
            $myLocalUsersOrGroups.Add('Description', $currentLocalUsersOrGroups.description)
            $myLocalUsersOrGroups.Add('Name', $currentLocalUsersOrGroups.name)
            $myLocalUsersOrGroups.Add('SecurityIdentifier', $currentLocalUsersOrGroups.securityIdentifier)
            if ($myLocalUsersOrGroups.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexLocalUsersOrGroups += $myLocalUsersOrGroups
            }
        }
        $complexUserRightsLockMemory.Add('LocalUsersOrGroups', $complexLocalUsersOrGroups)
        if ($null -ne $getValue.AdditionalProperties.userRightsLockMemory.state)
        {
            $complexUserRightsLockMemory.Add('State', $getValue.AdditionalProperties.userRightsLockMemory.state.ToString())
        }
        if ($complexUserRightsLockMemory.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsLockMemory = $null
        }

        $complexUserRightsManageAuditingAndSecurityLogs = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.AdditionalProperties.userRightsManageAuditingAndSecurityLogs.localUsersOrGroups)
        {
            $myLocalUsersOrGroups = [ordered]@{}
            $myLocalUsersOrGroups.Add('Description', $currentLocalUsersOrGroups.description)
            $myLocalUsersOrGroups.Add('Name', $currentLocalUsersOrGroups.name)
            $myLocalUsersOrGroups.Add('SecurityIdentifier', $currentLocalUsersOrGroups.securityIdentifier)
            if ($myLocalUsersOrGroups.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexLocalUsersOrGroups += $myLocalUsersOrGroups
            }
        }
        $complexUserRightsManageAuditingAndSecurityLogs.Add('LocalUsersOrGroups', $complexLocalUsersOrGroups)
        if ($null -ne $getValue.AdditionalProperties.userRightsManageAuditingAndSecurityLogs.state)
        {
            $complexUserRightsManageAuditingAndSecurityLogs.Add('State', $getValue.AdditionalProperties.userRightsManageAuditingAndSecurityLogs.state.ToString())
        }
        if ($complexUserRightsManageAuditingAndSecurityLogs.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsManageAuditingAndSecurityLogs = $null
        }

        $complexUserRightsManageVolumes = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.AdditionalProperties.userRightsManageVolumes.localUsersOrGroups)
        {
            $myLocalUsersOrGroups = [ordered]@{}
            $myLocalUsersOrGroups.Add('Description', $currentLocalUsersOrGroups.description)
            $myLocalUsersOrGroups.Add('Name', $currentLocalUsersOrGroups.name)
            $myLocalUsersOrGroups.Add('SecurityIdentifier', $currentLocalUsersOrGroups.securityIdentifier)
            if ($myLocalUsersOrGroups.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexLocalUsersOrGroups += $myLocalUsersOrGroups
            }
        }
        $complexUserRightsManageVolumes.Add('LocalUsersOrGroups', $complexLocalUsersOrGroups)
        if ($null -ne $getValue.AdditionalProperties.userRightsManageVolumes.state)
        {
            $complexUserRightsManageVolumes.Add('State', $getValue.AdditionalProperties.userRightsManageVolumes.state.ToString())
        }
        if ($complexUserRightsManageVolumes.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsManageVolumes = $null
        }

        $complexUserRightsModifyFirmwareEnvironment = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.AdditionalProperties.userRightsModifyFirmwareEnvironment.localUsersOrGroups)
        {
            $myLocalUsersOrGroups = [ordered]@{}
            $myLocalUsersOrGroups.Add('Description', $currentLocalUsersOrGroups.description)
            $myLocalUsersOrGroups.Add('Name', $currentLocalUsersOrGroups.name)
            $myLocalUsersOrGroups.Add('SecurityIdentifier', $currentLocalUsersOrGroups.securityIdentifier)
            if ($myLocalUsersOrGroups.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexLocalUsersOrGroups += $myLocalUsersOrGroups
            }
        }
        $complexUserRightsModifyFirmwareEnvironment.Add('LocalUsersOrGroups', $complexLocalUsersOrGroups)
        if ($null -ne $getValue.AdditionalProperties.userRightsModifyFirmwareEnvironment.state)
        {
            $complexUserRightsModifyFirmwareEnvironment.Add('State', $getValue.AdditionalProperties.userRightsModifyFirmwareEnvironment.state.ToString())
        }
        if ($complexUserRightsModifyFirmwareEnvironment.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsModifyFirmwareEnvironment = $null
        }

        $complexUserRightsModifyObjectLabels = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.AdditionalProperties.userRightsModifyObjectLabels.localUsersOrGroups)
        {
            $myLocalUsersOrGroups = [ordered]@{}
            $myLocalUsersOrGroups.Add('Description', $currentLocalUsersOrGroups.description)
            $myLocalUsersOrGroups.Add('Name', $currentLocalUsersOrGroups.name)
            $myLocalUsersOrGroups.Add('SecurityIdentifier', $currentLocalUsersOrGroups.securityIdentifier)
            if ($myLocalUsersOrGroups.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexLocalUsersOrGroups += $myLocalUsersOrGroups
            }
        }
        $complexUserRightsModifyObjectLabels.Add('LocalUsersOrGroups', $complexLocalUsersOrGroups)
        if ($null -ne $getValue.AdditionalProperties.userRightsModifyObjectLabels.state)
        {
            $complexUserRightsModifyObjectLabels.Add('State', $getValue.AdditionalProperties.userRightsModifyObjectLabels.state.ToString())
        }
        if ($complexUserRightsModifyObjectLabels.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsModifyObjectLabels = $null
        }

        $complexUserRightsProfileSingleProcess = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.AdditionalProperties.userRightsProfileSingleProcess.localUsersOrGroups)
        {
            $myLocalUsersOrGroups = [ordered]@{}
            $myLocalUsersOrGroups.Add('Description', $currentLocalUsersOrGroups.description)
            $myLocalUsersOrGroups.Add('Name', $currentLocalUsersOrGroups.name)
            $myLocalUsersOrGroups.Add('SecurityIdentifier', $currentLocalUsersOrGroups.securityIdentifier)
            if ($myLocalUsersOrGroups.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexLocalUsersOrGroups += $myLocalUsersOrGroups
            }
        }
        $complexUserRightsProfileSingleProcess.Add('LocalUsersOrGroups', $complexLocalUsersOrGroups)
        if ($null -ne $getValue.AdditionalProperties.userRightsProfileSingleProcess.state)
        {
            $complexUserRightsProfileSingleProcess.Add('State', $getValue.AdditionalProperties.userRightsProfileSingleProcess.state.ToString())
        }
        if ($complexUserRightsProfileSingleProcess.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsProfileSingleProcess = $null
        }

        $complexUserRightsRemoteDesktopServicesLogOn = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.AdditionalProperties.userRightsRemoteDesktopServicesLogOn.localUsersOrGroups)
        {
            $myLocalUsersOrGroups = [ordered]@{}
            $myLocalUsersOrGroups.Add('Description', $currentLocalUsersOrGroups.description)
            $myLocalUsersOrGroups.Add('Name', $currentLocalUsersOrGroups.name)
            $myLocalUsersOrGroups.Add('SecurityIdentifier', $currentLocalUsersOrGroups.securityIdentifier)
            if ($myLocalUsersOrGroups.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexLocalUsersOrGroups += $myLocalUsersOrGroups
            }
        }
        $complexUserRightsRemoteDesktopServicesLogOn.Add('LocalUsersOrGroups', $complexLocalUsersOrGroups)
        if ($null -ne $getValue.AdditionalProperties.userRightsRemoteDesktopServicesLogOn.state)
        {
            $complexUserRightsRemoteDesktopServicesLogOn.Add('State', $getValue.AdditionalProperties.userRightsRemoteDesktopServicesLogOn.state.ToString())
        }
        if ($complexUserRightsRemoteDesktopServicesLogOn.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsRemoteDesktopServicesLogOn = $null
        }

        $complexUserRightsRemoteShutdown = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.AdditionalProperties.userRightsRemoteShutdown.localUsersOrGroups)
        {
            $myLocalUsersOrGroups = [ordered]@{}
            $myLocalUsersOrGroups.Add('Description', $currentLocalUsersOrGroups.description)
            $myLocalUsersOrGroups.Add('Name', $currentLocalUsersOrGroups.name)
            $myLocalUsersOrGroups.Add('SecurityIdentifier', $currentLocalUsersOrGroups.securityIdentifier)
            if ($myLocalUsersOrGroups.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexLocalUsersOrGroups += $myLocalUsersOrGroups
            }
        }
        $complexUserRightsRemoteShutdown.Add('LocalUsersOrGroups', $complexLocalUsersOrGroups)
        if ($null -ne $getValue.AdditionalProperties.userRightsRemoteShutdown.state)
        {
            $complexUserRightsRemoteShutdown.Add('State', $getValue.AdditionalProperties.userRightsRemoteShutdown.state.ToString())
        }
        if ($complexUserRightsRemoteShutdown.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsRemoteShutdown = $null
        }

        $complexUserRightsRestoreData = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.AdditionalProperties.userRightsRestoreData.localUsersOrGroups)
        {
            $myLocalUsersOrGroups = [ordered]@{}
            $myLocalUsersOrGroups.Add('Description', $currentLocalUsersOrGroups.description)
            $myLocalUsersOrGroups.Add('Name', $currentLocalUsersOrGroups.name)
            $myLocalUsersOrGroups.Add('SecurityIdentifier', $currentLocalUsersOrGroups.securityIdentifier)
            if ($myLocalUsersOrGroups.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexLocalUsersOrGroups += $myLocalUsersOrGroups
            }
        }
        $complexUserRightsRestoreData.Add('LocalUsersOrGroups', $complexLocalUsersOrGroups)
        if ($null -ne $getValue.AdditionalProperties.userRightsRestoreData.state)
        {
            $complexUserRightsRestoreData.Add('State', $getValue.AdditionalProperties.userRightsRestoreData.state.ToString())
        }
        if ($complexUserRightsRestoreData.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsRestoreData = $null
        }

        $complexUserRightsTakeOwnership = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.AdditionalProperties.userRightsTakeOwnership.localUsersOrGroups)
        {
            $myLocalUsersOrGroups = [ordered]@{}
            $myLocalUsersOrGroups.Add('Description', $currentLocalUsersOrGroups.description)
            $myLocalUsersOrGroups.Add('Name', $currentLocalUsersOrGroups.name)
            $myLocalUsersOrGroups.Add('SecurityIdentifier', $currentLocalUsersOrGroups.securityIdentifier)
            if ($myLocalUsersOrGroups.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexLocalUsersOrGroups += $myLocalUsersOrGroups
            }
        }
        $complexUserRightsTakeOwnership.Add('LocalUsersOrGroups', $complexLocalUsersOrGroups)
        if ($null -ne $getValue.AdditionalProperties.userRightsTakeOwnership.state)
        {
            $complexUserRightsTakeOwnership.Add('State', $getValue.AdditionalProperties.userRightsTakeOwnership.state.ToString())
        }
        if ($complexUserRightsTakeOwnership.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsTakeOwnership = $null
        }

        #endregion

        #region resource generator code
        $enumApplicationGuardBlockClipboardSharing = $null
        if ($null -ne $getValue.AdditionalProperties.applicationGuardBlockClipboardSharing)
        {
            $enumApplicationGuardBlockClipboardSharing = $getValue.AdditionalProperties.applicationGuardBlockClipboardSharing.ToString()
        }

        $enumApplicationGuardBlockFileTransfer = $null
        if ($null -ne $getValue.AdditionalProperties.applicationGuardBlockFileTransfer)
        {
            $enumApplicationGuardBlockFileTransfer = $getValue.AdditionalProperties.applicationGuardBlockFileTransfer.ToString()
        }

        $enumApplicationGuardEnabledOptions = $null
        if ($null -ne $getValue.AdditionalProperties.applicationGuardEnabledOptions)
        {
            $enumApplicationGuardEnabledOptions = $getValue.AdditionalProperties.applicationGuardEnabledOptions.ToString()
        }

        $enumAppLockerApplicationControl = $null
        if ($null -ne $getValue.AdditionalProperties.appLockerApplicationControl)
        {
            $enumAppLockerApplicationControl = $getValue.AdditionalProperties.appLockerApplicationControl.ToString()
        }

        $enumBitLockerRecoveryPasswordRotation = $null
        if ($null -ne $getValue.AdditionalProperties.bitLockerRecoveryPasswordRotation)
        {
            $enumBitLockerRecoveryPasswordRotation = $getValue.AdditionalProperties.bitLockerRecoveryPasswordRotation.ToString()
        }

        $enumDefenderAdobeReaderLaunchChildProcess = $null
        if ($null -ne $getValue.AdditionalProperties.defenderAdobeReaderLaunchChildProcess)
        {
            $enumDefenderAdobeReaderLaunchChildProcess = $getValue.AdditionalProperties.defenderAdobeReaderLaunchChildProcess.ToString()
        }

        $enumDefenderAdvancedRansomewareProtectionType = $null
        if ($null -ne $getValue.AdditionalProperties.defenderAdvancedRansomewareProtectionType)
        {
            $enumDefenderAdvancedRansomewareProtectionType = $getValue.AdditionalProperties.defenderAdvancedRansomewareProtectionType.ToString()
        }

        $enumDefenderBlockPersistenceThroughWmiType = $null
        if ($null -ne $getValue.AdditionalProperties.defenderBlockPersistenceThroughWmiType)
        {
            $enumDefenderBlockPersistenceThroughWmiType = $getValue.AdditionalProperties.defenderBlockPersistenceThroughWmiType.ToString()
        }

        $enumDefenderCloudBlockLevel = $null
        if ($null -ne $getValue.AdditionalProperties.defenderCloudBlockLevel)
        {
            $enumDefenderCloudBlockLevel = $getValue.AdditionalProperties.defenderCloudBlockLevel.ToString()
        }

        $enumDefenderEmailContentExecution = $null
        if ($null -ne $getValue.AdditionalProperties.defenderEmailContentExecution)
        {
            $enumDefenderEmailContentExecution = $getValue.AdditionalProperties.defenderEmailContentExecution.ToString()
        }

        $enumDefenderEmailContentExecutionType = $null
        if ($null -ne $getValue.AdditionalProperties.defenderEmailContentExecutionType)
        {
            $enumDefenderEmailContentExecutionType = $getValue.AdditionalProperties.defenderEmailContentExecutionType.ToString()
        }

        $enumDefenderGuardMyFoldersType = $null
        if ($null -ne $getValue.AdditionalProperties.defenderGuardMyFoldersType)
        {
            $enumDefenderGuardMyFoldersType = $getValue.AdditionalProperties.defenderGuardMyFoldersType.ToString()
        }

        $enumDefenderNetworkProtectionType = $null
        if ($null -ne $getValue.AdditionalProperties.defenderNetworkProtectionType)
        {
            $enumDefenderNetworkProtectionType = $getValue.AdditionalProperties.defenderNetworkProtectionType.ToString()
        }

        $enumDefenderOfficeAppsExecutableContentCreationOrLaunch = $null
        if ($null -ne $getValue.AdditionalProperties.defenderOfficeAppsExecutableContentCreationOrLaunch)
        {
            $enumDefenderOfficeAppsExecutableContentCreationOrLaunch = $getValue.AdditionalProperties.defenderOfficeAppsExecutableContentCreationOrLaunch.ToString()
        }

        $enumDefenderOfficeAppsExecutableContentCreationOrLaunchType = $null
        if ($null -ne $getValue.AdditionalProperties.defenderOfficeAppsExecutableContentCreationOrLaunchType)
        {
            $enumDefenderOfficeAppsExecutableContentCreationOrLaunchType = $getValue.AdditionalProperties.defenderOfficeAppsExecutableContentCreationOrLaunchType.ToString()
        }

        $enumDefenderOfficeAppsLaunchChildProcess = $null
        if ($null -ne $getValue.AdditionalProperties.defenderOfficeAppsLaunchChildProcess)
        {
            $enumDefenderOfficeAppsLaunchChildProcess = $getValue.AdditionalProperties.defenderOfficeAppsLaunchChildProcess.ToString()
        }

        $enumDefenderOfficeAppsLaunchChildProcessType = $null
        if ($null -ne $getValue.AdditionalProperties.defenderOfficeAppsLaunchChildProcessType)
        {
            $enumDefenderOfficeAppsLaunchChildProcessType = $getValue.AdditionalProperties.defenderOfficeAppsLaunchChildProcessType.ToString()
        }

        $enumDefenderOfficeAppsOtherProcessInjection = $null
        if ($null -ne $getValue.AdditionalProperties.defenderOfficeAppsOtherProcessInjection)
        {
            $enumDefenderOfficeAppsOtherProcessInjection = $getValue.AdditionalProperties.defenderOfficeAppsOtherProcessInjection.ToString()
        }

        $enumDefenderOfficeAppsOtherProcessInjectionType = $null
        if ($null -ne $getValue.AdditionalProperties.defenderOfficeAppsOtherProcessInjectionType)
        {
            $enumDefenderOfficeAppsOtherProcessInjectionType = $getValue.AdditionalProperties.defenderOfficeAppsOtherProcessInjectionType.ToString()
        }

        $enumDefenderOfficeCommunicationAppsLaunchChildProcess = $null
        if ($null -ne $getValue.AdditionalProperties.defenderOfficeCommunicationAppsLaunchChildProcess)
        {
            $enumDefenderOfficeCommunicationAppsLaunchChildProcess = $getValue.AdditionalProperties.defenderOfficeCommunicationAppsLaunchChildProcess.ToString()
        }

        $enumDefenderOfficeMacroCodeAllowWin32Imports = $null
        if ($null -ne $getValue.AdditionalProperties.defenderOfficeMacroCodeAllowWin32Imports)
        {
            $enumDefenderOfficeMacroCodeAllowWin32Imports = $getValue.AdditionalProperties.defenderOfficeMacroCodeAllowWin32Imports.ToString()
        }

        $enumDefenderOfficeMacroCodeAllowWin32ImportsType = $null
        if ($null -ne $getValue.AdditionalProperties.defenderOfficeMacroCodeAllowWin32ImportsType)
        {
            $enumDefenderOfficeMacroCodeAllowWin32ImportsType = $getValue.AdditionalProperties.defenderOfficeMacroCodeAllowWin32ImportsType.ToString()
        }

        $enumDefenderPotentiallyUnwantedAppAction = $null
        if ($null -ne $getValue.AdditionalProperties.defenderPotentiallyUnwantedAppAction)
        {
            $enumDefenderPotentiallyUnwantedAppAction = $getValue.AdditionalProperties.defenderPotentiallyUnwantedAppAction.ToString()
        }

        $enumDefenderPreventCredentialStealingType = $null
        if ($null -ne $getValue.AdditionalProperties.defenderPreventCredentialStealingType)
        {
            $enumDefenderPreventCredentialStealingType = $getValue.AdditionalProperties.defenderPreventCredentialStealingType.ToString()
        }

        $enumDefenderProcessCreation = $null
        if ($null -ne $getValue.AdditionalProperties.defenderProcessCreation)
        {
            $enumDefenderProcessCreation = $getValue.AdditionalProperties.defenderProcessCreation.ToString()
        }

        $enumDefenderProcessCreationType = $null
        if ($null -ne $getValue.AdditionalProperties.defenderProcessCreationType)
        {
            $enumDefenderProcessCreationType = $getValue.AdditionalProperties.defenderProcessCreationType.ToString()
        }

        $enumDefenderScanDirection = $null
        if ($null -ne $getValue.AdditionalProperties.defenderScanDirection)
        {
            $enumDefenderScanDirection = $getValue.AdditionalProperties.defenderScanDirection.ToString()
        }

        $enumDefenderScanType = $null
        if ($null -ne $getValue.AdditionalProperties.defenderScanType)
        {
            $enumDefenderScanType = $getValue.AdditionalProperties.defenderScanType.ToString()
        }

        $enumDefenderScheduledScanDay = $null
        if ($null -ne $getValue.AdditionalProperties.defenderScheduledScanDay)
        {
            $enumDefenderScheduledScanDay = $getValue.AdditionalProperties.defenderScheduledScanDay.ToString()
        }

        $enumDefenderScriptDownloadedPayloadExecution = $null
        if ($null -ne $getValue.AdditionalProperties.defenderScriptDownloadedPayloadExecution)
        {
            $enumDefenderScriptDownloadedPayloadExecution = $getValue.AdditionalProperties.defenderScriptDownloadedPayloadExecution.ToString()
        }

        $enumDefenderScriptDownloadedPayloadExecutionType = $null
        if ($null -ne $getValue.AdditionalProperties.defenderScriptDownloadedPayloadExecutionType)
        {
            $enumDefenderScriptDownloadedPayloadExecutionType = $getValue.AdditionalProperties.defenderScriptDownloadedPayloadExecutionType.ToString()
        }

        $enumDefenderScriptObfuscatedMacroCode = $null
        if ($null -ne $getValue.AdditionalProperties.defenderScriptObfuscatedMacroCode)
        {
            $enumDefenderScriptObfuscatedMacroCode = $getValue.AdditionalProperties.defenderScriptObfuscatedMacroCode.ToString()
        }

        $enumDefenderScriptObfuscatedMacroCodeType = $null
        if ($null -ne $getValue.AdditionalProperties.defenderScriptObfuscatedMacroCodeType)
        {
            $enumDefenderScriptObfuscatedMacroCodeType = $getValue.AdditionalProperties.defenderScriptObfuscatedMacroCodeType.ToString()
        }

        $enumDefenderSecurityCenterITContactDisplay = $null
        if ($null -ne $getValue.AdditionalProperties.defenderSecurityCenterITContactDisplay)
        {
            $enumDefenderSecurityCenterITContactDisplay = $getValue.AdditionalProperties.defenderSecurityCenterITContactDisplay.ToString()
        }

        $enumDefenderSecurityCenterNotificationsFromApp = $null
        if ($null -ne $getValue.AdditionalProperties.defenderSecurityCenterNotificationsFromApp)
        {
            $enumDefenderSecurityCenterNotificationsFromApp = $getValue.AdditionalProperties.defenderSecurityCenterNotificationsFromApp.ToString()
        }

        $enumDefenderSubmitSamplesConsentType = $null
        if ($null -ne $getValue.AdditionalProperties.defenderSubmitSamplesConsentType)
        {
            $enumDefenderSubmitSamplesConsentType = $getValue.AdditionalProperties.defenderSubmitSamplesConsentType.ToString()
        }

        $enumDefenderUntrustedExecutable = $null
        if ($null -ne $getValue.AdditionalProperties.defenderUntrustedExecutable)
        {
            $enumDefenderUntrustedExecutable = $getValue.AdditionalProperties.defenderUntrustedExecutable.ToString()
        }

        $enumDefenderUntrustedExecutableType = $null
        if ($null -ne $getValue.AdditionalProperties.defenderUntrustedExecutableType)
        {
            $enumDefenderUntrustedExecutableType = $getValue.AdditionalProperties.defenderUntrustedExecutableType.ToString()
        }

        $enumDefenderUntrustedUSBProcess = $null
        if ($null -ne $getValue.AdditionalProperties.defenderUntrustedUSBProcess)
        {
            $enumDefenderUntrustedUSBProcess = $getValue.AdditionalProperties.defenderUntrustedUSBProcess.ToString()
        }

        $enumDefenderUntrustedUSBProcessType = $null
        if ($null -ne $getValue.AdditionalProperties.defenderUntrustedUSBProcessType)
        {
            $enumDefenderUntrustedUSBProcessType = $getValue.AdditionalProperties.defenderUntrustedUSBProcessType.ToString()
        }

        $enumDeviceGuardLaunchSystemGuard = $null
        if ($null -ne $getValue.AdditionalProperties.deviceGuardLaunchSystemGuard)
        {
            $enumDeviceGuardLaunchSystemGuard = $getValue.AdditionalProperties.deviceGuardLaunchSystemGuard.ToString()
        }

        $enumDeviceGuardLocalSystemAuthorityCredentialGuardSettings = $null
        if ($null -ne $getValue.AdditionalProperties.deviceGuardLocalSystemAuthorityCredentialGuardSettings)
        {
            $enumDeviceGuardLocalSystemAuthorityCredentialGuardSettings = $getValue.AdditionalProperties.deviceGuardLocalSystemAuthorityCredentialGuardSettings.ToString()
        }

        $enumDeviceGuardSecureBootWithDMA = $null
        if ($null -ne $getValue.AdditionalProperties.deviceGuardSecureBootWithDMA)
        {
            $enumDeviceGuardSecureBootWithDMA = $getValue.AdditionalProperties.deviceGuardSecureBootWithDMA.ToString()
        }

        $enumDmaGuardDeviceEnumerationPolicy = $null
        if ($null -ne $getValue.AdditionalProperties.dmaGuardDeviceEnumerationPolicy)
        {
            $enumDmaGuardDeviceEnumerationPolicy = $getValue.AdditionalProperties.dmaGuardDeviceEnumerationPolicy.ToString()
        }

        $enumFirewallCertificateRevocationListCheckMethod = $null
        if ($null -ne $getValue.AdditionalProperties.firewallCertificateRevocationListCheckMethod)
        {
            $enumFirewallCertificateRevocationListCheckMethod = $getValue.AdditionalProperties.firewallCertificateRevocationListCheckMethod.ToString()
        }

        $enumFirewallPacketQueueingMethod = $null
        if ($null -ne $getValue.AdditionalProperties.firewallPacketQueueingMethod)
        {
            $enumFirewallPacketQueueingMethod = $getValue.AdditionalProperties.firewallPacketQueueingMethod.ToString()
        }

        $enumFirewallPreSharedKeyEncodingMethod = $null
        if ($null -ne $getValue.AdditionalProperties.firewallPreSharedKeyEncodingMethod)
        {
            $enumFirewallPreSharedKeyEncodingMethod = $getValue.AdditionalProperties.firewallPreSharedKeyEncodingMethod.ToString()
        }

        $enumLanManagerAuthenticationLevel = $null
        if ($null -ne $getValue.AdditionalProperties.lanManagerAuthenticationLevel)
        {
            $enumLanManagerAuthenticationLevel = $getValue.AdditionalProperties.lanManagerAuthenticationLevel.ToString()
        }

        $enumLocalSecurityOptionsAdministratorElevationPromptBehavior = $null
        if ($null -ne $getValue.AdditionalProperties.localSecurityOptionsAdministratorElevationPromptBehavior)
        {
            $enumLocalSecurityOptionsAdministratorElevationPromptBehavior = $getValue.AdditionalProperties.localSecurityOptionsAdministratorElevationPromptBehavior.ToString()
        }

        $enumLocalSecurityOptionsFormatAndEjectOfRemovableMediaAllowedUser = $null
        if ($null -ne $getValue.AdditionalProperties.localSecurityOptionsFormatAndEjectOfRemovableMediaAllowedUser)
        {
            $enumLocalSecurityOptionsFormatAndEjectOfRemovableMediaAllowedUser = $getValue.AdditionalProperties.localSecurityOptionsFormatAndEjectOfRemovableMediaAllowedUser.ToString()
        }

        $enumLocalSecurityOptionsInformationDisplayedOnLockScreen = $null
        if ($null -ne $getValue.AdditionalProperties.localSecurityOptionsInformationDisplayedOnLockScreen)
        {
            $enumLocalSecurityOptionsInformationDisplayedOnLockScreen = $getValue.AdditionalProperties.localSecurityOptionsInformationDisplayedOnLockScreen.ToString()
        }

        $enumLocalSecurityOptionsInformationShownOnLockScreen = $null
        if ($null -ne $getValue.AdditionalProperties.localSecurityOptionsInformationShownOnLockScreen)
        {
            $enumLocalSecurityOptionsInformationShownOnLockScreen = $getValue.AdditionalProperties.localSecurityOptionsInformationShownOnLockScreen.ToString()
        }

        $enumLocalSecurityOptionsMinimumSessionSecurityForNtlmSspBasedClients = $null
        if ($null -ne $getValue.AdditionalProperties.localSecurityOptionsMinimumSessionSecurityForNtlmSspBasedClients)
        {
            $enumLocalSecurityOptionsMinimumSessionSecurityForNtlmSspBasedClients = $getValue.AdditionalProperties.localSecurityOptionsMinimumSessionSecurityForNtlmSspBasedClients.ToString()
        }

        $enumLocalSecurityOptionsMinimumSessionSecurityForNtlmSspBasedServers = $null
        if ($null -ne $getValue.AdditionalProperties.localSecurityOptionsMinimumSessionSecurityForNtlmSspBasedServers)
        {
            $enumLocalSecurityOptionsMinimumSessionSecurityForNtlmSspBasedServers = $getValue.AdditionalProperties.localSecurityOptionsMinimumSessionSecurityForNtlmSspBasedServers.ToString()
        }

        $enumLocalSecurityOptionsSmartCardRemovalBehavior = $null
        if ($null -ne $getValue.AdditionalProperties.localSecurityOptionsSmartCardRemovalBehavior)
        {
            $enumLocalSecurityOptionsSmartCardRemovalBehavior = $getValue.AdditionalProperties.localSecurityOptionsSmartCardRemovalBehavior.ToString()
        }

        $enumLocalSecurityOptionsStandardUserElevationPromptBehavior = $null
        if ($null -ne $getValue.AdditionalProperties.localSecurityOptionsStandardUserElevationPromptBehavior)
        {
            $enumLocalSecurityOptionsStandardUserElevationPromptBehavior = $getValue.AdditionalProperties.localSecurityOptionsStandardUserElevationPromptBehavior.ToString()
        }

        $enumWindowsDefenderTamperProtection = $null
        if ($null -ne $getValue.AdditionalProperties.windowsDefenderTamperProtection)
        {
            $enumWindowsDefenderTamperProtection = $getValue.AdditionalProperties.windowsDefenderTamperProtection.ToString()
        }

        $enumXboxServicesAccessoryManagementServiceStartupMode = $null
        if ($null -ne $getValue.AdditionalProperties.xboxServicesAccessoryManagementServiceStartupMode)
        {
            $enumXboxServicesAccessoryManagementServiceStartupMode = $getValue.AdditionalProperties.xboxServicesAccessoryManagementServiceStartupMode.ToString()
        }

        $enumXboxServicesLiveAuthManagerServiceStartupMode = $null
        if ($null -ne $getValue.AdditionalProperties.xboxServicesLiveAuthManagerServiceStartupMode)
        {
            $enumXboxServicesLiveAuthManagerServiceStartupMode = $getValue.AdditionalProperties.xboxServicesLiveAuthManagerServiceStartupMode.ToString()
        }

        $enumXboxServicesLiveGameSaveServiceStartupMode = $null
        if ($null -ne $getValue.AdditionalProperties.xboxServicesLiveGameSaveServiceStartupMode)
        {
            $enumXboxServicesLiveGameSaveServiceStartupMode = $getValue.AdditionalProperties.xboxServicesLiveGameSaveServiceStartupMode.ToString()
        }

        $enumXboxServicesLiveNetworkingServiceStartupMode = $null
        if ($null -ne $getValue.AdditionalProperties.xboxServicesLiveNetworkingServiceStartupMode)
        {
            $enumXboxServicesLiveNetworkingServiceStartupMode = $getValue.AdditionalProperties.xboxServicesLiveNetworkingServiceStartupMode.ToString()
        }

        #endregion

        #region resource generator code
        $timeDefenderScheduledQuickScanTime = $null
        if ($null -ne $getValue.AdditionalProperties.defenderScheduledQuickScanTime)
        {
            $timeDefenderScheduledQuickScanTime = ([TimeSpan]$getValue.AdditionalProperties.defenderScheduledQuickScanTime).ToString()
        }

        $timeDefenderScheduledScanTime = $null
        if ($null -ne $getValue.AdditionalProperties.defenderScheduledScanTime)
        {
            $timeDefenderScheduledScanTime = ([TimeSpan]$getValue.AdditionalProperties.defenderScheduledScanTime).ToString()
        }

        #endregion

        $results = @{
            #region resource generator code
            ApplicationGuardAllowCameraMicrophoneRedirection                             = $getValue.AdditionalProperties.applicationGuardAllowCameraMicrophoneRedirection
            ApplicationGuardAllowFileSaveOnHost                                          = $getValue.AdditionalProperties.applicationGuardAllowFileSaveOnHost
            ApplicationGuardAllowPersistence                                             = $getValue.AdditionalProperties.applicationGuardAllowPersistence
            ApplicationGuardAllowPrintToLocalPrinters                                    = $getValue.AdditionalProperties.applicationGuardAllowPrintToLocalPrinters
            ApplicationGuardAllowPrintToNetworkPrinters                                  = $getValue.AdditionalProperties.applicationGuardAllowPrintToNetworkPrinters
            ApplicationGuardAllowPrintToPDF                                              = $getValue.AdditionalProperties.applicationGuardAllowPrintToPDF
            ApplicationGuardAllowPrintToXPS                                              = $getValue.AdditionalProperties.applicationGuardAllowPrintToXPS
            ApplicationGuardAllowVirtualGPU                                              = $getValue.AdditionalProperties.applicationGuardAllowVirtualGPU
            ApplicationGuardBlockClipboardSharing                                        = $enumApplicationGuardBlockClipboardSharing
            ApplicationGuardBlockFileTransfer                                            = $enumApplicationGuardBlockFileTransfer
            ApplicationGuardBlockNonEnterpriseContent                                    = $getValue.AdditionalProperties.applicationGuardBlockNonEnterpriseContent
            ApplicationGuardCertificateThumbprints                                       = $getValue.AdditionalProperties.applicationGuardCertificateThumbprints
            ApplicationGuardEnabled                                                      = $getValue.AdditionalProperties.applicationGuardEnabled
            ApplicationGuardEnabledOptions                                               = $enumApplicationGuardEnabledOptions
            ApplicationGuardForceAuditing                                                = $getValue.AdditionalProperties.applicationGuardForceAuditing
            AppLockerApplicationControl                                                  = $enumAppLockerApplicationControl
            BitLockerAllowStandardUserEncryption                                         = $getValue.AdditionalProperties.bitLockerAllowStandardUserEncryption
            BitLockerDisableWarningForOtherDiskEncryption                                = $getValue.AdditionalProperties.bitLockerDisableWarningForOtherDiskEncryption
            BitLockerEnableStorageCardEncryptionOnMobile                                 = $getValue.AdditionalProperties.bitLockerEnableStorageCardEncryptionOnMobile
            BitLockerEncryptDevice                                                       = $getValue.AdditionalProperties.bitLockerEncryptDevice
            BitLockerFixedDrivePolicy                                                    = $complexBitLockerFixedDrivePolicy
            BitLockerRecoveryPasswordRotation                                            = $enumBitLockerRecoveryPasswordRotation
            BitLockerRemovableDrivePolicy                                                = $complexBitLockerRemovableDrivePolicy
            BitLockerSystemDrivePolicy                                                   = $complexBitLockerSystemDrivePolicy
            DefenderAdditionalGuardedFolders                                             = $getValue.AdditionalProperties.defenderAdditionalGuardedFolders
            DefenderAdobeReaderLaunchChildProcess                                        = $enumDefenderAdobeReaderLaunchChildProcess
            DefenderAdvancedRansomewareProtectionType                                    = $enumDefenderAdvancedRansomewareProtectionType
            DefenderAllowBehaviorMonitoring                                              = $getValue.AdditionalProperties.defenderAllowBehaviorMonitoring
            DefenderAllowCloudProtection                                                 = $getValue.AdditionalProperties.defenderAllowCloudProtection
            DefenderAllowEndUserAccess                                                   = $getValue.AdditionalProperties.defenderAllowEndUserAccess
            DefenderAllowIntrusionPreventionSystem                                       = $getValue.AdditionalProperties.defenderAllowIntrusionPreventionSystem
            DefenderAllowOnAccessProtection                                              = $getValue.AdditionalProperties.defenderAllowOnAccessProtection
            DefenderAllowRealTimeMonitoring                                              = $getValue.AdditionalProperties.defenderAllowRealTimeMonitoring
            DefenderAllowScanArchiveFiles                                                = $getValue.AdditionalProperties.defenderAllowScanArchiveFiles
            DefenderAllowScanDownloads                                                   = $getValue.AdditionalProperties.defenderAllowScanDownloads
            DefenderAllowScanNetworkFiles                                                = $getValue.AdditionalProperties.defenderAllowScanNetworkFiles
            DefenderAllowScanRemovableDrivesDuringFullScan                               = $getValue.AdditionalProperties.defenderAllowScanRemovableDrivesDuringFullScan
            DefenderAllowScanScriptsLoadedInInternetExplorer                             = $getValue.AdditionalProperties.defenderAllowScanScriptsLoadedInInternetExplorer
            DefenderAttackSurfaceReductionExcludedPaths                                  = $getValue.AdditionalProperties.defenderAttackSurfaceReductionExcludedPaths
            DefenderBlockEndUserAccess                                                   = $getValue.AdditionalProperties.defenderBlockEndUserAccess
            DefenderBlockPersistenceThroughWmiType                                       = $enumDefenderBlockPersistenceThroughWmiType
            DefenderCheckForSignaturesBeforeRunningScan                                  = $getValue.AdditionalProperties.defenderCheckForSignaturesBeforeRunningScan
            DefenderCloudBlockLevel                                                      = $enumDefenderCloudBlockLevel
            DefenderCloudExtendedTimeoutInSeconds                                        = $getValue.AdditionalProperties.defenderCloudExtendedTimeoutInSeconds
            DefenderDaysBeforeDeletingQuarantinedMalware                                 = $getValue.AdditionalProperties.defenderDaysBeforeDeletingQuarantinedMalware
            DefenderDetectedMalwareActions                                               = $complexDefenderDetectedMalwareActions
            DefenderDisableBehaviorMonitoring                                            = $getValue.AdditionalProperties.defenderDisableBehaviorMonitoring
            DefenderDisableCatchupFullScan                                               = $getValue.AdditionalProperties.defenderDisableCatchupFullScan
            DefenderDisableCatchupQuickScan                                              = $getValue.AdditionalProperties.defenderDisableCatchupQuickScan
            DefenderDisableCloudProtection                                               = $getValue.AdditionalProperties.defenderDisableCloudProtection
            DefenderDisableIntrusionPreventionSystem                                     = $getValue.AdditionalProperties.defenderDisableIntrusionPreventionSystem
            DefenderDisableOnAccessProtection                                            = $getValue.AdditionalProperties.defenderDisableOnAccessProtection
            DefenderDisableRealTimeMonitoring                                            = $getValue.AdditionalProperties.defenderDisableRealTimeMonitoring
            DefenderDisableScanArchiveFiles                                              = $getValue.AdditionalProperties.defenderDisableScanArchiveFiles
            DefenderDisableScanDownloads                                                 = $getValue.AdditionalProperties.defenderDisableScanDownloads
            DefenderDisableScanNetworkFiles                                              = $getValue.AdditionalProperties.defenderDisableScanNetworkFiles
            DefenderDisableScanRemovableDrivesDuringFullScan                             = $getValue.AdditionalProperties.defenderDisableScanRemovableDrivesDuringFullScan
            DefenderDisableScanScriptsLoadedInInternetExplorer                           = $getValue.AdditionalProperties.defenderDisableScanScriptsLoadedInInternetExplorer
            DefenderEmailContentExecution                                                = $enumDefenderEmailContentExecution
            DefenderEmailContentExecutionType                                            = $enumDefenderEmailContentExecutionType
            DefenderEnableLowCpuPriority                                                 = $getValue.AdditionalProperties.defenderEnableLowCpuPriority
            DefenderEnableScanIncomingMail                                               = $getValue.AdditionalProperties.defenderEnableScanIncomingMail
            DefenderEnableScanMappedNetworkDrivesDuringFullScan                          = $getValue.AdditionalProperties.defenderEnableScanMappedNetworkDrivesDuringFullScan
            DefenderExploitProtectionXml                                                 = $getValue.AdditionalProperties.defenderExploitProtectionXml
            DefenderExploitProtectionXmlFileName                                         = $getValue.AdditionalProperties.defenderExploitProtectionXmlFileName
            DefenderFileExtensionsToExclude                                              = $getValue.AdditionalProperties.defenderFileExtensionsToExclude
            DefenderFilesAndFoldersToExclude                                             = $getValue.AdditionalProperties.defenderFilesAndFoldersToExclude
            DefenderGuardedFoldersAllowedAppPaths                                        = $getValue.AdditionalProperties.defenderGuardedFoldersAllowedAppPaths
            DefenderGuardMyFoldersType                                                   = $enumDefenderGuardMyFoldersType
            DefenderNetworkProtectionType                                                = $enumDefenderNetworkProtectionType
            DefenderOfficeAppsExecutableContentCreationOrLaunch                          = $enumDefenderOfficeAppsExecutableContentCreationOrLaunch
            DefenderOfficeAppsExecutableContentCreationOrLaunchType                      = $enumDefenderOfficeAppsExecutableContentCreationOrLaunchType
            DefenderOfficeAppsLaunchChildProcess                                         = $enumDefenderOfficeAppsLaunchChildProcess
            DefenderOfficeAppsLaunchChildProcessType                                     = $enumDefenderOfficeAppsLaunchChildProcessType
            DefenderOfficeAppsOtherProcessInjection                                      = $enumDefenderOfficeAppsOtherProcessInjection
            DefenderOfficeAppsOtherProcessInjectionType                                  = $enumDefenderOfficeAppsOtherProcessInjectionType
            DefenderOfficeCommunicationAppsLaunchChildProcess                            = $enumDefenderOfficeCommunicationAppsLaunchChildProcess
            DefenderOfficeMacroCodeAllowWin32Imports                                     = $enumDefenderOfficeMacroCodeAllowWin32Imports
            DefenderOfficeMacroCodeAllowWin32ImportsType                                 = $enumDefenderOfficeMacroCodeAllowWin32ImportsType
            DefenderPotentiallyUnwantedAppAction                                         = $enumDefenderPotentiallyUnwantedAppAction
            DefenderPreventCredentialStealingType                                        = $enumDefenderPreventCredentialStealingType
            DefenderProcessCreation                                                      = $enumDefenderProcessCreation
            DefenderProcessCreationType                                                  = $enumDefenderProcessCreationType
            DefenderProcessesToExclude                                                   = $getValue.AdditionalProperties.defenderProcessesToExclude
            DefenderScanDirection                                                        = $enumDefenderScanDirection
            DefenderScanMaxCpuPercentage                                                 = $getValue.AdditionalProperties.defenderScanMaxCpuPercentage
            DefenderScanType                                                             = $enumDefenderScanType
            DefenderScheduledQuickScanTime                                               = $timeDefenderScheduledQuickScanTime
            DefenderScheduledScanDay                                                     = $enumDefenderScheduledScanDay
            DefenderScheduledScanTime                                                    = $timeDefenderScheduledScanTime
            DefenderScriptDownloadedPayloadExecution                                     = $enumDefenderScriptDownloadedPayloadExecution
            DefenderScriptDownloadedPayloadExecutionType                                 = $enumDefenderScriptDownloadedPayloadExecutionType
            DefenderScriptObfuscatedMacroCode                                            = $enumDefenderScriptObfuscatedMacroCode
            DefenderScriptObfuscatedMacroCodeType                                        = $enumDefenderScriptObfuscatedMacroCodeType
            DefenderSecurityCenterBlockExploitProtectionOverride                         = $getValue.AdditionalProperties.defenderSecurityCenterBlockExploitProtectionOverride
            DefenderSecurityCenterDisableAccountUI                                       = $getValue.AdditionalProperties.defenderSecurityCenterDisableAccountUI
            DefenderSecurityCenterDisableAppBrowserUI                                    = $getValue.AdditionalProperties.defenderSecurityCenterDisableAppBrowserUI
            DefenderSecurityCenterDisableClearTpmUI                                      = $getValue.AdditionalProperties.defenderSecurityCenterDisableClearTpmUI
            DefenderSecurityCenterDisableFamilyUI                                        = $getValue.AdditionalProperties.defenderSecurityCenterDisableFamilyUI
            DefenderSecurityCenterDisableHardwareUI                                      = $getValue.AdditionalProperties.defenderSecurityCenterDisableHardwareUI
            DefenderSecurityCenterDisableHealthUI                                        = $getValue.AdditionalProperties.defenderSecurityCenterDisableHealthUI
            DefenderSecurityCenterDisableNetworkUI                                       = $getValue.AdditionalProperties.defenderSecurityCenterDisableNetworkUI
            DefenderSecurityCenterDisableNotificationAreaUI                              = $getValue.AdditionalProperties.defenderSecurityCenterDisableNotificationAreaUI
            DefenderSecurityCenterDisableRansomwareUI                                    = $getValue.AdditionalProperties.defenderSecurityCenterDisableRansomwareUI
            DefenderSecurityCenterDisableSecureBootUI                                    = $getValue.AdditionalProperties.defenderSecurityCenterDisableSecureBootUI
            DefenderSecurityCenterDisableTroubleshootingUI                               = $getValue.AdditionalProperties.defenderSecurityCenterDisableTroubleshootingUI
            DefenderSecurityCenterDisableVirusUI                                         = $getValue.AdditionalProperties.defenderSecurityCenterDisableVirusUI
            DefenderSecurityCenterDisableVulnerableTpmFirmwareUpdateUI                   = $getValue.AdditionalProperties.defenderSecurityCenterDisableVulnerableTpmFirmwareUpdateUI
            DefenderSecurityCenterHelpEmail                                              = $getValue.AdditionalProperties.defenderSecurityCenterHelpEmail
            DefenderSecurityCenterHelpPhone                                              = $getValue.AdditionalProperties.defenderSecurityCenterHelpPhone
            DefenderSecurityCenterHelpURL                                                = $getValue.AdditionalProperties.defenderSecurityCenterHelpURL
            DefenderSecurityCenterITContactDisplay                                       = $enumDefenderSecurityCenterITContactDisplay
            DefenderSecurityCenterNotificationsFromApp                                   = $enumDefenderSecurityCenterNotificationsFromApp
            DefenderSecurityCenterOrganizationDisplayName                                = $getValue.AdditionalProperties.defenderSecurityCenterOrganizationDisplayName
            DefenderSignatureUpdateIntervalInHours                                       = $getValue.AdditionalProperties.defenderSignatureUpdateIntervalInHours
            DefenderSubmitSamplesConsentType                                             = $enumDefenderSubmitSamplesConsentType
            DefenderUntrustedExecutable                                                  = $enumDefenderUntrustedExecutable
            DefenderUntrustedExecutableType                                              = $enumDefenderUntrustedExecutableType
            DefenderUntrustedUSBProcess                                                  = $enumDefenderUntrustedUSBProcess
            DefenderUntrustedUSBProcessType                                              = $enumDefenderUntrustedUSBProcessType
            DeviceGuardEnableSecureBootWithDMA                                           = $getValue.AdditionalProperties.deviceGuardEnableSecureBootWithDMA
            DeviceGuardEnableVirtualizationBasedSecurity                                 = $getValue.AdditionalProperties.deviceGuardEnableVirtualizationBasedSecurity
            DeviceGuardLaunchSystemGuard                                                 = $enumDeviceGuardLaunchSystemGuard
            DeviceGuardLocalSystemAuthorityCredentialGuardSettings                       = $enumDeviceGuardLocalSystemAuthorityCredentialGuardSettings
            DeviceGuardSecureBootWithDMA                                                 = $enumDeviceGuardSecureBootWithDMA
            DmaGuardDeviceEnumerationPolicy                                              = $enumDmaGuardDeviceEnumerationPolicy
            FirewallBlockStatefulFTP                                                     = $getValue.AdditionalProperties.firewallBlockStatefulFTP
            FirewallCertificateRevocationListCheckMethod                                 = $enumFirewallCertificateRevocationListCheckMethod
            FirewallIdleTimeoutForSecurityAssociationInSeconds                           = $getValue.AdditionalProperties.firewallIdleTimeoutForSecurityAssociationInSeconds
            FirewallIPSecExemptionsAllowDHCP                                             = $getValue.AdditionalProperties.firewallIPSecExemptionsAllowDHCP
            FirewallIPSecExemptionsAllowICMP                                             = $getValue.AdditionalProperties.firewallIPSecExemptionsAllowICMP
            FirewallIPSecExemptionsAllowNeighborDiscovery                                = $getValue.AdditionalProperties.firewallIPSecExemptionsAllowNeighborDiscovery
            FirewallIPSecExemptionsAllowRouterDiscovery                                  = $getValue.AdditionalProperties.firewallIPSecExemptionsAllowRouterDiscovery
            FirewallIPSecExemptionsNone                                                  = $getValue.AdditionalProperties.firewallIPSecExemptionsNone
            FirewallMergeKeyingModuleSettings                                            = $getValue.AdditionalProperties.firewallMergeKeyingModuleSettings
            FirewallPacketQueueingMethod                                                 = $enumFirewallPacketQueueingMethod
            FirewallPreSharedKeyEncodingMethod                                           = $enumFirewallPreSharedKeyEncodingMethod
            FirewallProfileDomain                                                        = $complexFirewallProfileDomain
            FirewallProfilePrivate                                                       = $complexFirewallProfilePrivate
            FirewallProfilePublic                                                        = $complexFirewallProfilePublic
            FirewallRules                                                                = $complexFirewallRules
            LanManagerAuthenticationLevel                                                = $enumLanManagerAuthenticationLevel
            LanManagerWorkstationDisableInsecureGuestLogons                              = $getValue.AdditionalProperties.lanManagerWorkstationDisableInsecureGuestLogons
            LocalSecurityOptionsAdministratorAccountName                                 = $getValue.AdditionalProperties.localSecurityOptionsAdministratorAccountName
            LocalSecurityOptionsAdministratorElevationPromptBehavior                     = $enumLocalSecurityOptionsAdministratorElevationPromptBehavior
            LocalSecurityOptionsAllowAnonymousEnumerationOfSAMAccountsAndShares          = $getValue.AdditionalProperties.localSecurityOptionsAllowAnonymousEnumerationOfSAMAccountsAndShares
            LocalSecurityOptionsAllowPKU2UAuthenticationRequests                         = $getValue.AdditionalProperties.localSecurityOptionsAllowPKU2UAuthenticationRequests
            LocalSecurityOptionsAllowRemoteCallsToSecurityAccountsManager                = $getValue.AdditionalProperties.localSecurityOptionsAllowRemoteCallsToSecurityAccountsManager
            LocalSecurityOptionsAllowRemoteCallsToSecurityAccountsManagerHelperBool      = $getValue.AdditionalProperties.localSecurityOptionsAllowRemoteCallsToSecurityAccountsManagerHelperBool
            LocalSecurityOptionsAllowSystemToBeShutDownWithoutHavingToLogOn              = $getValue.AdditionalProperties.localSecurityOptionsAllowSystemToBeShutDownWithoutHavingToLogOn
            LocalSecurityOptionsAllowUIAccessApplicationElevation                        = $getValue.AdditionalProperties.localSecurityOptionsAllowUIAccessApplicationElevation
            LocalSecurityOptionsAllowUIAccessApplicationsForSecureLocations              = $getValue.AdditionalProperties.localSecurityOptionsAllowUIAccessApplicationsForSecureLocations
            LocalSecurityOptionsAllowUndockWithoutHavingToLogon                          = $getValue.AdditionalProperties.localSecurityOptionsAllowUndockWithoutHavingToLogon
            LocalSecurityOptionsBlockMicrosoftAccounts                                   = $getValue.AdditionalProperties.localSecurityOptionsBlockMicrosoftAccounts
            LocalSecurityOptionsBlockRemoteLogonWithBlankPassword                        = $getValue.AdditionalProperties.localSecurityOptionsBlockRemoteLogonWithBlankPassword
            LocalSecurityOptionsBlockRemoteOpticalDriveAccess                            = $getValue.AdditionalProperties.localSecurityOptionsBlockRemoteOpticalDriveAccess
            LocalSecurityOptionsBlockUsersInstallingPrinterDrivers                       = $getValue.AdditionalProperties.localSecurityOptionsBlockUsersInstallingPrinterDrivers
            LocalSecurityOptionsClearVirtualMemoryPageFile                               = $getValue.AdditionalProperties.localSecurityOptionsClearVirtualMemoryPageFile
            LocalSecurityOptionsClientDigitallySignCommunicationsAlways                  = $getValue.AdditionalProperties.localSecurityOptionsClientDigitallySignCommunicationsAlways
            LocalSecurityOptionsClientSendUnencryptedPasswordToThirdPartySMBServers      = $getValue.AdditionalProperties.localSecurityOptionsClientSendUnencryptedPasswordToThirdPartySMBServers
            LocalSecurityOptionsDetectApplicationInstallationsAndPromptForElevation      = $getValue.AdditionalProperties.localSecurityOptionsDetectApplicationInstallationsAndPromptForElevation
            LocalSecurityOptionsDisableAdministratorAccount                              = $getValue.AdditionalProperties.localSecurityOptionsDisableAdministratorAccount
            LocalSecurityOptionsDisableClientDigitallySignCommunicationsIfServerAgrees   = $getValue.AdditionalProperties.localSecurityOptionsDisableClientDigitallySignCommunicationsIfServerAgrees
            LocalSecurityOptionsDisableGuestAccount                                      = $getValue.AdditionalProperties.localSecurityOptionsDisableGuestAccount
            LocalSecurityOptionsDisableServerDigitallySignCommunicationsAlways           = $getValue.AdditionalProperties.localSecurityOptionsDisableServerDigitallySignCommunicationsAlways
            LocalSecurityOptionsDisableServerDigitallySignCommunicationsIfClientAgrees   = $getValue.AdditionalProperties.localSecurityOptionsDisableServerDigitallySignCommunicationsIfClientAgrees
            LocalSecurityOptionsDoNotAllowAnonymousEnumerationOfSAMAccounts              = $getValue.AdditionalProperties.localSecurityOptionsDoNotAllowAnonymousEnumerationOfSAMAccounts
            LocalSecurityOptionsDoNotRequireCtrlAltDel                                   = $getValue.AdditionalProperties.localSecurityOptionsDoNotRequireCtrlAltDel
            LocalSecurityOptionsDoNotStoreLANManagerHashValueOnNextPasswordChange        = $getValue.AdditionalProperties.localSecurityOptionsDoNotStoreLANManagerHashValueOnNextPasswordChange
            LocalSecurityOptionsFormatAndEjectOfRemovableMediaAllowedUser                = $enumLocalSecurityOptionsFormatAndEjectOfRemovableMediaAllowedUser
            LocalSecurityOptionsGuestAccountName                                         = $getValue.AdditionalProperties.localSecurityOptionsGuestAccountName
            LocalSecurityOptionsHideLastSignedInUser                                     = $getValue.AdditionalProperties.localSecurityOptionsHideLastSignedInUser
            LocalSecurityOptionsHideUsernameAtSignIn                                     = $getValue.AdditionalProperties.localSecurityOptionsHideUsernameAtSignIn
            LocalSecurityOptionsInformationDisplayedOnLockScreen                         = $enumLocalSecurityOptionsInformationDisplayedOnLockScreen
            LocalSecurityOptionsInformationShownOnLockScreen                             = $enumLocalSecurityOptionsInformationShownOnLockScreen
            LocalSecurityOptionsLogOnMessageText                                         = $getValue.AdditionalProperties.localSecurityOptionsLogOnMessageText
            LocalSecurityOptionsLogOnMessageTitle                                        = $getValue.AdditionalProperties.localSecurityOptionsLogOnMessageTitle
            LocalSecurityOptionsMachineInactivityLimit                                   = $getValue.AdditionalProperties.localSecurityOptionsMachineInactivityLimit
            LocalSecurityOptionsMachineInactivityLimitInMinutes                          = $getValue.AdditionalProperties.localSecurityOptionsMachineInactivityLimitInMinutes
            LocalSecurityOptionsMinimumSessionSecurityForNtlmSspBasedClients             = $enumLocalSecurityOptionsMinimumSessionSecurityForNtlmSspBasedClients
            LocalSecurityOptionsMinimumSessionSecurityForNtlmSspBasedServers             = $enumLocalSecurityOptionsMinimumSessionSecurityForNtlmSspBasedServers
            LocalSecurityOptionsOnlyElevateSignedExecutables                             = $getValue.AdditionalProperties.localSecurityOptionsOnlyElevateSignedExecutables
            LocalSecurityOptionsRestrictAnonymousAccessToNamedPipesAndShares             = $getValue.AdditionalProperties.localSecurityOptionsRestrictAnonymousAccessToNamedPipesAndShares
            LocalSecurityOptionsSmartCardRemovalBehavior                                 = $enumLocalSecurityOptionsSmartCardRemovalBehavior
            LocalSecurityOptionsStandardUserElevationPromptBehavior                      = $enumLocalSecurityOptionsStandardUserElevationPromptBehavior
            LocalSecurityOptionsSwitchToSecureDesktopWhenPromptingForElevation           = $getValue.AdditionalProperties.localSecurityOptionsSwitchToSecureDesktopWhenPromptingForElevation
            LocalSecurityOptionsUseAdminApprovalMode                                     = $getValue.AdditionalProperties.localSecurityOptionsUseAdminApprovalMode
            LocalSecurityOptionsUseAdminApprovalModeForAdministrators                    = $getValue.AdditionalProperties.localSecurityOptionsUseAdminApprovalModeForAdministrators
            LocalSecurityOptionsVirtualizeFileAndRegistryWriteFailuresToPerUserLocations = $getValue.AdditionalProperties.localSecurityOptionsVirtualizeFileAndRegistryWriteFailuresToPerUserLocations
            SmartScreenBlockOverrideForFiles                                             = $getValue.AdditionalProperties.smartScreenBlockOverrideForFiles
            SmartScreenEnableInShell                                                     = $getValue.AdditionalProperties.smartScreenEnableInShell
            UserRightsAccessCredentialManagerAsTrustedCaller                             = $complexUserRightsAccessCredentialManagerAsTrustedCaller
            UserRightsActAsPartOfTheOperatingSystem                                      = $complexUserRightsActAsPartOfTheOperatingSystem
            UserRightsAllowAccessFromNetwork                                             = $complexUserRightsAllowAccessFromNetwork
            UserRightsBackupData                                                         = $complexUserRightsBackupData
            UserRightsBlockAccessFromNetwork                                             = $complexUserRightsBlockAccessFromNetwork
            UserRightsChangeSystemTime                                                   = $complexUserRightsChangeSystemTime
            UserRightsCreateGlobalObjects                                                = $complexUserRightsCreateGlobalObjects
            UserRightsCreatePageFile                                                     = $complexUserRightsCreatePageFile
            UserRightsCreatePermanentSharedObjects                                       = $complexUserRightsCreatePermanentSharedObjects
            UserRightsCreateSymbolicLinks                                                = $complexUserRightsCreateSymbolicLinks
            UserRightsCreateToken                                                        = $complexUserRightsCreateToken
            UserRightsDebugPrograms                                                      = $complexUserRightsDebugPrograms
            UserRightsDelegation                                                         = $complexUserRightsDelegation
            UserRightsDenyLocalLogOn                                                     = $complexUserRightsDenyLocalLogOn
            UserRightsGenerateSecurityAudits                                             = $complexUserRightsGenerateSecurityAudits
            UserRightsImpersonateClient                                                  = $complexUserRightsImpersonateClient
            UserRightsIncreaseSchedulingPriority                                         = $complexUserRightsIncreaseSchedulingPriority
            UserRightsLoadUnloadDrivers                                                  = $complexUserRightsLoadUnloadDrivers
            UserRightsLocalLogOn                                                         = $complexUserRightsLocalLogOn
            UserRightsLockMemory                                                         = $complexUserRightsLockMemory
            UserRightsManageAuditingAndSecurityLogs                                      = $complexUserRightsManageAuditingAndSecurityLogs
            UserRightsManageVolumes                                                      = $complexUserRightsManageVolumes
            UserRightsModifyFirmwareEnvironment                                          = $complexUserRightsModifyFirmwareEnvironment
            UserRightsModifyObjectLabels                                                 = $complexUserRightsModifyObjectLabels
            UserRightsProfileSingleProcess                                               = $complexUserRightsProfileSingleProcess
            UserRightsRemoteDesktopServicesLogOn                                         = $complexUserRightsRemoteDesktopServicesLogOn
            UserRightsRemoteShutdown                                                     = $complexUserRightsRemoteShutdown
            UserRightsRestoreData                                                        = $complexUserRightsRestoreData
            UserRightsTakeOwnership                                                      = $complexUserRightsTakeOwnership
            WindowsDefenderTamperProtection                                              = $enumWindowsDefenderTamperProtection
            XboxServicesAccessoryManagementServiceStartupMode                            = $enumXboxServicesAccessoryManagementServiceStartupMode
            XboxServicesEnableXboxGameSaveTask                                           = $getValue.AdditionalProperties.xboxServicesEnableXboxGameSaveTask
            XboxServicesLiveAuthManagerServiceStartupMode                                = $enumXboxServicesLiveAuthManagerServiceStartupMode
            XboxServicesLiveGameSaveServiceStartupMode                                   = $enumXboxServicesLiveGameSaveServiceStartupMode
            XboxServicesLiveNetworkingServiceStartupMode                                 = $enumXboxServicesLiveNetworkingServiceStartupMode
            Description                                                                  = $getValue.Description
            DisplayName                                                                  = $getValue.DisplayName
            Id                                                                           = $getValue.Id
            RoleScopeTagIds                                                              = $getValue.RoleScopeTagIds
            Ensure                                                                       = 'Present'
            Credential                                                                   = $Credential
            ApplicationId                                                                = $ApplicationId
            TenantId                                                                     = $TenantId
            ApplicationSecret                                                            = $ApplicationSecret
            CertificateThumbprint                                                        = $CertificateThumbprint
            ManagedIdentity                                                              = $ManagedIdentity.IsPresent
            AccessTokens                                                                 = $AccessTokens
            #endregion
        }

        $returnAssignments = @()
        $graphAssignments = Get-MgBetaDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId $Id
        if ($graphAssignments.Count -gt 0)
        {
            $returnAssignments += ConvertFrom-IntunePolicyAssignment `
                -IncludeDeviceFilter:$true `
                -Assignments ($graphAssignments)
        }
        $results.Add('Assignments', $returnAssignments)

        return $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.Boolean]
        $ApplicationGuardAllowCameraMicrophoneRedirection,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardAllowFileSaveOnHost,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardAllowPersistence,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardAllowPrintToLocalPrinters,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardAllowPrintToNetworkPrinters,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardAllowPrintToPDF,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardAllowPrintToXPS,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardAllowVirtualGPU,

        [Parameter()]
        [ValidateSet('notConfigured', 'blockBoth', 'blockHostToContainer', 'blockContainerToHost', 'blockNone')]
        [System.String]
        $ApplicationGuardBlockClipboardSharing,

        [Parameter()]
        [ValidateSet('notConfigured', 'blockImageAndTextFile', 'blockImageFile', 'blockNone', 'blockTextFile')]
        [System.String]
        $ApplicationGuardBlockFileTransfer,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardBlockNonEnterpriseContent,

        [Parameter()]
        [System.String[]]
        $ApplicationGuardCertificateThumbprints,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardEnabled,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabledForEdge', 'enabledForOffice', 'enabledForEdgeAndOffice')]
        [System.String]
        $ApplicationGuardEnabledOptions,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardForceAuditing,

        [Parameter()]
        [ValidateSet('notConfigured', 'enforceComponentsAndStoreApps', 'auditComponentsAndStoreApps', 'enforceComponentsStoreAppsAndSmartlocker', 'auditComponentsStoreAppsAndSmartlocker')]
        [System.String]
        $AppLockerApplicationControl,

        [Parameter()]
        [System.Boolean]
        $BitLockerAllowStandardUserEncryption,

        [Parameter()]
        [System.Boolean]
        $BitLockerDisableWarningForOtherDiskEncryption,

        [Parameter()]
        [System.Boolean]
        $BitLockerEnableStorageCardEncryptionOnMobile,

        [Parameter()]
        [System.Boolean]
        $BitLockerEncryptDevice,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $BitLockerFixedDrivePolicy,

        [Parameter()]
        [ValidateSet('notConfigured', 'disabled', 'enabledForAzureAd', 'enabledForAzureAdAndHybrid')]
        [System.String]
        $BitLockerRecoveryPasswordRotation,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $BitLockerRemovableDrivePolicy,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $BitLockerSystemDrivePolicy,

        [Parameter()]
        [System.String[]]
        $DefenderAdditionalGuardedFolders,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderAdobeReaderLaunchChildProcess,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderAdvancedRansomewareProtectionType,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowBehaviorMonitoring,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowCloudProtection,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowEndUserAccess,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowIntrusionPreventionSystem,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowOnAccessProtection,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowRealTimeMonitoring,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowScanArchiveFiles,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowScanDownloads,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowScanNetworkFiles,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowScanRemovableDrivesDuringFullScan,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowScanScriptsLoadedInInternetExplorer,

        [Parameter()]
        [System.String[]]
        $DefenderAttackSurfaceReductionExcludedPaths,

        [Parameter()]
        [System.Boolean]
        $DefenderBlockEndUserAccess,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderBlockPersistenceThroughWmiType,

        [Parameter()]
        [System.Boolean]
        $DefenderCheckForSignaturesBeforeRunningScan,

        [Parameter()]
        [ValidateSet('notConfigured', 'high', 'highPlus', 'zeroTolerance')]
        [System.String]
        $DefenderCloudBlockLevel,

        [Parameter()]
        [System.Int32]
        $DefenderCloudExtendedTimeoutInSeconds,

        [Parameter()]
        [System.Int32]
        $DefenderDaysBeforeDeletingQuarantinedMalware,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DefenderDetectedMalwareActions,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableBehaviorMonitoring,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableCatchupFullScan,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableCatchupQuickScan,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableCloudProtection,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableIntrusionPreventionSystem,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableOnAccessProtection,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableRealTimeMonitoring,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableScanArchiveFiles,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableScanDownloads,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableScanNetworkFiles,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableScanRemovableDrivesDuringFullScan,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableScanScriptsLoadedInInternetExplorer,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderEmailContentExecution,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderEmailContentExecutionType,

        [Parameter()]
        [System.Boolean]
        $DefenderEnableLowCpuPriority,

        [Parameter()]
        [System.Boolean]
        $DefenderEnableScanIncomingMail,

        [Parameter()]
        [System.Boolean]
        $DefenderEnableScanMappedNetworkDrivesDuringFullScan,

        [Parameter()]
        [System.String]
        $DefenderExploitProtectionXml,

        [Parameter()]
        [System.String]
        $DefenderExploitProtectionXmlFileName,

        [Parameter()]
        [System.String[]]
        $DefenderFileExtensionsToExclude,

        [Parameter()]
        [System.String[]]
        $DefenderFilesAndFoldersToExclude,

        [Parameter()]
        [System.String[]]
        $DefenderGuardedFoldersAllowedAppPaths,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'blockDiskModification', 'auditDiskModification')]
        [System.String]
        $DefenderGuardMyFoldersType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderNetworkProtectionType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderOfficeAppsExecutableContentCreationOrLaunch,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderOfficeAppsExecutableContentCreationOrLaunchType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderOfficeAppsLaunchChildProcess,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderOfficeAppsLaunchChildProcessType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderOfficeAppsOtherProcessInjection,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderOfficeAppsOtherProcessInjectionType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderOfficeCommunicationAppsLaunchChildProcess,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderOfficeMacroCodeAllowWin32Imports,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderOfficeMacroCodeAllowWin32ImportsType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderPotentiallyUnwantedAppAction,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderPreventCredentialStealingType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderProcessCreation,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderProcessCreationType,

        [Parameter()]
        [System.String[]]
        $DefenderProcessesToExclude,

        [Parameter()]
        [ValidateSet('monitorAllFiles', 'monitorIncomingFilesOnly', 'monitorOutgoingFilesOnly')]
        [System.String]
        $DefenderScanDirection,

        [Parameter()]
        [System.Int32]
        $DefenderScanMaxCpuPercentage,

        [Parameter()]
        [ValidateSet('userDefined', 'disabled', 'quick', 'full')]
        [System.String]
        $DefenderScanType,

        [Parameter()]
        [System.TimeSpan]
        $DefenderScheduledQuickScanTime,

        [Parameter()]
        [ValidateSet('userDefined', 'everyday', 'sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'noScheduledScan')]
        [System.String]
        $DefenderScheduledScanDay,

        [Parameter()]
        [System.TimeSpan]
        $DefenderScheduledScanTime,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderScriptDownloadedPayloadExecution,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderScriptDownloadedPayloadExecutionType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderScriptObfuscatedMacroCode,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderScriptObfuscatedMacroCodeType,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterBlockExploitProtectionOverride,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableAccountUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableAppBrowserUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableClearTpmUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableFamilyUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableHardwareUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableHealthUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableNetworkUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableNotificationAreaUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableRansomwareUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableSecureBootUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableTroubleshootingUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableVirusUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableVulnerableTpmFirmwareUpdateUI,

        [Parameter()]
        [System.String]
        $DefenderSecurityCenterHelpEmail,

        [Parameter()]
        [System.String]
        $DefenderSecurityCenterHelpPhone,

        [Parameter()]
        [System.String]
        $DefenderSecurityCenterHelpURL,

        [Parameter()]
        [ValidateSet('notConfigured', 'displayInAppAndInNotifications', 'displayOnlyInApp', 'displayOnlyInNotifications')]
        [System.String]
        $DefenderSecurityCenterITContactDisplay,

        [Parameter()]
        [ValidateSet('notConfigured', 'blockNoncriticalNotifications', 'blockAllNotifications')]
        [System.String]
        $DefenderSecurityCenterNotificationsFromApp,

        [Parameter()]
        [System.String]
        $DefenderSecurityCenterOrganizationDisplayName,

        [Parameter()]
        [System.Int32]
        $DefenderSignatureUpdateIntervalInHours,

        [Parameter()]
        [ValidateSet('sendSafeSamplesAutomatically', 'alwaysPrompt', 'neverSend', 'sendAllSamplesAutomatically')]
        [System.String]
        $DefenderSubmitSamplesConsentType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderUntrustedExecutable,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderUntrustedExecutableType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderUntrustedUSBProcess,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderUntrustedUSBProcessType,

        [Parameter()]
        [System.Boolean]
        $DeviceGuardEnableSecureBootWithDMA,

        [Parameter()]
        [System.Boolean]
        $DeviceGuardEnableVirtualizationBasedSecurity,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $DeviceGuardLaunchSystemGuard,

        [Parameter()]
        [ValidateSet('notConfigured', 'enableWithUEFILock', 'enableWithoutUEFILock', 'disable')]
        [System.String]
        $DeviceGuardLocalSystemAuthorityCredentialGuardSettings,

        [Parameter()]
        [ValidateSet('notConfigured', 'withoutDMA', 'withDMA')]
        [System.String]
        $DeviceGuardSecureBootWithDMA,

        [Parameter()]
        [ValidateSet('deviceDefault', 'blockAll', 'allowAll')]
        [System.String]
        $DmaGuardDeviceEnumerationPolicy,

        [Parameter()]
        [System.Boolean]
        $FirewallBlockStatefulFTP,

        [Parameter()]
        [ValidateSet('deviceDefault', 'none', 'attempt', 'require')]
        [System.String]
        $FirewallCertificateRevocationListCheckMethod,

        [Parameter()]
        [System.Int32]
        $FirewallIdleTimeoutForSecurityAssociationInSeconds,

        [Parameter()]
        [System.Boolean]
        $FirewallIPSecExemptionsAllowDHCP,

        [Parameter()]
        [System.Boolean]
        $FirewallIPSecExemptionsAllowICMP,

        [Parameter()]
        [System.Boolean]
        $FirewallIPSecExemptionsAllowNeighborDiscovery,

        [Parameter()]
        [System.Boolean]
        $FirewallIPSecExemptionsAllowRouterDiscovery,

        [Parameter()]
        [System.Boolean]
        $FirewallIPSecExemptionsNone,

        [Parameter()]
        [System.Boolean]
        $FirewallMergeKeyingModuleSettings,

        [Parameter()]
        [ValidateSet('deviceDefault', 'disabled', 'queueInbound', 'queueOutbound', 'queueBoth')]
        [System.String]
        $FirewallPacketQueueingMethod,

        [Parameter()]
        [ValidateSet('deviceDefault', 'none', 'utF8')]
        [System.String]
        $FirewallPreSharedKeyEncodingMethod,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FirewallProfileDomain,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FirewallProfilePrivate,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FirewallProfilePublic,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $FirewallRules,

        [Parameter()]
        [ValidateSet('lmAndNltm', 'lmNtlmAndNtlmV2', 'lmAndNtlmOnly', 'lmAndNtlmV2', 'lmNtlmV2AndNotLm', 'lmNtlmV2AndNotLmOrNtm')]
        [System.String]
        $LanManagerAuthenticationLevel,

        [Parameter()]
        [System.Boolean]
        $LanManagerWorkstationDisableInsecureGuestLogons,

        [Parameter()]
        [System.String]
        $LocalSecurityOptionsAdministratorAccountName,

        [Parameter()]
        [ValidateSet('notConfigured', 'elevateWithoutPrompting', 'promptForCredentialsOnTheSecureDesktop', 'promptForConsentOnTheSecureDesktop', 'promptForCredentials', 'promptForConsent', 'promptForConsentForNonWindowsBinaries')]
        [System.String]
        $LocalSecurityOptionsAdministratorElevationPromptBehavior,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsAllowAnonymousEnumerationOfSAMAccountsAndShares,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsAllowPKU2UAuthenticationRequests,

        [Parameter()]
        [System.String]
        $LocalSecurityOptionsAllowRemoteCallsToSecurityAccountsManager,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsAllowRemoteCallsToSecurityAccountsManagerHelperBool,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsAllowSystemToBeShutDownWithoutHavingToLogOn,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsAllowUIAccessApplicationElevation,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsAllowUIAccessApplicationsForSecureLocations,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsAllowUndockWithoutHavingToLogon,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsBlockMicrosoftAccounts,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsBlockRemoteLogonWithBlankPassword,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsBlockRemoteOpticalDriveAccess,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsBlockUsersInstallingPrinterDrivers,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsClearVirtualMemoryPageFile,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsClientDigitallySignCommunicationsAlways,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsClientSendUnencryptedPasswordToThirdPartySMBServers,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsDetectApplicationInstallationsAndPromptForElevation,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsDisableAdministratorAccount,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsDisableClientDigitallySignCommunicationsIfServerAgrees,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsDisableGuestAccount,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsDisableServerDigitallySignCommunicationsAlways,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsDisableServerDigitallySignCommunicationsIfClientAgrees,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsDoNotAllowAnonymousEnumerationOfSAMAccounts,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsDoNotRequireCtrlAltDel,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsDoNotStoreLANManagerHashValueOnNextPasswordChange,

        [Parameter()]
        [ValidateSet('notConfigured', 'administrators', 'administratorsAndPowerUsers', 'administratorsAndInteractiveUsers')]
        [System.String]
        $LocalSecurityOptionsFormatAndEjectOfRemovableMediaAllowedUser,

        [Parameter()]
        [System.String]
        $LocalSecurityOptionsGuestAccountName,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsHideLastSignedInUser,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsHideUsernameAtSignIn,

        [Parameter()]
        [ValidateSet('notConfigured', 'administrators', 'administratorsAndPowerUsers', 'administratorsAndInteractiveUsers')]
        [System.String]
        $LocalSecurityOptionsInformationDisplayedOnLockScreen,

        [Parameter()]
        [ValidateSet('notConfigured', 'userDisplayNameDomainUser', 'userDisplayNameOnly', 'doNotDisplayUser')]
        [System.String]
        $LocalSecurityOptionsInformationShownOnLockScreen,

        [Parameter()]
        [System.String]
        $LocalSecurityOptionsLogOnMessageText,

        [Parameter()]
        [System.String]
        $LocalSecurityOptionsLogOnMessageTitle,

        [Parameter()]
        [System.Int32]
        $LocalSecurityOptionsMachineInactivityLimit,

        [Parameter()]
        [System.Int32]
        $LocalSecurityOptionsMachineInactivityLimitInMinutes,

        [Parameter()]
        [ValidateSet('none', 'requireNtmlV2SessionSecurity', 'require128BitEncryption', 'ntlmV2And128BitEncryption')]
        [System.String]
        $LocalSecurityOptionsMinimumSessionSecurityForNtlmSspBasedClients,

        [Parameter()]
        [ValidateSet('none', 'requireNtmlV2SessionSecurity', 'require128BitEncryption', 'ntlmV2And128BitEncryption')]
        [System.String]
        $LocalSecurityOptionsMinimumSessionSecurityForNtlmSspBasedServers,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsOnlyElevateSignedExecutables,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsRestrictAnonymousAccessToNamedPipesAndShares,

        [Parameter()]
        [ValidateSet('noAction', 'lockWorkstation', 'forceLogoff', 'disconnectRemoteDesktopSession')]
        [System.String]
        $LocalSecurityOptionsSmartCardRemovalBehavior,

        [Parameter()]
        [ValidateSet('notConfigured', 'automaticallyDenyElevationRequests', 'promptForCredentialsOnTheSecureDesktop', 'promptForCredentials')]
        [System.String]
        $LocalSecurityOptionsStandardUserElevationPromptBehavior,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsSwitchToSecureDesktopWhenPromptingForElevation,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsUseAdminApprovalMode,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsUseAdminApprovalModeForAdministrators,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsVirtualizeFileAndRegistryWriteFailuresToPerUserLocations,

        [Parameter()]
        [System.Boolean]
        $SmartScreenBlockOverrideForFiles,

        [Parameter()]
        [System.Boolean]
        $SmartScreenEnableInShell,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsAccessCredentialManagerAsTrustedCaller,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsActAsPartOfTheOperatingSystem,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsAllowAccessFromNetwork,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsBackupData,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsBlockAccessFromNetwork,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsChangeSystemTime,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsCreateGlobalObjects,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsCreatePageFile,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsCreatePermanentSharedObjects,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsCreateSymbolicLinks,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsCreateToken,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsDebugPrograms,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsDelegation,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsDenyLocalLogOn,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsGenerateSecurityAudits,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsImpersonateClient,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsIncreaseSchedulingPriority,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsLoadUnloadDrivers,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsLocalLogOn,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsLockMemory,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsManageAuditingAndSecurityLogs,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsManageVolumes,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsModifyFirmwareEnvironment,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsModifyObjectLabels,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsProfileSingleProcess,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsRemoteDesktopServicesLogOn,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsRemoteShutdown,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsRestoreData,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsTakeOwnership,

        [Parameter()]
        [ValidateSet('notConfigured', 'enable', 'disable')]
        [System.String]
        $WindowsDefenderTamperProtection,

        [Parameter()]
        [ValidateSet('manual', 'automatic', 'disabled')]
        [System.String]
        $XboxServicesAccessoryManagementServiceStartupMode,

        [Parameter()]
        [System.Boolean]
        $XboxServicesEnableXboxGameSaveTask,

        [Parameter()]
        [ValidateSet('manual', 'automatic', 'disabled')]
        [System.String]
        $XboxServicesLiveAuthManagerServiceStartupMode,

        [Parameter()]
        [ValidateSet('manual', 'automatic', 'disabled')]
        [System.String]
        $XboxServicesLiveGameSaveServiceStartupMode,

        [Parameter()]
        [ValidateSet('manual', 'automatic', 'disabled')]
        [System.String]
        $XboxServicesLiveNetworkingServiceStartupMode,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentInstance = Get-TargetResource @PSBoundParameters
    $PSBoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Device Configuration Endpoint Protection Policy for Windows10 with DisplayName {$DisplayName}"
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $CreateParameters = ([Hashtable]$PSBoundParameters).Clone()
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters
        $CreateParameters.Remove('Id') | Out-Null

        $keys = (([Hashtable]$CreateParameters).Clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $CreateParameters.$key -and $CreateParameters.$key.GetType().Name -like '*cimInstance*')
            {
                $CreateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters.$key
            }
        }
        if ($CreateParameters.FirewallRules.Count -gt 0)
        {
            $intuneFirewallRules = @()
            foreach ($firewallRule in $CreateParameters.FirewallRules)
            {
                if ($firewallRule.interfaceTypes -gt 1)
                {
                    $firewallRule.interfaceTypes = $firewallRule.interfaceTypes -join ','
                }
                $intuneFirewallRules += $firewallRule
            }
            $CreateParameters.FirewallRules = $intuneFirewallRules
        }
        #region resource generator code
        $CreateParameters.Add('@odata.type', '#microsoft.graph.windows10EndpointProtectionConfiguration')
        $policy = New-MgBetaDeviceManagementDeviceConfiguration -BodyParameter $CreateParameters
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments

        if ($policy.id)
        {
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $policy.id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/deviceConfigurations'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Device Configuration Endpoint Protection Policy for Windows10 with Id {$($currentInstance.Id)}"
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $UpdateParameters = ([Hashtable]$PSBoundParameters).Clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters

        $UpdateParameters.Remove('Id') | Out-Null

        $keys = (([Hashtable]$UpdateParameters).Clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $UpdateParameters.$key -and $UpdateParameters.$key.GetType().Name -like '*cimInstance*')
            {
                $UpdateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters.$key
            }
        }
        if ($UpdateParameters.FirewallRules.Count -gt 0)
        {
            $intuneFirewallRules = @()
            foreach ($firewallRule in $UpdateParameters.FirewallRules)
            {
                if ($firewallRule.interfaceTypes -gt 1)
                {
                    $firewallRule.interfaceTypes = $firewallRule.interfaceTypes -join ','
                }
                $intuneFirewallRules += $firewallRule
            }
            $UpdateParameters.FirewallRules = $intuneFirewallRules
        }
        #region resource generator code
        $UpdateParameters.Add('@odata.type', '#microsoft.graph.windows10EndpointProtectionConfiguration')
        Update-MgBetaDeviceManagementDeviceConfiguration  `
            -DeviceConfigurationId $currentInstance.Id `
            -BodyParameter $UpdateParameters
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $currentInstance.id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/deviceConfigurations'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Device Configuration Endpoint Protection Policy for Windows10 with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaDeviceManagementDeviceConfiguration -DeviceConfigurationId $currentInstance.Id
        #endregion
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.Boolean]
        $ApplicationGuardAllowCameraMicrophoneRedirection,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardAllowFileSaveOnHost,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardAllowPersistence,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardAllowPrintToLocalPrinters,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardAllowPrintToNetworkPrinters,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardAllowPrintToPDF,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardAllowPrintToXPS,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardAllowVirtualGPU,

        [Parameter()]
        [ValidateSet('notConfigured', 'blockBoth', 'blockHostToContainer', 'blockContainerToHost', 'blockNone')]
        [System.String]
        $ApplicationGuardBlockClipboardSharing,

        [Parameter()]
        [ValidateSet('notConfigured', 'blockImageAndTextFile', 'blockImageFile', 'blockNone', 'blockTextFile')]
        [System.String]
        $ApplicationGuardBlockFileTransfer,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardBlockNonEnterpriseContent,

        [Parameter()]
        [System.String[]]
        $ApplicationGuardCertificateThumbprints,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardEnabled,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabledForEdge', 'enabledForOffice', 'enabledForEdgeAndOffice')]
        [System.String]
        $ApplicationGuardEnabledOptions,

        [Parameter()]
        [System.Boolean]
        $ApplicationGuardForceAuditing,

        [Parameter()]
        [ValidateSet('notConfigured', 'enforceComponentsAndStoreApps', 'auditComponentsAndStoreApps', 'enforceComponentsStoreAppsAndSmartlocker', 'auditComponentsStoreAppsAndSmartlocker')]
        [System.String]
        $AppLockerApplicationControl,

        [Parameter()]
        [System.Boolean]
        $BitLockerAllowStandardUserEncryption,

        [Parameter()]
        [System.Boolean]
        $BitLockerDisableWarningForOtherDiskEncryption,

        [Parameter()]
        [System.Boolean]
        $BitLockerEnableStorageCardEncryptionOnMobile,

        [Parameter()]
        [System.Boolean]
        $BitLockerEncryptDevice,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $BitLockerFixedDrivePolicy,

        [Parameter()]
        [ValidateSet('notConfigured', 'disabled', 'enabledForAzureAd', 'enabledForAzureAdAndHybrid')]
        [System.String]
        $BitLockerRecoveryPasswordRotation,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $BitLockerRemovableDrivePolicy,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $BitLockerSystemDrivePolicy,

        [Parameter()]
        [System.String[]]
        $DefenderAdditionalGuardedFolders,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderAdobeReaderLaunchChildProcess,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderAdvancedRansomewareProtectionType,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowBehaviorMonitoring,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowCloudProtection,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowEndUserAccess,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowIntrusionPreventionSystem,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowOnAccessProtection,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowRealTimeMonitoring,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowScanArchiveFiles,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowScanDownloads,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowScanNetworkFiles,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowScanRemovableDrivesDuringFullScan,

        [Parameter()]
        [System.Boolean]
        $DefenderAllowScanScriptsLoadedInInternetExplorer,

        [Parameter()]
        [System.String[]]
        $DefenderAttackSurfaceReductionExcludedPaths,

        [Parameter()]
        [System.Boolean]
        $DefenderBlockEndUserAccess,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderBlockPersistenceThroughWmiType,

        [Parameter()]
        [System.Boolean]
        $DefenderCheckForSignaturesBeforeRunningScan,

        [Parameter()]
        [ValidateSet('notConfigured', 'high', 'highPlus', 'zeroTolerance')]
        [System.String]
        $DefenderCloudBlockLevel,

        [Parameter()]
        [System.Int32]
        $DefenderCloudExtendedTimeoutInSeconds,

        [Parameter()]
        [System.Int32]
        $DefenderDaysBeforeDeletingQuarantinedMalware,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DefenderDetectedMalwareActions,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableBehaviorMonitoring,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableCatchupFullScan,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableCatchupQuickScan,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableCloudProtection,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableIntrusionPreventionSystem,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableOnAccessProtection,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableRealTimeMonitoring,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableScanArchiveFiles,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableScanDownloads,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableScanNetworkFiles,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableScanRemovableDrivesDuringFullScan,

        [Parameter()]
        [System.Boolean]
        $DefenderDisableScanScriptsLoadedInInternetExplorer,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderEmailContentExecution,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderEmailContentExecutionType,

        [Parameter()]
        [System.Boolean]
        $DefenderEnableLowCpuPriority,

        [Parameter()]
        [System.Boolean]
        $DefenderEnableScanIncomingMail,

        [Parameter()]
        [System.Boolean]
        $DefenderEnableScanMappedNetworkDrivesDuringFullScan,

        [Parameter()]
        [System.String]
        $DefenderExploitProtectionXml,

        [Parameter()]
        [System.String]
        $DefenderExploitProtectionXmlFileName,

        [Parameter()]
        [System.String[]]
        $DefenderFileExtensionsToExclude,

        [Parameter()]
        [System.String[]]
        $DefenderFilesAndFoldersToExclude,

        [Parameter()]
        [System.String[]]
        $DefenderGuardedFoldersAllowedAppPaths,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'blockDiskModification', 'auditDiskModification')]
        [System.String]
        $DefenderGuardMyFoldersType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderNetworkProtectionType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderOfficeAppsExecutableContentCreationOrLaunch,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderOfficeAppsExecutableContentCreationOrLaunchType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderOfficeAppsLaunchChildProcess,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderOfficeAppsLaunchChildProcessType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderOfficeAppsOtherProcessInjection,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderOfficeAppsOtherProcessInjectionType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderOfficeCommunicationAppsLaunchChildProcess,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderOfficeMacroCodeAllowWin32Imports,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderOfficeMacroCodeAllowWin32ImportsType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderPotentiallyUnwantedAppAction,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderPreventCredentialStealingType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderProcessCreation,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderProcessCreationType,

        [Parameter()]
        [System.String[]]
        $DefenderProcessesToExclude,

        [Parameter()]
        [ValidateSet('monitorAllFiles', 'monitorIncomingFilesOnly', 'monitorOutgoingFilesOnly')]
        [System.String]
        $DefenderScanDirection,

        [Parameter()]
        [System.Int32]
        $DefenderScanMaxCpuPercentage,

        [Parameter()]
        [ValidateSet('userDefined', 'disabled', 'quick', 'full')]
        [System.String]
        $DefenderScanType,

        [Parameter()]
        [System.TimeSpan]
        $DefenderScheduledQuickScanTime,

        [Parameter()]
        [ValidateSet('userDefined', 'everyday', 'sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'noScheduledScan')]
        [System.String]
        $DefenderScheduledScanDay,

        [Parameter()]
        [System.TimeSpan]
        $DefenderScheduledScanTime,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderScriptDownloadedPayloadExecution,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderScriptDownloadedPayloadExecutionType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderScriptObfuscatedMacroCode,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderScriptObfuscatedMacroCodeType,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterBlockExploitProtectionOverride,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableAccountUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableAppBrowserUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableClearTpmUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableFamilyUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableHardwareUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableHealthUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableNetworkUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableNotificationAreaUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableRansomwareUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableSecureBootUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableTroubleshootingUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableVirusUI,

        [Parameter()]
        [System.Boolean]
        $DefenderSecurityCenterDisableVulnerableTpmFirmwareUpdateUI,

        [Parameter()]
        [System.String]
        $DefenderSecurityCenterHelpEmail,

        [Parameter()]
        [System.String]
        $DefenderSecurityCenterHelpPhone,

        [Parameter()]
        [System.String]
        $DefenderSecurityCenterHelpURL,

        [Parameter()]
        [ValidateSet('notConfigured', 'displayInAppAndInNotifications', 'displayOnlyInApp', 'displayOnlyInNotifications')]
        [System.String]
        $DefenderSecurityCenterITContactDisplay,

        [Parameter()]
        [ValidateSet('notConfigured', 'blockNoncriticalNotifications', 'blockAllNotifications')]
        [System.String]
        $DefenderSecurityCenterNotificationsFromApp,

        [Parameter()]
        [System.String]
        $DefenderSecurityCenterOrganizationDisplayName,

        [Parameter()]
        [System.Int32]
        $DefenderSignatureUpdateIntervalInHours,

        [Parameter()]
        [ValidateSet('sendSafeSamplesAutomatically', 'alwaysPrompt', 'neverSend', 'sendAllSamplesAutomatically')]
        [System.String]
        $DefenderSubmitSamplesConsentType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderUntrustedExecutable,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderUntrustedExecutableType,

        [Parameter()]
        [ValidateSet('userDefined', 'enable', 'auditMode', 'warn', 'notConfigured')]
        [System.String]
        $DefenderUntrustedUSBProcess,

        [Parameter()]
        [ValidateSet('userDefined', 'block', 'auditMode', 'warn', 'disable')]
        [System.String]
        $DefenderUntrustedUSBProcessType,

        [Parameter()]
        [System.Boolean]
        $DeviceGuardEnableSecureBootWithDMA,

        [Parameter()]
        [System.Boolean]
        $DeviceGuardEnableVirtualizationBasedSecurity,

        [Parameter()]
        [ValidateSet('notConfigured', 'enabled', 'disabled')]
        [System.String]
        $DeviceGuardLaunchSystemGuard,

        [Parameter()]
        [ValidateSet('notConfigured', 'enableWithUEFILock', 'enableWithoutUEFILock', 'disable')]
        [System.String]
        $DeviceGuardLocalSystemAuthorityCredentialGuardSettings,

        [Parameter()]
        [ValidateSet('notConfigured', 'withoutDMA', 'withDMA')]
        [System.String]
        $DeviceGuardSecureBootWithDMA,

        [Parameter()]
        [ValidateSet('deviceDefault', 'blockAll', 'allowAll')]
        [System.String]
        $DmaGuardDeviceEnumerationPolicy,

        [Parameter()]
        [System.Boolean]
        $FirewallBlockStatefulFTP,

        [Parameter()]
        [ValidateSet('deviceDefault', 'none', 'attempt', 'require')]
        [System.String]
        $FirewallCertificateRevocationListCheckMethod,

        [Parameter()]
        [System.Int32]
        $FirewallIdleTimeoutForSecurityAssociationInSeconds,

        [Parameter()]
        [System.Boolean]
        $FirewallIPSecExemptionsAllowDHCP,

        [Parameter()]
        [System.Boolean]
        $FirewallIPSecExemptionsAllowICMP,

        [Parameter()]
        [System.Boolean]
        $FirewallIPSecExemptionsAllowNeighborDiscovery,

        [Parameter()]
        [System.Boolean]
        $FirewallIPSecExemptionsAllowRouterDiscovery,

        [Parameter()]
        [System.Boolean]
        $FirewallIPSecExemptionsNone,

        [Parameter()]
        [System.Boolean]
        $FirewallMergeKeyingModuleSettings,

        [Parameter()]
        [ValidateSet('deviceDefault', 'disabled', 'queueInbound', 'queueOutbound', 'queueBoth')]
        [System.String]
        $FirewallPacketQueueingMethod,

        [Parameter()]
        [ValidateSet('deviceDefault', 'none', 'utF8')]
        [System.String]
        $FirewallPreSharedKeyEncodingMethod,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FirewallProfileDomain,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FirewallProfilePrivate,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FirewallProfilePublic,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $FirewallRules,

        [Parameter()]
        [ValidateSet('lmAndNltm', 'lmNtlmAndNtlmV2', 'lmAndNtlmOnly', 'lmAndNtlmV2', 'lmNtlmV2AndNotLm', 'lmNtlmV2AndNotLmOrNtm')]
        [System.String]
        $LanManagerAuthenticationLevel,

        [Parameter()]
        [System.Boolean]
        $LanManagerWorkstationDisableInsecureGuestLogons,

        [Parameter()]
        [System.String]
        $LocalSecurityOptionsAdministratorAccountName,

        [Parameter()]
        [ValidateSet('notConfigured', 'elevateWithoutPrompting', 'promptForCredentialsOnTheSecureDesktop', 'promptForConsentOnTheSecureDesktop', 'promptForCredentials', 'promptForConsent', 'promptForConsentForNonWindowsBinaries')]
        [System.String]
        $LocalSecurityOptionsAdministratorElevationPromptBehavior,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsAllowAnonymousEnumerationOfSAMAccountsAndShares,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsAllowPKU2UAuthenticationRequests,

        [Parameter()]
        [System.String]
        $LocalSecurityOptionsAllowRemoteCallsToSecurityAccountsManager,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsAllowRemoteCallsToSecurityAccountsManagerHelperBool,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsAllowSystemToBeShutDownWithoutHavingToLogOn,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsAllowUIAccessApplicationElevation,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsAllowUIAccessApplicationsForSecureLocations,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsAllowUndockWithoutHavingToLogon,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsBlockMicrosoftAccounts,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsBlockRemoteLogonWithBlankPassword,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsBlockRemoteOpticalDriveAccess,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsBlockUsersInstallingPrinterDrivers,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsClearVirtualMemoryPageFile,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsClientDigitallySignCommunicationsAlways,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsClientSendUnencryptedPasswordToThirdPartySMBServers,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsDetectApplicationInstallationsAndPromptForElevation,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsDisableAdministratorAccount,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsDisableClientDigitallySignCommunicationsIfServerAgrees,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsDisableGuestAccount,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsDisableServerDigitallySignCommunicationsAlways,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsDisableServerDigitallySignCommunicationsIfClientAgrees,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsDoNotAllowAnonymousEnumerationOfSAMAccounts,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsDoNotRequireCtrlAltDel,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsDoNotStoreLANManagerHashValueOnNextPasswordChange,

        [Parameter()]
        [ValidateSet('notConfigured', 'administrators', 'administratorsAndPowerUsers', 'administratorsAndInteractiveUsers')]
        [System.String]
        $LocalSecurityOptionsFormatAndEjectOfRemovableMediaAllowedUser,

        [Parameter()]
        [System.String]
        $LocalSecurityOptionsGuestAccountName,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsHideLastSignedInUser,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsHideUsernameAtSignIn,

        [Parameter()]
        [ValidateSet('notConfigured', 'administrators', 'administratorsAndPowerUsers', 'administratorsAndInteractiveUsers')]
        [System.String]
        $LocalSecurityOptionsInformationDisplayedOnLockScreen,

        [Parameter()]
        [ValidateSet('notConfigured', 'userDisplayNameDomainUser', 'userDisplayNameOnly', 'doNotDisplayUser')]
        [System.String]
        $LocalSecurityOptionsInformationShownOnLockScreen,

        [Parameter()]
        [System.String]
        $LocalSecurityOptionsLogOnMessageText,

        [Parameter()]
        [System.String]
        $LocalSecurityOptionsLogOnMessageTitle,

        [Parameter()]
        [System.Int32]
        $LocalSecurityOptionsMachineInactivityLimit,

        [Parameter()]
        [System.Int32]
        $LocalSecurityOptionsMachineInactivityLimitInMinutes,

        [Parameter()]
        [ValidateSet('none', 'requireNtmlV2SessionSecurity', 'require128BitEncryption', 'ntlmV2And128BitEncryption')]
        [System.String]
        $LocalSecurityOptionsMinimumSessionSecurityForNtlmSspBasedClients,

        [Parameter()]
        [ValidateSet('none', 'requireNtmlV2SessionSecurity', 'require128BitEncryption', 'ntlmV2And128BitEncryption')]
        [System.String]
        $LocalSecurityOptionsMinimumSessionSecurityForNtlmSspBasedServers,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsOnlyElevateSignedExecutables,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsRestrictAnonymousAccessToNamedPipesAndShares,

        [Parameter()]
        [ValidateSet('noAction', 'lockWorkstation', 'forceLogoff', 'disconnectRemoteDesktopSession')]
        [System.String]
        $LocalSecurityOptionsSmartCardRemovalBehavior,

        [Parameter()]
        [ValidateSet('notConfigured', 'automaticallyDenyElevationRequests', 'promptForCredentialsOnTheSecureDesktop', 'promptForCredentials')]
        [System.String]
        $LocalSecurityOptionsStandardUserElevationPromptBehavior,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsSwitchToSecureDesktopWhenPromptingForElevation,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsUseAdminApprovalMode,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsUseAdminApprovalModeForAdministrators,

        [Parameter()]
        [System.Boolean]
        $LocalSecurityOptionsVirtualizeFileAndRegistryWriteFailuresToPerUserLocations,

        [Parameter()]
        [System.Boolean]
        $SmartScreenBlockOverrideForFiles,

        [Parameter()]
        [System.Boolean]
        $SmartScreenEnableInShell,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsAccessCredentialManagerAsTrustedCaller,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsActAsPartOfTheOperatingSystem,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsAllowAccessFromNetwork,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsBackupData,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsBlockAccessFromNetwork,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsChangeSystemTime,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsCreateGlobalObjects,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsCreatePageFile,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsCreatePermanentSharedObjects,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsCreateSymbolicLinks,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsCreateToken,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsDebugPrograms,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsDelegation,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsDenyLocalLogOn,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsGenerateSecurityAudits,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsImpersonateClient,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsIncreaseSchedulingPriority,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsLoadUnloadDrivers,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsLocalLogOn,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsLockMemory,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsManageAuditingAndSecurityLogs,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsManageVolumes,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsModifyFirmwareEnvironment,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsModifyObjectLabels,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsProfileSingleProcess,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsRemoteDesktopServicesLogOn,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsRemoteShutdown,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsRestoreData,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserRightsTakeOwnership,

        [Parameter()]
        [ValidateSet('notConfigured', 'enable', 'disable')]
        [System.String]
        $WindowsDefenderTamperProtection,

        [Parameter()]
        [ValidateSet('manual', 'automatic', 'disabled')]
        [System.String]
        $XboxServicesAccessoryManagementServiceStartupMode,

        [Parameter()]
        [System.Boolean]
        $XboxServicesEnableXboxGameSaveTask,

        [Parameter()]
        [ValidateSet('manual', 'automatic', 'disabled')]
        [System.String]
        $XboxServicesLiveAuthManagerServiceStartupMode,

        [Parameter()]
        [ValidateSet('manual', 'automatic', 'disabled')]
        [System.String]
        $XboxServicesLiveGameSaveServiceStartupMode,

        [Parameter()]
        [ValidateSet('manual', 'automatic', 'disabled')]
        [System.String]
        $XboxServicesLiveNetworkingServiceStartupMode,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '')
    return $result
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        #region resource generator code
        [array]$getValue = Get-MgBetaDeviceManagementDeviceConfiguration -Filter $Filter -All `
            -ErrorAction Stop | Where-Object `
            -FilterScript { `
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.windows10EndpointProtectionConfiguration' `
        }
        #endregion

        $i = 1
        $dscContent = ''
        if ($getValue.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $getValue)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                Id                    = $config.Id
                DisplayName           = $config.displayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @params

            if ( $null -ne $Results.BitLockerFixedDrivePolicy)
            {
                $complexMapping = @(
                    @{
                        Name            = 'BitLockerFixedDrivePolicy'
                        CimInstanceName = 'MicrosoftGraphBitLockerFixedDrivePolicy'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'RecoveryOptions'
                        CimInstanceName = 'MicrosoftGraphBitLockerRecoveryOptions'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.BitLockerFixedDrivePolicy `
                    -CIMInstanceName 'MicrosoftGraphbitLockerFixedDrivePolicy' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.BitLockerFixedDrivePolicy = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('BitLockerFixedDrivePolicy') | Out-Null
                }
            }
            if ( $null -ne $Results.BitLockerRemovableDrivePolicy)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.BitLockerRemovableDrivePolicy `
                    -CIMInstanceName 'MicrosoftGraphbitLockerRemovableDrivePolicy'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.BitLockerRemovableDrivePolicy = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('BitLockerRemovableDrivePolicy') | Out-Null
                }
            }
            if ( $null -ne $Results.BitLockerSystemDrivePolicy)
            {
                $complexMapping = @(
                    @{
                        Name            = 'BitLockerSystemDrivePolicy'
                        CimInstanceName = 'MicrosoftGraphBitLockerSystemDrivePolicy'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'RecoveryOptions'
                        CimInstanceName = 'MicrosoftGraphBitLockerRecoveryOptions'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.BitLockerSystemDrivePolicy `
                    -CIMInstanceName 'MicrosoftGraphbitLockerSystemDrivePolicy' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.BitLockerSystemDrivePolicy = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('BitLockerSystemDrivePolicy') | Out-Null
                }
            }
            if ( $null -ne $Results.DefenderDetectedMalwareActions)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.DefenderDetectedMalwareActions `
                    -CIMInstanceName 'MicrosoftGraphdefenderDetectedMalwareActions'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.DefenderDetectedMalwareActions = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('DefenderDetectedMalwareActions') | Out-Null
                }
            }
            if ( $null -ne $Results.FirewallProfileDomain)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.FirewallProfileDomain `
                    -CIMInstanceName 'MicrosoftGraphwindowsFirewallNetworkProfile'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.FirewallProfileDomain = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('FirewallProfileDomain') | Out-Null
                }
            }
            if ( $null -ne $Results.FirewallProfilePrivate)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.FirewallProfilePrivate `
                    -CIMInstanceName 'MicrosoftGraphwindowsFirewallNetworkProfile'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.FirewallProfilePrivate = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('FirewallProfilePrivate') | Out-Null
                }
            }
            if ( $null -ne $Results.FirewallProfilePublic)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.FirewallProfilePublic `
                    -CIMInstanceName 'MicrosoftGraphwindowsFirewallNetworkProfile'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.FirewallProfilePublic = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('FirewallProfilePublic') | Out-Null
                }
            }
            if ( $null -ne $Results.FirewallRules)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.FirewallRules `
                    -CIMInstanceName 'MicrosoftGraphwindowsFirewallRule'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.FirewallRules = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('FirewallRules') | Out-Null
                }
            }
            if ( $null -ne $Results.UserRightsAccessCredentialManagerAsTrustedCaller)
            {
                $complexMapping = @(
                    @{
                        Name            = 'UserRightsAccessCredentialManagerAsTrustedCaller'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalUsersOrGroups'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserRightsAccessCredentialManagerAsTrustedCaller `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementUserRightsSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserRightsAccessCredentialManagerAsTrustedCaller = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserRightsAccessCredentialManagerAsTrustedCaller') | Out-Null
                }
            }
            if ( $null -ne $Results.UserRightsActAsPartOfTheOperatingSystem)
            {
                $complexMapping = @(
                    @{
                        Name            = 'UserRightsActAsPartOfTheOperatingSystem'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalUsersOrGroups'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserRightsActAsPartOfTheOperatingSystem `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementUserRightsSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserRightsActAsPartOfTheOperatingSystem = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserRightsActAsPartOfTheOperatingSystem') | Out-Null
                }
            }
            if ( $null -ne $Results.UserRightsAllowAccessFromNetwork)
            {
                $complexMapping = @(
                    @{
                        Name            = 'UserRightsAllowAccessFromNetwork'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalUsersOrGroups'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserRightsAllowAccessFromNetwork `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementUserRightsSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserRightsAllowAccessFromNetwork = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserRightsAllowAccessFromNetwork') | Out-Null
                }
            }
            if ( $null -ne $Results.UserRightsBackupData)
            {
                $complexMapping = @(
                    @{
                        Name            = 'UserRightsBackupData'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalUsersOrGroups'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserRightsBackupData `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementUserRightsSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserRightsBackupData = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserRightsBackupData') | Out-Null
                }
            }
            if ( $null -ne $Results.UserRightsBlockAccessFromNetwork)
            {
                $complexMapping = @(
                    @{
                        Name            = 'UserRightsBlockAccessFromNetwork'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalUsersOrGroups'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserRightsBlockAccessFromNetwork `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementUserRightsSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserRightsBlockAccessFromNetwork = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserRightsBlockAccessFromNetwork') | Out-Null
                }
            }
            if ( $null -ne $Results.UserRightsChangeSystemTime)
            {
                $complexMapping = @(
                    @{
                        Name            = 'UserRightsChangeSystemTime'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalUsersOrGroups'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserRightsChangeSystemTime `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementUserRightsSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserRightsChangeSystemTime = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserRightsChangeSystemTime') | Out-Null
                }
            }
            if ( $null -ne $Results.UserRightsCreateGlobalObjects)
            {
                $complexMapping = @(
                    @{
                        Name            = 'UserRightsCreateGlobalObjects'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalUsersOrGroups'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserRightsCreateGlobalObjects `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementUserRightsSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserRightsCreateGlobalObjects = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserRightsCreateGlobalObjects') | Out-Null
                }
            }
            if ( $null -ne $Results.UserRightsCreatePageFile)
            {
                $complexMapping = @(
                    @{
                        Name            = 'UserRightsCreatePageFile'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalUsersOrGroups'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserRightsCreatePageFile `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementUserRightsSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserRightsCreatePageFile = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserRightsCreatePageFile') | Out-Null
                }
            }
            if ( $null -ne $Results.UserRightsCreatePermanentSharedObjects)
            {
                $complexMapping = @(
                    @{
                        Name            = 'UserRightsCreatePermanentSharedObjects'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalUsersOrGroups'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserRightsCreatePermanentSharedObjects `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementUserRightsSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserRightsCreatePermanentSharedObjects = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserRightsCreatePermanentSharedObjects') | Out-Null
                }
            }
            if ( $null -ne $Results.UserRightsCreateSymbolicLinks)
            {
                $complexMapping = @(
                    @{
                        Name            = 'UserRightsCreateSymbolicLinks'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalUsersOrGroups'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserRightsCreateSymbolicLinks `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementUserRightsSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserRightsCreateSymbolicLinks = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserRightsCreateSymbolicLinks') | Out-Null
                }
            }
            if ( $null -ne $Results.UserRightsCreateToken)
            {
                $complexMapping = @(
                    @{
                        Name            = 'UserRightsCreateToken'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalUsersOrGroups'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserRightsCreateToken `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementUserRightsSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserRightsCreateToken = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserRightsCreateToken') | Out-Null
                }
            }
            if ( $null -ne $Results.UserRightsDebugPrograms)
            {
                $complexMapping = @(
                    @{
                        Name            = 'UserRightsDebugPrograms'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalUsersOrGroups'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserRightsDebugPrograms `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementUserRightsSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserRightsDebugPrograms = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserRightsDebugPrograms') | Out-Null
                }
            }
            if ( $null -ne $Results.UserRightsDelegation)
            {
                $complexMapping = @(
                    @{
                        Name            = 'UserRightsDelegation'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalUsersOrGroups'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserRightsDelegation `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementUserRightsSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserRightsDelegation = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserRightsDelegation') | Out-Null
                }
            }
            if ( $null -ne $Results.UserRightsDenyLocalLogOn)
            {
                $complexMapping = @(
                    @{
                        Name            = 'UserRightsDenyLocalLogOn'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalUsersOrGroups'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserRightsDenyLocalLogOn `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementUserRightsSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserRightsDenyLocalLogOn = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserRightsDenyLocalLogOn') | Out-Null
                }
            }
            if ( $null -ne $Results.UserRightsGenerateSecurityAudits)
            {
                $complexMapping = @(
                    @{
                        Name            = 'UserRightsGenerateSecurityAudits'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalUsersOrGroups'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserRightsGenerateSecurityAudits `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementUserRightsSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserRightsGenerateSecurityAudits = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserRightsGenerateSecurityAudits') | Out-Null
                }
            }
            if ( $null -ne $Results.UserRightsImpersonateClient)
            {
                $complexMapping = @(
                    @{
                        Name            = 'UserRightsImpersonateClient'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalUsersOrGroups'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserRightsImpersonateClient `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementUserRightsSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserRightsImpersonateClient = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserRightsImpersonateClient') | Out-Null
                }
            }
            if ( $null -ne $Results.UserRightsIncreaseSchedulingPriority)
            {
                $complexMapping = @(
                    @{
                        Name            = 'UserRightsIncreaseSchedulingPriority'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalUsersOrGroups'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserRightsIncreaseSchedulingPriority `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementUserRightsSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserRightsIncreaseSchedulingPriority = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserRightsIncreaseSchedulingPriority') | Out-Null
                }
            }
            if ( $null -ne $Results.UserRightsLoadUnloadDrivers)
            {
                $complexMapping = @(
                    @{
                        Name            = 'UserRightsLoadUnloadDrivers'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalUsersOrGroups'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserRightsLoadUnloadDrivers `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementUserRightsSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserRightsLoadUnloadDrivers = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserRightsLoadUnloadDrivers') | Out-Null
                }
            }
            if ( $null -ne $Results.UserRightsLocalLogOn)
            {
                $complexMapping = @(
                    @{
                        Name            = 'UserRightsLocalLogOn'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalUsersOrGroups'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserRightsLocalLogOn `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementUserRightsSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserRightsLocalLogOn = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserRightsLocalLogOn') | Out-Null
                }
            }
            if ( $null -ne $Results.UserRightsLockMemory)
            {
                $complexMapping = @(
                    @{
                        Name            = 'UserRightsLockMemory'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalUsersOrGroups'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserRightsLockMemory `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementUserRightsSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserRightsLockMemory = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserRightsLockMemory') | Out-Null
                }
            }
            if ( $null -ne $Results.UserRightsManageAuditingAndSecurityLogs)
            {
                $complexMapping = @(
                    @{
                        Name            = 'UserRightsManageAuditingAndSecurityLogs'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalUsersOrGroups'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserRightsManageAuditingAndSecurityLogs `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementUserRightsSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserRightsManageAuditingAndSecurityLogs = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserRightsManageAuditingAndSecurityLogs') | Out-Null
                }
            }
            if ( $null -ne $Results.UserRightsManageVolumes)
            {
                $complexMapping = @(
                    @{
                        Name            = 'UserRightsManageVolumes'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalUsersOrGroups'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserRightsManageVolumes `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementUserRightsSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserRightsManageVolumes = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserRightsManageVolumes') | Out-Null
                }
            }
            if ( $null -ne $Results.UserRightsModifyFirmwareEnvironment)
            {
                $complexMapping = @(
                    @{
                        Name            = 'UserRightsModifyFirmwareEnvironment'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalUsersOrGroups'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserRightsModifyFirmwareEnvironment `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementUserRightsSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserRightsModifyFirmwareEnvironment = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserRightsModifyFirmwareEnvironment') | Out-Null
                }
            }
            if ( $null -ne $Results.UserRightsModifyObjectLabels)
            {
                $complexMapping = @(
                    @{
                        Name            = 'UserRightsModifyObjectLabels'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalUsersOrGroups'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserRightsModifyObjectLabels `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementUserRightsSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserRightsModifyObjectLabels = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserRightsModifyObjectLabels') | Out-Null
                }
            }
            if ( $null -ne $Results.UserRightsProfileSingleProcess)
            {
                $complexMapping = @(
                    @{
                        Name            = 'UserRightsProfileSingleProcess'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalUsersOrGroups'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserRightsProfileSingleProcess `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementUserRightsSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserRightsProfileSingleProcess = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserRightsProfileSingleProcess') | Out-Null
                }
            }
            if ( $null -ne $Results.UserRightsRemoteDesktopServicesLogOn)
            {
                $complexMapping = @(
                    @{
                        Name            = 'UserRightsRemoteDesktopServicesLogOn'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalUsersOrGroups'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserRightsRemoteDesktopServicesLogOn `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementUserRightsSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserRightsRemoteDesktopServicesLogOn = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserRightsRemoteDesktopServicesLogOn') | Out-Null
                }
            }
            if ( $null -ne $Results.UserRightsRemoteShutdown)
            {
                $complexMapping = @(
                    @{
                        Name            = 'UserRightsRemoteShutdown'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalUsersOrGroups'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserRightsRemoteShutdown `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementUserRightsSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserRightsRemoteShutdown = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserRightsRemoteShutdown') | Out-Null
                }
            }
            if ( $null -ne $Results.UserRightsRestoreData)
            {
                $complexMapping = @(
                    @{
                        Name            = 'UserRightsRestoreData'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalUsersOrGroups'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserRightsRestoreData `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementUserRightsSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserRightsRestoreData = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserRightsRestoreData') | Out-Null
                }
            }
            if ( $null -ne $Results.UserRightsTakeOwnership)
            {
                $complexMapping = @(
                    @{
                        Name            = 'UserRightsTakeOwnership'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsSetting'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'LocalUsersOrGroups'
                        CimInstanceName = 'MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserRightsTakeOwnership `
                    -CIMInstanceName 'MicrosoftGraphdeviceManagementUserRightsSetting' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserRightsTakeOwnership = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserRightsTakeOwnership') | Out-Null
                }
            }
            if ($Results.Assignments)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.Assignments -CIMInstanceName DeviceManagementConfigurationPolicyAssignments
                if ($complexTypeStringResult)
                {
                    $Results.Assignments = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Assignments') | Out-Null
                }
            }
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('BitLockerFixedDrivePolicy', 'BitLockerRemovableDrivePolicy', 'BitLockerSystemDrivePolicy', 'DefenderDetectedMalwareActions',
                'FirewallProfileDomain', 'FirewallProfilePrivate', 'FirewallProfilePublic', 'FirewallRules',
                'UserRightsAccessCredentialManagerAsTrustedCaller', 'UserRightsActAsPartOfTheOperatingSystem', 'UserRightsAllowAccessFromNetwork',
                'UserRightsBackupData', 'UserRightsBlockAccessFromNetwork', 'UserRightsChangeSystemTime', 'UserRightsCreateGlobalObjects',
                'UserRightsCreatePageFile', 'UserRightsCreatePermanentSharedObjects', 'UserRightsCreateSymbolicLinks', 'UserRightsCreateToken',
                'UserRightsDebugPrograms', 'UserRightsDelegation', 'UserRightsDenyLocalLogOn', 'UserRightsGenerateSecurityAudits',
                'UserRightsImpersonateClient', 'UserRightsIncreaseSchedulingPriority', 'UserRightsLoadUnloadDrivers', 'UserRightsLocalLogOn',
                'UserRightsLockMemory', 'UserRightsManageAuditingAndSecurityLogs', 'UserRightsManageVolumes', 'UserRightsModifyFirmwareEnvironment',
                'UserRightsModifyObjectLabels', 'UserRightsProfileSingleProcess', 'UserRightsRemoteDesktopServicesLogOn', 'UserRightsRemoteShutdown',
                'UserRightsRestoreData', 'UserRightsTakeOwnership', 'Assignments')
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent
    }
    catch
    {
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*" -or `
                $_.Exception -like '*Request not applicable to target tenant*')
        {
            Write-M365DSCHost -Message "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }
        else
        {
            New-M365DSCLogEntry -Message 'Error during Export:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential

            throw
        }
    }
}

Export-ModuleMember -Function *-TargetResource
