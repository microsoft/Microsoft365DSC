# AzureBillingAccountScheduledAction

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | Display name of the scheduled action. | |
| **BillingAccount** | Write | String | Associated billing account id. | |
| **Status** | Write | String | Status of the scheduled action. | |
| **View** | Write | String | Associated view id. | |
| **Notification** | Write | MSFT_AzureBillingAccountScheduledActionNotification | Notification properties based on scheduled action kind. | |
| **NotificationEmail** | Write | String | Email address of the point of contact that should get the unsubscribe requests and notification emails. | |
| **Schedule** | Write | MSFT_AzureBillingAccountScheduledActionSchedule | Schedule of the scheduled action. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Absent`, `Present` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_AzureBillingAccountScheduledActionNotification

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **subject** | Write | String | Subject of the email. Length is limited to 70 characters. | |
| **message** | Write | String | Optional message to be added in the email. Length is limited to 250 characters. | |
| **to** | Write | StringArray[] | Array of email addresses. | |

### MSFT_AzureBillingAccountScheduledActionSchedule

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **dayOfMonth** | Write | UInt32 | UTC day on which cost analysis data will be emailed. Must be between 1 and 31. This property is applicable when frequency is Monthly and overrides weeksOfMonth or daysOfWeek. | |
| **daysOfWeek** | Write | StringArray[] | Day names in english on which cost analysis data will be emailed. This property is applicable when frequency is Weekly or Monthly. | |
| **startDate** | Write | String | The start date and time of the scheduled action (UTC). | |
| **endDate** | Write | String | The end date and time of the scheduled action (UTC). | |
| **weeksOfMonth** | Write | StringArray[] | Weeks in which cost analysis data will be emailed. This property is applicable when frequency is Monthly and used in combination with daysOfWeek. | |
| **frequency** | Write | String | Frequency of the schedule. | |
| **hourOfDay** | Write | UInt32 | UTC time at which cost analysis data will be emailed. | |


## Description

Manages scheduled actions for Azure billing accounts.

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
        AzureBillingAccountScheduledAction "AzureBillingAccountScheduledAction-MyAction"
        {
            ApplicationId         = $ApplicationId;
            BillingAccount        = "1e5b9e50-a1ea-581e-fb3a-778b93a06854:6487d5cf-0a7b-42e6-9549-23cavvvvvvv_2019-05-31";
            CertificateThumbprint = $CertificateThumbprint;
            DisplayName           = "MyAction";
            Ensure                = "Present";
            Notification          = MSFT_AzureBillingAccountScheduledActionNotification{
                subject = 'Cost Alert'
                message = 'This is my demo message!'
                to = @('john.smith@contoso.com')
            };
            NotificationEmail     = "alert@contoso.com";
            Schedule              = MSFT_AzureBillingAccountScheduledActionSchedule{
                daysOfWeek = @('Wednesday')
                startDate = '2024-11-06T13:00:00Z'
                endDate = '2025-11-06T05:00:00Z'
                frequency = 'Weekly'
                dayOfMonth = 0
                hourOfDay = 13
            };
            Status                = "Enabled";
            TenantId              = $TenantId;
            View                  = "/providers/Microsoft.Billing/billingAccounts/xxxxx:xxxxx_xxxxx/providers/Microsoft.CostManagement/views/ms:AccumulatedCosts";
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
        AzureBillingAccountScheduledAction "AzureBillingAccountScheduledAction-MyAction"
        {
            ApplicationId         = $ApplicationId;
            BillingAccount        = "1e5b9e50-a1ea-581e-fb3a-778b93a06854:6487d5cf-0a7b-42e6-9549-23cavvvvvvv_2019-05-31";
            CertificateThumbprint = $CertificateThumbprint;
            DisplayName           = "MyAction";
            Ensure                = "Present";
            Notification          = MSFT_AzureBillingAccountScheduledActionNotification{
                subject = 'Cost Alert'
                message = 'This is my demo message!'
                to = @('john.smith@contoso.com')
            };
            NotificationEmail     = "alert@contoso.com";
            Schedule              = MSFT_AzureBillingAccountScheduledActionSchedule{
                daysOfWeek = @('Wednesday')
                startDate = '2024-11-06T13:00:00Z'
                endDate = '2025-11-06T05:00:00Z'
                frequency = 'Weekly'
                dayOfMonth = 0
                hourOfDay = 13
            };
            Status                = "Disabled"; # Drift
            TenantId              = $TenantId;
            View                  = "/providers/Microsoft.Billing/billingAccounts/xxxxx:xxxxx_xxxxx/providers/Microsoft.CostManagement/views/ms:AccumulatedCosts";
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
        AzureBillingAccountScheduledAction "AzureBillingAccountScheduledAction-MyAction"
        {
            ApplicationId         = $ApplicationId;
            BillingAccount        = "1e5b9e50-a1ea-581e-fb3a-778b93a06854:6487d5cf-0a7b-42e6-9549-23cavvvvvvv_2019-05-31";
            CertificateThumbprint = $CertificateThumbprint;
            DisplayName           = "MyAction";
            Ensure                = "Absent";
            Status                = "Enabled";
            TenantId              = $TenantId;
            View                  = "/providers/Microsoft.Billing/billingAccounts/xxxxx:xxxxx_xxxxx/providers/Microsoft.CostManagement/views/ms:AccumulatedCosts";
        }
    }
}
```

