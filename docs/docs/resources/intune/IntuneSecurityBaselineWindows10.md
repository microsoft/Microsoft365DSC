# IntuneSecurityBaselineWindows10

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Description** | Write | String | Policy description | |
| **DisplayName** | Key | String | Policy name | |
| **RoleScopeTagIds** | Write | StringArray[] | List of Scope Tags for this Entity instance. | |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |
| **DeviceSettings** | Write | MSFT_MicrosoftGraphIntuneSettingsCatalogDeviceSettings_IntuneSecurityBaselineWindows10 | The policy settings for the device scope. | |
| **UserSettings** | Write | MSFT_MicrosoftGraphIntuneSettingsCatalogUserSettings_IntuneSecurityBaselineWindows10 | The policy settings for the user scope. | |
| **Assignments** | Write | MSFT_DeviceManagementConfigurationPolicyAssignments[] | Represents the assignment to the Intune policy. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_DeviceManagementConfigurationPolicyAssignments

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **dataType** | Write | String | The type of the target assignment. | `#microsoft.graph.groupAssignmentTarget`, `#microsoft.graph.allLicensedUsersAssignmentTarget`, `#microsoft.graph.allDevicesAssignmentTarget`, `#microsoft.graph.exclusionGroupAssignmentTarget`, `#microsoft.graph.configurationManagerCollectionAssignmentTarget` |
| **deviceAndAppManagementAssignmentFilterType** | Write | String | The type of filter of the target assignment i.e. Exclude or Include. Possible values are:none, include, exclude. | `none`, `include`, `exclude` |
| **deviceAndAppManagementAssignmentFilterId** | Write | String | The Id of the filter for the target assignment. | |
| **groupId** | Write | String | The group Id that is the target of the assignment. | |
| **groupDisplayName** | Write | String | The group Display Name that is the target of the assignment. | |
| **collectionId** | Write | String | The collection Id that is the target of the assignment.(ConfigMgr) | |

### MSFT_MicrosoftGraphIntuneSettingsCatalogpol_hardenedpaths

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **value** | Write | String | Value | |
| **key** | Write | String | Name | |

### MSFT_MicrosoftGraphIntuneSettingsCatalogDeviceSettings_IntuneSecurityBaselineWindows10

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **CPL_Personalization_NoLockScreenCamera** | Write | String | Prevent enabling lock screen camera (0: Disabled, 1: Enabled) | `0`, `1` |
| **CPL_Personalization_NoLockScreenSlideshow** | Write | String | Prevent enabling lock screen slide show (0: Disabled, 1: Enabled) | `0`, `1` |
| **Pol_SecGuide_0201_LATFP** | Write | String | Apply UAC restrictions to local accounts on network logons (0: Disabled, 1: Enabled) | `0`, `1` |
| **Pol_SecGuide_0002_SMBv1_ClientDriver** | Write | String | Configure SMB v1 client driver (0: Disabled, 1: Enabled) | `0`, `1` |
| **Pol_SecGuide_SMB1ClientDriver** | Write | String | Configure MrxSmb10 driver - Depends on Pol_SecGuide_0002_SMBv1_ClientDriver (4: Disable driver (recommended), 3: Manual start (default for Win7/2008/2008R2/2012), 2: Automatic start (default for Win8.1/2012R2/newer)) | `4`, `3`, `2` |
| **Pol_SecGuide_0001_SMBv1_Server** | Write | String | Configure SMB v1 server (0: Disabled, 1: Enabled) | `0`, `1` |
| **Pol_SecGuide_0102_SEHOP** | Write | String | Enable Structured Exception Handling Overwrite Protection (SEHOP) (0: Disabled, 1: Enabled) | `0`, `1` |
| **Pol_SecGuide_0202_WDigestAuthn** | Write | String | WDigest Authentication (disabling may require KB2871997) (0: Disabled, 1: Enabled) | `0`, `1` |
| **Pol_MSS_DisableIPSourceRoutingIPv6** | Write | String | MSS: (DisableIPSourceRouting IPv6) IP source routing protection level (protects against packet spoofing) (0: Disabled, 1: Enabled) | `0`, `1` |
| **DisableIPSourceRoutingIPv6** | Write | String | DisableIPSourceRoutingIPv6 (Device) - Depends on Pol_MSS_DisableIPSourceRoutingIPv6 (0: No additional protection, source routed packets are allowed, 1: Medium, source routed packets ignored when IP forwarding is enabled, 2: Highest protection, source routing is completely disabled) | `0`, `1`, `2` |
| **Pol_MSS_DisableIPSourceRouting** | Write | String | MSS: (DisableIPSourceRouting) IP source routing protection level (protects against packet spoofing) (0: Disabled, 1: Enabled) | `0`, `1` |
| **DisableIPSourceRouting** | Write | String | DisableIPSourceRouting (Device) - Depends on Pol_MSS_DisableIPSourceRouting (0: No additional protection, source routed packets are allowed, 1: Medium, source routed packets ignored when IP forwarding is enabled, 2: Highest protection, source routing is completely disabled) | `0`, `1`, `2` |
| **Pol_MSS_EnableICMPRedirect** | Write | String | MSS: (EnableICMPRedirect) Allow ICMP redirects to override OSPF generated routes (0: Disabled, 1: Enabled) | `0`, `1` |
| **Pol_MSS_NoNameReleaseOnDemand** | Write | String | MSS: (NoNameReleaseOnDemand) Allow the computer to ignore NetBIOS name release requests except from WINS servers (0: Disabled, 1: Enabled) | `0`, `1` |
| **Turn_Off_Multicast** | Write | String | Turn off multicast name resolution (0: Disabled, 1: Enabled) | `0`, `1` |
| **NC_ShowSharedAccessUI** | Write | String | Prohibit use of Internet Connection Sharing on your DNS domain network (0: Disabled, 1: Enabled) | `0`, `1` |
| **hardeneduncpaths_Pol_HardenedPaths** | Write | String | Hardened UNC Paths (0: Disabled, 1: Enabled) | `0`, `1` |
| **pol_hardenedpaths** | Write | MSFT_MicrosoftGraphIntuneSettingsCatalogpol_hardenedpaths[] | Hardened UNC Paths: (Device) - Depends on hardeneduncpaths_Pol_HardenedPaths | |
| **WCM_BlockNonDomain** | Write | String | Prohibit connection to non-domain networks when connected to domain authenticated network (0: Disabled, 1: Enabled) | `0`, `1` |
| **ConfigureRedirectionGuardPolicy** | Write | String | Configure Redirection Guard (0: Disabled, 1: Enabled) | `0`, `1` |
| **RedirectionGuardPolicy_Enum** | Write | String | Redirection Guard Options (Device) - Depends on ConfigureRedirectionGuardPolicy (0: Redirection Guard Disabled, 1: Redirection Guard Enabled, 2: Redirection Guard Audit Only) | `0`, `1`, `2` |
| **ConfigureRpcConnectionPolicy** | Write | String | Configure RPC connection settings (0: Disabled, 1: Enabled) | `0`, `1` |
| **RpcConnectionAuthentication_Enum** | Write | String | Use authentication for outgoing RPC connections: (Device) - Depends on ConfigureRpcConnectionPolicy (0: Default, 1: Authentication enabled, 2: Authentication disabled) | `0`, `1`, `2` |
| **RpcConnectionProtocol_Enum** | Write | String | Protocol to use for outgoing RPC connections: (Device) - Depends on ConfigureRpcConnectionPolicy (0: RPC over TCP, 1: RPC over named pipes) | `0`, `1` |
| **ConfigureRpcListenerPolicy** | Write | String | Configure RPC listener settings (0: Disabled, 1: Enabled) | `0`, `1` |
| **RpcAuthenticationProtocol_Enum** | Write | String | Authentication protocol to use for incoming RPC connections: (Device) - Depends on ConfigureRpcListenerPolicy (0: Negotiate, 1: Kerberos) | `0`, `1` |
| **RpcListenerProtocols_Enum** | Write | String | Protocols to allow for incoming RPC connections: (Device) - Depends on ConfigureRpcListenerPolicy (3: RPC over named pipes, 5: RPC over TCP, 7: RPC over named pipes and TCP) | `3`, `5`, `7` |
| **ConfigureRpcTcpPort** | Write | String | Configure RPC over TCP port (0: Disabled, 1: Enabled) | `0`, `1` |
| **RpcTcpPort** | Write | SInt32 | RPC over TCP port: (Device) - Depends on ConfigureRpcTcpPort | |
| **RestrictDriverInstallationToAdministrators** | Write | String | Limits print driver installation to Administrators (0: Disabled, 1: Enabled) | `0`, `1` |
| **ConfigureCopyFilesPolicy** | Write | String | Manage processing of Queue-specific files (0: Disabled, 1: Enabled) | `0`, `1` |
| **CopyFilesPolicy_Enum** | Write | String | Manage processing of Queue-Specific files: (Device) - Depends on ConfigureCopyFilesPolicy (0: Do not allow Queue-specific files, 1: Limit Queue-specific files to Color profiles, 2: Allow all Queue-specfic files) | `0`, `1`, `2` |
| **AllowEncryptionOracle** | Write | String | Encryption Oracle Remediation (0: Disabled, 1: Enabled) | `0`, `1` |
| **AllowEncryptionOracleDrop** | Write | String | Protection Level: (Device) - Depends on AllowEncryptionOracle (0: Force Updated Clients, 1: Mitigated, 2: Vulnerable) | `0`, `1`, `2` |
| **AllowProtectedCreds** | Write | String | Remote host allows delegation of non-exportable credentials (0: Disabled, 1: Enabled) | `0`, `1` |
| **DeviceInstall_Classes_Deny** | Write | String | Prevent installation of devices using drivers that match these device setup classes (0: Disabled, 1: Enabled) | `0`, `1` |
| **DeviceInstall_Classes_Deny_List** | Write | StringArray[] | Prevented Classes - Depends on DeviceInstall_Classes_Deny | |
| **DeviceInstall_Classes_Deny_Retroactive** | Write | String | Also apply to matching devices that are already installed. - Depends on DeviceInstall_Classes_Deny (0: False, 1: True) | `0`, `1` |
| **POL_DriverLoadPolicy_Name** | Write | String | Boot-Start Driver Initialization Policy (0: Disabled, 1: Enabled) | `0`, `1` |
| **SelectDriverLoadPolicy** | Write | String | Choose the boot-start drivers that can be initialized: - Depends on POL_DriverLoadPolicy_Name (8: Good only, 1: Good and unknown, 3: Good, unknown and bad but critical, 7: All) | `8`, `1`, `3`, `7` |
| **CSE_Registry** | Write | String | Configure registry policy processing (0: Disabled, 1: Enabled) | `0`, `1` |
| **CSE_NOBACKGROUND10** | Write | String | Do not apply during periodic background processing (Device) - Depends on CSE_Registry (0: False, 1: True) | `0`, `1` |
| **CSE_NOCHANGES10** | Write | String | Process even if the Group Policy objects have not changed (Device) - Depends on CSE_Registry (0: False, 1: True) | `0`, `1` |
| **DisableWebPnPDownload_2** | Write | String | Turn off downloading of print drivers over HTTP (0: Disabled, 1: Enabled) | `0`, `1` |
| **ShellPreventWPWDownload_2** | Write | String | Turn off Internet download for Web publishing and online ordering wizards (0: Disabled, 1: Enabled) | `0`, `1` |
| **AllowCustomSSPsAPs** | Write | String | Allow Custom SSPs and APs to be loaded into LSASS (0: Disabled, 1: Enabled) | `0`, `1` |
| **AllowStandbyStatesDC_2** | Write | String | Allow standby states (S1-S3) when sleeping (on battery) (0: Disabled, 1: Enabled) | `0`, `1` |
| **AllowStandbyStatesAC_2** | Write | String | Allow standby states (S1-S3) when sleeping (plugged in) (0: Disabled, 1: Enabled) | `0`, `1` |
| **DCPromptForPasswordOnResume_2** | Write | String | Require a password when a computer wakes (on battery) (0: Disabled, 1: Enabled) | `0`, `1` |
| **ACPromptForPasswordOnResume_2** | Write | String | Require a password when a computer wakes (plugged in) (0: Disabled, 1: Enabled) | `0`, `1` |
| **RA_Solicit** | Write | String | Configure Solicited Remote Assistance (0: Disabled, 1: Enabled) | `0`, `1` |
| **RA_Solicit_ExpireUnits_List** | Write | String | Maximum ticket time (units): - Depends on RA_Solicit (0: Minutes, 1: Hours, 2: Days) | `0`, `1`, `2` |
| **RA_Solicit_ExpireValue_Edt** | Write | SInt32 | Maximum ticket time (value): - Depends on RA_Solicit | |
| **RA_Solicit_Control_List** | Write | String | Permit remote control of this computer: - Depends on RA_Solicit (1: Allow helpers to remotely control the computer, 0: Allow helpers to only view the computer) | `1`, `0` |
| **RA_Solicit_Mailto_List** | Write | String | Method for sending email invitations: - Depends on RA_Solicit (0: Simple MAPI, 1: Mailto) | `0`, `1` |
| **RpcRestrictRemoteClients** | Write | String | Restrict Unauthenticated RPC clients (0: Disabled, 1: Enabled) | `0`, `1` |
| **RpcRestrictRemoteClientsList** | Write | String | RPC Runtime Unauthenticated Client Restriction to Apply: - Depends on RpcRestrictRemoteClients (0: None, 1: Authenticated, 2: Authenticated without exceptions) | `0`, `1`, `2` |
| **AppxRuntimeMicrosoftAccountsOptional** | Write | String | Allow Microsoft accounts to be optional (0: Disabled, 1: Enabled) | `0`, `1` |
| **NoAutoplayfornonVolume** | Write | String | Disallow Autoplay for non-volume devices (0: Disabled, 1: Enabled) | `0`, `1` |
| **NoAutorun** | Write | String | Set the default behavior for AutoRun (0: Disabled, 1: Enabled) | `0`, `1` |
| **NoAutorun_Dropdown** | Write | String | Default AutoRun Behavior - Depends on NoAutorun (1: Do not execute any autorun commands, 2: Automatically execute autorun commands) | `1`, `2` |
| **Autorun** | Write | String | Turn off Autoplay (0: Disabled, 1: Enabled) | `0`, `1` |
| **Autorun_Box** | Write | String | Turn off Autoplay on: - Depends on Autorun (181: CD-ROM and removable media drives, 255: All drives) | `181`, `255` |
| **FDVDenyWriteAccess_Name** | Write | String | Deny write access to fixed drives not protected by BitLocker (0: Disabled, 1: Enabled) | `0`, `1` |
| **RDVDenyWriteAccess_Name** | Write | String | Deny write access to removable drives not protected by BitLocker (0: Disabled, 1: Enabled) | `0`, `1` |
| **RDVCrossOrg** | Write | String | Do not allow write access to devices configured in another organization - Depends on RDVDenyWriteAccess_Name (0: False, 1: True) | `0`, `1` |
| **EnumerateAdministrators** | Write | String | Enumerate administrator accounts on elevation (0: Disabled, 1: Enabled) | `0`, `1` |
| **Channel_LogMaxSize_1** | Write | String | Specify the maximum log file size (KB) (0: Disabled, 1: Enabled) | `0`, `1` |
| **Channel_LogMaxSize_1_Channel_LogMaxSize** | Write | SInt32 | Maximum Log Size (KB) - Depends on Channel_LogMaxSize_1 | |
| **Channel_LogMaxSize_2** | Write | String | Specify the maximum log file size (KB) (0: Disabled, 1: Enabled) | `0`, `1` |
| **Channel_LogMaxSize_2_Channel_LogMaxSize** | Write | SInt32 | Maximum Log Size (KB) - Depends on Channel_LogMaxSize_2 | |
| **Channel_LogMaxSize_4** | Write | String | Specify the maximum log file size (KB) (0: Disabled, 1: Enabled) | `0`, `1` |
| **Channel_LogMaxSize_4_Channel_LogMaxSize** | Write | SInt32 | Maximum Log Size (KB) - Depends on Channel_LogMaxSize_4 | |
| **EnableSmartScreen** | Write | String | Configure Windows Defender SmartScreen (0: Disabled, 1: Enabled) | `0`, `1` |
| **EnableSmartScreenDropdown** | Write | String | Pick one of the following settings: (Device) - Depends on EnableSmartScreen (block: Warn and prevent bypass, warn: Warn) | `block`, `warn` |
| **NoDataExecutionPrevention** | Write | String | Turn off Data Execution Prevention for Explorer (0: Disabled, 1: Enabled) | `0`, `1` |
| **NoHeapTerminationOnCorruption** | Write | String | Turn off heap termination on corruption (0: Disabled, 1: Enabled) | `0`, `1` |
| **Advanced_InvalidSignatureBlock** | Write | String | Allow software to run or install even if the signature is invalid (0: Disabled, 1: Enabled) | `0`, `1` |
| **Advanced_CertificateRevocation** | Write | String | Check for server certificate revocation (0: Disabled, 1: Enabled) | `0`, `1` |
| **Advanced_DownloadSignatures** | Write | String | Check for signatures on downloaded programs (0: Disabled, 1: Enabled) | `0`, `1` |
| **Advanced_DisableEPMCompat** | Write | String | Do not allow ActiveX controls to run in Protected Mode when Enhanced Protected Mode is enabled (0: Disabled, 1: Enabled) | `0`, `1` |
| **Advanced_SetWinInetProtocols** | Write | String | Turn off encryption support (0: Disabled, 1: Enabled) | `0`, `1` |
| **Advanced_WinInetProtocolOptions** | Write | String | Secure Protocol combinations - Depends on Advanced_SetWinInetProtocols (0: Use no secure protocols, 8: Only use SSL 2.0, 32: Only use SSL 3.0, 40: Use SSL 2.0 and SSL 3.0, 128: Only use TLS 1.0, 136: Use SSL 2.0 and TLS 1.0, 160: Use SSL 3.0 and TLS 1.0, 168: Use SSL 2.0, SSL 3.0, and TLS 1.0, 512: Only use TLS 1.1, 520: Use SSL 2.0 and TLS 1.1, 544: Use SSL 3.0 and TLS 1.1, 552: Use SSL 2.0, SSL 3.0, and TLS 1.1, 640: Use TLS 1.0 and TLS 1.1, 648: Use SSL 2.0, TLS 1.0, and TLS 1.1, 672: Use SSL 3.0, TLS 1.0, and TLS 1.1, 680: Use SSL 2.0, SSL 3.0, TLS 1.0, and TLS 1.1, 2048: Only use TLS 1.2, 2056: Use SSL 2.0 and TLS 1.2, 2080: Use SSL 3.0 and TLS 1.2, 2088: Use SSL 2.0, SSL 3.0, and TLS 1.2, 2176: Use TLS 1.0 and TLS 1.2, 2184: Use SSL 2.0, TLS 1.0, and TLS 1.2, 2208: Use SSL 3.0, TLS 1.0, and TLS 1.2, 2216: Use SSL 2.0, SSL 3.0, TLS 1.0, and TLS 1.2, 2560: Use TLS 1.1 and TLS 1.2, 2568: Use SSL 2.0, TLS 1.1, and TLS 1.2, 2592: Use SSL 3.0, TLS 1.1, and TLS 1.2, 2600: Use SSL 2.0, SSL 3.0, TLS 1.1, and TLS 1.2, 2688: Use TLS 1.0, TLS 1.1, and TLS 1.2, 2696: Use SSL 2.0, TLS 1.0, TLS 1.1, and TLS 1.2, 2720: Use SSL 3.0, TLS 1.0, TLS 1.1, and TLS 1.2, 2728: Use SSL 2.0, SSL 3.0, TLS 1.0, TLS 1.1, and TLS 1.2, 8192: Only use TLS 1.3, 10240: Use TLS 1.2 and TLS 1.3, 10752: Use TLS 1.1, TLS 1.2, and TLS 1.3, 10880: Use TLS 1.0, TLS 1.1, TLS 1.2, and TLS 1.3, 10912: Use SSL 3.0, TLS 1.0, TLS 1.1, TLS 1.2, and TLS 1.3) | `0`, `8`, `32`, `40`, `128`, `136`, `160`, `168`, `512`, `520`, `544`, `552`, `640`, `648`, `672`, `680`, `2048`, `2056`, `2080`, `2088`, `2176`, `2184`, `2208`, `2216`, `2560`, `2568`, `2592`, `2600`, `2688`, `2696`, `2720`, `2728`, `8192`, `10240`, `10752`, `10880`, `10912` |
| **Advanced_EnableEnhancedProtectedMode64Bit** | Write | String | Turn on 64-bit tab processes when running in Enhanced Protected Mode on 64-bit versions of Windows (0: Disabled, 1: Enabled) | `0`, `1` |
| **Advanced_EnableEnhancedProtectedMode** | Write | String | Turn on Enhanced Protected Mode (0: Disabled, 1: Enabled) | `0`, `1` |
| **NoCertError** | Write | String | Prevent ignoring certificate errors (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyAccessDataSourcesAcrossDomains_1** | Write | String | Access data sources across domains (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyAccessDataSourcesAcrossDomains_1_IZ_Partname1406** | Write | String | Access data sources across domains - Depends on IZ_PolicyAccessDataSourcesAcrossDomains_1 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_PolicyAllowPasteViaScript_1** | Write | String | Allow cut, copy or paste operations from the clipboard via script (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyAllowPasteViaScript_1_IZ_Partname1407** | Write | String | Allow paste operations via script - Depends on IZ_PolicyAllowPasteViaScript_1 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_PolicyDropOrPasteFiles_1** | Write | String | Allow drag and drop or copy and paste files (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyDropOrPasteFiles_1_IZ_Partname1802** | Write | String | Allow drag and drop or copy and paste files - Depends on IZ_PolicyDropOrPasteFiles_1 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_Policy_XAML_1** | Write | String | Allow loading of XAML files (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_Policy_XAML_1_IZ_Partname2402** | Write | String | XAML Files - Depends on IZ_Policy_XAML_1 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_PolicyOnlyAllowApprovedDomainsToUseActiveXWithoutPrompt_Both_Internet** | Write | String | Allow only approved domains to use ActiveX controls without prompt (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyOnlyAllowApprovedDomainsToUseActiveXWithoutPrompt_Both_Internet_IZ_Partname120b** | Write | String | Only allow approved domains to use ActiveX controls without prompt - Depends on IZ_PolicyOnlyAllowApprovedDomainsToUseActiveXWithoutPrompt_Both_Internet (3: Enable, 0: Disable) | `3`, `0` |
| **IZ_PolicyAllowTDCControl_Both_Internet** | Write | String | Allow only approved domains to use the TDC ActiveX control (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyAllowTDCControl_Both_Internet_IZ_Partname120c** | Write | String | Only allow approved domains to use the TDC ActiveX control - Depends on IZ_PolicyAllowTDCControl_Both_Internet (3: Enable, 0: Disable) | `3`, `0` |
| **IZ_PolicyWindowsRestrictionsURLaction_1** | Write | String | Allow script-initiated windows without size or position constraints (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyWindowsRestrictionsURLaction_1_IZ_Partname2102** | Write | String | Allow script-initiated windows without size or position constraints - Depends on IZ_PolicyWindowsRestrictionsURLaction_1 (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_Policy_WebBrowserControl_1** | Write | String | Allow scripting of Internet Explorer WebBrowser controls (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_Policy_WebBrowserControl_1_IZ_Partname1206** | Write | String | Internet Explorer web browser control - Depends on IZ_Policy_WebBrowserControl_1 (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_Policy_AllowScriptlets_1** | Write | String | Allow scriptlets (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_Policy_AllowScriptlets_1_IZ_Partname1209** | Write | String | Scriptlets - Depends on IZ_Policy_AllowScriptlets_1 (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_Policy_ScriptStatusBar_1** | Write | String | Allow updates to status bar via script (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_Policy_ScriptStatusBar_1_IZ_Partname2103** | Write | String | Status bar updates via script - Depends on IZ_Policy_ScriptStatusBar_1 (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_PolicyAllowVBScript_1** | Write | String | Allow VBScript to run in Internet Explorer (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyAllowVBScript_1_IZ_Partname140C** | Write | String | Allow VBScript to run in Internet Explorer - Depends on IZ_PolicyAllowVBScript_1 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_PolicyNotificationBarDownloadURLaction_1** | Write | String | Automatic prompting for file downloads (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyNotificationBarDownloadURLaction_1_IZ_Partname2200** | Write | String | Automatic prompting for file downloads - Depends on IZ_PolicyNotificationBarDownloadURLaction_1 (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_PolicyAntiMalwareCheckingOfActiveXControls_1** | Write | String | Don't run antimalware programs against ActiveX controls (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyAntiMalwareCheckingOfActiveXControls_1_IZ_Partname270C** | Write | String | Don't run antimalware programs against ActiveX controls - Depends on IZ_PolicyAntiMalwareCheckingOfActiveXControls_1 (3: Enable, 0: Disable) | `3`, `0` |
| **IZ_PolicyDownloadSignedActiveX_1** | Write | String | Download signed ActiveX controls (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyDownloadSignedActiveX_1_IZ_Partname1001** | Write | String | Download signed ActiveX controls - Depends on IZ_PolicyDownloadSignedActiveX_1 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_PolicyDownloadUnsignedActiveX_1** | Write | String | Download unsigned ActiveX controls (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyDownloadUnsignedActiveX_1_IZ_Partname1004** | Write | String | Download unsigned ActiveX controls - Depends on IZ_PolicyDownloadUnsignedActiveX_1 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_PolicyDragDropAcrossDomainsAcrossWindows_Both_Internet** | Write | String | Enable dragging of content from different domains across windows (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyDragDropAcrossDomainsAcrossWindows_Both_Internet_IZ_Partname2709** | Write | String | Enable dragging of content from different domains across windows - Depends on IZ_PolicyDragDropAcrossDomainsAcrossWindows_Both_Internet (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_PolicyDragDropAcrossDomainsWithinWindow_Both_Internet** | Write | String | Enable dragging of content from different domains within a window (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyDragDropAcrossDomainsWithinWindow_Both_Internet_IZ_Partname2708** | Write | String | Enable dragging of content from different domains within a window - Depends on IZ_PolicyDragDropAcrossDomainsWithinWindow_Both_Internet (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_Policy_LocalPathForUpload_1** | Write | String | Include local path when user is uploading files to a server (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_Policy_LocalPathForUpload_1_IZ_Partname160A** | Write | String | Include local directory path when uploading files to a server - Depends on IZ_Policy_LocalPathForUpload_1 (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_PolicyScriptActiveXNotMarkedSafe_1** | Write | String | Initialize and script ActiveX controls not marked as safe (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyScriptActiveXNotMarkedSafe_1_IZ_Partname1201** | Write | String | Initialize and script ActiveX controls not marked as safe - Depends on IZ_PolicyScriptActiveXNotMarkedSafe_1 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_PolicyJavaPermissions_1** | Write | String | Java permissions (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyJavaPermissions_1_IZ_Partname1C00** | Write | String | Java permissions - Depends on IZ_PolicyJavaPermissions_1 (65536: High safety, 131072: Medium safety, 196608: Low safety, 8388608: Custom, 0: Disable Java) | `65536`, `131072`, `196608`, `8388608`, `0` |
| **IZ_PolicyLaunchAppsAndFilesInIFRAME_1** | Write | String | Launching applications and files in an IFRAME (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyLaunchAppsAndFilesInIFRAME_1_IZ_Partname1804** | Write | String | Launching applications and files in an IFRAME - Depends on IZ_PolicyLaunchAppsAndFilesInIFRAME_1 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_PolicyLogon_1** | Write | String | Logon options (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyLogon_1_IZ_Partname1A00** | Write | String | Logon options - Depends on IZ_PolicyLogon_1 (196608: Anonymous logon, 131072: Automatic logon only in Intranet zone, 0: Automatic logon with current username and password, 65536: Prompt for user name and password) | `196608`, `131072`, `0`, `65536` |
| **IZ_PolicyNavigateSubframesAcrossDomains_1** | Write | String | Navigate windows and frames across different domains (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyNavigateSubframesAcrossDomains_1_IZ_Partname1607** | Write | String | Navigate windows and frames across different domains - Depends on IZ_PolicyNavigateSubframesAcrossDomains_1 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_PolicyUnsignedFrameworkComponentsURLaction_1** | Write | String | Run .NET Framework-reliant components not signed with Authenticode (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyUnsignedFrameworkComponentsURLaction_1_IZ_Partname2004** | Write | String | Run .NET Framework-reliant components not signed with Authenticode - Depends on IZ_PolicyUnsignedFrameworkComponentsURLaction_1 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_PolicySignedFrameworkComponentsURLaction_1** | Write | String | Run .NET Framework-reliant components signed with Authenticode (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicySignedFrameworkComponentsURLaction_1_IZ_Partname2001** | Write | String | Run .NET Framework-reliant components signed with Authenticode - Depends on IZ_PolicySignedFrameworkComponentsURLaction_1 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_Policy_UnsafeFiles_1** | Write | String | Show security warning for potentially unsafe files (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_Policy_UnsafeFiles_1_IZ_Partname1806** | Write | String | Launching programs and unsafe files - Depends on IZ_Policy_UnsafeFiles_1 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_PolicyTurnOnXSSFilter_Both_Internet** | Write | String | Turn on Cross-Site Scripting Filter (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyTurnOnXSSFilter_Both_Internet_IZ_Partname1409** | Write | String | Turn on Cross-Site Scripting (XSS) Filter - Depends on IZ_PolicyTurnOnXSSFilter_Both_Internet (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_Policy_TurnOnProtectedMode_1** | Write | String | Turn on Protected Mode (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_Policy_TurnOnProtectedMode_1_IZ_Partname2500** | Write | String | Protected Mode - Depends on IZ_Policy_TurnOnProtectedMode_1 (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_Policy_Phishing_1** | Write | String | Turn on SmartScreen Filter scan (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_Policy_Phishing_1_IZ_Partname2301** | Write | String | Use SmartScreen Filter - Depends on IZ_Policy_Phishing_1 (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_PolicyBlockPopupWindows_1** | Write | String | Use Pop-up Blocker (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyBlockPopupWindows_1_IZ_Partname1809** | Write | String | Use Pop-up Blocker - Depends on IZ_PolicyBlockPopupWindows_1 (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_PolicyUserdataPersistence_1** | Write | String | Userdata persistence (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyUserdataPersistence_1_IZ_Partname1606** | Write | String | Userdata persistence - Depends on IZ_PolicyUserdataPersistence_1 (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_PolicyZoneElevationURLaction_1** | Write | String | Web sites in less privileged Web content zones can navigate into this zone (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyZoneElevationURLaction_1_IZ_Partname2101** | Write | String | Web sites in less privileged Web content zones can navigate into this zone - Depends on IZ_PolicyZoneElevationURLaction_1 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_UNCAsIntranet** | Write | String | Intranet Sites: Include all network paths (UNCs) (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyAntiMalwareCheckingOfActiveXControls_3** | Write | String | Don't run antimalware programs against ActiveX controls (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyAntiMalwareCheckingOfActiveXControls_3_IZ_Partname270C** | Write | String | Don't run antimalware programs against ActiveX controls - Depends on IZ_PolicyAntiMalwareCheckingOfActiveXControls_3 (3: Enable, 0: Disable) | `3`, `0` |
| **IZ_PolicyScriptActiveXNotMarkedSafe_3** | Write | String | Initialize and script ActiveX controls not marked as safe (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyScriptActiveXNotMarkedSafe_3_IZ_Partname1201** | Write | String | Initialize and script ActiveX controls not marked as safe - Depends on IZ_PolicyScriptActiveXNotMarkedSafe_3 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_PolicyJavaPermissions_3** | Write | String | Java permissions (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyJavaPermissions_3_IZ_Partname1C00** | Write | String | Java permissions - Depends on IZ_PolicyJavaPermissions_3 (65536: High safety, 131072: Medium safety, 196608: Low safety, 8388608: Custom, 0: Disable Java) | `65536`, `131072`, `196608`, `8388608`, `0` |
| **IZ_PolicyAntiMalwareCheckingOfActiveXControls_9** | Write | String | Don't run antimalware programs against ActiveX controls (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyAntiMalwareCheckingOfActiveXControls_9_IZ_Partname270C** | Write | String | Don't run antimalware programs against ActiveX controls - Depends on IZ_PolicyAntiMalwareCheckingOfActiveXControls_9 (3: Enable, 0: Disable) | `3`, `0` |
| **IZ_PolicyJavaPermissions_9** | Write | String | Java permissions (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyJavaPermissions_9_IZ_Partname1C00** | Write | String | Java permissions - Depends on IZ_PolicyJavaPermissions_9 (65536: High safety, 131072: Medium safety, 196608: Low safety, 8388608: Custom, 0: Disable Java) | `65536`, `131072`, `196608`, `8388608`, `0` |
| **IZ_Policy_Phishing_2** | Write | String | Turn on SmartScreen Filter scan (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_Policy_Phishing_2_IZ_Partname2301** | Write | String | Use SmartScreen Filter - Depends on IZ_Policy_Phishing_2 (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_PolicyJavaPermissions_4** | Write | String | Java permissions (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyJavaPermissions_4_IZ_Partname1C00** | Write | String | Java permissions - Depends on IZ_PolicyJavaPermissions_4 (65536: High safety, 131072: Medium safety, 196608: Low safety, 8388608: Custom, 0: Disable Java) | `65536`, `131072`, `196608`, `8388608`, `0` |
| **IZ_PolicyJavaPermissions_10** | Write | String | Java permissions (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyJavaPermissions_10_IZ_Partname1C00** | Write | String | Java permissions - Depends on IZ_PolicyJavaPermissions_10 (65536: High safety, 131072: Medium safety, 196608: Low safety, 8388608: Custom, 0: Disable Java) | `65536`, `131072`, `196608`, `8388608`, `0` |
| **IZ_PolicyJavaPermissions_8** | Write | String | Java permissions (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyJavaPermissions_8_IZ_Partname1C00** | Write | String | Java permissions - Depends on IZ_PolicyJavaPermissions_8 (65536: High safety, 131072: Medium safety, 196608: Low safety, 8388608: Custom, 0: Disable Java) | `65536`, `131072`, `196608`, `8388608`, `0` |
| **IZ_Policy_Phishing_8** | Write | String | Turn on SmartScreen Filter scan (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_Policy_Phishing_8_IZ_Partname2301** | Write | String | Use SmartScreen Filter - Depends on IZ_Policy_Phishing_8 (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_PolicyJavaPermissions_6** | Write | String | Java permissions (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyJavaPermissions_6_IZ_Partname1C00** | Write | String | Java permissions - Depends on IZ_PolicyJavaPermissions_6 (65536: High safety, 131072: Medium safety, 196608: Low safety, 8388608: Custom, 0: Disable Java) | `65536`, `131072`, `196608`, `8388608`, `0` |
| **IZ_PolicyAccessDataSourcesAcrossDomains_7** | Write | String | Access data sources across domains (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyAccessDataSourcesAcrossDomains_7_IZ_Partname1406** | Write | String | Access data sources across domains - Depends on IZ_PolicyAccessDataSourcesAcrossDomains_7 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_PolicyActiveScripting_7** | Write | String | Allow active scripting (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_Partname1400** | Write | String | Allow active scripting - Depends on IZ_PolicyActiveScripting_7 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_PolicyBinaryBehaviors_7** | Write | String | Allow binary and script behaviors (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_Partname2000** | Write | String | Allow Binary and Script Behaviors - Depends on IZ_PolicyBinaryBehaviors_7 (0: Enable, 65536: Administrator approved, 3: Disable) | `0`, `65536`, `3` |
| **IZ_PolicyAllowPasteViaScript_7** | Write | String | Allow cut, copy or paste operations from the clipboard via script (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyAllowPasteViaScript_7_IZ_Partname1407** | Write | String | Allow paste operations via script - Depends on IZ_PolicyAllowPasteViaScript_7 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_PolicyDropOrPasteFiles_7** | Write | String | Allow drag and drop or copy and paste files (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyDropOrPasteFiles_7_IZ_Partname1802** | Write | String | Allow drag and drop or copy and paste files - Depends on IZ_PolicyDropOrPasteFiles_7 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_PolicyFileDownload_7** | Write | String | Allow file downloads (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_Partname1803** | Write | String | Allow file downloads - Depends on IZ_PolicyFileDownload_7 (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_Policy_XAML_7** | Write | String | Allow loading of XAML files (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_Policy_XAML_7_IZ_Partname2402** | Write | String | XAML Files - Depends on IZ_Policy_XAML_7 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_PolicyAllowMETAREFRESH_7** | Write | String | Allow META REFRESH (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_Partname1608** | Write | String | Allow META REFRESH - Depends on IZ_PolicyAllowMETAREFRESH_7 (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_PolicyOnlyAllowApprovedDomainsToUseActiveXWithoutPrompt_Both_Restricted** | Write | String | Allow only approved domains to use ActiveX controls without prompt (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyOnlyAllowApprovedDomainsToUseActiveXWithoutPrompt_Both_Restricted_IZ_Partname120b** | Write | String | Only allow approved domains to use ActiveX controls without prompt - Depends on IZ_PolicyOnlyAllowApprovedDomainsToUseActiveXWithoutPrompt_Both_Restricted (3: Enable, 0: Disable) | `3`, `0` |
| **IZ_PolicyAllowTDCControl_Both_Restricted** | Write | String | Allow only approved domains to use the TDC ActiveX control (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyAllowTDCControl_Both_Restricted_IZ_Partname120c** | Write | String | Only allow approved domains to use the TDC ActiveX control - Depends on IZ_PolicyAllowTDCControl_Both_Restricted (3: Enable, 0: Disable) | `3`, `0` |
| **IZ_PolicyWindowsRestrictionsURLaction_7** | Write | String | Allow script-initiated windows without size or position constraints (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyWindowsRestrictionsURLaction_7_IZ_Partname2102** | Write | String | Allow script-initiated windows without size or position constraints - Depends on IZ_PolicyWindowsRestrictionsURLaction_7 (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_Policy_WebBrowserControl_7** | Write | String | Allow scripting of Internet Explorer WebBrowser controls (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_Policy_WebBrowserControl_7_IZ_Partname1206** | Write | String | Internet Explorer web browser control - Depends on IZ_Policy_WebBrowserControl_7 (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_Policy_AllowScriptlets_7** | Write | String | Allow scriptlets (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_Policy_AllowScriptlets_7_IZ_Partname1209** | Write | String | Scriptlets - Depends on IZ_Policy_AllowScriptlets_7 (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_Policy_ScriptStatusBar_7** | Write | String | Allow updates to status bar via script (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_Policy_ScriptStatusBar_7_IZ_Partname2103** | Write | String | Status bar updates via script - Depends on IZ_Policy_ScriptStatusBar_7 (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_PolicyAllowVBScript_7** | Write | String | Allow VBScript to run in Internet Explorer (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyAllowVBScript_7_IZ_Partname140C** | Write | String | Allow VBScript to run in Internet Explorer - Depends on IZ_PolicyAllowVBScript_7 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_PolicyNotificationBarDownloadURLaction_7** | Write | String | Automatic prompting for file downloads (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyNotificationBarDownloadURLaction_7_IZ_Partname2200** | Write | String | Automatic prompting for file downloads - Depends on IZ_PolicyNotificationBarDownloadURLaction_7 (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_PolicyAntiMalwareCheckingOfActiveXControls_7** | Write | String | Don't run antimalware programs against ActiveX controls (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyAntiMalwareCheckingOfActiveXControls_7_IZ_Partname270C** | Write | String | Don't run antimalware programs against ActiveX controls - Depends on IZ_PolicyAntiMalwareCheckingOfActiveXControls_7 (3: Enable, 0: Disable) | `3`, `0` |
| **IZ_PolicyDownloadSignedActiveX_7** | Write | String | Download signed ActiveX controls (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyDownloadSignedActiveX_7_IZ_Partname1001** | Write | String | Download signed ActiveX controls - Depends on IZ_PolicyDownloadSignedActiveX_7 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_PolicyDownloadUnsignedActiveX_7** | Write | String | Download unsigned ActiveX controls (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyDownloadUnsignedActiveX_7_IZ_Partname1004** | Write | String | Download unsigned ActiveX controls - Depends on IZ_PolicyDownloadUnsignedActiveX_7 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_PolicyDragDropAcrossDomainsAcrossWindows_Both_Restricted** | Write | String | Enable dragging of content from different domains across windows (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyDragDropAcrossDomainsAcrossWindows_Both_Restricted_IZ_Partname2709** | Write | String | Enable dragging of content from different domains across windows - Depends on IZ_PolicyDragDropAcrossDomainsAcrossWindows_Both_Restricted (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_PolicyDragDropAcrossDomainsWithinWindow_Both_Restricted** | Write | String | Enable dragging of content from different domains within a window (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyDragDropAcrossDomainsWithinWindow_Both_Restricted_IZ_Partname2708** | Write | String | Enable dragging of content from different domains within a window - Depends on IZ_PolicyDragDropAcrossDomainsWithinWindow_Both_Restricted (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_Policy_LocalPathForUpload_7** | Write | String | Include local path when user is uploading files to a server (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_Policy_LocalPathForUpload_7_IZ_Partname160A** | Write | String | Include local directory path when uploading files to a server - Depends on IZ_Policy_LocalPathForUpload_7 (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_PolicyScriptActiveXNotMarkedSafe_7** | Write | String | Initialize and script ActiveX controls not marked as safe (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyScriptActiveXNotMarkedSafe_7_IZ_Partname1201** | Write | String | Initialize and script ActiveX controls not marked as safe - Depends on IZ_PolicyScriptActiveXNotMarkedSafe_7 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_PolicyJavaPermissions_7** | Write | String | Java permissions (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyJavaPermissions_7_IZ_Partname1C00** | Write | String | Java permissions - Depends on IZ_PolicyJavaPermissions_7 (65536: High safety, 131072: Medium safety, 196608: Low safety, 8388608: Custom, 0: Disable Java) | `65536`, `131072`, `196608`, `8388608`, `0` |
| **IZ_PolicyLaunchAppsAndFilesInIFRAME_7** | Write | String | Launching applications and files in an IFRAME (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyLaunchAppsAndFilesInIFRAME_7_IZ_Partname1804** | Write | String | Launching applications and files in an IFRAME - Depends on IZ_PolicyLaunchAppsAndFilesInIFRAME_7 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_PolicyLogon_7** | Write | String | Logon options (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyLogon_7_IZ_Partname1A00** | Write | String | Logon options - Depends on IZ_PolicyLogon_7 (196608: Anonymous logon, 131072: Automatic logon only in Intranet zone, 0: Automatic logon with current username and password, 65536: Prompt for user name and password) | `196608`, `131072`, `0`, `65536` |
| **IZ_PolicyNavigateSubframesAcrossDomains_7** | Write | String | Navigate windows and frames across different domains (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyNavigateSubframesAcrossDomains_7_IZ_Partname1607** | Write | String | Navigate windows and frames across different domains - Depends on IZ_PolicyNavigateSubframesAcrossDomains_7 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_PolicyUnsignedFrameworkComponentsURLaction_7** | Write | String | Run .NET Framework-reliant components not signed with Authenticode (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyUnsignedFrameworkComponentsURLaction_7_IZ_Partname2004** | Write | String | Run .NET Framework-reliant components not signed with Authenticode - Depends on IZ_PolicyUnsignedFrameworkComponentsURLaction_7 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_PolicySignedFrameworkComponentsURLaction_7** | Write | String | Run .NET Framework-reliant components signed with Authenticode (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicySignedFrameworkComponentsURLaction_7_IZ_Partname2001** | Write | String | Run .NET Framework-reliant components signed with Authenticode - Depends on IZ_PolicySignedFrameworkComponentsURLaction_7 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_PolicyRunActiveXControls_7** | Write | String | Run ActiveX controls and plugins (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_Partname1200** | Write | String | Run ActiveX controls and plugins - Depends on IZ_PolicyRunActiveXControls_7 (65536: Administrator approved, 0: Enable, 3: Disable, 1: Prompt) | `65536`, `0`, `3`, `1` |
| **IZ_PolicyScriptActiveXMarkedSafe_7** | Write | String | Script ActiveX controls marked safe for scripting (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_Partname1405** | Write | String | Script ActiveX controls marked safe for scripting - Depends on IZ_PolicyScriptActiveXMarkedSafe_7 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_PolicyScriptingOfJavaApplets_7** | Write | String | Scripting of Java applets (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_Partname1402** | Write | String | Scripting of Java applets - Depends on IZ_PolicyScriptingOfJavaApplets_7 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_Policy_UnsafeFiles_7** | Write | String | Show security warning for potentially unsafe files (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_Policy_UnsafeFiles_7_IZ_Partname1806** | Write | String | Launching programs and unsafe files - Depends on IZ_Policy_UnsafeFiles_7 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_PolicyTurnOnXSSFilter_Both_Restricted** | Write | String | Turn on Cross-Site Scripting Filter (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyTurnOnXSSFilter_Both_Restricted_IZ_Partname1409** | Write | String | Turn on Cross-Site Scripting (XSS) Filter - Depends on IZ_PolicyTurnOnXSSFilter_Both_Restricted (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_Policy_TurnOnProtectedMode_7** | Write | String | Turn on Protected Mode (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_Policy_TurnOnProtectedMode_7_IZ_Partname2500** | Write | String | Protected Mode - Depends on IZ_Policy_TurnOnProtectedMode_7 (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_Policy_Phishing_7** | Write | String | Turn on SmartScreen Filter scan (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_Policy_Phishing_7_IZ_Partname2301** | Write | String | Use SmartScreen Filter - Depends on IZ_Policy_Phishing_7 (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_PolicyBlockPopupWindows_7** | Write | String | Use Pop-up Blocker (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyBlockPopupWindows_7_IZ_Partname1809** | Write | String | Use Pop-up Blocker - Depends on IZ_PolicyBlockPopupWindows_7 (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_PolicyUserdataPersistence_7** | Write | String | Userdata persistence (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyUserdataPersistence_7_IZ_Partname1606** | Write | String | Userdata persistence - Depends on IZ_PolicyUserdataPersistence_7 (0: Enable, 3: Disable) | `0`, `3` |
| **IZ_PolicyZoneElevationURLaction_7** | Write | String | Web sites in less privileged Web content zones can navigate into this zone (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyZoneElevationURLaction_7_IZ_Partname2101** | Write | String | Web sites in less privileged Web content zones can navigate into this zone - Depends on IZ_PolicyZoneElevationURLaction_7 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_PolicyAntiMalwareCheckingOfActiveXControls_5** | Write | String | Don't run antimalware programs against ActiveX controls (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyAntiMalwareCheckingOfActiveXControls_5_IZ_Partname270C** | Write | String | Don't run antimalware programs against ActiveX controls - Depends on IZ_PolicyAntiMalwareCheckingOfActiveXControls_5 (3: Enable, 0: Disable) | `3`, `0` |
| **IZ_PolicyScriptActiveXNotMarkedSafe_5** | Write | String | Initialize and script ActiveX controls not marked as safe (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyScriptActiveXNotMarkedSafe_5_IZ_Partname1201** | Write | String | Initialize and script ActiveX controls not marked as safe - Depends on IZ_PolicyScriptActiveXNotMarkedSafe_5 (0: Enable, 3: Disable, 1: Prompt) | `0`, `3`, `1` |
| **IZ_PolicyJavaPermissions_5** | Write | String | Java permissions (0: Disabled, 1: Enabled) | `0`, `1` |
| **IZ_PolicyJavaPermissions_5_IZ_Partname1C00** | Write | String | Java permissions - Depends on IZ_PolicyJavaPermissions_5 (65536: High safety, 131072: Medium safety, 196608: Low safety, 8388608: Custom, 0: Disable Java) | `65536`, `131072`, `196608`, `8388608`, `0` |
| **IZ_PolicyWarnCertMismatch** | Write | String | Turn on certificate address mismatch warning (0: Disabled, 1: Enabled) | `0`, `1` |
| **DisableSafetyFilterOverride** | Write | String | Prevent bypassing SmartScreen Filter warnings (0: Disabled, 1: Enabled) | `0`, `1` |
| **DisableSafetyFilterOverrideForAppRepUnknown** | Write | String | Prevent bypassing SmartScreen Filter warnings about files that are not commonly downloaded from the Internet (0: Disabled, 1: Enabled) | `0`, `1` |
| **Disable_Managing_Safety_Filter_IE9** | Write | String | Prevent managing SmartScreen Filter (0: Disabled, 1: Enabled) | `0`, `1` |
| **IE9SafetyFilterOptions** | Write | String | Select SmartScreen Filter mode - Depends on Disable_Managing_Safety_Filter_IE9 (0: Off, 1: On) | `0`, `1` |
| **DisablePerUserActiveXInstall** | Write | String | Prevent per-user installation of ActiveX controls (0: Disabled, 1: Enabled) | `0`, `1` |
| **VerMgmtDisableRunThisTime** | Write | String | Remove 'Run this time' button for outdated ActiveX controls in Internet Explorer (0: Disabled, 1: Enabled) | `0`, `1` |
| **VerMgmtDisable** | Write | String | Turn off blocking of outdated ActiveX controls for Internet Explorer (0: Disabled, 1: Enabled) | `0`, `1` |
| **Advanced_EnableSSL3Fallback** | Write | String | Allow fallback to SSL 3.0 (Internet Explorer) (0: Disabled, 1: Enabled) | `0`, `1` |
| **Advanced_EnableSSL3FallbackOptions** | Write | String | Allow insecure fallback for: - Depends on Advanced_EnableSSL3Fallback (0: No Sites, 1: Non-Protected Mode Sites, 3: All Sites) | `0`, `1`, `3` |
| **IESF_PolicyExplorerProcesses_5** | Write | String | Internet Explorer Processes (0: Disabled, 1: Enabled) | `0`, `1` |
| **IESF_PolicyExplorerProcesses_6** | Write | String | Internet Explorer Processes (0: Disabled, 1: Enabled) | `0`, `1` |
| **IESF_PolicyExplorerProcesses_3** | Write | String | Internet Explorer Processes (0: Disabled, 1: Enabled) | `0`, `1` |
| **IESF_PolicyExplorerProcesses_10** | Write | String | Internet Explorer Processes (0: Disabled, 1: Enabled) | `0`, `1` |
| **IESF_PolicyExplorerProcesses_9** | Write | String | Internet Explorer Processes (0: Disabled, 1: Enabled) | `0`, `1` |
| **IESF_PolicyExplorerProcesses_11** | Write | String | Internet Explorer Processes (0: Disabled, 1: Enabled) | `0`, `1` |
| **IESF_PolicyExplorerProcesses_12** | Write | String | Internet Explorer Processes (0: Disabled, 1: Enabled) | `0`, `1` |
| **IESF_PolicyExplorerProcesses_8** | Write | String | Internet Explorer Processes (0: Disabled, 1: Enabled) | `0`, `1` |
| **Security_zones_map_edit** | Write | String | Security Zones: Do not allow users to add/delete sites (0: Disabled, 1: Enabled) | `0`, `1` |
| **Security_options_edit** | Write | String | Security Zones: Do not allow users to change policies (0: Disabled, 1: Enabled) | `0`, `1` |
| **Security_HKLM_only** | Write | String | Security Zones: Use only machine settings (0: Disabled, 1: Enabled) | `0`, `1` |
| **OnlyUseAXISForActiveXInstall** | Write | String | Specify use of ActiveX Installer Service for installation of ActiveX controls (0: Disabled, 1: Enabled) | `0`, `1` |
| **AddonManagement_RestrictCrashDetection** | Write | String | Turn off Crash Detection (0: Disabled, 1: Enabled) | `0`, `1` |
| **Disable_Security_Settings_Check** | Write | String | Turn off the Security Settings Check feature (0: Disabled, 1: Enabled) | `0`, `1` |
| **DisableBlockAtFirstSeen** | Write | String | Configure the 'Block at First Sight' feature (0: Disabled, 1: Enabled) | `0`, `1` |
| **RealtimeProtection_DisableScanOnRealtimeEnable** | Write | String | Turn on process scanning whenever real-time protection is enabled (0: Disabled, 1: Enabled) | `0`, `1` |
| **Scan_DisablePackedExeScanning** | Write | String | Scan packed executables (0: Disabled, 1: Enabled) | `0`, `1` |
| **DisableRoutinelyTakingAction** | Write | String | Turn off routine remediation (0: Disabled, 1: Enabled) | `0`, `1` |
| **TS_CLIENT_DISABLE_PASSWORD_SAVING_2** | Write | String | Do not allow passwords to be saved (0: Disabled, 1: Enabled) | `0`, `1` |
| **TS_CLIENT_DRIVE_M** | Write | String | Do not allow drive redirection (0: Disabled, 1: Enabled) | `0`, `1` |
| **TS_PASSWORD** | Write | String | Always prompt for password upon connection (0: Disabled, 1: Enabled) | `0`, `1` |
| **TS_RPC_ENCRYPTION** | Write | String | Require secure RPC communication (0: Disabled, 1: Enabled) | `0`, `1` |
| **TS_ENCRYPTION_POLICY** | Write | String | Set client connection encryption level (0: Disabled, 1: Enabled) | `0`, `1` |
| **TS_ENCRYPTION_LEVEL** | Write | String | Encryption Level - Depends on TS_ENCRYPTION_POLICY (1: Low Level, 2: Client Compatible, 3: High Level) | `1`, `2`, `3` |
| **Disable_Downloading_of_Enclosures** | Write | String | Prevent downloading of enclosures (0: Disabled, 1: Enabled) | `0`, `1` |
| **EnableMPRNotifications** | Write | String | Enable MPR notifications for the system (0: Disabled, 1: Enabled) | `0`, `1` |
| **AutomaticRestartSignOn** | Write | String | Sign-in and lock last interactive user automatically after a restart (0: Disabled, 1: Enabled) | `0`, `1` |
| **EnableScriptBlockLogging** | Write | String | Turn on PowerShell Script Block Logging (0: Disabled, 1: Enabled) | `0`, `1` |
| **EnableScriptBlockInvocationLogging** | Write | String | Log script block invocation start / stop events: - Depends on EnableScriptBlockLogging (0: False, 1: True) | `0`, `1` |
| **AllowBasic_2** | Write | String | Allow Basic authentication (0: Disabled, 1: Enabled) | `0`, `1` |
| **AllowUnencrypted_2** | Write | String | Allow unencrypted traffic (0: Disabled, 1: Enabled) | `0`, `1` |
| **DisallowDigest** | Write | String | Disallow Digest authentication (0: Disabled, 1: Enabled) | `0`, `1` |
| **AllowBasic_1** | Write | String | Allow Basic authentication (0: Disabled, 1: Enabled) | `0`, `1` |
| **AllowUnencrypted_1** | Write | String | Allow unencrypted traffic (0: Disabled, 1: Enabled) | `0`, `1` |
| **DisableRunAs** | Write | String | Disallow WinRM from storing RunAs credentials (0: Disabled, 1: Enabled) | `0`, `1` |
| **AccountLogon_AuditCredentialValidation** | Write | String | Account Logon Audit Credential Validation (0: Off/None, 1: Success, 2: Failure, 3: Success+Failure) | `0`, `1`, `2`, `3` |
| **AccountLogonLogoff_AuditAccountLockout** | Write | String | Account Logon Logoff Audit Account Lockout (0: Off/None, 1: Success, 2: Failure, 3: Success+Failure) | `0`, `1`, `2`, `3` |
| **AccountLogonLogoff_AuditGroupMembership** | Write | String | Account Logon Logoff Audit Group Membership (0: Off/None, 1: Success, 2: Failure, 3: Success+Failure) | `0`, `1`, `2`, `3` |
| **AccountLogonLogoff_AuditLogon** | Write | String | Account Logon Logoff Audit Logon (0: Off/None, 1: Success, 2: Failure, 3: Success+Failure) | `0`, `1`, `2`, `3` |
| **PolicyChange_AuditAuthenticationPolicyChange** | Write | String | Audit Authentication Policy Change (0: Off/None, 1: Success, 2: Failure, 3: Success+Failure) | `0`, `1`, `2`, `3` |
| **PolicyChange_AuditPolicyChange** | Write | String | Audit Changes to Audit Policy (0: Off/None, 1: Success, 2: Failure, 3: Success+Failure) | `0`, `1`, `2`, `3` |
| **ObjectAccess_AuditFileShare** | Write | String | Audit File Share Access (0: Off/None, 1: Success, 2: Failure, 3: Success+Failure) | `0`, `1`, `2`, `3` |
| **AccountLogonLogoff_AuditOtherLogonLogoffEvents** | Write | String | Audit Other Logon Logoff Events (0: Off/None, 1: Success, 2: Failure, 3: Success+Failure) | `0`, `1`, `2`, `3` |
| **AccountManagement_AuditSecurityGroupManagement** | Write | String | Audit Security Group Management (0: Off/None, 1: Success, 2: Failure, 3: Success+Failure) | `0`, `1`, `2`, `3` |
| **System_AuditSecuritySystemExtension** | Write | String | Audit Security System Extension (0: Off/None, 1: Success, 2: Failure, 3: Success+Failure) | `0`, `1`, `2`, `3` |
| **AccountLogonLogoff_AuditSpecialLogon** | Write | String | Audit Special Logon (0: Off/None, 1: Success, 2: Failure, 3: Success+Failure) | `0`, `1`, `2`, `3` |
| **AccountManagement_AuditUserAccountManagement** | Write | String | Audit User Account Management (0: Off/None, 1: Success, 2: Failure, 3: Success+Failure) | `0`, `1`, `2`, `3` |
| **DetailedTracking_AuditPNPActivity** | Write | String | Detailed Tracking Audit PNP Activity (0: Off/None, 1: Success, 2: Failure, 3: Success+Failure) | `0`, `1`, `2`, `3` |
| **DetailedTracking_AuditProcessCreation** | Write | String | Detailed Tracking Audit Process Creation (0: Off/None, 1: Success, 2: Failure, 3: Success+Failure) | `0`, `1`, `2`, `3` |
| **ObjectAccess_AuditDetailedFileShare** | Write | String | Object Access Audit Detailed File Share (0: Off/None, 1: Success, 2: Failure, 3: Success+Failure) | `0`, `1`, `2`, `3` |
| **ObjectAccess_AuditOtherObjectAccessEvents** | Write | String | Object Access Audit Other Object Access Events (0: Off/None, 1: Success, 2: Failure, 3: Success+Failure) | `0`, `1`, `2`, `3` |
| **ObjectAccess_AuditRemovableStorage** | Write | String | Object Access Audit Removable Storage (0: Off/None, 1: Success, 2: Failure, 3: Success+Failure) | `0`, `1`, `2`, `3` |
| **PolicyChange_AuditMPSSVCRuleLevelPolicyChange** | Write | String | Policy Change Audit MPSSVC Rule Level Policy Change (0: Off/None, 1: Success, 2: Failure, 3: Success+Failure) | `0`, `1`, `2`, `3` |
| **PolicyChange_AuditOtherPolicyChangeEvents** | Write | String | Policy Change Audit Other Policy Change Events (0: Off/None, 1: Success, 2: Failure, 3: Success+Failure) | `0`, `1`, `2`, `3` |
| **PrivilegeUse_AuditSensitivePrivilegeUse** | Write | String | Privilege Use Audit Sensitive Privilege Use (0: Off/None, 1: Success, 2: Failure, 3: Success+Failure) | `0`, `1`, `2`, `3` |
| **System_AuditOtherSystemEvents** | Write | String | System Audit Other System Events (0: Off/None, 1: Success, 2: Failure, 3: Success+Failure) | `0`, `1`, `2`, `3` |
| **System_AuditSecurityStateChange** | Write | String | System Audit Security State Change (0: Off/None, 1: Success, 2: Failure, 3: Success+Failure) | `0`, `1`, `2`, `3` |
| **System_AuditSystemIntegrity** | Write | String | System Audit System Integrity (0: Off/None, 1: Success, 2: Failure, 3: Success+Failure) | `0`, `1`, `2`, `3` |
| **AllowPasswordManager** | Write | String | Allow Password Manager (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **AllowSmartScreen** | Write | String | Allow Smart Screen (0: Turned off. Do not protect users from potential threats and prevent users from turning it on., 1: Turned on. Protect users from potential threats and prevent users from turning it off.) | `0`, `1` |
| **PreventCertErrorOverrides** | Write | String | Prevent Cert Error Overrides (0: Allowed/turned on. Override the security warning to sites that have SSL errors., 1: Prevented/turned on.) | `0`, `1` |
| **Browser_PreventSmartScreenPromptOverride** | Write | String | Prevent Smart Screen Prompt Override (0: Allowed/turned off. Users can ignore the warning and continue to the site., 1: Prevented/turned on.) | `0`, `1` |
| **PreventSmartScreenPromptOverrideForFiles** | Write | String | Prevent Smart Screen Prompt Override For Files (0: Allowed/turned off. Users can ignore the warning and continue to download the unverified file(s)., 1: Prevented/turned on.) | `0`, `1` |
| **AllowDirectMemoryAccess** | Write | String | Allow Direct Memory Access (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **AllowArchiveScanning** | Write | String | Allow Archive Scanning (0: Not allowed. Turns off scanning on archived files., 1: Allowed. Scans the archive files.) | `0`, `1` |
| **AllowBehaviorMonitoring** | Write | String | Allow Behavior Monitoring (0: Not allowed. Turns off behavior monitoring., 1: Allowed. Turns on real-time behavior monitoring.) | `0`, `1` |
| **AllowCloudProtection** | Write | String | Allow Cloud Protection (0: Not allowed. Turns off the Microsoft Active Protection Service., 1: Allowed. Turns on the Microsoft Active Protection Service.) | `0`, `1` |
| **AllowFullScanRemovableDriveScanning** | Write | String | Allow Full Scan Removable Drive Scanning (0: Not allowed. Turns off scanning on removable drives., 1: Allowed. Scans removable drives.) | `0`, `1` |
| **AllowOnAccessProtection** | Write | String | Allow On Access Protection (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **AllowRealtimeMonitoring** | Write | String | Allow Realtime Monitoring (0: Not allowed. Turns off the real-time monitoring service., 1: Allowed. Turns on and runs the real-time monitoring service.) | `0`, `1` |
| **AllowIOAVProtection** | Write | String | Allow scanning of all downloaded files and attachments (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **AllowScriptScanning** | Write | String | Allow Script Scanning (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **BlockExecutionOfPotentiallyObfuscatedScripts** | Write | String | Block execution of potentially obfuscated scripts - Depends on AttackSurfaceReductionRules (off: Off, block: Block, audit: Audit, warn: Warn) | `off`, `block`, `audit`, `warn` |
| **BlockExecutionOfPotentiallyObfuscatedScripts_ASROnlyPerRuleExclusions** | Write | StringArray[] | ASR Only Per Rule Exclusions | |
| **BlockWin32APICallsFromOfficeMacros** | Write | String | Block Win32 API calls from Office macros - Depends on AttackSurfaceReductionRules (off: Off, block: Block, audit: Audit, warn: Warn) | `off`, `block`, `audit`, `warn` |
| **BlockWin32APICallsFromOfficeMacros_ASROnlyPerRuleExclusions** | Write | StringArray[] | ASR Only Per Rule Exclusions | |
| **BlockExecutableFilesRunningUnlessTheyMeetPrevalenceAgeTrustedListCriterion** | Write | String | Block executable files from running unless they meet a prevalence, age, or trusted list criterion - Depends on AttackSurfaceReductionRules (off: Off, block: Block, audit: Audit, warn: Warn) | `off`, `block`, `audit`, `warn` |
| **BlockExecutableFilesRunningUnlessTheyMeetPrevalenceAgeTrustedListCriterion_ASROnlyPerRuleExclusions** | Write | StringArray[] | ASR Only Per Rule Exclusions | |
| **BlockOfficeCommunicationAppFromCreatingChildProcesses** | Write | String | Block Office communication application from creating child processes - Depends on AttackSurfaceReductionRules (off: Off, block: Block, audit: Audit, warn: Warn) | `off`, `block`, `audit`, `warn` |
| **BlockOfficeCommunicationAppFromCreatingChildProcesses_ASROnlyPerRuleExclusions** | Write | StringArray[] | ASR Only Per Rule Exclusions | |
| **BlockAllOfficeApplicationsFromCreatingChildProcesses** | Write | String | Block all Office applications from creating child processes - Depends on AttackSurfaceReductionRules (off: Off, block: Block, audit: Audit, warn: Warn) | `off`, `block`, `audit`, `warn` |
| **BlockAllOfficeApplicationsFromCreatingChildProcesses_ASROnlyPerRuleExclusions** | Write | StringArray[] | ASR Only Per Rule Exclusions | |
| **BlockAdobeReaderFromCreatingChildProcesses** | Write | String | Block Adobe Reader from creating child processes - Depends on AttackSurfaceReductionRules (off: Off, block: Block, audit: Audit, warn: Warn) | `off`, `block`, `audit`, `warn` |
| **BlockAdobeReaderFromCreatingChildProcesses_ASROnlyPerRuleExclusions** | Write | StringArray[] | ASR Only Per Rule Exclusions | |
| **BlockCredentialStealingFromWindowsLocalSecurityAuthoritySubsystem** | Write | String | Block credential stealing from the Windows local security authority subsystem - Depends on AttackSurfaceReductionRules (off: Off, block: Block, audit: Audit, warn: Warn) | `off`, `block`, `audit`, `warn` |
| **BlockCredentialStealingFromWindowsLocalSecurityAuthoritySubsystem_ASROnlyPerRuleExclusions** | Write | StringArray[] | ASR Only Per Rule Exclusions | |
| **BlockJavaScriptOrVBScriptFromLaunchingDownloadedExecutableContent** | Write | String | Block JavaScript or VBScript from launching downloaded executable content - Depends on AttackSurfaceReductionRules (off: Off, block: Block, audit: Audit, warn: Warn) | `off`, `block`, `audit`, `warn` |
| **BlockJavaScriptOrVBScriptFromLaunchingDownloadedExecutableContent_ASROnlyPerRuleExclusions** | Write | StringArray[] | ASR Only Per Rule Exclusions | |
| **BlockWebshellCreationForServers** | Write | String | Block Webshell creation for Servers - Depends on AttackSurfaceReductionRules (off: Off, block: Block, audit: Audit, warn: Warn) | `off`, `block`, `audit`, `warn` |
| **BlockWebshellCreationForServers_ASROnlyPerRuleExclusions** | Write | StringArray[] | ASR Only Per Rule Exclusions | |
| **BlockUntrustedUnsignedProcessesThatRunFromUSB** | Write | String | Block untrusted and unsigned processes that run from USB - Depends on AttackSurfaceReductionRules (off: Off, block: Block, audit: Audit, warn: Warn) | `off`, `block`, `audit`, `warn` |
| **BlockUntrustedUnsignedProcessesThatRunFromUSB_ASROnlyPerRuleExclusions** | Write | StringArray[] | ASR Only Per Rule Exclusions | |
| **BlockPersistenceThroughWMIEventSubscription** | Write | String | Block persistence through WMI event subscription - Depends on AttackSurfaceReductionRules (off: Off, block: Block, audit: Audit, warn: Warn) | `off`, `block`, `audit`, `warn` |
| **BlockUseOfCopiedOrImpersonatedSystemTools** | Write | String | [PREVIEW] Block use of copied or impersonated system tools - Depends on AttackSurfaceReductionRules (off: Off, block: Block, audit: Audit, warn: Warn) | `off`, `block`, `audit`, `warn` |
| **BlockUseOfCopiedOrImpersonatedSystemTools_ASROnlyPerRuleExclusions** | Write | StringArray[] | ASR Only Per Rule Exclusions | |
| **BlockAbuseOfExploitedVulnerableSignedDrivers** | Write | String | Block abuse of exploited vulnerable signed drivers (Device) - Depends on AttackSurfaceReductionRules (off: Off, block: Block, audit: Audit, warn: Warn) | `off`, `block`, `audit`, `warn` |
| **BlockAbuseOfExploitedVulnerableSignedDrivers_ASROnlyPerRuleExclusions** | Write | StringArray[] | ASR Only Per Rule Exclusions | |
| **BlockProcessCreationsFromPSExecAndWMICommands** | Write | String | Block process creations originating from PSExec and WMI commands - Depends on AttackSurfaceReductionRules (off: Off, block: Block, audit: Audit, warn: Warn) | `off`, `block`, `audit`, `warn` |
| **BlockProcessCreationsFromPSExecAndWMICommands_ASROnlyPerRuleExclusions** | Write | StringArray[] | ASR Only Per Rule Exclusions | |
| **BlockOfficeApplicationsFromCreatingExecutableContent** | Write | String | Block Office applications from creating executable content - Depends on AttackSurfaceReductionRules (off: Off, block: Block, audit: Audit, warn: Warn) | `off`, `block`, `audit`, `warn` |
| **BlockOfficeApplicationsFromCreatingExecutableContent_ASROnlyPerRuleExclusions** | Write | StringArray[] | ASR Only Per Rule Exclusions | |
| **BlockOfficeApplicationsFromInjectingCodeIntoOtherProcesses** | Write | String | Block Office applications from injecting code into other processes - Depends on AttackSurfaceReductionRules (off: Off, block: Block, audit: Audit, warn: Warn) | `off`, `block`, `audit`, `warn` |
| **BlockOfficeApplicationsFromInjectingCodeIntoOtherProcesses_ASROnlyPerRuleExclusions** | Write | StringArray[] | ASR Only Per Rule Exclusions | |
| **BlockRebootingMachineInSafeMode** | Write | String | [PREVIEW] Block rebooting machine in Safe Mode - Depends on AttackSurfaceReductionRules (off: Off, block: Block, audit: Audit, warn: Warn) | `off`, `block`, `audit`, `warn` |
| **BlockRebootingMachineInSafeMode_ASROnlyPerRuleExclusions** | Write | StringArray[] | ASR Only Per Rule Exclusions | |
| **UseAdvancedProtectionAgainstRansomware** | Write | String | Use advanced protection against ransomware - Depends on AttackSurfaceReductionRules (off: Off, block: Block, audit: Audit, warn: Warn) | `off`, `block`, `audit`, `warn` |
| **UseAdvancedProtectionAgainstRansomware_ASROnlyPerRuleExclusions** | Write | StringArray[] | ASR Only Per Rule Exclusions | |
| **BlockExecutableContentFromEmailClientAndWebmail** | Write | String | Block executable content from email client and webmail - Depends on AttackSurfaceReductionRules (off: Off, block: Block, audit: Audit, warn: Warn) | `off`, `block`, `audit`, `warn` |
| **BlockExecutableContentFromEmailClientAndWebmail_ASROnlyPerRuleExclusions** | Write | StringArray[] | ASR Only Per Rule Exclusions | |
| **CloudBlockLevel** | Write | String | Cloud Block Level (0: NotConfigured, 2: High, 4: HighPlus, 6: ZeroTolerance) | `0`, `2`, `4`, `6` |
| **CloudExtendedTimeout** | Write | SInt32 | Cloud Extended Timeout | |
| **DisableLocalAdminMerge** | Write | String | Disable Local Admin Merge (0: Enable Local Admin Merge, 1: Disable Local Admin Merge) | `0`, `1` |
| **EnableFileHashComputation** | Write | String | Enable File Hash Computation (0: Disable, 1: Enable) | `0`, `1` |
| **EnableNetworkProtection** | Write | String | Enable Network Protection (0: Disabled, 1: Enabled (block mode), 2: Enabled (audit mode)) | `0`, `1`, `2` |
| **HideExclusionsFromLocalAdmins** | Write | String | Hide Exclusions From Local Admins (1: If you enable this setting, local admins will no longer be able to see the exclusion list in Windows Security App or via PowerShell., 0: If you disable or do not configure this setting, local admins will be able to see exclusions in the Windows Security App and via PowerShell.) | `1`, `0` |
| **PUAProtection** | Write | String | PUA Protection (0: PUA Protection off. Windows Defender will not protect against potentially unwanted applications., 1: PUA Protection on. Detected items are blocked. They will show in history along with other threats., 2: Audit mode. Windows Defender will detect potentially unwanted applications, but take no action. You can review information about the applications Windows Defender would have taken action against by searching for events created by Windows Defender in the Event Viewer.) | `0`, `1`, `2` |
| **RealTimeScanDirection** | Write | String | Real Time Scan Direction (0: Monitor all files (bi-directional)., 1: Monitor incoming files., 2: Monitor outgoing files.) | `0`, `1`, `2` |
| **SubmitSamplesConsent** | Write | String | Submit Samples Consent (0: Always prompt., 1: Send safe samples automatically., 2: Never send., 3: Send all samples automatically.) | `0`, `1`, `2`, `3` |
| **ConfigureSystemGuardLaunch** | Write | String | Configure System Guard Launch (0: Unmanaged Configurable by Administrative user, 1: Unmanaged Enables Secure Launch if supported by hardware, 2: Unmanaged Disables Secure Launch) | `0`, `1`, `2` |
| **LsaCfgFlags** | Write | String | Credential Guard (0: (Disabled) Turns off Credential Guard remotely if configured previously without UEFI Lock., 1: (Enabled with UEFI lock) Turns on Credential Guard with UEFI lock., 2: (Enabled without lock) Turns on Credential Guard without UEFI lock.) | `0`, `1`, `2` |
| **EnableVirtualizationBasedSecurity** | Write | String | Enable Virtualization Based Security (0: disable virtualization based security., 1: enable virtualization based security.) | `0`, `1` |
| **RequirePlatformSecurityFeatures** | Write | String | Require Platform Security Features (1: Turns on VBS with Secure Boot., 3: Turns on VBS with Secure Boot and direct memory access (DMA). DMA requires hardware support.) | `1`, `3` |
| **DevicePasswordEnabled** | Write | String | Device Password Enabled (0: Enabled, 1: Disabled) | `0`, `1` |
| **DevicePasswordExpiration** | Write | SInt32 | Device Password Expiration - Depends on DevicePasswordEnabled | |
| **MinDevicePasswordLength** | Write | SInt32 | Min Device Password Length - Depends on DevicePasswordEnabled | |
| **AlphanumericDevicePasswordRequired** | Write | String | Alphanumeric Device Password Required - Depends on DevicePasswordEnabled (0: Password or Alphanumeric PIN required., 1: Password or Numeric PIN required., 2: Password, Numeric PIN, or Alphanumeric PIN required.) | `0`, `1`, `2` |
| **MaxDevicePasswordFailedAttempts** | Write | SInt32 | Max Device Password Failed Attempts - Depends on DevicePasswordEnabled | |
| **MinDevicePasswordComplexCharacters** | Write | String | Min Device Password Complex Characters - Depends on DevicePasswordEnabled (1: Digits only, 2: Digits and lowercase letters are required, 3: Digits lowercase letters and uppercase letters are required. Not supported in desktop Microsoft accounts and domain accounts, 4: Digits lowercase letters uppercase letters and special characters are required. Not supported in desktop) | `1`, `2`, `3`, `4` |
| **MaxInactivityTimeDeviceLock** | Write | SInt32 | Max Inactivity Time Device Lock - Depends on DevicePasswordEnabled | |
| **DevicePasswordHistory** | Write | SInt32 | Device Password History - Depends on DevicePasswordEnabled | |
| **AllowSimpleDevicePassword** | Write | String | Allow Simple Device Password - Depends on DevicePasswordEnabled (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **DeviceEnumerationPolicy** | Write | String | Device Enumeration Policy (0: Block all (Most restrictive), 1: Only after log in/screen unlock, 2: Allow all (Least restrictive)) | `0`, `1`, `2` |
| **EnableInsecureGuestLogons** | Write | String | Enable Insecure Guest Logons (0: Disabled, 1: Enabled) | `0`, `1` |
| **Accounts_LimitLocalAccountUseOfBlankPasswordsToConsoleLogonOnly** | Write | String | Accounts Limit Local Account Use Of Blank Passwords To Console Logon Only (0: Disabled, 1: Enabled) | `0`, `1` |
| **InteractiveLogon_MachineInactivityLimit** | Write | SInt32 | Interactive Logon Machine Inactivity Limit | |
| **InteractiveLogon_SmartCardRemovalBehavior** | Write | String | Interactive Logon Smart Card Removal Behavior (0: No Action, 1: Lock Workstation, 2: Force Logoff, 3: Disconnect if a Remote Desktop Services session) | `0`, `1`, `2`, `3` |
| **MicrosoftNetworkClient_DigitallySignCommunicationsAlways** | Write | String | Microsoft Network Client Digitally Sign Communications Always (1: Enable, 0: Disable) | `1`, `0` |
| **MicrosoftNetworkClient_SendUnencryptedPasswordToThirdPartySMBServers** | Write | String | Microsoft Network Client Send Unencrypted Password To Third Party SMB Servers (1: Enable, 0: Disable) | `1`, `0` |
| **MicrosoftNetworkServer_DigitallySignCommunicationsAlways** | Write | String | Microsoft Network Server Digitally Sign Communications Always (1: Enable, 0: Disable) | `1`, `0` |
| **NetworkAccess_DoNotAllowAnonymousEnumerationOfSAMAccounts** | Write | String | Network Access Do Not Allow Anonymous Enumeration Of SAM Accounts (1: Enabled, 0: Disabled) | `1`, `0` |
| **NetworkAccess_DoNotAllowAnonymousEnumerationOfSamAccountsAndShares** | Write | String | Network Access Do Not Allow Anonymous Enumeration Of Sam Accounts And Shares (1: Enabled, 0: Disabled) | `1`, `0` |
| **NetworkAccess_RestrictAnonymousAccessToNamedPipesAndShares** | Write | String | Network Access Restrict Anonymous Access To Named Pipes And Shares (1: Enable, 0: Disable) | `1`, `0` |
| **NetworkAccess_RestrictClientsAllowedToMakeRemoteCallsToSAM** | Write | String | Network Access Restrict Clients Allowed To Make Remote Calls To SAM | |
| **NetworkSecurity_DoNotStoreLANManagerHashValueOnNextPasswordChange** | Write | String | Network Security Do Not Store LAN Manager Hash Value On Next Password Change (1: Enable, 0: Disable) | `1`, `0` |
| **NetworkSecurity_LANManagerAuthenticationLevel** | Write | String | Network Security LAN Manager Authentication Level (0: Send LM and NTLM responses, 1: Send LM and NTLM-use NTLMv2 session security if negotiated, 2: Send LM and NTLM responses only, 3: Send LM and NTLMv2 responses only, 4: Send LM and NTLMv2 responses only. Refuse LM, 5: Send LM and NTLMv2 responses only. Refuse LM and NTLM) | `0`, `1`, `2`, `3`, `4`, `5` |
| **NetworkSecurity_MinimumSessionSecurityForNTLMSSPBasedClients** | Write | String | Network Security Minimum Session Security For NTLMSSP Based Clients (0: None, 524288: Require NTLMv2 session security, 536870912: Require 128-bit encryption, 537395200: Require NTLM and 128-bit encryption) | `0`, `524288`, `536870912`, `537395200` |
| **NetworkSecurity_MinimumSessionSecurityForNTLMSSPBasedServers** | Write | String | Network Security Minimum Session Security For NTLMSSP Based Servers (0: None, 524288: Require NTLMv2 session security, 536870912: Require 128-bit encryption, 537395200: Require NTLM and 128-bit encryption) | `0`, `524288`, `536870912`, `537395200` |
| **UserAccountControl_BehaviorOfTheElevationPromptForAdministrators** | Write | String | User Account Control Behavior Of The Elevation Prompt For Administrators (0: Elevate without prompting, 1: Prompt for credentials on the secure desktop, 2: Prompt for consent on the secure desktop, 3: Prompt for credentials, 4: Prompt for consent, 5: Prompt for consent for non-Windows binaries) | `0`, `1`, `2`, `3`, `4`, `5` |
| **UserAccountControl_BehaviorOfTheElevationPromptForStandardUsers** | Write | String | User Account Control Behavior Of The Elevation Prompt For Standard Users (0: Automatically deny elevation requests, 1: Prompt for credentials on the secure desktop, 3: Prompt for credentials) | `0`, `1`, `3` |
| **UserAccountControl_DetectApplicationInstallationsAndPromptForElevation** | Write | String | User Account Control Detect Application Installations And Prompt For Elevation (1: Enable, 0: Disable) | `1`, `0` |
| **UserAccountControl_OnlyElevateUIAccessApplicationsThatAreInstalledInSecureLocations** | Write | String | User Account Control Only Elevate UI Access Applications That Are Installed In Secure Locations (0: Disabled: Application runs with UIAccess integrity even if it does not reside in a secure location., 1: Enabled: Application runs with UIAccess integrity only if it resides in secure location.) | `0`, `1` |
| **UserAccountControl_RunAllAdministratorsInAdminApprovalMode** | Write | String | User Account Control Run All Administrators In Admin Approval Mode (0: Disabled, 1: Enabled) | `0`, `1` |
| **UserAccountControl_UseAdminApprovalMode** | Write | String | User Account Control Use Admin Approval Mode (1: Enable, 0: Disable) | `1`, `0` |
| **UserAccountControl_VirtualizeFileAndRegistryWriteFailuresToPerUserLocations** | Write | String | User Account Control Virtualize File And Registry Write Failures To Per User Locations (0: Disabled, 1: Enabled) | `0`, `1` |
| **ConfigureLsaProtectedProcess** | Write | String | Configure Lsa Protected Process (0: Disabled. Default value. LSA will not run as protected process., 1: Enabled with UEFI lock. LSA will run as protected process and this configuration is UEFI locked., 2: Enabled without UEFI lock. LSA will run as protected process and this configuration is not UEFI locked.) | `0`, `1`, `2` |
| **AllowGameDVR** | Write | String | Allow Game DVR (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **MSIAllowUserControlOverInstall** | Write | String | MSI Allow User Control Over Install (0: Disabled, 1: Enabled) | `0`, `1` |
| **MSIAlwaysInstallWithElevatedPrivileges** | Write | String | MSI Always Install With Elevated Privileges (0: Disabled, 1: Enabled) | `0`, `1` |
| **SmartScreenEnabled** | Write | String | Configure Microsoft Defender SmartScreen (0: Disabled, 1: Enabled) | `0`, `1` |
| **MicrosoftEdge_SmartScreen_PreventSmartScreenPromptOverride** | Write | String | Prevent bypassing Microsoft Defender SmartScreen prompts for sites (0: Disabled, 1: Enabled) | `0`, `1` |
| **LetAppsActivateWithVoiceAboveLock** | Write | String | Let Apps Activate With Voice Above Lock (0: User in control. Users can decide if Windows apps can be activated by voice while the screen is locked using Settings > Privacy options on the device., 1: Force allow. Windows apps can be activated by voice while the screen is locked, and users cannot change it., 2: Force deny. Windows apps cannot be activated by voice while the screen is locked, and users cannot change it.) | `0`, `1`, `2` |
| **AllowIndexingEncryptedStoresOrItems** | Write | String | Allow Indexing Encrypted Stores Or Items (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **EnableSmartScreenInShell** | Write | String | Enable Smart Screen In Shell (0: Disabled., 1: Enabled.) | `0`, `1` |
| **NotifyMalicious** | Write | String | Notify Malicious (0: Disabled, 1: Enabled) | `0`, `1` |
| **NotifyPasswordReuse** | Write | String | Notify Password Reuse (0: Disabled, 1: Enabled) | `0`, `1` |
| **NotifyUnsafeApp** | Write | String | Notify Unsafe App (0: Disabled, 1: Enabled) | `0`, `1` |
| **ServiceEnabled** | Write | String | Service Enabled (0: Disabled, 1: Enabled) | `0`, `1` |
| **PreventOverrideForFilesInShell** | Write | String | Prevent Override For Files In Shell (0: Do not prevent override., 1: Prevent override.) | `0`, `1` |
| **ConfigureXboxAccessoryManagementServiceStartupMode** | Write | String | Configure Xbox Accessory Management Service Startup Mode (2: Automatic, 3: Manual, 4: Disabled) | `2`, `3`, `4` |
| **ConfigureXboxLiveAuthManagerServiceStartupMode** | Write | String | Configure Xbox Live Auth Manager Service Startup Mode (2: Automatic, 3: Manual, 4: Disabled) | `2`, `3`, `4` |
| **ConfigureXboxLiveGameSaveServiceStartupMode** | Write | String | Configure Xbox Live Game Save Service Startup Mode (2: Automatic, 3: Manual, 4: Disabled) | `2`, `3`, `4` |
| **ConfigureXboxLiveNetworkingServiceStartupMode** | Write | String | Configure Xbox Live Networking Service Startup Mode (2: Automatic, 3: Manual, 4: Disabled) | `2`, `3`, `4` |
| **EnableXboxGameSaveTask** | Write | String | Enable Xbox Game Save Task (0: Disabled, 1: Enabled) | `0`, `1` |
| **AccessFromNetwork** | Write | StringArray[] | Access From Network | |
| **AllowLocalLogOn** | Write | StringArray[] | Allow Local Log On | |
| **BackupFilesAndDirectories** | Write | StringArray[] | Backup Files And Directories | |
| **CreateGlobalObjects** | Write | StringArray[] | Create Global Objects | |
| **CreatePageFile** | Write | StringArray[] | Create Page File | |
| **DebugPrograms** | Write | StringArray[] | Debug Programs | |
| **DenyAccessFromNetwork** | Write | StringArray[] | Deny Access From Network | |
| **DenyRemoteDesktopServicesLogOn** | Write | StringArray[] | Deny Remote Desktop Services Log On | |
| **ImpersonateClient** | Write | StringArray[] | Impersonate Client | |
| **LoadUnloadDeviceDrivers** | Write | StringArray[] | Load Unload Device Drivers | |
| **ManageAuditingAndSecurityLog** | Write | StringArray[] | Manage Auditing And Security Log | |
| **ManageVolume** | Write | StringArray[] | Manage Volume | |
| **ModifyFirmwareEnvironment** | Write | StringArray[] | Modify Firmware Environment | |
| **ProfileSingleProcess** | Write | StringArray[] | Profile Single Process | |
| **RemoteShutdown** | Write | StringArray[] | Remote Shutdown | |
| **RestoreFilesAndDirectories** | Write | StringArray[] | Restore Files And Directories | |
| **TakeOwnership** | Write | StringArray[] | Take Ownership | |
| **HypervisorEnforcedCodeIntegrity** | Write | String | Hypervisor Enforced Code Integrity (0: (Disabled) Turns off Hypervisor-Protected Code Integrity remotely if configured previously without UEFI Lock., 1: (Enabled with UEFI lock) Turns on Hypervisor-Protected Code Integrity with UEFI lock., 2: (Enabled without lock) Turns on Hypervisor-Protected Code Integrity without UEFI lock.) | `0`, `1`, `2` |
| **AllowAutoConnectToWiFiSenseHotspots** | Write | String | Allow Auto Connect To Wi Fi Sense Hotspots (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **AllowInternetSharing** | Write | String | Allow Internet Sharing (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **FacialFeaturesUseEnhancedAntiSpoofing** | Write | String | Facial Features Use Enhanced Anti Spoofing (false: Disabled, true: Enabled) | `false`, `true` |
| **AllowWindowsInkWorkspace** | Write | String | Allow Windows Ink Workspace (0: access to ink workspace is disabled. The feature is turned off., 1: ink workspace is enabled (feature is turned on), but the user cannot access it above the lock screen., 2: ink workspace is enabled (feature is turned on), and the user is allowed to use it above the lock screen.) | `0`, `1`, `2` |
| **BackupDirectory** | Write | String | Backup Directory (0: Disabled (password will not be backed up), 1: Backup the password to Azure AD only, 2: Backup the password to Active Directory only) | `0`, `1`, `2` |
| **ADEncryptedPasswordHistorySize** | Write | SInt32 | AD Encrypted Password History Size - Depends on BackupDirectory | |
| **passwordagedays** | Write | SInt32 | Password Age Days - Depends on BackupDirectory | |
| **ADPasswordEncryptionEnabled** | Write | String | AD Password Encryption Enabled - Depends on BackupDirectory (false: Store the password in clear-text form in Active Directory, true: Store the password in encrypted form in Active Directory) | `false`, `true` |
| **passwordagedays_aad** | Write | SInt32 | Password Age Days - Depends on BackupDirectory | |
| **ADPasswordEncryptionPrincipal** | Write | String | AD Password Encryption Principal - Depends on BackupDirectory | |
| **PasswordExpirationProtectionEnabled** | Write | String | Password Expiration Protection Enabled - Depends on BackupDirectory (false: Allow configured password expiriration timestamp to exceed maximum password age, true: Do not allow configured password expiriration timestamp to exceed maximum password age) | `false`, `true` |

### MSFT_MicrosoftGraphIntuneSettingsCatalogUserSettings_IntuneSecurityBaselineWindows10

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **NoLockScreenToastNotification** | Write | String | Turn off toast notifications on the lock screen (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **RestrictFormSuggestPW** | Write | String | Turn on the auto-complete feature for user names and passwords on forms (User) (0: Disabled, 1: Enabled) | `0`, `1` |
| **ChkBox_PasswordAsk** | Write | String | Prompt me to save passwords (User) - Depends on RestrictFormSuggestPW (0: False, 1: True) | `0`, `1` |
| **AllowWindowsSpotlight** | Write | String | Allow Windows Spotlight (User) (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **AllowWindowsTips** | Write | String | Allow Windows Tips - Depends on AllowWindowsSpotlight (0: Disabled., 1: Enabled.) | `0`, `1` |
| **AllowTailoredExperiencesWithDiagnosticData** | Write | String | Allow Tailored Experiences With Diagnostic Data (User) - Depends on AllowWindowsSpotlight (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **AllowWindowsSpotlightOnActionCenter** | Write | String | Allow Windows Spotlight On Action Center (User) - Depends on AllowWindowsSpotlight (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **AllowWindowsConsumerFeatures** | Write | String | Allow Windows Consumer Features - Depends on AllowWindowsSpotlight (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **ConfigureWindowsSpotlightOnLockScreen** | Write | String | Configure Windows Spotlight On Lock Screen (User) - Depends on AllowWindowsSpotlight (0: Windows spotlight disabled., 1: Windows spotlight enabled., 2: Windows spotlight is always enabled, the user cannot disable it, 3: Windows spotlight is always enabled, the user cannot disable it. For special configurations only) | `0`, `1`, `2`, `3` |
| **AllowWindowsSpotlightWindowsWelcomeExperience** | Write | String | Allow Windows Spotlight Windows Welcome Experience (User) - Depends on AllowWindowsSpotlight (0: Not allowed., 1: Allowed.) | `0`, `1` |
| **AllowThirdPartySuggestionsInWindowsSpotlight** | Write | String | Allow Third Party Suggestions In Windows Spotlight (User) - Depends on AllowWindowsSpotlight (0: Third-party suggestions not allowed., 1: Third-party suggestions allowed.) | `0`, `1` |


## Description

Intune Security Baseline for Windows10

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - DeviceManagementConfiguration.Read.All, Group.Read.All

- **Update**

    - Group.Read.All, DeviceManagementConfiguration.ReadWrite.All

#### Application permissions

- **Read**

    - DeviceManagementConfiguration.Read.All, Group.Read.All

- **Update**

    - Group.Read.All, DeviceManagementConfiguration.ReadWrite.All

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneSecurityBaselineWindows10 'mySecurityBaselineWindows10'
        {
            DisplayName           = 'test'
            DeviceSettings = MSFT_MicrosoftGraphIntuneSettingsCatalogDeviceSettings_IntuneSecurityBaselineWindows10
            {
                Pol_MSS_DisableIPSourceRoutingIPv6 = '1'
                DisableIPSourceRoutingIPv6 = '0'
                BlockExecutionOfPotentiallyObfuscatedScripts = 'block'                             
                HardenedUNCPaths_Pol_HardenedPaths = '1'
                pol_hardenedPaths = @(
                    MSFT_MicrosoftGraphIntuneSettingsCatalogpol_hardenedpaths{
                        Key = '\\*\SYSVOL'
                        Value = 'RequireMutualAuthentication=1,RequireIntegrity=1'
                    }
                )
            }
            UserSettings = MSFT_MicrosoftGraphIntuneSettingsCatalogUserSettings_IntuneSecurityBaselineWindows10
            {
                AllowWindowsSpotlight = '1'
            }
            Ensure                = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

### Example 2

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneSecurityBaselineWindows10 'mySecurityBaselineWindows10'
        {
            DisplayName           = 'test'
            DeviceSettings = MSFT_MicrosoftGraphIntuneSettingsCatalogDeviceSettings_IntuneSecurityBaselineWindows10
            {
                Pol_MSS_DisableIPSourceRoutingIPv6 = '1'
                DisableIPSourceRoutingIPv6 = '0'
                BlockExecutionOfPotentiallyObfuscatedScripts = 'block'                         
                HardenedUNCPaths_Pol_HardenedPaths = '1'
                pol_hardenedPaths = @(
                    MSFT_MicrosoftGraphIntuneSettingsCatalogpol_hardenedpaths{
                        Key = '\\*\SYSVOL'
                        Value = 'RequireMutualAuthentication=1,RequireIntegrity=1'
                    }
                )
            }
            UserSettings = MSFT_MicrosoftGraphIntuneSettingsCatalogUserSettings_IntuneSecurityBaselineWindows10
            {
                AllowWindowsSpotlight = '1' #drift
            }
            Ensure                = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

### Example 3

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneSecurityBaselineWindows10 'mySecurityBaselineWindows10'
        {
            DisplayName           = 'test'
            Ensure                = 'Absent'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

