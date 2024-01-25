# EXOHostedConnectionFilterPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the Hosted Connection Filter Policy that you want to modify. | |
| **AdminDisplayName** | Write | String | The AdminDisplayName parameter specifies a description for the policy. | |
| **EnableSafeList** | Write | Boolean | The EnableSafeList parameter enables or disables use of the safe list. The safe list is a dynamic allow list in the Microsoft datacenter that requires no customer configuration. Valid input for this parameter is $true or $false. The default value is $false. | |
| **IPAllowList** | Write | StringArray[] | The IPAllowList parameter specifies IP addresses from which messages are always allowed. Messages from the IP addresses you specify won't be identified as spam, despite any other spam characteristics of the messages. Valid values for this parameter are: A single IP address, an IP address range, a CIDR IP. | |
| **IPBlockList** | Write | StringArray[] | The IPBlockList parameter specifies IP addresses from which messages are never allowed. Messages from the IP addresses you specify are blocked without any further spam scanning. Valid values for this parameter are: A single IP address, an IP address range, a CIDR IP. | |
| **MakeDefault** | Write | Boolean | The MakeDefault parameter makes the specified policy the default connection filter policy. Default is $false. | |
| **Ensure** | Write | String | Specifies if this Hosted Connection Filter Policy should exist. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures the settings of connection filter policies
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
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOHostedConnectionFilterPolicy 'ConfigureHostedConnectionFilterPolicy'
        {
            Identity         = "Integration Policy"
            AdminDisplayName = ""
            EnableSafeList   = $False
            IPAllowList      = @()
            IPBlockList      = @()
            MakeDefault      = $False
            Ensure           = "Present"
            Credential       = $Credscredential
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
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOHostedConnectionFilterPolicy 'ConfigureHostedConnectionFilterPolicy'
        {
            Identity         = "Integration Policy"
            AdminDisplayName = ""
            EnableSafeList   = $True # Updated Property
            IPAllowList      = @()
            IPBlockList      = @()
            MakeDefault      = $False
            Ensure           = "Present"
            Credential       = $Credscredential
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
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOHostedConnectionFilterPolicy 'ConfigureHostedConnectionFilterPolicy'
        {
            Identity         = "Integration Policy"
            Ensure           = "Absent"
            Credential       = $Credscredential
        }
    }
}
```

