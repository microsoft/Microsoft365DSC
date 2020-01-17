# EXOIntraOrganizationConnector

# Description

Create a new EXOIntraOrganizationConnector in your cloud-based organization.
Reference: https://docs.microsoft.com/en-us/powershell/module/exchange/federation-and-hybrid/new-intraorganizationconnector

## Parameters

IntraOrganizationConnector

- Required: Yes
- Description: The Identity of the IntraOrganizationConnector to associate with this IntraOrganizationConnector.

Ensure

- Required: No (Defaults to 'Present')
- Description: Specifies if the configuration should be `Present` or `Absent`

GlobalAdminAccount

- Required: Yes
- Description: Credentials of an Office365 Global Admin

Identity

- Required: Yes
- Description: Name of the IntraOrganizationConnector

## Example

```PowerShell
        IntraOrganizationConnector TestIntraOrganizationConnector {
                Ensure               = 'Present'
                GlobalAdminAccount   = $GlobalAdminAccount
                Identity             = 'TestIntraOrganizationConnector'
                DiscoveryEndpoint    = 'https://ExternalDiscovery.Contoso.com/autodiscover/autodiscover.svc'
                Enabled              = $true
                TargetAddressDomains = @('contoso.com', 'contoso.org')
        }
```
