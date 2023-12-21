# SPOSearchManagedProperty

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name of the Managed Property | |
| **Type** | Key | String | The Type of the Managed Property | `Text`, `Integer`, `Decimal`, `DateTime`, `YesNo`, `Double`, `Binary` |
| **Description** | Write | String | Description of the Managed Property | |
| **Searchable** | Write | Boolean | Enables querying against the content of the managed property.  The content of this managed property is included in the full-text index. For example, if the property is 'author', a simple query for 'Smith' returns items containing the word 'Smith' and items whose author property contains 'Smith'. | |
| **FullTextIndex** | Write | String | Defines which full-text index the Managed Property is stored in. | |
| **FullTextContext** | Write | UInt32 | Defines the context of a managed property within its full-text index. | |
| **Queryable** | Write | Boolean | Enables querying against the specific Managed Property. The Managed Property field name must be included in the query, either specified in the query itself or included in the query programmatically. If the Managed Property is 'author', the query must contain 'author:Smith'. | |
| **Retrievable** | Write | Boolean | Enables the content of this managed property to be returned in search results. Enable this setting for managed properties that are relevant to present in search results. | |
| **AllowMultipleValues** | Write | Boolean | Allow multiple values of the same type in this managed property. For example, if this is the 'author' managed property, and a document has multiple authors, each author name will be stored as a separate value in this managed property. | |
| **Refinable** | Write | String | Yes: Enables using the property as a refiner for search results in the front end. You must manually configure the refiner in the web part. Yes - latent: Enables switching refinable to active later, without having to do a full re-crawl when you switch. Both options require a full crawl to take effect. | `No`, `Yes - latent`, `Yes` |
| **Sortable** | Write | String | Yes: Enables sorting the result set based on the property before the result set is returned. Use for example for large result sets that cannot be sorted and retrieved at the same time. Yes - latent: Enables switching sortable to active later, without having to do a full re-crawl when you switch. Both options require a full crawl to take effect. | `No`, `Yes - latent`, `Yes` |
| **Safe** | Write | Boolean | Enables this managed property to be returned for queries executed by anonymous users. Enable this setting for managed properties that do not contain sensitive information and are appropriate for anonymous users to view. | |
| **Aliases** | Write | StringArray[] | Define an alias for a managed property if you want to use the alias instead of the managed property name in queries and in search results. Use the original managed property and not the alias to map to a crawled property. Use an alias if you don't want to or don't have permission to create a new managed property. | |
| **TokenNormalization** | Write | Boolean | Enable to return results independent of letter casing and diacritics(for example accented characters) used in the query. | |
| **CompleteMatching** | Write | Boolean | By default, search returns partial matches between queries against this managed property and its content. Select Complete Matching for search to return exact matches instead. If a managed property 'Title' contains 'Contoso Sites', only the query Title: 'Contoso Sites' will give a result. | |
| **LanguageNeutralTokenization** | Write | Boolean | By default, search depends on language when it breaks queries and content into parts (tokenization). Select language neutral tokenization if you have multilingual content and this managed property contains tags that are based on metadata term sets or other identifiers. | |
| **FinerQueryTokenization** | Write | Boolean | By default, search tokenizes queries coarser than content. If a managed property 'ID' contains the string '1-23-456#7', and you query ID:'1-23', you might not get a partial match because search didn't break the query into small enough parts. Consider selecting finer query tokenization if the content of this managed property contains separators such as dots and dashes. Finer query tokenization makes queries against this managed property slower. | |
| **MappedCrawledProperties** | Write | StringArray[] | Names of the crawled properties that are mapped to this managed property | |
| **CompanyNameExtraction** | Write | Boolean | Enables the system to extract company name entities from the managed property when crawling new or updated items. Afterwards, the extracted entities can be used to set up refiners in the web part. | |
| **Ensure** | Write | String | Present ensures the Search Managed Property exists. | `Present` |
| **Credential** | Write | PSCredential | Credentials of the account to authenticate with. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for certificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource allows users to create and monitor SharePoint Online Search
Managed Properties.

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
        SPOSearchManagedProperty 'ConfigureSearchMP'
        {
            Searchable                  = $True
            FullTextIndex               = ""
            MappedCrawledProperties     = @()
            LanguageNeutralTokenization = $True
            CompanyNameExtraction       = $False
            AllowMultipleValues         = $True
            Aliases                     = $True
            Queryable                   = $True
            Name                        = "TestManagedProperty"
            Safe                        = $True
            Description                 = "Description of item"
            FinerQueryTokenization      = $True
            Retrievable                 = $True
            Type                        = "Text"
            CompleteMatching            = $True
            FullTextContext             = 4
            Sortable                    = "Yes"
            Refinable                   = "Yes"
            TokenNormalization          = $True
            Ensure                      = "Present"
            Credential                  = $Credscredential
        }
    }
}
```

