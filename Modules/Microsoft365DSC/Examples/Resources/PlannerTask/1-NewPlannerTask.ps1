<#
This example creates a new Planner Task in a Plan.
#>

Configuration Example
{
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        PlannerTask ContosoTask
        {
            PlanId                = "1234567890"
            Title                 = "Contoso Task"
            StartDateTime         = "2020-06-09"
            Priority              = 7
            PercentComplete       = 75
            Ensure                = "Present"
            ApplicationId         = "12345-12345-12345-12345-12345"
            TenantId              = "12345-12345-12345-12345-12345"
            CertificateThumbprint = "1234567890"
        }
    }
}
