# IntuneDeviceComplianceScriptWindows10

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Description** | Write | String | Optional description for the device compliance script. | |
| **DisplayName** | Key | String | Name of the device compliance script. | |
| **EnforceSignatureCheck** | Write | Boolean | Indicate whether the script signature needs be checked. | |
| **Publisher** | Write | String | Publisher of the script. | |
| **RoleScopeTagIds** | Write | StringArray[] | List of Scope Tag IDs for this PowerShellScript instance. | |
| **RunAs32Bit** | Write | Boolean | A value indicating whether the PowerShell script should run as 32-bit | |
| **RunAsAccount** | Write | String | Indicates the type of execution context. Possible values are: system, user. | `system`, `user` |
| **DetectionScriptContent** | Write | String | The script content in Base64. | |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Intune Device Compliance Script for Windows10

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
        IntuneDeviceComplianceScriptWindows10 'Example'
        {
            DisplayName            = "custom";
            Ensure                 = "Present";
            EnforceSignatureCheck  = $False;
            Id                     = "00000000-0000-0000-0000-000000000000";
            RunAs32Bit             = $True;
            RunAsAccount           = "system";
            DetectionScriptContent = "Write-Output `$true";
            Publisher              = "";
            ApplicationId          = $ApplicationId;
            TenantId               = $TenantId;
            CertificateThumbprint  = $CertificateThumbprint;
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
        IntuneDeviceComplianceScriptWindows10 'Example'
        {
            DisplayName            = "custom";
            Ensure                 = "Present";
            EnforceSignatureCheck  = $False;
            Id                     = "00000000-0000-0000-0000-000000000000";
            RunAs32Bit             = $False; # Updated property
            RunAsAccount           = "system";
            DetectionScriptContent = "Write-Output `$true";
            Publisher              = "";
            ApplicationId          = $ApplicationId;
            TenantId               = $TenantId;
            CertificateThumbprint  = $CertificateThumbprint;
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
        IntuneDeviceComplianceScriptWindows10 'Example'
        {
            DisplayName           = "custom";
            Ensure                = "Absent";
            Id                    = "00000000-0000-0000-0000-000000000000";
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

