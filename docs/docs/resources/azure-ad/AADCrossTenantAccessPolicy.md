# AADCrossTenantAccessPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Only valid value is 'Yes'. | `Yes` |
| **DisplayName** | Write | String | The name of the policy. | |
| **AllowedCloudEndpoints** | Write | StringArray[] | Used to specify which Microsoft clouds an organization would like to collaborate with. By default, this value is empty. | `microsoftonline.com`, `microsoftonline.us`, `partner.microsoftonline.cn` |
| **Ensure** | Write | String | Specify if the policy should exist or not. | `Present` |
| **Credential** | Write | PSCredential | Credentials of the Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |


## Description

This resource manages Azure AD Cross Tenant Access Policies.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Policy.Read.All

- **Update**

    - Policy.ReadWrite.CrossTenantAccess

#### Application permissions

- **Read**

    - Policy.Read.All

- **Update**

    - Policy.ReadWrite.CrossTenantAccess

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
        $credsCredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        AADCrossTenantAccessPolicy "AADCrossTenantAccessPolicy"
        {
            AllowedCloudEndpoints = @("microsoftonline.us");
            Credential            = $Credscredential;
            DisplayName           = "MyXTAPPolicy";
            Ensure                = "Present";
            IsSingleInstance      = "Yes";
        }
    }
}
```

