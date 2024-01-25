# EXOGroupSettings

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | The DisplayName parameter specifies the name of the Microsoft 365 Group. The display name is visible in the Exchange admin center, address lists, and Outlook. The maximum length is 64 characters. | |
| **AcceptMessagesOnlyFromSendersOrMembers** | Write | StringArray[] | The AcceptMessagesOnlyFromSendersOrMembers parameter specifies who is allowed to send messages to this recipient. Messages from other senders are rejected. | |
| **AccessType** | Write | String | Private | `Public`, `Private` |
| **AlwaysSubscribeMembersToCalendarEvents** | Write | Boolean | The AlwaysSubscribeMembersToCalendarEvents switch controls the default subscription settings of new members that are added to the Microsoft 365 Group. Changing this setting doesn't affect existing group members. | |
| **AuditLogAgeLimit** | Write | String | The AlwaysSubscribeMembersToCalendarEvents switch controls the default subscription settings of new members that are added to the Microsoft 365 Group. Changing this setting doesn't affect existing group members. | |
| **AutoSubscribeNewMembers** | Write | Boolean | The AutoSubscribeNewMembers switch specifies whether to automatically subscribe new members that are added to the Microsoft 365 Group to conversations and calendar events. Only users that are added to the group after you enable this setting are automatically subscribed to the group. | |
| **CalendarMemberReadOnly** | Write | Boolean | The CalendarMemberReadOnly parameter specifies whether to set read-only Calendar permissions to the Microsoft 365 Group for members of the group. | |
| **Classification** | Write | String | The CalendarMemberReadOnly switch specifies whether to set read-only Calendar permissions to the Microsoft 365 Group for members of the group. | |
| **ConnectorsEnabled** | Write | Boolean | The CalendarMemberReadOnly switch specifies whether to set read-only Calendar permissions to the Microsoft 365 Group for members of the group. | |
| **CustomAttribute1** | Write | String | This parameter specifies a value for the CustomAttribute1 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. | |
| **CustomAttribute2** | Write | String | This parameter specifies a value for the CustomAttribute2 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. | |
| **CustomAttribute3** | Write | String | This parameter specifies a value for the CustomAttribute3 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. | |
| **CustomAttribute4** | Write | String | This parameter specifies a value for the CustomAttribute4 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. | |
| **CustomAttribute5** | Write | String | This parameter specifies a value for the CustomAttribute5 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. | |
| **CustomAttribute6** | Write | String | This parameter specifies a value for the CustomAttribute6 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. | |
| **CustomAttribute7** | Write | String | This parameter specifies a value for the CustomAttribute7 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. | |
| **CustomAttribute8** | Write | String | This parameter specifies a value for the CustomAttribute8 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. | |
| **CustomAttribute9** | Write | String | This parameter specifies a value for the CustomAttribute9 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. | |
| **CustomAttribute10** | Write | String | This parameter specifies a value for the CustomAttribute10 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. | |
| **CustomAttribute11** | Write | String | This parameter specifies a value for the CustomAttribute11 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. | |
| **CustomAttribute12** | Write | String | This parameter specifies a value for the CustomAttribute12 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. | |
| **CustomAttribute13** | Write | String | This parameter specifies a value for the CustomAttribute13 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. | |
| **CustomAttribute14** | Write | String | This parameter specifies a value for the CustomAttribute14 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. | |
| **CustomAttribute15** | Write | String | This parameter specifies a value for the CustomAttribute15 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. The maximum length is 1024 characters. | |
| **DataEncryptionPolicy** | Write | String | The DataEncryptionPolicy parameter specifies the data encryption policy that's applied to the Microsoft 365 Group.  | |
| **EmailAddresses** | Write | StringArray[] | The EmailAddresses parameter specifies all the email addresses (proxy addresses) for the recipient, including the primary SMTP address. | |
| **ExtensionCustomAttribute1** | Write | String | This parameter specifies a value for the ExtensionCustomAttribute1 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. You can specify up to 1300 values separated by commas. | |
| **ExtensionCustomAttribute2** | Write | String | This parameter specifies a value for the ExtensionCustomAttribute2 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. You can specify up to 1300 values separated by commas. | |
| **ExtensionCustomAttribute3** | Write | String | This parameter specifies a value for the ExtensionCustomAttribute3 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. You can specify up to 1300 values separated by commas. | |
| **ExtensionCustomAttribute4** | Write | String | This parameter specifies a value for the ExtensionCustomAttribute4 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. You can specify up to 1300 values separated by commas. | |
| **ExtensionCustomAttribute5** | Write | String | This parameter specifies a value for the ExtensionCustomAttribute5 property on the recipient. You can use this property to store custom information about the recipient, and to identify the recipient in filters. You can specify up to 1300 values separated by commas. | |
| **GrantSendOnBehalfTo** | Write | StringArray[] | The GrantSendOnBehalfTo parameter specifies who can send on behalf of this Microsoft 365 Group. | |
| **HiddenFromAddressListsEnabled** | Write | Boolean | The GrantSendOnBehalfTo parameter specifies who can send on behalf of this Microsoft 365 Group. | |
| **HiddenFromExchangeClientsEnabled** | Write | Boolean | The HiddenFromExchangeClientsEnabled switch specifies whether the Microsoft 365 Group is hidden from Outlook clients connected to Microsoft 365. | |
| **InformationBarrierMode** | Write | String | The InformationBarrierMode parameter specifies the information barrier mode for the Microsoft 365 Group. | `Explicit`, `Implicit`, `Open`, `OwnerModerated` |
| **IsMemberAllowedToEditContent** | Write | Boolean | This parameter specifies whether or not members are allow to edit content. | |
| **Language** | Write | String | The Language parameter specifies language preference for the Microsoft 365 Group. | |
| **MailboxRegion** | Write | String | The MailboxRegion parameter specifies the preferred data location (PDL) for the Microsoft 365 Group in multi-geo environments. | |
| **MailTip** | Write | String | The MailTip parameter specifies the custom MailTip text for this recipient. The MailTip is shown to senders when they start drafting an email message to this recipient.  | |
| **MailTipTranslations** | Write | String | The MailTipTranslations parameter specifies additional languages for the custom MailTip text that's defined by the MailTip parameter. | |
| **MaxReceiveSize** | Write | String | The MaxReceiveSize parameter specifies the maximum size of an email message that can be sent to this group. Messages that exceed the maximum size are rejected by the group. | |
| **MaxSendSize** | Write | String | The MaxSendSize parameter specifies the maximum size of an email message that can be sent by this group. | |
| **ModeratedBy** | Write | StringArray[] | The ModeratedBy parameter specifies one or more moderators for this recipient. A moderator approves messages sent to the recipient before the messages are delivered. A moderator must be a mailbox, mail user, or mail contact in your organization. You can use any value that uniquely identifies the moderator.  | |
| **ModerationEnabled** | Write | Boolean | The ModerationEnabled parameter specifies whether moderation is enabled for this recipient. | |
| **Notes** | Write | String | The Notes parameter specifies the description of the Microsoft 365 Group. If the value contains spaces, enclose the value in quotation marks. | |
| **PrimarySmtpAddress** | Write | String | The PrimarySmtpAddress parameter specifies the primary return email address that's used for the recipient. You can't use the EmailAddresses and PrimarySmtpAddress parameters in the same command. | |
| **RejectMessagesFromSendersOrMembers** | Write | StringArray[] | The RejectMessagesFromSendersOrMembers parameter specifies who isn't allowed to send messages to this recipient. Messages from these senders are rejected. | |
| **RequireSenderAuthenticationEnabled** | Write | Boolean | The RequireSenderAuthenticationEnabled parameter specifies whether to accept messages only from authenticated (internal) senders.  | |
| **SensitivityLabelId** | Write | String | The SensitivityLabelId parameter specifies the GUID value of the sensitivity label that's assigned to the Microsoft 365 Group. | |
| **SubscriptionEnabled** | Write | Boolean | The SubscriptionEnabled switch specifies whether the group owners can enable subscription to conversations and calendar events on the groups they own.  | |
| **UnifiedGroupWelcomeMessageEnabled** | Write | Boolean | The UnifiedGroupWelcomeMessageEnabled switch specifies whether to enable or disable sending system-generated welcome messages to users who are added as members to the Microsoft 365 Group. | |
| **Credential** | Write | PSCredential | Credentials of the Exchange Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures settings on groups
such as the custom attributes and language.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- User Options, View-Only Recipients, Mail Recipients

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

    $Domain = $Credscredential.Username.Split('@')[1]
    node localhost
    {
        EXOGroupSettings 'TestGroup'
        {
            DisplayName                            = "Test Group";
            AccessType                             = "Public";
            AlwaysSubscribeMembersToCalendarEvents = $False;
            AuditLogAgeLimit                       = "90.00:00:00";
            AutoSubscribeNewMembers                = $False;
            CalendarMemberReadOnly                 = $False;
            ConnectorsEnabled                      = $False; # Updated Property
            Credential                             = $Credscredential;
            HiddenFromAddressListsEnabled          = $True;
            HiddenFromExchangeClientsEnabled       = $True;
            InformationBarrierMode                 = "Open";
            Language                               = "en-US";
            MaxReceiveSize                         = "36 MB (37,748,736 bytes)";
            MaxSendSize                            = "35 MB (36,700,160 bytes)";
            ModerationEnabled                      = $False;
            Notes                                  = "My Notes";
            PrimarySmtpAddress                     = "TestGroup@$Domain";
            RequireSenderAuthenticationEnabled     = $True;
            SubscriptionEnabled                    = $False;
        }
    }
}
```

