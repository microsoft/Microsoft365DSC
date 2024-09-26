# EXOSecOpsOverrideRule

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |
| **Identity** | Key | String | The unique identifier (GUID or name) of the override rule. This parameter is mandatory. | |
| **Comment** | Write | String | An optional comment for the override rule. | |
| **Policy** | Write | String | The SecOps simulation override policy that's associated with the rule. | |
| **Ensure** | Write | String | Ensures the presence or absence of the configuration. | `Present`, `Absent` |


## Description

This resource allows users to manage resource to modify SecOps
override rules to bypass Exchange Online Protection filtering.

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
        EXOSecOpsOverrideRule "EXOSecOpsOverrideRule-_Exe:SecOpsOverrid:ca3c51ac-925c-49f4-af42-43e26b874245"
        {
            Comment              = "TestComment";
            Ensure               = "Present";
            Identity             = "_Exe:SecOpsOverrid:ca3c51ac-925c-49f4-af42-43e26b874245";
            Policy               = "40528418-717d-4368-a1ae-7912918f8a1f";
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
        EXOSecOpsOverrideRule "EXOSecOpsOverrideRule-_Exe:SecOpsOverrid:ca3c51ac-925c-49f4-af42-43e26b874245"
        {
            Comment                                  = "TestComment";
            Ensure                                   = "Present";
            Identity                                 = "_Exe:SecOpsOverrid:ca3c51ac-925c-49f4-af42-43e26b874245";
            Policy                                   = "40528418-717d-4368-a1ae-7912918f8a1f";
            ApplicationId                            = $ApplicationId
            TenantId                                 = $TenantId
            CertificateThumbprint                    = $CertificateThumbprint
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
        EXOSecOpsOverrideRule "EXOSecOpsOverrideRule-_Exe:SecOpsOverrid:ca3c51ac-925c-49f4-af42-43e26b874245"
        {
            Ensure               = "Absent";
            Identity             = "_Exe:SecOpsOverrid:ca3c51ac-925c-49f4-af42-43e26b874245";
        }
    }
}
```

