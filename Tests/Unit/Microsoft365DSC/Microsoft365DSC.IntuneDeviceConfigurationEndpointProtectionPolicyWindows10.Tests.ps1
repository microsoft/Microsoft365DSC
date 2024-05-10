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
    -DscResource "IntuneDeviceConfigurationEndpointProtectionPolicyWindows10" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ("tenantadmin@mydomain.com", $secpasswd)

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

            Mock -CommandName Get-MgBetaDeviceManagementDeviceConfigurationAssignment -MockWith {
            }
            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }
            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name "The IntuneDeviceConfigurationEndpointProtectionPolicyWindows10 should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    ApplicationGuardAllowCameraMicrophoneRedirection = $True
                    ApplicationGuardAllowFileSaveOnHost = $True
                    ApplicationGuardAllowPersistence = $True
                    ApplicationGuardAllowPrintToLocalPrinters = $True
                    ApplicationGuardAllowPrintToNetworkPrinters = $True
                    ApplicationGuardAllowPrintToPDF = $True
                    ApplicationGuardAllowPrintToXPS = $True
                    ApplicationGuardAllowVirtualGPU = $True
                    ApplicationGuardBlockClipboardSharing = "notConfigured"
                    ApplicationGuardBlockFileTransfer = "notConfigured"
                    ApplicationGuardBlockNonEnterpriseContent = $True
                    ApplicationGuardCertificateThumbprints = @("FakeStringValue")
                    ApplicationGuardEnabled = $True
                    ApplicationGuardEnabledOptions = "notConfigured"
                    ApplicationGuardForceAuditing = $True
                    AppLockerApplicationControl = "notConfigured"
                    BitLockerAllowStandardUserEncryption = $True
                    BitLockerDisableWarningForOtherDiskEncryption = $True
                    BitLockerEnableStorageCardEncryptionOnMobile = $True
                    BitLockerEncryptDevice = $True
                    bitLockerFixedDrivePolicy = (New-CimInstance -ClassName MSFT_MicrosoftGraphbitLockerFixedDrivePolicy -Property @{
                        RecoveryOptions = (New-CimInstance -ClassName MSFT_MicrosoftGraphbitLockerRecoveryOptions -Property @{
                            RecoveryInformationToStore = "passwordAndKey"
                            HideRecoveryOptions = $True
                            BlockDataRecoveryAgent = $True
                            RecoveryKeyUsage = "blocked"
                            EnableBitLockerAfterRecoveryInformationToStore = $True
                            EnableRecoveryInformationSaveToStore = $True
                            RecoveryPasswordUsage = "blocked"
                        } -ClientOnly)
                        RequireEncryptionForWriteAccess = $True
                        encryptionMethod = "aesCbc128"
                    } -ClientOnly)
                    bitLockerRecoveryPasswordRotation = "notConfigured"
                    bitLockerRemovableDrivePolicy = (New-CimInstance -ClassName MSFT_MicrosoftGraphbitLockerRemovableDrivePolicy -Property @{
                        requireEncryptionForWriteAccess = $True
                        blockCrossOrganizationWriteAccess = $True
                        encryptionMethod = "aesCbc128"
                    } -ClientOnly)
                    bitLockerSystemDrivePolicy = (New-CimInstance -ClassName MSFT_MicrosoftGraphbitLockerSystemDrivePolicy -Property @{
                        prebootRecoveryEnableMessageAndUrl = $True
                        StartupAuthenticationTpmPinUsage = "blocked"
                        encryptionMethod = "aesCbc128"
                        minimumPinLength = 25
                        prebootRecoveryMessage = "FakeStringValue"
                        StartupAuthenticationTpmPinAndKeyUsage = "blocked"
                        StartupAuthenticationRequired = $True
                        RecoveryOptions = (New-CimInstance -ClassName MSFT_MicrosoftGraphbitLockerRecoveryOptions -Property @{
                            RecoveryInformationToStore = "passwordAndKey"
                            HideRecoveryOptions = $True
                            BlockDataRecoveryAgent = $True
                            RecoveryKeyUsage = "blocked"
                            EnableBitLockerAfterRecoveryInformationToStore = $True
                            EnableRecoveryInformationSaveToStore = $True
                            RecoveryPasswordUsage = "blocked"
                        } -ClientOnly)
                        prebootRecoveryUrl = "FakeStringValue"
                        StartupAuthenticationTpmUsage = "blocked"
                        StartupAuthenticationTpmKeyUsage = "blocked"
                        StartupAuthenticationBlockWithoutTpmChip = $True
                    } -ClientOnly)
                    defenderAdditionalGuardedFolders = @("FakeStringValue")
                    defenderAdobeReaderLaunchChildProcess = "userDefined"
                    defenderAdvancedRansomewareProtectionType = "userDefined"
                    defenderAllowBehaviorMonitoring = $True
                    defenderAllowCloudProtection = $True
                    defenderAllowEndUserAccess = $True
                    defenderAllowIntrusionPreventionSystem = $True
                    defenderAllowOnAccessProtection = $True
                    defenderAllowRealTimeMonitoring = $True
                    defenderAllowScanArchiveFiles = $True
                    defenderAllowScanDownloads = $True
                    defenderAllowScanNetworkFiles = $True
                    defenderAllowScanRemovableDrivesDuringFullScan = $True
                    defenderAllowScanScriptsLoadedInInternetExplorer = $True
                    defenderAttackSurfaceReductionExcludedPaths = @("FakeStringValue")
                    defenderBlockEndUserAccess = $True
                    defenderBlockPersistenceThroughWmiType = "userDefined"
                    defenderCheckForSignaturesBeforeRunningScan = $True
                    defenderCloudBlockLevel = "notConfigured"
                    defenderCloudExtendedTimeoutInSeconds = 25
                    defenderDaysBeforeDeletingQuarantinedMalware = 25
                    defenderDetectedMalwareActions = (New-CimInstance -ClassName MSFT_MicrosoftGraphdefenderDetectedMalwareActions -Property @{
                        lowSeverity = "deviceDefault"
                        severeSeverity = "deviceDefault"
                        moderateSeverity = "deviceDefault"
                        highSeverity = "deviceDefault"
                    } -ClientOnly)
                    defenderDisableBehaviorMonitoring = $True
                    defenderDisableCatchupFullScan = $True
                    defenderDisableCatchupQuickScan = $True
                    defenderDisableCloudProtection = $True
                    defenderDisableIntrusionPreventionSystem = $True
                    defenderDisableOnAccessProtection = $True
                    defenderDisableRealTimeMonitoring = $True
                    defenderDisableScanArchiveFiles = $True
                    defenderDisableScanDownloads = $True
                    defenderDisableScanNetworkFiles = $True
                    defenderDisableScanRemovableDrivesDuringFullScan = $True
                    defenderDisableScanScriptsLoadedInInternetExplorer = $True
                    defenderEmailContentExecution = "userDefined"
                    defenderEmailContentExecutionType = "userDefined"
                    defenderEnableLowCpuPriority = $True
                    defenderEnableScanIncomingMail = $True
                    defenderEnableScanMappedNetworkDrivesDuringFullScan = $True
                    defenderExploitProtectionXml = $True
                    defenderExploitProtectionXmlFileName = "FakeStringValue"
                    defenderFileExtensionsToExclude = @("FakeStringValue")
                    defenderFilesAndFoldersToExclude = @("FakeStringValue")
                    defenderGuardedFoldersAllowedAppPaths = @("FakeStringValue")
                    defenderGuardMyFoldersType = "userDefined"
                    defenderNetworkProtectionType = "userDefined"
                    defenderOfficeAppsExecutableContentCreationOrLaunch = "userDefined"
                    defenderOfficeAppsExecutableContentCreationOrLaunchType = "userDefined"
                    defenderOfficeAppsLaunchChildProcess = "userDefined"
                    defenderOfficeAppsLaunchChildProcessType = "userDefined"
                    defenderOfficeAppsOtherProcessInjection = "userDefined"
                    defenderOfficeAppsOtherProcessInjectionType = "userDefined"
                    defenderOfficeCommunicationAppsLaunchChildProcess = "userDefined"
                    defenderOfficeMacroCodeAllowWin32Imports = "userDefined"
                    defenderOfficeMacroCodeAllowWin32ImportsType = "userDefined"
                    defenderPotentiallyUnwantedAppAction = "userDefined"
                    defenderPreventCredentialStealingType = "userDefined"
                    defenderProcessCreation = "userDefined"
                    defenderProcessCreationType = "userDefined"
                    defenderProcessesToExclude = @("FakeStringValue")
                    defenderScanDirection = "monitorAllFiles"
                    defenderScanMaxCpuPercentage = 25
                    defenderScanType = "userDefined"
                    defenderScheduledQuickScanTime = "00:00:00"
                    defenderScheduledScanDay = "userDefined"
                    defenderScheduledScanTime = "00:00:00"
                    defenderScriptDownloadedPayloadExecution = "userDefined"
                    defenderScriptDownloadedPayloadExecutionType = "userDefined"
                    defenderScriptObfuscatedMacroCode = "userDefined"
                    defenderScriptObfuscatedMacroCodeType = "userDefined"
                    defenderSecurityCenterBlockExploitProtectionOverride = $True
                    defenderSecurityCenterDisableAccountUI = $True
                    defenderSecurityCenterDisableAppBrowserUI = $True
                    defenderSecurityCenterDisableClearTpmUI = $True
                    defenderSecurityCenterDisableFamilyUI = $True
                    defenderSecurityCenterDisableHardwareUI = $True
                    defenderSecurityCenterDisableHealthUI = $True
                    defenderSecurityCenterDisableNetworkUI = $True
                    defenderSecurityCenterDisableNotificationAreaUI = $True
                    defenderSecurityCenterDisableRansomwareUI = $True
                    defenderSecurityCenterDisableSecureBootUI = $True
                    defenderSecurityCenterDisableTroubleshootingUI = $True
                    defenderSecurityCenterDisableVirusUI = $True
                    defenderSecurityCenterDisableVulnerableTpmFirmwareUpdateUI = $True
                    defenderSecurityCenterHelpEmail = "FakeStringValue"
                    defenderSecurityCenterHelpPhone = "FakeStringValue"
                    defenderSecurityCenterHelpURL = "FakeStringValue"
                    defenderSecurityCenterITContactDisplay = "notConfigured"
                    defenderSecurityCenterNotificationsFromApp = "notConfigured"
                    defenderSecurityCenterOrganizationDisplayName = "FakeStringValue"
                    defenderSignatureUpdateIntervalInHours = 25
                    defenderSubmitSamplesConsentType = "sendSafeSamplesAutomatically"
                    defenderUntrustedExecutable = "userDefined"
                    defenderUntrustedExecutableType = "userDefined"
                    defenderUntrustedUSBProcess = "userDefined"
                    defenderUntrustedUSBProcessType = "userDefined"
                    description = "FakeStringValue"
                    deviceGuardEnableSecureBootWithDMA = $True
                    deviceGuardEnableVirtualizationBasedSecurity = $True
                    deviceGuardLaunchSystemGuard = "notConfigured"
                    deviceGuardLocalSystemAuthorityCredentialGuardSettings = "notConfigured"
                    deviceGuardSecureBootWithDMA = "notConfigured"
                    displayName = "FakeStringValue"
                    dmaGuardDeviceEnumerationPolicy = "deviceDefault"
                    firewallBlockStatefulFTP = $True
                    firewallCertificateRevocationListCheckMethod = "deviceDefault"
                    firewallIdleTimeoutForSecurityAssociationInSeconds = 25
                    firewallIPSecExemptionsAllowDHCP = $True
                    firewallIPSecExemptionsAllowICMP = $True
                    firewallIPSecExemptionsAllowNeighborDiscovery = $True
                    firewallIPSecExemptionsAllowRouterDiscovery = $True
                    firewallIPSecExemptionsNone = $True
                    firewallMergeKeyingModuleSettings = $True
                    firewallPacketQueueingMethod = "deviceDefault"
                    firewallPreSharedKeyEncodingMethod = "deviceDefault"
                    firewallProfileDomain = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsFirewallNetworkProfile -Property @{
                        policyRulesFromGroupPolicyNotMerged = $True
                        inboundConnectionsRequired = $True
                        securedPacketExemptionAllowed = $True
                        securedPacketExemptionBlocked = $True
                        globalPortRulesFromGroupPolicyMerged = $True
                        stealthModeBlocked = $True
                        outboundConnectionsBlocked = $True
                        inboundConnectionsBlocked = $True
                        authorizedApplicationRulesFromGroupPolicyMerged = $True
                        inboundNotificationsRequired = $True
                        firewallEnabled = "notConfigured"
                        stealthModeRequired = $True
                        incomingTrafficBlocked = $True
                        incomingTrafficRequired = $True
                        unicastResponsesToMulticastBroadcastsBlocked = $True
                        policyRulesFromGroupPolicyMerged = $True
                        unicastResponsesToMulticastBroadcastsRequired = $True
                        connectionSecurityRulesFromGroupPolicyNotMerged = $True
                        globalPortRulesFromGroupPolicyNotMerged = $True
                        outboundConnectionsRequired = $True
                        inboundNotificationsBlocked = $True
                        connectionSecurityRulesFromGroupPolicyMerged = $True
                        authorizedApplicationRulesFromGroupPolicyNotMerged = $True
                    } -ClientOnly)
                    firewallProfilePrivate = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsFirewallNetworkProfile -Property @{
                        policyRulesFromGroupPolicyNotMerged = $True
                        inboundConnectionsRequired = $True
                        securedPacketExemptionAllowed = $True
                        securedPacketExemptionBlocked = $True
                        globalPortRulesFromGroupPolicyMerged = $True
                        stealthModeBlocked = $True
                        outboundConnectionsBlocked = $True
                        inboundConnectionsBlocked = $True
                        authorizedApplicationRulesFromGroupPolicyMerged = $True
                        inboundNotificationsRequired = $True
                        firewallEnabled = "notConfigured"
                        stealthModeRequired = $True
                        incomingTrafficBlocked = $True
                        incomingTrafficRequired = $True
                        unicastResponsesToMulticastBroadcastsBlocked = $True
                        policyRulesFromGroupPolicyMerged = $True
                        unicastResponsesToMulticastBroadcastsRequired = $True
                        connectionSecurityRulesFromGroupPolicyNotMerged = $True
                        globalPortRulesFromGroupPolicyNotMerged = $True
                        outboundConnectionsRequired = $True
                        inboundNotificationsBlocked = $True
                        connectionSecurityRulesFromGroupPolicyMerged = $True
                        authorizedApplicationRulesFromGroupPolicyNotMerged = $True
                    } -ClientOnly)
                    firewallProfilePublic = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsFirewallNetworkProfile -Property @{
                        policyRulesFromGroupPolicyNotMerged = $True
                        inboundConnectionsRequired = $True
                        securedPacketExemptionAllowed = $True
                        securedPacketExemptionBlocked = $True
                        globalPortRulesFromGroupPolicyMerged = $True
                        stealthModeBlocked = $True
                        outboundConnectionsBlocked = $True
                        inboundConnectionsBlocked = $True
                        authorizedApplicationRulesFromGroupPolicyMerged = $True
                        inboundNotificationsRequired = $True
                        firewallEnabled = "notConfigured"
                        stealthModeRequired = $True
                        incomingTrafficBlocked = $True
                        incomingTrafficRequired = $True
                        unicastResponsesToMulticastBroadcastsBlocked = $True
                        policyRulesFromGroupPolicyMerged = $True
                        unicastResponsesToMulticastBroadcastsRequired = $True
                        connectionSecurityRulesFromGroupPolicyNotMerged = $True
                        globalPortRulesFromGroupPolicyNotMerged = $True
                        outboundConnectionsRequired = $True
                        inboundNotificationsBlocked = $True
                        connectionSecurityRulesFromGroupPolicyMerged = $True
                        authorizedApplicationRulesFromGroupPolicyNotMerged = $True
                    } -ClientOnly)
                    firewallRules = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsFirewallRule -Property @{
                            localAddressRanges = @("FakeStringValue")
                            action = "notConfigured"
                            description = "FakeStringValue"
                            interfaceTypes = "notConfigured"
                            remotePortRanges = @("FakeStringValue")
                            displayName = "FakeStringValue"
                            filePath = "FakeStringValue"
                            localUserAuthorizations = "FakeStringValue"
                            protocol = 25
                            trafficDirection = "notConfigured"
                            remoteAddressRanges = @("FakeStringValue")
                            packageFamilyName = "FakeStringValue"
                            serviceName = "FakeStringValue"
                            localPortRanges = @("FakeStringValue")
                            profileTypes = "notConfigured"
                            edgeTraversal = "notConfigured"
                        } -ClientOnly)
                    )
                    id = "FakeStringValue"
                    lanManagerAuthenticationLevel = "lmAndNltm"
                    lanManagerWorkstationDisableInsecureGuestLogons = $True
                    localSecurityOptionsAdministratorAccountName = "FakeStringValue"
                    localSecurityOptionsAdministratorElevationPromptBehavior = "notConfigured"
                    localSecurityOptionsAllowAnonymousEnumerationOfSAMAccountsAndShares = $True
                    localSecurityOptionsAllowPKU2UAuthenticationRequests = $True
                    localSecurityOptionsAllowRemoteCallsToSecurityAccountsManager = "FakeStringValue"
                    localSecurityOptionsAllowRemoteCallsToSecurityAccountsManagerHelperBool = $True
                    localSecurityOptionsAllowSystemToBeShutDownWithoutHavingToLogOn = $True
                    localSecurityOptionsAllowUIAccessApplicationElevation = $True
                    localSecurityOptionsAllowUIAccessApplicationsForSecureLocations = $True
                    localSecurityOptionsAllowUndockWithoutHavingToLogon = $True
                    localSecurityOptionsBlockMicrosoftAccounts = $True
                    localSecurityOptionsBlockRemoteLogonWithBlankPassword = $True
                    localSecurityOptionsBlockRemoteOpticalDriveAccess = $True
                    localSecurityOptionsBlockUsersInstallingPrinterDrivers = $True
                    localSecurityOptionsClearVirtualMemoryPageFile = $True
                    localSecurityOptionsClientDigitallySignCommunicationsAlways = $True
                    localSecurityOptionsClientSendUnencryptedPasswordToThirdPartySMBServers = $True
                    localSecurityOptionsDetectApplicationInstallationsAndPromptForElevation = $True
                    localSecurityOptionsDisableAdministratorAccount = $True
                    localSecurityOptionsDisableClientDigitallySignCommunicationsIfServerAgrees = $True
                    localSecurityOptionsDisableGuestAccount = $True
                    localSecurityOptionsDisableServerDigitallySignCommunicationsAlways = $True
                    localSecurityOptionsDisableServerDigitallySignCommunicationsIfClientAgrees = $True
                    localSecurityOptionsDoNotAllowAnonymousEnumerationOfSAMAccounts = $True
                    localSecurityOptionsDoNotRequireCtrlAltDel = $True
                    localSecurityOptionsDoNotStoreLANManagerHashValueOnNextPasswordChange = $True
                    localSecurityOptionsFormatAndEjectOfRemovableMediaAllowedUser = "notConfigured"
                    localSecurityOptionsGuestAccountName = "FakeStringValue"
                    localSecurityOptionsHideLastSignedInUser = $True
                    localSecurityOptionsHideUsernameAtSignIn = $True
                    localSecurityOptionsInformationDisplayedOnLockScreen = "notConfigured"
                    localSecurityOptionsInformationShownOnLockScreen = "notConfigured"
                    localSecurityOptionsLogOnMessageText = "FakeStringValue"
                    localSecurityOptionsLogOnMessageTitle = "FakeStringValue"
                    localSecurityOptionsMachineInactivityLimit = 25
                    localSecurityOptionsMachineInactivityLimitInMinutes = 25
                    localSecurityOptionsMinimumSessionSecurityForNtlmSspBasedClients = "none"
                    localSecurityOptionsMinimumSessionSecurityForNtlmSspBasedServers = "none"
                    localSecurityOptionsOnlyElevateSignedExecutables = $True
                    localSecurityOptionsRestrictAnonymousAccessToNamedPipesAndShares = $True
                    localSecurityOptionsSmartCardRemovalBehavior = "noAction"
                    localSecurityOptionsStandardUserElevationPromptBehavior = "notConfigured"
                    localSecurityOptionsSwitchToSecureDesktopWhenPromptingForElevation = $True
                    localSecurityOptionsUseAdminApprovalMode = $True
                    localSecurityOptionsUseAdminApprovalModeForAdministrators = $True
                    localSecurityOptionsVirtualizeFileAndRegistryWriteFailuresToPerUserLocations = $True
                    smartScreenBlockOverrideForFiles = $True
                    smartScreenEnableInShell = $True
                    supportsScopeTags = $True
                    userRightsAccessCredentialManagerAsTrustedCaller = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsActAsPartOfTheOperatingSystem = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsAllowAccessFromNetwork = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsBackupData = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsBlockAccessFromNetwork = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsChangeSystemTime = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsCreateGlobalObjects = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsCreatePageFile = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsCreatePermanentSharedObjects = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsCreateSymbolicLinks = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsCreateToken = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsDebugPrograms = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsDelegation = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsDenyLocalLogOn = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsGenerateSecurityAudits = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsImpersonateClient = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsIncreaseSchedulingPriority = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsLoadUnloadDrivers = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsLocalLogOn = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsLockMemory = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsManageAuditingAndSecurityLogs = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsManageVolumes = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsModifyFirmwareEnvironment = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsModifyObjectLabels = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsProfileSingleProcess = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsRemoteDesktopServicesLogOn = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsRemoteShutdown = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsRestoreData = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsTakeOwnership = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    windowsDefenderTamperProtection = "notConfigured"
                    xboxServicesAccessoryManagementServiceStartupMode = "manual"
                    xboxServicesEnableXboxGameSaveTask = $True
                    xboxServicesLiveAuthManagerServiceStartupMode = "manual"
                    xboxServicesLiveGameSaveServiceStartupMode = "manual"
                    xboxServicesLiveNetworkingServiceStartupMode = "manual"
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
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
                Should -Invoke -CommandName New-MgBetaDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name "The IntuneDeviceConfigurationEndpointProtectionPolicyWindows10 exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    ApplicationGuardAllowCameraMicrophoneRedirection = $True
                    ApplicationGuardAllowFileSaveOnHost = $True
                    ApplicationGuardAllowPersistence = $True
                    ApplicationGuardAllowPrintToLocalPrinters = $True
                    ApplicationGuardAllowPrintToNetworkPrinters = $True
                    ApplicationGuardAllowPrintToPDF = $True
                    ApplicationGuardAllowPrintToXPS = $True
                    ApplicationGuardAllowVirtualGPU = $True
                    ApplicationGuardBlockClipboardSharing = "notConfigured"
                    ApplicationGuardBlockFileTransfer = "notConfigured"
                    ApplicationGuardBlockNonEnterpriseContent = $True
                    ApplicationGuardCertificateThumbprints = @("FakeStringValue")
                    ApplicationGuardEnabled = $True
                    ApplicationGuardEnabledOptions = "notConfigured"
                    ApplicationGuardForceAuditing = $True
                    AppLockerApplicationControl = "notConfigured"
                    BitLockerAllowStandardUserEncryption = $True
                    BitLockerDisableWarningForOtherDiskEncryption = $True
                    BitLockerEnableStorageCardEncryptionOnMobile = $True
                    BitLockerEncryptDevice = $True
                    bitLockerFixedDrivePolicy = (New-CimInstance -ClassName MSFT_MicrosoftGraphbitLockerFixedDrivePolicy -Property @{
                        RecoveryOptions = (New-CimInstance -ClassName MSFT_MicrosoftGraphbitLockerRecoveryOptions -Property @{
                            RecoveryInformationToStore = "passwordAndKey"
                            HideRecoveryOptions = $True
                            BlockDataRecoveryAgent = $True
                            RecoveryKeyUsage = "blocked"
                            EnableBitLockerAfterRecoveryInformationToStore = $True
                            EnableRecoveryInformationSaveToStore = $True
                            RecoveryPasswordUsage = "blocked"
                        } -ClientOnly)
                        RequireEncryptionForWriteAccess = $True
                        encryptionMethod = "aesCbc128"
                    } -ClientOnly)
                    bitLockerRecoveryPasswordRotation = "notConfigured"
                    bitLockerRemovableDrivePolicy = (New-CimInstance -ClassName MSFT_MicrosoftGraphbitLockerRemovableDrivePolicy -Property @{
                        requireEncryptionForWriteAccess = $True
                        blockCrossOrganizationWriteAccess = $True
                        encryptionMethod = "aesCbc128"
                    } -ClientOnly)
                    bitLockerSystemDrivePolicy = (New-CimInstance -ClassName MSFT_MicrosoftGraphbitLockerSystemDrivePolicy -Property @{
                        prebootRecoveryEnableMessageAndUrl = $True
                        StartupAuthenticationTpmPinUsage = "blocked"
                        encryptionMethod = "aesCbc128"
                        minimumPinLength = 25
                        prebootRecoveryMessage = "FakeStringValue"
                        StartupAuthenticationTpmPinAndKeyUsage = "blocked"
                        StartupAuthenticationRequired = $True
                        RecoveryOptions = (New-CimInstance -ClassName MSFT_MicrosoftGraphbitLockerRecoveryOptions -Property @{
                            RecoveryInformationToStore = "passwordAndKey"
                            HideRecoveryOptions = $True
                            BlockDataRecoveryAgent = $True
                            RecoveryKeyUsage = "blocked"
                            EnableBitLockerAfterRecoveryInformationToStore = $True
                            EnableRecoveryInformationSaveToStore = $True
                            RecoveryPasswordUsage = "blocked"
                        } -ClientOnly)
                        prebootRecoveryUrl = "FakeStringValue"
                        StartupAuthenticationTpmUsage = "blocked"
                        StartupAuthenticationTpmKeyUsage = "blocked"
                        StartupAuthenticationBlockWithoutTpmChip = $True
                    } -ClientOnly)
                    defenderAdditionalGuardedFolders = @("FakeStringValue")
                    defenderAdobeReaderLaunchChildProcess = "userDefined"
                    defenderAdvancedRansomewareProtectionType = "userDefined"
                    defenderAllowBehaviorMonitoring = $True
                    defenderAllowCloudProtection = $True
                    defenderAllowEndUserAccess = $True
                    defenderAllowIntrusionPreventionSystem = $True
                    defenderAllowOnAccessProtection = $True
                    defenderAllowRealTimeMonitoring = $True
                    defenderAllowScanArchiveFiles = $True
                    defenderAllowScanDownloads = $True
                    defenderAllowScanNetworkFiles = $True
                    defenderAllowScanRemovableDrivesDuringFullScan = $True
                    defenderAllowScanScriptsLoadedInInternetExplorer = $True
                    defenderAttackSurfaceReductionExcludedPaths = @("FakeStringValue")
                    defenderBlockEndUserAccess = $True
                    defenderBlockPersistenceThroughWmiType = "userDefined"
                    defenderCheckForSignaturesBeforeRunningScan = $True
                    defenderCloudBlockLevel = "notConfigured"
                    defenderCloudExtendedTimeoutInSeconds = 25
                    defenderDaysBeforeDeletingQuarantinedMalware = 25
                    defenderDetectedMalwareActions = (New-CimInstance -ClassName MSFT_MicrosoftGraphdefenderDetectedMalwareActions -Property @{
                        lowSeverity = "deviceDefault"
                        severeSeverity = "deviceDefault"
                        moderateSeverity = "deviceDefault"
                        highSeverity = "deviceDefault"
                    } -ClientOnly)
                    defenderDisableBehaviorMonitoring = $True
                    defenderDisableCatchupFullScan = $True
                    defenderDisableCatchupQuickScan = $True
                    defenderDisableCloudProtection = $True
                    defenderDisableIntrusionPreventionSystem = $True
                    defenderDisableOnAccessProtection = $True
                    defenderDisableRealTimeMonitoring = $True
                    defenderDisableScanArchiveFiles = $True
                    defenderDisableScanDownloads = $True
                    defenderDisableScanNetworkFiles = $True
                    defenderDisableScanRemovableDrivesDuringFullScan = $True
                    defenderDisableScanScriptsLoadedInInternetExplorer = $True
                    defenderEmailContentExecution = "userDefined"
                    defenderEmailContentExecutionType = "userDefined"
                    defenderEnableLowCpuPriority = $True
                    defenderEnableScanIncomingMail = $True
                    defenderEnableScanMappedNetworkDrivesDuringFullScan = $True
                    defenderExploitProtectionXml = $True
                    defenderExploitProtectionXmlFileName = "FakeStringValue"
                    defenderFileExtensionsToExclude = @("FakeStringValue")
                    defenderFilesAndFoldersToExclude = @("FakeStringValue")
                    defenderGuardedFoldersAllowedAppPaths = @("FakeStringValue")
                    defenderGuardMyFoldersType = "userDefined"
                    defenderNetworkProtectionType = "userDefined"
                    defenderOfficeAppsExecutableContentCreationOrLaunch = "userDefined"
                    defenderOfficeAppsExecutableContentCreationOrLaunchType = "userDefined"
                    defenderOfficeAppsLaunchChildProcess = "userDefined"
                    defenderOfficeAppsLaunchChildProcessType = "userDefined"
                    defenderOfficeAppsOtherProcessInjection = "userDefined"
                    defenderOfficeAppsOtherProcessInjectionType = "userDefined"
                    defenderOfficeCommunicationAppsLaunchChildProcess = "userDefined"
                    defenderOfficeMacroCodeAllowWin32Imports = "userDefined"
                    defenderOfficeMacroCodeAllowWin32ImportsType = "userDefined"
                    defenderPotentiallyUnwantedAppAction = "userDefined"
                    defenderPreventCredentialStealingType = "userDefined"
                    defenderProcessCreation = "userDefined"
                    defenderProcessCreationType = "userDefined"
                    defenderProcessesToExclude = @("FakeStringValue")
                    defenderScanDirection = "monitorAllFiles"
                    defenderScanMaxCpuPercentage = 25
                    defenderScanType = "userDefined"
                    defenderScheduledQuickScanTime = "00:00:00"
                    defenderScheduledScanDay = "userDefined"
                    defenderScheduledScanTime = "00:00:00"
                    defenderScriptDownloadedPayloadExecution = "userDefined"
                    defenderScriptDownloadedPayloadExecutionType = "userDefined"
                    defenderScriptObfuscatedMacroCode = "userDefined"
                    defenderScriptObfuscatedMacroCodeType = "userDefined"
                    defenderSecurityCenterBlockExploitProtectionOverride = $True
                    defenderSecurityCenterDisableAccountUI = $True
                    defenderSecurityCenterDisableAppBrowserUI = $True
                    defenderSecurityCenterDisableClearTpmUI = $True
                    defenderSecurityCenterDisableFamilyUI = $True
                    defenderSecurityCenterDisableHardwareUI = $True
                    defenderSecurityCenterDisableHealthUI = $True
                    defenderSecurityCenterDisableNetworkUI = $True
                    defenderSecurityCenterDisableNotificationAreaUI = $True
                    defenderSecurityCenterDisableRansomwareUI = $True
                    defenderSecurityCenterDisableSecureBootUI = $True
                    defenderSecurityCenterDisableTroubleshootingUI = $True
                    defenderSecurityCenterDisableVirusUI = $True
                    defenderSecurityCenterDisableVulnerableTpmFirmwareUpdateUI = $True
                    defenderSecurityCenterHelpEmail = "FakeStringValue"
                    defenderSecurityCenterHelpPhone = "FakeStringValue"
                    defenderSecurityCenterHelpURL = "FakeStringValue"
                    defenderSecurityCenterITContactDisplay = "notConfigured"
                    defenderSecurityCenterNotificationsFromApp = "notConfigured"
                    defenderSecurityCenterOrganizationDisplayName = "FakeStringValue"
                    defenderSignatureUpdateIntervalInHours = 25
                    defenderSubmitSamplesConsentType = "sendSafeSamplesAutomatically"
                    defenderUntrustedExecutable = "userDefined"
                    defenderUntrustedExecutableType = "userDefined"
                    defenderUntrustedUSBProcess = "userDefined"
                    defenderUntrustedUSBProcessType = "userDefined"
                    description = "FakeStringValue"
                    deviceGuardEnableSecureBootWithDMA = $True
                    deviceGuardEnableVirtualizationBasedSecurity = $True
                    deviceGuardLaunchSystemGuard = "notConfigured"
                    deviceGuardLocalSystemAuthorityCredentialGuardSettings = "notConfigured"
                    deviceGuardSecureBootWithDMA = "notConfigured"
                    displayName = "FakeStringValue"
                    dmaGuardDeviceEnumerationPolicy = "deviceDefault"
                    firewallBlockStatefulFTP = $True
                    firewallCertificateRevocationListCheckMethod = "deviceDefault"
                    firewallIdleTimeoutForSecurityAssociationInSeconds = 25
                    firewallIPSecExemptionsAllowDHCP = $True
                    firewallIPSecExemptionsAllowICMP = $True
                    firewallIPSecExemptionsAllowNeighborDiscovery = $True
                    firewallIPSecExemptionsAllowRouterDiscovery = $True
                    firewallIPSecExemptionsNone = $True
                    firewallMergeKeyingModuleSettings = $True
                    firewallPacketQueueingMethod = "deviceDefault"
                    firewallPreSharedKeyEncodingMethod = "deviceDefault"
                    firewallProfileDomain = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsFirewallNetworkProfile -Property @{
                        policyRulesFromGroupPolicyNotMerged = $True
                        inboundConnectionsRequired = $True
                        securedPacketExemptionAllowed = $True
                        securedPacketExemptionBlocked = $True
                        globalPortRulesFromGroupPolicyMerged = $True
                        stealthModeBlocked = $True
                        outboundConnectionsBlocked = $True
                        inboundConnectionsBlocked = $True
                        authorizedApplicationRulesFromGroupPolicyMerged = $True
                        inboundNotificationsRequired = $True
                        firewallEnabled = "notConfigured"
                        stealthModeRequired = $True
                        incomingTrafficBlocked = $True
                        incomingTrafficRequired = $True
                        unicastResponsesToMulticastBroadcastsBlocked = $True
                        policyRulesFromGroupPolicyMerged = $True
                        unicastResponsesToMulticastBroadcastsRequired = $True
                        connectionSecurityRulesFromGroupPolicyNotMerged = $True
                        globalPortRulesFromGroupPolicyNotMerged = $True
                        outboundConnectionsRequired = $True
                        inboundNotificationsBlocked = $True
                        connectionSecurityRulesFromGroupPolicyMerged = $True
                        authorizedApplicationRulesFromGroupPolicyNotMerged = $True
                    } -ClientOnly)
                    firewallProfilePrivate = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsFirewallNetworkProfile -Property @{
                        policyRulesFromGroupPolicyNotMerged = $True
                        inboundConnectionsRequired = $True
                        securedPacketExemptionAllowed = $True
                        securedPacketExemptionBlocked = $True
                        globalPortRulesFromGroupPolicyMerged = $True
                        stealthModeBlocked = $True
                        outboundConnectionsBlocked = $True
                        inboundConnectionsBlocked = $True
                        authorizedApplicationRulesFromGroupPolicyMerged = $True
                        inboundNotificationsRequired = $True
                        firewallEnabled = "notConfigured"
                        stealthModeRequired = $True
                        incomingTrafficBlocked = $True
                        incomingTrafficRequired = $True
                        unicastResponsesToMulticastBroadcastsBlocked = $True
                        policyRulesFromGroupPolicyMerged = $True
                        unicastResponsesToMulticastBroadcastsRequired = $True
                        connectionSecurityRulesFromGroupPolicyNotMerged = $True
                        globalPortRulesFromGroupPolicyNotMerged = $True
                        outboundConnectionsRequired = $True
                        inboundNotificationsBlocked = $True
                        connectionSecurityRulesFromGroupPolicyMerged = $True
                        authorizedApplicationRulesFromGroupPolicyNotMerged = $True
                    } -ClientOnly)
                    firewallProfilePublic = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsFirewallNetworkProfile -Property @{
                        policyRulesFromGroupPolicyNotMerged = $True
                        inboundConnectionsRequired = $True
                        securedPacketExemptionAllowed = $True
                        securedPacketExemptionBlocked = $True
                        globalPortRulesFromGroupPolicyMerged = $True
                        stealthModeBlocked = $True
                        outboundConnectionsBlocked = $True
                        inboundConnectionsBlocked = $True
                        authorizedApplicationRulesFromGroupPolicyMerged = $True
                        inboundNotificationsRequired = $True
                        firewallEnabled = "notConfigured"
                        stealthModeRequired = $True
                        incomingTrafficBlocked = $True
                        incomingTrafficRequired = $True
                        unicastResponsesToMulticastBroadcastsBlocked = $True
                        policyRulesFromGroupPolicyMerged = $True
                        unicastResponsesToMulticastBroadcastsRequired = $True
                        connectionSecurityRulesFromGroupPolicyNotMerged = $True
                        globalPortRulesFromGroupPolicyNotMerged = $True
                        outboundConnectionsRequired = $True
                        inboundNotificationsBlocked = $True
                        connectionSecurityRulesFromGroupPolicyMerged = $True
                        authorizedApplicationRulesFromGroupPolicyNotMerged = $True
                    } -ClientOnly)
                    firewallRules = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsFirewallRule -Property @{
                            localAddressRanges = @("FakeStringValue")
                            action = "notConfigured"
                            description = "FakeStringValue"
                            interfaceTypes = "notConfigured"
                            remotePortRanges = @("FakeStringValue")
                            displayName = "FakeStringValue"
                            filePath = "FakeStringValue"
                            localUserAuthorizations = "FakeStringValue"
                            protocol = 25
                            trafficDirection = "notConfigured"
                            remoteAddressRanges = @("FakeStringValue")
                            packageFamilyName = "FakeStringValue"
                            serviceName = "FakeStringValue"
                            localPortRanges = @("FakeStringValue")
                            profileTypes = "notConfigured"
                            edgeTraversal = "notConfigured"
                        } -ClientOnly)
                    )
                    id = "FakeStringValue"
                    lanManagerAuthenticationLevel = "lmAndNltm"
                    lanManagerWorkstationDisableInsecureGuestLogons = $True
                    localSecurityOptionsAdministratorAccountName = "FakeStringValue"
                    localSecurityOptionsAdministratorElevationPromptBehavior = "notConfigured"
                    localSecurityOptionsAllowAnonymousEnumerationOfSAMAccountsAndShares = $True
                    localSecurityOptionsAllowPKU2UAuthenticationRequests = $True
                    localSecurityOptionsAllowRemoteCallsToSecurityAccountsManager = "FakeStringValue"
                    localSecurityOptionsAllowRemoteCallsToSecurityAccountsManagerHelperBool = $True
                    localSecurityOptionsAllowSystemToBeShutDownWithoutHavingToLogOn = $True
                    localSecurityOptionsAllowUIAccessApplicationElevation = $True
                    localSecurityOptionsAllowUIAccessApplicationsForSecureLocations = $True
                    localSecurityOptionsAllowUndockWithoutHavingToLogon = $True
                    localSecurityOptionsBlockMicrosoftAccounts = $True
                    localSecurityOptionsBlockRemoteLogonWithBlankPassword = $True
                    localSecurityOptionsBlockRemoteOpticalDriveAccess = $True
                    localSecurityOptionsBlockUsersInstallingPrinterDrivers = $True
                    localSecurityOptionsClearVirtualMemoryPageFile = $True
                    localSecurityOptionsClientDigitallySignCommunicationsAlways = $True
                    localSecurityOptionsClientSendUnencryptedPasswordToThirdPartySMBServers = $True
                    localSecurityOptionsDetectApplicationInstallationsAndPromptForElevation = $True
                    localSecurityOptionsDisableAdministratorAccount = $True
                    localSecurityOptionsDisableClientDigitallySignCommunicationsIfServerAgrees = $True
                    localSecurityOptionsDisableGuestAccount = $True
                    localSecurityOptionsDisableServerDigitallySignCommunicationsAlways = $True
                    localSecurityOptionsDisableServerDigitallySignCommunicationsIfClientAgrees = $True
                    localSecurityOptionsDoNotAllowAnonymousEnumerationOfSAMAccounts = $True
                    localSecurityOptionsDoNotRequireCtrlAltDel = $True
                    localSecurityOptionsDoNotStoreLANManagerHashValueOnNextPasswordChange = $True
                    localSecurityOptionsFormatAndEjectOfRemovableMediaAllowedUser = "notConfigured"
                    localSecurityOptionsGuestAccountName = "FakeStringValue"
                    localSecurityOptionsHideLastSignedInUser = $True
                    localSecurityOptionsHideUsernameAtSignIn = $True
                    localSecurityOptionsInformationDisplayedOnLockScreen = "notConfigured"
                    localSecurityOptionsInformationShownOnLockScreen = "notConfigured"
                    localSecurityOptionsLogOnMessageText = "FakeStringValue"
                    localSecurityOptionsLogOnMessageTitle = "FakeStringValue"
                    localSecurityOptionsMachineInactivityLimit = 25
                    localSecurityOptionsMachineInactivityLimitInMinutes = 25
                    localSecurityOptionsMinimumSessionSecurityForNtlmSspBasedClients = "none"
                    localSecurityOptionsMinimumSessionSecurityForNtlmSspBasedServers = "none"
                    localSecurityOptionsOnlyElevateSignedExecutables = $True
                    localSecurityOptionsRestrictAnonymousAccessToNamedPipesAndShares = $True
                    localSecurityOptionsSmartCardRemovalBehavior = "noAction"
                    localSecurityOptionsStandardUserElevationPromptBehavior = "notConfigured"
                    localSecurityOptionsSwitchToSecureDesktopWhenPromptingForElevation = $True
                    localSecurityOptionsUseAdminApprovalMode = $True
                    localSecurityOptionsUseAdminApprovalModeForAdministrators = $True
                    localSecurityOptionsVirtualizeFileAndRegistryWriteFailuresToPerUserLocations = $True
                    smartScreenBlockOverrideForFiles = $True
                    smartScreenEnableInShell = $True
                    supportsScopeTags = $True
                    userRightsAccessCredentialManagerAsTrustedCaller = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsActAsPartOfTheOperatingSystem = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsAllowAccessFromNetwork = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsBackupData = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsBlockAccessFromNetwork = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsChangeSystemTime = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsCreateGlobalObjects = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsCreatePageFile = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsCreatePermanentSharedObjects = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsCreateSymbolicLinks = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsCreateToken = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsDebugPrograms = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsDelegation = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsDenyLocalLogOn = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsGenerateSecurityAudits = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsImpersonateClient = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsIncreaseSchedulingPriority = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsLoadUnloadDrivers = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsLocalLogOn = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsLockMemory = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsManageAuditingAndSecurityLogs = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsManageVolumes = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsModifyFirmwareEnvironment = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsModifyObjectLabels = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsProfileSingleProcess = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsRemoteDesktopServicesLogOn = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsRemoteShutdown = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsRestoreData = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsTakeOwnership = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    windowsDefenderTamperProtection = "notConfigured"
                    xboxServicesAccessoryManagementServiceStartupMode = "manual"
                    xboxServicesEnableXboxGameSaveTask = $True
                    xboxServicesLiveAuthManagerServiceStartupMode = "manual"
                    xboxServicesLiveGameSaveServiceStartupMode = "manual"
                    xboxServicesLiveNetworkingServiceStartupMode = "manual"
                    Ensure = "Absent"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            localSecurityOptionsClearVirtualMemoryPageFile = $True
                            defenderSecurityCenterDisableHardwareUI = $True
                            applicationGuardAllowPrintToNetworkPrinters = $True
                            defenderFilesAndFoldersToExclude = @("FakeStringValue")
                            defenderAllowScanArchiveFiles = $True
                            firewallIPSecExemptionsNone = $True
                            bitLockerAllowStandardUserEncryption = $True
                            localSecurityOptionsAllowRemoteCallsToSecurityAccountsManager = "FakeStringValue"
                            defenderScheduledScanDay = "userDefined"
                            firewallPacketQueueingMethod = "deviceDefault"
                            defenderUntrustedUSBProcessType = "userDefined"
                            defenderNetworkProtectionType = "userDefined"
                            defenderProcessCreation = "userDefined"
                            applicationGuardEnabledOptions = "notConfigured"
                            defenderOfficeAppsLaunchChildProcess = "userDefined"
                            defenderAllowRealTimeMonitoring = $True
                            firewallIPSecExemptionsAllowNeighborDiscovery = $True
                            defenderUntrustedExecutable = "userDefined"
                            defenderGuardMyFoldersType = "userDefined"
                            localSecurityOptionsInformationDisplayedOnLockScreen = "notConfigured"
                            defenderScheduledQuickScanTime = "00:00:00"
                            localSecurityOptionsUseAdminApprovalMode = $True
                            applicationGuardAllowCameraMicrophoneRedirection = $True
                            applicationGuardAllowPrintToXPS = $True
                            deviceGuardLaunchSystemGuard = "notConfigured"
                            defenderScanDirection = "monitorAllFiles"
                            userRightsIncreaseSchedulingPriority = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            deviceGuardEnableVirtualizationBasedSecurity = $True
                            defenderBlockEndUserAccess = $True
                            firewallIPSecExemptionsAllowRouterDiscovery = $True
                            xboxServicesLiveGameSaveServiceStartupMode = "manual"
                            bitLockerFixedDrivePolicy = @{
                                RecoveryOptions = @{
                                    RecoveryInformationToStore = "passwordAndKey"
                                    HideRecoveryOptions = $True
                                    BlockDataRecoveryAgent = $True
                                    RecoveryKeyUsage = "blocked"
                                    EnableBitLockerAfterRecoveryInformationToStore = $True
                                    EnableRecoveryInformationSaveToStore = $True
                                    RecoveryPasswordUsage = "blocked"
                                }
                                RequireEncryptionForWriteAccess = $True
                                encryptionMethod = "aesCbc128"
                            }
                            userRightsCreateSymbolicLinks = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            applicationGuardBlockFileTransfer = "notConfigured"
                            defenderCheckForSignaturesBeforeRunningScan = $True
                            userRightsRemoteShutdown = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            firewallRules = @(
                                @{
                                    localAddressRanges = @("FakeStringValue")
                                    action = "notConfigured"
                                    description = "FakeStringValue"
                                    interfaceTypes = "notConfigured"
                                    remotePortRanges = @("FakeStringValue")
                                    displayName = "FakeStringValue"
                                    filePath = "FakeStringValue"
                                    localUserAuthorizations = "FakeStringValue"
                                    protocol = 25
                                    trafficDirection = "notConfigured"
                                    remoteAddressRanges = @("FakeStringValue")
                                    packageFamilyName = "FakeStringValue"
                                    serviceName = "FakeStringValue"
                                    localPortRanges = @("FakeStringValue")
                                    profileTypes = "notConfigured"
                                    edgeTraversal = "notConfigured"
                                }
                            )
                            defenderSignatureUpdateIntervalInHours = 25
                            defenderEnableLowCpuPriority = $True
                            localSecurityOptionsAllowAnonymousEnumerationOfSAMAccountsAndShares = $True
                            defenderFileExtensionsToExclude = @("FakeStringValue")
                            localSecurityOptionsHideLastSignedInUser = $True
                            userRightsBlockAccessFromNetwork = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsMinimumSessionSecurityForNtlmSspBasedServers = "none"
                            xboxServicesLiveAuthManagerServiceStartupMode = "manual"
                            localSecurityOptionsMachineInactivityLimitInMinutes = 25
                            localSecurityOptionsClientDigitallySignCommunicationsAlways = $True
                            defenderSecurityCenterDisableNetworkUI = $True
                            userRightsModifyObjectLabels = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            deviceGuardLocalSystemAuthorityCredentialGuardSettings = "notConfigured"
                            firewallIdleTimeoutForSecurityAssociationInSeconds = 25
                            defenderSecurityCenterHelpURL = "FakeStringValue"
                            localSecurityOptionsDisableServerDigitallySignCommunicationsAlways = $True
                            localSecurityOptionsAllowRemoteCallsToSecurityAccountsManagerHelperBool = $True
                            userRightsChangeSystemTime = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsAllowUndockWithoutHavingToLogon = $True
                            defenderEnableScanMappedNetworkDrivesDuringFullScan = $True
                            defenderUntrustedUSBProcess = "userDefined"
                            localSecurityOptionsHideUsernameAtSignIn = $True
                            defenderAllowScanDownloads = $True
                            localSecurityOptionsDisableAdministratorAccount = $True
                            defenderSecurityCenterDisableHealthUI = $True
                            userRightsCreateGlobalObjects = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsRestrictAnonymousAccessToNamedPipesAndShares = $True
                            localSecurityOptionsMachineInactivityLimit = 25
                            firewallCertificateRevocationListCheckMethod = "deviceDefault"
                            defenderSecurityCenterDisableFamilyUI = $True
                            defenderAllowCloudProtection = $True
                            bitLockerEnableStorageCardEncryptionOnMobile = $True
                            applicationGuardEnabled = $True
                            defenderOfficeAppsOtherProcessInjection = "userDefined"
                            userRightsImpersonateClient = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            '@odata.type' = "#microsoft.graph.windows10EndpointProtectionConfiguration"
                            localSecurityOptionsUseAdminApprovalModeForAdministrators = $True
                            lanManagerWorkstationDisableInsecureGuestLogons = $True
                            defenderAdvancedRansomewareProtectionType = "userDefined"
                            defenderUntrustedExecutableType = "userDefined"
                            defenderDisableScanArchiveFiles = $True
                            lanManagerAuthenticationLevel = "lmAndNltm"
                            userRightsActAsPartOfTheOperatingSystem = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderPreventCredentialStealingType = "userDefined"
                            localSecurityOptionsAllowUIAccessApplicationsForSecureLocations = $True
                            deviceGuardEnableSecureBootWithDMA = $True
                            localSecurityOptionsDisableClientDigitallySignCommunicationsIfServerAgrees = $True
                            defenderScriptObfuscatedMacroCode = "userDefined"
                            defenderDaysBeforeDeletingQuarantinedMalware = 25
                            defenderAllowScanRemovableDrivesDuringFullScan = $True
                            localSecurityOptionsDisableServerDigitallySignCommunicationsIfClientAgrees = $True
                            firewallProfilePrivate = @{
                                policyRulesFromGroupPolicyNotMerged = $True
                                inboundConnectionsRequired = $True
                                securedPacketExemptionAllowed = $True
                                securedPacketExemptionBlocked = $True
                                globalPortRulesFromGroupPolicyMerged = $True
                                stealthModeBlocked = $True
                                outboundConnectionsBlocked = $True
                                inboundConnectionsBlocked = $True
                                authorizedApplicationRulesFromGroupPolicyMerged = $True
                                inboundNotificationsRequired = $True
                                firewallEnabled = "notConfigured"
                                stealthModeRequired = $True
                                incomingTrafficBlocked = $True
                                incomingTrafficRequired = $True
                                unicastResponsesToMulticastBroadcastsBlocked = $True
                                policyRulesFromGroupPolicyMerged = $True
                                unicastResponsesToMulticastBroadcastsRequired = $True
                                connectionSecurityRulesFromGroupPolicyNotMerged = $True
                                globalPortRulesFromGroupPolicyNotMerged = $True
                                outboundConnectionsRequired = $True
                                inboundNotificationsBlocked = $True
                                connectionSecurityRulesFromGroupPolicyMerged = $True
                                authorizedApplicationRulesFromGroupPolicyNotMerged = $True
                            }
                            defenderSecurityCenterDisableAppBrowserUI = $True
                            localSecurityOptionsInformationShownOnLockScreen = "notConfigured"
                            defenderOfficeAppsLaunchChildProcessType = "userDefined"
                            deviceGuardSecureBootWithDMA = "notConfigured"
                            applicationGuardAllowPrintToPDF = $True
                            userRightsCreateToken = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderExploitProtectionXml = $True
                            userRightsRemoteDesktopServicesLogOn = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsBlockRemoteLogonWithBlankPassword = $True
                            userRightsBackupData = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            userRightsDenyLocalLogOn = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsOnlyElevateSignedExecutables = $True
                            applicationGuardAllowVirtualGPU = $True
                            defenderScanType = "userDefined"
                            bitLockerSystemDrivePolicy = @{
                                prebootRecoveryEnableMessageAndUrl = $True
                                StartupAuthenticationTpmPinUsage = "blocked"
                                encryptionMethod = "aesCbc128"
                                minimumPinLength = 25
                                prebootRecoveryMessage = "FakeStringValue"
                                StartupAuthenticationTpmPinAndKeyUsage = "blocked"
                                StartupAuthenticationRequired = $True
                                RecoveryOptions = @{
                                    RecoveryInformationToStore = "passwordAndKey"
                                    HideRecoveryOptions = $True
                                    BlockDataRecoveryAgent = $True
                                    RecoveryKeyUsage = "blocked"
                                    EnableBitLockerAfterRecoveryInformationToStore = $True
                                    EnableRecoveryInformationSaveToStore = $True
                                    RecoveryPasswordUsage = "blocked"
                                }
                                prebootRecoveryUrl = "FakeStringValue"
                                StartupAuthenticationTpmUsage = "blocked"
                                StartupAuthenticationTpmKeyUsage = "blocked"
                                StartupAuthenticationBlockWithoutTpmChip = $True
                            }
                            defenderAllowBehaviorMonitoring = $True
                            defenderAllowIntrusionPreventionSystem = $True
                            localSecurityOptionsDoNotStoreLANManagerHashValueOnNextPasswordChange = $True
                            defenderSecurityCenterHelpEmail = "FakeStringValue"
                            defenderDisableBehaviorMonitoring = $True
                            localSecurityOptionsVirtualizeFileAndRegistryWriteFailuresToPerUserLocations = $True
                            applicationGuardBlockClipboardSharing = "notConfigured"
                            defenderEmailContentExecution = "userDefined"
                            localSecurityOptionsBlockRemoteOpticalDriveAccess = $True
                            firewallProfilePublic = @{
                                policyRulesFromGroupPolicyNotMerged = $True
                                inboundConnectionsRequired = $True
                                securedPacketExemptionAllowed = $True
                                securedPacketExemptionBlocked = $True
                                globalPortRulesFromGroupPolicyMerged = $True
                                stealthModeBlocked = $True
                                outboundConnectionsBlocked = $True
                                inboundConnectionsBlocked = $True
                                authorizedApplicationRulesFromGroupPolicyMerged = $True
                                inboundNotificationsRequired = $True
                                firewallEnabled = "notConfigured"
                                stealthModeRequired = $True
                                incomingTrafficBlocked = $True
                                incomingTrafficRequired = $True
                                unicastResponsesToMulticastBroadcastsBlocked = $True
                                policyRulesFromGroupPolicyMerged = $True
                                unicastResponsesToMulticastBroadcastsRequired = $True
                                connectionSecurityRulesFromGroupPolicyNotMerged = $True
                                globalPortRulesFromGroupPolicyNotMerged = $True
                                outboundConnectionsRequired = $True
                                inboundNotificationsBlocked = $True
                                connectionSecurityRulesFromGroupPolicyMerged = $True
                                authorizedApplicationRulesFromGroupPolicyNotMerged = $True
                            }
                            defenderScriptDownloadedPayloadExecutionType = "userDefined"
                            xboxServicesAccessoryManagementServiceStartupMode = "manual"
                            xboxServicesEnableXboxGameSaveTask = $True
                            bitLockerEncryptDevice = $True
                            localSecurityOptionsBlockMicrosoftAccounts = $True
                            bitLockerRemovableDrivePolicy = @{
                                requireEncryptionForWriteAccess = $True
                                blockCrossOrganizationWriteAccess = $True
                                encryptionMethod = "aesCbc128"
                            }
                            defenderSecurityCenterBlockExploitProtectionOverride = $True
                            localSecurityOptionsLogOnMessageText = "FakeStringValue"
                            applicationGuardCertificateThumbprints = @("FakeStringValue")
                            defenderCloudBlockLevel = "notConfigured"
                            defenderProcessCreationType = "userDefined"
                            defenderDisableScanDownloads = $True
                            defenderOfficeCommunicationAppsLaunchChildProcess = "userDefined"
                            localSecurityOptionsClientSendUnencryptedPasswordToThirdPartySMBServers = $True
                            userRightsAllowAccessFromNetwork = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            applicationGuardForceAuditing = $True
                            defenderDisableRealTimeMonitoring = $True
                            defenderSecurityCenterNotificationsFromApp = "notConfigured"
                            localSecurityOptionsAdministratorAccountName = "FakeStringValue"
                            windowsDefenderTamperProtection = "notConfigured"
                            defenderSecurityCenterDisableAccountUI = $True
                            localSecurityOptionsSwitchToSecureDesktopWhenPromptingForElevation = $True
                            defenderEmailContentExecutionType = "userDefined"
                            defenderAllowScanNetworkFiles = $True
                            defenderSecurityCenterDisableNotificationAreaUI = $True
                            userRightsProfileSingleProcess = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsSmartCardRemovalBehavior = "noAction"
                            defenderDisableCloudProtection = $True
                            userRightsManageVolumes = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            smartScreenEnableInShell = $True
                            applicationGuardBlockNonEnterpriseContent = $True
                            defenderAdditionalGuardedFolders = @("FakeStringValue")
                            localSecurityOptionsDoNotAllowAnonymousEnumerationOfSAMAccounts = $True
                            userRightsRestoreData = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsMinimumSessionSecurityForNtlmSspBasedClients = "none"
                            defenderDisableOnAccessProtection = $True
                            bitLockerRecoveryPasswordRotation = "notConfigured"
                            firewallPreSharedKeyEncodingMethod = "deviceDefault"
                            userRightsDelegation = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            userRightsDebugPrograms = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderSecurityCenterDisableVulnerableTpmFirmwareUpdateUI = $True
                            defenderSecurityCenterOrganizationDisplayName = "FakeStringValue"
                            localSecurityOptionsFormatAndEjectOfRemovableMediaAllowedUser = "notConfigured"
                            userRightsLockMemory = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            appLockerApplicationControl = "notConfigured"
                            defenderBlockPersistenceThroughWmiType = "userDefined"
                            defenderDisableScanNetworkFiles = $True
                            defenderDisableCatchupQuickScan = $True
                            localSecurityOptionsLogOnMessageTitle = "FakeStringValue"
                            localSecurityOptionsStandardUserElevationPromptBehavior = "notConfigured"
                            userRightsGenerateSecurityAudits = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderSecurityCenterDisableClearTpmUI = $True
                            defenderEnableScanIncomingMail = $True
                            defenderSecurityCenterHelpPhone = "FakeStringValue"
                            localSecurityOptionsDoNotRequireCtrlAltDel = $True
                            userRightsTakeOwnership = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            userRightsLocalLogOn = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            applicationGuardAllowPersistence = $True
                            defenderCloudExtendedTimeoutInSeconds = 25
                            firewallIPSecExemptionsAllowICMP = $True
                            defenderAllowEndUserAccess = $True
                            defenderScriptDownloadedPayloadExecution = "userDefined"
                            defenderExploitProtectionXmlFileName = "FakeStringValue"
                            defenderScriptObfuscatedMacroCodeType = "userDefined"
                            defenderDisableScanRemovableDrivesDuringFullScan = $True
                            localSecurityOptionsAllowSystemToBeShutDownWithoutHavingToLogOn = $True
                            defenderOfficeMacroCodeAllowWin32ImportsType = "userDefined"
                            firewallIPSecExemptionsAllowDHCP = $True
                            firewallProfileDomain = @{
                                policyRulesFromGroupPolicyNotMerged = $True
                                inboundConnectionsRequired = $True
                                securedPacketExemptionAllowed = $True
                                securedPacketExemptionBlocked = $True
                                globalPortRulesFromGroupPolicyMerged = $True
                                stealthModeBlocked = $True
                                outboundConnectionsBlocked = $True
                                inboundConnectionsBlocked = $True
                                authorizedApplicationRulesFromGroupPolicyMerged = $True
                                inboundNotificationsRequired = $True
                                firewallEnabled = "notConfigured"
                                stealthModeRequired = $True
                                incomingTrafficBlocked = $True
                                incomingTrafficRequired = $True
                                unicastResponsesToMulticastBroadcastsBlocked = $True
                                policyRulesFromGroupPolicyMerged = $True
                                unicastResponsesToMulticastBroadcastsRequired = $True
                                connectionSecurityRulesFromGroupPolicyNotMerged = $True
                                globalPortRulesFromGroupPolicyNotMerged = $True
                                outboundConnectionsRequired = $True
                                inboundNotificationsBlocked = $True
                                connectionSecurityRulesFromGroupPolicyMerged = $True
                                authorizedApplicationRulesFromGroupPolicyNotMerged = $True
                            }
                            localSecurityOptionsAllowPKU2UAuthenticationRequests = $True
                            defenderSecurityCenterDisableTroubleshootingUI = $True
                            defenderPotentiallyUnwantedAppAction = "userDefined"
                            userRightsModifyFirmwareEnvironment = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderOfficeAppsExecutableContentCreationOrLaunch = "userDefined"
                            defenderOfficeAppsExecutableContentCreationOrLaunchType = "userDefined"
                            defenderSubmitSamplesConsentType = "sendSafeSamplesAutomatically"
                            defenderAdobeReaderLaunchChildProcess = "userDefined"
                            localSecurityOptionsDetectApplicationInstallationsAndPromptForElevation = $True
                            defenderDisableIntrusionPreventionSystem = $True
                            defenderDisableCatchupFullScan = $True
                            bitLockerDisableWarningForOtherDiskEncryption = $True
                            xboxServicesLiveNetworkingServiceStartupMode = "manual"
                            firewallBlockStatefulFTP = $True
                            firewallMergeKeyingModuleSettings = $True
                            userRightsManageAuditingAndSecurityLogs = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            userRightsCreatePermanentSharedObjects = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsBlockUsersInstallingPrinterDrivers = $True
                            smartScreenBlockOverrideForFiles = $True
                            userRightsCreatePageFile = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderAllowOnAccessProtection = $True
                            dmaGuardDeviceEnumerationPolicy = "deviceDefault"
                            defenderOfficeAppsOtherProcessInjectionType = "userDefined"
                            localSecurityOptionsGuestAccountName = "FakeStringValue"
                            defenderDetectedMalwareActions = @{
                                lowSeverity = "deviceDefault"
                                severeSeverity = "deviceDefault"
                                moderateSeverity = "deviceDefault"
                                highSeverity = "deviceDefault"
                            }
                            defenderProcessesToExclude = @("FakeStringValue")
                            defenderScheduledScanTime = "00:00:00"
                            defenderSecurityCenterDisableSecureBootUI = $True
                            applicationGuardAllowFileSaveOnHost = $True
                            localSecurityOptionsDisableGuestAccount = $True
                            defenderSecurityCenterDisableRansomwareUI = $True
                            defenderGuardedFoldersAllowedAppPaths = @("FakeStringValue")
                            defenderOfficeMacroCodeAllowWin32Imports = "userDefined"
                            applicationGuardAllowPrintToLocalPrinters = $True
                            defenderSecurityCenterITContactDisplay = "notConfigured"
                            defenderAttackSurfaceReductionExcludedPaths = @("FakeStringValue")
                            defenderAllowScanScriptsLoadedInInternetExplorer = $True
                            defenderSecurityCenterDisableVirusUI = $True
                            userRightsAccessCredentialManagerAsTrustedCaller = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsAllowUIAccessApplicationElevation = $True
                            defenderDisableScanScriptsLoadedInInternetExplorer = $True
                            localSecurityOptionsAdministratorElevationPromptBehavior = "notConfigured"
                            userRightsLoadUnloadDrivers = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderScanMaxCpuPercentage = 25
                        }
                        description = "FakeStringValue"
                        displayName = "FakeStringValue"
                        id = "FakeStringValue"
                        supportsScopeTags = $True

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
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementDeviceConfiguration -Exactly 1
            }
        }
        Context -Name "The IntuneDeviceConfigurationEndpointProtectionPolicyWindows10 Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    ApplicationGuardAllowCameraMicrophoneRedirection = $True
                    ApplicationGuardAllowFileSaveOnHost = $True
                    ApplicationGuardAllowPersistence = $True
                    ApplicationGuardAllowPrintToLocalPrinters = $True
                    ApplicationGuardAllowPrintToNetworkPrinters = $True
                    ApplicationGuardAllowPrintToPDF = $True
                    ApplicationGuardAllowPrintToXPS = $True
                    ApplicationGuardAllowVirtualGPU = $True
                    ApplicationGuardBlockClipboardSharing = "notConfigured"
                    ApplicationGuardBlockFileTransfer = "notConfigured"
                    ApplicationGuardBlockNonEnterpriseContent = $True
                    ApplicationGuardCertificateThumbprints = @("FakeStringValue")
                    ApplicationGuardEnabled = $True
                    ApplicationGuardEnabledOptions = "notConfigured"
                    ApplicationGuardForceAuditing = $True
                    AppLockerApplicationControl = "notConfigured"
                    BitLockerAllowStandardUserEncryption = $True
                    BitLockerDisableWarningForOtherDiskEncryption = $True
                    BitLockerEnableStorageCardEncryptionOnMobile = $True
                    BitLockerEncryptDevice = $True
                    bitLockerFixedDrivePolicy = (New-CimInstance -ClassName MSFT_MicrosoftGraphbitLockerFixedDrivePolicy -Property @{
                        RecoveryOptions = (New-CimInstance -ClassName MSFT_MicrosoftGraphbitLockerRecoveryOptions -Property @{
                            RecoveryInformationToStore = "passwordAndKey"
                            HideRecoveryOptions = $True
                            BlockDataRecoveryAgent = $True
                            RecoveryKeyUsage = "blocked"
                            EnableBitLockerAfterRecoveryInformationToStore = $True
                            EnableRecoveryInformationSaveToStore = $True
                            RecoveryPasswordUsage = "blocked"
                        } -ClientOnly)
                        RequireEncryptionForWriteAccess = $True
                        encryptionMethod = "aesCbc128"
                    } -ClientOnly)
                    bitLockerRecoveryPasswordRotation = "notConfigured"
                    bitLockerRemovableDrivePolicy = (New-CimInstance -ClassName MSFT_MicrosoftGraphbitLockerRemovableDrivePolicy -Property @{
                        requireEncryptionForWriteAccess = $True
                        blockCrossOrganizationWriteAccess = $True
                        encryptionMethod = "aesCbc128"
                    } -ClientOnly)
                    bitLockerSystemDrivePolicy = (New-CimInstance -ClassName MSFT_MicrosoftGraphbitLockerSystemDrivePolicy -Property @{
                        prebootRecoveryEnableMessageAndUrl = $True
                        StartupAuthenticationTpmPinUsage = "blocked"
                        encryptionMethod = "aesCbc128"
                        minimumPinLength = 25
                        prebootRecoveryMessage = "FakeStringValue"
                        StartupAuthenticationTpmPinAndKeyUsage = "blocked"
                        StartupAuthenticationRequired = $True
                        RecoveryOptions = (New-CimInstance -ClassName MSFT_MicrosoftGraphbitLockerRecoveryOptions -Property @{
                            RecoveryInformationToStore = "passwordAndKey"
                            HideRecoveryOptions = $True
                            BlockDataRecoveryAgent = $True
                            RecoveryKeyUsage = "blocked"
                            EnableBitLockerAfterRecoveryInformationToStore = $True
                            EnableRecoveryInformationSaveToStore = $True
                            RecoveryPasswordUsage = "blocked"
                        } -ClientOnly)
                        prebootRecoveryUrl = "FakeStringValue"
                        StartupAuthenticationTpmUsage = "blocked"
                        StartupAuthenticationTpmKeyUsage = "blocked"
                        StartupAuthenticationBlockWithoutTpmChip = $True
                    } -ClientOnly)
                    defenderAdditionalGuardedFolders = @("FakeStringValue")
                    defenderAdobeReaderLaunchChildProcess = "userDefined"
                    defenderAdvancedRansomewareProtectionType = "userDefined"
                    defenderAllowBehaviorMonitoring = $True
                    defenderAllowCloudProtection = $True
                    defenderAllowEndUserAccess = $True
                    defenderAllowIntrusionPreventionSystem = $True
                    defenderAllowOnAccessProtection = $True
                    defenderAllowRealTimeMonitoring = $True
                    defenderAllowScanArchiveFiles = $True
                    defenderAllowScanDownloads = $True
                    defenderAllowScanNetworkFiles = $True
                    defenderAllowScanRemovableDrivesDuringFullScan = $True
                    defenderAllowScanScriptsLoadedInInternetExplorer = $True
                    defenderAttackSurfaceReductionExcludedPaths = @("FakeStringValue")
                    defenderBlockEndUserAccess = $True
                    defenderBlockPersistenceThroughWmiType = "userDefined"
                    defenderCheckForSignaturesBeforeRunningScan = $True
                    defenderCloudBlockLevel = "notConfigured"
                    defenderCloudExtendedTimeoutInSeconds = 25
                    defenderDaysBeforeDeletingQuarantinedMalware = 25
                    defenderDetectedMalwareActions = (New-CimInstance -ClassName MSFT_MicrosoftGraphdefenderDetectedMalwareActions -Property @{
                        lowSeverity = "deviceDefault"
                        severeSeverity = "deviceDefault"
                        moderateSeverity = "deviceDefault"
                        highSeverity = "deviceDefault"
                    } -ClientOnly)
                    defenderDisableBehaviorMonitoring = $True
                    defenderDisableCatchupFullScan = $True
                    defenderDisableCatchupQuickScan = $True
                    defenderDisableCloudProtection = $True
                    defenderDisableIntrusionPreventionSystem = $True
                    defenderDisableOnAccessProtection = $True
                    defenderDisableRealTimeMonitoring = $True
                    defenderDisableScanArchiveFiles = $True
                    defenderDisableScanDownloads = $True
                    defenderDisableScanNetworkFiles = $True
                    defenderDisableScanRemovableDrivesDuringFullScan = $True
                    defenderDisableScanScriptsLoadedInInternetExplorer = $True
                    defenderEmailContentExecution = "userDefined"
                    defenderEmailContentExecutionType = "userDefined"
                    defenderEnableLowCpuPriority = $True
                    defenderEnableScanIncomingMail = $True
                    defenderEnableScanMappedNetworkDrivesDuringFullScan = $True
                    defenderExploitProtectionXml = $True
                    defenderExploitProtectionXmlFileName = "FakeStringValue"
                    defenderFileExtensionsToExclude = @("FakeStringValue")
                    defenderFilesAndFoldersToExclude = @("FakeStringValue")
                    defenderGuardedFoldersAllowedAppPaths = @("FakeStringValue")
                    defenderGuardMyFoldersType = "userDefined"
                    defenderNetworkProtectionType = "userDefined"
                    defenderOfficeAppsExecutableContentCreationOrLaunch = "userDefined"
                    defenderOfficeAppsExecutableContentCreationOrLaunchType = "userDefined"
                    defenderOfficeAppsLaunchChildProcess = "userDefined"
                    defenderOfficeAppsLaunchChildProcessType = "userDefined"
                    defenderOfficeAppsOtherProcessInjection = "userDefined"
                    defenderOfficeAppsOtherProcessInjectionType = "userDefined"
                    defenderOfficeCommunicationAppsLaunchChildProcess = "userDefined"
                    defenderOfficeMacroCodeAllowWin32Imports = "userDefined"
                    defenderOfficeMacroCodeAllowWin32ImportsType = "userDefined"
                    defenderPotentiallyUnwantedAppAction = "userDefined"
                    defenderPreventCredentialStealingType = "userDefined"
                    defenderProcessCreation = "userDefined"
                    defenderProcessCreationType = "userDefined"
                    defenderProcessesToExclude = @("FakeStringValue")
                    defenderScanDirection = "monitorAllFiles"
                    defenderScanMaxCpuPercentage = 25
                    defenderScanType = "userDefined"
                    defenderScheduledQuickScanTime = "00:00:00"
                    defenderScheduledScanDay = "userDefined"
                    defenderScheduledScanTime = "00:00:00"
                    defenderScriptDownloadedPayloadExecution = "userDefined"
                    defenderScriptDownloadedPayloadExecutionType = "userDefined"
                    defenderScriptObfuscatedMacroCode = "userDefined"
                    defenderScriptObfuscatedMacroCodeType = "userDefined"
                    defenderSecurityCenterBlockExploitProtectionOverride = $True
                    defenderSecurityCenterDisableAccountUI = $True
                    defenderSecurityCenterDisableAppBrowserUI = $True
                    defenderSecurityCenterDisableClearTpmUI = $True
                    defenderSecurityCenterDisableFamilyUI = $True
                    defenderSecurityCenterDisableHardwareUI = $True
                    defenderSecurityCenterDisableHealthUI = $True
                    defenderSecurityCenterDisableNetworkUI = $True
                    defenderSecurityCenterDisableNotificationAreaUI = $True
                    defenderSecurityCenterDisableRansomwareUI = $True
                    defenderSecurityCenterDisableSecureBootUI = $True
                    defenderSecurityCenterDisableTroubleshootingUI = $True
                    defenderSecurityCenterDisableVirusUI = $True
                    defenderSecurityCenterDisableVulnerableTpmFirmwareUpdateUI = $True
                    defenderSecurityCenterHelpEmail = "FakeStringValue"
                    defenderSecurityCenterHelpPhone = "FakeStringValue"
                    defenderSecurityCenterHelpURL = "FakeStringValue"
                    defenderSecurityCenterITContactDisplay = "notConfigured"
                    defenderSecurityCenterNotificationsFromApp = "notConfigured"
                    defenderSecurityCenterOrganizationDisplayName = "FakeStringValue"
                    defenderSignatureUpdateIntervalInHours = 25
                    defenderSubmitSamplesConsentType = "sendSafeSamplesAutomatically"
                    defenderUntrustedExecutable = "userDefined"
                    defenderUntrustedExecutableType = "userDefined"
                    defenderUntrustedUSBProcess = "userDefined"
                    defenderUntrustedUSBProcessType = "userDefined"
                    description = "FakeStringValue"
                    deviceGuardEnableSecureBootWithDMA = $True
                    deviceGuardEnableVirtualizationBasedSecurity = $True
                    deviceGuardLaunchSystemGuard = "notConfigured"
                    deviceGuardLocalSystemAuthorityCredentialGuardSettings = "notConfigured"
                    deviceGuardSecureBootWithDMA = "notConfigured"
                    displayName = "FakeStringValue"
                    dmaGuardDeviceEnumerationPolicy = "deviceDefault"
                    firewallBlockStatefulFTP = $True
                    firewallCertificateRevocationListCheckMethod = "deviceDefault"
                    firewallIdleTimeoutForSecurityAssociationInSeconds = 25
                    firewallIPSecExemptionsAllowDHCP = $True
                    firewallIPSecExemptionsAllowICMP = $True
                    firewallIPSecExemptionsAllowNeighborDiscovery = $True
                    firewallIPSecExemptionsAllowRouterDiscovery = $True
                    firewallIPSecExemptionsNone = $True
                    firewallMergeKeyingModuleSettings = $True
                    firewallPacketQueueingMethod = "deviceDefault"
                    firewallPreSharedKeyEncodingMethod = "deviceDefault"
                    firewallProfileDomain = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsFirewallNetworkProfile -Property @{
                        policyRulesFromGroupPolicyNotMerged = $True
                        inboundConnectionsRequired = $True
                        securedPacketExemptionAllowed = $True
                        securedPacketExemptionBlocked = $True
                        globalPortRulesFromGroupPolicyMerged = $True
                        stealthModeBlocked = $True
                        outboundConnectionsBlocked = $True
                        inboundConnectionsBlocked = $True
                        authorizedApplicationRulesFromGroupPolicyMerged = $True
                        inboundNotificationsRequired = $True
                        firewallEnabled = "notConfigured"
                        stealthModeRequired = $True
                        incomingTrafficBlocked = $True
                        incomingTrafficRequired = $True
                        unicastResponsesToMulticastBroadcastsBlocked = $True
                        policyRulesFromGroupPolicyMerged = $True
                        unicastResponsesToMulticastBroadcastsRequired = $True
                        connectionSecurityRulesFromGroupPolicyNotMerged = $True
                        globalPortRulesFromGroupPolicyNotMerged = $True
                        outboundConnectionsRequired = $True
                        inboundNotificationsBlocked = $True
                        connectionSecurityRulesFromGroupPolicyMerged = $True
                        authorizedApplicationRulesFromGroupPolicyNotMerged = $True
                    } -ClientOnly)
                    firewallProfilePrivate = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsFirewallNetworkProfile -Property @{
                        policyRulesFromGroupPolicyNotMerged = $True
                        inboundConnectionsRequired = $True
                        securedPacketExemptionAllowed = $True
                        securedPacketExemptionBlocked = $True
                        globalPortRulesFromGroupPolicyMerged = $True
                        stealthModeBlocked = $True
                        outboundConnectionsBlocked = $True
                        inboundConnectionsBlocked = $True
                        authorizedApplicationRulesFromGroupPolicyMerged = $True
                        inboundNotificationsRequired = $True
                        firewallEnabled = "notConfigured"
                        stealthModeRequired = $True
                        incomingTrafficBlocked = $True
                        incomingTrafficRequired = $True
                        unicastResponsesToMulticastBroadcastsBlocked = $True
                        policyRulesFromGroupPolicyMerged = $True
                        unicastResponsesToMulticastBroadcastsRequired = $True
                        connectionSecurityRulesFromGroupPolicyNotMerged = $True
                        globalPortRulesFromGroupPolicyNotMerged = $True
                        outboundConnectionsRequired = $True
                        inboundNotificationsBlocked = $True
                        connectionSecurityRulesFromGroupPolicyMerged = $True
                        authorizedApplicationRulesFromGroupPolicyNotMerged = $True
                    } -ClientOnly)
                    firewallProfilePublic = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsFirewallNetworkProfile -Property @{
                        policyRulesFromGroupPolicyNotMerged = $True
                        inboundConnectionsRequired = $True
                        securedPacketExemptionAllowed = $True
                        securedPacketExemptionBlocked = $True
                        globalPortRulesFromGroupPolicyMerged = $True
                        stealthModeBlocked = $True
                        outboundConnectionsBlocked = $True
                        inboundConnectionsBlocked = $True
                        authorizedApplicationRulesFromGroupPolicyMerged = $True
                        inboundNotificationsRequired = $True
                        firewallEnabled = "notConfigured"
                        stealthModeRequired = $True
                        incomingTrafficBlocked = $True
                        incomingTrafficRequired = $True
                        unicastResponsesToMulticastBroadcastsBlocked = $True
                        policyRulesFromGroupPolicyMerged = $True
                        unicastResponsesToMulticastBroadcastsRequired = $True
                        connectionSecurityRulesFromGroupPolicyNotMerged = $True
                        globalPortRulesFromGroupPolicyNotMerged = $True
                        outboundConnectionsRequired = $True
                        inboundNotificationsBlocked = $True
                        connectionSecurityRulesFromGroupPolicyMerged = $True
                        authorizedApplicationRulesFromGroupPolicyNotMerged = $True
                    } -ClientOnly)
                    firewallRules = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsFirewallRule -Property @{
                            localAddressRanges = @("FakeStringValue")
                            action = "notConfigured"
                            description = "FakeStringValue"
                            interfaceTypes = "notConfigured"
                            remotePortRanges = @("FakeStringValue")
                            displayName = "FakeStringValue"
                            filePath = "FakeStringValue"
                            localUserAuthorizations = "FakeStringValue"
                            protocol = 25
                            trafficDirection = "notConfigured"
                            remoteAddressRanges = @("FakeStringValue")
                            packageFamilyName = "FakeStringValue"
                            serviceName = "FakeStringValue"
                            localPortRanges = @("FakeStringValue")
                            profileTypes = "notConfigured"
                            edgeTraversal = "notConfigured"
                        } -ClientOnly)
                    )
                    id = "FakeStringValue"
                    lanManagerAuthenticationLevel = "lmAndNltm"
                    lanManagerWorkstationDisableInsecureGuestLogons = $True
                    localSecurityOptionsAdministratorAccountName = "FakeStringValue"
                    localSecurityOptionsAdministratorElevationPromptBehavior = "notConfigured"
                    localSecurityOptionsAllowAnonymousEnumerationOfSAMAccountsAndShares = $True
                    localSecurityOptionsAllowPKU2UAuthenticationRequests = $True
                    localSecurityOptionsAllowRemoteCallsToSecurityAccountsManager = "FakeStringValue"
                    localSecurityOptionsAllowRemoteCallsToSecurityAccountsManagerHelperBool = $True
                    localSecurityOptionsAllowSystemToBeShutDownWithoutHavingToLogOn = $True
                    localSecurityOptionsAllowUIAccessApplicationElevation = $True
                    localSecurityOptionsAllowUIAccessApplicationsForSecureLocations = $True
                    localSecurityOptionsAllowUndockWithoutHavingToLogon = $True
                    localSecurityOptionsBlockMicrosoftAccounts = $True
                    localSecurityOptionsBlockRemoteLogonWithBlankPassword = $True
                    localSecurityOptionsBlockRemoteOpticalDriveAccess = $True
                    localSecurityOptionsBlockUsersInstallingPrinterDrivers = $True
                    localSecurityOptionsClearVirtualMemoryPageFile = $True
                    localSecurityOptionsClientDigitallySignCommunicationsAlways = $True
                    localSecurityOptionsClientSendUnencryptedPasswordToThirdPartySMBServers = $True
                    localSecurityOptionsDetectApplicationInstallationsAndPromptForElevation = $True
                    localSecurityOptionsDisableAdministratorAccount = $True
                    localSecurityOptionsDisableClientDigitallySignCommunicationsIfServerAgrees = $True
                    localSecurityOptionsDisableGuestAccount = $True
                    localSecurityOptionsDisableServerDigitallySignCommunicationsAlways = $True
                    localSecurityOptionsDisableServerDigitallySignCommunicationsIfClientAgrees = $True
                    localSecurityOptionsDoNotAllowAnonymousEnumerationOfSAMAccounts = $True
                    localSecurityOptionsDoNotRequireCtrlAltDel = $True
                    localSecurityOptionsDoNotStoreLANManagerHashValueOnNextPasswordChange = $True
                    localSecurityOptionsFormatAndEjectOfRemovableMediaAllowedUser = "notConfigured"
                    localSecurityOptionsGuestAccountName = "FakeStringValue"
                    localSecurityOptionsHideLastSignedInUser = $True
                    localSecurityOptionsHideUsernameAtSignIn = $True
                    localSecurityOptionsInformationDisplayedOnLockScreen = "notConfigured"
                    localSecurityOptionsInformationShownOnLockScreen = "notConfigured"
                    localSecurityOptionsLogOnMessageText = "FakeStringValue"
                    localSecurityOptionsLogOnMessageTitle = "FakeStringValue"
                    localSecurityOptionsMachineInactivityLimit = 25
                    localSecurityOptionsMachineInactivityLimitInMinutes = 25
                    localSecurityOptionsMinimumSessionSecurityForNtlmSspBasedClients = "none"
                    localSecurityOptionsMinimumSessionSecurityForNtlmSspBasedServers = "none"
                    localSecurityOptionsOnlyElevateSignedExecutables = $True
                    localSecurityOptionsRestrictAnonymousAccessToNamedPipesAndShares = $True
                    localSecurityOptionsSmartCardRemovalBehavior = "noAction"
                    localSecurityOptionsStandardUserElevationPromptBehavior = "notConfigured"
                    localSecurityOptionsSwitchToSecureDesktopWhenPromptingForElevation = $True
                    localSecurityOptionsUseAdminApprovalMode = $True
                    localSecurityOptionsUseAdminApprovalModeForAdministrators = $True
                    localSecurityOptionsVirtualizeFileAndRegistryWriteFailuresToPerUserLocations = $True
                    smartScreenBlockOverrideForFiles = $True
                    smartScreenEnableInShell = $True
                    supportsScopeTags = $True
                    userRightsAccessCredentialManagerAsTrustedCaller = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsActAsPartOfTheOperatingSystem = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsAllowAccessFromNetwork = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsBackupData = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsBlockAccessFromNetwork = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsChangeSystemTime = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsCreateGlobalObjects = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsCreatePageFile = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsCreatePermanentSharedObjects = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsCreateSymbolicLinks = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsCreateToken = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsDebugPrograms = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsDelegation = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsDenyLocalLogOn = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsGenerateSecurityAudits = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsImpersonateClient = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsIncreaseSchedulingPriority = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsLoadUnloadDrivers = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsLocalLogOn = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsLockMemory = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsManageAuditingAndSecurityLogs = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsManageVolumes = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsModifyFirmwareEnvironment = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsModifyObjectLabels = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsProfileSingleProcess = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsRemoteDesktopServicesLogOn = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsRemoteShutdown = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsRestoreData = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsTakeOwnership = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    windowsDefenderTamperProtection = "notConfigured"
                    xboxServicesAccessoryManagementServiceStartupMode = "manual"
                    xboxServicesEnableXboxGameSaveTask = $True
                    xboxServicesLiveAuthManagerServiceStartupMode = "manual"
                    xboxServicesLiveGameSaveServiceStartupMode = "manual"
                    xboxServicesLiveNetworkingServiceStartupMode = "manual"
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            localSecurityOptionsClearVirtualMemoryPageFile = $True
                            defenderSecurityCenterDisableHardwareUI = $True
                            applicationGuardAllowPrintToNetworkPrinters = $True
                            defenderFilesAndFoldersToExclude = @("FakeStringValue")
                            defenderAllowScanArchiveFiles = $True
                            firewallIPSecExemptionsNone = $True
                            bitLockerAllowStandardUserEncryption = $True
                            localSecurityOptionsAllowRemoteCallsToSecurityAccountsManager = "FakeStringValue"
                            defenderScheduledScanDay = "userDefined"
                            firewallPacketQueueingMethod = "deviceDefault"
                            defenderUntrustedUSBProcessType = "userDefined"
                            defenderNetworkProtectionType = "userDefined"
                            defenderProcessCreation = "userDefined"
                            applicationGuardEnabledOptions = "notConfigured"
                            defenderOfficeAppsLaunchChildProcess = "userDefined"
                            defenderAllowRealTimeMonitoring = $True
                            firewallIPSecExemptionsAllowNeighborDiscovery = $True
                            defenderUntrustedExecutable = "userDefined"
                            defenderGuardMyFoldersType = "userDefined"
                            localSecurityOptionsInformationDisplayedOnLockScreen = "notConfigured"
                            defenderScheduledQuickScanTime = "00:00:00"
                            localSecurityOptionsUseAdminApprovalMode = $True
                            applicationGuardAllowCameraMicrophoneRedirection = $True
                            applicationGuardAllowPrintToXPS = $True
                            deviceGuardLaunchSystemGuard = "notConfigured"
                            defenderScanDirection = "monitorAllFiles"
                            userRightsIncreaseSchedulingPriority = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            deviceGuardEnableVirtualizationBasedSecurity = $True
                            defenderBlockEndUserAccess = $True
                            firewallIPSecExemptionsAllowRouterDiscovery = $True
                            xboxServicesLiveGameSaveServiceStartupMode = "manual"
                            bitLockerFixedDrivePolicy = @{
                                RecoveryOptions = @{
                                    RecoveryInformationToStore = "passwordAndKey"
                                    HideRecoveryOptions = $True
                                    BlockDataRecoveryAgent = $True
                                    RecoveryKeyUsage = "blocked"
                                    EnableBitLockerAfterRecoveryInformationToStore = $True
                                    EnableRecoveryInformationSaveToStore = $True
                                    RecoveryPasswordUsage = "blocked"
                                }
                                RequireEncryptionForWriteAccess = $True
                                encryptionMethod = "aesCbc128"
                            }
                            userRightsCreateSymbolicLinks = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            applicationGuardBlockFileTransfer = "notConfigured"
                            defenderCheckForSignaturesBeforeRunningScan = $True
                            userRightsRemoteShutdown = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            firewallRules = @(
                                @{
                                    localAddressRanges = @("FakeStringValue")
                                    action = "notConfigured"
                                    description = "FakeStringValue"
                                    interfaceTypes = "notConfigured"
                                    remotePortRanges = @("FakeStringValue")
                                    displayName = "FakeStringValue"
                                    filePath = "FakeStringValue"
                                    localUserAuthorizations = "FakeStringValue"
                                    protocol = 25
                                    trafficDirection = "notConfigured"
                                    remoteAddressRanges = @("FakeStringValue")
                                    packageFamilyName = "FakeStringValue"
                                    serviceName = "FakeStringValue"
                                    localPortRanges = @("FakeStringValue")
                                    profileTypes = "notConfigured"
                                    edgeTraversal = "notConfigured"
                                }
                            )
                            defenderSignatureUpdateIntervalInHours = 25
                            defenderEnableLowCpuPriority = $True
                            localSecurityOptionsAllowAnonymousEnumerationOfSAMAccountsAndShares = $True
                            defenderFileExtensionsToExclude = @("FakeStringValue")
                            localSecurityOptionsHideLastSignedInUser = $True
                            userRightsBlockAccessFromNetwork = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsMinimumSessionSecurityForNtlmSspBasedServers = "none"
                            xboxServicesLiveAuthManagerServiceStartupMode = "manual"
                            localSecurityOptionsMachineInactivityLimitInMinutes = 25
                            localSecurityOptionsClientDigitallySignCommunicationsAlways = $True
                            defenderSecurityCenterDisableNetworkUI = $True
                            userRightsModifyObjectLabels = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            deviceGuardLocalSystemAuthorityCredentialGuardSettings = "notConfigured"
                            firewallIdleTimeoutForSecurityAssociationInSeconds = 25
                            defenderSecurityCenterHelpURL = "FakeStringValue"
                            localSecurityOptionsDisableServerDigitallySignCommunicationsAlways = $True
                            localSecurityOptionsAllowRemoteCallsToSecurityAccountsManagerHelperBool = $True
                            userRightsChangeSystemTime = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsAllowUndockWithoutHavingToLogon = $True
                            defenderEnableScanMappedNetworkDrivesDuringFullScan = $True
                            defenderUntrustedUSBProcess = "userDefined"
                            localSecurityOptionsHideUsernameAtSignIn = $True
                            defenderAllowScanDownloads = $True
                            localSecurityOptionsDisableAdministratorAccount = $True
                            defenderSecurityCenterDisableHealthUI = $True
                            userRightsCreateGlobalObjects = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsRestrictAnonymousAccessToNamedPipesAndShares = $True
                            localSecurityOptionsMachineInactivityLimit = 25
                            firewallCertificateRevocationListCheckMethod = "deviceDefault"
                            defenderSecurityCenterDisableFamilyUI = $True
                            defenderAllowCloudProtection = $True
                            bitLockerEnableStorageCardEncryptionOnMobile = $True
                            applicationGuardEnabled = $True
                            defenderOfficeAppsOtherProcessInjection = "userDefined"
                            userRightsImpersonateClient = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            '@odata.type' = "#microsoft.graph.windows10EndpointProtectionConfiguration"
                            localSecurityOptionsUseAdminApprovalModeForAdministrators = $True
                            lanManagerWorkstationDisableInsecureGuestLogons = $True
                            defenderAdvancedRansomewareProtectionType = "userDefined"
                            defenderUntrustedExecutableType = "userDefined"
                            defenderDisableScanArchiveFiles = $True
                            lanManagerAuthenticationLevel = "lmAndNltm"
                            userRightsActAsPartOfTheOperatingSystem = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderPreventCredentialStealingType = "userDefined"
                            localSecurityOptionsAllowUIAccessApplicationsForSecureLocations = $True
                            deviceGuardEnableSecureBootWithDMA = $True
                            localSecurityOptionsDisableClientDigitallySignCommunicationsIfServerAgrees = $True
                            defenderScriptObfuscatedMacroCode = "userDefined"
                            defenderDaysBeforeDeletingQuarantinedMalware = 25
                            defenderAllowScanRemovableDrivesDuringFullScan = $True
                            localSecurityOptionsDisableServerDigitallySignCommunicationsIfClientAgrees = $True
                            firewallProfilePrivate = @{
                                policyRulesFromGroupPolicyNotMerged = $True
                                inboundConnectionsRequired = $True
                                securedPacketExemptionAllowed = $True
                                securedPacketExemptionBlocked = $True
                                globalPortRulesFromGroupPolicyMerged = $True
                                stealthModeBlocked = $True
                                outboundConnectionsBlocked = $True
                                inboundConnectionsBlocked = $True
                                authorizedApplicationRulesFromGroupPolicyMerged = $True
                                inboundNotificationsRequired = $True
                                firewallEnabled = "notConfigured"
                                stealthModeRequired = $True
                                incomingTrafficBlocked = $True
                                incomingTrafficRequired = $True
                                unicastResponsesToMulticastBroadcastsBlocked = $True
                                policyRulesFromGroupPolicyMerged = $True
                                unicastResponsesToMulticastBroadcastsRequired = $True
                                connectionSecurityRulesFromGroupPolicyNotMerged = $True
                                globalPortRulesFromGroupPolicyNotMerged = $True
                                outboundConnectionsRequired = $True
                                inboundNotificationsBlocked = $True
                                connectionSecurityRulesFromGroupPolicyMerged = $True
                                authorizedApplicationRulesFromGroupPolicyNotMerged = $True
                            }
                            defenderSecurityCenterDisableAppBrowserUI = $True
                            localSecurityOptionsInformationShownOnLockScreen = "notConfigured"
                            defenderOfficeAppsLaunchChildProcessType = "userDefined"
                            deviceGuardSecureBootWithDMA = "notConfigured"
                            applicationGuardAllowPrintToPDF = $True
                            userRightsCreateToken = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderExploitProtectionXml = $True
                            userRightsRemoteDesktopServicesLogOn = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsBlockRemoteLogonWithBlankPassword = $True
                            userRightsBackupData = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            userRightsDenyLocalLogOn = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsOnlyElevateSignedExecutables = $True
                            applicationGuardAllowVirtualGPU = $True
                            defenderScanType = "userDefined"
                            bitLockerSystemDrivePolicy = @{
                                prebootRecoveryEnableMessageAndUrl = $True
                                StartupAuthenticationTpmPinUsage = "blocked"
                                encryptionMethod = "aesCbc128"
                                minimumPinLength = 25
                                prebootRecoveryMessage = "FakeStringValue"
                                StartupAuthenticationTpmPinAndKeyUsage = "blocked"
                                StartupAuthenticationRequired = $True
                                RecoveryOptions = @{
                                    RecoveryInformationToStore = "passwordAndKey"
                                    HideRecoveryOptions = $True
                                    BlockDataRecoveryAgent = $True
                                    RecoveryKeyUsage = "blocked"
                                    EnableBitLockerAfterRecoveryInformationToStore = $True
                                    EnableRecoveryInformationSaveToStore = $True
                                    RecoveryPasswordUsage = "blocked"
                                }
                                prebootRecoveryUrl = "FakeStringValue"
                                StartupAuthenticationTpmUsage = "blocked"
                                StartupAuthenticationTpmKeyUsage = "blocked"
                                StartupAuthenticationBlockWithoutTpmChip = $True
                            }
                            defenderAllowBehaviorMonitoring = $True
                            defenderAllowIntrusionPreventionSystem = $True
                            localSecurityOptionsDoNotStoreLANManagerHashValueOnNextPasswordChange = $True
                            defenderSecurityCenterHelpEmail = "FakeStringValue"
                            defenderDisableBehaviorMonitoring = $True
                            localSecurityOptionsVirtualizeFileAndRegistryWriteFailuresToPerUserLocations = $True
                            applicationGuardBlockClipboardSharing = "notConfigured"
                            defenderEmailContentExecution = "userDefined"
                            localSecurityOptionsBlockRemoteOpticalDriveAccess = $True
                            firewallProfilePublic = @{
                                policyRulesFromGroupPolicyNotMerged = $True
                                inboundConnectionsRequired = $True
                                securedPacketExemptionAllowed = $True
                                securedPacketExemptionBlocked = $True
                                globalPortRulesFromGroupPolicyMerged = $True
                                stealthModeBlocked = $True
                                outboundConnectionsBlocked = $True
                                inboundConnectionsBlocked = $True
                                authorizedApplicationRulesFromGroupPolicyMerged = $True
                                inboundNotificationsRequired = $True
                                firewallEnabled = "notConfigured"
                                stealthModeRequired = $True
                                incomingTrafficBlocked = $True
                                incomingTrafficRequired = $True
                                unicastResponsesToMulticastBroadcastsBlocked = $True
                                policyRulesFromGroupPolicyMerged = $True
                                unicastResponsesToMulticastBroadcastsRequired = $True
                                connectionSecurityRulesFromGroupPolicyNotMerged = $True
                                globalPortRulesFromGroupPolicyNotMerged = $True
                                outboundConnectionsRequired = $True
                                inboundNotificationsBlocked = $True
                                connectionSecurityRulesFromGroupPolicyMerged = $True
                                authorizedApplicationRulesFromGroupPolicyNotMerged = $True
                            }
                            defenderScriptDownloadedPayloadExecutionType = "userDefined"
                            xboxServicesAccessoryManagementServiceStartupMode = "manual"
                            xboxServicesEnableXboxGameSaveTask = $True
                            bitLockerEncryptDevice = $True
                            localSecurityOptionsBlockMicrosoftAccounts = $True
                            bitLockerRemovableDrivePolicy = @{
                                requireEncryptionForWriteAccess = $True
                                blockCrossOrganizationWriteAccess = $True
                                encryptionMethod = "aesCbc128"
                            }
                            defenderSecurityCenterBlockExploitProtectionOverride = $True
                            localSecurityOptionsLogOnMessageText = "FakeStringValue"
                            applicationGuardCertificateThumbprints = @("FakeStringValue")
                            defenderCloudBlockLevel = "notConfigured"
                            defenderProcessCreationType = "userDefined"
                            defenderDisableScanDownloads = $True
                            defenderOfficeCommunicationAppsLaunchChildProcess = "userDefined"
                            localSecurityOptionsClientSendUnencryptedPasswordToThirdPartySMBServers = $True
                            userRightsAllowAccessFromNetwork = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            applicationGuardForceAuditing = $True
                            defenderDisableRealTimeMonitoring = $True
                            defenderSecurityCenterNotificationsFromApp = "notConfigured"
                            localSecurityOptionsAdministratorAccountName = "FakeStringValue"
                            windowsDefenderTamperProtection = "notConfigured"
                            defenderSecurityCenterDisableAccountUI = $True
                            localSecurityOptionsSwitchToSecureDesktopWhenPromptingForElevation = $True
                            defenderEmailContentExecutionType = "userDefined"
                            defenderAllowScanNetworkFiles = $True
                            defenderSecurityCenterDisableNotificationAreaUI = $True
                            userRightsProfileSingleProcess = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsSmartCardRemovalBehavior = "noAction"
                            defenderDisableCloudProtection = $True
                            userRightsManageVolumes = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            smartScreenEnableInShell = $True
                            applicationGuardBlockNonEnterpriseContent = $True
                            defenderAdditionalGuardedFolders = @("FakeStringValue")
                            localSecurityOptionsDoNotAllowAnonymousEnumerationOfSAMAccounts = $True
                            userRightsRestoreData = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsMinimumSessionSecurityForNtlmSspBasedClients = "none"
                            defenderDisableOnAccessProtection = $True
                            bitLockerRecoveryPasswordRotation = "notConfigured"
                            firewallPreSharedKeyEncodingMethod = "deviceDefault"
                            userRightsDelegation = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            userRightsDebugPrograms = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderSecurityCenterDisableVulnerableTpmFirmwareUpdateUI = $True
                            defenderSecurityCenterOrganizationDisplayName = "FakeStringValue"
                            localSecurityOptionsFormatAndEjectOfRemovableMediaAllowedUser = "notConfigured"
                            userRightsLockMemory = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            appLockerApplicationControl = "notConfigured"
                            defenderBlockPersistenceThroughWmiType = "userDefined"
                            defenderDisableScanNetworkFiles = $True
                            defenderDisableCatchupQuickScan = $True
                            localSecurityOptionsLogOnMessageTitle = "FakeStringValue"
                            localSecurityOptionsStandardUserElevationPromptBehavior = "notConfigured"
                            userRightsGenerateSecurityAudits = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderSecurityCenterDisableClearTpmUI = $True
                            defenderEnableScanIncomingMail = $True
                            defenderSecurityCenterHelpPhone = "FakeStringValue"
                            localSecurityOptionsDoNotRequireCtrlAltDel = $True
                            userRightsTakeOwnership = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            userRightsLocalLogOn = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            applicationGuardAllowPersistence = $True
                            defenderCloudExtendedTimeoutInSeconds = 25
                            firewallIPSecExemptionsAllowICMP = $True
                            defenderAllowEndUserAccess = $True
                            defenderScriptDownloadedPayloadExecution = "userDefined"
                            defenderExploitProtectionXmlFileName = "FakeStringValue"
                            defenderScriptObfuscatedMacroCodeType = "userDefined"
                            defenderDisableScanRemovableDrivesDuringFullScan = $True
                            localSecurityOptionsAllowSystemToBeShutDownWithoutHavingToLogOn = $True
                            defenderOfficeMacroCodeAllowWin32ImportsType = "userDefined"
                            firewallIPSecExemptionsAllowDHCP = $True
                            firewallProfileDomain = @{
                                policyRulesFromGroupPolicyNotMerged = $True
                                inboundConnectionsRequired = $True
                                securedPacketExemptionAllowed = $True
                                securedPacketExemptionBlocked = $True
                                globalPortRulesFromGroupPolicyMerged = $True
                                stealthModeBlocked = $True
                                outboundConnectionsBlocked = $True
                                inboundConnectionsBlocked = $True
                                authorizedApplicationRulesFromGroupPolicyMerged = $True
                                inboundNotificationsRequired = $True
                                firewallEnabled = "notConfigured"
                                stealthModeRequired = $True
                                incomingTrafficBlocked = $True
                                incomingTrafficRequired = $True
                                unicastResponsesToMulticastBroadcastsBlocked = $True
                                policyRulesFromGroupPolicyMerged = $True
                                unicastResponsesToMulticastBroadcastsRequired = $True
                                connectionSecurityRulesFromGroupPolicyNotMerged = $True
                                globalPortRulesFromGroupPolicyNotMerged = $True
                                outboundConnectionsRequired = $True
                                inboundNotificationsBlocked = $True
                                connectionSecurityRulesFromGroupPolicyMerged = $True
                                authorizedApplicationRulesFromGroupPolicyNotMerged = $True
                            }
                            localSecurityOptionsAllowPKU2UAuthenticationRequests = $True
                            defenderSecurityCenterDisableTroubleshootingUI = $True
                            defenderPotentiallyUnwantedAppAction = "userDefined"
                            userRightsModifyFirmwareEnvironment = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderOfficeAppsExecutableContentCreationOrLaunch = "userDefined"
                            defenderOfficeAppsExecutableContentCreationOrLaunchType = "userDefined"
                            defenderSubmitSamplesConsentType = "sendSafeSamplesAutomatically"
                            defenderAdobeReaderLaunchChildProcess = "userDefined"
                            localSecurityOptionsDetectApplicationInstallationsAndPromptForElevation = $True
                            defenderDisableIntrusionPreventionSystem = $True
                            defenderDisableCatchupFullScan = $True
                            bitLockerDisableWarningForOtherDiskEncryption = $True
                            xboxServicesLiveNetworkingServiceStartupMode = "manual"
                            firewallBlockStatefulFTP = $True
                            firewallMergeKeyingModuleSettings = $True
                            userRightsManageAuditingAndSecurityLogs = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            userRightsCreatePermanentSharedObjects = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsBlockUsersInstallingPrinterDrivers = $True
                            smartScreenBlockOverrideForFiles = $True
                            userRightsCreatePageFile = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderAllowOnAccessProtection = $True
                            dmaGuardDeviceEnumerationPolicy = "deviceDefault"
                            defenderOfficeAppsOtherProcessInjectionType = "userDefined"
                            localSecurityOptionsGuestAccountName = "FakeStringValue"
                            defenderDetectedMalwareActions = @{
                                lowSeverity = "deviceDefault"
                                severeSeverity = "deviceDefault"
                                moderateSeverity = "deviceDefault"
                                highSeverity = "deviceDefault"
                            }
                            defenderProcessesToExclude = @("FakeStringValue")
                            defenderScheduledScanTime = "00:00:00"
                            defenderSecurityCenterDisableSecureBootUI = $True
                            applicationGuardAllowFileSaveOnHost = $True
                            localSecurityOptionsDisableGuestAccount = $True
                            defenderSecurityCenterDisableRansomwareUI = $True
                            defenderGuardedFoldersAllowedAppPaths = @("FakeStringValue")
                            defenderOfficeMacroCodeAllowWin32Imports = "userDefined"
                            applicationGuardAllowPrintToLocalPrinters = $True
                            defenderSecurityCenterITContactDisplay = "notConfigured"
                            defenderAttackSurfaceReductionExcludedPaths = @("FakeStringValue")
                            defenderAllowScanScriptsLoadedInInternetExplorer = $True
                            defenderSecurityCenterDisableVirusUI = $True
                            userRightsAccessCredentialManagerAsTrustedCaller = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsAllowUIAccessApplicationElevation = $True
                            defenderDisableScanScriptsLoadedInInternetExplorer = $True
                            localSecurityOptionsAdministratorElevationPromptBehavior = "notConfigured"
                            userRightsLoadUnloadDrivers = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderScanMaxCpuPercentage = 25
                        }
                        description = "FakeStringValue"
                        displayName = "FakeStringValue"
                        id = "FakeStringValue"
                        supportsScopeTags = $True

                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The IntuneDeviceConfigurationEndpointProtectionPolicyWindows10 exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    ApplicationGuardAllowCameraMicrophoneRedirection = $True
                    ApplicationGuardAllowFileSaveOnHost = $True
                    ApplicationGuardAllowPersistence = $True
                    ApplicationGuardAllowPrintToLocalPrinters = $True
                    ApplicationGuardAllowPrintToNetworkPrinters = $True
                    ApplicationGuardAllowPrintToPDF = $True
                    ApplicationGuardAllowPrintToXPS = $True
                    ApplicationGuardAllowVirtualGPU = $True
                    ApplicationGuardBlockClipboardSharing = "notConfigured"
                    ApplicationGuardBlockFileTransfer = "notConfigured"
                    ApplicationGuardBlockNonEnterpriseContent = $True
                    ApplicationGuardCertificateThumbprints = @("FakeStringValue")
                    ApplicationGuardEnabled = $True
                    ApplicationGuardEnabledOptions = "notConfigured"
                    ApplicationGuardForceAuditing = $True
                    AppLockerApplicationControl = "notConfigured"
                    BitLockerAllowStandardUserEncryption = $True
                    BitLockerDisableWarningForOtherDiskEncryption = $True
                    BitLockerEnableStorageCardEncryptionOnMobile = $True
                    BitLockerEncryptDevice = $True
                    bitLockerFixedDrivePolicy = (New-CimInstance -ClassName MSFT_MicrosoftGraphbitLockerFixedDrivePolicy -Property @{
                        RecoveryOptions = (New-CimInstance -ClassName MSFT_MicrosoftGraphbitLockerRecoveryOptions -Property @{
                            RecoveryInformationToStore = "passwordAndKey"
                            HideRecoveryOptions = $True
                            BlockDataRecoveryAgent = $True
                            RecoveryKeyUsage = "blocked"
                            EnableBitLockerAfterRecoveryInformationToStore = $True
                            EnableRecoveryInformationSaveToStore = $True
                            RecoveryPasswordUsage = "blocked"
                        } -ClientOnly)
                        RequireEncryptionForWriteAccess = $True
                        encryptionMethod = "aesCbc128"
                    } -ClientOnly)
                    bitLockerRecoveryPasswordRotation = "notConfigured"
                    bitLockerRemovableDrivePolicy = (New-CimInstance -ClassName MSFT_MicrosoftGraphbitLockerRemovableDrivePolicy -Property @{
                        requireEncryptionForWriteAccess = $True
                        blockCrossOrganizationWriteAccess = $True
                        encryptionMethod = "aesCbc128"
                    } -ClientOnly)
                    bitLockerSystemDrivePolicy = (New-CimInstance -ClassName MSFT_MicrosoftGraphbitLockerSystemDrivePolicy -Property @{
                        prebootRecoveryEnableMessageAndUrl = $True
                        StartupAuthenticationTpmPinUsage = "blocked"
                        encryptionMethod = "aesCbc128"
                        minimumPinLength = 25
                        prebootRecoveryMessage = "FakeStringValue"
                        StartupAuthenticationTpmPinAndKeyUsage = "blocked"
                        StartupAuthenticationRequired = $True
                        RecoveryOptions = (New-CimInstance -ClassName MSFT_MicrosoftGraphbitLockerRecoveryOptions -Property @{
                            RecoveryInformationToStore = "passwordAndKey"
                            HideRecoveryOptions = $True
                            BlockDataRecoveryAgent = $True
                            RecoveryKeyUsage = "blocked"
                            EnableBitLockerAfterRecoveryInformationToStore = $True
                            EnableRecoveryInformationSaveToStore = $True
                            RecoveryPasswordUsage = "blocked"
                        } -ClientOnly)
                        prebootRecoveryUrl = "FakeStringValue"
                        StartupAuthenticationTpmUsage = "blocked"
                        StartupAuthenticationTpmKeyUsage = "blocked"
                        StartupAuthenticationBlockWithoutTpmChip = $True
                    } -ClientOnly)
                    defenderAdditionalGuardedFolders = @("FakeStringValue")
                    defenderAdobeReaderLaunchChildProcess = "userDefined"
                    defenderAdvancedRansomewareProtectionType = "userDefined"
                    defenderAllowBehaviorMonitoring = $True
                    defenderAllowCloudProtection = $True
                    defenderAllowEndUserAccess = $True
                    defenderAllowIntrusionPreventionSystem = $True
                    defenderAllowOnAccessProtection = $True
                    defenderAllowRealTimeMonitoring = $True
                    defenderAllowScanArchiveFiles = $True
                    defenderAllowScanDownloads = $True
                    defenderAllowScanNetworkFiles = $True
                    defenderAllowScanRemovableDrivesDuringFullScan = $True
                    defenderAllowScanScriptsLoadedInInternetExplorer = $True
                    defenderAttackSurfaceReductionExcludedPaths = @("FakeStringValue")
                    defenderBlockEndUserAccess = $True
                    defenderBlockPersistenceThroughWmiType = "userDefined"
                    defenderCheckForSignaturesBeforeRunningScan = $True
                    defenderCloudBlockLevel = "notConfigured"
                    defenderCloudExtendedTimeoutInSeconds = 25
                    defenderDaysBeforeDeletingQuarantinedMalware = 25
                    defenderDetectedMalwareActions = (New-CimInstance -ClassName MSFT_MicrosoftGraphdefenderDetectedMalwareActions -Property @{
                        lowSeverity = "deviceDefault"
                        severeSeverity = "deviceDefault"
                        moderateSeverity = "deviceDefault"
                        highSeverity = "deviceDefault"
                    } -ClientOnly)
                    defenderDisableBehaviorMonitoring = $True
                    defenderDisableCatchupFullScan = $True
                    defenderDisableCatchupQuickScan = $True
                    defenderDisableCloudProtection = $True
                    defenderDisableIntrusionPreventionSystem = $True
                    defenderDisableOnAccessProtection = $True
                    defenderDisableRealTimeMonitoring = $True
                    defenderDisableScanArchiveFiles = $True
                    defenderDisableScanDownloads = $True
                    defenderDisableScanNetworkFiles = $True
                    defenderDisableScanRemovableDrivesDuringFullScan = $True
                    defenderDisableScanScriptsLoadedInInternetExplorer = $True
                    defenderEmailContentExecution = "userDefined"
                    defenderEmailContentExecutionType = "userDefined"
                    defenderEnableLowCpuPriority = $True
                    defenderEnableScanIncomingMail = $True
                    defenderEnableScanMappedNetworkDrivesDuringFullScan = $True
                    defenderExploitProtectionXml = $True
                    defenderExploitProtectionXmlFileName = "FakeStringValue"
                    defenderFileExtensionsToExclude = @("FakeStringValue")
                    defenderFilesAndFoldersToExclude = @("FakeStringValue")
                    defenderGuardedFoldersAllowedAppPaths = @("FakeStringValue")
                    defenderGuardMyFoldersType = "userDefined"
                    defenderNetworkProtectionType = "userDefined"
                    defenderOfficeAppsExecutableContentCreationOrLaunch = "userDefined"
                    defenderOfficeAppsExecutableContentCreationOrLaunchType = "userDefined"
                    defenderOfficeAppsLaunchChildProcess = "userDefined"
                    defenderOfficeAppsLaunchChildProcessType = "userDefined"
                    defenderOfficeAppsOtherProcessInjection = "userDefined"
                    defenderOfficeAppsOtherProcessInjectionType = "userDefined"
                    defenderOfficeCommunicationAppsLaunchChildProcess = "userDefined"
                    defenderOfficeMacroCodeAllowWin32Imports = "userDefined"
                    defenderOfficeMacroCodeAllowWin32ImportsType = "userDefined"
                    defenderPotentiallyUnwantedAppAction = "userDefined"
                    defenderPreventCredentialStealingType = "userDefined"
                    defenderProcessCreation = "userDefined"
                    defenderProcessCreationType = "userDefined"
                    defenderProcessesToExclude = @("FakeStringValue")
                    defenderScanDirection = "monitorAllFiles"
                    defenderScanMaxCpuPercentage = 25
                    defenderScanType = "userDefined"
                    defenderScheduledQuickScanTime = "00:00:00"
                    defenderScheduledScanDay = "userDefined"
                    defenderScheduledScanTime = "00:00:00"
                    defenderScriptDownloadedPayloadExecution = "userDefined"
                    defenderScriptDownloadedPayloadExecutionType = "userDefined"
                    defenderScriptObfuscatedMacroCode = "userDefined"
                    defenderScriptObfuscatedMacroCodeType = "userDefined"
                    defenderSecurityCenterBlockExploitProtectionOverride = $True
                    defenderSecurityCenterDisableAccountUI = $True
                    defenderSecurityCenterDisableAppBrowserUI = $True
                    defenderSecurityCenterDisableClearTpmUI = $True
                    defenderSecurityCenterDisableFamilyUI = $True
                    defenderSecurityCenterDisableHardwareUI = $True
                    defenderSecurityCenterDisableHealthUI = $True
                    defenderSecurityCenterDisableNetworkUI = $True
                    defenderSecurityCenterDisableNotificationAreaUI = $True
                    defenderSecurityCenterDisableRansomwareUI = $True
                    defenderSecurityCenterDisableSecureBootUI = $True
                    defenderSecurityCenterDisableTroubleshootingUI = $True
                    defenderSecurityCenterDisableVirusUI = $True
                    defenderSecurityCenterDisableVulnerableTpmFirmwareUpdateUI = $True
                    defenderSecurityCenterHelpEmail = "FakeStringValue"
                    defenderSecurityCenterHelpPhone = "FakeStringValue"
                    defenderSecurityCenterHelpURL = "FakeStringValue"
                    defenderSecurityCenterITContactDisplay = "notConfigured"
                    defenderSecurityCenterNotificationsFromApp = "notConfigured"
                    defenderSecurityCenterOrganizationDisplayName = "FakeStringValue"
                    defenderSignatureUpdateIntervalInHours = 25
                    defenderSubmitSamplesConsentType = "sendSafeSamplesAutomatically"
                    defenderUntrustedExecutable = "userDefined"
                    defenderUntrustedExecutableType = "userDefined"
                    defenderUntrustedUSBProcess = "userDefined"
                    defenderUntrustedUSBProcessType = "userDefined"
                    description = "FakeStringValue"
                    deviceGuardEnableSecureBootWithDMA = $True
                    deviceGuardEnableVirtualizationBasedSecurity = $True
                    deviceGuardLaunchSystemGuard = "notConfigured"
                    deviceGuardLocalSystemAuthorityCredentialGuardSettings = "notConfigured"
                    deviceGuardSecureBootWithDMA = "notConfigured"
                    displayName = "FakeStringValue"
                    dmaGuardDeviceEnumerationPolicy = "deviceDefault"
                    firewallBlockStatefulFTP = $True
                    firewallCertificateRevocationListCheckMethod = "deviceDefault"
                    firewallIdleTimeoutForSecurityAssociationInSeconds = 25
                    firewallIPSecExemptionsAllowDHCP = $True
                    firewallIPSecExemptionsAllowICMP = $True
                    firewallIPSecExemptionsAllowNeighborDiscovery = $True
                    firewallIPSecExemptionsAllowRouterDiscovery = $True
                    firewallIPSecExemptionsNone = $True
                    firewallMergeKeyingModuleSettings = $True
                    firewallPacketQueueingMethod = "deviceDefault"
                    firewallPreSharedKeyEncodingMethod = "deviceDefault"
                    firewallProfileDomain = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsFirewallNetworkProfile -Property @{
                        policyRulesFromGroupPolicyNotMerged = $True
                        inboundConnectionsRequired = $True
                        securedPacketExemptionAllowed = $True
                        securedPacketExemptionBlocked = $True
                        globalPortRulesFromGroupPolicyMerged = $True
                        stealthModeBlocked = $True
                        outboundConnectionsBlocked = $True
                        inboundConnectionsBlocked = $True
                        authorizedApplicationRulesFromGroupPolicyMerged = $True
                        inboundNotificationsRequired = $True
                        firewallEnabled = "notConfigured"
                        stealthModeRequired = $True
                        incomingTrafficBlocked = $True
                        incomingTrafficRequired = $True
                        unicastResponsesToMulticastBroadcastsBlocked = $True
                        policyRulesFromGroupPolicyMerged = $True
                        unicastResponsesToMulticastBroadcastsRequired = $True
                        connectionSecurityRulesFromGroupPolicyNotMerged = $True
                        globalPortRulesFromGroupPolicyNotMerged = $True
                        outboundConnectionsRequired = $True
                        inboundNotificationsBlocked = $True
                        connectionSecurityRulesFromGroupPolicyMerged = $True
                        authorizedApplicationRulesFromGroupPolicyNotMerged = $True
                    } -ClientOnly)
                    firewallProfilePrivate = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsFirewallNetworkProfile -Property @{
                        policyRulesFromGroupPolicyNotMerged = $True
                        inboundConnectionsRequired = $True
                        securedPacketExemptionAllowed = $True
                        securedPacketExemptionBlocked = $True
                        globalPortRulesFromGroupPolicyMerged = $True
                        stealthModeBlocked = $True
                        outboundConnectionsBlocked = $True
                        inboundConnectionsBlocked = $True
                        authorizedApplicationRulesFromGroupPolicyMerged = $True
                        inboundNotificationsRequired = $True
                        firewallEnabled = "notConfigured"
                        stealthModeRequired = $True
                        incomingTrafficBlocked = $True
                        incomingTrafficRequired = $True
                        unicastResponsesToMulticastBroadcastsBlocked = $True
                        policyRulesFromGroupPolicyMerged = $True
                        unicastResponsesToMulticastBroadcastsRequired = $True
                        connectionSecurityRulesFromGroupPolicyNotMerged = $True
                        globalPortRulesFromGroupPolicyNotMerged = $True
                        outboundConnectionsRequired = $True
                        inboundNotificationsBlocked = $True
                        connectionSecurityRulesFromGroupPolicyMerged = $True
                        authorizedApplicationRulesFromGroupPolicyNotMerged = $True
                    } -ClientOnly)
                    firewallProfilePublic = (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsFirewallNetworkProfile -Property @{
                        policyRulesFromGroupPolicyNotMerged = $True
                        inboundConnectionsRequired = $True
                        securedPacketExemptionAllowed = $True
                        securedPacketExemptionBlocked = $True
                        globalPortRulesFromGroupPolicyMerged = $True
                        stealthModeBlocked = $True
                        outboundConnectionsBlocked = $True
                        inboundConnectionsBlocked = $True
                        authorizedApplicationRulesFromGroupPolicyMerged = $True
                        inboundNotificationsRequired = $True
                        firewallEnabled = "notConfigured"
                        stealthModeRequired = $True
                        incomingTrafficBlocked = $True
                        incomingTrafficRequired = $True
                        unicastResponsesToMulticastBroadcastsBlocked = $True
                        policyRulesFromGroupPolicyMerged = $True
                        unicastResponsesToMulticastBroadcastsRequired = $True
                        connectionSecurityRulesFromGroupPolicyNotMerged = $True
                        globalPortRulesFromGroupPolicyNotMerged = $True
                        outboundConnectionsRequired = $True
                        inboundNotificationsBlocked = $True
                        connectionSecurityRulesFromGroupPolicyMerged = $True
                        authorizedApplicationRulesFromGroupPolicyNotMerged = $True
                    } -ClientOnly)
                    firewallRules = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphwindowsFirewallRule -Property @{
                            localAddressRanges = @("FakeStringValue")
                            action = "notConfigured"
                            description = "FakeStringValue"
                            interfaceTypes = "notConfigured"
                            remotePortRanges = @("FakeStringValue")
                            displayName = "FakeStringValue"
                            filePath = "FakeStringValue"
                            localUserAuthorizations = "FakeStringValue"
                            protocol = 25
                            trafficDirection = "notConfigured"
                            remoteAddressRanges = @("FakeStringValue")
                            packageFamilyName = "FakeStringValue"
                            serviceName = "FakeStringValue"
                            localPortRanges = @("FakeStringValue")
                            profileTypes = "notConfigured"
                            edgeTraversal = "notConfigured"
                        } -ClientOnly)
                    )
                    id = "FakeStringValue"
                    lanManagerAuthenticationLevel = "lmAndNltm"
                    lanManagerWorkstationDisableInsecureGuestLogons = $True
                    localSecurityOptionsAdministratorAccountName = "FakeStringValue"
                    localSecurityOptionsAdministratorElevationPromptBehavior = "notConfigured"
                    localSecurityOptionsAllowAnonymousEnumerationOfSAMAccountsAndShares = $True
                    localSecurityOptionsAllowPKU2UAuthenticationRequests = $True
                    localSecurityOptionsAllowRemoteCallsToSecurityAccountsManager = "FakeStringValue"
                    localSecurityOptionsAllowRemoteCallsToSecurityAccountsManagerHelperBool = $True
                    localSecurityOptionsAllowSystemToBeShutDownWithoutHavingToLogOn = $True
                    localSecurityOptionsAllowUIAccessApplicationElevation = $True
                    localSecurityOptionsAllowUIAccessApplicationsForSecureLocations = $True
                    localSecurityOptionsAllowUndockWithoutHavingToLogon = $True
                    localSecurityOptionsBlockMicrosoftAccounts = $True
                    localSecurityOptionsBlockRemoteLogonWithBlankPassword = $True
                    localSecurityOptionsBlockRemoteOpticalDriveAccess = $True
                    localSecurityOptionsBlockUsersInstallingPrinterDrivers = $True
                    localSecurityOptionsClearVirtualMemoryPageFile = $True
                    localSecurityOptionsClientDigitallySignCommunicationsAlways = $True
                    localSecurityOptionsClientSendUnencryptedPasswordToThirdPartySMBServers = $True
                    localSecurityOptionsDetectApplicationInstallationsAndPromptForElevation = $True
                    localSecurityOptionsDisableAdministratorAccount = $True
                    localSecurityOptionsDisableClientDigitallySignCommunicationsIfServerAgrees = $True
                    localSecurityOptionsDisableGuestAccount = $True
                    localSecurityOptionsDisableServerDigitallySignCommunicationsAlways = $True
                    localSecurityOptionsDisableServerDigitallySignCommunicationsIfClientAgrees = $True
                    localSecurityOptionsDoNotAllowAnonymousEnumerationOfSAMAccounts = $True
                    localSecurityOptionsDoNotRequireCtrlAltDel = $True
                    localSecurityOptionsDoNotStoreLANManagerHashValueOnNextPasswordChange = $True
                    localSecurityOptionsFormatAndEjectOfRemovableMediaAllowedUser = "notConfigured"
                    localSecurityOptionsGuestAccountName = "FakeStringValue"
                    localSecurityOptionsHideLastSignedInUser = $True
                    localSecurityOptionsHideUsernameAtSignIn = $True
                    localSecurityOptionsInformationDisplayedOnLockScreen = "notConfigured"
                    localSecurityOptionsInformationShownOnLockScreen = "notConfigured"
                    localSecurityOptionsLogOnMessageText = "FakeStringValue"
                    localSecurityOptionsLogOnMessageTitle = "FakeStringValue"
                    localSecurityOptionsMachineInactivityLimit = 25
                    localSecurityOptionsMachineInactivityLimitInMinutes = 25
                    localSecurityOptionsMinimumSessionSecurityForNtlmSspBasedClients = "none"
                    localSecurityOptionsMinimumSessionSecurityForNtlmSspBasedServers = "none"
                    localSecurityOptionsOnlyElevateSignedExecutables = $True
                    localSecurityOptionsRestrictAnonymousAccessToNamedPipesAndShares = $True
                    localSecurityOptionsSmartCardRemovalBehavior = "noAction"
                    localSecurityOptionsStandardUserElevationPromptBehavior = "notConfigured"
                    localSecurityOptionsSwitchToSecureDesktopWhenPromptingForElevation = $True
                    localSecurityOptionsUseAdminApprovalMode = $True
                    localSecurityOptionsUseAdminApprovalModeForAdministrators = $True
                    localSecurityOptionsVirtualizeFileAndRegistryWriteFailuresToPerUserLocations = $True
                    smartScreenBlockOverrideForFiles = $True
                    smartScreenEnableInShell = $True
                    supportsScopeTags = $True
                    userRightsAccessCredentialManagerAsTrustedCaller = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsActAsPartOfTheOperatingSystem = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsAllowAccessFromNetwork = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsBackupData = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsBlockAccessFromNetwork = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsChangeSystemTime = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsCreateGlobalObjects = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsCreatePageFile = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsCreatePermanentSharedObjects = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsCreateSymbolicLinks = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsCreateToken = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsDebugPrograms = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsDelegation = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsDenyLocalLogOn = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsGenerateSecurityAudits = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsImpersonateClient = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsIncreaseSchedulingPriority = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsLoadUnloadDrivers = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsLocalLogOn = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsLockMemory = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsManageAuditingAndSecurityLogs = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsManageVolumes = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsModifyFirmwareEnvironment = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsModifyObjectLabels = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsProfileSingleProcess = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsRemoteDesktopServicesLogOn = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsRemoteShutdown = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsRestoreData = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    userRightsTakeOwnership = (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsSetting -Property @{
                        State = "notConfigured"
                        LocalUsersOrGroups = [CimInstance[]]@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphdeviceManagementUserRightsLocalUserOrGroup -Property @{
                                Description = "FakeStringValue"
                                Name = "FakeStringValue"
                                SecurityIdentifier = "FakeStringValue"
                            } -ClientOnly)
                        )
                    } -ClientOnly)
                    windowsDefenderTamperProtection = "notConfigured"
                    xboxServicesAccessoryManagementServiceStartupMode = "manual"
                    xboxServicesEnableXboxGameSaveTask = $True
                    xboxServicesLiveAuthManagerServiceStartupMode = "manual"
                    xboxServicesLiveGameSaveServiceStartupMode = "manual"
                    xboxServicesLiveNetworkingServiceStartupMode = "manual"
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            userRightsManageAuditingAndSecurityLogs = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            bitLockerSystemDrivePolicy = @{
                                StartupAuthenticationTpmPinUsage = "blocked"
                                encryptionMethod = "aesCbc128"
                                minimumPinLength = 7
                                prebootRecoveryMessage = "FakeStringValue"
                                StartupAuthenticationTpmPinAndKeyUsage = "blocked"
                                RecoveryOptions = @{
                                    RecoveryPasswordUsage = "blocked"
                                    RecoveryInformationToStore = "passwordAndKey"
                                    RecoveryKeyUsage = "blocked"
                                }
                                prebootRecoveryUrl = "FakeStringValue"
                                StartupAuthenticationTpmUsage = "blocked"
                                StartupAuthenticationTpmKeyUsage = "blocked"
                            }
                            localSecurityOptionsGuestAccountName = "FakeStringValue"
                            defenderSecurityCenterOrganizationDisplayName = "FakeStringValue"
                            userRightsAccessCredentialManagerAsTrustedCaller = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsMinimumSessionSecurityForNtlmSspBasedClients = "none"
                            userRightsTakeOwnership = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            firewallPacketQueueingMethod = "deviceDefault"
                            defenderProcessCreation = "userDefined"
                            windowsDefenderTamperProtection = "notConfigured"
                            firewallIdleTimeoutForSecurityAssociationInSeconds = 7
                            defenderUntrustedUSBProcessType = "userDefined"
                            deviceGuardLaunchSystemGuard = "notConfigured"
                            userRightsCreatePermanentSharedObjects = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            firewallPreSharedKeyEncodingMethod = "deviceDefault"
                            applicationGuardBlockClipboardSharing = "notConfigured"
                            userRightsLocalLogOn = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderAdvancedRansomewareProtectionType = "userDefined"
                            firewallProfilePublic = @{
                                firewallEnabled = "notConfigured"
                            }
                            defenderOfficeAppsLaunchChildProcess = "userDefined"
                            defenderDetectedMalwareActions = @{
                                lowSeverity = "deviceDefault"
                                severeSeverity = "deviceDefault"
                                moderateSeverity = "deviceDefault"
                                highSeverity = "deviceDefault"
                            }
                            localSecurityOptionsSmartCardRemovalBehavior = "noAction"
                            lanManagerAuthenticationLevel = "lmAndNltm"
                            userRightsCreateGlobalObjects = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            xboxServicesAccessoryManagementServiceStartupMode = "manual"
                            applicationGuardCertificateThumbprints = @("FakeStringValue")
                            xboxServicesLiveNetworkingServiceStartupMode = "manual"
                            '@odata.type' = "#microsoft.graph.windows10EndpointProtectionConfiguration"
                            userRightsManageVolumes = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderSecurityCenterHelpEmail = "FakeStringValue"
                            localSecurityOptionsLogOnMessageTitle = "FakeStringValue"
                            userRightsDenyLocalLogOn = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderAdditionalGuardedFolders = @("FakeStringValue")
                            defenderUntrustedExecutable = "userDefined"
                            localSecurityOptionsStandardUserElevationPromptBehavior = "notConfigured"
                            firewallRules = @(
                                @{
                                    localAddressRanges = @("FakeStringValue")
                                    action = "notConfigured"
                                    description = "FakeStringValue"
                                    interfaceTypes = "notConfigured"
                                    remotePortRanges = @("FakeStringValue")
                                    displayName = "FakeStringValue"
                                    filePath = "FakeStringValue"
                                    localUserAuthorizations = "FakeStringValue"
                                    protocol = 7
                                    trafficDirection = "notConfigured"
                                    remoteAddressRanges = @("FakeStringValue")
                                    packageFamilyName = "FakeStringValue"
                                    serviceName = "FakeStringValue"
                                    localPortRanges = @("FakeStringValue")
                                    profileTypes = "notConfigured"
                                    edgeTraversal = "notConfigured"
                                }
                            )
                            bitLockerRemovableDrivePolicy = @{
                                encryptionMethod = "aesCbc128"
                            }
                            defenderGuardedFoldersAllowedAppPaths = @("FakeStringValue")
                            defenderEmailContentExecutionType = "userDefined"
                            defenderScriptDownloadedPayloadExecutionType = "userDefined"
                            dmaGuardDeviceEnumerationPolicy = "deviceDefault"
                            defenderEmailContentExecution = "userDefined"
                            userRightsLockMemory = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderSubmitSamplesConsentType = "sendSafeSamplesAutomatically"
                            defenderSecurityCenterHelpURL = "FakeStringValue"
                            defenderScheduledScanDay = "userDefined"
                            userRightsLoadUnloadDrivers = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            userRightsGenerateSecurityAudits = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderDaysBeforeDeletingQuarantinedMalware = 7
                            defenderBlockPersistenceThroughWmiType = "userDefined"
                            defenderFilesAndFoldersToExclude = @("FakeStringValue")
                            defenderSecurityCenterNotificationsFromApp = "notConfigured"
                            userRightsBlockAccessFromNetwork = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            bitLockerRecoveryPasswordRotation = "notConfigured"
                            defenderFileExtensionsToExclude = @("FakeStringValue")
                            defenderProcessCreationType = "userDefined"
                            defenderScanMaxCpuPercentage = 7
                            userRightsChangeSystemTime = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderScanDirection = "monitorAllFiles"
                            defenderOfficeAppsExecutableContentCreationOrLaunch = "userDefined"
                            localSecurityOptionsMachineInactivityLimit = 7
                            userRightsModifyFirmwareEnvironment = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsInformationDisplayedOnLockScreen = "notConfigured"
                            defenderOfficeAppsExecutableContentCreationOrLaunchType = "userDefined"
                            userRightsRemoteShutdown = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsInformationShownOnLockScreen = "notConfigured"
                            defenderOfficeCommunicationAppsLaunchChildProcess = "userDefined"
                            bitLockerFixedDrivePolicy = @{
                                RecoveryOptions = @{
                                    RecoveryPasswordUsage = "blocked"
                                    RecoveryInformationToStore = "passwordAndKey"
                                    RecoveryKeyUsage = "blocked"
                                }
                                encryptionMethod = "aesCbc128"
                            }
                            userRightsDelegation = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderExploitProtectionXmlFileName = "FakeStringValue"
                            userRightsImpersonateClient = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsMachineInactivityLimitInMinutes = 7
                            firewallProfileDomain = @{
                                firewallEnabled = "notConfigured"
                            }
                            defenderCloudBlockLevel = "notConfigured"
                            firewallProfilePrivate = @{
                                firewallEnabled = "notConfigured"
                            }
                            defenderCloudExtendedTimeoutInSeconds = 7
                            userRightsIncreaseSchedulingPriority = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsAdministratorAccountName = "FakeStringValue"
                            defenderAttackSurfaceReductionExcludedPaths = @("FakeStringValue")
                            userRightsCreatePageFile = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderAdobeReaderLaunchChildProcess = "userDefined"
                            userRightsBackupData = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderOfficeAppsLaunchChildProcessType = "userDefined"
                            defenderOfficeMacroCodeAllowWin32Imports = "userDefined"
                            applicationGuardEnabledOptions = "notConfigured"
                            deviceGuardSecureBootWithDMA = "notConfigured"
                            defenderScheduledQuickScanTime = "00:00:00"
                            defenderScriptObfuscatedMacroCode = "userDefined"
                            defenderScriptObfuscatedMacroCodeType = "userDefined"
                            defenderPreventCredentialStealingType = "userDefined"
                            defenderOfficeMacroCodeAllowWin32ImportsType = "userDefined"
                            userRightsAllowAccessFromNetwork = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderProcessesToExclude = @("FakeStringValue")
                            defenderNetworkProtectionType = "userDefined"
                            firewallCertificateRevocationListCheckMethod = "deviceDefault"
                            userRightsCreateToken = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderOfficeAppsOtherProcessInjection = "userDefined"
                            localSecurityOptionsLogOnMessageText = "FakeStringValue"
                            defenderUntrustedExecutableType = "userDefined"
                            defenderScanType = "userDefined"
                            deviceGuardLocalSystemAuthorityCredentialGuardSettings = "notConfigured"
                            userRightsModifyObjectLabels = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderSecurityCenterHelpPhone = "FakeStringValue"
                            appLockerApplicationControl = "notConfigured"
                            userRightsRemoteDesktopServicesLogOn = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderUntrustedUSBProcess = "userDefined"
                            userRightsDebugPrograms = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            applicationGuardBlockFileTransfer = "notConfigured"
                            localSecurityOptionsFormatAndEjectOfRemovableMediaAllowedUser = "notConfigured"
                            userRightsProfileSingleProcess = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderOfficeAppsOtherProcessInjectionType = "userDefined"
                            defenderGuardMyFoldersType = "userDefined"
                            xboxServicesLiveGameSaveServiceStartupMode = "manual"
                            userRightsRestoreData = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsAdministratorElevationPromptBehavior = "notConfigured"
                            localSecurityOptionsAllowRemoteCallsToSecurityAccountsManager = "FakeStringValue"
                            defenderPotentiallyUnwantedAppAction = "userDefined"
                            defenderScriptDownloadedPayloadExecution = "userDefined"
                            defenderSecurityCenterITContactDisplay = "notConfigured"
                            userRightsCreateSymbolicLinks = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderScheduledScanTime = "00:00:00"
                            xboxServicesLiveAuthManagerServiceStartupMode = "manual"
                            userRightsActAsPartOfTheOperatingSystem = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsMinimumSessionSecurityForNtlmSspBasedServers = "none"
                            defenderSignatureUpdateIntervalInHours = 7
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
                Should -Invoke -CommandName Update-MgBetaDeviceManagementDeviceConfiguration -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementDeviceConfiguration -MockWith {
                    return @{
                        AdditionalProperties = @{
                            localSecurityOptionsClearVirtualMemoryPageFile = $True
                            defenderSecurityCenterDisableHardwareUI = $True
                            applicationGuardAllowPrintToNetworkPrinters = $True
                            defenderFilesAndFoldersToExclude = @("FakeStringValue")
                            defenderAllowScanArchiveFiles = $True
                            firewallIPSecExemptionsNone = $True
                            bitLockerAllowStandardUserEncryption = $True
                            localSecurityOptionsAllowRemoteCallsToSecurityAccountsManager = "FakeStringValue"
                            defenderScheduledScanDay = "userDefined"
                            firewallPacketQueueingMethod = "deviceDefault"
                            defenderUntrustedUSBProcessType = "userDefined"
                            defenderNetworkProtectionType = "userDefined"
                            defenderProcessCreation = "userDefined"
                            applicationGuardEnabledOptions = "notConfigured"
                            defenderOfficeAppsLaunchChildProcess = "userDefined"
                            defenderAllowRealTimeMonitoring = $True
                            firewallIPSecExemptionsAllowNeighborDiscovery = $True
                            defenderUntrustedExecutable = "userDefined"
                            defenderGuardMyFoldersType = "userDefined"
                            localSecurityOptionsInformationDisplayedOnLockScreen = "notConfigured"
                            defenderScheduledQuickScanTime = "00:00:00"
                            localSecurityOptionsUseAdminApprovalMode = $True
                            applicationGuardAllowCameraMicrophoneRedirection = $True
                            applicationGuardAllowPrintToXPS = $True
                            deviceGuardLaunchSystemGuard = "notConfigured"
                            defenderScanDirection = "monitorAllFiles"
                            userRightsIncreaseSchedulingPriority = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            deviceGuardEnableVirtualizationBasedSecurity = $True
                            defenderBlockEndUserAccess = $True
                            firewallIPSecExemptionsAllowRouterDiscovery = $True
                            xboxServicesLiveGameSaveServiceStartupMode = "manual"
                            bitLockerFixedDrivePolicy = @{
                                RecoveryOptions = @{
                                    RecoveryInformationToStore = "passwordAndKey"
                                    HideRecoveryOptions = $True
                                    BlockDataRecoveryAgent = $True
                                    RecoveryKeyUsage = "blocked"
                                    EnableBitLockerAfterRecoveryInformationToStore = $True
                                    EnableRecoveryInformationSaveToStore = $True
                                    RecoveryPasswordUsage = "blocked"
                                }
                                RequireEncryptionForWriteAccess = $True
                                encryptionMethod = "aesCbc128"
                            }
                            userRightsCreateSymbolicLinks = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            applicationGuardBlockFileTransfer = "notConfigured"
                            defenderCheckForSignaturesBeforeRunningScan = $True
                            userRightsRemoteShutdown = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            firewallRules = @(
                                @{
                                    localAddressRanges = @("FakeStringValue")
                                    action = "notConfigured"
                                    description = "FakeStringValue"
                                    interfaceTypes = "notConfigured"
                                    remotePortRanges = @("FakeStringValue")
                                    displayName = "FakeStringValue"
                                    filePath = "FakeStringValue"
                                    localUserAuthorizations = "FakeStringValue"
                                    protocol = 25
                                    trafficDirection = "notConfigured"
                                    remoteAddressRanges = @("FakeStringValue")
                                    packageFamilyName = "FakeStringValue"
                                    serviceName = "FakeStringValue"
                                    localPortRanges = @("FakeStringValue")
                                    profileTypes = "notConfigured"
                                    edgeTraversal = "notConfigured"
                                }
                            )
                            defenderSignatureUpdateIntervalInHours = 25
                            defenderEnableLowCpuPriority = $True
                            localSecurityOptionsAllowAnonymousEnumerationOfSAMAccountsAndShares = $True
                            defenderFileExtensionsToExclude = @("FakeStringValue")
                            localSecurityOptionsHideLastSignedInUser = $True
                            userRightsBlockAccessFromNetwork = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsMinimumSessionSecurityForNtlmSspBasedServers = "none"
                            xboxServicesLiveAuthManagerServiceStartupMode = "manual"
                            localSecurityOptionsMachineInactivityLimitInMinutes = 25
                            localSecurityOptionsClientDigitallySignCommunicationsAlways = $True
                            defenderSecurityCenterDisableNetworkUI = $True
                            userRightsModifyObjectLabels = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            deviceGuardLocalSystemAuthorityCredentialGuardSettings = "notConfigured"
                            firewallIdleTimeoutForSecurityAssociationInSeconds = 25
                            defenderSecurityCenterHelpURL = "FakeStringValue"
                            localSecurityOptionsDisableServerDigitallySignCommunicationsAlways = $True
                            localSecurityOptionsAllowRemoteCallsToSecurityAccountsManagerHelperBool = $True
                            userRightsChangeSystemTime = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsAllowUndockWithoutHavingToLogon = $True
                            defenderEnableScanMappedNetworkDrivesDuringFullScan = $True
                            defenderUntrustedUSBProcess = "userDefined"
                            localSecurityOptionsHideUsernameAtSignIn = $True
                            defenderAllowScanDownloads = $True
                            localSecurityOptionsDisableAdministratorAccount = $True
                            defenderSecurityCenterDisableHealthUI = $True
                            userRightsCreateGlobalObjects = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsRestrictAnonymousAccessToNamedPipesAndShares = $True
                            localSecurityOptionsMachineInactivityLimit = 25
                            firewallCertificateRevocationListCheckMethod = "deviceDefault"
                            defenderSecurityCenterDisableFamilyUI = $True
                            defenderAllowCloudProtection = $True
                            bitLockerEnableStorageCardEncryptionOnMobile = $True
                            applicationGuardEnabled = $True
                            defenderOfficeAppsOtherProcessInjection = "userDefined"
                            userRightsImpersonateClient = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            '@odata.type' = "#microsoft.graph.windows10EndpointProtectionConfiguration"
                            localSecurityOptionsUseAdminApprovalModeForAdministrators = $True
                            lanManagerWorkstationDisableInsecureGuestLogons = $True
                            defenderAdvancedRansomewareProtectionType = "userDefined"
                            defenderUntrustedExecutableType = "userDefined"
                            defenderDisableScanArchiveFiles = $True
                            lanManagerAuthenticationLevel = "lmAndNltm"
                            userRightsActAsPartOfTheOperatingSystem = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderPreventCredentialStealingType = "userDefined"
                            localSecurityOptionsAllowUIAccessApplicationsForSecureLocations = $True
                            deviceGuardEnableSecureBootWithDMA = $True
                            localSecurityOptionsDisableClientDigitallySignCommunicationsIfServerAgrees = $True
                            defenderScriptObfuscatedMacroCode = "userDefined"
                            defenderDaysBeforeDeletingQuarantinedMalware = 25
                            defenderAllowScanRemovableDrivesDuringFullScan = $True
                            localSecurityOptionsDisableServerDigitallySignCommunicationsIfClientAgrees = $True
                            firewallProfilePrivate = @{
                                policyRulesFromGroupPolicyNotMerged = $True
                                inboundConnectionsRequired = $True
                                securedPacketExemptionAllowed = $True
                                securedPacketExemptionBlocked = $True
                                globalPortRulesFromGroupPolicyMerged = $True
                                stealthModeBlocked = $True
                                outboundConnectionsBlocked = $True
                                inboundConnectionsBlocked = $True
                                authorizedApplicationRulesFromGroupPolicyMerged = $True
                                inboundNotificationsRequired = $True
                                firewallEnabled = "notConfigured"
                                stealthModeRequired = $True
                                incomingTrafficBlocked = $True
                                incomingTrafficRequired = $True
                                unicastResponsesToMulticastBroadcastsBlocked = $True
                                policyRulesFromGroupPolicyMerged = $True
                                unicastResponsesToMulticastBroadcastsRequired = $True
                                connectionSecurityRulesFromGroupPolicyNotMerged = $True
                                globalPortRulesFromGroupPolicyNotMerged = $True
                                outboundConnectionsRequired = $True
                                inboundNotificationsBlocked = $True
                                connectionSecurityRulesFromGroupPolicyMerged = $True
                                authorizedApplicationRulesFromGroupPolicyNotMerged = $True
                            }
                            defenderSecurityCenterDisableAppBrowserUI = $True
                            localSecurityOptionsInformationShownOnLockScreen = "notConfigured"
                            defenderOfficeAppsLaunchChildProcessType = "userDefined"
                            deviceGuardSecureBootWithDMA = "notConfigured"
                            applicationGuardAllowPrintToPDF = $True
                            userRightsCreateToken = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderExploitProtectionXml = $True
                            userRightsRemoteDesktopServicesLogOn = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsBlockRemoteLogonWithBlankPassword = $True
                            userRightsBackupData = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            userRightsDenyLocalLogOn = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsOnlyElevateSignedExecutables = $True
                            applicationGuardAllowVirtualGPU = $True
                            defenderScanType = "userDefined"
                            bitLockerSystemDrivePolicy = @{
                                prebootRecoveryEnableMessageAndUrl = $True
                                StartupAuthenticationTpmPinUsage = "blocked"
                                encryptionMethod = "aesCbc128"
                                minimumPinLength = 25
                                prebootRecoveryMessage = "FakeStringValue"
                                StartupAuthenticationTpmPinAndKeyUsage = "blocked"
                                StartupAuthenticationRequired = $True
                                RecoveryOptions = @{
                                    RecoveryInformationToStore = "passwordAndKey"
                                    HideRecoveryOptions = $True
                                    BlockDataRecoveryAgent = $True
                                    RecoveryKeyUsage = "blocked"
                                    EnableBitLockerAfterRecoveryInformationToStore = $True
                                    EnableRecoveryInformationSaveToStore = $True
                                    RecoveryPasswordUsage = "blocked"
                                }
                                prebootRecoveryUrl = "FakeStringValue"
                                StartupAuthenticationTpmUsage = "blocked"
                                StartupAuthenticationTpmKeyUsage = "blocked"
                                StartupAuthenticationBlockWithoutTpmChip = $True
                            }
                            defenderAllowBehaviorMonitoring = $True
                            defenderAllowIntrusionPreventionSystem = $True
                            localSecurityOptionsDoNotStoreLANManagerHashValueOnNextPasswordChange = $True
                            defenderSecurityCenterHelpEmail = "FakeStringValue"
                            defenderDisableBehaviorMonitoring = $True
                            localSecurityOptionsVirtualizeFileAndRegistryWriteFailuresToPerUserLocations = $True
                            applicationGuardBlockClipboardSharing = "notConfigured"
                            defenderEmailContentExecution = "userDefined"
                            localSecurityOptionsBlockRemoteOpticalDriveAccess = $True
                            firewallProfilePublic = @{
                                policyRulesFromGroupPolicyNotMerged = $True
                                inboundConnectionsRequired = $True
                                securedPacketExemptionAllowed = $True
                                securedPacketExemptionBlocked = $True
                                globalPortRulesFromGroupPolicyMerged = $True
                                stealthModeBlocked = $True
                                outboundConnectionsBlocked = $True
                                inboundConnectionsBlocked = $True
                                authorizedApplicationRulesFromGroupPolicyMerged = $True
                                inboundNotificationsRequired = $True
                                firewallEnabled = "notConfigured"
                                stealthModeRequired = $True
                                incomingTrafficBlocked = $True
                                incomingTrafficRequired = $True
                                unicastResponsesToMulticastBroadcastsBlocked = $True
                                policyRulesFromGroupPolicyMerged = $True
                                unicastResponsesToMulticastBroadcastsRequired = $True
                                connectionSecurityRulesFromGroupPolicyNotMerged = $True
                                globalPortRulesFromGroupPolicyNotMerged = $True
                                outboundConnectionsRequired = $True
                                inboundNotificationsBlocked = $True
                                connectionSecurityRulesFromGroupPolicyMerged = $True
                                authorizedApplicationRulesFromGroupPolicyNotMerged = $True
                            }
                            defenderScriptDownloadedPayloadExecutionType = "userDefined"
                            xboxServicesAccessoryManagementServiceStartupMode = "manual"
                            xboxServicesEnableXboxGameSaveTask = $True
                            bitLockerEncryptDevice = $True
                            localSecurityOptionsBlockMicrosoftAccounts = $True
                            bitLockerRemovableDrivePolicy = @{
                                requireEncryptionForWriteAccess = $True
                                blockCrossOrganizationWriteAccess = $True
                                encryptionMethod = "aesCbc128"
                            }
                            defenderSecurityCenterBlockExploitProtectionOverride = $True
                            localSecurityOptionsLogOnMessageText = "FakeStringValue"
                            applicationGuardCertificateThumbprints = @("FakeStringValue")
                            defenderCloudBlockLevel = "notConfigured"
                            defenderProcessCreationType = "userDefined"
                            defenderDisableScanDownloads = $True
                            defenderOfficeCommunicationAppsLaunchChildProcess = "userDefined"
                            localSecurityOptionsClientSendUnencryptedPasswordToThirdPartySMBServers = $True
                            userRightsAllowAccessFromNetwork = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            applicationGuardForceAuditing = $True
                            defenderDisableRealTimeMonitoring = $True
                            defenderSecurityCenterNotificationsFromApp = "notConfigured"
                            localSecurityOptionsAdministratorAccountName = "FakeStringValue"
                            windowsDefenderTamperProtection = "notConfigured"
                            defenderSecurityCenterDisableAccountUI = $True
                            localSecurityOptionsSwitchToSecureDesktopWhenPromptingForElevation = $True
                            defenderEmailContentExecutionType = "userDefined"
                            defenderAllowScanNetworkFiles = $True
                            defenderSecurityCenterDisableNotificationAreaUI = $True
                            userRightsProfileSingleProcess = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsSmartCardRemovalBehavior = "noAction"
                            defenderDisableCloudProtection = $True
                            userRightsManageVolumes = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            smartScreenEnableInShell = $True
                            applicationGuardBlockNonEnterpriseContent = $True
                            defenderAdditionalGuardedFolders = @("FakeStringValue")
                            localSecurityOptionsDoNotAllowAnonymousEnumerationOfSAMAccounts = $True
                            userRightsRestoreData = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsMinimumSessionSecurityForNtlmSspBasedClients = "none"
                            defenderDisableOnAccessProtection = $True
                            bitLockerRecoveryPasswordRotation = "notConfigured"
                            firewallPreSharedKeyEncodingMethod = "deviceDefault"
                            userRightsDelegation = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            userRightsDebugPrograms = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderSecurityCenterDisableVulnerableTpmFirmwareUpdateUI = $True
                            defenderSecurityCenterOrganizationDisplayName = "FakeStringValue"
                            localSecurityOptionsFormatAndEjectOfRemovableMediaAllowedUser = "notConfigured"
                            userRightsLockMemory = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            appLockerApplicationControl = "notConfigured"
                            defenderBlockPersistenceThroughWmiType = "userDefined"
                            defenderDisableScanNetworkFiles = $True
                            defenderDisableCatchupQuickScan = $True
                            localSecurityOptionsLogOnMessageTitle = "FakeStringValue"
                            localSecurityOptionsStandardUserElevationPromptBehavior = "notConfigured"
                            userRightsGenerateSecurityAudits = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderSecurityCenterDisableClearTpmUI = $True
                            defenderEnableScanIncomingMail = $True
                            defenderSecurityCenterHelpPhone = "FakeStringValue"
                            localSecurityOptionsDoNotRequireCtrlAltDel = $True
                            userRightsTakeOwnership = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            userRightsLocalLogOn = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            applicationGuardAllowPersistence = $True
                            defenderCloudExtendedTimeoutInSeconds = 25
                            firewallIPSecExemptionsAllowICMP = $True
                            defenderAllowEndUserAccess = $True
                            defenderScriptDownloadedPayloadExecution = "userDefined"
                            defenderExploitProtectionXmlFileName = "FakeStringValue"
                            defenderScriptObfuscatedMacroCodeType = "userDefined"
                            defenderDisableScanRemovableDrivesDuringFullScan = $True
                            localSecurityOptionsAllowSystemToBeShutDownWithoutHavingToLogOn = $True
                            defenderOfficeMacroCodeAllowWin32ImportsType = "userDefined"
                            firewallIPSecExemptionsAllowDHCP = $True
                            firewallProfileDomain = @{
                                policyRulesFromGroupPolicyNotMerged = $True
                                inboundConnectionsRequired = $True
                                securedPacketExemptionAllowed = $True
                                securedPacketExemptionBlocked = $True
                                globalPortRulesFromGroupPolicyMerged = $True
                                stealthModeBlocked = $True
                                outboundConnectionsBlocked = $True
                                inboundConnectionsBlocked = $True
                                authorizedApplicationRulesFromGroupPolicyMerged = $True
                                inboundNotificationsRequired = $True
                                firewallEnabled = "notConfigured"
                                stealthModeRequired = $True
                                incomingTrafficBlocked = $True
                                incomingTrafficRequired = $True
                                unicastResponsesToMulticastBroadcastsBlocked = $True
                                policyRulesFromGroupPolicyMerged = $True
                                unicastResponsesToMulticastBroadcastsRequired = $True
                                connectionSecurityRulesFromGroupPolicyNotMerged = $True
                                globalPortRulesFromGroupPolicyNotMerged = $True
                                outboundConnectionsRequired = $True
                                inboundNotificationsBlocked = $True
                                connectionSecurityRulesFromGroupPolicyMerged = $True
                                authorizedApplicationRulesFromGroupPolicyNotMerged = $True
                            }
                            localSecurityOptionsAllowPKU2UAuthenticationRequests = $True
                            defenderSecurityCenterDisableTroubleshootingUI = $True
                            defenderPotentiallyUnwantedAppAction = "userDefined"
                            userRightsModifyFirmwareEnvironment = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderOfficeAppsExecutableContentCreationOrLaunch = "userDefined"
                            defenderOfficeAppsExecutableContentCreationOrLaunchType = "userDefined"
                            defenderSubmitSamplesConsentType = "sendSafeSamplesAutomatically"
                            defenderAdobeReaderLaunchChildProcess = "userDefined"
                            localSecurityOptionsDetectApplicationInstallationsAndPromptForElevation = $True
                            defenderDisableIntrusionPreventionSystem = $True
                            defenderDisableCatchupFullScan = $True
                            bitLockerDisableWarningForOtherDiskEncryption = $True
                            xboxServicesLiveNetworkingServiceStartupMode = "manual"
                            firewallBlockStatefulFTP = $True
                            firewallMergeKeyingModuleSettings = $True
                            userRightsManageAuditingAndSecurityLogs = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            userRightsCreatePermanentSharedObjects = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsBlockUsersInstallingPrinterDrivers = $True
                            smartScreenBlockOverrideForFiles = $True
                            userRightsCreatePageFile = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderAllowOnAccessProtection = $True
                            dmaGuardDeviceEnumerationPolicy = "deviceDefault"
                            defenderOfficeAppsOtherProcessInjectionType = "userDefined"
                            localSecurityOptionsGuestAccountName = "FakeStringValue"
                            defenderDetectedMalwareActions = @{
                                lowSeverity = "deviceDefault"
                                severeSeverity = "deviceDefault"
                                moderateSeverity = "deviceDefault"
                                highSeverity = "deviceDefault"
                            }
                            defenderProcessesToExclude = @("FakeStringValue")
                            defenderScheduledScanTime = "00:00:00"
                            defenderSecurityCenterDisableSecureBootUI = $True
                            applicationGuardAllowFileSaveOnHost = $True
                            localSecurityOptionsDisableGuestAccount = $True
                            defenderSecurityCenterDisableRansomwareUI = $True
                            defenderGuardedFoldersAllowedAppPaths = @("FakeStringValue")
                            defenderOfficeMacroCodeAllowWin32Imports = "userDefined"
                            applicationGuardAllowPrintToLocalPrinters = $True
                            defenderSecurityCenterITContactDisplay = "notConfigured"
                            defenderAttackSurfaceReductionExcludedPaths = @("FakeStringValue")
                            defenderAllowScanScriptsLoadedInInternetExplorer = $True
                            defenderSecurityCenterDisableVirusUI = $True
                            userRightsAccessCredentialManagerAsTrustedCaller = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            localSecurityOptionsAllowUIAccessApplicationElevation = $True
                            defenderDisableScanScriptsLoadedInInternetExplorer = $True
                            localSecurityOptionsAdministratorElevationPromptBehavior = "notConfigured"
                            userRightsLoadUnloadDrivers = @{
                                State = "notConfigured"
                                LocalUsersOrGroups = @(
                                    @{
                                        Description = "FakeStringValue"
                                        Name = "FakeStringValue"
                                        SecurityIdentifier = "FakeStringValue"
                                    }
                                )
                            }
                            defenderScanMaxCpuPercentage = 25
                        }
                        description = "FakeStringValue"
                        displayName = "FakeStringValue"
                        id = "FakeStringValue"
                        supportsScopeTags = $True

                    }
                }
            }
            It "Should Reverse Engineer resource from the Export method" {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
