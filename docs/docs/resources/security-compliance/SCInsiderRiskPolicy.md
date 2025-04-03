# SCInsiderRiskPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | Name of the insider risk policy. | |
| **InsiderRiskScenario** | Key | String | Name of the scenario supported by the policy. | |
| **IRASettingsEnabled** | Write | Boolean | When turned on, we'll scan sources in your org (such as the Microsoft 365 audit log) to detect the same activities used by insider risk policies. Scans run daily and provide real-time insights that can help you set up and refine policies to ensure you're detecting the most relevant activities. | |
| **Anonymization** | Write | Boolean | For users who perform activities matching your insider risk policies, decide whether to show their actual names or use pseudonymized versions to mask their identities. | |
| **DLPUserRiskSync** | Write | Boolean | When turned on, admins with the correct permissions will be able to review user risk details from Insider Risk Management within other solutions such as Data Loss Prevention (DLP), Communication Compliance, and user entity pages in Microsoft Defender. | |
| **OptInIRMDataExport** | Write | Boolean | When turned on, admins with the correct permissions will be able to review user risk details from Insider Risk Management within other solutions such as Data Loss Prevention (DLP), Communication Compliance, and user entity pages in Microsoft Defender. | |
| **RaiseAuditAlert** | Write | Boolean | Insider risk management alert information is exportable to security information and event management (SIEM) services by using Office 365 Management Activity APIs. Turn this on to use these APIs to export insider risk alert details to other applications your organization might use to manage or aggregate insider risk data. | |
| **InlineAlertPolicyCustomization** | Write | Boolean | Enable inline alert customization for all alert reviewers. | |
| **FileVolCutoffLimits** | Write | String | Minimum number of daily events to boost score for unusual activity. | |
| **AlertVolume** | Write | String | Alert volume. | |
| **AnomalyDetections** | Write | Boolean | Risk score boosters indicator. | |
| **CopyToPersonalCloud** | Write | Boolean | Official documentation to come. | |
| **CopyToUSB** | Write | Boolean | Device indicator. | |
| **CumulativeExfiltrationDetector** | Write | Boolean | Cumulative exfiltration detection indicator. | |
| **EmailExternal** | Write | Boolean | Official documentation to come. | |
| **EmployeeAccessedEmployeePatientData** | Write | Boolean | Health record access indicator. | |
| **EmployeeAccessedFamilyData** | Write | Boolean | Health record access indicator. | |
| **EmployeeAccessedHighVolumePatientData** | Write | Boolean | Health record access indicator. | |
| **EmployeeAccessedNeighbourData** | Write | Boolean | Health record access indicator. | |
| **EmployeeAccessedRestrictedData** | Write | Boolean | Health record access indicator. | |
| **EpoBrowseToChildAbuseSites** | Write | Boolean | Risky browsing indicator. | |
| **EpoBrowseToCriminalActivitySites** | Write | Boolean | Risky browsing indicator. | |
| **EpoBrowseToCultSites** | Write | Boolean | Risky browsing indicator. | |
| **EpoBrowseToGamblingSites** | Write | Boolean | Risky browsing indicator. | |
| **EpoBrowseToHackingSites** | Write | Boolean | Risky browsing indicator. | |
| **EpoBrowseToHateIntoleranceSites** | Write | Boolean | Risky browsing indicator. | |
| **EpoBrowseToIllegalSoftwareSites** | Write | Boolean | Risky browsing indicator. | |
| **EpoBrowseToKeyloggerSites** | Write | Boolean | Risky browsing indicator. | |
| **EpoBrowseToLlmSites** | Write | Boolean | Risky browsing indicator. | |
| **EpoBrowseToMalwareSites** | Write | Boolean | Risky browsing indicator. | |
| **EpoBrowseToPhishingSites** | Write | Boolean | Risky browsing indicator. | |
| **EpoBrowseToPornographySites** | Write | Boolean | Risky browsing indicator. | |
| **EpoBrowseToUnallowedDomain** | Write | Boolean | Risky browsing indicator. | |
| **EpoBrowseToViolenceSites** | Write | Boolean | Risky browsing indicator. | |
| **EpoCopyToClipboardFromSensitiveFile** | Write | Boolean | Device indicator. | |
| **EpoCopyToNetworkShare** | Write | Boolean | Device indicator. | |
| **EpoFileArchived** | Write | Boolean | Device indicator. | |
| **EpoFileCopiedToRemoteDesktopSession** | Write | Boolean | Device indicator. | |
| **EpoFileDeleted** | Write | Boolean | Device indicator. | |
| **EpoFileDownloadedFromBlacklistedDomain** | Write | Boolean | Device indicator. | |
| **EpoFileDownloadedFromEnterpriseDomain** | Write | Boolean | Device indicator. | |
| **EpoFileRenamed** | Write | Boolean | Device indicator. | |
| **EpoFileStagedToCentralLocation** | Write | Boolean | Device indicator. | |
| **EpoHiddenFileCreated** | Write | Boolean | Device indicator. | |
| **EpoRemovableMediaMount** | Write | Boolean | Device indicator. | |
| **EpoSensitiveFileRead** | Write | Boolean | Device indicator. | |
| **Mcas3rdPartyAppDownload** | Write | Boolean | Microsoft Defender for Cloud Apps indicator. | |
| **Mcas3rdPartyAppFileDelete** | Write | Boolean | Microsoft Defender for Cloud Apps indicator. | |
| **Mcas3rdPartyAppFileSharing** | Write | Boolean | Microsoft Defender for Cloud Apps indicator. | |
| **McasActivityFromInfrequentCountry** | Write | Boolean | Microsoft Defender for Cloud Apps indicator. | |
| **McasImpossibleTravel** | Write | Boolean | Microsoft Defender for Cloud Apps indicator. | |
| **McasMultipleFailedLogins** | Write | Boolean | Microsoft Defender for Cloud Apps indicator. | |
| **McasMultipleStorageDeletion** | Write | Boolean | Microsoft Defender for Cloud Apps indicator. | |
| **McasMultipleVMCreation** | Write | Boolean | Microsoft Defender for Cloud Apps indicator. | |
| **McasMultipleVMDeletion** | Write | Boolean | Microsoft Defender for Cloud Apps indicator. | |
| **McasSuspiciousAdminActivities** | Write | Boolean | Microsoft Defender for Cloud Apps indicator. | |
| **McasSuspiciousCloudCreation** | Write | Boolean | Microsoft Defender for Cloud Apps indicator. | |
| **McasSuspiciousCloudTrailLoggingChange** | Write | Boolean | Microsoft Defender for Cloud Apps indicator. | |
| **McasTerminatedEmployeeActivity** | Write | Boolean | Microsoft Defender for Cloud Apps indicator. | |
| **OdbDownload** | Write | Boolean | Office Indicator. | |
| **OdbSyncDownload** | Write | Boolean | Office Indicator. | |
| **PeerCumulativeExfiltrationDetector** | Write | Boolean | Cumulative exfiltration detection indicator. | |
| **PhysicalAccess** | Write | Boolean | Physical access indicator. | |
| **PotentialHighImpactUser** | Write | Boolean | Risk score boosters indicator. | |
| **Print** | Write | Boolean | Official documentation to come. | |
| **PriorityUserGroupMember** | Write | Boolean | Risk score boosters indicator. | |
| **SecurityAlertDefenseEvasion** | Write | Boolean | Microsoft Defender for Endpoint indicator. | |
| **SecurityAlertUnwantedSoftware** | Write | Boolean | Microsoft Defender for Endpoint indicator. | |
| **SpoAccessRequest** | Write | Boolean | Office Indicator. | |
| **SpoApprovedAccess** | Write | Boolean | Office Indicator. | |
| **SpoDownload** | Write | Boolean | Office Indicator. | |
| **SpoDownloadV2** | Write | Boolean | Office Indicator. | |
| **SpoFileAccessed** | Write | Boolean | Office Indicator. | |
| **SpoFileDeleted** | Write | Boolean | Office Indicator. | |
| **SpoFileDeletedFromFirstStageRecycleBin** | Write | Boolean | Office Indicator. | |
| **SpoFileDeletedFromSecondStageRecycleBin** | Write | Boolean | Office Indicator. | |
| **SpoFileLabelDowngraded** | Write | Boolean | Office Indicator. | |
| **SpoFileLabelRemoved** | Write | Boolean | Office Indicator. | |
| **SpoFileSharing** | Write | Boolean | Office Indicator. | |
| **SpoFolderDeleted** | Write | Boolean | Office Indicator. | |
| **SpoFolderDeletedFromFirstStageRecycleBin** | Write | Boolean | Office Indicator. | |
| **SpoFolderDeletedFromSecondStageRecycleBin** | Write | Boolean | Office Indicator. | |
| **SpoFolderSharing** | Write | Boolean | Office Indicator. | |
| **SpoSiteExternalUserAdded** | Write | Boolean | Office Indicator. | |
| **SpoSiteInternalUserAdded** | Write | Boolean | Office Indicator. | |
| **SpoSiteLabelRemoved** | Write | Boolean | Office Indicator. | |
| **SpoSiteSharing** | Write | Boolean | Office Indicator. | |
| **SpoSyncDownload** | Write | Boolean | Office Indicator. | |
| **TeamsChannelFileSharedExternal** | Write | Boolean | Office Indicator. | |
| **TeamsChannelMemberAddedExternal** | Write | Boolean | Office Indicator. | |
| **TeamsChatFileSharedExternal** | Write | Boolean | Office Indicator. | |
| **TeamsFileDownload** | Write | Boolean | Office Indicator. | |
| **TeamsFolderSharedExternal** | Write | Boolean | Office Indicator. | |
| **TeamsMemberAddedExternal** | Write | Boolean | Office Indicator. | |
| **TeamsSensitiveMessage** | Write | Boolean | Office Indicator. | |
| **UserHistory** | Write | Boolean | Risk score boosters indicator. | |
| **AWSS3BlockPublicAccessDisabled** | Write | Boolean | AWS indicator. | |
| **AWSS3BucketDeleted** | Write | Boolean | AWS indicator. | |
| **AWSS3PublicAccessEnabled** | Write | Boolean | AWS indicator. | |
| **AWSS3ServerLoggingDisabled** | Write | Boolean | AWS indicator. | |
| **AzureElevateAccessToAllSubscriptions** | Write | Boolean | Azure indicator. | |
| **AzureResourceThreatProtectionSettingsUpdated** | Write | Boolean | Azure indicator. | |
| **AzureSQLServerAuditingSettingsUpdated** | Write | Boolean | Azure indicator. | |
| **AzureSQLServerFirewallRuleDeleted** | Write | Boolean | Azure indicator. | |
| **AzureSQLServerFirewallRuleUpdated** | Write | Boolean | Azure indicator. | |
| **AzureStorageAccountOrContainerDeleted** | Write | Boolean | Azure indicator. | |
| **BoxContentAccess** | Write | Boolean | Box indicator. | |
| **BoxContentDelete** | Write | Boolean | Box indicator. | |
| **BoxContentDownload** | Write | Boolean | Box indicator. | |
| **BoxContentExternallyShared** | Write | Boolean | Box indicator. | |
| **CCFinancialRegulatoryRiskyTextSent** | Write | Boolean | Detect messages matching specific trainable classifiers. | |
| **CCInappropriateContentSent** | Write | Boolean | Detect messages matching specific trainable classifiers. | |
| **CCInappropriateImagesSent** | Write | Boolean | Detect messages matching specific trainable classifiers. | |
| **DropboxContentAccess** | Write | Boolean | Dropbox indicator. | |
| **DropboxContentDelete** | Write | Boolean | Dropbox indicator. | |
| **DropboxContentDownload** | Write | Boolean | Dropbox indicator. | |
| **DropboxContentExternallyShared** | Write | Boolean | Dropbox indicator. | |
| **GoogleDriveContentAccess** | Write | Boolean | Google Drive indicator. | |
| **GoogleDriveContentDelete** | Write | Boolean | Google Drive indicator. | |
| **GoogleDriveContentExternallyShared** | Write | Boolean | Google Drive indicator. | |
| **PowerBIDashboardsDeleted** | Write | Boolean | Power BI indicator. | |
| **PowerBIReportsDeleted** | Write | Boolean | Power BI indicator. | |
| **PowerBIReportsDownloaded** | Write | Boolean | Power BI indicator. | |
| **PowerBIReportsExported** | Write | Boolean | Power BI indicator. | |
| **PowerBIReportsViewed** | Write | Boolean | Power BI indicator. | |
| **PowerBISemanticModelsDeleted** | Write | Boolean | Power BI indicator. | |
| **PowerBISensitivityLabelDowngradedForArtifacts** | Write | Boolean | Power BI indicator. | |
| **PowerBISensitivityLabelRemovedFromArtifacts** | Write | Boolean | Power BI indicator. | |
| **HistoricTimeSpan** | Write | String | Determines how far back a policy should go to detect user activity and is triggered when a user performs the first activity matching a policy. | |
| **InScopeTimeSpan** | Write | String | Determines how long policies will actively detect activity for users and is triggered when a user performs the first activity matching a policy. | |
| **EnableTeam** | Write | Boolean | Integrate Microsoft Teams capabilities with insider risk case management to enhance collaboration with stakeholders.  | |
| **AnalyticsNewInsightEnabled** | Write | Boolean | Send a monthly email summarizing new analytics scan insights. | |
| **AnalyticsTurnedOffEnabled** | Write | Boolean | Send an email when analytics is turned off for your organization. | |
| **HighSeverityAlertsEnabled** | Write | Boolean | Send a daily email when new high severity alerts are generated. | |
| **HighSeverityAlertsRoleGroups** | Write | StringArray[] | Specifies the groups of high severity alerts to include. Possible values are: InsiderRiskManagement, InsiderRiskManagementAnalysts, and InsiderRiskManagementInvestigators. | |
| **PoliciesHealthEnabled** | Write | Boolean | Send a weekly email summarizing policies that have unresolved warnings. | |
| **PoliciesHealthRoleGroups** | Write | StringArray[] | Specifies the groups to notify with weekly email. Possible values are: InsiderRiskManagement and InsiderRiskManagementAdmins. | |
| **NotificationDetailsEnabled** | Write | Boolean | Send a notification email when the first alert is generated for a new policy. | |
| **NotificationDetailsRoleGroups** | Write | StringArray[] | Specifies the groups to notify when the first alert is generated. Possible values are: InsiderRiskManagement, InsiderRiskManagementAnalysts, and InsiderRiskManagementInvestigators. | |
| **ClipDeletionEnabled** | Write | Boolean | Official documentation to come. | |
| **SessionRecordingEnabled** | Write | Boolean | Official documentation to come. | |
| **RecordingTimeframePreEventInSec** | Write | String | Official documentation to come. | |
| **RecordingTimeframePostEventInSec** | Write | String | Official documentation to come. | |
| **BandwidthCapInMb** | Write | String | Official documentation to come. | |
| **OfflineRecordingStorageLimitInMb** | Write | String | Official documentation to come. | |
| **AdaptiveProtectionEnabled** | Write | Boolean | Determines if Adaptive Protection is enabled for Purview. | |
| **AdaptiveProtectionHighProfileSourceType** | Write | UInt32 | Official documentation to come. | |
| **AdaptiveProtectionHighProfileConfirmedIssueSeverity** | Write | UInt32 | Official documentation to come. | |
| **AdaptiveProtectionHighProfileGeneratedIssueSeverity** | Write | UInt32 | Official documentation to come. | |
| **AdaptiveProtectionHighProfileInsightSeverity** | Write | UInt32 | Official documentation to come. | |
| **AdaptiveProtectionHighProfileInsightCount** | Write | UInt32 | Official documentation to come. | |
| **AdaptiveProtectionHighProfileInsightTypes** | Write | StringArray[] | Official documentation to come. | |
| **AdaptiveProtectionHighProfileConfirmedIssue** | Write | Boolean | Official documentation to come. | |
| **AdaptiveProtectionMediumProfileSourceType** | Write | UInt32 | Official documentation to come. | |
| **AdaptiveProtectionMediumProfileConfirmedIssueSeverity** | Write | UInt32 | Official documentation to come. | |
| **AdaptiveProtectionMediumProfileGeneratedIssueSeverity** | Write | UInt32 | Official documentation to come. | |
| **AdaptiveProtectionMediumProfileInsightSeverity** | Write | UInt32 | Official documentation to come. | |
| **AdaptiveProtectionMediumProfileInsightCount** | Write | UInt32 | Official documentation to come. | |
| **AdaptiveProtectionMediumProfileInsightTypes** | Write | StringArray[] | Official documentation to come. | |
| **AdaptiveProtectionMediumProfileConfirmedIssue** | Write | Boolean | Official documentation to come. | |
| **AdaptiveProtectionLowProfileSourceType** | Write | UInt32 | Official documentation to come. | |
| **AdaptiveProtectionLowProfileConfirmedIssueSeverity** | Write | UInt32 | Official documentation to come. | |
| **AdaptiveProtectionLowProfileGeneratedIssueSeverity** | Write | UInt32 | Official documentation to come. | |
| **AdaptiveProtectionLowProfileInsightSeverity** | Write | UInt32 | Official documentation to come. | |
| **AdaptiveProtectionLowProfileInsightCount** | Write | UInt32 | Official documentation to come. | |
| **AdaptiveProtectionLowProfileInsightTypes** | Write | StringArray[] | Official documentation to come. | |
| **AdaptiveProtectionLowProfileConfirmedIssue** | Write | Boolean | Official documentation to come. | |
| **RetainSeverityAfterTriage** | Write | Boolean | Official documentation to come. | |
| **LookbackTimeSpan** | Write | UInt32 | Official documentation to come. | |
| **ProfileInScopeTimeSpan** | Write | UInt32 | Official documentation to come. | |
| **GPUUtilizationLimit** | Write | UInt32 | Official documentation to come. | |
| **CPUUtilizationLimit** | Write | UInt32 | Official documentation to come. | |
| **MDATPTriageStatus** | Write | StringArray[] | Microsoft Defender for Endpoint alert statuses. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Absent`, `Present` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Configures Insider Risk Policies in Purview.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - None

- **Update**

    - None

#### Application permissions

- **Read**

    - None

- **Update**

    - None

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
            TeamsChatFileSharedExternal                   = $True; # Drift
            TeamsFileDownload                             = $False;
            TeamsFolderSharedExternal                     = $False;
            TeamsMemberAddedExternal                      = $False;
            TeamsSensitiveMessage                         = $False;
            TenantId                                      = $TenantId;
            UserHistory                                   = $False;
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
        SCInsiderRiskPolicy "SCInsiderRiskPolicy-IRM_Tenant_Setting"
        {
            ApplicationId                                 = $ApplicationId;
            CertificateThumbprint                         = $CertificateThumbprint;
            Ensure                                        = "Absent";
            InsiderRiskScenario                           = "TenantSetting";
            Name                                          = "IRM_Tenant_Setting";
            TenantId                                      = $TenantId;
        }
    }
}
```

