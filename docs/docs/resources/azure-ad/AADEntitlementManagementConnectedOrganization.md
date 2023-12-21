# AADEntitlementManagementConnectedOrganization

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | The display name of the connected organization. | |
| **Id** | Write | String | The Id of the Connected organization object. | |
| **Description** | Write | String | The description of the connected organization. | |
| **IdentitySources** | Write | MSFT_AADEntitlementManagementConnectedOrganizationIdentitySource[] | The identity sources in this connected organization. | |
| **State** | Write | String | The state of a connected organization defines whether assignment policies with requestor scope type AllConfiguredConnectedOrganizationSubjects are applicable or not. | `configured`, `proposed`, `unknownFutureValue` |
| **ExternalSponsors** | Write | StringArray[] | Collection of objectID of extenal sponsors. the sponsor can be a user or a group. | |
| **InternalSponsors** | Write | StringArray[] | Collection of objectID of internal sponsors. the sponsor can be a user or a group. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Intune Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

### MSFT_AADEntitlementManagementConnectedOrganizationIdentitySource

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **odataType** | Write | String | Type of the identity source. | `#microsoft.graph.azureActiveDirectoryTenant`, `#microsoft.graph.crossCloudAzureActiveDirectoryTenant`, `#microsoft.graph.domainIdentitySource`, `#microsoft.graph.externalDomainFederation` |
| **DisplayName** | Write | String | The name of the Azure Active Directory tenant. | |
| **ExternalTenantId** | Write | String | The ID of the Azure Active Directory tenant. | |
| **CloudInstance** | Write | String | The ID of the cloud where the tenant is located, one of microsoftonline.com, microsoftonline.us or partner.microsoftonline.cn. | |
| **DomainName** | Write | String | The domain name. | |
| **IssuerUri** | Write | String | The issuerURI of the incoming federation. | |


## Description

This resource configures an Azure AD Entitlement Management Connected Organization.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - EntitlementManagement.Read.All, EntitlementManagement.ReadWrite.All

- **Update**

    - EntitlementManagement.ReadWrite.All, Directory.Read.All

#### Application permissions

- **Read**

    - EntitlementManagement.Read.All, EntitlementManagement.ReadWrite.All

- **Update**

    - EntitlementManagement.ReadWrite.All, Directory.Read.All

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
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADEntitlementManagementConnectedOrganization 'MyConnectedOrganization'
        {
            Description           = "this is the tenant partner";
            DisplayName           = "Test Tenant - DSC";
            ExternalSponsors      = @("12345678-1234-1234-1234-123456789012");
            IdentitySources       = @(
                MSFT_AADEntitlementManagementConnectedOrganizationIdentitySource{
                    ExternalTenantId = "12345678-1234-1234-1234-123456789012"
                    DisplayName = 'Contoso'
                    odataType = '#microsoft.graph.azureActiveDirectoryTenant'
                }
            );
            InternalSponsors      = @("12345678-1234-1234-1234-123456789012");
            State                 = "configured";
            Ensure                = "Present"
            Credential            = $Credscredential
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
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADEntitlementManagementConnectedOrganization 'MyConnectedOrganization'
        {
            Description           = "this is the tenant partner - Updated"; # Updated Property
            DisplayName           = "Test Tenant - DSC";
            ExternalSponsors      = @("12345678-1234-1234-1234-123456789012");
            IdentitySources       = @(
                MSFT_AADEntitlementManagementConnectedOrganizationIdentitySource{
                    ExternalTenantId = "12345678-1234-1234-1234-123456789012"
                    DisplayName = 'Contoso'
                    odataType = '#microsoft.graph.azureActiveDirectoryTenant'
                }
            );
            InternalSponsors      = @("12345678-1234-1234-1234-123456789012");
            State                 = "configured";
            Ensure                = "Present"
            Credential            = $Credscredential
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
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADEntitlementManagementConnectedOrganization 'MyConnectedOrganization'
        {
            DisplayName           = "Test Tenant - DSC";
            Ensure                = "Absent"
            Credential            = $Credscredential
        }
    }
}
```

