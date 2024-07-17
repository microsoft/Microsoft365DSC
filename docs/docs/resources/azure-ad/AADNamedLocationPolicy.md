# AADNamedLocationPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **OdataType** | Write | String | Specifies the Odata Type of a Named Location object in Azure Active Directory | `#microsoft.graph.countryNamedLocation`, `#microsoft.graph.ipNamedLocation`, `#microsoft.graph.compliantNetworkNamedLocation` |
| **Id** | Write | String | Specifies the ID of a Named Location in Azure Active Directory. | |
| **DisplayName** | Key | String | Specifies the Display Name of a Named Location in Azure Active Directory | |
| **IpRanges** | Write | StringArray[] | Specifies the IP ranges of the Named Location in Azure Active Directory | |
| **IsTrusted** | Write | Boolean | Specifies the isTrusted value for the Named Location (IP ranges only) in Azure Active Directory | |
| **CountriesAndRegions** | Write | StringArray[] | Specifies the countries and regions for the Named Location in Azure Active Directory | |
| **CountryLookupMethod** | Write | String | Determines what method is used to decide which country the user is located in. Possible values are clientIpAddress(default) and authenticatorAppGps. | `clientIpAddress`, `authenticatorAppGps` |
| **IncludeUnknownCountriesAndRegions** | Write | Boolean | Specifies the includeUnknownCountriesAndRegions value for the Named Location in Azure Active Directory | |
| **Ensure** | Write | String | Specify if the Azure AD Named Location should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials for the Microsoft Graph delegated permissions. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

This resource configures the Azure AD Named Location Policies in Azure Active Directory

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Policy.Read.All

- **Update**

    - Policy.Read.All, Policy.ReadWrite.ConditionalAccess

#### Application permissions

- **Read**

    - Policy.Read.All

- **Update**

    - Policy.Read.All, Policy.ReadWrite.ConditionalAccess

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
        AADNamedLocationPolicy 'CompanyNetwork'
        {
            DisplayName = "Company Network"
            IpRanges    = @("2.1.1.1/32", "1.2.2.2/32")
            IsTrusted   = $False
            OdataType   = "#microsoft.graph.ipNamedLocation"
            Ensure      = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
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
        AADNamedLocationPolicy 'CompanyNetwork'
        {
            DisplayName = "Company Network"
            IpRanges    = @("2.1.1.1/32") # Updated Property
            IsTrusted   = $False
            OdataType   = "#microsoft.graph.ipNamedLocation"
            Ensure      = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
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
        AADNamedLocationPolicy 'CompanyNetwork'
        {
            DisplayName = "Company Network"
            Ensure      = "Absent"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
```

