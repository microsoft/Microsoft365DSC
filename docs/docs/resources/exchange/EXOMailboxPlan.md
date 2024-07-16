# EXOMailboxPlan

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the Mailbox Plan that you want to modify. | |
| **DisplayName** | Write | String | The display name of the mailbox plan. | |
| **Ensure** | Write | String | MailboxPlans cannot be created/removed in O365.  This must be set to 'Present' | `Present` |
| **IssueWarningQuota** | Write | String | The IssueWarningQuota parameter specifies the warning threshold for the size of the mailboxes that are created or enabled using the mailbox plan. | |
| **MaxReceiveSize** | Write | String | The MaxReceiveSize parameter specifies the maximum size of a message that can be sent to the mailbox. | |
| **MaxSendSize** | Write | String | The MaxSendSize parameter specifies the maximum size of a message that can be sent by the mailbox. | |
| **ProhibitSendQuota** | Write | String | The ProhibitSendQuota parameter specifies a size limit for the mailbox. | |
| **ProhibitSendReceiveQuota** | Write | String | The ProhibitSendReceiveQuota parameter specifies a size limit for the mailbox. | |
| **RetainDeletedItemsFor** | Write | String | The RetainDeletedItemsFor parameter specifies the length of time to keep soft-deleted items for the mailbox. | |
| **RetentionPolicy** | Write | String | The RetentionPolicy parameter specifies the retention policy that's applied to the mailbox. | |
| **RoleAssignmentPolicy** | Write | String | The RoleAssignmentPolicy parameter specifies the role assignment policy that's applied to the mailbox. | |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

Use this resource to modify the settings of mailbox plans in the cloud-based service.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Unified Messaging, View-Only Recipients, Mail Recipient Creation, Mail Recipients, UM Mailboxes

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
        EXOMailboxPlan 'ConfigureMailboxPlan'
        {
            Ensure                   = "Present";
            Identity                 = "ExchangeOnlineEssentials";
            IssueWarningQuota        = "15 GB (16,106,127,360 bytes)";
            MaxReceiveSize           = "25 MB (26,214,400 bytes)";
            MaxSendSize              = "25 MB (26,214,400 bytes)";
            ProhibitSendQuota        = "15 GB (16,106,127,360 bytes)";
            ProhibitSendReceiveQuota = "15 GB (16,106,127,360 bytes)"; # Updated Property
            RetainDeletedItemsFor    = "14.00:00:00";
            RoleAssignmentPolicy     = "Default Role Assignment Policy";
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
```

