function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.Boolean]
        $DLPUserRiskSync,

        [Parameter()]
        [System.Boolean]
        $OptInIRMDataExport,

        [Parameter()]
        [System.Boolean]
        $RaiseAuditAlert,

        [Parameter()]
        [System.String]
        $FileVolCutoffLimits,

        [Parameter()]
        [System.String]
        $AlertVolume,

        [Parameter()]
        [System.Boolean]
        $AnomalyDetections,

        [Parameter()]
        [System.Boolean]
        $CopyToPersonalCloud,

        [Parameter()]
        [System.Boolean]
        $CopyToUSB,

        [Parameter()]
        [System.Boolean]
        $CumulativeExfiltrationDetector,

        [Parameter()]
        [System.Boolean]
        $EmailExternal,

        [Parameter()]
        [System.Boolean]
        $EmployeeAccessedEmployeePatientData,

        [Parameter()]
        [System.Boolean]
        $EmployeeAccessedFamilyData,

        [Parameter()]
        [System.Boolean]
        $EmployeeAccessedHighVolumePatientData,

        [Parameter()]
        [System.Boolean]
        $EmployeeAccessedNeighbourData,

        [Parameter()]
        [System.Boolean]
        $EmployeeAccessedRestrictedData,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToChildAbuseSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToCriminalActivitySites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToCultSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToGamblingSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToHackingSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToHateIntoleranceSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToIllegalSoftwareSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToKeyloggerSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToLlmSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToMalwareSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToPhishingSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToPornographySites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToUnallowedDomain,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToViolenceSites,

        [Parameter()]
        [System.Boolean]
        $EpoCopyToClipboardFromSensitiveFile,

        [Parameter()]
        [System.Boolean]
        $EpoCopyToNetworkShare,

        [Parameter()]
        [System.Boolean]
        $EpoFileArchived,

        [Parameter()]
        [System.Boolean]
        $EpoFileCopiedToRemoteDesktopSession,

        [Parameter()]
        [System.Boolean]
        $EpoFileDeleted,

        [Parameter()]
        [System.Boolean]
        $EpoFileDownloadedFromBlacklistedDomain,

        [Parameter()]
        [System.Boolean]
        $EpoFileDownloadedFromEnterpriseDomain,

        [Parameter()]
        [System.Boolean]
        $EpoFileRenamed,

        [Parameter()]
        [System.Boolean]
        $EpoFileStagedToCentralLocation,

        [Parameter()]
        [System.Boolean]
        $EpoHiddenFileCreated,

        [Parameter()]
        [System.Boolean]
        $EpoRemovableMediaMount,

        [Parameter()]
        [System.Boolean]
        $EpoSensitiveFileRead,

        [Parameter()]
        [System.Boolean]
        $Mcas3rdPartyAppDownload,

        [Parameter()]
        [System.Boolean]
        $Mcas3rdPartyAppFileDelete,

        [Parameter()]
        [System.Boolean]
        $Mcas3rdPartyAppFileSharing,

        [Parameter()]
        [System.Boolean]
        $McasActivityFromInfrequentCountry,

        [Parameter()]
        [System.Boolean]
        $McasImpossibleTravel,

        [Parameter()]
        [System.Boolean]
        $McasMultipleFailedLogins,

        [Parameter()]
        [System.Boolean]
        $McasMultipleStorageDeletion,

        [Parameter()]
        [System.Boolean]
        $McasMultipleVMCreation,

        [Parameter()]
        [System.Boolean]
        $McasMultipleVMDeletion,

        [Parameter()]
        [System.Boolean]
        $McasSuspiciousAdminActivities,

        [Parameter()]
        [System.Boolean]
        $McasSuspiciousCloudCreation,

        [Parameter()]
        [System.Boolean]
        $McasSuspiciousCloudTrailLoggingChange,

        [Parameter()]
        [System.Boolean]
        $McasTerminatedEmployeeActivity,

        [Parameter()]
        [System.Boolean]
        $OdbDownload,

        [Parameter()]
        [System.Boolean]
        $OdbSyncDownload,

        [Parameter()]
        [System.Boolean]
        $PeerCumulativeExfiltrationDetector,

        [Parameter()]
        [System.Boolean]
        $PhysicalAccess,

        [Parameter()]
        [System.Boolean]
        $PotentialHighImpactUser,

        [Parameter()]
        [System.Boolean]
        $Print,

        [Parameter()]
        [System.Boolean]
        $PriorityUserGroupMember,

        [Parameter()]
        [System.Boolean]
        $SecurityAlertDefenseEvasion,

        [Parameter()]
        [System.Boolean]
        $SecurityAlertUnwantedSoftware,

        [Parameter()]
        [System.Boolean]
        $SpoAccessRequest,

        [Parameter()]
        [System.Boolean]
        $SpoApprovedAccess,

        [Parameter()]
        [System.Boolean]
        $SpoDownload,

        [Parameter()]
        [System.Boolean]
        $SpoDownloadV2,

        [Parameter()]
        [System.Boolean]
        $SpoFileAccessed,

        [Parameter()]
        [System.Boolean]
        $SpoFileDeleted,

        [Parameter()]
        [System.Boolean]
        $SpoFileDeletedFromFirstStageRecycleBin,

        [Parameter()]
        [System.Boolean]
        $SpoFileDeletedFromSecondStageRecycleBin,

        [Parameter()]
        [System.Boolean]
        $SpoFileLabelDowngraded,

        [Parameter()]
        [System.Boolean]
        $SpoFileLabelRemoved,

        [Parameter()]
        [System.Boolean]
        $SpoFileSharing,

        [Parameter()]
        [System.Boolean]
        $SpoFolderDeleted,

        [Parameter()]
        [System.Boolean]
        $SpoFolderDeletedFromFirstStageRecycleBin,

        [Parameter()]
        [System.Boolean]
        $SpoFolderDeletedFromSecondStageRecycleBin,

        [Parameter()]
        [System.Boolean]
        $SpoFolderSharing,

        [Parameter()]
        [System.Boolean]
        $SpoSiteExternalUserAdded,

        [Parameter()]
        [System.Boolean]
        $SpoSiteInternalUserAdded,

        [Parameter()]
        [System.Boolean]
        $SpoSiteLabelRemoved,

        [Parameter()]
        [System.Boolean]
        $SpoSiteSharing,

        [Parameter()]
        [System.Boolean]
        $SpoSyncDownload,

        [Parameter()]
        [System.Boolean]
        $TeamsChannelFileSharedExternal,

        [Parameter()]
        [System.Boolean]
        $TeamsChannelMemberAddedExternal,

        [Parameter()]
        [System.Boolean]
        $TeamsChatFileSharedExternal,

        [Parameter()]
        [System.Boolean]
        $TeamsFileDownload,

        [Parameter()]
        [System.Boolean]
        $TeamsFolderSharedExternal,

        [Parameter()]
        [System.Boolean]
        $TeamsMemberAddedExternal,

        [Parameter()]
        [System.Boolean]
        $TeamsSensitiveMessage,

        [Parameter()]
        [System.Boolean]
        $UserHistory,

        [Parameter()]
        [System.Boolean]
        $AWSS3BlockPublicAccessDisabled,

        [Parameter()]
        [System.Boolean]
        $AWSS3BucketDeleted,

        [Parameter()]
        [System.Boolean]
        $AWSS3PublicAccessEnabled,

        [Parameter()]
        [System.Boolean]
        $AWSS3ServerLoggingDisabled,

        [Parameter()]
        [System.Boolean]
        $AzureElevateAccessToAllSubscriptions,

        [Parameter()]
        [System.Boolean]
        $AzureResourceThreatProtectionSettingsUpdated,

        [Parameter()]
        [System.Boolean]
        $AzureSQLServerAuditingSettingsUpdated,

        [Parameter()]
        [System.Boolean]
        $AzureSQLServerFirewallRuleDeleted,

        [Parameter()]
        [System.Boolean]
        $AzureSQLServerFirewallRuleUpdated,

        [Parameter()]
        [System.Boolean]
        $AzureStorageAccountOrContainerDeleted,

        [Parameter()]
        [System.Boolean]
        $BoxContentAccess,

        [Parameter()]
        [System.Boolean]
        $BoxContentDelete,

        [Parameter()]
        [System.Boolean]
        $BoxContentDownload,

        [Parameter()]
        [System.Boolean]
        $BoxContentExternallyShared,

        [Parameter()]
        [System.Boolean]
        $CCFinancialRegulatoryRiskyTextSent,

        [Parameter()]
        [System.Boolean]
        $CCInappropriateContentSent,

        [Parameter()]
        [System.Boolean]
        $CCInappropriateImagesSent,

        [Parameter()]
        [System.Boolean]
        $DropboxContentAccess,

        [Parameter()]
        [System.Boolean]
        $DropboxContentDelete,

        [Parameter()]
        [System.Boolean]
        $DropboxContentDownload,

        [Parameter()]
        [System.Boolean]
        $DropboxContentExternallyShared,

        [Parameter()]
        [System.Boolean]
        $GoogleDriveContentAccess,

        [Parameter()]
        [System.Boolean]
        $GoogleDriveContentDelete,

        [Parameter()]
        [System.Boolean]
        $GoogleDriveContentExternallyShared,

        [Parameter()]
        [System.Boolean]
        $PowerBIDashboardsDeleted,

        [Parameter()]
        [System.Boolean]
        $PowerBIReportsDeleted,

        [Parameter()]
        [System.Boolean]
        $PowerBIReportsDownloaded,

        [Parameter()]
        [System.Boolean]
        $PowerBIReportsExported,

        [Parameter()]
        [System.Boolean]
        $PowerBIReportsViewed,

        [Parameter()]
        [System.Boolean]
        $PowerBISemanticModelsDeleted,

        [Parameter()]
        [System.Boolean]
        $PowerBISensitivityLabelDowngradedForArtifacts,

        [Parameter()]
        [System.Boolean]
        $PowerBISensitivityLabelRemovedFromArtifacts,

        [Parameter()]
        [System.String]
        $HistoricTimeSpan,

        [Parameter()]
        [System.String]
        $InScopeTimeSpan,

        [Parameter()]
        [System.Boolean]
        $EnableTeam,

        [Parameter()]
        [System.Boolean]
        $AnalyticsNewInsightEnabled,

        [Parameter()]
        [System.Boolean]
        $AnalyticsTurnedOffEnabled,

        [Parameter()]
        [System.Boolean]
        $HighSeverityAlertsEnabled,

        [Parameter()]
        [System.String[]]
        $HighSeverityAlertsRoleGroups,

        [Parameter()]
        [System.Boolean]
        $PoliciesHealthEnabled,

        [Parameter()]
        [System.String[]]
        $PoliciesHealthRoleGroups,

        [Parameter()]
        [System.Boolean]
        $NotificationDetailsEnabled,

        [Parameter()]
        [System.String[]]
        $NotificationDetailsRoleGroups,

        [Parameter()]
        [System.Boolean]
        $ClipDeletionEnabled,

        [Parameter()]
        [System.Boolean]
        $SessionRecordingEnabled,

        [Parameter()]
        [System.Boolean]
        $RecordingTimeframePreEventInSec,

        [Parameter()]
        [System.Boolean]
        $RecordingTimeframePostEventInSec,

        [Parameter()]
        [System.Boolean]
        $BandwidthCapInMb,

        [Parameter()]
        [System.Boolean]
        $OfflineRecordingStorageLimitInMb,

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
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters | Out-Null

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
    try
    {
        if ($null -ne $Script:exportedInstances -and $Script:ExportMode)
        {
            $instance = $Script:exportedInstances | Where-Object -FilterScript {$_.Name -eq $Name}
        }
        else
        {
            $instance = Get-InsiderRiskPolicy -Identity $Name
        }

        $results = @{
            Name                  = $instance.Name
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
        }

        if (-not [System.String]::IsNullOrEmpty($instance.SessionRecordingSettings))
        {
            $SessionRecordingSettings = ConvertFrom-Json $instance.SessionRecordingSettings
            $forensicSettingsHash = @{
                ClipDeletionEnabled              = [Boolean]$SessionRecordingSettings.ClipDeletionEnabled
                SessionRecordingEnabled          = [Boolean]$SessionRecordingSettings.Enabled
                RecordingTimeframePreEventInSec  = $SessionRecordingSettings.RecordingTimeframePreEventInSec
                RecordingTimeframePostEventInSec = $SessionRecordingSettings.RecordingTimeframePostEventInSec
                BandwidthCapInMb                 = $SessionRecordingSettings.BandwidthCapInMb
                OfflineRecordingStorageLimitInMb = $SessionRecordingSettings.OfflineRecordingStorageLimitInMb
            }
            $results += $forensicSettingsHash
        }

        if (-not [System.String]::IsNullOrEmpty($instance.TenantSettings))
        {
            $tenantSettings = ConvertFrom-Json $instance.TenantSettings[0]
            $tenantSettingsHash = @{
                DLPUserRiskSync                               = [Boolean]$tenantSettings.FeatureSettings.DLPUserRiskSync
                OptInIRMDataExport                            = [Boolean]$tenantSettings.FeatureSettings.OptInIRMDataExport
                RaiseAuditAlert                               = [Boolean]$tenantSettings.FeatureSettings.RaiseAuditAlert
                FileVolCutoffLimits                           = $tenantSettings.IntelligentDetections.FileVolCutoffLimits
                AlertVolume                                   = $tenantSettings.IntelligentDetections.AlertVolume
                AnomalyDetections                             = [Boolean]$tenantSettings.Indicators.AnomalyDetections
                CopyToPersonalCloud                           = [Boolean]$tenantSettings.Indicators.CopyToPersonalCloud
                CopyToUSB                                     = [Boolean]$tenantSettings.Indicators.CopyToUSB
                CumulativeExfiltrationDetector                = [Boolean]$tenantSettings.Indicators.CumulativeExfiltrationDetector
                EmailExternal                                 = [Boolean]$tenantSettings.Indicators.EmailExternal
                EmployeeAccessedEmployeePatientData           = [Boolean]$tenantSettings.Indicators.EmployeeAccessedEmployeePatientData
                EmployeeAccessedFamilyData                    = [Boolean]$tenantSettings.Indicators.EmployeeAccessedFamilyData
                EmployeeAccessedHighVolumePatientData         = [Boolean]$tenantSettings.Indicators.EmployeeAccessedHighVolumePatientData
                EmployeeAccessedNeighbourData                 = [Boolean]$tenantSettings.Indicators.EmployeeAccessedNeighbourData
                EmployeeAccessedRestrictedData                = [Boolean]$tenantSettings.Indicators.EmployeeAccessedRestrictedData
                EpoBrowseToChildAbuseSites                    = [Boolean]$tenantSettings.Indicators.EpoBrowseToChildAbuseSites
                EpoBrowseToCriminalActivitySites              = [Boolean]$tenantSettings.Indicators.EpoBrowseToCriminalActivitySites
                EpoBrowseToCultSites                          = [Boolean]$tenantSettings.Indicators.EpoBrowseToCultSites
                EpoBrowseToGamblingSites                      = [Boolean]$tenantSettings.Indicators.EpoBrowseToGamblingSites
                EpoBrowseToHackingSites                       = [Boolean]$tenantSettings.Indicators.EpoBrowseToHackingSites
                EpoBrowseToHateIntoleranceSites               = [Boolean]$tenantSettings.Indicators.EpoBrowseToHateIntoleranceSites
                EpoBrowseToIllegalSoftwareSites               = [Boolean]$tenantSettings.Indicators.EpoBrowseToIllegalSoftwareSites
                EpoBrowseToKeyloggerSites                     = [Boolean]$tenantSettings.Indicators.EpoBrowseToKeyloggerSites
                EpoBrowseToLlmSites                           = [Boolean]$tenantSettings.Indicators.EpoBrowseToLlmSites
                EpoBrowseToMalwareSites                       = [Boolean]$tenantSettings.Indicators.EpoBrowseToMalwareSites
                EpoBrowseToPhishingSites                      = [Boolean]$tenantSettings.Indicators.EpoBrowseToPhishingSites
                EpoBrowseToPornographySites                   = [Boolean]$tenantSettings.Indicators.EpoBrowseToPornographySites
                EpoBrowseToUnallowedDomain                    = [Boolean]$tenantSettings.Indicators.EpoBrowseToUnallowedDomain
                EpoBrowseToViolenceSites                      = [Boolean]$tenantSettings.Indicators.EpoBrowseToViolenceSites
                EpoCopyToClipboardFromSensitiveFile           = [Boolean]$tenantSettings.Indicators.EpoCopyToClipboardFromSensitiveFile
                EpoCopyToNetworkShare                         = [Boolean]$tenantSettings.Indicators.EpoCopyToNetworkShare
                EpoFileArchived                               = [Boolean]$tenantSettings.Indicators.EpoFileArchived
                EpoFileCopiedToRemoteDesktopSession           = [Boolean]$tenantSettings.Indicators.EpoFileCopiedToRemoteDesktopSession
                EpoFileDeleted                                = [Boolean]$tenantSettings.Indicators.EpoFileDeleted
                EpoFileDownloadedFromBlacklistedDomain        = [Boolean]$tenantSettings.Indicators.EpoFileDownloadedFromBlacklistedDomain
                EpoFileDownloadedFromEnterpriseDomain         = [Boolean]$tenantSettings.Indicators.EpoFileDownloadedFromEnterpriseDomain
                EpoFileRenamed                                = [Boolean]$tenantSettings.Indicators.EpoFileRenamed
                EpoFileStagedToCentralLocation                = [Boolean]$tenantSettings.Indicators.EpoFileStagedToCentralLocation
                EpoHiddenFileCreated                          = [Boolean]$tenantSettings.Indicators.EpoHiddenFileCreated
                EpoRemovableMediaMount                        = [Boolean]$tenantSettings.Indicators.EpoRemovableMediaMount
                EpoSensitiveFileRead                          = [Boolean]$tenantSettings.Indicators.EpoSensitiveFileRead
                Mcas3rdPartyAppDownload                       = [Boolean]$tenantSettings.Indicators.Mcas3rdPartyAppDownload
                Mcas3rdPartyAppFileDelete                     = [Boolean]$tenantSettings.Indicators.Mcas3rdPartyAppFileDelete
                Mcas3rdPartyAppFileSharing                    = [Boolean]$tenantSettings.Indicators.Mcas3rdPartyAppFileSharing
                McasActivityFromInfrequentCountry             = [Boolean]$tenantSettings.Indicators.McasActivityFromInfrequentCountry
                McasImpossibleTravel                          = [Boolean]$tenantSettings.Indicators.McasImpossibleTravel
                McasMultipleFailedLogins                      = [Boolean]$tenantSettings.Indicators.McasMultipleFailedLogins
                McasMultipleStorageDeletion                   = [Boolean]$tenantSettings.Indicators.McasMultipleStorageDeletion
                McasMultipleVMCreation                        = [Boolean]$tenantSettings.Indicators.McasMultipleVMCreation
                McasMultipleVMDeletion                        = [Boolean]$tenantSettings.Indicators.McasMultipleVMDeletion
                McasSuspiciousAdminActivities                 = [Boolean]$tenantSettings.Indicators.McasSuspiciousAdminActivities
                McasSuspiciousCloudCreation                   = [Boolean]$tenantSettings.Indicators.McasSuspiciousCloudCreation
                McasSuspiciousCloudTrailLoggingChange         = [Boolean]$tenantSettings.Indicators.McasSuspiciousCloudTrailLoggingChange
                McasTerminatedEmployeeActivity                = [Boolean]$tenantSettings.Indicators.McasTerminatedEmployeeActivity
                OdbDownload                                   = [Boolean]$tenantSettings.Indicators.OdbDownload
                OdbSyncDownload                               = [Boolean]$tenantSettings.Indicators.OdbSyncDownload
                PeerCumulativeExfiltrationDetector            = [Boolean]$tenantSettings.Indicators.PeerCumulativeExfiltrationDetector
                PhysicalAccess                                = [Boolean]$tenantSettings.Indicators.PhysicalAccess
                PotentialHighImpactUser                       = [Boolean]$tenantSettings.Indicators.PotentialHighImpactUser
                Print                                         = [Boolean]$tenantSettings.Indicators.Print
                PriorityUserGroupMember                       = [Boolean]$tenantSettings.Indicators.PriorityUserGroupMember
                SecurityAlertDefenseEvasion                   = [Boolean]$tenantSettings.Indicators.SecurityAlertDefenseEvasion
                SecurityAlertUnwantedSoftware                 = [Boolean]$tenantSettings.Indicators.SecurityAlertUnwantedSoftware
                SpoAccessRequest                              = [Boolean]$tenantSettings.Indicators.SpoAccessRequest
                SpoApprovedAccess                             = [Boolean]$tenantSettings.Indicators.SpoApprovedAccess
                SpoDownload                                   = [Boolean]$tenantSettings.Indicators.SpoDownload
                SpoDownloadV2                                 = [Boolean]$tenantSettings.Indicators.SpoDownloadV2
                SpoFileAccessed                               = [Boolean]$tenantSettings.Indicators.SpoFileAccessed
                SpoFileDeleted                                = [Boolean]$tenantSettings.Indicators.SpoFileDeleted
                SpoFileDeletedFromFirstStageRecycleBin        = [Boolean]$tenantSettings.Indicators.SpoFileDeletedFromFirstStageRecycleBin
                SpoFileDeletedFromSecondStageRecycleBin       = [Boolean]$tenantSettings.Indicators.SpoFileDeletedFromSecondStageRecycleBin
                SpoFileLabelDowngraded                        = [Boolean]$tenantSettings.Indicators.SpoFileLabelDowngraded
                SpoFileLabelRemoved                           = [Boolean]$tenantSettings.Indicators.SpoFileLabelRemoved
                SpoFileSharing                                = [Boolean]$tenantSettings.Indicators.SpoFileSharing
                SpoFolderDeleted                              = [Boolean]$tenantSettings.Indicators.SpoFolderDeleted
                SpoFolderDeletedFromFirstStageRecycleBin      = [Boolean]$tenantSettings.Indicators.SpoFolderDeletedFromFirstStageRecycleBin
                SpoFolderDeletedFromSecondStageRecycleBin     = [Boolean]$tenantSettings.Indicators.SpoFolderDeletedFromSecondStageRecycleBin
                SpoFolderSharing                              = [Boolean]$tenantSettings.Indicators.SpoFolderSharing
                SpoSiteExternalUserAdded                      = [Boolean]$tenantSettings.Indicators.SpoSiteExternalUserAdded
                SpoSiteInternalUserAdded                      = [Boolean]$tenantSettings.Indicators.SpoSiteInternalUserAdded
                SpoSiteLabelRemoved                           = [Boolean]$tenantSettings.Indicators.SpoSiteLabelRemoved
                SpoSiteSharing                                = [Boolean]$tenantSettings.Indicators.SpoSiteSharing
                SpoSyncDownload                               = [Boolean]$tenantSettings.Indicators.SpoSyncDownload
                TeamsChannelFileSharedExternal                = [Boolean]$tenantSettings.Indicators.TeamsChannelFileSharedExternal
                TeamsChannelMemberAddedExternal               = [Boolean]$tenantSettings.Indicators.TeamsChannelMemberAddedExternal
                TeamsChatFileSharedExternal                   = [Boolean]$tenantSettings.Indicators.TeamsChatFileSharedExternal
                TeamsFileDownload                             = [Boolean]$tenantSettings.Indicators.TeamsFileDownload
                TeamsFolderSharedExternal                     = [Boolean]$tenantSettings.Indicators.TeamsFolderSharedExternal
                TeamsMemberAddedExternal                      = [Boolean]$tenantSettings.Indicators.TeamsMemberAddedExternal
                TeamsSensitiveMessage                         = [Boolean]$tenantSettings.Indicators.TeamsSensitiveMessage
                UserHistory                                   = [Boolean]$tenantSettings.Indicators.UserHistory
                AWSS3BlockPublicAccessDisabled                = [Boolean]$tenantSettings.ExtensibleIndicators.AWSS3BlockPublicAccessDisabled
                AWSS3BucketDeleted                            = [Boolean]$tenantSettings.ExtensibleIndicators.AWSS3BucketDeleted
                AWSS3PublicAccessEnabled                      = [Boolean]$tenantSettings.ExtensibleIndicators.AWSS3PublicAccessEnabled
                AWSS3ServerLoggingDisabled                    = [Boolean]$tenantSettings.ExtensibleIndicators.AWSS3ServerLoggingDisabled
                AzureElevateAccessToAllSubscriptions          = [Boolean]$tenantSettings.ExtensibleIndicators.AzureElevateAccessToAllSubscriptions
                AzureResourceThreatProtectionSettingsUpdated  = [Boolean]$tenantSettings.ExtensibleIndicators.AzureResourceThreatProtectionSettingsUpdated
                AzureSQLServerAuditingSettingsUpdated         = [Boolean]$tenantSettings.ExtensibleIndicators.AzureSQLServerAuditingSettingsUpdated
                AzureSQLServerFirewallRuleDeleted             = [Boolean]$tenantSettings.ExtensibleIndicators.AzureSQLServerFirewallRuleDeleted
                AzureSQLServerFirewallRuleUpdated             = [Boolean]$tenantSettings.ExtensibleIndicators.AzureSQLServerFirewallRuleUpdated
                AzureStorageAccountOrContainerDeleted         = [Boolean]$tenantSettings.ExtensibleIndicators.AzureStorageAccountOrContainerDeleted
                BoxContentAccess                              = [Boolean]$tenantSettings.ExtensibleIndicators.BoxContentAccess
                BoxContentDelete                              = [Boolean]$tenantSettings.ExtensibleIndicators.BoxContentDelete
                BoxContentDownload                            = [Boolean]$tenantSettings.ExtensibleIndicators.BoxContentDownload
                BoxContentExternallyShared                    = [Boolean]$tenantSettings.ExtensibleIndicators.BoxContentExternallyShared
                CCFinancialRegulatoryRiskyTextSent            = [Boolean]$tenantSettings.ExtensibleIndicators.CCFinancialRegulatoryRiskyTextSent
                CCInappropriateContentSent                    = [Boolean]$tenantSettings.ExtensibleIndicators.CCInappropriateContentSent
                CCInappropriateImagesSent                     = [Boolean]$tenantSettings.ExtensibleIndicators.CCInappropriateImagesSent
                DropboxContentAccess                          = [Boolean]$tenantSettings.ExtensibleIndicators.DropboxContentAccess
                DropboxContentDelete                          = [Boolean]$tenantSettings.ExtensibleIndicators.DropboxContentDelete
                DropboxContentDownload                        = [Boolean]$tenantSettings.ExtensibleIndicators.DropboxContentDownload
                DropboxContentExternallyShared                = [Boolean]$tenantSettings.ExtensibleIndicators.DropboxContentExternallyShared
                GoogleDriveContentAccess                      = [Boolean]$tenantSettings.ExtensibleIndicators.GoogleDriveContentAccess
                GoogleDriveContentDelete                      = [Boolean]$tenantSettings.ExtensibleIndicators.GoogleDriveContentDelete
                GoogleDriveContentExternallyShared            = [Boolean]$tenantSettings.ExtensibleIndicators.GoogleDriveContentExternallyShared
                PowerBIDashboardsDeleted                      = [Boolean]$tenantSettings.ExtensibleIndicators.PowerBIDashboardsDeleted
                PowerBIReportsDeleted                         = [Boolean]$tenantSettings.ExtensibleIndicators.PowerBIReportsDeleted
                PowerBIReportsDownloaded                      = [Boolean]$tenantSettings.ExtensibleIndicators.PowerBIReportsDownloaded
                PowerBIReportsExported                        = [Boolean]$tenantSettings.ExtensibleIndicators.PowerBIReportsExported
                PowerBIReportsViewed                          = [Boolean]$tenantSettings.ExtensibleIndicators.PowerBIReportsViewed
                PowerBISemanticModelsDeleted                  = [Boolean]$tenantSettings.ExtensibleIndicators.PowerBISemanticModelsDeleted
                PowerBISensitivityLabelDowngradedForArtifacts = [Boolean]$tenantSettings.ExtensibleIndicators.PowerBISensitivityLabelDowngradedForArtifacts
                PowerBISensitivityLabelRemovedFromArtifacts   = [Boolean]$tenantSettings.ExtensibleIndicators.PowerBISensitivityLabelRemovedFromArtifacts
                HistoricTimeSpan                              = $tenantSettings.TimeSpan.HistoricTimeSpan
                InScopeTimeSpan                               = $tenantSettings.TimeSpan.InScopeTimeSpan
                EnableTeam                                    = [Boolean]$tenantSettings.FeatureSettings.EnableTeam
            }

            $AnalyticsNewInsight = $tenantSettings.NotificationPreferences | Where-Object -FilterScript {$_.NotificationType -eq 'AnalyticsNewInsight'}
            if ($null -ne $AnalyticsNewInsight)
            {
                $tenantSettingsHash.Add('AnalyticsNewInsightEnabled', [Boolean]$AnalyticsNewInsight.Enabled)
            }

            $AnalyticsTurnedOff = $tenantSettings.NotificationPreferences | Where-Object -FilterScript {$_.NotificationType -eq 'AnalyticsTurnedOff'}
            if ($null -ne $AnalyticsTurnedOff)
            {
                $tenantSettingsHash.Add('AnalyticsTurnedOffEnabled', [Boolean]$AnalyticsTurnedOff.Enabled)
            }

            $highSeverityAlerts = $tenantSettings.NotificationPreferences | Where-Object -FilterScript {$_.NotificationType -eq 'HighSeverityAlerts'}
            if ($null -ne $highSeverityAlerts)
            {
                $tenantSettingsHash.Add('HighSeverityAlertsEnabled', [Boolean]$highSeverityAlerts.Enabled)
                $tenantSettingsHash.Add('HighSeverityAlertsRoleGroups', [Array]$highSeverityAlerts.RoleGroups)
            }

            $policiesHealth = $tenantSettings.NotificationPreferences | Where-Object -FilterScript {$_.NotificationType -eq 'PoliciesHealth'}
            if ($null -ne $policiesHealth)
            {
                $tenantSettingsHash.Add('PoliciesHealthEnabled', [Boolean]$policiesHealth.Enabled)
                $tenantSettingsHash.Add('PoliciesHealthRoleGroups', [Array]$policiesHealth.RoleGroups)
            }

            if ($null -ne $tenantSettings.FeatureSettings.NotificationDetails)
            {
                $tenantSettingsHash.Add('NotificationDetailsEnabled', $true)
                $tenantSettingsHash.Add('NotificationDetailsRoleGroups', [Array]$tenantSettings.FeatureSettings.NotificationDetails.RoleGroups)
            }
            else
            {
                $tenantSettingsHash.Add('NotificationDetailsEnabled', $false)
            }

            $results += $tenantSettingsHash
        }

        return [System.Collections.Hashtable] $results
    }
    catch
    {
        Write-Verbose -Message $_
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
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.Boolean]
        $DLPUserRiskSync,

        [Parameter()]
        [System.Boolean]
        $OptInIRMDataExport,

        [Parameter()]
        [System.Boolean]
        $RaiseAuditAlert,

        [Parameter()]
        [System.String]
        $FileVolCutoffLimits,

        [Parameter()]
        [System.String]
        $AlertVolume,

        [Parameter()]
        [System.Boolean]
        $AnomalyDetections,

        [Parameter()]
        [System.Boolean]
        $CopyToPersonalCloud,

        [Parameter()]
        [System.Boolean]
        $CopyToUSB,

        [Parameter()]
        [System.Boolean]
        $CumulativeExfiltrationDetector,

        [Parameter()]
        [System.Boolean]
        $EmailExternal,

        [Parameter()]
        [System.Boolean]
        $EmployeeAccessedEmployeePatientData,

        [Parameter()]
        [System.Boolean]
        $EmployeeAccessedFamilyData,

        [Parameter()]
        [System.Boolean]
        $EmployeeAccessedHighVolumePatientData,

        [Parameter()]
        [System.Boolean]
        $EmployeeAccessedNeighbourData,

        [Parameter()]
        [System.Boolean]
        $EmployeeAccessedRestrictedData,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToChildAbuseSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToCriminalActivitySites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToCultSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToGamblingSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToHackingSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToHateIntoleranceSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToIllegalSoftwareSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToKeyloggerSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToLlmSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToMalwareSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToPhishingSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToPornographySites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToUnallowedDomain,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToViolenceSites,

        [Parameter()]
        [System.Boolean]
        $EpoCopyToClipboardFromSensitiveFile,

        [Parameter()]
        [System.Boolean]
        $EpoCopyToNetworkShare,

        [Parameter()]
        [System.Boolean]
        $EpoFileArchived,

        [Parameter()]
        [System.Boolean]
        $EpoFileCopiedToRemoteDesktopSession,

        [Parameter()]
        [System.Boolean]
        $EpoFileDeleted,

        [Parameter()]
        [System.Boolean]
        $EpoFileDownloadedFromBlacklistedDomain,

        [Parameter()]
        [System.Boolean]
        $EpoFileDownloadedFromEnterpriseDomain,

        [Parameter()]
        [System.Boolean]
        $EpoFileRenamed,

        [Parameter()]
        [System.Boolean]
        $EpoFileStagedToCentralLocation,

        [Parameter()]
        [System.Boolean]
        $EpoHiddenFileCreated,

        [Parameter()]
        [System.Boolean]
        $EpoRemovableMediaMount,

        [Parameter()]
        [System.Boolean]
        $EpoSensitiveFileRead,

        [Parameter()]
        [System.Boolean]
        $Mcas3rdPartyAppDownload,

        [Parameter()]
        [System.Boolean]
        $Mcas3rdPartyAppFileDelete,

        [Parameter()]
        [System.Boolean]
        $Mcas3rdPartyAppFileSharing,

        [Parameter()]
        [System.Boolean]
        $McasActivityFromInfrequentCountry,

        [Parameter()]
        [System.Boolean]
        $McasImpossibleTravel,

        [Parameter()]
        [System.Boolean]
        $McasMultipleFailedLogins,

        [Parameter()]
        [System.Boolean]
        $McasMultipleStorageDeletion,

        [Parameter()]
        [System.Boolean]
        $McasMultipleVMCreation,

        [Parameter()]
        [System.Boolean]
        $McasMultipleVMDeletion,

        [Parameter()]
        [System.Boolean]
        $McasSuspiciousAdminActivities,

        [Parameter()]
        [System.Boolean]
        $McasSuspiciousCloudCreation,

        [Parameter()]
        [System.Boolean]
        $McasSuspiciousCloudTrailLoggingChange,

        [Parameter()]
        [System.Boolean]
        $McasTerminatedEmployeeActivity,

        [Parameter()]
        [System.Boolean]
        $OdbDownload,

        [Parameter()]
        [System.Boolean]
        $OdbSyncDownload,

        [Parameter()]
        [System.Boolean]
        $PeerCumulativeExfiltrationDetector,

        [Parameter()]
        [System.Boolean]
        $PhysicalAccess,

        [Parameter()]
        [System.Boolean]
        $PotentialHighImpactUser,

        [Parameter()]
        [System.Boolean]
        $Print,

        [Parameter()]
        [System.Boolean]
        $PriorityUserGroupMember,

        [Parameter()]
        [System.Boolean]
        $SecurityAlertDefenseEvasion,

        [Parameter()]
        [System.Boolean]
        $SecurityAlertUnwantedSoftware,

        [Parameter()]
        [System.Boolean]
        $SpoAccessRequest,

        [Parameter()]
        [System.Boolean]
        $SpoApprovedAccess,

        [Parameter()]
        [System.Boolean]
        $SpoDownload,

        [Parameter()]
        [System.Boolean]
        $SpoDownloadV2,

        [Parameter()]
        [System.Boolean]
        $SpoFileAccessed,

        [Parameter()]
        [System.Boolean]
        $SpoFileDeleted,

        [Parameter()]
        [System.Boolean]
        $SpoFileDeletedFromFirstStageRecycleBin,

        [Parameter()]
        [System.Boolean]
        $SpoFileDeletedFromSecondStageRecycleBin,

        [Parameter()]
        [System.Boolean]
        $SpoFileLabelDowngraded,

        [Parameter()]
        [System.Boolean]
        $SpoFileLabelRemoved,

        [Parameter()]
        [System.Boolean]
        $SpoFileSharing,

        [Parameter()]
        [System.Boolean]
        $SpoFolderDeleted,

        [Parameter()]
        [System.Boolean]
        $SpoFolderDeletedFromFirstStageRecycleBin,

        [Parameter()]
        [System.Boolean]
        $SpoFolderDeletedFromSecondStageRecycleBin,

        [Parameter()]
        [System.Boolean]
        $SpoFolderSharing,

        [Parameter()]
        [System.Boolean]
        $SpoSiteExternalUserAdded,

        [Parameter()]
        [System.Boolean]
        $SpoSiteInternalUserAdded,

        [Parameter()]
        [System.Boolean]
        $SpoSiteLabelRemoved,

        [Parameter()]
        [System.Boolean]
        $SpoSiteSharing,

        [Parameter()]
        [System.Boolean]
        $SpoSyncDownload,

        [Parameter()]
        [System.Boolean]
        $TeamsChannelFileSharedExternal,

        [Parameter()]
        [System.Boolean]
        $TeamsChannelMemberAddedExternal,

        [Parameter()]
        [System.Boolean]
        $TeamsChatFileSharedExternal,

        [Parameter()]
        [System.Boolean]
        $TeamsFileDownload,

        [Parameter()]
        [System.Boolean]
        $TeamsFolderSharedExternal,

        [Parameter()]
        [System.Boolean]
        $TeamsMemberAddedExternal,

        [Parameter()]
        [System.Boolean]
        $TeamsSensitiveMessage,

        [Parameter()]
        [System.Boolean]
        $UserHistory,

        [Parameter()]
        [System.Boolean]
        $AWSS3BlockPublicAccessDisabled,

        [Parameter()]
        [System.Boolean]
        $AWSS3BucketDeleted,

        [Parameter()]
        [System.Boolean]
        $AWSS3PublicAccessEnabled,

        [Parameter()]
        [System.Boolean]
        $AWSS3ServerLoggingDisabled,

        [Parameter()]
        [System.Boolean]
        $AzureElevateAccessToAllSubscriptions,

        [Parameter()]
        [System.Boolean]
        $AzureResourceThreatProtectionSettingsUpdated,

        [Parameter()]
        [System.Boolean]
        $AzureSQLServerAuditingSettingsUpdated,

        [Parameter()]
        [System.Boolean]
        $AzureSQLServerFirewallRuleDeleted,

        [Parameter()]
        [System.Boolean]
        $AzureSQLServerFirewallRuleUpdated,

        [Parameter()]
        [System.Boolean]
        $AzureStorageAccountOrContainerDeleted,

        [Parameter()]
        [System.Boolean]
        $BoxContentAccess,

        [Parameter()]
        [System.Boolean]
        $BoxContentDelete,

        [Parameter()]
        [System.Boolean]
        $BoxContentDownload,

        [Parameter()]
        [System.Boolean]
        $BoxContentExternallyShared,

        [Parameter()]
        [System.Boolean]
        $CCFinancialRegulatoryRiskyTextSent,

        [Parameter()]
        [System.Boolean]
        $CCInappropriateContentSent,

        [Parameter()]
        [System.Boolean]
        $CCInappropriateImagesSent,

        [Parameter()]
        [System.Boolean]
        $DropboxContentAccess,

        [Parameter()]
        [System.Boolean]
        $DropboxContentDelete,

        [Parameter()]
        [System.Boolean]
        $DropboxContentDownload,

        [Parameter()]
        [System.Boolean]
        $DropboxContentExternallyShared,

        [Parameter()]
        [System.Boolean]
        $GoogleDriveContentAccess,

        [Parameter()]
        [System.Boolean]
        $GoogleDriveContentDelete,

        [Parameter()]
        [System.Boolean]
        $GoogleDriveContentExternallyShared,

        [Parameter()]
        [System.Boolean]
        $PowerBIDashboardsDeleted,

        [Parameter()]
        [System.Boolean]
        $PowerBIReportsDeleted,

        [Parameter()]
        [System.Boolean]
        $PowerBIReportsDownloaded,

        [Parameter()]
        [System.Boolean]
        $PowerBIReportsExported,

        [Parameter()]
        [System.Boolean]
        $PowerBIReportsViewed,

        [Parameter()]
        [System.Boolean]
        $PowerBISemanticModelsDeleted,

        [Parameter()]
        [System.Boolean]
        $PowerBISensitivityLabelDowngradedForArtifacts,

        [Parameter()]
        [System.Boolean]
        $PowerBISensitivityLabelRemovedFromArtifacts,

        [Parameter()]
        [System.String]
        $HistoricTimeSpan,

        [Parameter()]
        [System.String]
        $InScopeTimeSpan,

        [Parameter()]
        [System.Boolean]
        $EnableTeam,

        [Parameter()]
        [System.Boolean]
        $AnalyticsNewInsightEnabled,

        [Parameter()]
        [System.Boolean]
        $AnalyticsTurnedOffEnabled,

        [Parameter()]
        [System.Boolean]
        $HighSeverityAlertsEnabled,

        [Parameter()]
        [System.String[]]
        $HighSeverityAlertsRoleGroups,

        [Parameter()]
        [System.Boolean]
        $PoliciesHealthEnabled,

        [Parameter()]
        [System.String[]]
        $PoliciesHealthRoleGroups,

        [Parameter()]
        [System.Boolean]
        $NotificationDetailsEnabled,

        [Parameter()]
        [System.String[]]
        $NotificationDetailsRoleGroups,

        [Parameter()]
        [System.Boolean]
        $ClipDeletionEnabled,

        [Parameter()]
        [System.Boolean]
        $SessionRecordingEnabled,

        [Parameter()]
        [System.Boolean]
        $RecordingTimeframePreEventInSec,

        [Parameter()]
        [System.Boolean]
        $RecordingTimeframePostEventInSec,

        [Parameter()]
        [System.Boolean]
        $BandwidthCapInMb,

        [Parameter()]
        [System.Boolean]
        $OfflineRecordingStorageLimitInMb,

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

    $setParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        ##TODO - Replace by the New cmdlet for the resource
        New-Cmdlet @SetParameters
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        ##TODO - Replace by the Update/Set cmdlet for the resource
        Set-cmdlet @SetParameters
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        ##TODO - Replace by the Remove cmdlet for the resource
        Remove-cmdlet @SetParameters
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
        $Name,

        [Parameter()]
        [System.Boolean]
        $DLPUserRiskSync,

        [Parameter()]
        [System.Boolean]
        $OptInIRMDataExport,

        [Parameter()]
        [System.Boolean]
        $RaiseAuditAlert,

        [Parameter()]
        [System.String]
        $FileVolCutoffLimits,

        [Parameter()]
        [System.String]
        $AlertVolume,

        [Parameter()]
        [System.Boolean]
        $AnomalyDetections,

        [Parameter()]
        [System.Boolean]
        $CopyToPersonalCloud,

        [Parameter()]
        [System.Boolean]
        $CopyToUSB,

        [Parameter()]
        [System.Boolean]
        $CumulativeExfiltrationDetector,

        [Parameter()]
        [System.Boolean]
        $EmailExternal,

        [Parameter()]
        [System.Boolean]
        $EmployeeAccessedEmployeePatientData,

        [Parameter()]
        [System.Boolean]
        $EmployeeAccessedFamilyData,

        [Parameter()]
        [System.Boolean]
        $EmployeeAccessedHighVolumePatientData,

        [Parameter()]
        [System.Boolean]
        $EmployeeAccessedNeighbourData,

        [Parameter()]
        [System.Boolean]
        $EmployeeAccessedRestrictedData,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToChildAbuseSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToCriminalActivitySites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToCultSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToGamblingSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToHackingSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToHateIntoleranceSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToIllegalSoftwareSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToKeyloggerSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToLlmSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToMalwareSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToPhishingSites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToPornographySites,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToUnallowedDomain,

        [Parameter()]
        [System.Boolean]
        $EpoBrowseToViolenceSites,

        [Parameter()]
        [System.Boolean]
        $EpoCopyToClipboardFromSensitiveFile,

        [Parameter()]
        [System.Boolean]
        $EpoCopyToNetworkShare,

        [Parameter()]
        [System.Boolean]
        $EpoFileArchived,

        [Parameter()]
        [System.Boolean]
        $EpoFileCopiedToRemoteDesktopSession,

        [Parameter()]
        [System.Boolean]
        $EpoFileDeleted,

        [Parameter()]
        [System.Boolean]
        $EpoFileDownloadedFromBlacklistedDomain,

        [Parameter()]
        [System.Boolean]
        $EpoFileDownloadedFromEnterpriseDomain,

        [Parameter()]
        [System.Boolean]
        $EpoFileRenamed,

        [Parameter()]
        [System.Boolean]
        $EpoFileStagedToCentralLocation,

        [Parameter()]
        [System.Boolean]
        $EpoHiddenFileCreated,

        [Parameter()]
        [System.Boolean]
        $EpoRemovableMediaMount,

        [Parameter()]
        [System.Boolean]
        $EpoSensitiveFileRead,

        [Parameter()]
        [System.Boolean]
        $Mcas3rdPartyAppDownload,

        [Parameter()]
        [System.Boolean]
        $Mcas3rdPartyAppFileDelete,

        [Parameter()]
        [System.Boolean]
        $Mcas3rdPartyAppFileSharing,

        [Parameter()]
        [System.Boolean]
        $McasActivityFromInfrequentCountry,

        [Parameter()]
        [System.Boolean]
        $McasImpossibleTravel,

        [Parameter()]
        [System.Boolean]
        $McasMultipleFailedLogins,

        [Parameter()]
        [System.Boolean]
        $McasMultipleStorageDeletion,

        [Parameter()]
        [System.Boolean]
        $McasMultipleVMCreation,

        [Parameter()]
        [System.Boolean]
        $McasMultipleVMDeletion,

        [Parameter()]
        [System.Boolean]
        $McasSuspiciousAdminActivities,

        [Parameter()]
        [System.Boolean]
        $McasSuspiciousCloudCreation,

        [Parameter()]
        [System.Boolean]
        $McasSuspiciousCloudTrailLoggingChange,

        [Parameter()]
        [System.Boolean]
        $McasTerminatedEmployeeActivity,

        [Parameter()]
        [System.Boolean]
        $OdbDownload,

        [Parameter()]
        [System.Boolean]
        $OdbSyncDownload,

        [Parameter()]
        [System.Boolean]
        $PeerCumulativeExfiltrationDetector,

        [Parameter()]
        [System.Boolean]
        $PhysicalAccess,

        [Parameter()]
        [System.Boolean]
        $PotentialHighImpactUser,

        [Parameter()]
        [System.Boolean]
        $Print,

        [Parameter()]
        [System.Boolean]
        $PriorityUserGroupMember,

        [Parameter()]
        [System.Boolean]
        $SecurityAlertDefenseEvasion,

        [Parameter()]
        [System.Boolean]
        $SecurityAlertUnwantedSoftware,

        [Parameter()]
        [System.Boolean]
        $SpoAccessRequest,

        [Parameter()]
        [System.Boolean]
        $SpoApprovedAccess,

        [Parameter()]
        [System.Boolean]
        $SpoDownload,

        [Parameter()]
        [System.Boolean]
        $SpoDownloadV2,

        [Parameter()]
        [System.Boolean]
        $SpoFileAccessed,

        [Parameter()]
        [System.Boolean]
        $SpoFileDeleted,

        [Parameter()]
        [System.Boolean]
        $SpoFileDeletedFromFirstStageRecycleBin,

        [Parameter()]
        [System.Boolean]
        $SpoFileDeletedFromSecondStageRecycleBin,

        [Parameter()]
        [System.Boolean]
        $SpoFileLabelDowngraded,

        [Parameter()]
        [System.Boolean]
        $SpoFileLabelRemoved,

        [Parameter()]
        [System.Boolean]
        $SpoFileSharing,

        [Parameter()]
        [System.Boolean]
        $SpoFolderDeleted,

        [Parameter()]
        [System.Boolean]
        $SpoFolderDeletedFromFirstStageRecycleBin,

        [Parameter()]
        [System.Boolean]
        $SpoFolderDeletedFromSecondStageRecycleBin,

        [Parameter()]
        [System.Boolean]
        $SpoFolderSharing,

        [Parameter()]
        [System.Boolean]
        $SpoSiteExternalUserAdded,

        [Parameter()]
        [System.Boolean]
        $SpoSiteInternalUserAdded,

        [Parameter()]
        [System.Boolean]
        $SpoSiteLabelRemoved,

        [Parameter()]
        [System.Boolean]
        $SpoSiteSharing,

        [Parameter()]
        [System.Boolean]
        $SpoSyncDownload,

        [Parameter()]
        [System.Boolean]
        $TeamsChannelFileSharedExternal,

        [Parameter()]
        [System.Boolean]
        $TeamsChannelMemberAddedExternal,

        [Parameter()]
        [System.Boolean]
        $TeamsChatFileSharedExternal,

        [Parameter()]
        [System.Boolean]
        $TeamsFileDownload,

        [Parameter()]
        [System.Boolean]
        $TeamsFolderSharedExternal,

        [Parameter()]
        [System.Boolean]
        $TeamsMemberAddedExternal,

        [Parameter()]
        [System.Boolean]
        $TeamsSensitiveMessage,

        [Parameter()]
        [System.Boolean]
        $UserHistory,

        [Parameter()]
        [System.Boolean]
        $AWSS3BlockPublicAccessDisabled,

        [Parameter()]
        [System.Boolean]
        $AWSS3BucketDeleted,

        [Parameter()]
        [System.Boolean]
        $AWSS3PublicAccessEnabled,

        [Parameter()]
        [System.Boolean]
        $AWSS3ServerLoggingDisabled,

        [Parameter()]
        [System.Boolean]
        $AzureElevateAccessToAllSubscriptions,

        [Parameter()]
        [System.Boolean]
        $AzureResourceThreatProtectionSettingsUpdated,

        [Parameter()]
        [System.Boolean]
        $AzureSQLServerAuditingSettingsUpdated,

        [Parameter()]
        [System.Boolean]
        $AzureSQLServerFirewallRuleDeleted,

        [Parameter()]
        [System.Boolean]
        $AzureSQLServerFirewallRuleUpdated,

        [Parameter()]
        [System.Boolean]
        $AzureStorageAccountOrContainerDeleted,

        [Parameter()]
        [System.Boolean]
        $BoxContentAccess,

        [Parameter()]
        [System.Boolean]
        $BoxContentDelete,

        [Parameter()]
        [System.Boolean]
        $BoxContentDownload,

        [Parameter()]
        [System.Boolean]
        $BoxContentExternallyShared,

        [Parameter()]
        [System.Boolean]
        $CCFinancialRegulatoryRiskyTextSent,

        [Parameter()]
        [System.Boolean]
        $CCInappropriateContentSent,

        [Parameter()]
        [System.Boolean]
        $CCInappropriateImagesSent,

        [Parameter()]
        [System.Boolean]
        $DropboxContentAccess,

        [Parameter()]
        [System.Boolean]
        $DropboxContentDelete,

        [Parameter()]
        [System.Boolean]
        $DropboxContentDownload,

        [Parameter()]
        [System.Boolean]
        $DropboxContentExternallyShared,

        [Parameter()]
        [System.Boolean]
        $GoogleDriveContentAccess,

        [Parameter()]
        [System.Boolean]
        $GoogleDriveContentDelete,

        [Parameter()]
        [System.Boolean]
        $GoogleDriveContentExternallyShared,

        [Parameter()]
        [System.Boolean]
        $PowerBIDashboardsDeleted,

        [Parameter()]
        [System.Boolean]
        $PowerBIReportsDeleted,

        [Parameter()]
        [System.Boolean]
        $PowerBIReportsDownloaded,

        [Parameter()]
        [System.Boolean]
        $PowerBIReportsExported,

        [Parameter()]
        [System.Boolean]
        $PowerBIReportsViewed,

        [Parameter()]
        [System.Boolean]
        $PowerBISemanticModelsDeleted,

        [Parameter()]
        [System.Boolean]
        $PowerBISensitivityLabelDowngradedForArtifacts,

        [Parameter()]
        [System.Boolean]
        $PowerBISensitivityLabelRemovedFromArtifacts,

        [Parameter()]
        [System.String]
        $HistoricTimeSpan,

        [Parameter()]
        [System.String]
        $InScopeTimeSpan,

        [Parameter()]
        [System.Boolean]
        $EnableTeam,

        [Parameter()]
        [System.Boolean]
        $AnalyticsNewInsightEnabled,

        [Parameter()]
        [System.Boolean]
        $AnalyticsTurnedOffEnabled,

        [Parameter()]
        [System.Boolean]
        $HighSeverityAlertsEnabled,

        [Parameter()]
        [System.String[]]
        $HighSeverityAlertsRoleGroups,

        [Parameter()]
        [System.Boolean]
        $PoliciesHealthEnabled,

        [Parameter()]
        [System.String[]]
        $PoliciesHealthRoleGroups,

        [Parameter()]
        [System.Boolean]
        $NotificationDetailsEnabled,

        [Parameter()]
        [System.String[]]
        $NotificationDetailsRoleGroups,

        [Parameter()]
        [System.Boolean]
        $ClipDeletionEnabled,

        [Parameter()]
        [System.Boolean]
        $SessionRecordingEnabled,

        [Parameter()]
        [System.Boolean]
        $RecordingTimeframePreEventInSec,

        [Parameter()]
        [System.Boolean]
        $RecordingTimeframePostEventInSec,

        [Parameter()]
        [System.Boolean]
        $BandwidthCapInMb,

        [Parameter()]
        [System.Boolean]
        $OfflineRecordingStorageLimitInMb,

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

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).Clone()

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

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

    $ConnectionMode = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
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
        [array] $Script:exportedInstances = Get-InsiderRiskPolicy -ErrorAction Stop

        $dscContent = ''
        $i = 1
        if ($Script:exportedInstances.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $Script:exportedInstances)
        {
            $displayedKey = $config.Name
            Write-Host "    |---[$i/$($Script:exportedInstances.Count)] $displayedKey" -NoNewline
            $params = @{
                Name                  = $config.Name
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
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
