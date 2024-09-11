# SPOAccessControlSettings

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Specifies the resource is a single instance, the value must be 'Yes' | `Yes` |
| **DisplayStartASiteOption** | Write | Boolean | Determines whether tenant users see the Start a Site menu option | |
| **StartASiteFormUrl** | Write | String | Specifies URL of the form to load in the Start a Site dialog. The valid values are:<emptyString> (default) - Blank by default, this will also remove or clear any value that has been set.Full URL - Example: https://contoso.sharepoint.com/path/to/form | |
| **IPAddressEnforcement** | Write | Boolean | Allows access from network locations that are defined by an administrator. | |
| **IPAddressAllowList** | Write | String | Configures multiple IP addresses or IP address ranges (IPv4 or IPv6). Use commas to separate multiple IP addresses or IP address ranges. | |
| **IPAddressWACTokenLifetime** | Write | UInt32 | Office webapps TokenLifeTime in minutes | |
| **DisallowInfectedFileDownload** | Write | Boolean | Prevents the Download button from being displayed on the Virus Found warning page. | |
| **ExternalServicesEnabled** | Write | Boolean | Enables external services for a tenant. External services are defined as services that are not in the Office 365 datacenters. | |
| **EmailAttestationRequired** | Write | Boolean | Sets email attestation to required | |
| **EmailAttestationReAuthDays** | Write | UInt32 | Sets email attestation re-auth days | |
| **EnableRestrictedAccessControl** | Write | Boolean | Enables or disables the restricted access control. | |
| **Ensure** | Write | String | Only value accepted is 'Present' | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the account to authenticate with. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for certificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **ConditionalAccessPolicy** | Write | String | Blocks or limits access to SharePoint and OneDrive content from un-managed devices. | `AllowFullAccess`, `AllowLimitedAccess`, `BlockAccess`, `ProtectionLevel` |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


# SPO Access Control Settings

## Description

This resource allows users to configure and monitor the access control settings for
your SPO tenant sharing settings.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Domain.Read.All

- **Update**

    - Domain.Read.All

#### Application permissions

- **Read**

    - Domain.Read.All

- **Update**

    - Domain.Read.All

### Microsoft SharePoint

To authenticate with the SharePoint API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Sites.FullControl.All

- **Update**

    - Sites.FullControl.All

#### Application permissions

- **Read**

    - Sites.FullControl.All

- **Update**

    - Sites.FullControl.All

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
        SPOAccessControlSettings 'ConfigureAccessControlSettings'
        {
            IsSingleInstance             = "Yes"
            DisplayStartASiteOption      = $false
            StartASiteFormUrl            = "https://contoso.sharepoint.com"
            IPAddressEnforcement         = $false
            IPAddressWACTokenLifetime    = 15
            DisallowInfectedFileDownload = $false
            ExternalServicesEnabled      = $true
            EmailAttestationRequired     = $false
            EmailAttestationReAuthDays   = 30
            Ensure                       = "Present"
            Credential                   = $Credscredential
        }
    }
}
```

