# EXOOutboundConnector

# Description

Create a new Inbound connector in your cloud-based organization.
Reference: https://docs.microsoft.com/en-us/powershell/module/exchange/mail-flow/new-OutboundConnector

## Parameters

OutboundConnector

- Required: Yes
- Description: The Identity of the OutboundConnector
to associate with this Inbound connector.

Ensure

- Required: No (Defaults to 'Present')
- Description: Specifies if the configuration should be `Present` or `Absent`

GlobalAdminAccount

- Required: Yes
- Description: Credentials of an Office365 Global Admin

Identity

- Required: Yes
- Description: Name of the OutboundConnector

## Example

```PowerShell
OutboundConnector TestOutboundConnector {
        Ensure                        = 'Present'
        GlobalAdminAccount            = $GlobalAdminAccount
        Identity                      = 'TestOutboundConnector'
        CloudServicesMailEnabled      = $false
        Comment                       = 'Test outbound connector'
        Enabled                       = $true
        ConnectorSource               = 'Default'
        ConnectorType                 = 'Partner'
        IsTransportRuleScoped         = $false
        RecipientDomains              = @('fabrikam.com', 'contoso.com')
        RouteAllMessagesViaOnPremises = $false
        SmartHosts                    = @('mail.contoso.com')
        TestMode                      = $false
        TlsDomain                     = '*.contoso.com'
        TlsSettings                   = 'EncryptionOnly'
        UseMxRecord                   = $false
        ValidationRecipients          = @('test@contoso.com', 'contoso.org')
}
```
