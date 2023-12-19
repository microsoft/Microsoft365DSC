﻿# EXOMailboxAutoReplyConfiguration

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the mailbox that you want to modify. You can use any value that uniquely identifies the mailbox. | |
| **AutoDeclineFutureRequestsWhenOOF** | Write | Boolean | The AutoDeclineFutureRequestsWhenOOF parameter specifies whether to automatically decline new meeting requests that are sent to the mailbox during the scheduled time period when Automatic Replies are being sent.  | |
| **AutoReplyState** | Write | String | The AutoReplyState parameter specifies whether the mailbox is enabled for Automatic Replies. Valid values are: Enabled, Disabled, Scheduled | `Enabled`, `Disabled`, `Scheduled` |
| **CreateOOFEvent** | Write | Boolean | The CreateOOFEvent parameter specifies whether to create a calendar event that corresponds to the scheduled time period when Automatic Replies are being sent for the mailbox. | |
| **DeclineAllEventsForScheduledOOF** | Write | Boolean | The DeclineAllEventsForScheduledOOF parameter specifies whether to decline all existing calendar events in the mailbox during the scheduled time period when Automatic Replies are being sent. | |
| **DeclineEventsForScheduledOOF** | Write | Boolean | The DeclineEventsForScheduledOOF parameter specifies whether it's possible to decline existing calendar events in the mailbox during the scheduled time period when Automatic Replies are being sent.  | |
| **DeclineMeetingMessage** | Write | String | The DeclineMeetingMessage parameter specifies the text in the message when meetings requests that are sent to the mailbox are automatically declined. | |
| **EndTime** | Write | String | The EndTime parameter specifies the end date and time that Automatic Replies are sent for the mailbox. You use this parameter only when the AutoReplyState parameter is set to Scheduled, and the value of this parameter is meaningful only when AutoReplyState is Scheduled. | |
| **EventsToDeleteIDs** | Write | StringArray[] | The EventsToDeleteIDs parameter specifies the calendar events to delete from the mailbox when the DeclineEventsForScheduledOOF parameter is set to $true. | |
| **ExternalAudience** | Write | String | The ExternalAudience parameter specifies whether Automatic Replies are sent to external senders. Valid values are: None, Known, All | `None`, `Known`, `All` |
| **ExternalMessage** | Write | String | The ExternalMessage parameter specifies the Automatic Replies message that's sent to external senders or senders outside the organization. If the value contains spaces, enclose the value in quotation marks. | |
| **InternalMessage** | Write | String | The InternalMessage parameter specifies the Automatic Replies message that's sent to internal senders or senders within the organization. If the value contains spaces, enclose the value in quotation marks. | |
| **OOFEventSubject** | Write | String | The OOFEventSubject parameter specifies the subject for the calendar event that's automatically created when the CreateOOFEvent parameter is set to $true. | |
| **StartTime** | Write | String | The StartTime parameter specifies the start date and time that Automatic Replies are sent for the specified mailbox. You use this parameter only when the AutoReplyState parameter is set to Scheduled, and the value of this parameter is meaningful only when AutoReplyState is Scheduled. | |
| **Ensure** | Write | String | Represents the existance of the instance. This must be set to 'Present' | `Present` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures the Auto Reply settings of mailboxes.

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
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOEmailAddressPolicy 'ConfigureEmailAddressPolicy'
        {
            Name                              = "Default Policy"
            EnabledEmailAddressTemplates      = @("SMTP:@contoso.onmicrosoft.com")
            EnabledPrimarySMTPAddressTemplate = "@contoso.onmicrosoft.com"
            ManagedByFilter                   = ""
            Priority                          = "Lowest"
            Ensure                            = "Present"
            Credential                        = $Credscredential
        }
    }
}
```

