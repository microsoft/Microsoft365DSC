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
        TeamsApplicationInstance "TestResourceAccount"
        {
            ApplicationId         = $ConfigurationData.NonNodeData.ApplicationId;
            CertificateThumbprint = $ConfigurationData.NonNodeData.CertificateThumbprint;
            DisplayName           = "JohnRA";
            Ensure                = "Present";
            ResourceAccountType   = "AutoAttendant";
            TenantId              = $OrganizationName;
            UserPrincipalName     = "John.Smith@M365x73318397.mail.onmicrosoft.com";
        }
    }
}
