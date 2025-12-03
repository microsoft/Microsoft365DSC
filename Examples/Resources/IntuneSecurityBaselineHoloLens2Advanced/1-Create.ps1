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
        IntuneSecurityBaselineHoloLens2Advanced 'mySecurityBaselineHoloLens2Advanced'
        {
            DisplayName                           = 'test'
            AADGroupMembershipCacheValidityInDays = 7;
            PasswordManagerEnabled                = "0";
            VideoPowerDownTimeOutAC_2             = "1";
            Ensure                                = 'Present'
            ApplicationId                         = $ApplicationId
            TenantId                              = $TenantId
            CertificateThumbprint                 = $CertificateThumbprint
        }
    }
}
