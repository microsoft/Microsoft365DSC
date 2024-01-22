# EXOSafeLinksPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the SafeLinks policy that you want to modify. | |
| **Ensure** | Write | String | Specify if this policy should exist or not. | `Present`, `Absent` |
| **AdminDisplayName** | Write | String | The AdminDisplayName parameter specifies a description for the policy. | |
| **AllowClickThrough** | Write | Boolean | The AllowClickThrough parameter specifies whether to allow users to click through to the original URL on warning pages. | |
| **CustomNotificationText** | Write | String | The custom notification text specifies the customized notification text to show to users. | |
| **DeliverMessageAfterScan** | Write | Boolean | The DeliverMessageAfterScan parameter specifies whether to deliver email messages only after Safe Links scanning is complete. Valid values are: $true: Wait until Safe Links scanning is complete before delivering the message. $false: If Safe Links scanning can't complete, deliver the message anyway. This is the default value. | |
| **DoNotRewriteUrls** | Write | StringArray[] | The DoNotRewriteUrls parameter specifies a URL that's skipped by Safe Links scanning. You can specify multiple values separated by commas. | |
| **EnableForInternalSenders** | Write | Boolean | The EnableForInternalSenders parameter specifies whether the Safe Links policy is applied to messages sent between internal senders and internal recipients within the same Exchange Online organization. | |
| **EnableOrganizationBranding** | Write | Boolean | The EnableOrganizationBranding parameter specifies whether your organization's logo is displayed on Safe Links warning and notification pages. | |
| **EnableSafeLinksForOffice** | Write | Boolean | The EnableSafeLinksForOffice parameter specifies whether to enable Safe Links protection for supported Office desktop, mobile, or web apps. | |
| **EnableSafeLinksForTeams** | Write | Boolean | The EnableSafeLinksForTeams parameter specifies whether Safe Links is enabled for Microsoft Teams. Valid values are: $true: Safe Links is enabled for Teams. If a protected user clicks a malicious link in a Teams conversation, group chat, or from channels, a warning page will appear in the default web browser. $false: Safe Links isn't enabled for Teams. This is the default value. | |
| **EnableSafeLinksForEmail** | Write | Boolean | The EnableSafeLinksForEmail parameter specifies whether to enable Safe Links protection for email messages. Valid values are: $true: Safe Links is enabled for email. When a user clicks a link in an email, the link is checked by Safe Links. If the link is found to be malicious, a warning page appears in the default web browser. $false: Safe Links isn't enabled for email. This is the default value. | |
| **DisableUrlRewrite** | Write | Boolean | The DisableUrlRewrite parameter specifies whether to rewrite (wrap) URLs in email messages. Valid values are: $true: URLs in messages are not rewritten, but messages are still scanned by Safe Links prior to delivery. Time of click checks on links are done using the Safe Links API in supported Outlook clients (currently, Outlook for Windows and Outlook for Mac). Typically, we don't recommend using this value. $false: URLs in messages are rewritten. API checks still occur on unwrapped URLs in supported clients if the user is in a valid Safe Links policy. This is the default value. | |
| **ScanUrls** | Write | Boolean | The ScanUrls parameter specifies whether to enable or disable the scanning of links in email messages. Valid values are: $true: Scanning links in email messages is enabled. $false: Scanning links in email messages is disabled. This is the default value. | |
| **TrackClicks** | Write | Boolean | The TrackClicks parameter specifies whether to track user clicks related to Safe Links protection of links. | |
| **UseTranslatedNotificationText** | Write | Boolean | The UseTranslatedNotificationText specifies whether to use Microsoft Translator to automatically localize the custom notification text that you specified with the CustomNotificationText parameter. | |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures the settings of the SafeLinks policies
in your cloud-based organization.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Transport Hygiene, Security Admin, View-Only Configuration, Security Reader

#### Role Groups

- Organization Management

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOSafeLinksPolicy 'ConfigureSafeLinksPolicy'
        {
            Identity                      = 'Marketing Block URL'
            AdminDisplayName              = 'Marketing Block URL'
            CustomNotificationText        = 'Blocked URLs for Marketing'
            DeliverMessageAfterScan       = $True
            EnableOrganizationBranding    = $True
            EnableSafeLinksForTeams       = $True
            ScanUrls                      = $True
            UseTranslatedNotificationText = $True
            Ensure                        = 'Present'
            Credential                    = $Credscredential
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
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOSafeLinksPolicy 'ConfigureSafeLinksPolicy'
        {
            Identity                      = 'Marketing Block URL'
            AdminDisplayName              = 'Marketing Block URL'
            CustomNotificationText        = 'Blocked URLs for Marketing'
            DeliverMessageAfterScan       = $True
            EnableOrganizationBranding    = $False # Updated Property
            EnableSafeLinksForTeams       = $True
            ScanUrls                      = $True
            UseTranslatedNotificationText = $True
            Ensure                        = 'Present'
            Credential                    = $Credscredential
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
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOSafeLinksPolicy 'ConfigureSafeLinksPolicy'
        {
            Identity                      = 'Marketing Block URL'
            Ensure                        = 'Absent'
            Credential                    = $Credscredential
        }
    }
}
```

