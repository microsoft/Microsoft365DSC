# Description

Use the New-OutboundConnector cmdlet to create a new Outbound connector in your cloud-based organization.
https://docs.microsoft.com/en-us/powershell/module/exchange/mail-flow/new-outboundconnector

For information about the parameter sets in the Syntax section below, see Exchange cmdlet syntax (https://docs.microsoft.com/powershell/exchange/exchange-server/exchange-cmdlet-syntax).
Syntax
PowerShell

Copy
New-OutboundConnector
   [-Name] <String>
   [-AllAcceptedDomains <Boolean>]
   [-CloudServicesMailEnabled <Boolean>]
   [-Comment <String>]
   [-Confirm]
   [-ConnectorSource <TenantConnectorSource>]
   [-ConnectorType <TenantConnectorType>]
   [-Enabled <Boolean>]
   [-IsTransportRuleScoped <Boolean>]
   [-LinkForModifiedConnector <Guid>]
   [-RecipientDomains <MultiValuedProperty>]
   [-RouteAllMessagesViaOnPremises <Boolean>]
   [-SmartHosts <MultiValuedProperty>]
   [-TestMode <Boolean>]
   [-TlsDomain <SmtpDomainWithSubdomains>]
   [-TlsSettings <TlsAuthLevel>]
   [-UseMXRecord <Boolean>]
   [-WhatIf]
   [<CommonParameters>]

This resource allows to configure Exchange Online Oubound Connectors.
https://docs.microsoft.com/en-us/powershell/module/exchange/mail-flow/set-outboundconnector


Set-OutboundConnector
   [-Identity] <OutboundConnectorIdParameter>
   [-AllAcceptedDomains <$true | $false>]
   [-CloudServicesMailEnabled <$true | $false>]
   [-Comment <String>]
   [-Confirm]
   [-ConnectorSource <Default | Migrated | HybridWizard | AdminUI>]
   [-ConnectorType <OnPremises | Partner>]
   [-Enabled <$true | $false>]
   [-IsTransportRuleScoped <$true | $false>]
   [-IsValidated <$true | $false>]
   [-LastValidationTimestamp <DateTime>]
   [-Name <String>]
   [-RecipientDomains <MultiValuedProperty>]
   [-RouteAllMessagesViaOnPremises <$true | $false>]
   [-SmartHosts <MultiValuedProperty>]
   [-TestMode <$true | $false>]
   [-TlsDomain <SmtpDomainWithSubdomains>]
   [-TlsSettings <EncryptionOnly | CertificateValidation | DomainValidation>]
   [-UseMXRecord <$true | $false>]
   [-ValidationRecipients <String[]>]
   [-WhatIf]
   [<CommonParameters>]
