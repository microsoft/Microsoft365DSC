# EXOInboundConnector

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the outbound connector that you want to modify. | |
| **AssociatedAcceptedDomains** | Write | StringArray[] | The AssociatedAcceptedDomains parameter specifies the accepted domains that the connector applies to, thereby limiting its scope. For example, you can apply the connector to a specific accepted domain in your organization, such as contoso.com. | |
| **CloudServicesMailEnabled** | Write | Boolean | The CloudServicesMailEnabled parameter specifies whether the connector is used for hybrid mail flow between an on-premises Exchange environment and Microsoft Office 365. Specifically, this parameter controls how certain internal X-MS-Exchange-Organization-* message headers are handled in messages that are sent between accepted domains in the on-premises and cloud organizations. These headers are collectively known as cross-premises headers. DO NOT USE MANUALLY! | |
| **Comment** | Write | String | The Comment parameter specifies an optional comment. | |
| **ConnectorSource** | Write | String | The ConnectorSource parameter specifies how the connector is created. DO NOT CHANGE THIS! | `Default`, `Migrated`, `HybridWizard` |
| **ConnectorType** | Write | String | The ConnectorType parameter specifies a category for the domains that are serviced by the connector. Valid values are Partner and OnPremises | `Partner`, `OnPremises` |
| **EFSkipIPs** | Write | StringArray[] | The EFSkipIPs parameter specifies the source IP addresses to skip in Enhanced Filtering for Connectors when the EFSkipLastIP parameter value is $false. | |
| **EFSkipLastIP** | Write | Boolean | The EFSkipLastIP parameter specifies the behavior of Enhanced Filtering for Connectors. | |
| **EFUsers** | Write | StringArray[] | The EFUsers parameter specifies the recipients that Enhanced Filtering for Connectors applies to. | |
| **Enabled** | Write | Boolean | Specifies whether connector is enabled. | |
| **RequireTls** | Write | Boolean | The RequireTLS parameter specifies that all messages received by this connector require TLS transmission. Valid values for this parameter are $true or $false. The default value is $false. When the RequireTLS parameter is set to $true, all messages received by this connector require TLS transmission. | |
| **RestrictDomainsToCertificate** | Write | Boolean | The RestrictDomainsToCertificate parameter specifies that Office 365 should identify incoming messages that are eligible for this connector by verifying that the remote server authenticates using a TLS certificate that has the TlsSenderCertificateName in the Subject. | |
| **RestrictDomainsToIPAddresses** | Write | Boolean | The RestrictDomainsToIPAddresses parameter, when set to $true, automatically rejects mail from the domains specified by the SenderDomains parameter if the mail originates from an IP address that isn't specified by the SenderIPAddresses parameter. | |
| **SenderDomains** | Write | StringArray[] | The SenderDomains parameter specifies the remote domains from which this connector accepts messages, thereby limiting its scope. You can use a wildcard character to specify all subdomains of a specified domain, as shown in the following example: *.contoso.com. However, you can't embed a wildcard character, as shown in the following example: domain.*.contoso.com. | |
| **SenderIPAddresses** | Write | StringArray[] | The SenderIPAddresses parameter specifies the remote IP addresses from which this connector accepts messages. | |
| **TlsSenderCertificateName** | Write | String | The TlsSenderCertificateName parameter specifies the certificate used by the sender's domain when the RequireTls parameter is set to $true. Valid input for the TlsSenderCertificateName parameter is an SMTP domain.  | |
| **TreatMessagesAsInternal** | Write | Boolean | The TreatMessagesAsInternal parameter specifies an alternative method to identify messages sent from an on-premises organization as internal messages. You should only consider using this parameter when your on-premises organization doesn't use Exchange. | |
| **Ensure** | Write | String | Specifies if this Outbound connector should exist. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

This resource configures an Inbound connector in your cloud-based organization.

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
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOInboundConnector 'ConfigureInboundConnector'
        {
            Identity                     = "Integration Inbound Connector"
            CloudServicesMailEnabled     = $False
            Comment                      = "Inbound connector for Integration"
            ConnectorSource              = "Default"
            ConnectorType                = "Partner"
            Enabled                      = $True
            RequireTls                   = $True
            SenderDomains                = "*.contoso.com"
            TlsSenderCertificateName     = "contoso.com"
            Ensure                       = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
```

### Example 2

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOInboundConnector 'ConfigureInboundConnector'
        {
            Identity                     = "Integration Inbound Connector"
            CloudServicesMailEnabled     = $False
            Comment                      = "Inbound connector for Integration"
            ConnectorSource              = "Default"
            ConnectorType                = "Partner"
            Enabled                      = $False # Updated Property
            RequireTls                   = $True
            SenderDomains                = "*.contoso.com"
            TlsSenderCertificateName     = "contoso.com"
            Ensure                       = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
```

### Example 3

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOInboundConnector 'ConfigureInboundConnector'
        {
            Identity                     = "Integration Inbound Connector"
            Ensure                       = "Absent"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
```

