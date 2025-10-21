# IntuneWindowsUpdateForBusinessHotpatchProfileWindows10

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | Indicates the display name of the device cleanup rule. | |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |
| **Description** | Write | String | Indicates the description for the device clean up rule. | |
| **HotpatchEnabled** | Write | Boolean | Indicates if hotpatch is enabled. | |
| **RoleScopeTagIds** | Write | StringArray[] | List of Scope Tags for this Entity instance. | |
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

Intune Windows Update For Business Hotpatch Profile for Windows10

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

This example creates a device cleanup rule.

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
        IntuneWindowsUpdateForBusinessHotpatchProfileWindows10 'IntuneWindowsUpdateForBusinessHotpatchProfileWindows10-Example'
        {
            DisplayName           = "Example";
            Description           = "";
            HotpatchEnabled       = $True;
            RoleScopeTagIds       = @("0");
            Ensure                = 'Present';
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

### Example 2

This example updates a device cleanup rule.

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
        IntuneWindowsUpdateForBusinessHotpatchProfileWindows10 'IntuneWindowsUpdateForBusinessHotpatchProfileWindows10-Example'
        {
            DisplayName           = "Example";
            Description           = "";
            HotpatchEnabled       = $False; # Updated property
            RoleScopeTagIds       = @("0");
            Ensure                = 'Present';
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

### Example 3

This example removes a device cleanup rule.

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
        IntuneWindowsUpdateForBusinessHotpatchProfileWindows10 'IntuneWindowsUpdateForBusinessHotpatchProfileWindows10-Example'
        {
            DisplayName           = "Example";
            Ensure                = 'Absent';
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

