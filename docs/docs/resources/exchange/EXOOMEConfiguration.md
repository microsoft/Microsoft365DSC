# EXOOMEConfiguration

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the OME Configuration policy that you want to modify. | |
| **BackgroundColor** | Write | String | The BackgroundColor parameter specifies the background color | |
| **DisclaimerText** | Write | String | The DisclaimerText parameter specifies the disclaimer text in the email that contains the encrypted message | |
| **EmailText** | Write | String | The EmailText parameter specifies the default text that accompanies encrypted email messages. | |
| **ExternalMailExpiryInDays** | Write | UInt32 | The ExternalMailExpiryInDays parameter specifies the number of days that the encrypted message is available to external recipients in the Microsoft 365 portal. A valid value is an integer from 0 to 730. | |
| **IntroductionText** | Write | String | The IntroductionText parameter specifies the default text that accompanies encrypted email messages. | |
| **OTPEnabled** | Write | Boolean | The OTPEnabled parameter specifies whether to allow recipients to use a one-time passcode to view encrypted messages. | |
| **PortalText** | Write | String | The PortalText parameter specifies the text that appears at the top of the encrypted email viewing portal. | |
| **PrivacyStatementUrl** | Write | String | The PrivacyStatementUrl parameter specifies the Privacy Statement link in the encrypted email notification message. | |
| **ReadButtonText** | Write | String | The ReadButtonText parameter specifies the text that appears on the 'Read the message' button.  | |
| **SocialIdSignIn** | Write | Boolean | The SocialIdSignIn parameter specifies whether a user is allowed to view an encrypted message in the Microsoft 365 admin center using their own social network id (Google, Yahoo, and Microsoft account). | |
| **Ensure** | Write | String | Specifies if this Outbound connector should exist. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |

## Description

Create a new OME Configuration policy in your cloud-based organization.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Compliance Admin, Security Admin, Data Loss Prevention, Transport Rules, Information Rights Management, View-Only Configuration, Security Reader

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
        EXOOMEConfiguration 'ConfigureOMEConfiguration'
        {
            Identity                 = "Contoso Marketing"
            BackgroundColor          = "0x00FFFF00"
            DisclaimerText           = "Encryption security disclaimer."
            EmailText                = "Encrypted message enclosed."
            ExternalMailExpiryInDays = 0
            IntroductionText         = "You have received an encypted message"
            OTPEnabled               = $True
            PortalText               = "This portal is encrypted."
            SocialIdSignIn           = $True
            Ensure                   = "Present"
            Credential               = $Credscredential
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

    node localhost
    {
        EXOOMEConfiguration 'ConfigureOMEConfiguration'
        {
            Identity                 = "Contoso Marketing"
            BackgroundColor          = "0x00FFFF00"
            DisclaimerText           = "Encryption security disclaimer."
            EmailText                = "Encrypted message enclosed."
            ExternalMailExpiryInDays = 1 # Updated Property
            IntroductionText         = "You have received an encypted message"
            OTPEnabled               = $True
            PortalText               = "This portal is encrypted."
            SocialIdSignIn           = $True
            Ensure                   = "Present"
            Credential               = $Credscredential
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
        EXOOMEConfiguration 'ConfigureOMEConfiguration'
        {
            Identity                 = "Contoso Marketing"
            Ensure                   = "Absent"
            Credential               = $Credscredential
        }
    }
}
```

