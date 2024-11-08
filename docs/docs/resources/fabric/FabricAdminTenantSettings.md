# FabricAdminTenantSettings

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Specifies the resource is a single instance, the value must be 'Yes'. | `Yes` |
| **AADSSOForGateway** | Write | MSFT_FabricTenantSetting | Microsoft Entra single sign-on for data gateway | |
| **AdminApisIncludeDetailedMetadata** | Write | MSFT_FabricTenantSetting | Enhance admin APIs responses with detailed metadata | |
| **AdminApisIncludeExpressions** | Write | MSFT_FabricTenantSetting | Enhance admin APIs responses with DAX and mashup expressions | |
| **AdminCustomDisclaimer** | Write | MSFT_FabricTenantSetting | Show a custom message before publishing reports | |
| **AISkillArtifactTenantSwitch** | Write | MSFT_FabricTenantSetting | Users can create and share AI skill item types (preview) | |
| **AllowAccessOverPrivateLinks** | Write | MSFT_FabricTenantSetting | Azure Private Link | |
| **AllowCVAuthenticationTenant** | Write | MSFT_FabricTenantSetting | AppSource Custom Visuals SSO | |
| **AllowCVLocalStorageV2Tenant** | Write | MSFT_FabricTenantSetting | Allow access to the browser's local storage | |
| **AllowCVToExportDataToFileTenant** | Write | MSFT_FabricTenantSetting | Allow downloads from custom visuals | |
| **AllowEndorsementMasterDataSwitch** | Write | MSFT_FabricTenantSetting | Endorse master data (preview) | |
| **AllowExternalDataSharingReceiverSwitch** | Write | MSFT_FabricTenantSetting | Users can accept external data shares (preview) | |
| **AllowExternalDataSharingSwitch** | Write | MSFT_FabricTenantSetting | External data sharing (preview) | |
| **AllowFreeTrial** | Write | MSFT_FabricTenantSetting | Users can try Microsoft Fabric paid features | |
| **AllowGuestLookup** | Write | MSFT_FabricTenantSetting | Users can see guest users in lists of suggested people | |
| **AllowGuestUserToAccessSharedContent** | Write | MSFT_FabricTenantSetting | Guest users can access Microsoft Fabric | |
| **AllowPowerBIASDQOnTenant** | Write | MSFT_FabricTenantSetting | Allow DirectQuery connections to Power BI semantic models | |
| **AllowSendAOAIDataToOtherRegions** | Write | MSFT_FabricTenantSetting | Data sent to Azure OpenAI can be processed outside your capacity's geographic region, compliance boundary, or national cloud instance | |
| **AllowSendNLToDaxDataToOtherRegions** | Write | MSFT_FabricTenantSetting | Allow user data to leave their geography | |
| **AllowServicePrincipalsCreateAndUseProfiles** | Write | MSFT_FabricTenantSetting | Allow service principals to create and use profiles | |
| **AllowServicePrincipalsUseReadAdminAPIs** | Write | MSFT_FabricTenantSetting | Service principals can access read-only admin APIs | |
| **AppPush** | Write | MSFT_FabricTenantSetting | Push apps to end users | |
| **ArtifactSearchTenant** | Write | MSFT_FabricTenantSetting | Use global search for Power BI | |
| **ASCollectQueryTextTelemetryTenantSwitch** | Write | MSFT_FabricTenantSetting | Microsoft can store query text to aid in support investigations | |
| **ASShareableCloudConnectionBindingSecurityModeTenant** | Write | MSFT_FabricTenantSetting | Enable granular access control for all data connections | |
| **ASWritethruContinuousExportTenantSwitch** | Write | MSFT_FabricTenantSetting | Semantic models can export data to OneLake (preview) | |
| **ASWritethruTenantSwitch** | Write | MSFT_FabricTenantSetting | Users can store semantic model tables in OneLake (preview) | |
| **AutoInstallPowerBIAppInTeamsTenant** | Write | MSFT_FabricTenantSetting | Install Power BI app for Microsoft Teams automatically | |
| **AutomatedInsightsEntryPoints** | Write | MSFT_FabricTenantSetting | Show entry points for insights (preview) | |
| **AutomatedInsightsTenant** | Write | MSFT_FabricTenantSetting | Receive notifications for top insights (preview) | |
| **AzureMap** | Write | MSFT_FabricTenantSetting | Use Azure Maps visual | |
| **BingMap** | Write | MSFT_FabricTenantSetting | Map and filled map visuals | |
| **BlockAccessFromPublicNetworks** | Write | MSFT_FabricTenantSetting | Block Public Internet Access | |
| **BlockAutoDiscoverAndPackageRefresh** | Write | MSFT_FabricTenantSetting | Block republish and disable package refresh | |
| **BlockProtectedLabelSharingToEntireOrg** | Write | MSFT_FabricTenantSetting | Restrict content with protected labels from being shared via link with everyone in your organization | |
| **BlockResourceKeyAuthentication** | Write | MSFT_FabricTenantSetting | Block ResourceKey Authentication | |
| **CDSAManagement** | Write | MSFT_FabricTenantSetting | Create and use Gen1 dataflows | |
| **CertifiedCustomVisualsTenant** | Write | MSFT_FabricTenantSetting | Add and use certified visuals only (block uncertified) | |
| **CertifyDatasets** | Write | MSFT_FabricTenantSetting | Certification | |
| **ConfigureFolderRetentionPeriod** | Write | MSFT_FabricTenantSetting | Define workspace retention period | |
| **CreateAppWorkspaces** | Write | MSFT_FabricTenantSetting | Create workspaces | |
| **CustomVisualsTenant** | Write | MSFT_FabricTenantSetting | Allow visuals created using the Power BI SDK | |
| **DatamartTenant** | Write | MSFT_FabricTenantSetting | Create Datamarts (preview) | |
| **DatasetExecuteQueries** | Write | MSFT_FabricTenantSetting | Semantic Model Execute Queries REST API | |
| **DevelopServiceApps** | Write | MSFT_FabricTenantSetting | Publish template apps | |
| **DiscoverDatasetsConsumption** | Write | MSFT_FabricTenantSetting | Discover content | |
| **DiscoverDatasetsSettingsCertified** | Write | MSFT_FabricTenantSetting | Make certified content discoverable  | |
| **DiscoverDatasetsSettingsPromoted** | Write | MSFT_FabricTenantSetting | Make promoted content discoverable | |
| **DremioSSO** | Write | MSFT_FabricTenantSetting | Dremio SSO | |
| **EimInformationProtectionDataSourceInheritanceSetting** | Write | MSFT_FabricTenantSetting | Apply sensitivity labels from data sources to their data in Power BI | |
| **EimInformationProtectionDownstreamInheritanceSetting** | Write | MSFT_FabricTenantSetting | Automatically apply sensitivity labels to downstream content | |
| **EimInformationProtectionEdit** | Write | MSFT_FabricTenantSetting | Allow users to apply sensitivity labels for content | |
| **EimInformationProtectionLessElevated** | Write | MSFT_FabricTenantSetting | Increase the number of users who can edit and republish encrypted PBIX files (preview) | |
| **EimInformationProtectionWorkspaceAdminsOverrideAutomaticLabelsSetting** | Write | MSFT_FabricTenantSetting | Allow workspace admins to override automatically applied sensitivity labels | |
| **ElevatedGuestsTenant** | Write | MSFT_FabricTenantSetting | Guest users can browse and access Fabric content | |
| **EmailSecurityGroupsOnOutage** | Write | MSFT_FabricTenantSetting | Receive email notifications for service outages or incidents | |
| **EmailSubscriptionsToB2BUsers** | Write | MSFT_FabricTenantSetting | Guest users can set up and subscribe to email subscriptions | |
| **EmailSubscriptionsToExternalUsers** | Write | MSFT_FabricTenantSetting | Users can send email subscriptions to guest users | |
| **EmailSubscriptionTenant** | Write | MSFT_FabricTenantSetting | Users can set up email subscriptions | |
| **Embedding** | Write | MSFT_FabricTenantSetting | Embed content in apps | |
| **EnableAOAI** | Write | MSFT_FabricTenantSetting | Users can use Copilot and other features powered by Azure OpenAI | |
| **EnableDatasetInPlaceSharing** | Write | MSFT_FabricTenantSetting | Allow specific users to turn on external data sharing | |
| **EnableExcelYellowIntegration** | Write | MSFT_FabricTenantSetting | Allow connections to featured tables | |
| **EnableFabricAirflow** | Write | MSFT_FabricTenantSetting | Users can create and use data workflows (preview) | |
| **EnableNLToDax** | Write | MSFT_FabricTenantSetting | Allow quick measure suggestions (preview) | |
| **EnableReassignDataDomainSwitch** | Write | MSFT_FabricTenantSetting | Allow tenant and domain admins to override workspace assignments (preview) | |
| **EsriVisual** | Write | MSFT_FabricTenantSetting | Use ArcGIS Maps for Power BI | |
| **ExpFlightingTenant** | Write | MSFT_FabricTenantSetting | Help Power BI optimize your experience | |
| **ExportReport** | Write | MSFT_FabricTenantSetting | Download reports | |
| **ExportToCsv** | Write | MSFT_FabricTenantSetting | Export to .csv | |
| **ExportToExcelSetting** | Write | MSFT_FabricTenantSetting | Export to Excel | |
| **ExportToImage** | Write | MSFT_FabricTenantSetting | Export reports as image files | |
| **ExportToMHTML** | Write | MSFT_FabricTenantSetting | Export reports as MHTML documents | |
| **ExportToPowerPoint** | Write | MSFT_FabricTenantSetting | Export reports as PowerPoint presentations or PDF documents | |
| **ExportToWord** | Write | MSFT_FabricTenantSetting | Export reports as Word documents | |
| **ExportToXML** | Write | MSFT_FabricTenantSetting | Export reports as XML documents | |
| **ExportVisualImageTenant** | Write | MSFT_FabricTenantSetting | Copy and paste visuals | |
| **ExternalDatasetSharingTenant** | Write | MSFT_FabricTenantSetting | Guest users can work with shared semantic models in their own tenants | |
| **ExternalSharingV2** | Write | MSFT_FabricTenantSetting | Users can invite guest users to collaborate through item sharing and permissions | |
| **FabricAddPartnerWorkload** | Write | MSFT_FabricTenantSetting | Capacity admins and contributors can add and remove additional workloads | |
| **FabricFeedbackTenantSwitch** | Write | MSFT_FabricTenantSetting | Product Feedback | |
| **FabricGAWorkloads** | Write | MSFT_FabricTenantSetting | Users can create Fabric items | |
| **FabricThirdPartyWorkloads** | Write | MSFT_FabricTenantSetting | Capacity admins can develop additional workloads | |
| **GitHubTenantSettings** | Write | MSFT_FabricTenantSetting | Users can sync workspace items with GitHub repositories  | |
| **GitIntegrationCrossGeoTenantSwitch** | Write | MSFT_FabricTenantSetting | Users can export items to Git repositories in other geographical locations (preview) | |
| **GitIntegrationSensitivityLabelsTenantSwitch** | Write | MSFT_FabricTenantSetting | Users can export workspace items with applied sensitivity labels to Git repositories (preview) | |
| **GitIntegrationTenantSwitch** | Write | MSFT_FabricTenantSetting | Users can synchronize workspace items with their Git repositories (preview) | |
| **GoogleBigQuerySSO** | Write | MSFT_FabricTenantSetting | Google BigQuery SSO | |
| **GraphQLTenant** | Write | MSFT_FabricTenantSetting | API for GraphQL (preview) | |
| **HealthcareSolutionsTenantSwitch** | Write | MSFT_FabricTenantSetting | Healthcare data solutions (preview) | |
| **InstallNonvalidatedTemplateApps** | Write | MSFT_FabricTenantSetting | Install template apps not listed in AppSource | |
| **InstallServiceApps** | Write | MSFT_FabricTenantSetting | Install template apps | |
| **KustoDashboardTenantSwitch** | Write | MSFT_FabricTenantSetting | Users can create Real-Time Dashboards (preview) | |
| **LiveConnection** | Write | MSFT_FabricTenantSetting | Users can work with semantic models in Excel using a live connection | |
| **LogAnalyticsAttachForWorkspaceAdmins** | Write | MSFT_FabricTenantSetting | Azure Log Analytics connections for workspace administrators | |
| **M365DataSharing** | Write | MSFT_FabricTenantSetting | Users can see Microsoft Fabric metadata in Microsoft 365 | |
| **Mirroring** | Write | MSFT_FabricTenantSetting | Database Mirroring (preview) | |
| **ODSPRefreshEnforcementTenantAllowAutomaticUpdate** | Write | MSFT_FabricTenantSetting | Semantic model owners can choose to automatically update semantic models from files imported from OneDrive or SharePoint | |
| **OneDriveSharePointAllowSharingTenantSetting** | Write | MSFT_FabricTenantSetting | Users can share links to Power BI files stored in OneDrive and SharePoint through Power BI Desktop (preview) | |
| **OneDriveSharePointViewerIntegrationTenantSettingV2** | Write | MSFT_FabricTenantSetting | Users can view Power BI files saved in OneDrive and SharePoint (preview) | |
| **OneLakeFileExplorer** | Write | MSFT_FabricTenantSetting | Users can sync data in OneLake with the OneLake File Explorer app | |
| **OneLakeForThirdParty** | Write | MSFT_FabricTenantSetting | Users can access data stored in OneLake with apps external to Fabric | |
| **OnPremAnalyzeInExcel** | Write | MSFT_FabricTenantSetting | Allow XMLA endpoints and Analyze in Excel with on-premises semantic models | |
| **PowerBIGoalsTenant** | Write | MSFT_FabricTenantSetting | Create and use Metrics | |
| **PowerPlatformSolutionsIntegrationTenant** | Write | MSFT_FabricTenantSetting | Power Platform Solutions Integration (preview) | |
| **Printing** | Write | MSFT_FabricTenantSetting | Print dashboards and reports | |
| **PromoteContent** | Write | MSFT_FabricTenantSetting | Featured content | |
| **PublishContentPack** | Write | MSFT_FabricTenantSetting | Publish apps to the entire organization | |
| **PublishToWeb** | Write | MSFT_FabricTenantSetting | Publish to web | |
| **QnaFeedbackLoop** | Write | MSFT_FabricTenantSetting | Review questions | |
| **QnaLsdlSharing** | Write | MSFT_FabricTenantSetting | Synonym sharing | |
| **QueryScaleOutTenant** | Write | MSFT_FabricTenantSetting | Scale out queries for large semantic models | |
| **RedshiftSSO** | Write | MSFT_FabricTenantSetting | Redshift SSO | |
| **RestrictMyFolderCapacity** | Write | MSFT_FabricTenantSetting | Block users from reassigning personal workspaces (My Workspace) | |
| **RetailSolutionsTenantSwitch** | Write | MSFT_FabricTenantSetting | Retail data solutions (preview)  | |
| **RScriptVisual** | Write | MSFT_FabricTenantSetting | Interact with and share R and Python visuals | |
| **ServicePrincipalAccess** | Write | MSFT_FabricTenantSetting | Service principals can use Fabric APIs | |
| **ShareLinkToEntireOrg** | Write | MSFT_FabricTenantSetting | Allow shareable links to grant access to everyone in your organization | |
| **ShareToTeamsTenant** | Write | MSFT_FabricTenantSetting | Enable Microsoft Teams integration | |
| **SnowflakeSSO** | Write | MSFT_FabricTenantSetting | Snowflake SSO | |
| **StorytellingTenant** | Write | MSFT_FabricTenantSetting | Enable Power BI add-in for PowerPoint | |
| **SustainabilitySolutionsTenantSwitch** | Write | MSFT_FabricTenantSetting | Sustainability solutions (preview) | |
| **TemplatePublish** | Write | MSFT_FabricTenantSetting | Create template organizational apps | |
| **TenantSettingPublishGetHelpInfo** | Write | MSFT_FabricTenantSetting | Publish Get Help information | |
| **TridentPrivatePreview** | Write | MSFT_FabricTenantSetting | Data Activator (preview) | |
| **UsageMetrics** | Write | MSFT_FabricTenantSetting | Usage metrics for content creators | |
| **UsageMetricsTrackUserLevelInfo** | Write | MSFT_FabricTenantSetting | Per-user data in usage metrics for content creators | |
| **UseDatasetsAcrossWorkspaces** | Write | MSFT_FabricTenantSetting | Use semantic models across workspaces | |
| **VisualizeListInPowerBI** | Write | MSFT_FabricTenantSetting | Integration with SharePoint and Microsoft Lists | |
| **WebContentTilesTenant** | Write | MSFT_FabricTenantSetting | Web content on dashboard tiles | |
| **WebModelingTenantSwitch** | Write | MSFT_FabricTenantSetting | Users can edit data models in the Power BI service (preview) | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_FabricDelegatedFrom

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Capacity** | Write | String | The setting is delegated from a capacity. | |
| **Domain** | Write | String | The setting is delegated from a domain. | |
| **Tenant** | Write | String | The setting is delegated from a tenant. | |

### MSFT_FabricTenantSettingProperty

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **name** | Write | String | The name of the property. | |
| **type** | Write | String | The type of the property. | |
| **value** | Write | String | The value of the property. | |

### MSFT_FabricTenantSetting

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **canSpecifySecurityGroups** | Write | Boolean | Indicates if the tenant setting is enabled for a security group. 0 - The tenant setting is enabled for the entire organization. | |
| **delegateToWorkspace** | Write | Boolean | Indicates whether the tenant setting can be delegated to a workspace admin. False - Workspace admin cannot override the tenant setting. | |
| **delegatedFrom** | Write | MSFT_FabricDelegatedFrom | Tenant setting delegated from tenant, capacity or domain. | |
| **settingName** | Write | String | The name of the tenant setting. | |
| **enabled** | Write | Boolean | The status of the tenant setting. | |
| **tenantSettingGroup** | Write | String | Tenant setting group name. | |
| **title** | Write | String | The title of the tenant setting. | |
| **properties** | Write | MSFT_FabricTenantSettingProperty[] | Tenant setting properties. | |
| **excludedSecurityGroups** | Write | StringArray[] | A list of excluded security groups. | |
| **enabledSecurityGroups** | Write | StringArray[] | A list of enabled security groups. | |


## Description

This resource configures the tenant settings for Microsoft Fabric.

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
        FabricAdminTenantSettings "FabricAdminTenantSettings"
        {
            IsSingleInstance = 'Yes'
            AADSSOForGateway                                                      = MSFT_FabricTenantSetting {
                settingName              = 'AADSSOForGateway'
                canSpecifySecurityGroups = $False
                enabled                  = $True
                tenantSettingGroup       = 'Integration settings'
                title                    = 'Microsoft Entra single sign-on for data gateway'
            };
            AdminApisIncludeDetailedMetadata                                      = MSFT_FabricTenantSetting {
                settingName              = 'AdminApisIncludeDetailedMetadata'
                canSpecifySecurityGroups = $True
                enabled                  = $True
                tenantSettingGroup       = 'Admin API settings'
                title                    = 'Enhance admin APIs responses with detailed metadata'
                excludedSecurityGroups   = @('MyExcludedGroup')
                enabledSecurityGroups    = @('Group1','Group2')
            };
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
```

