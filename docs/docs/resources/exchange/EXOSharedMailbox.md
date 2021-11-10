# EXOSharedMailbox

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | The display name of the Shared Mailbox ||
| **PrimarySMTPAddress** | Write | String | The primary email address of the Shared Mailbox ||
| **Aliases** | Write | StringArray[] | Aliases for the Shared Mailbox ||
| **Ensure** | Write | String | Present ensures the group exists, absent ensures it is removed |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword ||
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. ||

## Description

This resource allows users to create Office 365 Shared Mailboxes.

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
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOSharedMailbox 'SharedMailbox'
        {
            DisplayName        = "Test"
            PrimarySMTPAddress = "Test@O365DSC1.onmicrosoft.com"
            Aliases            = @("Joufflu@o365dsc1.onmicrosoft.com", "Gilles@O365dsc1.onmicrosoft.com")
            Ensure             = "Present"
            Credential         = $credsGlobalAdmin
        }
    }
}
```

