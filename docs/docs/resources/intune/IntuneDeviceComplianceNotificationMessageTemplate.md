# IntuneDeviceComplianceNotificationMessageTemplate

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **BrandingOptions** | Write | StringArray[] | The Message Template Branding Options. Branding is defined in the Intune Admin Console. Possible values are: none, includeCompanyLogo, includeCompanyName, includeContactInformation, includeCompanyPortalLink, includeDeviceDetails | `none`, `includeCompanyLogo`, `includeCompanyName`, `includeContactInformation`, `includeCompanyPortalLink`, `includeDeviceDetails` |
| **LocalizedNotificationMessages** | Write | MSFT_DeviceManagementNotificationMessageTemplate[] | The localized notification message templates. | |
| **Description** | Write | String | Display name for the Notification Message Template. | |
| **DisplayName** | Key | String | Display name for the Notification Message Template. | |
| **RoleScopeTagIds** | Write | StringArray[] | List of Scope Tags for this Entity instance. | |
| **Id** | Write | String | The unique identifier for an entity. Read-only. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_DeviceManagementNotificationMessageTemplate

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsDefault** | Write | Boolean | If this is the default message template. | |
| **Locale** | Write | String | The locale of the message template. | `ar-sa`, `bg-bg`, `cs-cz`, `da-dk`, `de-de`, `el-gr`, `en-gb`, `en-us`, `es-es`, `es-mx`, `et-ee`, `fi-fi`, `fr-ca`, `fr-fr`, `he-il`, `hr-hr`, `hu-hu`, `it-it`, `ja-jp`, `ko-kr`, `lt-lt`, `lv-lv`, `nb-no`, `nl-nl`, `pl-pl`, `pt-br`, `pt-pt`, `ro-ro`, `sk-sk`, `sl-si`, `ru-ru`, `sr-Latn-rs`, `sv-se`, `th-th`, `tr-tr`, `uk-ua`, `zh-cn`, `zh-tw` |
| **MessageTemplate** | Write | String | The body of the message template | |
| **Subject** | Write | String | The subject of the message template. | |


## Description

Intune Device Compliance Notification Message Template

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - DeviceManagementServiceConfig.Read.All, Group.Read.All

- **Update**

    - DeviceManagementServiceConfig.ReadWrite.All, Group.Read.All

#### Application permissions

- **Read**

    - DeviceManagementServiceConfig.Read.All, Group.Read.All

- **Update**

    - DeviceManagementServiceConfig.ReadWrite.All, Group.Read.All

## Examples

### Example 1

This example creates a new Device Compliance Notification Message Template.

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
        IntuneDeviceComplianceNotificationMessageTemplate 'IntuneDeviceComplianceNotificationMessageTemplate-Test'
        {
            BrandingOptions               = @("includeCompanyName","includeContactInformation","includeCompanyPortalLink");
            LocalizedNotificationMessages = @(
                MSFT_DeviceManagementNotificationMessageTemplate{
                    MessageTemplate = "Das ist eine Testnachricht fÃ¼r Deutsch."
                    IsDefault = $True
                    Subject = "Test Deutsch2"
                    Locale = "de-de"
                }
                MSFT_DeviceManagementNotificationMessageTemplate{
                    MessageTemplate = "This is a message for English (United States)."
                    IsDefault = $False
                    Subject = "Test English"
                    Locale = "en-us"
                }
            );
            Description                   = "";
            DisplayName                   = "Test";
            Ensure                        = "Present";
            RoleScopeTagIds               = @("0");
            ApplicationId                 = $ApplicationId;
            TenantId                      = $TenantId;
            CertificateThumbprint         = $CertificateThumbprint;
        }
    }
}
```

### Example 2

This example creates a new Device Enrollment Status Page.

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
        IntuneDeviceComplianceNotificationMessageTemplate 'IntuneDeviceComplianceNotificationMessageTemplate-Test'
        {
            BrandingOptions               = @("includeCompanyName","includeContactInformation","includeCompanyPortalLink");
            LocalizedNotificationMessages = @(
                MSFT_DeviceManagementNotificationMessageTemplate{
                    MessageTemplate = "Das ist eine Testnachricht fÃ¼r Deutsch."
                    IsDefault = $False # Updated property
                    Subject = "Test Deutsch2"
                    Locale = "de-de"
                }
                MSFT_DeviceManagementNotificationMessageTemplate{
                    MessageTemplate = "This is a message for English (United States)."
                    IsDefault = $True # Updated property
                    Subject = "Test English"
                    Locale = "en-us"
                }
            );
            Description                   = "";
            DisplayName                   = "Test";
            Ensure                        = "Present";
            RoleScopeTagIds               = @("0");
            ApplicationId                 = $ApplicationId;
            TenantId                      = $TenantId;
            CertificateThumbprint         = $CertificateThumbprint;
        }
    }
}
```

### Example 3

This example creates a new Device Enrollment Status Page.

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
        IntuneDeviceComplianceNotificationMessageTemplate 'IntuneDeviceComplianceNotificationMessageTemplate-Test'
        {
            DisplayName           = "Test";
            Ensure                = "Absent";
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
```

