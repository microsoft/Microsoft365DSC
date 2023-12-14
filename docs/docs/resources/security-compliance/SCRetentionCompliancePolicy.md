# SCRetentionCompliancePolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies the unique name of the retention policy. | |
| **Ensure** | Write | String | Specify if this policy should exist or not. | `Present`, `Absent` |
| **Comment** | Write | String | The Comment parameter specifies an optional comment. | |
| **DynamicScopeLocation** | Write | StringArray[] | Location of the dynamic scope for this policy. | |
| **Enabled** | Write | Boolean | Determines if the policy is enabled or not. | |
| **ExchangeLocation** | Write | StringArray[] | The ExchangeLocation parameter specifies the mailboxes to include. | |
| **ExchangeLocationException** | Write | StringArray[] | This parameter specifies the mailboxes to remove from the list of excluded mailboxes when you use the value All for the ExchangeLocation parameter | |
| **ModernGroupLocation** | Write | StringArray[] | The ModernGroupLocation parameter specifies the Office 365 groups to include in the policy. | |
| **ModernGroupLocationException** | Write | StringArray[] | The ModernGroupLocationException parameter specifies the Office 365 groups to exclude when you're using the value All for the ModernGroupLocation parameter. | |
| **OneDriveLocation** | Write | StringArray[] | The OneDriveLocation parameter specifies the OneDrive for Business sites to include. You identify the site by its URL value, or you can use the value All to include all sites. | |
| **OneDriveLocationException** | Write | StringArray[] | This parameter specifies the OneDrive for Business sites to exclude when you use the value All for the OneDriveLocation parameter. You identify the site by its URL value. | |
| **PublicFolderLocation** | Write | StringArray[] | The PublicFolderLocation parameter specifies that you want to include all public folders in the retention policy. You use the value All for this parameter. | |
| **RestrictiveRetention** | Write | Boolean | The RestrictiveRetention parameter specifies whether Preservation Lock is enabled for the policy. | |
| **SharePointLocation** | Write | StringArray[] | The SharePointLocation parameter specifies the SharePoint Online sites to include. You identify the site by its URL value, or you can use the value All to include all sites. | |
| **SharePointLocationException** | Write | StringArray[] | This parameter specifies the SharePoint Online sites to exclude when you use the value All for the SharePointLocation parameter. You identify the site by its URL value. | |
| **SkypeLocation** | Write | StringArray[] | The SkypeLocation parameter specifies the Skype for Business Online users to include in the policy. | |
| **SkypeLocationException** | Write | StringArray[] | This parameter is reserved for internal Microsoft use. | |
| **TeamsChannelLocation** | Write | StringArray[] | The TeamsChannelLocation parameter specifies the Teams Channel to include in the policy. | |
| **TeamsChannelLocationException** | Write | StringArray[] | This parameter specifies the SharePoint Online sites to exclude when you use the value All for the TeamsChannelLocation parameter. You identify the site by its URL value. | |
| **TeamsChatLocation** | Write | StringArray[] | The TeamsChatLocation parameter specifies the Teams Chat to include in the policy. | |
| **TeamsChatLocationException** | Write | StringArray[] | This parameter specifies the SharePoint Online sites to exclude when you use the value All for the TeamsChatLocation parameter. You identify the site by its URL value. | |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |

## Description

This resource configures a Retention Compliance Policy in Security and Compliance.

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
        SCRetentionCompliancePolicy 'RetentionCompliancePolicy'
        {
            Name               = "MyPolicy"
            Comment            = "Test Policy"
            SharePointLocation = "https://contoso.sharepoint.com/sites/demo"
            Ensure             = "Present"
            Credential         = $Credscredential
        }
    }
}
```

