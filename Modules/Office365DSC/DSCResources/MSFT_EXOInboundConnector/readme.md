# EXOInboundConnector

# Description

Create a new Inbound connector in your cloud-based organization.
Reference: https://docs.microsoft.com/en-us/powershell/module/exchange/mail-flow/new-inboundconnector

## Parameters

InboundConnector

- Required: Yes
- Description: The Identity of the InboundConnector to associate
with this Inbound connector.

Ensure

- Required: No (Defaults to 'Present')
- Description: Specifies if the configuration should be `Present` or `Absent`

GlobalAdminAccount

- Required: Yes
- Description: Credentials of an Office365 Global Admin

Identity

- Required: Yes
- Description: Name of the InboundConnector

## Example

```PowerShell
InboundConnector TestInboundConnector {
        Ensure                       = 'Present'
        GlobalAdminAccount           = $GlobalAdminAccount
        Identity                     = 'TestInboundConnector'
        AssociatedAcceptedDomains    = @('test@contoso.com', 'contoso.org')
        CloudServicesMailEnabled     = $false
        Comment                      = 'Test Inbound connector'
        ConnectorSource              = 'HybridWizard'
        ConnectorType                = 'onPremises'
        Enabled                      = $true
        RequireTls                   = $true
        RestrictDomainsToCertificate = $false
        RestrictDomainsToIPAddresses = $true
        SenderDomains                = @('fabrikam.com', 'contoso.com')
        SenderIPAddresses            = '192.168.2.11'
        TlsSenderCertificateName     = '*.contoso.com'
        TreatMessagesAsInternal      = $true
}
```
