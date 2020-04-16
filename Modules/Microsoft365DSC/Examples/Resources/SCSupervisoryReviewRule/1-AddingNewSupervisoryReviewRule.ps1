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
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        SCSupervisoryReviewRule Rule
        {
            Name               = "DemoRule"
            Condition          = "(NOT(Reviewee:US Compliance))"
            SamplingRate       = 100
            Policy             = 'TestPolicy'
            Ensure             = "Present"
            GlobalAdminAccount = $credsGlobalAdmin
        }
    }
}
