# AADTenantDetails

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Only valid value is 'Yes'. |Yes|
| **MarketingNotificationEmails** | Write | StringArray[] | Email-addresses from the people who should receive Marketing Notifications ||
| **SecurityComplianceNotificationMails** | Write | StringArray[] | Email-addresses from the people who should receive Security Compliance Notifications ||
| **SecurityComplianceNotificationPhones** | Write | StringArray[] | Phone Numbers from the people who should receive Security Notifications ||
| **TechnicalNotificationMails** | Write | StringArray[] | Email-addresses from the people who should receive Technical Notifications ||
| **Credential** | Write | PSCredential | Credentials of the Azure Active Directory Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **ApplicationSecret** | Write | String | Secret of the Azure Active Directory application to authenticate with. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||

# AAD Tenant Details

### Description

This resource configures the Azure AD Tenant Details

## Azure AD Permissions

To authenticate via Azure Active Directory, this resource required the following Application permissions:

* **Automate**
  * Organization.Read.All, Directory.Read.All, Organization.ReadWrite.All, Directory.ReadWrite.All
* **Export**
  * None

NOTE: All permisions listed above require admin consent.

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example {
    param(
        [System.Management.Automation.PSCredential]
        $GlobalAdmin
    )

    Import-DscResource -ModuleName Microsoft365DSC

    Node Localhost
    {
        AADTenantDetails 'Ã‡onfigureTenantDetails'
        {
            IsSingleInstance                     = 'Yes'
            TechnicalNotificationMails           = "example@contoso.com"
            SecurityComplianceNotificationPhones = "+1123456789"
            SecurityComplianceNotificationMails  = "example@contoso.com"
            MarketingNotificationEmails          = "example@contoso.com"
            Credential                           = $GlobalAdmin
        }
    }
}
```

