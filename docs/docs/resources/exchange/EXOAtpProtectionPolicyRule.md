# EXOAtpProtectionPolicyRule

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Identifier for the rule | |
| **Enabled** | Write | Boolean | Specifies whether the rule is enabled | |
| **Comments** | Write | String | Informative comments for the rule, such as what the rule is used for or how it has changed over time. The length of the comment can't exceed 1024 characters. | |
| **ExceptIfRecipientDomainIs** | Write | StringArray[] | Specifies an exception that looks for recipients with email addresses in the specified domains. | |
| **ExceptIfSentTo** | Write | StringArray[] | Specifies an exception that looks for recipients in messages. You can use any value that uniquely identifies the recipient | |
| **ExceptIfSentToMemberOf** | Write | StringArray[] | Specifies an exception that looks for messages sent to members of groups. You can use any value that uniquely identifies the group. | |
| **Name** | Write | String | Unique name for the rule. The maximum length is 64 characters. | |
| **Priority** | Write | UInt32 | Specifies a priority value for the rule that determines the order of rule processing. A lower integer value indicates a higher priority, the value 0 is the highest priority, and rules can't have the same priority value. | |
| **RecipientDomainIs** | Write | StringArray[] | Specifies a condition that looks for recipients with email addresses in the specified domains. | |
| **SafeAttachmentPolicy** | Write | String | Specifies the existing Safe Attachments policy that's associated with the preset security policy. | |
| **SafeLinksPolicy** | Write | String | Specifies the existing Safe Links policy that's associated with the preset security policy. | |
| **SentTo** | Write | StringArray[] | Specifies a condition that looks for recipients in messages. You can use any value that uniquely identifies the recipient. | |
| **SentToMemberOf** | Write | StringArray[] | Specifies a condition that looks for messages sent to members of distribution groups, dynamic distribution groups, or mail-enabled security groups.  | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Manage ATP Protection policy rules that are associated with Microsoft Defender for Office 365 protections in preset security policies.

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
        EXOATPProtectionPolicyRule "EXOATPProtectionPolicyRule-Strict Preset Security Policy"
        {
            Comments                = "Built-in Strict Preset Security Policy";
            Enabled                 = $False;
            Identity                = "Strict Preset Security Policy";
            Name                    = "Strict Preset Security Policy";
            Priority                = 0;
            SafeAttachmentPolicy    = "Strict Preset Security Policy1725468967835";
            SafeLinksPolicy         = "Strict Preset Security Policy1725468969412";
            Ensure                  = "Present"
            ApplicationId           = $ApplicationId
            TenantId                = $TenantId
            CertificateThumbprint   = $CertificateThumbprint
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
        EXOATPProtectionPolicyRule "EXOATPProtectionPolicyRule-Strict Preset Security Policy"
        {
            Comments                = "Built-in Strict Preset Security Policy with comments"; # Changed value
            Enabled                 = $True; # Changed value
            Identity                = "Strict Preset Security Policy";
            Name                    = "Strict Preset Security Policy";
            Priority                = 0;
            SafeAttachmentPolicy    = "Strict Preset Security Policy1725468967835";
            SafeLinksPolicy         = "Strict Preset Security Policy1725468969412";
            Ensure                  = "Present"
            ApplicationId           = $ApplicationId
            TenantId                = $TenantId
            CertificateThumbprint   = $CertificateThumbprint
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
        EXOATPProtectionPolicyRule "EXOATPProtectionPolicyRule-Strict Preset Security Policy"
        {
            Comments                = "Built-in Strict Preset Security Policy";
            Enabled                 = $False;
            Identity                = "Strict Preset Security Policy";
            Name                    = "Strict Preset Security Policy";
            Priority                = 0;
            SafeAttachmentPolicy    = "Strict Preset Security Policy1725468967835";
            SafeLinksPolicy         = "Strict Preset Security Policy1725468969412";
            Ensure                  = "Absent"
            ApplicationId           = $ApplicationId
            TenantId                = $TenantId
            CertificateThumbprint   = $CertificateThumbprint
        }
    }
}
```

