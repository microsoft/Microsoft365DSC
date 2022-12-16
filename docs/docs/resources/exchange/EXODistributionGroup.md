# EXODistributionGroup

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies a unique name for the address list. | |
| **Alias** | Write | String | Exchange alias (also known as the mail nickname) for the recipient | |
| **BccBlocked** | Write | Boolean | Is Bcc blocked for the distribution group. | |
| **BypassNestedModerationEnabled** | Write | Boolean | The ByPassNestedModerationEnabled parameter specifies how to handle message approval when a moderated group contains other moderated groups as members. | |
| **Description** | Write | String | Description of the distribution group. | |
| **DisplayName** | Write | String | The DisplayName parameter specifies the display name of the group. The display name is visible in the Exchange admin center and in address lists. The maximum length is 256 characters. | |
| **HiddenGroupMembershipEnabled** | Write | Boolean | The HiddenGroupMembershipEnabled switch specifies whether to hide the members of the distribution group from members of the group and users who aren't members of the group. | |
| **ManagedBy** | Write | StringArray[] | The ManagedBy parameter specifies an owner for the group. A group must have at least one owner. | |
| **MemberDepartRestriction** | Write | String | The MemberDepartRestriction parameter specifies the restrictions that you put on requests to leave the group. Valid values are: Open & Closed | `Open`, `Closed` |
| **MemberJoinRestriction** | Write | String | The MemberJoinRestriction parameter specifies the restrictions that you put on requests to join the group. Valid values are: Open, Closed & ApprovalRequired | `Open`, `Closed`, `ApprovalRequired` |
| **Members** | Write | StringArray[] | The Members parameter specifies the recipients (mail-enabled objects) that are members of the group. You can use any value that uniquely identifies the recipient. | |
| **ModeratedBy** | Write | StringArray[] | The ModeratedBy parameter specifies one or more moderators for this group. A moderator approves messages sent to the group before the messages are delivered. A moderator must be a mailbox, mail user, or mail contact in your organization. You can use any value that uniquely identifies the moderator. | |
| **ModerationEnabled** | Write | Boolean | The ModerationEnabled parameter specifies whether moderation is enabled for this recipient. | |
| **Notes** | Write | String | The Notes parameters specifies additional information about the object. | |
| **OrganizationalUnit** | Write | String | The OrganizationalUnit parameter specifies the location in Active Directory where the group is created. | |
| **PrimarySmtpAddress** | Write | String | The PrimarySmtpAddress parameter specifies the primary return email address that's used for the recipient. | |
| **RequireSenderAuthenticationEnabled** | Write | Boolean | The RequireSenderAuthenticationEnabled parameter specifies whether to accept messages only from authenticated (internal) senders. | |
| **RoomList** | Write | Boolean | The RoomList switch specifies that all members of this distribution group are room mailboxes. You don't need to specify a value with this switch. | |
| **SendModerationNotifications** | Write | String | The SendModerationNotifications parameter specifies when moderation notification messages are sent. Valid values are: Always, Internal & Never | `Always`, `Internal`, `Never` |
| **Type** | Write | String | The Type parameter specifies the type of group that you want to create. Valid values are: Distribution & Security | `Distribution`, `Security` |
| **Ensure** | Write | String | Specifies if this AddressList should exist. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures Exchange Online distribution groups.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Organization Management, Recipient Management

#### Role Groups

- None

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
        $credsAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXODistributionGroup 'DemoDG'
        {
            Alias                              = "demodg";
            BccBlocked                         = $False;
            BypassNestedModerationEnabled      = $False;
            DisplayName                        = "My Demo DG";
            Ensure                             = "Present";
            HiddenGroupMembershipEnabled       = $True;
            ManagedBy                          = @("john.smith@contoso.com");
            MemberDepartRestriction            = "Open";
            MemberJoinRestriction              = "Closed";
            ModeratedBy                        = @("admin@contoso.com");
            ModerationEnabled                  = $False;
            Name                               = "DemoDG";
            OrganizationalUnit                 = "nampr03a010.prod.outlook.com/Microsoft Exchange Hosted Organizations/contoso.com";
            PrimarySmtpAddress                 = "demodg@contoso.com";
            RequireSenderAuthenticationEnabled = $True;
            SendModerationNotifications        = "Always";
            Credential                         = $credsAdmin
        }
    }
}
```

