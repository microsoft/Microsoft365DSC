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
            DisplayName                       = "All users and all devices";
            Ensure                            = "Absent";
        }
    }
}
