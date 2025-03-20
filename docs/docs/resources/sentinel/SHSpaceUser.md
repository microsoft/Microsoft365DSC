# SHSpaceUser

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **SpaceName** | Key | String | Name of the associated Services Hub space. | |
| **Email** | Key | String | Email identifier for the user. | |
| **Roles** | Write | StringArray[] | List of roles associated with the user. Accepted values are: CustomerActivityPagePermissionRole, HealthPermissionRole, InviteUsersPermissionRole, PlansPermissionRole, SharedFilesPermissionRole, SupportCasePermissionRole, TrainingManager, TrainingPermissionRole, WorkspaceAdministratorRole. Role Account manager,IncidentManagerUnified,CSMAdministrator, ContractSupportUser are read-only and inherited from the upstream system and cannot be modified. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Absent`, `Present` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Represents a Services Hub space user.

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

    - User.Read.All

- **Update**

    - User.Read.All

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
        SHSpaceUser "SHSpaceUser"
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            Email                 = "Test@contoso.com";
            Ensure                = "Present";
            Roles                 = @("TrainingPermissionRole","HealthPermissionRole");
            SpaceName             = "Test Workspace";
            TenantId              = $TenantId;
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
        SHSpaceUser "SHSpaceUser"
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            Email                 = "Test@contoso.com";
            Ensure                = "Present";
            Roles                 = @("TrainingPermissionRole");
            SpaceName             = "Test Workspace";
            TenantId              = $TenantId;
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
        SHSpaceUser "SHSpaceUser"
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            Email                 = "Test@contoso.com";
            Ensure                = "Absent";
            Roles                 = @("TrainingPermissionRole","HealthPermissionRole");
            SpaceName             = "Test Workspace";
            TenantId              = $TenantId;
        }
    }
}
```

