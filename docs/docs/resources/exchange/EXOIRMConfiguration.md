# EXOIRMConfiguration

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Only valid value is 'Yes'. | `Yes` |
| **AutomaticServiceUpdateEnabled** | Write | Boolean | The AutomaticServiceUpdateEnabled parameter specifies whether to allow the automatic addition of new features within Azure Information Protection for your cloud-based organization. | |
| **AzureRMSLicensingEnabled** | Write | Boolean | The AzureRMSLicensingEnabled parameter specifies whether the Exchange Online organization can to connect directly to Azure Rights Management. | |
| **DecryptAttachmentForEncryptOnly** | Write | Boolean | The DecryptAttachmentForEncryptOnly parameter specifies whether mail recipients have unrestricted rights on the attachment or not for Encrypt-only mails sent using Microsoft Purview Message Encryption. | |
| **EDiscoverySuperUserEnabled** | Write | Boolean | The EDiscoverySuperUserEnabled parameter specifies whether members of the Discovery Management role group can access IRM-protected messages in a discovery mailbox that were returned by a discovery search. | |
| **EnablePdfEncryption** | Write | Boolean | The EnablePdfEncryption parameter specifies whether to enable the encryption of PDF attachments using Microsoft Purview Message Encryption.  | |
| **InternalLicensingEnabled** | Write | Boolean | The InternalLicensingEnabled parameter specifies whether to enable IRM features for messages that are sent to internal and external recipients. | |
| **JournalReportDecryptionEnabled** | Write | Boolean | The JournalReportDecryptionEnabled parameter specifies whether to enable journal report decryption. | |
| **LicensingLocation** | Write | StringArray[] | The LicensingLocation parameter specifies the RMS licensing URLs. You can specify multiple URL values separated by commas. | |
| **RejectIfRecipientHasNoRights** | Write | Boolean | This parameter is available only in the cloud-based service. | |
| **RMSOnlineKeySharingLocation** | Write | String | The RMSOnlineKeySharingLocation parameter specifies the Azure Rights Management URL that's used to get the trusted publishing domain (TPD) for the Exchange Online organization. | |
| **SearchEnabled** | Write | Boolean | The SearchEnabled parameter specifies whether to enable searching of IRM-encrypted messages in Outlook on the web (formerly known as Outlook Web App). | |
| **SimplifiedClientAccessDoNotForwardDisabled** | Write | Boolean | The SimplifiedClientAccessDoNotForwardDisabled parameter specifies whether to disable Do not forward in Outlook on the web. | |
| **SimplifiedClientAccessEnabled** | Write | Boolean | The SimplifiedClientAccessEnabled parameter specifies whether to enable the Protect button in Outlook on the web. | |
| **SimplifiedClientAccessEncryptOnlyDisabled** | Write | Boolean | The SimplifiedClientAccessEncryptOnlyDisabled parameter specifies whether to disable Encrypt only in Outlook on the web.  | |
| **TransportDecryptionSetting** | Write | String | The TransportDecryptionSetting parameter specifies the transport decryption configuration. | `Disabled`, `Mandatory`, `Optional` |
| **Ensure** | Write | String | Specifies if this Outbound connector should exist. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

Modify the resource Configuration policy in your cloud-based organization.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Information Rights Management, View-Only Configuration

#### Role Groups

- Organization Management, Compliance Management

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
        EXOIRMConfiguration 'ConfigureIRMConfiguration'
        {
            IsSingleInstance                           = 'Yes'
            AutomaticServiceUpdateEnabled              = $True
            AzureRMSLicensingEnabled                   = $True
            DecryptAttachmentForEncryptOnly            = $True
            EDiscoverySuperUserEnabled                 = $True
            EnablePdfEncryption                        = $True
            InternalLicensingEnabled                   = $True
            JournalReportDecryptionEnabled             = $True
            RejectIfRecipientHasNoRights               = $True
            SearchEnabled                              = $True
            SimplifiedClientAccessDoNotForwardDisabled = $True
            SimplifiedClientAccessEnabled              = $True
            SimplifiedClientAccessEncryptOnlyDisabled  = $True
            TransportDecryptionSetting                 = 'Mandatory'
            Ensure                                     = 'Present'
            Credential                                 = $Credscredential
        }
    }
}
```

