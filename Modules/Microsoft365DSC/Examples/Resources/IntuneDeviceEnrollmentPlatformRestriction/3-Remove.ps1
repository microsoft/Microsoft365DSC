<#
This example creates a new Device Enrollment Platform Restriction.
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
        IntuneDeviceEnrollmentPlatformRestriction 'DeviceEnrollmentPlatformRestriction'
        {
            DisplayName                       = "Removed Policy";
            Ensure                            = "Absent";
            Assignments                       = @();
            Description                       = "This is a single platform restriction policy.";
            DeviceEnrollmentConfigurationType = "singlePlatformRestriction";
            Identity                          = "d59e4c28-b6b2-48ad-a6f0-a2132300b99d_SinglePlatformRestriction";
            IosRestriction                    = MSFT_DeviceEnrollmentPlatformRestriction{
                PlatformBlocked                 = $True
                PersonalDeviceEnrollmentBlocked = $False
            };
            Priority                          = 1;
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
