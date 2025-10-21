# IntuneEpmElevationSettingsPolicyWindows10

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Description** | Write | String | Policy description | |
| **DisplayName** | Key | String | Policy name | |
| **RoleScopeTagIds** | Write | StringArray[] | List of Scope Tags for this Entity instance. | |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |
| **EndpointPrivilegeManagement** | Write | SInt32 | Endpoint Privilege Management (1: Enabled, 0: Disabled) | `1`, `0` |
| **DefaultElevationResponse** | Write | SInt32 | Default elevation response - Depends on EndpointPrivilegeManagement (0: DenyAllRequests, 1: RequireUserConfirmation, 2: RequireSupportApproval) | `0`, `1`, `2` |
| **DefaultBehaviorValidation** | Write | SInt32Array[] | Validation (0: Business Justification, 1: Windows Authentication) | `0`, `1` |
| **AllowElevationDetection** | Write | SInt32 | (Preview) Automatically detect elevations - Depends on EndpointPrivilegeManagement (0: No, 1: Yes) | `0`, `1` |
| **SendDataToMicrosoft** | Write | SInt32 | Send elevation data for reporting - Depends on EndpointPrivilegeManagement (1: Yes, 0: No) | `1`, `0` |
| **ReportingScope** | Write | SInt32 | Reporting scope (1: DiagnosticDataAndManagedElevationsOnly, 2: DiagnosticDataAndAllEndpointElevations, 0: DiagnosticDataOnly) | `1`, `2`, `0` |
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


## Description

Intune Endpoint Privilege Management Elevation Settings Policy for Windows10

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

This example creates a new Intune Firewall Policy for Windows10.

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
        IntuneEpmElevationSettingsPolicyWindows10 'Example'
        {
            Assignments           = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.groupAssignmentTarget'
                    groupId = '11111111-1111-1111-1111-111111111111'
                }
            );
            Description                 = 'Description'
            DefaultElevationResponse    = "0";
            DisplayName                 = "IntuneEpmElevationSettingsPolicyWindows10_1";
            EndpointPrivilegeManagement = "1";
            ReportingScope              = "1";
            SendDataToMicrosoft         = "1";
            Ensure                      = "Present";
            Id                          = '00000000-0000-0000-0000-000000000000'
            RoleScopeTagIds             = @("0");
            ApplicationId               = $ApplicationId;
            TenantId                    = $TenantId;
            CertificateThumbprint       = $CertificateThumbprint;
        }
    }
}
```

### Example 2

This example updates a Intune Firewall Policy for Windows10.

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
        IntuneEpmElevationSettingsPolicyWindows10 'Example'
        {
            Assignments           = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.groupAssignmentTarget'
                    groupId = '11111111-1111-1111-1111-111111111111'
                }
            );
            Description                 = 'Description'
            DefaultElevationResponse    = "0";
            DisplayName                 = "IntuneEpmElevationSettingsPolicyWindows10_1";
            EndpointPrivilegeManagement = "1";
            ReportingScope              = "1";
            SendDataToMicrosoft         = "1";
            Ensure                      = "Present";
            Id                          = '00000000-0000-0000-0000-000000000000'
            RoleScopeTagIds             = @("0");
            ApplicationId               = $ApplicationId;
            TenantId                    = $TenantId;
            CertificateThumbprint       = $CertificateThumbprint;
        }
    }
}
```

### Example 3

This example removes a Device Control Policy.

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
        IntuneEpmElevationSettingsPolicyWindows10 'Example'
        {
            DisplayName                 = "IntuneEpmElevationSettingsPolicyWindows10_1";
            Ensure                      = "Absent";
            Id                          = '00000000-0000-0000-0000-000000000000'
            ApplicationId               = $ApplicationId;
            TenantId                    = $TenantId;
            CertificateThumbprint       = $CertificateThumbprint;
        }
    }
}
```

