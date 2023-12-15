# TeamsFederationConfiguration

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The only valid input is Global - the tenant wide configuration | `Global` |
| **AllowFederatedUsers** | Write | Boolean | When set to True users will be potentially allowed to communicate with users from other domains. | |
| **AllowedDomains** | Write | StringArray[] | List of federated domains to allow. | |
| **BlockedDomains** | Write | StringArray[] | List of federated domains to block. | |
| **AllowPublicUsers** | Write | Boolean | When set to True users will be potentially allowed to communicate with users who have accounts on public IM and presence providers. | |
| **AllowTeamsConsumer** | Write | Boolean | Allows federation with people using Teams with an account that's not managed by an organization. | |
| **AllowTeamsConsumerInbound** | Write | Boolean | Allows people using Teams with an account that's not managed by an organization, to discover and start communication with users in your organization. | |
| **TreatDiscoveredPartnersAsUnverified** | Write | Boolean | When set to True, messages sent from discovered partners are considered unverified. That means that those messages will be delivered only if they were sent from a person who is on the recipient's Contacts list. | |
| **SharedSipAddressSpace** | Write | Boolean | When set to True, indicates that the users homed on Skype for Business Online use the same SIP domain as users homed on the on-premises version of Skype for Business Server. | |
| **RestrictTeamsConsumerToExternalUserProfiles** | Write | Boolean | When set to True, Teamsconsumer have access only to external user profiles | |
| **Credential** | Write | PSCredential | Credentials of the Teams Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |

## Description

This resource is used to configure the Teams Federation Configuration (CsTenantFederationConfiguration).
In the Teams admin center this is available in 'External access' in the Users section.

More information: https://docs.microsoft.com/en-us/microsoftteams/manage-external-access

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

    - Organization.Read.All, User.Read.All, Group.ReadWrite.All, AppCatalog.ReadWrite.All, TeamSettings.ReadWrite.All, Channel.Delete.All, ChannelSettings.ReadWrite.All, ChannelMember.ReadWrite.All

- **Update**

    - Organization.Read.All, User.Read.All, Group.ReadWrite.All, AppCatalog.ReadWrite.All, TeamSettings.ReadWrite.All, Channel.Delete.All, ChannelSettings.ReadWrite.All, ChannelMember.ReadWrite.All

## Examples

### Example 1

This examples sets the Teams Federation Configuration.

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
        TeamsFederationConfiguration 'FederationConfiguration'
        {
            Identity                                    = "Global";
            AllowedDomains                              = @();
            BlockedDomains                              = @();
            AllowFederatedUsers                         = $True;
            AllowPublicUsers                            = $True;
            AllowTeamsConsumer                          = $True;
            AllowTeamsConsumerInbound                   = $True;
            RestrictTeamsConsumerToExternalUserProfiles = $False;
            SharedSipAddressSpace                       = $False;
            TreatDiscoveredPartnersAsUnverified         = $False;
            Credential                                  = $Credscredential
        }
    }
}
```

