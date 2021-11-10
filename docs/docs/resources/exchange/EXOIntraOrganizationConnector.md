# EXOIntraOrganizationConnector

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the intraorg connector that you want to modify. ||
| **DiscoveryEndpoint** | Write | String | The DiscoveryEndpoint parameter specifies the externally-accessible URL that's used for the Autodiscover service for the domain that's configured in the Intra-Organization connector. ||
| **Enabled** | Write | Boolean | Specifies whether connector is enabled. ||
| **TargetAddressDomains** | Write | StringArray[] | The TargetAddressDomains parameter specifies the domain namespaces that will be used in the Intra-organization connector. These domains must have valid Autodiscover endpoints defined in their organizations. The domains and their associated Autodiscover endpoints are used by the Intra-Organization connector for feature and service connectivity. You can specify multiple domains separated by commas. ||
| **Ensure** | Write | String | Specifies if this Intra-Organization connector should exist. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||

# EXOIntraOrganizationConnector

### Description

Create a new EXOIntraOrganizationConnector in your cloud-based organization.


