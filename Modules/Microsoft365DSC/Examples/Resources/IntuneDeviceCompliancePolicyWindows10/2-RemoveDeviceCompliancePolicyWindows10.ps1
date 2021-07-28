<#
This example removes an existing Device Compliance Policy for MacOS devices
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
        IntuneDeviceCompliancePolicyWindows10 MyCustomWindows10Policy
        {
            DisplayName          = 'Demo Windows 10 Device Compliance Policy';
            Ensure               = 'Absent';
            GlobalAdminAccount   = $credsGlobalAdmin;
        }
    }
}
