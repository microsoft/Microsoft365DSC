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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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
                        -Filter "DisplayName eq '$($DisplayName -replace "'", "''")' and isof('microsoft.graph.windows10EndpointProtectionConfiguration')" `
                        -ErrorAction SilentlyContinue

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
        if ($null -ne $getValue.bitLockerFixedDrivePolicy.encryptionMethod)
        {
            $complexBitLockerFixedDrivePolicy.Add('EncryptionMethod', $getValue.bitLockerFixedDrivePolicy.encryptionMethod.ToString())
        }
        $complexRecoveryOptions = [ordered]@{}
        $complexRecoveryOptions.Add('BlockDataRecoveryAgent', $getValue.bitLockerFixedDrivePolicy.recoveryOptions.blockDataRecoveryAgent)
        $complexRecoveryOptions.Add('EnableBitLockerAfterRecoveryInformationToStore', $getValue.bitLockerFixedDrivePolicy.recoveryOptions.enableBitLockerAfterRecoveryInformationToStore)
        $complexRecoveryOptions.Add('EnableRecoveryInformationSaveToStore', $getValue.bitLockerFixedDrivePolicy.recoveryOptions.enableRecoveryInformationSaveToStore)
        $complexRecoveryOptions.Add('HideRecoveryOptions', $getValue.bitLockerFixedDrivePolicy.recoveryOptions.hideRecoveryOptions)
        if ($null -ne $getValue.bitLockerFixedDrivePolicy.recoveryOptions.recoveryInformationToStore)
        {
            $complexRecoveryOptions.Add('RecoveryInformationToStore', $getValue.bitLockerFixedDrivePolicy.recoveryOptions.recoveryInformationToStore.ToString())
        }
        if ($null -ne $getValue.bitLockerFixedDrivePolicy.recoveryOptions.recoveryKeyUsage)
        {
            $complexRecoveryOptions.Add('RecoveryKeyUsage', $getValue.bitLockerFixedDrivePolicy.recoveryOptions.recoveryKeyUsage.ToString())
        }
        if ($null -ne $getValue.bitLockerFixedDrivePolicy.recoveryOptions.recoveryPasswordUsage)
        {
            $complexRecoveryOptions.Add('RecoveryPasswordUsage', $getValue.bitLockerFixedDrivePolicy.recoveryOptions.recoveryPasswordUsage.ToString())
        }
        if ($complexRecoveryOptions.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexRecoveryOptions = $null
        }
        $complexBitLockerFixedDrivePolicy.Add('RecoveryOptions', $complexRecoveryOptions)
        $complexBitLockerFixedDrivePolicy.Add('RequireEncryptionForWriteAccess', $getValue.bitLockerFixedDrivePolicy.requireEncryptionForWriteAccess)
        if ($complexBitLockerFixedDrivePolicy.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexBitLockerFixedDrivePolicy = $null
        }

        $complexBitLockerRemovableDrivePolicy = [ordered]@{}
        $complexBitLockerRemovableDrivePolicy.Add('BlockCrossOrganizationWriteAccess', $getValue.bitLockerRemovableDrivePolicy.blockCrossOrganizationWriteAccess)
        if ($null -ne $getValue.bitLockerRemovableDrivePolicy.encryptionMethod)
        {
            $complexBitLockerRemovableDrivePolicy.Add('EncryptionMethod', $getValue.bitLockerRemovableDrivePolicy.encryptionMethod.ToString())
        }
        $complexBitLockerRemovableDrivePolicy.Add('RequireEncryptionForWriteAccess', $getValue.bitLockerRemovableDrivePolicy.requireEncryptionForWriteAccess)
        if ($complexBitLockerRemovableDrivePolicy.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexBitLockerRemovableDrivePolicy = $null
        }

        $complexBitLockerSystemDrivePolicy = [ordered]@{}
        if ($null -ne $getValue.bitLockerSystemDrivePolicy.encryptionMethod)
        {
            $complexBitLockerSystemDrivePolicy.Add('EncryptionMethod', $getValue.bitLockerSystemDrivePolicy.encryptionMethod.ToString())
        }
        $complexBitLockerSystemDrivePolicy.Add('MinimumPinLength', $getValue.bitLockerSystemDrivePolicy.minimumPinLength)
        $complexBitLockerSystemDrivePolicy.Add('PrebootRecoveryEnableMessageAndUrl', $getValue.bitLockerSystemDrivePolicy.prebootRecoveryEnableMessageAndUrl)
        $complexBitLockerSystemDrivePolicy.Add('PrebootRecoveryMessage', $getValue.bitLockerSystemDrivePolicy.prebootRecoveryMessage)
        $complexBitLockerSystemDrivePolicy.Add('PrebootRecoveryUrl', $getValue.bitLockerSystemDrivePolicy.prebootRecoveryUrl)
        $complexRecoveryOptions = [ordered]@{}
        $complexRecoveryOptions.Add('BlockDataRecoveryAgent', $getValue.bitLockerSystemDrivePolicy.recoveryOptions.blockDataRecoveryAgent)
        $complexRecoveryOptions.Add('EnableBitLockerAfterRecoveryInformationToStore', $getValue.bitLockerSystemDrivePolicy.recoveryOptions.enableBitLockerAfterRecoveryInformationToStore)
        $complexRecoveryOptions.Add('EnableRecoveryInformationSaveToStore', $getValue.bitLockerSystemDrivePolicy.recoveryOptions.enableRecoveryInformationSaveToStore)
        $complexRecoveryOptions.Add('HideRecoveryOptions', $getValue.bitLockerSystemDrivePolicy.recoveryOptions.hideRecoveryOptions)
        if ($null -ne $getValue.bitLockerSystemDrivePolicy.recoveryOptions.recoveryInformationToStore)
        {
            $complexRecoveryOptions.Add('RecoveryInformationToStore', $getValue.bitLockerSystemDrivePolicy.recoveryOptions.recoveryInformationToStore.ToString())
        }
        if ($null -ne $getValue.bitLockerSystemDrivePolicy.recoveryOptions.recoveryKeyUsage)
        {
            $complexRecoveryOptions.Add('RecoveryKeyUsage', $getValue.bitLockerSystemDrivePolicy.recoveryOptions.recoveryKeyUsage.ToString())
        }
        if ($null -ne $getValue.bitLockerSystemDrivePolicy.recoveryOptions.recoveryPasswordUsage)
        {
            $complexRecoveryOptions.Add('RecoveryPasswordUsage', $getValue.bitLockerSystemDrivePolicy.recoveryOptions.recoveryPasswordUsage.ToString())
        }
        if ($complexRecoveryOptions.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexRecoveryOptions = $null
        }
        $complexBitLockerSystemDrivePolicy.Add('RecoveryOptions', $complexRecoveryOptions)
        $complexBitLockerSystemDrivePolicy.Add('StartupAuthenticationBlockWithoutTpmChip', $getValue.bitLockerSystemDrivePolicy.startupAuthenticationBlockWithoutTpmChip)
        $complexBitLockerSystemDrivePolicy.Add('StartupAuthenticationRequired', $getValue.bitLockerSystemDrivePolicy.startupAuthenticationRequired)
        if ($null -ne $getValue.bitLockerSystemDrivePolicy.startupAuthenticationTpmKeyUsage)
        {
            $complexBitLockerSystemDrivePolicy.Add('StartupAuthenticationTpmKeyUsage', $getValue.bitLockerSystemDrivePolicy.startupAuthenticationTpmKeyUsage.ToString())
        }
        if ($null -ne $getValue.bitLockerSystemDrivePolicy.startupAuthenticationTpmPinAndKeyUsage)
        {
            $complexBitLockerSystemDrivePolicy.Add('StartupAuthenticationTpmPinAndKeyUsage', $getValue.bitLockerSystemDrivePolicy.startupAuthenticationTpmPinAndKeyUsage.ToString())
        }
        if ($null -ne $getValue.bitLockerSystemDrivePolicy.startupAuthenticationTpmPinUsage)
        {
            $complexBitLockerSystemDrivePolicy.Add('StartupAuthenticationTpmPinUsage', $getValue.bitLockerSystemDrivePolicy.startupAuthenticationTpmPinUsage.ToString())
        }
        if ($null -ne $getValue.bitLockerSystemDrivePolicy.startupAuthenticationTpmUsage)
        {
            $complexBitLockerSystemDrivePolicy.Add('StartupAuthenticationTpmUsage', $getValue.bitLockerSystemDrivePolicy.startupAuthenticationTpmUsage.ToString())
        }
        if ($complexBitLockerSystemDrivePolicy.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexBitLockerSystemDrivePolicy = $null
        }

        $complexDefenderDetectedMalwareActions = [ordered]@{}
        if ($null -ne $getValue.defenderDetectedMalwareActions.highSeverity)
        {
            $complexDefenderDetectedMalwareActions.Add('HighSeverity', $getValue.defenderDetectedMalwareActions.highSeverity.ToString())
        }
        if ($null -ne $getValue.defenderDetectedMalwareActions.lowSeverity)
        {
            $complexDefenderDetectedMalwareActions.Add('LowSeverity', $getValue.defenderDetectedMalwareActions.lowSeverity.ToString())
        }
        if ($null -ne $getValue.defenderDetectedMalwareActions.moderateSeverity)
        {
            $complexDefenderDetectedMalwareActions.Add('ModerateSeverity', $getValue.defenderDetectedMalwareActions.moderateSeverity.ToString())
        }
        if ($null -ne $getValue.defenderDetectedMalwareActions.severeSeverity)
        {
            $complexDefenderDetectedMalwareActions.Add('SevereSeverity', $getValue.defenderDetectedMalwareActions.severeSeverity.ToString())
        }
        if ($complexDefenderDetectedMalwareActions.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexDefenderDetectedMalwareActions = $null
        }

        $complexFirewallProfileDomain = [ordered]@{}
        $complexFirewallProfileDomain.Add('AuthorizedApplicationRulesFromGroupPolicyMerged', $getValue.firewallProfileDomain.authorizedApplicationRulesFromGroupPolicyMerged)
        $complexFirewallProfileDomain.Add('AuthorizedApplicationRulesFromGroupPolicyNotMerged', $getValue.firewallProfileDomain.authorizedApplicationRulesFromGroupPolicyNotMerged)
        $complexFirewallProfileDomain.Add('ConnectionSecurityRulesFromGroupPolicyMerged', $getValue.firewallProfileDomain.connectionSecurityRulesFromGroupPolicyMerged)
        $complexFirewallProfileDomain.Add('ConnectionSecurityRulesFromGroupPolicyNotMerged', $getValue.firewallProfileDomain.connectionSecurityRulesFromGroupPolicyNotMerged)
        if ($null -ne $getValue.firewallProfileDomain.firewallEnabled)
        {
            $complexFirewallProfileDomain.Add('FirewallEnabled', $getValue.firewallProfileDomain.firewallEnabled.ToString())
        }
        $complexFirewallProfileDomain.Add('GlobalPortRulesFromGroupPolicyMerged', $getValue.firewallProfileDomain.globalPortRulesFromGroupPolicyMerged)
        $complexFirewallProfileDomain.Add('GlobalPortRulesFromGroupPolicyNotMerged', $getValue.firewallProfileDomain.globalPortRulesFromGroupPolicyNotMerged)
        $complexFirewallProfileDomain.Add('InboundConnectionsBlocked', $getValue.firewallProfileDomain.inboundConnectionsBlocked)
        $complexFirewallProfileDomain.Add('InboundConnectionsRequired', $getValue.firewallProfileDomain.inboundConnectionsRequired)
        $complexFirewallProfileDomain.Add('InboundNotificationsBlocked', $getValue.firewallProfileDomain.inboundNotificationsBlocked)
        $complexFirewallProfileDomain.Add('InboundNotificationsRequired', $getValue.firewallProfileDomain.inboundNotificationsRequired)
        $complexFirewallProfileDomain.Add('IncomingTrafficBlocked', $getValue.firewallProfileDomain.incomingTrafficBlocked)
        $complexFirewallProfileDomain.Add('IncomingTrafficRequired', $getValue.firewallProfileDomain.incomingTrafficRequired)
        $complexFirewallProfileDomain.Add('OutboundConnectionsBlocked', $getValue.firewallProfileDomain.outboundConnectionsBlocked)
        $complexFirewallProfileDomain.Add('OutboundConnectionsRequired', $getValue.firewallProfileDomain.outboundConnectionsRequired)
        $complexFirewallProfileDomain.Add('PolicyRulesFromGroupPolicyMerged', $getValue.firewallProfileDomain.policyRulesFromGroupPolicyMerged)
        $complexFirewallProfileDomain.Add('PolicyRulesFromGroupPolicyNotMerged', $getValue.firewallProfileDomain.policyRulesFromGroupPolicyNotMerged)
        $complexFirewallProfileDomain.Add('SecuredPacketExemptionAllowed', $getValue.firewallProfileDomain.securedPacketExemptionAllowed)
        $complexFirewallProfileDomain.Add('SecuredPacketExemptionBlocked', $getValue.firewallProfileDomain.securedPacketExemptionBlocked)
        $complexFirewallProfileDomain.Add('StealthModeBlocked', $getValue.firewallProfileDomain.stealthModeBlocked)
        $complexFirewallProfileDomain.Add('StealthModeRequired', $getValue.firewallProfileDomain.stealthModeRequired)
        $complexFirewallProfileDomain.Add('UnicastResponsesToMulticastBroadcastsBlocked', $getValue.firewallProfileDomain.unicastResponsesToMulticastBroadcastsBlocked)
        $complexFirewallProfileDomain.Add('UnicastResponsesToMulticastBroadcastsRequired', $getValue.firewallProfileDomain.unicastResponsesToMulticastBroadcastsRequired)
        if ($complexFirewallProfileDomain.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexFirewallProfileDomain = $null
        }

        $complexFirewallProfilePrivate = [ordered]@{}
        $complexFirewallProfilePrivate.Add('AuthorizedApplicationRulesFromGroupPolicyMerged', $getValue.firewallProfilePrivate.authorizedApplicationRulesFromGroupPolicyMerged)
        $complexFirewallProfilePrivate.Add('AuthorizedApplicationRulesFromGroupPolicyNotMerged', $getValue.firewallProfilePrivate.authorizedApplicationRulesFromGroupPolicyNotMerged)
        $complexFirewallProfilePrivate.Add('ConnectionSecurityRulesFromGroupPolicyMerged', $getValue.firewallProfilePrivate.connectionSecurityRulesFromGroupPolicyMerged)
        $complexFirewallProfilePrivate.Add('ConnectionSecurityRulesFromGroupPolicyNotMerged', $getValue.firewallProfilePrivate.connectionSecurityRulesFromGroupPolicyNotMerged)
        if ($null -ne $getValue.firewallProfilePrivate.firewallEnabled)
        {
            $complexFirewallProfilePrivate.Add('FirewallEnabled', $getValue.firewallProfilePrivate.firewallEnabled.ToString())
        }
        $complexFirewallProfilePrivate.Add('GlobalPortRulesFromGroupPolicyMerged', $getValue.firewallProfilePrivate.globalPortRulesFromGroupPolicyMerged)
        $complexFirewallProfilePrivate.Add('GlobalPortRulesFromGroupPolicyNotMerged', $getValue.firewallProfilePrivate.globalPortRulesFromGroupPolicyNotMerged)
        $complexFirewallProfilePrivate.Add('InboundConnectionsBlocked', $getValue.firewallProfilePrivate.inboundConnectionsBlocked)
        $complexFirewallProfilePrivate.Add('InboundConnectionsRequired', $getValue.firewallProfilePrivate.inboundConnectionsRequired)
        $complexFirewallProfilePrivate.Add('InboundNotificationsBlocked', $getValue.firewallProfilePrivate.inboundNotificationsBlocked)
        $complexFirewallProfilePrivate.Add('InboundNotificationsRequired', $getValue.firewallProfilePrivate.inboundNotificationsRequired)
        $complexFirewallProfilePrivate.Add('IncomingTrafficBlocked', $getValue.firewallProfilePrivate.incomingTrafficBlocked)
        $complexFirewallProfilePrivate.Add('IncomingTrafficRequired', $getValue.firewallProfilePrivate.incomingTrafficRequired)
        $complexFirewallProfilePrivate.Add('OutboundConnectionsBlocked', $getValue.firewallProfilePrivate.outboundConnectionsBlocked)
        $complexFirewallProfilePrivate.Add('OutboundConnectionsRequired', $getValue.firewallProfilePrivate.outboundConnectionsRequired)
        $complexFirewallProfilePrivate.Add('PolicyRulesFromGroupPolicyMerged', $getValue.firewallProfilePrivate.policyRulesFromGroupPolicyMerged)
        $complexFirewallProfilePrivate.Add('PolicyRulesFromGroupPolicyNotMerged', $getValue.firewallProfilePrivate.policyRulesFromGroupPolicyNotMerged)
        $complexFirewallProfilePrivate.Add('SecuredPacketExemptionAllowed', $getValue.firewallProfilePrivate.securedPacketExemptionAllowed)
        $complexFirewallProfilePrivate.Add('SecuredPacketExemptionBlocked', $getValue.firewallProfilePrivate.securedPacketExemptionBlocked)
        $complexFirewallProfilePrivate.Add('StealthModeBlocked', $getValue.firewallProfilePrivate.stealthModeBlocked)
        $complexFirewallProfilePrivate.Add('StealthModeRequired', $getValue.firewallProfilePrivate.stealthModeRequired)
        $complexFirewallProfilePrivate.Add('UnicastResponsesToMulticastBroadcastsBlocked', $getValue.firewallProfilePrivate.unicastResponsesToMulticastBroadcastsBlocked)
        $complexFirewallProfilePrivate.Add('UnicastResponsesToMulticastBroadcastsRequired', $getValue.firewallProfilePrivate.unicastResponsesToMulticastBroadcastsRequired)
        if ($complexFirewallProfilePrivate.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexFirewallProfilePrivate = $null
        }

        $complexFirewallProfilePublic = [ordered]@{}
        $complexFirewallProfilePublic.Add('AuthorizedApplicationRulesFromGroupPolicyMerged', $getValue.firewallProfilePublic.authorizedApplicationRulesFromGroupPolicyMerged)
        $complexFirewallProfilePublic.Add('AuthorizedApplicationRulesFromGroupPolicyNotMerged', $getValue.firewallProfilePublic.authorizedApplicationRulesFromGroupPolicyNotMerged)
        $complexFirewallProfilePublic.Add('ConnectionSecurityRulesFromGroupPolicyMerged', $getValue.firewallProfilePublic.connectionSecurityRulesFromGroupPolicyMerged)
        $complexFirewallProfilePublic.Add('ConnectionSecurityRulesFromGroupPolicyNotMerged', $getValue.firewallProfilePublic.connectionSecurityRulesFromGroupPolicyNotMerged)
        if ($null -ne $getValue.firewallProfilePublic.firewallEnabled)
        {
            $complexFirewallProfilePublic.Add('FirewallEnabled', $getValue.firewallProfilePublic.firewallEnabled.ToString())
        }
        $complexFirewallProfilePublic.Add('GlobalPortRulesFromGroupPolicyMerged', $getValue.firewallProfilePublic.globalPortRulesFromGroupPolicyMerged)
        $complexFirewallProfilePublic.Add('GlobalPortRulesFromGroupPolicyNotMerged', $getValue.firewallProfilePublic.globalPortRulesFromGroupPolicyNotMerged)
        $complexFirewallProfilePublic.Add('InboundConnectionsBlocked', $getValue.firewallProfilePublic.inboundConnectionsBlocked)
        $complexFirewallProfilePublic.Add('InboundConnectionsRequired', $getValue.firewallProfilePublic.inboundConnectionsRequired)
        $complexFirewallProfilePublic.Add('InboundNotificationsBlocked', $getValue.firewallProfilePublic.inboundNotificationsBlocked)
        $complexFirewallProfilePublic.Add('InboundNotificationsRequired', $getValue.firewallProfilePublic.inboundNotificationsRequired)
        $complexFirewallProfilePublic.Add('IncomingTrafficBlocked', $getValue.firewallProfilePublic.incomingTrafficBlocked)
        $complexFirewallProfilePublic.Add('IncomingTrafficRequired', $getValue.firewallProfilePublic.incomingTrafficRequired)
        $complexFirewallProfilePublic.Add('OutboundConnectionsBlocked', $getValue.firewallProfilePublic.outboundConnectionsBlocked)
        $complexFirewallProfilePublic.Add('OutboundConnectionsRequired', $getValue.firewallProfilePublic.outboundConnectionsRequired)
        $complexFirewallProfilePublic.Add('PolicyRulesFromGroupPolicyMerged', $getValue.firewallProfilePublic.policyRulesFromGroupPolicyMerged)
        $complexFirewallProfilePublic.Add('PolicyRulesFromGroupPolicyNotMerged', $getValue.firewallProfilePublic.policyRulesFromGroupPolicyNotMerged)
        $complexFirewallProfilePublic.Add('SecuredPacketExemptionAllowed', $getValue.firewallProfilePublic.securedPacketExemptionAllowed)
        $complexFirewallProfilePublic.Add('SecuredPacketExemptionBlocked', $getValue.firewallProfilePublic.securedPacketExemptionBlocked)
        $complexFirewallProfilePublic.Add('StealthModeBlocked', $getValue.firewallProfilePublic.stealthModeBlocked)
        $complexFirewallProfilePublic.Add('StealthModeRequired', $getValue.firewallProfilePublic.stealthModeRequired)
        $complexFirewallProfilePublic.Add('UnicastResponsesToMulticastBroadcastsBlocked', $getValue.firewallProfilePublic.unicastResponsesToMulticastBroadcastsBlocked)
        $complexFirewallProfilePublic.Add('UnicastResponsesToMulticastBroadcastsRequired', $getValue.firewallProfilePublic.unicastResponsesToMulticastBroadcastsRequired)
        if ($complexFirewallProfilePublic.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexFirewallProfilePublic = $null
        }

        $complexFirewallRules = @()
        foreach ($currentfirewallRules in $getValue.firewallRules)
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
                $myfirewallRules.Add('InterfaceTypes', [System.String[]]($currentfirewallRules.interfaceTypes.ToString().Split(',') | Where-Object { -not [System.String]::IsNullOrEmpty($_) }))
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
        foreach ($currentLocalUsersOrGroups in $getValue.userRightsAccessCredentialManagerAsTrustedCaller.localUsersOrGroups)
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
        if ($null -ne $getValue.userRightsAccessCredentialManagerAsTrustedCaller.state)
        {
            $complexUserRightsAccessCredentialManagerAsTrustedCaller.Add('State', $getValue.userRightsAccessCredentialManagerAsTrustedCaller.state.ToString())
        }
        if ($complexUserRightsAccessCredentialManagerAsTrustedCaller.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsAccessCredentialManagerAsTrustedCaller = $null
        }

        $complexUserRightsActAsPartOfTheOperatingSystem = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.userRightsActAsPartOfTheOperatingSystem.localUsersOrGroups)
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
        if ($null -ne $getValue.userRightsActAsPartOfTheOperatingSystem.state)
        {
            $complexUserRightsActAsPartOfTheOperatingSystem.Add('State', $getValue.userRightsActAsPartOfTheOperatingSystem.state.ToString())
        }
        if ($complexUserRightsActAsPartOfTheOperatingSystem.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsActAsPartOfTheOperatingSystem = $null
        }

        $complexUserRightsAllowAccessFromNetwork = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.userRightsAllowAccessFromNetwork.localUsersOrGroups)
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
        if ($null -ne $getValue.userRightsAllowAccessFromNetwork.state)
        {
            $complexUserRightsAllowAccessFromNetwork.Add('State', $getValue.userRightsAllowAccessFromNetwork.state.ToString())
        }
        if ($complexUserRightsAllowAccessFromNetwork.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsAllowAccessFromNetwork = $null
        }

        $complexUserRightsBackupData = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.userRightsBackupData.localUsersOrGroups)
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
        if ($null -ne $getValue.userRightsBackupData.state)
        {
            $complexUserRightsBackupData.Add('State', $getValue.userRightsBackupData.state.ToString())
        }
        if ($complexUserRightsBackupData.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsBackupData = $null
        }

        $complexUserRightsBlockAccessFromNetwork = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.userRightsBlockAccessFromNetwork.localUsersOrGroups)
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
        if ($null -ne $getValue.userRightsBlockAccessFromNetwork.state)
        {
            $complexUserRightsBlockAccessFromNetwork.Add('State', $getValue.userRightsBlockAccessFromNetwork.state.ToString())
        }
        if ($complexUserRightsBlockAccessFromNetwork.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsBlockAccessFromNetwork = $null
        }

        $complexUserRightsChangeSystemTime = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.userRightsChangeSystemTime.localUsersOrGroups)
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
        if ($null -ne $getValue.userRightsChangeSystemTime.state)
        {
            $complexUserRightsChangeSystemTime.Add('State', $getValue.userRightsChangeSystemTime.state.ToString())
        }
        if ($complexUserRightsChangeSystemTime.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsChangeSystemTime = $null
        }

        $complexUserRightsCreateGlobalObjects = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.userRightsCreateGlobalObjects.localUsersOrGroups)
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
        if ($null -ne $getValue.userRightsCreateGlobalObjects.state)
        {
            $complexUserRightsCreateGlobalObjects.Add('State', $getValue.userRightsCreateGlobalObjects.state.ToString())
        }
        if ($complexUserRightsCreateGlobalObjects.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsCreateGlobalObjects = $null
        }

        $complexUserRightsCreatePageFile = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.userRightsCreatePageFile.localUsersOrGroups)
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
        if ($null -ne $getValue.userRightsCreatePageFile.state)
        {
            $complexUserRightsCreatePageFile.Add('State', $getValue.userRightsCreatePageFile.state.ToString())
        }
        if ($complexUserRightsCreatePageFile.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsCreatePageFile = $null
        }

        $complexUserRightsCreatePermanentSharedObjects = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.userRightsCreatePermanentSharedObjects.localUsersOrGroups)
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
        if ($null -ne $getValue.userRightsCreatePermanentSharedObjects.state)
        {
            $complexUserRightsCreatePermanentSharedObjects.Add('State', $getValue.userRightsCreatePermanentSharedObjects.state.ToString())
        }
        if ($complexUserRightsCreatePermanentSharedObjects.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsCreatePermanentSharedObjects = $null
        }

        $complexUserRightsCreateSymbolicLinks = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.userRightsCreateSymbolicLinks.localUsersOrGroups)
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
        if ($null -ne $getValue.userRightsCreateSymbolicLinks.state)
        {
            $complexUserRightsCreateSymbolicLinks.Add('State', $getValue.userRightsCreateSymbolicLinks.state.ToString())
        }
        if ($complexUserRightsCreateSymbolicLinks.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsCreateSymbolicLinks = $null
        }

        $complexUserRightsCreateToken = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.userRightsCreateToken.localUsersOrGroups)
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
        if ($null -ne $getValue.userRightsCreateToken.state)
        {
            $complexUserRightsCreateToken.Add('State', $getValue.userRightsCreateToken.state.ToString())
        }
        if ($complexUserRightsCreateToken.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsCreateToken = $null
        }

        $complexUserRightsDebugPrograms = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.userRightsDebugPrograms.localUsersOrGroups)
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
        if ($null -ne $getValue.userRightsDebugPrograms.state)
        {
            $complexUserRightsDebugPrograms.Add('State', $getValue.userRightsDebugPrograms.state.ToString())
        }
        if ($complexUserRightsDebugPrograms.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsDebugPrograms = $null
        }

        $complexUserRightsDelegation = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.userRightsDelegation.localUsersOrGroups)
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
        if ($null -ne $getValue.userRightsDelegation.state)
        {
            $complexUserRightsDelegation.Add('State', $getValue.userRightsDelegation.state.ToString())
        }
        if ($complexUserRightsDelegation.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsDelegation = $null
        }

        $complexUserRightsDenyLocalLogOn = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.userRightsDenyLocalLogOn.localUsersOrGroups)
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
        if ($null -ne $getValue.userRightsDenyLocalLogOn.state)
        {
            $complexUserRightsDenyLocalLogOn.Add('State', $getValue.userRightsDenyLocalLogOn.state.ToString())
        }
        if ($complexUserRightsDenyLocalLogOn.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsDenyLocalLogOn = $null
        }

        $complexUserRightsGenerateSecurityAudits = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.userRightsGenerateSecurityAudits.localUsersOrGroups)
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
        if ($null -ne $getValue.userRightsGenerateSecurityAudits.state)
        {
            $complexUserRightsGenerateSecurityAudits.Add('State', $getValue.userRightsGenerateSecurityAudits.state.ToString())
        }
        if ($complexUserRightsGenerateSecurityAudits.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsGenerateSecurityAudits = $null
        }

        $complexUserRightsImpersonateClient = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.userRightsImpersonateClient.localUsersOrGroups)
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
        if ($null -ne $getValue.userRightsImpersonateClient.state)
        {
            $complexUserRightsImpersonateClient.Add('State', $getValue.userRightsImpersonateClient.state.ToString())
        }
        if ($complexUserRightsImpersonateClient.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsImpersonateClient = $null
        }

        $complexUserRightsIncreaseSchedulingPriority = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.userRightsIncreaseSchedulingPriority.localUsersOrGroups)
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
        if ($null -ne $getValue.userRightsIncreaseSchedulingPriority.state)
        {
            $complexUserRightsIncreaseSchedulingPriority.Add('State', $getValue.userRightsIncreaseSchedulingPriority.state.ToString())
        }
        if ($complexUserRightsIncreaseSchedulingPriority.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsIncreaseSchedulingPriority = $null
        }

        $complexUserRightsLoadUnloadDrivers = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.userRightsLoadUnloadDrivers.localUsersOrGroups)
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
        if ($null -ne $getValue.userRightsLoadUnloadDrivers.state)
        {
            $complexUserRightsLoadUnloadDrivers.Add('State', $getValue.userRightsLoadUnloadDrivers.state.ToString())
        }
        if ($complexUserRightsLoadUnloadDrivers.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsLoadUnloadDrivers = $null
        }

        $complexUserRightsLocalLogOn = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.userRightsLocalLogOn.localUsersOrGroups)
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
        if ($null -ne $getValue.userRightsLocalLogOn.state)
        {
            $complexUserRightsLocalLogOn.Add('State', $getValue.userRightsLocalLogOn.state.ToString())
        }
        if ($complexUserRightsLocalLogOn.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsLocalLogOn = $null
        }

        $complexUserRightsLockMemory = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.userRightsLockMemory.localUsersOrGroups)
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
        if ($null -ne $getValue.userRightsLockMemory.state)
        {
            $complexUserRightsLockMemory.Add('State', $getValue.userRightsLockMemory.state.ToString())
        }
        if ($complexUserRightsLockMemory.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsLockMemory = $null
        }

        $complexUserRightsManageAuditingAndSecurityLogs = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.userRightsManageAuditingAndSecurityLogs.localUsersOrGroups)
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
        if ($null -ne $getValue.userRightsManageAuditingAndSecurityLogs.state)
        {
            $complexUserRightsManageAuditingAndSecurityLogs.Add('State', $getValue.userRightsManageAuditingAndSecurityLogs.state.ToString())
        }
        if ($complexUserRightsManageAuditingAndSecurityLogs.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsManageAuditingAndSecurityLogs = $null
        }

        $complexUserRightsManageVolumes = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.userRightsManageVolumes.localUsersOrGroups)
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
        if ($null -ne $getValue.userRightsManageVolumes.state)
        {
            $complexUserRightsManageVolumes.Add('State', $getValue.userRightsManageVolumes.state.ToString())
        }
        if ($complexUserRightsManageVolumes.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsManageVolumes = $null
        }

        $complexUserRightsModifyFirmwareEnvironment = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.userRightsModifyFirmwareEnvironment.localUsersOrGroups)
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
        if ($null -ne $getValue.userRightsModifyFirmwareEnvironment.state)
        {
            $complexUserRightsModifyFirmwareEnvironment.Add('State', $getValue.userRightsModifyFirmwareEnvironment.state.ToString())
        }
        if ($complexUserRightsModifyFirmwareEnvironment.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsModifyFirmwareEnvironment = $null
        }

        $complexUserRightsModifyObjectLabels = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.userRightsModifyObjectLabels.localUsersOrGroups)
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
        if ($null -ne $getValue.userRightsModifyObjectLabels.state)
        {
            $complexUserRightsModifyObjectLabels.Add('State', $getValue.userRightsModifyObjectLabels.state.ToString())
        }
        if ($complexUserRightsModifyObjectLabels.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsModifyObjectLabels = $null
        }

        $complexUserRightsProfileSingleProcess = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.userRightsProfileSingleProcess.localUsersOrGroups)
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
        if ($null -ne $getValue.userRightsProfileSingleProcess.state)
        {
            $complexUserRightsProfileSingleProcess.Add('State', $getValue.userRightsProfileSingleProcess.state.ToString())
        }
        if ($complexUserRightsProfileSingleProcess.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsProfileSingleProcess = $null
        }

        $complexUserRightsRemoteDesktopServicesLogOn = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.userRightsRemoteDesktopServicesLogOn.localUsersOrGroups)
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
        if ($null -ne $getValue.userRightsRemoteDesktopServicesLogOn.state)
        {
            $complexUserRightsRemoteDesktopServicesLogOn.Add('State', $getValue.userRightsRemoteDesktopServicesLogOn.state.ToString())
        }
        if ($complexUserRightsRemoteDesktopServicesLogOn.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsRemoteDesktopServicesLogOn = $null
        }

        $complexUserRightsRemoteShutdown = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.userRightsRemoteShutdown.localUsersOrGroups)
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
        if ($null -ne $getValue.userRightsRemoteShutdown.state)
        {
            $complexUserRightsRemoteShutdown.Add('State', $getValue.userRightsRemoteShutdown.state.ToString())
        }
        if ($complexUserRightsRemoteShutdown.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsRemoteShutdown = $null
        }

        $complexUserRightsRestoreData = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.userRightsRestoreData.localUsersOrGroups)
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
        if ($null -ne $getValue.userRightsRestoreData.state)
        {
            $complexUserRightsRestoreData.Add('State', $getValue.userRightsRestoreData.state.ToString())
        }
        if ($complexUserRightsRestoreData.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsRestoreData = $null
        }

        $complexUserRightsTakeOwnership = [ordered]@{}
        $complexLocalUsersOrGroups = @()
        foreach ($currentLocalUsersOrGroups in $getValue.userRightsTakeOwnership.localUsersOrGroups)
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
        if ($null -ne $getValue.userRightsTakeOwnership.state)
        {
            $complexUserRightsTakeOwnership.Add('State', $getValue.userRightsTakeOwnership.state.ToString())
        }
        if ($complexUserRightsTakeOwnership.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserRightsTakeOwnership = $null
        }

        #endregion

        #region resource generator code
        $enumApplicationGuardBlockClipboardSharing = $null
        if ($null -ne $getValue.applicationGuardBlockClipboardSharing)
        {
            $enumApplicationGuardBlockClipboardSharing = $getValue.applicationGuardBlockClipboardSharing.ToString()
        }

        $enumApplicationGuardBlockFileTransfer = $null
        if ($null -ne $getValue.applicationGuardBlockFileTransfer)
        {
            $enumApplicationGuardBlockFileTransfer = $getValue.applicationGuardBlockFileTransfer.ToString()
        }

        $enumApplicationGuardEnabledOptions = $null
        if ($null -ne $getValue.applicationGuardEnabledOptions)
        {
            $enumApplicationGuardEnabledOptions = $getValue.applicationGuardEnabledOptions.ToString()
        }

        $enumAppLockerApplicationControl = $null
        if ($null -ne $getValue.appLockerApplicationControl)
        {
            $enumAppLockerApplicationControl = $getValue.appLockerApplicationControl.ToString()
        }

        $enumBitLockerRecoveryPasswordRotation = $null
        if ($null -ne $getValue.bitLockerRecoveryPasswordRotation)
        {
            $enumBitLockerRecoveryPasswordRotation = $getValue.bitLockerRecoveryPasswordRotation.ToString()
        }

        $enumDefenderAdobeReaderLaunchChildProcess = $null
        if ($null -ne $getValue.defenderAdobeReaderLaunchChildProcess)
        {
            $enumDefenderAdobeReaderLaunchChildProcess = $getValue.defenderAdobeReaderLaunchChildProcess.ToString()
        }

        $enumDefenderAdvancedRansomewareProtectionType = $null
        if ($null -ne $getValue.defenderAdvancedRansomewareProtectionType)
        {
            $enumDefenderAdvancedRansomewareProtectionType = $getValue.defenderAdvancedRansomewareProtectionType.ToString()
        }

        $enumDefenderBlockPersistenceThroughWmiType = $null
        if ($null -ne $getValue.defenderBlockPersistenceThroughWmiType)
        {
            $enumDefenderBlockPersistenceThroughWmiType = $getValue.defenderBlockPersistenceThroughWmiType.ToString()
        }

        $enumDefenderCloudBlockLevel = $null
        if ($null -ne $getValue.defenderCloudBlockLevel)
        {
            $enumDefenderCloudBlockLevel = $getValue.defenderCloudBlockLevel.ToString()
        }

        $enumDefenderEmailContentExecution = $null
        if ($null -ne $getValue.defenderEmailContentExecution)
        {
            $enumDefenderEmailContentExecution = $getValue.defenderEmailContentExecution.ToString()
        }

        $enumDefenderEmailContentExecutionType = $null
        if ($null -ne $getValue.defenderEmailContentExecutionType)
        {
            $enumDefenderEmailContentExecutionType = $getValue.defenderEmailContentExecutionType.ToString()
        }

        $enumDefenderGuardMyFoldersType = $null
        if ($null -ne $getValue.defenderGuardMyFoldersType)
        {
            $enumDefenderGuardMyFoldersType = $getValue.defenderGuardMyFoldersType.ToString()
        }

        $enumDefenderNetworkProtectionType = $null
        if ($null -ne $getValue.defenderNetworkProtectionType)
        {
            $enumDefenderNetworkProtectionType = $getValue.defenderNetworkProtectionType.ToString()
        }

        $enumDefenderOfficeAppsExecutableContentCreationOrLaunch = $null
        if ($null -ne $getValue.defenderOfficeAppsExecutableContentCreationOrLaunch)
        {
            $enumDefenderOfficeAppsExecutableContentCreationOrLaunch = $getValue.defenderOfficeAppsExecutableContentCreationOrLaunch.ToString()
        }

        $enumDefenderOfficeAppsExecutableContentCreationOrLaunchType = $null
        if ($null -ne $getValue.defenderOfficeAppsExecutableContentCreationOrLaunchType)
        {
            $enumDefenderOfficeAppsExecutableContentCreationOrLaunchType = $getValue.defenderOfficeAppsExecutableContentCreationOrLaunchType.ToString()
        }

        $enumDefenderOfficeAppsLaunchChildProcess = $null
        if ($null -ne $getValue.defenderOfficeAppsLaunchChildProcess)
        {
            $enumDefenderOfficeAppsLaunchChildProcess = $getValue.defenderOfficeAppsLaunchChildProcess.ToString()
        }

        $enumDefenderOfficeAppsLaunchChildProcessType = $null
        if ($null -ne $getValue.defenderOfficeAppsLaunchChildProcessType)
        {
            $enumDefenderOfficeAppsLaunchChildProcessType = $getValue.defenderOfficeAppsLaunchChildProcessType.ToString()
        }

        $enumDefenderOfficeAppsOtherProcessInjection = $null
        if ($null -ne $getValue.defenderOfficeAppsOtherProcessInjection)
        {
            $enumDefenderOfficeAppsOtherProcessInjection = $getValue.defenderOfficeAppsOtherProcessInjection.ToString()
        }

        $enumDefenderOfficeAppsOtherProcessInjectionType = $null
        if ($null -ne $getValue.defenderOfficeAppsOtherProcessInjectionType)
        {
            $enumDefenderOfficeAppsOtherProcessInjectionType = $getValue.defenderOfficeAppsOtherProcessInjectionType.ToString()
        }

        $enumDefenderOfficeCommunicationAppsLaunchChildProcess = $null
        if ($null -ne $getValue.defenderOfficeCommunicationAppsLaunchChildProcess)
        {
            $enumDefenderOfficeCommunicationAppsLaunchChildProcess = $getValue.defenderOfficeCommunicationAppsLaunchChildProcess.ToString()
        }

        $enumDefenderOfficeMacroCodeAllowWin32Imports = $null
        if ($null -ne $getValue.defenderOfficeMacroCodeAllowWin32Imports)
        {
            $enumDefenderOfficeMacroCodeAllowWin32Imports = $getValue.defenderOfficeMacroCodeAllowWin32Imports.ToString()
        }

        $enumDefenderOfficeMacroCodeAllowWin32ImportsType = $null
        if ($null -ne $getValue.defenderOfficeMacroCodeAllowWin32ImportsType)
        {
            $enumDefenderOfficeMacroCodeAllowWin32ImportsType = $getValue.defenderOfficeMacroCodeAllowWin32ImportsType.ToString()
        }

        $enumDefenderPotentiallyUnwantedAppAction = $null
        if ($null -ne $getValue.defenderPotentiallyUnwantedAppAction)
        {
            $enumDefenderPotentiallyUnwantedAppAction = $getValue.defenderPotentiallyUnwantedAppAction.ToString()
        }

        $enumDefenderPreventCredentialStealingType = $null
        if ($null -ne $getValue.defenderPreventCredentialStealingType)
        {
            $enumDefenderPreventCredentialStealingType = $getValue.defenderPreventCredentialStealingType.ToString()
        }

        $enumDefenderProcessCreation = $null
        if ($null -ne $getValue.defenderProcessCreation)
        {
            $enumDefenderProcessCreation = $getValue.defenderProcessCreation.ToString()
        }

        $enumDefenderProcessCreationType = $null
        if ($null -ne $getValue.defenderProcessCreationType)
        {
            $enumDefenderProcessCreationType = $getValue.defenderProcessCreationType.ToString()
        }

        $enumDefenderScanDirection = $null
        if ($null -ne $getValue.defenderScanDirection)
        {
            $enumDefenderScanDirection = $getValue.defenderScanDirection.ToString()
        }

        $enumDefenderScanType = $null
        if ($null -ne $getValue.defenderScanType)
        {
            $enumDefenderScanType = $getValue.defenderScanType.ToString()
        }

        $enumDefenderScheduledScanDay = $null
        if ($null -ne $getValue.defenderScheduledScanDay)
        {
            $enumDefenderScheduledScanDay = $getValue.defenderScheduledScanDay.ToString()
        }

        $enumDefenderScriptDownloadedPayloadExecution = $null
        if ($null -ne $getValue.defenderScriptDownloadedPayloadExecution)
        {
            $enumDefenderScriptDownloadedPayloadExecution = $getValue.defenderScriptDownloadedPayloadExecution.ToString()
        }

        $enumDefenderScriptDownloadedPayloadExecutionType = $null
        if ($null -ne $getValue.defenderScriptDownloadedPayloadExecutionType)
        {
            $enumDefenderScriptDownloadedPayloadExecutionType = $getValue.defenderScriptDownloadedPayloadExecutionType.ToString()
        }

        $enumDefenderScriptObfuscatedMacroCode = $null
        if ($null -ne $getValue.defenderScriptObfuscatedMacroCode)
        {
            $enumDefenderScriptObfuscatedMacroCode = $getValue.defenderScriptObfuscatedMacroCode.ToString()
        }

        $enumDefenderScriptObfuscatedMacroCodeType = $null
        if ($null -ne $getValue.defenderScriptObfuscatedMacroCodeType)
        {
            $enumDefenderScriptObfuscatedMacroCodeType = $getValue.defenderScriptObfuscatedMacroCodeType.ToString()
        }

        $enumDefenderSecurityCenterITContactDisplay = $null
        if ($null -ne $getValue.defenderSecurityCenterITContactDisplay)
        {
            $enumDefenderSecurityCenterITContactDisplay = $getValue.defenderSecurityCenterITContactDisplay.ToString()
        }

        $enumDefenderSecurityCenterNotificationsFromApp = $null
        if ($null -ne $getValue.defenderSecurityCenterNotificationsFromApp)
        {
            $enumDefenderSecurityCenterNotificationsFromApp = $getValue.defenderSecurityCenterNotificationsFromApp.ToString()
        }

        $enumDefenderSubmitSamplesConsentType = $null
        if ($null -ne $getValue.defenderSubmitSamplesConsentType)
        {
            $enumDefenderSubmitSamplesConsentType = $getValue.defenderSubmitSamplesConsentType.ToString()
        }

        $enumDefenderUntrustedExecutable = $null
        if ($null -ne $getValue.defenderUntrustedExecutable)
        {
            $enumDefenderUntrustedExecutable = $getValue.defenderUntrustedExecutable.ToString()
        }

        $enumDefenderUntrustedExecutableType = $null
        if ($null -ne $getValue.defenderUntrustedExecutableType)
        {
            $enumDefenderUntrustedExecutableType = $getValue.defenderUntrustedExecutableType.ToString()
        }

        $enumDefenderUntrustedUSBProcess = $null
        if ($null -ne $getValue.defenderUntrustedUSBProcess)
        {
            $enumDefenderUntrustedUSBProcess = $getValue.defenderUntrustedUSBProcess.ToString()
        }

        $enumDefenderUntrustedUSBProcessType = $null
        if ($null -ne $getValue.defenderUntrustedUSBProcessType)
        {
            $enumDefenderUntrustedUSBProcessType = $getValue.defenderUntrustedUSBProcessType.ToString()
        }

        $enumDeviceGuardLaunchSystemGuard = $null
        if ($null -ne $getValue.deviceGuardLaunchSystemGuard)
        {
            $enumDeviceGuardLaunchSystemGuard = $getValue.deviceGuardLaunchSystemGuard.ToString()
        }

        $enumDeviceGuardLocalSystemAuthorityCredentialGuardSettings = $null
        if ($null -ne $getValue.deviceGuardLocalSystemAuthorityCredentialGuardSettings)
        {
            $enumDeviceGuardLocalSystemAuthorityCredentialGuardSettings = $getValue.deviceGuardLocalSystemAuthorityCredentialGuardSettings.ToString()
        }

        $enumDeviceGuardSecureBootWithDMA = $null
        if ($null -ne $getValue.deviceGuardSecureBootWithDMA)
        {
            $enumDeviceGuardSecureBootWithDMA = $getValue.deviceGuardSecureBootWithDMA.ToString()
        }

        $enumDmaGuardDeviceEnumerationPolicy = $null
        if ($null -ne $getValue.dmaGuardDeviceEnumerationPolicy)
        {
            $enumDmaGuardDeviceEnumerationPolicy = $getValue.dmaGuardDeviceEnumerationPolicy.ToString()
        }

        $enumFirewallCertificateRevocationListCheckMethod = $null
        if ($null -ne $getValue.firewallCertificateRevocationListCheckMethod)
        {
            $enumFirewallCertificateRevocationListCheckMethod = $getValue.firewallCertificateRevocationListCheckMethod.ToString()
        }

        $enumFirewallPacketQueueingMethod = $null
        if ($null -ne $getValue.firewallPacketQueueingMethod)
        {
            $enumFirewallPacketQueueingMethod = $getValue.firewallPacketQueueingMethod.ToString()
        }

        $enumFirewallPreSharedKeyEncodingMethod = $null
        if ($null -ne $getValue.firewallPreSharedKeyEncodingMethod)
        {
            $enumFirewallPreSharedKeyEncodingMethod = $getValue.firewallPreSharedKeyEncodingMethod.ToString()
        }

        $enumLanManagerAuthenticationLevel = $null
        if ($null -ne $getValue.lanManagerAuthenticationLevel)
        {
            $enumLanManagerAuthenticationLevel = $getValue.lanManagerAuthenticationLevel.ToString()
        }

        $enumLocalSecurityOptionsAdministratorElevationPromptBehavior = $null
        if ($null -ne $getValue.localSecurityOptionsAdministratorElevationPromptBehavior)
        {
            $enumLocalSecurityOptionsAdministratorElevationPromptBehavior = $getValue.localSecurityOptionsAdministratorElevationPromptBehavior.ToString()
        }

        $enumLocalSecurityOptionsFormatAndEjectOfRemovableMediaAllowedUser = $null
        if ($null -ne $getValue.localSecurityOptionsFormatAndEjectOfRemovableMediaAllowedUser)
        {
            $enumLocalSecurityOptionsFormatAndEjectOfRemovableMediaAllowedUser = $getValue.localSecurityOptionsFormatAndEjectOfRemovableMediaAllowedUser.ToString()
        }

        $enumLocalSecurityOptionsInformationDisplayedOnLockScreen = $null
        if ($null -ne $getValue.localSecurityOptionsInformationDisplayedOnLockScreen)
        {
            $enumLocalSecurityOptionsInformationDisplayedOnLockScreen = $getValue.localSecurityOptionsInformationDisplayedOnLockScreen.ToString()
        }

        $enumLocalSecurityOptionsInformationShownOnLockScreen = $null
        if ($null -ne $getValue.localSecurityOptionsInformationShownOnLockScreen)
        {
            $enumLocalSecurityOptionsInformationShownOnLockScreen = $getValue.localSecurityOptionsInformationShownOnLockScreen.ToString()
        }

        $enumLocalSecurityOptionsMinimumSessionSecurityForNtlmSspBasedClients = $null
        if ($null -ne $getValue.localSecurityOptionsMinimumSessionSecurityForNtlmSspBasedClients)
        {
            $enumLocalSecurityOptionsMinimumSessionSecurityForNtlmSspBasedClients = $getValue.localSecurityOptionsMinimumSessionSecurityForNtlmSspBasedClients.ToString()
        }

        $enumLocalSecurityOptionsMinimumSessionSecurityForNtlmSspBasedServers = $null
        if ($null -ne $getValue.localSecurityOptionsMinimumSessionSecurityForNtlmSspBasedServers)
        {
            $enumLocalSecurityOptionsMinimumSessionSecurityForNtlmSspBasedServers = $getValue.localSecurityOptionsMinimumSessionSecurityForNtlmSspBasedServers.ToString()
        }

        $enumLocalSecurityOptionsSmartCardRemovalBehavior = $null
        if ($null -ne $getValue.localSecurityOptionsSmartCardRemovalBehavior)
        {
            $enumLocalSecurityOptionsSmartCardRemovalBehavior = $getValue.localSecurityOptionsSmartCardRemovalBehavior.ToString()
        }

        $enumLocalSecurityOptionsStandardUserElevationPromptBehavior = $null
        if ($null -ne $getValue.localSecurityOptionsStandardUserElevationPromptBehavior)
        {
            $enumLocalSecurityOptionsStandardUserElevationPromptBehavior = $getValue.localSecurityOptionsStandardUserElevationPromptBehavior.ToString()
        }

        $enumWindowsDefenderTamperProtection = $null
        if ($null -ne $getValue.windowsDefenderTamperProtection)
        {
            $enumWindowsDefenderTamperProtection = $getValue.windowsDefenderTamperProtection.ToString()
        }

        $enumXboxServicesAccessoryManagementServiceStartupMode = $null
        if ($null -ne $getValue.xboxServicesAccessoryManagementServiceStartupMode)
        {
            $enumXboxServicesAccessoryManagementServiceStartupMode = $getValue.xboxServicesAccessoryManagementServiceStartupMode.ToString()
        }

        $enumXboxServicesLiveAuthManagerServiceStartupMode = $null
        if ($null -ne $getValue.xboxServicesLiveAuthManagerServiceStartupMode)
        {
            $enumXboxServicesLiveAuthManagerServiceStartupMode = $getValue.xboxServicesLiveAuthManagerServiceStartupMode.ToString()
        }

        $enumXboxServicesLiveGameSaveServiceStartupMode = $null
        if ($null -ne $getValue.xboxServicesLiveGameSaveServiceStartupMode)
        {
            $enumXboxServicesLiveGameSaveServiceStartupMode = $getValue.xboxServicesLiveGameSaveServiceStartupMode.ToString()
        }

        $enumXboxServicesLiveNetworkingServiceStartupMode = $null
        if ($null -ne $getValue.xboxServicesLiveNetworkingServiceStartupMode)
        {
            $enumXboxServicesLiveNetworkingServiceStartupMode = $getValue.xboxServicesLiveNetworkingServiceStartupMode.ToString()
        }

        #endregion

        #region resource generator code
        $timeDefenderScheduledQuickScanTime = $null
        if ($null -ne $getValue.defenderScheduledQuickScanTime)
        {
            $timeDefenderScheduledQuickScanTime = ([TimeSpan]$getValue.defenderScheduledQuickScanTime).ToString()
        }

        $timeDefenderScheduledScanTime = $null
        if ($null -ne $getValue.defenderScheduledScanTime)
        {
            $timeDefenderScheduledScanTime = ([TimeSpan]$getValue.defenderScheduledScanTime).ToString()
        }

        #endregion

        $results = @{
            #region resource generator code
            ApplicationGuardAllowCameraMicrophoneRedirection                             = $getValue.applicationGuardAllowCameraMicrophoneRedirection
            ApplicationGuardAllowFileSaveOnHost                                          = $getValue.applicationGuardAllowFileSaveOnHost
            ApplicationGuardAllowPersistence                                             = $getValue.applicationGuardAllowPersistence
            ApplicationGuardAllowPrintToLocalPrinters                                    = $getValue.applicationGuardAllowPrintToLocalPrinters
            ApplicationGuardAllowPrintToNetworkPrinters                                  = $getValue.applicationGuardAllowPrintToNetworkPrinters
            ApplicationGuardAllowPrintToPDF                                              = $getValue.applicationGuardAllowPrintToPDF
            ApplicationGuardAllowPrintToXPS                                              = $getValue.applicationGuardAllowPrintToXPS
            ApplicationGuardAllowVirtualGPU                                              = $getValue.applicationGuardAllowVirtualGPU
            ApplicationGuardBlockClipboardSharing                                        = $enumApplicationGuardBlockClipboardSharing
            ApplicationGuardBlockFileTransfer                                            = $enumApplicationGuardBlockFileTransfer
            ApplicationGuardBlockNonEnterpriseContent                                    = $getValue.applicationGuardBlockNonEnterpriseContent
            ApplicationGuardCertificateThumbprints                                       = $getValue.applicationGuardCertificateThumbprints
            ApplicationGuardEnabled                                                      = $getValue.applicationGuardEnabled
            ApplicationGuardEnabledOptions                                               = $enumApplicationGuardEnabledOptions
            ApplicationGuardForceAuditing                                                = $getValue.applicationGuardForceAuditing
            AppLockerApplicationControl                                                  = $enumAppLockerApplicationControl
            BitLockerAllowStandardUserEncryption                                         = $getValue.bitLockerAllowStandardUserEncryption
            BitLockerDisableWarningForOtherDiskEncryption                                = $getValue.bitLockerDisableWarningForOtherDiskEncryption
            BitLockerEnableStorageCardEncryptionOnMobile                                 = $getValue.bitLockerEnableStorageCardEncryptionOnMobile
            BitLockerEncryptDevice                                                       = $getValue.bitLockerEncryptDevice
            BitLockerFixedDrivePolicy                                                    = $complexBitLockerFixedDrivePolicy
            BitLockerRecoveryPasswordRotation                                            = $enumBitLockerRecoveryPasswordRotation
            BitLockerRemovableDrivePolicy                                                = $complexBitLockerRemovableDrivePolicy
            BitLockerSystemDrivePolicy                                                   = $complexBitLockerSystemDrivePolicy
            DefenderAdditionalGuardedFolders                                             = $getValue.defenderAdditionalGuardedFolders
            DefenderAdobeReaderLaunchChildProcess                                        = $enumDefenderAdobeReaderLaunchChildProcess
            DefenderAdvancedRansomewareProtectionType                                    = $enumDefenderAdvancedRansomewareProtectionType
            DefenderAllowBehaviorMonitoring                                              = $getValue.defenderAllowBehaviorMonitoring
            DefenderAllowCloudProtection                                                 = $getValue.defenderAllowCloudProtection
            DefenderAllowEndUserAccess                                                   = $getValue.defenderAllowEndUserAccess
            DefenderAllowIntrusionPreventionSystem                                       = $getValue.defenderAllowIntrusionPreventionSystem
            DefenderAllowOnAccessProtection                                              = $getValue.defenderAllowOnAccessProtection
            DefenderAllowRealTimeMonitoring                                              = $getValue.defenderAllowRealTimeMonitoring
            DefenderAllowScanArchiveFiles                                                = $getValue.defenderAllowScanArchiveFiles
            DefenderAllowScanDownloads                                                   = $getValue.defenderAllowScanDownloads
            DefenderAllowScanNetworkFiles                                                = $getValue.defenderAllowScanNetworkFiles
            DefenderAllowScanRemovableDrivesDuringFullScan                               = $getValue.defenderAllowScanRemovableDrivesDuringFullScan
            DefenderAllowScanScriptsLoadedInInternetExplorer                             = $getValue.defenderAllowScanScriptsLoadedInInternetExplorer
            DefenderAttackSurfaceReductionExcludedPaths                                  = $getValue.defenderAttackSurfaceReductionExcludedPaths
            DefenderBlockEndUserAccess                                                   = $getValue.defenderBlockEndUserAccess
            DefenderBlockPersistenceThroughWmiType                                       = $enumDefenderBlockPersistenceThroughWmiType
            DefenderCheckForSignaturesBeforeRunningScan                                  = $getValue.defenderCheckForSignaturesBeforeRunningScan
            DefenderCloudBlockLevel                                                      = $enumDefenderCloudBlockLevel
            DefenderCloudExtendedTimeoutInSeconds                                        = $getValue.defenderCloudExtendedTimeoutInSeconds
            DefenderDaysBeforeDeletingQuarantinedMalware                                 = $getValue.defenderDaysBeforeDeletingQuarantinedMalware
            DefenderDetectedMalwareActions                                               = $complexDefenderDetectedMalwareActions
            DefenderDisableBehaviorMonitoring                                            = $getValue.defenderDisableBehaviorMonitoring
            DefenderDisableCatchupFullScan                                               = $getValue.defenderDisableCatchupFullScan
            DefenderDisableCatchupQuickScan                                              = $getValue.defenderDisableCatchupQuickScan
            DefenderDisableCloudProtection                                               = $getValue.defenderDisableCloudProtection
            DefenderDisableIntrusionPreventionSystem                                     = $getValue.defenderDisableIntrusionPreventionSystem
            DefenderDisableOnAccessProtection                                            = $getValue.defenderDisableOnAccessProtection
            DefenderDisableRealTimeMonitoring                                            = $getValue.defenderDisableRealTimeMonitoring
            DefenderDisableScanArchiveFiles                                              = $getValue.defenderDisableScanArchiveFiles
            DefenderDisableScanDownloads                                                 = $getValue.defenderDisableScanDownloads
            DefenderDisableScanNetworkFiles                                              = $getValue.defenderDisableScanNetworkFiles
            DefenderDisableScanRemovableDrivesDuringFullScan                             = $getValue.defenderDisableScanRemovableDrivesDuringFullScan
            DefenderDisableScanScriptsLoadedInInternetExplorer                           = $getValue.defenderDisableScanScriptsLoadedInInternetExplorer
            DefenderEmailContentExecution                                                = $enumDefenderEmailContentExecution
            DefenderEmailContentExecutionType                                            = $enumDefenderEmailContentExecutionType
            DefenderEnableLowCpuPriority                                                 = $getValue.defenderEnableLowCpuPriority
            DefenderEnableScanIncomingMail                                               = $getValue.defenderEnableScanIncomingMail
            DefenderEnableScanMappedNetworkDrivesDuringFullScan                          = $getValue.defenderEnableScanMappedNetworkDrivesDuringFullScan
            DefenderExploitProtectionXml                                                 = $getValue.defenderExploitProtectionXml
            DefenderExploitProtectionXmlFileName                                         = $getValue.defenderExploitProtectionXmlFileName
            DefenderFileExtensionsToExclude                                              = $getValue.defenderFileExtensionsToExclude
            DefenderFilesAndFoldersToExclude                                             = $getValue.defenderFilesAndFoldersToExclude
            DefenderGuardedFoldersAllowedAppPaths                                        = $getValue.defenderGuardedFoldersAllowedAppPaths
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
            DefenderProcessesToExclude                                                   = $getValue.defenderProcessesToExclude
            DefenderScanDirection                                                        = $enumDefenderScanDirection
            DefenderScanMaxCpuPercentage                                                 = $getValue.defenderScanMaxCpuPercentage
            DefenderScanType                                                             = $enumDefenderScanType
            DefenderScheduledQuickScanTime                                               = $timeDefenderScheduledQuickScanTime
            DefenderScheduledScanDay                                                     = $enumDefenderScheduledScanDay
            DefenderScheduledScanTime                                                    = $timeDefenderScheduledScanTime
            DefenderScriptDownloadedPayloadExecution                                     = $enumDefenderScriptDownloadedPayloadExecution
            DefenderScriptDownloadedPayloadExecutionType                                 = $enumDefenderScriptDownloadedPayloadExecutionType
            DefenderScriptObfuscatedMacroCode                                            = $enumDefenderScriptObfuscatedMacroCode
            DefenderScriptObfuscatedMacroCodeType                                        = $enumDefenderScriptObfuscatedMacroCodeType
            DefenderSecurityCenterBlockExploitProtectionOverride                         = $getValue.defenderSecurityCenterBlockExploitProtectionOverride
            DefenderSecurityCenterDisableAccountUI                                       = $getValue.defenderSecurityCenterDisableAccountUI
            DefenderSecurityCenterDisableAppBrowserUI                                    = $getValue.defenderSecurityCenterDisableAppBrowserUI
            DefenderSecurityCenterDisableClearTpmUI                                      = $getValue.defenderSecurityCenterDisableClearTpmUI
            DefenderSecurityCenterDisableFamilyUI                                        = $getValue.defenderSecurityCenterDisableFamilyUI
            DefenderSecurityCenterDisableHardwareUI                                      = $getValue.defenderSecurityCenterDisableHardwareUI
            DefenderSecurityCenterDisableHealthUI                                        = $getValue.defenderSecurityCenterDisableHealthUI
            DefenderSecurityCenterDisableNetworkUI                                       = $getValue.defenderSecurityCenterDisableNetworkUI
            DefenderSecurityCenterDisableNotificationAreaUI                              = $getValue.defenderSecurityCenterDisableNotificationAreaUI
            DefenderSecurityCenterDisableRansomwareUI                                    = $getValue.defenderSecurityCenterDisableRansomwareUI
            DefenderSecurityCenterDisableSecureBootUI                                    = $getValue.defenderSecurityCenterDisableSecureBootUI
            DefenderSecurityCenterDisableTroubleshootingUI                               = $getValue.defenderSecurityCenterDisableTroubleshootingUI
            DefenderSecurityCenterDisableVirusUI                                         = $getValue.defenderSecurityCenterDisableVirusUI
            DefenderSecurityCenterDisableVulnerableTpmFirmwareUpdateUI                   = $getValue.defenderSecurityCenterDisableVulnerableTpmFirmwareUpdateUI
            DefenderSecurityCenterHelpEmail                                              = $getValue.defenderSecurityCenterHelpEmail
            DefenderSecurityCenterHelpPhone                                              = $getValue.defenderSecurityCenterHelpPhone
            DefenderSecurityCenterHelpURL                                                = $getValue.defenderSecurityCenterHelpURL
            DefenderSecurityCenterITContactDisplay                                       = $enumDefenderSecurityCenterITContactDisplay
            DefenderSecurityCenterNotificationsFromApp                                   = $enumDefenderSecurityCenterNotificationsFromApp
            DefenderSecurityCenterOrganizationDisplayName                                = $getValue.defenderSecurityCenterOrganizationDisplayName
            DefenderSignatureUpdateIntervalInHours                                       = $getValue.defenderSignatureUpdateIntervalInHours
            DefenderSubmitSamplesConsentType                                             = $enumDefenderSubmitSamplesConsentType
            DefenderUntrustedExecutable                                                  = $enumDefenderUntrustedExecutable
            DefenderUntrustedExecutableType                                              = $enumDefenderUntrustedExecutableType
            DefenderUntrustedUSBProcess                                                  = $enumDefenderUntrustedUSBProcess
            DefenderUntrustedUSBProcessType                                              = $enumDefenderUntrustedUSBProcessType
            DeviceGuardEnableSecureBootWithDMA                                           = $getValue.deviceGuardEnableSecureBootWithDMA
            DeviceGuardEnableVirtualizationBasedSecurity                                 = $getValue.deviceGuardEnableVirtualizationBasedSecurity
            DeviceGuardLaunchSystemGuard                                                 = $enumDeviceGuardLaunchSystemGuard
            DeviceGuardLocalSystemAuthorityCredentialGuardSettings                       = $enumDeviceGuardLocalSystemAuthorityCredentialGuardSettings
            DeviceGuardSecureBootWithDMA                                                 = $enumDeviceGuardSecureBootWithDMA
            DmaGuardDeviceEnumerationPolicy                                              = $enumDmaGuardDeviceEnumerationPolicy
            FirewallBlockStatefulFTP                                                     = $getValue.firewallBlockStatefulFTP
            FirewallCertificateRevocationListCheckMethod                                 = $enumFirewallCertificateRevocationListCheckMethod
            FirewallIdleTimeoutForSecurityAssociationInSeconds                           = $getValue.firewallIdleTimeoutForSecurityAssociationInSeconds
            FirewallIPSecExemptionsAllowDHCP                                             = $getValue.firewallIPSecExemptionsAllowDHCP
            FirewallIPSecExemptionsAllowICMP                                             = $getValue.firewallIPSecExemptionsAllowICMP
            FirewallIPSecExemptionsAllowNeighborDiscovery                                = $getValue.firewallIPSecExemptionsAllowNeighborDiscovery
            FirewallIPSecExemptionsAllowRouterDiscovery                                  = $getValue.firewallIPSecExemptionsAllowRouterDiscovery
            FirewallIPSecExemptionsNone                                                  = $getValue.firewallIPSecExemptionsNone
            FirewallMergeKeyingModuleSettings                                            = $getValue.firewallMergeKeyingModuleSettings
            FirewallPacketQueueingMethod                                                 = $enumFirewallPacketQueueingMethod
            FirewallPreSharedKeyEncodingMethod                                           = $enumFirewallPreSharedKeyEncodingMethod
            FirewallProfileDomain                                                        = $complexFirewallProfileDomain
            FirewallProfilePrivate                                                       = $complexFirewallProfilePrivate
            FirewallProfilePublic                                                        = $complexFirewallProfilePublic
            FirewallRules                                                                = $complexFirewallRules
            LanManagerAuthenticationLevel                                                = $enumLanManagerAuthenticationLevel
            LanManagerWorkstationDisableInsecureGuestLogons                              = $getValue.lanManagerWorkstationDisableInsecureGuestLogons
            LocalSecurityOptionsAdministratorAccountName                                 = $getValue.localSecurityOptionsAdministratorAccountName
            LocalSecurityOptionsAdministratorElevationPromptBehavior                     = $enumLocalSecurityOptionsAdministratorElevationPromptBehavior
            LocalSecurityOptionsAllowAnonymousEnumerationOfSAMAccountsAndShares          = $getValue.localSecurityOptionsAllowAnonymousEnumerationOfSAMAccountsAndShares
            LocalSecurityOptionsAllowPKU2UAuthenticationRequests                         = $getValue.localSecurityOptionsAllowPKU2UAuthenticationRequests
            LocalSecurityOptionsAllowRemoteCallsToSecurityAccountsManager                = $getValue.localSecurityOptionsAllowRemoteCallsToSecurityAccountsManager
            LocalSecurityOptionsAllowRemoteCallsToSecurityAccountsManagerHelperBool      = $getValue.localSecurityOptionsAllowRemoteCallsToSecurityAccountsManagerHelperBool
            LocalSecurityOptionsAllowSystemToBeShutDownWithoutHavingToLogOn              = $getValue.localSecurityOptionsAllowSystemToBeShutDownWithoutHavingToLogOn
            LocalSecurityOptionsAllowUIAccessApplicationElevation                        = $getValue.localSecurityOptionsAllowUIAccessApplicationElevation
            LocalSecurityOptionsAllowUIAccessApplicationsForSecureLocations              = $getValue.localSecurityOptionsAllowUIAccessApplicationsForSecureLocations
            LocalSecurityOptionsAllowUndockWithoutHavingToLogon                          = $getValue.localSecurityOptionsAllowUndockWithoutHavingToLogon
            LocalSecurityOptionsBlockMicrosoftAccounts                                   = $getValue.localSecurityOptionsBlockMicrosoftAccounts
            LocalSecurityOptionsBlockRemoteLogonWithBlankPassword                        = $getValue.localSecurityOptionsBlockRemoteLogonWithBlankPassword
            LocalSecurityOptionsBlockRemoteOpticalDriveAccess                            = $getValue.localSecurityOptionsBlockRemoteOpticalDriveAccess
            LocalSecurityOptionsBlockUsersInstallingPrinterDrivers                       = $getValue.localSecurityOptionsBlockUsersInstallingPrinterDrivers
            LocalSecurityOptionsClearVirtualMemoryPageFile                               = $getValue.localSecurityOptionsClearVirtualMemoryPageFile
            LocalSecurityOptionsClientDigitallySignCommunicationsAlways                  = $getValue.localSecurityOptionsClientDigitallySignCommunicationsAlways
            LocalSecurityOptionsClientSendUnencryptedPasswordToThirdPartySMBServers      = $getValue.localSecurityOptionsClientSendUnencryptedPasswordToThirdPartySMBServers
            LocalSecurityOptionsDetectApplicationInstallationsAndPromptForElevation      = $getValue.localSecurityOptionsDetectApplicationInstallationsAndPromptForElevation
            LocalSecurityOptionsDisableAdministratorAccount                              = $getValue.localSecurityOptionsDisableAdministratorAccount
            LocalSecurityOptionsDisableClientDigitallySignCommunicationsIfServerAgrees   = $getValue.localSecurityOptionsDisableClientDigitallySignCommunicationsIfServerAgrees
            LocalSecurityOptionsDisableGuestAccount                                      = $getValue.localSecurityOptionsDisableGuestAccount
            LocalSecurityOptionsDisableServerDigitallySignCommunicationsAlways           = $getValue.localSecurityOptionsDisableServerDigitallySignCommunicationsAlways
            LocalSecurityOptionsDisableServerDigitallySignCommunicationsIfClientAgrees   = $getValue.localSecurityOptionsDisableServerDigitallySignCommunicationsIfClientAgrees
            LocalSecurityOptionsDoNotAllowAnonymousEnumerationOfSAMAccounts              = $getValue.localSecurityOptionsDoNotAllowAnonymousEnumerationOfSAMAccounts
            LocalSecurityOptionsDoNotRequireCtrlAltDel                                   = $getValue.localSecurityOptionsDoNotRequireCtrlAltDel
            LocalSecurityOptionsDoNotStoreLANManagerHashValueOnNextPasswordChange        = $getValue.localSecurityOptionsDoNotStoreLANManagerHashValueOnNextPasswordChange
            LocalSecurityOptionsFormatAndEjectOfRemovableMediaAllowedUser                = $enumLocalSecurityOptionsFormatAndEjectOfRemovableMediaAllowedUser
            LocalSecurityOptionsGuestAccountName                                         = $getValue.localSecurityOptionsGuestAccountName
            LocalSecurityOptionsHideLastSignedInUser                                     = $getValue.localSecurityOptionsHideLastSignedInUser
            LocalSecurityOptionsHideUsernameAtSignIn                                     = $getValue.localSecurityOptionsHideUsernameAtSignIn
            LocalSecurityOptionsInformationDisplayedOnLockScreen                         = $enumLocalSecurityOptionsInformationDisplayedOnLockScreen
            LocalSecurityOptionsInformationShownOnLockScreen                             = $enumLocalSecurityOptionsInformationShownOnLockScreen
            LocalSecurityOptionsLogOnMessageText                                         = $getValue.localSecurityOptionsLogOnMessageText
            LocalSecurityOptionsLogOnMessageTitle                                        = $getValue.localSecurityOptionsLogOnMessageTitle
            LocalSecurityOptionsMachineInactivityLimit                                   = $getValue.localSecurityOptionsMachineInactivityLimit
            LocalSecurityOptionsMachineInactivityLimitInMinutes                          = $getValue.localSecurityOptionsMachineInactivityLimitInMinutes
            LocalSecurityOptionsMinimumSessionSecurityForNtlmSspBasedClients             = $enumLocalSecurityOptionsMinimumSessionSecurityForNtlmSspBasedClients
            LocalSecurityOptionsMinimumSessionSecurityForNtlmSspBasedServers             = $enumLocalSecurityOptionsMinimumSessionSecurityForNtlmSspBasedServers
            LocalSecurityOptionsOnlyElevateSignedExecutables                             = $getValue.localSecurityOptionsOnlyElevateSignedExecutables
            LocalSecurityOptionsRestrictAnonymousAccessToNamedPipesAndShares             = $getValue.localSecurityOptionsRestrictAnonymousAccessToNamedPipesAndShares
            LocalSecurityOptionsSmartCardRemovalBehavior                                 = $enumLocalSecurityOptionsSmartCardRemovalBehavior
            LocalSecurityOptionsStandardUserElevationPromptBehavior                      = $enumLocalSecurityOptionsStandardUserElevationPromptBehavior
            LocalSecurityOptionsSwitchToSecureDesktopWhenPromptingForElevation           = $getValue.localSecurityOptionsSwitchToSecureDesktopWhenPromptingForElevation
            LocalSecurityOptionsUseAdminApprovalMode                                     = $getValue.localSecurityOptionsUseAdminApprovalMode
            LocalSecurityOptionsUseAdminApprovalModeForAdministrators                    = $getValue.localSecurityOptionsUseAdminApprovalModeForAdministrators
            LocalSecurityOptionsVirtualizeFileAndRegistryWriteFailuresToPerUserLocations = $getValue.localSecurityOptionsVirtualizeFileAndRegistryWriteFailuresToPerUserLocations
            SmartScreenBlockOverrideForFiles                                             = $getValue.smartScreenBlockOverrideForFiles
            SmartScreenEnableInShell                                                     = $getValue.smartScreenEnableInShell
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
            XboxServicesEnableXboxGameSaveTask                                           = $getValue.xboxServicesEnableXboxGameSaveTask
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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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
        $createParameters = Rename-M365DSCCimInstanceParameter -Properties $createParameters
        $createParameters.Remove('Id') | Out-Null

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
        Update-MgBetaDeviceManagementDeviceConfiguration `
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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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
        $baseFilter = "isof('microsoft.graph.windows10EndpointProtectionConfiguration')"
        if (-not [string]::IsNullOrEmpty($Filter))
        {
            $Filter = "($baseFilter) and ($Filter)"
        }
        else
        {
            $Filter = $baseFilter
        }
        [array]$getValue = Get-MgBetaDeviceManagementDeviceConfiguration -Filter $Filter -All -ErrorAction Stop
        #endregion

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
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
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
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
            [void]$dscContent.Append($currentDSCBlock)
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent.ToString()
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
