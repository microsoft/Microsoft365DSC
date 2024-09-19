# SCInsiderRiskEntityList

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The name of the group or setting. | |
| **ListType** | Required | String | The setting type. | |
| **Description** | Write | String | Description for the group or setting. | |
| **DisplayName** | Write | String | The display name of the group or setting. | |
| **Domains** | Write | MSFT_SCInsiderRiskEntityListDomain[] | List of domains | |
| **FilePaths** | Write | StringArray[] | List of file paths. | |
| **FileTypes** | Write | StringArray[] | List of file types. | |
| **Keywords** | Write | StringArray[] | List of keywords. | |
| **SensitiveInformationTypes** | Write | StringArray[] | List of sensitive information types. | |
| **Sites** | Write | MSFT_SCInsiderRiskEntityListSite[] | List of sites. | |
| **TrainableClassifiers** | Write | StringArray[] | List of trainable classifiers. | |
| **ExceptionKeyworkGroups** | Write | StringArray[] | List of keywords for exception. | |
| **ExcludedClassifierGroups** | Write | StringArray[] | List of excluded trainable classifiers. | |
| **ExcludedDomainGroups** | Write | StringArray[] | List of excluded domains. | |
| **ExcludedFilePathGroups** | Write | StringArray[] | List of excluded file paths. | |
| **ExcludedFileTypeGroups** | Write | StringArray[] | List of excluded file types. | |
| **ExcludedKeyworkGroups** | Write | StringArray[] | List of excluded keywords. | |
| **ExcludedSensitiveInformationTypeGroups** | Write | StringArray[] | List of excluded sensitive information types. | |
| **ExcludedSiteGroups** | Write | StringArray[] | List of excluded sites. | |
| **Ensure** | Write | String | Specify if this entity should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_SCInsiderRiskEntityListDomain

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Dmn** | Required | String | Domain name. | |
| **isMLSubDmn** | Write | Boolean | Defines if the entry should include multi-level subdomains or not. | |

### MSFT_SCInsiderRiskEntityListSite

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Url** | Required | String | Url of the site. | |
| **Name** | Write | String | Name of the site. | |
| **Guid** | Write | String | Unique identifier of the site. | |


## Description

Configures settings for Insider Risk in Purview.

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
        SCInsiderRiskEntityList "SCInsiderRiskEntityList-MyFileType"
        {
            ApplicationId                          = $ApplicationId;
            CertificateThumbprint                  = $CertificateThumbprint;
            Description                            = "Test file type";
            DisplayName                            = "MyFileType";
            Ensure                                 = "Present";
            FileTypes                              = @(".exe",".cmd",".bat");
            Keywords                               = @();
            ListType                               = "CustomFileTypeLists";
            Name                                   = "MyFileTypeList";
            TenantId                               = $OrganizationName;
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
        SCInsiderRiskEntityList "SCInsiderRiskEntityList-MyFileType"
        {
            ApplicationId                          = $ApplicationId;
            CertificateThumbprint                  = $CertificateThumbprint;
            Description                            = "Test file type";
            DisplayName                            = "MyFileType";
            Ensure                                 = "Present";
            FileTypes                              = @(".exe",".txt",".bat"); # Drfit
            Keywords                               = @();
            ListType                               = "CustomFileTypeLists";
            Name                                   = "MyFileTypeList";
            TenantId                               = $OrganizationName;
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
        SCInsiderRiskEntityList "SCInsiderRiskEntityList-MyFileType"
        {
            ApplicationId                          = $ApplicationId;
            CertificateThumbprint                  = $CertificateThumbprint;
            Description                            = "Test file type";
            DisplayName                            = "MyFileType";
            Ensure                                 = "Absent";
            FileTypes                              = @(".exe",".cmd",".bat");
            Keywords                               = @();
            ListType                               = "CustomFileTypeLists";
            Name                                   = "MyFileTypeList";
            TenantId                               = $OrganizationName;
        }
    }
}
```

