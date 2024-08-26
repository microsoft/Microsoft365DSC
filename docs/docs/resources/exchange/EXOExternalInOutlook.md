# EXOExternalInOutlook

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | OrganisationIDParameter, not needed for cmdlet Functionality, use 'ExternalinOutlook' to use the same configuration for multiple Tenants | |
| **Enabled** | Write | Boolean | The Enabled parameter enables or disables external sender identification in supported versions of Outlook. Valid values are:$true: External sender identification in Outlook is enabled. An External icon is added in the area of the subject line of messages from external senders. To exempt specific senders or sender domains from this identification, use the AllowList parameter.$false: External sender identification in Outlook is disabled. | |
| **AllowList** | Write | StringArray[] | The AllowList parameter specifies exceptions to external sender identification in supported versions of Outlook. Messages received from the specified senders or senders in the specified domains don't receive native External sender identification. The allow list uses the 5322.From address (also known as the From address or P2 sender). Valid values are an individual domain (contoso.com), a domain and all subdomains (*.contoso.com) or email addresses (admin@contoso.com). | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |


## Description

This resource will use Set-ExternalInOutlook cmdlet to modify the configuration of external sender identification that's available in Outlook, Outlook for Mac, Outlook on the web, and Outlook for iOS and Android.

## Permissions

### Exchange

To authenticate with Microsoft Exchange, this resource required the following permissions:

#### Roles

- O365SupportViewConfig, OrganizationConfiguration, ViewOnlyConfiguration

#### Role Groups

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
        EXOExternalInOutlook "EXOExternalInOutlook"
        {
            Identity              = "ExternalInOutlook";
            AllowList             = @("mobile01@contoso.onmicrosoft.com","*contoso.onmicrosoft.com","contoso.com");
            Enabled               = $False;
            Ensure                = "Present";
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
```

