# EXOManagementScope

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the name of the management scope to modify. | |
| **Name** | Write | String | The Name parameter specifies the name of the management scope. | |
| **RecipientRestrictionFilter** | Write | String | The RecipientRestrictionFilter parameter uses OPATH filter syntax to specify the recipients that are included in the scope. | |
| **RecipientRoot** | Write | String | The RecipientRoot parameter specifies the organizational unit (OU) under which the filter specified with the RecipientRestrictionFilter parameter should be applied. | |
| **Exclusive** | Write | Boolean | The Exclusive switch specifies that the role should be an exclusive scope. | |
| **Ensure** | Write | String | Specifies if this Outbound connector should exist. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Use this resource to create ManagementScopes.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Hygiene Management, Compliance Management, Organization Management, View-Only Organization Management

#### Role Groups

- Organization Management

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
        EXOManagementScope "EXOManagementScope-Test New DGs"
        {
            ApplicationId              = $ApplicationId
            TenantId                   = $TenantId
            CertificateThumbprint      = $CertificateThumbprint
            Ensure                     = "Present";
            Exclusive                  = $False;
            Identity                   = "Test New DGs";
            Name                       = "Test New DGs";
            RecipientRestrictionFilter = "Name -like 'Test*'";
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
        EXOManagementScope "EXOManagementScope-Test New DGs"
        {
            ApplicationId              = $ApplicationId
            TenantId                   = $TenantId
            CertificateThumbprint      = $CertificateThumbprint
            Ensure                     = "Present";
            Exclusive                  = $False;
            Identity                   = "Test New DGs";
            Name                       = "Test New DGs";
            RecipientRestrictionFilter = "Name -like 'NewTest*'";
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
        EXOManagementScope "EXOManagementScope-Test New DGs"
        {
            ApplicationId              = $ApplicationId
            TenantId                   = $TenantId
            CertificateThumbprint      = $CertificateThumbprint
            Ensure                     = "Absent";
            Exclusive                  = $False;
            Identity                   = "Test New DGs";
            Name                       = "Test New DGs";
            RecipientRestrictionFilter = "Name -like 'NewTest*'";
        }

    }
}
```

