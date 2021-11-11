# SPOTenantSettings

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Specifies the resource is a single instance, the value must be 'Yes' |Yes|
| **MinCompatibilityLevel** | Write | UInt32 | Specifies the lower bound on the compatibility level for new sites. ||
| **MaxCompatibilityLevel** | Write | UInt32 | Specifies the upper bound on the compatibility level for new sites. ||
| **SearchResolveExactEmailOrUPN** | Write | Boolean | Removes the search capability from People Picker. Note, recently resolved names will still appear in the list until browser cache is cleared or expired. ||
| **OfficeClientADALDisabled** | Write | Boolean | When set to true this will disable the ability to use Modern Authentication that leverages ADAL across the tenant. ||
| **LegacyAuthProtocolsEnabled** | Write | Boolean | Setting this parameter prevents Office clients using non-modern authentication protocols from accessing SharePoint Online resources. ||
| **RequireAcceptingAccountMatchInvitedAccount** | Write | Boolean | DEPRECATED ||
| **SignInAccelerationDomain** | Write | String | Specifies the home realm discovery value to be sent to Azure Active Directory (AAD) during the user sign-in process. ||
| **UsePersistentCookiesForExplorerView** | Write | Boolean | Lets SharePoint issue a special cookie that will allow this feature to work even when Keep Me Signed In is not selected. ||
| **UserVoiceForFeedbackEnabled** | Write | Boolean | Allow feedback via UserVoice. ||
| **PublicCdnEnabled** | Write | Boolean | Configure PublicCDN ||
| **PublicCdnAllowedFileTypes** | Write | String | Configure filetypes allowed for PublicCDN ||
| **UseFindPeopleInPeoplePicker** | Write | Boolean | When set to $true, users aren't able to share with security groups or SharePoint groups ||
| **NotificationsInSharePointEnabled** | Write | Boolean | When set to $true, users aren't able to share with security groups or SharePoint groups ||
| **OwnerAnonymousNotification** | Write | Boolean |  ||
| **ApplyAppEnforcedRestrictionsToAdHocRecipients** | Write | Boolean |  ||
| **FilePickerExternalImageSearchEnabled** | Write | Boolean |  ||
| **HideDefaultThemes** | Write | Boolean | Defines if the default themes are visible or hidden ||
| **MarkNewFilesSensitiveByDefault** | Write | String | Allow or block external sharing until at least one Office DLP policy scans the content of the file. |AllowExternalSharing, BlockExternalSharing|
| **ConditionalAccessPolicy** | Write | String | Allow or Block Conditional Access Policy on the SharePoint Tenant |AllowFullAccess, AllowLimitedAccess, BlockAccess|
| **DisabledWebPartIds** | Write | String | Provide GUID for the Web Parts that are to be disabled on the Sharepoint Site ||
| **Ensure** | Write | String | Only accepted value is 'Present'. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the account to authenticate with. ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for certificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||


# SPO Tenant Settings

This resource allows users to configure and monitor the tenant settings for
their SPO tenant settings.


## Azure AD Permissions

To authenticate via Azure Active Directory, this resource required the following Application permissions:

* **Automate**
  * SharePoint
    * Sites.FullControl.All
* **Export**
  * SharePoint
    * Sites.FullControl.All

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
        SPOTenantSettings 'ConfigureTenantSettings'
        {
            IsSingleInstance                              = "Yes"
            MinCompatibilityLevel                         = 16
            MaxCompatibilityLevel                         = 16
            SearchResolveExactEmailOrUPN                  = $false
            OfficeClientADALDisabled                      = $false
            LegacyAuthProtocolsEnabled                    = $true
            SignInAccelerationDomain                      = ""
            UsePersistentCookiesForExplorerView           = $false
            UserVoiceForFeedbackEnabled                   = $true
            PublicCdnEnabled                              = $false
            PublicCdnAllowedFileTypes                     = "CSS,EOT,GIF,ICO,JPEG,JPG,JS,MAP,PNG,SVG,TTF,WOFF"
            UseFindPeopleInPeoplePicker                   = $false
            NotificationsInSharePointEnabled              = $true
            OwnerAnonymousNotification                    = $true
            ApplyAppEnforcedRestrictionsToAdHocRecipients = $true
            FilePickerExternalImageSearchEnabled          = $true
            HideDefaultThemes                             = $false
            MarkNewFilesSensitiveByDefault                = "AllowExternalSharing"
            Ensure                                        = "Present"
            Credential                                    = $credsGlobalAdmin
        }
    }
}
```

