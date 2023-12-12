# SCComplianceSearch

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the unique name of the complaiance tag. | |
| **Case** | Write | String | Compliance Case (eDiscovery) that this Search is associated with | |
| **AllowNotFoundExchangeLocationsEnabled** | Write | Boolean | The AllowNotFoundExchangeLocationsEnabled parameter specifies whether to include mailboxes other than regular user mailboxes in the compliance search. | |
| **ContentMatchQuery** | Write | String | The ContentMatchQuery parameter specifies a content search filter. This parameter uses a text search string or a query that's formatted by using the Keyword Query Language (KQL). | |
| **Description** | Write | String | The Description parameter specifies an optional description for the compliance search. If the value contains spaces, enclose the value in quotation marks. | |
| **ExchangeLocation** | Write | StringArray[] | The ExchangeLocation parameter specifies the mailboxes to include. | |
| **ExchangeLocationExclusion** | Write | StringArray[] | This parameter specifies the mailboxes to exclude when you use the value All for the ExchangeLocation parameter. | |
| **HoldNames** | Write | StringArray[] | The HoldNames parameter specifies that the content locations that have been placed on hold in the specified eDiscovery case will be searched. You use the value All for this parameter. You also need to specify the name of an eDiscovery case by using the Case parameter. | |
| **IncludeUserAppContent** | Write | Boolean | The IncludeUserAppContent parameter specifies that you want to search the cloud-based storage location for users who don't have a regular Office 365 user account in your organization. These types of users include users without an Exchange Online license who use Office applications, Office 365 guest users, and on-premises users whose identity is synchronized with your Office 365 organization. | |
| **Language** | Write | String | The Language parameter specifies the language for the compliance search. Valid input for this parameter is a supported culture code value from the Microsoft .NET Framework CultureInfo class. For example, da-DK for Danish or ja-JP for Japanese. | |
| **PublicFolderLocation** | Write | StringArray[] | The PublicFolderLocation parameter specifies that you want to include all public folders in the search. You use the value All for this parameter. | |
| **SharePointLocation** | Write | StringArray[] | The SharePointLocation parameter specifies the SharePoint Online sites to include. You identify the site by its URL value, or you can use the value All to include all sites. | |
| **SharePointLocationExclusion** | Write | StringArray[] | This parameter specifies the SharePoint Online sites to exclude when you use the value All for the SharePointLocation parameter. You identify the site by its URL value. | |
| **Ensure** | Write | String | Specify if this search should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Global Admin Account | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |

## Description

This resource configures an Compliance Search (eDiscovery) in Security and Compliance.

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
        SCComplianceSearch 'ConfigureComplianceSearch'
        {
            Case                                  = "Demo Search"
            HoldNames                             = @()
            Name                                  = "Demo Compliance Search"
            Language                              = "iv"
            AllowNotFoundExchangeLocationsEnabled = $False
            SharePointLocation                    = @("All")
            Credential                            = $Credscredential
            Ensure                                = "Present"
        }
    }
}
```

