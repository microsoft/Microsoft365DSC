# TeamsApplicationInstance

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | The display name of the resource instance. | |
| **UserPrincipalName** | Key | String | The user principal name associated with the resource instance. | |
| **ResourceAccountType** | Write | String | The type of resource account. Values can be: AutoAttendant or CallQueue. | `AutoAttendant`, `CallQueue` |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Absent`, `Present` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Manages Teams Resource Accounts.

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
        TeamsApplicationInstance "TestResourceAccount"
        {
            ApplicationId         = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint = $ConfigurationData.NonNodeData.CertificateThumbprint;
            DisplayName           = "JohnRA";
            Ensure                = "Present";
            ResourceAccountType   = "AutoAttendant";
            TenantId              = $OrganizationName;
            UserPrincipalName     = "John.Smith@M365x73318397.mail.onmicrosoft.com";
        }
    }
}
```

