# EXOActiveSyncOrganizationSettings

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Only valid value is 'Yes'. | `Yes` |
| **DefaultAccessLevel** | Write | String | The default access level for new ActiveSync devices. | |
| **TenantAdminPreference** | Write | String | The tenant admin preference for ActiveSync. | |
| **UserMailInsert** | Write | String | The text to include in email messages sent to users whose devices are blocked. | |
| **AllowAccessForUnSupportedPlatform** | Write | Boolean | Allow access for unsupported platforms. | |
| **EnableMobileMailboxPolicyWhenCAInplace** | Write | Boolean | Enable mobile mailbox policy when conditional access is in place. | |
| **AllowRMSSupportForUnenlightenedApps** | Write | Boolean | Allow RMS support for unenlightened apps. | |
| **AdminMailRecipients** | Write | String[] | The email addresses of administrators who receive messages about blocked devices. | |
| **OtaNotificationMailInsert** | Write | String | The text to include in notification emails sent to administrators. | |
| **DeviceFiltering** | Write | String | Device filtering settings for ActiveSync. | |
| **Identity** | Write | String | The identity of the organization. | |
| **IsIntuneManaged** | Write | Boolean | Indicates whether the organization is managed by Intune. | |
| **HasAzurePremiumSubscription** | Write | Boolean | Indicates whether the organization has an Azure Premium subscription. | |
| **Credential** | Write | PSCredential | Credentials of the Exchange Global Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for CertificatePassword | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | String[] | Access token used for authentication. | |

## Description

This resource allows users to manage ActiveSync organization settings in Exchange Online.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- Organization Management, Security Reader

#### Role Groups

- Organization Management, Security Administrator

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
        EXOActiveSyncOrganizationSettings 'ActiveSyncOrgSettings'
        {
            IsSingleInstance                       = 'Yes'
            DefaultAccessLevel                     = 'Allow'
            AllowAccessForUnSupportedPlatform      = $true
            AllowRMSSupportForUnenlightenedApps    = $true
            AdminMailRecipients                    = @('admin@contoso.com')
            ApplicationId                          = $ApplicationId
            TenantId                              = $TenantId
            CertificateThumbprint                 = $CertificateThumbprint
        }
    }
}
```

### Example 2

This example shows how to update ActiveSync organization settings with different values.

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
        EXOActiveSyncOrganizationSettings 'ActiveSyncOrgSettings'
        {
            IsSingleInstance                       = 'Yes'
            DefaultAccessLevel                     = 'Block'
            AllowAccessForUnSupportedPlatform      = $false
            AllowRMSSupportForUnenlightenedApps    = $false
            UserMailInsert                         = 'Your device has been blocked by the administrator.'
            OtaNotificationMailInsert              = 'A device has been blocked.'
            DeviceFiltering                        = 'BlockList'
            ApplicationId                          = $ApplicationId
            TenantId                              = $TenantId
            CertificateThumbprint                 = $CertificateThumbprint
        }
    }
}
```