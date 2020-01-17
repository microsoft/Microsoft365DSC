# Description

Use the New-InboundConnector cmdlet to create a new Inbound connector in your cloud-based organization.
https://docs.microsoft.com/en-us/powershell/module/exchange/mail-flow/new-inboundconnector

For information about the parameter sets in the Syntax section below, see Exchange cmdlet syntax (https://docs.microsoft.com/powershell/exchange/exchange-server/exchange-cmdlet-syntax).
Syntax
PowerShell

Copy
New-InboundConnector
   [-Name] <String>
   -SenderDomains <MultiValuedProperty>
   [-AssociatedAcceptedDomains <MultiValuedProperty>]
   [-CloudServicesMailEnabled <Boolean>]
   [-Comment <String>]
   [-Confirm]
   [-ConnectorSource <TenantConnectorSource>]
   [-ConnectorType <TenantConnectorType>]
   [-Enabled <Boolean>]
   [-RequireTls <Boolean>]
   [-RestrictDomainsToCertificate <Boolean>]
   [-RestrictDomainsToIPAddresses <Boolean>]
   [-SenderIPAddresses <MultiValuedProperty>]
   [-TlsSenderCertificateName <TlsCertificate>]
   [-TreatMessagesAsInternal <Boolean>]
   [-WhatIf]
   [<CommonParameters>]


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
