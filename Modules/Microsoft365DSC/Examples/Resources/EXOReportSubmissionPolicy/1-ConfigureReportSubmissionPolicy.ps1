<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        EXOReportSubmissionPolicy 'ConfigureReportSubmissionPolicy'
        {
            IsSingleInstance                       = 'Yes'
            DisableQuarantineReportingOption       = $False
            EnableCustomNotificationSender         = $False
            EnableOrganizationBranding             = $False
            EnableReportToMicrosoft                = $True
            EnableThirdPartyAddress                = $False
            EnableUserEmailNotification            = $False
            PostSubmitMessageEnabled               = $True
            PreSubmitMessageEnabled                = $True
            ReportJunkToCustomizedAddress          = $False
            ReportNotJunkToCustomizedAddress       = $False
            ReportPhishToCustomizedAddress         = $False
            Ensure                                 = "Present"
            Credential                             = $Credscredential
        }
    }
}
