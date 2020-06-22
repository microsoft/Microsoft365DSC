<#
This example creates a new Planner Bucket in a Plan.
#>

Configuration Example
{
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        PlannerBucket ContosoBucket
        {
            PlanId                = "1234567890"
            Name                  = "Contoso Bucket"
            Ensure                = "Present"
            ApplicationId         = "12345-12345-12345-12345-12345"
            TenantId              = "12345-12345-12345-12345-12345"
            CertificateThumbprint = "1234567890"
        }
    }
}
