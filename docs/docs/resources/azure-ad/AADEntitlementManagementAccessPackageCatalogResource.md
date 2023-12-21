# AADEntitlementManagementAccessPackageCatalogResource

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | The display name of the resource, such as the application name, group name or site name. | |
| **Id** | Write | String | Id of the access package catalog resource. | |
| **CatalogId** | Write | String | The unique ID of the access package catalog. | |
| **AddedBy** | Write | String | The name of the user or application that first added this resource. Read-only. | |
| **AddedOn** | Write | String | The Timestamp type represents date and time information using ISO 8601 format and is always in UTC time. For example, midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z. Read-only. | |
| **Attributes** | Write | MSFT_MicrosoftGraphaccesspackageresourceattribute[] | Contains information about the attributes to be collected from the requestor and sent to the resource application. | |
| **Description** | Write | String | A description for the resource. | |
| **IsPendingOnboarding** | Write | Boolean | True if the resource is not yet available for assignment. Read-only. | |
| **OriginId** | Write | String | The unique identifier of the resource in the origin system. In the case of an Azure AD group, this is the identifier of the group. | |
| **OriginSystem** | Write | String | The type of the resource in the origin system. | |
| **ResourceType** | Write | String | The type of the resource. | |
| **Url** | Write | String | A unique resource locator for the resource, such as the URL for signing a user into an application. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Intune Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

### MSFT_MicrosoftGraphaccesspackageresourceattribute

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **AttributeDestination** | Write | MSFT_MicrosoftGraphaccesspackageresourceattributedestination | Information about how to set the attribute, currently a accessPackageUserDirectoryAttributeStore object type. | |
| **AttributeName** | Write | String | The name of the attribute in the end system. | |
| **AttributeSource** | Write | MSFT_MicrosoftGraphaccesspackageresourceattributesource | Information about how to populate the attribute value when an accessPackageAssignmentRequest is being fulfilled, currently a accessPackageResourceAttributeQuestion object type. | |
| **Id** | Write | String | Id of the access package resource attribute. | |
| **IsEditable** | Write | Boolean | Specifies whether or not an existing attribute value can be edited by the requester. | |
| **IsPersistedOnAssignmentRemoval** | Write | Boolean | Specifies whether the attribute will remain in the end system after an assignment ends. | |

### MSFT_MicrosoftGraphaccesspackageresourceattributedestination

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **odataType** | Write | String | Type of the access package resource attribute destination. | `#microsoft.graph.accessPackageUserDirectoryAttributeStore` |

### MSFT_MicrosoftGraphaccesspackageresourceattributesource

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **odataType** | Write | String | Type of the access package resource attribute source. | `#microsoft.graph.accessPackageResourceAttributeQuestion` |
| **Question** | Write | MSFT_MicrosoftGraphaccessPackageResourceAttributeQuestion | The question asked in order to get the value of the attribute. | |

### MSFT_MicrosoftGraphaccessPackageResourceAttributeQuestion

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **odataType** | Write | String | Type of the access package resource attribute question. | `#microsoft.graph.accessPackageTextInputQuestion`, `#microsoft.graph.accessPackageMultipleChoiceQuestion` |
| **Id** | Write | String | Id of the access package resource attribute question. | |
| **IsRequired** | Write | Boolean | Indicates whether the requestor is required to supply an answer or not. | |
| **IsSingleLine** | Write | Boolean | Indicates whether the answer will be in single or multiple line format. | |
| **RegexPattern** | Write | String | This is the regex pattern that the corresponding text answer must follow. | |
| **Sequence** | Write | UInt32 | Relative position of this question when displaying a list of questions to the requestor. | |
| **QuestionText** | Write | MSFT_MicrosoftGraphaccessPackageLocalizedContent | The text of the question to show to the requestor. | |
| **AllowsMultipleSelection** | Write | Boolean | Indicates whether requestor can select multiple choices as their answer. | |
| **Choices** | Write | MSFT_MicrosoftGraphaccessPackageAnswerChoice[] | List of answer choices. | |

### MSFT_MicrosoftGraphaccessPackageLocalizedContent

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DefaultText** | Write | String | The fallback string, which is used when a requested localization is not available. Required. | |
| **LocalizedTexts** | Write | MSFT_MicrosoftGraphaccessPackageLocalizedText[] | Content represented in a format for a specific locale. | |

### MSFT_MicrosoftGraphaccessPackageLocalizedText

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Text** | Write | String | The text in the specific language. Required. | |
| **LanguageCode** | Write | String | The ISO code for the intended language. Required. | |

### MSFT_MicrosoftGraphaccessPackageAnswerChoice

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **ActualValue** | Write | String | The actual value of the selected choice. This is typically a string value which is understandable by applications. Required. | |
| **displayValue** | Write | MSFT_MicrosoftGraphaccessPackageLocalizedContent | The localized display values shown to the requestor and approvers. Required. | |


## Description

This resource configures an Azure AD Entitlement Management Access Package Catalog Resource.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - EntitlementManagement.Read.All

- **Update**

    - EntitlementManagement.ReadWrite.All

#### Application permissions

- **Read**

    - EntitlementManagement.Read.All

- **Update**

    - EntitlementManagement.ReadWrite.All

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
        AADEntitlementManagementAccessPackageCatalogResource 'myAccessPackageCatalogResource'
        {
            DisplayName         = 'Communication site'
            AddedBy             = 'admin@contoso.onmicrosoft.com'
            AddedOn             = '05/11/2022 16:21:15'
            CatalogId           = 'f34c2d92-9e9d-4703-ba9b-955b6ac8dcb3'
            Description         = 'https://contoso.sharepoint.com/'
            IsPendingOnboarding = $False
            OriginId            = 'https://contoso.sharepoint.com/'
            OriginSystem        = 'SharePointOnline'
            ResourceType        = 'SharePoint Online Site'
            Url                 = 'https://contoso.sharepoint.com/'
            Ensure              = 'Present'
            Credential          = $Credscredential
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
        AADEntitlementManagementAccessPackageCatalogResource 'myAccessPackageCatalogResource'
        {
            DisplayName         = 'Communication site'
            AddedBy             = 'admin@contoso.onmicrosoft.com'
            AddedOn             = '05/11/2022 16:21:15'
            CatalogId           = 'f34c2d92-9e9d-4703-ba9b-955b6ac8dcb3'
            Description         = 'https://contoso.sharepoint.com/'
            IsPendingOnboarding = $False # Updated Property
            OriginId            = 'https://contoso.sharepoint.com/'
            OriginSystem        = 'SharePointOnline'
            ResourceType        = 'SharePoint Online Site'
            Url                 = 'https://contoso.sharepoint.com/'
            Ensure              = 'Present'
            Credential          = $Credscredential
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
        AADEntitlementManagementAccessPackageCatalogResource 'myAccessPackageCatalogResource'
        {
            DisplayName         = 'Communication site'
            Ensure              = 'Absent'
            Credential          = $Credscredential
        }
    }
}
```

