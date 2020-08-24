<#
This example creates a new Plan in Planner.
#>

Configuration Example
{
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        PlannerPlan ContosoPlan
        {
            Title                 = "Contoso Plan"
            OwnerGroup            = "Contoso Group"
            Ensure                = "Present"
            ApplicationId         = "12345-12345-12345-12345-12345"
            TenantId              = "12345-12345-12345-12345-12345"
            CertificateThumbprint = "1234567890"
        }
    }
}
