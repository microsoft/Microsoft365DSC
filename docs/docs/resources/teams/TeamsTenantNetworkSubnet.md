# TeamsTenantNetworkSubnet

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **MaskBits** | Key | UInt32 | This parameter determines the length of bits to mask to the subnet. IPv4 format subnet accepts maskbits from 0 to 32 inclusive. IPv6 format subnet accepts maskbits from 0 to 128 inclusive. | |
| **Identity** | Key | String | Unique identifier for the network subnet to be created. | |
| **Description** | Write | String | Provide a description of the network subnet to identify purpose of creating it. | |
| **NetworkSiteID** | Write | String | NetworkSiteID is the identifier for the network site which the current network subnet is associating to. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |


## Description

As an Admin, you can use the Windows PowerShell command, New-CsTenantNetworkSubnet to define network subnets and assign them to network sites. Each internal subnet may only be associated with one site. Tenant network subnet is used for Location Based Routing.

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
        TeamsTenantNetworkSubnet 'Example'
        {
            Credential           = $Credscredential
            Description          = "Nik Test";
            Ensure               = "Present";
            Identity             = "192.168.0.0";
            MaskBits             = 24;
            NetworkSiteID        = "Nik";
        }
    }
}
```

