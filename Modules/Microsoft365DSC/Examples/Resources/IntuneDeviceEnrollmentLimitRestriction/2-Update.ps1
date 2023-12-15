<#
This example creates a new Device Enrollment Limit Restriction.
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
        IntuneDeviceEnrollmentLimitRestriction 'DeviceEnrollmentLimitRestriction'
        {
            DisplayName = 'My DSC Limit'
            Description = 'My Restriction'
            Limit       = 11 # Updated Property
            Ensure      = 'Present'
            Credential  = $Credscredential
        }
    }
}
