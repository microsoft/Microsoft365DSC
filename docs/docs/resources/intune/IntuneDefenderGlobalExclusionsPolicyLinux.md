# IntuneDefenderGlobalExclusionsPolicyLinux

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Description** | Write | String | Policy description | |
| **DisplayName** | Key | String | Policy name | |
| **RoleScopeTagIds** | Write | StringArray[] | List of Scope Tags for this Entity instance. | |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |
| **Exclusions** | Write | MSFT_MicrosoftGraphIntuneSettingsCatalogExclusionsV2[] | Global Exclusions | |
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
| **dataType** | Write | String | The type of the target assignment. | `#microsoft.graph.cloudPcManagementGroupAssignmentTarget`, `#microsoft.graph.groupAssignmentTarget`, `#microsoft.graph.allLicensedUsersAssignmentTarget`, `#microsoft.graph.allDevicesAssignmentTarget`, `#microsoft.graph.exclusionGroupAssignmentTarget`, `#microsoft.graph.configurationManagerCollectionAssignmentTarget` |
| **deviceAndAppManagementAssignmentFilterType** | Write | String | The type of filter of the target assignment i.e. Exclude or Include. Possible values are:none, include, exclude. | `none`, `include`, `exclude` |
| **deviceAndAppManagementAssignmentFilterId** | Write | String | The Id of the filter for the target assignment. | |
| **deviceAndAppManagementAssignmentFilterDisplayName** | Write | String | The display name of the filter for the target assignment. | |
| **groupId** | Write | String | The group Id that is the target of the assignment. | |
| **groupDisplayName** | Write | String | The group Display Name that is the target of the assignment. | |
| **collectionId** | Write | String | The collection Id that is the target of the assignment.(ConfigMgr) | |

### MSFT_MicrosoftGraphIntuneSettingsCatalogExclusionsV2

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **exclusions_item_type** | Write | String | Type - (excludedPath: Path, excludedFileName: Process name) | `excludedPath`, `excludedFileName` |
| **exclusions_item_path** | Write | String | Path | |
| **exclusions_item_name** | Write | String | Process name | |
| **exclusions_item_isDirectory** | Write | String | Is directory (false: Disabled, true: Enabled) | `false`, `true` |


## Description

Intune Defender Global Exclusions Policy for Linux. Can be found under Endpoint Security > Endpoint detection and response > Create policy: Platform - Linux, Profile - Microsoft Defender Global Exclusions (AV + EDR)

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
        IntuneDefenderGlobalExclusionsPolicyLinux 'myIntuneDefenderGlobalExclusionsPolicyLinux'
        {
            Assignments = @();
            Description = "";
            DisplayName = "Test";
            Ensure      = "Present";
            Exclusions  = @(
                MSFT_MicrosoftGraphIntuneSettingsCatalogExclusionsV2{
                    exclusions_item_path = '/path/to/directory'
                    exclusions_item_isDirectory = 'true'
                    exclusions_item_type = 'excludedPath'
                }
                MSFT_MicrosoftGraphIntuneSettingsCatalogExclusionsV2{
                    Exclusions_item_name = 'process1'
                    Exclusions_item_type = 'excludedFileName'
                }
            );
            RoleScopeTagIds       = @("0");
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
        IntuneDefenderGlobalExclusionsPolicyLinux 'myIntuneDefenderGlobalExclusionsPolicyLinux'
        {
            Assignments = @();
            Description = "";
            DisplayName = "Test";
            Ensure      = "Present";
            Exclusions  = @(
                MSFT_MicrosoftGraphIntuneSettingsCatalogExclusionsV2{
                    exclusions_item_path = '/path/to/otherDirectory' # Updated property
                    exclusions_item_isDirectory = 'true'
                    exclusions_item_type = 'excludedPath'
                }
                MSFT_MicrosoftGraphIntuneSettingsCatalogExclusionsV2{
                    Exclusions_item_name = 'process1'
                    Exclusions_item_type = 'excludedFileName'
                }
            );
            RoleScopeTagIds       = @("0");
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
        IntuneDefenderGlobalExclusionsPolicyLinux 'myIntuneDefenderGlobalExclusionsPolicyLinux'
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

