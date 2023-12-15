<#
This example creates a new Device Enrollment Status Page.
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
        IntuneDeviceEnrollmentStatusPageWindows10 '6b43c039-c1d0-4a9f-aab9-48c5531acbd6'
        {
            DisplayName                             = "All users and all devices";
            Ensure                                  = "Absent";
            Credential                              = $Credscredential
        }
    }
}
