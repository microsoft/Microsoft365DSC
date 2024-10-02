# SCRecordReviewNotificationTemplateConfig

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Specifies the resource is a single instance, the value must be 'Yes' | `Yes` |
| **CustomizedNotificationDataString** | Write | String | The CustomizedNotificationDataString parameter specifies the customized review notification text to use. If the value contains spaces, enclose the value in quotation marks. | |
| **CustomizedReminderDataString** | Write | String | The CustomizedReminderDataString parameter specifies the customized review reminder text to use. If the value contains spaces, enclose the value in quotation marks. | |
| **IsCustomizedNotificationTemplate** | Write | Boolean | The IsCustomizedNotificationTemplate switch specifies whether to use a customized review notification instead of the system default notification. | |
| **IsCustomizedReminderTemplate** | Write | Boolean | The IsCustomizedReminderTemplate switch specifies whether to use a customized review reminder instead of the system default reminder. | |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Configures Purview Records Management disposition settings.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - None

- **Update**

    - None

#### Application permissions

- **Read**

    - None

- **Update**

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
        SCRecordReviewNotificationTemplateConfig "SCRecordReviewNotificationTemplateConfig"
        {
            ApplicationId                    = $ApplicationId;
            CertificateThumbprint            = $CertificateThumbprint;
            CustomizedNotificationDataString = "This is my Notification Message";
            CustomizedReminderDataString     = "This is my reminder message";
            IsCustomizedNotificationTemplate = $True;
            IsCustomizedReminderTemplate     = $True;
            IsSingleInstance                 = "Yes";
            TenantId                         = $TenantId;
        }
    }
}
```

