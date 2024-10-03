# SentinelWatchlist

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | Tha name of the watchlist. | |
| **SubscriptionId** | Write | String | The name of the resource group. The name is case insensitive. | |
| **ResourceGroupName** | Write | String | The name of the resource group. The name is case insensitive. | |
| **WorkspaceName** | Write | String | The name of the workspace. | |
| **Id** | Write | String | The id (a Guid) of the watchlist | |
| **DisplayName** | Write | String | The display name of the watchlist. | |
| **SourceType** | Write | String | The source of the watchlist. Only accepts 'Local file' and 'Remote storage'. And it must included in the request. | |
| **ItemsSearchKey** | Write | String | The search key is used to optimize query performance when using watchlists for joins with other data. For example, enable a column with IP addresses to be the designated SearchKey field, then use this field as the key field when joining to other event data by IP address. | |
| **Description** | Write | String | A description of the watchlist | |
| **DefaultDuration** | Write | String | The default duration of a watchlist (in ISO 8601 duration format) | |
| **Alias** | Write | String | The watchlist alias | |
| **NumberOfLinesToSkip** | Write | UInt32 | The number of lines in a csv content to skip before the header | |
| **RawContent** | Write | String | The raw content that represents to watchlist items to create. Example : This line will be skipped header1,header2 value1,value2 | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Absent`, `Present` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Configures watchlists in Azure Sentinel.

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
        SentinelWatchlist "SentinelWatchlist-TestWatch"
        {
            Alias                 = "MyAlias";
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            DefaultDuration       = "P1DT3H";
            Description           = "My description";
            DisplayName           = "My Display Name";
            Ensure                = "Present";
            ItemsSearchKey        = "Test";
            Name                  = "MyWatchList";
            NumberOfLinesToSkip   = 1;
            RawContent            = 'MyContent'
            ResourceGroupName     = "MyResourceGroup";
            SourceType            = "Local";
            SubscriptionId        = "20f41296-9edc-4374-b5e0-b1c1aa07e7d3";
            TenantId              = $TenantId;
            WorkspaceName         = "MyWorkspace";
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
        SentinelWatchlist "SentinelWatchlist-TestWatch"
        {
            Alias                 = "MyAlias";
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            DefaultDuration       = "P1DT3H";
            Description           = "My description";
            DisplayName           = "My Display Name";
            Ensure                = "Present";
            ItemsSearchKey        = "Test";
            Name                  = "MyWatchList";
            NumberOfLinesToSkip   = 0; # Drift
            RawContent            = 'MyContent'
            ResourceGroupName     = "MyResourceGroup";
            SourceType            = "Local";
            SubscriptionId        = "20f41296-9edc-4374-b5e0-b1c1aa07e7d3";
            TenantId              = $TenantId;
            WorkspaceName         = "MyWorkspace";
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
        SentinelWatchlist "SentinelWatchlist-TestWatch"
        {
            Alias                 = "MyAlias";
            ApplicationId         = $ApplicationId;
            CertificateThumbprint = $CertificateThumbprint;
            DefaultDuration       = "P1DT3H";
            Description           = "My description";
            DisplayName           = "My Display Name";
            Ensure                = "Absent";
            ItemsSearchKey        = "Test";
            Name                  = "MyWatchList";
            NumberOfLinesToSkip   = 1;
            RawContent            = 'MyContent'
            ResourceGroupName     = "MyResourceGroup";
            SourceType            = "Local";
            SubscriptionId        = "20f41296-9edc-4374-b5e0-b1c1aa07e7d3";
            TenantId              = $TenantId;
            WorkspaceName         = "MyWorkspace";
        }
    }
}
```

