# EXOOutboundConnector

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the outbound connector that you want to modify. | |
| **Enabled** | Write | Boolean | Specifies whether connector is enabled. | |
| **UseMXRecord** | Write | Boolean | Specifies whether connector should use MXRecords for target resolution. | |
| **Comment** | Write | String | The Comment parameter specifies an optional comment. | |
| **ConnectorSource** | Write | String | The ConnectorSource parameter specifies how the connector is created. DO NOT CHANGE THIS! values are Default (the default) | Migrated | HybridWizard  | `Default`, `Migrated`, `HybridWizard` |
| **ConnectorType** | Write | String | The ConnectorType parameter specifies a category for the domains that are serviced by the connector. Valid values are Partner and OnPremises | `Partner`, `OnPremises` |
| **RecipientDomains** | Write | StringArray[] | The RecipientDomains parameter specifies the domain that the Outbound connector routes mail to. You can specify multiple domains separated by commas. | |
| **SmartHosts** | Write | StringArray[] | The SmartHosts parameter specifies the smart hosts the Outbound connector uses to route mail. This parameter is required if you set the UseMxRecord parameter to $false and must be specified on the same command line. | |
| **TlsDomain** | Write | String | The TlsDomain parameter specifies the domain name that the Outbound connector uses to verify the FQDN of the target certificate when establishing a TLS secured connection. This parameter is only used if the TlsSettings parameter is set to DomainValidation. Valid input for the TlsDomain parameter is an SMTP domain. You can use a wildcard character to specify all subdomains of a specified domain, as shown in the following example: *.contoso.com. However, you can't embed a wildcard character, as shown in the following example: domain.*.contoso.com | |
| **TlsSettings** | Write | String | The TlsSettings parameter specifies the TLS authentication level that's used for outbound TLS connections established by this Outbound connector. Valid values are:EncryptionOnly | CertificateValidation | DomainValidation | `EncryptionOnly`, `CertificateValidation`, `DomainValidation` |
| **IsTransportRuleScoped** | Write | Boolean | The IsTransportRuleScoped parameter specifies whether the Outbound connector is associated with a transport rule (also known as a mail flow rule). Valid values are: $true | $false | |
| **RouteAllMessagesViaOnPremises** | Write | Boolean | The RouteAllMessagesViaOnPremises parameter specifies that all messages serviced by this connector are first routed through the on-premises messaging system (Centralized mailrouting). Valid values are: $true | $false | |
| **CloudServicesMailEnabled** | Write | Boolean | The CloudServicesMailEnabled parameter specifies whether the connector is used for hybrid mail flow between an on-premises Exchange environment and Microsoft Office 365. Specifically, this parameter controls how certain internal X-MS-Exchange-Organization-* message headers are handled in messages that are sent between accepted domains in the on-premises and cloud organizations. These headers are collectively known as cross-premises headers. DO NOT USE MANUALLY! Valid values are: $true | $false | |
| **AllAcceptedDomains** | Write | Boolean | The AllAcceptedDomains parameter specifies whether the Outbound connector is used in hybrid organizations where message recipients are in accepted domains of the cloud-based organization. Valid values are: $true | $false (default) | |
| **SenderRewritingEnabled** | Write | Boolean | The SenderRewritingEnabled parameter specifies that all messages that normally qualify for SRS rewriting are rewritten for routing through the on-premises email system. | |
| **TestMode** | Write | Boolean | The TestMode parameter specifies whether you want to enabled or disable test mode for the Outbound connector. Valid values are: $true | $false (default) | |
| **ValidationRecipients** | Write | StringArray[] | The ValidationRecipients parameter specifies the email addresses of the validation recipients for the Outbound connector. You can specify multiple email addresses separated by commas. | |
| **Ensure** | Write | String | Specifies if this Outbound connector should exist. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

Create a new Inbound connector in your cloud-based organization.

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
        EXOOutboundConnector 'ConfigureOutboundConnector'
        {
            Identity                      = "Contoso Outbound Connector"
            AllAcceptedDomains            = $True
            CloudServicesMailEnabled      = $True
            Comment                       = "Outbound connector to Contoso"
            ConnectorSource               = "Default"
            ConnectorType                 = "OnPremises"
            Enabled                       = $True
            IsTransportRuleScoped         = $True
            RecipientDomains              = "*.contoso.com"
            RouteAllMessagesViaOnPremises = $True
            TlsDomain                     = "*.contoso.com"
            TlsSettings                   = "DomainValidation"
            UseMxRecord                   = $True
            Ensure                        = "Present"
            Credential                    = $Credscredential
        }
    }
}
```

