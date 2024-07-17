# AADTenantDetails

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Only valid value is 'Yes'. | `Yes` |
| **MarketingNotificationEmails** | Write | StringArray[] | Email-addresses from the people who should receive Marketing Notifications | |
| **SecurityComplianceNotificationMails** | Write | StringArray[] | Email-addresses from the people who should receive Security Compliance Notifications | |
| **SecurityComplianceNotificationPhones** | Write | StringArray[] | Phone Numbers from the people who should receive Security Notifications | |
| **TechnicalNotificationMails** | Write | StringArray[] | Email-addresses from the people who should receive Technical Notifications | |
| **Credential** | Write | PSCredential | Credentials of the Azure Active Directory Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

# AAD Tenant Details

## Description

This resource configures the Azure AD Tenant Details

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Organization.Read.All

- **Update**

    - Organization.Read.All, Organization.ReadWrite.All

#### Application permissions

- **Read**

    - Organization.Read.All

- **Update**

    - Organization.Read.All, Organization.ReadWrite.All

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example {
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

    Node Localhost
    {
        AADTenantDetails 'ConfigureTenantDetails'
        {
            IsSingleInstance                     = 'Yes'
            TechnicalNotificationMails           = "example@contoso.com"
            MarketingNotificationEmails          = "example@contoso.com"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
```

