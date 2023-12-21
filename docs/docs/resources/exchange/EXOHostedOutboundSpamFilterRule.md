# EXOHostedOutboundSpamFilterRule

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the name of the HostedOutboundSpamFilter rule that you want to modify. | |
| **HostedOutboundSpamFilterPolicy** | Required | String | The HostedOutboundSpamFilterPolicy parameter specifies the name of the HostedOutboundSpamFilter policy that's associated with the HostedOutboundSpamFilter rule. | |
| **Enabled** | Write | Boolean | Specify if this rule should be enabled. Default is $true. | |
| **Priority** | Write | UInt32 | The Priority parameter specifies a priority value for the rule that determines the order of rule processing. A lower integer value indicates a higher priority, the value 0 is the highest priority, and rules can't have the same priority value. | |
| **Comments** | Write | String | The Comments parameter specifies informative comments for the rule, such as what the rule is used for or how it has changed over time. The length of the comment can't exceed 1024 characters. | |
| **ExceptIfSenderDomainIs** | Write | StringArray[] | The ExceptIfSenderDomainIs parameter specifies an exception that looks for senders with email address in the specified domains. You can specify multiple domains separated by commas. | |
| **ExceptIfFrom** | Write | StringArray[] | The ExceptIfFrom parameter specifies an exception that looks for messages from specific senders. You can use any value that uniquely identifies the sender. | |
| **ExceptIfFromMemberOf** | Write | StringArray[] | The ExceptIfFromMemberOf parameter specifies an exception that looks for messages sent by group members. You can use any value that uniquely identifies the group. | |
| **SenderDomainIs** | Write | StringArray[] | The SenderDomainIs parameter specifies a condition that looks for senders with email address in the specified domains. You can specify multiple domains separated by commas. | |
| **From** | Write | StringArray[] | The From parameter specifies a condition that looks for messages from specific senders. You can use any value that uniquely identifies the sender. | |
| **FromMemberOf** | Write | StringArray[] | The FromMemberOf parameter specifies a condition that looks for messages sent by group members. You can use any value that uniquely identifies the group. | |
| **Ensure** | Write | String | Specify if this rule should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures an Hosted Content Filter Rule in Exchange Online.
Reference: https://docs.microsoft.com/en-us/powershell/module/exchange/new-hostedoutboundspamfilterrule?view=exchange-ps

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Transport Hygiene, Security Admin, View-Only Configuration, Security Reader

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
        EXOHostedOutboundSpamFilterRule 'ConfigureHostedOutboundSpamFilterRule'
        {
            Identity                       = "Contoso Executives"
            Comments                       = "Does not apply to Executives"
            Enabled                        = $True
            ExceptIfFrom                   = "Elizabeth Brunner"
            HostedOutboundSpamFilterPolicy = "Default"
            Ensure                         = "Present"
            Credential                     = $Credscredential
        }
    }
}
```

