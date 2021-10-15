# EXOOnPremisesOrganization

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the identity of the on-premises organization object. ||
| **HybridDomains** | Write | StringArray[] | The HybridDomains parameter specifies the domains that are configured in the hybrid deployment between an Office 365 tenant and an on-premises Exchange organization. The domains specified in this parameter must match the domains listed in the HybridConfiguration Active Directory object for the on-premises Exchange organization configured by the Hybrid Configuration wizard.  ||
| **InboundConnector** | Write | String | The InboundConnector parameter specifies the name of the inbound connector configured on the Microsoft Exchange Online Protection (EOP) service for a hybrid deployment configured with an on-premises Exchange organization. ||
| **OutboundConnector** | Write | String | The OutboundConnector parameter specifies the name of the outbound connector configured on the EOP service for a hybrid deployment configured with an on-premises Exchange organization. ||
| **OrganizationName** | Write | String | The OrganizationName parameter specifies the Active Directory object name of the on-premises Exchange organization. ||
| **OrganizationGuid** | Write | String | The OrganizationGuid parameter specifies the globally unique identifier (GUID) of the on-premises Exchange organization object in the Office 365 tenant. ||
| **OrganizationRelationship** | Write | String | The OrganizationRelationship parameter specifies the organization relationship configured by the Hybrid Configuration wizard on the Office 365 tenant as part of a hybrid deployment with an on-premises Exchange organization. This organization relationship defines the federated sharing features enabled on the Office 365 tenant. ||
| **Comment** | Write | String | The Comment parameter specifies an optional comment. ||
| **Ensure** | Write | String | Specify if the On-Premises Organization should exist or not. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||

# EXOOnPremisesOrganization

### Description

This resource configures On-Premises Organization in Exchange Online.


