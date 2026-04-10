<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

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
        SCInsiderRiskPolicy "SCInsiderRiskPolicy-IRM_Tenant_Setting"
        {
            Anonymization = $false
            AlertVolume                                   = "Medium";
            AnalyticsNewInsightEnabled                    = $False;
            AnalyticsTurnedOffEnabled                     = $False;
            AnomalyDetections                             = $False;
            ApplicationId                                 = $ApplicationId;
            AWSS3BlockPublicAccessDisabled                = $False;
            AWSS3BucketDeleted                            = $False;
            AWSS3PublicAccessEnabled                      = $False;
            AWSS3ServerLoggingDisabled                    = $False;
            AzureElevateAccessToAllSubscriptions          = $False;
            AzureResourceThreatProtectionSettingsUpdated  = $False;
            AzureSQLServerAuditingSettingsUpdated         = $False;
            AzureSQLServerFirewallRuleDeleted             = $False;
            AzureSQLServerFirewallRuleUpdated             = $False;
            AzureStorageAccountOrContainerDeleted         = $False;
            BoxContentAccess                              = $False;
            BoxContentDelete                              = $False;
            BoxContentDownload                            = $False;
            BoxContentExternallyShared                    = $False;
            CCFinancialRegulatoryRiskyTextSent            = $False;
            CCInappropriateContentSent                    = $False;
            CCInappropriateImagesSent                     = $False;
            CertificateThumbprint                         = $CertificateThumbprint;
            CopyToPersonalCloud                           = $False;
            CopyToUSB                                     = $False;
            CumulativeExfiltrationDetector                = $True;
            DLPUserRiskSync                               = $True;
            DropboxContentAccess                          = $False;
            DropboxContentDelete                          = $False;
            DropboxContentDownload                        = $False;
            DropboxContentExternallyShared                = $False;
            EmailExternal                                 = $False;
            EmployeeAccessedEmployeePatientData           = $False;
            EmployeeAccessedFamilyData                    = $False;
            EmployeeAccessedHighVolumePatientData         = $False;
            EmployeeAccessedNeighbourData                 = $False;
            EmployeeAccessedRestrictedData                = $False;
            EnableTeam                                    = $True;
            Ensure                                        = "Present";
            EpoBrowseToChildAbuseSites                    = $False;
            EpoBrowseToCriminalActivitySites              = $False;
            EpoBrowseToCultSites                          = $False;
            EpoBrowseToGamblingSites                      = $False;
            EpoBrowseToHackingSites                       = $False;
            EpoBrowseToHateIntoleranceSites               = $False;
            EpoBrowseToIllegalSoftwareSites               = $False;
            EpoBrowseToKeyloggerSites                     = $False;
            EpoBrowseToLlmSites                           = $False;
            EpoBrowseToMalwareSites                       = $False;
            EpoBrowseToPhishingSites                      = $False;
            EpoBrowseToPornographySites                   = $False;
            EpoBrowseToUnallowedDomain                    = $False;
            EpoBrowseToViolenceSites                      = $False;
            EpoCopyToClipboardFromSensitiveFile           = $False;
            EpoCopyToNetworkShare                         = $False;
            EpoFileArchived                               = $False;
            EpoFileCopiedToRemoteDesktopSession           = $False;
            EpoFileDeleted                                = $False;
            EpoFileDownloadedFromBlacklistedDomain        = $False;
            EpoFileDownloadedFromEnterpriseDomain         = $False;
            EpoFileRenamed                                = $False;
            EpoFileStagedToCentralLocation                = $False;
            EpoHiddenFileCreated                          = $False;
            EpoRemovableMediaMount                        = $False;
            EpoSensitiveFileRead                          = $False;
            FileVolCutoffLimits                           = "59";
            GoogleDriveContentAccess                      = $False;
            GoogleDriveContentDelete                      = $False;
            GoogleDriveContentExternallyShared            = $False;
            HistoricTimeSpan                              = "89";
            InScopeTimeSpan                               = "30";
            InsiderRiskScenario                           = "TenantSetting";
            Mcas3rdPartyAppDownload                       = $False;
            Mcas3rdPartyAppFileDelete                     = $False;
            Mcas3rdPartyAppFileSharing                    = $False;
            McasActivityFromInfrequentCountry             = $False;
            McasImpossibleTravel                          = $False;
            McasMultipleFailedLogins                      = $False;
            McasMultipleStorageDeletion                   = $False;
            McasMultipleVMCreation                        = $True;
            McasMultipleVMDeletion                        = $False;
            McasSuspiciousAdminActivities                 = $False;
            McasSuspiciousCloudCreation                   = $False;
            McasSuspiciousCloudTrailLoggingChange         = $False;
            McasTerminatedEmployeeActivity                = $False;
            Name                                          = "IRM_Tenant_Setting";
            NotificationDetailsEnabled                    = $True;
            OdbDownload                                   = $False;
            OdbSyncDownload                               = $False;
            OptInIRMDataExport                            = $True;
            PeerCumulativeExfiltrationDetector            = $False;
            PhysicalAccess                                = $False;
            PotentialHighImpactUser                       = $False;
            PowerBIDashboardsDeleted                      = $False;
            PowerBIReportsDeleted                         = $False;
            PowerBIReportsDownloaded                      = $False;
            PowerBIReportsExported                        = $False;
            PowerBIReportsViewed                          = $False;
            PowerBISemanticModelsDeleted                  = $False;
            PowerBISensitivityLabelDowngradedForArtifacts = $False;
            PowerBISensitivityLabelRemovedFromArtifacts   = $False;
            Print                                         = $False;
            PriorityUserGroupMember                       = $False;
            RaiseAuditAlert                               = $True;
            SecurityAlertDefenseEvasion                   = $False;
            SecurityAlertUnwantedSoftware                 = $False;
            SpoAccessRequest                              = $False;
            SpoApprovedAccess                             = $False;
            SpoDownload                                   = $False;
            SpoDownloadV2                                 = $False;
            SpoFileAccessed                               = $False;
            SpoFileDeleted                                = $False;
            SpoFileDeletedFromFirstStageRecycleBin        = $False;
            SpoFileDeletedFromSecondStageRecycleBin       = $False;
            SpoFileLabelDowngraded                        = $False;
            SpoFileLabelRemoved                           = $False;
            SpoFileSharing                                = $True;
            SpoFolderDeleted                              = $False;
            SpoFolderDeletedFromFirstStageRecycleBin      = $False;
            SpoFolderDeletedFromSecondStageRecycleBin     = $False;
            SpoFolderSharing                              = $False;
            SpoSiteExternalUserAdded                      = $False;
            SpoSiteInternalUserAdded                      = $False;
            SpoSiteLabelRemoved                           = $False;
            SpoSiteSharing                                = $False;
            SpoSyncDownload                               = $False;
            TeamsChannelFileSharedExternal                = $False;
            TeamsChannelMemberAddedExternal               = $False;
            TeamsChatFileSharedExternal                   = $False;
            TeamsFileDownload                             = $False;
            TeamsFolderSharedExternal                     = $False;
            TeamsMemberAddedExternal                      = $False;
            TeamsSensitiveMessage                         = $False;
            TenantId                                      = $TenantId;
            UserHistory                                   = $False;
        }
    }
}
