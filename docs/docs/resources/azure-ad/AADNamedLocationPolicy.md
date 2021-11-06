# AADNamedLocationPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **OdataType** | Write | String | Specifies the Odata Type of a Named Location object in Azure Active Directory |#microsoft.graph.countryNamedLocation, #microsoft.graph.ipNamedLocation|
| **Id** | Write | String | Specifies the ID of a Named Location in Azure Active Directory. ||
| **DisplayName** | Key | String | Specifies the Display Name of a Named Location in Azure Active Directory ||
| **IpRanges** | Write | StringArray[] | Specifies the IP ranges of the Named Location in Azure Active Directory ||
| **IsTrusted** | Write | Boolean | Specifies the isTrusted value for the Named Location in Azure Active Directory ||
| **CountriesAndRegions** | Write | StringArray[] | Specifies the countries and regions for the Named Location in Azure Active Directory ||
| **IncludeUnknownCountriesAndRegions** | Write | Boolean | Specifies the includeUnknownCountriesAndRegions value for the Named Location in Azure Active Directory ||
| **Ensure** | Write | String | Specify if the Azure AD Named Location should exist or not. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials for the Microsoft Graph delegated permissions. ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory application to authenticate with. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||

# AADNamedLocationPolicy

### Description

This resource configures the Azure AD Named Location Policies in Azure Active Directory

## Azure AD Permissions

To authenticate via Azure Active Directory, this resource required the following Application permissions:

* **Automate**
  * Policy.Read.All,Policy.ReadWrite.ApplicationConfiguration
* **Export**
  * Policy.Read.All

NOTE: All permisions listed above require admin consent.

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
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADNamedLocationPolicy 'CompanyNetwork'
        {
            DisplayName = "Company Network"
            IpRanges    = @("2.1.1.1/32", "1.2.2.2/32")
            IsTrusted   = $True
            OdataType   = "#microsoft.graph.ipNamedLocation"
            Ensure      = "Present"
            Credential  = $credsGlobalAdmin
        }
        AADNamedLocationPolicy 'AllowedCountries'
        {
            CountriesAndRegions               = @("GH", "AX", "DZ", "AI", "AM")
            DisplayName                       = "Allowed Countries"
            IncludeUnknownCountriesAndRegions = $False
            OdataType                         = "#microsoft.graph.countryNamedLocation"
            Ensure                            = "Present"
            Credential                        = $credsGlobalAdmin
        }
    }
}
```

