# Description

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
