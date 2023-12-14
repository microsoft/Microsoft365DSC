﻿# AADTokenLifetimePolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | DisplayName of the Policy | |
| **Id** | Write | String | ObjectID of the Policy. | |
| **Description** | Write | String | Description of the Policy. | |
| **Definition** | Write | StringArray[] | Definition of the Policy. | |
| **IsOrganizationDefault** | Write | Boolean | IsOrganizationDefault of the Policy. | |
| **Ensure** | Write | String | Specify if the Azure AD Policy should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials for the Microsoft Graph delegated permissions. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures the Azure AD Token Lifetime Policies

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Policy.Read.All

- **Update**

    - Policy.ReadWrite.ApplicationConfiguration

#### Application permissions

- **Read**

    - Policy.Read.All

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
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADTokenLifetimePolicy 'CreateTokenLifetimePolicy'
        {
            DisplayName           = "PolicyDisplayName"
            Definition            = @('{"TokenIssuancePolicy":{"Version": 1,"SigningAlgorithm": "http://www.w3.org/2000/09/xmldsig#rsa-sha1","TokenResponseSigningPolicy": "TokenOnly","SamlTokenVersion": "2.0"}}')
            IsOrganizationDefault = $false
            Ensure                = "Present"
            Credential            = $Credscredential
        }
    }
}
```

