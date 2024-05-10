# SPOSite

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Url** | Key | String | The URL of the site collection. | |
| **Title** | Required | String | The title of the site collection. | |
| **Owner** | Required | String | Specifies the owner of the site. | |
| **TimeZoneId** | Required | UInt32 | TimeZone ID of the site collection. | |
| **Template** | Write | String | Specifies with template of site to create. | |
| **HubUrl** | Write | String | The URL of the Hub site the site collection needs to get connected to. | |
| **DisableFlows** | Write | Boolean | Disables Microsoft Flow for this site. | |
| **SharingCapability** | Write | String | Specifies what the sharing capabilities are for the site. Possible values: Disabled, ExternalUserSharingOnly, ExternalUserAndGuestSharing, ExistingExternalUserSharingOnly. | `Disabled`, `ExistingExternalUserSharingOnly`, `ExternalUserSharingOnly`, `ExternalUserAndGuestSharing` |
| **StorageMaximumLevel** | Write | UInt32 | Specifies the storage quota for this site collection in megabytes. This value must not exceed the company's available quota. | |
| **StorageWarningLevel** | Write | UInt32 | Specifies the warning level for the storage quota in megabytes. This value must not exceed the values set for the StorageMaximumLevel parameter. | |
| **AllowSelfServiceUpgrade** | Write | Boolean | Specifies if the site administrator can upgrade the site collection. | |
| **CommentsOnSitePagesDisabled** | Write | Boolean | Specifies if comments on site pages are enabled or disabled. | |
| **DefaultLinkPermission** | Write | String | Specifies the default link permission for the site collection. None - Respect the organization default link permission. View - Sets the default link permission for the site to 'view' permissions. Edit - Sets the default link permission for the site to 'edit' permissions. | `None`, `View`, `Edit` |
| **DefaultSharingLinkType** | Write | String | Specifies the default link type for the site collection. None - Respect the organization default sharing link type. AnonymousAccess - Sets the default sharing link for this site to an Anonymous Access or Anyone link. Internal - Sets the default sharing link for this site to the 'organization' link or company shareable link. Direct - Sets the default sharing link for this site to the 'Specific people' link. | `None`, `AnonymousAccess`, `Internal`, `Direct` |
| **DisableAppViews** | Write | String | Disables App Views. | `Unknown`, `Disabled`, `NotDisabled` |
| **DisableCompanyWideSharingLinks** | Write | String | Disables Company wide sharing links. | `Unknown`, `Disabled`, `NotDisabled` |
| **LocaleId** | Write | UInt32 | Specifies the language of the new site collection. Defaults to the current language of the web connected to. | |
| **DenyAddAndCustomizePages** | Write | Boolean | Determines whether the Add And Customize Pages right is denied on the site collection. For more information about permission levels, see User permissions and permission levels in SharePoint. | |
| **RestrictedToRegion** | Write | String | Defines geo-restriction settings for this site | `NoRestriction`, `BlockMoveOnly`, `BlockFull`, `Unknown` |
| **SharingAllowedDomainList** | Write | String | Specifies a list of email domains that is allowed for sharing with the external collaborators. Use the space character as the delimiter. | |
| **SharingBlockedDomainList** | Write | String | Specifies a list of email domains that is blocked for sharing with the external collaborators. | |
| **SharingDomainRestrictionMode** | Write | String | Specifies the external sharing mode for domains. | `None`, `AllowList`, `BlockList` |
| **ShowPeoplePickerSuggestionsForGuestUsers** | Write | Boolean | To enable the option to search for existing guest users at Site Collection Level, set this parameter to $true. | |
| **AnonymousLinkExpirationInDays** | Write | UInt32 | Specifies that all anonymous/anyone links that have been created (or will be created) will expire after the set number of days. Only applies if OverrideTenantAnonymousLinkExpirationPolicy is set to true. To remove the expiration requirement, set the value to zero (0) | |
| **SocialBarOnSitePagesDisabled** | Write | Boolean | Disables or enables the Social Bar for Site Collection. | |
| **OverrideTenantAnonymousLinkExpirationPolicy** | Write | Boolean | False - Respect the organization-level policy for anonymous or anyone link expiration. True - Override the organization-level policy for anonymous or anyone link expiration (can be more or less restrictive) | |
| **Ensure** | Write | String | Present ensures the site collection exists, absent ensures it is removed | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the account to authenticate with. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for certificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

This resource allows users to create and monitor SharePoint Online Site Collections.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Application.Read.All, Domain.Read.All

- **Update**

    - Domain.Read.All

#### Application permissions

- **Read**

    - Application.Read.All, Domain.Read.All

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
        SPOSite 'ConfigureTestSite'
        {
            Url                            = "https://contoso.sharepoint.com/sites/testsite1"
            StorageMaximumLevel            = 26214400
            LocaleId                       = 1033
            Template                       = "STS#3"
            Owner                          = "admin@contoso.onmicrosoft.com"
            Title                          = "TestSite"
            TimeZoneId                     = 13
            StorageWarningLevel            = 25574400
            SharingCapability              = "Disabled"
            CommentsOnSitePagesDisabled    = $false
            DisableAppViews                = "NotDisabled"
            DisableCompanyWideSharingLinks = "NotDisabled"
            DisableFlows                   = $false
            DefaultSharingLinkType         = "None"
            DefaultLinkPermission          = "None"
            Ensure                         = "Present"
            Credential                     = $Credscredential
        }
    }
}
```

