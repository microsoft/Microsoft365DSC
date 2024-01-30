# TeamsTenantNetworkSite

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Unique identifier for the network site to be created. | |
| **Description** | Write | String | Provide a description of the network site to identify purpose of creating it. | |
| **EmergencyCallingPolicy** | Write | String | This parameter is used to assign a custom emergency calling policy to a network site | |
| **EmergencyCallRoutingPolicy** | Write | String | This parameter is used to assign a custom emergency call routing policy to a network site | |
| **EnableLocationBasedRouting** | Write | Boolean | This parameter determines whether the current site is enabled for location based routing. | |
| **LocationPolicy** | Write | String | LocationPolicy is the identifier for the location policy which the current network site is associating to. | |
| **NetworkRegionID** | Write | String | NetworkRegionID is the identifier for the network region which the current network site is associating to. | |
| **NetworkRoamingPolicy** | Write | String | NetworkRoamingPolicy is the identifier for the network roaming policy to which the network site will associate to. | |
| **SiteAddress** | Write | String | The address of current network site. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |


## Description

As an Admin, you can use the Windows PowerShell command, New-CsTenantNetworkSite to define network sites. Network sites are defined as a collection of IP subnets. Each network site must be associated with a network region. Tenant network site is used for Location Based Routing.

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
        TeamsTenantNetworkSite 'Example'
        {
            Credential                 = $Credscredential;
            EnableLocationBasedRouting = $False;
            Ensure                     = "Present";
            Identity                   = "Nik";
        }
    }
}
```

