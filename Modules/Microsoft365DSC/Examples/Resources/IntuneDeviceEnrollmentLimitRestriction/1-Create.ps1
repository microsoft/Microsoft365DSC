<#
This example creates a new Device Enrollment Limit Restriction.
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
        IntuneDeviceEnrollmentLimitRestriction 'DeviceEnrollmentLimitRestriction'
        {
            DisplayName = 'My DSC Limit'
            Description = 'My Restriction'
            Limit       = 12
            Ensure      = 'Present'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
