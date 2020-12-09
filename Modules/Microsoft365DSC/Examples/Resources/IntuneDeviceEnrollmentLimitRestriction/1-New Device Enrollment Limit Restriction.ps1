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
        IntuneDeviceEnrollmentLimitRestriction LimitRestriction
        {
            Description          = "My Restriction";
            DisplayName          = "My DSC Limit";
            Ensure               = "Present"
            GlobalAdminAccount   = $Credsglobaladmin;
            Limit                = 12;
        }
    }
}
