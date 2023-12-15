# SCSecurityFilter

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **FilterName** | Key | String | The FilterName parameter specifies the name of the compliance security filter that you want to view. If the value contains spaces, enclose the value in quotation marks ("). | |
| **Action** | Write | String | The Action parameter filters the results by the type of search action that a filter is applied to.  | `Export`, `Preview`, `Purge`, `Search`, `All` |
| **Users** | Write | StringArray[] | The User parameter filters the results by the user who gets a filter applied to their searches. Acceptable values are : The alias or email address of a user, All or The name of a role group | |
| **Description** | Write | String | The Description parameter specifies a description for the compliance security filter. The maximum length is 256 characters. If the value contains spaces, enclose the value in quotation marks ("). | |
| **Filters** | Write | StringArray[] | The Filters parameter specifies the search criteria for the compliance security filter. The filters are applied to the users specified by the Users parameter. You can create three different types of filters: Mailbox filter, Mailbox content filter or Site and site content filter | |
| **Region** | Write | String | The Region parameter specifies the satellite location for multi-geo tenants to conduct eDiscovery searches in. | `APC`, `AUS`, `CAN`, `EUR`, `FRA`, `GBR`, `IND`, `JPN`, `LAM`, `NAM`, `` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **Ensure** | Write | String | Specify if this label policy should exist or not. | `Present`, `Absent` |

## Description

This resource configures a Security Filter in Security and Compliance.

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
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SCSecurityFilter 'ConfigureSecurityLabel'
        {
            FilterName      = "My Filter Name"
            Action          = "All"
            Users           = @("jonh.doe@1234.onmicrosoft.com")
            Description     = "Demo Security Label description"
            Filters         = @("Mailbox_CountryCode -eq '124'")
            Region          = "AUS"
            Ensure          = "Present"
            Credential      = $Credscredential
        }
    }
}
```

