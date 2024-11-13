<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

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
