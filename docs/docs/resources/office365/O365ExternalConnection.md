# O365ExternalConnection

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The name of the external connector. | |
| **Id** | Write | String | The unique identifier of the external connector. | |
| **Description** | Write | String | The description of the external connector. | |
| **AuthorizedAppIds** | Write | StringArray[] | A collection of application IDs for registered Microsoft Entra apps that are allowed to manage the externalConnection and to index content in the externalConnection. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Absent`, `Present` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Configures external connectors in Microsoft 365.

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

    - ExternalConnection.Read.All

- **Update**

    - ExternalConnection.ReadWrite.All

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
        O365ExternalConnection "O365ExternalConnection-Contoso HR"
        {
            ApplicationId         = $ApplicationId;
            AuthorizedAppIds      = @("MyApp");
            CertificateThumbprint = $CertificateThumbprint;
            Description           = "Connection to index Contoso HR system";
            Ensure                = "Present";
            Id                    = "contosohr";
            Name                  = "Contoso HR Nik";
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
        O365ExternalConnection "O365ExternalConnection-Contoso HR"
        {
            ApplicationId         = $ApplicationId;
            AuthorizedAppIds      = @("MyApp", "MySecondApp"); # Drift
            CertificateThumbprint = $CertificateThumbprint;
            Description           = "Connection to index Contoso HR system";
            Ensure                = "Present";
            Id                    = "contosohr";
            Name                  = "Contoso HR Nik";
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
        O365ExternalConnection "O365ExternalConnection-Contoso HR"
        {
            ApplicationId         = $ApplicationId;
            AuthorizedAppIds      = @("MyApp");
            CertificateThumbprint = $CertificateThumbprint;
            Description           = "Connection to index Contoso HR system";
            Ensure                = "Absent";
            Id                    = "contosohr";
            Name                  = "Contoso HR Nik";
            TenantId              = $TenantId;
        }
    }
}
```

