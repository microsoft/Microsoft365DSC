function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DeviceSettings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserSettings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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

    Write-Verbose -Message "Getting configuration of the Intune Security Baseline for Windows10 with Id {$Id} and Name {$DisplayName}"

    try
    {
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

        $nullResult = $PSBoundParameters
        $nullResult.Ensure = 'Absent'

        $getValue = $null
        #region resource generator code
        $getValue = Get-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $Id -ErrorAction SilentlyContinue

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Security Baseline for Windows10 with Id {$Id}"

            if (-not [System.String]::IsNullOrEmpty($DisplayName))
            {
                $getValue = Get-MgBetaDeviceManagementConfigurationPolicy `
                    -Filter "Name eq '$DisplayName'" `
                    -ErrorAction SilentlyContinue
            }
        }
        #endregion
        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Security Baseline for Windows10 with Name {$DisplayName}."
            return $nullResult
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Security Baseline for Windows10 with Id {$Id} and Name {$DisplayName} was found"

        # Retrieve policy specific settings
        [array]$settings = Get-MgBetaDeviceManagementConfigurationPolicySetting `
            -DeviceManagementConfigurationPolicyId $Id `
            -ExpandProperty 'settingDefinitions' `
            -All `
            -ErrorAction Stop

        $policySettings = @{}
        $policySettings = Export-IntuneSettingCatalogPolicySettings -Settings $settings -ReturnHashtable $policySettings -ContainsDeviceAndUserSettings

        #region resource generator code
        $complexDeviceSettings = @{}
        if ($null -ne $policySettings.DeviceSettings.blockExecutionOfPotentiallyObfuscatedScripts)
        {
            $complexDeviceSettings.Add('BlockExecutionOfPotentiallyObfuscatedScripts', $policySettings.DeviceSettings.blockExecutionOfPotentiallyObfuscatedScripts)
        }
        if ($null -ne $policySettings.DeviceSettings.blockExecutionOfPotentiallyObfuscatedScripts_ASROnlyPerRuleExclusions)
        {
            $complexDeviceSettings.Add('BlockExecutionOfPotentiallyObfuscatedScripts_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockExecutionOfPotentiallyObfuscatedScripts_ASROnlyPerRuleExclusions)
        }
        if ($null -ne $policySettings.DeviceSettings.blockWin32APICallsFromOfficeMacros)
        {
            $complexDeviceSettings.Add('BlockWin32APICallsFromOfficeMacros', $policySettings.DeviceSettings.blockWin32APICallsFromOfficeMacros)
        }
        if ($null -ne $policySettings.DeviceSettings.blockWin32APICallsFromOfficeMacros_ASROnlyPerRuleExclusions)
        {
            $complexDeviceSettings.Add('BlockWin32APICallsFromOfficeMacros_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockWin32APICallsFromOfficeMacros_ASROnlyPerRuleExclusions)
        }
        if ($null -ne $policySettings.DeviceSettings.blockExecutableFilesRunningUnlessTheyMeetPrevalenceAgeTrustedListCriterion)
        {
            $complexDeviceSettings.Add('BlockExecutableFilesRunningUnlessTheyMeetPrevalenceAgeTrustedListCriterion', $policySettings.DeviceSettings.blockExecutableFilesRunningUnlessTheyMeetPrevalenceAgeTrustedListCriterion)
        }
        if ($null -ne $policySettings.DeviceSettings.blockExecutableFilesRunningUnlessTheyMeetPrevalenceAgeTrustedListCriterion_ASROnlyPerRuleExclusions)
        {
            $complexDeviceSettings.Add('BlockExecutableFilesRunningUnlessTheyMeetPrevalenceAgeTrustedListCriterion_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockExecutableFilesRunningUnlessTheyMeetPrevalenceAgeTrustedListCriterion_ASROnlyPerRuleExclusions)
        }
        if ($null -ne $policySettings.DeviceSettings.blockOfficeCommunicationAppFromCreatingChildProcesses)
        {
            $complexDeviceSettings.Add('BlockOfficeCommunicationAppFromCreatingChildProcesses', $policySettings.DeviceSettings.blockOfficeCommunicationAppFromCreatingChildProcesses)
        }
        if ($null -ne $policySettings.DeviceSettings.blockOfficeCommunicationAppFromCreatingChildProcesses_ASROnlyPerRuleExclusions)
        {
            $complexDeviceSettings.Add('BlockOfficeCommunicationAppFromCreatingChildProcesses_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockOfficeCommunicationAppFromCreatingChildProcesses_ASROnlyPerRuleExclusions)
        }
        if ($null -ne $policySettings.DeviceSettings.blockAllOfficeApplicationsFromCreatingChildProcesses)
        {
            $complexDeviceSettings.Add('BlockAllOfficeApplicationsFromCreatingChildProcesses', $policySettings.DeviceSettings.blockAllOfficeApplicationsFromCreatingChildProcesses)
        }
        if ($null -ne $policySettings.DeviceSettings.blockAllOfficeApplicationsFromCreatingChildProcesses_ASROnlyPerRuleExclusions)
        {
            $complexDeviceSettings.Add('BlockAllOfficeApplicationsFromCreatingChildProcesses_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockAllOfficeApplicationsFromCreatingChildProcesses_ASROnlyPerRuleExclusions)
        }
        if ($null -ne $policySettings.DeviceSettings.blockAdobeReaderFromCreatingChildProcesses)
        {
            $complexDeviceSettings.Add('BlockAdobeReaderFromCreatingChildProcesses', $policySettings.DeviceSettings.blockAdobeReaderFromCreatingChildProcesses)
        }
        if ($null -ne $policySettings.DeviceSettings.blockAdobeReaderFromCreatingChildProcesses_ASROnlyPerRuleExclusions)
        {
            $complexDeviceSettings.Add('BlockAdobeReaderFromCreatingChildProcesses_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockAdobeReaderFromCreatingChildProcesses_ASROnlyPerRuleExclusions)
        }
        if ($null -ne $policySettings.DeviceSettings.blockCredentialStealingFromWindowsLocalSecurityAuthoritySubsystem)
        {
            $complexDeviceSettings.Add('BlockCredentialStealingFromWindowsLocalSecurityAuthoritySubsystem', $policySettings.DeviceSettings.blockCredentialStealingFromWindowsLocalSecurityAuthoritySubsystem)
        }
        if ($null -ne $policySettings.DeviceSettings.blockCredentialStealingFromWindowsLocalSecurityAuthoritySubsystem_ASROnlyPerRuleExclusions)
        {
            $complexDeviceSettings.Add('BlockCredentialStealingFromWindowsLocalSecurityAuthoritySubsystem_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockCredentialStealingFromWindowsLocalSecurityAuthoritySubsystem_ASROnlyPerRuleExclusions)
        }
        if ($null -ne $policySettings.DeviceSettings.blockJavaScriptOrVBScriptFromLaunchingDownloadedExecutableContent)
        {
            $complexDeviceSettings.Add('BlockJavaScriptOrVBScriptFromLaunchingDownloadedExecutableContent', $policySettings.DeviceSettings.blockJavaScriptOrVBScriptFromLaunchingDownloadedExecutableContent)
        }
        if ($null -ne $policySettings.DeviceSettings.blockJavaScriptOrVBScriptFromLaunchingDownloadedExecutableContent_ASROnlyPerRuleExclusions)
        {
            $complexDeviceSettings.Add('BlockJavaScriptOrVBScriptFromLaunchingDownloadedExecutableContent_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockJavaScriptOrVBScriptFromLaunchingDownloadedExecutableContent_ASROnlyPerRuleExclusions)
        }
        if ($null -ne $policySettings.DeviceSettings.blockWebshellCreationForServers)
        {
            $complexDeviceSettings.Add('BlockWebshellCreationForServers', $policySettings.DeviceSettings.blockWebshellCreationForServers)
        }
        if ($null -ne $policySettings.DeviceSettings.blockWebshellCreationForServers_ASROnlyPerRuleExclusions)
        {
            $complexDeviceSettings.Add('BlockWebshellCreationForServers_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockWebshellCreationForServers_ASROnlyPerRuleExclusions)
        }
        if ($null -ne $policySettings.DeviceSettings.blockUntrustedUnsignedProcessesThatRunFromUSB)
        {
            $complexDeviceSettings.Add('BlockUntrustedUnsignedProcessesThatRunFromUSB', $policySettings.DeviceSettings.blockUntrustedUnsignedProcessesThatRunFromUSB)
        }
        if ($null -ne $policySettings.DeviceSettings.blockUntrustedUnsignedProcessesThatRunFromUSB_ASROnlyPerRuleExclusions)
        {
            $complexDeviceSettings.Add('BlockUntrustedUnsignedProcessesThatRunFromUSB_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockUntrustedUnsignedProcessesThatRunFromUSB_ASROnlyPerRuleExclusions)
        }
        if ($null -ne $policySettings.DeviceSettings.blockPersistenceThroughWMIEventSubscription)
        {
            $complexDeviceSettings.Add('BlockPersistenceThroughWMIEventSubscription', $policySettings.DeviceSettings.blockPersistenceThroughWMIEventSubscription)
        }
        if ($null -ne $policySettings.DeviceSettings.blockUseOfCopiedOrImpersonatedSystemTools)
        {
            $complexDeviceSettings.Add('BlockUseOfCopiedOrImpersonatedSystemTools', $policySettings.DeviceSettings.blockUseOfCopiedOrImpersonatedSystemTools)
        }
        if ($null -ne $policySettings.DeviceSettings.blockUseOfCopiedOrImpersonatedSystemTools_ASROnlyPerRuleExclusions)
        {
            $complexDeviceSettings.Add('BlockUseOfCopiedOrImpersonatedSystemTools_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockUseOfCopiedOrImpersonatedSystemTools_ASROnlyPerRuleExclusions)
        }
        if ($null -ne $policySettings.DeviceSettings.blockAbuseOfExploitedVulnerableSignedDrivers)
        {
            $complexDeviceSettings.Add('BlockAbuseOfExploitedVulnerableSignedDrivers', $policySettings.DeviceSettings.blockAbuseOfExploitedVulnerableSignedDrivers)
        }
        if ($null -ne $policySettings.DeviceSettings.blockAbuseOfExploitedVulnerableSignedDrivers_ASROnlyPerRuleExclusions)
        {
            $complexDeviceSettings.Add('BlockAbuseOfExploitedVulnerableSignedDrivers_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockAbuseOfExploitedVulnerableSignedDrivers_ASROnlyPerRuleExclusions)
        }
        if ($null -ne $policySettings.DeviceSettings.blockProcessCreationsFromPSExecAndWMICommands)
        {
            $complexDeviceSettings.Add('BlockProcessCreationsFromPSExecAndWMICommands', $policySettings.DeviceSettings.blockProcessCreationsFromPSExecAndWMICommands)
        }
        if ($null -ne $policySettings.DeviceSettings.blockProcessCreationsFromPSExecAndWMICommands_ASROnlyPerRuleExclusions)
        {
            $complexDeviceSettings.Add('BlockProcessCreationsFromPSExecAndWMICommands_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockProcessCreationsFromPSExecAndWMICommands_ASROnlyPerRuleExclusions)
        }
        if ($null -ne $policySettings.DeviceSettings.blockOfficeApplicationsFromCreatingExecutableContent)
        {
            $complexDeviceSettings.Add('BlockOfficeApplicationsFromCreatingExecutableContent', $policySettings.DeviceSettings.blockOfficeApplicationsFromCreatingExecutableContent)
        }
        if ($null -ne $policySettings.DeviceSettings.blockOfficeApplicationsFromCreatingExecutableContent_ASROnlyPerRuleExclusions)
        {
            $complexDeviceSettings.Add('BlockOfficeApplicationsFromCreatingExecutableContent_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockOfficeApplicationsFromCreatingExecutableContent_ASROnlyPerRuleExclusions)
        }
        if ($null -ne $policySettings.DeviceSettings.blockOfficeApplicationsFromInjectingCodeIntoOtherProcesses)
        {
            $complexDeviceSettings.Add('BlockOfficeApplicationsFromInjectingCodeIntoOtherProcesses', $policySettings.DeviceSettings.blockOfficeApplicationsFromInjectingCodeIntoOtherProcesses)
        }
        if ($null -ne $policySettings.DeviceSettings.blockOfficeApplicationsFromInjectingCodeIntoOtherProcesses_ASROnlyPerRuleExclusions)
        {
            $complexDeviceSettings.Add('BlockOfficeApplicationsFromInjectingCodeIntoOtherProcesses_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockOfficeApplicationsFromInjectingCodeIntoOtherProcesses_ASROnlyPerRuleExclusions)
        }
        if ($null -ne $policySettings.DeviceSettings.blockRebootingMachineInSafeMode)
        {
            $complexDeviceSettings.Add('BlockRebootingMachineInSafeMode', $policySettings.DeviceSettings.blockRebootingMachineInSafeMode)
        }
        if ($null -ne $policySettings.DeviceSettings.blockRebootingMachineInSafeMode_ASROnlyPerRuleExclusions)
        {
            $complexDeviceSettings.Add('BlockRebootingMachineInSafeMode_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockRebootingMachineInSafeMode_ASROnlyPerRuleExclusions)
        }
        if ($null -ne $policySettings.DeviceSettings.useAdvancedProtectionAgainstRansomware)
        {
            $complexDeviceSettings.Add('UseAdvancedProtectionAgainstRansomware', $policySettings.DeviceSettings.useAdvancedProtectionAgainstRansomware)
        }
        if ($null -ne $policySettings.DeviceSettings.useAdvancedProtectionAgainstRansomware_ASROnlyPerRuleExclusions)
        {
            $complexDeviceSettings.Add('UseAdvancedProtectionAgainstRansomware_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.useAdvancedProtectionAgainstRansomware_ASROnlyPerRuleExclusions)
        }
        if ($null -ne $policySettings.DeviceSettings.blockExecutableContentFromEmailClientAndWebmail)
        {
            $complexDeviceSettings.Add('BlockExecutableContentFromEmailClientAndWebmail', $policySettings.DeviceSettings.blockExecutableContentFromEmailClientAndWebmail)
        }
        if ($null -ne $policySettings.DeviceSettings.blockExecutableContentFromEmailClientAndWebmail_ASROnlyPerRuleExclusions)
        {
            $complexDeviceSettings.Add('BlockExecutableContentFromEmailClientAndWebmail_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockExecutableContentFromEmailClientAndWebmail_ASROnlyPerRuleExclusions)
        }
        if ($null -ne $policySettings.DeviceSettings.cPL_Personalization_NoLockScreenCamera)
        {
            $complexDeviceSettings.Add('CPL_Personalization_NoLockScreenCamera', $policySettings.DeviceSettings.cPL_Personalization_NoLockScreenCamera)
        }
        if ($null -ne $policySettings.DeviceSettings.cPL_Personalization_NoLockScreenSlideshow)
        {
            $complexDeviceSettings.Add('CPL_Personalization_NoLockScreenSlideshow', $policySettings.DeviceSettings.cPL_Personalization_NoLockScreenSlideshow)
        }
        if ($null -ne $policySettings.DeviceSettings.pol_SecGuide_0201_LATFP)
        {
            $complexDeviceSettings.Add('Pol_SecGuide_0201_LATFP', $policySettings.DeviceSettings.pol_SecGuide_0201_LATFP)
        }
        if ($null -ne $policySettings.DeviceSettings.pol_SecGuide_0002_SMBv1_ClientDriver)
        {
            $complexDeviceSettings.Add('Pol_SecGuide_0002_SMBv1_ClientDriver', $policySettings.DeviceSettings.pol_SecGuide_0002_SMBv1_ClientDriver)
        }
        if ($null -ne $policySettings.DeviceSettings.pol_SecGuide_SMB1ClientDriver)
        {
            $complexDeviceSettings.Add('Pol_SecGuide_SMB1ClientDriver', $policySettings.DeviceSettings.pol_SecGuide_SMB1ClientDriver)
        }
        if ($null -ne $policySettings.DeviceSettings.pol_SecGuide_0001_SMBv1_Server)
        {
            $complexDeviceSettings.Add('Pol_SecGuide_0001_SMBv1_Server', $policySettings.DeviceSettings.pol_SecGuide_0001_SMBv1_Server)
        }
        if ($null -ne $policySettings.DeviceSettings.pol_SecGuide_0102_SEHOP)
        {
            $complexDeviceSettings.Add('Pol_SecGuide_0102_SEHOP', $policySettings.DeviceSettings.pol_SecGuide_0102_SEHOP)
        }
        if ($null -ne $policySettings.DeviceSettings.pol_SecGuide_0202_WDigestAuthn)
        {
            $complexDeviceSettings.Add('Pol_SecGuide_0202_WDigestAuthn', $policySettings.DeviceSettings.pol_SecGuide_0202_WDigestAuthn)
        }
        if ($null -ne $policySettings.DeviceSettings.pol_MSS_DisableIPSourceRoutingIPv6)
        {
            $complexDeviceSettings.Add('Pol_MSS_DisableIPSourceRoutingIPv6', $policySettings.DeviceSettings.pol_MSS_DisableIPSourceRoutingIPv6)
        }
        if ($null -ne $policySettings.DeviceSettings.disableIPSourceRoutingIPv6)
        {
            $complexDeviceSettings.Add('DisableIPSourceRoutingIPv6', $policySettings.DeviceSettings.disableIPSourceRoutingIPv6)
        }
        if ($null -ne $policySettings.DeviceSettings.pol_MSS_DisableIPSourceRouting)
        {
            $complexDeviceSettings.Add('Pol_MSS_DisableIPSourceRouting', $policySettings.DeviceSettings.pol_MSS_DisableIPSourceRouting)
        }
        if ($null -ne $policySettings.DeviceSettings.disableIPSourceRouting)
        {
            $complexDeviceSettings.Add('DisableIPSourceRouting', $policySettings.DeviceSettings.disableIPSourceRouting)
        }
        if ($null -ne $policySettings.DeviceSettings.pol_MSS_EnableICMPRedirect)
        {
            $complexDeviceSettings.Add('Pol_MSS_EnableICMPRedirect', $policySettings.DeviceSettings.pol_MSS_EnableICMPRedirect)
        }
        if ($null -ne $policySettings.DeviceSettings.pol_MSS_NoNameReleaseOnDemand)
        {
            $complexDeviceSettings.Add('Pol_MSS_NoNameReleaseOnDemand', $policySettings.DeviceSettings.pol_MSS_NoNameReleaseOnDemand)
        }
        if ($null -ne $policySettings.DeviceSettings.turn_Off_Multicast)
        {
            $complexDeviceSettings.Add('Turn_Off_Multicast', $policySettings.DeviceSettings.turn_Off_Multicast)
        }
        if ($null -ne $policySettings.DeviceSettings.nC_ShowSharedAccessUI)
        {
            $complexDeviceSettings.Add('NC_ShowSharedAccessUI', $policySettings.DeviceSettings.nC_ShowSharedAccessUI)
        }
        if ($null -ne $policySettings.DeviceSettings.hardeneduncpaths_Pol_HardenedPaths)
        {
            $complexDeviceSettings.Add('hardeneduncpaths_Pol_HardenedPaths', $policySettings.DeviceSettings.hardeneduncpaths_Pol_HardenedPaths)
        }
        if ($null -ne $policySettings.DeviceSettings.pol_hardenedPaths)
        {
            $complexPol_hardenedpaths = @()
            foreach ($currentPol_hardenedpaths in $policySettings.DeviceSettings.pol_hardenedPaths)
            {
                $myPol_hardenedpaths = @{}
                if ($null -ne $currentPol_hardenedpaths.value)
                {
                    $myPol_hardenedpaths.Add('Value', $currentPol_hardenedpaths.value)
                }
                if ($null -ne $currentPol_hardenedpaths.Key)
                {
                    $myPol_hardenedpaths.Add('Key', $currentPol_hardenedpaths.key)
                }
                if ($myPol_hardenedpaths.values.Where({ $null -ne $_ }).Count -gt 0)
                {
                    $complexPol_hardenedpaths += $myPol_hardenedpaths
                }
            }
            $complexDeviceSettings.Add('pol_hardenedPaths', $complexPol_hardenedpaths)
        }
        if ($null -ne $policySettings.DeviceSettings.wCM_BlockNonDomain)
        {
            $complexDeviceSettings.Add('WCM_BlockNonDomain', $policySettings.DeviceSettings.wCM_BlockNonDomain)
        }
        if ($null -ne $policySettings.DeviceSettings.configureRedirectionGuardPolicy)
        {
            $complexDeviceSettings.Add('ConfigureRedirectionGuardPolicy', $policySettings.DeviceSettings.configureRedirectionGuardPolicy)
        }
        if ($null -ne $policySettings.DeviceSettings.redirectionGuardPolicy_Enum)
        {
            $complexDeviceSettings.Add('RedirectionGuardPolicy_Enum', $policySettings.DeviceSettings.redirectionGuardPolicy_Enum)
        }
        if ($null -ne $policySettings.DeviceSettings.configureRpcConnectionPolicy)
        {
            $complexDeviceSettings.Add('ConfigureRpcConnectionPolicy', $policySettings.DeviceSettings.configureRpcConnectionPolicy)
        }
        if ($null -ne $policySettings.DeviceSettings.rpcConnectionAuthentication_Enum)
        {
            $complexDeviceSettings.Add('RpcConnectionAuthentication_Enum', $policySettings.DeviceSettings.rpcConnectionAuthentication_Enum)
        }
        if ($null -ne $policySettings.DeviceSettings.rpcConnectionProtocol_Enum)
        {
            $complexDeviceSettings.Add('RpcConnectionProtocol_Enum', $policySettings.DeviceSettings.rpcConnectionProtocol_Enum)
        }
        if ($null -ne $policySettings.DeviceSettings.configureRpcListenerPolicy)
        {
            $complexDeviceSettings.Add('ConfigureRpcListenerPolicy', $policySettings.DeviceSettings.configureRpcListenerPolicy)
        }
        if ($null -ne $policySettings.DeviceSettings.rpcAuthenticationProtocol_Enum)
        {
            $complexDeviceSettings.Add('RpcAuthenticationProtocol_Enum', $policySettings.DeviceSettings.rpcAuthenticationProtocol_Enum)
        }
        if ($null -ne $policySettings.DeviceSettings.rpcListenerProtocols_Enum)
        {
            $complexDeviceSettings.Add('RpcListenerProtocols_Enum', $policySettings.DeviceSettings.rpcListenerProtocols_Enum)
        }
        if ($null -ne $policySettings.DeviceSettings.configureRpcTcpPort)
        {
            $complexDeviceSettings.Add('ConfigureRpcTcpPort', $policySettings.DeviceSettings.configureRpcTcpPort)
        }
        if ($null -ne $policySettings.DeviceSettings.rpcTcpPort)
        {
            $complexDeviceSettings.Add('RpcTcpPort', $policySettings.DeviceSettings.rpcTcpPort)
        }
        if ($null -ne $policySettings.DeviceSettings.restrictDriverInstallationToAdministrators)
        {
            $complexDeviceSettings.Add('RestrictDriverInstallationToAdministrators', $policySettings.DeviceSettings.restrictDriverInstallationToAdministrators)
        }
        if ($null -ne $policySettings.DeviceSettings.configureCopyFilesPolicy)
        {
            $complexDeviceSettings.Add('ConfigureCopyFilesPolicy', $policySettings.DeviceSettings.configureCopyFilesPolicy)
        }
        if ($null -ne $policySettings.DeviceSettings.copyFilesPolicy_Enum)
        {
            $complexDeviceSettings.Add('CopyFilesPolicy_Enum', $policySettings.DeviceSettings.copyFilesPolicy_Enum)
        }
        if ($null -ne $policySettings.DeviceSettings.allowEncryptionOracle)
        {
            $complexDeviceSettings.Add('AllowEncryptionOracle', $policySettings.DeviceSettings.allowEncryptionOracle)
        }
        if ($null -ne $policySettings.DeviceSettings.allowEncryptionOracleDrop)
        {
            $complexDeviceSettings.Add('AllowEncryptionOracleDrop', $policySettings.DeviceSettings.allowEncryptionOracleDrop)
        }
        if ($null -ne $policySettings.DeviceSettings.allowProtectedCreds)
        {
            $complexDeviceSettings.Add('AllowProtectedCreds', $policySettings.DeviceSettings.allowProtectedCreds)
        }
        if ($null -ne $policySettings.DeviceSettings.deviceInstall_Classes_Deny)
        {
            $complexDeviceSettings.Add('DeviceInstall_Classes_Deny', $policySettings.DeviceSettings.deviceInstall_Classes_Deny)
        }
        if ($null -ne $policySettings.DeviceSettings.deviceInstall_Classes_Deny_List)
        {
            $complexDeviceSettings.Add('DeviceInstall_Classes_Deny_List', $policySettings.DeviceSettings.deviceInstall_Classes_Deny_List)
        }
        if ($null -ne $policySettings.DeviceSettings.deviceInstall_Classes_Deny_Retroactive)
        {
            $complexDeviceSettings.Add('DeviceInstall_Classes_Deny_Retroactive', $policySettings.DeviceSettings.deviceInstall_Classes_Deny_Retroactive)
        }
        if ($null -ne $policySettings.DeviceSettings.pOL_DriverLoadPolicy_Name)
        {
            $complexDeviceSettings.Add('POL_DriverLoadPolicy_Name', $policySettings.DeviceSettings.pOL_DriverLoadPolicy_Name)
        }
        if ($null -ne $policySettings.DeviceSettings.selectDriverLoadPolicy)
        {
            $complexDeviceSettings.Add('SelectDriverLoadPolicy', $policySettings.DeviceSettings.selectDriverLoadPolicy)
        }
        if ($null -ne $policySettings.DeviceSettings.cSE_Registry)
        {
            $complexDeviceSettings.Add('CSE_Registry', $policySettings.DeviceSettings.cSE_Registry)
        }
        if ($null -ne $policySettings.DeviceSettings.cSE_NOBACKGROUND10)
        {
            $complexDeviceSettings.Add('CSE_NOBACKGROUND10', $policySettings.DeviceSettings.cSE_NOBACKGROUND10)
        }
        if ($null -ne $policySettings.DeviceSettings.cSE_NOCHANGES10)
        {
            $complexDeviceSettings.Add('CSE_NOCHANGES10', $policySettings.DeviceSettings.cSE_NOCHANGES10)
        }
        if ($null -ne $policySettings.DeviceSettings.disableWebPnPDownload_2)
        {
            $complexDeviceSettings.Add('DisableWebPnPDownload_2', $policySettings.DeviceSettings.disableWebPnPDownload_2)
        }
        if ($null -ne $policySettings.DeviceSettings.shellPreventWPWDownload_2)
        {
            $complexDeviceSettings.Add('ShellPreventWPWDownload_2', $policySettings.DeviceSettings.shellPreventWPWDownload_2)
        }
        if ($null -ne $policySettings.DeviceSettings.allowCustomSSPsAPs)
        {
            $complexDeviceSettings.Add('AllowCustomSSPsAPs', $policySettings.DeviceSettings.allowCustomSSPsAPs)
        }
        if ($null -ne $policySettings.DeviceSettings.allowStandbyStatesDC_2)
        {
            $complexDeviceSettings.Add('AllowStandbyStatesDC_2', $policySettings.DeviceSettings.allowStandbyStatesDC_2)
        }
        if ($null -ne $policySettings.DeviceSettings.allowStandbyStatesAC_2)
        {
            $complexDeviceSettings.Add('AllowStandbyStatesAC_2', $policySettings.DeviceSettings.allowStandbyStatesAC_2)
        }
        if ($null -ne $policySettings.DeviceSettings.dCPromptForPasswordOnResume_2)
        {
            $complexDeviceSettings.Add('DCPromptForPasswordOnResume_2', $policySettings.DeviceSettings.dCPromptForPasswordOnResume_2)
        }
        if ($null -ne $policySettings.DeviceSettings.aCPromptForPasswordOnResume_2)
        {
            $complexDeviceSettings.Add('ACPromptForPasswordOnResume_2', $policySettings.DeviceSettings.aCPromptForPasswordOnResume_2)
        }
        if ($null -ne $policySettings.DeviceSettings.rA_Solicit)
        {
            $complexDeviceSettings.Add('RA_Solicit', $policySettings.DeviceSettings.rA_Solicit)
        }
        if ($null -ne $policySettings.DeviceSettings.rA_Solicit_ExpireUnits_List)
        {
            $complexDeviceSettings.Add('RA_Solicit_ExpireUnits_List', $policySettings.DeviceSettings.rA_Solicit_ExpireUnits_List)
        }
        if ($null -ne $policySettings.DeviceSettings.rA_Solicit_ExpireValue_Edt)
        {
            $complexDeviceSettings.Add('RA_Solicit_ExpireValue_Edt', $policySettings.DeviceSettings.rA_Solicit_ExpireValue_Edt)
        }
        if ($null -ne $policySettings.DeviceSettings.rA_Solicit_Control_List)
        {
            $complexDeviceSettings.Add('RA_Solicit_Control_List', $policySettings.DeviceSettings.rA_Solicit_Control_List)
        }
        if ($null -ne $policySettings.DeviceSettings.rA_Solicit_Mailto_List)
        {
            $complexDeviceSettings.Add('RA_Solicit_Mailto_List', $policySettings.DeviceSettings.rA_Solicit_Mailto_List)
        }
        if ($null -ne $policySettings.DeviceSettings.rpcRestrictRemoteClients)
        {
            $complexDeviceSettings.Add('RpcRestrictRemoteClients', $policySettings.DeviceSettings.rpcRestrictRemoteClients)
        }
        if ($null -ne $policySettings.DeviceSettings.rpcRestrictRemoteClientsList)
        {
            $complexDeviceSettings.Add('RpcRestrictRemoteClientsList', $policySettings.DeviceSettings.rpcRestrictRemoteClientsList)
        }
        if ($null -ne $policySettings.DeviceSettings.appxRuntimeMicrosoftAccountsOptional)
        {
            $complexDeviceSettings.Add('AppxRuntimeMicrosoftAccountsOptional', $policySettings.DeviceSettings.appxRuntimeMicrosoftAccountsOptional)
        }
        if ($null -ne $policySettings.DeviceSettings.noAutoplayfornonVolume)
        {
            $complexDeviceSettings.Add('NoAutoplayfornonVolume', $policySettings.DeviceSettings.noAutoplayfornonVolume)
        }
        if ($null -ne $policySettings.DeviceSettings.noAutorun)
        {
            $complexDeviceSettings.Add('NoAutorun', $policySettings.DeviceSettings.noAutorun)
        }
        if ($null -ne $policySettings.DeviceSettings.noAutorun_Dropdown)
        {
            $complexDeviceSettings.Add('NoAutorun_Dropdown', $policySettings.DeviceSettings.noAutorun_Dropdown)
        }
        if ($null -ne $policySettings.DeviceSettings.autorun)
        {
            $complexDeviceSettings.Add('Autorun', $policySettings.DeviceSettings.autorun)
        }
        if ($null -ne $policySettings.DeviceSettings.autorun_Box)
        {
            $complexDeviceSettings.Add('Autorun_Box', $policySettings.DeviceSettings.autorun_Box)
        }
        if ($null -ne $policySettings.DeviceSettings.fDVDenyWriteAccess_Name)
        {
            $complexDeviceSettings.Add('FDVDenyWriteAccess_Name', $policySettings.DeviceSettings.fDVDenyWriteAccess_Name)
        }
        if ($null -ne $policySettings.DeviceSettings.rDVDenyWriteAccess_Name)
        {
            $complexDeviceSettings.Add('RDVDenyWriteAccess_Name', $policySettings.DeviceSettings.rDVDenyWriteAccess_Name)
        }
        if ($null -ne $policySettings.DeviceSettings.rDVCrossOrg)
        {
            $complexDeviceSettings.Add('RDVCrossOrg', $policySettings.DeviceSettings.rDVCrossOrg)
        }
        if ($null -ne $policySettings.DeviceSettings.enumerateAdministrators)
        {
            $complexDeviceSettings.Add('EnumerateAdministrators', $policySettings.DeviceSettings.enumerateAdministrators)
        }
        if ($null -ne $policySettings.DeviceSettings.channel_LogMaxSize_1)
        {
            $complexDeviceSettings.Add('Channel_LogMaxSize_1', $policySettings.DeviceSettings.channel_LogMaxSize_1)
        }
        if ($null -ne $policySettings.DeviceSettings.channel_LogMaxSize_1_Channel_LogMaxSize)
        {
            $complexDeviceSettings.Add('Channel_LogMaxSize_1_Channel_LogMaxSize', $policySettings.DeviceSettings.channel_LogMaxSize_1_Channel_LogMaxSize)
        }
        if ($null -ne $policySettings.DeviceSettings.channel_LogMaxSize_2)
        {
            $complexDeviceSettings.Add('Channel_LogMaxSize_2', $policySettings.DeviceSettings.channel_LogMaxSize_2)
        }
        if ($null -ne $policySettings.DeviceSettings.channel_LogMaxSize_2_Channel_LogMaxSize)
        {
            $complexDeviceSettings.Add('Channel_LogMaxSize_2_Channel_LogMaxSize', $policySettings.DeviceSettings.channel_LogMaxSize_2_Channel_LogMaxSize)
        }
        if ($null -ne $policySettings.DeviceSettings.channel_LogMaxSize_4)
        {
            $complexDeviceSettings.Add('Channel_LogMaxSize_4', $policySettings.DeviceSettings.channel_LogMaxSize_4)
        }
        if ($null -ne $policySettings.DeviceSettings.channel_LogMaxSize_4_Channel_LogMaxSize)
        {
            $complexDeviceSettings.Add('Channel_LogMaxSize_4_Channel_LogMaxSize', $policySettings.DeviceSettings.channel_LogMaxSize_4_Channel_LogMaxSize)
        }
        if ($null -ne $policySettings.DeviceSettings.enableSmartScreen)
        {
            $complexDeviceSettings.Add('EnableSmartScreen', $policySettings.DeviceSettings.enableSmartScreen)
        }
        if ($null -ne $policySettings.DeviceSettings.enableSmartScreenDropdown)
        {
            $complexDeviceSettings.Add('EnableSmartScreenDropdown', $policySettings.DeviceSettings.enableSmartScreenDropdown)
        }
        if ($null -ne $policySettings.DeviceSettings.noDataExecutionPrevention)
        {
            $complexDeviceSettings.Add('NoDataExecutionPrevention', $policySettings.DeviceSettings.noDataExecutionPrevention)
        }
        if ($null -ne $policySettings.DeviceSettings.noHeapTerminationOnCorruption)
        {
            $complexDeviceSettings.Add('NoHeapTerminationOnCorruption', $policySettings.DeviceSettings.noHeapTerminationOnCorruption)
        }
        if ($null -ne $policySettings.DeviceSettings.advanced_InvalidSignatureBlock)
        {
            $complexDeviceSettings.Add('Advanced_InvalidSignatureBlock', $policySettings.DeviceSettings.advanced_InvalidSignatureBlock)
        }
        if ($null -ne $policySettings.DeviceSettings.advanced_CertificateRevocation)
        {
            $complexDeviceSettings.Add('Advanced_CertificateRevocation', $policySettings.DeviceSettings.advanced_CertificateRevocation)
        }
        if ($null -ne $policySettings.DeviceSettings.advanced_DownloadSignatures)
        {
            $complexDeviceSettings.Add('Advanced_DownloadSignatures', $policySettings.DeviceSettings.advanced_DownloadSignatures)
        }
        if ($null -ne $policySettings.DeviceSettings.advanced_DisableEPMCompat)
        {
            $complexDeviceSettings.Add('Advanced_DisableEPMCompat', $policySettings.DeviceSettings.advanced_DisableEPMCompat)
        }
        if ($null -ne $policySettings.DeviceSettings.advanced_SetWinInetProtocols)
        {
            $complexDeviceSettings.Add('Advanced_SetWinInetProtocols', $policySettings.DeviceSettings.advanced_SetWinInetProtocols)
        }
        if ($null -ne $policySettings.DeviceSettings.advanced_WinInetProtocolOptions)
        {
            $complexDeviceSettings.Add('Advanced_WinInetProtocolOptions', $policySettings.DeviceSettings.advanced_WinInetProtocolOptions)
        }
        if ($null -ne $policySettings.DeviceSettings.advanced_EnableEnhancedProtectedMode64Bit)
        {
            $complexDeviceSettings.Add('Advanced_EnableEnhancedProtectedMode64Bit', $policySettings.DeviceSettings.advanced_EnableEnhancedProtectedMode64Bit)
        }
        if ($null -ne $policySettings.DeviceSettings.advanced_EnableEnhancedProtectedMode)
        {
            $complexDeviceSettings.Add('Advanced_EnableEnhancedProtectedMode', $policySettings.DeviceSettings.advanced_EnableEnhancedProtectedMode)
        }
        if ($null -ne $policySettings.DeviceSettings.noCertError)
        {
            $complexDeviceSettings.Add('NoCertError', $policySettings.DeviceSettings.noCertError)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyAccessDataSourcesAcrossDomains_1)
        {
            $complexDeviceSettings.Add('IZ_PolicyAccessDataSourcesAcrossDomains_1', $policySettings.DeviceSettings.iZ_PolicyAccessDataSourcesAcrossDomains_1)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyAccessDataSourcesAcrossDomains_1_IZ_Partname1406)
        {
            $complexDeviceSettings.Add('IZ_PolicyAccessDataSourcesAcrossDomains_1_IZ_Partname1406', $policySettings.DeviceSettings.iZ_PolicyAccessDataSourcesAcrossDomains_1_IZ_Partname1406)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyAllowPasteViaScript_1)
        {
            $complexDeviceSettings.Add('IZ_PolicyAllowPasteViaScript_1', $policySettings.DeviceSettings.iZ_PolicyAllowPasteViaScript_1)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyAllowPasteViaScript_1_IZ_Partname1407)
        {
            $complexDeviceSettings.Add('IZ_PolicyAllowPasteViaScript_1_IZ_Partname1407', $policySettings.DeviceSettings.iZ_PolicyAllowPasteViaScript_1_IZ_Partname1407)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyDropOrPasteFiles_1)
        {
            $complexDeviceSettings.Add('IZ_PolicyDropOrPasteFiles_1', $policySettings.DeviceSettings.iZ_PolicyDropOrPasteFiles_1)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyDropOrPasteFiles_1_IZ_Partname1802)
        {
            $complexDeviceSettings.Add('IZ_PolicyDropOrPasteFiles_1_IZ_Partname1802', $policySettings.DeviceSettings.iZ_PolicyDropOrPasteFiles_1_IZ_Partname1802)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_XAML_1)
        {
            $complexDeviceSettings.Add('IZ_Policy_XAML_1', $policySettings.DeviceSettings.iZ_Policy_XAML_1)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_XAML_1_IZ_Partname2402)
        {
            $complexDeviceSettings.Add('IZ_Policy_XAML_1_IZ_Partname2402', $policySettings.DeviceSettings.iZ_Policy_XAML_1_IZ_Partname2402)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyOnlyAllowApprovedDomainsToUseActiveXWithoutPrompt_Both_Internet)
        {
            $complexDeviceSettings.Add('IZ_PolicyOnlyAllowApprovedDomainsToUseActiveXWithoutPrompt_Both_Internet', $policySettings.DeviceSettings.iZ_PolicyOnlyAllowApprovedDomainsToUseActiveXWithoutPrompt_Both_Internet)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyOnlyAllowApprovedDomainsToUseActiveXWithoutPrompt_Both_Internet_IZ_Partname120b)
        {
            $complexDeviceSettings.Add('IZ_PolicyOnlyAllowApprovedDomainsToUseActiveXWithoutPrompt_Both_Internet_IZ_Partname120b', $policySettings.DeviceSettings.iZ_PolicyOnlyAllowApprovedDomainsToUseActiveXWithoutPrompt_Both_Internet_IZ_Partname120b)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyAllowTDCControl_Both_Internet)
        {
            $complexDeviceSettings.Add('IZ_PolicyAllowTDCControl_Both_Internet', $policySettings.DeviceSettings.iZ_PolicyAllowTDCControl_Both_Internet)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyAllowTDCControl_Both_Internet_IZ_Partname120c)
        {
            $complexDeviceSettings.Add('IZ_PolicyAllowTDCControl_Both_Internet_IZ_Partname120c', $policySettings.DeviceSettings.iZ_PolicyAllowTDCControl_Both_Internet_IZ_Partname120c)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyWindowsRestrictionsURLaction_1)
        {
            $complexDeviceSettings.Add('IZ_PolicyWindowsRestrictionsURLaction_1', $policySettings.DeviceSettings.iZ_PolicyWindowsRestrictionsURLaction_1)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyWindowsRestrictionsURLaction_1_IZ_Partname2102)
        {
            $complexDeviceSettings.Add('IZ_PolicyWindowsRestrictionsURLaction_1_IZ_Partname2102', $policySettings.DeviceSettings.iZ_PolicyWindowsRestrictionsURLaction_1_IZ_Partname2102)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_WebBrowserControl_1)
        {
            $complexDeviceSettings.Add('IZ_Policy_WebBrowserControl_1', $policySettings.DeviceSettings.iZ_Policy_WebBrowserControl_1)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_WebBrowserControl_1_IZ_Partname1206)
        {
            $complexDeviceSettings.Add('IZ_Policy_WebBrowserControl_1_IZ_Partname1206', $policySettings.DeviceSettings.iZ_Policy_WebBrowserControl_1_IZ_Partname1206)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_AllowScriptlets_1)
        {
            $complexDeviceSettings.Add('IZ_Policy_AllowScriptlets_1', $policySettings.DeviceSettings.iZ_Policy_AllowScriptlets_1)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_AllowScriptlets_1_IZ_Partname1209)
        {
            $complexDeviceSettings.Add('IZ_Policy_AllowScriptlets_1_IZ_Partname1209', $policySettings.DeviceSettings.iZ_Policy_AllowScriptlets_1_IZ_Partname1209)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_ScriptStatusBar_1)
        {
            $complexDeviceSettings.Add('IZ_Policy_ScriptStatusBar_1', $policySettings.DeviceSettings.iZ_Policy_ScriptStatusBar_1)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_ScriptStatusBar_1_IZ_Partname2103)
        {
            $complexDeviceSettings.Add('IZ_Policy_ScriptStatusBar_1_IZ_Partname2103', $policySettings.DeviceSettings.iZ_Policy_ScriptStatusBar_1_IZ_Partname2103)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyAllowVBScript_1)
        {
            $complexDeviceSettings.Add('IZ_PolicyAllowVBScript_1', $policySettings.DeviceSettings.iZ_PolicyAllowVBScript_1)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyAllowVBScript_1_IZ_Partname140C)
        {
            $complexDeviceSettings.Add('IZ_PolicyAllowVBScript_1_IZ_Partname140C', $policySettings.DeviceSettings.iZ_PolicyAllowVBScript_1_IZ_Partname140C)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyNotificationBarDownloadURLaction_1)
        {
            $complexDeviceSettings.Add('IZ_PolicyNotificationBarDownloadURLaction_1', $policySettings.DeviceSettings.iZ_PolicyNotificationBarDownloadURLaction_1)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyNotificationBarDownloadURLaction_1_IZ_Partname2200)
        {
            $complexDeviceSettings.Add('IZ_PolicyNotificationBarDownloadURLaction_1_IZ_Partname2200', $policySettings.DeviceSettings.iZ_PolicyNotificationBarDownloadURLaction_1_IZ_Partname2200)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_1)
        {
            $complexDeviceSettings.Add('IZ_PolicyAntiMalwareCheckingOfActiveXControls_1', $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_1)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_1_IZ_Partname270C)
        {
            $complexDeviceSettings.Add('IZ_PolicyAntiMalwareCheckingOfActiveXControls_1_IZ_Partname270C', $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_1_IZ_Partname270C)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyDownloadSignedActiveX_1)
        {
            $complexDeviceSettings.Add('IZ_PolicyDownloadSignedActiveX_1', $policySettings.DeviceSettings.iZ_PolicyDownloadSignedActiveX_1)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyDownloadSignedActiveX_1_IZ_Partname1001)
        {
            $complexDeviceSettings.Add('IZ_PolicyDownloadSignedActiveX_1_IZ_Partname1001', $policySettings.DeviceSettings.iZ_PolicyDownloadSignedActiveX_1_IZ_Partname1001)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyDownloadUnsignedActiveX_1)
        {
            $complexDeviceSettings.Add('IZ_PolicyDownloadUnsignedActiveX_1', $policySettings.DeviceSettings.iZ_PolicyDownloadUnsignedActiveX_1)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyDownloadUnsignedActiveX_1_IZ_Partname1004)
        {
            $complexDeviceSettings.Add('IZ_PolicyDownloadUnsignedActiveX_1_IZ_Partname1004', $policySettings.DeviceSettings.iZ_PolicyDownloadUnsignedActiveX_1_IZ_Partname1004)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyDragDropAcrossDomainsAcrossWindows_Both_Internet)
        {
            $complexDeviceSettings.Add('IZ_PolicyDragDropAcrossDomainsAcrossWindows_Both_Internet', $policySettings.DeviceSettings.iZ_PolicyDragDropAcrossDomainsAcrossWindows_Both_Internet)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyDragDropAcrossDomainsAcrossWindows_Both_Internet_IZ_Partname2709)
        {
            $complexDeviceSettings.Add('IZ_PolicyDragDropAcrossDomainsAcrossWindows_Both_Internet_IZ_Partname2709', $policySettings.DeviceSettings.iZ_PolicyDragDropAcrossDomainsAcrossWindows_Both_Internet_IZ_Partname2709)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyDragDropAcrossDomainsWithinWindow_Both_Internet)
        {
            $complexDeviceSettings.Add('IZ_PolicyDragDropAcrossDomainsWithinWindow_Both_Internet', $policySettings.DeviceSettings.iZ_PolicyDragDropAcrossDomainsWithinWindow_Both_Internet)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyDragDropAcrossDomainsWithinWindow_Both_Internet_IZ_Partname2708)
        {
            $complexDeviceSettings.Add('IZ_PolicyDragDropAcrossDomainsWithinWindow_Both_Internet_IZ_Partname2708', $policySettings.DeviceSettings.iZ_PolicyDragDropAcrossDomainsWithinWindow_Both_Internet_IZ_Partname2708)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_LocalPathForUpload_1)
        {
            $complexDeviceSettings.Add('IZ_Policy_LocalPathForUpload_1', $policySettings.DeviceSettings.iZ_Policy_LocalPathForUpload_1)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_LocalPathForUpload_1_IZ_Partname160A)
        {
            $complexDeviceSettings.Add('IZ_Policy_LocalPathForUpload_1_IZ_Partname160A', $policySettings.DeviceSettings.iZ_Policy_LocalPathForUpload_1_IZ_Partname160A)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyScriptActiveXNotMarkedSafe_1)
        {
            $complexDeviceSettings.Add('IZ_PolicyScriptActiveXNotMarkedSafe_1', $policySettings.DeviceSettings.iZ_PolicyScriptActiveXNotMarkedSafe_1)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyScriptActiveXNotMarkedSafe_1_IZ_Partname1201)
        {
            $complexDeviceSettings.Add('IZ_PolicyScriptActiveXNotMarkedSafe_1_IZ_Partname1201', $policySettings.DeviceSettings.iZ_PolicyScriptActiveXNotMarkedSafe_1_IZ_Partname1201)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_1)
        {
            $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_1', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_1)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_1_IZ_Partname1C00)
        {
            $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_1_IZ_Partname1C00', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_1_IZ_Partname1C00)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyLaunchAppsAndFilesInIFRAME_1)
        {
            $complexDeviceSettings.Add('IZ_PolicyLaunchAppsAndFilesInIFRAME_1', $policySettings.DeviceSettings.iZ_PolicyLaunchAppsAndFilesInIFRAME_1)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyLaunchAppsAndFilesInIFRAME_1_IZ_Partname1804)
        {
            $complexDeviceSettings.Add('IZ_PolicyLaunchAppsAndFilesInIFRAME_1_IZ_Partname1804', $policySettings.DeviceSettings.iZ_PolicyLaunchAppsAndFilesInIFRAME_1_IZ_Partname1804)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyLogon_1)
        {
            $complexDeviceSettings.Add('IZ_PolicyLogon_1', $policySettings.DeviceSettings.iZ_PolicyLogon_1)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyLogon_1_IZ_Partname1A00)
        {
            $complexDeviceSettings.Add('IZ_PolicyLogon_1_IZ_Partname1A00', $policySettings.DeviceSettings.iZ_PolicyLogon_1_IZ_Partname1A00)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyNavigateSubframesAcrossDomains_1)
        {
            $complexDeviceSettings.Add('IZ_PolicyNavigateSubframesAcrossDomains_1', $policySettings.DeviceSettings.iZ_PolicyNavigateSubframesAcrossDomains_1)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyNavigateSubframesAcrossDomains_1_IZ_Partname1607)
        {
            $complexDeviceSettings.Add('IZ_PolicyNavigateSubframesAcrossDomains_1_IZ_Partname1607', $policySettings.DeviceSettings.iZ_PolicyNavigateSubframesAcrossDomains_1_IZ_Partname1607)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyUnsignedFrameworkComponentsURLaction_1)
        {
            $complexDeviceSettings.Add('IZ_PolicyUnsignedFrameworkComponentsURLaction_1', $policySettings.DeviceSettings.iZ_PolicyUnsignedFrameworkComponentsURLaction_1)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyUnsignedFrameworkComponentsURLaction_1_IZ_Partname2004)
        {
            $complexDeviceSettings.Add('IZ_PolicyUnsignedFrameworkComponentsURLaction_1_IZ_Partname2004', $policySettings.DeviceSettings.iZ_PolicyUnsignedFrameworkComponentsURLaction_1_IZ_Partname2004)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicySignedFrameworkComponentsURLaction_1)
        {
            $complexDeviceSettings.Add('IZ_PolicySignedFrameworkComponentsURLaction_1', $policySettings.DeviceSettings.iZ_PolicySignedFrameworkComponentsURLaction_1)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicySignedFrameworkComponentsURLaction_1_IZ_Partname2001)
        {
            $complexDeviceSettings.Add('IZ_PolicySignedFrameworkComponentsURLaction_1_IZ_Partname2001', $policySettings.DeviceSettings.iZ_PolicySignedFrameworkComponentsURLaction_1_IZ_Partname2001)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_UnsafeFiles_1)
        {
            $complexDeviceSettings.Add('IZ_Policy_UnsafeFiles_1', $policySettings.DeviceSettings.iZ_Policy_UnsafeFiles_1)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_UnsafeFiles_1_IZ_Partname1806)
        {
            $complexDeviceSettings.Add('IZ_Policy_UnsafeFiles_1_IZ_Partname1806', $policySettings.DeviceSettings.iZ_Policy_UnsafeFiles_1_IZ_Partname1806)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyTurnOnXSSFilter_Both_Internet)
        {
            $complexDeviceSettings.Add('IZ_PolicyTurnOnXSSFilter_Both_Internet', $policySettings.DeviceSettings.iZ_PolicyTurnOnXSSFilter_Both_Internet)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyTurnOnXSSFilter_Both_Internet_IZ_Partname1409)
        {
            $complexDeviceSettings.Add('IZ_PolicyTurnOnXSSFilter_Both_Internet_IZ_Partname1409', $policySettings.DeviceSettings.iZ_PolicyTurnOnXSSFilter_Both_Internet_IZ_Partname1409)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_TurnOnProtectedMode_1)
        {
            $complexDeviceSettings.Add('IZ_Policy_TurnOnProtectedMode_1', $policySettings.DeviceSettings.iZ_Policy_TurnOnProtectedMode_1)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_TurnOnProtectedMode_1_IZ_Partname2500)
        {
            $complexDeviceSettings.Add('IZ_Policy_TurnOnProtectedMode_1_IZ_Partname2500', $policySettings.DeviceSettings.iZ_Policy_TurnOnProtectedMode_1_IZ_Partname2500)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_Phishing_1)
        {
            $complexDeviceSettings.Add('IZ_Policy_Phishing_1', $policySettings.DeviceSettings.iZ_Policy_Phishing_1)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_Phishing_1_IZ_Partname2301)
        {
            $complexDeviceSettings.Add('IZ_Policy_Phishing_1_IZ_Partname2301', $policySettings.DeviceSettings.iZ_Policy_Phishing_1_IZ_Partname2301)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyBlockPopupWindows_1)
        {
            $complexDeviceSettings.Add('IZ_PolicyBlockPopupWindows_1', $policySettings.DeviceSettings.iZ_PolicyBlockPopupWindows_1)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyBlockPopupWindows_1_IZ_Partname1809)
        {
            $complexDeviceSettings.Add('IZ_PolicyBlockPopupWindows_1_IZ_Partname1809', $policySettings.DeviceSettings.iZ_PolicyBlockPopupWindows_1_IZ_Partname1809)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyUserdataPersistence_1)
        {
            $complexDeviceSettings.Add('IZ_PolicyUserdataPersistence_1', $policySettings.DeviceSettings.iZ_PolicyUserdataPersistence_1)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyUserdataPersistence_1_IZ_Partname1606)
        {
            $complexDeviceSettings.Add('IZ_PolicyUserdataPersistence_1_IZ_Partname1606', $policySettings.DeviceSettings.iZ_PolicyUserdataPersistence_1_IZ_Partname1606)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyZoneElevationURLaction_1)
        {
            $complexDeviceSettings.Add('IZ_PolicyZoneElevationURLaction_1', $policySettings.DeviceSettings.iZ_PolicyZoneElevationURLaction_1)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyZoneElevationURLaction_1_IZ_Partname2101)
        {
            $complexDeviceSettings.Add('IZ_PolicyZoneElevationURLaction_1_IZ_Partname2101', $policySettings.DeviceSettings.iZ_PolicyZoneElevationURLaction_1_IZ_Partname2101)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_UNCAsIntranet)
        {
            $complexDeviceSettings.Add('IZ_UNCAsIntranet', $policySettings.DeviceSettings.iZ_UNCAsIntranet)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_3)
        {
            $complexDeviceSettings.Add('IZ_PolicyAntiMalwareCheckingOfActiveXControls_3', $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_3)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_3_IZ_Partname270C)
        {
            $complexDeviceSettings.Add('IZ_PolicyAntiMalwareCheckingOfActiveXControls_3_IZ_Partname270C', $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_3_IZ_Partname270C)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyScriptActiveXNotMarkedSafe_3)
        {
            $complexDeviceSettings.Add('IZ_PolicyScriptActiveXNotMarkedSafe_3', $policySettings.DeviceSettings.iZ_PolicyScriptActiveXNotMarkedSafe_3)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyScriptActiveXNotMarkedSafe_3_IZ_Partname1201)
        {
            $complexDeviceSettings.Add('IZ_PolicyScriptActiveXNotMarkedSafe_3_IZ_Partname1201', $policySettings.DeviceSettings.iZ_PolicyScriptActiveXNotMarkedSafe_3_IZ_Partname1201)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_3)
        {
            $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_3', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_3)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_3_IZ_Partname1C00)
        {
            $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_3_IZ_Partname1C00', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_3_IZ_Partname1C00)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_9)
        {
            $complexDeviceSettings.Add('IZ_PolicyAntiMalwareCheckingOfActiveXControls_9', $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_9)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_9_IZ_Partname270C)
        {
            $complexDeviceSettings.Add('IZ_PolicyAntiMalwareCheckingOfActiveXControls_9_IZ_Partname270C', $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_9_IZ_Partname270C)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_9)
        {
            $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_9', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_9)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_9_IZ_Partname1C00)
        {
            $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_9_IZ_Partname1C00', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_9_IZ_Partname1C00)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_Phishing_2)
        {
            $complexDeviceSettings.Add('IZ_Policy_Phishing_2', $policySettings.DeviceSettings.iZ_Policy_Phishing_2)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_Phishing_2_IZ_Partname2301)
        {
            $complexDeviceSettings.Add('IZ_Policy_Phishing_2_IZ_Partname2301', $policySettings.DeviceSettings.iZ_Policy_Phishing_2_IZ_Partname2301)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_4)
        {
            $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_4', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_4)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_4_IZ_Partname1C00)
        {
            $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_4_IZ_Partname1C00', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_4_IZ_Partname1C00)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_10)
        {
            $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_10', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_10)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_10_IZ_Partname1C00)
        {
            $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_10_IZ_Partname1C00', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_10_IZ_Partname1C00)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_8)
        {
            $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_8', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_8)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_8_IZ_Partname1C00)
        {
            $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_8_IZ_Partname1C00', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_8_IZ_Partname1C00)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_Phishing_8)
        {
            $complexDeviceSettings.Add('IZ_Policy_Phishing_8', $policySettings.DeviceSettings.iZ_Policy_Phishing_8)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_Phishing_8_IZ_Partname2301)
        {
            $complexDeviceSettings.Add('IZ_Policy_Phishing_8_IZ_Partname2301', $policySettings.DeviceSettings.iZ_Policy_Phishing_8_IZ_Partname2301)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_6)
        {
            $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_6', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_6)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_6_IZ_Partname1C00)
        {
            $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_6_IZ_Partname1C00', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_6_IZ_Partname1C00)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyAccessDataSourcesAcrossDomains_7)
        {
            $complexDeviceSettings.Add('IZ_PolicyAccessDataSourcesAcrossDomains_7', $policySettings.DeviceSettings.iZ_PolicyAccessDataSourcesAcrossDomains_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyAccessDataSourcesAcrossDomains_7_IZ_Partname1406)
        {
            $complexDeviceSettings.Add('IZ_PolicyAccessDataSourcesAcrossDomains_7_IZ_Partname1406', $policySettings.DeviceSettings.iZ_PolicyAccessDataSourcesAcrossDomains_7_IZ_Partname1406)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyActiveScripting_7)
        {
            $complexDeviceSettings.Add('IZ_PolicyActiveScripting_7', $policySettings.DeviceSettings.iZ_PolicyActiveScripting_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Partname1400)
        {
            $complexDeviceSettings.Add('IZ_Partname1400', $policySettings.DeviceSettings.iZ_Partname1400)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyBinaryBehaviors_7)
        {
            $complexDeviceSettings.Add('IZ_PolicyBinaryBehaviors_7', $policySettings.DeviceSettings.iZ_PolicyBinaryBehaviors_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Partname2000)
        {
            $complexDeviceSettings.Add('IZ_Partname2000', $policySettings.DeviceSettings.iZ_Partname2000)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyAllowPasteViaScript_7)
        {
            $complexDeviceSettings.Add('IZ_PolicyAllowPasteViaScript_7', $policySettings.DeviceSettings.iZ_PolicyAllowPasteViaScript_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyAllowPasteViaScript_7_IZ_Partname1407)
        {
            $complexDeviceSettings.Add('IZ_PolicyAllowPasteViaScript_7_IZ_Partname1407', $policySettings.DeviceSettings.iZ_PolicyAllowPasteViaScript_7_IZ_Partname1407)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyDropOrPasteFiles_7)
        {
            $complexDeviceSettings.Add('IZ_PolicyDropOrPasteFiles_7', $policySettings.DeviceSettings.iZ_PolicyDropOrPasteFiles_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyDropOrPasteFiles_7_IZ_Partname1802)
        {
            $complexDeviceSettings.Add('IZ_PolicyDropOrPasteFiles_7_IZ_Partname1802', $policySettings.DeviceSettings.iZ_PolicyDropOrPasteFiles_7_IZ_Partname1802)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyFileDownload_7)
        {
            $complexDeviceSettings.Add('IZ_PolicyFileDownload_7', $policySettings.DeviceSettings.iZ_PolicyFileDownload_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Partname1803)
        {
            $complexDeviceSettings.Add('IZ_Partname1803', $policySettings.DeviceSettings.iZ_Partname1803)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_XAML_7)
        {
            $complexDeviceSettings.Add('IZ_Policy_XAML_7', $policySettings.DeviceSettings.iZ_Policy_XAML_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_XAML_7_IZ_Partname2402)
        {
            $complexDeviceSettings.Add('IZ_Policy_XAML_7_IZ_Partname2402', $policySettings.DeviceSettings.iZ_Policy_XAML_7_IZ_Partname2402)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyAllowMETAREFRESH_7)
        {
            $complexDeviceSettings.Add('IZ_PolicyAllowMETAREFRESH_7', $policySettings.DeviceSettings.iZ_PolicyAllowMETAREFRESH_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Partname1608)
        {
            $complexDeviceSettings.Add('IZ_Partname1608', $policySettings.DeviceSettings.iZ_Partname1608)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyOnlyAllowApprovedDomainsToUseActiveXWithoutPrompt_Both_Restricted)
        {
            $complexDeviceSettings.Add('IZ_PolicyOnlyAllowApprovedDomainsToUseActiveXWithoutPrompt_Both_Restricted', $policySettings.DeviceSettings.iZ_PolicyOnlyAllowApprovedDomainsToUseActiveXWithoutPrompt_Both_Restricted)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyOnlyAllowApprovedDomainsToUseActiveXWithoutPrompt_Both_Restricted_IZ_Partname120b)
        {
            $complexDeviceSettings.Add('IZ_PolicyOnlyAllowApprovedDomainsToUseActiveXWithoutPrompt_Both_Restricted_IZ_Partname120b', $policySettings.DeviceSettings.iZ_PolicyOnlyAllowApprovedDomainsToUseActiveXWithoutPrompt_Both_Restricted_IZ_Partname120b)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyAllowTDCControl_Both_Restricted)
        {
            $complexDeviceSettings.Add('IZ_PolicyAllowTDCControl_Both_Restricted', $policySettings.DeviceSettings.iZ_PolicyAllowTDCControl_Both_Restricted)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyAllowTDCControl_Both_Restricted_IZ_Partname120c)
        {
            $complexDeviceSettings.Add('IZ_PolicyAllowTDCControl_Both_Restricted_IZ_Partname120c', $policySettings.DeviceSettings.iZ_PolicyAllowTDCControl_Both_Restricted_IZ_Partname120c)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyWindowsRestrictionsURLaction_7)
        {
            $complexDeviceSettings.Add('IZ_PolicyWindowsRestrictionsURLaction_7', $policySettings.DeviceSettings.iZ_PolicyWindowsRestrictionsURLaction_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyWindowsRestrictionsURLaction_7_IZ_Partname2102)
        {
            $complexDeviceSettings.Add('IZ_PolicyWindowsRestrictionsURLaction_7_IZ_Partname2102', $policySettings.DeviceSettings.iZ_PolicyWindowsRestrictionsURLaction_7_IZ_Partname2102)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_WebBrowserControl_7)
        {
            $complexDeviceSettings.Add('IZ_Policy_WebBrowserControl_7', $policySettings.DeviceSettings.iZ_Policy_WebBrowserControl_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_WebBrowserControl_7_IZ_Partname1206)
        {
            $complexDeviceSettings.Add('IZ_Policy_WebBrowserControl_7_IZ_Partname1206', $policySettings.DeviceSettings.iZ_Policy_WebBrowserControl_7_IZ_Partname1206)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_AllowScriptlets_7)
        {
            $complexDeviceSettings.Add('IZ_Policy_AllowScriptlets_7', $policySettings.DeviceSettings.iZ_Policy_AllowScriptlets_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_AllowScriptlets_7_IZ_Partname1209)
        {
            $complexDeviceSettings.Add('IZ_Policy_AllowScriptlets_7_IZ_Partname1209', $policySettings.DeviceSettings.iZ_Policy_AllowScriptlets_7_IZ_Partname1209)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_ScriptStatusBar_7)
        {
            $complexDeviceSettings.Add('IZ_Policy_ScriptStatusBar_7', $policySettings.DeviceSettings.iZ_Policy_ScriptStatusBar_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_ScriptStatusBar_7_IZ_Partname2103)
        {
            $complexDeviceSettings.Add('IZ_Policy_ScriptStatusBar_7_IZ_Partname2103', $policySettings.DeviceSettings.iZ_Policy_ScriptStatusBar_7_IZ_Partname2103)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyAllowVBScript_7)
        {
            $complexDeviceSettings.Add('IZ_PolicyAllowVBScript_7', $policySettings.DeviceSettings.iZ_PolicyAllowVBScript_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyAllowVBScript_7_IZ_Partname140C)
        {
            $complexDeviceSettings.Add('IZ_PolicyAllowVBScript_7_IZ_Partname140C', $policySettings.DeviceSettings.iZ_PolicyAllowVBScript_7_IZ_Partname140C)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyNotificationBarDownloadURLaction_7)
        {
            $complexDeviceSettings.Add('IZ_PolicyNotificationBarDownloadURLaction_7', $policySettings.DeviceSettings.iZ_PolicyNotificationBarDownloadURLaction_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyNotificationBarDownloadURLaction_7_IZ_Partname2200)
        {
            $complexDeviceSettings.Add('IZ_PolicyNotificationBarDownloadURLaction_7_IZ_Partname2200', $policySettings.DeviceSettings.iZ_PolicyNotificationBarDownloadURLaction_7_IZ_Partname2200)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_7)
        {
            $complexDeviceSettings.Add('IZ_PolicyAntiMalwareCheckingOfActiveXControls_7', $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_7_IZ_Partname270C)
        {
            $complexDeviceSettings.Add('IZ_PolicyAntiMalwareCheckingOfActiveXControls_7_IZ_Partname270C', $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_7_IZ_Partname270C)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyDownloadSignedActiveX_7)
        {
            $complexDeviceSettings.Add('IZ_PolicyDownloadSignedActiveX_7', $policySettings.DeviceSettings.iZ_PolicyDownloadSignedActiveX_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyDownloadSignedActiveX_7_IZ_Partname1001)
        {
            $complexDeviceSettings.Add('IZ_PolicyDownloadSignedActiveX_7_IZ_Partname1001', $policySettings.DeviceSettings.iZ_PolicyDownloadSignedActiveX_7_IZ_Partname1001)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyDownloadUnsignedActiveX_7)
        {
            $complexDeviceSettings.Add('IZ_PolicyDownloadUnsignedActiveX_7', $policySettings.DeviceSettings.iZ_PolicyDownloadUnsignedActiveX_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyDownloadUnsignedActiveX_7_IZ_Partname1004)
        {
            $complexDeviceSettings.Add('IZ_PolicyDownloadUnsignedActiveX_7_IZ_Partname1004', $policySettings.DeviceSettings.iZ_PolicyDownloadUnsignedActiveX_7_IZ_Partname1004)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyDragDropAcrossDomainsAcrossWindows_Both_Restricted)
        {
            $complexDeviceSettings.Add('IZ_PolicyDragDropAcrossDomainsAcrossWindows_Both_Restricted', $policySettings.DeviceSettings.iZ_PolicyDragDropAcrossDomainsAcrossWindows_Both_Restricted)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyDragDropAcrossDomainsAcrossWindows_Both_Restricted_IZ_Partname2709)
        {
            $complexDeviceSettings.Add('IZ_PolicyDragDropAcrossDomainsAcrossWindows_Both_Restricted_IZ_Partname2709', $policySettings.DeviceSettings.iZ_PolicyDragDropAcrossDomainsAcrossWindows_Both_Restricted_IZ_Partname2709)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyDragDropAcrossDomainsWithinWindow_Both_Restricted)
        {
            $complexDeviceSettings.Add('IZ_PolicyDragDropAcrossDomainsWithinWindow_Both_Restricted', $policySettings.DeviceSettings.iZ_PolicyDragDropAcrossDomainsWithinWindow_Both_Restricted)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyDragDropAcrossDomainsWithinWindow_Both_Restricted_IZ_Partname2708)
        {
            $complexDeviceSettings.Add('IZ_PolicyDragDropAcrossDomainsWithinWindow_Both_Restricted_IZ_Partname2708', $policySettings.DeviceSettings.iZ_PolicyDragDropAcrossDomainsWithinWindow_Both_Restricted_IZ_Partname2708)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_LocalPathForUpload_7)
        {
            $complexDeviceSettings.Add('IZ_Policy_LocalPathForUpload_7', $policySettings.DeviceSettings.iZ_Policy_LocalPathForUpload_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_LocalPathForUpload_7_IZ_Partname160A)
        {
            $complexDeviceSettings.Add('IZ_Policy_LocalPathForUpload_7_IZ_Partname160A', $policySettings.DeviceSettings.iZ_Policy_LocalPathForUpload_7_IZ_Partname160A)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyScriptActiveXNotMarkedSafe_7)
        {
            $complexDeviceSettings.Add('IZ_PolicyScriptActiveXNotMarkedSafe_7', $policySettings.DeviceSettings.iZ_PolicyScriptActiveXNotMarkedSafe_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyScriptActiveXNotMarkedSafe_7_IZ_Partname1201)
        {
            $complexDeviceSettings.Add('IZ_PolicyScriptActiveXNotMarkedSafe_7_IZ_Partname1201', $policySettings.DeviceSettings.iZ_PolicyScriptActiveXNotMarkedSafe_7_IZ_Partname1201)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_7)
        {
            $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_7', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_7_IZ_Partname1C00)
        {
            $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_7_IZ_Partname1C00', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_7_IZ_Partname1C00)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyLaunchAppsAndFilesInIFRAME_7)
        {
            $complexDeviceSettings.Add('IZ_PolicyLaunchAppsAndFilesInIFRAME_7', $policySettings.DeviceSettings.iZ_PolicyLaunchAppsAndFilesInIFRAME_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyLaunchAppsAndFilesInIFRAME_7_IZ_Partname1804)
        {
            $complexDeviceSettings.Add('IZ_PolicyLaunchAppsAndFilesInIFRAME_7_IZ_Partname1804', $policySettings.DeviceSettings.iZ_PolicyLaunchAppsAndFilesInIFRAME_7_IZ_Partname1804)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyLogon_7)
        {
            $complexDeviceSettings.Add('IZ_PolicyLogon_7', $policySettings.DeviceSettings.iZ_PolicyLogon_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyLogon_7_IZ_Partname1A00)
        {
            $complexDeviceSettings.Add('IZ_PolicyLogon_7_IZ_Partname1A00', $policySettings.DeviceSettings.iZ_PolicyLogon_7_IZ_Partname1A00)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyNavigateSubframesAcrossDomains_7)
        {
            $complexDeviceSettings.Add('IZ_PolicyNavigateSubframesAcrossDomains_7', $policySettings.DeviceSettings.iZ_PolicyNavigateSubframesAcrossDomains_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyNavigateSubframesAcrossDomains_7_IZ_Partname1607)
        {
            $complexDeviceSettings.Add('IZ_PolicyNavigateSubframesAcrossDomains_7_IZ_Partname1607', $policySettings.DeviceSettings.iZ_PolicyNavigateSubframesAcrossDomains_7_IZ_Partname1607)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyUnsignedFrameworkComponentsURLaction_7)
        {
            $complexDeviceSettings.Add('IZ_PolicyUnsignedFrameworkComponentsURLaction_7', $policySettings.DeviceSettings.iZ_PolicyUnsignedFrameworkComponentsURLaction_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyUnsignedFrameworkComponentsURLaction_7_IZ_Partname2004)
        {
            $complexDeviceSettings.Add('IZ_PolicyUnsignedFrameworkComponentsURLaction_7_IZ_Partname2004', $policySettings.DeviceSettings.iZ_PolicyUnsignedFrameworkComponentsURLaction_7_IZ_Partname2004)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicySignedFrameworkComponentsURLaction_7)
        {
            $complexDeviceSettings.Add('IZ_PolicySignedFrameworkComponentsURLaction_7', $policySettings.DeviceSettings.iZ_PolicySignedFrameworkComponentsURLaction_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicySignedFrameworkComponentsURLaction_7_IZ_Partname2001)
        {
            $complexDeviceSettings.Add('IZ_PolicySignedFrameworkComponentsURLaction_7_IZ_Partname2001', $policySettings.DeviceSettings.iZ_PolicySignedFrameworkComponentsURLaction_7_IZ_Partname2001)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyRunActiveXControls_7)
        {
            $complexDeviceSettings.Add('IZ_PolicyRunActiveXControls_7', $policySettings.DeviceSettings.iZ_PolicyRunActiveXControls_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Partname1200)
        {
            $complexDeviceSettings.Add('IZ_Partname1200', $policySettings.DeviceSettings.iZ_Partname1200)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyScriptActiveXMarkedSafe_7)
        {
            $complexDeviceSettings.Add('IZ_PolicyScriptActiveXMarkedSafe_7', $policySettings.DeviceSettings.iZ_PolicyScriptActiveXMarkedSafe_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Partname1405)
        {
            $complexDeviceSettings.Add('IZ_Partname1405', $policySettings.DeviceSettings.iZ_Partname1405)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyScriptingOfJavaApplets_7)
        {
            $complexDeviceSettings.Add('IZ_PolicyScriptingOfJavaApplets_7', $policySettings.DeviceSettings.iZ_PolicyScriptingOfJavaApplets_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Partname1402)
        {
            $complexDeviceSettings.Add('IZ_Partname1402', $policySettings.DeviceSettings.iZ_Partname1402)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_UnsafeFiles_7)
        {
            $complexDeviceSettings.Add('IZ_Policy_UnsafeFiles_7', $policySettings.DeviceSettings.iZ_Policy_UnsafeFiles_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_UnsafeFiles_7_IZ_Partname1806)
        {
            $complexDeviceSettings.Add('IZ_Policy_UnsafeFiles_7_IZ_Partname1806', $policySettings.DeviceSettings.iZ_Policy_UnsafeFiles_7_IZ_Partname1806)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyTurnOnXSSFilter_Both_Restricted)
        {
            $complexDeviceSettings.Add('IZ_PolicyTurnOnXSSFilter_Both_Restricted', $policySettings.DeviceSettings.iZ_PolicyTurnOnXSSFilter_Both_Restricted)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyTurnOnXSSFilter_Both_Restricted_IZ_Partname1409)
        {
            $complexDeviceSettings.Add('IZ_PolicyTurnOnXSSFilter_Both_Restricted_IZ_Partname1409', $policySettings.DeviceSettings.iZ_PolicyTurnOnXSSFilter_Both_Restricted_IZ_Partname1409)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_TurnOnProtectedMode_7)
        {
            $complexDeviceSettings.Add('IZ_Policy_TurnOnProtectedMode_7', $policySettings.DeviceSettings.iZ_Policy_TurnOnProtectedMode_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_TurnOnProtectedMode_7_IZ_Partname2500)
        {
            $complexDeviceSettings.Add('IZ_Policy_TurnOnProtectedMode_7_IZ_Partname2500', $policySettings.DeviceSettings.iZ_Policy_TurnOnProtectedMode_7_IZ_Partname2500)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_Phishing_7)
        {
            $complexDeviceSettings.Add('IZ_Policy_Phishing_7', $policySettings.DeviceSettings.iZ_Policy_Phishing_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_Policy_Phishing_7_IZ_Partname2301)
        {
            $complexDeviceSettings.Add('IZ_Policy_Phishing_7_IZ_Partname2301', $policySettings.DeviceSettings.iZ_Policy_Phishing_7_IZ_Partname2301)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyBlockPopupWindows_7)
        {
            $complexDeviceSettings.Add('IZ_PolicyBlockPopupWindows_7', $policySettings.DeviceSettings.iZ_PolicyBlockPopupWindows_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyBlockPopupWindows_7_IZ_Partname1809)
        {
            $complexDeviceSettings.Add('IZ_PolicyBlockPopupWindows_7_IZ_Partname1809', $policySettings.DeviceSettings.iZ_PolicyBlockPopupWindows_7_IZ_Partname1809)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyUserdataPersistence_7)
        {
            $complexDeviceSettings.Add('IZ_PolicyUserdataPersistence_7', $policySettings.DeviceSettings.iZ_PolicyUserdataPersistence_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyUserdataPersistence_7_IZ_Partname1606)
        {
            $complexDeviceSettings.Add('IZ_PolicyUserdataPersistence_7_IZ_Partname1606', $policySettings.DeviceSettings.iZ_PolicyUserdataPersistence_7_IZ_Partname1606)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyZoneElevationURLaction_7)
        {
            $complexDeviceSettings.Add('IZ_PolicyZoneElevationURLaction_7', $policySettings.DeviceSettings.iZ_PolicyZoneElevationURLaction_7)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyZoneElevationURLaction_7_IZ_Partname2101)
        {
            $complexDeviceSettings.Add('IZ_PolicyZoneElevationURLaction_7_IZ_Partname2101', $policySettings.DeviceSettings.iZ_PolicyZoneElevationURLaction_7_IZ_Partname2101)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_5)
        {
            $complexDeviceSettings.Add('IZ_PolicyAntiMalwareCheckingOfActiveXControls_5', $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_5)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_5_IZ_Partname270C)
        {
            $complexDeviceSettings.Add('IZ_PolicyAntiMalwareCheckingOfActiveXControls_5_IZ_Partname270C', $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_5_IZ_Partname270C)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyScriptActiveXNotMarkedSafe_5)
        {
            $complexDeviceSettings.Add('IZ_PolicyScriptActiveXNotMarkedSafe_5', $policySettings.DeviceSettings.iZ_PolicyScriptActiveXNotMarkedSafe_5)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyScriptActiveXNotMarkedSafe_5_IZ_Partname1201)
        {
            $complexDeviceSettings.Add('IZ_PolicyScriptActiveXNotMarkedSafe_5_IZ_Partname1201', $policySettings.DeviceSettings.iZ_PolicyScriptActiveXNotMarkedSafe_5_IZ_Partname1201)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_5)
        {
            $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_5', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_5)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_5_IZ_Partname1C00)
        {
            $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_5_IZ_Partname1C00', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_5_IZ_Partname1C00)
        }
        if ($null -ne $policySettings.DeviceSettings.iZ_PolicyWarnCertMismatch)
        {
            $complexDeviceSettings.Add('IZ_PolicyWarnCertMismatch', $policySettings.DeviceSettings.iZ_PolicyWarnCertMismatch)
        }
        if ($null -ne $policySettings.DeviceSettings.disableSafetyFilterOverride)
        {
            $complexDeviceSettings.Add('DisableSafetyFilterOverride', $policySettings.DeviceSettings.disableSafetyFilterOverride)
        }
        if ($null -ne $policySettings.DeviceSettings.disableSafetyFilterOverrideForAppRepUnknown)
        {
            $complexDeviceSettings.Add('DisableSafetyFilterOverrideForAppRepUnknown', $policySettings.DeviceSettings.disableSafetyFilterOverrideForAppRepUnknown)
        }
        if ($null -ne $policySettings.DeviceSettings.disable_Managing_Safety_Filter_IE9)
        {
            $complexDeviceSettings.Add('Disable_Managing_Safety_Filter_IE9', $policySettings.DeviceSettings.disable_Managing_Safety_Filter_IE9)
        }
        if ($null -ne $policySettings.DeviceSettings.iE9SafetyFilterOptions)
        {
            $complexDeviceSettings.Add('IE9SafetyFilterOptions', $policySettings.DeviceSettings.iE9SafetyFilterOptions)
        }
        if ($null -ne $policySettings.DeviceSettings.disablePerUserActiveXInstall)
        {
            $complexDeviceSettings.Add('DisablePerUserActiveXInstall', $policySettings.DeviceSettings.disablePerUserActiveXInstall)
        }
        if ($null -ne $policySettings.DeviceSettings.verMgmtDisableRunThisTime)
        {
            $complexDeviceSettings.Add('VerMgmtDisableRunThisTime', $policySettings.DeviceSettings.verMgmtDisableRunThisTime)
        }
        if ($null -ne $policySettings.DeviceSettings.verMgmtDisable)
        {
            $complexDeviceSettings.Add('VerMgmtDisable', $policySettings.DeviceSettings.verMgmtDisable)
        }
        if ($null -ne $policySettings.DeviceSettings.advanced_EnableSSL3Fallback)
        {
            $complexDeviceSettings.Add('Advanced_EnableSSL3Fallback', $policySettings.DeviceSettings.advanced_EnableSSL3Fallback)
        }
        if ($null -ne $policySettings.DeviceSettings.advanced_EnableSSL3FallbackOptions)
        {
            $complexDeviceSettings.Add('Advanced_EnableSSL3FallbackOptions', $policySettings.DeviceSettings.advanced_EnableSSL3FallbackOptions)
        }
        if ($null -ne $policySettings.DeviceSettings.iESF_PolicyExplorerProcesses_5)
        {
            $complexDeviceSettings.Add('IESF_PolicyExplorerProcesses_5', $policySettings.DeviceSettings.iESF_PolicyExplorerProcesses_5)
        }
        if ($null -ne $policySettings.DeviceSettings.iESF_PolicyExplorerProcesses_6)
        {
            $complexDeviceSettings.Add('IESF_PolicyExplorerProcesses_6', $policySettings.DeviceSettings.iESF_PolicyExplorerProcesses_6)
        }
        if ($null -ne $policySettings.DeviceSettings.iESF_PolicyExplorerProcesses_3)
        {
            $complexDeviceSettings.Add('IESF_PolicyExplorerProcesses_3', $policySettings.DeviceSettings.iESF_PolicyExplorerProcesses_3)
        }
        if ($null -ne $policySettings.DeviceSettings.iESF_PolicyExplorerProcesses_10)
        {
            $complexDeviceSettings.Add('IESF_PolicyExplorerProcesses_10', $policySettings.DeviceSettings.iESF_PolicyExplorerProcesses_10)
        }
        if ($null -ne $policySettings.DeviceSettings.iESF_PolicyExplorerProcesses_9)
        {
            $complexDeviceSettings.Add('IESF_PolicyExplorerProcesses_9', $policySettings.DeviceSettings.iESF_PolicyExplorerProcesses_9)
        }
        if ($null -ne $policySettings.DeviceSettings.iESF_PolicyExplorerProcesses_11)
        {
            $complexDeviceSettings.Add('IESF_PolicyExplorerProcesses_11', $policySettings.DeviceSettings.iESF_PolicyExplorerProcesses_11)
        }
        if ($null -ne $policySettings.DeviceSettings.iESF_PolicyExplorerProcesses_12)
        {
            $complexDeviceSettings.Add('IESF_PolicyExplorerProcesses_12', $policySettings.DeviceSettings.iESF_PolicyExplorerProcesses_12)
        }
        if ($null -ne $policySettings.DeviceSettings.iESF_PolicyExplorerProcesses_8)
        {
            $complexDeviceSettings.Add('IESF_PolicyExplorerProcesses_8', $policySettings.DeviceSettings.iESF_PolicyExplorerProcesses_8)
        }
        if ($null -ne $policySettings.DeviceSettings.security_zones_map_edit)
        {
            $complexDeviceSettings.Add('Security_zones_map_edit', $policySettings.DeviceSettings.security_zones_map_edit)
        }
        if ($null -ne $policySettings.DeviceSettings.security_options_edit)
        {
            $complexDeviceSettings.Add('Security_options_edit', $policySettings.DeviceSettings.security_options_edit)
        }
        if ($null -ne $policySettings.DeviceSettings.security_HKLM_only)
        {
            $complexDeviceSettings.Add('Security_HKLM_only', $policySettings.DeviceSettings.security_HKLM_only)
        }
        if ($null -ne $policySettings.DeviceSettings.onlyUseAXISForActiveXInstall)
        {
            $complexDeviceSettings.Add('OnlyUseAXISForActiveXInstall', $policySettings.DeviceSettings.onlyUseAXISForActiveXInstall)
        }
        if ($null -ne $policySettings.DeviceSettings.addonManagement_RestrictCrashDetection)
        {
            $complexDeviceSettings.Add('AddonManagement_RestrictCrashDetection', $policySettings.DeviceSettings.addonManagement_RestrictCrashDetection)
        }
        if ($null -ne $policySettings.DeviceSettings.disable_Security_Settings_Check)
        {
            $complexDeviceSettings.Add('Disable_Security_Settings_Check', $policySettings.DeviceSettings.disable_Security_Settings_Check)
        }
        if ($null -ne $policySettings.DeviceSettings.disableBlockAtFirstSeen)
        {
            $complexDeviceSettings.Add('DisableBlockAtFirstSeen', $policySettings.DeviceSettings.disableBlockAtFirstSeen)
        }
        if ($null -ne $policySettings.DeviceSettings.realtimeProtection_DisableScanOnRealtimeEnable)
        {
            $complexDeviceSettings.Add('RealtimeProtection_DisableScanOnRealtimeEnable', $policySettings.DeviceSettings.realtimeProtection_DisableScanOnRealtimeEnable)
        }
        if ($null -ne $policySettings.DeviceSettings.scan_DisablePackedExeScanning)
        {
            $complexDeviceSettings.Add('Scan_DisablePackedExeScanning', $policySettings.DeviceSettings.scan_DisablePackedExeScanning)
        }
        if ($null -ne $policySettings.DeviceSettings.disableRoutinelyTakingAction)
        {
            $complexDeviceSettings.Add('DisableRoutinelyTakingAction', $policySettings.DeviceSettings.disableRoutinelyTakingAction)
        }
        if ($null -ne $policySettings.DeviceSettings.tS_CLIENT_DISABLE_PASSWORD_SAVING_2)
        {
            $complexDeviceSettings.Add('TS_CLIENT_DISABLE_PASSWORD_SAVING_2', $policySettings.DeviceSettings.tS_CLIENT_DISABLE_PASSWORD_SAVING_2)
        }
        if ($null -ne $policySettings.DeviceSettings.tS_CLIENT_DRIVE_M)
        {
            $complexDeviceSettings.Add('TS_CLIENT_DRIVE_M', $policySettings.DeviceSettings.tS_CLIENT_DRIVE_M)
        }
        if ($null -ne $policySettings.DeviceSettings.tS_PASSWORD)
        {
            $complexDeviceSettings.Add('TS_PASSWORD', $policySettings.DeviceSettings.tS_PASSWORD)
        }
        if ($null -ne $policySettings.DeviceSettings.tS_RPC_ENCRYPTION)
        {
            $complexDeviceSettings.Add('TS_RPC_ENCRYPTION', $policySettings.DeviceSettings.tS_RPC_ENCRYPTION)
        }
        if ($null -ne $policySettings.DeviceSettings.tS_ENCRYPTION_POLICY)
        {
            $complexDeviceSettings.Add('TS_ENCRYPTION_POLICY', $policySettings.DeviceSettings.tS_ENCRYPTION_POLICY)
        }
        if ($null -ne $policySettings.DeviceSettings.tS_ENCRYPTION_LEVEL)
        {
            $complexDeviceSettings.Add('TS_ENCRYPTION_LEVEL', $policySettings.DeviceSettings.tS_ENCRYPTION_LEVEL)
        }
        if ($null -ne $policySettings.DeviceSettings.disable_Downloading_of_Enclosures)
        {
            $complexDeviceSettings.Add('Disable_Downloading_of_Enclosures', $policySettings.DeviceSettings.disable_Downloading_of_Enclosures)
        }
        if ($null -ne $policySettings.DeviceSettings.enableMPRNotifications)
        {
            $complexDeviceSettings.Add('EnableMPRNotifications', $policySettings.DeviceSettings.enableMPRNotifications)
        }
        if ($null -ne $policySettings.DeviceSettings.automaticRestartSignOn)
        {
            $complexDeviceSettings.Add('AutomaticRestartSignOn', $policySettings.DeviceSettings.automaticRestartSignOn)
        }
        if ($null -ne $policySettings.DeviceSettings.enableScriptBlockLogging)
        {
            $complexDeviceSettings.Add('EnableScriptBlockLogging', $policySettings.DeviceSettings.enableScriptBlockLogging)
        }
        if ($null -ne $policySettings.DeviceSettings.enableScriptBlockInvocationLogging)
        {
            $complexDeviceSettings.Add('EnableScriptBlockInvocationLogging', $policySettings.DeviceSettings.enableScriptBlockInvocationLogging)
        }
        if ($null -ne $policySettings.DeviceSettings.allowBasic_2)
        {
            $complexDeviceSettings.Add('AllowBasic_2', $policySettings.DeviceSettings.allowBasic_2)
        }
        if ($null -ne $policySettings.DeviceSettings.allowUnencrypted_2)
        {
            $complexDeviceSettings.Add('AllowUnencrypted_2', $policySettings.DeviceSettings.allowUnencrypted_2)
        }
        if ($null -ne $policySettings.DeviceSettings.disallowDigest)
        {
            $complexDeviceSettings.Add('DisallowDigest', $policySettings.DeviceSettings.disallowDigest)
        }
        if ($null -ne $policySettings.DeviceSettings.allowBasic_1)
        {
            $complexDeviceSettings.Add('AllowBasic_1', $policySettings.DeviceSettings.allowBasic_1)
        }
        if ($null -ne $policySettings.DeviceSettings.allowUnencrypted_1)
        {
            $complexDeviceSettings.Add('AllowUnencrypted_1', $policySettings.DeviceSettings.allowUnencrypted_1)
        }
        if ($null -ne $policySettings.DeviceSettings.disableRunAs)
        {
            $complexDeviceSettings.Add('DisableRunAs', $policySettings.DeviceSettings.disableRunAs)
        }
        if ($null -ne $policySettings.DeviceSettings.accountLogon_AuditCredentialValidation)
        {
            $complexDeviceSettings.Add('AccountLogon_AuditCredentialValidation', $policySettings.DeviceSettings.accountLogon_AuditCredentialValidation)
        }
        if ($null -ne $policySettings.DeviceSettings.accountLogonLogoff_AuditAccountLockout)
        {
            $complexDeviceSettings.Add('AccountLogonLogoff_AuditAccountLockout', $policySettings.DeviceSettings.accountLogonLogoff_AuditAccountLockout)
        }
        if ($null -ne $policySettings.DeviceSettings.accountLogonLogoff_AuditGroupMembership)
        {
            $complexDeviceSettings.Add('AccountLogonLogoff_AuditGroupMembership', $policySettings.DeviceSettings.accountLogonLogoff_AuditGroupMembership)
        }
        if ($null -ne $policySettings.DeviceSettings.accountLogonLogoff_AuditLogon)
        {
            $complexDeviceSettings.Add('AccountLogonLogoff_AuditLogon', $policySettings.DeviceSettings.accountLogonLogoff_AuditLogon)
        }
        if ($null -ne $policySettings.DeviceSettings.policyChange_AuditAuthenticationPolicyChange)
        {
            $complexDeviceSettings.Add('PolicyChange_AuditAuthenticationPolicyChange', $policySettings.DeviceSettings.policyChange_AuditAuthenticationPolicyChange)
        }
        if ($null -ne $policySettings.DeviceSettings.policyChange_AuditPolicyChange)
        {
            $complexDeviceSettings.Add('PolicyChange_AuditPolicyChange', $policySettings.DeviceSettings.policyChange_AuditPolicyChange)
        }
        if ($null -ne $policySettings.DeviceSettings.objectAccess_AuditFileShare)
        {
            $complexDeviceSettings.Add('ObjectAccess_AuditFileShare', $policySettings.DeviceSettings.objectAccess_AuditFileShare)
        }
        if ($null -ne $policySettings.DeviceSettings.accountLogonLogoff_AuditOtherLogonLogoffEvents)
        {
            $complexDeviceSettings.Add('AccountLogonLogoff_AuditOtherLogonLogoffEvents', $policySettings.DeviceSettings.accountLogonLogoff_AuditOtherLogonLogoffEvents)
        }
        if ($null -ne $policySettings.DeviceSettings.accountManagement_AuditSecurityGroupManagement)
        {
            $complexDeviceSettings.Add('AccountManagement_AuditSecurityGroupManagement', $policySettings.DeviceSettings.accountManagement_AuditSecurityGroupManagement)
        }
        if ($null -ne $policySettings.DeviceSettings.system_AuditSecuritySystemExtension)
        {
            $complexDeviceSettings.Add('System_AuditSecuritySystemExtension', $policySettings.DeviceSettings.system_AuditSecuritySystemExtension)
        }
        if ($null -ne $policySettings.DeviceSettings.accountLogonLogoff_AuditSpecialLogon)
        {
            $complexDeviceSettings.Add('AccountLogonLogoff_AuditSpecialLogon', $policySettings.DeviceSettings.accountLogonLogoff_AuditSpecialLogon)
        }
        if ($null -ne $policySettings.DeviceSettings.accountManagement_AuditUserAccountManagement)
        {
            $complexDeviceSettings.Add('AccountManagement_AuditUserAccountManagement', $policySettings.DeviceSettings.accountManagement_AuditUserAccountManagement)
        }
        if ($null -ne $policySettings.DeviceSettings.detailedTracking_AuditPNPActivity)
        {
            $complexDeviceSettings.Add('DetailedTracking_AuditPNPActivity', $policySettings.DeviceSettings.detailedTracking_AuditPNPActivity)
        }
        if ($null -ne $policySettings.DeviceSettings.detailedTracking_AuditProcessCreation)
        {
            $complexDeviceSettings.Add('DetailedTracking_AuditProcessCreation', $policySettings.DeviceSettings.detailedTracking_AuditProcessCreation)
        }
        if ($null -ne $policySettings.DeviceSettings.objectAccess_AuditDetailedFileShare)
        {
            $complexDeviceSettings.Add('ObjectAccess_AuditDetailedFileShare', $policySettings.DeviceSettings.objectAccess_AuditDetailedFileShare)
        }
        if ($null -ne $policySettings.DeviceSettings.objectAccess_AuditOtherObjectAccessEvents)
        {
            $complexDeviceSettings.Add('ObjectAccess_AuditOtherObjectAccessEvents', $policySettings.DeviceSettings.objectAccess_AuditOtherObjectAccessEvents)
        }
        if ($null -ne $policySettings.DeviceSettings.objectAccess_AuditRemovableStorage)
        {
            $complexDeviceSettings.Add('ObjectAccess_AuditRemovableStorage', $policySettings.DeviceSettings.objectAccess_AuditRemovableStorage)
        }
        if ($null -ne $policySettings.DeviceSettings.policyChange_AuditMPSSVCRuleLevelPolicyChange)
        {
            $complexDeviceSettings.Add('PolicyChange_AuditMPSSVCRuleLevelPolicyChange', $policySettings.DeviceSettings.policyChange_AuditMPSSVCRuleLevelPolicyChange)
        }
        if ($null -ne $policySettings.DeviceSettings.policyChange_AuditOtherPolicyChangeEvents)
        {
            $complexDeviceSettings.Add('PolicyChange_AuditOtherPolicyChangeEvents', $policySettings.DeviceSettings.policyChange_AuditOtherPolicyChangeEvents)
        }
        if ($null -ne $policySettings.DeviceSettings.privilegeUse_AuditSensitivePrivilegeUse)
        {
            $complexDeviceSettings.Add('PrivilegeUse_AuditSensitivePrivilegeUse', $policySettings.DeviceSettings.privilegeUse_AuditSensitivePrivilegeUse)
        }
        if ($null -ne $policySettings.DeviceSettings.system_AuditOtherSystemEvents)
        {
            $complexDeviceSettings.Add('System_AuditOtherSystemEvents', $policySettings.DeviceSettings.system_AuditOtherSystemEvents)
        }
        if ($null -ne $policySettings.DeviceSettings.system_AuditSecurityStateChange)
        {
            $complexDeviceSettings.Add('System_AuditSecurityStateChange', $policySettings.DeviceSettings.system_AuditSecurityStateChange)
        }
        if ($null -ne $policySettings.DeviceSettings.system_AuditSystemIntegrity)
        {
            $complexDeviceSettings.Add('System_AuditSystemIntegrity', $policySettings.DeviceSettings.system_AuditSystemIntegrity)
        }
        if ($null -ne $policySettings.DeviceSettings.allowPasswordManager)
        {
            $complexDeviceSettings.Add('AllowPasswordManager', $policySettings.DeviceSettings.allowPasswordManager)
        }
        if ($null -ne $policySettings.DeviceSettings.allowSmartScreen)
        {
            $complexDeviceSettings.Add('AllowSmartScreen', $policySettings.DeviceSettings.allowSmartScreen)
        }
        if ($null -ne $policySettings.DeviceSettings.preventCertErrorOverrides)
        {
            $complexDeviceSettings.Add('PreventCertErrorOverrides', $policySettings.DeviceSettings.preventCertErrorOverrides)
        }
        if ($null -ne $policySettings.DeviceSettings.browser_PreventSmartScreenPromptOverride)
        {
            $complexDeviceSettings.Add('Browser_PreventSmartScreenPromptOverride', $policySettings.DeviceSettings.browser_PreventSmartScreenPromptOverride)
        }
        if ($null -ne $policySettings.DeviceSettings.preventSmartScreenPromptOverrideForFiles)
        {
            $complexDeviceSettings.Add('PreventSmartScreenPromptOverrideForFiles', $policySettings.DeviceSettings.preventSmartScreenPromptOverrideForFiles)
        }
        if ($null -ne $policySettings.DeviceSettings.allowDirectMemoryAccess)
        {
            $complexDeviceSettings.Add('AllowDirectMemoryAccess', $policySettings.DeviceSettings.allowDirectMemoryAccess)
        }
        if ($null -ne $policySettings.DeviceSettings.allowArchiveScanning)
        {
            $complexDeviceSettings.Add('AllowArchiveScanning', $policySettings.DeviceSettings.allowArchiveScanning)
        }
        if ($null -ne $policySettings.DeviceSettings.allowBehaviorMonitoring)
        {
            $complexDeviceSettings.Add('AllowBehaviorMonitoring', $policySettings.DeviceSettings.allowBehaviorMonitoring)
        }
        if ($null -ne $policySettings.DeviceSettings.allowCloudProtection)
        {
            $complexDeviceSettings.Add('AllowCloudProtection', $policySettings.DeviceSettings.allowCloudProtection)
        }
        if ($null -ne $policySettings.DeviceSettings.allowFullScanRemovableDriveScanning)
        {
            $complexDeviceSettings.Add('AllowFullScanRemovableDriveScanning', $policySettings.DeviceSettings.allowFullScanRemovableDriveScanning)
        }
        if ($null -ne $policySettings.DeviceSettings.allowOnAccessProtection)
        {
            $complexDeviceSettings.Add('AllowOnAccessProtection', $policySettings.DeviceSettings.allowOnAccessProtection)
        }
        if ($null -ne $policySettings.DeviceSettings.allowRealtimeMonitoring)
        {
            $complexDeviceSettings.Add('AllowRealtimeMonitoring', $policySettings.DeviceSettings.allowRealtimeMonitoring)
        }
        if ($null -ne $policySettings.DeviceSettings.allowIOAVProtection)
        {
            $complexDeviceSettings.Add('AllowIOAVProtection', $policySettings.DeviceSettings.allowIOAVProtection)
        }
        if ($null -ne $policySettings.DeviceSettings.allowScriptScanning)
        {
            $complexDeviceSettings.Add('AllowScriptScanning', $policySettings.DeviceSettings.allowScriptScanning)
        }
        if ($null -ne $policySettings.DeviceSettings.cloudBlockLevel)
        {
            $complexDeviceSettings.Add('CloudBlockLevel', $policySettings.DeviceSettings.cloudBlockLevel)
        }
        if ($null -ne $policySettings.DeviceSettings.cloudExtendedTimeout)
        {
            $complexDeviceSettings.Add('CloudExtendedTimeout', $policySettings.DeviceSettings.cloudExtendedTimeout)
        }
        if ($null -ne $policySettings.DeviceSettings.disableLocalAdminMerge)
        {
            $complexDeviceSettings.Add('DisableLocalAdminMerge', $policySettings.DeviceSettings.disableLocalAdminMerge)
        }
        if ($null -ne $policySettings.DeviceSettings.enableFileHashComputation)
        {
            $complexDeviceSettings.Add('EnableFileHashComputation', $policySettings.DeviceSettings.enableFileHashComputation)
        }
        if ($null -ne $policySettings.DeviceSettings.enableNetworkProtection)
        {
            $complexDeviceSettings.Add('EnableNetworkProtection', $policySettings.DeviceSettings.enableNetworkProtection)
        }
        if ($null -ne $policySettings.DeviceSettings.hideExclusionsFromLocalAdmins)
        {
            $complexDeviceSettings.Add('HideExclusionsFromLocalAdmins', $policySettings.DeviceSettings.hideExclusionsFromLocalAdmins)
        }
        if ($null -ne $policySettings.DeviceSettings.pUAProtection)
        {
            $complexDeviceSettings.Add('PUAProtection', $policySettings.DeviceSettings.pUAProtection)
        }
        if ($null -ne $policySettings.DeviceSettings.realTimeScanDirection)
        {
            $complexDeviceSettings.Add('RealTimeScanDirection', $policySettings.DeviceSettings.realTimeScanDirection)
        }
        if ($null -ne $policySettings.DeviceSettings.submitSamplesConsent)
        {
            $complexDeviceSettings.Add('SubmitSamplesConsent', $policySettings.DeviceSettings.submitSamplesConsent)
        }
        if ($null -ne $policySettings.DeviceSettings.configureSystemGuardLaunch)
        {
            $complexDeviceSettings.Add('ConfigureSystemGuardLaunch', $policySettings.DeviceSettings.configureSystemGuardLaunch)
        }
        if ($null -ne $policySettings.DeviceSettings.lsaCfgFlags)
        {
            $complexDeviceSettings.Add('LsaCfgFlags', $policySettings.DeviceSettings.lsaCfgFlags)
        }
        if ($null -ne $policySettings.DeviceSettings.enableVirtualizationBasedSecurity)
        {
            $complexDeviceSettings.Add('EnableVirtualizationBasedSecurity', $policySettings.DeviceSettings.enableVirtualizationBasedSecurity)
        }
        if ($null -ne $policySettings.DeviceSettings.requirePlatformSecurityFeatures)
        {
            $complexDeviceSettings.Add('RequirePlatformSecurityFeatures', $policySettings.DeviceSettings.requirePlatformSecurityFeatures)
        }
        if ($null -ne $policySettings.DeviceSettings.devicePasswordEnabled)
        {
            $complexDeviceSettings.Add('DevicePasswordEnabled', $policySettings.DeviceSettings.devicePasswordEnabled)
        }
        if ($null -ne $policySettings.DeviceSettings.devicePasswordExpiration)
        {
            $complexDeviceSettings.Add('DevicePasswordExpiration', $policySettings.DeviceSettings.devicePasswordExpiration)
        }
        if ($null -ne $policySettings.DeviceSettings.minDevicePasswordLength)
        {
            $complexDeviceSettings.Add('MinDevicePasswordLength', $policySettings.DeviceSettings.minDevicePasswordLength)
        }
        if ($null -ne $policySettings.DeviceSettings.alphanumericDevicePasswordRequired)
        {
            $complexDeviceSettings.Add('AlphanumericDevicePasswordRequired', $policySettings.DeviceSettings.alphanumericDevicePasswordRequired)
        }
        if ($null -ne $policySettings.DeviceSettings.maxDevicePasswordFailedAttempts)
        {
            $complexDeviceSettings.Add('MaxDevicePasswordFailedAttempts', $policySettings.DeviceSettings.maxDevicePasswordFailedAttempts)
        }
        if ($null -ne $policySettings.DeviceSettings.minDevicePasswordComplexCharacters)
        {
            $complexDeviceSettings.Add('MinDevicePasswordComplexCharacters', $policySettings.DeviceSettings.minDevicePasswordComplexCharacters)
        }
        if ($null -ne $policySettings.DeviceSettings.maxInactivityTimeDeviceLock)
        {
            $complexDeviceSettings.Add('MaxInactivityTimeDeviceLock', $policySettings.DeviceSettings.maxInactivityTimeDeviceLock)
        }
        if ($null -ne $policySettings.DeviceSettings.devicePasswordHistory)
        {
            $complexDeviceSettings.Add('DevicePasswordHistory', $policySettings.DeviceSettings.devicePasswordHistory)
        }
        if ($null -ne $policySettings.DeviceSettings.allowSimpleDevicePassword)
        {
            $complexDeviceSettings.Add('AllowSimpleDevicePassword', $policySettings.DeviceSettings.allowSimpleDevicePassword)
        }
        if ($null -ne $policySettings.DeviceSettings.deviceEnumerationPolicy)
        {
            $complexDeviceSettings.Add('DeviceEnumerationPolicy', $policySettings.DeviceSettings.deviceEnumerationPolicy)
        }
        if ($null -ne $policySettings.DeviceSettings.enableInsecureGuestLogons)
        {
            $complexDeviceSettings.Add('EnableInsecureGuestLogons', $policySettings.DeviceSettings.enableInsecureGuestLogons)
        }
        if ($null -ne $policySettings.DeviceSettings.accounts_LimitLocalAccountUseOfBlankPasswordsToConsoleLogonOnly)
        {
            $complexDeviceSettings.Add('Accounts_LimitLocalAccountUseOfBlankPasswordsToConsoleLogonOnly', $policySettings.DeviceSettings.accounts_LimitLocalAccountUseOfBlankPasswordsToConsoleLogonOnly)
        }
        if ($null -ne $policySettings.DeviceSettings.interactiveLogon_MachineInactivityLimit)
        {
            $complexDeviceSettings.Add('InteractiveLogon_MachineInactivityLimit', $policySettings.DeviceSettings.interactiveLogon_MachineInactivityLimit)
        }
        if ($null -ne $policySettings.DeviceSettings.interactiveLogon_SmartCardRemovalBehavior)
        {
            $complexDeviceSettings.Add('InteractiveLogon_SmartCardRemovalBehavior', $policySettings.DeviceSettings.interactiveLogon_SmartCardRemovalBehavior)
        }
        if ($null -ne $policySettings.DeviceSettings.microsoftNetworkClient_DigitallySignCommunicationsAlways)
        {
            $complexDeviceSettings.Add('MicrosoftNetworkClient_DigitallySignCommunicationsAlways', $policySettings.DeviceSettings.microsoftNetworkClient_DigitallySignCommunicationsAlways)
        }
        if ($null -ne $policySettings.DeviceSettings.microsoftNetworkClient_SendUnencryptedPasswordToThirdPartySMBServers)
        {
            $complexDeviceSettings.Add('MicrosoftNetworkClient_SendUnencryptedPasswordToThirdPartySMBServers', $policySettings.DeviceSettings.microsoftNetworkClient_SendUnencryptedPasswordToThirdPartySMBServers)
        }
        if ($null -ne $policySettings.DeviceSettings.microsoftNetworkServer_DigitallySignCommunicationsAlways)
        {
            $complexDeviceSettings.Add('MicrosoftNetworkServer_DigitallySignCommunicationsAlways', $policySettings.DeviceSettings.microsoftNetworkServer_DigitallySignCommunicationsAlways)
        }
        if ($null -ne $policySettings.DeviceSettings.networkAccess_DoNotAllowAnonymousEnumerationOfSAMAccounts)
        {
            $complexDeviceSettings.Add('NetworkAccess_DoNotAllowAnonymousEnumerationOfSAMAccounts', $policySettings.DeviceSettings.networkAccess_DoNotAllowAnonymousEnumerationOfSAMAccounts)
        }
        if ($null -ne $policySettings.DeviceSettings.networkAccess_DoNotAllowAnonymousEnumerationOfSamAccountsAndShares)
        {
            $complexDeviceSettings.Add('NetworkAccess_DoNotAllowAnonymousEnumerationOfSamAccountsAndShares', $policySettings.DeviceSettings.networkAccess_DoNotAllowAnonymousEnumerationOfSamAccountsAndShares)
        }
        if ($null -ne $policySettings.DeviceSettings.networkAccess_RestrictAnonymousAccessToNamedPipesAndShares)
        {
            $complexDeviceSettings.Add('NetworkAccess_RestrictAnonymousAccessToNamedPipesAndShares', $policySettings.DeviceSettings.networkAccess_RestrictAnonymousAccessToNamedPipesAndShares)
        }
        if ($null -ne $policySettings.DeviceSettings.networkAccess_RestrictClientsAllowedToMakeRemoteCallsToSAM)
        {
            $complexDeviceSettings.Add('NetworkAccess_RestrictClientsAllowedToMakeRemoteCallsToSAM', $policySettings.DeviceSettings.networkAccess_RestrictClientsAllowedToMakeRemoteCallsToSAM)
        }
        if ($null -ne $policySettings.DeviceSettings.networkSecurity_DoNotStoreLANManagerHashValueOnNextPasswordChange)
        {
            $complexDeviceSettings.Add('NetworkSecurity_DoNotStoreLANManagerHashValueOnNextPasswordChange', $policySettings.DeviceSettings.networkSecurity_DoNotStoreLANManagerHashValueOnNextPasswordChange)
        }
        if ($null -ne $policySettings.DeviceSettings.networkSecurity_LANManagerAuthenticationLevel)
        {
            $complexDeviceSettings.Add('NetworkSecurity_LANManagerAuthenticationLevel', $policySettings.DeviceSettings.networkSecurity_LANManagerAuthenticationLevel)
        }
        if ($null -ne $policySettings.DeviceSettings.networkSecurity_MinimumSessionSecurityForNTLMSSPBasedClients)
        {
            $complexDeviceSettings.Add('NetworkSecurity_MinimumSessionSecurityForNTLMSSPBasedClients', $policySettings.DeviceSettings.networkSecurity_MinimumSessionSecurityForNTLMSSPBasedClients)
        }
        if ($null -ne $policySettings.DeviceSettings.networkSecurity_MinimumSessionSecurityForNTLMSSPBasedServers)
        {
            $complexDeviceSettings.Add('NetworkSecurity_MinimumSessionSecurityForNTLMSSPBasedServers', $policySettings.DeviceSettings.networkSecurity_MinimumSessionSecurityForNTLMSSPBasedServers)
        }
        if ($null -ne $policySettings.DeviceSettings.userAccountControl_BehaviorOfTheElevationPromptForAdministrators)
        {
            $complexDeviceSettings.Add('UserAccountControl_BehaviorOfTheElevationPromptForAdministrators', $policySettings.DeviceSettings.userAccountControl_BehaviorOfTheElevationPromptForAdministrators)
        }
        if ($null -ne $policySettings.DeviceSettings.userAccountControl_BehaviorOfTheElevationPromptForStandardUsers)
        {
            $complexDeviceSettings.Add('UserAccountControl_BehaviorOfTheElevationPromptForStandardUsers', $policySettings.DeviceSettings.userAccountControl_BehaviorOfTheElevationPromptForStandardUsers)
        }
        if ($null -ne $policySettings.DeviceSettings.userAccountControl_DetectApplicationInstallationsAndPromptForElevation)
        {
            $complexDeviceSettings.Add('UserAccountControl_DetectApplicationInstallationsAndPromptForElevation', $policySettings.DeviceSettings.userAccountControl_DetectApplicationInstallationsAndPromptForElevation)
        }
        if ($null -ne $policySettings.DeviceSettings.userAccountControl_OnlyElevateUIAccessApplicationsThatAreInstalledInSecureLocations)
        {
            $complexDeviceSettings.Add('UserAccountControl_OnlyElevateUIAccessApplicationsThatAreInstalledInSecureLocations', $policySettings.DeviceSettings.userAccountControl_OnlyElevateUIAccessApplicationsThatAreInstalledInSecureLocations)
        }
        if ($null -ne $policySettings.DeviceSettings.userAccountControl_RunAllAdministratorsInAdminApprovalMode)
        {
            $complexDeviceSettings.Add('UserAccountControl_RunAllAdministratorsInAdminApprovalMode', $policySettings.DeviceSettings.userAccountControl_RunAllAdministratorsInAdminApprovalMode)
        }
        if ($null -ne $policySettings.DeviceSettings.userAccountControl_UseAdminApprovalMode)
        {
            $complexDeviceSettings.Add('UserAccountControl_UseAdminApprovalMode', $policySettings.DeviceSettings.userAccountControl_UseAdminApprovalMode)
        }
        if ($null -ne $policySettings.DeviceSettings.userAccountControl_VirtualizeFileAndRegistryWriteFailuresToPerUserLocations)
        {
            $complexDeviceSettings.Add('UserAccountControl_VirtualizeFileAndRegistryWriteFailuresToPerUserLocations', $policySettings.DeviceSettings.userAccountControl_VirtualizeFileAndRegistryWriteFailuresToPerUserLocations)
        }
        if ($null -ne $policySettings.DeviceSettings.configureLsaProtectedProcess)
        {
            $complexDeviceSettings.Add('ConfigureLsaProtectedProcess', $policySettings.DeviceSettings.configureLsaProtectedProcess)
        }
        if ($null -ne $policySettings.DeviceSettings.allowGameDVR)
        {
            $complexDeviceSettings.Add('AllowGameDVR', $policySettings.DeviceSettings.allowGameDVR)
        }
        if ($null -ne $policySettings.DeviceSettings.mSIAllowUserControlOverInstall)
        {
            $complexDeviceSettings.Add('MSIAllowUserControlOverInstall', $policySettings.DeviceSettings.mSIAllowUserControlOverInstall)
        }
        if ($null -ne $policySettings.DeviceSettings.mSIAlwaysInstallWithElevatedPrivileges)
        {
            $complexDeviceSettings.Add('MSIAlwaysInstallWithElevatedPrivileges', $policySettings.DeviceSettings.mSIAlwaysInstallWithElevatedPrivileges)
        }
        if ($null -ne $policySettings.DeviceSettings.smartScreenEnabled)
        {
            $complexDeviceSettings.Add('SmartScreenEnabled', $policySettings.DeviceSettings.smartScreenEnabled)
        }
        if ($null -ne $policySettings.DeviceSettings.smartScreen_PreventSmartScreenPromptOverride)
        {
            $complexDeviceSettings.Add('SmartScreen_PreventSmartScreenPromptOverride', $policySettings.DeviceSettings.smartScreen_PreventSmartScreenPromptOverride)
        }
        if ($null -ne $policySettings.DeviceSettings.letAppsActivateWithVoiceAboveLock)
        {
            $complexDeviceSettings.Add('LetAppsActivateWithVoiceAboveLock', $policySettings.DeviceSettings.letAppsActivateWithVoiceAboveLock)
        }
        if ($null -ne $policySettings.DeviceSettings.allowIndexingEncryptedStoresOrItems)
        {
            $complexDeviceSettings.Add('AllowIndexingEncryptedStoresOrItems', $policySettings.DeviceSettings.allowIndexingEncryptedStoresOrItems)
        }
        if ($null -ne $policySettings.DeviceSettings.enableSmartScreenInShell)
        {
            $complexDeviceSettings.Add('EnableSmartScreenInShell', $policySettings.DeviceSettings.enableSmartScreenInShell)
        }
        if ($null -ne $policySettings.DeviceSettings.notifyMalicious)
        {
            $complexDeviceSettings.Add('NotifyMalicious', $policySettings.DeviceSettings.notifyMalicious)
        }
        if ($null -ne $policySettings.DeviceSettings.notifyPasswordReuse)
        {
            $complexDeviceSettings.Add('NotifyPasswordReuse', $policySettings.DeviceSettings.notifyPasswordReuse)
        }
        if ($null -ne $policySettings.DeviceSettings.notifyUnsafeApp)
        {
            $complexDeviceSettings.Add('NotifyUnsafeApp', $policySettings.DeviceSettings.notifyUnsafeApp)
        }
        if ($null -ne $policySettings.DeviceSettings.serviceEnabled)
        {
            $complexDeviceSettings.Add('ServiceEnabled', $policySettings.DeviceSettings.serviceEnabled)
        }
        if ($null -ne $policySettings.DeviceSettings.preventOverrideForFilesInShell)
        {
            $complexDeviceSettings.Add('PreventOverrideForFilesInShell', $policySettings.DeviceSettings.preventOverrideForFilesInShell)
        }
        if ($null -ne $policySettings.DeviceSettings.configureXboxAccessoryManagementServiceStartupMode)
        {
            $complexDeviceSettings.Add('ConfigureXboxAccessoryManagementServiceStartupMode', $policySettings.DeviceSettings.configureXboxAccessoryManagementServiceStartupMode)
        }
        if ($null -ne $policySettings.DeviceSettings.configureXboxLiveAuthManagerServiceStartupMode)
        {
            $complexDeviceSettings.Add('ConfigureXboxLiveAuthManagerServiceStartupMode', $policySettings.DeviceSettings.configureXboxLiveAuthManagerServiceStartupMode)
        }
        if ($null -ne $policySettings.DeviceSettings.configureXboxLiveGameSaveServiceStartupMode)
        {
            $complexDeviceSettings.Add('ConfigureXboxLiveGameSaveServiceStartupMode', $policySettings.DeviceSettings.configureXboxLiveGameSaveServiceStartupMode)
        }
        if ($null -ne $policySettings.DeviceSettings.configureXboxLiveNetworkingServiceStartupMode)
        {
            $complexDeviceSettings.Add('ConfigureXboxLiveNetworkingServiceStartupMode', $policySettings.DeviceSettings.configureXboxLiveNetworkingServiceStartupMode)
        }
        if ($null -ne $policySettings.DeviceSettings.enableXboxGameSaveTask)
        {
            $complexDeviceSettings.Add('EnableXboxGameSaveTask', $policySettings.DeviceSettings.enableXboxGameSaveTask)
        }
        if ($null -ne $policySettings.DeviceSettings.accessFromNetwork)
        {
            $complexDeviceSettings.Add('AccessFromNetwork', $policySettings.DeviceSettings.accessFromNetwork)
        }
        if ($null -ne $policySettings.DeviceSettings.allowLocalLogOn)
        {
            $complexDeviceSettings.Add('AllowLocalLogOn', $policySettings.DeviceSettings.allowLocalLogOn)
        }
        if ($null -ne $policySettings.DeviceSettings.backupFilesAndDirectories)
        {
            $complexDeviceSettings.Add('BackupFilesAndDirectories', $policySettings.DeviceSettings.backupFilesAndDirectories)
        }
        if ($null -ne $policySettings.DeviceSettings.createGlobalObjects)
        {
            $complexDeviceSettings.Add('CreateGlobalObjects', $policySettings.DeviceSettings.createGlobalObjects)
        }
        if ($null -ne $policySettings.DeviceSettings.createPageFile)
        {
            $complexDeviceSettings.Add('CreatePageFile', $policySettings.DeviceSettings.createPageFile)
        }
        if ($null -ne $policySettings.DeviceSettings.debugPrograms)
        {
            $complexDeviceSettings.Add('DebugPrograms', $policySettings.DeviceSettings.debugPrograms)
        }
        if ($null -ne $policySettings.DeviceSettings.denyAccessFromNetwork)
        {
            $complexDeviceSettings.Add('DenyAccessFromNetwork', $policySettings.DeviceSettings.denyAccessFromNetwork)
        }
        if ($null -ne $policySettings.DeviceSettings.denyRemoteDesktopServicesLogOn)
        {
            $complexDeviceSettings.Add('DenyRemoteDesktopServicesLogOn', $policySettings.DeviceSettings.denyRemoteDesktopServicesLogOn)
        }
        if ($null -ne $policySettings.DeviceSettings.impersonateClient)
        {
            $complexDeviceSettings.Add('ImpersonateClient', $policySettings.DeviceSettings.impersonateClient)
        }
        if ($null -ne $policySettings.DeviceSettings.loadUnloadDeviceDrivers)
        {
            $complexDeviceSettings.Add('LoadUnloadDeviceDrivers', $policySettings.DeviceSettings.loadUnloadDeviceDrivers)
        }
        if ($null -ne $policySettings.DeviceSettings.manageAuditingAndSecurityLog)
        {
            $complexDeviceSettings.Add('ManageAuditingAndSecurityLog', $policySettings.DeviceSettings.manageAuditingAndSecurityLog)
        }
        if ($null -ne $policySettings.DeviceSettings.manageVolume)
        {
            $complexDeviceSettings.Add('ManageVolume', $policySettings.DeviceSettings.manageVolume)
        }
        if ($null -ne $policySettings.DeviceSettings.modifyFirmwareEnvironment)
        {
            $complexDeviceSettings.Add('ModifyFirmwareEnvironment', $policySettings.DeviceSettings.modifyFirmwareEnvironment)
        }
        if ($null -ne $policySettings.DeviceSettings.profileSingleProcess)
        {
            $complexDeviceSettings.Add('ProfileSingleProcess', $policySettings.DeviceSettings.profileSingleProcess)
        }
        if ($null -ne $policySettings.DeviceSettings.remoteShutdown)
        {
            $complexDeviceSettings.Add('RemoteShutdown', $policySettings.DeviceSettings.remoteShutdown)
        }
        if ($null -ne $policySettings.DeviceSettings.restoreFilesAndDirectories)
        {
            $complexDeviceSettings.Add('RestoreFilesAndDirectories', $policySettings.DeviceSettings.restoreFilesAndDirectories)
        }
        if ($null -ne $policySettings.DeviceSettings.takeOwnership)
        {
            $complexDeviceSettings.Add('TakeOwnership', $policySettings.DeviceSettings.takeOwnership)
        }
        if ($null -ne $policySettings.DeviceSettings.hypervisorEnforcedCodeIntegrity)
        {
            $complexDeviceSettings.Add('HypervisorEnforcedCodeIntegrity', $policySettings.DeviceSettings.hypervisorEnforcedCodeIntegrity)
        }
        if ($null -ne $policySettings.DeviceSettings.allowAutoConnectToWiFiSenseHotspots)
        {
            $complexDeviceSettings.Add('AllowAutoConnectToWiFiSenseHotspots', $policySettings.DeviceSettings.allowAutoConnectToWiFiSenseHotspots)
        }
        if ($null -ne $policySettings.DeviceSettings.allowInternetSharing)
        {
            $complexDeviceSettings.Add('AllowInternetSharing', $policySettings.DeviceSettings.allowInternetSharing)
        }
        if ($null -ne $policySettings.DeviceSettings.facialFeaturesUseEnhancedAntiSpoofing)
        {
            $complexDeviceSettings.Add('FacialFeaturesUseEnhancedAntiSpoofing', $policySettings.DeviceSettings.facialFeaturesUseEnhancedAntiSpoofing)
        }
        if ($null -ne $policySettings.DeviceSettings.allowWindowsInkWorkspace)
        {
            $complexDeviceSettings.Add('AllowWindowsInkWorkspace', $policySettings.DeviceSettings.allowWindowsInkWorkspace)
        }
        if ($null -ne $policySettings.DeviceSettings.backupDirectory)
        {
            $complexDeviceSettings.Add('BackupDirectory', $policySettings.DeviceSettings.backupDirectory)
        }
        if ($null -ne $policySettings.DeviceSettings.aDEncryptedPasswordHistorySize)
        {
            $complexDeviceSettings.Add('ADEncryptedPasswordHistorySize', $policySettings.DeviceSettings.aDEncryptedPasswordHistorySize)
        }
        if ($null -ne $policySettings.DeviceSettings.passwordagedays)
        {
            $complexDeviceSettings.Add('Passwordagedays', $policySettings.DeviceSettings.passwordagedays)
        }
        if ($null -ne $policySettings.DeviceSettings.aDPasswordEncryptionEnabled)
        {
            $complexDeviceSettings.Add('ADPasswordEncryptionEnabled', $policySettings.DeviceSettings.aDPasswordEncryptionEnabled)
        }
        if ($null -ne $policySettings.DeviceSettings.passwordagedays_aad)
        {
            $complexDeviceSettings.Add('Passwordagedays_aad', $policySettings.DeviceSettings.passwordagedays_aad)
        }
        if ($null -ne $policySettings.DeviceSettings.aDPasswordEncryptionPrincipal)
        {
            $complexDeviceSettings.Add('ADPasswordEncryptionPrincipal', $policySettings.DeviceSettings.aDPasswordEncryptionPrincipal)
        }
        if ($null -ne $policySettings.DeviceSettings.passwordExpirationProtectionEnabled)
        {
            $complexDeviceSettings.Add('PasswordExpirationProtectionEnabled', $policySettings.DeviceSettings.passwordExpirationProtectionEnabled)
        }
        if ($complexDeviceSettings.Values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexDeviceSettings = $null
        }
        $policySettings.Remove('DeviceSettings') | Out-Null

        $complexUserSettings = @{}
        # Add user settings with conditional checks
        if ($null -ne $policySettings.UserSettings.noLockScreenToastNotification)
        {
            $complexUserSettings.Add('NoLockScreenToastNotification', $policySettings.UserSettings.noLockScreenToastNotification)
        }
        if ($null -ne $policySettings.UserSettings.restrictFormSuggestPW)
        {
            $complexUserSettings.Add('RestrictFormSuggestPW', $policySettings.UserSettings.restrictFormSuggestPW)
        }
        if ($null -ne $policySettings.UserSettings.chkBox_PasswordAsk)
        {
            $complexUserSettings.Add('ChkBox_PasswordAsk', $policySettings.UserSettings.chkBox_PasswordAsk)
        }
        if ($null -ne $policySettings.UserSettings.allowWindowsSpotlight)
        {
            $complexUserSettings.Add('AllowWindowsSpotlight', $policySettings.UserSettings.allowWindowsSpotlight)
        }
        if ($null -ne $policySettings.UserSettings.allowWindowsTips)
        {
            $complexUserSettings.Add('AllowWindowsTips', $policySettings.UserSettings.allowWindowsTips)
        }
        if ($null -ne $policySettings.UserSettings.allowTailoredExperiencesWithDiagnosticData)
        {
            $complexUserSettings.Add('AllowTailoredExperiencesWithDiagnosticData', $policySettings.UserSettings.allowTailoredExperiencesWithDiagnosticData)
        }
        if ($null -ne $policySettings.UserSettings.allowWindowsSpotlightOnActionCenter)
        {
            $complexUserSettings.Add('AllowWindowsSpotlightOnActionCenter', $policySettings.UserSettings.allowWindowsSpotlightOnActionCenter)
        }
        if ($null -ne $policySettings.UserSettings.allowWindowsConsumerFeatures)
        {
            $complexUserSettings.Add('AllowWindowsConsumerFeatures', $policySettings.UserSettings.allowWindowsConsumerFeatures)
        }
        if ($null -ne $policySettings.UserSettings.configureWindowsSpotlightOnLockScreen)
        {
            $complexUserSettings.Add('ConfigureWindowsSpotlightOnLockScreen', $policySettings.UserSettings.configureWindowsSpotlightOnLockScreen)
        }
        if ($null -ne $policySettings.UserSettings.allowWindowsSpotlightWindowsWelcomeExperience)
        {
            $complexUserSettings.Add('AllowWindowsSpotlightWindowsWelcomeExperience', $policySettings.UserSettings.allowWindowsSpotlightWindowsWelcomeExperience)
        }
        if ($null -ne $policySettings.UserSettings.allowThirdPartySuggestionsInWindowsSpotlight)
        {
            $complexUserSettings.Add('AllowThirdPartySuggestionsInWindowsSpotlight', $policySettings.UserSettings.allowThirdPartySuggestionsInWindowsSpotlight)
        }
        # Check if $complexUserSettings is empty
        if ($complexUserSettings.Values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexUserSettings = $null
        }
        $policySettings.Remove('UserSettings') | Out-Null
        #endregion

        $results = @{
            #region resource generator code
            Description           = $getValue.Description
            DisplayName           = $getValue.Name
            RoleScopeTagIds       = $getValue.RoleScopeTagIds
            Id                    = $getValue.Id
            DeviceSettings        = $complexDeviceSettings
            UserSettings          = $complexUserSettings
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            #endregion
        }
        $results += $policySettings

        $assignmentsValues = Get-MgBetaDeviceManagementConfigurationPolicyAssignment -DeviceManagementConfigurationPolicyId $Id
        $assignmentResult = @()
        if ($assignmentsValues.Count -gt 0)
        {
            $assignmentResult += ConvertFrom-IntunePolicyAssignment -Assignments $assignmentsValues -IncludeDeviceFilter $true
        }
        $results.Add('Assignments', $assignmentResult)

        return [System.Collections.Hashtable] $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullResult
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DeviceSettings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserSettings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion
        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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

    Write-Verbose -Message "Setting configuration of the Intune Security Baseline for Windows10 with Id {$Id} and Name {$DisplayName}"

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

    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    $templateReferenceId = '66df8dce-0166-4b82-92f7-1f74e3ca17a3_1'
    $platforms = 'windows10'
    $technologies = 'mdm'

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Security Baseline for Windows10 with Name {$DisplayName}"
        $BoundParameters.Remove('Assignments') | Out-Null

        $settings = Get-IntuneSettingCatalogPolicySetting `
            -DSCParams ([System.Collections.Hashtable]$BoundParameters) `
            -TemplateId $templateReferenceId `
            -ContainsDeviceAndUserSettings

        $createParameters = @{
            Name              = $DisplayName
            Description       = $Description
            TemplateReference = @{ templateId = $templateReferenceId }
            Platforms         = $platforms
            Technologies      = $technologies
            Settings          = $settings
        }

        #region resource generator code
        $policy = New-MgBetaDeviceManagementConfigurationPolicy -BodyParameter $createParameters

        if ($policy.Id)
        {
            $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
            Update-DeviceConfigurationPolicyAssignment `
                -DeviceConfigurationPolicyId $policy.Id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/configurationPolicies'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Security Baseline for Windows10 with Id {$($currentInstance.Id)}"
        $BoundParameters.Remove('Assignments') | Out-Null

        $settings = Get-IntuneSettingCatalogPolicySetting `
            -DSCParams ([System.Collections.Hashtable]$BoundParameters) `
            -TemplateId $templateReferenceId `
            -ContainsDeviceAndUserSettings

        Update-IntuneDeviceConfigurationPolicy `
            -DeviceConfigurationPolicyId $currentInstance.Id `
            -Name $DisplayName `
            -Description $Description `
            -TemplateReferenceId $templateReferenceId `
            -Platforms $platforms `
            -Technologies $technologies `
            -Settings $settings

        #region resource generator code
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentInstance.Id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/configurationPolicies'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Security Baseline for Windows10 with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $currentInstance.Id
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
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DeviceSettings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UserSettings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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

    Write-Verbose -Message "Testing configuration of the Intune Security Baseline for Windows10 with Id {$Id} and Name {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    [Hashtable]$ValuesToCheck = @{}
    $MyInvocation.MyCommand.Parameters.GetEnumerator() | ForEach-Object {
        if ($_.Key -notlike '*Variable' -or $_.Key -notin @('Verbose', 'Debug', 'ErrorAction', 'WarningAction', 'InformationAction'))
        {
            if ($null -ne $CurrentValues[$_.Key] -or $null -ne $PSBoundParameters[$_.Key])
            {
                $ValuesToCheck.Add($_.Key, $null)
                if (-not $PSBoundParameters.ContainsKey($_.Key))
                {
                    $PSBoundParameters.Add($_.Key, $null)
                }
            }
        }
    }

    if ($CurrentValues.Ensure -ne $Ensure)
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }
    $testResult = $true

    #Compare Cim instances
    foreach ($key in $PSBoundParameters.Keys)
    {
        $source = $PSBoundParameters.$key
        $target = $CurrentValues.$key
        if ($null -ne $source -and $source.GetType().Name -like '*CimInstance*')
        {
            $testResult = Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target)

            if (-not $testResult)
            {
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    $ValuesToCheck.Remove('Id') | Out-Null
    $ValuesToCheck = Remove-M365DSCAuthenticationParameter -BoundParameters $ValuesToCheck

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    if ($testResult)
    {
        $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
            -Source $($MyInvocation.MyCommand.Source) `
            -DesiredValues $PSBoundParameters `
            -ValuesToCheck $ValuesToCheck.Keys
    }

    Write-Verbose -Message "Test-TargetResource returned $testResult"

    return $testResult
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
        $policyTemplateID = '66df8dce-0166-4b82-92f7-1f74e3ca17a3_1'
        [array]$getValue = Get-MgBetaDeviceManagementConfigurationPolicy `
            -Filter $Filter `
            -All `
            -ErrorAction Stop | Where-Object `
            -FilterScript {
            $_.TemplateReference.TemplateId -eq $policyTemplateID
        }
        #endregion

        $i = 1
        $dscContent = ''
        if ($getValue.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $getValue)
        {
            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            elseif (-not [string]::IsNullOrEmpty($config.name))
            {
                $displayedKey = $config.name
            }
            Write-Host "    |---[$i/$($getValue.Count)] $displayedKey" -NoNewline
            $params = @{
                Id                    = $config.Id
                DisplayName           = $config.Name
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            if ($null -ne $Results.DeviceSettings)
            {
                $complexMapping = @(
                    @{
                        Name            = 'DeviceSettings'
                        CimInstanceName = 'MicrosoftGraphIntuneSettingsCatalogDeviceSettings_IntuneSecurityBaselineWindows10'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'pol_hardenedpaths'
                        CimInstanceName = 'MicrosoftGraphIntuneSettingsCatalogpol_hardenedpaths'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.DeviceSettings `
                    -CIMInstanceName 'MicrosoftGraphIntuneSettingsCatalogDeviceSettings_IntuneSecurityBaselineWindows10' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.DeviceSettings = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('DeviceSettings') | Out-Null
                }
            }
            if ($null -ne $Results.UserSettings)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.UserSettings `
                    -CIMInstanceName 'MicrosoftGraphIntuneSettingsCatalogUserSettings_IntuneSecurityBaselineWindows10'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.UserSettings = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('UserSettings') | Out-Null
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
                -Credential $Credential
            if ($Results.DeviceSettings)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'DeviceSettings' -IsCIMArray:$False
            }
            if ($Results.UserSettings)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'UserSettings' -IsCIMArray:$False
            }

            if ($Results.Assignments)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Assignments' -IsCIMArray:$true
            }

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
        Write-Host $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
