# AADTokenIssuancePolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | Display name for this policy. Required. | |
| **Id** | Write | String | Unique identifier for this policy. Read-only. | |
| **IsOrganizationDefault** | Write | Boolean | The token-issuance policy can only be applied to service principals and can't be set globally for the organization. | |
| **Description** | Write | String | Description for this policy. | |
| **Definition** | Write | StringArray[] | A string collection containing a JSON string that defines the rules and settings for this policy. See below for more details about the JSON schema for this property. Required. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Absent`, `Present` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Represents the policy to specify the characteristics of SAML tokens issued by Microsoft Entra ID.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Policy.Read.ApplicationConfiguration

- **Update**

    - Policy.ReadWrite.ApplicationConfiguration

#### Application permissions

- **Read**

    - Policy.Read.ApplicationConfiguration

- **Update**

    - Policy.ReadWrite.ApplicationConfiguration

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
        AADTokenIssuancePolicy "AADTokenIssuancePolicy-Demo"
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            Definition            = @("{`"TokenResponseSigningPolicy`":`"ResponseOnly`",`"SamlTokenVersion`":`"1.1`",`"SigningAlgorithm`":`"http://www.w3.org/2001/04/xmldsig-more#rsa-sha256`",`"Version`":`"1`",`"EmitSAMLNameFormat`":`"true`"}");
            DisplayName           = "DemoPolicy";
            Ensure                = "Present";
            IsOrganizationDefault = $False;
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
        AADTokenIssuancePolicy "AADTokenIssuancePolicy-Demo"
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            Definition            = @("{`"TokenResponseSigningPolicy`":`"TokenOnly`",`"SamlTokenVersion`":`"1.1`",`"SigningAlgorithm`":`"http://www.w3.org/2001/04/xmldsig-more#rsa-sha256`",`"Version`":`"1`",`"EmitSAMLNameFormat`":`"true`"}");
            DisplayName           = "DemoPolicy";
            Ensure                = "Present";
            IsOrganizationDefault = $False;
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
        AADTokenIssuancePolicy "AADTokenIssuancePolicy-Demo"
        {
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            Definition            = @("{`"TokenResponseSigningPolicy`":`"ResponseOnly`",`"SamlTokenVersion`":`"1.1`",`"SigningAlgorithm`":`"http://www.w3.org/2001/04/xmldsig-more#rsa-sha256`",`"Version`":`"1`",`"EmitSAMLNameFormat`":`"true`"}");
            DisplayName           = "DemoPolicy";
            Ensure                = "Absent";
            IsOrganizationDefault = $False;
            TenantId              = $TenantId;
        }
    }
}
```

