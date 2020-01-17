# Description

This resource allows to configure Exchange Intraorganization Connectors.


https://docs.microsoft.com/en-us/powershell/module/exchange/federation-and-hybrid/new-intraorganizationconnector?view=exchange-ps

This cmdlet is available in on-premises Exchange and in the cloud-based service. Some parameters and settings may be exclusive to one environment or the other.

Use the New-IntraOrganizationConnector cmdlet to create an Intra-Organization connector between two on-premises Exchange forests in an organization, between an Exchange on-premises organization and an Exchange Online organization, or between two Exchange Online organizations. This connector enables feature availability and service connectivity across the organizations using a common connector and connection endpoints.

New-IntraOrganizationConnector
   [-Name] <String>
   -DiscoveryEndpoint <Uri>
   -TargetAddressDomains <MultiValuedProperty>
   [-Confirm]
   [-DomainController <Fqdn>]
   [-Enabled <Boolean>]
   [-WhatIf]
   [<CommonParameters>]


https://docs.microsoft.com/en-us/powershell/module/exchange/federation-and-hybrid/set-intraorganizationconnector?view=exchange-ps

This cmdlet is available in on-premises Exchange and in the cloud-based service. Some parameters and settings may be exclusive to one environment or the other.

Use the Set-IntraOrganizationConnector cmdlet to modify an existing Intra-Organization connector between two on-premises Exchange forests in an organization, between an on-premises Exchange organization and an Exchange Online organization or between two Exchange Online organizations.

Set-IntraOrganizationConnector
   [-Identity] <IntraOrganizationConnectorIdParameter>
   [-Confirm]
   [-DiscoveryEndpoint <Uri>]
   [-DomainController <Fqdn>]
   [-Enabled <Boolean>]
   [-TargetAddressDomains <MultiValuedProperty>]
   [-WhatIf]
   [<CommonParameters>]
