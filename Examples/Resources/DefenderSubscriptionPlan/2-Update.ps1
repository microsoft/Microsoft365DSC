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
        DefenderSubscriptionPlan 'TestSubscription'
        {
            SubscriptionName      = 'MyTestSubscription'
            PlanName              = 'VirtualMachines'
            SubPlanName           = 'P2'
            PricingTier           = 'Standard'
            SubscriptionId        = 'd620d94d-916d-4dd9-9de5-179292873e20'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
