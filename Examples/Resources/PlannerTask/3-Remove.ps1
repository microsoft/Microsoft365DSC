<#
This example creates a new Planner Task in a Plan.
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
        PlannerTask 'ContosoPlannerTask'
        {
            PlanId                = "1234567890"
            Title                 = "Contoso Task"
            StartDateTime         = "2020-06-09"
            Priority              = 7
            PercentComplete       = 75
            Ensure                = "Absent"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
