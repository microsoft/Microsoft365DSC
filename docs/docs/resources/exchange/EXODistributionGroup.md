# EXODistributionGroup

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the distribution group or mail-enabled security group that you want to modify. You can use any value that uniquely identifies the group. | |
| **Name** | Required | String | The Name parameter specifies a unique name for the address list. | |
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
| **AcceptMessagesOnlyFrom** | Write | StringArray[] | The AcceptMessagesOnlyFrom parameter specifies who is allowed to send messages to this recipient. Messages from other senders are rejected. | |
| **AcceptMessagesOnlyFromDLMembers** | Write | StringArray[] | The AcceptMessagesOnlyFromDLMembers parameter specifies who is allowed to send messages to this recipient. Messages from other senders are rejected. | |
| **AcceptMessagesOnlyFromSendersOrMembers** | Write | StringArray[] | The AcceptMessagesOnlyFromSendersOrMembers parameter specifies who is allowed to send messages to this recipient. Messages from other senders are rejected. | |
| **CustomAttribute1** | Write | String | This parameter specifies a value for the CustomAttribute1 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. If the value contains spaces, enclose the value in quotation marks. | |
| **CustomAttribute2** | Write | String | This parameter specifies a value for the CustomAttribute2 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. If the value contains spaces, enclose the value in quotation marks. | |
| **CustomAttribute3** | Write | String | This parameter specifies a value for the CustomAttribute3 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. If the value contains spaces, enclose the value in quotation marks. | |
| **CustomAttribute4** | Write | String | This parameter specifies a value for the CustomAttribute4 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. If the value contains spaces, enclose the value in quotation marks. | |
| **CustomAttribute5** | Write | String | This parameter specifies a value for the CustomAttribute5 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. If the value contains spaces, enclose the value in quotation marks. | |
| **CustomAttribute6** | Write | String | This parameter specifies a value for the CustomAttribute6 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. If the value contains spaces, enclose the value in quotation marks. | |
| **CustomAttribute7** | Write | String | This parameter specifies a value for the CustomAttribute7 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. If the value contains spaces, enclose the value in quotation marks. | |
| **CustomAttribute8** | Write | String | This parameter specifies a value for the CustomAttribute8 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. If the value contains spaces, enclose the value in quotation marks. | |
| **CustomAttribute9** | Write | String | This parameter specifies a value for the CustomAttribute9 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. If the value contains spaces, enclose the value in quotation marks. | |
| **CustomAttribute10** | Write | String | This parameter specifies a value for the CustomAttribute10 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. If the value contains spaces, enclose the value in quotation marks. | |
| **CustomAttribute11** | Write | String | This parameter specifies a value for the CustomAttribute11 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. If the value contains spaces, enclose the value in quotation marks. | |
| **CustomAttribute12** | Write | String | This parameter specifies a value for the CustomAttribute12 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. If the value contains spaces, enclose the value in quotation marks. | |
| **CustomAttribute13** | Write | String | This parameter specifies a value for the CustomAttribute13 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. If the value contains spaces, enclose the value in quotation marks. | |
| **CustomAttribute14** | Write | String | This parameter specifies a value for the CustomAttribute14 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. If the value contains spaces, enclose the value in quotation marks. | |
| **CustomAttribute15** | Write | String | This parameter specifies a value for the CustomAttribute15 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. If the value contains spaces, enclose the value in quotation marks. | |
| **EmailAddresses** | Write | StringArray[] | The EmailAddresses parameter specifies all email addresses (proxy addresses) for the recipient, including the primary SMTP address. In on-premises Exchange organizations, the primary SMTP address and other proxy addresses are typically set by email address policies. However, you can use this parameter to configure other proxy addresses for the recipient. | |
| **GrantSendOnBehalfTo** | Write | StringArray[] | The GrantSendOnBehalfTo parameter specifies who can send on behalf of this group. Although messages send on behalf of the group clearly show the sender in the From field (<Sender> on behalf of <Group>), replies to these messages are delivered to the group, not the sender. | |
| **HiddenFromAddressListsEnabled** | Write | Boolean | The HiddenFromAddressListsEnabled parameter specifies whether this recipient is visible in address lists. | |
| **SendOofMessageToOriginatorEnabled** | Write | Boolean | The SendOofMessageToOriginatorEnabled parameter specifies how to handle out of office (OOF) messages for members of the group. | |
| **SendModerationNotifications** | Write | String | The SendModerationNotifications parameter specifies when moderation notification messages are sent. Valid values are: Always, Internal, Never. | `Always`, `Internal`, `Never` |
| **Type** | Write | String | The Type parameter specifies the type of group that you want to create. Valid values are: Distribution, Security | `Distribution`, `Security` |
| **Ensure** | Write | String | Specifies if this AddressList should exist. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

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
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    $Domain = $Credscredential.Username.Split('@')[1]
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
            ManagedBy                          = @("adeleV@$Domain");
            MemberDepartRestriction            = "Open";
            MemberJoinRestriction              = "Closed";
            ModeratedBy                        = @("alexW@$Domain");
            ModerationEnabled                  = $False;
            Identity                           = "DemoDG";
            Name                               = "DemoDG";
            PrimarySmtpAddress                 = "demodg@$Domain";
            RequireSenderAuthenticationEnabled = $True;
            SendModerationNotifications        = "Always";
            Credential                         = $Credscredential
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

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        EXODistributionGroup 'DemoDG'
        {
            Alias                              = "demodg";
            BccBlocked                         = $True; # Updated Property
            BypassNestedModerationEnabled      = $False;
            DisplayName                        = "My Demo DG";
            Ensure                             = "Present";
            HiddenGroupMembershipEnabled       = $True;
            ManagedBy                          = @("adeleV@$Domain");
            MemberDepartRestriction            = "Open";
            MemberJoinRestriction              = "Closed";
            ModeratedBy                        = @("alexW@$Domain");
            ModerationEnabled                  = $False;
            Identity                           = "DemoDG";
            Name                               = "DemoDG";
            PrimarySmtpAddress                 = "demodg@$Domain";
            RequireSenderAuthenticationEnabled = $True;
            SendModerationNotifications        = "Always";
            Credential                         = $Credscredential
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
        $Domain = $Credscredential.Username.Split('@')[1]
        EXODistributionGroup 'DemoDG'
        {
            DisplayName                        = "My Demo DG";
            Ensure                             = "Absent";
            Identity                           = "DemoDG";
            Name                               = "DemoDG";
            Credential                         = $Credscredential
        }
    }
}
```

