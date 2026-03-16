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
        IntuneDeviceEnrollmentScopeConfigurationMam "Example"
        {
            AppliesTo            = "selected";
            ComplianceUrl        = "";
            Credential           = $Credential;
            DiscoveryUrl         = "https://wip.mam.manage.microsoft.com/Enroll";
            IncludedGroups       = @("AADGroup_1","AADGroup_3"); # Updated property
            IsSingleInstance     = "Yes";
            TermsOfUseUrl        = "";
        }
    }
}
