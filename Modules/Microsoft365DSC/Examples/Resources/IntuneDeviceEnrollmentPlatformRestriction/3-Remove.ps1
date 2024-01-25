<#
This example creates a new Device Enrollment Platform Restriction.
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
        IntuneDeviceEnrollmentPlatformRestriction 'DeviceEnrollmentPlatformRestriction'
        {
            Credential                        = $Credscredential
            DisplayName                       = "Removed Policy";
            Ensure                            = "Absent";
            Assignments                       = @();
            Description                       = "Enrollment restriction for POC users. Markus Köchli";
            DeviceEnrollmentConfigurationType = "singlePlatformRestriction";
            Identity                          = "d59e4c28-b6b2-48ad-a6f0-a2132300b99d_SinglePlatformRestriction";
            PlatformRestriction               = MSFT_DeviceEnrollmentPlatformRestriction{
                PlatformBlocked = $True
                BlockedSkus = @()
                BlockedManufacturers = @()
                PersonalDeviceEnrollmentBlocked = $False
            };
            PlatformType                      = "android";
            Priority                          = 1;
            TenantId                          = $OrganizationName;
        }
    }
}
