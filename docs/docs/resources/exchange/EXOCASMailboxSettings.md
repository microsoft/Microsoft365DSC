# EXOCASMailboxSettings

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the mailbox that you want to configure. | |
| **ActiveSyncAllowedDeviceIDs** | Write | StringArray[] | TheActiveSyncAllowedDeviceIDs parameter specifies one or more Exchange ActiveSync device IDs that are allowed to synchronize with the mailbox. | |
| **ActiveSyncBlockedDeviceIDs** | Write | StringArray[] | The ActiveSyncBlockedDeviceIDs parameter specifies one or more Exchange ActiveSync device IDs that aren't allowed to synchronize with the mailbox. | |
| **ActiveSyncDebugLogging** | Write | Boolean | The ActiveSyncDebugLogging parameter enables or disables Exchange ActiveSync debug logging for the mailbox. | |
| **ActiveSyncEnabled** | Write | Boolean | The ActiveSyncEnabled parameter enables or disables access to the mailbox using Exchange ActiveSync. | |
| **ActiveSyncMailboxPolicy** | Write | String | The ActiveSyncMailboxPolicy parameter specifies the Exchange ActiveSync mailbox policy for the mailbox. | |
| **ActiveSyncSuppressReadReceipt** | Write | Boolean | The ActiveSyncSuppressReadReceipt parameter controls the behavior of read receipts for Exchange ActiveSync clients that access the mailbox. | |
| **EwsAllowEntourage** | Write | Boolean | The EwsAllowEntourage parameter enables or disables access to the mailbox by Microsoft Entourage clients that use Exchange Web Services. | |
| **EwsAllowList** | Write | StringArray[] | The EwsAllowList parameter specifies the Exchange Web Services applications (user agent strings) that are allowed to access the mailbox. | |
| **EwsAllowMacOutlook** | Write | Boolean | The EwsAllowMacOutlook parameter enables or disables access to the mailbox by Outlook for Mac clients that use Exchange Web Services. | |
| **EwsAllowOutlook** | Write | Boolean | The EwsAllowOutlook parameter enables or disables access to the mailbox by Outlook clients that use Exchange Web Services. | |
| **EwsApplicationAccessPolicy** | Write | String | The EwsApplicationAccessPolicy parameter controls access to the mailbox using Exchange Web Services applications. | |
| **EwsBlockList** | Write | StringArray[] | The EwsBlockList parameter specifies the Exchange Web Services applications (user agent strings) that aren't allowed to access the mailbox using Exchange Web Services. | |
| **EwsEnabled** | Write | Boolean | The EwsEnabled parameter enables or disables access to the mailbox using Exchange Web Services clients. | |
| **ImapEnabled** | Write | Boolean | The ImapEnabled parameter enables or disables access to the mailbox using IMAP4 clients. | |
| **ImapMessagesRetrievalMimeFormat** | Write | String | The ImapMessagesRetrievalMimeFormat parameter specifies the message format for IMAP4 clients that access the mailbox. | |
| **ImapForceICalForCalendarRetrievalOption** | Write | Boolean | The ImapForceICalForCalendarRetrievalOption parameter specifies how meeting requests are presented to IMAP4 clients that access the mailbox. | |
| **ImapSuppressReadReceipt** | Write | Boolean | The ImapSuppressReadReceipt parameter controls the behavior of read receipts for IMAP4 clients that access the mailbox. | |
| **ImapUseProtocolDefaults** | Write | Boolean | The ImapUseProtocolDefaults parameter specifies whether to use the IMAP4 protocol defaults for the mailbox. | |
| **MacOutlookEnabled** | Write | Boolean | The MacOutlookEnabled parameter enables or disables access to the mailbox using Outlook for Mac clients that use Microsoft Sync technology. | |
| **MAPIEnabled** | Write | Boolean | The MAPIEnabled parameter enables or disables access to the mailbox using MAPI clients (for example, Outlook). | |
| **OneWinNativeOutlookEnabled** | Write | Boolean | The OneWinNativeOutlookEnabled parameter enables or disables access to the mailbox using the new Outlook for Windows. | |
| **OutlookMobileEnabled** | Write | Boolean | The OutlookMobileEnabled parameter enables or disables access to the mailbox using Outlook for iOS and Android. | |
| **OWAEnabled** | Write | Boolean | The OWAEnabled parameter enables or disables access to the mailbox using Outlook on the web (formerly known as Outlook Web App or OWA). | |
| **OWAforDevicesEnabled** | Write | Boolean | The OWAforDevicesEnabled parameter enables or disables access to the mailbox using the older Outlook Web App (OWA) app on iOS and Android devices. | |
| **OwaMailboxPolicy** | Write | String | The OwaMailboxPolicy parameter specifies the Outlook on the web mailbox policy for the mailbox. | |
| **PopEnabled** | Write | Boolean | The PopEnabled parameter enables or disables access to the mailbox using POP3 clients. | |
| **PopForceICalForCalendarRetrievalOption** | Write | Boolean | The PopForceICalForCalendarRetrievalOption parameter specifies how meeting requests are presented to POP3 clients that access the mailbox. | |
| **PopMessagesRetrievalMimeFormat** | Write | String | The PopMessagesRetrievalMimeFormat parameter specifies the message format for POP3 clients that access the mailbox. | |
| **PopSuppressReadReceipt** | Write | Boolean | The PopSuppressReadReceipt parameter controls the behavior of read receipts for POP3 clients that access the mailbox. | |
| **PopUseProtocolDefaults** | Write | Boolean | The PopUseProtocolDefaults parameter specifies whether to use the POP3 protocol defaults for the mailbox. | |
| **PublicFolderClientAccess** | Write | Boolean | The PublicFolderClientAccess parameter enables or disables access to public folders in Microsoft Outlook. | |
| **ShowGalAsDefaultView** | Write | Boolean | The ShowGalAsDefaultView parameter specifies whether the global address list (GAL) is the default recipient picker for messages. | |
| **SmtpClientAuthenticationDisabled** | Write | Boolean | The SmtpClientAuthenticationDisabled parameter specifies whether to disable authenticated SMTP (SMTP AUTH) for the mailbox. | |
| **UniversalOutlookEnabled** | Write | Boolean | The UniversalOutlookEnabled parameter enables or disables access to the mailbox using Windows 10 Mail and Calendar. | |
| **Ensure** | Write | String | Present ensures the Mailbox CAS settings are applied. | `Present` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

This resource configures CAS mailbox settings.

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

    node localhost
    {
        EXOCASMailboxSettings 'AdeleVCasMailboxSettings'
        {
            ActiveSyncAllowedDeviceIDs              = @()
            ActiveSyncBlockedDeviceIDs              = @()
            ActiveSyncDebugLogging                  = $False
            ActiveSyncEnabled                       = $True
            ActiveSyncMailboxPolicy                 = 'Demo EXO Mobile Device Policy Default'
            ActiveSyncSuppressReadReceipt           = $False
            EwsEnabled                              = $True
            Identity                                = 'AdeleV'
            ImapEnabled                             = $False
            ImapForceICalForCalendarRetrievalOption = $False
            ImapMessagesRetrievalMimeFormat         = 'BestBodyFormat'
            ImapSuppressReadReceipt                 = $False
            ImapUseProtocolDefaults                 = $True
            MacOutlookEnabled                       = $True
            MAPIEnabled                             = $True
            OutlookMobileEnabled                    = $True
            OWAEnabled                              = $True
            OWAforDevicesEnabled                    = $True
            OwaMailboxPolicy                        = 'OwaMailboxPolicy-Default'
            PopEnabled                              = $False
            PopForceICalForCalendarRetrievalOption  = $True
            PopMessagesRetrievalMimeFormat          = 'BestBodyFormat'
            PopSuppressReadReceipt                  = $False
            PopUseProtocolDefaults                  = $True
            PublicFolderClientAccess                = $False
            ShowGalAsDefaultView                    = $True
            UniversalOutlookEnabled                 = $True
            Ensure                                  = 'Present'
            Credential                              = $Credscredential
        }
    }
}
```

