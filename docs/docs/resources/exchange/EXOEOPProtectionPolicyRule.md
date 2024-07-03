# EXOEOPProtectionPolicyRule

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Comments** | Write | String | The Comments parameter specifies informative comments for the rule, such as what the rule is used for or how it has changed over time. The length of the comment can't exceed 1024 characters. | |
| **ExceptIfRecipientDomainIs** | Write | StringArray[] | The ExceptIfRecipientDomainIs parameter specifies an exception that looks for recipients with email addresses in the specified domains. You can specify multiple domains separated by commas. | |
| **ExceptIfSentTo** | Write | StringArray[] | The ExceptIfSentTo parameter specifies an exception that looks for recipients in messages. You can use any value that uniquely identifies the recipient. | |
| **ExceptIfSentToMemberOf** | Write | StringArray[] | The ExceptIfSentToMemberOf parameter specifies an exception that looks for messages sent to members of groups. You can use any value that uniquely identifies the group. | |
| **Identity** | Key | String | The Identity parameter specifies the rule that you want to view. You can use any value that uniquely identifies the rule.  | |
| **State** | Write | String | This parameter defin if the rule is enabled or disabled | |
| **Name** | Write | String | The Name parameter specifies a unique name for the rule. The maximum length is 64 characters. | |
| **Priority** | Write | UInt32 | The Priority parameter specifies a priority value for the rule that determines the order of rule processing. A lower integer value indicates a higher priority, the value 0 is the highest priority, and rules can't have the same priority value. | |
| **RecipientDomainIs** | Write | StringArray[] | The RecipientDomainIs parameter specifies a condition that looks for recipients with email addresses in the specified domains. You can specify multiple domains separated by commas. | |
| **SentTo** | Write | StringArray[] | The SentTo parameter specifies a condition that looks for recipients in messages. You can use any value that uniquely identifies the recipient. | |
| **SentToMemberOf** | Write | StringArray[] | The SentToMemberOf parameter specifies a condition that looks for messages sent to members of distribution groups, dynamic distribution groups, or mail-enabled security groups. You can use any value that uniquely identifies the group. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |


## Description

This resource configures EOP Protection Policy Rules.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- SecurityAdmin, TransportHygiene

#### Role Groups

- None

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        EXOEOPProtectionPolicyRule "EXOEOPProtectionPolicyRule-Strict Preset Security Policy"
        {
            ApplicationId             = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint     = $ConfigurationData.NonNodeData.CertificateThumbprint;
            Ensure                    = "Present";
            ExceptIfRecipientDomainIs = @("sandrodev.onmicrosoft.com");
            Identity                  = "Strict Preset Security Policy";
            Name                      = "Strict Preset Security Policy";
            Priority                  = 0;
            State                     = "Enabled";
            TenantId                  = $OrganizationName;
        }
    }
}
```

