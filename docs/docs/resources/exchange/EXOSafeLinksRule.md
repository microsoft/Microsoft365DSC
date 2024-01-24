# EXOSafeLinksRule

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the name of the SafeLink rule that you want to modify. | |
| **Ensure** | Write | String | Specify if this rule should exist or not. | `Present`, `Absent` |
| **SafeLinksPolicy** | Required | String | The SafeLinksPolicy parameter specifies the name of the SafeLink policy that's associated with the SafeLinksing rule. | |
| **Enabled** | Write | Boolean | Specify if this rule should be enabled. Default is $true. | |
| **Priority** | Write | UInt32 | The Priority parameter specifies a priority value for the rule that determines the order of rule processing. A lower integer value indicates a higher priority, the value 0 is the highest priority, and rules can't have the same priority value. | |
| **Comments** | Write | String | The Comments parameter specifies informative comments for the rule, such as what the rule is used for or how it has changed over time. The length of the comment can't exceed 1024 characters. | |
| **ExceptIfRecipientDomainIs** | Write | StringArray[] | The ExceptIfRecipientDomainIs parameter specifies an exception that looks for recipients with email address in the specified domains. You can specify multiple domains separated by commas. | |
| **ExceptIfSentTo** | Write | StringArray[] | The ExceptIfSentTo parameter specifies an exception that looks for recipients in messages. You can use any value that uniquely identifies the recipient. | |
| **ExceptIfSentToMemberOf** | Write | StringArray[] | The ExceptIfSentToMemberOf parameter specifies an exception that looks for messages sent to members of groups. You can use any value that uniquely identifies the group. | |
| **RecipientDomainIs** | Write | StringArray[] | The RecipientDomainIs parameter specifies a condition that looks for recipients with email address in the specified domains. You can specify multiple domains separated by commas. | |
| **SentTo** | Write | StringArray[] | The SentTo parameter specifies a condition that looks for recipients in messages. You can use any value that uniquely identifies the recipient. | |
| **SentToMemberOf** | Write | StringArray[] | The SentToMemberOf parameter looks for messages sent to members of groups. You can use any value that uniquely identifies the group. | |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures an SafeLinks Rule in Exchange Online.

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
        EXOSafeLinksRule 'ConfigureSafeLinksRule'
        {
            Identity                  = "Research Department URL Rule"
            Comments                  = "Applies to Research Department, except managers"
            Enabled                   = $True
            ExceptIfSentToMemberOf    = "Research Department Managers"
            SafeLinksPolicy           = "Marketing Block URL"
            SentToMemberOf            = "Research Department"
            Ensure                    = "Present"
            Credential                = $Credscredential
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
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOSafeLinksRule 'ConfigureSafeLinksRule'
        {
            Identity                  = "Research Department URL Rule"
            Comments                  = "Applies to Research Department, except managers"
            Enabled                   = $False # Updated Property
            ExceptIfSentToMemberOf    = "Research Department Managers"
            SafeLinksPolicy           = "Marketing Block URL"
            SentToMemberOf            = "Research Department"
            Ensure                    = "Present"
            Credential                = $Credscredential
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
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOSafeLinksRule 'ConfigureSafeLinksRule'
        {
            Identity                  = "Research Department URL Rule"
            Comments                  = "Applies to Research Department, except managers"
            Enabled                   = $False # Updated Property
            SafeLinksPolicy           = "Marketing Block URL"
            Ensure                    = "Absent"
            Credential                = $Credscredential
        }
    }
}
```

