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
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
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
            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                $getValue = Get-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $Id -ErrorAction SilentlyContinue
            }

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Security Baseline for Windows10 with Id {$Id}"

                if (-not [System.String]::IsNullOrEmpty($DisplayName))
                {
                    $getValue = Get-MgBetaDeviceManagementConfigurationPolicy `
                        -Filter "Name eq '$($DisplayName -replace "'", "''")'" `
                        -ErrorAction SilentlyContinue
                }
            }
            #endregion
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Security Baseline for Windows10 with Name {$DisplayName}."
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
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
        $complexDeviceSettings.Add('CPL_Personalization_NoLockScreenCamera', $policySettings.DeviceSettings.cPL_Personalization_NoLockScreenCamera)
        $complexDeviceSettings.Add('CPL_Personalization_NoLockScreenSlideshow', $policySettings.DeviceSettings.cPL_Personalization_NoLockScreenSlideshow)
        $complexDeviceSettings.Add('Pol_SecGuide_0201_LATFP', $policySettings.DeviceSettings.pol_SecGuide_0201_LATFP)
        $complexDeviceSettings.Add('Pol_SecGuide_0002_SMBv1_ClientDriver', $policySettings.DeviceSettings.pol_SecGuide_0002_SMBv1_ClientDriver)
        $complexDeviceSettings.Add('Pol_SecGuide_SMB1ClientDriver', $policySettings.DeviceSettings.pol_SecGuide_SMB1ClientDriver)
        $complexDeviceSettings.Add('Pol_SecGuide_0001_SMBv1_Server', $policySettings.DeviceSettings.pol_SecGuide_0001_SMBv1_Server)
        $complexDeviceSettings.Add('Pol_SecGuide_0102_SEHOP', $policySettings.DeviceSettings.pol_SecGuide_0102_SEHOP)
        $complexDeviceSettings.Add('Pol_SecGuide_0202_WDigestAuthn', $policySettings.DeviceSettings.pol_SecGuide_0202_WDigestAuthn)
        $complexDeviceSettings.Add('Pol_MSS_DisableIPSourceRoutingIPv6', $policySettings.DeviceSettings.pol_MSS_DisableIPSourceRoutingIPv6)
        $complexDeviceSettings.Add('DisableIPSourceRoutingIPv6', $policySettings.DeviceSettings.disableIPSourceRoutingIPv6)
        $complexDeviceSettings.Add('Pol_MSS_DisableIPSourceRouting', $policySettings.DeviceSettings.pol_MSS_DisableIPSourceRouting)
        $complexDeviceSettings.Add('DisableIPSourceRouting', $policySettings.DeviceSettings.disableIPSourceRouting)
        $complexDeviceSettings.Add('Pol_MSS_EnableICMPRedirect', $policySettings.DeviceSettings.pol_MSS_EnableICMPRedirect)
        $complexDeviceSettings.Add('Pol_MSS_NoNameReleaseOnDemand', $policySettings.DeviceSettings.pol_MSS_NoNameReleaseOnDemand)
        $complexDeviceSettings.Add('Turn_Off_Multicast', $policySettings.DeviceSettings.turn_Off_Multicast)
        $complexDeviceSettings.Add('NC_ShowSharedAccessUI', $policySettings.DeviceSettings.nC_ShowSharedAccessUI)
        $complexDeviceSettings.Add('Hardeneduncpaths_Pol_HardenedPaths', $policySettings.DeviceSettings.hardeneduncpaths_Pol_HardenedPaths)
        $complexPol_hardenedpaths = @()
        foreach ($currentPol_hardenedpaths in $policySettings.DeviceSettings.pol_hardenedpaths)
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
            if ($myPol_hardenedpaths.values.Where({$null -ne $_}).Count -gt 0)
            {
                $complexPol_hardenedpaths += $myPol_hardenedpaths
            }
        }
        $complexDeviceSettings.Add('Pol_hardenedpaths',$complexPol_hardenedpaths)
        $complexDeviceSettings.Add('WCM_BlockNonDomain', $policySettings.DeviceSettings.wCM_BlockNonDomain)
        $complexDeviceSettings.Add('ConfigureRedirectionGuardPolicy', $policySettings.DeviceSettings.configureRedirectionGuardPolicy)
        $complexDeviceSettings.Add('RedirectionGuardPolicy_Enum', $policySettings.DeviceSettings.redirectionGuardPolicy_Enum)
        $complexDeviceSettings.Add('ConfigureRpcConnectionPolicy', $policySettings.DeviceSettings.configureRpcConnectionPolicy)
        $complexDeviceSettings.Add('RpcConnectionAuthentication_Enum', $policySettings.DeviceSettings.rpcConnectionAuthentication_Enum)
        $complexDeviceSettings.Add('RpcConnectionProtocol_Enum', $policySettings.DeviceSettings.rpcConnectionProtocol_Enum)
        $complexDeviceSettings.Add('ConfigureRpcListenerPolicy', $policySettings.DeviceSettings.configureRpcListenerPolicy)
        $complexDeviceSettings.Add('RpcAuthenticationProtocol_Enum', $policySettings.DeviceSettings.rpcAuthenticationProtocol_Enum)
        $complexDeviceSettings.Add('RpcListenerProtocols_Enum', $policySettings.DeviceSettings.rpcListenerProtocols_Enum)
        $complexDeviceSettings.Add('ConfigureRpcTcpPort', $policySettings.DeviceSettings.configureRpcTcpPort)
        $complexDeviceSettings.Add('RpcTcpPort', $policySettings.DeviceSettings.rpcTcpPort)
        $complexDeviceSettings.Add('RestrictDriverInstallationToAdministrators', $policySettings.DeviceSettings.restrictDriverInstallationToAdministrators)
        $complexDeviceSettings.Add('ConfigureCopyFilesPolicy', $policySettings.DeviceSettings.configureCopyFilesPolicy)
        $complexDeviceSettings.Add('CopyFilesPolicy_Enum', $policySettings.DeviceSettings.copyFilesPolicy_Enum)
        $complexDeviceSettings.Add('AllowEncryptionOracle', $policySettings.DeviceSettings.allowEncryptionOracle)
        $complexDeviceSettings.Add('AllowEncryptionOracleDrop', $policySettings.DeviceSettings.allowEncryptionOracleDrop)
        $complexDeviceSettings.Add('AllowProtectedCreds', $policySettings.DeviceSettings.allowProtectedCreds)
        $complexDeviceSettings.Add('DeviceInstall_Classes_Deny', $policySettings.DeviceSettings.deviceInstall_Classes_Deny)
        $complexDeviceSettings.Add('DeviceInstall_Classes_Deny_Retroactive', $policySettings.DeviceSettings.deviceInstall_Classes_Deny_Retroactive)
        $complexDeviceSettings.Add('DeviceInstall_Classes_Deny_List', $policySettings.DeviceSettings.deviceInstall_Classes_Deny_List)
        $complexDeviceSettings.Add('POL_DriverLoadPolicy_Name', $policySettings.DeviceSettings.pOL_DriverLoadPolicy_Name)
        $complexDeviceSettings.Add('SelectDriverLoadPolicy', $policySettings.DeviceSettings.selectDriverLoadPolicy)
        $complexDeviceSettings.Add('CSE_Registry', $policySettings.DeviceSettings.cSE_Registry)
        $complexDeviceSettings.Add('CSE_NOBACKGROUND10', $policySettings.DeviceSettings.cSE_NOBACKGROUND10)
        $complexDeviceSettings.Add('CSE_NOCHANGES10', $policySettings.DeviceSettings.cSE_NOCHANGES10)
        $complexDeviceSettings.Add('DisableWebPnPDownload_2', $policySettings.DeviceSettings.disableWebPnPDownload_2)
        $complexDeviceSettings.Add('ShellPreventWPWDownload_2', $policySettings.DeviceSettings.shellPreventWPWDownload_2)
        $complexDeviceSettings.Add('AllowCustomSSPsAPs', $policySettings.DeviceSettings.allowCustomSSPsAPs)
        $complexDeviceSettings.Add('AllowStandbyStatesDC_2', $policySettings.DeviceSettings.allowStandbyStatesDC_2)
        $complexDeviceSettings.Add('AllowStandbyStatesAC_2', $policySettings.DeviceSettings.allowStandbyStatesAC_2)
        $complexDeviceSettings.Add('DCPromptForPasswordOnResume_2', $policySettings.DeviceSettings.dCPromptForPasswordOnResume_2)
        $complexDeviceSettings.Add('ACPromptForPasswordOnResume_2', $policySettings.DeviceSettings.aCPromptForPasswordOnResume_2)
        $complexDeviceSettings.Add('RA_Solicit', $policySettings.DeviceSettings.rA_Solicit)
        $complexDeviceSettings.Add('RA_Solicit_ExpireUnits_List', $policySettings.DeviceSettings.rA_Solicit_ExpireUnits_List)
        $complexDeviceSettings.Add('RA_Solicit_ExpireValue_Edt', $policySettings.DeviceSettings.rA_Solicit_ExpireValue_Edt)
        $complexDeviceSettings.Add('RA_Solicit_Control_List', $policySettings.DeviceSettings.rA_Solicit_Control_List)
        $complexDeviceSettings.Add('RA_Solicit_Mailto_List', $policySettings.DeviceSettings.rA_Solicit_Mailto_List)
        $complexDeviceSettings.Add('RpcRestrictRemoteClients', $policySettings.DeviceSettings.rpcRestrictRemoteClients)
        $complexDeviceSettings.Add('RpcRestrictRemoteClientsList', $policySettings.DeviceSettings.rpcRestrictRemoteClientsList)
        $complexDeviceSettings.Add('AppxRuntimeMicrosoftAccountsOptional', $policySettings.DeviceSettings.appxRuntimeMicrosoftAccountsOptional)
        $complexDeviceSettings.Add('NoAutoplayfornonVolume', $policySettings.DeviceSettings.noAutoplayfornonVolume)
        $complexDeviceSettings.Add('NoAutorun', $policySettings.DeviceSettings.noAutorun)
        $complexDeviceSettings.Add('NoAutorun_Dropdown', $policySettings.DeviceSettings.noAutorun_Dropdown)
        $complexDeviceSettings.Add('Autorun', $policySettings.DeviceSettings.autorun)
        $complexDeviceSettings.Add('Autorun_Box', $policySettings.DeviceSettings.autorun_Box)
        $complexDeviceSettings.Add('FDVDenyWriteAccess_Name', $policySettings.DeviceSettings.fDVDenyWriteAccess_Name)
        $complexDeviceSettings.Add('RDVDenyWriteAccess_Name', $policySettings.DeviceSettings.rDVDenyWriteAccess_Name)
        $complexDeviceSettings.Add('RDVCrossOrg', $policySettings.DeviceSettings.rDVCrossOrg)
        $complexDeviceSettings.Add('EnumerateAdministrators', $policySettings.DeviceSettings.enumerateAdministrators)
        $complexDeviceSettings.Add('Channel_LogMaxSize_1', $policySettings.DeviceSettings.channel_LogMaxSize_1)
        $complexDeviceSettings.Add('Channel_LogMaxSize_1_Channel_LogMaxSize', $policySettings.DeviceSettings.channel_LogMaxSize_1_Channel_LogMaxSize)
        $complexDeviceSettings.Add('Channel_LogMaxSize_2', $policySettings.DeviceSettings.channel_LogMaxSize_2)
        $complexDeviceSettings.Add('Channel_LogMaxSize_2_Channel_LogMaxSize', $policySettings.DeviceSettings.channel_LogMaxSize_2_Channel_LogMaxSize)
        $complexDeviceSettings.Add('Channel_LogMaxSize_4', $policySettings.DeviceSettings.channel_LogMaxSize_4)
        $complexDeviceSettings.Add('Channel_LogMaxSize_4_Channel_LogMaxSize', $policySettings.DeviceSettings.channel_LogMaxSize_4_Channel_LogMaxSize)
        $complexDeviceSettings.Add('EnableSmartScreen', $policySettings.DeviceSettings.enableSmartScreen)
        $complexDeviceSettings.Add('EnableSmartScreenDropdown', $policySettings.DeviceSettings.enableSmartScreenDropdown)
        $complexDeviceSettings.Add('NoDataExecutionPrevention', $policySettings.DeviceSettings.noDataExecutionPrevention)
        $complexDeviceSettings.Add('NoHeapTerminationOnCorruption', $policySettings.DeviceSettings.noHeapTerminationOnCorruption)
        $complexDeviceSettings.Add('Advanced_InvalidSignatureBlock', $policySettings.DeviceSettings.advanced_InvalidSignatureBlock)
        $complexDeviceSettings.Add('Advanced_CertificateRevocation', $policySettings.DeviceSettings.advanced_CertificateRevocation)
        $complexDeviceSettings.Add('Advanced_DownloadSignatures', $policySettings.DeviceSettings.advanced_DownloadSignatures)
        $complexDeviceSettings.Add('Advanced_DisableEPMCompat', $policySettings.DeviceSettings.advanced_DisableEPMCompat)
        $complexDeviceSettings.Add('Advanced_SetWinInetProtocols', $policySettings.DeviceSettings.advanced_SetWinInetProtocols)
        $complexDeviceSettings.Add('Advanced_WinInetProtocolOptions', $policySettings.DeviceSettings.advanced_WinInetProtocolOptions)
        $complexDeviceSettings.Add('Advanced_EnableEnhancedProtectedMode64Bit', $policySettings.DeviceSettings.advanced_EnableEnhancedProtectedMode64Bit)
        $complexDeviceSettings.Add('Advanced_EnableEnhancedProtectedMode', $policySettings.DeviceSettings.advanced_EnableEnhancedProtectedMode)
        $complexDeviceSettings.Add('NoCertError', $policySettings.DeviceSettings.noCertError)
        $complexDeviceSettings.Add('IZ_PolicyAccessDataSourcesAcrossDomains_1', $policySettings.DeviceSettings.iZ_PolicyAccessDataSourcesAcrossDomains_1)
        $complexDeviceSettings.Add('IZ_PolicyAccessDataSourcesAcrossDomains_1_IZ_Partname1406', $policySettings.DeviceSettings.iZ_PolicyAccessDataSourcesAcrossDomains_1_IZ_Partname1406)
        $complexDeviceSettings.Add('IZ_PolicyAllowPasteViaScript_1', $policySettings.DeviceSettings.iZ_PolicyAllowPasteViaScript_1)
        $complexDeviceSettings.Add('IZ_PolicyAllowPasteViaScript_1_IZ_Partname1407', $policySettings.DeviceSettings.iZ_PolicyAllowPasteViaScript_1_IZ_Partname1407)
        $complexDeviceSettings.Add('IZ_PolicyDropOrPasteFiles_1', $policySettings.DeviceSettings.iZ_PolicyDropOrPasteFiles_1)
        $complexDeviceSettings.Add('IZ_PolicyDropOrPasteFiles_1_IZ_Partname1802', $policySettings.DeviceSettings.iZ_PolicyDropOrPasteFiles_1_IZ_Partname1802)
        $complexDeviceSettings.Add('IZ_Policy_XAML_1', $policySettings.DeviceSettings.iZ_Policy_XAML_1)
        $complexDeviceSettings.Add('IZ_Policy_XAML_1_IZ_Partname2402', $policySettings.DeviceSettings.iZ_Policy_XAML_1_IZ_Partname2402)
        $complexDeviceSettings.Add('IZ_PolicyOnlyAllowApprovedDomainsToUseActiveXWithoutPrompt_Both_Internet', $policySettings.DeviceSettings.iZ_PolicyOnlyAllowApprovedDomainsToUseActiveXWithoutPrompt_Both_Internet)
        $complexDeviceSettings.Add('IZ_PolicyOnlyAllowApprovedDomainsToUseActiveXWithoutPrompt_Both_Internet_IZ_Partname120b', $policySettings.DeviceSettings.iZ_PolicyOnlyAllowApprovedDomainsToUseActiveXWithoutPrompt_Both_Internet_IZ_Partname120b)
        $complexDeviceSettings.Add('IZ_PolicyAllowTDCControl_Both_Internet', $policySettings.DeviceSettings.iZ_PolicyAllowTDCControl_Both_Internet)
        $complexDeviceSettings.Add('IZ_PolicyAllowTDCControl_Both_Internet_IZ_Partname120c', $policySettings.DeviceSettings.iZ_PolicyAllowTDCControl_Both_Internet_IZ_Partname120c)
        $complexDeviceSettings.Add('IZ_PolicyWindowsRestrictionsURLaction_1', $policySettings.DeviceSettings.iZ_PolicyWindowsRestrictionsURLaction_1)
        $complexDeviceSettings.Add('IZ_PolicyWindowsRestrictionsURLaction_1_IZ_Partname2102', $policySettings.DeviceSettings.iZ_PolicyWindowsRestrictionsURLaction_1_IZ_Partname2102)
        $complexDeviceSettings.Add('IZ_Policy_WebBrowserControl_1', $policySettings.DeviceSettings.iZ_Policy_WebBrowserControl_1)
        $complexDeviceSettings.Add('IZ_Policy_WebBrowserControl_1_IZ_Partname1206', $policySettings.DeviceSettings.iZ_Policy_WebBrowserControl_1_IZ_Partname1206)
        $complexDeviceSettings.Add('IZ_Policy_AllowScriptlets_1', $policySettings.DeviceSettings.iZ_Policy_AllowScriptlets_1)
        $complexDeviceSettings.Add('IZ_Policy_AllowScriptlets_1_IZ_Partname1209', $policySettings.DeviceSettings.iZ_Policy_AllowScriptlets_1_IZ_Partname1209)
        $complexDeviceSettings.Add('IZ_Policy_ScriptStatusBar_1', $policySettings.DeviceSettings.iZ_Policy_ScriptStatusBar_1)
        $complexDeviceSettings.Add('IZ_Policy_ScriptStatusBar_1_IZ_Partname2103', $policySettings.DeviceSettings.iZ_Policy_ScriptStatusBar_1_IZ_Partname2103)
        $complexDeviceSettings.Add('IZ_PolicyAllowVBScript_1', $policySettings.DeviceSettings.iZ_PolicyAllowVBScript_1)
        $complexDeviceSettings.Add('IZ_PolicyAllowVBScript_1_IZ_Partname140C', $policySettings.DeviceSettings.iZ_PolicyAllowVBScript_1_IZ_Partname140C)
        $complexDeviceSettings.Add('IZ_PolicyNotificationBarDownloadURLaction_1', $policySettings.DeviceSettings.iZ_PolicyNotificationBarDownloadURLaction_1)
        $complexDeviceSettings.Add('IZ_PolicyNotificationBarDownloadURLaction_1_IZ_Partname2200', $policySettings.DeviceSettings.iZ_PolicyNotificationBarDownloadURLaction_1_IZ_Partname2200)
        $complexDeviceSettings.Add('IZ_PolicyAntiMalwareCheckingOfActiveXControls_1', $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_1)
        $complexDeviceSettings.Add('IZ_PolicyAntiMalwareCheckingOfActiveXControls_1_IZ_Partname270C', $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_1_IZ_Partname270C)
        $complexDeviceSettings.Add('IZ_PolicyDownloadSignedActiveX_1', $policySettings.DeviceSettings.iZ_PolicyDownloadSignedActiveX_1)
        $complexDeviceSettings.Add('IZ_PolicyDownloadSignedActiveX_1_IZ_Partname1001', $policySettings.DeviceSettings.iZ_PolicyDownloadSignedActiveX_1_IZ_Partname1001)
        $complexDeviceSettings.Add('IZ_PolicyDownloadUnsignedActiveX_1', $policySettings.DeviceSettings.iZ_PolicyDownloadUnsignedActiveX_1)
        $complexDeviceSettings.Add('IZ_PolicyDownloadUnsignedActiveX_1_IZ_Partname1004', $policySettings.DeviceSettings.iZ_PolicyDownloadUnsignedActiveX_1_IZ_Partname1004)
        $complexDeviceSettings.Add('IZ_PolicyDragDropAcrossDomainsAcrossWindows_Both_Internet', $policySettings.DeviceSettings.iZ_PolicyDragDropAcrossDomainsAcrossWindows_Both_Internet)
        $complexDeviceSettings.Add('IZ_PolicyDragDropAcrossDomainsAcrossWindows_Both_Internet_IZ_Partname2709', $policySettings.DeviceSettings.iZ_PolicyDragDropAcrossDomainsAcrossWindows_Both_Internet_IZ_Partname2709)
        $complexDeviceSettings.Add('IZ_PolicyDragDropAcrossDomainsWithinWindow_Both_Internet', $policySettings.DeviceSettings.iZ_PolicyDragDropAcrossDomainsWithinWindow_Both_Internet)
        $complexDeviceSettings.Add('IZ_PolicyDragDropAcrossDomainsWithinWindow_Both_Internet_IZ_Partname2708', $policySettings.DeviceSettings.iZ_PolicyDragDropAcrossDomainsWithinWindow_Both_Internet_IZ_Partname2708)
        $complexDeviceSettings.Add('IZ_Policy_LocalPathForUpload_1', $policySettings.DeviceSettings.iZ_Policy_LocalPathForUpload_1)
        $complexDeviceSettings.Add('IZ_Policy_LocalPathForUpload_1_IZ_Partname160A', $policySettings.DeviceSettings.iZ_Policy_LocalPathForUpload_1_IZ_Partname160A)
        $complexDeviceSettings.Add('IZ_PolicyScriptActiveXNotMarkedSafe_1', $policySettings.DeviceSettings.iZ_PolicyScriptActiveXNotMarkedSafe_1)
        $complexDeviceSettings.Add('IZ_PolicyScriptActiveXNotMarkedSafe_1_IZ_Partname1201', $policySettings.DeviceSettings.iZ_PolicyScriptActiveXNotMarkedSafe_1_IZ_Partname1201)
        $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_1', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_1)
        $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_1_IZ_Partname1C00', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_1_IZ_Partname1C00)
        $complexDeviceSettings.Add('IZ_PolicyLaunchAppsAndFilesInIFRAME_1', $policySettings.DeviceSettings.iZ_PolicyLaunchAppsAndFilesInIFRAME_1)
        $complexDeviceSettings.Add('IZ_PolicyLaunchAppsAndFilesInIFRAME_1_IZ_Partname1804', $policySettings.DeviceSettings.iZ_PolicyLaunchAppsAndFilesInIFRAME_1_IZ_Partname1804)
        $complexDeviceSettings.Add('IZ_PolicyLogon_1', $policySettings.DeviceSettings.iZ_PolicyLogon_1)
        $complexDeviceSettings.Add('IZ_PolicyLogon_1_IZ_Partname1A00', $policySettings.DeviceSettings.iZ_PolicyLogon_1_IZ_Partname1A00)
        $complexDeviceSettings.Add('IZ_PolicyNavigateSubframesAcrossDomains_1', $policySettings.DeviceSettings.iZ_PolicyNavigateSubframesAcrossDomains_1)
        $complexDeviceSettings.Add('IZ_PolicyNavigateSubframesAcrossDomains_1_IZ_Partname1607', $policySettings.DeviceSettings.iZ_PolicyNavigateSubframesAcrossDomains_1_IZ_Partname1607)
        $complexDeviceSettings.Add('IZ_PolicyUnsignedFrameworkComponentsURLaction_1', $policySettings.DeviceSettings.iZ_PolicyUnsignedFrameworkComponentsURLaction_1)
        $complexDeviceSettings.Add('IZ_PolicyUnsignedFrameworkComponentsURLaction_1_IZ_Partname2004', $policySettings.DeviceSettings.iZ_PolicyUnsignedFrameworkComponentsURLaction_1_IZ_Partname2004)
        $complexDeviceSettings.Add('IZ_PolicySignedFrameworkComponentsURLaction_1', $policySettings.DeviceSettings.iZ_PolicySignedFrameworkComponentsURLaction_1)
        $complexDeviceSettings.Add('IZ_PolicySignedFrameworkComponentsURLaction_1_IZ_Partname2001', $policySettings.DeviceSettings.iZ_PolicySignedFrameworkComponentsURLaction_1_IZ_Partname2001)
        $complexDeviceSettings.Add('IZ_Policy_UnsafeFiles_1', $policySettings.DeviceSettings.iZ_Policy_UnsafeFiles_1)
        $complexDeviceSettings.Add('IZ_Policy_UnsafeFiles_1_IZ_Partname1806', $policySettings.DeviceSettings.iZ_Policy_UnsafeFiles_1_IZ_Partname1806)
        $complexDeviceSettings.Add('IZ_PolicyTurnOnXSSFilter_Both_Internet', $policySettings.DeviceSettings.iZ_PolicyTurnOnXSSFilter_Both_Internet)
        $complexDeviceSettings.Add('IZ_PolicyTurnOnXSSFilter_Both_Internet_IZ_Partname1409', $policySettings.DeviceSettings.iZ_PolicyTurnOnXSSFilter_Both_Internet_IZ_Partname1409)
        $complexDeviceSettings.Add('IZ_Policy_TurnOnProtectedMode_1', $policySettings.DeviceSettings.iZ_Policy_TurnOnProtectedMode_1)
        $complexDeviceSettings.Add('IZ_Policy_TurnOnProtectedMode_1_IZ_Partname2500', $policySettings.DeviceSettings.iZ_Policy_TurnOnProtectedMode_1_IZ_Partname2500)
        $complexDeviceSettings.Add('IZ_Policy_Phishing_1', $policySettings.DeviceSettings.iZ_Policy_Phishing_1)
        $complexDeviceSettings.Add('IZ_Policy_Phishing_1_IZ_Partname2301', $policySettings.DeviceSettings.iZ_Policy_Phishing_1_IZ_Partname2301)
        $complexDeviceSettings.Add('IZ_PolicyBlockPopupWindows_1', $policySettings.DeviceSettings.iZ_PolicyBlockPopupWindows_1)
        $complexDeviceSettings.Add('IZ_PolicyBlockPopupWindows_1_IZ_Partname1809', $policySettings.DeviceSettings.iZ_PolicyBlockPopupWindows_1_IZ_Partname1809)
        $complexDeviceSettings.Add('IZ_PolicyUserdataPersistence_1', $policySettings.DeviceSettings.iZ_PolicyUserdataPersistence_1)
        $complexDeviceSettings.Add('IZ_PolicyUserdataPersistence_1_IZ_Partname1606', $policySettings.DeviceSettings.iZ_PolicyUserdataPersistence_1_IZ_Partname1606)
        $complexDeviceSettings.Add('IZ_PolicyZoneElevationURLaction_1', $policySettings.DeviceSettings.iZ_PolicyZoneElevationURLaction_1)
        $complexDeviceSettings.Add('IZ_PolicyZoneElevationURLaction_1_IZ_Partname2101', $policySettings.DeviceSettings.iZ_PolicyZoneElevationURLaction_1_IZ_Partname2101)
        $complexDeviceSettings.Add('IZ_UNCAsIntranet', $policySettings.DeviceSettings.iZ_UNCAsIntranet)
        $complexDeviceSettings.Add('IZ_PolicyAntiMalwareCheckingOfActiveXControls_3', $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_3)
        $complexDeviceSettings.Add('IZ_PolicyAntiMalwareCheckingOfActiveXControls_3_IZ_Partname270C', $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_3_IZ_Partname270C)
        $complexDeviceSettings.Add('IZ_PolicyScriptActiveXNotMarkedSafe_3', $policySettings.DeviceSettings.iZ_PolicyScriptActiveXNotMarkedSafe_3)
        $complexDeviceSettings.Add('IZ_PolicyScriptActiveXNotMarkedSafe_3_IZ_Partname1201', $policySettings.DeviceSettings.iZ_PolicyScriptActiveXNotMarkedSafe_3_IZ_Partname1201)
        $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_3', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_3)
        $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_3_IZ_Partname1C00', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_3_IZ_Partname1C00)
        $complexDeviceSettings.Add('IZ_PolicyAntiMalwareCheckingOfActiveXControls_9', $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_9)
        $complexDeviceSettings.Add('IZ_PolicyAntiMalwareCheckingOfActiveXControls_9_IZ_Partname270C', $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_9_IZ_Partname270C)
        $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_9', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_9)
        $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_9_IZ_Partname1C00', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_9_IZ_Partname1C00)
        $complexDeviceSettings.Add('IZ_Policy_Phishing_2', $policySettings.DeviceSettings.iZ_Policy_Phishing_2)
        $complexDeviceSettings.Add('IZ_Policy_Phishing_2_IZ_Partname2301', $policySettings.DeviceSettings.iZ_Policy_Phishing_2_IZ_Partname2301)
        $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_4', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_4)
        $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_4_IZ_Partname1C00', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_4_IZ_Partname1C00)
        $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_10', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_10)
        $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_10_IZ_Partname1C00', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_10_IZ_Partname1C00)
        $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_8', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_8)
        $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_8_IZ_Partname1C00', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_8_IZ_Partname1C00)
        $complexDeviceSettings.Add('IZ_Policy_Phishing_8', $policySettings.DeviceSettings.iZ_Policy_Phishing_8)
        $complexDeviceSettings.Add('IZ_Policy_Phishing_8_IZ_Partname2301', $policySettings.DeviceSettings.iZ_Policy_Phishing_8_IZ_Partname2301)
        $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_6', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_6)
        $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_6_IZ_Partname1C00', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_6_IZ_Partname1C00)
        $complexDeviceSettings.Add('IZ_PolicyAccessDataSourcesAcrossDomains_7', $policySettings.DeviceSettings.iZ_PolicyAccessDataSourcesAcrossDomains_7)
        $complexDeviceSettings.Add('IZ_PolicyAccessDataSourcesAcrossDomains_7_IZ_Partname1406', $policySettings.DeviceSettings.iZ_PolicyAccessDataSourcesAcrossDomains_7_IZ_Partname1406)
        $complexDeviceSettings.Add('IZ_PolicyActiveScripting_7', $policySettings.DeviceSettings.iZ_PolicyActiveScripting_7)
        $complexDeviceSettings.Add('IZ_Partname1400', $policySettings.DeviceSettings.iZ_Partname1400)
        $complexDeviceSettings.Add('IZ_PolicyBinaryBehaviors_7', $policySettings.DeviceSettings.iZ_PolicyBinaryBehaviors_7)
        $complexDeviceSettings.Add('IZ_Partname2000', $policySettings.DeviceSettings.iZ_Partname2000)
        $complexDeviceSettings.Add('IZ_PolicyAllowPasteViaScript_7', $policySettings.DeviceSettings.iZ_PolicyAllowPasteViaScript_7)
        $complexDeviceSettings.Add('IZ_PolicyAllowPasteViaScript_7_IZ_Partname1407', $policySettings.DeviceSettings.iZ_PolicyAllowPasteViaScript_7_IZ_Partname1407)
        $complexDeviceSettings.Add('IZ_PolicyDropOrPasteFiles_7', $policySettings.DeviceSettings.iZ_PolicyDropOrPasteFiles_7)
        $complexDeviceSettings.Add('IZ_PolicyDropOrPasteFiles_7_IZ_Partname1802', $policySettings.DeviceSettings.iZ_PolicyDropOrPasteFiles_7_IZ_Partname1802)
        $complexDeviceSettings.Add('IZ_PolicyFileDownload_7', $policySettings.DeviceSettings.iZ_PolicyFileDownload_7)
        $complexDeviceSettings.Add('IZ_Partname1803', $policySettings.DeviceSettings.iZ_Partname1803)
        $complexDeviceSettings.Add('IZ_Policy_XAML_7', $policySettings.DeviceSettings.iZ_Policy_XAML_7)
        $complexDeviceSettings.Add('IZ_Policy_XAML_7_IZ_Partname2402', $policySettings.DeviceSettings.iZ_Policy_XAML_7_IZ_Partname2402)
        $complexDeviceSettings.Add('IZ_PolicyAllowMETAREFRESH_7', $policySettings.DeviceSettings.iZ_PolicyAllowMETAREFRESH_7)
        $complexDeviceSettings.Add('IZ_Partname1608', $policySettings.DeviceSettings.iZ_Partname1608)
        $complexDeviceSettings.Add('IZ_PolicyOnlyAllowApprovedDomainsToUseActiveXWithoutPrompt_Both_Restricted', $policySettings.DeviceSettings.iZ_PolicyOnlyAllowApprovedDomainsToUseActiveXWithoutPrompt_Both_Restricted)
        $complexDeviceSettings.Add('IZ_PolicyOnlyAllowApprovedDomainsToUseActiveXWithoutPrompt_Both_Restricted_IZ_Partname120b', $policySettings.DeviceSettings.iZ_PolicyOnlyAllowApprovedDomainsToUseActiveXWithoutPrompt_Both_Restricted_IZ_Partname120b)
        $complexDeviceSettings.Add('IZ_PolicyAllowTDCControl_Both_Restricted', $policySettings.DeviceSettings.iZ_PolicyAllowTDCControl_Both_Restricted)
        $complexDeviceSettings.Add('IZ_PolicyAllowTDCControl_Both_Restricted_IZ_Partname120c', $policySettings.DeviceSettings.iZ_PolicyAllowTDCControl_Both_Restricted_IZ_Partname120c)
        $complexDeviceSettings.Add('IZ_PolicyWindowsRestrictionsURLaction_7', $policySettings.DeviceSettings.iZ_PolicyWindowsRestrictionsURLaction_7)
        $complexDeviceSettings.Add('IZ_PolicyWindowsRestrictionsURLaction_7_IZ_Partname2102', $policySettings.DeviceSettings.iZ_PolicyWindowsRestrictionsURLaction_7_IZ_Partname2102)
        $complexDeviceSettings.Add('IZ_Policy_WebBrowserControl_7', $policySettings.DeviceSettings.iZ_Policy_WebBrowserControl_7)
        $complexDeviceSettings.Add('IZ_Policy_WebBrowserControl_7_IZ_Partname1206', $policySettings.DeviceSettings.iZ_Policy_WebBrowserControl_7_IZ_Partname1206)
        $complexDeviceSettings.Add('IZ_Policy_AllowScriptlets_7', $policySettings.DeviceSettings.iZ_Policy_AllowScriptlets_7)
        $complexDeviceSettings.Add('IZ_Policy_AllowScriptlets_7_IZ_Partname1209', $policySettings.DeviceSettings.iZ_Policy_AllowScriptlets_7_IZ_Partname1209)
        $complexDeviceSettings.Add('IZ_Policy_ScriptStatusBar_7', $policySettings.DeviceSettings.iZ_Policy_ScriptStatusBar_7)
        $complexDeviceSettings.Add('IZ_Policy_ScriptStatusBar_7_IZ_Partname2103', $policySettings.DeviceSettings.iZ_Policy_ScriptStatusBar_7_IZ_Partname2103)
        $complexDeviceSettings.Add('IZ_PolicyAllowVBScript_7', $policySettings.DeviceSettings.iZ_PolicyAllowVBScript_7)
        $complexDeviceSettings.Add('IZ_PolicyAllowVBScript_7_IZ_Partname140C', $policySettings.DeviceSettings.iZ_PolicyAllowVBScript_7_IZ_Partname140C)
        $complexDeviceSettings.Add('IZ_PolicyNotificationBarDownloadURLaction_7', $policySettings.DeviceSettings.iZ_PolicyNotificationBarDownloadURLaction_7)
        $complexDeviceSettings.Add('IZ_PolicyNotificationBarDownloadURLaction_7_IZ_Partname2200', $policySettings.DeviceSettings.iZ_PolicyNotificationBarDownloadURLaction_7_IZ_Partname2200)
        $complexDeviceSettings.Add('IZ_PolicyAntiMalwareCheckingOfActiveXControls_7', $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_7)
        $complexDeviceSettings.Add('IZ_PolicyAntiMalwareCheckingOfActiveXControls_7_IZ_Partname270C', $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_7_IZ_Partname270C)
        $complexDeviceSettings.Add('IZ_PolicyDownloadSignedActiveX_7', $policySettings.DeviceSettings.iZ_PolicyDownloadSignedActiveX_7)
        $complexDeviceSettings.Add('IZ_PolicyDownloadSignedActiveX_7_IZ_Partname1001', $policySettings.DeviceSettings.iZ_PolicyDownloadSignedActiveX_7_IZ_Partname1001)
        $complexDeviceSettings.Add('IZ_PolicyDownloadUnsignedActiveX_7', $policySettings.DeviceSettings.iZ_PolicyDownloadUnsignedActiveX_7)
        $complexDeviceSettings.Add('IZ_PolicyDownloadUnsignedActiveX_7_IZ_Partname1004', $policySettings.DeviceSettings.iZ_PolicyDownloadUnsignedActiveX_7_IZ_Partname1004)
        $complexDeviceSettings.Add('IZ_PolicyDragDropAcrossDomainsAcrossWindows_Both_Restricted', $policySettings.DeviceSettings.iZ_PolicyDragDropAcrossDomainsAcrossWindows_Both_Restricted)
        $complexDeviceSettings.Add('IZ_PolicyDragDropAcrossDomainsAcrossWindows_Both_Restricted_IZ_Partname2709', $policySettings.DeviceSettings.iZ_PolicyDragDropAcrossDomainsAcrossWindows_Both_Restricted_IZ_Partname2709)
        $complexDeviceSettings.Add('IZ_PolicyDragDropAcrossDomainsWithinWindow_Both_Restricted', $policySettings.DeviceSettings.iZ_PolicyDragDropAcrossDomainsWithinWindow_Both_Restricted)
        $complexDeviceSettings.Add('IZ_PolicyDragDropAcrossDomainsWithinWindow_Both_Restricted_IZ_Partname2708', $policySettings.DeviceSettings.iZ_PolicyDragDropAcrossDomainsWithinWindow_Both_Restricted_IZ_Partname2708)
        $complexDeviceSettings.Add('IZ_Policy_LocalPathForUpload_7', $policySettings.DeviceSettings.iZ_Policy_LocalPathForUpload_7)
        $complexDeviceSettings.Add('IZ_Policy_LocalPathForUpload_7_IZ_Partname160A', $policySettings.DeviceSettings.iZ_Policy_LocalPathForUpload_7_IZ_Partname160A)
        $complexDeviceSettings.Add('IZ_PolicyScriptActiveXNotMarkedSafe_7', $policySettings.DeviceSettings.iZ_PolicyScriptActiveXNotMarkedSafe_7)
        $complexDeviceSettings.Add('IZ_PolicyScriptActiveXNotMarkedSafe_7_IZ_Partname1201', $policySettings.DeviceSettings.iZ_PolicyScriptActiveXNotMarkedSafe_7_IZ_Partname1201)
        $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_7', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_7)
        $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_7_IZ_Partname1C00', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_7_IZ_Partname1C00)
        $complexDeviceSettings.Add('IZ_PolicyLaunchAppsAndFilesInIFRAME_7', $policySettings.DeviceSettings.iZ_PolicyLaunchAppsAndFilesInIFRAME_7)
        $complexDeviceSettings.Add('IZ_PolicyLaunchAppsAndFilesInIFRAME_7_IZ_Partname1804', $policySettings.DeviceSettings.iZ_PolicyLaunchAppsAndFilesInIFRAME_7_IZ_Partname1804)
        $complexDeviceSettings.Add('IZ_PolicyLogon_7', $policySettings.DeviceSettings.iZ_PolicyLogon_7)
        $complexDeviceSettings.Add('IZ_PolicyLogon_7_IZ_Partname1A00', $policySettings.DeviceSettings.iZ_PolicyLogon_7_IZ_Partname1A00)
        $complexDeviceSettings.Add('IZ_PolicyNavigateSubframesAcrossDomains_7', $policySettings.DeviceSettings.iZ_PolicyNavigateSubframesAcrossDomains_7)
        $complexDeviceSettings.Add('IZ_PolicyNavigateSubframesAcrossDomains_7_IZ_Partname1607', $policySettings.DeviceSettings.iZ_PolicyNavigateSubframesAcrossDomains_7_IZ_Partname1607)
        $complexDeviceSettings.Add('IZ_PolicyUnsignedFrameworkComponentsURLaction_7', $policySettings.DeviceSettings.iZ_PolicyUnsignedFrameworkComponentsURLaction_7)
        $complexDeviceSettings.Add('IZ_PolicyUnsignedFrameworkComponentsURLaction_7_IZ_Partname2004', $policySettings.DeviceSettings.iZ_PolicyUnsignedFrameworkComponentsURLaction_7_IZ_Partname2004)
        $complexDeviceSettings.Add('IZ_PolicySignedFrameworkComponentsURLaction_7', $policySettings.DeviceSettings.iZ_PolicySignedFrameworkComponentsURLaction_7)
        $complexDeviceSettings.Add('IZ_PolicySignedFrameworkComponentsURLaction_7_IZ_Partname2001', $policySettings.DeviceSettings.iZ_PolicySignedFrameworkComponentsURLaction_7_IZ_Partname2001)
        $complexDeviceSettings.Add('IZ_PolicyRunActiveXControls_7', $policySettings.DeviceSettings.iZ_PolicyRunActiveXControls_7)
        $complexDeviceSettings.Add('IZ_Partname1200', $policySettings.DeviceSettings.iZ_Partname1200)
        $complexDeviceSettings.Add('IZ_PolicyScriptActiveXMarkedSafe_7', $policySettings.DeviceSettings.iZ_PolicyScriptActiveXMarkedSafe_7)
        $complexDeviceSettings.Add('IZ_Partname1405', $policySettings.DeviceSettings.iZ_Partname1405)
        $complexDeviceSettings.Add('IZ_PolicyScriptingOfJavaApplets_7', $policySettings.DeviceSettings.iZ_PolicyScriptingOfJavaApplets_7)
        $complexDeviceSettings.Add('IZ_Partname1402', $policySettings.DeviceSettings.iZ_Partname1402)
        $complexDeviceSettings.Add('IZ_Policy_UnsafeFiles_7', $policySettings.DeviceSettings.iZ_Policy_UnsafeFiles_7)
        $complexDeviceSettings.Add('IZ_Policy_UnsafeFiles_7_IZ_Partname1806', $policySettings.DeviceSettings.iZ_Policy_UnsafeFiles_7_IZ_Partname1806)
        $complexDeviceSettings.Add('IZ_PolicyTurnOnXSSFilter_Both_Restricted', $policySettings.DeviceSettings.iZ_PolicyTurnOnXSSFilter_Both_Restricted)
        $complexDeviceSettings.Add('IZ_PolicyTurnOnXSSFilter_Both_Restricted_IZ_Partname1409', $policySettings.DeviceSettings.iZ_PolicyTurnOnXSSFilter_Both_Restricted_IZ_Partname1409)
        $complexDeviceSettings.Add('IZ_Policy_TurnOnProtectedMode_7', $policySettings.DeviceSettings.iZ_Policy_TurnOnProtectedMode_7)
        $complexDeviceSettings.Add('IZ_Policy_TurnOnProtectedMode_7_IZ_Partname2500', $policySettings.DeviceSettings.iZ_Policy_TurnOnProtectedMode_7_IZ_Partname2500)
        $complexDeviceSettings.Add('IZ_Policy_Phishing_7', $policySettings.DeviceSettings.iZ_Policy_Phishing_7)
        $complexDeviceSettings.Add('IZ_Policy_Phishing_7_IZ_Partname2301', $policySettings.DeviceSettings.iZ_Policy_Phishing_7_IZ_Partname2301)
        $complexDeviceSettings.Add('IZ_PolicyBlockPopupWindows_7', $policySettings.DeviceSettings.iZ_PolicyBlockPopupWindows_7)
        $complexDeviceSettings.Add('IZ_PolicyBlockPopupWindows_7_IZ_Partname1809', $policySettings.DeviceSettings.iZ_PolicyBlockPopupWindows_7_IZ_Partname1809)
        $complexDeviceSettings.Add('IZ_PolicyUserdataPersistence_7', $policySettings.DeviceSettings.iZ_PolicyUserdataPersistence_7)
        $complexDeviceSettings.Add('IZ_PolicyUserdataPersistence_7_IZ_Partname1606', $policySettings.DeviceSettings.iZ_PolicyUserdataPersistence_7_IZ_Partname1606)
        $complexDeviceSettings.Add('IZ_PolicyZoneElevationURLaction_7', $policySettings.DeviceSettings.iZ_PolicyZoneElevationURLaction_7)
        $complexDeviceSettings.Add('IZ_PolicyZoneElevationURLaction_7_IZ_Partname2101', $policySettings.DeviceSettings.iZ_PolicyZoneElevationURLaction_7_IZ_Partname2101)
        $complexDeviceSettings.Add('IZ_PolicyAntiMalwareCheckingOfActiveXControls_5', $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_5)
        $complexDeviceSettings.Add('IZ_PolicyAntiMalwareCheckingOfActiveXControls_5_IZ_Partname270C', $policySettings.DeviceSettings.iZ_PolicyAntiMalwareCheckingOfActiveXControls_5_IZ_Partname270C)
        $complexDeviceSettings.Add('IZ_PolicyScriptActiveXNotMarkedSafe_5', $policySettings.DeviceSettings.iZ_PolicyScriptActiveXNotMarkedSafe_5)
        $complexDeviceSettings.Add('IZ_PolicyScriptActiveXNotMarkedSafe_5_IZ_Partname1201', $policySettings.DeviceSettings.iZ_PolicyScriptActiveXNotMarkedSafe_5_IZ_Partname1201)
        $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_5', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_5)
        $complexDeviceSettings.Add('IZ_PolicyJavaPermissions_5_IZ_Partname1C00', $policySettings.DeviceSettings.iZ_PolicyJavaPermissions_5_IZ_Partname1C00)
        $complexDeviceSettings.Add('IZ_PolicyWarnCertMismatch', $policySettings.DeviceSettings.iZ_PolicyWarnCertMismatch)
        $complexDeviceSettings.Add('DisableSafetyFilterOverride', $policySettings.DeviceSettings.disableSafetyFilterOverride)
        $complexDeviceSettings.Add('DisableSafetyFilterOverrideForAppRepUnknown', $policySettings.DeviceSettings.disableSafetyFilterOverrideForAppRepUnknown)
        $complexDeviceSettings.Add('Disable_Managing_Safety_Filter_IE9', $policySettings.DeviceSettings.disable_Managing_Safety_Filter_IE9)
        $complexDeviceSettings.Add('IE9SafetyFilterOptions', $policySettings.DeviceSettings.iE9SafetyFilterOptions)
        $complexDeviceSettings.Add('DisablePerUserActiveXInstall', $policySettings.DeviceSettings.disablePerUserActiveXInstall)
        $complexDeviceSettings.Add('VerMgmtDisableRunThisTime', $policySettings.DeviceSettings.verMgmtDisableRunThisTime)
        $complexDeviceSettings.Add('VerMgmtDisable', $policySettings.DeviceSettings.verMgmtDisable)
        $complexDeviceSettings.Add('Advanced_EnableSSL3Fallback', $policySettings.DeviceSettings.advanced_EnableSSL3Fallback)
        $complexDeviceSettings.Add('Advanced_EnableSSL3FallbackOptions', $policySettings.DeviceSettings.advanced_EnableSSL3FallbackOptions)
        $complexDeviceSettings.Add('IESF_PolicyExplorerProcesses_5', $policySettings.DeviceSettings.iESF_PolicyExplorerProcesses_5)
        $complexDeviceSettings.Add('IESF_PolicyExplorerProcesses_6', $policySettings.DeviceSettings.iESF_PolicyExplorerProcesses_6)
        $complexDeviceSettings.Add('IESF_PolicyExplorerProcesses_3', $policySettings.DeviceSettings.iESF_PolicyExplorerProcesses_3)
        $complexDeviceSettings.Add('IESF_PolicyExplorerProcesses_10', $policySettings.DeviceSettings.iESF_PolicyExplorerProcesses_10)
        $complexDeviceSettings.Add('IESF_PolicyExplorerProcesses_9', $policySettings.DeviceSettings.iESF_PolicyExplorerProcesses_9)
        $complexDeviceSettings.Add('IESF_PolicyExplorerProcesses_11', $policySettings.DeviceSettings.iESF_PolicyExplorerProcesses_11)
        $complexDeviceSettings.Add('IESF_PolicyExplorerProcesses_12', $policySettings.DeviceSettings.iESF_PolicyExplorerProcesses_12)
        $complexDeviceSettings.Add('IESF_PolicyExplorerProcesses_8', $policySettings.DeviceSettings.iESF_PolicyExplorerProcesses_8)
        $complexDeviceSettings.Add('Security_zones_map_edit', $policySettings.DeviceSettings.security_zones_map_edit)
        $complexDeviceSettings.Add('Security_options_edit', $policySettings.DeviceSettings.security_options_edit)
        $complexDeviceSettings.Add('Security_HKLM_only', $policySettings.DeviceSettings.security_HKLM_only)
        $complexDeviceSettings.Add('OnlyUseAXISForActiveXInstall', $policySettings.DeviceSettings.onlyUseAXISForActiveXInstall)
        $complexDeviceSettings.Add('AddonManagement_RestrictCrashDetection', $policySettings.DeviceSettings.addonManagement_RestrictCrashDetection)
        $complexDeviceSettings.Add('Disable_Security_Settings_Check', $policySettings.DeviceSettings.disable_Security_Settings_Check)
        $complexDeviceSettings.Add('DisableBlockAtFirstSeen', $policySettings.DeviceSettings.disableBlockAtFirstSeen)
        $complexDeviceSettings.Add('RealtimeProtection_DisableScanOnRealtimeEnable', $policySettings.DeviceSettings.realtimeProtection_DisableScanOnRealtimeEnable)
        $complexDeviceSettings.Add('Scan_DisablePackedExeScanning', $policySettings.DeviceSettings.scan_DisablePackedExeScanning)
        $complexDeviceSettings.Add('DisableRoutinelyTakingAction', $policySettings.DeviceSettings.disableRoutinelyTakingAction)
        $complexDeviceSettings.Add('TS_CLIENT_DISABLE_PASSWORD_SAVING_2', $policySettings.DeviceSettings.tS_CLIENT_DISABLE_PASSWORD_SAVING_2)
        $complexDeviceSettings.Add('TS_CLIENT_DRIVE_M', $policySettings.DeviceSettings.tS_CLIENT_DRIVE_M)
        $complexDeviceSettings.Add('TS_PASSWORD', $policySettings.DeviceSettings.tS_PASSWORD)
        $complexDeviceSettings.Add('TS_RPC_ENCRYPTION', $policySettings.DeviceSettings.tS_RPC_ENCRYPTION)
        $complexDeviceSettings.Add('TS_ENCRYPTION_POLICY', $policySettings.DeviceSettings.tS_ENCRYPTION_POLICY)
        $complexDeviceSettings.Add('TS_ENCRYPTION_LEVEL', $policySettings.DeviceSettings.tS_ENCRYPTION_LEVEL)
        $complexDeviceSettings.Add('Disable_Downloading_of_Enclosures', $policySettings.DeviceSettings.disable_Downloading_of_Enclosures)
        $complexDeviceSettings.Add('EnableMPRNotifications', $policySettings.DeviceSettings.enableMPRNotifications)
        $complexDeviceSettings.Add('AutomaticRestartSignOn', $policySettings.DeviceSettings.automaticRestartSignOn)
        $complexDeviceSettings.Add('EnableScriptBlockLogging', $policySettings.DeviceSettings.enableScriptBlockLogging)
        $complexDeviceSettings.Add('EnableScriptBlockInvocationLogging', $policySettings.DeviceSettings.enableScriptBlockInvocationLogging)
        $complexDeviceSettings.Add('AllowBasic_2', $policySettings.DeviceSettings.allowBasic_2)
        $complexDeviceSettings.Add('AllowUnencrypted_2', $policySettings.DeviceSettings.allowUnencrypted_2)
        $complexDeviceSettings.Add('DisallowDigest', $policySettings.DeviceSettings.disallowDigest)
        $complexDeviceSettings.Add('AllowBasic_1', $policySettings.DeviceSettings.allowBasic_1)
        $complexDeviceSettings.Add('AllowUnencrypted_1', $policySettings.DeviceSettings.allowUnencrypted_1)
        $complexDeviceSettings.Add('DisableRunAs', $policySettings.DeviceSettings.disableRunAs)
        $complexDeviceSettings.Add('AccountLogon_AuditCredentialValidation', $policySettings.DeviceSettings.accountLogon_AuditCredentialValidation)
        $complexDeviceSettings.Add('AccountLogonLogoff_AuditAccountLockout', $policySettings.DeviceSettings.accountLogonLogoff_AuditAccountLockout)
        $complexDeviceSettings.Add('AccountLogonLogoff_AuditGroupMembership', $policySettings.DeviceSettings.accountLogonLogoff_AuditGroupMembership)
        $complexDeviceSettings.Add('AccountLogonLogoff_AuditLogon', $policySettings.DeviceSettings.accountLogonLogoff_AuditLogon)
        $complexDeviceSettings.Add('PolicyChange_AuditAuthenticationPolicyChange', $policySettings.DeviceSettings.policyChange_AuditAuthenticationPolicyChange)
        $complexDeviceSettings.Add('PolicyChange_AuditPolicyChange', $policySettings.DeviceSettings.policyChange_AuditPolicyChange)
        $complexDeviceSettings.Add('ObjectAccess_AuditFileShare', $policySettings.DeviceSettings.objectAccess_AuditFileShare)
        $complexDeviceSettings.Add('AccountLogonLogoff_AuditOtherLogonLogoffEvents', $policySettings.DeviceSettings.accountLogonLogoff_AuditOtherLogonLogoffEvents)
        $complexDeviceSettings.Add('AccountManagement_AuditSecurityGroupManagement', $policySettings.DeviceSettings.accountManagement_AuditSecurityGroupManagement)
        $complexDeviceSettings.Add('System_AuditSecuritySystemExtension', $policySettings.DeviceSettings.system_AuditSecuritySystemExtension)
        $complexDeviceSettings.Add('AccountLogonLogoff_AuditSpecialLogon', $policySettings.DeviceSettings.accountLogonLogoff_AuditSpecialLogon)
        $complexDeviceSettings.Add('AccountManagement_AuditUserAccountManagement', $policySettings.DeviceSettings.accountManagement_AuditUserAccountManagement)
        $complexDeviceSettings.Add('DetailedTracking_AuditPNPActivity', $policySettings.DeviceSettings.detailedTracking_AuditPNPActivity)
        $complexDeviceSettings.Add('DetailedTracking_AuditProcessCreation', $policySettings.DeviceSettings.detailedTracking_AuditProcessCreation)
        $complexDeviceSettings.Add('ObjectAccess_AuditDetailedFileShare', $policySettings.DeviceSettings.objectAccess_AuditDetailedFileShare)
        $complexDeviceSettings.Add('ObjectAccess_AuditOtherObjectAccessEvents', $policySettings.DeviceSettings.objectAccess_AuditOtherObjectAccessEvents)
        $complexDeviceSettings.Add('ObjectAccess_AuditRemovableStorage', $policySettings.DeviceSettings.objectAccess_AuditRemovableStorage)
        $complexDeviceSettings.Add('PolicyChange_AuditMPSSVCRuleLevelPolicyChange', $policySettings.DeviceSettings.policyChange_AuditMPSSVCRuleLevelPolicyChange)
        $complexDeviceSettings.Add('PolicyChange_AuditOtherPolicyChangeEvents', $policySettings.DeviceSettings.policyChange_AuditOtherPolicyChangeEvents)
        $complexDeviceSettings.Add('PrivilegeUse_AuditSensitivePrivilegeUse', $policySettings.DeviceSettings.privilegeUse_AuditSensitivePrivilegeUse)
        $complexDeviceSettings.Add('System_AuditOtherSystemEvents', $policySettings.DeviceSettings.system_AuditOtherSystemEvents)
        $complexDeviceSettings.Add('System_AuditSecurityStateChange', $policySettings.DeviceSettings.system_AuditSecurityStateChange)
        $complexDeviceSettings.Add('System_AuditSystemIntegrity', $policySettings.DeviceSettings.system_AuditSystemIntegrity)
        $complexDeviceSettings.Add('AllowPasswordManager', $policySettings.DeviceSettings.allowPasswordManager)
        $complexDeviceSettings.Add('AllowSmartScreen', $policySettings.DeviceSettings.allowSmartScreen)
        $complexDeviceSettings.Add('PreventCertErrorOverrides', $policySettings.DeviceSettings.preventCertErrorOverrides)
        $complexDeviceSettings.Add('Browser_PreventSmartScreenPromptOverride', $policySettings.DeviceSettings.browser_PreventSmartScreenPromptOverride)
        $complexDeviceSettings.Add('PreventSmartScreenPromptOverrideForFiles', $policySettings.DeviceSettings.preventSmartScreenPromptOverrideForFiles)
        $complexDeviceSettings.Add('AllowDirectMemoryAccess', $policySettings.DeviceSettings.allowDirectMemoryAccess)
        $complexDeviceSettings.Add('AllowArchiveScanning', $policySettings.DeviceSettings.allowArchiveScanning)
        $complexDeviceSettings.Add('AllowBehaviorMonitoring', $policySettings.DeviceSettings.allowBehaviorMonitoring)
        $complexDeviceSettings.Add('AllowCloudProtection', $policySettings.DeviceSettings.allowCloudProtection)
        $complexDeviceSettings.Add('AllowFullScanRemovableDriveScanning', $policySettings.DeviceSettings.allowFullScanRemovableDriveScanning)
        $complexDeviceSettings.Add('AllowOnAccessProtection', $policySettings.DeviceSettings.allowOnAccessProtection)
        $complexDeviceSettings.Add('AllowRealtimeMonitoring', $policySettings.DeviceSettings.allowRealtimeMonitoring)
        $complexDeviceSettings.Add('AllowIOAVProtection', $policySettings.DeviceSettings.allowIOAVProtection)
        $complexDeviceSettings.Add('AllowScriptScanning', $policySettings.DeviceSettings.allowScriptScanning)
        $complexDeviceSettings.Add('BlockExecutionOfPotentiallyObfuscatedScripts', $policySettings.DeviceSettings.blockExecutionOfPotentiallyObfuscatedScripts)
        $complexDeviceSettings.Add('BlockExecutionOfPotentiallyObfuscatedScripts_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockExecutionOfPotentiallyObfuscatedScripts_ASROnlyPerRuleExclusions)
        $complexDeviceSettings.Add('BlockOfficeCommunicationAppFromCreatingChildProcesses', $policySettings.DeviceSettings.blockOfficeCommunicationAppFromCreatingChildProcesses)
        $complexDeviceSettings.Add('BlockOfficeCommunicationAppFromCreatingChildProcesses_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockOfficeCommunicationAppFromCreatingChildProcesses_ASROnlyPerRuleExclusions)
        $complexDeviceSettings.Add('BlockAllOfficeApplicationsFromCreatingChildProcesses', $policySettings.DeviceSettings.blockAllOfficeApplicationsFromCreatingChildProcesses)
        $complexDeviceSettings.Add('BlockAllOfficeApplicationsFromCreatingChildProcesses_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockAllOfficeApplicationsFromCreatingChildProcesses_ASROnlyPerRuleExclusions)
        $complexDeviceSettings.Add('BlockWin32APICallsFromOfficeMacros', $policySettings.DeviceSettings.blockWin32APICallsFromOfficeMacros)
        $complexDeviceSettings.Add('BlockWin32APICallsFromOfficeMacros_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockWin32APICallsFromOfficeMacros_ASROnlyPerRuleExclusions)
        $complexDeviceSettings.Add('BlockExecutableFilesRunningUnlessTheyMeetPrevalenceAgeTrustedListCriterion', $policySettings.DeviceSettings.blockExecutableFilesRunningUnlessTheyMeetPrevalenceAgeTrustedListCriterion)
        $complexDeviceSettings.Add('BlockExecutableFilesRunningUnlessTheyMeetPrevalenceAgeTrustedListCriterion_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockExecutableFilesRunningUnlessTheyMeetPrevalenceAgeTrustedListCriterion_ASROnlyPerRuleExclusions)
        $complexDeviceSettings.Add('BlockJavaScriptOrVBScriptFromLaunchingDownloadedExecutableContent', $policySettings.DeviceSettings.blockJavaScriptOrVBScriptFromLaunchingDownloadedExecutableContent)
        $complexDeviceSettings.Add('BlockJavaScriptOrVBScriptFromLaunchingDownloadedExecutableContent_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockJavaScriptOrVBScriptFromLaunchingDownloadedExecutableContent_ASROnlyPerRuleExclusions)
        $complexDeviceSettings.Add('BlockUntrustedUnsignedProcessesThatRunFromUSB', $policySettings.DeviceSettings.blockUntrustedUnsignedProcessesThatRunFromUSB)
        $complexDeviceSettings.Add('BlockUntrustedUnsignedProcessesThatRunFromUSB_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockUntrustedUnsignedProcessesThatRunFromUSB_ASROnlyPerRuleExclusions)
        $complexDeviceSettings.Add('BlockAdobeReaderFromCreatingChildProcesses', $policySettings.DeviceSettings.blockAdobeReaderFromCreatingChildProcesses)
        $complexDeviceSettings.Add('BlockAdobeReaderFromCreatingChildProcesses_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockAdobeReaderFromCreatingChildProcesses_ASROnlyPerRuleExclusions)
        $complexDeviceSettings.Add('BlockCredentialStealingFromWindowsLocalSecurityAuthoritySubsystem', $policySettings.DeviceSettings.blockCredentialStealingFromWindowsLocalSecurityAuthoritySubsystem)
        $complexDeviceSettings.Add('BlockCredentialStealingFromWindowsLocalSecurityAuthoritySubsystem_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockCredentialStealingFromWindowsLocalSecurityAuthoritySubsystem_ASROnlyPerRuleExclusions)
        $complexDeviceSettings.Add('BlockWebshellCreationForServers', $policySettings.DeviceSettings.blockWebshellCreationForServers)
        $complexDeviceSettings.Add('BlockWebshellCreationForServers_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockWebshellCreationForServers_ASROnlyPerRuleExclusions)
        $complexDeviceSettings.Add('BlockAbuseOfExploitedVulnerableSignedDrivers', $policySettings.DeviceSettings.blockAbuseOfExploitedVulnerableSignedDrivers)
        $complexDeviceSettings.Add('BlockAbuseOfExploitedVulnerableSignedDrivers_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockAbuseOfExploitedVulnerableSignedDrivers_ASROnlyPerRuleExclusions)
        $complexDeviceSettings.Add('BlockPersistenceThroughWMIEventSubscription', $policySettings.DeviceSettings.blockPersistenceThroughWMIEventSubscription)
        $complexDeviceSettings.Add('BlockUseOfCopiedOrImpersonatedSystemTools', $policySettings.DeviceSettings.blockUseOfCopiedOrImpersonatedSystemTools)
        $complexDeviceSettings.Add('BlockUseOfCopiedOrImpersonatedSystemTools_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockUseOfCopiedOrImpersonatedSystemTools_ASROnlyPerRuleExclusions)
        $complexDeviceSettings.Add('BlockOfficeApplicationsFromInjectingCodeIntoOtherProcesses', $policySettings.DeviceSettings.blockOfficeApplicationsFromInjectingCodeIntoOtherProcesses)
        $complexDeviceSettings.Add('BlockOfficeApplicationsFromInjectingCodeIntoOtherProcesses_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockOfficeApplicationsFromInjectingCodeIntoOtherProcesses_ASROnlyPerRuleExclusions)
        $complexDeviceSettings.Add('UseAdvancedProtectionAgainstRansomware', $policySettings.DeviceSettings.useAdvancedProtectionAgainstRansomware)
        $complexDeviceSettings.Add('UseAdvancedProtectionAgainstRansomware_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.useAdvancedProtectionAgainstRansomware_ASROnlyPerRuleExclusions)
        $complexDeviceSettings.Add('BlockProcessCreationsFromPSExecAndWMICommands', $policySettings.DeviceSettings.blockProcessCreationsFromPSExecAndWMICommands)
        $complexDeviceSettings.Add('BlockProcessCreationsFromPSExecAndWMICommands_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockProcessCreationsFromPSExecAndWMICommands_ASROnlyPerRuleExclusions)
        $complexDeviceSettings.Add('BlockOfficeApplicationsFromCreatingExecutableContent', $policySettings.DeviceSettings.blockOfficeApplicationsFromCreatingExecutableContent)
        $complexDeviceSettings.Add('BlockOfficeApplicationsFromCreatingExecutableContent_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockOfficeApplicationsFromCreatingExecutableContent_ASROnlyPerRuleExclusions)
        $complexDeviceSettings.Add('BlockRebootingMachineInSafeMode', $policySettings.DeviceSettings.blockRebootingMachineInSafeMode)
        $complexDeviceSettings.Add('BlockRebootingMachineInSafeMode_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockRebootingMachineInSafeMode_ASROnlyPerRuleExclusions)
        $complexDeviceSettings.Add('BlockExecutableContentFromEmailClientAndWebmail', $policySettings.DeviceSettings.blockExecutableContentFromEmailClientAndWebmail)
        $complexDeviceSettings.Add('BlockExecutableContentFromEmailClientAndWebmail_ASROnlyPerRuleExclusions', $policySettings.DeviceSettings.blockExecutableContentFromEmailClientAndWebmail_ASROnlyPerRuleExclusions)
        $complexDeviceSettings.Add('CloudBlockLevel', $policySettings.DeviceSettings.cloudBlockLevel)
        $complexDeviceSettings.Add('CloudExtendedTimeout', $policySettings.DeviceSettings.cloudExtendedTimeout)
        $complexDeviceSettings.Add('DisableLocalAdminMerge', $policySettings.DeviceSettings.disableLocalAdminMerge)
        $complexDeviceSettings.Add('EnableFileHashComputation', $policySettings.DeviceSettings.enableFileHashComputation)
        $complexDeviceSettings.Add('EnableNetworkProtection', $policySettings.DeviceSettings.enableNetworkProtection)
        $complexDeviceSettings.Add('HideExclusionsFromLocalAdmins', $policySettings.DeviceSettings.hideExclusionsFromLocalAdmins)
        $complexDeviceSettings.Add('PUAProtection', $policySettings.DeviceSettings.pUAProtection)
        $complexDeviceSettings.Add('RealTimeScanDirection', $policySettings.DeviceSettings.realTimeScanDirection)
        $complexDeviceSettings.Add('SubmitSamplesConsent', $policySettings.DeviceSettings.submitSamplesConsent)
        $complexDeviceSettings.Add('ConfigureSystemGuardLaunch', $policySettings.DeviceSettings.configureSystemGuardLaunch)
        $complexDeviceSettings.Add('LsaCfgFlags', $policySettings.DeviceSettings.lsaCfgFlags)
        $complexDeviceSettings.Add('EnableVirtualizationBasedSecurity', $policySettings.DeviceSettings.enableVirtualizationBasedSecurity)
        $complexDeviceSettings.Add('RequirePlatformSecurityFeatures', $policySettings.DeviceSettings.requirePlatformSecurityFeatures)
        $complexDeviceSettings.Add('DevicePasswordEnabled', $policySettings.DeviceSettings.devicePasswordEnabled)
        $complexDeviceSettings.Add('DevicePasswordExpiration', $policySettings.DeviceSettings.devicePasswordExpiration)
        $complexDeviceSettings.Add('MinDevicePasswordLength', $policySettings.DeviceSettings.minDevicePasswordLength)
        $complexDeviceSettings.Add('MaxDevicePasswordFailedAttempts', $policySettings.DeviceSettings.maxDevicePasswordFailedAttempts)
        $complexDeviceSettings.Add('AlphanumericDevicePasswordRequired', $policySettings.DeviceSettings.alphanumericDevicePasswordRequired)
        $complexDeviceSettings.Add('MinDevicePasswordComplexCharacters', $policySettings.DeviceSettings.minDevicePasswordComplexCharacters)
        $complexDeviceSettings.Add('MaxInactivityTimeDeviceLock', $policySettings.DeviceSettings.maxInactivityTimeDeviceLock)
        $complexDeviceSettings.Add('DevicePasswordHistory', $policySettings.DeviceSettings.devicePasswordHistory)
        $complexDeviceSettings.Add('AllowSimpleDevicePassword', $policySettings.DeviceSettings.allowSimpleDevicePassword)
        $complexDeviceSettings.Add('DeviceEnumerationPolicy', $policySettings.DeviceSettings.deviceEnumerationPolicy)
        $complexDeviceSettings.Add('EnableInsecureGuestLogons', $policySettings.DeviceSettings.enableInsecureGuestLogons)
        $complexDeviceSettings.Add('Accounts_LimitLocalAccountUseOfBlankPasswordsToConsoleLogonOnly', $policySettings.DeviceSettings.accounts_LimitLocalAccountUseOfBlankPasswordsToConsoleLogonOnly)
        $complexDeviceSettings.Add('InteractiveLogon_MachineInactivityLimit', $policySettings.DeviceSettings.interactiveLogon_MachineInactivityLimit)
        $complexDeviceSettings.Add('InteractiveLogon_SmartCardRemovalBehavior', $policySettings.DeviceSettings.interactiveLogon_SmartCardRemovalBehavior)
        $complexDeviceSettings.Add('MicrosoftNetworkClient_DigitallySignCommunicationsAlways', $policySettings.DeviceSettings.microsoftNetworkClient_DigitallySignCommunicationsAlways)
        $complexDeviceSettings.Add('MicrosoftNetworkClient_SendUnencryptedPasswordToThirdPartySMBServers', $policySettings.DeviceSettings.microsoftNetworkClient_SendUnencryptedPasswordToThirdPartySMBServers)
        $complexDeviceSettings.Add('MicrosoftNetworkServer_DigitallySignCommunicationsAlways', $policySettings.DeviceSettings.microsoftNetworkServer_DigitallySignCommunicationsAlways)
        $complexDeviceSettings.Add('NetworkAccess_DoNotAllowAnonymousEnumerationOfSAMAccounts', $policySettings.DeviceSettings.networkAccess_DoNotAllowAnonymousEnumerationOfSAMAccounts)
        $complexDeviceSettings.Add('NetworkAccess_DoNotAllowAnonymousEnumerationOfSamAccountsAndShares', $policySettings.DeviceSettings.networkAccess_DoNotAllowAnonymousEnumerationOfSamAccountsAndShares)
        $complexDeviceSettings.Add('NetworkAccess_RestrictAnonymousAccessToNamedPipesAndShares', $policySettings.DeviceSettings.networkAccess_RestrictAnonymousAccessToNamedPipesAndShares)
        $complexDeviceSettings.Add('NetworkAccess_RestrictClientsAllowedToMakeRemoteCallsToSAM', $policySettings.DeviceSettings.networkAccess_RestrictClientsAllowedToMakeRemoteCallsToSAM)
        $complexDeviceSettings.Add('NetworkSecurity_DoNotStoreLANManagerHashValueOnNextPasswordChange', $policySettings.DeviceSettings.networkSecurity_DoNotStoreLANManagerHashValueOnNextPasswordChange)
        $complexDeviceSettings.Add('NetworkSecurity_LANManagerAuthenticationLevel', $policySettings.DeviceSettings.networkSecurity_LANManagerAuthenticationLevel)
        $complexDeviceSettings.Add('NetworkSecurity_MinimumSessionSecurityForNTLMSSPBasedClients', $policySettings.DeviceSettings.networkSecurity_MinimumSessionSecurityForNTLMSSPBasedClients)
        $complexDeviceSettings.Add('NetworkSecurity_MinimumSessionSecurityForNTLMSSPBasedServers', $policySettings.DeviceSettings.networkSecurity_MinimumSessionSecurityForNTLMSSPBasedServers)
        $complexDeviceSettings.Add('UserAccountControl_BehaviorOfTheElevationPromptForAdministrators', $policySettings.DeviceSettings.userAccountControl_BehaviorOfTheElevationPromptForAdministrators)
        $complexDeviceSettings.Add('UserAccountControl_BehaviorOfTheElevationPromptForStandardUsers', $policySettings.DeviceSettings.userAccountControl_BehaviorOfTheElevationPromptForStandardUsers)
        $complexDeviceSettings.Add('UserAccountControl_DetectApplicationInstallationsAndPromptForElevation', $policySettings.DeviceSettings.userAccountControl_DetectApplicationInstallationsAndPromptForElevation)
        $complexDeviceSettings.Add('UserAccountControl_OnlyElevateUIAccessApplicationsThatAreInstalledInSecureLocations', $policySettings.DeviceSettings.userAccountControl_OnlyElevateUIAccessApplicationsThatAreInstalledInSecureLocations)
        $complexDeviceSettings.Add('UserAccountControl_RunAllAdministratorsInAdminApprovalMode', $policySettings.DeviceSettings.userAccountControl_RunAllAdministratorsInAdminApprovalMode)
        $complexDeviceSettings.Add('UserAccountControl_UseAdminApprovalMode', $policySettings.DeviceSettings.userAccountControl_UseAdminApprovalMode)
        $complexDeviceSettings.Add('UserAccountControl_VirtualizeFileAndRegistryWriteFailuresToPerUserLocations', $policySettings.DeviceSettings.userAccountControl_VirtualizeFileAndRegistryWriteFailuresToPerUserLocations)
        $complexDeviceSettings.Add('ConfigureLsaProtectedProcess', $policySettings.DeviceSettings.configureLsaProtectedProcess)
        $complexDeviceSettings.Add('AllowGameDVR', $policySettings.DeviceSettings.allowGameDVR)
        $complexDeviceSettings.Add('MSIAllowUserControlOverInstall', $policySettings.DeviceSettings.mSIAllowUserControlOverInstall)
        $complexDeviceSettings.Add('MSIAlwaysInstallWithElevatedPrivileges', $policySettings.DeviceSettings.mSIAlwaysInstallWithElevatedPrivileges)
        $complexDeviceSettings.Add('SmartScreenEnabled', $policySettings.DeviceSettings.smartScreenEnabled)
        $complexDeviceSettings.Add('MicrosoftEdge_SmartScreen_PreventSmartScreenPromptOverride', $policySettings.DeviceSettings.microsoftEdge_SmartScreen_PreventSmartScreenPromptOverride)
        $complexDeviceSettings.Add('LetAppsActivateWithVoiceAboveLock', $policySettings.DeviceSettings.letAppsActivateWithVoiceAboveLock)
        $complexDeviceSettings.Add('AllowIndexingEncryptedStoresOrItems', $policySettings.DeviceSettings.allowIndexingEncryptedStoresOrItems)
        $complexDeviceSettings.Add('EnableSmartScreenInShell', $policySettings.DeviceSettings.enableSmartScreenInShell)
        $complexDeviceSettings.Add('NotifyMalicious', $policySettings.DeviceSettings.notifyMalicious)
        $complexDeviceSettings.Add('NotifyPasswordReuse', $policySettings.DeviceSettings.notifyPasswordReuse)
        $complexDeviceSettings.Add('NotifyUnsafeApp', $policySettings.DeviceSettings.notifyUnsafeApp)
        $complexDeviceSettings.Add('ServiceEnabled', $policySettings.DeviceSettings.serviceEnabled)
        $complexDeviceSettings.Add('PreventOverrideForFilesInShell', $policySettings.DeviceSettings.preventOverrideForFilesInShell)
        $complexDeviceSettings.Add('ConfigureXboxAccessoryManagementServiceStartupMode', $policySettings.DeviceSettings.configureXboxAccessoryManagementServiceStartupMode)
        $complexDeviceSettings.Add('ConfigureXboxLiveAuthManagerServiceStartupMode', $policySettings.DeviceSettings.configureXboxLiveAuthManagerServiceStartupMode)
        $complexDeviceSettings.Add('ConfigureXboxLiveGameSaveServiceStartupMode', $policySettings.DeviceSettings.configureXboxLiveGameSaveServiceStartupMode)
        $complexDeviceSettings.Add('ConfigureXboxLiveNetworkingServiceStartupMode', $policySettings.DeviceSettings.configureXboxLiveNetworkingServiceStartupMode)
        $complexDeviceSettings.Add('EnableXboxGameSaveTask', $policySettings.DeviceSettings.enableXboxGameSaveTask)
        $complexDeviceSettings.Add('AccessFromNetwork', $policySettings.DeviceSettings.accessFromNetwork)
        $complexDeviceSettings.Add('AllowLocalLogOn', $policySettings.DeviceSettings.allowLocalLogOn)
        $complexDeviceSettings.Add('BackupFilesAndDirectories', $policySettings.DeviceSettings.backupFilesAndDirectories)
        $complexDeviceSettings.Add('CreateGlobalObjects', $policySettings.DeviceSettings.createGlobalObjects)
        $complexDeviceSettings.Add('CreatePageFile', $policySettings.DeviceSettings.createPageFile)
        $complexDeviceSettings.Add('DebugPrograms', $policySettings.DeviceSettings.debugPrograms)
        $complexDeviceSettings.Add('DenyAccessFromNetwork', $policySettings.DeviceSettings.denyAccessFromNetwork)
        $complexDeviceSettings.Add('DenyRemoteDesktopServicesLogOn', $policySettings.DeviceSettings.denyRemoteDesktopServicesLogOn)
        $complexDeviceSettings.Add('ImpersonateClient', $policySettings.DeviceSettings.impersonateClient)
        $complexDeviceSettings.Add('LoadUnloadDeviceDrivers', $policySettings.DeviceSettings.loadUnloadDeviceDrivers)
        $complexDeviceSettings.Add('ManageAuditingAndSecurityLog', $policySettings.DeviceSettings.manageAuditingAndSecurityLog)
        $complexDeviceSettings.Add('ManageVolume', $policySettings.DeviceSettings.manageVolume)
        $complexDeviceSettings.Add('ModifyFirmwareEnvironment', $policySettings.DeviceSettings.modifyFirmwareEnvironment)
        $complexDeviceSettings.Add('ProfileSingleProcess', $policySettings.DeviceSettings.profileSingleProcess)
        $complexDeviceSettings.Add('RemoteShutdown', $policySettings.DeviceSettings.remoteShutdown)
        $complexDeviceSettings.Add('RestoreFilesAndDirectories', $policySettings.DeviceSettings.restoreFilesAndDirectories)
        $complexDeviceSettings.Add('TakeOwnership', $policySettings.DeviceSettings.takeOwnership)
        $complexDeviceSettings.Add('HypervisorEnforcedCodeIntegrity', $policySettings.DeviceSettings.hypervisorEnforcedCodeIntegrity)
        $complexDeviceSettings.Add('AllowAutoConnectToWiFiSenseHotspots', $policySettings.DeviceSettings.allowAutoConnectToWiFiSenseHotspots)
        $complexDeviceSettings.Add('AllowInternetSharing', $policySettings.DeviceSettings.allowInternetSharing)
        $complexDeviceSettings.Add('FacialFeaturesUseEnhancedAntiSpoofing', $policySettings.DeviceSettings.facialFeaturesUseEnhancedAntiSpoofing)
        $complexDeviceSettings.Add('AllowWindowsInkWorkspace', $policySettings.DeviceSettings.allowWindowsInkWorkspace)
        $complexDeviceSettings.Add('BackupDirectory', $policySettings.DeviceSettings.backupDirectory)
        $complexDeviceSettings.Add('ADEncryptedPasswordHistorySize', $policySettings.DeviceSettings.aDEncryptedPasswordHistorySize)
        $complexDeviceSettings.Add('Passwordagedays', $policySettings.DeviceSettings.passwordagedays)
        $complexDeviceSettings.Add('ADPasswordEncryptionEnabled', $policySettings.DeviceSettings.aDPasswordEncryptionEnabled)
        $complexDeviceSettings.Add('Passwordagedays_aad', $policySettings.DeviceSettings.passwordagedays_aad)
        $complexDeviceSettings.Add('ADPasswordEncryptionPrincipal', $policySettings.DeviceSettings.aDPasswordEncryptionPrincipal)
        $complexDeviceSettings.Add('PasswordExpirationProtectionEnabled', $policySettings.DeviceSettings.passwordExpirationProtectionEnabled)
        $complexDeviceSettings.Add('EnableConvertWarnToBlock', $policySettings.DeviceSettings.enableConvertWarnToBlock)
        $complexDeviceSettings.Add('HideExclusionsFromLocalUsers', $policySettings.DeviceSettings.hideExclusionsFromLocalUsers)
        $complexDeviceSettings.Add('OobeEnableRtpAndSigUpdate', $policySettings.DeviceSettings.oobeEnableRtpAndSigUpdate)
        $complexDeviceSettings.Add('PassiveRemediation', $policySettings.DeviceSettings.passiveRemediation)
        $complexDeviceSettings.Add('QuickScanIncludeExclusions', $policySettings.DeviceSettings.quickScanIncludeExclusions)
        $complexDeviceSettings.Add('PKInitHashAlgorithmConfiguration', $policySettings.DeviceSettings.pKInitHashAlgorithmConfiguration)
        $complexDeviceSettings.Add('PKInitHashAlgorithmSHA256', $policySettings.DeviceSettings.pKInitHashAlgorithmSHA256)
        $complexDeviceSettings.Add('PKInitHashAlgorithmSHA512', $policySettings.DeviceSettings.pKInitHashAlgorithmSHA512)
        $complexDeviceSettings.Add('PKInitHashAlgorithmSHA384', $policySettings.DeviceSettings.pKInitHashAlgorithmSHA384)
        $complexDeviceSettings.Add('PKInitHashAlgorithmSHA1', $policySettings.DeviceSettings.pKInitHashAlgorithmSHA1)
        $complexDeviceSettings.Add('EnableSudo', $policySettings.DeviceSettings.enableSudo)
        $complexDeviceSettings.Add('MachineIdentityIsolation', $policySettings.DeviceSettings.machineIdentityIsolation)
        $complexDeviceSettings.Add('AuditClientDoesNotSupportEncryption', $policySettings.DeviceSettings.auditClientDoesNotSupportEncryption)
        $complexDeviceSettings.Add('AuditClientDoesNotSupportSigning', $policySettings.DeviceSettings.auditClientDoesNotSupportSigning)
        $complexDeviceSettings.Add('LanmanServer_AuditInsecureGuestLogon', $policySettings.DeviceSettings.lanmanServer_AuditInsecureGuestLogon)
        $complexDeviceSettings.Add('AuthRateLimiterDelayInMs', $policySettings.DeviceSettings.authRateLimiterDelayInMs)
        $complexDeviceSettings.Add('EnableAuthRateLimiter', $policySettings.DeviceSettings.enableAuthRateLimiter)
        $complexDeviceSettings.Add('LanmanServer_EnableMailslots', $policySettings.DeviceSettings.lanmanServer_EnableMailslots)
        $complexDeviceSettings.Add('LanmanServer_MaxSmb2Dialect', $policySettings.DeviceSettings.lanmanServer_MaxSmb2Dialect)
        $complexDeviceSettings.Add('LanmanServer_MinSmb2Dialect', $policySettings.DeviceSettings.lanmanServer_MinSmb2Dialect)
        $complexDeviceSettings.Add('LanmanWorkstation_AuditInsecureGuestLogon', $policySettings.DeviceSettings.lanmanWorkstation_AuditInsecureGuestLogon)
        $complexDeviceSettings.Add('AuditServerDoesNotSupportEncryption', $policySettings.DeviceSettings.auditServerDoesNotSupportEncryption)
        $complexDeviceSettings.Add('AuditServerDoesNotSupportSigning', $policySettings.DeviceSettings.auditServerDoesNotSupportSigning)
        $complexDeviceSettings.Add('LanmanWorkstation_EnableMailslots', $policySettings.DeviceSettings.lanmanWorkstation_EnableMailslots)
        $complexDeviceSettings.Add('LanmanWorkstation_MaxSmb2Dialect', $policySettings.DeviceSettings.lanmanWorkstation_MaxSmb2Dialect)
        $complexDeviceSettings.Add('LanmanWorkstation_MinSmb2Dialect', $policySettings.DeviceSettings.lanmanWorkstation_MinSmb2Dialect)
        $complexDeviceSettings.Add('RequireEncryption', $policySettings.DeviceSettings.requireEncryption)
        $complexDeviceSettingsCopy = $complexDeviceSettings.Clone()
        foreach ($key in $complexDeviceSettingsCopy.Keys)
        {
            if ($null -eq $complexDeviceSettings[$key])
            {
                $complexDeviceSettings.Remove($key)
            }
        }
        if ($complexDeviceSettings.Values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexDeviceSettings = $null
        }
        $policySettings.Remove('DeviceSettings') | Out-Null

        $complexUserSettings = @{}
        $complexUserSettings.Add('NoLockScreenToastNotification', $policySettings.UserSettings.noLockScreenToastNotification)
        $complexUserSettings.Add('RestrictFormSuggestPW', $policySettings.UserSettings.restrictFormSuggestPW)
        $complexUserSettings.Add('ChkBox_PasswordAsk', $policySettings.UserSettings.chkBox_PasswordAsk)
        $complexUserSettings.Add('AllowWindowsSpotlight', $policySettings.UserSettings.allowWindowsSpotlight)
        $complexUserSettings.Add('AllowWindowsTips', $policySettings.UserSettings.allowWindowsTips)
        $complexUserSettings.Add('AllowTailoredExperiencesWithDiagnosticData', $policySettings.UserSettings.allowTailoredExperiencesWithDiagnosticData)
        $complexUserSettings.Add('AllowWindowsSpotlightOnActionCenter', $policySettings.UserSettings.allowWindowsSpotlightOnActionCenter)
        $complexUserSettings.Add('AllowWindowsConsumerFeatures', $policySettings.UserSettings.allowWindowsConsumerFeatures)
        $complexUserSettings.Add('ConfigureWindowsSpotlightOnLockScreen', $policySettings.UserSettings.configureWindowsSpotlightOnLockScreen)
        $complexUserSettings.Add('AllowThirdPartySuggestionsInWindowsSpotlight', $policySettings.UserSettings.allowThirdPartySuggestionsInWindowsSpotlight)
        $complexUserSettings.Add('AllowWindowsSpotlightWindowsWelcomeExperience', $policySettings.UserSettings.allowWindowsSpotlightWindowsWelcomeExperience)
        $complexUserSettingsCopy = $complexUserSettings.Clone()
        foreach ($key in $complexUserSettingsCopy.Keys)
        {
            if ($null -eq $complexUserSettings[$key])
            {
                $complexUserSettings.Remove($key)
            }
        }
        if ($complexUserSettings.values.Where({$null -ne $_}).Count -eq 0)
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

    $templateReferenceId = '66df8dce-0166-4b82-92f7-1f74e3ca17a3_4'
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
        $BoundParameters.Remove("Assignments") | Out-Null

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
        $policyTemplateID = '66df8dce-0166-4b82-92f7-1f74e3ca17a3_4'
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
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
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
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
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

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params
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
                -Credential $Credential `
                -NoEscape @('DeviceSettings', 'UserSettings', 'Assignments')
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
        Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
