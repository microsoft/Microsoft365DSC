# EXOHostedConnectionFilterPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the Hosted Connection Filter Policy that you want to modify. ||
| **AdminDisplayName** | Write | String | The AdminDisplayName parameter specifies a description for the policy. ||
| **EnableSafeList** | Write | Boolean | The EnableSafeList parameter enables or disables use of the safe list. The safe list is a dynamic allow list in the Microsoft datacenter that requires no customer configuration. Valid input for this parameter is $true or $false. The default value is $false. ||
| **IPAllowList** | Write | StringArray[] | The IPAllowList parameter specifies IP addresses from which messages are always allowed. Messages from the IP addresses you specify won't be identified as spam, despite any other spam characteristics of the messages. Valid values for this parameter are: A single IP address, an IP address range, a CIDR IP. ||
| **IPBlockList** | Write | StringArray[] | The IPBlockList parameter specifies IP addresses from which messages are never allowed. Messages from the IP addresses you specify are blocked without any further spam scanning. Valid values for this parameter are: A single IP address, an IP address range, a CIDR IP. ||
| **MakeDefault** | Write | Boolean | The MakeDefault parameter makes the specified policy the default connection filter policy. Default is $false. ||
| **Ensure** | Write | String | Specifies if this Hosted Connection Filter Policy should exist. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||

# EXOHostedConnectionFilterPolicy

### Description

This resource configures the settings of connection filter policies
in your cloud-based organization.

## Parameters

Ensure

- Required: No (Defaults to 'Present')
- Description: `Present` is the only value accepted.
    Configurations using `Ensure = 'Absent'` will throw an Error!

Credential

- Required: Yes
- Description: Credentials of the account to authenticate with

Identity

- Required: Yes
- Description: Name of the HostedConnectionFilterPolicy

AdminDisplayName

- Required: No
- Description: The AdminDisplayName parameter specifies a
  description for the policy.

EnableSafeList

- Required: No
- Description: The EnableSafeList parameter enables or disables use
  of the safe list. The safe list is a dynamic allow list in the
  Microsoft datacenter that requires no customer configuration.
  Valid input for this parameter is $true or $false.
  The default value is $false.

IPAllowList

- Required: No
- Description: The IPAllowList parameter specifies IP addresses
  from which messages are always allowed. Messages from the IP addresses
  you specify won't be identified as spam, despite any other
  spam characteristics of the messages.
  Valid values for this parameter are:
      A single IP address: For example, 192.168.1.1
      An IP address range: For example, 192.168.0.1-192.168.0.254
      Classless Inter-Domain Routing (CIDR) IP: e.g. 192.168.3.1/24

IPBlockList

- Required: No
- Description: The IPBlockList parameter specifies IP addresses
  from which messages are never allowed. Messages from the IP addresses
  you specify are blocked without any further spam scanning.
  Valid values for this parameter are:
      A single IP address: For example, 192.168.1.1
      An IP address range: For example, 192.168.0.1-192.168.0.254
      Classless Inter-Domain Routing (CIDR) IP: e.g. 192.168.3.1/24

## Example

```PowerShell
    EXOHostedConnectionFilterPolicy TestHostedConnectionFilterPolicy {
        Ensure             = 'Present'
        Identity           = 'TestPolicy'
        Credential         = $Credential
        AdminDisplayName   = 'This policiy is a test'
        EnableSafeList     = $true
        IPAllowList        = @('192.168.1.100', '10.1.1.0/24', '172.16.5.1-172.16.5.150')
        IPBlockList        = @('10.1.1.13', '172.16.5.2')
        MakeDefault        = $false
    }
}
```

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
        EXOHostedConnectionFilterPolicy 'ConfigureHostedConnectionFilterPolicy'
        {
            Identity         = "Default"
            AdminDisplayName = ""
            EnableSafeList   = $False
            IPAllowList      = @()
            IPBlockList      = @()
            MakeDefault      = $False
            Ensure           = "Present"
            Credential       = $credsGlobalAdmin
        }
    }
}
```

