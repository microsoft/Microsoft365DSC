<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param
    (
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceEnrollmentScopeConfigurationMdm "IntuneDeviceEnrollmentScopeConfigurationMdm"
        {
            AppliesTo            = "all";
            ComplianceUrl        = "https://portal.manage.microsoft.com/?portalAction=Compliance";
            Credential           = $Credential;
            DiscoveryUrl         = "https://enrollment.manage.microsoft.com/enrollmentserver/discovery.svc";
            IsSingleInstance     = "Yes";
            TermsOfUseUrl        = "https://portal.manage.microsoft.com/TermsofUse.aspx";
        }
    }
}
