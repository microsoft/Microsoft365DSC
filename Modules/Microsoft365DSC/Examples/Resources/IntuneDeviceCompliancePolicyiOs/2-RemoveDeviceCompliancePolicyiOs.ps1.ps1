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
        IntuneDeviceCompliancePolicyiOs RemoveDeviceCompliancePolicyiOs
        {
            DisplayName          = 'Demo iOS Device Compliance Policy'
            Ensure               = 'Absent'
            GlobalAdminAccount   = $credsGlobalAdmin;
        }
    }
}
