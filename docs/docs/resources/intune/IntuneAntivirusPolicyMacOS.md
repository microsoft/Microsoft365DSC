# IntuneAntivirusPolicyMacOS

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Description** | Write | String | Policy description | |
| **DisplayName** | Key | String | Policy name | |
| **RoleScopeTagIds** | Write | StringArray[] | List of Scope Tags for this Entity instance. | |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |
| **enabled** | Write | String | Enable / disable cloud delivered protection (false: Disabled, true: Enabled) | `false`, `true` |
| **automaticSampleSubmission** | Write | String | Enable / disable automatic sample submissions (false: Disabled, true: Enabled) | `false`, `true` |
| **diagnosticLevel** | Write | String | Diagnostic collection level (0: optional, 1: required) | `0`, `1` |
| **automaticDefinitionUpdateEnabled** | Write | String | Automatic security intelligence updates (false: Disabled, true: Enabled) | `false`, `true` |
| **enableRealTimeProtection** | Write | String | Enable real-time protection (deprecated) (false: Disabled, true: Enabled) | `false`, `true` |
| **passiveMode** | Write | String | Enable passive mode (deprecated) (false: Disabled, true: Enabled) | `false`, `true` |
| **scanHistoryMaximumItems** | Write | SInt32 | Scan history size | |
| **scanResultsRetentionDays** | Write | SInt32 | Scan results retention | |
| **exclusionsMergePolicy** | Write | String | Exclusions merge (0: merge, 1: admin_only) | `0`, `1` |
| **exclusions** | Write | MSFT_MicrosoftGraphIntuneSettingsCatalogexclusions[] | Scan exclusions | |
| **threatTypeSettings** | Write | MSFT_MicrosoftGraphIntuneSettingsCatalogthreatTypeSettings[] | Threat type settings | |
| **threatTypeSettingsMergePolicy** | Write | String | Threat type settings merge (0: merge, 1: admin_only) | `0`, `1` |
| **allowedThreats** | Write | StringArray[] | Allowed threats | |
| **disallowedThreatActions** | Write | StringArray[] | Disallowed threat actions | |
| **maximumOnDemandScanThreads** | Write | SInt32 | Degree of parallelism for on-demand scans | |
| **enableFileHashComputation** | Write | String | Enable file hash computation (false: Disabled, true: Enabled) | `false`, `true` |
| **scanAfterDefinitionUpdate** | Write | String | Run a scan after definitions are updated (false: Disabled, true: Enabled) | `false`, `true` |
| **scanArchives** | Write | String | Scanning inside archive files (false: Disabled, true: Enabled) | `false`, `true` |
| **enforcementLevel** | Write | String | Enforcement level (0: disabled, 1: audit, 2: block) | `0`, `1`, `2` |
| **enforcementLevel_tamperProtection** | Write | String | Enforcement level (0: disabled, 1: audit, 2: block) | `0`, `1`, `2` |
| **consumerExperience** | Write | String | Control sign-in to consumer version (0: enabled, 1: disabled) | `0`, `1` |
| **hideStatusMenuIcon** | Write | String | Show / hide status menu icon (false: Disabled, true: Enabled) | `false`, `true` |
| **userInitiatedFeedback** | Write | String | User initiated feedback (0: enabled, 1: disabled) | `0`, `1` |
| **antivirusengine_enforcementLevel** | Write | String | Enforcement level (0: passive, 1: on_demand, 2: real_time) | `0`, `1`, `2` |
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

### MSFT_MicrosoftGraphIntuneSettingsCatalogExclusions

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **exclusions_item_type** | Write | String | Type - Depends on exclusions (0: Path, 1: File extension, 2: Process name) | `0`, `1`, `2` |
| **exclusions_item_extension** | Write | String | File extension - Depends on exclusions_item_type=1 | |
| **exclusions_item_name** | Write | String | File name - exclusions_item_type=2 | |
| **exclusions_item_path** | Write | String | Path - exclusions_item_type=0 | |
| **exclusions_item_isDirectory** | Write | String | Is directory (false: Disabled, true: Enabled) - Depends on exclusions_item_type=0 | `false`, `true` |

### MSFT_MicrosoftGraphIntuneSettingsCatalogthreatTypeSettings

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **threatTypeSettings_item_key** | Write | String | Threat type - Depends on threatTypeSettings (0: potentially_unwanted_application, 1: archive_bomb) | `0`, `1` |
| **threatTypeSettings_item_value** | Write | String | Action to take - Depends on threatTypeSettings (0: audit, 1: block, 2: off) | `0`, `1`, `2` |


## Description

Intune Antivirus Policy for macOS

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - DeviceManagementConfiguration.Read.All, Group.Read.All

- **Update**

    - DeviceManagementConfiguration.ReadWrite.All, Group.Read.All

#### Application permissions

- **Read**

    - DeviceManagementConfiguration.Read.All, Group.Read.All

- **Update**

    - DeviceManagementConfiguration.ReadWrite.All, Group.Read.All

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
        IntuneAntivirusPolicyMacOS 'myIntuneAntivirusPolicyMacOS'
        {
            allowedThreats                     = @("Threat 1");
            Assignments                        = @();
            Description                        = "";
            disallowedThreatActions            = @("Disallowed Thread Action 1");
            DisplayName                        = "Test";
            enabled                            = "true";
            Ensure                             = "Present";
            exclusions                         = @(
                MSFT_MicrosoftGraphIntuneSettingsCatalogExclusions{
                    Exclusions_item_extension = '.dmg'
                    Exclusions_item_type = '1'
                }
                MSFT_MicrosoftGraphIntuneSettingsCatalogExclusions{
                    Exclusions_item_name = 'process1'
                    Exclusions_item_type = '2'
                }
            );
            RoleScopeTagIds                    = @("0");
            threatTypeSettings                 = @(
                MSFT_MicrosoftGraphIntuneSettingsCatalogThreatTypeSettings{
                    ThreatTypeSettings_item_key = '0'
                    ThreatTypeSettings_item_value = '0'
                }
                MSFT_MicrosoftGraphIntuneSettingsCatalogThreatTypeSettings{
                    ThreatTypeSettings_item_key = '1'
                    ThreatTypeSettings_item_value = '1'
                }
            );
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
        IntuneAntivirusPolicyMacOS 'myIntuneAntivirusPolicyMacOS'
        {
            allowedThreats                     = @("Threat 1");
            Assignments                        = @();
            Description                        = "";
            disallowedThreatActions            = @("Disallowed Thread Action 1");
            DisplayName                        = "Test";
            enabled                            = "true";
            Ensure                             = "Present";
            exclusions                         = @(
                MSFT_MicrosoftGraphIntuneSettingsCatalogExclusions{
                    Exclusions_item_extension = '.xcode' # Updated property
                    Exclusions_item_type = '1'
                }
                MSFT_MicrosoftGraphIntuneSettingsCatalogExclusions{
                    Exclusions_item_name = 'process1'
                    Exclusions_item_type = '2'
                }
            );
            RoleScopeTagIds                    = @("0");
            threatTypeSettings                 = @(
                MSFT_MicrosoftGraphIntuneSettingsCatalogThreatTypeSettings{
                    ThreatTypeSettings_item_key = '0'
                    ThreatTypeSettings_item_value = '0'
                }
                MSFT_MicrosoftGraphIntuneSettingsCatalogThreatTypeSettings{
                    ThreatTypeSettings_item_key = '1'
                    ThreatTypeSettings_item_value = '1'
                }
            );
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
        IntuneAntivirusPolicyMacOS 'myIntuneAntivirusPolicyMacOS'
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

