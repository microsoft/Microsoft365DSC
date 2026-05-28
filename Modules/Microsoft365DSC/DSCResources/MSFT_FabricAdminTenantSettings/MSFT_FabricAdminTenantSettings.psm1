Confirm-M365DSCModuleDependency -ModuleName 'MSFT_FabricAdminTenantSettings'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AADSSOForGateway,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AdminApisIncludeDetailedMetadata,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AdminApisIncludeExpressions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AdminCustomDisclaimer,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AISkillArtifactTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowAccessOverPrivateLinks,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowCVAuthenticationTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowCVLocalStorageV2Tenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowCVToExportDataToFileTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowEndorsementMasterDataSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowExternalDataSharingReceiverSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowExternalDataSharingSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowFreeTrial,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowGetOneLakeUDK,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowGuestLookup,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowGuestUserToAccessSharedContent,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowMountDfCreation,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowOneLakeUDK,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowPowerBIASDQOnTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowSendAOAIDataToOtherRegions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowSendNLToDaxDataToOtherRegions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowServicePrincipalsCreateAndUseProfiles,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowServicePrincipalsUseReadAdminAPIs,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AppPush,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ArtifactOrgAppPreview,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ArtifactSearchTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ASCollectQueryTextTelemetryTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ASShareableCloudConnectionBindingSecurityModeTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ASWritethruContinuousExportTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ASWritethruTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AutoInstallPowerBIAppInTeamsTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AutomatedInsightsEntryPoints,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AutomatedInsightsTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AzureMap,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $BingMap,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $BlockAccessFromPublicNetworks,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $BlockAutoDiscoverAndPackageRefresh,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $BlockProtectedLabelSharingToEntireOrg,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $BlockResourceKeyAuthentication,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $CDSAManagement,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $CertifiedCustomVisualsTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $CertifyDatasets,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ConfigureFolderRetentionPeriod,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $CreateAppWorkspaces,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $CustomVisualsTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DatamartTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DatasetExecuteQueries,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DevelopServiceApps,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DiscoverDatasetsConsumption,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DiscoverDatasetsSettingsCertified,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DiscoverDatasetsSettingsPromoted,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DremioSSO,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EimInformationProtectionDataSourceInheritanceSetting,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EimInformationProtectionDownstreamInheritanceSetting,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EimInformationProtectionEdit,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EimInformationProtectionLessElevated,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EimInformationProtectionWorkspaceAdminsOverrideAutomaticLabelsSetting,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ElevatedGuestsTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EmailSecurityGroupsOnOutage,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EmailSubscriptionsToB2BUsers,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EmailSubscriptionsToExternalUsers,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EmailSubscriptionTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $Embedding,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnableAOAI,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnableDatasetInPlaceSharing,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnableExcelYellowIntegration,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnableFabricAirflow,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnableNLToDax,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnableReassignDataDomainSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EsriVisual,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExpFlightingTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExportReport,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExportToCsv,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExportToExcelSetting,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExportToImage,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExportToMHTML,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExportToPowerPoint,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExportToWord,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExportToXML,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExportVisualImageTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExternalDatasetSharingTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExternalSharingV2,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FabricAddPartnerWorkload,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FabricFeedbackTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FabricGAWorkloads,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FabricThirdPartyWorkloads,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $GitHubTenantSettings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $GitIntegrationCrossGeoTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $GitIntegrationSensitivityLabelsTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $GitIntegrationTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $GoogleBigQuerySSO,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $GraphQLTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $HealthcareSolutionsTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $InstallNonvalidatedTemplateApps,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $InstallServiceApps,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $KustoDashboardTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $LiveConnection,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $LogAnalyticsAttachForWorkspaceAdmins,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $M365DataSharing,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $Mirroring,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ODSPRefreshEnforcementTenantAllowAutomaticUpdate,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $OneDriveSharePointAllowSharingTenantSetting,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $OneDriveSharePointViewerIntegrationTenantSettingV2,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $OneLakeFileExplorer,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $OneLakeForThirdParty,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $OnPremAnalyzeInExcel,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $PowerBIGoalsTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $PowerPlatformSolutionsIntegrationTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $Printing,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $PromoteContent,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $PublishContentPack,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $PublishToWeb,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $QnaFeedbackLoop,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $QnaLsdlSharing,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $QueryScaleOutTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RedshiftSSO,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RestrictMyFolderCapacity,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RetailSolutionsTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RScriptVisual,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ServicePrincipalAccess,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ShareLinkToEntireOrg,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ShareToTeamsTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $SnowflakeSSO,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $StorytellingTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $SustainabilitySolutionsTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $TemplatePublish,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $TenantSettingPublishGetHelpInfo,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $TridentPrivatePreview,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UsageMetrics,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UsageMetricsTrackUserLevelInfo,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UseDatasetsAcrossWorkspaces,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $VisualizeListInPowerBI,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WebContentTilesTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WebModelingTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AdminDataExploreViewPermission,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowCapacityMetricsReportUserMask,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowNonEntraADAuthInEventStream,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowServicePrincipalsUseWriteAdminAPIs,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowStoreAOAIDataInOtherRegions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ArtifactDBTItemTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ArtifactGraphPreview,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ArtifactMapTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ArtifactSnowflakeDatabasePreview,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AutomaticallyUsePBIR,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AzureMaps,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AzureMapsCrossRegionDataProcessing,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AzureMapsInFabric,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AzureMapsInFabricCrossRegionDataProcessing,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AzureMapsThirdPartyDataProcessing,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AzureMapsWeatherServices,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ConfigureWorkspaceLevelIPFirewallRules,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $CopilotCapacitySetupPermissionSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DataSecurityForAIInteractions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DeltaToIcebergTableVirtualization,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DigitalOperationsPreview,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DirectLakeOnOneLakeSemanticModelCreation,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EimInformationProtectionDefaultLabelDomainSetting,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnableEsriLibraries,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FabricAddWorkloadToWorkspace,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FabricPromotionTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ImmersiveTenantAdminSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MLModelEndpointsTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $OneLakeDiagnosticLogsEUII,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $OntologyPreview,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $PlatformMonitoringTenantSetting,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $PowerBIMCP,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $PreppedForCopilotContentDiscovery,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RTHAnomalyDetectionTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RTHOperationalAgentsTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ServicePrincipalAccessGlobalAPIs,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ServicePrincipalAccessPermissionAPIs,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ShowActivatorEntryPointsTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ThirdPartyPrivateWorkloads,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WorkspaceBlockInboundAccess,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WorkspaceBlockOutboundAccess,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WorkspaceCmk,

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
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message 'Getting configuration of Fabric Admin Tenant Settings'

    try
    {
        $null = New-M365DSCConnection -Workload 'Fabric' `
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

        if ($null -ne $Script:exportedInstances -and $Script:ExportMode)
        {
            $instance = $Script:exportedInstances
        }
        else
        {
            $uri = (Get-MSCloudLoginConnectionProfile -Workload 'Fabric').HostUrl + '/v1/admin/tenantsettings'
            $instance = Invoke-M365DSCFabricWebRequest -Uri $uri -Method 'GET'
        }
        if ($null -eq $instance)
        {
            return $nullResult
        }

        $results = @{
            IsSingleInstance                                                      = 'Yes'
            AADSSOForGateway                                                      = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AADSSOForGateway' })
            AdminApisIncludeDetailedMetadata                                      = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AdminApisIncludeDetailedMetadata' })
            AdminApisIncludeExpressions                                           = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AdminApisIncludeExpressions' })
            AdminCustomDisclaimer                                                 = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AdminCustomDisclaimer' })
            AISkillArtifactTenantSwitch                                           = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AISkillArtifactTenantSwitch' })
            AllowAccessOverPrivateLinks                                           = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AllowAccessOverPrivateLinks' })
            AllowCVAuthenticationTenant                                           = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AllowCVAuthenticationTenant' })
            AllowCVLocalStorageV2Tenant                                           = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AllowCVLocalStorageV2Tenant' })
            AllowCVToExportDataToFileTenant                                       = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AllowCVToExportDataToFileTenant' })
            AllowEndorsementMasterDataSwitch                                      = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AllowEndorsementMasterDataSwitch' })
            AllowExternalDataSharingReceiverSwitch                                = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AllowExternalDataSharingReceiverSwitch' })
            AllowExternalDataSharingSwitch                                        = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AllowExternalDataSharingSwitch' })
            AllowFreeTrial                                                        = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AllowFreeTrial' })
            AllowGetOneLakeUDK                                                    = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AllowGetOneLakeUDK' })
            AllowGuestLookup                                                      = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AllowGuestLookup' })
            AllowGuestUserToAccessSharedContent                                   = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AllowGuestUserToAccessSharedContent' })
            # DEPRECATED
            #AllowMountDfCreation                                                  = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AllowMountDfCreation' })
            AllowOneLakeUDK                                                       = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AllowOneLakeUDK' })
            AllowPowerBIASDQOnTenant                                              = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AllowPowerBIASDQOnTenant' })
            AllowSendAOAIDataToOtherRegions                                       = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AllowSendAOAIDataToOtherRegions' })
            AllowSendNLToDaxDataToOtherRegions                                    = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AllowSendNLToDaxDataToOtherRegions' })
            AllowServicePrincipalsCreateAndUseProfiles                            = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AllowServicePrincipalsCreateAndUseProfiles' })
            AllowServicePrincipalsUseReadAdminAPIs                                = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AllowServicePrincipalsUseReadAdminAPIs' })
            AppPush                                                               = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AppPush' })
            ArtifactOrgAppPreview                                                 = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ArtifactOrgAppPreview' })
            ArtifactSearchTenant                                                  = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ArtifactSearchTenant' })
            ASCollectQueryTextTelemetryTenantSwitch                               = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ASCollectQueryTextTelemetryTenantSwitch' })
            ASShareableCloudConnectionBindingSecurityModeTenant                   = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ASShareableCloudConnectionBindingSecurityModeTenant' })
            ASWritethruContinuousExportTenantSwitch                               = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ASWritethruContinuousExportTenantSwitch' })
            ASWritethruTenantSwitch                                               = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ASWritethruTenantSwitch' })
            AutoInstallPowerBIAppInTeamsTenant                                    = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AutoInstallPowerBIAppInTeamsTenant' })
            AutomatedInsightsEntryPoints                                          = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AutomatedInsightsEntryPoints' })
            AutomatedInsightsTenant                                               = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AutomatedInsightsTenant' })
            # DEPRECATED
            #AzureMap                                                              = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AzureMap' })
            BingMap                                                               = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'BingMap' })
            BlockAccessFromPublicNetworks                                         = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'BlockAccessFromPublicNetworks' })
            BlockAutoDiscoverAndPackageRefresh                                    = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'BlockAutoDiscoverAndPackageRefresh' })
            BlockProtectedLabelSharingToEntireOrg                                 = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'BlockProtectedLabelSharingToEntireOrg' })
            BlockResourceKeyAuthentication                                        = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'BlockResourceKeyAuthentication' })
            CDSAManagement                                                        = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'CDSAManagement' })
            CertifiedCustomVisualsTenant                                          = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'CertifiedCustomVisualsTenant' })
            CertifyDatasets                                                       = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'CertifyDatasets' })
            ConfigureFolderRetentionPeriod                                        = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ConfigureFolderRetentionPeriod' })
            CreateAppWorkspaces                                                   = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'CreateAppWorkspaces' })
            CustomVisualsTenant                                                   = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'CustomVisualsTenant' })
            DatamartTenant                                                        = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'DatamartTenant' })
            DatasetExecuteQueries                                                 = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'DatasetExecuteQueries' })
            DevelopServiceApps                                                    = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'DevelopServiceApps' })
            DiscoverDatasetsConsumption                                           = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'DiscoverDatasetsConsumption' })
            DiscoverDatasetsSettingsCertified                                     = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'DiscoverDatasetsSettingsCertified' })
            DiscoverDatasetsSettingsPromoted                                      = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'DiscoverDatasetsSettingsPromoted' })
            DremioSSO                                                             = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'DremioSSO' })
            EimInformationProtectionDataSourceInheritanceSetting                  = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'EimInformationProtectionDataSourceInheritanceSetting' })
            EimInformationProtectionDownstreamInheritanceSetting                  = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'EimInformationProtectionDownstreamInheritanceSetting' })
            EimInformationProtectionEdit                                          = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'EimInformationProtectionEdit' })
            # DEPRECATED
            #EimInformationProtectionLessElevated                                  = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'EimInformationProtectionLessElevated' })
            EimInformationProtectionWorkspaceAdminsOverrideAutomaticLabelsSetting = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'EimInformationProtectionWorkspaceAdminsOverrideAutomaticLabelsSetting' })
            ElevatedGuestsTenant                                                  = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ElevatedGuestsTenant' })
            EmailSecurityGroupsOnOutage                                           = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'EmailSecurityGroupsOnOutage' })
            EmailSubscriptionsToB2BUsers                                          = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'EmailSubscriptionsToB2BUsers' })
            EmailSubscriptionsToExternalUsers                                     = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'EmailSubscriptionsToExternalUsers' })
            EmailSubscriptionTenant                                               = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'EmailSubscriptionTenant' })
            Embedding                                                             = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'Embedding' })
            EnableAOAI                                                            = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'EnableAOAI' })
            EnableDatasetInPlaceSharing                                           = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'EnableDatasetInPlaceSharing' })
            EnableExcelYellowIntegration                                          = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'EnableExcelYellowIntegration' })
            # DEPRECATED
            #EnableFabricAirflow                                                   = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'EnableFabricAirflow' })
            EnableNLToDax                                                         = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'EnableNLToDax' })
            EnableReassignDataDomainSwitch                                        = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'EnableReassignDataDomainSwitch' })
            EsriVisual                                                            = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'EsriVisual' })
            ExpFlightingTenant                                                    = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ExpFlightingTenant' })
            ExportReport                                                          = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ExportReport' })
            ExportToCsv                                                           = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ExportToCsv' })
            ExportToExcelSetting                                                  = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ExportToExcelSetting' })
            ExportToImage                                                         = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ExportToImage' })
            ExportToMHTML                                                         = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ExportToMHTML' })
            ExportToPowerPoint                                                    = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ExportToPowerPoint' })
            ExportToWord                                                          = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ExportToWord' })
            ExportToXML                                                           = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ExportToXML' })
            ExportVisualImageTenant                                               = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ExportVisualImageTenant' })
            ExternalDatasetSharingTenant                                          = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ExternalDatasetSharingTenant' })
            ExternalSharingV2                                                     = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ExternalSharingV2' })
            FabricAddPartnerWorkload                                              = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'FabricAddPartnerWorkload' })
            FabricFeedbackTenantSwitch                                            = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'FabricFeedbackTenantSwitch' })
            FabricGAWorkloads                                                     = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'FabricGAWorkloads' })
            FabricThirdPartyWorkloads                                             = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'FabricThirdPartyWorkloads' })
            GitHubTenantSettings                                                  = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'GitHubTenantSettings' })
            GitIntegrationCrossGeoTenantSwitch                                    = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'GitIntegrationCrossGeoTenantSwitch' })
            GitIntegrationSensitivityLabelsTenantSwitch                           = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'GitIntegrationSensitivityLabelsTenantSwitch' })
            GitIntegrationTenantSwitch                                            = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'GitIntegrationTenantSwitch' })
            GoogleBigQuerySSO                                                     = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'GoogleBigQuerySSO' })
            # DEPRECATED
            #GraphQLTenant                                                         = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'GraphQLTenant' })
            HealthcareSolutionsTenantSwitch                                       = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'HealthcareSolutionsTenantSwitch' })
            InstallNonvalidatedTemplateApps                                       = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'InstallNonvalidatedTemplateApps' })
            InstallServiceApps                                                    = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'InstallServiceApps' })
            KustoDashboardTenantSwitch                                            = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'KustoDashboardTenantSwitch' })
            LiveConnection                                                        = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'LiveConnection' })
            LogAnalyticsAttachForWorkspaceAdmins                                  = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'LogAnalyticsAttachForWorkspaceAdmins' })
            M365DataSharing                                                       = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'M365DataSharing' })
            Mirroring                                                             = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'Mirroring' })
            ODSPRefreshEnforcementTenantAllowAutomaticUpdate                      = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ODSPRefreshEnforcementTenantAllowAutomaticUpdate' })
            OneDriveSharePointAllowSharingTenantSetting                           = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'OneDriveSharePointAllowSharingTenantSetting' })
            OneDriveSharePointViewerIntegrationTenantSettingV2                    = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'OneDriveSharePointViewerIntegrationTenantSettingV2' })
            OneLakeFileExplorer                                                   = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'OneLakeFileExplorer' })
            OneLakeForThirdParty                                                  = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'OneLakeForThirdParty' })
            OnPremAnalyzeInExcel                                                  = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'OnPremAnalyzeInExcel' })
            PowerBIGoalsTenant                                                    = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'PowerBIGoalsTenant' })
            # DEPRECATED
            #PowerPlatformSolutionsIntegrationTenant                               = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'PowerPlatformSolutionsIntegrationTenant' })
            Printing                                                              = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'Printing' })
            PromoteContent                                                        = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'PromoteContent' })
            PublishContentPack                                                    = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'PublishContentPack' })
            PublishToWeb                                                          = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'PublishToWeb' })
            QnaFeedbackLoop                                                       = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'QnaFeedbackLoop' })
            QnaLsdlSharing                                                        = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'QnaLsdlSharing' })
            QueryScaleOutTenant                                                   = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'QueryScaleOutTenant' })
            RedshiftSSO                                                           = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'RedshiftSSO' })
            RestrictMyFolderCapacity                                              = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'RestrictMyFolderCapacity' })
            # DEPRECATED
            #RetailSolutionsTenantSwitch                                           = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'RetailSolutionsTenantSwitch' })
            RScriptVisual                                                         = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'RScriptVisual' })
            # DEPRECATED
            #ServicePrincipalAccess                                                = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ServicePrincipalAccess' })
            ShareLinkToEntireOrg                                                  = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ShareLinkToEntireOrg' })
            ShareToTeamsTenant                                                    = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ShareToTeamsTenant' })
            SnowflakeSSO                                                          = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'SnowflakeSSO' })
            StorytellingTenant                                                    = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'StorytellingTenant' })
            SustainabilitySolutionsTenantSwitch                                   = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'SustainabilitySolutionsTenantSwitch' })
            TemplatePublish                                                       = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'TemplatePublish' })
            TenantSettingPublishGetHelpInfo                                       = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'TenantSettingPublishGetHelpInfo' })
            TridentPrivatePreview                                                 = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'TridentPrivatePreview' })
            UsageMetrics                                                          = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'UsageMetrics' })
            UsageMetricsTrackUserLevelInfo                                        = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'UsageMetricsTrackUserLevelInfo' })
            UseDatasetsAcrossWorkspaces                                           = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'UseDatasetsAcrossWorkspaces' })
            VisualizeListInPowerBI                                                = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'VisualizeListInPowerBI' })
            WebContentTilesTenant                                                 = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'WebContentTilesTenant' })
            WebModelingTenantSwitch                                               = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'WebModelingTenantSwitch' })
            AdminDataExploreViewPermission                                        = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AdminDataExploreViewPermission' })
            AllowCapacityMetricsReportUserMask                                    = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AllowCapacityMetricsReportUserMask' })
            AllowNonEntraADAuthInEventStream                                      = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AllowNonEntraADAuthInEventStream' })
            AllowServicePrincipalsUseWriteAdminAPIs                               = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AllowServicePrincipalsUseWriteAdminAPIs' })
            AllowStoreAOAIDataInOtherRegions                                      = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AllowStoreAOAIDataInOtherRegions' })
            ArtifactDBTItemTenantSwitch                                           = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ArtifactDBTItemTenantSwitch' })
            ArtifactGraphPreview                                                  = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ArtifactGraphPreview' })
            ArtifactMapTenantSwitch                                               = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ArtifactMapTenantSwitch' })
            ArtifactSnowflakeDatabasePreview                                      = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ArtifactSnowflakeDatabasePreview' })
            AutomaticallyUsePBIR                                                  = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AutomaticallyUsePBIR' })
            AzureMaps                                                             = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AzureMaps' })
            AzureMapsCrossRegionDataProcessing                                    = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AzureMapsCrossRegionDataProcessing' })
            AzureMapsInFabric                                                     = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AzureMapsInFabric' })
            AzureMapsInFabricCrossRegionDataProcessing                            = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AzureMapsInFabricCrossRegionDataProcessing' })
            AzureMapsThirdPartyDataProcessing                                     = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AzureMapsThirdPartyDataProcessing' })
            AzureMapsWeatherServices                                              = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'AzureMapsWeatherServices' })
            ConfigureWorkspaceLevelIPFirewallRules                                = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ConfigureWorkspaceLevelIPFirewallRules' })
            CopilotCapacitySetupPermissionSwitch                                  = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'CopilotCapacitySetupPermissionSwitch' })
            DataSecurityForAIInteractions                                         = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'DataSecurityForAIInteractions' })
            DeltaToIcebergTableVirtualization                                     = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'DeltaToIcebergTableVirtualization' })
            DigitalOperationsPreview                                              = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'DigitalOperationsPreview' })
            DirectLakeOnOneLakeSemanticModelCreation                              = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'DirectLakeOnOneLakeSemanticModelCreation' })
            EimInformationProtectionDefaultLabelDomainSetting                     = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'EimInformationProtectionDefaultLabelDomainSetting' })
            EnableEsriLibraries                                                   = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'EnableEsriLibraries' })
            FabricAddWorkloadToWorkspace                                          = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'FabricAddWorkloadToWorkspace' })
            FabricPromotionTenantSwitch                                           = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'FabricPromotionTenantSwitch' })
            ImmersiveTenantAdminSwitch                                            = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ImmersiveTenantAdminSwitch' })
            MLModelEndpointsTenantSwitch                                          = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'MLModelEndpointsTenantSwitch' })
            OneLakeDiagnosticLogsEUII                                             = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'OneLakeDiagnosticLogsEUII' })
            OntologyPreview                                                       = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'OntologyPreview' })
            PlatformMonitoringTenantSetting                                       = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'PlatformMonitoringTenantSetting' })
            PowerBIMCP                                                            = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'PowerBIMCP' })
            PreppedForCopilotContentDiscovery                                     = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'PreppedForCopilotContentDiscovery' })
            RTHAnomalyDetectionTenantSwitch                                       = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'RTHAnomalyDetectionTenantSwitch' })
            RTHOperationalAgentsTenantSwitch                                      = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'RTHOperationalAgentsTenantSwitch' })
            ServicePrincipalAccessGlobalAPIs                                      = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ServicePrincipalAccessGlobalAPIs' })
            ServicePrincipalAccessPermissionAPIs                                  = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ServicePrincipalAccessPermissionAPIs' })
            ShowActivatorEntryPointsTenantSwitch                                  = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ShowActivatorEntryPointsTenantSwitch' })
            ThirdPartyPrivateWorkloads                                            = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'ThirdPartyPrivateWorkloads' })
            WorkspaceBlockInboundAccess                                           = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'WorkspaceBlockInboundAccess' })
            WorkspaceBlockOutboundAccess                                          = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'WorkspaceBlockOutboundAccess' })
            WorkspaceCmk                                                          = Get-M365DSCFabricTenantSettingObject -Setting ($instance.tenantSettings | Where-Object -FilterScript { $_.settingName -eq 'WorkspaceCmk' })
            ApplicationId                                                         = $ApplicationId
            TenantId                                                              = $TenantId
            ApplicationSecret                                                     = $ApplicationSecret
            CertificateThumbprint                                                 = $CertificateThumbprint
            CertificatePath                                                       = $CertificatePath
            CertificatePassword                                                   = $CertificatePassword
            AccessTokens                                                          = $AccessTokens
        }
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
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AADSSOForGateway,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AdminApisIncludeDetailedMetadata,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AdminApisIncludeExpressions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AdminCustomDisclaimer,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AISkillArtifactTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowAccessOverPrivateLinks,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowCVAuthenticationTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowCVLocalStorageV2Tenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowCVToExportDataToFileTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowEndorsementMasterDataSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowExternalDataSharingReceiverSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowExternalDataSharingSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowFreeTrial,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowGetOneLakeUDK,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowGuestLookup,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowGuestUserToAccessSharedContent,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowMountDfCreation,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowOneLakeUDK,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowPowerBIASDQOnTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowSendAOAIDataToOtherRegions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowSendNLToDaxDataToOtherRegions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowServicePrincipalsCreateAndUseProfiles,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowServicePrincipalsUseReadAdminAPIs,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AppPush,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ArtifactOrgAppPreview,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ArtifactSearchTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ASCollectQueryTextTelemetryTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ASShareableCloudConnectionBindingSecurityModeTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ASWritethruContinuousExportTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ASWritethruTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AutoInstallPowerBIAppInTeamsTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AutomatedInsightsEntryPoints,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AutomatedInsightsTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AzureMap,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $BingMap,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $BlockAccessFromPublicNetworks,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $BlockAutoDiscoverAndPackageRefresh,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $BlockProtectedLabelSharingToEntireOrg,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $BlockResourceKeyAuthentication,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $CDSAManagement,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $CertifiedCustomVisualsTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $CertifyDatasets,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ConfigureFolderRetentionPeriod,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $CreateAppWorkspaces,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $CustomVisualsTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DatamartTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DatasetExecuteQueries,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DevelopServiceApps,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DiscoverDatasetsConsumption,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DiscoverDatasetsSettingsCertified,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DiscoverDatasetsSettingsPromoted,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DremioSSO,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EimInformationProtectionDataSourceInheritanceSetting,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EimInformationProtectionDownstreamInheritanceSetting,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EimInformationProtectionEdit,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EimInformationProtectionLessElevated,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EimInformationProtectionWorkspaceAdminsOverrideAutomaticLabelsSetting,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ElevatedGuestsTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EmailSecurityGroupsOnOutage,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EmailSubscriptionsToB2BUsers,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EmailSubscriptionsToExternalUsers,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EmailSubscriptionTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $Embedding,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnableAOAI,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnableDatasetInPlaceSharing,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnableExcelYellowIntegration,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnableFabricAirflow,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnableNLToDax,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnableReassignDataDomainSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EsriVisual,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExpFlightingTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExportReport,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExportToCsv,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExportToExcelSetting,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExportToImage,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExportToMHTML,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExportToPowerPoint,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExportToWord,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExportToXML,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExportVisualImageTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExternalDatasetSharingTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExternalSharingV2,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FabricAddPartnerWorkload,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FabricFeedbackTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FabricGAWorkloads,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FabricThirdPartyWorkloads,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $GitHubTenantSettings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $GitIntegrationCrossGeoTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $GitIntegrationSensitivityLabelsTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $GitIntegrationTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $GoogleBigQuerySSO,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $GraphQLTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $HealthcareSolutionsTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $InstallNonvalidatedTemplateApps,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $InstallServiceApps,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $KustoDashboardTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $LiveConnection,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $LogAnalyticsAttachForWorkspaceAdmins,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $M365DataSharing,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $Mirroring,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ODSPRefreshEnforcementTenantAllowAutomaticUpdate,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $OneDriveSharePointAllowSharingTenantSetting,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $OneDriveSharePointViewerIntegrationTenantSettingV2,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $OneLakeFileExplorer,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $OneLakeForThirdParty,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $OnPremAnalyzeInExcel,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $PowerBIGoalsTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $PowerPlatformSolutionsIntegrationTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $Printing,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $PromoteContent,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $PublishContentPack,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $PublishToWeb,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $QnaFeedbackLoop,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $QnaLsdlSharing,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $QueryScaleOutTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RedshiftSSO,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RestrictMyFolderCapacity,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RetailSolutionsTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RScriptVisual,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ServicePrincipalAccess,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ShareLinkToEntireOrg,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ShareToTeamsTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $SnowflakeSSO,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $StorytellingTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $SustainabilitySolutionsTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $TemplatePublish,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $TenantSettingPublishGetHelpInfo,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $TridentPrivatePreview,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UsageMetrics,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UsageMetricsTrackUserLevelInfo,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UseDatasetsAcrossWorkspaces,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $VisualizeListInPowerBI,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WebContentTilesTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WebModelingTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AdminDataExploreViewPermission,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowCapacityMetricsReportUserMask,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowNonEntraADAuthInEventStream,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowServicePrincipalsUseWriteAdminAPIs,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowStoreAOAIDataInOtherRegions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ArtifactDBTItemTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ArtifactGraphPreview,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ArtifactMapTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ArtifactSnowflakeDatabasePreview,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AutomaticallyUsePBIR,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AzureMaps,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AzureMapsCrossRegionDataProcessing,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AzureMapsInFabric,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AzureMapsInFabricCrossRegionDataProcessing,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AzureMapsThirdPartyDataProcessing,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AzureMapsWeatherServices,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ConfigureWorkspaceLevelIPFirewallRules,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $CopilotCapacitySetupPermissionSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DataSecurityForAIInteractions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DeltaToIcebergTableVirtualization,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DigitalOperationsPreview,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DirectLakeOnOneLakeSemanticModelCreation,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EimInformationProtectionDefaultLabelDomainSetting,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnableEsriLibraries,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FabricAddWorkloadToWorkspace,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FabricPromotionTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ImmersiveTenantAdminSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MLModelEndpointsTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $OneLakeDiagnosticLogsEUII,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $OntologyPreview,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $PlatformMonitoringTenantSetting,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $PowerBIMCP,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $PreppedForCopilotContentDiscovery,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RTHAnomalyDetectionTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RTHOperationalAgentsTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ServicePrincipalAccessGlobalAPIs,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ServicePrincipalAccessPermissionAPIs,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ShowActivatorEntryPointsTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ThirdPartyPrivateWorkloads,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WorkspaceBlockInboundAccess,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WorkspaceBlockOutboundAccess,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WorkspaceCmk,

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
        [System.String[]]
        $AccessTokens
    )

    Write-Warning -Message 'This resource is read-only and does not support changing the settings. It is used for monitoring purposes only.'
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AADSSOForGateway,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AdminApisIncludeDetailedMetadata,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AdminApisIncludeExpressions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AdminCustomDisclaimer,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AISkillArtifactTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowAccessOverPrivateLinks,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowCVAuthenticationTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowCVLocalStorageV2Tenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowCVToExportDataToFileTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowEndorsementMasterDataSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowExternalDataSharingReceiverSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowExternalDataSharingSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowFreeTrial,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowGetOneLakeUDK,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowGuestLookup,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowGuestUserToAccessSharedContent,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowMountDfCreation,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowOneLakeUDK,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowPowerBIASDQOnTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowSendAOAIDataToOtherRegions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowSendNLToDaxDataToOtherRegions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowServicePrincipalsCreateAndUseProfiles,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowServicePrincipalsUseReadAdminAPIs,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AppPush,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ArtifactOrgAppPreview,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ArtifactSearchTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ASCollectQueryTextTelemetryTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ASShareableCloudConnectionBindingSecurityModeTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ASWritethruContinuousExportTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ASWritethruTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AutoInstallPowerBIAppInTeamsTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AutomatedInsightsEntryPoints,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AutomatedInsightsTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AzureMap,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $BingMap,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $BlockAccessFromPublicNetworks,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $BlockAutoDiscoverAndPackageRefresh,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $BlockProtectedLabelSharingToEntireOrg,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $BlockResourceKeyAuthentication,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $CDSAManagement,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $CertifiedCustomVisualsTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $CertifyDatasets,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ConfigureFolderRetentionPeriod,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $CreateAppWorkspaces,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $CustomVisualsTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DatamartTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DatasetExecuteQueries,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DevelopServiceApps,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DiscoverDatasetsConsumption,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DiscoverDatasetsSettingsCertified,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DiscoverDatasetsSettingsPromoted,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DremioSSO,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EimInformationProtectionDataSourceInheritanceSetting,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EimInformationProtectionDownstreamInheritanceSetting,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EimInformationProtectionEdit,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EimInformationProtectionLessElevated,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EimInformationProtectionWorkspaceAdminsOverrideAutomaticLabelsSetting,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ElevatedGuestsTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EmailSecurityGroupsOnOutage,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EmailSubscriptionsToB2BUsers,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EmailSubscriptionsToExternalUsers,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EmailSubscriptionTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $Embedding,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnableAOAI,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnableDatasetInPlaceSharing,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnableExcelYellowIntegration,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnableFabricAirflow,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnableNLToDax,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnableReassignDataDomainSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EsriVisual,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExpFlightingTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExportReport,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExportToCsv,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExportToExcelSetting,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExportToImage,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExportToMHTML,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExportToPowerPoint,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExportToWord,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExportToXML,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExportVisualImageTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExternalDatasetSharingTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ExternalSharingV2,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FabricAddPartnerWorkload,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FabricFeedbackTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FabricGAWorkloads,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FabricThirdPartyWorkloads,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $GitHubTenantSettings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $GitIntegrationCrossGeoTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $GitIntegrationSensitivityLabelsTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $GitIntegrationTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $GoogleBigQuerySSO,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $GraphQLTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $HealthcareSolutionsTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $InstallNonvalidatedTemplateApps,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $InstallServiceApps,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $KustoDashboardTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $LiveConnection,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $LogAnalyticsAttachForWorkspaceAdmins,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $M365DataSharing,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $Mirroring,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ODSPRefreshEnforcementTenantAllowAutomaticUpdate,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $OneDriveSharePointAllowSharingTenantSetting,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $OneDriveSharePointViewerIntegrationTenantSettingV2,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $OneLakeFileExplorer,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $OneLakeForThirdParty,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $OnPremAnalyzeInExcel,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $PowerBIGoalsTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $PowerPlatformSolutionsIntegrationTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $Printing,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $PromoteContent,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $PublishContentPack,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $PublishToWeb,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $QnaFeedbackLoop,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $QnaLsdlSharing,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $QueryScaleOutTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RedshiftSSO,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RestrictMyFolderCapacity,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RetailSolutionsTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RScriptVisual,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ServicePrincipalAccess,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ShareLinkToEntireOrg,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ShareToTeamsTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $SnowflakeSSO,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $StorytellingTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $SustainabilitySolutionsTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $TemplatePublish,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $TenantSettingPublishGetHelpInfo,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $TridentPrivatePreview,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UsageMetrics,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UsageMetricsTrackUserLevelInfo,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $UseDatasetsAcrossWorkspaces,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $VisualizeListInPowerBI,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WebContentTilesTenant,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WebModelingTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AdminDataExploreViewPermission,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowCapacityMetricsReportUserMask,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowNonEntraADAuthInEventStream,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowServicePrincipalsUseWriteAdminAPIs,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AllowStoreAOAIDataInOtherRegions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ArtifactDBTItemTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ArtifactGraphPreview,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ArtifactMapTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ArtifactSnowflakeDatabasePreview,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AutomaticallyUsePBIR,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AzureMaps,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AzureMapsCrossRegionDataProcessing,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AzureMapsInFabric,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AzureMapsInFabricCrossRegionDataProcessing,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AzureMapsThirdPartyDataProcessing,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AzureMapsWeatherServices,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ConfigureWorkspaceLevelIPFirewallRules,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $CopilotCapacitySetupPermissionSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DataSecurityForAIInteractions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DeltaToIcebergTableVirtualization,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DigitalOperationsPreview,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $DirectLakeOnOneLakeSemanticModelCreation,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EimInformationProtectionDefaultLabelDomainSetting,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnableEsriLibraries,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FabricAddWorkloadToWorkspace,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FabricPromotionTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ImmersiveTenantAdminSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $MLModelEndpointsTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $OneLakeDiagnosticLogsEUII,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $OntologyPreview,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $PlatformMonitoringTenantSetting,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $PowerBIMCP,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $PreppedForCopilotContentDiscovery,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RTHAnomalyDetectionTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RTHOperationalAgentsTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ServicePrincipalAccessGlobalAPIs,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ServicePrincipalAccessPermissionAPIs,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ShowActivatorEntryPointsTenantSwitch,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ThirdPartyPrivateWorkloads,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WorkspaceBlockInboundAccess,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WorkspaceBlockOutboundAccess,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $WorkspaceCmk,

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
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'Fabric' `
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
        $Script:ExportMode = $true
        $uri = (Get-MSCloudLoginConnectionProfile -Workload 'Fabric').HostUrl + '/v1/admin/tenantsettings'
        [array] $Script:exportedInstances = Invoke-M365DSCFabricWebRequest -Uri $uri -Method 'GET'

        if ($null -ne $Global:M365DSCExportResourceInstancesCount)
        {
            $Global:M365DSCExportResourceInstancesCount++
        }
        $dscContent = [System.Text.StringBuilder]::new()
        $params = @{
            IsSingleInstance      = 'Yes'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            CertificatePath       = $CertificatePath
            CertificatePassword   = $CertificatePassword
            AccessTokens          = $AccessTokens
        }

        $Results = Get-TargetResource @Params

        $newResults = ([Hashtable]$Results).Clone()
        $noEscape = @()
        foreach ($key in @($Results.Keys))
        {
            if ($null -ne $Results.$key -and $key -notin $params.Keys)
            {
                $complexTypeMapping = @(
                    @{
                        Name            = $key
                        CIMInstanceName = 'FabricTenantSetting'
                    },
                    @{
                        Name            = 'properties'
                        CIMInstanceName = 'FabricTenantSettingProperty'
                        IsArray         = $true
                    }
                )

                if ($null -ne $Results.$key.enabledSecurityGroups)
                {
                    $Results.$key.enabledSecurityGroups = $Results.$key.enabledSecurityGroups -join ','
                }

                if ($null -ne $Results.$key.excludedSecurityGroups)
                {
                    $Results.$key.excludedSecurityGroups = $Results.$key.excludedSecurityGroups -join ','
                }

                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.$key `
                    -CIMInstanceName 'FabricTenantSetting' `
                    -ComplexTypeMapping $complexTypeMapping
                if (-not [String]::IsNullOrEmpty($complexTypeStringResult))
                {
                    $newResults.$key = $complexTypeStringResult
                    $noEscape += $key
                }
            }
        }

        $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
            -ConnectionMode $ConnectionMode `
            -ModulePath $PSScriptRoot `
            -Results $newResults `
            -Credential $Credential `
            -NoEscape $noEscape

        [void]$dscContent.Append($currentDSCBlock)
        Save-M365DSCPartialExport -Content $currentDSCBlock `
            -FileName $Global:PartialExportFileName
        Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        return $dscContent.ToString()
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

function Get-M365DSCFabricTenantSettingObject
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter()]
        $Setting
    )

    if ($null -eq $Setting)
    {
        return $null
    }

    Write-Verbose -Message "Retrieving values for setting {$($Setting.settingName)}"

    $values = @{
        settingName = $Setting.settingName
        enabled     = [Boolean]$Setting.enabled
        title       = ($Setting.title -creplace '\P{IsBasicLatin}').Replace("`"", "```"")
    }
    if (-not [System.String]::IsNullOrEmpty($Setting.canSpecifySecurityGroups))
    {
        $values.Add('canSpecifySecurityGroups', [Boolean]$Setting.canSpecifySecurityGroups)
    }
    if (-not [System.String]::IsNullOrEmpty($Setting.delegateToWorkspace))
    {
        $values.Add('delegateToWorkspace', $Setting.delegateToWorkspace)
    }
    if (-not [System.String]::IsNullOrEmpty($Setting.delegatedFrom))
    {
        $values.Add('delegatedFrom', $Setting.delegatedFrom)
    }
    if (-not [System.String]::IsNullOrEmpty($Setting.tenantSettingGroup))
    {
        $values.Add('tenantSettingGroup', ($Setting.tenantSettingGroup -creplace '\P{IsBasicLatin}'))
    }
    if ($null -ne $Setting.properties -and $Setting.properties.Length -gt 0)
    {
        $propertiesValue = @()
        foreach ($property in $Setting.Properties)
        {
            $curProperty = @{
                name  = $property.name
                value = $property.value
                type  = $property.type
            }
            $propertiesValue += $curProperty
        }

        $values.Add('properties', $propertiesValue)
    }
    if ($null -ne $Setting.excludedSecurityGroups -and $Setting.excludedSecurityGroups.Length -gt 0)
    {
        $values.Add('excludedSecurityGroups', [Array]$Setting.excludedSecurityGroups.name)
    }
    if ($null -ne $Setting.enabledSecurityGroups -and $Setting.enabledSecurityGroups.Length -gt 0)
    {
        $values.Add('enabledSecurityGroups', [Array]$Setting.enabledSecurityGroups.name)
    }
    return $values
}

Export-ModuleMember -Function *-TargetResource
