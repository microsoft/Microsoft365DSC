# TeamsMeetingBroadcastConfiguration

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The only valid input is Global - the tenant wide configuration | `Global` |
| **SupportURL** | Write | String | Specifies a URL where broadcast event attendees can find support information or FAQs specific to that event. The URL will be displayed to the attendees during the broadcast. | |
| **AllowSdnProviderForBroadcastMeeting** | Write | Boolean | If set to $true, Teams meeting broadcast streams are enabled to take advantage of the network and bandwidth management capabilities of your Software Defined Network (SDN) provider. | |
| **SdnProviderName** | Write | String | Specifies the Software Defined Network (SDN) provider's name. This parameter is only required if AllowSdnProviderForBroadcastMeeting is set to $true. | |
| **SdnLicenseId** | Write | String | Specifies the Software Defined Network (SDN) license identifier. This is required and provided by some SDN providers. This parameter is only required if AllowSdnProviderForBroadcastMeeting is set to $true. | |
| **SdnApiTemplateUrl** | Write | String | Specifies the Software Defined Network (SDN) provider's HTTP API endpoint. This information is provided to you by the SDN provider. This parameter is only required if AllowSdnProviderForBroadcastMeeting is set to $true. | |
| **SdnApiToken** | Write | String | Specifies the Software Defined Network (SDN) provider's authentication token which is required to use their SDN license. This is required by some SDN providers who will give you the required token. This parameter is only required if AllowSdnProviderForBroadcastMeeting is set to $true. | |
| **Credential** | Write | PSCredential | Credentials of the Teams Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

##  Description

This resource is used to configure the Teams Meeting Broadcast Settings.

More information: https://docs.microsoft.com/en-us/microsoftteams/teams-live-events/configure-teams-live-events

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

    - Organization.Read.All

- **Update**

    - Organization.Read.All

## Examples

### Example 1

This example adds a new Teams Meeting Policy.

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
        TeamsMeetingBroadcastConfiguration 'MeetingBroadcastConfiguration'
        {
            Identity                            = 'Global'
            AllowSdnProviderForBroadcastMeeting = $True
            SupportURL                          = "https://support.office.com/home/contact"
            SdnProviderName                     = "hive"
            SdnLicenseId                        = "5c12d0-d52950-e03e66-92b587"
            SdnApiTemplateUrl                   = "https://api.hivestreaming.com/v1/eventadmin?partner_token={0}"
            Credential                          = $Credscredential
        }
    }
}
```

