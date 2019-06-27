<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Office365DSC

    node localhost
    {
        SCRetentionComplianceTag DemoRule
        {
            Name               = "DemoRule2"
            Comment            = "This is a Demo Rule"
            RetentionAction    = "Keep"
            RetentionDuration  = "1025"
            GlobalAdminAccount = $credsGlobalAdmin
            RetentionType      = "ModificationAgeInDays"
            Ensure             = "Present"
        }
    }
}
