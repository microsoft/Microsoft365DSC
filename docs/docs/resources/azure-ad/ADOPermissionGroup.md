# ADOPermissionGroup

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **OrganizationName** | Key | String | The name of the Azure DevOPS Organization. | |
| **PrincipalName** | Key | String | Principal name to identify the group. | |
| **DisplayName** | Write | String | Display name for the group. | |
| **Description** | Write | String | Description of the group. | |
| **Members** | Write | StringArray[] | List of principal names of the members of the group. | |
| **Id** | Write | String | Unique identifier for the group. | |
| **Descriptor** | Write | String | Unique descriptor for the group. | |
| **Level** | Write | String | Determines at what level in the hierarchy the group exists. Valid values are Project or Organization. | `Organization`, `Project` |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Manages Azure DevOPS permission groups.

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
        ADOPermissionGroup "TestPermissionGroup"
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            Description           = "My Description";
            DisplayName           = "TestGroup";
            Ensure                = "Present";
            Level                 = "Organization";
            Members               = @("AdeleV@$TenantId");
            OrganizationName      = "O365DSC-Dev";
            PrincipalName         = "[O365DSC-DEV]\TestGroup";
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
        ADOPermissionGroup "TestPermissionGroup"
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            Description           = "My Description";
            DisplayName           = "TestGroup";
            Ensure                = "Present";
            Level                 = "Organization";
            Members               = @("AdeleV@$TenantId", "admin@$TenantId"); #Drift
            OrganizationName      = "O365DSC-Dev";
            PrincipalName         = "[O365DSC-DEV]\TestGroup";
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
        ADOPermissionGroup "TestPermissionGroup"
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            Description           = "My Description";
            DisplayName           = "TestGroup";
            Ensure                = "Absent";
            Level                 = "Organization";
            Members               = @("AdeleV@$TenantId");
            OrganizationName      = "O365DSC-Dev";
            PrincipalName         = "[O365DSC-DEV]\TestGroup";
            TenantId              = $TenantId;
        }
    }
}
```

