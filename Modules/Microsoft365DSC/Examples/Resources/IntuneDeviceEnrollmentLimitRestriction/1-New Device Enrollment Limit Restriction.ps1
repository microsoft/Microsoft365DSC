<#
This example creates a new Device Enrollment Limit Restriction.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceEnrollmentLimitRestriction 'DeviceEnrollmentLimitRestriction'
        {
            Description          = "My Restriction"
            DisplayName          = "My DSC Limit"
            Limit                = 12
            Ensure               = "Present"
            Credential           = $credsGlobalAdmin
        }
    }
}
