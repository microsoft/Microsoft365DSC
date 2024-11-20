# IntuneDiskEncryptionPDEPolicyWindows10

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Description** | Write | String | Policy description | |
| **DisplayName** | Key | String | Policy name | |
| **RoleScopeTagIds** | Write | StringArray[] | List of Scope Tags for this Entity instance. | |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |
| **EnablePersonalDataEncryption** | Write | String | Enable Personal Data Encryption (User) (0: Disable Personal Data Encryption., 1: Enable Personal Data Encryption.) | `0`, `1` |
| **ProtectDesktop** | Write | String | Protect Desktop (User) (Windows Insiders only) - Depends on EnablePersonalDataEncryption (0: Disable PDE on the folder. If the folder is currently protected by PDE, this will result in unprotecting the folder., 1: Enable PDE on the folder.) | `0`, `1` |
| **ProtectPictures** | Write | String | Protect Pictures (User) (Windows Insiders only) - Depends on EnablePersonalDataEncryption (0: Disable PDE on the folder. If the folder is currently protected by PDE, this will result in unprotecting the folder., 1: Enable PDE on the folder.) | `0`, `1` |
| **ProtectDocuments** | Write | String | Protect Documents (User) (Windows Insiders only) - Depends on EnablePersonalDataEncryption (0: Disable PDE on the folder. If the folder is currently protected by PDE, this will result in unprotecting the folder., 1: Enable PDE on the folder.) | `0`, `1` |
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

Intune Disk Encryption Personal Data Encryption Policy for Windows10

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
        IntuneDiskEncryptionPDEPolicyWindows10 "IntuneDiskEncryptionPDEPolicyWindows10"
        {
            Assignments                  = @();
            Description                  = "test";
            DisplayName                  = "test";
            Ensure                       = "Present";
            EnablePersonalDataEncryption = "1";
            ProtectDesktop               = "0";
            ProtectDocuments             = "0";
            ProtectPictures              = "0";
            RoleScopeTagIds              = @("0");
            ApplicationId                = $ApplicationId;
            TenantId                     = $TenantId;
            CertificateThumbprint        = $CertificateThumbprint;
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
        IntuneDiskEncryptionPDEPolicyWindows10 "IntuneDiskEncryptionPDEPolicyWindows10"
        {
            Assignments                  = @();
            Description                  = "test";
            DisplayName                  = "test";
            Ensure                       = "Present";
            EnablePersonalDataEncryption = "1";
            ProtectDesktop               = "0";
            ProtectDocuments             = "1"; # Updated property
            ProtectPictures              = "1"; # Updated property
            RoleScopeTagIds              = @("0");
            ApplicationId                = $ApplicationId;
            TenantId                     = $TenantId;
            CertificateThumbprint        = $CertificateThumbprint;
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
        IntuneDiskEncryptionPDEPolicyWindows10 "IntuneDiskEncryptionPDEPolicyWindows10"
        {
            DisplayName           = "test";
            Ensure                = "Absent";
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

