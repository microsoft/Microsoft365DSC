# IntuneDeviceConfigurationPlatformScriptWindows

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Description** | Write | String | Optional description for the device management script. | |
| **DisplayName** | Required | String | Name of the device management script. | |
| **EnforceSignatureCheck** | Write | Boolean | Indicate whether the script signature needs be checked. | |
| **FileName** | Write | String | The script file name. | |
| **RoleScopeTagIds** | Write | StringArray[] | List of Scope Tag IDs for this PowerShellScript instance. | |
| **RunAs32Bit** | Write | Boolean | A value indicating whether the PowerShell script should run as 32-bit | |
| **RunAsAccount** | Write | String | Indicates the type of execution context. Possible values are: system, user. | `system`, `user` |
| **ScriptContent** | Write | String | The script content in Base64. | |
| **Id** | Key | String | The unique identifier for an entity. Read-only. | |
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


## Description

Intune Device Configuration Platform Script Windows

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
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceConfigurationPlatformScriptWindows 'Example'
        {
            Assignments          = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allDevicesAssignmentTarget'
                }
            );
            Credential            = $Credscredential;
            DisplayName           = "custom";
            Ensure                = "Present";
            EnforceSignatureCheck = $False;
            FileName              = "script.ps1";
            Id                    = "00000000-0000-0000-0000-000000000000";
            RunAs32Bit            = $True;
            RunAsAccount          = "system";
            ScriptContent         = "Base64 encoded script content";
            TenantId              = $OrganizationName;
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
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceConfigurationPlatformScriptWindows 'Example'
        {
            Assignments          = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allDevicesAssignmentTarget'
                }
            );
            Credential            = $Credscredential;
            DisplayName           = "custom";
            Ensure                = "Present";
            EnforceSignatureCheck = $False;
            FileName              = "script.ps1";
            Id                    = "00000000-0000-0000-0000-000000000000";
            RunAs32Bit            = $False; # Updated property
            RunAsAccount          = "system";
            ScriptContent         = "Base64 encoded script content";
            TenantId              = $OrganizationName;
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
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceConfigurationPlatformScriptWindows 'Example'
        {
            Credential            = $Credscredential;
            DisplayName           = "custom";
            Ensure                = "Absent";
            Id                    = "00000000-0000-0000-0000-000000000000";
            TenantId              = $OrganizationName;
        }
    }
}
```

