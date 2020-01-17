# Description

This resource allows to configure Exchange Online Inbound Connectors.
https://docs.microsoft.com/en-us/powershell/module/exchange/mail-flow/set-inboundconnector

Set-InboundConnector
   [-Identity] <InboundConnectorIdParameter>
   [-AssociatedAcceptedDomains <MultiValuedProperty>]
   [-CloudServicesMailEnabled <$true | $false>]
   [-Comment <String>]
   [-Confirm]
   [-ConnectorSource <Default | Migrated | HybridWizard | AdminUI>]
   [-ConnectorType <OnPremises | Partner>]
   [-Enabled <$true | $false>]
   [-Name <String>]
   [-RequireTls <$true | $false>]
   [-RestrictDomainsToCertificate <$true | $false>]
   [-RestrictDomainsToIPAddresses <$true | $false>]
   [-SenderDomains <MultiValuedProperty>]
   [-SenderIPAddresses <MultiValuedProperty>]
   [-TlsSenderCertificateName <TlsCertificate>]
   [-TreatMessagesAsInternal <$true | $false>]
   [-WhatIf]
   [<CommonParameters>]