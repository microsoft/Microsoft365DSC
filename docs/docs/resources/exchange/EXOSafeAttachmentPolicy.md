# EXOSafeAttachmentPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | The Identity parameter specifies the name of the SafeAttachmentpolicy that you want to modify. | |
| **Action** | Write | String | The Action parameter specifies the action for the Safe Attachments policy. | `Block`, `Replace`, `Allow`, `DynamicDelivery` |
| **ActionOnError** | Write | Boolean | The ActionOnError parameter specifies the error handling option for Safe Attachments scanning (what to do if scanning times out or an error occurs). Valid values are: $true: The action specified by the Action parameter is applied to messages even when the attachments aren't successfully scanned. $false: The action specified by the Action parameter isn't applied to messages when the attachments aren't successfully scanned. This is the default value. | |
| **AdminDisplayName** | Write | String | The AdminDisplayName parameter specifies a description for the policy. | |
| **Enable** | Write | Boolean | Specify if this policy should be enabled. Default is $true. | |
| **QuarantineTag** | Write | String | The QuarantineTag specifies the quarantine policy that's used on messages that are quarantined as malware by Safe Attachments. | |
| **Redirect** | Write | Boolean | The Redirect parameter specifies whether to send detected malware attachments to another email address. Valid values are: $true: Malware attachments are sent to the email address specified by the RedirectAddress parameter. $false: Malware attachments aren't sent to another email address. This is the default value. | |
| **RedirectAddress** | Write | String | The RedirectAddress parameter specifies the email address where detected malware attachments are sent when the Redirect parameter is set to the value $true. | |
| **Ensure** | Write | String | Specify if this policy should exist or not. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

This resource configures the settings of the Safe Attachments policies
in your cloud-based organization.

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
        EXOSafeAttachmentPolicy 'ConfigureSafeAttachmentPolicy'
        {
            Identity             = "Marketing Block Attachments"
            Enable               = $True
            Redirect             = $True
            RedirectAddress      = "admin@$TenantId"
            Ensure               = "Present"
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
        EXOSafeAttachmentPolicy 'ConfigureSafeAttachmentPolicy'
        {
            Identity             = "Marketing Block Attachments"
            Enable               = $False # Updated Property
            Redirect             = $True
            RedirectAddress      = "admin@$TenantId"
            Ensure               = "Present"
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
        EXOSafeAttachmentPolicy 'ConfigureSafeAttachmentPolicy'
        {
            Identity             = "Marketing Block Attachments"
            Enable               = $False # Updated Property
            Ensure               = "Absent"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
```

