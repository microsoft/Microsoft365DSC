# AADLifecycleWorkflowSettings

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **IsSingleInstance** | Key | String | Only valid value is 'Yes'. | `Yes` |
| **SenderDomain** | Write | String | Specifies the domain that should be used when sending email notifications. This domain must be verified in order to be used. We recommend that you use a domain that has the appropriate DNS records to facilitate email validation, like SPF, DKIM, DMARC, and MX, because this then complies with the RFC compliance for sending and receiving email. For details, see Learn more about Exchange Online Email Routing. | |
| **WorkflowScheduleIntervalInHours** | Write | UInt32 | The interval in hours at which all workflows running in the tenant should be scheduled for execution. This interval has a minimum value of 1 and a maximum value of 24. The default value is 3 hours. | |
| **UseCompanyBranding** | Write | Boolean | Specifies if the organization's banner logo should be included in email notifications. The banner logo will replace the Microsoft logo at the top of the email notification. If true the banner logo will be taken from the tenant's branding settings. This value can only be set to true if the organizationalBranding bannerLogo property is set. | |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |


## Description

Update the properties of a lifecycleManagementSettings object.

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

    - LifecycleWorkflows.Read.All

- **Update**

    - LifecycleWorkflows.ReadWrite.All

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
        AADLifecycleWorkflowSettings "AADLifecycleWorkflowSettings"
        {
            ApplicationId                   = $ApplicationId;
            CertificateThumbprint           = $CertificateThumbprint;
            IsSingleInstance                = "Yes";
            SenderDomain                    = "microsoft.com";
            TenantId                        = $TenantId;
            UseCompanyBranding              = $True;
            WorkflowScheduleIntervalInHours = 10;
        }
    }
}
```

