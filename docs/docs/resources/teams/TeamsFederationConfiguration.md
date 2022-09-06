# TeamsFederationConfiguration

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The only valid input is Global - the tenant wide configuration |Global|
| **AllowFederatedUsers** | Write | Boolean | When set to True users will be potentially allowed to communicate with users from other domains. ||
| **AllowedDomains** | Write | StringArray[] | List of federated domains to allow. ||
| **BlockedDomains** | Write | StringArray[] | List of federated domains to block. ||
| **AllowPublicUsers** | Write | Boolean | When set to True users will be potentially allowed to communicate with users who have accounts on public IM and presence providers. ||
| **AllowTeamsConsumer** | Write | Boolean | Allows federation with people using Teams with an account that's not managed by an organization. ||
| **AllowTeamsConsumerInbound** | Write | Boolean | Allows people using Teams with an account that's not managed by an organization, to discover and start communication with users in your organization. ||
| **Credential** | Required | PSCredential | Credentials of the Teams Admin ||

# TeamsFederationConfiguration

### Description

This resource is used to configure the Teams Federation Configuration (CsTenantFederationConfiguration).
In the Teams admin center this is available in 'External access' in the Users section.

More information: https://docs.microsoft.com/en-us/microsoftteams/manage-external-access

## Examples

### Example 1

This examples sets the Teams Federation Configuration.

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
        TeamsFederationConfiguration 'FederationConfiguration'
        {
            Identity                  = "Global"
            AllowFederatedUsers       = $True
            AllowPublicUsers          = $True
            AllowTeamsConsumer        = $False
            AllowTeamsConsumerInbound = $False
            Credential                = $credsGlobalAdmin
        }
    }
}
```

