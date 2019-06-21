# EXOHostedConnectionFilterPolicy

## Description

This resource configures the settings of connection filter policies
in your cloud-based organization.

## Parameters

Ensure

- Required: No (Defaults to 'Present')
- Description: `Present` is the only value accepted.
    Configurations using `Ensure = 'Absent'` will throw an Error!

GlobalAdminAccount

- Required: Yes
- Description: Credentials of an Office365 Global Admin

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
        GlobalAdminAccount = $GlobalAdminAccount
        AdminDisplayName   = 'This policiy is a test'
        EnableSafeList     = $true
        IPAllowList        = @('192.168.1.100', '10.1.1.0/24', '172.16.5.1-172.16.5.150')
        IPBlockList        = @('10.1.1.13', '172.16.5.2')
        MakeDefault        = $false
    }
}
```
