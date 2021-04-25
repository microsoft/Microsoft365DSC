<#
This example removes an existing Device Compliance Policy for iOs devices
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
        IntuneDeviceCompliancePolicyAndroidWorkProfile RemoveDeviceCompliancePolicyAndroidWorkProfile
        {
            DisplayName          = "Test Android Work Profile Device Compliance Policy"
            Ensure               = "Absent"
            GlobalAdminAccount   = $credsGlobalAdmin;
        }
    }
}
