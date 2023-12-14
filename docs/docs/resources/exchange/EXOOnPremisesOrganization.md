# EXOOnPremisesOrganization

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the identity of the on-premises organization object. | |
| **HybridDomains** | Write | StringArray[] | The HybridDomains parameter specifies the domains that are configured in the hybrid deployment between an Office 365 tenant and an on-premises Exchange organization. The domains specified in this parameter must match the domains listed in the HybridConfiguration Active Directory object for the on-premises Exchange organization configured by the Hybrid Configuration wizard.  | |
| **InboundConnector** | Write | String | The InboundConnector parameter specifies the name of the inbound connector configured on the Microsoft Exchange Online Protection (EOP) service for a hybrid deployment configured with an on-premises Exchange organization. | |
| **OutboundConnector** | Write | String | The OutboundConnector parameter specifies the name of the outbound connector configured on the EOP service for a hybrid deployment configured with an on-premises Exchange organization. | |
| **OrganizationName** | Write | String | The OrganizationName parameter specifies the Active Directory object name of the on-premises Exchange organization. | |
| **OrganizationGuid** | Write | String | The OrganizationGuid parameter specifies the globally unique identifier (GUID) of the on-premises Exchange organization object in the Office 365 tenant. | |
| **OrganizationRelationship** | Write | String | The OrganizationRelationship parameter specifies the organization relationship configured by the Hybrid Configuration wizard on the Office 365 tenant as part of a hybrid deployment with an on-premises Exchange organization. This organization relationship defines the federated sharing features enabled on the Office 365 tenant. | |
| **Comment** | Write | String | The Comment parameter specifies an optional comment. | |
| **Ensure** | Write | String | Specify if the On-Premises Organization should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures On-Premises Organization in Exchange Online.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Remote and Accepted Domains, View-Only Configuration

#### Role Groups

- Organization Management

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOOnPremisesOrganization 'ConfigureOnPremisesOrganization'
        {
            Identity          = 'Contoso'
            Comment           = 'Mail for Contoso'
            HybridDomains     = 'contoso.com', 'sales.contoso.com'
            InboundConnector  = 'Inbound to Contoso'
            OrganizationGuid  = 'a1bc23cb-3456-bcde-abcd-feb363cacc88'
            OrganizationName  = 'Contoso'
            OutboundConnector = 'Outbound to Contoso'
            Ensure            = 'Present'
            Credential        = $Credscredential
        }
    }
}
```

