# EXOMailContact

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Name** | Key | String | The Name parameter specifies a unique name for the mail contact. | |
| **ExternalEmailAddress** | Required | String | The ExternalEmailAddress parameter specifies the target email address of the mail contact or mail user. By default, this value is used as the primary email address of the mail contact or mail user. | |
| **Alias** | Write | String | The Alias parameter specifies the Exchange alias (also known as the mail nickname) for the recipient. This value identifies the recipient as a mail-enabled object, and shouldn't be confused with multiple email addresses for the same recipient (also known as proxy addresses). A recipient can have only one Alias value. The maximum length is 64 characters. | |
| **DisplayName** | Write | String | The DisplayName parameter specifies the display name of the mail contact. The display name is visible in the Exchange admin center and in address lists.  | |
| **FirstName** | Write | String | The FirstName parameter specifies the user's first name. | |
| **Initials** | Write | String | The Initials parameter specifies the user's middle initials. | |
| **LastName** | Write | String | The LastName parameter specifies the user's last name. | |
| **MacAttachmentFormat** | Write | String | The MacAttachmentFormat parameter specifies the Apple Macintosh operating system attachment format to use for messages sent to the mail contact or mail user. Valid values are: BinHex, UuEncode, AppleSingle, AppleDouble | `BinHex`, `UuEncode`, `AppleSingle`, `AppleDouble` |
| **MessageBodyFormat** | Write | String | The MessageBodyFormat parameter specifies the message body format for messages sent to the mail contact or mail user. Valid values are: Text, Html, TextAndHtml | `Text`, `Html`, `TextAndHtml` |
| **MessageFormat** | Write | String | The MessageFormat parameter specifies the message format for messages sent to the mail contact or mail user. Valid values are: Mime, Text | `Mime`, `Text` |
| **ModeratedBy** | Write | StringArray[] | The ModeratedBy parameter specifies one or more moderators for this mail contact. A moderator approves messages sent to the mail contact before the messages are delivered. A moderator must be a mailbox, mail user, or mail contact in your organization. | |
| **ModerationEnabled** | Write | Boolean | The ModerationEnabled parameter specifies whether moderation is enabled for this recipient. | |
| **OrganizationalUnit** | Write | String | The OrganizationalUnit parameter specifies the location in Active Directory where the new contact is created. | |
| **SendModerationNotifications** | Write | String | The SendModerationNotifications parameter specifies when moderation notification messages are sent. Valid values are: ALways, Internal, Never | `Always`, `Internal`, `Never` |
| **UsePreferMessageFormat** | Write | Boolean | The UsePreferMessageFormat specifies whether the message format settings configured for the mail user or mail contact override the global settings configured for the remote domain or configured by the message sender | |
| **CustomAttribute1** | Write | String | The CustomAttribute1 parameter specifies the value of the CustomAttribute1 | |
| **CustomAttribute2** | Write | String | The CustomAttribute2 parameter specifies the value of the CustomAttribute2 | |
| **CustomAttribute3** | Write | String | The CustomAttribute3 parameter specifies the value of the CustomAttribute3 | |
| **CustomAttribute4** | Write | String | The CustomAttribute4 parameter specifies the value of the CustomAttribute4 | |
| **CustomAttribute5** | Write | String | The CustomAttribute5 parameter specifies the value of the CustomAttribute5 | |
| **CustomAttribute6** | Write | String | The CustomAttribute6 parameter specifies the value of the CustomAttribute6 | |
| **CustomAttribute7** | Write | String | The CustomAttribute7 parameter specifies the value of the CustomAttribute7 | |
| **CustomAttribute8** | Write | String | The CustomAttribute8 parameter specifies the value of the CustomAttribute8 | |
| **CustomAttribute9** | Write | String | The CustomAttribute9 parameter specifies the value of the CustomAttribute9 | |
| **CustomAttribute10** | Write | String | The CustomAttribute10 parameter specifies the value of the CustomAttribute10 | |
| **CustomAttribute11** | Write | String | The CustomAttribute11 parameter specifies the value of the CustomAttribute11 | |
| **CustomAttribute12** | Write | String | The CustomAttribute12 parameter specifies the value of the CustomAttribute12 | |
| **CustomAttribute13** | Write | String | The CustomAttribute13 parameter specifies the value of the CustomAttribute13 | |
| **CustomAttribute14** | Write | String | The CustomAttribute14 parameter specifies the value of the CustomAttribute14 | |
| **CustomAttribute15** | Write | String | The CustomAttribute15 parameter specifies the value of the CustomAttribute15 | |
| **ExtensionCustomAttribute1** | Write | StringArray[] | The ExtensionCustomAttribute1 parameter specifies the value of the ExtensionCustomAttribute1 | |
| **ExtensionCustomAttribute2** | Write | StringArray[] | The ExtensionCustomAttribute2 parameter specifies the value of the ExtensionCustomAttribute2 | |
| **ExtensionCustomAttribute3** | Write | StringArray[] | The ExtensionCustomAttribute3 parameter specifies the value of the ExtensionCustomAttribute3 | |
| **ExtensionCustomAttribute4** | Write | StringArray[] | The ExtensionCustomAttribute4 parameter specifies the value of the ExtensionCustomAttribute4 | |
| **ExtensionCustomAttribute5** | Write | StringArray[] | The ExtensionCustomAttribute5 parameter specifies the value of the ExtensionCustomAttribute5 | |
| **Ensure** | Write | String | Specifies if this Contact should exist. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

# EXOAddressList

## Description

This resource configures Exchange Online address lists.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Address Lists

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
        EXOMailContact 'TestMailContact'
        {
            Alias                       = 'TestMailContact'
            DisplayName                 = 'My Test Contact'
            Ensure                      = 'Present'
            ExternalEmailAddress        = 'SMTP:test@tailspintoys.com'
            MacAttachmentFormat         = 'BinHex'
            MessageBodyFormat           = 'TextAndHtml'
            MessageFormat               = 'Mime'
            ModeratedBy                 = @()
            ModerationEnabled           = $false
            Name                        = 'My Test Contact'
            OrganizationalUnit          = $TenantId
            SendModerationNotifications = 'Always'
            UsePreferMessageFormat      = $true
            CustomAttribute1            = 'Custom Value 1'
            ExtensionCustomAttribute5   = 'Extension Custom Value 1', 'Extension Custom Value 2'
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
        EXOMailContact 'TestMailContact'
        {
            Alias                       = 'TestMailContact'
            DisplayName                 = 'My Test Contact'
            Ensure                      = 'Present'
            ExternalEmailAddress        = 'SMTP:test@tailspintoys.com'
            MacAttachmentFormat         = 'BinHex'
            MessageBodyFormat           = 'TextAndHtml'
            MessageFormat               = 'Mime'
            ModeratedBy                 = @()
            ModerationEnabled           = $false
            Name                        = 'My Test Contact'
            OrganizationalUnit          = $TenantId
            SendModerationNotifications = 'Always'
            UsePreferMessageFormat      = $false # Updated Property
            CustomAttribute1            = 'Custom Value 1'
            ExtensionCustomAttribute5   = 'Extension Custom Value 1', 'Extension Custom Value 2'
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
        EXOMailContact 'TestMailContact'
        {
            Alias                       = 'TestMailContact'
            DisplayName                 = 'My Test Contact'
            Ensure                      = 'Absent'
            ExternalEmailAddress        = 'SMTP:test@tailspintoys.com'
            Name                        = 'My Test Contact'
            OrganizationalUnit          = $TenantId
            SendModerationNotifications = 'Always'
            UsePreferMessageFormat      = $false # Updated Property
            CustomAttribute1            = 'Custom Value 1'
            ExtensionCustomAttribute5   = 'Extension Custom Value 1', 'Extension Custom Value 2'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
```

